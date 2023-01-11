---
title: Kubernetes 运维记录（2）
readmore: false
date: 2022-11-17 18:56:08
categories: 云原生
tags:
- 运维
---

# CentOS Stream 8 Pod 网络跨节点不通

环境信息：
* OS: CentOS Stream 8
* K8S CNI: calico 

一样的部署，在 CentOS 7 上正常，一旦切换到 CentOS Stream 8，就网络异常。具体表现为node->其它节点pod、pod->其它node不通，但是本节点到pod是可以通信的。

解决方案：

参考： https://github.com/projectcalico/calico/issues/3709


**iptables-legacy 和 iptables-nft**

iptables-legacy 和 iptables-nft 是iptables命令的两个版本。两者不能同时使用，只能二选一，centos7 默认iptables-legacy，centos8 默认iptables-nft，iptables-nft和iptables-legacy是不一样的东西，iptables-nft是iptables-legacy的升级版。虽然命令完全一样，iptables-nft 100%兼容了iptables-legacy的命令格式。

> 小标题准确说应该是iptables 和 iptables-nft，从 iptables 1.8 开始，iptables 命令行客户端有两种不同的版本/模式：“legacy”，它使用内核 iptables API，就像 iptables 1.6 和更早版本一样，“nft”，它将 iptables 命令行 API 转换为内核 nftables API。未了好区分，姑且用iptables-legacy 和 iptables-nft。

要查看操作系统用的是iptables-legacy还是iptables-legacy。两种方式：

一种是 iptables -V 命令。一般带nf_tables的是iptables-nft，不带的是iptables-legacy。

```bash
[root@k8s-11 ~]# iptables -V
iptables v1.4.21
```

```bash
root@rhel-8 # iptables -V
iptables v1.8.4 (nf_tables)
```

另一种是 ls -al /usr/sbin/iptables 命令，带nft的是iptables-nft，不带的是iptables-legacy。

```bash
[root@k8s-11 ~]# ls -al /usr/sbin/iptables
lrwxrwxrwx. 1 root root 13 Jan 21  2022 /usr/sbin/iptables -> xtables-multi
```

```bash
root@rhel-8 # ls -al /usr/sbin/iptables
lrwxrwxrwx. 1 root root 17 Mar 17 10:22 /usr/sbin/iptables -> xtables-nft-multi
```



在calico-node中添加环境变量解决问题：

```yaml
env:
 - name: FELIX_IPTABLESBACKEND
   value: NFT
```

在RHEL 8系中iptables版本为1.8.2，基于nftables。 并且RHEL 8系不提供切换到legacy模式的方式。

CNI插件（calico）若使用iptables，需要加上上面的环境变量。

> 默认该环境变量是auto，但是auto的检测机制还不太完善，会有问题。不知道最新版改好了没有。

## 附：calico网络故障排错一般分析思路

如果跨节点 Calico Pod 网络不通：Pod A （宿主机是Host A）到 Pod B（宿主机是Host B） 网络不通，间网络不通常见的原因是：
* Pod 内的路由丢失
* Host 路由丢失
* iptables 规则问题
* IPVS 规则问题
* IP 冲突
* Pod 网卡停止工作
* ARP 表错误
* Core DNS 解析问题
* 流量转发表问题


# 为什么Kubernetes CNI用calico的时候，所有的pod都有一个到169.254.1.1的路线？

在 Calico 网络中，每台主机都充当其承载的工作负载的网关路由器。在容器部署中，Calico 使用169.254.1.1作为 Calico 路由器的地址。通过使用链路本地地址，Calico 节省了宝贵的 IP 地址，避免了用户配置合适地址的负担。虽然对于习惯于配置 LAN 网络的人来说，路由表可能看起来有点奇怪，但是在 WAN 网络中使用显式路由而不使用子网本地网关是相当常见的。

calico为所有pod分配相同名称的interface：cali0，并且calico0上分配相同的mac地址：ee:ee:ee:ee:ee:ee，因为 calico 只关心三层的 IP 地址，根本不关心二层 MAC 地址。并且分配了相同的默认路由 default via 169.254.1.1 dev cali0

所有的报文都会经过 cali0 发送到下一跳 169.254.1.1（这是预留的本地 IP 网段），这是 calico 为了简化网络配置做的选择，容器里的路由规则都是一样的，不需要动态更新。

cali0 是 veth pair 的一端，其对端是主机上 caliXXXX 命名的 interface，可以通过 ethtool -S cali0 列出对端的 interface idnex。

然后在宿主机上可以查到interface为idnex的网卡信息，查看宿主机该网卡信息，这个 interface 有一个随机分配的 MAC 地址，但是没有IP地址。该interface接收到 ARP 请求后，它直接进行了应答，应答报文中 MAC 地址是 该 interface 的 MAC 地址。换句话说，它把自己的 MAC 地址作为应答返回给容器。容器的后续报文 IP 地址还是目的容器，但是 MAC 地址就变成了主机上该 interface 的地址，也就是说所有的报文都会发给主机，然后主机根据 IP 地址进行转发。

主机这个 interface 不管 ARP 请求的内容，直接用自己的 MAC 地址作为应答的行为被成为 ARP proxy，是 calico 开启的，可以通过下面的命令确认：

```bash
# cat /proc/sys/net/ipv4/conf/calif24874aae57/proxy_arp
1
```

总的来说，可以认为 calico 把主机作为容器的默认网关来使用，所有的报文发到主机，然后主机根据路由表进行转发。和经典的网络架构不同的是，calico 并没有给默认网络配置一个 IP 地址（这样每个网络都会额外消耗一个 IP 资源，而且主机上也会增加对应的 IP 地址和路由信息），而是通过 arp proxy 和修改容器路由表来实现。

主机的 interface 接收到报文之后，下面的事情就容易理解了，所有的报文会根据宿主机的路由表来走。

# cni路径问题分析导致Pod创建报错

创建pod的时候报错：

```bash
remote_runtime.go:116] "RunPodSandbox from runtime service failed" err="rpc error: code = Unknown desc = failed to setup network for sandbox 
```

原因分析：

是容器引擎docker切换为containerd，两者CNI bin path不一致导致。

kubelet的参数 kubernetes/kubelet.env 配置为 --cni-bin-dir=/etc/cni/bin

calico-node部署yaml：

```yaml
      volumes:
      - hostPath:
          path: /etc/cni/bin
          type: ""
        name: cni-bin-dir
      - hostPath:
          path: /etc/cni/net.d
          type: ""
        name: cni-net-dir
```

containerd 的cni bin文件 放在了 /opt/cni/bin。做个目录的软链或者配置下新的目录路径。

# namespace 或 ingress 长时间 删除不掉 

可以删除资源对应的yaml文件中的finalizers里的内容，即可删除。

> 这种方式简单，暴力。但是Kubernetes用这个字段设计了删除拦截器，需要等待这个字段里的资源都被清除了才能真正删除。所以有条件最好分析下不能删除的具体原因，找出原因，自然就可以删除了。