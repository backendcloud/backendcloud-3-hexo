---
title: KubeVirt网络源码分析（1）
readmore: true
date: 2022-05-26 16:19:20
categories: KubeVirt
tags:
- KubeVirt
- virt-lancher
- 网络
---

kubevirt 以 CRD 形式将 VM 管理接口接入到kubernetes，通过一个pod去使用libvirtd管理VM方式，实现pod与VM的一对一对应，做到如同容器一般去管理虚拟机，并且做到与容器一样的资源管理、调度规划。

在解释Kubevirt如何执行VM网络配置之前，先将POD网络配置和VM网络配置概念分开。POD网络配置本篇不涉及。Kubernetes负责通过CNI根据其配置来设置POD网络，之后POD可以连通外面的世界。

Kubevirt的网络部分是VM网络配置，一般称为绑定。

# virt-launcher virtwrap 准备虚拟机的网络
virt-launcher pod 和 虚拟机一一对应，在pod中运行一台虚拟机， virt-launcher pod负责提供运行虚拟机必要的组件。本篇文章是介绍网络相关的组件。下图是KubeVirt的网络。图中的Kubetnets的CNI网络插件部分不是本篇涉及内容。
![](/images/virt-lancher-nw_images/a0f12de2.png)
> 三个包含关系的实线框，从外到里分别是：Kubernetes工作节点、工作节点上的POD、POD里运行的VM虚拟机
> 三个并列的虚线框，从下到上分别是：Kubernetes网络（Kubernetes CNI负责配置），libvirt网络，虚拟机网络
> 本篇不涉及Kubernetes网络，只涉及libvirt网络，虚拟机网络

`\kubevirt\pkg\virt-launcher\virtwrap\manager.go` 中的 `func (l *LibvirtDomainManager) preStartHook(vm *v1.VirtualMachine, domain *api.Domain) (*api.Domain, error)` 调用 `SetupPodNetwork` 方法给虚拟机准备网络。

`\kubevirt\pkg\virt-launcher\virtwrap\network\network.go` `SetupPodNetwork → SetupDefaultPodNetwork` 该方法做了三件事，对应下面三个方法
* discoverPodNetworkInterface
* preparePodNetworkInterface 
* StartDHCP

## discoverPodNetworkInterface
该方法收集pod interface如下信息：
* IP地址
* 路由
* 网关地址
* MAC地址
这些信息会传递给DHCP服务，DHCP服务会将这些信息传递给（在虚拟机启动后，现在是网络准备阶段）虚拟机（虚拟机作为DHCP客户端）。
```go
func discoverPodNetworkInterface(nic *VIF) (netlink.Link, error) {
	nicLink, err := Handler.LinkByName(podInterface)
	if err != nil {
		log.Log.Reason(err).Errorf("failed to get a link for interface: %s", podInterface)
		return nil, err
	}

	// get IP address
	addrList, err := Handler.AddrList(nicLink, netlink.FAMILY_V4)
	if err != nil {
		log.Log.Reason(err).Errorf("failed to get an ip address for %s", podInterface)
		return nil, err
	}
	if len(addrList) == 0 {
		return nil, fmt.Errorf("No IP address found on %s", podInterface)
	}
	nic.IP = addrList[0]

	// Get interface gateway
	routes, err := Handler.RouteList(nicLink, netlink.FAMILY_V4)
	if err != nil {
		log.Log.Reason(err).Errorf("failed to get routes for %s", podInterface)
		return nil, err
	}
	if len(routes) == 0 {
		return nil, fmt.Errorf("No gateway address found in routes for %s", podInterface)
	}
	nic.Gateway = routes[0].Gw
	if len(routes) > 1 {
		dhcpRoutes := filterPodNetworkRoutes(routes, nic)
		nic.Routes = &dhcpRoutes
	}

	// Get interface MAC address
	mac, err := Handler.GetMacDetails(podInterface)
	if err != nil {
		log.Log.Reason(err).Errorf("failed to get MAC for %s", podInterface)
		return nil, err
	}
	nic.MAC = mac
	return nicLink, nil
} 
```

