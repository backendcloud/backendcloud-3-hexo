---
title: K8S Pod 本地存储限制 源码分析
readmore: true
date: 2023-03-20 18:38:45
categories: 云原生
tags:
---


kubernetes提供了对CPU，内存的限制，可以防止应用无限制的使用系统的资源。

kubernetes在1.8版本引入了一种新的resource：local ephemeral storage(临时存储)，用来管理本地临时存储，对应特性 LocalStorageCapacityIsolation。

之后的版本就默认开启。

Pod的每个container都可以配置：

    spec.containers[].resources.limits.ephemeral-storage
    spec.containers[].resources.requests.ephemeral-storage


Evict Pod动作是由kubelet完成的。每个节点上的kubelet会启动一个evict manager，每隔一段固定的时间进行一次检查，ephemeral storage的检查也是在这个阶段完成的。

```go
// synchronize is the main control loop that enforces eviction thresholds.
// Returns the pod that was killed, or nil if no pod was killed.
// synchronize 方法是超过阈值强制驱逐的主循环，返回值是kill掉的pod列表
func (m *managerImpl) synchronize(diskInfoProvider DiskInfoProvider, podFunc ActivePodsFunc) []*v1.Pod {
	// ...
	// evict pods if there is a resource usage violation from local volume temporary storage
	// If eviction happens in localStorageEviction function, skip the rest of eviction action
	// 如果 是否可以支持本地存储容量隔离选项为true，则如果本地临时存储中存在资源使用冲突，则逐出 Pod
	if m.localStorageCapacityIsolation {
		if evictedPods := m.localStorageEviction(activePods, statsFunc); len(evictedPods) > 0 {
			return evictedPods
		}
	}
    // ...
}
```

```go
// localStorageEviction checks the EmptyDir volume usage for each pod and determine whether it exceeds the specified limit and needs
// to be evicted. It also checks every container in the pod, if the container overlay usage exceeds the limit, the pod will be evicted too.
// localStorageEviction方法对pod列表中的pod逐一处理；用statsFunc获取pod的实际状态，然后做三个检查
// 是否满足emptyDirLimit，是否满足podEphemeralStorageLimit，是否满足containerEphemeralStorageLimit
// 若有一项不满足，则加入to-be-evicted pod列表，该列表作为方法的返回值
func (m *managerImpl) localStorageEviction(pods []*v1.Pod, statsFunc statsFunc) []*v1.Pod {
	evicted := []*v1.Pod{}
	for _, pod := range pods {
		// statsFunc方法的作用：获取pod的pod ID，查询对应pod的实际状态
		podStats, ok := statsFunc(pod)
		if !ok {
			continue
		}

		// 检查该pod实际emptyDir状态是否超过了emptyDir Limit
		if m.emptyDirLimitEviction(podStats, pod) {
			evicted = append(evicted, pod)
			continue
		}

		// 检查该pod实际podEphemeralStorage状态是否超过了podEphemeralStorage Limit
		if m.podEphemeralStorageLimitEviction(podStats, pod) {
			evicted = append(evicted, pod)
			continue
		}

		// 检查该pod实际containerEphemeralStorage状态是否超过了containerEphemeralStorage Limit
		if m.containerEphemeralStorageLimitEviction(podStats, pod) {
			evicted = append(evicted, pod)
		}
	}

	return evicted
}
```

入参 statsFunc statsFunc 相关代码：

```go
	observations, statsFunc := makeSignalObservations(summary)
```

```go
	statsFunc := cachedStatsFunc(summary.Pods)
```

```go
// cachedStatsFunc returns a statsFunc based on the provided pod stats.
// cachedStatsFunc 入参是 PodStats列表，返回值是 statsFunc函数，该函数入参是*v1.Pod，返回值是pod状态和是否找到该pod
// cachedStatsFunc 在返回前做了个操作：将入参的PodStats列表转成了map，key是podStats[i].PodRef.UID，值是podStats列表元素，
// 为了方便返回的statsFunc索引pod
func cachedStatsFunc(podStats []statsapi.PodStats) statsFunc {
	uid2PodStats := map[string]statsapi.PodStats{}
	for i := range podStats {
		uid2PodStats[podStats[i].PodRef.UID] = podStats[i]
	}
	return func(pod *v1.Pod) (statsapi.PodStats, bool) {
		stats, found := uid2PodStats[string(pod.UID)]
		return stats, found
	}
}
```

