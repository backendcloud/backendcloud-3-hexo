---
title: WIProcess- client-go 源码分析（7） - Golang 标准库限流器
readmore: true
date: 2022-12-07 12:55:52
categories: 云原生
tags:
- client-go
---

![](/images/client-go-6/2022-12-06-15-28-32.png)

上图可以看出 client-go 用到了 workqueue 队列 来处理 从 DeltaFIFO pop 出来的内容，workqueue 队列用到了限流队列。

在分析workqueue前，需要了解下实现限流队列的限流器。限流器有多种实现，client-go用的限流器是 Golang 标准库限流器（Golang 的 timer/rate）。

本篇是关于 Golang 标准库限流器。

令牌桶就是想象有一个固定大小的桶，有取有放。

放：系统会以恒定速率向桶中放 Token，桶满则暂时不放。

取：用户则从桶中取 Token，如果有剩余 Token 就可以一直取。如果没有剩余 Token，则需要等到系统中被放置了 Token 才行。

直接按上面的实现，效率太低了，不仅要维护一个定时放token的定时器，还要维护一个token队列，消耗不必要的内存和算力。在 Golang 的 timer/rate 中的实现 是通过 lazyload 的方式，每次消费之前才根据时间差更新 Token 数目（是计算得到的）。

下面进入代码。内容主要是两个结构体，Limiter struct 和 Reservation struct。两个方法，reserve 预留方法 和 Token 的归还方法。

```go
// Limit defines the maximum frequency of some events.
// Limit is represented as number of events per second.
// A zero Limit allows no events.
type Limit float64

// Inf is the infinite rate limit; it allows all events (even if burst is zero).
const Inf = Limit(math.MaxFloat64)

// Every converts a minimum time interval between events to a Limit.
func Every(interval time.Duration) Limit {
	if interval <= 0 {
		return Inf
	}
	return 1 / Limit(interval.Seconds())
}
```

```go
type Limiter struct {
	mu     sync.Mutex
    // limit 最大事件率
	limit  Limit
    // burst 桶大小
	burst  int
    // tokens 桶的当前令牌数目
	tokens float64
	// last is the last time the limiter's tokens field was updated
	last time.Time
	// lastEvent is the latest time of a rate-limited event (past or future)
	lastEvent time.Time
}
```

```go
// A Reservation holds information about events that are permitted by a Limiter to happen after a delay.
// A Reservation may be canceled, which may enable the Limiter to permit additional events.
type Reservation struct {
    // ok 是否 limiter 可以提供请求所需的tokens数目
	ok        bool
	lim       *Limiter
	tokens    int
    // timeToAct reserved action 预定的动作发生的时间
	timeToAct time.Time
	// This is the Limit at reservation time, it can change later.
	limit Limit
}
```

```go
func (lim *Limiter) reserveN(now time.Time, n int, maxFutureReserve time.Duration) Reservation {
	lim.mu.Lock()
	defer lim.mu.Unlock()

	if lim.limit == Inf {
		return Reservation{
			ok:        true,
			lim:       lim,
			tokens:    n,
			timeToAct: now,
		}
	} else if lim.limit == 0 {
		var ok bool
		if lim.burst >= n {
			ok = true
			lim.burst -= n
		}
		return Reservation{
			ok:        ok,
			lim:       lim,
			tokens:    lim.burst,
			timeToAct: now,
		}
	}

	now, last, tokens := lim.advance(now)

	// Calculate the remaining number of tokens resulting from the request.
	tokens -= float64(n)

	// Calculate the wait duration
	var waitDuration time.Duration
	if tokens < 0 {
		waitDuration = lim.limit.durationFromTokens(-tokens)
	}

	// Decide result
	ok := n <= lim.burst && waitDuration <= maxFutureReserve

	// Prepare reservation
	r := Reservation{
		ok:    ok,
		lim:   lim,
		limit: lim.limit,
	}
	if ok {
		r.tokens = n
		r.timeToAct = now.Add(waitDuration)
	}

	// Update state
	if ok {
		lim.last = now
		lim.tokens = tokens
		lim.lastEvent = r.timeToAct
	} else {
		lim.last = last
	}

	return r
}
```

```go

```