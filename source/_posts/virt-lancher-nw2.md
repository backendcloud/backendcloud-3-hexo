---
title: KubeVirt网络源码分析（2）
readmore: true
date: 2022-05-27 17:43:21
categories: KubeVirt
tags:
- KubeVirt
- virt-lancher
- 网络
---

对上篇分析的是老版本的KubeVirt的网络源码，这篇继续上篇，对目前的最新版本v0.53再做一次源码分析，作为对上篇的补充。

Bridge binding mechanism
```yaml
kind: VM
spec:
  domain:
    devices:
      interfaces:
        - name: default
          bridge: {}
  networks:
  - name: default
    pod: {} # Stock pod network
```

和上篇一样，bridge绑定模式也是有`DiscoverPodNetworkInterface`和`PreparePodNetworkInterface`方法。做的事情大体一样，最大的不同多了一个创建dummy网口的流程。其他的小的迭代功能还有支持vmi crd给虚拟机网口配置的mac地址。

```go
func (b *BridgePodNetworkConfigurator) DiscoverPodNetworkInterface(podIfaceName string) error {
	link, err := b.handler.LinkByName(podIfaceName)
	if err != nil {
		log.Log.Reason(err).Errorf("failed to get a link for interface: %s", podIfaceName)
		return err
	}
	b.podNicLink = link

	addrList, err := b.handler.AddrList(b.podNicLink, netlink.FAMILY_V4)
	if err != nil {
		log.Log.Reason(err).Errorf("failed to get an ip address for %s", podIfaceName)
		return err
	}
	if len(addrList) == 0 {
		b.ipamEnabled = false
	} else {
		b.podIfaceIP = addrList[0]
		b.ipamEnabled = true
		if err := b.learnInterfaceRoutes(); err != nil {
			return err
		}
	}

	b.tapDeviceName = virtnetlink.GenerateTapDeviceName(podIfaceName)

	b.vmMac, err = virtnetlink.RetrieveMacAddressFromVMISpecIface(b.vmiSpecIface)
	if err != nil {
		return err
	}
	if b.vmMac == nil {
		b.vmMac = &b.podNicLink.Attrs().HardwareAddr
	}

	return nil
}
```

```go
func (b *BridgePodNetworkConfigurator) switchPodInterfaceWithDummy() error {
	originalPodInterfaceName := b.podNicLink.Attrs().Name
	newPodInterfaceName := virtnetlink.GenerateNewBridgedVmiInterfaceName(originalPodInterfaceName)
	dummy := &netlink.Dummy{LinkAttrs: netlink.LinkAttrs{Name: originalPodInterfaceName}}

	// Rename pod interface to free the original name for a new dummy interface
	err := b.handler.LinkSetName(b.podNicLink, newPodInterfaceName)
	if err != nil {
		log.Log.Reason(err).Errorf("failed to rename interface : %s", b.podNicLink.Attrs().Name)
		return err
	}

	b.podNicLink, err = b.handler.LinkByName(newPodInterfaceName)
	if err != nil {
		log.Log.Reason(err).Errorf("failed to get a link for interface: %s", newPodInterfaceName)
		return err
	}

	// Create a dummy interface named after the original interface
	err = b.handler.LinkAdd(dummy)
	if err != nil {
		log.Log.Reason(err).Errorf("failed to create dummy interface : %s", originalPodInterfaceName)
		return err
	}

	// Replace original pod interface IP address to the dummy
	// Since the dummy is not connected to anything, it should not affect networking
	// Replace will add if ip doesn't exist or modify the ip
	err = b.handler.AddrReplace(dummy, &b.podIfaceIP)
	if err != nil {
		log.Log.Reason(err).Errorf("failed to replace original IP address to dummy interface: %s", originalPodInterfaceName)
		return err
	}

	return nil
}
```

上面的代码中的方法`switchPodInterfaceWithDummy`做了下面几件事：
1. 更名pod的网口，原来的名称加后缀“-nic”
2. 创建dummy网口，使用上一步更名前的名称
3. 将最早前的ip加到dummy网口上