localStorageEviction函数的三项检查：

```go
func (m *managerImpl) emptyDirLimitEviction(podStats statsapi.PodStats, pod *v1.Pod) bool {
	podVolumeUsed := make(map[string]*resource.Quantity)
	for _, volume := range podStats.VolumeStats {
		podVolumeUsed[volume.Name] = resource.NewQuantity(int64(*volume.UsedBytes), resource.BinarySI)
	}
	for i := range pod.Spec.Volumes {
		source := &pod.Spec.Volumes[i].VolumeSource
		// 一旦检查到有配置 pod.Spec.Volumes[i].VolumeSource，则比较 实际状态值和limit值
		if source.EmptyDir != nil {
			size := source.EmptyDir.SizeLimit
			used := podVolumeUsed[pod.Spec.Volumes[i].Name]
			if used != nil && size != nil && size.Sign() == 1 && used.Cmp(*size) > 0 {
				// the emptyDir usage exceeds the size limit, evict the pod
				if m.evictPod(pod, 0, fmt.Sprintf(emptyDirMessageFmt, pod.Spec.Volumes[i].Name, size.String()), nil, nil) {
					metrics.Evictions.WithLabelValues(signalEmptyDirFsLimit).Inc()
					return true
				}
				return false
			}
		}
	}

	return false
}

func (m *managerImpl) podEphemeralStorageLimitEviction(podStats statsapi.PodStats, pod *v1.Pod) bool {
	_, podLimits := apiv1resource.PodRequestsAndLimits(pod)
	_, found := podLimits[v1.ResourceEphemeralStorage]
	if !found {
		return false
	}

	// pod stats api summarizes ephemeral storage usage (container, emptyDir, host[etc-hosts, logs])
	podEphemeralStorageTotalUsage := &resource.Quantity{}
	// 若pod实际状态中 EphemeralStorage.UsedBytes 有数值，则和Limit值进行比较
	if podStats.EphemeralStorage != nil && podStats.EphemeralStorage.UsedBytes != nil {
		podEphemeralStorageTotalUsage = resource.NewQuantity(int64(*podStats.EphemeralStorage.UsedBytes), resource.BinarySI)
	}
	podEphemeralStorageLimit := podLimits[v1.ResourceEphemeralStorage]
	if podEphemeralStorageTotalUsage.Cmp(podEphemeralStorageLimit) > 0 {
		// the total usage of pod exceeds the total size limit of containers, evict the pod
		message := fmt.Sprintf(podEphemeralStorageMessageFmt, podEphemeralStorageLimit.String())
		if m.evictPod(pod, 0, message, nil, nil) {
			metrics.Evictions.WithLabelValues(signalEphemeralPodFsLimit).Inc()
			return true
		}
		return false
	}
	return false
}

func (m *managerImpl) containerEphemeralStorageLimitEviction(podStats statsapi.PodStats, pod *v1.Pod) bool {
	thresholdsMap := make(map[string]*resource.Quantity)
	for _, container := range pod.Spec.Containers {
		ephemeralLimit := container.Resources.Limits.StorageEphemeral()
		if ephemeralLimit != nil && ephemeralLimit.Value() != 0 {
			thresholdsMap[container.Name] = ephemeralLimit
		}
	}

	for _, containerStat := range podStats.Containers {
		containerUsed := diskUsage(containerStat.Logs)
		if !*m.dedicatedImageFs {
			containerUsed.Add(*diskUsage(containerStat.Rootfs))
		}

		// 比较该Pod下的每一个容器的实际临时存储已用值和Limit比较，有一个容器不满足则返回true
		if ephemeralStorageThreshold, ok := thresholdsMap[containerStat.Name]; ok {
			if ephemeralStorageThreshold.Cmp(*containerUsed) < 0 {
				if m.evictPod(pod, 0, fmt.Sprintf(containerEphemeralStorageMessageFmt, containerStat.Name, ephemeralStorageThreshold.String()), nil, nil) {
					metrics.Evictions.WithLabelValues(signalEphemeralContainerFsLimit).Inc()
					return true
				}
				return false
			}
		}
	}
	return false
}
```

上面3个Limit检查的方法都调用了m.evictPod方法：

