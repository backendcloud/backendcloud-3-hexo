title: POWER架构服务器作为计算节点
date: 2018-10-21 16:21:52
readmore: true
categories:
- Openstack_op
tags:
- POWER

---

# 目标

在power机器上安装计算组件，将power机器作为计算节点，并测试Openstack的基本功能。

# 环境

1台控制节点（x86机器）
5台计算节点（4个x86机器，1个power机器）

# 安装依赖的问题

就算将yum源都配置成power架构的yun源还是有一些依赖找不到。
power机器安装组件以及组件所需要的依赖，会遇到yum依赖找不到的各种问题。

解决方式：
1）不分架构的python包，手动pip安装
2）需要编译成Power架构编译器编译的。或者网上搜索，或者在power上编译安装。

# power机器对IDE的支持有问题

2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f] libvirtError: unsupported configuration: IDE controllers are unsupported for this QEMU binary or machine type
生成虚拟机的时候通过将IDE改成virtio解决

# python脚本执行错误

{"message": "Build of instance 15d9db88-d0a9-40a8-83e9-9ede3001b112 was re-scheduled: 'module' object has no attribute 'to_utf8'", "code": 500, "details": " File \"/usr/lib/python2.7/site-packages/nova/compute/manager.py\", line 2258, in _do_build_and_run_instance
执行起来会报错有的是因为pip安装的python包自动安装依赖，版本之间的关系错乱，需要卸载掉现在的版本，重新安装需要的版本。

# vnc不能用

{"message": "Build of instance a1feb48a-b5f5-48ab-93a7-838bb46573fb was re-scheduled: internal error: process exited while connecting to monitor: 2017-05-18T10:33:34.222333Z qemu-kvm: Cirrus VGA not available", "code": 500, "details": " File \"/usr/lib/python2.7/site-packages/nova/compute/manager.py\", line 2258, in _do_build_and_run_instance
通过修改libvirt源码，重新编译安装的方式解决。

# 键盘输入没反应

用ubuntu14.04镜像生成的虚拟机，键盘输入没有反应。
改用ubuntu16.04的就没有这个问题。Centos6，7问题肯定更多。Centos的镜像文件官网都没有下载。

# nova对POWER机几个常用操作测试

测试了Nova对vm生命周期管理的几个常用的操作，如生成，重启，挂起，恢复，关机，删除。测试正常。

测试了对vm挂载卷，卸载卷。测试正常。

测试了Nova对power机器的资源统计，对power机器上的nova服务心跳的监控。测试正常。

# 结论

计算组件部署在power机器上，问题很多，难以部署，运行起来风险太大，不可控因素太多。

Linux(Centos)+openstack 安装在power机器上，没有成熟的方案，或者说没有什么先例。自己去试和研究，成本太大。就是专业做研发，做技术也不太会往这个方向，一般是交给社区做。而Linux(Centos)的社区fedora，PowerPC被fedora降级为二级架构，排在x86和arm架构 之后 
https://fedoraproject.org/wiki/Architectures/ARM/Planning/Primary

就假设计算组件可以完好的在power机器上运行，但是power架构的机器上只能运行power架构的虚拟机，现在还极少有客户的虚拟机是power架构的。


