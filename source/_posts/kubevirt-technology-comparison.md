---
title: KubeVirt和其他技术的对比
readmore: false
date: 2022-08-02 18:31:57
categories: 云原生
tags:
- KubeVirt
---


# Kubevirt vs OpenStack or oVirt

Kubevirt的主要目标是允许基于Kubernetes运行虚拟机。它专注于虚拟化。一般的虚拟化管理系统（例如OpenStack或Ovirt）通常包括一些其他服务，这些服务要照顾网络管理，主机提供，数据仓库，仅举几例。这些服务超出了Kubevirt的范围。话虽如此，Kubevirt旨在成为虚拟化管理系统的一部分。Kubevirt可以看作是VM群集运行时，并且Kubernetes的组件提供了其他功能，以提供一个不错的连贯的用户体验。

> 虽然是完全不一样的技术路线，实现方案，但是有个强关联的地方，就是 Kubevirt 是用来代替 Openstack 和 oVirt 的。

# KubeVirt vs ClearContainers


ClearContainers 是关于使用 VM 情形， 在容器运行时级别 不同于 pod 或容器。另一方面，KubeVirt 是关于允许在集群级别管理虚拟机。

除此之外，暴露虚拟机的方式也不同。 ClearContainers 隐藏了使用虚拟机的事实，但 KubeVirt 对外提供一整套完整的 API 来配置虚拟机。

> ClearContainers 和 Kata Containers 是同一维度的东西。

# KubeVirt vs virtlet

这两个东西是采用的技术路线有一定的共通的地方，有较强的可比性。

virtlet 是一个 CRI 实现，用于运行虚拟机而不是容器。与 KubeVirt 的主要区别在于：

1. virtlet 是一个 CRI。这意味着 VM 运行时位于主机上，并且 kubelet 要特别适配 virtlet。而 KubeVirt 可以部署为原生 Kubernetes 插件。
2. Pod API。 virtlet 使用 Pod API 来指定 VM。某些字段（例如卷）映射到相应的 VM 功能。这是有问题的，VM 有很多细节无法映射到 Pod 对应对象。最终只能使用注解annotations来表示这些属性。而 KubeVirt 使用了 VM 的专用的一整套 API，并试图覆盖 VM 的所有属性。

> 因为上述种种原因Kubevirt终结了virtlet，ClearContainers倒不是被Kubevirt终结的，而是被Kata Containers取而代之了。就差Openstack还残喘着，但被完全取代或部分使用场景被取代是大势所趋。

# 为何基于Kubernetes构建vm的运行环境，而不采用将容器带入OpenStack or oVirt

容器工作负载是未来。因此，要在容器管理系统之上添加 VM 支持，而不是将容器支持构建到 VM 管理系统中。