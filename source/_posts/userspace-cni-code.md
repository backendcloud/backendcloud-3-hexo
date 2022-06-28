---
title: intel userspace cni 源码分析(workinprocess)
readmore: true
date: 2022-06-27 18:45:11
categories: 云原生
tags:
- cni
- userspace cni
---

> 基于 截至2022.06.27 最新的 intel userspace cni 源码

最近搞KubeVirt的代码和理解DPDK，涉及东西比计较多，没完没了的发散。发散到了一个intel的网络插件，先梳理下intel userspace cni的源码，再继续搞KubeVirt去。

```bash
# intel userspace cni 大致目录结构，暂时不涉及vpp，忽略vpp的代码
├── cniovs
│   ├── cniovs.go - ovs网络插件
│   ├── cniovs_test.go
│   ├── localdb.go - ovs本地存储
│   ├── localdb_test.go
│   ├── ovsctrl_fake.go
│   ├── ovsctrl.go - 各种ovs-vsctl命令
│   └── ovsctrl_test.go
├── cnivpp
├── docker
├── examples
├── logging
├── pkg
│   ├── annotations
│   │   ├── annotations.go
│   │   └── annotations_test.go
│   ├── configdata
│   │   ├── configdata.go
│   │   └── configdata_test.go
│   ├── k8sclient
│   │   ├── k8sclient.go
│   │   └── k8sclient_test.go
│   └── types
│       └── types.go
├── scripts
├── tests
├── userspace
└── usrspcni
```

cat cniovs/localdb.go
```go
package cniovs

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"

	"github.com/containernetworking/cni/pkg/skel"

	"github.com/intel/userspace-cni-network-plugin/pkg/annotations"
	"github.com/intel/userspace-cni-network-plugin/pkg/configdata"
	"github.com/intel/userspace-cni-network-plugin/pkg/types"
)

// This structure is a union of all the OVS data (for all types of
// interfaces) that need to be preserved for later use.
type OvsSavedData struct {
	Vhostname string `json:"vhostname"` // Vhost Port name
	VhostMac  string `json:"vhostmac"`  // Vhost port MAC address
	IfMac     string `json:"ifmac"`     // Interface Mac address
}

// SaveConfig() - Some data needs to be saved for cmdDel().
//  This function squirrels the data away to be retrieved later.
func SaveConfig(conf *types.NetConf, args *skel.CmdArgs, data *OvsSavedData) error {

	// Current implementation is to write data to a file with the name:
	//   /var/run/ovs/cni/data/local-<ContainerId:12>-<IfName>.json

	fileName := fmt.Sprintf("local-%s-%s.json", args.ContainerID[:12], args.IfName)
	if dataBytes, err := json.Marshal(data); err == nil {
		localDir := annotations.DefaultLocalCNIDir

		if _, err := os.Stat(localDir); err != nil {
			if os.IsNotExist(err) {
				if err := os.MkdirAll(localDir, 0700); err != nil {
					return err
				}
			} else {
				return err
			}
		}

		path := filepath.Join(localDir, fileName)

		return ioutil.WriteFile(path, dataBytes, 0644)
	} else {
		return fmt.Errorf("ERROR: serializing delegate OVS saved data: %v", err)
	}
}

func LoadConfig(conf *types.NetConf, args *skel.CmdArgs, data *OvsSavedData) error {

	fileName := fmt.Sprintf("local-%s-%s.json", args.ContainerID[:12], args.IfName)
	localDir := annotations.DefaultLocalCNIDir
	path := filepath.Join(localDir, fileName)

	if _, err := os.Stat(path); err == nil {
		if dataBytes, err := ioutil.ReadFile(path); err == nil {
			if err = json.Unmarshal(dataBytes, data); err != nil {
				return fmt.Errorf("ERROR: Failed to parse OVS saved data: %v", err)
			}
		} else {
			return fmt.Errorf("ERROR: Failed to read OVS saved data: %v", err)
		}

	} else {
		path = ""
	}

	// Delete file (and directory if empty)
	configdata.FileCleanup(localDir, path)

	return nil
}
```

> OvsSavedData是存储OVS data的数据结构，后面需要json序列号和反序列化，标记json key，
> SaveConfig()方法将OvsSavedData保存至文件/var/run/ovs/cni/data/local-<ContainerId:12>-<IfName>.json
> LoadConfig()和SaveConfig()反过来，将文件内容读到OvsSavedData
> 存储用文件的形式保存OvsSavedData为了给 cmdDel() 方法用

cniovs/ovsctrl.go (代码太长，可以自行github查看，这里为了锁定篇幅仅解释方法) 
> 每个方法对应一条openvswitch命令。
```go
createVhostPort // COMMAND: ovs-vsctl add-port <bridge_name> <sock_name> -- set Interface <sock_name> type=<dpdkvhostuser|dpdkvhostuserclient>
deleteVhostPort // COMMAND: ovs-vsctl del-port <bridge_name> <sock_name>
createBridge // COMMAND: ovs-vsctl add-br <bridge_name> -- set bridge <bridge_name> datapath_type=netdev
configL2Bridge // COMMAND: ovs-ofctl add-flow <bridge_name> actions=NORMAL
deleteBridge // COMMAND: ovs-vsctl del-br <bridge_name>
getVhostPortMac // COMMAND: ovs-vsctl --bare --columns=mac find port name=<sock_name>
findBridge // COMMAND: ovs-vsctl --bare --columns=name find bridge name=<bridge_name>
doesBridgeContainInterfaces // COMMAND: ovs-vsctl list-ports <bridge_name>
```

cniovs/cniovs.go (代码太长，可以自行github查看，这里为了锁定篇幅仅解释方法)
```go
AddOnHost // step1：根据conf.HostConf.BridgeConf.BridgeName创建ovs bridge，若未配置用默认br0代替。step2：创建bridge interface仅支持conf.HostConf.IfType == "vhostuser"一种类型。step3：Save Config - Save Create Data for Delete
DelFromHost // step1：用cniovs/localdb.go 从本地保存的json文件中 Load Config 删除bridge interface，检查brdge，若没有interface则删除bridge
AddOnContainer // Write configuration data(下面的ConfigurationData struct) that will be consumed by container。分2种情况，有k8sclient，k8sclient.WritePodAnnotation写入集群的PodAnnotation。若没有k8sclient，用文件保存信息
DelFromContainer // 调用configdata.FileCleanup方法清理文件夹（文件夹下0个文件则清理文件夹）和文件
addLocalDeviceVhost // 在 AddOnHost 方法中被调用，用于创建vhostuser socket以及相关操作
delLocalDeviceVhost // 在 DelFromHost 方法中被调用，用于删除vhostuser socket以及相关操作  
generateRandomMacAddress // 生成随机mac地址
getShortSharedDir createSharedDir setSharedDirGroup// 这三个方法参考 https://www.backendcloud.cn/2022/06/24/userspace-cni-for-kubevirt/
```

```go
type ConfigurationData struct {
	ContainerId string         `json:"containerId"` // From args.ContainerId, used locally. Used in several place, namely in the socket filenames.
	IfName      string         `json:"ifName"`      // From args.IfName, used locally. Used in several place, namely in the socket filenames.
	Name        string         `json:"name"`        // From NetConf.Name
	Config      UserSpaceConf  `json:"config"`      // From NetConf.ContainerConf
	IPResult    current.Result `json:"ipResult"`    // Network Status also has IP, but wrong format
}
```
