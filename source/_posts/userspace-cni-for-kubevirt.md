---
title: intel userspace cni 适配 Kubevirt（workinprocess）
readmore: true
date: 2022-06-24 15:09:27
categories:
tags:
- DPDK
- userspace cni
- ovs cni
- KubeVirt
---

虽然KubeVirt还没官方支持DPDK，但intel userspace cni已经为KubeVirt做了一些适配。

主要是3点适配：
* vhost user client&server
* emptyDir
* ovs&qemu privilege

# vhost user client&server
kubevirt 使用DPDK需要用到intel的网络插件userspace cni，该插件使得ovs工作在client模式，kubevirt使得qemu工作在server模式。

> 参考 <a href="https://www.backendcloud.cn/2022/06/20/kubevirt-with-dpdk/" target="_blank">https://www.backendcloud.cn/2022/06/20/kubevirt-with-dpdk/</a>

# emptyDir
An empty directory can be used in the libvirt container, which
create vhostuser socket in a specific kubelet directory. Since
the directory length exceeds the limit 108 characheters, this
directory is mounted to a local directory in order to shorten
the vhostuser path added to ovs.



> Why is the maximal path length allowed for unix-sockets on linux 108?
> 参考 https://www4.cs.fau.de/Services/Doc/C/libc.html#TOC189

# ovs&qemu privilege
Also added a "group" name input for the vhostuser socket
so that when OvS is running as reduced privilege
openvswitch:hugetlbfs and qemu runs with group as
hugetlbfs, the vhostuser socket will be shareable between
them.
