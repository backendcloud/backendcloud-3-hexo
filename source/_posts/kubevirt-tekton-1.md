---
title: KubeVirt CICD Tekton (1) - 准备环境&
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
> 将Kubernete版本从1.23.3降级到1.22.9果然没有之前的bug
```bash
[developer@localhost taskruns]$ kubectl get pod
NAME                                  READY   STATUS   RESTARTS   AGE
create-vm-from-manifest-taskrun-pod   0/1     Error    0          77s
[developer@localhost taskruns]$ kubectl describe pod create-vm-from-manifest-taskrun-pod
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  8h    default-scheduler  Successfully assigned default/create-vm-from-manifest-taskrun-pod to minikube
  Normal  Pulled     8h    kubelet            Container image "gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.35.1@sha256:4fc8631a27bdd1b4c149a08b7db0465a706559ccddd979d0b9dbc93ef676105d" already present on machine
  Normal  Created    8h    kubelet            Created container place-tools
  Normal  Started    8h    kubelet            Started container place-tools
  Normal  Pulled     8h    kubelet            Container image "gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.35.1@sha256:4fc8631a27bdd1b4c149a08b7db0465a706559ccddd979d0b9dbc93ef676105d" already present on machine
  Normal  Created    8h    kubelet            Created container step-init
  Normal  Started    8h    kubelet            Started container step-init
  Normal  Pulling    8h    kubelet            Pulling image "quay.io/kubevirt/tekton-task-create-vm:v0.9.2"
  Normal  Pulled     8h    kubelet            Successfully pulled image "quay.io/kubevirt/tekton-task-create-vm:v0.9.2" in 20.884952016s
  Normal  Created    8h    kubelet            Created container step-createvm
  Normal  Started    8h    kubelet            Started container step-createvm
[developer@localhost taskruns]$ kubectl logs create-vm-from-manifest-taskrun-pod
the server could not find the requested resource (post virtualmachines.kubevirt.io)
[developer@localhost taskruns]$ 
```
> 忘记部署KubeVirt，部署KubeVirt参考[这里](https://www.backendcloud.cn/2022/05/06/deploy-kubevirt/#deploy-KubeVirt)
```bash
[developer@localhost taskruns]$ kubectl get pods -n kubevirt
NAME                               READY   STATUS    RESTARTS   AGE
virt-api-b9fc66c44-ndp2p           1/1     Running   0          11m
virt-api-b9fc66c44-pxq4n           1/1     Running   0          11m
virt-controller-7556586574-9pkv7   1/1     Running   0          9m13s
virt-controller-7556586574-q6lnv   1/1     Running   0          9m13s
virt-handler-x224j                 1/1     Running   0          9m13s
virt-operator-7c67945b69-4gcpf     1/1     Running   0          12m
virt-operator-7c67945b69-qdgsb     1/1     Running   0          12m

[developer@localhost ~]$ kubectl get clustertask
NAME                              AGE
cleanup-vm                        43m
create-datavolume-from-manifest   43m
create-vm-from-manifest           43m
disk-virt-customize               43m
disk-virt-sysprep                 43m
execute-in-vm                     43m
generate-ssh-keys                 43m
wait-for-vmi-status               43m
[developer@localhost ~]$ kubectl get clustertask create-vm-from-manifest -o yaml
apiVersion: tekton.dev/v1beta1
kind: ClusterTask
metadata:
  annotations:
    dataVolumes.params.task.kubevirt.io/apiVersion: cdi.kubevirt.io/v1beta1
    dataVolumes.params.task.kubevirt.io/kind: DataVolume
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"tekton.dev/v1beta1","kind":"ClusterTask","metadata":{"annotations":{"dataVolumes.params.task.kubevirt.io/apiVersion":"cdi.kubevirt.io/v1beta1","dataVolumes.params.task.kubevirt.io/kind":"DataVolume","manifest.params.task.kubevirt.io/apiVersion":"kubevirt.io/v1","manifest.params.task.kubevirt.io/kind":"VirtualMachine","manifest.params.task.kubevirt.io/type":"resource-yaml","namespace.params.task.kubevirt.io/type":"namespace","ownDataVolumes.params.task.kubevirt.io/apiVersion":"cdi.kubevirt.io/v1beta1","ownDataVolumes.params.task.kubevirt.io/kind":"DataVolume","ownPersistentVolumeClaims.params.task.kubevirt.io/apiVersion":"v1","ownPersistentVolumeClaims.params.task.kubevirt.io/kind":"PersistentVolumeClaim","persistentVolumeClaims.params.task.kubevirt.io/apiVersion":"v1","persistentVolumeClaims.params.task.kubevirt.io/kind":"PersistentVolumeClaim","startVM.params.task.kubevirt.io/type":"boolean","task.kubevirt.io/associatedServiceAccount":"create-vm-from-manifest-task"},"labels":{"task.kubevirt.io/category":"create-vm","task.kubevirt.io/type":"create-vm-from-manifest"},"name":"create-vm-from-manifest"},"spec":{"params":[{"description":"YAML manifest of a VirtualMachine resource to be created.","name":"manifest","type":"string"},{"default":"","description":"Namespace where to create the VM. (defaults to manifest namespace or active namespace)","name":"namespace","type":"string"},{"default":"","description":"Set to true or false to start / not start vm after creation. In case of runStrategy is set to Always, startVM flag is ignored.","name":"startVM","type":"string"},{"default":"","description":"Set runStrategy to VM. If runStrategy is set, vm.spec.running attribute is set to nil.","name":"runStrategy","type":"string"},{"default":[],"description":"Add DVs to VM Volumes. Replaces a particular volume if in VOLUME_NAME:DV_NAME format. Eg. [\"rootdisk:my-dv\", \"my-dv2\"]","name":"dataVolumes","type":"array"},{"default":[],"description":"Add DVs to VM Volumes and add VM to DV ownerReferences. These DataVolumes will be deleted once the created VM gets deleted. Replaces a particular volume if in VOLUME_NAME:DV_NAME format. Eg. [\"rootdisk:my-dv\", \"my-dv2\"]","name":"ownDataVolumes","type":"array"},{"default":[],"description":"Add PVCs to VM Volumes. Replaces a particular volume if in VOLUME_NAME:PVC_NAME format. Eg. [\"rootdisk:my-pvc\", \"my-pvc2\"]","name":"persistentVolumeClaims","type":"array"},{"default":[],"description":"Add PVCs to VM Volumes and add VM to PVC ownerReferences. These PVCs will be deleted once the created VM gets deleted. Replaces a particular volume if in VOLUME_NAME:PVC_NAME format. Eg. [\"rootdisk:my-pvc\", \"my-pvc2\"]","name":"ownPersistentVolumeClaims","type":"array"}],"results":[{"description":"The name of a VM that was created.","name":"name"},{"description":"The namespace of a VM that was created.","name":"namespace"}],"steps":[{"args":["--output=yaml","--dvs","$(params.dataVolumes)","--own-dvs","$(params.ownDataVolumes)","--pvcs","$(params.persistentVolumeClaims)","--own-pvcs","$(params.ownPersistentVolumeClaims)"],"command":["create-vm"],"env":[{"name":"VM_MANIFEST","value":"$(params.manifest)"},{"name":"VM_NAMESPACE","value":"$(params.namespace)"},{"name":"START_VM","value":"$(params.startVM)"},{"name":"RUN_STRATEGY","value":"$(params.runStrategy)"}],"image":"quay.io/kubevirt/tekton-task-create-vm:v0.9.2","name":"createvm"}]}}
    manifest.params.task.kubevirt.io/apiVersion: kubevirt.io/v1
    manifest.params.task.kubevirt.io/kind: VirtualMachine
    manifest.params.task.kubevirt.io/type: resource-yaml
    namespace.params.task.kubevirt.io/type: namespace
    ownDataVolumes.params.task.kubevirt.io/apiVersion: cdi.kubevirt.io/v1beta1
    ownDataVolumes.params.task.kubevirt.io/kind: DataVolume
    ownPersistentVolumeClaims.params.task.kubevirt.io/apiVersion: v1
    ownPersistentVolumeClaims.params.task.kubevirt.io/kind: PersistentVolumeClaim
    persistentVolumeClaims.params.task.kubevirt.io/apiVersion: v1
    persistentVolumeClaims.params.task.kubevirt.io/kind: PersistentVolumeClaim
    startVM.params.task.kubevirt.io/type: boolean
    task.kubevirt.io/associatedServiceAccount: create-vm-from-manifest-task
  creationTimestamp: "2022-06-01T07:42:50Z"
  generation: 1
  labels:
    task.kubevirt.io/category: create-vm
    task.kubevirt.io/type: create-vm-from-manifest
  name: create-vm-from-manifest
  resourceVersion: "1322"
  uid: 23a21441-8bee-4627-81eb-429c642fd999
spec:
  params:
  - description: YAML manifest of a VirtualMachine resource to be created.
    name: manifest
    type: string
  - default: ""
    description: Namespace where to create the VM. (defaults to manifest namespace
      or active namespace)
    name: namespace
    type: string
  - default: ""
    description: Set to true or false to start / not start vm after creation. In case
      of runStrategy is set to Always, startVM flag is ignored.
    name: startVM
    type: string
  - default: ""
    description: Set runStrategy to VM. If runStrategy is set, vm.spec.running attribute
      is set to nil.
    name: runStrategy
    type: string
  - default: []
    description: Add DVs to VM Volumes. Replaces a particular volume if in VOLUME_NAME:DV_NAME
      format. Eg. ["rootdisk:my-dv", "my-dv2"]
    name: dataVolumes
    type: array
  - default: []
    description: Add DVs to VM Volumes and add VM to DV ownerReferences. These DataVolumes
      will be deleted once the created VM gets deleted. Replaces a particular volume
      if in VOLUME_NAME:DV_NAME format. Eg. ["rootdisk:my-dv", "my-dv2"]
    name: ownDataVolumes
    type: array
  - default: []
    description: Add PVCs to VM Volumes. Replaces a particular volume if in VOLUME_NAME:PVC_NAME
      format. Eg. ["rootdisk:my-pvc", "my-pvc2"]
    name: persistentVolumeClaims
    type: array
  - default: []
    description: Add PVCs to VM Volumes and add VM to PVC ownerReferences. These PVCs
      will be deleted once the created VM gets deleted. Replaces a particular volume
      if in VOLUME_NAME:PVC_NAME format. Eg. ["rootdisk:my-pvc", "my-pvc2"]
    name: ownPersistentVolumeClaims
    type: array
  results:
  - description: The name of a VM that was created.
    name: name
  - description: The namespace of a VM that was created.
    name: namespace
  steps:
  - args:
    - --output=yaml
    - --dvs
    - $(params.dataVolumes)
    - --own-dvs
    - $(params.ownDataVolumes)
    - --pvcs
    - $(params.persistentVolumeClaims)
    - --own-pvcs
    - $(params.ownPersistentVolumeClaims)
    command:
    - create-vm
    env:
    - name: VM_MANIFEST
      value: $(params.manifest)
    - name: VM_NAMESPACE
      value: $(params.namespace)
    - name: START_VM
      value: $(params.startVM)
    - name: RUN_STRATEGY
      value: $(params.runStrategy)
    image: quay.io/kubevirt/tekton-task-create-vm:v0.9.2
    name: createvm
    resources: {}
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
```

    apiVersion: tekton.dev/v1beta1
    kind: ClusterTask
    metadata:
      annotations:
        task.kubevirt.io/associatedServiceAccount: create-vm-from-manifest-task
        manifest.params.task.kubevirt.io/type: resource-yaml
        manifest.params.task.kubevirt.io/kind: VirtualMachine
        manifest.params.task.kubevirt.io/apiVersion: kubevirt.io/v1
        namespace.params.task.kubevirt.io/type: namespace
        dataVolumes.params.task.kubevirt.io/kind: DataVolume
        dataVolumes.params.task.kubevirt.io/apiVersion: cdi.kubevirt.io/v1beta1
        ownDataVolumes.params.task.kubevirt.io/kind: DataVolume
        ownDataVolumes.params.task.kubevirt.io/apiVersion: cdi.kubevirt.io/v1beta1
        persistentVolumeClaims.params.task.kubevirt.io/kind: PersistentVolumeClaim
        persistentVolumeClaims.params.task.kubevirt.io/apiVersion: v1
        ownPersistentVolumeClaims.params.task.kubevirt.io/kind: PersistentVolumeClaim
        ownPersistentVolumeClaims.params.task.kubevirt.io/apiVersion: v1
        startVM.params.task.kubevirt.io/type: boolean
      labels:
        task.kubevirt.io/type: create-vm-from-manifest
        task.kubevirt.io/category: create-vm
      name: create-vm-from-manifest
    spec:
      params:
        - name: manifest
          description: YAML manifest of a VirtualMachine resource to be created.
          type: string
        - name: namespace
          description: Namespace where to create the VM. (defaults to manifest namespace or active namespace)
          default: ""
          type: string
        - name: startVM
          description: Set to true or false to start / not start vm after creation. In case of runStrategy is set to Always, startVM flag is ignored.
          default: ""
          type: string
        - name: runStrategy
          description: Set runStrategy to VM. If runStrategy is set, vm.spec.running attribute is set to nil.
          default: ""
          type: string
        - name: dataVolumes
          description: Add DVs to VM Volumes. Replaces a particular volume if in VOLUME_NAME:DV_NAME format. Eg. ["rootdisk:my-dv", "my-dv2"]
          default: []
          type: array
        - name: ownDataVolumes
          description: Add DVs to VM Volumes and add VM to DV ownerReferences. These DataVolumes will be deleted once the created VM gets deleted. Replaces a particular volume if in VOLUME_NAME:DV_NAME format. Eg. ["rootdisk:my-dv", "my-dv2"]
          default: []
          type: array
        - name: persistentVolumeClaims
          description: Add PVCs to VM Volumes. Replaces a particular volume if in VOLUME_NAME:PVC_NAME format. Eg. ["rootdisk:my-pvc", "my-pvc2"]
          default: []
          type: array
        - name: ownPersistentVolumeClaims
          description: Add PVCs to VM Volumes and add VM to PVC ownerReferences. These PVCs will be deleted once the created VM gets deleted. Replaces a particular volume if in VOLUME_NAME:PVC_NAME format. Eg. ["rootdisk:my-pvc", "my-pvc2"]
          default: []
          type: array
      results:
        - name: name
          description: The name of a VM that was created.
        - name: namespace
          description: The namespace of a VM that was created.
      steps:
        - name: createvm
          image: "quay.io/kubevirt/tekton-task-create-vm:v0.9.2"
          command:
            - create-vm
          args:
            - "--output=yaml"
            - '--dvs'
            - $(params.dataVolumes)
            - '--own-dvs'
            - $(params.ownDataVolumes)
            - '--pvcs'
            - $(params.persistentVolumeClaims)
            - '--own-pvcs'
            - $(params.ownPersistentVolumeClaims)
          env:
            - name: VM_MANIFEST
              value: $(params.manifest)
            - name: VM_NAMESPACE
              value: $(params.namespace)
            - name: START_VM
              value: $(params.startVM)
            - name: RUN_STRATEGY
              value: $(params.runStrategy)

```bash
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