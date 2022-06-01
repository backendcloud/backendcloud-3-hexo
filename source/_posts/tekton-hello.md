---
title: workinprocess - Kubernetes原生CICD:Tekton hello-world
readmore: false
date: 2022-06-01 18:43:26
categories: 云原生
tags:
- CICD
- Tekton
---

本篇是关于Tekton的 Getting Started，也就是最简单的demo - helloworld

# install

用minikube或者kind搭建Kubernetes环境后。一条kubectl apply命令完成Tekton的安装。
```bash
[developer@localhost kubevirt-tekton-tasks]$ kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
namespace/tekton-pipelines created
Warning: policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
podsecuritypolicy.policy/tekton-pipelines created
clusterrole.rbac.authorization.k8s.io/tekton-pipelines-controller-cluster-access created
clusterrole.rbac.authorization.k8s.io/tekton-pipelines-controller-tenant-access created
clusterrole.rbac.authorization.k8s.io/tekton-pipelines-webhook-cluster-access created
role.rbac.authorization.k8s.io/tekton-pipelines-controller created
role.rbac.authorization.k8s.io/tekton-pipelines-webhook created
role.rbac.authorization.k8s.io/tekton-pipelines-leader-election created
role.rbac.authorization.k8s.io/tekton-pipelines-info created
serviceaccount/tekton-pipelines-controller created
serviceaccount/tekton-pipelines-webhook created
clusterrolebinding.rbac.authorization.k8s.io/tekton-pipelines-controller-cluster-access created
clusterrolebinding.rbac.authorization.k8s.io/tekton-pipelines-controller-tenant-access created
clusterrolebinding.rbac.authorization.k8s.io/tekton-pipelines-webhook-cluster-access created
rolebinding.rbac.authorization.k8s.io/tekton-pipelines-controller created
rolebinding.rbac.authorization.k8s.io/tekton-pipelines-webhook created
rolebinding.rbac.authorization.k8s.io/tekton-pipelines-controller-leaderelection created
rolebinding.rbac.authorization.k8s.io/tekton-pipelines-webhook-leaderelection created
rolebinding.rbac.authorization.k8s.io/tekton-pipelines-info created
customresourcedefinition.apiextensions.k8s.io/clustertasks.tekton.dev created
customresourcedefinition.apiextensions.k8s.io/conditions.tekton.dev created
customresourcedefinition.apiextensions.k8s.io/pipelines.tekton.dev created
customresourcedefinition.apiextensions.k8s.io/pipelineruns.tekton.dev created
customresourcedefinition.apiextensions.k8s.io/resolutionrequests.resolution.tekton.dev created
customresourcedefinition.apiextensions.k8s.io/pipelineresources.tekton.dev created
customresourcedefinition.apiextensions.k8s.io/runs.tekton.dev created
customresourcedefinition.apiextensions.k8s.io/tasks.tekton.dev created
customresourcedefinition.apiextensions.k8s.io/taskruns.tekton.dev created
secret/webhook-certs created
validatingwebhookconfiguration.admissionregistration.k8s.io/validation.webhook.pipeline.tekton.dev created
mutatingwebhookconfiguration.admissionregistration.k8s.io/webhook.pipeline.tekton.dev created
validatingwebhookconfiguration.admissionregistration.k8s.io/config.webhook.pipeline.tekton.dev created
clusterrole.rbac.authorization.k8s.io/tekton-aggregate-edit created
clusterrole.rbac.authorization.k8s.io/tekton-aggregate-view created
configmap/config-artifact-bucket created
configmap/config-artifact-pvc created
configmap/config-defaults created
configmap/feature-flags created
configmap/pipelines-info created
configmap/config-leader-election created
configmap/config-logging created
configmap/config-observability created
configmap/config-registry-cert created
deployment.apps/tekton-pipelines-controller created
service/tekton-pipelines-controller created
Warning: autoscaling/v2beta1 HorizontalPodAutoscaler is deprecated in v1.22+, unavailable in v1.25+; use autoscaling/v2 HorizontalPodAutoscaler
horizontalpodautoscaler.autoscaling/tekton-pipelines-webhook created
deployment.apps/tekton-pipelines-webhook created
service/tekton-pipelines-webhook created
#首次安装，等待拉取镜像
[developer@localhost ~]$ kubectl get pods -n tekton-pipelines
NAME                                           READY   STATUS    RESTARTS   AGE
tekton-pipelines-controller-795d77dbd6-x2dkt   1/1     Running   0          11m
tekton-pipelines-webhook-579c8dc94c-82cbn      1/1     Running   0          3m52s
```

