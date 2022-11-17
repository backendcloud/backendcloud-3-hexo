---
title: Kubevirt virtio model
readmore: true
date: 2022-11-16 18:33:00
categories: 云原生
tags:
---

将kubevirt的libvirt替换成在open欧拉下打包的libevirt版本后，同事反馈虚拟机的define xml内容多出了virtio-non-transitional内容，是不是替换libvirt哪里替换出错了。

登录虚拟机对应的virt-launcher pod，virsh list，virsh xmlduml下虚拟机的信息，如下：

```bash
bash-4.4# virsh dumpxml 1|grep virtio
Authorization not available. Check if polkit service is running or see debug message for more information.
    <disk type='file' device='disk' model='virtio-non-transitional'>
      <target dev='vda' bus='virtio'/>
    <disk type='file' device='disk' model='virtio-non-transitional'>
      <target dev='vdb' bus='virtio'/>
    <controller type='scsi' index='0' model='virtio-non-transitional'>
    <controller type='virtio-serial' index='0' model='virtio-non-transitional'>
      <alias name='virtio-serial0'/>
      <model type='virtio-non-transitional'/>
      <target type='virtio' name='org.qemu.guest_agent.0' state='disconnected'/>
      <address type='virtio-serial' controller='0' bus='0' port='1'/>
    <memballoon model='virtio-non-transitional'>
```

看来下libvirt官网 https://libvirt.org/ 对virtio几种模式的说明：

```bash
Virtio transitional devices
Since 5.2.0 , some of QEMU's virtio devices, when used with PCI/PCIe machine types, accept the following model values:

virtio-transitional
This device can work both with virtio 0.9 and virtio 1.0 guest drivers, so it's the best choice when compatibility with older guest operating systems is desired. libvirt will plug the device into a conventional PCI slot.

virtio-non-transitional
This device can only work with virtio 1.0 guest drivers, and it's the recommended option unless compatibility with older guest operating systems is necessary. libvirt will plug the device into either a PCI Express slot or a conventional PCI slot based on the machine type, resulting in a more optimized PCI topology.

virtio
This device will work like a virtio-non-transitional device when plugged into a PCI Express slot, and like a virtio-transitional device otherwise; libvirt will pick one or the other based on the machine type. This is the best choice when compatibility with libvirt versions older than 5.2.0 is necessary, but it's otherwise not recommended to use it.

While the information outlined above applies to most virtio devices, there are a few exceptions:

for SCSI controllers, there is no virtio model available due to historical reasons: use virtio-scsi instead, which behaves the same as virtio does for other devices. Both virtio-transitional and virtio-non-transitional work with SCSI controllers;

some devices, such as GPUs and input devices (keyboard, tablet and mouse), are only defined in the virtio 1.0 spec and as such don't have a transitional variant: the only accepted model is virtio, which will result in a non-transitional device.

For more details see the qemu patch posting and the virtio-1.0 spec.
```

查看了kubevirt的源码，从 kubevirt\staging\src\kubevirt.io\api\core\v1\schema.go Devices结构体 得知：

```go
type Devices struct {
	// Fall back to legacy virtio 0.9 support if virtio bus is selected on devices.
	// This is helpful for old machines like CentOS6 or RHEL6 which
	// do not understand virtio_non_transitional (virtio 1.0).
	UseVirtioTransitional *bool `json:"useVirtioTransitional,omitempty"`
    ...
}
```

```yaml
controlplane $ curl https://kubevirt.io/labs/manifests/vm.yaml
apiVersion: kubevirt.io/v1
kind: VirtualMachine
metadata:
  name: testvm
spec:
  running: false
  template:
    metadata:
      labels:
        kubevirt.io/size: small
        kubevirt.io/domain: testvm
    spec:
      domain:
        devices:
		  useVirtioTransitional: true
          disks:
            - name: containerdisk
              disk:
                bus: virtio
            - name: cloudinitdisk
              disk:
                bus: virtio
          interfaces:
          - name: default
            masquerade: {}
        resources:
          requests:
            memory: 64M
      networks:
      - name: default
        pod: {}
      volumes:
        - name: containerdisk
          containerDisk:
            image: quay.io/kubevirt/cirros-container-disk-demo
        - name: cloudinitdisk
          cloudInitNoCloud:
            userDataBase64: SGkuXG4=
```

在devices下一层级加上`useVirtioTransitional: true`。默认是false，就是默认<model type='virtio-non-transitional'/>，配置成true，就应该是<model type='virtio-transitional'/>可以兼容centos6或更早版本。

```yaml
controlplane $ curl https://kubevirt.io/labs/manifests/vm.yaml
apiVersion: kubevirt.io/v1
kind: VirtualMachine
metadata:
  name: testvm
spec:
  running: false
  template:
    metadata:
      labels:
        kubevirt.io/size: small
        kubevirt.io/domain: testvm
    spec:
      domain:
        devices:
          useVirtioTransitional: true
          disks:
            - name: containerdisk
              disk:
                bus: virtio
            - name: cloudinitdisk
              disk:
                bus: virtio
          interfaces:
          - name: default
            masquerade: {}
        resources:
          requests:
            memory: 64M
      networks:
      - name: default
        pod: {}
      volumes:
        - name: containerdisk
          containerDisk:
            image: quay.io/kubevirt/cirros-container-disk-demo
        - name: cloudinitdisk
          cloudInitNoCloud:
            userDataBase64: SGkuXG4=
```

kubevirt\pkg\virt-launcher\virtwrap\converter\converter.go
```go
func translateModel(ctx *ConverterContext, bus string) string {
	switch bus {
	case "virtio":
		if ctx.UseVirtioTransitional {
			return "virtio-transitional"
		} else {
			return "virtio-non-transitional"
		}
	default:
		return bus
	}
}
```

将yaml文件反序列化成golang结构体后，经过virtwrapper和convert，转成虚拟机所需的xml define文件信息。

ctx.UseVirtioTransitional 的值是根据 vmi.Spec.Domain.Devices.UseVirtioTransitional != nil && *vmi.Spec.Domain.Devices.UseVirtioTransitional 获得。

所以结论是：
1. virt-launcher pod 启动的虚拟机的xml信息 model='virtio-non-transitional' 暂无问题
2. openEuler下打包的Libvirt替换centos stream 8 社区的Libvirt后 暂无问题


