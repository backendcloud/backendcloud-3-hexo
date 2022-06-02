---
title: workinprocess - K8S的常见四种自动化部署方式
readmore: true
date: 2022-06-02 18:30:13
categories: 云原生
tags:
- deploy
---

K8S的常见四种自动化部署方式：Kind，Minikube，KubeAdmin，KubeSpray

# Kind

# Minikube
一条命令完成部署 minikube start
> kvm2 driver参考 <a href="https://www.backendcloud.cn/2022/05/18/minikube-driver-kvm2/" target="_blank">https://www.backendcloud.cn/2022/05/18/minikube-driver-kvm2/</a>

minikube可以直接对Kubernetes的版本进行升级，但是不支持降级，降级需要删除集群后重新创建更低版本的集群。
```bash
[developer@localhost taskruns]$ minikube start --kubernetes-version v1.23.6
😄  minikube v1.25.2 on Centos 7.9.2009
❗  Specified Kubernetes version 1.23.6 is newer than the newest supported version: v1.23.4-rc.0
✨  Using the kvm2 driver based on existing profile
👍  Starting control plane node minikube in cluster minikube
🔄  Restarting existing kvm2 VM for "minikube" ...
🐳  Preparing Kubernetes v1.23.6 on Docker 20.10.12 ...
    ▪ kubelet.housekeeping-interval=5m
    > kubelet.sha256: 64 B / 64 B [--------------------------] 100.00% ? p/s 0s
    > kubectl.sha256: 64 B / 64 B [--------------------------] 100.00% ? p/s 0s
    > kubeadm.sha256: 64 B / 64 B [--------------------------] 100.00% ? p/s 0s
    > kubeadm: 43.12 MiB / 43.12 MiB [--------------] 100.00% 6.37 MiB p/s 7.0s
    > kubectl: 44.44 MiB / 44.44 MiB [---------------] 100.00% 4.20 MiB p/s 11s
    > kubelet: 118.77 MiB / 118.77 MiB [-------------] 100.00% 6.01 MiB p/s 20s
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
    ▪ Using image gcr.io/google_containers/kube-registry-proxy:0.4
    ▪ Using image registry:2.7.1
🔎  Verifying registry addon...
🌟  Enabled addons: storage-provisioner, default-storageclass, registry
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
[developer@localhost taskruns]$ 
```
> minikube 最新版只支持到Kubernetes v1.23.4-rc.0，还不支持v1.23.6

> 只能换到 v1.22.9 试试，minekube只支持Kubernetes升级不支持降级，只能重建Kubetnetes集群
```bash
[developer@localhost taskruns]$ minikube stop
✋  Stopping node "minikube"  ...
🛑  1 node stopped.
[developer@localhost taskruns]$ minikube start --kubernetes-version v1.22.9
😄  minikube v1.25.2 on Centos 7.9.2009

🙈  Exiting due to K8S_DOWNGRADE_UNSUPPORTED: Unable to safely downgrade existing Kubernetes v1.23.6 cluster to v1.22.9
💡  Suggestion: 

    1) Recreate the cluster with Kubernetes 1.22.9, by running:
    
    minikube delete
    minikube start --kubernetes-version=v1.22.9
    
    2) Create a second cluster with Kubernetes 1.22.9, by running:
    
    minikube start -p minikube2 --kubernetes-version=v1.22.9
    
    3) Use the existing cluster at version Kubernetes 1.23.6, by running:
    
    minikube start --kubernetes-version=v1.23.6
    

[developer@localhost taskruns]$ minikube delete
🔥  Deleting "minikube" in kvm2 ...
💀  Removed all traces of the "minikube" cluster.
[developer@localhost taskruns]$ minikube start --kubernetes-version v1.22.9
😄  minikube v1.25.2 on Centos 7.9.2009
❗  Both driver=kvm2 and vm-driver=kvm2 have been set.

    Since vm-driver is deprecated, minikube will default to driver=kvm2.

    If vm-driver is set in the global config, please run "minikube config unset vm-driver" to resolve this warning.

✨  Using the kvm2 driver based on user configuration
👍  Starting control plane node minikube in cluster minikube
🔥  Creating kvm2 VM (CPUs=2, Memory=10240MB, Disk=20000MB) ...
🐳  Preparing Kubernetes v1.22.9 on Docker 20.10.12 ...
    ▪ kubelet.housekeeping-interval=5m
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: default-storageclass, storage-provisioner
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
[developer@localhost taskruns]$ kubectl get node -o wide
NAME       STATUS     ROLES                  AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE              KERNEL-VERSION   CONTAINER-RUNTIME
minikube   NotReady   control-plane,master   13s   v1.22.9   192.168.50.26   <none>        Buildroot 2021.02.4   4.19.202         docker://20.10.12
[developer@localhost taskruns]$ 
```

# KubeAdmin
> 参考 <a href="https://www.backendcloud.cn/2022/05/06/deploy-kubevirt/#deploy-Kubernetes" target="_blank">https://www.backendcloud.cn/2022/05/06/deploy-kubevirt/#deploy-Kubernetes</a>

# KubeSpray