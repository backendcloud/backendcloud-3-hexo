---
title: map在golang的底层实现和源码分析
readmore: false
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

底层对map的读写删除都运用了上面的（1）（2）（3），根据key是否存在写包括了更新和新增。

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
			// 走到这一步，就是tophash已匹配，取出桶结构体的key数组对应的index对应的值，并对比两个key是否相等（对比tophash和key对比为了防止哈希碰撞和加快寻址），若相等则返回桶结构体的value数组对应的index对应的值
			k := add(unsafe.Pointer(b), dataOffset+i*uintptr(t.keysize))
			// indirectkey 和 indirectvalue 在64位的系统中 map 里实际存储的是8字节的指针，会造成 GC 扫描时，扫描更多的对象。至于是否是 indirect，依然是由编译器来决定的，依据是:
			// key > 128 字节时，indirectkey = true
			// value > 128 字节时，indirectvalue = true
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

map的key的删除，类似上面的读，不详细分析了。下面的代码主要做了2件事：寻址到key并删除key对应的地址空间和value对应的地址空间；遍历删除key后面的桶元素和桶链表，对其中的tophash保存的标志位更新，是空emptyOne还是之后的所有的都是空emptyRest。可以加快map的读写操作。

```go
func mapdelete(t *maptype, h *hmap, key unsafe.Pointer) {
	...
	if h == nil || h.count == 0 {
		if t.hashMightPanic() {
			t.hasher(key, 0) // see issue 23734
		}
		return
	}
	if h.flags&hashWriting != 0 {
		fatal("concurrent map writes")
	}

	hash := t.hasher(key, uintptr(h.hash0))

	// Set hashWriting after calling t.hasher, since t.hasher may panic,
	// in which case we have not actually done a write (delete).
	h.flags ^= hashWriting

	bucket := hash & bucketMask(h.B)
	if h.growing() {
		growWork(t, h, bucket)
	}
	b := (*bmap)(add(h.buckets, bucket*uintptr(t.bucketsize)))
	bOrig := b
	top := tophash(hash)
search:
	for ; b != nil; b = b.overflow(t) {
		for i := uintptr(0); i < bucketCnt; i++ {
			if b.tophash[i] != top {
				if b.tophash[i] == emptyRest {
					break search
				}
				continue
			}
			k := add(unsafe.Pointer(b), dataOffset+i*uintptr(t.keysize))
			k2 := k
			if t.indirectkey() {
				k2 = *((*unsafe.Pointer)(k2))
			}
			if !t.key.equal(key, k2) {
				continue
			}
			// Only clear key if there are pointers in it.
			if t.indirectkey() {
				*(*unsafe.Pointer)(k) = nil
			} else if t.key.ptrdata != 0 {
				memclrHasPointers(k, t.key.size)
			}
			e := add(unsafe.Pointer(b), dataOffset+bucketCnt*uintptr(t.keysize)+i*uintptr(t.elemsize))
			if t.indirectelem() {
				*(*unsafe.Pointer)(e) = nil
			} else if t.elem.ptrdata != 0 {
				memclrHasPointers(e, t.elem.size)
			} else {
				memclrNoHeapPointers(e, t.elem.size)
			}
			b.tophash[i] = emptyOne
			// If the bucket now ends in a bunch of emptyOne states,
			// change those to emptyRest states.
			// It would be nice to make this a separate function, but
			// for loops are not currently inlineable.
			if i == bucketCnt-1 {
				if b.overflow(t) != nil && b.overflow(t).tophash[0] != emptyRest {
					goto notLast
				}
			} else {
				if b.tophash[i+1] != emptyRest {
					goto notLast
				}
			}
			for {
				b.tophash[i] = emptyRest
				if i == 0 {
					if b == bOrig {
						break // beginning of initial bucket, we're done.
					}
					// Find previous bucket, continue at its last entry.
					c := b
					for b = bOrig; b.overflow(t) != c; b = b.overflow(t) {
					}
					i = bucketCnt - 1
				} else {
					i--
				}
				if b.tophash[i] != emptyOne {
					break
				}
			}
		notLast:
			h.count--
			// Reset the hash seed to make it more difficult for attackers to
			// repeatedly trigger hash collisions. See issue 25237.
			if h.count == 0 {
				h.hash0 = fastrand()
			}
			break search
		}
	}

	if h.flags&hashWriting == 0 {
		fatal("concurrent map writes")
	}
	h.flags &^= hashWriting
}
```

