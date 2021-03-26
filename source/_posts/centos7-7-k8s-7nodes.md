title: CentOS7.7部署k8s（3 master + 3 node + 1 client）
date: 2020-04-13 13:46:34
categories:
- 容器
tags:
- CentOS7.7
- k8s
---

VMware创建7个vm，规格2cpu 2G mem 200G disk，一个NAT网卡

环境说明：

主机名	操作系统版本	ip	备注
master01	Centos 7.7.1908	192.168.174.159	master主机
master02	Centos 7.7.1908	192.168.174.160	master主机
master03	Centos 7.7.1908	192.168.174.161	master主机
（VIP 192.168.174.200	在3个master节点上浮动）
work01	Centos 7.7.1908	192.168.174.162	worker节点
work02	Centos 7.7.1908	192.168.174.163	worker节点
work03	Centos 7.7.1908	192.168.174.164	worker节点
client	Centos 7.7.1908	192.168.174.165	client节点

![jpg](/images/centos7-7-k8s-7nodes/1.png)

# 前期准备（所有节点）
## 修改主机名（若安装os的时候已经修改过，则跳过）

    # hostnamectl set-hostname <hostname>

## 修改hosts文件

    # cat << EOF >> /etc/hosts
    192.168.174.159 master01
    192.168.174.160 master02
    192.168.174.161 master03
    192.168.174.162 work01
    192.168.174.163 work02
    192.168.174.164 work03
    192.168.174.165 client
    192.168.174.200 master
    EOF
    
## 安装常用基础包vim，wget，yum-utils，device-mapper-persistent-data，lvm2，bash-completion

    # yum install -y vim wget yum-utils device-mapper-persistent-data lvm2 bash-completion
    # source /etc/profile.d/bash_completion.sh

## 关闭防火墙，selinux，swap

    # systemctl stop firewalld
    # systemctl disable firewalld 
    # setenforce 0
    SELINUX=enforcing修改成SELINUX=disabled
    # sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
    # swapoff -a
    # sed -i.bak '/swap/s/^/#/' /etc/fstab
    
## 免密登陆

    第一个节点执行
    # ssh-keygen -t rsa
    回车回车到结束
    秘钥同步至其他节点
    ssh-copy-id -i /root/.ssh/id_rsa.pub root@<其他节点>
    免密登陆测试
    第一个节点执行
    # ssh <其他节点的ip>
    # ssh <其他节点的hostname>    

# 安装docker（所有节点）
## 设置docker源

    # yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    
<!--more-->
    
## 安装Docker CE

    # yum list docker-ce --showduplicates | sort -r
    # yum install -y docker-ce-18.09.6 docker-ce-cli-18.09.6 containerd.io

## 启动docker

    # systemctl start docker
    # systemctl enable docker

## 配置国内镜像加速
登陆地址为：https://cr.console.aliyun.com ,未注册的可以先注册阿里云账户
点击左下角的`镜像中心`的`镜像加速器`

    # mkdir -p /etc/docker
    # sudo tee /etc/docker/daemon.json <<-'EOF'
    {
      "registry-mirrors": ["https://w6pljua0.mirror.aliyuncs.com"]
    }
    EOF 
    # systemctl daemon-reload
    # systemctl restart docker
    
## 验证docker安装

    # docker --version
    # docker run hello-world

