---
title: Golang标准库 container/ring
readmore: false
date: 2022-12-12 12:15:39
categories: 云原生
tags:
- Golang
---

> https://github.com/golang/go/tree/master/src/container/ring

ring 和 之前介绍的双向链表 一个最大的不同是ring是一个环，没有开始位置和结束位置。所以代码实现上双向链表有区别：
1. 因为没有开始和结束位置，就没有在开始和结束之间插入哨兵位置
2. 没有维护列表级的信息，只有一个元素的结构体。
3. 所以长度信息没有保存，获取列表长度需要每次算出来。
4. 对元素的引用就相当于对整个列表的引用。

ring的全部代码不足150行，直接上全部代码。

```go
// Copyright 2009 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package ring implements operations on circular lists.
package ring

// A Ring is an element of a circular list, or ring.
// Rings do not have a beginning or end; a pointer to any ring element
// serves as reference to the entire ring. Empty rings are represented
// as nil Ring pointers. The zero value for a Ring is a one-element
// ring with a nil Value.
type Ring struct {
	next, prev *Ring
	Value      any // for use by client; untouched by this library
}

func (r *Ring) init() *Ring {
	r.next = r
	r.prev = r
	return r
}

// Next returns the next ring element. r must not be empty.
func (r *Ring) Next() *Ring {
	if r.next == nil {
		return r.init()
	}
	return r.next
}

// Prev returns the previous ring element. r must not be empty.
func (r *Ring) Prev() *Ring {
	if r.next == nil {
		return r.init()
	}
	return r.prev
}

// Move moves n % r.Len() elements backward (n < 0) or forward (n >= 0)
// in the ring and returns that ring element. r must not be empty.
func (r *Ring) Move(n int) *Ring {
	if r.next == nil {
		return r.init()
	}
	switch {
	case n < 0:
		for ; n < 0; n++ {
			r = r.prev
		}
	case n > 0:
		for ; n > 0; n-- {
			r = r.next
		}
	}
	return r
}

// New creates a ring of n elements.
func New(n int) *Ring {
	if n <= 0 {
		return nil
	}
	r := new(Ring)
	p := r
	for i := 1; i < n; i++ {
		p.next = &Ring{prev: p}
		p = p.next
	}
	p.next = r
	r.prev = p
	return r
}

// Link connects ring r with ring s such that r.Next()
// becomes s and returns the original value for r.Next().
// r must not be empty.
//
// If r and s point to the same ring, linking
// them removes the elements between r and s from the ring.
// The removed elements form a subring and the result is a
// reference to that subring (if no elements were removed,
// the result is still the original value for r.Next(),
// and not nil).
//
// If r and s point to different rings, linking
// them creates a single ring with the elements of s inserted
// after r. The result points to the element following the
// last element of s after insertion.
func (r *Ring) Link(s *Ring) *Ring {
	n := r.Next()
	if s != nil {
		p := s.Prev()
		// Note: Cannot use multiple assignment because
		// evaluation order of LHS is not specified.
		r.next = s
		s.prev = r
		n.prev = p
		p.next = n
	}
	return n
}

// Unlink removes n % r.Len() elements from the ring r, starting
// at r.Next(). If n % r.Len() == 0, r remains unchanged.
// The result is the removed subring. r must not be empty.
func (r *Ring) Unlink(n int) *Ring {
	if n <= 0 {
		return nil
	}
	return r.Link(r.Move(n + 1))
}

// Len computes the number of elements in ring r.
// It executes in time proportional to the number of elements.
func (r *Ring) Len() int {
	n := 0
	if r != nil {
		n = 1
		for p := r.Next(); p != r; p = p.next {
			n++
		}
	}
	return n
}

// Do calls function f on each element of the ring, in forward order.
// The behavior of Do is undefined if f changes *r.
func (r *Ring) Do(f func(any)) {
	if r != nil {
		f(r.Value)
		for p := r.Next(); p != r; p = p.next {
			f(p.Value)
		}
	}
}
```

* Next, Prev, Move 三个方法分别是返回下移1位，上移1位，移动N位的元素。
* Len方法遍历ring，逐个++，算出ring的长度。（无法像双向链表一样直接获取）
* 关键和难点是Link方法。分同一个ring和不同ring两种情况，下面单独分析。
* 因为Link方法既可以合并两个ring（两个ring不是同一个），也可以截切ring（两个ring是同一个），Link和Mova的方法结合可以实现Unlink操作。
* 在调用Ring.Do时，会依次将每个节点的Value当做参数调用这个函数，实际上这是策略方法的应用，通过传递不同的函数，可以在同一个ring上实现多种不同的操作。下面展示一个简单的遍历打印程序。

不同ring的Link方法：
![](/images/golang-std-ring/1.png)

同一个ring的Link方法：
![](/images/golang-std-ring/2.png)

```go
package main

import (
    "container/ring"
    "fmt"
)

func main() {
    r := ring.New(10)

    for i := 0; i < 10; i++ {
        r.Value = i
        r = r.Next()
    }

    sum := SumInt{}
    r.Do(func(i interface{}) {
        fmt.Println(i)
    })
}
```

除了简单的无状态程序外，也可以通过结构体保存状态，例如下面是一个对ring上值求和的程序。

```go
package main

import (
    "container/ring"
    "fmt"
)

type SumInt struct {
    Value int
}

func (s *SumInt) add(i interface{}) {
    s.Value += i.(int)
}

func main() {
    r := ring.New(10)

    for i := 0; i < 10; i++ {
        r.Value = i
        r = r.Next()
    }

    sum := SumInt{}
    r.Do(sum.add)
    fmt.Println(sum.Value)
}
```