map的写类似上面的读，不详细分析了：

```go
func mapassign(t *maptype, h *hmap, key unsafe.Pointer) unsafe.Pointer {
	// 因为有这句，所以golang编程中声明一个map后，不初始化，赋值会报错。
	// 比如：
	// var countryCapitalMap map[string]string
	// //countryCapitalMap = make(map[string]string)
	// countryCapitalMap [ "France" ] = "巴黎"
	// 若不加中间这句make，会报错
	if h == nil {
		panic(plainError("assignment to entry in nil map"))
	}
	...
	// 读写冲突
	if h.flags&hashWriting != 0 {
		fatal("concurrent map writes")
	}
	hash := t.hasher(key, uintptr(h.hash0))

	// Set hashWriting after calling t.hasher, since t.hasher may panic,
	// in which case we have not actually done a write.
	h.flags ^= hashWriting

	if h.buckets == nil {
		h.buckets = newobject(t.bucket) // newarray(t.bucket, 1)
	}

again:
	bucket := hash & bucketMask(h.B)
	if h.growing() {
		growWork(t, h, bucket)
	}
	b := (*bmap)(add(h.buckets, bucket*uintptr(t.bucketsize)))
	top := tophash(hash)

	var inserti *uint8
	var insertk unsafe.Pointer
	var elem unsafe.Pointer
bucketloop:
	for {
		for i := uintptr(0); i < bucketCnt; i++ {
			if b.tophash[i] != top {
				if isEmpty(b.tophash[i]) && inserti == nil {
					inserti = &b.tophash[i]
					insertk = add(unsafe.Pointer(b), dataOffset+i*uintptr(t.keysize))
					elem = add(unsafe.Pointer(b), dataOffset+bucketCnt*uintptr(t.keysize)+i*uintptr(t.elemsize))
				}
				if b.tophash[i] == emptyRest {
					break bucketloop
				}
				continue
			}
			k := add(unsafe.Pointer(b), dataOffset+i*uintptr(t.keysize))
			if t.indirectkey() {
				k = *((*unsafe.Pointer)(k))
			}
			if !t.key.equal(key, k) {
				continue
			}
			// already have a mapping for key. Update it.
			if t.needkeyupdate() {
				typedmemmove(t.key, k, key)
			}
			elem = add(unsafe.Pointer(b), dataOffset+bucketCnt*uintptr(t.keysize)+i*uintptr(t.elemsize))
			goto done
		}
		ovf := b.overflow(t)
		if ovf == nil {
			break
		}
		b = ovf
	}

	// Did not find mapping for key. Allocate new cell & add entry.

	// If we hit the max load factor or we have too many overflow buckets,
	// and we're not already in the middle of growing, start growing.
	if !h.growing() && (overLoadFactor(h.count+1, h.B) || tooManyOverflowBuckets(h.noverflow, h.B)) {
		hashGrow(t, h)
		goto again // Growing the table invalidates everything, so try again
	}

	if inserti == nil {
		// The current bucket and all the overflow buckets connected to it are full, allocate a new one.
		newb := h.newoverflow(t, b)
		inserti = &newb.tophash[0]
		insertk = add(unsafe.Pointer(newb), dataOffset)
		elem = add(insertk, bucketCnt*uintptr(t.keysize))
	}

	// store new key/elem at insert position
	if t.indirectkey() {
		kmem := newobject(t.key)
		*(*unsafe.Pointer)(insertk) = kmem
		insertk = kmem
	}
	if t.indirectelem() {
		vmem := newobject(t.elem)
		*(*unsafe.Pointer)(elem) = vmem
	}
	typedmemmove(t.key, insertk, key)
	*inserti = top
	h.count++

done:
	if h.flags&hashWriting == 0 {
		fatal("concurrent map writes")
	}
	h.flags &^= hashWriting
	if t.indirectelem() {
		elem = *((*unsafe.Pointer)(elem))
	}
	return elem
}
```

