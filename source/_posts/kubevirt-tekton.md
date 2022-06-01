---
title: workinprocess - KubeVirt CICD Tekton
readmore: false
date: 2022-06-01 19:44:23
categories: 云原生
tags:
- CICD
- Tekton
- KubeVirt
---

```bash
[developer@localhost ~]$ VERSION=v0.9.2
[developer@localhost ~]$ echo $VERSION
v0.9.2
[developer@localhost ~]$ kubectl apply -f "https://github.com/kubevirt/kubevirt-tekton-tasks/releases/download/${VERSION}/kubevirt-tekton-tasks-kubernetes.yaml"
clustertask.tekton.dev/cleanup-vm created
clusterrole.rbac.authorization.k8s.io/cleanup-vm-task created
serviceaccount/cleanup-vm-task created
rolebinding.rbac.authorization.k8s.io/cleanup-vm-task created
clustertask.tekton.dev/create-datavolume-from-manifest created
clusterrole.rbac.authorization.k8s.io/create-datavolume-from-manifest-task created
serviceaccount/create-datavolume-from-manifest-task created
rolebinding.rbac.authorization.k8s.io/create-datavolume-from-manifest-task created
clustertask.tekton.dev/create-vm-from-manifest created
clusterrole.rbac.authorization.k8s.io/create-vm-from-manifest-task created
serviceaccount/create-vm-from-manifest-task created
rolebinding.rbac.authorization.k8s.io/create-vm-from-manifest-task created
clustertask.tekton.dev/disk-virt-customize created
clustertask.tekton.dev/disk-virt-sysprep created
clustertask.tekton.dev/execute-in-vm created
clusterrole.rbac.authorization.k8s.io/execute-in-vm-task created
serviceaccount/execute-in-vm-task created
rolebinding.rbac.authorization.k8s.io/execute-in-vm-task created
clustertask.tekton.dev/generate-ssh-keys created
clusterrole.rbac.authorization.k8s.io/generate-ssh-keys-task created
serviceaccount/generate-ssh-keys-task created
rolebinding.rbac.authorization.k8s.io/generate-ssh-keys-task created
clustertask.tekton.dev/wait-for-vmi-status created
clusterrole.rbac.authorization.k8s.io/wait-for-vmi-status-task created
serviceaccount/wait-for-vmi-status-task created
rolebinding.rbac.authorization.k8s.io/wait-for-vmi-status-task created
```



```bash
[developer@localhost taskruns]$ kubectl get pod
NAME                                  READY   STATUS   RESTARTS   AGE
create-vm-from-manifest-taskrun-pod   0/1     Error    0          3m24s
[developer@localhost taskruns]$ kubectl describe pod create-vm-from-manifest-taskrun-pod
Events:
  Type     Reason       Age              From               Message
  ----     ------       ----             ----               -------
  Normal   Scheduled    8h               default-scheduler  Successfully assigned default/create-vm-from-manifest-taskrun-pod to minikube
  Normal   Pulled       8h               kubelet            Container image "gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.35.1@sha256:4fc8631a27bdd1b4c149a08b7db0465a706559ccddd979d0b9dbc93ef676105d" already present on machine
  Normal   Created      8h               kubelet            Created container place-tools
  Normal   Started      8h               kubelet            Started container place-tools
  Normal   Pulled       8h               kubelet            Container image "gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.35.1@sha256:4fc8631a27bdd1b4c149a08b7db0465a706559ccddd979d0b9dbc93ef676105d" already present on machine
  Normal   Created      8h               kubelet            Created container step-init
  Normal   Started      8h               kubelet            Started container step-init
  Normal   Pulled       8h               kubelet            Container image "quay.io/kubevirt/tekton-task-create-vm:v0.9.2" already present on machine
  Normal   Created      8h               kubelet            Created container step-createvm
  Normal   Started      8h               kubelet            Started container step-createvm
  Warning  FailedMount  8h (x3 over 8h)  kubelet            MountVolume.SetUp failed for volume "kube-api-access-h4dqx" : object "default"/"kube-root-ca.crt" not registered
[developer@localhost taskruns]$ kubectl get node
NAME       STATUS   ROLES                  AGE     VERSION
minikube   Ready    control-plane,master   4h41m   v1.23.3  
```
> 参考 https://github.com/kubernetes/kubernetes/issues/105204#issuecomment-1104427967
> Able to build the k8s kind images myself. Here is how to build kind node image for kubernetes in case anyone interested.
> Confirmed v1.22.9 fixed this bug.
> Confirmed v1.23.6 also fixed this bug.
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
    > kubeadm.sha256: 64 B / 64 B [--------------------------] 100.00% ? p/s 0s
    > kubelet.sha256: 64 B / 64 B [--------------------------] 100.00% ? p/s 0s
    > kubeadm: 43.73 MiB / 43.73 MiB [--------------] 100.00% 8.16 MiB p/s 5.6s
    > kubelet: 115.64 MiB / 115.64 MiB [-------------] 100.00% 8.76 MiB p/s 13s

❌  Exiting due to INET_RESET_BY_PEER: updating control plane: downloading binaries: downloading kubectl: download failed: https://storage.googleapis.com/kubernetes-release/release/v1.22.9/bin/linux/amd64/kubectl?checksum=file:https://storage.googleapis.com/kubernetes-release/release/v1.22.9/bin/linux/amd64/kubectl.sha256: getter: &{Ctx:context.Background Src:https://storage.googleapis.com/kubernetes-release/release/v1.22.9/bin/linux/amd64/kubectl?checksum=file:https://storage.googleapis.com/kubernetes-release/release/v1.22.9/bin/linux/amd64/kubectl.sha256 Dst:/home/developer/.minikube/cache/linux/amd64/v1.22.9/kubectl.download Pwd: Mode:2 Umask:---------- Detectors:[0x36f58f8 0x36f58f8 0x36f58f8 0x36f58f8 0x36f58f8 0x36f58f8 0x36f58f8] Decompressors:map[bz2:0x36f58f8 gz:0x36f58f8 tar:0x36f58f8 tar.bz2:0x36f58f8 tar.gz:0x36f58f8 tar.xz:0x36f58f8 tar.zst:0x36f58f8 tbz2:0x36f58f8 tgz:0x36f58f8 txz:0x36f58f8 tzst:0x36f58f8 xz:0x36f58f8 zip:0x36f58f8 zst:0x36f58f8] Getters:map[file:0xc000ba5330 http:0xc000ba88c0 https:0xc000ba88e0] Dir:false ProgressListener:0x36b4cc0 Insecure:false Options:[0x19449a0]}: invalid checksum: Error downloading checksum file: Get "https://storage.googleapis.com/kubernetes-release/release/v1.22.9/bin/linux/amd64/kubectl.sha256": read tcp 192.168.137.10:53364->172.217.160.80:443: read: connection reset by peer
💡  Suggestion: A firewall is likely blocking minikube from reaching the internet. You may need to configure minikube to use a proxy.
📘  Documentation: https://minikube.sigs.k8s.io/docs/handbook/vpn_and_proxy/
🍿  Related issue: https://github.com/kubernetes/minikube/issues/3909

[developer@localhost taskruns]$ 
```