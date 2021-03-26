title: 本地存储条件下的热迁移
date: 2017-06-14 15:25:48
categories: Openstack_op
tags:
- Nova
- 热迁移
---

    nova live-migration --block-migrate

# 虚拟机热迁移的作用
每个读者都可能会问这样一个问题，虚拟机用的好好的，为啥要迁移呀？也就是迁移的价值和目的在哪里。在数据中心的日常运维中，常常要处理下面几种场景和需求，了解了这些需求，这个问题也就有了答案。
需求 1：物理机器硬件系统的维护，故障修复和升级(upgrade)，但运行在这台物理机器上的虚拟机不能关机，因为用户重要的服务跑在上面。
需求 2：物理机器软件系统升级，打补丁(patch)，为了不影响上面跑的虚拟机，在升级和打补丁之前，需要把虚拟机迁移到别的物理机器上。
需求 3：一个物理机器上的负载太重，需要减少一些虚拟机来释放资源。
需求 4：在一个 cluster 里，有的物理机上的虚拟机太多，有的物理机上虚拟机太少，需要做一下资源平衡。

除了上面四个主要的需求，从服务的角度来看，Live migration 有下面两个好处：
好处 1：软件和硬件系统的维护升级，不会影响用户的关键服务，提高了服务的高可用性和 用户的满意度。
好处 2：系统管理员不用加班加点，在大半夜进行系统升级了，在正常的工作时间就可以完成这项工作，减少了公司的维护费用。

有这四个需求和两个好处，所以动态迁移值得一作。



# 基本概念
在了解动态迁移之前，必须了解镜像文件的格式 QCOW2。Qcow2 是 QEMU 目前推荐的镜像格式，它支持稀疏文件以节省存储空间，支持加密以提高镜像文件的安全性，支持基于 zlib 的压缩。Qcow2 镜像可以用来保存另一个镜像文件的变化，它并不去修改原始镜像文件，原始镜像文件也叫后端镜像(backing_file)。只记录与原始镜像文件的不同部分的镜像文件，这种镜像文件就叫做 copy-on-write 镜像，它虽然是一个单独的镜像文件，但它的大部分数据都来自原始镜像，只有基于原始镜像文件的增量部分才会被记录下来。本文提及的虚拟机都是 OpenStack 用 Qcow2 格式的镜像文件建立的，如图所示，包含两部分。
1.后端镜像(libvirt base)
2.虚拟机单独的增量镜像文件(libvirt instance disks)，copy-on-write 镜像

![block-migrate](/images/block-migrate/nova-disk.png)

    [root@NFJD-TESTN-COMPUTE-1 ~]# cd /var/lib/nova/instances/
    [root@NFJD-TESTN-COMPUTE-1 ~]# tree
    ├── b9530e7b-2309-4eb5-bec3-180241c1e3a2
    │   ├── console.log
    │   ├── disk
    │   ├── disk.config
    │   ├── disk.info
    │   └── libvirt.xml
    ├── ...
    ├── _base
    │   ├── 0522bc602608d45758d815b01a6899ff3e1e3e27
    │   ├── 05252f6d26980b56fbf93a14c5e70910f18b412c
    │   ├── ...



用 qemu-img 查看虚拟机单独的增量镜像文件的信息，我们可以看到他的 backing file 是_base 目录下的镜像文件

    [root@NFJD-TESTN-COMPUTE-1 ~]# cd /var/lib/nova/instances/
    [root@NFJD-TESTN-COMPUTE-1 instances]# cd 852e1a26-bd49-4149-bd24-552eb4b37034
    [root@NFJD-TESTN-COMPUTE-1 852e1a26-bd49-4149-bd24-552eb4b37034]# ls
    console.log  disk  disk.config  disk.info  libvirt.xml
    [root@NFJD-TESTN-COMPUTE-1 852e1a26-bd49-4149-bd24-552eb4b37034]# qemu-img info disk
    image: disk
    file format: qcow2
    virtual size: 20G (21474836480 bytes)
    disk size: 281M
    cluster_size: 65536
    backing file: /var/lib/nova/instances/_base/731d527f50917ff3364203ebbcf8d4c22dc7919c
    Format specific information:
        compat: 1.1
        lazy refcounts: false
        refcount bits: 16
        corrupt: false

费了这么多篇幅介绍 QCOW2，您会奇怪，目的何在？其实上面介绍的后端镜像(libvirt Base)，虚拟机单独的增量镜像文件(libvirt instance disks)，它们就是要被迁移的数据。动态迁移的最终目标就是把它们完整地从源物理主机迁移到目标物理主机。除了他们两个之外，还有一个需要迁移的对象就是内存里运行的虚拟机的数据。

数据的转移就涉及数据的传输，数据的传输需要通过网络，本文介绍使用 TCP 网路协议完实现动态迁移。Libvirt 默认情况下不支持 TCP 协议，需要对 libvirt 的配置做修改，使 libvirt 能够支持 TCP 协议，后面的章节会详细的介绍如何配置。 在迁移的过程中，运行在目的物理主机（Dest Host）中的 libvirtd 进程要根据 address 和 port 创建一个 URI，URI 是目的物理主机用来接收数据和发回数据到源物理主机（Source Host）的 libvirtd 进程的。