有个特别的地方就是上面mapassign函数只返回了value插入的地址，并没有插入value的值。实际上赋值的最后一步是由编译器额外生成的汇编指令来完成的。汇编和golang编写的runtime包相结合，还是为了提高效率。为何不纯汇编写，效率更高，因为纯汇编有些复杂的流程人脑已经很难完成编写，所以有了编译器和 runtime 配合。

```go
    var a = make(map[int]int, 7)
    for i := 0; i < 1000; i++ {
        a[i] = 99999
    }
```

看看生成的汇编部分:

```bash
    0x003f 00063 (m.go:9)    MOVQ    DX, (SP) // 第一个参数
    0x0043 00067 (m.go:9)    MOVQ    AX, 8(SP) // 第二个参数
    0x0048 00072 (m.go:9)    MOVQ    CX, 16(SP) // 第三个参数
    0x004d 00077 (m.go:9)    PCDATA    $0, $1 // GC 相关
    0x004d 00077 (m.go:9)    CALL    runtime.mapassign_fast64(SB) // 调用函数
    0x0052 00082 (m.go:9)    MOVQ    24(SP), AX // 返回值，即 value 应该存放的内存地址
    0x0057 00087 (m.go:9)    MOVQ    $99999, (AX) // 把 99999 放入该地址中
```

## （4）扩容和迁移

扩容分为sameSizeGrow和biggerSizeGrow：

### sameSizeGrow本质不是扩容，桶数组的length不变，而是重新整理，减少链表，提高寻址效率

```bash
                                                  ┌──────────┬──────────┬──────────┬──────────┬──────────┬──────────┬──────────┬──────────┐
                                                  │    0     │    1     │    2     │    3     │    4     │    5     │    6     │    7     │
                                                  └──────────┼──────────┴─────┬────┴──────────┴──────────┴──────────┴──────────┴──────────┘
                             ┌────────────────┐              │  tophash: 10   │                                                            
                             │     empty      │              │ lowbits: 1001  │                                                            
                             │                │◀─────┐       ├────────────────┤                                                            
                             ├────────────────┤      │       │     empty      │                                                            
                             │     empty      │      │       │                │                                                            
                             │                │      │       ├────────────────┤                                                            
                             ├────────────────┤      │       │     empty      │                                                            
                             │     empty      │      │       │                │                                                            
                    │        │                │      │       ├────────────────┤                                                            
                    │        ├────────────────┤      │       │  tophash: 23   │                                                            
                    │        │     empty      │      │       │ lowbits: 0001  │                                                            
                    │        │                │      │       ├────────────────┤                                                            
                    │        ├────────────────┤      │       │     empty      │                                                            
┌──────────┐        │        │     empty      │      │       │                │                                                            
│  before  │        │        │                │      │       ├────────────────┤                                                            
└──────────┘        │        ├────────────────┤      │       │  tophash: 100  │                                                            
                    │        │     empty      │      │       │ lowbits: 0001  │                                                            
                    │        │                │      │       ├────────────────┤                                                            
                    │        ├────────────────┤      │       │     empty      │                                                            
                    │        │  tophash: 15   │      │       │                │                                                            
                    │        │ lowbits: 0001  │      │       ├────────────────┤                                                            
                    │        ├────────────────┤      │       │     empty      │                                                            
                    │        │     empty      │      │       │                │                                                            
                    │        │                │      │       ├──────────┬─────┘                                                            
                    │        └────────────────┘      └───────│ overflow │                                                                  
                    │                                        └──────────┘                                                                  
                    │                                                                                                                      
                    │                                                                                                                      
                    │                                                                                                                      
                    │                                                                                                                      
                    │                                        ┌────────────────┐                                                            
                    │                                        │  tophash: 10   │                                                            
                    │                                        │ lowbits: 1001  │                                                            
                    │                                        ├────────────────┤                                                            
                    │                                        │  tophash: 23   │                                                            
                    │                                        │ lowbits: 0001  │                                                            
                    │                                        ├────────────────┤                                                            
                    │                                        │  tophash: 100  │                                                            
                    │                                        │ lowbits: 0001  │                                                            
                    │                                        ├────────────────┤                                                            
                    │                                        │  tophash: 15   │                                                            
                    │                                        │ lowbits: 0001  │                                                            
                    │                                        ├────────────────┤                                                            
┌──────────┐        │                                        │     empty      │                                                            
│  after   │        │                                        │                │                                                            
└──────────┘        │                                        ├────────────────┤                                                            
                    │                                        │     empty      │                                                            
                    │                                        │                │                                                            
                    │                                        ├────────────────┤                                                            
                    │                                        │     empty      │                                                            
                    │                                        │                │                                                            
                    │                                        ├────────────────┤                                                            
                    │                                        │     empty      │                                                            
                    │                                        │                │                                                            
                    │                             ┌──────────┼──────────┬─────┴────┬──────────┬──────────┬──────────┬──────────┬──────────┐
                    │                             │    0     │    1     │    2     │    3     │    4     │    5     │    6     │    7     │
                    │                             ├──────────┴──────────┴──────────┴──────────┴──────────┴──────────┴──────────┴──────────┤
                    │                             │                                                                                       │
                    │                             │                                                                                       │
                    │                             │                                                                                       │
                    │                             │                                                                                       │
                    │                             │                                                                                       │
                    │                             │                                                                                       │
                    │                             │                                                                                       │
                    │                             │◀─────────────────────────────         X part           ──────────────────────────────▶│
                    │                             │                                                                                       │
                    ▼                             │                                                                                       │
                                                  │                                                                                       │
                                                  │                                                                                       │
                                                  │                                                                                       │
```