就会发生下面的效果：

虚拟机的网口：

    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
    valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
    valid_lft forever preferred_lft forever
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 5e:04:61:17:c1:c9 brd ff:ff:ff:ff:ff:ff
    altname enp1s0
    inet 172.16.0.24/26 brd 172.16.0.63 scope global dynamic noprefixroute eth0
    valid_lft 85794782sec preferred_lft 85794782sec
    inet6 fe80::5c04:61ff:fe17:c1c9/64 scope link
    valid_lft forever preferred_lft forever

launcher Pod的网口：

    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
    valid_lft forever preferred_lft forever
    3: eth0-nic@if28: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master k6t-eth0 state UP group default
    link/ether 5e:04:61:bf:d4:04 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    4: eth0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default
    link/ether 0a:80:97:de:c2:56 brd ff:ff:ff:ff:ff:ff
    inet 172.16.0.24/26 brd 172.16.0.63 scope global eth0
    valid_lft forever preferred_lft forever
    5: k6t-eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 1a:2b:ab:44:18:07 brd ff:ff:ff:ff:ff:ff
    inet 169.254.75.10/32 scope global k6t-eth0
    valid_lft forever preferred_lft forever
    6: tap0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master k6t-eth0 state UP group default qlen 1000
    link/ether 36:9c:11:71:fa:d6 brd ff:ff:ff:ff:ff:ff

会发现一个奇怪的现象，launcher Pod的eth0的ip和虚拟机的eth0 ip完全一样。实际上是不会冲突的，因为launcher Pod的eth0就是代码中的dummy网口，不参与任何网络的连接，不会影响任何网络，就是个dummy网口。

那么为什么要这么麻烦，创建一个dummy网口，原来是不这样做，当kubelet重启后，会检查所有的pod的网络，若pod的IP不是预期的，会移除pod。这个是Kubernetes的kubelet的运行机制决定的。

然而KubeVirt在bridge绑定模式的时候，会将pod的ip移给VM，这样pod就没有ip，会被Kubernetes当成pod状态异常，移除pod。这不是想要的结果，所以需要通过创建一个有预期ip的且不会影响KubeVirt网络的dummy网口来愚弄Kubernetes一下。

本篇分析的版本相对上篇分析的版本还有一个不同是，上篇版本网络部分都在virt-lancher中处理，本篇对应版本从virt-lancher中拿出来，分成`phase#1`和`phase#2`。

`phase#1`包含`DiscoverPodNetworkInterface`和`PreparePodNetworkInterface`两个方法方法。`phase#1`会创建一个大概的interface of the vm的domxml。

`phase#2`获取存储的MTU和MAC信息，充实domxml，像这样：

    <interface type='bridge'>
      <mac address='8e:61:55:c2:4a:bd'/>
      <source bridge='k6t-eth0'/>
      <target dev='vnet0'/>
      <model type='virtio'/>
      <mtu size='1440'/>
      <alias name='ua-bridge'/>
      <address type='pci' domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
    </interface>

virt-lancher wrap manager.go中的preStartHook方法`func (l *LibvirtDomainManager) preStartHook(vmi *v1.VirtualMachineInstance, domain *api.Domain, generateEmptyIsos bool) (*api.Domain, error)`会做下面几件事情：
- storage prep
- network prep
- cloud-init
- sysprep

在`network prep`会调用`phase#1` plugin和 `phase#2` plugin。

KubeVirt v0.53目前支持如下绑定方法，本篇仅分析了bridge，以后再分析其他绑定方法。
```go
type InterfaceBindingMethod struct {
	Bridge     *InterfaceBridge     `json:"bridge,omitempty"`
	Slirp      *InterfaceSlirp      `json:"slirp,omitempty"`
	Masquerade *InterfaceMasquerade `json:"masquerade,omitempty"`
	SRIOV      *InterfaceSRIOV      `json:"sriov,omitempty"`
	Macvtap    *InterfaceMacvtap    `json:"macvtap,omitempty"`
}
```