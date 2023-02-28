---
title: Pod Overhead
readmore: true
date: 2023-02-28 19:19:22
categories: 云原生
tags:
- pod
- overhead
---


# 为什么引入 Pod Overhead

Docker Pod 除了传统的 container 容器之外，还有一个 pause 容器，但我们在计算它的容器开销的时候会忽略 pause 容器。

对于 Kata Pod，除了 container 容器之外，kata-agent, pause, guest-kernel 这些开销都是没有被统计进来的。像这些开销，多的时候甚至能超过 100MB，这些开销我们是没法忽略的。

这就是引入 Pod Overhead 的初衷。

# Pod Overhead 在K8S源码中的使用场景

## API设计

**pod.Spec.Overhead 类型的定义**

```go
type PodSpec struct {
    // ...
    Overhead ResourceList `json:"overhead,omitempty" protobuf:"bytes,32,opt,name=overhead"`
    // ...
```

```go
// ResourceList is a set of (resource name, quantity) pairs.
type ResourceList map[ResourceName]resource.Quantity
```

## scheduler 对 Overhead 的处理

调度程序、资源配额处理以及 Kubelet 的 pod cgroup 创建和驱逐处理将考虑Overhead，以及 pod 的容器请求的总和。

水平和垂直自动缩放是根据容器级别的统计数据计算的，因此不应受到 pod Overhead的影响。

例如调度程序的calculatePodResourceRequest函数在计算某个pod的资源requst请求时，若pod的Overhead请求定义了，则需要将Overhead的值加入request统计。

```go
func (r *resourceAllocationScorer) calculatePodResourceRequest(pod *v1.Pod, resource v1.ResourceName) int64 {
	var podRequest int64
	for i := range pod.Spec.Containers {
		container := &pod.Spec.Containers[i]
		value := schedutil.GetRequestForResource(resource, &container.Resources.Requests, !r.useRequested)
		podRequest += value
	}

	for i := range pod.Spec.InitContainers {
		initContainer := &pod.Spec.InitContainers[i]
		value := schedutil.GetRequestForResource(resource, &initContainer.Resources.Requests, !r.useRequested)
		if podRequest < value {
			podRequest = value
		}
	}

	// If Overhead is being utilized, add to the total requests for the pod
	if pod.Spec.Overhead != nil {
		if quantity, found := pod.Spec.Overhead[resource]; found {
			podRequest += quantity.Value()
		}
	}

	return podRequest
}
```

podResourceRequest = max(sum(podSpec.Containers), podSpec.InitContainers) + overHead

上面的公式取了常规容器和 每个init 容器的最大值。因为 init 容器是按顺序运行的，多个init也是按顺序运行的。相反，对常规容器的资源向量求和，因为它们是同时运行。

GetRequestForResource函数的参数 !r.useRequested 相当于 nonZero 取反后bool值等价。

!r.useRequested 整体为 true 表示不采用request的值（比如零值），而是用默认值（默认值只涉及cpu和memory，cpu默认为0.1核，memory默认为200兆）

