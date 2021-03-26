title: 云主机的指令集配置
date: 2017-07-31 05:05:20
categories: Openstack_op
tags:
- CPU
- Nova
---
一些高性能计算应用需要CPU支持某些特性，如SSE4.2、 AVX、 AVX2、LZCNT、 FMA、 BMI等。OpenStack 默认的配置项为了保持虚拟机能够在不同的宿主机之间顺利迁移，没有特别指定CPU模式，而采用的是兼容模式。

若云主机需要特殊的指令集，如需要某些增强了的指令集，从多媒体应用到高性能计算应用领域的性能，同时还利用一些专用电路实现对于特定应用加速。

1、修改计算节点的 nova.conf，将 cpu_mode=none 改成 cpu_mode=host-passthrough

    # vim /etc/nova/nova.conf
    cpu_mode=host-passthrough

前提是物理cpu支持该指令

2、重启nova-compute服务

    service nova-compute restart

3、重启云主机

    nova reboot instance-ID

4、查看CPU属性

    # cat /proc/cpuinfo

发现已经有自己所需要的cpu指令集了



nova.conf配置项cpu_model的4种配置选项说明

* none 最小cpu模型，相比其他三个是最能兼容所有cpu型号
* custom 自己定义
* host-model 根据物理CPU的特性，选择一个最靠近的标准CPU型号 
* host-passthrough 直接将物理CPU 暴露给虚拟机使用，在虚拟机上完全可以看到的就是物理CPU的型号
