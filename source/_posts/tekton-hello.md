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
[developer@localhost tekton-hello]$ 
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