---
title: WIProcess-client-go 源码分析（5） - informer机制中的本地存储
readmore: true
date: 2022-12-05 18:16:20
categories: 云原生
tags:
- client-go
---

informer机制中的本地存储（local cache），对应的结构体是下面的cache struct。

```go
type cache struct {
	// cacheStorage bears the burden of thread safety for the cache
	cacheStorage ThreadSafeStore
	// keyFunc is used to make the key for objects stored in and retrieved from items, and
	// should be deterministic.
	keyFunc KeyFunc
}
```

改结构体包含有一个KeyFunc函数属性和ThreadSafeStore接口，下面的threadSafeMap struct实现了ThreadSafeStore接口的所有方法。

```go
type KeyFunc func(obj interface{}) (string, error)
```

KeyFunc用于实现将某个对象通过KeyFunc函数算出对对应的key，该key就是items的key，而items map就是实际的本地存储。

```go
type threadSafeMap struct {
	lock  sync.RWMutex
	items map[string]interface{}

	// index implements the indexing functionality
	index *storeIndex
}
```

```go
type storeIndex struct {
	// indexers maps a name to an IndexFunc
	indexers Indexers
	// indices maps a name to an Index
	indices Indices
}
```

在进入threadSafeMap结构体中的storeIndex结构体前，需要了解几个概念。

storeIndex是items map的索引，且设计的比较精妙，但是理解起来有点绕，下面的图是索引的简单例子。接下来的索引的代码要结合下面的图理解会清晰很多。

![](/images/client-go-5/2022-12-05-11-01-45.png)

在local store中最主要的是有4个概念需要理解：

1. Indexers: type Indexers map[string]IndexFunc
2. IndexFunc: type IndexFunc func(obj interface{}) ([]string, error)
3. Indices: type Indices map[string]Index
4. Index: type Index map[string]sets.String

结合上面的图理解：
1. Indexers：索引函数的集合，它为一个map，其key为索引器的名字IndexName(自定义，但要唯一)，value为对应的索引函数IndexFunc
2. IndexFunc: 索引函数，它接收一个obj，并实现逻辑来取出/算出该obj的索引数组。需要注意是索引数组，具体取什么或算出什么作为索引完全是我们可以自定义的。
3. Indices: 索引数据集合，它为一个map，其key和Indexers中的key对应，表示索引器的名字。Value为当前到达数据通过该索引函数计算出来的Index。
4. Index: 索引与数据key集合，它的key为索引器计算出来的索引数组中的每一项，value为对应的资源的key(默认namespace/name)集合。

```go

```

```go

```

```go

```