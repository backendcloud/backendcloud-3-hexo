---
title: Kubernetes Service
readmore: true
date: 2022-09-02 13:12:38
categories: 云原生
tags:
- Kubernetes
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

本篇按顺序简单介绍 Kubernetes内部Service， Kubernetes Ingress， Kubernetes Istio。

# Kubernetes内部Service

ClusterIP, NodePort, ExternalIPs 和 LoadBalancer服务是由kube-proxy或者CNI比如Cilium，Calico提供的。参考 {% post_link cilium-replace-kube-proxy %}

如果创建一个 NodePort 服务，它也会创建一个 ClusterIP 服务。如果创建一个 LoadBalancer，它会创建一个 NodePort，然后创建一个 ClusterIP。

**为何要有 Kubernetes内部Service：**

![](/images/k8s-service/2022-09-02-12-21-33.png)

上图的情况，若pod-python被销毁并创建了一个新的。（在本文中，我们不讨论如何管理和控制 pod。）突然pod-nginx无法再到达1.1.1.3，有了Service或者说Cluster IP，情况就不一样了。 

![](/images/k8s-service/2022-09-02-12-23-53.png)

现在服务只能被集群内部访问了，为了能被外部访问，可以配置NodePort。这样内部服务 python 现在也可以从端口 30080 上的每个节点内部和外部 IP 地址访问。

![](/images/k8s-service/2022-09-02-12-25-21.png)



# Kubernetes Ingress

Kubernetes Ingress 不是 Kubernetes 服务。它是一个将请求重定向到其他内部（ClusterIP）服务的 Nginx Pod。

**Kubernetes Ingress 能做什么：**

和 Kubernetes Service 的工作有点类似。和传统的Nginx工作内容一样，HTTP 协议接收对特定文件路径的请求 和 将 HTTP 协议的请求进行重定向转发并返回他们的响应。

例如可以配置不同的 url /folder /other转发到不同的 Kubernetes Service。

```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
  namespace: default
  name: test-ingress
spec:
  rules:
  - http:
      paths:
      - path: /folder
        backend:
          serviceName: service-nginx
          servicePort: 3001
  - http:
      paths:
      - path: /other
        backend:
          serviceName: service-python
          servicePort: 3002 
```

![](/images/k8s-service/2022-09-02-12-41-10.png)

# Kubernetes Istio

Istio 是服务网格，它允许在集群中的 pod 和服务之间进行更详细、复杂和可观察的通信。它将代理容器注入所有 pod，然后控制集群中的流量。

Kubernetes 中的服务由kube-proxy运行在每个节点上的组件实现。该组件创建将请求重定向到 pod 的 iptables 规则。因此，服务只不过是 iptables 规则。（还有其他不使用 iptables 的代理模式可用，但过程相同。 参考 {% post_link cilium-replace-kube-proxy %} ）

![](/images/k8s-service/2022-09-02-12-43-45.png)

上图显示了已安装的 Istio，它与 Istio 控制平面一起提供。同样普遍的是，每个 pod 都有一个名为 的第二个容器istio-proxy，它会在创建过程中自动注入到 pod 中。具有 的 pod istio-proxy将不再使用这些kube-proxy组件。

istio-proxy每当配置或服务的 pod 发生更改时，Istio 控制平面都会对所有sidecar 进行配置。类似于 Kubernetes API 对kube-proxy进行配置。Istio 控制平面利用pod ip实现了自己的路由。Istio 会将 Kubernetes 服务声明转换为自己的路由声明。

**接下来看看如何使用 Istio 发出请求：**

![](/images/k8s-service/2022-09-02-12-47-51.png)

上图中，所有istio-proxy容器都已由 Istio 控制平面进行了配置，并包含所有必要的路由信息​​。nginx 容器 from pod1-nginx向 service 发出请求service-python。

请求被istio-proxy容器拦截pod1-nginx并重定向到istio-proxy 一个python pod的容器，然后将其重定向到python容器。


可见，Istio 和 Kubernetes内部Service 和 Kubernetes内部Service 有很多重叠的功能，或者说可以是相同需求的多种实现。**Istio 相对于 Kubernetes Service 和 Kubernetes Ingress的优势是什么？**

所有流量都通过istio-proxy每个 pod 中的容器进行路由。每当istio-proxy接收和重定向请求时，它也会将有关它的信息提交给 Istio 控制平面。因此，Istio 控制平面确切地知道请求来自哪个 pod、存在哪些 HTTP 标头、从一个请求istio-proxy到另一个请求需要多长时间等等。在具有许多相互通信的服务的集群中，这可以提高可观察性并更好地控制所有流量。

具体点的优势有：
* 高级路由：Kubernetes 内部服务只能将服务请求轮询或随机分发到 Pod。使用 Istio 可以实现更复杂的方法。就像根据请求标头重定向一样，如果发生错误或使用最少的服务。
* 部署：它允许将某些百分比的流量路由到某些服务版本，因此允许绿/蓝和金丝雀部署。
* 加密：可以加密pod 之间的集群内部流量 from istio-proxy 到 istio-proxy。
* 监控/图表生成：Istio 连接到 Prometheus 等监控工具。它还可以与 Kiali 一起很好地显示所有服务及其流量。
* 追踪：由于 Istio 控制平面有大量关于请求的数据，因此可以使用 Jaeger 等工具对这些数据进行跟踪和检查。
* 多集群网格：Istio 有一个内部服务注册中心，可以使用现有的 Kubernetes 服务。也可以从集群外部添加资源，甚至可以将不同的集群连接到一个网格中。

# 总结

综上，所以Istio不是取代 Kubernetes内部服务 的，Istio 使用现有的 Kubernetes 服务来获取其所有端点/pod IP 地址。Istio 是可以取代Kubernetes Ingress的，Istio 提供了新的资源，例如 Gateway 和 VirtualService，甚至还附带了 ingress 转换器istioctl convert-ingress。
