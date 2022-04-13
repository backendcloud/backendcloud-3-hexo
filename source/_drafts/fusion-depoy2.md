---
title: Openstack和Kubernetes融合部署（1） - 使用minikube快速部署单机版Kubernetes
date: 2022-04-13 00:02:53
categories: 云原生
tags:
- minikube
- Kubernetes
---

# 部署docker
minikube需要docker环境

升级docker，或新装跳过

    yum remove dockerdocker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
    rm -rf /var/lib/docker/

安装最新版docker

    yum install -y yum-utils
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install docker-ce docker-ce-cli containerd.io
    systemctl start docker
    systemctl enable docker

检查docker状态

    systemctl status docker

# 部署minikube

    minikube不能直接用root账号部署，需要创建一个属于docker组的账号，这里创建一个developer账号
    #创建developer账号
    adduser developer
    passwd developer #修改密码
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

# 检查 minikube 状态
```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
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