在目的物理主机和源物理主机，只要下面的命令能够执行，就说明能够传输数据了。
在 compute01 上执行：

    [root@compute01]# virsh -c qemu+tcp://nova@compute02/system

在 compute02 上执行：

    [root@compute01]# virsh -c qemu+tcp://nova@compute01/system


如：

    [root@NFJD-TESTN-COMPUTE-1 instances]# virsh -c qemu+tcp://nova@NFJD-TESTN-COMPUTE-2/system
    欢迎使用 virsh，虚拟化的交互式终端。
    
    输入：'help' 来获得命令的帮助信息
           'quit' 退出
    
    virsh # ^C
    [root@NFJD-TESTN-COMPUTE-1 instances]# virsh -c qemu+tcp://nova@NFJD-TESTN-COMPUTE-2/system
    欢迎使用 virsh，虚拟化的交互式终端。
    
    输入：'help' 来获得命令的帮助信息
           'quit' 退出
    
    virsh # list
     Id    名称                         状态
    ----------------------------------------------------
     9     instance-000057c2              暂停
     10    instance-000057c6              running
     24    instance-0000581a              暂停
     25    instance-0000581f              running
     31    instance-00005833              running
     ...

# 迁移的步骤

迁移的基本概念弄清楚了，下面我们继续介绍迁移的步骤。OpenStack 做动态迁移一个正常的流程主要包括四部分：迁移前的条件检查、迁移前的预处理、迁移、迁移后的处理。



## 迁移前的条件检查

动态迁移要成功执行，一些条件必须满足，所以在执行迁移前必须做一些条件检查。
1.权限检查，执行迁移的用户是否有足够的权限执行动态迁移。
2.参数检查，传递给 API 的参数是否足够和正确，如是否指定了 block-migrate 参数。
3.检查目标物理主机是否存在。
4.检查被迁移的虚拟机是否是 running 状态。
5.检查源和目的物理主机上的 nova-compute service 是否正常运行。
6.检查目的物理主机和源物理主机是否是同一台机器。
7.检查目的物理主机是否有足够的内存(memory)。
8.检查目的和源物理主机器 hypervisor 和 hypervisor 的版本是否相同。



## 迁移前的预处理

在真正执行迁移前，必须做一下热身，做一些准备工作。
1.在目的物理主机上获得和准备虚拟机挂载的块设备(volume)。
2.在目的物理主机上设置虚拟机的网络(networks)。
3.目的物理主机上设置虚拟机的防火墙(fireware)。



## 迁移

条件满足并且做完了预处理工作后，就可以执行动态迁移了。主要步骤如下：

1.调用 libvirt python 接口 migrateToURI，来把源主机迁移到目的主机。
  * dom.migrateToURI(CONF.live_migration_uri % dest,logical_sum,None,CONF.live_migration_bandwidth)
  * live_migration_uri：这个 URI 就是在 3.2.2 里介绍的 libvirtd 进程定义的。
  * live_migration_bandwidth：这个参数定义了迁移过程中所使用的最大的带宽。

2.以一定的时间间隔（0.5）循环调用 wait_for_live_migration 方法，来检测虚拟机迁移 的状态，一直到虚拟机成功迁移为止。



## 迁移后的处理
当虚拟机迁移完成后，要做一些善后工作。
1.在源物理主机上 detach volume。
2.在源物理主机上释放 security group ingress rule。
3.在目的物理主机上更新数据库里虚拟机的状态。
4.在源物理主机上删除虚拟机。
上面四步正常完成后，虚拟机就成功的从源物理主机成功地迁移到了目的物理主机了。系统管理员就可以执行第二章所列的哪些管理任务了。



# 动态迁移的配置
本节列出了支持动态迁移的配置，必须确保所有物理主机上配置真确，动态迁移才能成功完成。

## Libvirt
libvirt 默认情况下支持远程连接的 TLS 协议，不支持 TCP 协议，因此将 listen_tls=0 listen_tcp=1 使 libvirt 能够支持 TCP 协议。
1.修改/etc/sysconfig/libvirtd 文件。

    LIBVIRTD_ARGS="--listen"

2.在/etc/libvirt/libvirtd.conf 文件中做如下配置。

    listen_tls=0
    listen_tcp=1
    auth_tcp="none"

3.重启 libvirtd 服务



## 防火墙
配置/etc/sysconfig/iptables，打开 TCP 端口 16509。

    -A INPUT -p tcp -m multiport --ports 16509 -m comment --comment "libvirt" -j ACCEPT



## OpenStack Nova
在/etc/nova/nova.conf 文件里配置 live_migration 标记。

    live_migration_flag=VIR_MIGRATE_UNDEFINE_SOURCE,VIR_MIGRATE_PEER2PEER,VIR_MIGRATE_LIVE