sameSizeGrow需要了解标准桶和溢出桶的概念。当 bucket 总数 < 2 ^ 15 时，如果 overflow 的 bucket 总数 >= bucket 的总数，那么我们认为 overflow 的桶太多了。当 bucket 总数 >= 2 ^ 15 时，那我们直接和 2 ^ 15 比较，overflow 的 bucket >= 2 ^ 15 时，即认为溢出桶太多了。为啥会导致这种情况呢？是因为我们对 map 一边插入，一边删除，会导致其中很多桶出现空洞，这样使得 bucket 使用率不高，值存储得比较稀疏。在查找时效率会下降。

解决方法是通过移动 bucket 内容，使其倾向于紧密排列从而提高 bucket 利用率。

![](/images/golang-map/image-20221102143237849.png)

### biggerSizeGrow是桶数组不够用了而进行的扩容，桶数组的length是原来的2倍

```bash
┌──────────┐                                              ┌──────────┬───────────  
│    0     │                                              │    0     │     ▲       
├──────────┼───────────────┬────────────────┐             ├──────────┤     │       
│    1     │  tophash: 10  │   tophash:23   │      ┌─────▶│    1     │     │       
├──────────┤ lowbits: 1001 │ low bits: 0001 │──────┘      ├──────────┤     │       
│    2     ├───────────────┴────────────────┘             │    2     │     │       
├──────────┤       │                                      ├──────────┤             
│    3     │       │                                      │    3     │             
├──────────┤       │                                      ├──────────┤     X part  
│    4     │       │                                      │    4     │             
├──────────┤       │                                      ├──────────┤             
│    5     │       │                                      │    5     │     │       
├──────────┤       │                                      ├──────────┤     │       
│    6     │       │                                      │    6     │     │       
├──────────┤       │                                      ├──────────┤     │       
│    7     │       │                                      │    7     │     ▼       
└──────────┘       │                                      ├──────────┼───────────  
                   │                                      │    8     │     ▲       
                   │                                      ├──────────┤     │       
                   └─────────────────────────────────────▶│    9     │     │       
                                                          ├──────────┤     │       
                                                          │    10    │     │       
                                                          ├──────────┤             
                                                          │    11    │             
                                                          ├──────────┤     Y part  
                                                          │    12    │             
                                                          ├──────────┤             
                                                          │    13    │     │       
                                                          ├──────────┤     │       
                                                          │    14    │     │       
                                                          ├──────────┤     │       
                                                          │    15    │     ▼       
                                                          └──────────┴───────────  
```

