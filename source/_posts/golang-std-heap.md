---
title: Golang标准库 container/heap
readmore: true
date: 2022-12-12 18:58:25
categories: 云原生
tags:
- Golang
---

# Heap

> https://github.com/golang/go/tree/master/src/container/heap

heap和之前讲的list和ring有一个很大不同是，list和ring直接拿来调用即可，元素的值是任意对象，而heap需要根据不同的对象自己定义堆的方法的实现，就是用堆需要首先实现heap.Interface接口中的方法，然后应用堆的pop，push等方法才能够实现想要的功能。

heap的源码不足120行。直接上源码。

```go
// Copyright 2009 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package heap provides heap operations for any type that implements
// heap.Interface. A heap is a tree with the property that each node is the
// minimum-valued node in its subtree.
//
// The minimum element in the tree is the root, at index 0.
//
// A heap is a common way to implement a priority queue. To build a priority
// queue, implement the Heap interface with the (negative) priority as the
// ordering for the Less method, so Push adds items while Pop removes the
// highest-priority item from the queue. The Examples include such an
// implementation; the file example_pq_test.go has the complete source.
package heap

import "sort"

// The Interface type describes the requirements
// for a type using the routines in this package.
// Any type that implements it may be used as a
// min-heap with the following invariants (established after
// Init has been called or if the data is empty or sorted):
//
//	!h.Less(j, i) for 0 <= i < h.Len() and 2*i+1 <= j <= 2*i+2 and j < h.Len()
//
// Note that Push and Pop in this interface are for package heap's
// implementation to call. To add and remove things from the heap,
// use heap.Push and heap.Pop.
type Interface interface {
	sort.Interface
	Push(x any) // add x as element Len()
	Pop() any   // remove and return element Len() - 1.
}

// Init establishes the heap invariants required by the other routines in this package.
// Init is idempotent with respect to the heap invariants
// and may be called whenever the heap invariants may have been invalidated.
// The complexity is O(n) where n = h.Len().
func Init(h Interface) {
	// heapify
	n := h.Len()
	for i := n/2 - 1; i >= 0; i-- {
		down(h, i, n)
	}
}

// Push pushes the element x onto the heap.
// The complexity is O(log n) where n = h.Len().
func Push(h Interface, x any) {
	h.Push(x)
	up(h, h.Len()-1)
}

// Pop removes and returns the minimum element (according to Less) from the heap.
// The complexity is O(log n) where n = h.Len().
// Pop is equivalent to Remove(h, 0).
func Pop(h Interface) any {
	n := h.Len() - 1
	h.Swap(0, n)
	down(h, 0, n)
	return h.Pop()
}

// Remove removes and returns the element at index i from the heap.
// The complexity is O(log n) where n = h.Len().
func Remove(h Interface, i int) any {
	n := h.Len() - 1
	if n != i {
		h.Swap(i, n)
		if !down(h, i, n) {
			up(h, i)
		}
	}
	return h.Pop()
}

// Fix re-establishes the heap ordering after the element at index i has changed its value.
// Changing the value of the element at index i and then calling Fix is equivalent to,
// but less expensive than, calling Remove(h, i) followed by a Push of the new value.
// The complexity is O(log n) where n = h.Len().
func Fix(h Interface, i int) {
	if !down(h, i, h.Len()) {
		up(h, i)
	}
}

func up(h Interface, j int) {
	for {
		i := (j - 1) / 2 // parent
		if i == j || !h.Less(j, i) {
			break
		}
		h.Swap(i, j)
		j = i
	}
}

func down(h Interface, i0, n int) bool {
	i := i0
	for {
		j1 := 2*i + 1
		if j1 >= n || j1 < 0 { // j1 < 0 after int overflow
			break
		}
		j := j1 // left child
		if j2 := j1 + 1; j2 < n && h.Less(j2, j1) {
			j = j2 // = 2*i + 2  // right child
		}
		if !h.Less(j, i) {
			break
		}
		h.Swap(i, j)
		i = j
	}
	return i > i0
}
```

