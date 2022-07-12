---
title: 一步步学KubeVirt CI （4） - Podman
readmore: true
date: 2022-07-11 19:17:40
categories: 云原生
tags:
- KubeVirt CI
---


# Why Podman

因为使用Docker Daemon运行Docker有以下这些问题：
* Docker 运行在单个进程上，这可能会导致单点故障。
* 所有子进程都归属于此进程。
* 无论何时，如果 Docker 守护进程失败，所有子进程都会失去跟踪并进入孤立状态。
* 安全漏洞。
* 对于 Docker 的操作，所有步骤都需要由 root 执行。

CentOS Stream 8/9 默认用Podman代替Docker。

# Podman CLI

podman和docker cli命令几乎完全一致，常用命令基本感觉不到区别。Podman CLI 里面87%的指令都和Docker CLI 相同。
* podman ps
* podman images
* podman run -dit the-image
* podman exec -it the-container
* podman rm/rmi the-container/the-image
* podman container prune 清理所有处于终止状态的容器
* podman export the-container-id > xx.tar 导出本地某个容器
* podman cat xx.tar | docker import - test/yyy:v1.0 从容器快照文件中再导入为镜像

# 搭建私有仓库

若docker.io速度慢，可以搭建私有仓库，若用不到harbor重型私有仓库，搭建个官方自带的轻量的私有仓库。

    podman run -d -p 5000:5000 --name registry registry:2

# Podman - http: server gave HTTP response to HTTPS client

私有仓库推送镜像的时候失败，报了常见的错误：

pinging container registry localhost:5000: Get "https://localhost:5000/v2/": http: server gave HTTP response to HTTPS client

解决办法：

编辑 /etc/containers/registries.conf 增加：

```toml
[[registry]]
location = "localhost:5000"
insecure = true
```

```bash
 ⚡ root@localhost  ~/CLionProjects/untitled/src   master ±✚  podman system info|grep Inse -B3 -A5 
registries:
  localhost:5000:
    Blocked: false
    Insecure: true
    Location: localhost:5000
    MirrorByDigestOnly: false
    Mirrors: null
    Prefix: localhost:5000
    PullFromMirror: ""
```

再用podman push镜像就可以成功。例如：

```bash
 ⚡ root@localhost  /dev/pts  podman push localhost:5000/hello:2
Getting image source signatures
Copying blob 24302eb7d908 done  
Copying blob a11c8f043ca5 done  
Copying config a37976309a done  
Writing manifest to image destination
Storing signatures
 ⚡ root@localhost  /dev/pts  podman pull localhost:5000/hello:2
Trying to pull localhost:5000/hello:2...
Getting image source signatures
Copying blob 86c185ae0c15 skipped: already exists  
Copying blob 4794e514b721 skipped: already exists  
Copying config a37976309a done  
Writing manifest to image destination
Storing signatures
a37976309a6375e3107bf0c89cc373d6c0b953b6596238006aabf0ac3bcfa762
```

# DNS

```bash
 ⚡ root@localhost  /dev/pts  podman exec -it d4df0ba3f7e5 sh
/ # mount|grep hosts
tmpfs on /etc/hosts type tmpfs (rw,seclabel,size=2469232k,nr_inodes=819200,mode=755,inode64)
/ # mount|grep hostname
tmpfs on /etc/hostname type tmpfs (rw,seclabel,size=2469232k,nr_inodes=819200,mode=755,inode64)
/ # mount|grep resolv
tmpfs on /etc/resolv.conf type tmpfs (rw,seclabel,size=2469232k,nr_inodes=819200,mode=755,inode64)
```

这种mount这种机制可以让宿主主机 DNS 信息发生更新后，所有 Podman 容器的 DNS 配置通过 /etc/resolv.conf 文件立刻得到更新。

如果用户想要手动指定容器的配置，可以在使用 Podman run 命令启动容器时加入如下参数：

-h HOSTNAME 或者 --hostname=HOSTNAME 设定容器的主机名，它会被写到容器内的 /etc/hostname 和 /etc/hosts。但它在容器外部看不到，既不会在 Podman container ls 中显示，也不会在其他的容器的 /etc/hosts 看到。

--dns=IP_ADDRESS 添加 DNS 服务器到容器的 /etc/resolv.conf 中，让容器用这个服务器来解析所有不在 /etc/hosts 中的主机名。

--dns-search=DOMAIN 设定容器的搜索域，当设定搜索域为 .example.com 时，在搜索一个名为 host 的主机时，DNS 不仅搜索 host，还会搜索 host.example.com。

> 如果在容器启动时没有指定最后两个参数，Podman 会默认用主机上的 /etc/resolv.conf 来配置容器。



# Podman网络