# keepalived安装

    master01, master02, master03分别执行
    # yum -y install keepalived
    master01上执行
    # cat /etc/keepalived/keepalived.conf 
    ! Configuration File for keepalived
    global_defs {
       router_id master01
    }
    vrrp_instance VI_1 {
        state MASTER 
        interface ens33
        virtual_router_id 50
        priority 100
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        virtual_ipaddress {
            192.168.174.200
        }
    }
    # cat /etc/keepalived/keepalived.conf 
    ! Configuration File for keepalived
    global_defs {
       router_id master02
    }
    vrrp_instance VI_1 {
        state BACKUP 
        interface ens33
        virtual_router_id 50
        priority 90
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        virtual_ipaddress {
            192.168.174.200
        }
    }
    # cat /etc/keepalived/keepalived.conf 
    ! Configuration File for keepalived
    global_defs {
       router_id master03
    }
    vrrp_instance VI_1 {
        state BACKUP 
        interface ens33
        virtual_router_id 50
        priority 80
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        virtual_ipaddress {
            192.168.174.200
        }
    # service keepalived start
    # systemctl enable keepalived    
    vip查看
    # ip a
    

# k8s安装前的准备工作（所有节点）
## 内核参数修改

    # cat <<EOF >  /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    EOF
    # sysctl -p /etc/sysctl.d/k8s.conf

## 修改Cgroup Driver

    # vim /etc/docker/daemon.json
    新增‘"exec-opts": ["native.cgroupdriver=systemd"’
    # cat /etc/docker/daemon.json 
    {
        "registry-mirrors": ["https://v16stybc.mirror.aliyuncs.com"],
        "exec-opts": ["native.cgroupdriver=systemd"]
    }

## 重新加载docker

    # systemctl daemon-reload
    # systemctl restart docker
    修改cgroupdriver是为了消除告警：
    [WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd". Please follow the guide at https://kubernetes.io/docs/setup/cri/

## 设置kubernetes源

    # cat <<EOF > /etc/yum.repos.d/kubernetes.repo
    [kubernetes]
    name=Kubernetes
    baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
    EOF
    # yum clean all
    # yum -y makecache
    
# 安装k8s（Master节点, work节点）

    # yum list kubelet --showduplicates | sort -r
    # yum install -y kubelet-1.16.4 kubeadm-1.16.4 kubectl-1.16.4
    启动kubelet并设置开机启动
    # systemctl enable kubelet && systemctl start kubelet
    kubelet命令补全
    # echo "source <(kubectl completion bash)" >> ~/.bash_profile
    # source .bash_profile 
    编辑下载镜像的脚本
    # cat image.sh
    #!/bin/bash
    url=registry.cn-hangzhou.aliyuncs.com/loong576
    version=v1.16.4
    images=(`kubeadm config images list --kubernetes-version=$version|awk -F '/' '{print $2}'`)
    for imagename in ${images[@]} ; do
      docker pull $url/$imagename
      docker tag $url/$imagename k8s.gcr.io/$imagename
      docker rmi -f $url/$imagename
    done 
    # chmod u+x image.sh
    # ./image.sh
    # docker images
    REPOSITORY                           TAG                 IMAGE ID            CREATED             SIZE
    k8s.gcr.io/kube-proxy                v1.14.2             5c24210246bb        10 months ago       82.1MB
    k8s.gcr.io/kube-apiserver            v1.14.2             5eeff402b659        10 months ago       210MB
    k8s.gcr.io/kube-controller-manager   v1.14.2             8be94bdae139        10 months ago       158MB
    k8s.gcr.io/kube-scheduler            v1.14.2             ee18f350636d        10 months ago       81.6MB
    k8s.gcr.io/coredns                   1.3.1               eb516548c180        15 months ago       40.3MB
    k8s.gcr.io/etcd                      3.3.10              2c4adeb21b4f        16 months ago       258MB
    k8s.gcr.io/pause                     3.1                 da86e6ba6ca1        2 years ago         742kB
    
# 初始化Master(仅在master01节点执行)

    # cat kubeadm-config.yaml 
    apiVersion: kubeadm.k8s.io/v1beta2
    kind: ClusterConfiguration
    kubernetesVersion: v1.16.4
    apiServer:
      certSANs:    #填写所有kube-apiserver节点的hostname、IP、VIP
      - master01
      - master02
      - master03
      - work01
      - work02
      - work03
      - 192.168.174.159
      - 192.168.174.160
      - 192.168.174.161
      - 192.168.174.162
      - 192.168.174.163
      - 192.168.174.164
      - 192.168.174.200
    controlPlaneEndpoint: "192.168.174.200:6443"
    networking:
      podSubnet: "10.244.0.0/16"
    # kubeadm init --config=kubeadm-config.yaml
    [init] Using Kubernetes version: v1.16.4
    [preflight] Running pre-flight checks
    [preflight] Pulling images required for setting up a Kubernetes cluster
    [preflight] This might take a minute or two, depending on the speed of your internet connection
    [preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
    [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
    [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
    [kubelet-start] Activating the kubelet service
    [certs] Using certificateDir folder "/etc/kubernetes/pki"
    [certs] Generating "ca" certificate and key
    [certs] Generating "apiserver" certificate and key
    [certs] apiserver serving cert is signed for DNS names [master01 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local master01 master02 master03 work01 work02 work03] and IPs [10.96.0.1 192.168.174.159 192.168.174.200 192.168.174.159 192.168.174.160 192.168.174.161 192.168.174.162 192.168.174.163 192.168.174.164 192.168.174.200]
    [certs] Generating "apiserver-kubelet-client" certificate and key
    [certs] Generating "front-proxy-ca" certificate and key
    [certs] Generating "front-proxy-client" certificate and key
    [certs] Generating "etcd/ca" certificate and key
    [certs] Generating "etcd/server" certificate and key
    [certs] etcd/server serving cert is signed for DNS names [master01 localhost] and IPs [192.168.174.159 127.0.0.1 ::1]
    [certs] Generating "etcd/peer" certificate and key
    [certs] etcd/peer serving cert is signed for DNS names [master01 localhost] and IPs [192.168.174.159 127.0.0.1 ::1]
    [certs] Generating "etcd/healthcheck-client" certificate and key
    [certs] Generating "apiserver-etcd-client" certificate and key
    [certs] Generating "sa" key and public key
    [kubeconfig] Using kubeconfig folder "/etc/kubernetes"
    [kubeconfig] Writing "admin.conf" kubeconfig file
    [kubeconfig] Writing "kubelet.conf" kubeconfig file
    [kubeconfig] Writing "controller-manager.conf" kubeconfig file
    [kubeconfig] Writing "scheduler.conf" kubeconfig file
    [control-plane] Using manifest folder "/etc/kubernetes/manifests"
    [control-plane] Creating static Pod manifest for "kube-apiserver"
    [control-plane] Creating static Pod manifest for "kube-controller-manager"
    [control-plane] Creating static Pod manifest for "kube-scheduler"
    [etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
    [wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
    [apiclient] All control plane components are healthy after 19.501964 seconds
    [upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
    [kubelet] Creating a ConfigMap "kubelet-config-1.16" in namespace kube-system with the configuration for the kubelets in the cluster
    [upload-certs] Skipping phase. Please see --upload-certs
    [mark-control-plane] Marking the node master01 as control-plane by adding the label "node-role.kubernetes.io/master=''"
    [mark-control-plane] Marking the node master01 as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
    [bootstrap-token] Using token: l1x9vx.bbqycpviej5ya31s
    [bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
    [bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
    [bootstrap-token] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
    [bootstrap-token] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
    [bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
    [addons] Applied essential addon: CoreDNS
    [addons] Applied essential addon: kube-proxy
    
    Your Kubernetes control-plane has initialized successfully!
    
    To start using your cluster, you need to run the following as a regular user:
    
      mkdir -p $HOME/.kube
      sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
      sudo chown $(id -u):$(id -g) $HOME/.kube/config
    
    You should now deploy a pod network to the cluster.
    Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
      https://kubernetes.io/docs/concepts/cluster-administration/addons/
    
    You can now join any number of control-plane nodes by copying certificate authorities
    and service account keys on each node and then running the following as root:
    
      kubeadm join 192.168.174.200:6443 --token l1x9vx.bbqycpviej5ya31s \
        --discovery-token-ca-cert-hash sha256:396670c9fa96a5866aaeedc2a69b767aa0d751c6d55c6f8e8bc37e8f230ec5f0 \
        --control-plane
    
    Then you can join any number of worker nodes by running the following on each as root:
    
    kubeadm join 192.168.174.200:6443 --token l1x9vx.bbqycpviej5ya31s \
        --discovery-token-ca-cert-hash sha256:396670c9fa96a5866aaeedc2a69b767aa0d751c6d55c6f8e8bc37e8f230ec5f0
    
    如果初始化失败，可执行kubeadm reset后重新初始化
    # kubeadm reset
    # rm -rf $HOME/.kube/config  
    加载环境变量
    # echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bash_profile
    # source .bash_profile 
    安装pod网络
    # kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
    podsecuritypolicy.policy/psp.flannel.unprivileged created
    clusterrole.rbac.authorization.k8s.io/flannel created
    clusterrolebinding.rbac.authorization.k8s.io/flannel created
    serviceaccount/flannel created
    configmap/kube-flannel-cfg created
    daemonset.apps/kube-flannel-ds-amd64 created
    daemonset.apps/kube-flannel-ds-arm64 created
    daemonset.apps/kube-flannel-ds-arm created
    daemonset.apps/kube-flannel-ds-ppc64le created
    daemonset.apps/kube-flannel-ds-s390x created
    
https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml 文件可能需要翻墙
也可点击下面链接下载，下载后解压缩
下载[kube-flannel.tar.gz](/files/centos7-7-k8s-7nodes/kube-flannel.tar.gz)
    

# control plane节点加入集群

    在master01上运行脚本cert-main-master.sh，将证书分发至master02和master03
    # cat cert-main-master.sh 
    USER=root # customizable
    CONTROL_PLANE_IPS="192.168.174.160 192.168.174.161"
    for host in ${CONTROL_PLANE_IPS}; do
        scp /etc/kubernetes/pki/ca.crt "${USER}"@$host:
        scp /etc/kubernetes/pki/ca.key "${USER}"@$host:
        scp /etc/kubernetes/pki/sa.key "${USER}"@$host:
        scp /etc/kubernetes/pki/sa.pub "${USER}"@$host:
        scp /etc/kubernetes/pki/front-proxy-ca.crt "${USER}"@$host:
        scp /etc/kubernetes/pki/front-proxy-ca.key "${USER}"@$host:
        scp /etc/kubernetes/pki/etcd/ca.crt "${USER}"@$host:etcd-ca.crt
        # Quote this line if you are using external etcd
        scp /etc/kubernetes/pki/etcd/ca.key "${USER}"@$host:etcd-ca.key
    done
    # chmod u+x cert-main-master.sh
    # ./cert-main-master.sh
    在master02上运行脚本cert-other-master.sh，将证书移至指定目录
    [root@master02 ~]# cat cert-other-master.sh 
    USER=root # customizable
    mkdir -p /etc/kubernetes/pki/etcd
    mv /${USER}/ca.crt /etc/kubernetes/pki/
    mv /${USER}/ca.key /etc/kubernetes/pki/
    mv /${USER}/sa.pub /etc/kubernetes/pki/
    mv /${USER}/sa.key /etc/kubernetes/pki/
    mv /${USER}/front-proxy-ca.crt /etc/kubernetes/pki/
    mv /${USER}/front-proxy-ca.key /etc/kubernetes/pki/
    mv /${USER}/etcd-ca.crt /etc/kubernetes/pki/etcd/ca.crt
    # Quote this line if you are using external etcd
    mv /${USER}/etcd-ca.key /etc/kubernetes/pki/etcd/ca.key
    [root@master02 ~]# chmod u+x cert-other-master.sh
    [root@master02 ~]# ./cert-other-master.sh 
    在master03上也运行脚本cert-other-master.sh
    # ./cert-other-master.sh 
    下面这几条命令在master01节点上执行
    查看令牌
    # kubeadm token list
    发现之前初始化时的令牌已过期
    生成新的令牌
    # kubeadm token create
    wob9v2.2t7fwzg3sdfvbe05
    生成新的加密串
    # openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null |    openssl dgst -sha256
    396670c9fa96a5866aaeedc2a69b767aa0d751c6d55c6f8e8bc37e8f230ec5f0 
    master02加入集群（在master02上执行）
    # kubeadm join 192.168.174.200:6443 --token wob9v2.2t7fwzg3sdfvbe05 \
        --discovery-token-ca-cert-hash sha256:396670c9fa96a5866aaeedc2a69b767aa0d751c6d55c6f8e8bc37e8f230ec5f0 \
        --control-plane    
    [preflight] Running pre-flight checks
    [preflight] Reading configuration from the cluster...
    [preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
    [preflight] Running pre-flight checks before initializing the new control plane instance
    [preflight] Pulling images required for setting up a Kubernetes cluster
    [preflight] This might take a minute or two, depending on the speed of your internet connection
    [preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
    [certs] Using certificateDir folder "/etc/kubernetes/pki"
    [certs] Generating "front-proxy-client" certificate and key
    [certs] Generating "etcd/server" certificate and key
    [certs] etcd/server serving cert is signed for DNS names [master02 localhost] and IPs [192.168.174.160 127.0.0.1 ::1]
    [certs] Generating "etcd/peer" certificate and key
    [certs] etcd/peer serving cert is signed for DNS names [master02 localhost] and IPs [192.168.174.160 127.0.0.1 ::1]
    [certs] Generating "etcd/healthcheck-client" certificate and key
    [certs] Generating "apiserver-etcd-client" certificate and key
    [certs] Generating "apiserver" certificate and key
    [certs] apiserver serving cert is signed for DNS names [master02 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local master01 master02 master03 work01 work02 work03] and IPs [10.96.0.1 192.168.174.160 192.168.174.200 192.168.174.159 192.168.174.160 192.168.174.161 192.168.174.162 192.168.174.163 192.168.174.164 192.168.174.200]
    [certs] Generating "apiserver-kubelet-client" certificate and key
    [certs] Valid certificates and keys now exist in "/etc/kubernetes/pki"
    [certs] Using the existing "sa" key
    [kubeconfig] Generating kubeconfig files
    [kubeconfig] Using kubeconfig folder "/etc/kubernetes"
    [kubeconfig] Writing "admin.conf" kubeconfig file
    [kubeconfig] Writing "controller-manager.conf" kubeconfig file
    [kubeconfig] Writing "scheduler.conf" kubeconfig file
    [control-plane] Using manifest folder "/etc/kubernetes/manifests"
    [control-plane] Creating static Pod manifest for "kube-apiserver"
    [control-plane] Creating static Pod manifest for "kube-controller-manager"
    [control-plane] Creating static Pod manifest for "kube-scheduler"
    [check-etcd] Checking that the etcd cluster is healthy
    [kubelet-start] Downloading configuration for the kubelet from the "kubelet-config-1.16" ConfigMap in the kube-system namespace
    [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
    [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
    [kubelet-start] Activating the kubelet service
    [kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...
    [etcd] Announced new etcd member joining to the existing etcd cluster
    [etcd] Creating static Pod manifest for "etcd"
    [etcd] Waiting for the new etcd member to join the cluster. This can take up to 40s
    {"level":"warn","ts":"2020-04-13T17:04:13.333+0800","caller":"clientv3/retry_interceptor.go:61","msg":"retrying of unary invoker failed","target":"passthrough:///https://192.168.174.160:2379","attempt":0,"error":"rpc error: code = DeadlineExceeded desc = context deadline exceeded"}
    [upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
    [mark-control-plane] Marking the node master02 as control-plane by adding the label "node-role.kubernetes.io/master=''"
    [mark-control-plane] Marking the node master02 as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
    
    This node has joined the cluster and a new control plane instance was created:
    
    * Certificate signing request was sent to apiserver and approval was received.
    * The Kubelet was informed of the new secure connection details.
    * Control plane (master) label and taint were applied to the new node.
    * The Kubernetes control plane instances scaled up.
    * A new etcd member was added to the local/stacked etcd cluster.
    
    To start administering your cluster from this node, you need to run the following as a regular user:
    
            mkdir -p $HOME/.kube
            sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
            sudo chown $(id -u):$(id -g) $HOME/.kube/config
    
    Run 'kubectl get nodes' to see this node join the cluster.

    master03加入集群（在master03上执行）
    # kubeadm join 192.168.174.200:6443 --token wob9v2.2t7fwzg3sdfvbe05 \
        --discovery-token-ca-cert-hash sha256:396670c9fa96a5866aaeedc2a69b767aa0d751c6d55c6f8e8bc37e8f230ec5f0 \
        --control-plane
    [preflight] Running pre-flight checks
    [preflight] Reading configuration from the cluster...
    [preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
    [preflight] Running pre-flight checks before initializing the new control plane instance
    [preflight] Pulling images required for setting up a Kubernetes cluster
    [preflight] This might take a minute or two, depending on the speed of your internet connection
    [preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
    [certs] Using certificateDir folder "/etc/kubernetes/pki"
    [certs] Generating "apiserver" certificate and key
    [certs] apiserver serving cert is signed for DNS names [master03 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local master01 master02 master03 work01 work02 work03] and IPs [10.96.0.1 192.168.174.161 192.168.174.200 192.168.174.159 192.168.174.160 192.168.174.161 192.168.174.162 192.168.174.163 192.168.174.164 192.168.174.200]
    [certs] Generating "apiserver-kubelet-client" certificate and key
    [certs] Generating "front-proxy-client" certificate and key
    [certs] Generating "etcd/peer" certificate and key
    [certs] etcd/peer serving cert is signed for DNS names [master03 localhost] and IPs [192.168.174.161 127.0.0.1 ::1]
    [certs] Generating "apiserver-etcd-client" certificate and key
    [certs] Generating "etcd/server" certificate and key
    [certs] etcd/server serving cert is signed for DNS names [master03 localhost] and IPs [192.168.174.161 127.0.0.1 ::1]
    [certs] Generating "etcd/healthcheck-client" certificate and key
    [certs] Valid certificates and keys now exist in "/etc/kubernetes/pki"
    [certs] Using the existing "sa" key
    [kubeconfig] Generating kubeconfig files
    [kubeconfig] Using kubeconfig folder "/etc/kubernetes"
    [kubeconfig] Writing "admin.conf" kubeconfig file
    [kubeconfig] Writing "controller-manager.conf" kubeconfig file
    [kubeconfig] Writing "scheduler.conf" kubeconfig file
    [control-plane] Using manifest folder "/etc/kubernetes/manifests"
    [control-plane] Creating static Pod manifest for "kube-apiserver"
    [control-plane] Creating static Pod manifest for "kube-controller-manager"
    [control-plane] Creating static Pod manifest for "kube-scheduler"
    [check-etcd] Checking that the etcd cluster is healthy
    [kubelet-start] Downloading configuration for the kubelet from the "kubelet-config-1.16" ConfigMap in the kube-system namespace
    [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
    [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
    [kubelet-start] Activating the kubelet service
    [kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...
    [etcd] Announced new etcd member joining to the existing etcd cluster
    [etcd] Creating static Pod manifest for "etcd"
    [etcd] Waiting for the new etcd member to join the cluster. This can take up to 40s
    [upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
    [mark-control-plane] Marking the node master03 as control-plane by adding the label "node-role.kubernetes.io/master=''"
    [mark-control-plane] Marking the node master03 as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
    
    This node has joined the cluster and a new control plane instance was created:
    
    * Certificate signing request was sent to apiserver and approval was received.
    * The Kubelet was informed of the new secure connection details.
    * Control plane (master) label and taint were applied to the new node.
    * The Kubernetes control plane instances scaled up.
    * A new etcd member was added to the local/stacked etcd cluster.
    
    To start administering your cluster from this node, you need to run the following as a regular user:
    
            mkdir -p $HOME/.kube
            sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
            sudo chown $(id -u):$(id -g) $HOME/.kube/config
    
    Run 'kubectl get nodes' to see this node join the cluster.
            
    为了在master02和master03上也能执行kubectl命令，master02和master03加载环境变量（以下3条命令分别在master02，master03上执行）
    # scp master01:/etc/kubernetes/admin.conf /etc/kubernetes/
    # echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bash_profile
    # source .bash_profile     
    集群节点查看
    # kubectl get nodes
    NAME       STATUS   ROLES    AGE     VERSION
    master01   Ready    master   29m     v1.16.4
    master02   Ready    master   5m16s   v1.16.4
    master03   Ready    master   4m3s    v1.16.4
    # kubectl get pod -o wide -n kube-system
    NAME                               READY   STATUS    RESTARTS   AGE     IP                NODE       NOMINATED NODE   READINESS GATES
    coredns-5644d7b6d9-8slvg           1/1     Running   0          30m     10.244.0.2        master01   <none>           <none>
    coredns-5644d7b6d9-pw8mz           1/1     Running   0          30m     10.244.0.3        master01   <none>           <none>
    etcd-master01                      1/1     Running   0          29m     192.168.174.159   master01   <none>           <none>
    etcd-master02                      1/1     Running   0          6m22s   192.168.174.160   master02   <none>           <none>
    etcd-master03                      1/1     Running   0          5m9s    192.168.174.161   master03   <none>           <none>
    kube-apiserver-master01            1/1     Running   0          29m     192.168.174.159   master01   <none>           <none>
    kube-apiserver-master02            1/1     Running   0          6m22s   192.168.174.160   master02   <none>           <none>
    kube-apiserver-master03            1/1     Running   0          5m9s    192.168.174.161   master03   <none>           <none>
    kube-controller-manager-master01   1/1     Running   1          29m     192.168.174.159   master01   <none>           <none>
    kube-controller-manager-master02   1/1     Running   0          6m22s   192.168.174.160   master02   <none>           <none>
    kube-controller-manager-master03   1/1     Running   0          5m10s   192.168.174.161   master03   <none>           <none>
    kube-flannel-ds-amd64-j48v5        1/1     Running   0          6m23s   192.168.174.160   master02   <none>           <none>
    kube-flannel-ds-amd64-njhpb        1/1     Running   0          20m     192.168.174.159   master01   <none>           <none>
    kube-flannel-ds-amd64-wxwdm        1/1     Running   0          5m10s   192.168.174.161   master03   <none>           <none>
    kube-proxy-2tqqt                   1/1     Running   0          30m     192.168.174.159   master01   <none>           <none>
    kube-proxy-l8cbn                   1/1     Running   0          5m10s   192.168.174.161   master03   <none>           <none>
    kube-proxy-mcss8                   1/1     Running   0          6m23s   192.168.174.160   master02   <none>           <none>
    kube-scheduler-master01            1/1     Running   1          29m     192.168.174.159   master01   <none>           <none>
    kube-scheduler-master02            1/1     Running   0          6m23s   192.168.174.160   master02   <none>           <none>
    kube-scheduler-master03            1/1     Running   0          5m9s    192.168.174.161   master03   <none>           <none>
    所有control plane节点处于ready状态，所有的系统组件也正常。
    
# work节点加入集群
    分别在3个work节点执行
    # kubeadm join 192.168.174.200:6443 --token wob9v2.2t7fwzg3sdfvbe05 \
    --discovery-token-ca-cert-hash sha256:396670c9fa96a5866aaeedc2a69b767aa0d751c6d55c6f8e8bc37e8f230ec5f0
    [preflight] Running pre-flight checks
    [preflight] Reading configuration from the cluster...
    [preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
    [kubelet-start] Downloading configuration for the kubelet from the "kubelet-config-1.16" ConfigMap in the kube-system namespace
    [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
    [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
    [kubelet-start] Activating the kubelet service
    [kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...
    
    This node has joined the cluster:
    * Certificate signing request was sent to apiserver and a response was received.
    * The Kubelet was informed of the new secure connection details.
    
    Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
    
    集群节点查看
    # kubectl get nodes 
    NAME       STATUS     ROLES    AGE     VERSION
    master01   Ready      master   33m     v1.16.4
    master02   Ready      master   9m24s   v1.16.4
    master03   Ready      master   8m11s   v1.16.4
    work01     Ready      <none>   54s     v1.16.4
    work02     NotReady   <none>   9s      v1.16.4
    work03     NotReady   <none>   4s      v1.16.4
    

# client配置

    # mkdir -p /etc/kubernetes
    # scp 192.168.174.159:/etc/kubernetes/admin.conf /etc/kubernetes/
    # echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bash_profile
    # source .bash_profile 
    # kubectl get nodes 
    # kubectl get cs
    # kubectl get po -o wide -n kube-system 
    

# 集群高可用测试（在client节点执行）

    [root@master01 ~]# ip a|grep 200
        inet 192.168.174.200/32 scope global ens33
    # kubectl get endpoints kube-controller-manager -n kube-system -o yaml |grep holderIdentity
        control-plane.alpha.kubernetes.io/leader: '{"holderIdentity":"master03_e1abdbd5-350c-4da0-9086-922ca883d67c","leaseDurationSeconds":15,"acquireTime":"2020-04-14T00:11:42Z","renewTime":"2020-04-14T02:09:26Z","leaderTransitions":2}'
    # kubectl get endpoints kube-scheduler -n kube-system -o yaml |grep holderIdentity
        control-plane.alpha.kubernetes.io/leader: '{"holderIdentity":"master01_6a213e1a-9dba-466b-b840-f483c214fb39","leaseDurationSeconds":15,"acquireTime":"2020-04-14T00:11:29Z","renewTime":"2020-04-14T02:09:34Z","leaderTransitions":2}'

组件名	所在节点
apiserver	master01
controller-manager	master03
scheduler	master01

    关闭master01
    [root@master01 ~]# init 0
    [root@master02 ~]# ip a|grep 200
        inet 192.168.174.200/32 scope global ens33
    # kubectl get endpoints kube-controller-manager -n kube-system -o yaml |grep holderIdentity
        control-plane.alpha.kubernetes.io/leader: '{"holderIdentity":"master02_41b9bc77-ead4-4a56-81a0-09410d38c9d2","leaseDurationSeconds":15,"acquireTime":"2020-04-14T02:14:09Z","renewTime":"2020-04-14T02:14:27Z","leaderTransitions":3}'
    # kubectl get endpoints kube-scheduler -n kube-system -o yaml |grep holderIdentity
        control-plane.alpha.kubernetes.io/leader: '{"holderIdentity":"master03_70c057d9-d62b-4a5a-97b4-385b86bd716d","leaseDurationSeconds":15,"acquireTime":"2020-04-14T02:14:08Z","renewTime":"2020-04-14T02:14:36Z","leaderTransitions":3}'
        
组件名	所在节点
apiserver	master02
controller-manager	master02
scheduler	master03

    # kubectl get nodes
    NAME       STATUS     ROLES    AGE   VERSION
    master01   NotReady   master   17h   v1.16.4
    master02   Ready      master   17h   v1.16.4
    master03   Ready      master   17h   v1.16.4
    work01     Ready      <none>   17h   v1.16.4
    work02     Ready      <none>   17h   v1.16.4
    work03     Ready      <none>   17h   v1.16.4
    master01状态为NotReady
    # cat nginx-master.yaml 
    apiVersion: apps/v1             #描述文件遵循extensions/v1beta1版本的Kubernetes API
    kind: Deployment                #创建资源类型为Deployment
    metadata:                       #该资源元数据
      name: nginx-master            #Deployment名称
    spec:                           #Deployment的规格说明
      selector:
        matchLabels:
          app: nginx 
      replicas: 3                   #指定副本数为3
      template:                     #定义Pod的模板
        metadata:                   #定义Pod的元数据
          labels:                   #定义label（标签）
            app: nginx              #label的key和value分别为app和nginx
        spec:                       #Pod的规格说明
          containers:               
          - name: nginx             #容器的名称
            image: nginx:latest     #创建容器所使用的镜像    

    # kubectl apply -f nginx-master.yaml
    deployment.apps/nginx-master created
    # kubectl get po -o wide
    NAME                            READY   STATUS    RESTARTS   AGE     IP           NODE     NOMINATED NODE   READINESS GATES
    nginx-master-75b7bfdb6b-fnk5n   1/1     Running   0          2m34s   10.244.3.4   work01   <none>           <none>
    nginx-master-75b7bfdb6b-qzqr4   1/1     Running   0          2m34s   10.244.5.3   work03   <none>           <none>
    nginx-master-75b7bfdb6b-t75bv   1/1     Running   0          2m34s   10.244.4.4   work02   <none>           <none>
    当有一个control plane节点宕机时，VIP会发生漂移，集群各项功能不受影响。
    在关闭master01的同时关闭master02，测试集群还能否正常对外服务。
    [root@master02 ~]# init 0
    [root@master03 ~]# ip a|grep 200
    vip漂移至唯一的control plane：master03
    # kubectl get endpoints kube-controller-manager -n kube-system -o yaml |grep holderIdentity
    # kubectl get nodes
    Unable to connect to the server: dial tcp 192.168.174.200:6443: connect: no route to host
    etcd集群崩溃，整个k8s集群也不能正常对外服务。
