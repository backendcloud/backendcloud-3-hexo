---
title: 初识Rust
readmore: false
date: 2022-07-12 21:01:35
categories: Fuchsia
tags:
- Rust
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

# Rust - 面向未来

虽然Rust工作上不一定用到，目前很难靠这个吃饭。但因为下面几个原因，有必要了解下Rust：
* 2016 年开始，截止到 2021年，Rust 连续五年成为 StackOverflow 语言榜上最受欢迎的语言。
* 非常新的语言，没有历史包袱，融入了很多现代编程的思想，非常值得借鉴。
* 从语言的生命周期说，Rust处于快速上升期，换成大白话就是Rust有更好的未来。

现在的Rust生态的体量太小，和Java，Go的生态比还不值一提。但在云原生，web框架，中间件以及应用领域也已经有了些明星项目。比如：

* https://github.com/kube-rs/kube-rs 
* https://github.com/bottlerocket-os/bottlerocket
* https://github.com/containers/youki
* https://github.com/firecracker-microvm/firecracker
* https://github.com/nushell/nushell
* https://github.com/hyperium/tonic
* https://github.com/iron/iron
* https://github.com/swc-project/swc
* https://github.com/alacritty/alacritty
* https://github.com/EmbarkStudios/rust-gpu

Rust目前在嵌入式，机器人，云原生几个重点领域有广阔发展前景。操作系统和操作系统相关也有很多项目：
* https://gitlab.redox-os.org/redox-os/redox
* https://github.com/rcore-os/rCore   https://rcore-os.github.io/rCore-Tutorial-Book-v3/
* https://github.com/Ko-oK-OS/xv6-rust
* https://github.com/rustsbi/rustsbi
* https://github.com/rcore-os/zCore
* https://github.com/mit-pdos/biscuit
* https://github.com/tock/tock



# 特别的语法

> 仅从语言的外观找出些特性。本篇并非深入研究Rust。

## 没有Null
Rust没有其他语言的null，因为当尝试使用非Null值那样使用Null值，就会引起错误。这是个Billion dollar mistake。

虽然Rust中没有Null这个东西，但Rust中有Null这个概念，Rust提供拥有Null这个概念：`Option<T>`。

## 覆盖

如下面的代码第二个guess是个全新的变量，只是和之前的guess变量同名，若不加let是用的第一个guess。用了let第二个变量将第一个覆盖了。

```rust
let mut guess = String::new();
io::stdin().read_line(&mut guess).expect("无法读取行");
let guess:u32 = match guess.trim().parse(){
    Ok(num) => num,
    Err(_) => continue,
}
```

## 可变和不可变的变量
没有mut修饰的变量是不可变，有mut修饰的是可变。

## println!
println!不是函数，而是macro宏。使用!来区分它们与普通方法调用。

## 对多个可变引用的限制
Rust语言在特定的作用域内，只能有一个可变的引用。可以用于在编译时防止数据竞争。例如：

```rust
fn main() {
    let mut s = String::from("hello");
    let s1 = &mut s;
    let s2 = &mut s;
    println!("{}, {}",s1, s2)
}
```
> 上面的代码在编译时候就会报错：Cannot borrow `s` as mutable more than once at a time

## 不存在悬空引用
其他语言会发生：一个指针引用了内存中的某个地址，而这块内存可能已经释放并另作他用了。在Rust里，编译器可保证不出现此类情况。例如下面的代码s出了函数作用域会被销毁，但是返回了一个对被销毁对象的引用，编译不会通过，提示缺少生命周期说明符：

```rust
fn dangle() -> &String {
    let s = String::from("hello");
    return &s;
}
```
> 上面的代码在编译时候就会报错：Missing lifetime specifier

## 函数 和 方法 和 关联函数

### 函数

```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    length: u32,
}

fn main() {
    let rect = Rectangle {
        width: 30,
        length: 50,
    };
    println!("{}", area(&rect));
    println!("{:#?}", rect);
}

fn area(rect: &Rectangle) -> u32 {
    rect.width * rect.length
}
```

### struct方法（Rust没有类的概念，可以用struct实现类的功能，这点和Go很像）（用struct实例化后的名称+点调用）
```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    length: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.length
    }
}

fn main() {
    let rect = Rectangle {
        width: 30,
        length: 50,
    };
    println!("{}", rect.area());
    println!("{:#?}", rect);
}
```

### 关联函数（用struct名称+冒号冒号调用）
```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    length: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.length
    }

    fn square(size: u32) -> Rectangle {
        Rectangle {
            width: size,
            length: size,
        }
    }
}

fn main() {
    let s = Rectangle::square(20);
    println!("{:#?}", s);
    let rect = Rectangle {
        width: 30,
        length: 50,
    };
    println!("{}", rect.area());
    println!("{:#?}", rect);
}
```

