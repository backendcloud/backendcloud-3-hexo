---
title: Golang标准库time（1） - 程序员需要相信的关于时间的谎言 时间可以倒流
readmore: true
date: 2022-12-14 18:50:31
categories: 云原生
tags:
- Golang
---


# 问题背景：程序员需要相信的关于时间的谎言 时间可以倒流

> golang社区有关于此问题的讨论 https://github.com/golang/go/issues/12914

因为程序员相信时间不会倒流，就是记录下当前时间timeA，然后程序处理一些事情后，再记录当前时间timeB，程序员认为 timeB - timeA 一定是正数，因为现在的时间永远发生在过去时间之后。按照这种想法写程序有时候程序里就可能埋藏着bug。但实际上是可以为负数的，因为有闰秒的存在。

闰秒是偶尔运用于协调世界时（UTC）的调整，经由增加或减少一秒，以消弥精确的时间（使用原子钟测量）和不精确的观测太阳时 （称为UT1)，之间的差异。这会由于地球自转的不规则和长期项的地球自转减慢而有所不同。UTC标准时间广泛用于国际计时，并在大多数国家用作民用时的参考，它使用精确的原子时，因此，除非根据需要将其重置为UT1，否则将超前运行在观测到的太阳时。闰秒的存在就是为了提供这样的调整。

因为地球的旋转速度会随着气候和地质事件的变化而变化，因此UTC的闰秒间隔不规则且不可预知。每个UTC闰秒的插入，通常由国际地球自转服务（IERS）提前约六个月决定，以确保UTC和UT1读数之间的差值永远不会超过0.9秒。

这种做法已被证明具有破坏性，特别是在二十一世纪，尤其是在依赖精确时间戳或时间关键程序控制的服务中。相关国际标准机构一直在讨论是否继续这种做法。

从1972年到2020年，平均每21个月就插入一次闰秒。然而，间隔是非常不规则的，而且明显在增加：在1999年1月1日至2004年12月31日的六年中没有闰秒，但在1972-1979年的八年中有九个闰秒。

因为地球的自转速度的变化不规则，导致闰秒的间隔不规则。事实上，地球自转在长期上是不可预测的（地球自转速度减慢的主要原因是潮汐摩擦，改变了地球的惯性矩，由于角动量守恒而影响了自转速率。一次大的海啸也会改变地球的自转速率从而改变一天的时间），这也解释了为什么闰秒通常只提前六个月宣布。

由于已经存在两个没有闰秒的时间，国际原子时（TAI）和全球定位系统（GPS）时间。例如，电脑可以使用这些时间，并根据需要转换为UTC或本地民用时间进行输出。2022年11月，在第27届国际计量大会上，投票决定到2035年取消闰秒。

Now方法返回当前的时间，其中用到了runtime中的now()函数，该函数对应的runtime中的time_now方法。而walltime 和 nanotime 是以汇编实现的。汇编中用 vdso call 来获取到当前的时间信息。

```go
func Now() Time {
	sec, nsec, mono := now()
	mono -= startNano
	sec += unixToInternal - minWall
	if uint64(sec)>>33 != 0 {
		return Time{uint64(nsec), sec + minWall, Local}
	}
	return Time{hasMonotonic | uint64(sec)<<nsecShift | uint64(nsec), mono, Local}
}
```

```go
//go:linkname time_now time.now
func time_now() (sec int64, nsec int32, mono int64) {
	sec, nsec = walltime()
	return sec, nsec, nanotime()
}
```

