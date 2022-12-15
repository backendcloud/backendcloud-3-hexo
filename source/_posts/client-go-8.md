---
title: client-go 源码分析（8） - workerqueue之延时队列DelayingQueue
readmore: false
date: 2022-12-14 12:59:07
categories: 云原生
tags:
- client-go
---

延时队列DelayingQueue，从下面的接口可以看出添加的元素，有一个延迟时间，延时时间到了之后才能加入队列。

延迟队列的实现是，根据加入队列的时间，构造一个最小堆min-heap，然后到时间点后，将从最小堆pop一个元素加入queue中（因为最小堆是按照延时时间从小到大排序的）。

```go
type DelayingInterface interface {
	Interface
	// AddAfter adds an item to the workqueue after the indicated duration has passed
	AddAfter(item interface{}, duration time.Duration)
}

type delayingType struct {
	Interface // 实例化延迟队列的同时实例化了普通队列

	// clock tracks time for delayed firing
	clock clock.Clock

	// stopCh lets us signal a shutdown to the waiting loop
	stopCh chan struct{}
	// stopOnce guarantees we only signal shutdown a single time
	stopOnce sync.Once

	// heartbeat ensures we wait no more than maxWait before firing
	heartbeat clock.Ticker

	// waitingForAddCh is a buffered channel that feeds waitingForAdd
	waitingForAddCh chan *waitFor

	// metrics counts the number of retries
	metrics retryMetrics
}
```

延迟队列的实现用到了很多概念和数据结构，需要搞清楚这些概念和数据结构才能理解相关代码，且在判断时间点是否到达，用到了最小堆机制，心跳机制和channel机制。

waitFor结构体保存了要加入队列的数据对象，加入队列的时间，waitFor最为最小堆item的堆上的index。

```go
type waitFor struct {
   data    t          // 准备添加到队列中的数据
   readyAt time.Time  // 应该被加入队列的时间
   index int          // 在 heap 中的索引
}
```

下面代码实现了堆heap的接口的5个方法。堆heap的元素item就是上面的waitFor结构体。

```go
type waitForPriorityQueue []*waitFor

func (pq waitForPriorityQueue) Len() int {
	return len(pq)
}
func (pq waitForPriorityQueue) Less(i, j int) bool {
	return pq[i].readyAt.Before(pq[j].readyAt)
}
func (pq waitForPriorityQueue) Swap(i, j int) {
	pq[i], pq[j] = pq[j], pq[i]
	pq[i].index = i
	pq[j].index = j
}
func (pq *waitForPriorityQueue) Push(x interface{}) {
	n := len(*pq)
	item := x.(*waitFor)
	item.index = n
	*pq = append(*pq, item)
}
func (pq *waitForPriorityQueue) Pop() interface{} {
	n := len(*pq)
	item := (*pq)[n-1]
	item.index = -1
	*pq = (*pq)[0:(n - 1)]
	return item
}
// 返回第一个元素，非heap接口的实现方法。
// 这里没有写错，函数接收器不用指针是为了不改变waitForPriorityQueue内的数据。
// 后面调用该方法都是为了检查最小堆pop的item，（因为是最小堆，pop出来的item的到期时间一定是最早的）的到期时间是比now时间早还是晚
func (pq waitForPriorityQueue) Peek() interface{} {
    return pq[0]
}
```

延时队列DelayingQueue的核心就是运行 waitingLoop方法。

```go
func newDelayingQueue(clock clock.WithTicker, q Interface, name string) *delayingType {
	ret := &delayingType{
		Interface:       q,
		clock:           clock,
		heartbeat:       clock.NewTicker(maxWait),
		stopCh:          make(chan struct{}),
		waitingForAddCh: make(chan *waitFor, 1000),
		metrics:         newRetryMetrics(name),
	}

	go ret.waitingLoop()
	return ret
}
```

AddAfter方法是对DelayingInterface接口的实现。AddAfter方法是在给定延迟后将给定项目添加到工作队列。具体是通过将两个入参组装成waitFor结构体 &waitFor{data: item, readyAt: q.clock.Now().Add(duration)} 放入到channel waitingForAddCh: make(chan *waitFor, 1000) 中去。（最大可以缓存1000个 &waitForm items）

```go
func (q *delayingType) AddAfter(item interface{}, duration time.Duration) {
	// don't add if we're already shutting down
	if q.ShuttingDown() {
		return
	}

	q.metrics.retry()

	// immediately add things with no delay
	if duration <= 0 {
		q.Add(item)
		return
	}

	select {
	case <-q.stopCh:
		// unblock if ShutDown() is called
	case q.waitingForAddCh <- &waitFor{data: item, readyAt: q.clock.Now().Add(duration)}:
	}
}
```

