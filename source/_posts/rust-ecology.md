---
title: Rust生态的现状和未来
readmore: false
date: 2022-07-18 08:35:32
categories: Fuchsia
tags:
---


# 现状

> Rust是目前最有未来的一门语言，已在所有领域开花结果。

## 操作系统
英特尔已经开始致力于让Rust实现与C相同的功能，微软也或将加入其中。由于Rust缺少C的一些功能，该团队发现Rust将最适用于新近开发的Windows组件。假如微软将部分代码库迁移到Rust，我也不会感到吃惊。微软已经为Rust搭建了一个标准Windows库，它具备C++版本的所有功能;Linux也在考虑将一些内核迁移到Rust。这两大操作系统之间有可能展开竞争，看谁能最先将Rust代码投入生产。

也有几个试水的小操作系统内核已经用纯rust编写，另外linux驱动，linux库，linux内置工具大量已经用rust编写。

google下一代全平台操作系统fuschia，现在很低调，2022年7月登进去，还是是每天都有大量代码merge。2016 年开始开发的 Fuchsia 操作系统，在 2020 年 12 月首次亮相于 google open source，其中 22% 的代码为 Rust 编写。2022年7月再去看，已经存量的底层代码已经变成一大半是用rust编写。现在merge进去的底层代码几乎都是Rust，感觉除了维护，新的内容都是用Rust编写。

## 云原生
Rust在云原生的代表项目（随便列举几个）:
* https://github.com/WasmEdge/WasmEdge
* https://github.com/krustlet/krustlet
* https://github.com/openeuler-mirror/stratovirt
* https://github.com/containers

WasmEdge：用于边缘计算的云原生 WebAssembly 运行时 ，WasmEdge 是目前市场上最快的 Wasm VM。由 CNCF 进行托管。

krustlet是微软的项目：Kubernetes Rust Kubelet。

stratovirt华为的项目：代替qemu的rust重构的qemu，说已经可以让虚拟机在50ms内启动。

podman 所在的 https://github.com/containers 组织，已经写了很多轮子, 包括 buildah 和 skopeo 这两个工具,与 podman 一起被称为下一代容器工具。

runc 是一个有名的 low-level OCI rumtime, 他们就开发了一个 crun . podman 早期版本使用 runc, 最新的版本已经使用 crun 了。

众所周知, golang 是容器生态的主要语言, podman 也是 go 写的,但是在 podman 4 的版本中, podman 增加了非 CNI 的网络栈支持, 这几个工具是 netavark 和 aardvark-dns, 这两个工具是 rust 写的, 而且还有 youki 这个 rust 写的 low-level OCI runtime, 不知道将来某一天 podman 会不会默认使用 youki , 还有好几个 rust 写的容器技术相关的应用和库, 这是要与 golang 分天下的节奏。

**Rust 将在云原生领域大放异彩了。目前来看，很有可能和Golang相互配合，Rust负责底层部分，Go负责中间部分，共同服务上层各种语言的应用。**

比如要轻量场景边缘场景可替换kvm/qemu的轻量vmm中，rust也有很多新兴开源项目：比如google的crosvm和基于crosvm的亚马逊的Firecracker，Rust-vmm项目以及基于Rust-vmm的Intel的cloud-hypervisor。

kata-container 2.0 3.0都越来越多的将底层和容器运行时用rust重写go和调用第三方rust底层模块。

## 区块链
Rust已完全取代Golang在区块链的地位，成为首选语言。

## 嵌入式，机器人
Rust在大量蚕食c/c++的市场

> 参考 https://github.com/rust-embedded/awesome-embedded-rust

## 中间件
在数据处理层的中间件，Rust已经有很多生产级的应用。这个领域是很多公司试水Rust开发项目的首选领域。也是Rust开始认为最擅长的领域。最先大规模应用的是金融交易领域，输赢就在响应的毫厘之间。

## GPU和游戏

例如：
* https://github.com/Rust-GPU/Rust-CUDA
* https://github.com/EmbarkStudios/rust-gpu
* https://github.com/bevyengine/bevy
* https://github.com/FyroxEngine/Fyrox


## 机器学习和科学计算

Transformers，linfa，Polars，oxide-enzyme，MegFlow，qdrant等等

## 前端
google的下一代全平台操作系统fuschia的前端是google自己的一套 Flutter+Dart 生态。

前端原来是js和ts的天下，js是号称网页版的汇编，ts是完全兼容js的更高级的语言，js工具链都是js编写的。如今javascript的所有工具链快要完全被rust取代了。Rust 开始替换 Javascript 的 Web 生态系统的重要组成部分包括压缩（Terser）、编译（Babel）、格式化（Prettier）、打包（webpack）、代码检查（ESLint）、以及更多其他的库。Rust Is The Future of JavaScript Infrastructure. Node.js 的创始人推出了Rust语言的Deno项目（js/ts的运行时），想要替换node.js。前端两大发展方向：wasm和js/ts  的基础架构都被rust拿下。

前端和桌面应用（windows/mac/linux）的融合框架领域，rust的代表项目Tuari现在也大有和Flutter平分天下的趋势。

![](/images/rust-ecology/js.png)

## web框架
多如牛毛的用于web后端开发的Rust web框架。Rocket，actix-web，yew，warp，axum，tokio等等。

## Rust FFI（Foreign Function Interface）
> 参考 https://doc.rust-lang.org/nomicon/ffi.html

# 上面都是Rust生态的现状，那未来呢？

Rust就如自己的名称一样，一种真菌的名字，这是要成为大一统的语言，大一统整个语言生态吗？