```go
// 首先，检查pod是否是CriticalPod，CriticalPod包括static pod，mirror pod以及根据优先级来判定是否是CriticalPod
// static pod 的Annotations key：ConfigSourceAnnotationKey    = "kubernetes.io/config.source" 对应的value是file，普通的pod对应的value是api
// mirror pod的Annotations key：kubernetes.io/config.mirror ，有此notation就是mirror pod
func (m *managerImpl) evictPod(pod *v1.Pod, gracePeriodOverride int64, evictMsg string, annotations map[string]string, condition *v1.PodCondition) bool {
	// If the pod is marked as critical and static, and support for critical pod annotations is enabled,
	// do not evict such pods. Static pods are not re-admitted after evictions.
	// https://github.com/kubernetes/kubernetes/issues/40573 has more details.
	if kubelettypes.IsCriticalPod(pod) {
		klog.ErrorS(nil, "Eviction manager: cannot evict a critical pod", "pod", klog.KObj(pod))
		return false
	}
	// record that we are evicting the pod
	//若不是CriticalPod，进入evict流程
	// 1. 通过client-go recoder event发送给K8S event记录
	// 2. evict信息记录日志
	// 3. 调用  m.killPodFunc evict the pod
	m.recorder.AnnotatedEventf(pod, annotations, v1.EventTypeWarning, Reason, evictMsg)
	// this is a blocking call and should only return when the pod and its containers are killed.
	klog.V(3).InfoS("Evicting pod", "pod", klog.KObj(pod), "podUID", pod.UID, "message", evictMsg)
	err := m.killPodFunc(pod, true, &gracePeriodOverride, func(status *v1.PodStatus) {
		status.Phase = v1.PodFailed
		status.Reason = Reason
		status.Message = evictMsg
		if condition != nil {
			podutil.UpdatePodCondition(status, condition)
		}
	})
	if err != nil {
		klog.ErrorS(err, "Eviction manager: pod failed to evict", "pod", klog.KObj(pod))
	} else {
		klog.InfoS("Eviction manager: pod is evicted successfully", "pod", klog.KObj(pod))
	}
	return true
}
```

```go
// killPodNow returns a KillPodFunc that can be used to kill a pod.
// It is intended to be injected into other modules that need to kill a pod.
// 这个方法的英文注释已经非常详尽了
func killPodNow(podWorkers PodWorkers, recorder record.EventRecorder) eviction.KillPodFunc {
	return func(pod *v1.Pod, isEvicted bool, gracePeriodOverride *int64, statusFn func(*v1.PodStatus)) error {
		// determine the grace period to use when killing the pod
		gracePeriod := int64(0)
		if gracePeriodOverride != nil {
			gracePeriod = *gracePeriodOverride
		} else if pod.Spec.TerminationGracePeriodSeconds != nil {
			gracePeriod = *pod.Spec.TerminationGracePeriodSeconds
		}

		// we timeout and return an error if we don't get a callback within a reasonable time.
		// the default timeout is relative to the grace period (we settle on 10s to wait for kubelet->runtime traffic to complete in sigkill)
		timeout := int64(gracePeriod + (gracePeriod / 2))
		minTimeout := int64(10)
		if timeout < minTimeout {
			timeout = minTimeout
		}
		timeoutDuration := time.Duration(timeout) * time.Second

		// open a channel we block against until we get a result
		ch := make(chan struct{}, 1)
		podWorkers.UpdatePod(UpdatePodOptions{
			Pod:        pod,
			UpdateType: kubetypes.SyncPodKill,
			KillPodOptions: &KillPodOptions{
				CompletedCh:                              ch,
				Evict:                                    isEvicted,
				PodStatusFunc:                            statusFn,
				PodTerminationGracePeriodSecondsOverride: gracePeriodOverride,
			},
		})

		// wait for either a response, or a timeout
		select {
		case <-ch:
			return nil
		case <-time.After(timeoutDuration):
			recorder.Eventf(pod, v1.EventTypeWarning, events.ExceededGracePeriod, "Container runtime did not kill the pod within specified grace period.")
			return fmt.Errorf("timeout waiting to kill pod")
		}
	}
}
```

可见是调用的podWorkers.UpdatePod，实际的更新pod的方法，并给了相关的参数，实现了KillPodFunc，或者说evicting the pod。podWorkers.UpdatePod和其他podWorkers内容较多，令开一篇分析。