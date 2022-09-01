---
title: minikube config set driver kvm2
readmore: true
date: 2022-05-18 21:46:32
categories: 云原生
tags:
- minikube
- kvm2
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

> 参考： https://minikube.sigs.k8s.io/docs/drivers/kvm2/

# 记录下 minikube的driver切换成kvm2遇到的问题 

## docker: Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post http://%2Fvar%2Frun%2Fdocker.sock/v1.35/containers/create: dial unix /var/run/docker.sock: connect: permission denied. See 'docker run --help'.
```bash
$ sudo groupadd docker
$ sudo usermod -aG docker $USER
$ newgrp docker
Check if docker can be run without root
$ docker run hello-world
# Reboot if still got error
$ reboot
```

## PROVIDER_KVM2_NOT_FOUND: The 'kvm2' provider was not found: exec: "virsh": executable file not found in $PATH
```bash
developer@localhost ~]$ minikube config set vm-driver kvm2
❗  These changes will take effect upon a minikube delete and then a minikube start
[developer@localhost ~]$ minikube start --memory 4096
😄  minikube v1.25.2 on Centos 7.9.2009
✨  Using the kvm2 driver based on user configuration

🤷  Exiting due to PROVIDER_KVM2_NOT_FOUND: The 'kvm2' provider was not found: exec: "virsh": executable file not found in $PATH
💡  Suggestion: Install libvirt
📘  Documentation: https://minikube.sigs.k8s.io/docs/reference/drivers/kvm2/
```

```bash
[developer@localhost ~]$ cat /sys/module/kvm_intel/parameters/nested
N
[developer@localhost ~]$ uname -r
3.10.0-1160.el7.x86_64
[developer@localhost ~]$ lsmod|grep kvm_intel
kvm_intel             188740  0 
kvm                   637289  1 kvm_intel
# 上面有了kvm说明host bois打开了intel vmx，vmware也打开了intel vmx（该机器是vmware虚拟机），再确认下是否打开了嵌套虚拟化
[developer@localhost ~]$ logout
[root@localhost ~]# modprobe -r kvm_intel^C
[root@localhost ~]# lsmod|grep kvm_intel
kvm_intel             188740  0 
kvm                   637289  1 kvm_intel
[root@localhost ~]# modprobe -r kvm_intel
[root@localhost ~]# lsmod|grep kvm_intel
[root@localhost ~]# modprobe kvm_intel nested=1
[root@localhost ~]# lsmod|grep kvm_intel
kvm_intel             188740  0 
kvm                   637289  1 kvm_intel
[root@localhost ~]# cat /sys/module/kvm_intel/parameters/nested
Y
# Enable nested virtualization permanently
[root@localhost ~]# vi /etc/modprobe.d/kvm.conf
# 编辑文件，增加一行
options kvm_intel nested=1
```

```bash
[developer@localhost ~]$ minikube config set vm-driver kvm2
❗  These changes will take effect upon a minikube delete and then a minikube start
[developer@localhost ~]$ minikube delete
🙄  "minikube" profile does not exist, trying anyways.
💀  Removed all traces of the "minikube" cluster.
[developer@localhost ~]$ minikube start --memory 4096
😄  minikube v1.25.2 on Centos 7.9.2009
✨  Using the kvm2 driver based on user configuration

🤷  Exiting due to PROVIDER_KVM2_NOT_FOUND: The 'kvm2' provider was not found: exec: "virsh": executable file not found in $PATH
💡  Suggestion: Install libvirt
📘  Documentation: https://minikube.sigs.k8s.io/docs/reference/drivers/kvm2/

[developer@localhost ~]$ sudo yum install qemu-kvm libvirt libvirt-python libguestfs-tools virt-install^C
```

## Exiting due to PR_KVM_USER_PERMISSION: libvirt group membership check failed
```bash
[developer@localhost ~]$ minikube start --memory 4096
😄  minikube v1.25.2 on Centos 7.9.2009
✨  Using the kvm2 driver based on user configuration

🚫  Exiting due to PR_KVM_USER_PERMISSION: libvirt group membership check failed:
user is not a member of the appropriate libvirt group
💡  Suggestion: Ensure that you are a member of the appropriate libvirt group (remember to relogin for group changes to take effect!)
📘  Documentation: https://minikube.sigs.k8s.io/docs/reference/drivers/kvm2/
🍿  Related issues:
    ▪ https://github.com/kubernetes/minikube/issues/5617
    ▪ https://github.com/kubernetes/minikube/issues/10070

[developer@localhost ~]$ sudo groupadd libvirt4minikube
[sudo] password for developer: 
[developer@localhost ~]$ sudo usermod -a -G libvirt4minikube $USER
```

