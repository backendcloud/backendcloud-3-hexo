---
title: workinprocess-map在golang的底层实现和源码分析
readmore: true
date: 2022-11-02 18:27:47
categories: 云原生
tags:
- Golang源码
---

> 本篇的源码分析基于golang 1.19.2
>
> https://github.com/golang/go

# map的底层数据结构

golang map底层由两个核心的结构体实现：hmap和bmap，bmap本篇用桶代替。

![](/images/golang-map/image-20221102141650817.png)

golang的代码中一旦初始化一个map，比如：make(map[k]v, hint)，底层就会创建一个hmap的结构体实例。该结构体实例包含了该map的所有信息。上图列了几个主要的成员。

* count：golang中的length(map[k]v)就返回的是该结构体的count

* B：桶的数量的log2，如果B为1就创建两个桶，若B为3就创建8个桶，一个桶可以最多存放8个key/value对，golang代码中若写了make(map[k]v, 10)，创建的hmap对应的B就等于2

* buckets：当前map的桶数组

* hash0：哈希因子，有点类似加密算法的盐

下面的makemap函数就是初始化了一个map的golang语句make(map[k]v, hint)，底层的map初始化。下面代码干的事情主要是：初始化一个hmap结构体，计算B值，创建桶数组。

```go
func makemap(t *maptype, hint int, h *hmap) *hmap {
	mem, overflow := math.MulUintptr(uintptr(hint), t.bucket.size)
	if overflow || mem > maxAlloc {
		hint = 0
	}

	// initialize Hmap
	if h == nil {
		h = new(hmap)
	}
	h.hash0 = fastrand()

	// Find the size parameter B which will hold the requested # of elements.
	// For hint < 0 overLoadFactor returns false since hint < bucketCnt.
	B := uint8(0)
	for overLoadFactor(hint, B) {
		B++
	}
	h.B = B

	// allocate initial hash table
	// if B == 0, the buckets field is allocated lazily later (in mapassign)
	// If hint is large zeroing this memory could take a while.
	if h.B != 0 {
		var nextOverflow *bmap
		h.buckets, nextOverflow = makeBucketArray(t, h.B, nil)
		if nextOverflow != nil {
			h.extra = new(mapextra)
			h.extra.nextOverflow = nextOverflow
		}
	}

	return h
}
```



# 设计

golang的map之所以效率高，得益于下面的几处巧妙设计：

## （1）key hash值的后B位作为桶index查找桶

```bash
   ┌─────────────┬─────────────────────────────────────────────────────┬─────────────┐                          
   │  10010111   │ 000011110110110010001111001010100010010110010101010 │    01010    │                          
   └─────────────┴─────────────────────────────────────────────────────┴─────────────┘                          
          ▲                                                                   ▲                                 
          │                                                                   │                                 
          │                                                                   │                   B = 5         
          │                                                                   │             bucketMask = 11111  
          │                                                                   │                                 
          │                                                            ┌─────────────┬───┬─────────────┐        
          │                                                            │  low bits   │ & │ bucketMask  │        
          │                                                            ├─────────────┴───┴─────────────┤        
          │                                                            │         01010 & 11111         │        
          │                                                            └───────────────────────────────┘        
          │                                                                            │                        
          │                                                                            │                        
          │                                                                            │                        
          │                                                                            ▼                        
          │                                                                  ┌───────────────────┐              
          │                                                                  │    01010 = 12     │              
          │                                                                  └───────────────────┘              
          │                                                                            │                        
          │                                                                            │                        
          │                                                                            │                        
          │                                                                            │                        
          │                                                                            │                        
   ┌─────────────┐                                                                     │                        
   │   tophash   │                                                                     │                        
   └─────────────┘                       ┌─────────┐                                   │                        
          │                              │ buckets │                                   ▼                        
          │                              ├───┬───┬─┴─┬───┬───┬───┬───┬───┬───┬───┬───┬───┐    ┌───┬───┬───┐     
          │                              │ 0 │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │ 8 │ 9 │10 │11 │ ...│29 │30 │31 │     
          │                              └───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┘    └───┴───┴───┘     
          ▼                                                                            │                        
┌──────────────────┐                                                                   │                        
│  10010111 = 151  │─────────────┐                                                     │                        
└──────────────────┘             │                                                     │                        
                                 │                                                     │                        
                                 │                                                     │                        
                                 │                             ┌───────────────────────┘                        
                                 │                             │                                                
                                 │                             │                                                
                                 │                             │                                                
                                 │                             │                                                
                                 │                             │                                                
                                 │                             │                                                
                                 │                             ▼                                                
                                 │                      ┌─────────────┐                                         
                                 │                      │   bucket    │                                         
   ┌─────────────────────────────┼──────────────────────┴─────────────┤                                         
   │                             │                                    │                                         
   │ ┌─────────┐                 │                                    │                                         
   │ │ tophash │                 ▼                                    │                                         
   │ ├───────┬─┴─────┬───────┬───────┬───────┬───────┬───────┬───────┐│                                         
   │ │  124  │  33   │  41   │  151  │   1   │   0   │   0   │   0   ││                                         
   │ ├───────┴─┬─────┴───────┴───────┴───────┴───────┴───────┴───────┘│                                         
   │ │    1    │                                                      │                                         
   │ ├───────┬─┴─────┬───────┬───────┬───────┬───────┬───────┬───────┐│                                         
   │ │  124  │  412  │  423  │   5   │  14   │   0   │   0   │   0   ││                                         
   │ ├───────┴─┬─────┴───────┴───────┴───────┴───────┴───────┴───────┘│                                         
   │ │ values  │                                                      │                                         
   │ ├───────┬─┴─────┬───────┬───────┬───────┬───────┬───────┬───────┐│                                         
   │ │  v0   │  v1   │  v2   │  v3   │  v4   │   0   │   0   │   0   ││                                         
   │ ├───────┴───────┴──┬────┴───────┴───────┴───────┴───────┴───────┘│                                         
   │ │ overflow pointer │                                             │                                         
   │ └──────────────────┘                                             │                                         
   │                                                                  │                                         
   └──────────────────────────────────────────────────────────────────┘                                         
```

