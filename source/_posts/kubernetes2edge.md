---
title: K3S, OpenYurt, KubeEdge 主要差异
date: 2021-01-21 16:47:45
categories: 云原生
tags:
- Kubernetes
- K8S
- K3S
- OpenYurt
- KubeEdge
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

Kubernetes 已经成为云原生的标准，并且能够在任何基础设施上提供一致的云上体验。我们经常能够看到“容器 + Kubernetes”的组合在 DevOps 发挥 10X 效率，最近也有越来越多 Kubernetes 运行在数据中心外（边缘）的需求。

# 如果要在边缘部署较复杂的应用，那么 Kubernetes 是个理想的选择：

* 容器的轻量化和可移植性非常适合边缘计算的场景；
* Kubernetes 已经被证明具备良好的可扩展性；
* 能够跨底层基础设施提供一致的体验；
* 同时支持集群和单机运维模式；
* Workload 抽象，例如：Deployment 和 Job 等；
* 应用的滚动升级和回滚；
* 围绕 Kubernetes 已经形成了一个强大的云原生技术生态圈，诸如：监控、日志、CI、存储、网络都能找到现成的工具链；
* 支持异构的硬件配置（存储、CPU、GPU 等）；
* 用户可以使用熟悉的 kubectl 或者 helm chart 把 IoT 应用从云端推到边缘；
* 边缘节点可以直接映射成 Kubernetes 的 Node 资源，而 Kubernetes 的扩展
* API（CRD）可以实现对边缘设备的抽象。

# 然而 Kubernetes 毕竟是为云数据中心设计的，要想在边缘使用 Kubernetes 的能力，Kubernetes 或其扩展需要解决以下问题：

* ARM 的低功耗和多核的特点又使得其在 IoT/Edge 领域的应用非常广泛，然而大部分的 Kubernetes 发行版并不支持 ARM 架构；
* 很多设备边缘的资源规格有限，特别是 CPU 处理能力较弱，因此无法部署完整的 Kubernetes；
* Kubernetes 非常依赖 list/watch 机制，不支持离线运行，而边缘节点的离线又是常态，例如：设备休眠重启；
* Kubernetes 的运维相对于边缘场景用到的功能子集还是太复杂了；
* 特殊的网络协议和拓扑要求。设备接入协议往往非 TCP/IP 协议，例如，工业物联网的 Modbus 和 OPC UA，消费物联网的 Bluetooth 和 ZigBee 等；

把 Kubernetes 从云端延伸到边缘，有3个开源项目做得不错，分别是 OpenYurt, KubeEdge 和 K3S，这篇文章主要讲下三者的主要差异。

K3S, OpenYurt, KubeEdge 三者都是基于Kubernetes的边缘计算相关的开源项目，完全兼容Kubernetes API，都可应用在边缘计算的场景。

K3S是轻量化的Kubernetes，可以不需要中心云，独立部署于边缘节点。和OpenYurt, KubeEdge相比也缺少边缘计算的云边协同，边缘自治等特性，K3S主要强调是轻量化的Kubernetes，应用于需要完整集群（包含管理集群）的边缘节点。

在边缘安装 Kubernetes 管理面将消耗较多资源，Kubernetes适合资源充足的“基础设施边缘”场景，K3S适用于资源较少的“设备边缘”的场景；但是为了管理边缘 Kubernetes/K3S 集群还需要在上面叠加一层多集群管理方案，遗憾的是该方案还不成熟。

# KubeEdge的架构如下：

![](/images/kubernetes2edge/3.png)

# OpenYurt的架构如下：

![](/images/kubernetes2edge/4.png)

KubeEdge要早于OpenYurt开源，KubeEdge已到1.4， 1.5版本，OpenYurt还处于0.3版本，还未发布1.0版本，KubeEdge相对于OpenYurt更成熟，功能更完善，但两者特色都是云边协同，边缘自治，管理节点在中心云，边缘节点在边缘。

KubeEdge和OpenYurt最主要的差异在：

OpenYurt可以通过命令将 Kubernetes 集群转换为 OpenYurt 集群，将 OpenYurt 集群 转换为 Kubernetes 集群。且OpenYurt完整的保留kubelet，KubeEdge的edged组件 是个重新开发的轻量化 Kubelet，实现 Pod，Volume，Node 等 Kubernetes 资源对象的生命周期管理。所以KubeEdge需要维护更新K8S的新版本，OpenYurt对边缘节点的资源要求较高，2U4G 起步，这个要求不管手机还是树莓派都可以轻松满足，要求不算苛刻，KubeEdge在边缘运行内存只有区区几十兆，做到了至极轻量，但功能精简严重，随着版本的升级，功能逐渐增加，对资源的消耗也逐渐在增加。OpenYurt相对于KubeEdge 跟随 Kubernetes 版本升级零负担，OpenYurt 非常容易扩展出更多的能力。

# OpenYurt和KubeEdge的对比

![](/images/kubernetes2edge/5.png)

# OpenYurt和K3S的对比

![](/images/kubernetes2edge/7.png)

# 边缘计算场景应用概况对比

![](/images/kubernetes2edge/6.png)

