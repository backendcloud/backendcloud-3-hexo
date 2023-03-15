---
title: kubelet 上报节点状态 源码分析
readmore: true
date: 2023-03-15 12:16:18
categories: 云原生
tags:
---



kubelet 上报节点状态 源码 从 Run 方法开始，一层层方法的调用。详细的分析写在代码的注释里了。

```go
// Run starts the kubelet reacting to config updates
func (kl *Kubelet) Run(updates <-chan kubetypes.PodUpdate) {
    // ...
	if kl.kubeClient != nil {
		// Start two go-routines to update the status.
		//
		// The first will report to the apiserver every nodeStatusUpdateFrequency and is aimed to provide regular status intervals,
		// while the second is used to provide a more timely status update during initialization and runs an one-shot update to the apiserver
		// once the node becomes ready, then exits afterwards.
		//
		// Introduce some small jittering to ensure that over time the requests won't start
		// accumulating at approximately the same time from the set of nodes due to priority and
		// fairness effect.
		// 状态上报的功能 kl.syncNodeStatus 是在 kubernetes/pkg/kubelet/kubelet.go Run 方法以 goroutine 形式中启动的，
		// 默认上报间隔 NodeStatusUpdateFrequency.Duration = 10 * time.Second
		go wait.JitterUntil(kl.syncNodeStatus, kl.nodeStatusUpdateFrequency, 0.04, true, wait.NeverStop)
		// 检查 kubelet + 容器运行时的当前状态是否能够将节点准备就绪，并尽快将就绪状态同步到 apiserver。
		// 函数在此类事件之后节点状态更新后返回，或者当节点已准备就绪时返回。
		// 函数仅在 Kubelet 启动期间执行，通过尽快更新 kubelet 状态、运行时状态和节点状态来改善就绪节点的延迟。
		go kl.fastStatusUpdateOnce()

		// start syncing lease
		// 一种新的轻量的状态上报方式
		go kl.nodeLeaseController.Run(wait.NeverStop)
	}
    // ...
}
```

```go
func (kl *Kubelet) syncNodeStatus() {
	kl.syncNodeStatusMux.Lock()
	defer kl.syncNodeStatusMux.Unlock()
	ctx := context.Background()

	if kl.kubeClient == nil || kl.heartbeatClient == nil {
		return
	}
	// 若该node需要自注册，则自注册到apiserver
	if kl.registerNode {
		// This will exit immediately if it doesn't need to do anything.
		kl.registerWithAPIServer()
	}
	// kl.updateNodeStatus(ctx) 方法更新node状态
	if err := kl.updateNodeStatus(ctx); err != nil {
		klog.ErrorS(err, "Unable to update node status")
	}
}
```

```go
func (kl *Kubelet) updateNodeStatus(ctx context.Context) error {
	klog.V(5).InfoS("Updating node status")
	// 更新NodeStatus失败超过nodeStatusUpdateRetry次数，停止更新。
	for i := 0; i < nodeStatusUpdateRetry; i++ {
		if err := kl.tryUpdateNodeStatus(ctx, i); err != nil {
			// 若有kl.onRepeatedHeartbeatFailure方法，则在失败1次后执行该方法。
			if i > 0 && kl.onRepeatedHeartbeatFailure != nil {
				kl.onRepeatedHeartbeatFailure()
			}
			klog.ErrorS(err, "Error updating node status, will retry")
		} else {
			return nil
		}
	}
	return fmt.Errorf("update node status exceeds retry count")
}
```

```go
// tryUpdateNodeStatus tries to update node status to master if there is any
// change or enough time passed from the last sync.
func (kl *Kubelet) tryUpdateNodeStatus(ctx context.Context, tryNumber int) error {
	// In large clusters, GET and PUT operations on Node objects coming
	// from here are the majority of load on apiserver and etcd.
	// To reduce the load on etcd, we are serving GET operations from
	// apiserver cache (the data might be slightly delayed but it doesn't
	// seem to cause more conflict - the delays are pretty small).
	// If it result in a conflict, all retries are served directly from etcd.
	opts := metav1.GetOptions{}
	// 若入参tryNumber == 0，则从apiserver cache GET 替代 load on apiserver
	if tryNumber == 0 {
		util.FromApiserverCache(&opts)
	}
	originalNode, err := kl.heartbeatClient.CoreV1().Nodes().Get(ctx, string(kl.nodeName), opts)
	if err != nil {
		return fmt.Errorf("error getting node %q: %v", kl.nodeName, err)
	}
	if originalNode == nil {
		return fmt.Errorf("nil %q node object", kl.nodeName)
	}

	// changed 返回node status是否有变化
	// 若有变化，或者即使没变化，但是超过了上报周期kl.nodeStatusReportFrequency，都会上报
	node, changed := kl.updateNode(ctx, originalNode)
	shouldPatchNodeStatus := changed || kl.clock.Since(kl.lastStatusReportTime) >= kl.nodeStatusReportFrequency

	if !shouldPatchNodeStatus {
		kl.markVolumesFromNode(node)
		return nil
	}

	updatedNode, err := kl.patchNodeStatus(originalNode, node)
	if err == nil {
		kl.markVolumesFromNode(updatedNode)
	}
	return err
}
```

