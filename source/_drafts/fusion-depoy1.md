`---
title: Openstack和Kubernetes融合部署（1） - 准备工作
date: 2022-04-12 22:02:45
categories: 云原生
tags:
- deploy
- Openstack
- Kubernetes
---

# 融合部署步骤
step1 在自己windows系统的电脑上用vmware起一个ubuntu虚拟机

step2 虚拟机里部署openstack all-in-one：尝试2种方式：devstack 和 kolla-ansible

step3 openstack起N+M个vm，用于部署Kubernetes，N个master + M个worker

step4 Kubernetes中部署helm-openstack

windows下起单ubuntu虚拟机，ubuntu虚拟机部署单节点Openstack，单节点Openstack起N+M个vm作为Kubernetes的N个master+M个worker节点，N+M个节点的Kubernetes上部署Openstack

为了研究容器化部署Openstack，虚拟化部署Kubernetes，kubernetes部署Openstack三件事情。

# 准备工作
很多包是国内访问受限，要流畅部署，最方便的是搭梯子。

step0 翻墙（特别是要让vmware中的虚拟机可以翻墙）
翻墙vpn软件很多，本文不是介绍这方面的文章，跳过。介绍下如何让vmware中的虚拟机可以翻墙。

> 若VPN可以安装在虚拟机中可以跳过。以下适用于虚拟机又不能直接安装VPN 或者 VPN多终端使用受限的情况。

## 原理
由于桥接模式，NAT模式，host-only模式类似，以NAT模式介绍原理。
![](/source/images/fusion-deploy1/a7438588.png)
当登录VPN时，则主机的部分（也可能是所有）数据会先走VPN再出主机网卡。其网络结构如下图所示。可知，虚拟机的数据始终不会通过VPN。
![](/source/images/fusion-deploy1/9abc1dc7.png)
通过共享VPN虚拟网卡给VMnet8，则虚拟机便可使用VPN与目的网络进行通信。其网络结果如下图所示。
![](/source/images/fusion-deploy1/080d2480.png)
不止是VMnet8，采用“仅主机模式”，原理也同样适用。

## 操作
控制面板\网络和 Internet\网络连接
右击vpn对应的网络适配器，选择属性，选择第二个标签`共享`，选中`运行其他网络用户通过此计算机的Internet连接来连接`，下面选虚拟机要用的网络适配器，点击确认。

接下来右击虚拟机连接的网络适配器，选择属性，查看ip地址，应该是192.168.137.1

登录vmware虚拟机，网络不要用DHCP配置的，用手动分配的192.168.137.0/24网段的。

测试 `curl https://www.youtube.com/channel/UCw2MGqCYN_xyCpVMnNoLhWA` 发现可以获取一堆数据。

使用minikube快速部署单机版k8s
