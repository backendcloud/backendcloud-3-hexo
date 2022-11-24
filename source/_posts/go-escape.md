---
title: Golang的逃逸分析和C以及Rust的此类问题的处理对比
readmore: false
date: 2022-11-23 12:43:35
categories: 云原生
tags:
---

# Golang的逃逸分析

首先抛出几个常见的问题：
1. 用golang编程时是选用传指针还是传值？既然传指针效率高，那是不是只要不涉及复制需求的情况下每次都采用指针传递？
2. Go 语言的局部变量分配在栈上还是堆上？

首先回答第2个问题，分配在栈上还是堆上是由编译器决定的，编译器会做逃逸分析(escape analysis)，当发现变量的作用域没有超出函数范围，就可以在栈上，反之则必须分配在堆上。

```go
func foo() *int {
	v := 11
	return &v
}

func main() {
	m := foo()
	println(*m) // 11
}
```

上面foo() 函数若不是返回的指针，而是变量v的值，编译器会将其放在栈上。编译器发现返回的是指针，且在main方法用用到了该指针，即编译器发现 v 的引用脱离了 foo 的作用域，就会将其分配在堆上。因此，main 函数中仍能够正常访问该值。

编译器决定内存分配位置的方式（分配在栈上，还是堆上），就称之为逃逸分析(escape analysis)。逃逸分析由编译器完成，作用于编译阶段。上面的逃逸分析就是常见的指针逃逸，除了上面的情况会分配到堆上，还有哪些常见情况会被分配到堆上呢。比如动态类型逃逸，栈空间不足逃逸，闭包逃逸。

在 Go 语言中，空接口即 interface{} 可以表示任意的类型，如果函数参数为 interface{}，编译期间很难确定其参数的具体类型，也会发生逃逸，成为动态类型逃逸。比如fmt报下的println函数：

```go
func Println(a ...interface{}) (n int, err error) {
	return Fprintln(os.Stdout, a...)
}
```

因为 fmt.Println() 的参数类型定义为 interface{}，因此使用fmt.Println()函数也发生了逃逸。

操作系统的栈空间通常限制在8 MB。

```go
func generate8191() {
	nums := make([]int, 8191) // < 64KB
	for i := 0; i < 8191; i++ {
		nums[i] = rand.Int()
	}
}

func generate8192() {
	nums := make([]int, 8192) // = 64KB
	for i := 0; i < 8192; i++ {
		nums[i] = rand.Int()
	}
}

func generate(n int) {
	nums := make([]int, n) // 不确定大小
	for i := 0; i < n; i++ {
		nums[i] = rand.Int()
	}
}

func main() {
	generate8191()
    generate8192()
    generate(1)
}
```

generate8191() 创建了大小为 8191 的 int 型切片，恰好小于 64 KB(64位机器上，int 占 8 字节)，不包含切片内部字段占用的内存大小。generate8191()函数调用的时候不会发生逃逸，会分配到栈上。

generate8192() 创建了大小为 8192 的 int 型切片，恰好占用 64 KB。generate8192() 函数调用的时候会发生逃逸，逃逸到堆上。

generate(n)，切片大小不确定，调用时传入。generate(n) 函数调用的时候会发生逃逸，逃逸到堆上。

总结下，当切片占用内存超过一定大小，或无法确定当前切片长度时，对象占用内存将在堆上分配。

```go
func Increase() func() int {
	n := 0
	return func() int {
		n++
		return n
	}
}

func main() {
	in := Increase()
	fmt.Println(in()) // 1
	fmt.Println(in()) // 2
}
```

> 闭包可以在一个内层函数中访问到其外层函数的作用域。

Increase() 返回值是一个闭包函数，该闭包函数访问了外部变量 n，那变量 n 将会一直存在，直到 in 被销毁。很显然，变量 n 占用的内存不能随着函数 Increase() 的退出而回收，因此将会逃逸到堆上。

了解了逃逸分析，栈上的效率要远高于堆上的效率。就可以回答第一个问题了。一般情况下指针传递效率是高于值传递。因为传值会拷贝整个对象，而传指针只会拷贝指针地址，指向的对象是同一个。传指针可以减少值的拷贝。

但是在对象频繁创建和删除的特殊场景下，会导致内存分配逃逸到堆中，增加垃圾回收(GC)的负担，传递指针导致的 GC 开销可能会严重影响性能。

总结下，在一般情况下，对于需要修改原对象值，或占用内存比较大的结构体，选择传指针。对于只读的占用内存较小的结构体，直接传值能够获得更好的性能。

# c和Rust以及golang 对 dangling reference 处理的对比

篇外话：c/rust/go/java这四门语言是云原生绕不开的四门语言。大量的业务层的应用，监控，中间件，后台管理后端是java开发的。云原生基础架构的中间层是golang开发的，云原生基础架构的底层，如运行时，等等是rust开发，且越来越多的偏向底层组件，原来golang或c开发的正在被rust重写和代替。

总结下，云原生领域中，c和Rust负责底层部分，Go负责中间部分，共同服务上层各种语言的应用（java/go/ts/js）。且目前的趋势是对性能要求高的底层和中间部分，比如操作系统，运行时，vmm等等原来c/go开发的正在被rust重写。rust是具备接近c的性能开销，但远高于c的开发效率，且天生适合review的现代语言。

回到主题来：

c/rust/go 对dangling reference 处理的对比，要从三门语言怎么对内存作管理的说起，c是手动管理内存，这样c可以写出高性能的程序，但是经常会出现内存泄漏的问题，java跨时代的引入了gc垃圾回收机制，go也有gc机制，但是光gc，要占7%~8%的性能损耗。本篇上面讲的golang的逃逸分析，内存逃逸到堆中，堆上的内存就会交由gc负责内存管理，而堆上的内存开销要远远大于在栈上的内存开销。Rust的内存管理是静态的，是不依赖逃逸分析的。

