---
title: Golang 限流器（2） - beefsack个人的开源 限流器
readmore: true
date: 2022-12-07 13:14:44
categories: 云原生
tags:
- client-go
---

> https://github.com/beefsack/go-rate

```go
package rate

import (
	"container/list"
	"sync"
	"time"
)

// A RateLimiter limits the rate at which an action can be performed.  It
// applies neither smoothing (like one could achieve in a token bucket system)
// nor does it offer any conception of warmup, wherein the rate of actions
// granted are steadily increased until a steady throughput equilibrium is
// reached.
type RateLimiter struct {
	limit    int
	interval time.Duration
	mtx      sync.Mutex
	times    list.List
}

// New creates a new rate limiter for the limit and interval.
func New(limit int, interval time.Duration) *RateLimiter {
	lim := &RateLimiter{
		limit:    limit,
		interval: interval,
	}
	lim.times.Init()
	return lim
}

// Wait blocks if the rate limit has been reached.  Wait offers no guarantees
// of fairness for multiple actors if the allowed rate has been temporarily
// exhausted.
func (r *RateLimiter) Wait() {
	for {
		ok, remaining := r.Try()
		if ok {
			break
		}
		time.Sleep(remaining)
	}
}

// Try returns true if under the rate limit, or false if over and the
// remaining time before the rate limit expires.
func (r *RateLimiter) Try() (ok bool, remaining time.Duration) {
	r.mtx.Lock()
	defer r.mtx.Unlock()
	now := time.Now()
	if l := r.times.Len(); l < r.limit {
		r.times.PushBack(now)
		return true, 0
	}
	frnt := r.times.Front()
	if diff := now.Sub(frnt.Value.(time.Time)); diff < r.interval {
		return false, r.interval - diff
	}
	frnt.Value = now
	r.times.MoveToBack(frnt)
	return true, 0
}
```

加注释，换行，不到100行代码的限流包。非常好理解，没有用令牌桶，所以代码非常简单，行数很少。

该限流包实现了一个功能：限流，限流的限制条件是 interval time.Duration 时间内不超过 limit int 个数量 的执行。

用了个双向链表，并用 if l := r.times.Len(); l < r.limit 保证 双向链表的数量不超过 RateLimiter struct 的 lim 定的数量。并按时间顺序排列。

检查是否被限流用了try方法检查，若链表没满，说明还没超lim定的数量，可以执行，return true, 0 。若链表满了，获取双向链表的第一个元素（第一个元素存放时间最长），若超过了 interval time.Duration 说明也可以继续执行，return true, 0 ，否则返回 flase 和 需要等待的时间。


使用example：

```go
package main

import (
	"fmt"
	"time"

	"github.com/beefsack/go-rate"
)

func main() {
	rl := rate.New(3, time.Second) // 3 times per second
	begin := time.Now()
	for i := 1; i <= 10; i++ {
		rl.Wait()
		fmt.Printf("%d started at %s\n", i, time.Now().Sub(begin))
	}
	// Output:
	// 1 started at 12.584us
	// 2 started at 40.13us
	// 3 started at 44.92us
	// 4 started at 1.000125362s
	// 5 started at 1.000143066s
	// 6 started at 1.000144707s
	// 7 started at 2.000224641s
	// 8 started at 2.000240751s
	// 9 started at 2.00024244s
	// 10 started at 3.000314332s
}
```