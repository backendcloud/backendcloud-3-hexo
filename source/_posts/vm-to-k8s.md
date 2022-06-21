---
title: 将虚拟机迁移到Kubernetes
readmore: true
date: 2022-06-20 20:55:47
categories: 云原生
tags:
- 虚拟机
- Kubernetes
- KubeVirt
---

# KubeVirt简介

随着微服务的出现，人们通常会问: “是否有可能在 Kernel-based Virtual Machine (kVM)中运行我的遗留虚拟机(VM)或在 Kubernetes 上运行我的微服务的 VMware，或者我需要将它们迁移到容器中?”这个问题的一个可能的答案是 KubeVirt。

KubeVirt 项目将 Kubernetes 转换为用于应用程序容器和虚拟机工作负载的编制引擎。它解决了那些已经采用或想要采用 Kubernetes 的开发团队的需求，这些团队拥有现有的基于 VM 的工作负载，而这些工作负载不能轻易地放入容器中。KubeVirt这项技术提供了一个统一的开发平台，开发人员可以在其中构建、修改和部署驻留在公共共享环境中的应用程序容器和 VM 中的应用程序。

> KubeVirt 可以部署在具有裸金属或 VM 形式的 Kubernetes 工作节点的容器引擎上。如果您的集群工作者节点配置了 VM 形式，那么 KubeVirt 将以嵌套模式运行遗留的 KVM 或 VMware 虚拟机。

# 在容器引擎中运行 KVM 和 VirtualBox/VMware 虚拟机

分两步：
1. 将磁盘转换为原始格式。有两个免费实用工具可以帮助您实现这一点: Oracle VirtualBoxVBoxManagement 和 QEMU 磁盘映像实用工具。

```bash
VBoxManage clonehd --format RAW kvm_qcow2_OR_VMware_vmdk_disk disk-name.img

qemu-img convert kvm_qcow2_OR_VMware_vmdk_disk -O raw disk-name.img
```

2. 用磁盘创建一个持久卷声明PVC，并启动使用PVC的VM。

> 如何使用 CDI(容器化数据导入器) 将 VM 映像导入到PVC中，以及如何定义使用 PVC 的 VM。参考：<a href="https://www.backendcloud.cn/2022/06/02/k8s-vnc-win10/" target="_blank">https://www.backendcloud.cn/2022/06/02/k8s-vnc-win10/</a>




