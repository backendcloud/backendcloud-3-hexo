---
title: tensile-kube 简介
readmore: true
date: 2023-03-14 17:28:42
categories: 云原生
tags:
- Serverless
---


tensile-kube核心组件为4个：

* virtual-node 基于virtual-kubelet实现的了K8s provider功能，同时增加了多个controller，用于同步ConfigMap、Sercret、Service等资源。

* webhook 对Pod中可能对上层集群调度产生干扰的字段进行转换，将其写入annotation中，virtual-node在创建Pod时再将其恢复，避免影响用户期望的调度结果。

* descheduler 用于避免资源碎片带来的影响，这个组件我们基于社区的descheduler进行了二次开发，使之更适用于这个场景。

* multi-scheduler 主要用于连接下层集群的API Server, 避免资源碎片的影响，在调度时判断virtual-node的资源是否足够。（multi-scheduler独立出tensile-kube建立了项目仓库，multi-scheduler会比较重，不是特别推荐使用；如果要使用，需将上层集群kube-scheduler替换成multi-scheduler。）

tensile-kube基于微软开源项目virtual-kubelet开发，准确说是实现了virtual-kubelet的provider接口中的一种资源类型，kubernetes on kubernetes。

> Virtual Kubelet（VK）是一个“Kubernetes Kubelet实现，它伪装成 Kubelet，将 Kubernetes 连接到其他 API”。初始的 VK 实现将远程服务建模为集群的节点，从而在 Kubernetes 集群中引入无服务器计算。后来，VK 在多集群上下文中变得流行起来：VK 提供者可以将远程集群映射到本地集群节点。包括Admiralty、Tensile-kube和 Liqo 在内的几个项目都采用了这种方法。virtual-kubelet项目本身是一个框架，并没有实际功能，通过provider项目实现provider功能才具备实际能力。
> 
> 与专用 API 服务器相比，这种方法有几个优点。首先，它引入了多集群，不需要额外的 API，而且它对应用程序透明。其次，它灵活地将远程集群的资源集成到调度器的可用性中：用户可以以与本地 pod 相同的方式调度远程集群 pod。第三，它使分散治理成为可能。

tensile-kube对原生K8s集群无侵入，tensile-kube中，通过virtual-node建立上下层集群之间的连接，上层的Pod通过调度器调度到virtual-node，随后将Pod同步到下层集群创建，整个方案对于K8s无侵入。

tensile-kube可以实现多集群调度，功能类似于k8s集群联邦（Cluster Federation），但tensile-kube不止可以用于多集群调度，还主要可以应用在Serverless领域，还可以用在边缘计算和混合云上。

tensile-kube未来待解决的几个课题：
1. 多集群调度器优化
2. provider状态同步实时性优化
3. 多租户场景下多个子集群资源名称冲突

> tensile-kube项目已经停更几年了，目前社区还活跃的是另一个类似项目liqo，liqo的复杂度和功能相对tensile-kube项目要多不少。

总之，基于Virtual-Kubelet的tensile-kube，可以简单形象理解成Kubernetes的套娃项目。