是不是已经到了 load factor 的临界点，即元素个数 >= 桶个数 * 6.5，这时候说明大部分的桶可能都快满了，如果插入新元素，有大概率需要挂在 overflow 的桶上。

解决方法是将 B + 1，进而 hmap 的 bucket 数组扩容一倍。下面的biggerSizeGrow主要是重构扩容后的hmap结构体。

```go
func hashGrow(t *maptype, h *hmap) {
	// If we've hit the load factor, get bigger.
	// Otherwise, there are too many overflow buckets,
	// so keep the same number of buckets and "grow" laterally.
	bigger := uint8(1)
	if !overLoadFactor(h.count+1, h.B) {
		bigger = 0
		h.flags |= sameSizeGrow
	}
	oldbuckets := h.buckets
	newbuckets, nextOverflow := makeBucketArray(t, h.B+bigger, nil)

	flags := h.flags &^ (iterator | oldIterator)
	if h.flags&iterator != 0 {
		flags |= oldIterator
	}
	// commit the grow (atomic wrt gc)
	h.B += bigger
	h.flags = flags
	h.oldbuckets = oldbuckets
	h.buckets = newbuckets
	h.nevacuate = 0
	h.noverflow = 0

	if h.extra != nil && h.extra.overflow != nil {
		// Promote current overflow buckets to the old generation.
		if h.extra.oldoverflow != nil {
			throw("oldoverflow is not nil")
		}
		h.extra.oldoverflow = h.extra.overflow
		h.extra.overflow = nil
	}
	if nextOverflow != nil {
		if h.extra == nil {
			h.extra = new(mapextra)
		}
		h.extra.nextOverflow = nextOverflow
	}

	// the actual copying of the hash table data is done incrementally
	// by growWork() and evacuate().
}
```



### 迁移evacuate

```go
func growWork(t *maptype, h *hmap, bucket uintptr) {
   // make sure we evacuate the oldbucket corresponding
   // to the bucket we're about to use
   // 移动的 oldbucket 对应的是马上就要用到的那一个
   evacuate(t, h, bucket&h.oldbucketmask())

   // evacuate one more oldbucket to make progress on growing
   // 如果还在 growing 状态，再多移动一个 oldbucket
   if h.growing() {
      evacuate(t, h, h.nevacuate)
   }
}
```

evacuate函数主要是 if hash&newbit != 0 { useY = 1 }，决定是迁移到新的桶数组的上半区还是下半区，并进行内存拷贝和旧空间的清理工作。