```go
func (kl *Kubelet) updateNode(ctx context.Context, originalNode *v1.Node) (*v1.Node, bool) {
	node := originalNode.DeepCopy()

	podCIDRChanged := false
	if len(node.Spec.PodCIDRs) != 0 {
		// Pod CIDR could have been updated before, so we cannot rely on
		// node.Spec.PodCIDR being non-empty. We also need to know if pod CIDR is
		// actually changed.
		var err error
		podCIDRs := strings.Join(node.Spec.PodCIDRs, ",")
		if podCIDRChanged, err = kl.updatePodCIDR(ctx, podCIDRs); err != nil {
			klog.ErrorS(err, "Error updating pod CIDR")
		}
	}

	areRequiredLabelsNotPresent := false
	osName, osLabelExists := node.Labels[v1.LabelOSStable]
	if !osLabelExists || osName != goruntime.GOOS {
		if len(node.Labels) == 0 {
			node.Labels = make(map[string]string)
		}
		node.Labels[v1.LabelOSStable] = goruntime.GOOS
		areRequiredLabelsNotPresent = true
	}
	// Set the arch if there is a mismatch
	arch, archLabelExists := node.Labels[v1.LabelArchStable]
	if !archLabelExists || arch != goruntime.GOARCH {
		if len(node.Labels) == 0 {
			node.Labels = make(map[string]string)
		}
		node.Labels[v1.LabelArchStable] = goruntime.GOARCH
		areRequiredLabelsNotPresent = true
	}

	kl.setNodeStatus(ctx, node)
	
	// 若下面的3个条件满足1个
	// 1. pod cidr改变了
	// 2. node 状态改变了
	// 3. os label和 arch label和实际不一致
	// 怎返回的 changed 为 true
	changed := podCIDRChanged || nodeStatusHasChanged(&originalNode.Status, &node.Status) || areRequiredLabelsNotPresent
	return node, changed
}
```

```go
// setNodeStatus fills in the Status fields of the given Node, overwriting
// any fields that are currently set.
// setNodeStatus 填充和更新node的各个类型的状态值
// TODO(madhusudancs): Simplify the logic for setting node conditions and
// refactor the node status condition code out to a different file.
func (kl *Kubelet) setNodeStatus(ctx context.Context, node *v1.Node) {
	for i, f := range kl.setNodeStatusFuncs {
		klog.V(5).InfoS("Setting node status condition code", "position", i, "node", klog.KObj(node))
		if err := f(ctx, node); err != nil {
			klog.ErrorS(err, "Failed to set some node status fields", "node", klog.KObj(node))
		}
	}
}
```