## Failed to connect socket to '/var/run/libvirt/libvirt-sock': No such file or directory
```bash
[developer@localhost ~]$ minikube start --memory 4096
😄  minikube v1.25.2 on Centos 7.9.2009
✨  Using the kvm2 driver based on user configuration

💣  Exiting due to PROVIDER_KVM2_ERROR: /bin/virsh domcapabilities --virttype kvm failed:
error: failed to connect to the hypervisor
error: Failed to connect socket to '/var/run/libvirt/libvirt-sock': No such file or directory
exit status 1
💡  Suggestion: Follow your Linux distribution instructions for configuring KVM
📘  Documentation: https://minikube.sigs.k8s.io/docs/reference/drivers/kvm2/

[developer@localhost ~]$ sudo systemctl start libvirtd
[developer@localhost ~]$ sudo systemctl enable libvirtd
```

## authentication unavailable: no polkit agent available to authenticate action 'org.libvirt.unix.manage'
```bash
[developer@localhost ~]$ minikube start --memory 4096
😄  minikube v1.25.2 on Centos 7.9.2009
✨  Using the kvm2 driver based on user configuration

💣  Exiting due to PROVIDER_KVM2_ERROR: /bin/virsh domcapabilities --virttype kvm failed:
error: failed to connect to the hypervisor
error: authentication unavailable: no polkit agent available to authenticate action 'org.libvirt.unix.manage'
exit status 1
💡  Suggestion: Follow your Linux distribution instructions for configuring KVM
📘  Documentation: https://minikube.sigs.k8s.io/docs/reference/drivers/kvm2/
```

```bash
这个主要是WebVirtMgr的安装导致出现的错误，解决方法如下：

1、增加libvirtd用户组
groupadd libvirtd

2、设置用户到组
sudo usermod -a -G libvirtd $USER

3、设置启动libvirtd服务的用户组
vi /etc/libvirt/libvirtd.conf
修改下面的内容
# This is restricted to 'root' by default.
#unix_sock_group = "libvirt"
unix_sock_group = "libvirtd"

4、增加权限启动配置 - 为libvirt添加一条polkit策略
vi /etc/polkit-1/localauthority/50-local.d/50-org.libvirtd-group-access.pkla
# 增加下面的内容
[libvirtd group Management Access]
Identity=unix-group:libvirtd
Action=org.libvirt.unix.manage
ResultAny=yes
ResultInactive=yes
ResultActive=yes

5、重启服务
service libvirtd restart
```
## error creating VM: virError(Code=1, Domain=10, Message='internal error: qemu unexpectedly closed the monitor: Cannot set up guest memory 'pc.ram': Cannot allocate memory')
```bash
[developer@localhost ~]$ minikube delete
🔥  Deleting "minikube" in kvm2 ...
💀  Removed all traces of the "minikube" cluster.
[developer@localhost ~]$ minikube start --memory 4096
😄  minikube v1.25.2 on Centos 7.9.2009
✨  Using the kvm2 driver based on user configuration
👍  Starting control plane node minikube in cluster minikube
🔥  Creating kvm2 VM (CPUs=2, Memory=4096MB, Disk=20000MB) ...
🔥  Deleting "minikube" in kvm2 ...
🤦  StartHost failed, but will try again: creating host: create: Error creating machine: Error in driver during machine creation: error creating VM: virError(Code=1, Domain=10, Message='internal error: qemu unexpectedly closed the monitor: Cannot set up guest memory 'pc.ram': Cannot allocate memory')
🔥  Creating kvm2 VM (CPUs=2, Memory=4096MB, Disk=20000MB) ...
😿  Failed to start kvm2 VM. Running "minikube delete" may fix it: creating host: create: Error creating machine: Error in driver during machine creation: error creating VM: virError(Code=1, Domain=10, Message='internal error: process exited while connecting to monitor: Cannot set up guest memory 'pc.ram': Cannot allocate memory')

❌  Exiting due to GUEST_PROVISION: Failed to start host: creating host: create: Error creating machine: Error in driver during machine creation: error creating VM: virError(Code=1, Domain=10, Message='internal error: process exited while connecting to monitor: Cannot set up guest memory 'pc.ram': Cannot allocate memory')

╭───────────────────────────────────────────────────────────────────────────────────────────╮
│                                                                                           │
│    😿  If the above advice does not help, please let us know:                             │
│    👉  https://github.com/kubernetes/minikube/issues/new/choose                           │
│                                                                                           │
│    Please run `minikube logs --file=logs.txt` and attach logs.txt to the GitHub issue.    │
│                                                                                           │
╰───────────────────────────────────────────────────────────────────────────────────────────╯
```

