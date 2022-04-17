---
title: Openstack和Kubernetes融合部署（1） - 准备工作
categories: 云原生
tags:
  - deploy
  - Openstack
  - Kubernetes
  - minikube
date: 2022-04-14 08:02:45
---

# 融合部署实践计划
step1 在自己windows系统的电脑上用vmware起一个ubuntu虚拟机 或者 centos虚拟机

step2 虚拟机里部署openstack all-in-one：尝试2种方式：devstack 和 kolla-ansible

step3 openstack起N+M个vm，用于部署Kubernetes，N个master + M个worker

step4 Kubernetes中部署helm-openstack

总结：windows下 起 单个ubuntu虚拟机，ubuntu虚拟机部署单节点Openstack，单节点Openstack起N+M个vm作为Kubernetes的N个master+M个worker节点，N+M个节点的Kubernetes上部署Openstack。同时实践了容器化部署Openstack，虚拟化部署Kubernetes，kubernetes部署Openstack三件事情。

# 准备工作 - 虚拟机借助宿主机翻墙
很多包是国内访问受限，要流畅部署，最方便的是搭梯子。

所以在做 step2 前要做些准备工作：翻墙（特别是要让vmware中的虚拟机可以翻墙）

翻墙vpn软件很多，本文不是介绍这方面的文章，跳过。介绍下宿主机已经具备翻墙的前提下，如何让vmware中的虚拟机可以借助宿主机翻墙。

> 若VPN可以安装在虚拟机中可以跳过。以下适用于虚拟机又不能直接安装VPN 或者 VPN多终端使用受限的情况。

## 虚拟机借助宿主机翻墙原理
由于桥接模式，NAT模式，host-only模式类似，以NAT模式介绍原理。
![](/images/fusion-deploy1/a7438588.png)
当登录VPN时，则主机的部分（也可能是所有）数据会先走VPN再出主机网卡。其网络结构如下图所示。可知，虚拟机的数据始终不会通过VPN。
![](/images/fusion-deploy1/9abc1dc7.png)
通过共享VPN虚拟网卡给VMnet8，则虚拟机便可使用VPN与目的网络进行通信。其网络结果如下图所示。
![](/images/fusion-deploy1/080d2480.png)
不止是VMnet8，采用“仅主机模式”，原理也同样适用。

## 虚拟机借助宿主机翻墙实操
控制面板\网络和 Internet\网络连接
右击vpn对应的网络适配器，选择属性，选择第二个标签`共享`，选中`运行其他网络用户通过此计算机的Internet连接来连接`，下面选虚拟机要用的网络适配器，点击确认。

接下来右击虚拟机连接的网络适配器，选择属性，查看ip地址，应该是192.168.137.1

登录vmware虚拟机，网络不要用DHCP配置的，用手动分配的192.168.137.0/24网段的。

    #BOOTPROTO=DHCP
    BOOTPROTO=STATIC
    IPADDR=192.168.137.10
    PREFIX=24
    GATEWAY=192.168.137.1

> 若是虚拟机有多块网卡，将192.168.137.0/24网段的网卡配成默认路由器。

## 虚拟机借助宿主机翻墙测试

### 网页测试
测试 `curl https://www.youtube.com/channel/UCw2MGqCYN_xyCpVMnNoLhWA` 发现可以获取一堆数据，虚拟机借助宿主机翻墙成功。

### docker和k8s包获取测试 - 使用minikube快速部署单机版k8s
在做 step2 前，可以先部署个minikube试试vpn是否好使。

minikube需要docker环境

升级docker，若新装跳过

    yum remove dockerdocker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
    rm -rf /var/lib/docker/

安装最新版docker

    yum install -y yum-utils
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install docker-ce docker-ce-cli containerd.io
    systemctl start docker && systemctl enable docker && systemctl status docker



minikube不能直接用root账号部署，需要创建一个属于docker组的账号，这里创建一个developer账号

    #创建developer账号
    adduser developer
    passwd developer  #修改密码
    usermod -aG wheel developer
    #创建docker组，并将developer账号添加到docker组中
    su - developer
    sudo groupadd docker
    sudo usermod -aG docker $USER
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube

