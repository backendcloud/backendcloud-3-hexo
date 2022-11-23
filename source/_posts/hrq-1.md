---
title: HRQ (Hierarchical Resource Quotas 层级资源配额)（1）
readmore: true
date: 2022-11-17 19:09:49
categories: 云原生
tags:
- HRQ
- HNC
---


# HRQ 需求

Kubernetes的资源配额（Resource Quotas）是通过namespace实现的，可以给不同的namespace分配不同的配额，再结合BRAC权限管理（通过权限与角色关联实现访问控制），勉强实现简单的租户管理和租户配额管理。

但是现在的需求是这样的：假设有一个大客户，他们有很多小团队。大客户需要的资源配额很大，也为此付足了钱，大客户需要他有权限给自己的每个小团队创建独立的workspace和为每个workspace分配独立的资源。

# HRQ GKE (Google Kubernetes Engine) 的实现

GKE早已实现上述需求。以下内容出自GKE的帮助文档。

```bash
使用分层资源配额，设置配额。设置 HRQ (Hierarchical Resource Quotas 层级资源配额) 与设置常规 ResourceQuota 相同，但具有不同的 apiVersion 和 kind；因此，您可以像在 ResourceQuota 中一样在 spec.hard 字段中设置资源限制。

假设有一个名为 team-a 的团队拥有一个名为 service-a 的服务，并且有一个名为 team-b 的子团队，三者均由分层命名空间表示，如下所示：

kubectl hns tree team-a
输出：


team-a
├── service-a
└── team-b

如果要限制 team-a 中的 configmaps 数量，但不限制后代（子空间）的任何的数量，您可以按照常规方式创建常规 ResourceQuota，如下所示：

cat > team-a-rq.yaml <<EOF
apiVersion: v1
kind: ResourceQuota
metadata:
  name: team-a-rq
  namespace: team-a
spec:
  hard:
    configmaps: "1"
EOF

kubectl apply -f team-a-rq.yaml

相比之下，如需限制 team-a 及其后代（子空间）中的 configmaps 总数，请替换上一示例中的 apiVersion 和 kind：

cat > team-a-hrq.yaml <<EOF
# Modify the following two lines:
apiVersion: hierarchycontroller.configmanagement.gke.io/v1alpha1
kind: HierarchicalResourceQuota
# Everything below this line remains the same
metadata:
  name: team-a-hrq
  namespace: team-a
spec:
  hard:
    configmaps: "1"

EOF

kubectl apply -f team-a-hrq.yaml

在这三种命名空间中尝试创建 configmap 都会成功。例如，我们可能会选择在其中一个子命名空间中创建 configmap：

kubectl create configmap config-1 --from-literal key=value -n team-b
输出：

confimap/config-1 created

但如果再尝试在任何一个命名空间中创建新 configmap 都将失败，包括在同级或父级命名空间中：

kubectl create configmap config-2 --from-literal key=value -n service-a
kubectl create configmap config-2 --from-literal key=value -n team-a
二者的输出：


Error from server (Forbidden): admission webhook "resourcesquotasstatus.hierarchycontroller.configmanagement.gke.io" denied the request: exceeded hierarchical quota in namespace "team-a": "team-a-hrq", requested: configmaps=1, used: configmaps=1, limited: configmaps=1
```

# HRQ 的开源实现

Kubernetes SIG（特别兴趣小组）下的子项目：多租户项目 下孵化毕业的子项目： HNC（Hierarchical Namespace Controller）项目 最近正在把 GKE 的 HRQ 功能 引入HNC项目，目前还在进行中。

> 这是个相对简单却很有需求的功能，且复杂度和难度对于新手特别友好，适合拿来作为K8S功能开发的学习入门。