要理解上面的代码，主要难点和重点是down方法，在看代码前首先要知道堆具有以下特性：
1. 任意节点小于（或大于）它的所有后裔，最小元（或最大元）在堆的根上（堆序性）。
2. 堆总是一棵完全二叉树（complete tree）。即除了最底层，其他层的节点都被元素填满，且最底层尽可能地从左到右填入。
3. 因为堆总是完全二叉树，所以堆是一个顺序一维数组。任何元素（假设下标index=i）的子元素的下标必然分别是2i+1, 2i+2。如下图所示。

![](/images/golang-std-heap/2022-12-12-16-55-52.png)

有了上面的堆特性的概念，理解down方法就不难了。down方法的三个入参分别是 heap， 需要下沉down的元素下标， heap的长度。返回值是是否对元素做了下沉操作。for循环是遍历完该元素的每一层，直到最后一层（一旦检测到不需要下沉了，就是该元素比下一层的两个元素都要小，跳出for循环）。

```go
		j := j1 // left child
		if j2 := j1 + 1; j2 < n && h.Less(j2, j1) {
			j = j2 // = 2*i + 2  // right child
		}
```

上面的代码是先对比下一层的两个元素（子节点的左右元素），执行完上面的语句后，j是两个子节点的相对较小的元素的index。

然后和父元素比较，若父元素比较小的子元素还要小，则该父元素不需要再下沉了，跳出for循环，否则需要下沉至下一层较小的元素的位置，继续for循环进入再下一层比较。

init方法和pop方法用到了down方法。init就是从倒数第二层开始遍历所有元素直到顶层对每个元素调用下沉方法。pop方法就是弹出顶层的最小元素，然后调用down方法重新排序填补顶层元素的位置。

up方法是上浮，每次调用push方法的时候都要讲push的元素上浮，因为每次push都是将元素push在顺序数组的最后一个位置。

up方法就是down方法的反过来，但是要略简单一些，因为一来不需要知道一维数组长度从而判定是否是最底层，只要index为0就知道是顶层了，up方法就可以跳出for循环。二来down方法每下一层需要当前节点和2个子节点比较，up方法，每上一层，只需要当前节点和父节点比较。

Remove方法和Fix方法都涉及到了对index为i的元素先下沉，若没有下沉则上浮的操作。Remove是因为删除了一个元素需要填补空缺，Fix因为该元素的value被改了，需要重新排序。

开头的时候说了，heap和之前讲的list和ring有一个很大不同是，list和ring直接拿来调用即可，而heap需要根据不同的对象自己定义堆的方法的实现。需要实现接口的5个方法：

* Push(x any) // add x as element Len()
* Pop() any   // remove and return element Len() - 1.
* Len() int
* Less(i, j int) bool
* Swap(i, j int)

下面介绍三种具体的heap实现：IntHeap，优先队列，时间戳队列

# IntHeap

```go
// This example demonstrates an integer heap built using the heap interface.
package main

import (
	"container/heap"
	"fmt"
)

// An IntHeap is a min-heap of ints.
type IntHeap []int

func (h IntHeap) Len() int           { return len(h) }
func (h IntHeap) Less(i, j int) bool { return h[i] < h[j] }
func (h IntHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }

func (h *IntHeap) Push(x any) {
	// Push and Pop use pointer receivers because they modify the slice's length,
	// not just its contents.
	*h = append(*h, x.(int))
}

func (h *IntHeap) Pop() any {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[0 : n-1]
	return x
}

// This example inserts several ints into an IntHeap, checks the minimum,
// and removes them in order of priority.
func main() {
	h := &IntHeap{2, 1, 5}
	heap.Init(h)
	heap.Push(h, 3)
	fmt.Printf("minimum: %d\n", (*h)[0])
	for h.Len() > 0 {
		fmt.Printf("%d ", heap.Pop(h))
	}
}

// Output：
// minimum: 1
// 1 2 3 5
```

# 优先队列

