---
title: workinprocess - KubeVirt CICD Tekton
readmore: true
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



