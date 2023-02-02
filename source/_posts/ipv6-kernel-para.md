---
title: ipv6相关内核参数配置的优化实践
readmore: false
date: 2023-02-02 07:44:11
categories: 云原生
tags:
---


# 调整ARP缓存大小

这个参数通常需要在高负载的访问服务器上增加。比如繁忙的网络（或网关/防火墙 Linux 服务器），再比如集群规模大，node 和 pod 数量超多，往往需要增加内核的内部 ARP 缓存大小。

dmesg命令查看内核消息，当内核消息报：NEIGHBOUR: ARP_CACHE: NEIGHBOR TABLE OVERFLOW!

此内核消息表明 ARP 缓存已满。 ARP 缓存是 IP/MAC 地址绑定的查找表。

需要调大gc_thresh参数，下面是参考值：

下面是服务超过 6,000 个客户端的服务器的配置参考值: 

```bash
sysctl -w net.ipv4.neigh.default.gc_thresh3=24456
sysctl -w net.ipv4.neigh.default.gc_thresh2=12228
sysctl -w net.ipv4.neigh.default.gc_thresh1=8192
sysctl -w net.ipv6.neigh.default.gc_thresh3=24456
sysctl -w net.ipv6.neigh.default.gc_thresh2=12228
sysctl -w net.ipv6.neigh.default.gc_thresh1=8192
```

除了上面的调整缓存大小的参数配置外，还可以调整下面两个参数以应对繁忙的网络，下面是200~500个客户端请求的网络服务器的配置参考值：

    # 强制 gc 快速清理
    net.ipv4.neigh.default.gc_interval = 3600
    
    # 设置 ARP 缓存条目超时
    net.ipv4.neigh.default.gc_stale_time = 3600

# 禁用ipv6

如果不使用 IPv6 或双栈，建议禁用 IPv6 以减少系统的攻击面。

编辑 /etc/default/grub 并将 ipv6.disable=1 添加到 GRUB_CMDLINE_LINUX 参数：
GRUB_CMDLINE_LINUX='ipv6.disable=1'运行以下命令更新 grub2 配置：# update-grub

除了grub方式，还可以通过在 /etc/sysctl.conf 加上

	net.ipv6.conf .all.disable_ipv6 = 1
	net.ipv6.conf.default.disable_ipv6 = 1

执行 /sbin/sysctl -p 使其生效。



# 转发

IP 转发是操作系统在一个接口上接受传入网络数据包的能力，识别它不是针对系统本身的，而是应该转发到另一个网络，然后相应地转发。

如果我们要设置  Linux 路由器/网关 或 VPN 服务器，就需要必须开启转发。

    net.ipv4.ip_forward=1
    net.ipv6.conf.all.forwarding=1

若不需要ip转发，比如不用做Linux 路由器/网关 或 VPN 服务器，将值设为0。

# 高并发场景，扩大源端口范围

高并发场景，对于 client 来说会使用大量源端口，源端口范围从 net.ipv4.ip_local_port_range 这个内核参数中定义的区间随机选取，在高并发环境下，端口范围小容易导致源端口耗尽，使得部分连接异常。通常 Pod 源端口范围默认是 32768-60999，建议将其扩大，调整为 1024-65535: 

    net.ipv4.ip_local_port_range=”1024 65535”。

该配置参数修改后对ipv6同样生效。

# bridge-nf-call-iptables

若该K8S节点网络使用了Linux网桥，bridge-nf-call-iptables参数需要设置为1。

    net.bridge.bridge-nf-call-iptables=1

否则会因为DNAT回包异常而丢包。

# 调整tcp全连接连接队列的大小

TCP 全连接队列的长度如果过小，在高并发环境可能导致队列溢出，使得部分连接无法建立。

如果因全连接队列溢出导致了丢包，从统计的计数上是可以看出来的：



```bash
# 用 netstat 查看统计
$ netstat -s | grep -E 'overflow|drop'
    12178939 times the listen queue of a socket overflowed
    12247395 SYNs to LISTEN sockets dropped
```

高并发环境可以考虑将其改到 `65535`:

```bash
sysctl -w net.core.somaxconn=65535
```

# 调整UDP缓冲区

UDP socket 的发送和接收缓冲区是有上限的，如果缓冲区较小，高并发环境可能导致缓冲区满而丢包，通过下面的命令可以看出来:

```bash
# 使用 netstat 查看统计
$ netstat -s | grep "buffer errors"
    429469 receive buffer errors
    23568 send buffer errors
```

`net.core.wmem_default` 和 `net.core.wmem_max` 这两个内核参数，分别表示缓冲区的默认大小和最大上限。

# 调整conntrack 表

内核日志:

```bash
# demsg
$ journalctl -k | grep "nf_conntrack: table full"
nf_conntrack: nf_conntrack: table full, dropping packet
```

若有以上报错，证明 conntrack 表满了，需要调大 conntrack 表:

```bash
sysctl -w net.netfilter.nf_conntrack_max=1000000
```

#  主机无法ping通ipv6网关

 

有几台业务虚机，经常会出现ipv6无法访问自己网关，要重启机器才可以修复。

## 原因

分析dmesg日志有如下信息:

    [113050.599558] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
    [113052.663065] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.

 





查看该内配参数配置：

    $ sudo sysctl net.ipv6.route.max_size 
    net.ipv6.route.max_size = 4096

 net.ipv6.route.max_size 该内核参数的作用是设置目的地条目的缓存。当 Linux 内核解析到目的地的路由时，它会将其放入缓存中以备将来使用。

 net.ipv6.route.max_size 默认为 4096。IPv4 的等效设置默认为“百万”，甚至在现代内核中动态调整大小。

## 解决方案：将内核参数net.ipv6.route.max_size置为2147483647。默认为4096。

可以将该值调足够大，比如 2147483647

    vim /etc/sysctl.conf

做以下配置

    net.ipv6.route.max_size = 2147483647

然后执行sysctl -p

可能的话，再重启下网络。



 

 

# ipv6默认路由丢失：

重启network或者网卡后，ipv6默认路由存在（下一跳为fe80开头的默认路由）

![](/images/ipv-kernel-para/clip_image002.jpg)

大约8分钟左右，fe80这条默认路由丢失。


## 原因：

accept_ra这个内核参数默认为1。由于主机开启了路由转发，导致ce1800v发送到主机RA参数不生效。

![](/images/ipv-kernel-para/clip_image004.jpg)

## 解决方案：

将accept_ra置为2。

 

# 重启网卡或者network时，ipv6默认路由没有立即生成问题

重启network时，ipv6路由没有立即获取到fe80的默认路由，如下图：

![](/images/ipv-kernel-para/clip_image006.jpg)

大约7分钟左右，主机会生成到fe80的路由。此时间和华为RA通告的时间间隔基本一致。


## 原因：

主机开启ipv6路由转发（net.ipv6.conf.all.forwarding=1）后，系统不再主动发起RS请求报文。

## 解决方案：

关闭ipv6路由转发（net.ipv6.conf.all.forwarding=0）。