若上面的makemap函数算出的B值=5，则bucketMask = 11111，key的hash值和bucketMask相与。就是取key的hash值的低B位，作为buckets数组的index查找桶。

## （2）key hash值的前8位作为桶内结构体的三个数组（tophash，key，value）的index

通过上一步找到了桶，因为一个桶最多由8个key/value对，所以还要进一步查找，这时候用到了tophash。参考上一步的图，tophash是取key的hash值的高8位。之所以要多出tophash存储空间，是为了空间换时间，加速寻址速度。

## （3）桶结构体的tophash复用，既作为tophash使用，也作为标志位使用

从上面的图看出，tophash数组不仅保存了tophash，还在当桶里8个key/value对某一对为空时保存了标志位。

```go
	emptyRest      = 0 // this cell is empty, and there are no more non-empty cells at higher indexes or overflows.
	emptyOne       = 1 // this cell is empty
	evacuatedX     = 2 // key/elem is valid.  Entry has been evacuated to first half of larger table.
	evacuatedY     = 3 // same as above, but evacuated to second half of larger table.
	evacuatedEmpty = 4 // cell is empty, bucket is evacuated.
	minTopHash     = 5 // minimum tophash for a normal filled cell.
```

底层对map的读运用了上面的（1）（2）（3），写运用了（1）和（2）。

```go
func mapaccess2(t *maptype, h *hmap, key unsafe.Pointer) (unsafe.Pointer, bool) {
	...
    // hmap为nil或map的length为0，返回未找到key
	if h == nil || h.count == 0 {
		if t.hashMightPanic() {
			t.hasher(key, 0) // see issue 23734
		}
		return unsafe.Pointer(&zeroVal[0]), false
	}
    // 读写冲突
	if h.flags&hashWriting != 0 {
		fatal("concurrent map read and map write")
	}
    // 不同的key类型运用不同的hash算法，并加入hash因子，算出key对应的hash值
	hash := t.hasher(key, uintptr(h.hash0))
    // 根据B值算出mask，就是B等于几就是几个1
	m := bucketMask(h.B)
    // 根据key的hash的后B位作为buckets数组的index，寻址到桶b
	b := (*bmap)(add(h.buckets, (hash&m)*uintptr(t.bucketsize)))
    // 若存在biggerSizeGrow扩容的旧桶数组，则将m去掉一个1，并在旧桶中寻址
	if c := h.oldbuckets; c != nil {
		if !h.sameSizeGrow() {
			// There used to be half as many buckets; mask down one more power of two.
			m >>= 1
		}
		oldb := (*bmap)(add(c, (hash&m)*uintptr(t.bucketsize)))
		if !evacuated(oldb) {
			b = oldb
		}
	}
	top := tophash(hash)
bucketloop:
    // for ; b != nil; b = b.overflow(t) 是链式查找（为了解决hash碰撞，桶结构体加入了链表）
	for ; b != nil; b = b.overflow(t) {
		for i := uintptr(0); i < bucketCnt; i++ {
            // b.tophash[i] != top 对比key的tophash是否存在
			if b.tophash[i] != top {
                // 优化寻址，tophash数组复用了标志位，一旦检测到emptyRest则跳出外层大循环，返回key在map中未找到
				if b.tophash[i] == emptyRest {
					break bucketloop
				}
                // key的tophash和tophash数组中的某个元素不相等，则进入小循环的下一个index的对比，或者进入大循环的下一个桶链表的查找
				continue
			}
            // 走到这一步，就是tophash已匹配，取出桶结构体的key数组对应的index对应的值，并对比两个key是否相等，若相等则返回桶结构体的value数组对应的index对应的值
			k := add(unsafe.Pointer(b), dataOffset+i*uintptr(t.keysize))
			if t.indirectkey() {
				k = *((*unsafe.Pointer)(k))
			}
			if t.key.equal(key, k) {
				e := add(unsafe.Pointer(b), dataOffset+bucketCnt*uintptr(t.keysize)+i*uintptr(t.elemsize))
				if t.indirectelem() {
					e = *((*unsafe.Pointer)(e))
				}
				return e, true
			}
		}
	}
	return unsafe.Pointer(&zeroVal[0]), false
}
```



## （4）扩容和迁移

扩容分为sameSizeGrow和biggerSizeGrow：

### sameSizeGrow本质不是扩容，桶数组的length不变，而是重新整理，减少链表，提高寻址效率

### biggerSizeGrow是桶数组不够用了而进行的扩容，桶数组的length是原来的2倍

![](/images/golang-map/image-20221102143237849.png)

![](/images/golang-map/image-20221102143607066.png)