```go
// defaultNodeStatusFuncs is a factory that generates the default set of
// setNodeStatus funcs
// defaultNodeStatusFuncs是工厂函数，生成 setNodeStatus funcs 列表
//```go
//	// handlers called during the tryUpdateNodeStatus cycle
//	setNodeStatusFuncs []func(context.Context, *v1.Node) error
//```
//
//```go
//	// Generating the status funcs should be the last thing we do,
//	// since this relies on the rest of the Kubelet having been constructed.
//	klet.setNodeStatusFuncs = klet.defaultNodeStatusFuncs()
//```
func (kl *Kubelet) defaultNodeStatusFuncs() []func(context.Context, *v1.Node) error {
	// if cloud is not nil, we expect the cloud resource sync manager to exist
	var nodeAddressesFunc func() ([]v1.NodeAddress, error)
	if kl.cloud != nil {
		nodeAddressesFunc = kl.cloudResourceSyncManager.NodeAddresses
	}
	var validateHostFunc func() error
	if kl.appArmorValidator != nil {
		validateHostFunc = kl.appArmorValidator.ValidateHost
	}
	var setters []func(ctx context.Context, n *v1.Node) error
	setters = append(setters,
		nodestatus.NodeAddress(kl.nodeIPs, kl.nodeIPValidator, kl.hostname, kl.hostnameOverridden, kl.externalCloudProvider, kl.cloud, nodeAddressesFunc),
		nodestatus.MachineInfo(string(kl.nodeName), kl.maxPods, kl.podsPerCore, kl.GetCachedMachineInfo, kl.containerManager.GetCapacity,
			kl.containerManager.GetDevicePluginResourceCapacity, kl.containerManager.GetNodeAllocatableReservation, kl.recordEvent, kl.supportLocalStorageCapacityIsolation()),
		nodestatus.VersionInfo(kl.cadvisor.VersionInfo, kl.containerRuntime.Type, kl.containerRuntime.Version),
		nodestatus.DaemonEndpoints(kl.daemonEndpoints),
		nodestatus.Images(kl.nodeStatusMaxImages, kl.imageManager.GetImageList),
		nodestatus.GoRuntime(),
	)
	// Volume limits
	setters = append(setters, nodestatus.VolumeLimits(kl.volumePluginMgr.ListVolumePluginWithLimits))

	setters = append(setters,
		nodestatus.MemoryPressureCondition(kl.clock.Now, kl.evictionManager.IsUnderMemoryPressure, kl.recordNodeStatusEvent),
		nodestatus.DiskPressureCondition(kl.clock.Now, kl.evictionManager.IsUnderDiskPressure, kl.recordNodeStatusEvent),
		nodestatus.PIDPressureCondition(kl.clock.Now, kl.evictionManager.IsUnderPIDPressure, kl.recordNodeStatusEvent),
		nodestatus.ReadyCondition(kl.clock.Now, kl.runtimeState.runtimeErrors, kl.runtimeState.networkErrors, kl.runtimeState.storageErrors,
			validateHostFunc, kl.containerManager.Status, kl.shutdownManager.ShutdownStatus, kl.recordNodeStatusEvent, kl.supportLocalStorageCapacityIsolation()),
		nodestatus.VolumesInUse(kl.volumeManager.ReconcilerStatesHasBeenSynced, kl.volumeManager.GetVolumesInUse),
		// TODO(mtaufen): I decided not to move this setter for now, since all it does is send an event
		// and record state back to the Kubelet runtime object. In the future, I'd like to isolate
		// these side-effects by decoupling the decisions to send events and partial status recording
		// from the Node setters.
		kl.recordNodeSchedulableEvent,
	)
	return setters
}
```

对于二次开发而言，如果我们需要 APIServer 掌握更多的 Node 信息，可以在此处添加自定义函数。

以 nodestatus.MemoryPressureCondition(kl.clock.Now, kl.evictionManager.IsUnderMemoryPressure, kl.recordNodeStatusEvent), 为例

```go
// MemoryPressureCondition returns a Setter that updates the v1.NodeMemoryPressure condition on the node.
// 传入的三个形参，分别为：
// 1. 当前时间函数
// 2. kl.evictionManager.IsUnderMemoryPressure 函数， 作用是返回 是否内存不足
// 3. 记录节点状态事件函数（调用client-go的记录事件函数）
func MemoryPressureCondition(nowFunc func() time.Time, // typically Kubelet.clock.Now
	pressureFunc func() bool, // typically Kubelet.evictionManager.IsUnderMemoryPressure
	recordEventFunc func(eventType, event string), // typically Kubelet.recordNodeStatusEvent
) Setter {
	return func(ctx context.Context, node *v1.Node) error {
		currentTime := metav1.NewTime(nowFunc())
		var condition *v1.NodeCondition

		// Check if NodeMemoryPressure condition already exists and if it does, just pick it up for update.
		for i := range node.Status.Conditions {
			if node.Status.Conditions[i].Type == v1.NodeMemoryPressure {
				condition = &node.Status.Conditions[i]
			}
		}

		newCondition := false
		// If the NodeMemoryPressure condition doesn't exist, create one
		if condition == nil {
			condition = &v1.NodeCondition{
				Type:   v1.NodeMemoryPressure,
				Status: v1.ConditionUnknown,
			}
			// cannot be appended to node.Status.Conditions here because it gets
			// copied to the slice. So if we append to the slice here none of the
			// updates we make below are reflected in the slice.
			newCondition = true
		}

		// Update the heartbeat time
		condition.LastHeartbeatTime = currentTime

		// Note: The conditions below take care of the case when a new NodeMemoryPressure condition is
		// created and as well as the case when the condition already exists. When a new condition
		// is created its status is set to v1.ConditionUnknown which matches either
		// condition.Status != v1.ConditionTrue or
		// condition.Status != v1.ConditionFalse in the conditions below depending on whether
		// the kubelet is under memory pressure or not.
		if pressureFunc() {
			if condition.Status != v1.ConditionTrue {
				condition.Status = v1.ConditionTrue
				condition.Reason = "KubeletHasInsufficientMemory"
				condition.Message = "kubelet has insufficient memory available"
				condition.LastTransitionTime = currentTime
				recordEventFunc(v1.EventTypeNormal, "NodeHasInsufficientMemory")
			}
		} else if condition.Status != v1.ConditionFalse {
			condition.Status = v1.ConditionFalse
			condition.Reason = "KubeletHasSufficientMemory"
			condition.Message = "kubelet has sufficient memory available"
			condition.LastTransitionTime = currentTime
			recordEventFunc(v1.EventTypeNormal, "NodeHasSufficientMemory")
		}

		if newCondition {
			node.Status.Conditions = append(node.Status.Conditions, *condition)
		}
		return nil
	}
}
```