> 参考： https://github.com/kubernetes/minikube/issues/3634

> 该错误在Openstack Nova内存不够时中也会出现，这个时候需要调整内存超分或调低vm的flavor：
> nova-conductor.log 报错：
> ERROR nova.scheduler.utils [req-9880cb62-7a70-41aa-b6c0-db4ec5333e98 53a1cf0ad2924532aa4b7b0750dec282 0ab2dbde4f754b699e22461426cd0774 - - -] [instance: 36bb1220-f295-4205-ba2e-6e41f8b134b9] Error from last host: xiandian (node xiandian): [u'Traceback (most recent call last):\n', u'  File "/usr/lib/python2.7/site-packages/nova/compute/manager.py", line 1926, in _do_build_and_run_instance\n    filter_properties)\n', u'  File "/usr/lib/python2.7/site-packages/nova/compute/manager.py", line 2116, in _build_and_run_instance\n    instance_uuid=instance.uuid, reason=six.text_type(e))\n', u"RescheduledException: Build of instance 36bb1220-f295-4205-ba2e-6e41f8b134b9 was re-scheduled: internal error: process exited while connecting to monitor: 2019-05-20T17:38:19.473598Z qemu-kvm: cannot set up guest memory 'pc.ram': Cannot allocate memory\n\n"]

报错原因：memory不足，free查看memory使用情况后，调低内存
```bash
[developer@localhost ~]$ free
              total        used        free      shared  buff/cache   available
Mem:        7990064     3911652      490180       12216     3588232     3777588
Swap:             0           0           0
[developer@localhost ~]$ minikube start --memory 2048
😄  minikube v1.25.2 on Centos 7.9.2009
✨  Using the kvm2 driver based on user configuration
👍  Starting control plane node minikube in cluster minikube
🔥  Creating kvm2 VM (CPUs=2, Memory=2048MB, Disk=20000MB) ...
🐳  Preparing Kubernetes v1.23.3 on Docker 20.10.12 ...
    ▪ kubelet.housekeeping-interval=5m
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: storage-provisioner, default-storageclass
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```

# minikube with vm-driver kvm2 启动成功
```bash
[developer@localhost ~]$ minikube start --memory 4096
😄  minikube v1.25.2 on Centos 7.9.2009
✨  Using the kvm2 driver based on user configuration
💾  Downloading driver docker-machine-driver-kvm2:
    > docker-machine-driver-kvm2-...: 65 B / 65 B [----------] 100.00% ? p/s 0s
    > docker-machine-driver-kvm2-...: 11.62 MiB / 11.62 MiB  100.00% 8.31 MiB p
💿  Downloading VM boot image ...
    > minikube-v1.25.2.iso.sha256: 65 B / 65 B [-------------] 100.00% ? p/s 0s
    > minikube-v1.25.2.iso: 237.06 MiB / 237.06 MiB [] 100.00% 8.84 MiB p/s 27s
👍  Starting control plane node minikube in cluster minikube
🔥  Creating kvm2 VM (CPUs=2, Memory=4096MB, Disk=20000MB) ...
🐳  Preparing Kubernetes v1.23.3 on Docker 20.10.12 ...
    ▪ kubelet.housekeeping-interval=5m
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: default-storageclass, storage-provisioner
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```

