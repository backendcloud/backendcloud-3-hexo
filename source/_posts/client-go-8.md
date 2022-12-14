---
title: wiprocess - client-go 源码分析（8） - workerqueue之延时队列DelayingQueue
readmore: true
date: 2022-12-14 12:59:07
categories: 云原生
tags:
- client-go
---

延时队列DelayingQueue，从下面的接口可以看出添加的元素，有一个延迟时间，延时时间到了之后才能加入队列。

延迟队列的实现是，根据加入队列的时间，构造一个最小堆，然后到时间点后，将最小堆pop一个元素加入queue中（因为最小堆是按照延时时间从小到大排序的）。在判断时间点是否到达，用到了心跳机制和channel机制。

```go
// DelayingInterface is an Interface that can Add an item at a later time. This makes it easier to
// requeue items after failures without ending up in a hot-loop.
type DelayingInterface interface {
	Interface
	// AddAfter adds an item to the workqueue after the indicated duration has passed
	AddAfter(item interface{}, duration time.Duration)
}

type delayingType struct {
	Interface

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

```go

```

```go

```

```go

```

```go

```

```go

```

```go

```