```bash
[developer@localhost ~]$ minikube start  --driver=docker --preload=false
* minikube v1.25.2 on Centos 7.9.2009
* Using the docker driver based on user configuration
* Starting control plane node minikube in cluster minikube
* Pulling base image ...
  > gcr.io/k8s-minikube/kicbase: 379.06 MiB / 379.06 MiB  100.00% 704.16 KiB
* Creating docker container (CPUs=2, Memory=2200MB) ...| E0413 08:01:17.916471    2259 cache.go:217] Error caching images:  Caching images for kubeadm: caching images: caching image "/home/developer/.minikube/cache/images/amd64/docker.io/kubernetesui/metrics-scraper_v1.0.7": write: Get "https://index.docker.io/v2/kubernetesui/metrics-scraper/blobs/sha256:1930c20668a899918b711b39b3d38cccf7ac555cc9ed3a54cd97c64fdabb5837": EOF
* Preparing Kubernetes v1.23.3 on Docker 20.10.12 ...
    - kubelet.housekeeping-interval=5m
      X Unable to load cached images: loading cached images: stat /home/developer/.minikube/cache/images/amd64/docker.io/kubernetesui/metrics-scraper_v1.0.7: no such file or directory
      > kubectl.sha256: 64 B / 64 B [--------------------------] 100.00% ? p/s 0s
      > kubelet.sha256: 64 B / 64 B [--------------------------] 100.00% ? p/s 0s
      > kubeadm.sha256: 64 B / 64 B [--------------------------] 100.00% ? p/s 0s
      > kubectl: 44.43 MiB / 44.43 MiB [-------------] 100.00% 983.21 KiB p/s 46s
      > kubeadm: 43.12 MiB / 43.12 MiB [------------] 100.00% 351.20 KiB p/s 2m6s
      > kubelet: 118.75 MiB / 118.75 MiB [---------] 100.00% 690.57 KiB p/s 2m56s
    - Generating certificates and keys ...
    - Booting up control plane ...
    - Configuring RBAC rules ...
* Verifying Kubernetes components...
    - Using image gcr.io/k8s-minikube/storage-provisioner:v5
* Enabled addons: default-storageclass, storage-provisioner
* kubectl not found. If you need it, try: 'minikube kubectl -- get pods -A'
* Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```

检查 minikube 状态
```bash
[developer@localhost ~]$ curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
[developer@localhost ~]$ chmod +x ./kubectl
[developer@localhost ~]$ sudo mv ./kubectl /usr/local/bin/kubectl
[developer@localhost ~]$ minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured

[developer@localhost ~]$ kubectl get node -o wide
NAME       STATUS   ROLES                  AGE     VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION           CONTAINER-RUNTIME
minikube   Ready    control-plane,master   4m51s   v1.23.3   192.168.49.2   <none>        Ubuntu 20.04.2 LTS   3.10.0-1160.el7.x86_64   docker://20.10.12
[developer@localhost ~]$ kubectl get pod --all-namespaces
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   coredns-64897985d-slpgj            1/1     Running   0          4m38s
kube-system   etcd-minikube                      1/1     Running   0          4m50s
kube-system   kube-apiserver-minikube            1/1     Running   0          4m50s
kube-system   kube-controller-manager-minikube   1/1     Running   0          4m50s
kube-system   kube-proxy-9v7q5                   1/1     Running   0          4m38s
kube-system   kube-scheduler-minikube            1/1     Running   0          4m50s
kube-system   storage-provisioner                1/1     Running   0          4m48s
[developer@localhost ~]$ ssh root@$(minikube ip)
The authenticity of host '192.168.49.2 (192.168.49.2)' can't be established.
ECDSA key fingerprint is SHA256:GVF6b6EEpMDMDtYRJ/x8LdHaFytmzSx6/bLd8XF/ZsA.
ECDSA key fingerprint is MD5:38:22:ab:67:d5:ee:75:17:a2:f9:28:38:eb:0b:28:78.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.49.2' (ECDSA) to the list of known hosts.
root@192.168.49.2's password:
root@minikube:~#
```