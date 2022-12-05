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

该结构体包含有一个KeyFunc函数属性和ThreadSafeStore接口，下面的threadSafeMap struct实现了ThreadSafeStore接口的所有方法。

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

通读下client-go\tools\cache 包下的 store.go 和 thread_safe_store.go 的代码，其中索引有点绕，多次反复对照上图可以获得更好理解。再结合下面实际的建立和查询索引的例子：

```go
package main

import (
	"fmt"

	v1 "k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/api/meta"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/tools/cache"
)

const (
	NamespaceIndexName = "namespace"
	NodeNameIndexName  = "nodeName"
)

func NamespaceIndexFunc(obj interface{}) ([]string, error) {
	m, err := meta.Accessor(obj)
	if err != nil {
		return []string{""}, fmt.Errorf("object has no meta: %v", err)
	}
	return []string{m.GetNamespace()}, nil
}

func NodeNameIndexFunc(obj interface{}) ([]string, error) {
	pod, ok := obj.(*v1.Pod)
	if !ok {
		return []string{}, nil
	}
	return []string{pod.Spec.NodeName}, nil
}

func main() {
	index := cache.NewIndexer(cache.MetaNamespaceKeyFunc, cache.Indexers{
		NamespaceIndexName: NamespaceIndexFunc,
		NodeNameIndexName:  NodeNameIndexFunc,
	})

	pod1 := &v1.Pod{
		ObjectMeta: metav1.ObjectMeta{
			Name:      "index-pod-1",
			Namespace: "default",
		},
		Spec: v1.PodSpec{NodeName: "node1"},
	}
	pod2 := &v1.Pod{
		ObjectMeta: metav1.ObjectMeta{
			Name:      "index-pod-2",
			Namespace: "default",
		},
		Spec: v1.PodSpec{NodeName: "node2"},
	}
	pod3 := &v1.Pod{
		ObjectMeta: metav1.ObjectMeta{
			Name:      "index-pod-3",
			Namespace: "kube-system",
		},
		Spec: v1.PodSpec{NodeName: "node2"},
	}

	_ = index.Add(pod1)
	_ = index.Add(pod2)
	_ = index.Add(pod3)

	// ByIndex 两个参数：IndexName（索引器名称）和 indexKey（需要检索的key）
	pods, err := index.ByIndex(NamespaceIndexName, "default")
	if err != nil {
		panic(err)
	}
	for _, pod := range pods {
		fmt.Println(pod.(*v1.Pod).Name)
	}

	fmt.Println("==========================")

	pods, err = index.ByIndex(NodeNameIndexName, "node2")
	if err != nil {
		panic(err)
	}
	for _, pod := range pods {
		fmt.Println(pod.(*v1.Pod).Name)
	}

}
```

上面的代码可以说是最常见的最简单的索引example。创建了两个索引函数，分别是NamespaceIndexFunc和NodeNameIndexFunc，函数的作用分别是获取obj的namespace信息和获取obj的所在节点信息。创建了3个pod，其中pod1，pod2在default namespace中，pod3在另一个namespace中；pod2，pod3在node2上，pod1在另一个node上。

index.ByIndex是通过索引查找，调用了两次，分别查找default namespace的pod对象 和 在node2节点的pod对象。

```bash
GOROOT=C:\go\go1.19 #gosetup
GOPATH=C:\Users\hanwei\go #gosetup
C:\go\go1.19\bin\go.exe build -o C:\Users\hanwei\AppData\Local\Temp\GoLand\___11go_build_lab.exe lab #gosetup
C:\Users\hanwei\AppData\Local\Temp\GoLand\___11go_build_lab.exe
index-pod-1
index-pod-2
==========================
index-pod-2
index-pod-3

Process finished with the exit code 0
```

```go
ByIndex(indexName, indexedValue string) ([]interface{}, error)
```

ByIndex 方法，更加索引器名称，比如上面main方法例子中的nodeName索引器名称，获取索引函数NodeNameIndexFunc，所根据索引器名称获得的索引函数为nil，则往上层报错索引器不存在。并根据索引器名称nodeName获取真正的索引index，对应上图的右下角的表格，ByIndex 方法的第二个参数对应上图右下角表格的第一列，set := index[indexedValue]中的set对应第二列，set对应items的key值，items map是实际存储obj的map。通过set对应items的key值可以获取实际的obj，即main方法中的pod list。

```go
// ByIndex returns a list of the items whose indexed values in the given index include the given indexed value
func (c *threadSafeMap) ByIndex(indexName, indexedValue string) ([]interface{}, error) {
	c.lock.RLock()
	defer c.lock.RUnlock()

	indexFunc := c.indexers[indexName]
	if indexFunc == nil {
		return nil, fmt.Errorf("Index with name %s does not exist", indexName)
	}

	index := c.indices[indexName]

	set := index[indexedValue]
	list := make([]interface{}, 0, set.Len())
	for key := range set {
		list = append(list, c.items[key])
	}

	return list, nil
}
```

```go

```

```go

```

```go

```