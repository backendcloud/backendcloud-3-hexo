---
title: KubeVirt对实时内核的支持
readmore: true
date: 2022-06-30 18:29:35
categories: 云原生
tags:
- KubeVirt
- RT
---

# KubeVirt对实时内核的支持的相关代码分析

> 实时追求的是cpu响应的低延时，不是高性能，相反实时的性能是很差的，因为在性能和低延时天平上完全导向了低延时，就是那性能交换了低延时。

> 本篇是关于KubeVirt对实时内核的支持，首先KubeVirt启动的虚拟机的镜像系统需要是实时内核的操作系统。

以下代码，检测到虚拟机manifest的实时配置为enable，则去配置下VCPUScheduler和PMU。为了实现实时，优化了cpu的调度以及绑核，PMU（Performance Monitoring Unit）设置为off，就是关闭了cpu性能监控单元。
```go
...
	if vmi.IsRealtimeEnabled() {
		// RT settings
		// To be configured by manifest
		// - CPU Model: Host Passthrough
		// - VCPU (placement type and number)
		// - VCPU Pin (DedicatedCPUPlacement)
		// - USB controller should be disabled if no input type usb is found
		// - Memballoning can be disabled when setting 'autoattachMemBalloon' to false
		formatVCPUScheduler(domain, vmi)
		domain.Spec.Features.PMU = &api.FeatureState{State: "off"}
	}
...

func formatVCPUScheduler(domain *api.Domain, vmi *v12.VirtualMachineInstance) {

	var mask string
	if len(strings.TrimSpace(vmi.Spec.Domain.CPU.Realtime.Mask)) > 0 {
		mask = vmi.Spec.Domain.CPU.Realtime.Mask
	} else {
		mask = "0"
		if len(domain.Spec.CPUTune.VCPUPin) > 1 {
			mask = fmt.Sprintf("0-%d", len(domain.Spec.CPUTune.VCPUPin)-1)
		}
	}
	domain.Spec.CPUTune.VCPUScheduler = &api.VCPUScheduler{Scheduler: api.SchedulerFIFO, Priority: uint(1), VCPUs: mask}
}
```

> virtwrap就如其名，在libvirt外又包了一层，convert是vmi manifest转成libvirt xml define。

> 为了达到最佳的实时效果，除了代码对实时的适配外，还需要虚拟机manifest的配置，业务应用的对分配cpu的核的绑定配置。

> cpu绑核的代码，numa的代码过于复杂，本篇略过，下面讲下对虚拟机manifest的配置

## MemBalloon 虚拟机的内存热插拔技术
MemBalloon是虚拟机的内存热插拔技术，可以设定内存的上限，可以在虚拟机运行过程中，动态修改内存的根数和每根内存的大小。允许该特性会影响实时效果。可以通过virsh cli配置

    virsh setmaxmem <domain> --size <max_size>
    virsh start <domain>
    virsh setmem <domain> --size <mem_size>

也可以通过xml define来配置

    <memballoon model='virtio' autodeflate='on'>

还可以在没有libevirt的情况下通过qemu配置

    -device virtio-balloon,automatic=true

## PMU（Performance Monitoring Unit）

虚拟性能监控单元 (PMU) 可以显示虚拟机cpu运行的统计信息。PMU可以帮助用户识别和分析他们的业务影响虚拟机的性能可能出现问题的来源。

但开启PMU会影响CPU的响应延时。可以牺牲调试工具来换取实时性。

验证系统是否开启了PMU可以执行下面的命令查看 CPU 上的 arch_perfmon 标志，若有内容就已经开启，没有任何返回则不支持或已关闭

    # cat /proc/cpuinfo|grep arch_perfmon

若要启用 PMU，需要将guest vm XML 中的 cpu 模式指定为 host-passthrough：

    # virsh dumpxml guest_name |grep "cpu mode"
    <cpu mode='host-passthrough'>

虚拟机启动好了后，进入虚拟机执行yum install -y perf就可以通过perf工具显示虚拟机的性能统计数据。


## 实时虚拟机manifest配置参考：

```yaml
apiVersion: kubevirt.io/v1
kind: VirtualMachineInstance
spec:
  domain:
    cpu:
      dedicatedCpuPlacement: true
      isolateEmulatorThread: true
    resources:
      limits:
        cpu: 2
        memory: 2Gi
```

```yaml
spec.domain.devices.autoattachSerialConsole: true
spec.domain.devices.autoattachMemBalloon: false
spec.domain.devices.autoattachGraphicsDevice: false

spec.domain.cpu.model: host-passthrough
spec.domain.cpu.dedicateCpuPlacement: true
spec.domain.cpu.isolateEmulatorThread: true
spec.domain.cpu.ioThreadsPolicy: auto

spec.domain.cpu.numa.guestMappingPassthrough: {}
spec.domain.memory.hugepages.pageSize: 1Gi

spec.domain.cpu.realtime.mask: 0

spec.domain.cpu.realtime: {}
```
