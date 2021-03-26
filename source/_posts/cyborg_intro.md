title: Openstack Cyborg 项目介绍
date: 2017-01-07 00:38:19
categories: 智能云
tags:
- Openstack
- Cyborg
---
项目原来叫Nomad，刚改名为Cyborg，是刚刚启动的一个项目。项目目标是提供通用的硬件加速管理框架。加速的硬件包括加密卡，GPU，FPGA，NVMe/NOF SSDs, DPDK/SPDK等等。

应该和面向未来的人工智能的基础设施有很大关联的一个项目。

# 起源于NFV需求

Cyborg项目起源于NFV acceleration management以及ETSI NFV-IFA 004 document，和OPNFV DPACC项目。

![nomad](https://wiki.openstack.org/w/images/thumb/f/f2/Nomad2.png/800px-Nomad2.png)

# Initial Architecture

![architecture](https://wiki.openstack.org/w/images/thumb/3/3f/Nomad3.png/800px-Nomad3.png)

# a virtual FPGA device as demonstrated

![fpga1](/images/cyborg_intro/fpga1.jpg)

1.Ironic monitors network and discovers new resource

2.New hosts are pXE booted and initialized with Hypervisor etc

3.Nova and Neutron DB are updated by agents

4.Ironic agent loads static region based on bit stream stored in swift/glance/glsre

5.Nova agent becomes aware of new PCIe devices (VFs from SR-IOV) and updated Nova DB




![fpga2](/images/cyborg_intro/fpga2.jpg)

1.Nova is requested to provision a VM with a PR (vFPGA)

2.Nova filters locate available resources and cause VM creation/config.

3.ungated VM cloud_init loads PR with bitstream from local file or Swift

  Future B) gated – VM requests Cyborg to load PR from Glare 

4.VFs are registered and allocated to VM

5.VM application access VF

