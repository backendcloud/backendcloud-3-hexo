---
title: Kubernetes 运维遇到的问题记录（2）
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