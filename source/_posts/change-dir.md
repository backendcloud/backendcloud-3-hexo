---
title: 优化后端云网站的部分的分类/标签/标题
readmore: false
date: 2022-07-21 21:57:29
categories: 网站里程碑
tags:
---

# 优化部分分类

## 原来分类太多了，压缩一些分类

## 增加了`Fuchsia`分类

Fuchsia具有以下特点：
* 截至该文章发布时2022-07-21，Fuchsia还在密集开发和代码合并中。
* 未来Fuchsia成为大一统所有平台的通用操作系统的愿望的是否能实现还很难说。但Fuchsia中用到的技术都是非常前沿的，代表未来方向的，即使Fuchsia本身不一定成功，但是作为个人兴趣投入Fuchsia一点不亏，学到的东西可以用到其他项目的开发中去，且Fuchsia是非常有希望成功的。
* Fuchsia会进一步加快Rust和Dart语言的发展和应用，虽然Rust已经是编程语言中最火的编程语言，Flutter已经是UI开发最火的框架。那就算继续火上浇油吧。
* Fuchsia有很多颠覆性的疯狂项目：
  * [Jiri](https://fuchsia.googlesource.com/jiri): 相对于单仓库管理工具Git，Jiri是Fuchsia的多仓库代码管理工具。
  * [Zircon](https://fuchsia.googlesource.com/fuchsia/+/refs/heads/main/zircon/): Fuchsia的操作系统内核。
  * [Topaz](https://fuchsia.googlesource.com/topaz/): Fuchsia的用户体验层（由Flutter支持）。
  * [Starnix](https://fuchsia.googlesource.com/fuchsia/+/refs/heads/main/src/proc/bin/starnix/): 转译来自 Linux 的底层内核架构到 Fuchsia 的 Zircon 内核。Starnix creates a Linux runtime natively in Fuchsia. Starnix 让 Fuchsia 能够原生效率运行 Linux/Android 应用和库。

> 增加`Fuchsia分类` 和`Fuchsia`一样，动机不是因为Fuchsia本身百分百能成功，而是因为兴趣以及对Fuchsia的投入可以运用到其他项目上。个人能力有限，刚开始肯定只能一窥Fuchsia的一点皮毛。
> `Fuchsia分类` 不仅仅会放关于Fuchsia的研究学习文章，且打算把兴趣类的前沿探索全放此分类里。



# 优化部分文章的标题和标签

优化前是这样的

![](/images/change-dir/2022-07-22-13-57-49.png)

快被`一步步学KubeVirt CI`给覆盖满了，不细看以为后端云网站全是做这个的，实际上技术范围有点混乱和杂的，但都是围绕云原生发散开的。

优化后，把标题`一步步学KubeVirt CI`去掉，对应的文章打上了`KubeVirt CI`标签。
