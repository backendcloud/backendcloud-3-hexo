---
title: nsenter
readmore: true
date: 2022-05-23 10:37:06
categories:
tags:
---

# nsenter 使用实例
## 进入 docker 容器的 namespace 中运行指定程序
使用 nsenter 进入 docker 容器的 namespace 是非常简单的，通常你只需要以下两步：

    # 获取相应的 Dokcer 容器的 PID
    $ PID=$(docker inspect --format {{.State.Pid}} <container_name_or_ID>)
    # 使用相应参数进入程序所在的不同 NameSpace
    $ nsenter -m -u -i -n -p -t $PID <command>

下面我们来看几个实例:

### 进入指定程序所在的所有命名空间

    $ docker run --rm --name test -d busybox  sleep 10000
    8115009baccc53a2a5f6dfff642e0d8ab1dfb95dde473d14fb9a06ce4e89364c
    
    $ docker ps |grep busybox
    8115009baccc        busybox             "sleep 10000"            9 seconds ago       Up 8 seconds                            test
    
    $ PID=$(docker inspect --format {{.State.Pid}} 8115009baccc)
    
    $ nsenter -m -u -i -n -p -t $PID ps aux
    PID   USER     TIME  COMMAND
    1 root      0:00 sleep 10000
    7 root      0:00 ps aux
    
    $ nsenter -m -u -i -n -p -t $PID hostname
    8115009baccc

### 进入指定程序所在的网络命名空间
运行一个 Nginx 容器，查看该容器的 Pid：

    $ docker inspect -f {{.State.Pid}} nginx
    5645

然后，使用 nsenter 命令进入该容器的网络命令空间：

    $ nsenter -n -t5645
    $ ip addr
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
    valid_lft forever preferred_lft forever
    18: eth0@if19: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
    valid_lft forever preferred_lft forever

## 进入 Kubernetes 容器的 namespace 中运行指定程序
如果是在 Kubernetes 中，在得到容器 Pid 之前，你还需先获取容器的 ID，可以使用如下命令获取：

    $ kubectl get pod nginx -n web -o yaml|grep containerID
    - containerID: docker://cf0873782d587dbca6aa32f49605229da3748600a9926e85b36916141597ec85
    
      或者更为精确地获取 containerID：
    
    $ kubectl get pod nginx -n web -o template --template='{{range .status.containerStatuses}}{{.containerID}}{{end}}'
    docker://cf0873782d587dbca6aa32f49605229da3748600a9926e85b36916141597ec85

其它的步骤就和前面进入 Docker 容器的命名空间类似了。
