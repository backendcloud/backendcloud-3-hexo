---
title: workinprocess - KubeVirt CICD Tekton (2) - task run:datavolume & ssh-key
readmore: false
date: 2022-06-02 18:13:07
categories: 云原生
tags:
- CICD
- Tekton
- KubeVirt
---

# 创建 DataVolume
```bash
[developer@localhost ~]$ kubectl get DataVolume
error: the server doesn't have a resource type "DataVolume"
# 没有安装Containerized Data Importer，先部署CDI。
[developer@localhost ~]$ echo $VERSION
v1.49.0
[developer@localhost ~]$ kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-operator.yaml
namespace/cdi created
customresourcedefinition.apiextensions.k8s.io/cdis.cdi.kubevirt.io created
clusterrole.rbac.authorization.k8s.io/cdi-operator-cluster created
clusterrolebinding.rbac.authorization.k8s.io/cdi-operator created
serviceaccount/cdi-operator created
role.rbac.authorization.k8s.io/cdi-operator created
rolebinding.rbac.authorization.k8s.io/cdi-operator createde
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
Created example-dv-67t4j Datavolume in default namespace.
Waiting for Ready condition.
datavolume.cdi.kubevirt.io/example-dv-67t4j condition met
[developer@localhost taskruns]$ kubectl get dv
NAME               PHASE       PROGRESS   RESTARTS   AGE
example-dv-67t4j   Succeeded   100.0%                3m14s
[developer@localhost taskruns]$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                      STORAGECLASS   REASON   AGE
pvc-268ecfec-1706-4fea-9ef8-9dde3b466d80   100Mi      RWO            Delete           Bound    default/example-dv-67t4j   standard                17s
[developer@localhost taskruns]$ kubectl get pvc
NAME               STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
example-dv-67t4j   Bound    pvc-268ecfec-1706-4fea-9ef8-9dde3b466d80   100Mi      RWO            standard       22s
[developer@localhost taskruns]$ kubectl get pod
NAME                                  READY   STATUS      RESTARTS   AGE
create-dv-from-manifest-taskrun-pod   0/1     Completed   0          2m39s
[developer@localhost taskruns]$ kubectl get dv example-dv-67t4j -o yaml
apiVersion: cdi.kubevirt.io/v1beta1
kind: DataVolume
metadata:
  creationTimestamp: "2022-06-02T02:05:38Z"
  generateName: example-dv-
  generation: 7
  name: example-dv-67t4j
  namespace: default
  resourceVersion: "37955"
  uid: b6f97382-3936-4d7c-b3b3-0c3028624a9e
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
  claimName: example-dv-67t4j
  conditions:
  - lastHeartbeatTime: "2022-06-02T02:05:40Z"
    lastTransitionTime: "2022-06-02T02:05:40Z"
    message: PVC example-dv-67t4j Bound
    reason: Bound
    status: "True"
    type: Bound
  - lastHeartbeatTime: "2022-06-02T02:05:47Z"
    lastTransitionTime: "2022-06-02T02:05:47Z"
    status: "True"
    type: Ready
  - lastHeartbeatTime: "2022-06-02T02:05:45Z"
    lastTransitionTime: "2022-06-02T02:05:45Z"
    message: Import Complete
    reason: Completed
    status: "False"
    type: Running
  phase: Succeeded
  progress: 100.0%
[developer@localhost taskruns]$ 
```

