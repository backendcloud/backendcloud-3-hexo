---
title: Go 调用 Openstack API 的 几个简单的 example
date: 2022-05-07 10:05:19
categories: 云原生
tags:
- Go
- Openstack API
- gophercloud
---

使用开源项目 gophercloud 调用 Openstack API，是现在go项目的开发中调用Openstack的主流方案。下面给几个简单的例子：
* 创建 openstackclient
* 创建虚拟机 - 等同于 nova boot --image imageID --flavor flavorID --nic net-id=nicID serverName
* 查询虚拟机列表 - 等同于 nova list
* 查询flavor列表 - 等同于 nova flavor-list

openstack/openstackclient.go
```go
import (
	"github.com/gophercloud/gophercloud"
	"github.com/gophercloud/gophercloud/openstack"
)

type OpenStackClient struct {
	IdentityEndpoint string `json:"identityEndpoint"`
	Region           string `json:"region"`
	ProjectName      string `json:"projectName"`
	ProjectDomain    string `json:"projectDomain"`
	Username         string `json:"username"`
	Password         string `json:"password"`
	DomainName       string `json:"domainName"`
}

func (c *OpenStackClient) GetAuth() (*gophercloud.ProviderClient, error) {
	projectScope := gophercloud.AuthScope{
		ProjectName: c.ProjectName,
		DomainName:  c.ProjectDomain,
	}
	opts := gophercloud.AuthOptions{
		IdentityEndpoint: c.IdentityEndpoint,
		Username:         c.Username,
		Password:         c.Password,
		DomainName:       c.DomainName,
		Scope:            &projectScope,
	}

	provider, err := openstack.AuthenticatedClient(opts)
	if err != nil {
		return nil, err
	}
	return provider, nil
}
```

openstack/server.go
```go
import (
	"github.com/gophercloud/gophercloud"
	"github.com/gophercloud/gophercloud/openstack"
	"github.com/gophercloud/gophercloud/openstack/compute/v2/servers"
)

func (c *OpenStackClient) GetServerProvider() (*gophercloud.ServiceClient, error) {
	provider, err := c.GetAuth()
	if err != nil {
		return nil, err
	}
	return openstack.NewComputeV2(provider, gophercloud.EndpointOpts{
		Region: c.Region,
	})
}

func (c *OpenStackClient) CreateServer(opts servers.CreateOpts) (*servers.Server, error) {
	client, err := c.GetServerProvider()
	if err != nil {
		return nil, err
	}
	return servers.Create(client, opts).Extract()
}

func (c *OpenStackClient) GetServer(serverId string) (*servers.Server, error) {
	client, err := c.GetServerProvider()
	if err != nil {
		return nil, err
	}
	return servers.Get(client, serverId).Extract()
}

func (c *OpenStackClient) ListServer() ([]servers.Server, error) {
	client, err := c.GetServerProvider()
	if err != nil {
		return nil, err
	}
	opts := servers.ListOpts{}
	pager, _ := servers.List(client, opts).AllPages()
	allPages, err := servers.ExtractServers(pager)
	if err != nil {
		return nil, err
	}
	return allPages, nil
}
```

openstack/flavor.go
```go
import (
	"github.com/gophercloud/gophercloud"
	"github.com/gophercloud/gophercloud/openstack"
	"github.com/gophercloud/gophercloud/openstack/compute/v2/flavors"
)

func (c *OpenStackClient) ListFlavors() ([]flavors.Flavor, error) {
	var fls []flavors.Flavor
	provider, err := c.GetAuth()
	if err != nil {
		return fls, err
	}
	client, err := openstack.NewComputeV2(provider, gophercloud.EndpointOpts{
		Region: c.Region,
	})
	if err != nil {
		return fls, err
	}
	pager, err := flavors.ListDetail(client, flavors.ListOpts{}).AllPages()
	if err != nil {
		return fls, err
	}
	allPages, err := flavors.ExtractFlavors(pager)
	if err != nil {
		return fls, err
	}
	//fmt.Println(allPages)
	return allPages, nil
}
```

main.go
```go
import (
	. "demo/openstack"
	"fmt"
	"github.com/gophercloud/gophercloud/openstack/compute/v2/servers"
)

func main() {
	openStackClient := &OpenStackClient{
		IdentityEndpoint: "http://openstack-keystone-vip:35357/v3",
		Region:           "regionone",
		ProjectName:      "admin",
		ProjectDomain:    "Default",
		Username:         "admin",
		Password:         "Admin_PWD_xx",
		DomainName:       "Default",
	}

	// create server
	createServerDetail, err := openStackClient.CreateServer(servers.CreateOpts{
		Name:      "hanwei",
		FlavorRef: "1",
		ImageRef:  "cbd95b01-f714-49d6-96a1-431d7f00d93d",
		Networks: []servers.Network{
			servers.Network{UUID: "a1512f64-3dee-4c56-9bff-d39a1b1f4ddd"}},
	})
	if err != nil {
		panic(err)
	}
	//fmt.Printf("server details: %s\n", createServerDetail)

	// get server by serverId
	serverDetail, err := openStackClient.GetServer(createServerDetail.ID)
	if err != nil {
		panic(err)
	}
	fmt.Printf("server details: %s\n", serverDetail)

	// list all servers
	serverList, err := openStackClient.ListServer()
	for _, s := range serverList {
		fmt.Printf("server id: %s   server name: %s\n", s.ID, s.Name)
	}

}
```