# task
```bash
[developer@localhost ~]$ cat hello-world.yaml
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: hello
spec:
  steps:
    - name: echo
      image: alpine
      script: |
        #!/bin/sh
        echo "Hello World"
[developer@localhost ~]$ kubectl apply -f hello-world.yaml 
task.tekton.dev/hello created
[developer@localhost tekton-hello]$ cat hello-world-run.yaml
apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
  name: hello-task-run
spec:
  taskRef:
    name: hello
[developer@localhost tekton-hello]$ kubectl apply --filename hello-world-run.yaml
taskrun.tekton.dev/hello-task-run created
[developer@localhost tekton-hello]$ kubectl get taskrun hello-task-run
NAME             SUCCEEDED   REASON    STARTTIME   COMPLETIONTIME
hello-task-run   Unknown     Pending   22s         
[developer@localhost tekton-hello]$ kubectl logs --selector=tekton.dev/taskRun=hello-task-run
Error from server (BadRequest): container "step-echo" in pod "hello-task-run-pod" is waiting to start: PodInitializing
[developer@localhost tekton-hello]$ kubectl get pod
NAME                 READY   STATUS     RESTARTS   AGE
hello-task-run-pod   0/1     Init:0/3   0          41s
#等待 gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.35.1 镜像拉取完成
vents:
  Type     Reason     Age              From               Message
  ----     ------     ----             ----               -------
  Normal   Scheduled  8h               default-scheduler  Successfully assigned default/hello-task-run-pod to minikube
  Warning  Failed     8h               kubelet            Failed to pull image "gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.35.1@sha256:4fc8631a27bdd1b4c149a08b7db0465a706559ccddd979d0b9dbc93ef676105d": rpc error: code = Unknown desc = error pulling image configuration: Get "https://gcr.io/v2/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint/blobs/sha256:17e1278505574391f7a58602fabadd837aded266a298a2a58f3d7e646a84491e": net/http: TLS handshake timeout
  Normal   Pulling    8h (x4 over 8h)  kubelet            Pulling image "gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.35.1@sha256:4fc8631a27bdd1b4c149a08b7db0465a706559ccddd979d0b9dbc93ef676105d"
  Warning  Failed     8h (x3 over 8h)  kubelet            Failed to pull image "gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.35.1@sha256:4fc8631a27bdd1b4c149a08b7db0465a706559ccddd979d0b9dbc93ef676105d": rpc error: code = Unknown desc = context canceled
  Warning  Failed     8h (x4 over 8h)  kubelet            Error: ErrImagePull
  Warning  Failed     8h (x7 over 8h)  kubelet            Error: ImagePullBackOff
  Normal   BackOff    8h (x8 over 8h)  kubelet            Back-off pulling image "gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.35.1@sha256:4fc8631a27bdd1b4c149a08b7db0465a706559ccddd979d0b9dbc93ef676105d"
# 镜像太大了，竟然下载失败了，可能网络不稳定导致超时，可以手动拉取镜像
[developer@localhost tekton-hello]$ minikube ssh
                         _             _            
            _         _ ( )           ( )           
  ___ ___  (_)  ___  (_)| |/')  _   _ | |_      __  
/' _ ` _ `\| |/' _ `\| || , <  ( ) ( )| '_`\  /'__`\
| ( ) ( ) || || ( ) || || |\`\ | (_) || |_) )(  ___/
(_) (_) (_)(_)(_) (_)(_)(_) (_)`\___/'(_,__/'`\____)

$ docker images
REPOSITORY                                                           TAG       IMAGE ID       CREATED         SIZE
k8s.gcr.io/kube-apiserver                                            v1.23.3   f40be0088a83   4 months ago    135MB
k8s.gcr.io/kube-controller-manager                                   v1.23.3   b07520cd7ab7   4 months ago    125MB
k8s.gcr.io/kube-scheduler                                            v1.23.3   99a3486be4f2   4 months ago    53.5MB
k8s.gcr.io/kube-proxy                                                v1.23.3   9b7cc9982109   4 months ago    112MB
k8s.gcr.io/etcd                                                      3.5.1-0   25f8c7f3da61   7 months ago    293MB
k8s.gcr.io/coredns/coredns                                           v1.8.6    a4ca41631cc7   7 months ago    46.8MB
k8s.gcr.io/pause                                                     3.6       6270bb605e12   9 months ago    683kB
kubernetesui/dashboard                                               v2.3.1    e1482a24335a   11 months ago   220MB
kubernetesui/metrics-scraper                                         v1.0.7    7801cfc6d5c0   11 months ago   34.4MB
gcr.io/k8s-minikube/storage-provisioner                              v5        6e38f40d628d   14 months ago   31.5MB
registry                                                             <none>    678dfa38fcfa   17 months ago   26.2MB
gcr.io/google_containers/kube-registry-proxy                         <none>    60dc18151daf   5 years ago     188MB
gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/webhook      <none>    fc324a2913a5   52 years ago    76.8MB
gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint   <none>    17e127850557   52 years ago    64.7MB
gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/controller   <none>    721d8b7d2eaf   52 years ago    86.1MB
$ docker pull gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.35.1@sha256:4fc8631a27bdd1b4c149a08b7db0465a706559ccddd979d0b9dbc93ef676105d
gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint@sha256:4fc8631a27bdd1b4c149a08b7db0465a706559ccddd979d0b9dbc93ef676105d: Pulling from tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint
Digest: sha256:4fc8631a27bdd1b4c149a08b7db0465a706559ccddd979d0b9dbc93ef676105d
Status: Image is up to date for gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint@sha256:4fc8631a27bdd1b4c149a08b7db0465a706559ccddd979d0b9dbc93ef676105d
gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.35.1@sha256:4fc8631a27bdd1b4c149a08b7db0465a706559ccddd979d0b9dbc93ef676105d
# 发现镜像成功拉取了，应该仅仅是下载时间太长了，超时了，过了一会，pod：hello-task-run-pod 执行完成。状态为Completed
[developer@localhost tekton-hello]$ kubectl get pod
NAME                 READY   STATUS      RESTARTS   AGE
hello-task-run-pod   0/1     Completed   0          22m
[developer@localhost tekton-hello]$ kubectl logs --selector=tekton.dev/taskRun=hello-task-run
Hello World
```

# pipeline
```bash
[developer@localhost tekton-hello]$ cat goodbye-world.yaml 
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: goodbye
spec:
  steps:
    - name: goodbye
      image: ubuntu
      script: |
        #!/bin/bash
        echo "Goodbye World!"     
[developer@localhost tekton-hello]$ kubectl apply -f goodbye-world.yaml
task.tekton.dev/goodbye created
[developer@localhost tekton-hello]$ cat hello-goodbye-pipeline.yaml
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: hello-goodbye
spec:
  tasks:
    - name: hello
      taskRef:
        name: hello
    - name: goodbye
      runAfter:
        - hello
      taskRef:
        name: goodbye
[developer@localhost tekton-hello]$ 
```