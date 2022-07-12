---
title: Rust初探
readmore: false
date: 2022-07-12 21:01:35
categories: 未分类
tags:
- Rust
---

> Rust是现代语言，虽然工作上不一定用到，目前很难靠这个吃饭，但其设计思想非常值得学习。另外一个需要学习的重要原因是从语言的生命周期说，Rust处于快速上升期，Java快速下降期，Go稳定期，换成大白话就是Rust有未来。

现在的Rust的体量太小，和Java，Go的生态比还不值一提。但在云原生，web框架，中间件也已经有了些明星项目。比如：

* https://github.com/kube-rs/kube-rs 
* https://github.com/hyperium/tonic
* https://github.com/iron/iron

Rust目前在嵌入式，机器人，云原生几个重点领域已经有了不少的应用。还有几个Rust写的著名的操作系统。
* https://github.com/redox-os/redox
* https://github.com/rcore-os/rCore   https://rcore-os.github.io/rCore-Tutorial-Book-v3/


> 本文作者对Rust也就是只接触1小时，仅从语言的外观找出些特性。本篇并非深入研究Rust。

# 特别的语法

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
* 一个变量赋值给另一个变量，会发生移动
* 存在heap的数据的变量离开作用域，它的值会被drop函数清理，除非数据的所有权移动都另一个变量上。
* 把引用作为函数参数这个行为叫做借用，用符号&表示引用，引用不会取得所有权。
> stack访问速度快，heap访问速度慢。一般标量是放在stack中的，String变量的内容放在heap上，其地址和字符个数这些存放在stack上。
