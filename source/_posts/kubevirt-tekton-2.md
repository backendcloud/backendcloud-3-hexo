---
title: KubeVirt CICD Tekton (2) - 各种task run
readmore: true
date: 2022-06-01 18:53:07
categories: 云原生
tags:
- CICD
- Tekton
- KubeVirt
---

# 创建 DataVolume
没有安装Containerized Data Importer，先部署CDI。
```bash
[developer@localhost ~]$ kubectl get DataVolume
error: the server doesn't have a resource type "DataVolume"
[developer@localhost ~]$ echo $VERSION
v1.49.0
[developer@localhost ~]$ $ kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-operator.yaml
-bash: $: command not found
[developer@localhost ~]$ kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-operator.yaml
namespace/cdi created
customresourcedefinition.apiextensions.k8s.io/cdis.cdi.kubevirt.io created
clusterrole.rbac.authorization.k8s.io/cdi-operator-cluster created
clusterrolebinding.rbac.authorization.k8s.io/cdi-operator created
serviceaccount/cdi-operator created
role.rbac.authorization.k8s.io/cdi-operator created
rolebinding.rbac.authorization.k8s.io/cdi-operator created
deployment.apps/cdi-operator created
configmap/cdi-operator-leader-election-helper created
[developer@localhost ~]$ kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-cr.yaml
cdi.cdi.kubevirt.io/cdi created
[developer@localhost ~]$ kubectl get DataVolume
No resources found in default namespace.
[developer@localhost taskruns]$ kubectl get pod -ncdi
NAME                              READY   STATUS    RESTARTS   AGE
cdi-apiserver-67b544479b-frkpl    1/1     Running   0          81s
cdi-deployment-d9bfbdd55-bpcs5    1/1     Running   0          94s
cdi-operator-6c789c4bc5-6pxng     1/1     Running   0          2m9s
cdi-uploadproxy-b6d5657fd-5t8c5   1/1     Running   0          90s
[developer@localhost taskruns]$ cat create-dv-from-manifest-taskrun.yaml 
---
apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
  name: create-dv-from-manifest-taskrun
spec:
  serviceAccountName: create-datavolume-from-manifest-task
  taskRef:
    kind: ClusterTask
    name: create-datavolume-from-manifest
  params:
    - name: waitForSuccess
      value: 'true'
    - name: manifest
      value: |
        apiVersion: cdi.kubevirt.io/v1beta1
        kind: DataVolume
        metadata:
          generateName: example-dv-
        spec:
          pvc:
            accessModes:
              - ReadWriteOnce
            resources:
              requests:
                storage: 100Mi
            volumeMode: Filesystem
          source:
            blank: {}
[developer@localhost taskruns]$ kubectl create -f create-dv-from-manifest-taskrun.yaml 
taskrun.tekton.dev/create-dv-from-manifest-taskrun created
```
> waitForSuccess = true，意味着container需要等待DataVolume Ready才能将状态置为Completed。

```bash
[developer@localhost taskruns]$ kubectl get pod 
NAME                                  READY   STATUS    RESTARTS   AGE
create-dv-from-manifest-taskrun-pod   1/1     Running   0          72s
[developer@localhost taskruns]$ kubectl logs create-dv-from-manifest-taskrun-pod
Created example-dv-nzcsz Datavolume in default namespace.
Waiting for Ready condition.
datavolume.cdi.kubevirt.io/example-dv-nzcsz condition met
[developer@localhost taskruns]$ kubectl get datavolume
NAME               PHASE       PROGRESS   RESTARTS   AGE
example-dv-nzcsz   Succeeded   100.0%                83s
[developer@localhost taskruns]$ kubectl get pod
NAME                                  READY   STATUS      RESTARTS   AGE
create-dv-from-manifest-taskrun-pod   0/1     Completed   0          2m39s
[developer@localhost taskruns]$ kubectl get dv -o yaml
apiVersion: v1
items:
- apiVersion: cdi.kubevirt.io/v1beta1
  kind: DataVolume
  metadata:
    creationTimestamp: "2022-06-01T09:58:10Z"
    generateName: example-dv-
    generation: 7
    name: example-dv-nzcsz
    namespace: default
    resourceVersion: "22358"
    uid: 8f5b7674-3dbb-4526-9e06-b433d3109740
  spec:
    pvc:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 100Mi
      volumeMode: Filesystem
    source:
      blank: {}
  status:
    claimName: example-dv-nzcsz
    conditions:
    - lastHeartbeatTime: "2022-06-01T09:58:15Z"
      lastTransitionTime: "2022-06-01T09:58:15Z"
      message: PVC example-dv-nzcsz Bound
      reason: Bound
      status: "True"
      type: Bound
    - lastHeartbeatTime: "2022-06-01T09:58:47Z"
      lastTransitionTime: "2022-06-01T09:58:47Z"
      status: "True"
      type: Ready
    - lastHeartbeatTime: "2022-06-01T09:58:45Z"
      lastTransitionTime: "2022-06-01T09:58:45Z"
      message: Import Complete
      reason: Completed
      status: "False"
      type: Running
    phase: Succeeded
    progress: 100.0%
kind: List
metadata:
  resourceVersion: ""
  selfLink: ""
[developer@localhost taskruns]$
```