## 枚举很强大，相对于其他语言的枚举
* `Option<T>`
* 枚举可以和struct一样实现其他语言中`类`的功能
* 可以在枚举类型的变体中嵌入任意类型的数据（如数值，字符串，struct，另外一种枚举类型）

## 不能在同一作用域内同时拥有可变和不可变引用。

```rust
fn main() {
    let mut v = vec![1,2,3,4,5];
    let first = &v[0];
    v.push(6);
    println!("The first element is {}", first);
}
```
编译报错：
```bash
error[E0502]: cannot borrow `v` as mutable because it is also borrowed as immutable
 --> src\main.rs:4:5
  |
3 |     let first = &v[0];
  |                  - immutable borrow occurs here
4 |     v.push(6);
  |     ^^^^^^^^^ mutable borrow occurs here
5 |     println!("The first element is {}", first);
  |                                         ----- immutable borrow later used here

```
> vec这种数据类型是放在heap上的，在内存中的摆放是连续的。所以在往vec添加一个元素时，在内存中就可能没有这么大的连续内存块了，Rust这时就把内存重新分配下，再找个足够大的内存来存放这个添加了元素之后的vec，这样原来的内存会被释放和重新分配，而上面代码的first仍然指向原来的地址，这样程序就出问题了。Rust的借用规则在编译时就可以防止这种情况发生。

## HashMap
```rust
use std::collections::HashMap;

fn main() {
    let text = "hello world wonderfull world";
    let mut map = HashMap::new();
    for word in text.split_whitespace() {
        let count = map.entry(word).or_insert(0);
        *count += 1;
    }
    print!("{:#?}", map);
}
```

## 可恢复错误处理
```rust
use std::fs::File;
use std::io::ErrorKind;

fn main() {
    let f = File::open("hello.txt").unwrap_or_else(|error| {
        if error.kind() == ErrorKind::NotFound {
            File::create("hello.txt").unwrap_or_else(|error| {
                panic!("Error creating file: {:?}", error);
            })
        } else {
            panic!("Error opening file: {:?}", error);
        }
    });
}
```

## 错误传播
除了可以在函数中处理错误外，还可以将错误返回给函数的调用者，让调用者决定如何进一步处理错误。

```rust
use std::fs::File;
use std::io;
use std::io::Read;

fn read_username_from_file() -> Result<String, io::Error> {
    let mut s = String::new();
    File::open("hello.txt")?.read_to_string(&mut s)?;
    Ok(s)
}

fn main() {
    let result = read_username_from_file();
}
```

## 泛型
```rust
enum Option<T> {
    Some(T),
    None,
}

enum Result<T, E> {
    Ok(T),
    Err(E),
}

fn main() {}
```

再如下面的代码中x1方法只有在`Point<i32>`中存在x1方法

```rust
struct Point<T> {
    x: T,
    y: T,
}

impl<T> Point<T> {
    fn x(&self) -> &T {
        &self.x
    }
}

impl Point<i32> {
    fn x1(&self) -> &i32 {
        &self.x
    }
}

fn main() {}
```

# 所有权

```rust
fn main(){    
    let s = String::from("Hello World");    
    take_ownership(s);    
    let x=5;    
    makes_copy(x);    
    println!("x:",x);
}

fn take_ownership(some_string:String)
{
    println!("",some_string);
}
fn makes_copy(some_number:i32)
{
    println!(""，some_number);
}
```
经过这一行`take_ownership(s);`后变量s不能被使用，`makes_copy(x);`后变量x依然可以被使用。

这是rust特有的所有权，和内存管理规则决定的：
* 一个变量赋值给另一个变量，会发生移动。
* 存在heap的数据的变量离开作用域，它的值会被drop函数清理，除非数据的所有权移动到另一个变量上。
* 把引用作为函数参数这个行为叫做借用，用符号&表示引用，引用不会取得所有权。
> stack访问速度快，heap访问速度慢。一般标量是放在stack中的，String变量的内容放在heap上，其地址和字符个数这些存放在stack上。

# 学习Rust语言的感受

* 只要熟练掌握了任何一门编程语言后，学任何一门新的编程语言都可以在一天内学会，但是代码片段和常用库需要数周甚至数月的频繁练习。
* 编写 Rust 需要非常了解计算机处理器和内存模型背后的基础知识。
* 虽然Rust学习曲线略陡，且很多项目中用不到，但任何人都可以学习，学习它绝不是浪费时间，因为无论您编写什么语言代码，了解内存和并发的工作方式都会使您受益。
* 与任何语言一样，有些高级概念需要更多的耐心和练习才能掌握，但您很少经常需要这些概念。只需了解这些是什么，以便在您可能需要它们的极少数情况下，您知道该去哪里查询。