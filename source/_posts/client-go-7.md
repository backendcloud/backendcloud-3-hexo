---
title: WIProcess- client-go 源码分析（7） - Golang 标准库限流器
readmore: true
date: 2022-12-07 12:55:52
categories: 云原生
tags:
- client-go
---

![](/images/client-go-6/2022-12-06-15-28-32.png)

上图可以看出 client-go 用到了 workqueue 队列 来处理 从 DeltaFIFO pop 出来的内容，workqueue 队列用到了限流队列（微服务中常用的技术，防止性能过载，从而导致任务处理失败）。

在分析workqueue前，需要了解下实现限流队列的限流器。限流器有多种实现方式，client-go用了其中一种，client-go用的限流器是 Golang 标准库限流器（Golang 的 timer/rate）。

本篇是关于 Golang 标准库限流器。

令牌桶就是想象有一个固定大小的桶，通过有取有放，实现了限流目的。

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
    // lim 就是上面的结构体 Limiter struct
	lim       *Limiter
	tokens    int
    // timeToAct reserved action 预定的动作发生的时间
	timeToAct time.Time
	// This is the Limit at reservation time, it can change later.
	limit Limit
}
```

reserve 方法的大致流程：
1. if lim.limit == Inf 如果最大时间率是无限大的，那么直接返回 Reservation struct， ok=true，预定执行时间是立刻。相当于没有限流器，限流器功能disable。
2. lim.advance(now) 重新计算桶里的token数目，就是通过计算Limiter结构体的last属性减去现在的时间，算出这段时间流逝中应该往桶里加多少token，加上旧的token数目（Limiter结构体的tokens属性）就是now的token数目
3. tokens -= float64(n) now的token数目减去reserve方法的入参n，就是经过reserve消费后的token数目
4. 更新last时间为将now时间，返回结构体Reservation

```go
func (lim *Limiter) Reserve() *Reservation {
	return lim.ReserveN(time.Now(), 1)
}
func (lim *Limiter) ReserveN(now time.Time, n int) *Reservation {
	r := lim.reserveN(now, n, InfDuration)
	return &r
}
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

// advance calculates and returns an updated state for lim resulting from the passage of time.
// lim is not changed.
// advance requires that lim.mu is held.
func (lim *Limiter) advance(now time.Time) (newNow time.Time, newLast time.Time, newTokens float64) {
	last := lim.last
	if now.Before(last) {
		last = now
	}

	// Calculate the new number of tokens, due to time that passed.
	elapsed := now.Sub(last)
	delta := lim.limit.tokensFromDuration(elapsed)
	tokens := lim.tokens + delta
	if burst := float64(lim.burst); tokens > burst {
		tokens = burst
	}
	return now, last, tokens
}
```

```go

```