```go
func evacuate(t *maptype, h *hmap, oldbucket uintptr) {
	b := (*bmap)(add(h.oldbuckets, oldbucket*uintptr(t.bucketsize)))
	newbit := h.noldbuckets()
	if !evacuated(b) {
		// TODO: reuse overflow buckets instead of using new ones, if there
		// is no iterator using the old buckets.  (If !oldIterator.)

		// xy contains the x and y (low and high) evacuation destinations.
		var xy [2]evacDst
		x := &xy[0]
		x.b = (*bmap)(add(h.buckets, oldbucket*uintptr(t.bucketsize)))
		x.k = add(unsafe.Pointer(x.b), dataOffset)
		x.e = add(x.k, bucketCnt*uintptr(t.keysize))

		if !h.sameSizeGrow() {
			// Only calculate y pointers if we're growing bigger.
			// Otherwise GC can see bad pointers.
			y := &xy[1]
			y.b = (*bmap)(add(h.buckets, (oldbucket+newbit)*uintptr(t.bucketsize)))
			y.k = add(unsafe.Pointer(y.b), dataOffset)
			y.e = add(y.k, bucketCnt*uintptr(t.keysize))
		}

		for ; b != nil; b = b.overflow(t) {
			k := add(unsafe.Pointer(b), dataOffset)
			e := add(k, bucketCnt*uintptr(t.keysize))
			for i := 0; i < bucketCnt; i, k, e = i+1, add(k, uintptr(t.keysize)), add(e, uintptr(t.elemsize)) {
				top := b.tophash[i]
				if isEmpty(top) {
					b.tophash[i] = evacuatedEmpty
					continue
				}
				if top < minTopHash {
					throw("bad map state")
				}
				k2 := k
				if t.indirectkey() {
					k2 = *((*unsafe.Pointer)(k2))
				}
				var useY uint8
				if !h.sameSizeGrow() {
					// Compute hash to make our evacuation decision (whether we need
					// to send this key/elem to bucket x or bucket y).
					hash := t.hasher(k2, uintptr(h.hash0))
					if h.flags&iterator != 0 && !t.reflexivekey() && !t.key.equal(k2, k2) {
						// If key != key (NaNs), then the hash could be (and probably
						// will be) entirely different from the old hash. Moreover,
						// it isn't reproducible. Reproducibility is required in the
						// presence of iterators, as our evacuation decision must
						// match whatever decision the iterator made.
						// Fortunately, we have the freedom to send these keys either
						// way. Also, tophash is meaningless for these kinds of keys.
						// We let the low bit of tophash drive the evacuation decision.
						// We recompute a new random tophash for the next level so
						// these keys will get evenly distributed across all buckets
						// after multiple grows.
						useY = top & 1
						top = tophash(hash)
					} else {
						if hash&newbit != 0 {
							useY = 1
						}
					}
				}

				if evacuatedX+1 != evacuatedY || evacuatedX^1 != evacuatedY {
					throw("bad evacuatedN")
				}

				b.tophash[i] = evacuatedX + useY // evacuatedX + 1 == evacuatedY
				dst := &xy[useY]                 // evacuation destination

				if dst.i == bucketCnt {
					dst.b = h.newoverflow(t, dst.b)
					dst.i = 0
					dst.k = add(unsafe.Pointer(dst.b), dataOffset)
					dst.e = add(dst.k, bucketCnt*uintptr(t.keysize))
				}
				dst.b.tophash[dst.i&(bucketCnt-1)] = top // mask dst.i as an optimization, to avoid a bounds check
				if t.indirectkey() {
					*(*unsafe.Pointer)(dst.k) = k2 // copy pointer
				} else {
					typedmemmove(t.key, dst.k, k) // copy elem
				}
				if t.indirectelem() {
					*(*unsafe.Pointer)(dst.e) = *(*unsafe.Pointer)(e)
				} else {
					typedmemmove(t.elem, dst.e, e)
				}
				dst.i++
				// These updates might push these pointers past the end of the
				// key or elem arrays.  That's ok, as we have the overflow pointer
				// at the end of the bucket to protect against pointing past the
				// end of the bucket.
				dst.k = add(dst.k, uintptr(t.keysize))
				dst.e = add(dst.e, uintptr(t.elemsize))
			}
		}
		// Unlink the overflow buckets & clear key/elem to help GC.
		if h.flags&oldIterator == 0 && t.bucket.ptrdata != 0 {
			b := add(h.oldbuckets, oldbucket*uintptr(t.bucketsize))
			// Preserve b.tophash because the evacuation
			// state is maintained there.
			ptr := add(b, dataOffset)
			n := uintptr(t.bucketsize) - dataOffset
			memclrHasPointers(ptr, n)
		}
	}

	if oldbucket == h.nevacuate {
		advanceEvacuationMark(h, t, newbit)
	}
}
```

![](/images/golang-map/image-20221102143607066.png)

