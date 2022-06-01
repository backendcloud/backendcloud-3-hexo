---
title: KubeVirt CICD Tekton (1) - 准备环境&run task:create-vm
readmore: false
date: 2022-06-01 19:44:23
categories: 云原生
tags:
- CICD
- Tekton
- KubeVirt
---
![](/images/kubevirt-tekton-1/1.png)

```bash
[developer@localhost taskruns]$ cat create-vm-from-manifest-taskrun.yaml 
---
apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
  name: create-vm-from-manifest-taskrun
spec:
  serviceAccountName: create-vm-from-manifest-task
  taskRef:
    kind: ClusterTask
    name: create-vm-from-manifest
  params:
  - name: manifest
    value: |
      apiVersion: kubevirt.io/v1
      kind: VirtualMachine
      metadata:
        labels:
          kubevirt.io/vm: vm-cirros
        generateName: vm-cirros-
      spec:
        running: false
        template:
          metadata:
            labels:
              kubevirt.io/vm: vm-cirros
          spec:
            domain:
              devices:
                disks:
                - disk:
                    bus: virtio
                  name: containerdisk
                - disk:
                    bus: virtio
                  name: cloudinitdisk
              machine:
                type: ""
              resources:
                requests:
                  memory: 64M
            terminationGracePeriodSeconds: 0
            volumes:
            - containerDisk:
                image: kubevirt/cirros-container-disk-demo
              name: containerdisk
            - cloudInitNoCloud:
                userData: |
                  #!/bin/sh
                  echo 'printed from cloud-init userdata'
              name: cloudinitdisk
[developer@localhost taskruns]$ kubectl apply -f create-vm-from-manifest-taskrun.yaml 
taskrun.tekton.dev/create-vm-from-manifest-taskrun created
[developer@localhost taskruns]$ kubectl get pod
NAME                                  READY   STATUS      RESTARTS   AGE
create-vm-from-manifest-taskrun-pod   0/1     Completed   0          52s
[developer@localhost taskruns]$ kubectl delete -f create-vm-from-manifest-taskrun.yaml
[developer@localhost taskruns]$ kubectl apply -f create-vm-from-manifest-taskrun.yaml
[developer@localhost taskruns]$ kubectl delete -f create-vm-from-manifest-taskrun.yaml
[developer@localhost taskruns]$ kubectl apply -f create-vm-from-manifest-taskrun.yaml
```

```bash
[developer@localhost ~]$ kubectl get vm --watch
NAME              AGE    STATUS    READY
vm-cirros-vj8wb   3m4s   Stopped   False
vm-cirros-5r9f6   0s               
vm-cirros-5r9f6   0s               
vm-cirros-5r9f6   0s               
vm-cirros-5r9f6   0s     Stopped   False
vm-cirros-l2n94   0s               
vm-cirros-l2n94   0s               
vm-cirros-l2n94   0s     Stopped   False
vm-cirros-l2n94   0s     Stopped   False
^C[developer@localhost ~]$ kubectl get vm 
NAME              AGE     STATUS    READY
vm-cirros-5r9f6   2m46s   Stopped   False
vm-cirros-l2n94   32s     Stopped   False
vm-cirros-vj8wb   6m19s   Stopped   False
[developer@localhost ~]$ kubectl get vmi
No resources found in default namespace.
```
> 可以看到经过3次Tekton task创建的vm

该文章为付费文章，要查看全文可在公众号上查看[文章](https://mp.weixin.qq.com/s/b1FJMrhxJAQybf8sdqJhvQ)