在Rust之前主要分为两个阵营：C/C++系和非C/C++。再抽象一点就是：手动管理内存和自动回收内存。Rust另辟蹊径，采用了第三种实现，交由通过严格的语法限制和编译器实现：具体说就是保障一块内存只被一个变量引用，变量死的同时执行下析构函数把内存也干掉。

什么是dangling reference。就是一个指针，它引用的内存已经被释放，但是，指向该内存的指针会保留在程序中。比如下面的c语言实现：

```c
int *func(void)
{
    int num = 1234;
    /* ... */
    return &num;
}
```

Go就不会Dangling pointer，因为专门设计了内存逃逸（本篇上半部分讲到）。

C语言的手动管理内存方式，除了Dangling pointer问题，还有头疼的内存泄露问题。

Rust 如何处理dangling reference。一句话简单说，在 Rust 中，编译器保证引用永远不会是dangling reference。

比如下面一段程序，在Rust 中创建一个dangling reference，编译环节是通过不了的。

```rust
fn main() {
    let reference_to_nothing = create_dangling_reference();
}

fn create_dangling_reference() -> &String {
    let greeting_msg = String::from("Greetings from the future");

    &greeting_msg
}
```

编译器报错：

```bash
error[E0106]: missing lifetime specifier
 --> src\main.rs:5:35
  |
5 | fn create_dangling_reference() -> &String {
  |                                   ^ expected named lifetime parameter
  |
  = help: this function's return type contains a borrowed value, but there is no value for it to be borrowed from
help: consider using the `'static` lifetime
  |
5 | fn create_dangling_reference() -> &'static String {
  |                                    +++++++
```

为了解决这个问题，我们应该返回字符串。见下文：

```rust
fn main() {
    let msg = create_dangling_reference();
}

fn create_dangling_reference() -> String {
    let greeting_msg = String::from("Greetings from the future");

    greeting_msg
}
```

在这种情况下，所有权被正确转移，没有任何东西被解除分配。

总结：作为开发人员，我们不需要担心 Rust 中的dangling reference。编译器负责避免dangling reference。

Rust除了通过严格的语法和编译器的方式实现了golang中gc逃逸分析机制才能避免的dangling reference问题。实现了golang中gc对内存的管理，又没有c语言的内存问题；通过对内存的控制实现了c语言的高性能，又没有golang中gc的性能消耗问题。再举个例子：

```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1;
    println!("{}", s1)
}
```

上面这段rust程序会报错：

```bash
error[E0382]: borrow of moved value: `s1`
 --> src\main.rs:4:20
  |
2 |     let s1 = String::from("hello");
  |         -- move occurs because `s1` has type `String`, which does not implement the `Copy` trait
3 |     let s2 = s1;
  |              -- value moved here
4 |     println!("{}", s1)
  |                    ^^ value borrowed here after move
  |
  = note: this error originates in the macro `$crate::format_args_nl` which comes from the expansion of the macro `println` (in Nightly builds, run with -Z macro-backtrace for more info)
```

String和大多数语言一样是存在堆上的，String的底层相当于一个结构体（存放在栈上，存放在栈上的该结构体只有指针，长度，容量这几个属性），ptr是指向堆内存的首地址，内存结构如下图：

```rust
    let s2 = s1;
```

一旦执行了上面这一句，因为一块内存只能有一个所属者，所以这行代码就把上图右边内存所属从s1移动到了s2身上（MOVE），之后s1就相当于C语言中的dangling reference了，在编译的时候就会报错。

> 若将上面程序的String::from换成int，就不会报错。是因为所有固定size（编译时能确定多少字节）的变量（可能除数组）都分配在栈上，不会如String::from一样分配在堆上。要想上面的程序不报错，可以将String::from复制一份（COPY）。如下：

```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1.clone();
    println!("{}， {}", s1, s2)
}
```

举一反三，下面的程序是不会报错的：

```rust
fn main() {
    let s1: String = String::from("hello");
    let s2: &String = &s1;
    println!("{}， {}", s1, s2)
}
```

不会报错的原因是 不涉及一块内存只能有一个所属者，并没有发生内存所属从s1移动到了s2身上（MOVE）。s2只是在内存的栈空间另开一各空间用于存放指向s1变量地址的指针。这样s1和s2都能读这块内存了，Rust是允许这种情况的，这种情况叫Borrowing。因为是只读，Rust才允许，不仅两个变量允许，两个以上的只读变量也是允许的。若可写，比如s1和s2都能写，Rust就不允许了。如下：

```rust
fn main() {
    let s1= String::from("hello");
    let s2 = &s1;
    let s3 = &s1;
    println!("{}， {}, {}", s1, s2, s3)
}
```

上面的一段代码是三个只读变量，不会报错。下面的有读有写的就会报错了：

```rust
fn main() {
    let mut s = String::from("hello");
    let r1 = &s;
    let r3 = &mut s; // 挂掉
    println!("{} and {}", r1, r3);
}
```

```bash
error[E0502]: cannot borrow `s` as mutable because it is also borrowed as immutable
 --> src\main.rs:4:14
  |
3 |     let r1 = &s;
  |              -- immutable borrow occurs here
4 |     let r3 = &mut s; // 挂掉
  |              ^^^^^^ mutable borrow occurs here
5 |     println!("{} and {}", r1, r3);
  |                           -- immutable borrow later used here
```