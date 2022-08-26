---
title: Knative Serving flowchart
readmore: true
date: 2022-08-26 13:13:22
categories: 云原生
tags:
- Knative
---

相比庞大的Kubernetes和KubeVirt功能和代码，Knative的功能和代码就简单太多了。

Knative 包括build（现在转向tekton），serving，event。本篇是关于serving的。

之前的一篇文章 {% post_link knative-getting-started %} 介绍了 Knative Serving 的两个最主要的功能，版本流量控制和自动扩缩容（可以将pod缩容到0以及冷启动是Knative扩缩容最大的特性）。

# 版本流量控制：Knative 网关

版本流量控制 是通过 Knative 网关 实现的。

![](/images/knative-serving-flowchart/2022-08-26-16-25-02.png)

Knative 从设计之初就考虑到了其扩展性，通过抽象出来 Knative Ingress （kingress）资源来对接不同的网络扩展：Ambassador、Contour、Gloo、Istio、Kong、Kourier 这些网络插件都是基于 Envoy 这个新生的云原生服务代理，关键特性是可以基于流量百分比进行分流。


# 正常扩缩容场景（非 0 实例）

![](/images/knative-serving-flowchart/2022-08-26-16-25-21.png)

**稳定状态下的工作流程如下：**

请求通过 ingress 路由到 public service ，此时 public service 对应的 endpoints 是 revision 对应的 pod

Autoscaler 会定期通过 queue-proxy 获取 revision 活跃实例的指标，并不断调整 revision 实例。

请求打到系统时， Autoscaler 会根据当前最新的请求指标确定扩缩容比例。

SKS 模式是 serve, 它会监控 private service 的状态，保持 public service 的 endpoints 与 private service 一致 。


# 缩容到 0 的场景

![](/images/knative-serving-flowchart/2022-08-26-16-25-30.png)

**缩容到零过程的工作流程如下：**

AutoScaler 通过 queue-proxy 获取 revision 实例的请求指标

一旦系统中某个 revision 不再接收到请求（此时 Activator 和 queue-proxy 收到的请求数都为 0）

AutoScaler 会通过 Decider 确定出当前所需的实例数为 0，通过 PodAutoscaler 修改 revision 对应 Deployment 的 实例数

在系统删掉 revision 最后一个 Pod 之前，会先将 Activator 加到 数据流路径中（请求先到 Activator）。Autoscaler 触发 SKS 变为 proxy 模式，此时 SKS 的 public service 后端的endpoints 变为 Activator 的IP，所有的流量都直接导到 Activator

此时，如果在冷却窗口时间内依然没有流量进来，那么最后一个 Pod 才会真正缩容到零。

# 从 0 启动的场景

![](/images/knative-serving-flowchart/2022-08-26-16-25-38.png)

**冷启动过程的工作流程如下：**

当 revision 缩容到零之后，此时如果有请求进来，则系统需要扩容。因为 SKS 在 proxy 模式，流量会直接请求到 Activator 。Activator 会统计请求量并将 指标主动上报到 Autoscaler， 同时 Activator 会缓存请求，并 watch SKS 的 private service， 直到 private service 对应的endpoints产生。

Autoscaler 收到 Activator 发送的指标后，会立即启动扩容的逻辑。这个过程的得出的结论是至少一个Pod要被创造出来，AutoScaler 会修改 revision 对应 Deployment 的副本数为为N（N>0）,AutoScaler 同时会将 SKS 的状态置为 serve 模式，流量会直接到导到 revision 对应的 pod上。

Activator 最终会监测到 private service 对应的endpoints的产生，并对 endpoints 进行健康检查。健康检查通过后，Activator 会将之前缓存的请求转发到健康的实例上。
最终 revison 完成了冷启动（从零扩容）。


# API
## PodAutoscaler (PA,KPA)
API: podautoscalers.autoscaling.internal.knative.dev

PodAutoscaler 是对扩缩容的一个抽象，简写是 KPA 或 PA ，每个 revision

会对应生成一个 PodAutoscaler。

可通过下面的指令查看

kubectl get kpa -n xxx

## ServerlessServices (SKS)
API: serverlessservices.networking.internal.knative.dev

ServerlessServices 是 KPA 产生的，一个 KPA 生成一个 SKS，SKS 是对 k8s service 之上的一个抽象，
主要是用来控制数据流是直接流向服务 revision（实例数不为零） 还是经过 Activator（实例数为0）。

对于每个 revision，会对应生成两个k8s service ，一个public service，一个 private service.

private service 是标准的 k8s service，通过label selector 来筛选对应的deploy 产生的pod，即 svc 对应的 endpoints 由 k8s 自动管控。

public service 是不受 k8s 管控的，它没有 label selector，不会像 private service 一样 自动生成 endpoints。public service 对应的 endpoints
由 Knative SKS reconciler 来控制。

SKS 有两种模式：proxy 和 serve
* serve 模式下 public service 后端 endpoints 跟 private service一样， 所有流量都会直接指向 revision 对应的 pod。
* proxy 模式下 public service 后端 endpoints 指向的是 系统中 Activator 对应的 pod，所有流量都会流经 Activator。

> 跟 queue-proxy 不同，Activator 是通过 websocket 主动上报指标给 Autoscaler，这种设计当然是为了应用实例尽可能快的冷启动。queue-proxy 是被动的拉取：Autoscaler去 queue-proxy指定端口拉取指标。