waitingLoop方法，随着delayingType实例的创建而启动，并一直运行下去直到workqueue被shutdown。waitingLoop方法一直在做的事情就是 不停的将上面的 AddAfter方法 放进 q.waitingForAddCh channel的item取出来，根据item的时间是早于现在还是晚于现在，早于现在就加入工作队列，晚于现在就放到heap上。并不断的从heap pop出第一个item，检测item的到期时间，根据item的时间是早于现在还是晚于现在，早于现在就加入工作队列，晚于现在啥也不做，item继续保留在heap上。

```go
func (q *delayingType) waitingLoop() {
	defer utilruntime.HandleCrash()

	// Make a placeholder channel to use when there are no items in our list
	never := make(<-chan time.Time)

	// Make a timer that expires when the item at the head of the waiting queue is ready
	var nextReadyAtTimer clock.Timer

	waitingForQueue := &waitForPriorityQueue{}
	heap.Init(waitingForQueue)

	waitingEntryByData := map[t]*waitFor{}

	for {
		// 如果该延迟队列包含wrap的普通队列的属性和方法，得知该队列正在被关闭，则跳出整个waitingLoop()方法
		if q.Interface.ShuttingDown() {
			return
		}

		now := q.clock.Now()

		// Add ready entries
		for waitingForQueue.Len() > 0 {
			entry := waitingForQueue.Peek().(*waitFor)
			// heap的第一个item是最接近到期时间的，该item时间还没到，则heap不动，若该item时间已到，则pop出来，并将该item加入workqueue和从唯一无序set集合waitingEntryByData删除该item。
			if entry.readyAt.After(now) {
				break
			}

			entry = heap.Pop(waitingForQueue).(*waitFor)
			q.Add(entry.data)
			delete(waitingEntryByData, entry.data)
		}

		// Set up a wait for the first item's readyAt (if one exists)
		// nextReadyAt是个定时器，never是永不到期的定时器
		nextReadyAt := never
		//若 heeap：waitingForQueue 还有item
		if waitingForQueue.Len() > 0 {
			// 若定时器在工作，则停止改计时器
			if nextReadyAtTimer != nil {
				nextReadyAtTimer.Stop()
			}
			entry := waitingForQueue.Peek().(*waitFor) // 获取 heeap：waitingForQueue 首个item
			nextReadyAtTimer = q.clock.NewTimer(entry.readyAt.Sub(now)) // 获取该首个item还有多久到期（到期时间减去现在时间），根据该时间创建定时器 nextReadyAtTimer.C()
			nextReadyAt = nextReadyAtTimer.C() 
		}

		select {
		case <-q.stopCh:
			return

		case <-q.heartbeat.C():
			// continue the loop, which will add ready items

		case <-nextReadyAt:
			// continue the loop, which will add ready items

		case waitEntry := <-q.waitingForAddCh:
			if waitEntry.readyAt.After(q.clock.Now()) {
				insert(waitingForQueue, waitingEntryByData, waitEntry)
			} else {
				q.Add(waitEntry.data)
			}

			drained := false
			for !drained {
				select {
				case waitEntry := <-q.waitingForAddCh:
					if waitEntry.readyAt.After(q.clock.Now()) {
						insert(waitingForQueue, waitingEntryByData, waitEntry)
					} else {
						q.Add(waitEntry.data)
					}
				default:
					drained = true
				}
			}
		}
	}
}
```

上面的代码中的select方法，满足心跳时间 或者 pop后的heap的第一个元素的时间已经到了 或者q.waitingForAddCh channel有数据，就进入下一次的for循环。

其中，从q.waitingForAddCh取出数据后，根据item的到期时间，决定是放入堆中（item的到期时间晚于现在的时间），还是放入工作队列（item的到期时间早于现在的时间）。本次的放入工作队列不同于上面几行的放入工作队列的代码，区别是上次是从堆里拿出的item，这次是从channel拿出的item跳过了放入堆的过程直接放入工作队列。（因为item的到期时间已经晚于现在的时间，没必要放投入堆里进行排序了，提高执行效率，避免做无用功）

for !drained 是为了将 q.waitingForAddCh channel里的items处理完，当 drained = true 表示已处理完成该channel的全部items。

insert方法往heap添加元素，分两种情况。若元素存在则update，若不存在，push该元素到heap中，并将入参的 knownEntries（即waitingLoop方法的waitingEntryByData） set集合添加该元素的值，为了保证不重复。

```go
func insert(q *waitForPriorityQueue, knownEntries map[t]*waitFor, entry *waitFor) {
	// if the entry already exists, update the time only if it would cause the item to be queued sooner
	existing, exists := knownEntries[entry.data]
	if exists {
		if existing.readyAt.After(entry.readyAt) {
			existing.readyAt = entry.readyAt
			heap.Fix(q, existing.index)
		}

		return
	}

	heap.Push(q, entry)
	knownEntries[entry.data] = entry
}
```