## preparePodNetworkInterfaces
因容器的IP和MAC地址都将来会通过DHCP传给容器里的虚拟机，所以要用`preparePodNetworkInterfaces`方法对原容器的网路做如下操作：
* 删除POD的的interface的IP地址
* 将POD的interface down
* 修改POD的interface mac地址，换一个MAC任意的MAC地址，只要和原来的MAC不一样，因为原来的MAC地址要给虚拟机，同一个网桥的不同端口的MAC地址不能一样
* 将POD的interface up
* 创建网桥，名称代码里固定死了，为br1
* 将POD的interface绑到br1上，将来虚拟机创建出来后也会绑到br1网桥上
```go
func preparePodNetworkInterfaces(nic *VIF, nicLink netlink.Link) error {
	// Remove IP from POD interface
	err := Handler.AddrDel(nicLink, &nic.IP)

	if err != nil {
		log.Log.Reason(err).Errorf("failed to delete link for interface: %s", podInterface)
		return err
	}

	// Set interface link to down to change its MAC address
	err = Handler.LinkSetDown(nicLink)
	if err != nil {
		log.Log.Reason(err).Errorf("failed to bring link down for interface: %s", podInterface)
		return err
	}

	_, err = Handler.ChangeMacAddr(podInterface)
	if err != nil {
		return err
	}

	err = Handler.LinkSetUp(nicLink)
	if err != nil {
		log.Log.Reason(err).Errorf("failed to bring link up for interface: %s", podInterface)
		return err
	}

	// Create a bridge
	bridge := &netlink.Bridge{
		LinkAttrs: netlink.LinkAttrs{
			Name: api.DefaultBridgeName,
		},
	}
	err = Handler.LinkAdd(bridge)
	if err != nil {
		log.Log.Reason(err).Errorf("failed to create a bridge")
		return err
	}
	netlink.LinkSetMaster(nicLink, bridge)

	err = Handler.LinkSetUp(bridge)
	if err != nil {
		log.Log.Reason(err).Errorf("failed to bring link up for interface: %s", api.DefaultBridgeName)
		return err
	}

	// set fake ip on a bridge
	fakeaddr, err := Handler.ParseAddr(bridgeFakeIP)
	if err != nil {
		log.Log.Reason(err).Errorf("failed to bring link up for interface: %s", api.DefaultBridgeName)
		return err
	}

	if err := Handler.AddrAdd(bridge, fakeaddr); err != nil {
		log.Log.Reason(err).Errorf("failed to set macvlan IP")
		return err
	}

	return nil
}
```

## StartDHCP → DHCPServer → SingleClientDHCPServer
DHCP服务只能给DHCP客户端（将来创建的虚拟机）提供1个IP地址，除了IP，网关信息，路由信息都会提供。`SingleClientDHCPServer`该方法启动一个只提供一个DHCP Client的DHCP服务端。
```go
func (h *NetworkUtilsHandler) StartDHCP(nic *VIF, serverAddr *netlink.Addr) {
	nameservers, searchDomains, err := getResolvConfDetailsFromPod()
	if err != nil {
		log.Log.Errorf("Failed to get DNS servers from resolv.conf: %v", err)
		panic(err)
	}

	// panic in case the DHCP server failed during the vm creation
	// but ignore dhcp errors when the vm is destroyed or shutting down
	if err = DHCPServer(
		nic.MAC,
		nic.IP.IP,
		nic.IP.Mask,
		api.DefaultBridgeName,
		serverAddr.IP,
		nic.Gateway,
		nameservers,
		nic.Routes,
		searchDomains,
	); err != nil {
		log.Log.Errorf("failed to run DHCP: %v", err)
		panic(err)
	}
}
```

> 上面的源码是KubeVirt 0.4.1版本的，以后再对最新的代码的 KubeVirt virt-lancher 网络部分做一次分析。

# 参考 - qemu 创建传统虚拟机以及虚拟机网络流程
```bash
# 创建一个虚拟机镜像，大小为 8G，其中 qcow2 格式为动态分配，raw 格式为固定大小
qemu-img create -f qcow2 ubuntutest.img 8G# 创建虚拟机（可能与下面的启动虚拟机操作重复）
qemu-system-x86_64 -enable-kvm -name ubuntutest -m 2048 -hda ubuntutest.img -cdrom ubuntu-14.04-server-amd64.iso -boot d -vnc :19# 在 Host 机器上创建 bridge br0
brctl addbr br0
# 将 br0 设为 up
ip link set br0 up
# 创建 tap device
tunctl -b# 将 tap0 设为 up
ip link set tap0 up
# 将 tap0 加入到 br0 上
brctl addif br0 tap0
# 启动虚拟机, 虚拟机连接 tap0、tap0 连接 br0
qemu-system-x86_64 -enable-kvm -name ubuntutest -m 2048 -hda ubuntutest.qcow2 -vnc :19 -net nic,model=virtio -nettap,ifname=tap0,script=no,downscript=no# ifconfig br0 192.168.57.1/24
ifconfig br0 192.168.57.1/24# VNC 连上虚拟机，给网卡设置地址，重启虚拟机，可 ping 通 br0# 要想访问外网，在 Host 上设置 NAT，并且 enable ip forwarding，可以 ping 通外网网关。# sysctl -p
net.ipv4.ip_forward = 1
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# 如果 DNS 没配错，可以进行 apt-get update
```