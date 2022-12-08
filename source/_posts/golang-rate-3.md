---
title: Golang 限流器（3） - uber 开源限流器
readmore: false
date: 2022-12-08 12:55:52
categories: 云原生
tags:
- client-go
---

> https://github.com/uber-go/ratelimit

uber的限流器也只有短短的不到200行。直接上代码：

```go
package main

import (
	"fmt"
	"time"

	"go.uber.org/ratelimit"
)

func main() {
	rl := ratelimit.New(10) // per second

	prev := time.Now()
	for i := 0; i < 10; i++ {
		now := rl.Take()
		fmt.Println(i, now.Sub(prev))
		prev = now
	}
}
```

```bash
:\go\go1.19 #gosetup
GOPATH=C:\Users\hanwei\go #gosetup
C:\go\go1.19\bin\go.exe build -o C:\Users\hanwei\AppData\Local\Temp\GoLand\___1go_build_lab.exe lab #gosetup
C:\Users\hanwei\AppData\Local\Temp\GoLand\___1go_build_lab.exe
0 0s
1 100ms
2 100ms
3 100ms
4 100ms
5 100ms
6 100ms
7 100ms
8 100ms
9 100ms

Process finished with the exit code 0
```

main方法中调用了take方法，该方法囊括了整个uber限流器包的主要代码和主要几乎全部功能：

```go
func (t *atomicLimiter) Take() time.Time {
	var (
		newState state
		taken    bool
		interval time.Duration
	)
	for !taken {
		now := t.clock.Now()

		previousStatePointer := atomic.LoadPointer(&t.state)
		oldState := (*state)(previousStatePointer)

		newState = state{
			last:     now,
			sleepFor: oldState.sleepFor,
		}

		// If this is our first request, then we allow it.
		if oldState.last.IsZero() {
			taken = atomic.CompareAndSwapPointer(&t.state, previousStatePointer, unsafe.Pointer(&newState))
			continue
		}

		// sleepFor calculates how much time we should sleep based on
		// the perRequest budget and how long the last request took.
		// Since the request may take longer than the budget, this number
		// can get negative, and is summed across requests.
		newState.sleepFor += t.perRequest - now.Sub(oldState.last)
		// We shouldn't allow sleepFor to get too negative, since it would mean that
		// a service that slowed down a lot for a short period of time would get
		// a much higher RPS following that.
		if newState.sleepFor < t.maxSlack {
			newState.sleepFor = t.maxSlack
		}
		if newState.sleepFor > 0 {
			newState.last = newState.last.Add(newState.sleepFor)
			interval, newState.sleepFor = newState.sleepFor, 0
		}
		taken = atomic.CompareAndSwapPointer(&t.state, previousStatePointer, unsafe.Pointer(&newState))
	}
	t.clock.Sleep(interval)
	return newState.last
}
```

直接看稍稍难理解点，因为这里用到了原子操作，我们平时见到的防止多线程竞争的主要是通过互斥锁mutex实现的。

原子操作和互斥锁的目的都是一样的。互斥锁是一种数据结构，能够执行互斥操作。原子操作是相互排斥的单个操作，这意味着没有其他线程可以干扰它。就性能而言，原子操作的性能要由优于互斥锁。

原子操作的性能之所以更高。简单说，原子操作 是在 cpu 指令级别上实现的锁。所以，除了必不可少的内存栅栏带来流水线效率损失外，几乎可以认为没什么额外的开销了。

而 互斥锁mutex，光是在内核里睡眠/唤醒一下，就至少是微秒级的时间开销，更别说各种额外的调用、封装、判断了。

> 内存屏障（Memory barrier），也称内存栅栏，内存栅障，屏障指令等，是一类同步屏障指令，它使得CPU 或编译器在对内存进行操作的时候, 严格按照一定的顺序来执行, 也就是说在内存屏障之前的指令和之后的指令不会由于系统优化等原因而导致乱序。

uber的限流器是用的原子操作，但代码中也保留了互斥锁限流器方法从而对接口方法的实现，只是该main方法这样写用的是默认的原子操作，没有实际用到互斥锁的限流器的代码。

