title: vm挂载卷，镜像，vm实例的共享存储架构
date: 2017-06-07 8:20:29
categories: Openstack_op
tags:
- 存储
---

测试环境可以用本地存储，但生产环境都会上共享存储，特别是现在比较火的ceph。

生产环境一般有独立的存储网络，和管理网络以及用户虚拟机的业务网络隔离开，互不影响网络的传输性能。



# 块存储（cinder）

块存储（cinder）服务管理环境中的存储设备上卷。在生产环境中，该装置通过存储协议（例如，NFS，iSCSI或Ceph的RBD）到存储网络（br-storage）和存储管理API来管理网络（br-mgmt）。实例由计算主机上的管理程序通过存储网络连接到卷。

下图说明了块存储是如何连接到实例。
![cinder](/images/storage_arch/cinder.png)
该图示出了以下步骤。
1. 卷是由cinder-volume收到cinder api服务走管理网络发过来消息而创建的。
2. 创建该卷后，nova-compute服务经由存储网络将计算主机hypervisor连接到卷。
3. hypervisor连接到卷后，卷可以当成vm的本地硬件设备来使用。



# 镜像存储（glance）

镜像服务（glance）可以通过驱动配置多种多端存储。

若使用本地存储，没有机制来保障在镜像服务节点的镜像存储的冗余。一个镜像节点丢失，会导致镜像丢失而找不到，所以生产环境建议后端存储使用共享存储保证glance-api服务对所有镜像可以访问。

![cinder](/images/storage_arch/glance.png)
该图示出了以下步骤。
1. 当client请求的image时，glance-api服务访问存储设备上相应的存储在存储网络（br-storage）并将其拉入它的高速缓存。当再次请求相同的图像，它是从缓存直接提供给client。
2. 当一个实例被安排在计算节点上创建， nova-compute服务通过管理网络（br-mgmt）请求glance-api 服务。
3. image检索后，该nova-compute服务存储镜像至在其自己的图像缓存中。当使用相同的image来创建另一实例中，image被从本地基础image高速缓存中检索。



# vm实例存储（nova）

当在计算服务中flavor配置为提供与根或短暂的磁盘情况下，nova-compute服务管理使用其临时磁盘存储位置这些分配。

在许多环境中，nova instance的disk存储在计算节点的本地磁盘上，但对于生产环境，我们建议计算主机配置为使用共享存储子系统来代替。共享存储子系统，可让计算主机间实现快速迁移，这对于虚拟机的高可用，执行虚拟机的疏散非常有用，即当计算节点故障，将故障节点的虚拟机从故障节点疏散到另一台可用的节点并再次启动来恢复虚拟机 。下图说明的存储设备，计算节点，hypervisor，和实例之间的相互作用。

![cinder](/images/storage_arch/nova.png)
该图示出了以下步骤。
1. 计算节点被配置为可以访问该存储设备。计算主机访问经由存储网络（br-storage）通过使用存储的协议（例如，NFS，iSCSI或Ceph的RBD）来访问存储设备。
2. nova-compute服务配置hypervisor以分配的实例硬盘。
3. hypervisor将该磁盘作为实例的磁盘设备。

