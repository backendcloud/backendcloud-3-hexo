---
title: K8S的常见四种自动化部署方式
readmore: true
date: 2022-06-02 18:30:13
categories: 云原生
tags:
- deploy
---

K8S的常见四种自动化部署方式：Kind，Minikube，KubeAdmin，KubeSpray

# Kind
一条命令完成部署 kind create cluster
删除集群 kind delete cluster

# Minikube
一条命令完成部署 minikube start
停止集群 minikube stop
删除集群 minikube delete
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

> minekube只支持Kubernetes升级不支持降级，只能重建Kubetnetes集群
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
```

# KubeAdmin
> 参考 <a href="https://www.backendcloud.cn/2022/05/06/deploy-kubevirt/#deploy-Kubernetes" target="_blank">https://www.backendcloud.cn/2022/05/06/deploy-kubevirt/#deploy-Kubernetes</a>

# KubeSpray
```bash
git clone https://github.com/kubernetes-sigs/kubespray
# 面前的main分支支持的最新版Kubernetes版本是1.23.7
cd kubespray
cp -rfp inventory/sample inventory/mycluster
declare -a IPS=(10.10.1.3 10.10.1.4 10.10.1.5)
yum install -y epel-release python3-pip
pip3 install -U pip
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
DEBUG: Adding group all
DEBUG: Adding group kube_control_plane
DEBUG: Adding group kube_node
DEBUG: Adding group etcd
DEBUG: Adding group k8s_cluster
DEBUG: Adding group calico_rr
DEBUG: adding host node1 to group all
DEBUG: adding host node1 to group etcd
DEBUG: adding host node1 to group kube_control_plane
DEBUG: adding host node1 to group kube_node
# 若是单个节点 declare -a IPS=(10.10.1.3)

# 根据需要编辑下面两个配置文件
cat inventory/mycluster/group_vars/all/all.yml
cat inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml
# 节点的密码可以配置免密，或者配置在inventory文件中，或者 inventory/mycluster/group_vars/all/all.yml 中加入ansible_ssh_user: your ssh-user 和 ansible_ssh_pass: your ssh-password

ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml
<省略>
TASK [network_plugin/calico : Check ipip and vxlan mode defined correctly] ************************************************************************************************************************************************************************************************************ok: [node1 -> 192.168.137.20] => {
    "changed": false,
    "msg": "All assertions passed"
}
Thursday 02 June 2022  09:22:36 +0800 (0:00:00.060)       0:12:21.818 *********** 
Thursday 02 June 2022  09:22:36 +0800 (0:00:00.040)       0:12:21.859 *********** 

TASK [network_plugin/calico : Check ipip and vxlan mode if simultaneously enabled] ****************************************************************************************************************************************************************************************************ok: [node1 -> 192.168.137.20] => {
    "changed": false,
    "msg": "All assertions passed"
}
Thursday 02 June 2022  09:22:36 +0800 (0:00:00.057)       0:12:21.916 *********** 

TASK [network_plugin/calico : Get Calico default-pool configuration] ******************************************************************************************************************************************************************************************************************ok: [node1 -> 192.168.137.20]
Thursday 02 June 2022  09:22:42 +0800 (0:00:06.605)       0:12:28.522 *********** 

TASK [network_plugin/calico : Set calico_pool_conf] ***********************************************************************************************************************************************************************************************************************************ok: [node1 -> 192.168.137.20]
Thursday 02 June 2022  09:22:42 +0800 (0:00:00.054)       0:12:28.577 *********** 

TASK [network_plugin/calico : Check if inventory match current cluster configuration] *************************************************************************************************************************************************************************************************ok: [node1 -> 192.168.137.20] => {
    "changed": false,
    "msg": "All assertions passed"
}
Thursday 02 June 2022  09:22:42 +0800 (0:00:00.061)       0:12:28.638 *********** 
Thursday 02 June 2022  09:22:42 +0800 (0:00:00.038)       0:12:28.677 *********** 
Thursday 02 June 2022  09:22:42 +0800 (0:00:00.037)       0:12:28.715 *********** 

PLAY RECAP ****************************************************************************************************************************************************************************************************************************************************************************localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   
node1                      : ok=792  changed=151  unreachable=0    failed=0    skipped=1326 rescued=0    ignored=8   

Thursday 02 June 2022  09:22:42 +0800 (0:00:00.022)       0:12:28.738 *********** 
=============================================================================== 
download_container | Download image if required ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 31.38s
download_container | Download image if required ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 29.07s
download_file | Validate mirrors ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 25.64s
bootstrap-os : Assign inventory name to unconfigured hostnames (non-CoreOS, non-Flatcar, Suse and ClearLinux, non-Fedora) ----------------------------------------------------------------------------------------------------------------------------------------------------- 20.64s
download_container | Download image if required ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 19.77s
download_container | Download image if required ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 18.04s
download_file | Download item ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 17.09s
kubernetes/control-plane : kubeadm | Initialize first master ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 16.96s
kubernetes/preinstall : Install packages requirements ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 16.37s
kubernetes/preinstall : NetworkManager | Prevent NetworkManager from managing K8S interfaces (kube-ipvs0/nodelocaldns) -------------------------------------------------------------------------------------------------------------------------------------------------------- 16.01s
download_container | Download image if required ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 15.78s
download_container | Download image if required ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 15.63s
bootstrap-os : Install libselinux python package ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 13.67s
download_container | Download image if required ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 12.98s
download_container | Download image if required ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 10.80s
bootstrap-os : Gather host facts to get ansible_distribution_version ansible_distribution_major_version ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- 10.65s
Gather necessary facts (hardware) --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 10.52s
Gather necessary facts (network) ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 10.24s
bootstrap-os : Gather host facts to get ansible_os_family --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 10.24s
Gather minimal facts ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 10.22s
```

# 总结
以上四种部署方式，
* kind是耗时最短，适合CI测试环境
* minikube适合搭建开发环境，多种plugin可选，部署也很快，也可以随意指定节点的资源配置，节点数量，不用后两种部署方式那样，几个节点要准备几个节点的虚拟资源或物理资源。
* kubeadmin偏手动些，前期后期还有些要额外操作才能完成完整的部署。很多自动化部署工具也是调用的kubeadmin。
* KubeSpray用的ansible自动化部署，整个部署过程较慢，不太适合反复创建删除集群，但是配置灵活，且适合生产环境。