```bash
[developer@localhost ~]$ kubectl get pod -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   coredns-64897985d-dxggj            1/1     Running   0          4m46s
kube-system   etcd-minikube                      1/1     Running   0          4m59s
kube-system   kube-apiserver-minikube            1/1     Running   0          5m
kube-system   kube-controller-manager-minikube   1/1     Running   0          4m59s
kube-system   kube-proxy-9q4dg                   1/1     Running   0          4m46s
kube-system   kube-scheduler-minikube            1/1     Running   0          4m59s
kube-system   storage-provisioner                1/1     Running   0          4m57s
[developer@localhost ~]$ kubectl get node
NAME       STATUS   ROLES                  AGE    VERSION
minikube   Ready    control-plane,master   5m7s   v1.23.3
[developer@localhost ~]$ virt-host-validate
  QEMU: Checking for hardware virtualization                                 : PASS
  QEMU: Checking if device /dev/kvm exists                                   : PASS
  QEMU: Checking if device /dev/kvm is accessible                            : PASS
  QEMU: Checking if device /dev/vhost-net exists                             : PASS
  QEMU: Checking if device /dev/net/tun exists                               : PASS
  QEMU: Checking for cgroup 'memory' controller support                      : PASS
  QEMU: Checking for cgroup 'memory' controller mount-point                  : PASS
  QEMU: Checking for cgroup 'cpu' controller support                         : PASS
  QEMU: Checking for cgroup 'cpu' controller mount-point                     : PASS
  QEMU: Checking for cgroup 'cpuacct' controller support                     : PASS
  QEMU: Checking for cgroup 'cpuacct' controller mount-point                 : PASS
  QEMU: Checking for cgroup 'cpuset' controller support                      : PASS
  QEMU: Checking for cgroup 'cpuset' controller mount-point                  : PASS
  QEMU: Checking for cgroup 'devices' controller support                     : PASS
  QEMU: Checking for cgroup 'devices' controller mount-point                 : PASS
  QEMU: Checking for cgroup 'blkio' controller support                       : PASS
  QEMU: Checking for cgroup 'blkio' controller mount-point                   : PASS
  QEMU: Checking for device assignment IOMMU support                         : PASS
  QEMU: Checking if IOMMU is enabled by kernel                               : WARN (IOMMU appears to be disabled in kernel. Add intel_iommu=on to kernel cmdline arguments)
   LXC: Checking for Linux >= 2.6.26                                         : PASS
   LXC: Checking for namespace ipc                                           : PASS
   LXC: Checking for namespace mnt                                           : PASS
   LXC: Checking for namespace pid                                           : PASS
   LXC: Checking for namespace uts                                           : PASS
   LXC: Checking for namespace net                                           : PASS
   LXC: Checking for namespace user                                          : PASS
   LXC: Checking for cgroup 'memory' controller support                      : PASS
   LXC: Checking for cgroup 'memory' controller mount-point                  : PASS
   LXC: Checking for cgroup 'cpu' controller support                         : PASS
   LXC: Checking for cgroup 'cpu' controller mount-point                     : PASS
   LXC: Checking for cgroup 'cpuacct' controller support                     : PASS
   LXC: Checking for cgroup 'cpuacct' controller mount-point                 : PASS
   LXC: Checking for cgroup 'cpuset' controller support                      : PASS
   LXC: Checking for cgroup 'cpuset' controller mount-point                  : PASS
   LXC: Checking for cgroup 'devices' controller support                     : PASS
   LXC: Checking for cgroup 'devices' controller mount-point                 : PASS
   LXC: Checking for cgroup 'blkio' controller support                       : PASS
   LXC: Checking for cgroup 'blkio' controller mount-point                   : PASS
   LXC: Checking if device /sys/fs/fuse/connections exists                   : FAIL (Load the 'fuse' module to enable /proc/ overrides)
```

# Usage
Start a cluster using the kvm2 driver:

    minikube start --driver=kvm2

To make kvm2 the default driver:

    minikube config set driver kvm2

# Special features
The minikube start command supports 5 additional KVM specific flags:
* --gpu: Enable experimental NVIDIA GPU support in minikube
* --hidden: Hide the hypervisor signature from the guest in minikube
* --kvm-network: The KVM default network name
* --network: The dedicated KVM private network name
* --kvm-qemu-uri: The KVM qemu uri, defaults to qemu:///system
