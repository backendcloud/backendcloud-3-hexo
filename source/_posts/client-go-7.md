---
title: client-go 源码分析（7） - workerqueue之普通队列Queue
readmore: true
date: 2022-12-14 12:35:57
categories: 云原生
tags:
- client-go
---

client-go 的 util/workqueue 包里主要有三个队列，分别是普通队列Queue，延时队列DelayingQueue，限速队列RateLimitingQueue，后一个队列以前一个队列的实现为基础，层层添加新功能。

workqueue是整个client-go源码的难点。采用层层拨开分步理解有助于理解workqueue的源码。理解workqueue源码前，首先需要理解之前介绍的标准库限流器和标准库heap的源码。

下面是queue的接口。queue、dirty、processing 都保存 items。区别是queue是有序列表用来存储 item 的处理顺序。dirty集合存储的是所有需要处理的 item，是set类型，无序，用于保证items的唯一。processing集合存储的是当前正在处理的 item，也是set类型，无序，用于保证items的唯一。

```go
type Interface interface {
	Add(item interface{})
	Len() int
	Get() (item interface{}, shutdown bool)
	Done(item interface{})
	ShutDown()
	ShutDownWithDrain()
	ShuttingDown() bool
}

type Type struct {
	// queue defines the order in which we will work on items. Every
	// element of queue should be in the dirty set and not in the
	// processing set.
	queue []t

	// dirty defines all of the items that need to be processed.
	dirty set

	// Things that are currently being processed are in the processing set.
	// These things may be simultaneously in the dirty set. When we finish
	// processing something and remove it from this set, we'll check if
	// it's in the dirty set, and if so, add it to the queue.
	processing set

	cond *sync.Cond

	shuttingDown bool
	drain        bool

	metrics queueMetrics

	unfinishedWorkUpdatePeriod time.Duration
	clock                      clock.WithTicker
}
```

set集合的代码：

```go
type empty struct{}
type t interface{}
type set map[t]empty

func (s set) has(item t) bool {
	_, exists := s[item]
	return exists
}

func (s set) insert(item t) {
	s[item] = empty{}
}

func (s set) delete(item t) {
	delete(s, item)
}

func (s set) len() int {
	return len(s)
}
```

队列queue主要又3个方法，Add，Get，Done。

Add方法将item加入队列q.queue和待处理集合q.dirty。若该item正在被处理只加入q.dirty。

```go
func (q *Type) Add(item interface{}) {
	q.cond.L.Lock()
	defer q.cond.L.Unlock()
	if q.shuttingDown {
		return
	}
	if q.dirty.has(item) {
		return
	}

	q.metrics.add(item)

	q.dirty.insert(item)
	if q.processing.has(item) {
		return
	}

	q.queue = append(q.queue, item)
	q.cond.Signal()
}
```

Get方法是从 queue队列中取出一个元素item加入正处理集合q.processing，并从queue队列中删除，从dirty中删除。

```go
func (q *Type) Get() (item interface{}, shutdown bool) {
	q.cond.L.Lock()
	defer q.cond.L.Unlock()
	for len(q.queue) == 0 && !q.shuttingDown {
		q.cond.Wait()
	}
	if len(q.queue) == 0 {
		// We must be shutting down.
		return nil, true
	}

	item = q.queue[0]
	// The underlying array still exists and reference this object, so the object will not be garbage collected.
	q.queue[0] = nil
	q.queue = q.queue[1:]

	q.metrics.get(item)

	q.processing.insert(item)
	q.dirty.delete(item)

	return item, false
}
```

Done方法是表明这个元素item被处理完了，从processing队列删除。这里加了一个判断，如果dirty中还存在，还要将其加入 queue队列。

```go
func (q *Type) Done(item interface{}) {
	q.cond.L.Lock()
	defer q.cond.L.Unlock()

	q.metrics.done(item)

	q.processing.delete(item)
	if q.dirty.has(item) {
		q.queue = append(q.queue, item)
		q.cond.Signal()
	} else if q.processing.len() == 0 {
		q.cond.Signal()
	}
}
```