Podman 服务默认会创建一个 podman0 网桥，它在内核层连通了其他的物理或虚拟网卡，这就将所有容器和本地主机都放到同一个物理网络。

    ⚡ root@localhost  ~/CLionProjects/untitled/src   master ±✚  podman network ls
    NETWORK ID    NAME        DRIVER
    2f259bab93aa  podman      bridge
    ⚡ root@localhost  ~/CLionProjects/untitled/src   master ±✚  ip a
    ...
    3: podman0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
        link/ether 4e:41:72:5c:b5:0e brd ff:ff:ff:ff:ff:ff
        inet 10.88.0.1/16 brd 10.88.255.255 scope global podman0
        valid_lft forever preferred_lft forever
        inet6 fe80::8c2b:79ff:fe70:516f/64 scope link 
        valid_lft forever preferred_lft forever
    ...

默认情况下，Podman 会将所有容器连接到由 podman0 提供的虚拟子网中。

用户有时候需要两个容器之间可以直连通信，而不用通过主机网桥进行桥接。

解决办法很简单：创建一对 peer 接口，分别放到两个容器中，配置成点到点链路类型即可。

```bash
 ⚡ root@localhost  /dev/pts  podman run -itd --name c1  --net=none alpine
35e6e1f8a922e06a7b8979b1c35d3aa382fb307f7cf29fedadafa6a4514bea6e
 ⚡ root@localhost  /dev/pts  podman run -itd --name c2  --net=none alpine
8f6c1220f6d02e52507236d1d0490b52441cf6725d5d775994c3057175a635d4
 ✘ ⚡ root@localhost  ~/CLionProjects/untitled/src   master ±✚  docker exec -it c1 sh  
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
/ # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
/ # 
```

找到进程号，然后创建网络命名空间的跟踪文件。创建一对 peer 接口，然后配置路由。

```bash
 ⚡ root@localhost  /dev/pts  podman inspect -f '{{.State.Pid}}' c1
42753
 ⚡ root@localhost  /dev/pts  podman inspect -f '{{.State.Pid}}' c2
42807
 ⚡ root@localhost  /dev/pts  ll /proc/42807/ns/net
lrwxrwxrwx. 1 root root 0 Jul 11 14:37 /proc/42807/ns/net -> 'net:[4026532934]'
 ⚡ root@localhost  /dev/pts  mkdir -p /var/run/netns
 ⚡ root@localhost  /dev/pts  ln -s /proc/42753/ns/net /var/run/netns/42753
 ⚡ root@localhost  /dev/pts  ln -s /proc/42807/ns/net /var/run/netns/42807
 ⚡ root@localhost  /dev/pts  ip link add A type veth peer name B
 ⚡ root@localhost  /dev/pts  ip link set A netns 42753
 ⚡ root@localhost  /dev/pts  ip netns exec 42753 ip addr add 10.1.1.1/32 dev A
 ⚡ root@localhost  /dev/pts  ip netns exec 42753 ip link set A up
 ⚡ root@localhost  /dev/pts  ip netns exec 42753 ip route add 10.1.1.2/32 dev A
 ⚡ root@localhost  /dev/pts  ip link set B netns 42907
RTNETLINK answers: No such process
 ✘ ⚡ root@localhost  /dev/pts  ip link set B netns 42807
 ⚡ root@localhost  /dev/pts  ip netns exec 42807 ip addr add 10.1.1.2/32 dev B
 ⚡ root@localhost  /dev/pts  ip netns exec 42807 ip link set B up
 ⚡ root@localhost  /dev/pts  ip netns exec 42807 ip route add 10.1.1.1/32 dev B
```

现在这 2 个容器就可以相互 ping 通，并成功建立连接。点到点链路不需要子网和子网掩码。

```bash
 ⚡ root@localhost  ~/CLionProjects/untitled/src   master ±✚  podman exec -it c1 sh
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
/ # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
41: A@if40: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP qlen 1000
    link/ether 96:c6:c1:f4:4d:0f brd ff:ff:ff:ff:ff:ff
    inet 10.1.1.1/32 scope global A
       valid_lft forever preferred_lft forever
    inet6 fe80::94c6:c1ff:fef4:4d0f/64 scope link 
       valid_lft forever preferred_lft forever
/ # ping 10.1.1.2
PING 10.1.1.2 (10.1.1.2): 56 data bytes
64 bytes from 10.1.1.2: seq=0 ttl=64 time=0.153 ms
64 bytes from 10.1.1.2: seq=1 ttl=64 time=0.045 ms
64 bytes from 10.1.1.2: seq=2 ttl=64 time=0.046 ms
```

此外，也可以不指定 --net=none 来创建点到点链路。这样容器还可以通过原先的网络来通信。
