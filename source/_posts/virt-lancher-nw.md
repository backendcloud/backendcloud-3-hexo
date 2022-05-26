---
title: KubeVirt virt-lancher 网络
readmore: true
date: 2022-05-26 16:19:20
categories: KubeVirt
tags:
- KubeVirt
- virt-lancher
- 网络
---


# virt-launcher virtwrap 准备虚拟机的网络
virt-launcher pod 和 虚拟机一一对应，在pod中运行一台虚拟机， virt-launcher pod负责提供运行虚拟机必要的组件。本篇文章是介绍网络相关的组件。下图是KubeVirt的网络。图中的Kubetnets的CNI网络插件部分不是本篇涉及内容。
![](/images/virt-lancher-nw_images/a0f12de2.png)

\kubevirt\pkg\virt-launcher\virtwrap\manager.go 中的 func (l *LibvirtDomainManager) preStartHook(vm *v1.VirtualMachine, domain *api.Domain) (*api.Domain, error) 调用 SetupPodNetwork 方法给虚拟机准备网络。

\kubevirt\pkg\virt-launcher\virtwrap\network\network.go SetupPodNetwork → SetupDefaultPodNetwork 该方法做了三件事，对应下面三个方法
* discoverPodNetworkInterface
* preparePodNetworkInterface 
* StartDHCP

## discoverPodNetworkInterface
This function gathers the following information about the pod interface:
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
因容器的IP和MAC地址都将来会通过DHCP传给容器里的虚拟机，所以需要对原容器的网路做如下操作：
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
DHCP服务只能给DHCP客户端（将来创建的虚拟机）提供1个IP地址，除了IP，网关信息，路由信息都会提供。
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