```go
// This example demonstrates a priority queue built using the heap interface.
package main

import (
	"container/heap"
	"fmt"
)

// An Item is something we manage in a priority queue.
type Item struct {
	value    string // The value of the item; arbitrary.
	priority int    // The priority of the item in the queue.
	// The index is needed by update and is maintained by the heap.Interface methods.
	index int // The index of the item in the heap.
}

// A PriorityQueue implements heap.Interface and holds Items.
type PriorityQueue []*Item

func (pq PriorityQueue) Len() int { return len(pq) }

func (pq PriorityQueue) Less(i, j int) bool {
	// We want Pop to give us the highest, not lowest, priority so we use greater than here.
	return pq[i].priority > pq[j].priority
}

func (pq PriorityQueue) Swap(i, j int) {
	pq[i], pq[j] = pq[j], pq[i]
	pq[i].index = i
	pq[j].index = j
}

func (pq *PriorityQueue) Push(x any) {
	n := len(*pq)
	item := x.(*Item)
	item.index = n
	*pq = append(*pq, item)
}

func (pq *PriorityQueue) Pop() any {
	old := *pq
	n := len(old)
	item := old[n-1]
	old[n-1] = nil  // avoid memory leak
	item.index = -1 // for safety
	*pq = old[0 : n-1]
	return item
}

// update modifies the priority and value of an Item in the queue.
func (pq *PriorityQueue) update(item *Item, value string, priority int) {
	item.value = value
	item.priority = priority
	heap.Fix(pq, item.index)
}

// This example creates a PriorityQueue with some items, adds and manipulates an item,
// and then removes the items in priority order.
func main() {
	// Some items and their priorities.
	items := map[string]int{
		"banana": 3, "apple": 2, "pear": 4,
	}

	// Create a priority queue, put the items in it, and
	// establish the priority queue (heap) invariants.
	pq := make(PriorityQueue, len(items))
	i := 0
	for value, priority := range items {
		pq[i] = &Item{
			value:    value,
			priority: priority,
			index:    i,
		}
		i++
	}
	heap.Init(&pq)

	// Insert a new item and then modify its priority.
	item := &Item{
		value:    "orange",
		priority: 1,
	}
	heap.Push(&pq, item)
	pq.update(item, item.value, 5)

	// Take the items out; they arrive in decreasing priority order.
	for pq.Len() > 0 {
		item := heap.Pop(&pq).(*Item)
		fmt.Printf("%.2d:%s ", item.priority, item.value)
	}
}


// Output
// 05:orange 04:pear 03:banana 02:apple
```

# 时间戳队列

```go
package util

import (
	"container/heap"
)

type TimeSortedQueueItem struct {
	Time  int64
	Value interface{}
}

type TimeSortedQueue []*TimeSortedQueueItem

func (q TimeSortedQueue) Len() int           { return len(q) }
func (q TimeSortedQueue) Less(i, j int) bool { return q[i].Time < q[j].Time }
func (q TimeSortedQueue) Swap(i, j int)      { q[i], q[j] = q[j], q[i] }

func (q *TimeSortedQueue) Push(v interface{}) {
	*q = append(*q, v.(*TimeSortedQueueItem))
}

func (q *TimeSortedQueue) Pop() interface{} {
	n := len(*q)
	item := (*q)[n-1]
	*q = (*q)[0 : n-1]
	return item
}

func NewTimeSortedQueue(items ...*TimeSortedQueueItem) *TimeSortedQueue {
	q := make(TimeSortedQueue, len(items))
	for i, item := range items {
		q[i] = item
	}
	heap.Init(&q)
	return &q
}

func (q *TimeSortedQueue) PushItem(time int64, value interface{}) {
	heap.Push(q, &TimeSortedQueueItem{
		Time:  time,
		Value: value,
	})
}

func (q *TimeSortedQueue) PopItem() interface{} {
	if q.Len() == 0 {
		return nil
	}

	return heap.Pop(q).(*TimeSortedQueueItem).Value
}
```