```x86asm
// func walltime() (sec int64, nsec int32)
TEXT runtime·walltime(SB),NOSPLIT,$24-12
	MOVD	RSP, R20	// R20 is unchanged by C code
	MOVD	RSP, R1

	MOVD	g_m(g), R21	// R21 = m

	// Set vdsoPC and vdsoSP for SIGPROF traceback.
	// Save the old values on stack and restore them on exit,
	// so this function is reentrant.
	MOVD	m_vdsoPC(R21), R2
	MOVD	m_vdsoSP(R21), R3
	MOVD	R2, 8(RSP)
	MOVD	R3, 16(RSP)

	MOVD	$ret-8(FP), R2 // caller's SP
	MOVD	LR, m_vdsoPC(R21)
	MOVD	R2, m_vdsoSP(R21)

	MOVD	m_curg(R21), R0
	CMP	g, R0
	BNE	noswitch

	MOVD	m_g0(R21), R3
	MOVD	(g_sched+gobuf_sp)(R3), R1	// Set RSP to g0 stack

noswitch:
	SUB	$16, R1
	BIC	$15, R1	// Align for C code
	MOVD	R1, RSP

	MOVW	$CLOCK_REALTIME, R0
	MOVD	runtime·vdsoClockgettimeSym(SB), R2
	CBZ	R2, fallback

	// Store g on gsignal's stack, so if we receive a signal
	// during VDSO code we can find the g.
	// If we don't have a signal stack, we won't receive signal,
	// so don't bother saving g.
	// When using cgo, we already saved g on TLS, also don't save
	// g here.
	// Also don't save g if we are already on the signal stack.
	// We won't get a nested signal.
	MOVBU	runtime·iscgo(SB), R22
	CBNZ	R22, nosaveg
	MOVD	m_gsignal(R21), R22          // g.m.gsignal
	CBZ	R22, nosaveg
	CMP	g, R22
	BEQ	nosaveg
	MOVD	(g_stack+stack_lo)(R22), R22 // g.m.gsignal.stack.lo
	MOVD	g, (R22)

	BL	(R2)

	MOVD	ZR, (R22)  // clear g slot, R22 is unchanged by C code

	B	finish

nosaveg:
	BL	(R2)
	B	finish

fallback:
	MOVD	$SYS_clock_gettime, R8
	SVC

finish:
	MOVD	0(RSP), R3	// sec
	MOVD	8(RSP), R5	// nsec

	MOVD	R20, RSP	// restore SP
	// Restore vdsoPC, vdsoSP
	// We don't worry about being signaled between the two stores.
	// If we are not in a signal handler, we'll restore vdsoSP to 0,
	// and no one will care about vdsoPC. If we are in a signal handler,
	// we cannot receive another signal.
	MOVD	16(RSP), R1
	MOVD	R1, m_vdsoSP(R21)
	MOVD	8(RSP), R1
	MOVD	R1, m_vdsoPC(R21)

	MOVD	R3, sec+0(FP)
	MOVW	R5, nsec+8(FP)
	RET
```

```go
const (
	hasMonotonic = 1 << 63
	maxWall      = wallToInternal + (1<<33 - 1) // year 2157
	minWall      = wallToInternal               // year 1885
	nsecMask     = 1<<30 - 1
	nsecShift    = 30
)
```

若晚于2157年，Time结构体中的wall和ext的格式是下面这样的：

```go
	if uint64(sec)>>33 != 0 {
		return Time{uint64(nsec), sec + minWall, Local}
	}
```

```go
type Time struct {
	wall uint64
	ext  int64
	loc *Location
}
```

![](/images/golang-time-1/2022-12-14-17-31-41.png)

若早于2157年，Time结构体中的wall和ext的格式是下面这样的：（现在2022年12月就是下面的数据格式，实际上上面的情况永远不可能存在，因为golang不可能存活100多年并且time包不会不发生变化100多年）

```go
	return Time{hasMonotonic | uint64(sec)<<nsecShift | uint64(nsec), mono, Local}
```

![](/images/golang-time-1/2022-12-14-17-31-57.png)

下面的Sub方法返回的是两个时间的间隔。Sub方法的代码可见计算两个时间的间隔是通过ext计算的，不是通过wall计算的，而ext在2157年之前ext是但单调递增的。

> golang在 1.9版本 增加了透明单调递增时间（transparent monotonic time）支持。所以在之前的版本由于wall（墙上的挂钟）增加了闰秒会因为不是单调递增从而引入时间倒流的bug。

```go
func (t Time) Sub(u Time) Duration {
	if t.wall&u.wall&hasMonotonic != 0 {
		te := t.ext
		ue := u.ext
		d := Duration(te - ue)
		if d < 0 && te > ue {
			return maxDuration // t - u is positive out of range
		}
		if d > 0 && te < ue {
			return minDuration // t - u is negative out of range
		}
		return d
	}
	d := Duration(t.sec()-u.sec())*Second + Duration(t.nsec()-u.nsec())
	// Check for overflow or underflow.
	switch {
	case u.Add(d).Equal(t):
		return d // d is correct
	case t.Before(u):
		return minDuration // t - u is negative out of range
	default:
		return maxDuration // t - u is positive out of range
	}
}
```