互斥操作的代码实现要好理解些，只需要理解了下面的互斥锁实现的代码，就理解了上面的原子锁代码，因为是几乎是逐行一一对应的。

```go
func (t *mutexLimiter) Take() time.Time {
	t.Lock()
	defer t.Unlock()

	now := t.clock.Now()

	// If this is our first request, then we allow it.
	if t.last.IsZero() {
		t.last = now
		return t.last
	}

	// sleepFor calculates how much time we should sleep based on
	// the perRequest budget and how long the last request took.
	// Since the request may take longer than the budget, this number
	// can get negative, and is summed across requests.
	t.sleepFor += t.perRequest - now.Sub(t.last)

	// We shouldn't allow sleepFor to get too negative, since it would mean that
	// a service that slowed down a lot for a short period of time would get
	// a much higher RPS following that.
	if t.sleepFor < t.maxSlack {
		t.sleepFor = t.maxSlack
	}

	// If sleepFor is positive, then we should sleep now.
	if t.sleepFor > 0 {
		t.clock.Sleep(t.sleepFor)
		t.last = now.Add(t.sleepFor)
		t.sleepFor = 0
	} else {
		t.last = now
	}

	return t.last
}
```

在理解上面的代码之前，要理解下面两个概念，基本实现 和 最大松弛量。

![](/images/golang-rate-3/1.png)

如上图所示，基本实现就是在配置的速率之间（上面的main方法每秒10个process，就是每个process间隔100ms），和前一个请求相隔大于这个值则立刻执行，相隔还不到100ms的设定的间隔时间，则需要等待一段时间后，间隔时间符合要求了才能执行。

下图是没有松弛量有松弛量slack的对比，没有松弛量则和上图的基本实现一样，有松弛量，则会通过消费之前的请求累计的多余出来的时间，实现更长时间（比如下图的2个间隔范围的满足速率要求）。

![](/images/golang-rate-3/2.png)

形象点说，通过劳逸结合，有松弛量的限流器可以更好的满足突发的业务需求，实现负载平稳，当然也不是越大越好，太大了也会导致应付不了短时间的大量突发业务。默认值是10倍的t.perRequest

将上面的main方法每秒10个的速率改成100，就能看出松弛量的效果了：

```go
package main

import (
	"fmt"
	"time"

	"go.uber.org/ratelimit"
)

func main() {
	rl := ratelimit.New(100) // per second

	prev := time.Now()
	for i := 0; i < 10; i++ {
		now := rl.Take()
		fmt.Println(i, now.Sub(prev))
		prev = now
	}
}
```

```bash
GOROOT=C:\go\go1.19 #gosetup
GOPATH=C:\Users\hanwei\go #gosetup
C:\go\go1.19\bin\go.exe build -o C:\Users\hanwei\AppData\Local\Temp\GoLand\___1go_build_lab.exe lab #gosetup
C:\Users\hanwei\AppData\Local\Temp\GoLand\___1go_build_lab.exe
0 0s
1 10ms
2 10ms
3 10ms
4 12.3344ms
5 7.6656ms
6 10ms
7 13.2554ms
8 6.7446ms
9 10ms

Process finished with the exit code 0
```

这时候再看uber的开源限流器的源码就非常好理解了，只需要理解几行的代码。
1. if t.last.IsZero() 如果是首次请求，直接执行。（参考main方法运行的结果）
2. t.sleepFor += t.perRequest - now.Sub(t.last) 这行是关键。是否sleep是看累加的结果，为正则意味着余额不足需要sleep，为负意味着有积累的余额，可以用来给下一次的请求透支。当然因为有最大松弛量限制，余额不能超过t.maxSlack（因为是都是负数，所以小于号表示大于）

全部代码已完。

可见uber的限流器既能通过sleep实现限流需求，又能通过最大松弛量的配置，更好的应对突发请求，就是更好的应对波谷波峰，可以实现一定程度的平稳波谷波峰。实现资源的最大效率利用。