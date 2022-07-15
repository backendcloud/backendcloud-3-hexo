---
title: 钱是个好东西
readmore: false
date: 2022-07-15 18:42:38
categories: 生活
tags:
---

```bash
[developer@localhost ~]$ cat /sys/module/kvm_intel/parameters/nested
N
[developer@localhost ~]$ uname -r
3.10.0-1160.el7.x86_64
[developer@localhost ~]$ lsmod|grep kvm_intel
kvm_intel             188740  0 
kvm                   637289  1 kvm_intel
# 上面有了kvm说明host bois打开了intel vmx，vmware也打开了intel vmx（该机器是vmware虚拟机），再确认下是否打开了嵌套虚拟化
[developer@localhost ~]$ logout
[root@localhost ~]# modprobe -r kvm_intel^C
[root@localhost ~]# lsmod|grep kvm_intel
kvm_intel             188740  0 
```

# 自媒体

曾经看不上的硬广行为，如今却：

公众号开了广告，观察了一段时间，发现广告收入勉勉强强够付云服务的费用，可能都不够付的。腾讯有够小气。

还放了了几个付费文章。做了多点尝试。

现在做事的一切动机都朝钱看。没钱都哪凉快哪呆去。

过去当做“反面教材”的东西，如今却是我正在做的事情。

能力配不上野心时候，“归来仍是少年”就成空话了。

日语不自由就是中文的贫穷的意思，不得不说有相同起跑线汉字的基础上，通过单个汉字造多字词语上，日文这个词胜过中文。和一起奋斗过多年的好友探讨过钱和不自由的关系。“把技术当信念，不是工作。”“钱能限制的东西很多，但不是全部。”“穷折腾的例子也不少。”

野心，努力，敬业，躺平，折腾。可能就是对钱的不同态度而已。从这角度看钱真是个好东西。

# Rust

Rust初上手时，人人都说难。

也是有编程基础的时候，对比其他语言的时候觉得难。Rust中的内存安全对语法的强限定以及所有权，对一个零编程语言大学生上来就学Rust并不觉得难，觉得理所当然的。

Rust的在各个领域的发展和扩张势头以及新生代对Rust生态的贡献速度，大有要把前浪拍在沙滩上的趋势。

看到大趋势的情况下，前辈也只能硬撑着老骨头，混入年轻大军，避免被拍死。