# generate ssh key
```bash
[developer@localhost taskruns]$ cat generate-ssh-keys-simple-taskrun.yaml 
---
apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
  name: generate-ssh-keys-simple-taskrun
spec:
  serviceAccountName: generate-ssh-keys-task
  taskRef:
    kind: ClusterTask
    name: generate-ssh-keys
  params: []
[developer@localhost taskruns]$ kubectl apply -f generate-ssh-keys-simple-taskrun.yaml 
taskrun.tekton.dev/generate-ssh-keys-simple-taskrun created
[developer@localhost taskruns]$ kubectl get pod
NAME                                   READY   STATUS     RESTARTS   AGE
generate-ssh-keys-simple-taskrun-pod   0/1     Init:0/2   0          2s
[developer@localhost taskruns]$ kubectl get pod
NAME                                   READY   STATUS            RESTARTS   AGE
generate-ssh-keys-simple-taskrun-pod   0/1     PodInitializing   0          6s
[developer@localhost taskruns]$ kubectl describe pod generate-ssh-keys-simple-taskrun-pod
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  8h    default-scheduler  Successfully assigned default/generate-ssh-keys-simple-taskrun-pod to minikube
  Normal  Pulled     8h    kubelet            Container image "gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.35.1@sha256:4fc8631a27bdd1b4c149a08b7db0465a706559ccddd979d0b9dbc93ef676105d" already present on machine
  Normal  Created    8h    kubelet            Created container place-tools
  Normal  Started    8h    kubelet            Started container place-tools
  Normal  Pulled     8h    kubelet            Container image "gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.35.1@sha256:4fc8631a27bdd1b4c149a08b7db0465a706559ccddd979d0b9dbc93ef676105d" already present on machine
  Normal  Created    8h    kubelet            Created container step-init
  Normal  Started    8h    kubelet            Started container step-init
  Normal  Pulling    8h    kubelet            Pulling image "quay.io/kubevirt/tekton-task-generate-ssh-keys:v0.9.2"
  Normal  Pulled     8h    kubelet            Successfully pulled image "quay.io/kubevirt/tekton-task-generate-ssh-keys:v0.9.2" in 25.144859196s
  Normal  Created    8h    kubelet            Created container step-generate-ssh-keys
  Normal  Started    8h    kubelet            Started container step-generate-ssh-keys
[developer@localhost taskruns]$ kubectl get pod
NAME                                   READY   STATUS      RESTARTS   AGE
generate-ssh-keys-simple-taskrun-pod   0/1     Completed   0          37s
[developer@localhost taskruns]$ kubectl logs generate-ssh-keys-simple-taskrun-pod
Generating public/private rsa key pair.
Your identification has been saved in /tmp/sshkey-2709323324/id_rsa.
Your public key has been saved in /tmp/sshkey-2709323324/id_rsa.pub.
The key fingerprint is:
SHA256:0iOp+jpw1k/C0XC6HloxerAG9NuG3miZ/Ex7K6db7/M default@generated
The key's randomart image is:
+---[RSA 4096]----+
|                 |
| .  . .          |
|. .  =           |
|. ..= .o         |
| . *+=+ S        |
|. *oO+.o .       |
| =o=B* .         |
|  oO+o+o..       |
|  ++o**.oooE     |
+----[SHA256]-----+
[developer@localhost taskruns]$ kubectl get secret
NAME                                               TYPE                                  DATA   AGE
cleanup-vm-task-token-m7lzb                        kubernetes.io/service-account-token   3      17h
create-datavolume-from-manifest-task-token-6m89v   kubernetes.io/service-account-token   3      17h
create-vm-from-manifest-task-token-g84vz           kubernetes.io/service-account-token   3      17h
default-token-xfdcb                                kubernetes.io/service-account-token   3      18h
execute-in-vm-task-token-4vfgw                     kubernetes.io/service-account-token   3      17h
generate-ssh-keys-task-token-bb5n4                 kubernetes.io/service-account-token   3      17h
private-key-kpmzz                                  kubernetes.io/ssh-auth                1      2m3s
private-key-phd6j                                  kubernetes.io/ssh-auth                1      24s
private-key-rgn2s                                  kubernetes.io/ssh-auth                1      13m
public-key-g2dpg                                   Opaque                                1      24s
wait-for-vmi-status-task-token-mzdpw               kubernetes.io/service-account-token   3      17h
[developer@localhost taskruns]$ kubectl get secret public-key-g2dpg -o yaml
apiVersion: v1
data:
  id-rsa-bbmlc.pub: c3NoLXJzYSBBQUFBQjNOemFDMXljMkVBQUFBREFRQUJBQUFDQVFDdkFIN1dnNjhpTnp2M0dnRXZMMW15VU1LLzRMNEZKdWhjR3lHS3IzREV5V2Vaa3BlanJRVGFBQVlRTmRRM2RnSjR2YVIwS1Y5NW10blNPSWNQeUYzcWlBZitjTjM5eHdqMGw2eEpQQW04dk5pTCtPcS9XWnRQUllEaHRIeFNYbUdIdFhiSFV3cS9pWkxkUEIySVhuL1JUendud2NURW0vWmI0c0pGOEhxclRXa1RyQlJFcWpTVmtabE1aUWNOVVZpQXZ2THVpcGIyWURtOGluRStvYnF6SXVRdEVZb25JVHdRV292ZHUzeTZEY0NIdmdsV2htUm5LVlorOEk3d0pEeHNJcGZ3VCsxVERiN25jQUI0VDBnNWQxd2ZCOWFpZEFwNktlZ295UWh3cUY3RWVrMWJPTCtaWXJUS2lYeUdJZFRISHlhWmN4REVacWN1SUI0MjBrRS9ibEIzTGpZYTBrS3BDVVBvQ2VNYjV2UmgvZFNkUDNRRGxmUEZpamlTQW1Lb01hWk04TzNVMGVKNFN6aGtVZGdkaXF6NVE5T0VWaFVVY3RSZ1EzNTFXelFnbXFVRTVXd0U2dTZ6SjZRNUlURytjL3hXZUg4Z2xqc3Q2d3lCU0tlYWhXbVpOTytZUDl4OVhHOTl2NnRTdW9UeVk3bC9OSzBFWFYxM3lraTBneUtVQmg4aW9EekxPbFRoczdmcGFLMkozYlliYSszdmNwUHUrSTJvZEwvVmFGamtCQUlCS2VVSkF0alNoNlpLODNwQlh0TVZqOUttaDRJU252R0hNc0M0dmhTMVpFZHNGbEI3Mi8zVW54V1gwV3FLeTdxbDBmY3dzdExNTHh2dHhHdG4xUWdWb2YzL01wQmpxazRSdzlPU3hSekZZNTI1eFcrNXNwb0ZUbGJLOXc9PSBkZWZhdWx0QGdlbmVyYXRlZAo=
kind: Secret
metadata:
  creationTimestamp: "2022-06-02T01:36:07Z"
  generateName: public-key-
  name: public-key-g2dpg
  namespace: default
  resourceVersion: "29728"
  uid: 4b75065c-a57a-470c-9b14-fa017e52e337
type: Opaque
# 执行另一个taskrun
[developer@localhost taskruns]$ cat generate-ssh-keys-advanced-taskrun.yaml 
---
apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
  name: generate-ssh-keys-advanced-taskrun
spec:
  serviceAccountName: generate-ssh-keys-task
  taskRef:
    kind: ClusterTask
    name: generate-ssh-keys
  params:
    - name: publicKeySecretName
      value: my-client-public-secret
    - name: privateKeySecretName
      value: my-client-private-secret
    - name: privateKeyConnectionOptions
      value:
        - 'user:root'
        - 'disable-strict-host-key-checking:true'
        - 'additional-ssh-options:-p 8022'
    - name: additionalSSHKeygenOptions
      value: '-t rsa-sha2-512 -b 4096'
[developer@localhost taskruns]$ kubectl apply -f generate-ssh-keys-advanced-taskrun.yaml 
taskrun.tekton.dev/generate-ssh-keys-advanced-taskrun created
[developer@localhost taskruns]$ kubectl get pod
NAME                                     READY   STATUS     RESTARTS   AGE
generate-ssh-keys-advanced-taskrun-pod   0/1     Init:1/2   0          3s
[developer@localhost taskruns]$ kubectl get pod
NAME                                     READY   STATUS      RESTARTS   AGE
generate-ssh-keys-advanced-taskrun-pod   0/1     Completed   0          7s
[developer@localhost taskruns]$ kubectl get secret
NAME                                               TYPE                                  DATA   AGE
cleanup-vm-task-token-m7lzb                        kubernetes.io/service-account-token   3      17h
create-datavolume-from-manifest-task-token-6m89v   kubernetes.io/service-account-token   3      17h
create-vm-from-manifest-task-token-g84vz           kubernetes.io/service-account-token   3      17h
default-token-xfdcb                                kubernetes.io/service-account-token   3      18h
execute-in-vm-task-token-4vfgw                     kubernetes.io/service-account-token   3      17h
generate-ssh-keys-task-token-bb5n4                 kubernetes.io/service-account-token   3      17h
my-client-private-secret                           kubernetes.io/ssh-auth                4      5s
my-client-public-secret                            Opaque                                1      5s
private-key-kpmzz                                  kubernetes.io/ssh-auth                1      5m22s
private-key-phd6j                                  kubernetes.io/ssh-auth                1      3m43s
private-key-rgn2s                                  kubernetes.io/ssh-auth                1      16m
public-key-g2dpg                                   Opaque                                1      3m43s
wait-for-vmi-status-task-token-mzdpw               kubernetes.io/service-account-token   3      17h
[developer@localhost taskruns]$ kubectl get secret my-client-public-secret -o yaml
apiVersion: v1
data:
  id-rsa-69hcj.pub: c3NoLXJzYSBBQUFB<省略>YXRlZAo=
kind: Secret
metadata:
  creationTimestamp: "2022-06-02T01:39:45Z"
  name: my-client-public-secret
  namespace: default
  resourceVersion: "30747"
  uid: 9b01e460-f6ba-420f-b4e7-8cf0aa077f61
type: Opaque
[developer@localhost taskruns]$ kubectl get secret my-client-private-secret -o yaml
apiVersion: v1
data:
  additional-ssh-options: LXAgODAyMg==
  disable-strict-host-key-checking: dHJ1ZQ==
  ssh-privatekey: LS0tLS1CRUdJTiBPUEV<省略>TBRR2RsYm1WeVlYUmxaQUVDQXc9PQotLS0tLUVORCBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0K
  user: cm9vdA==
kind: Secret
metadata:
  creationTimestamp: "2022-06-02T01:39:45Z"
  name: my-client-private-secret
  namespace: default
  resourceVersion: "30748"
  uid: 76698051-5fe3-452c-9a34-1de28259e0f3
type: kubernetes.io/ssh-auth
```
