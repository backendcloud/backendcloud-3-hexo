---
title: intel userspace cni 源码分析（1）(workinprocess)
readmore: true
date: 2022-06-27 18:45:11
categories: 云原生
tags:
- cni
- userspace cni
---

> 基于 截至2022.06.27 最新的 intel userspace cni 源码

最近搞KubeVirt的代码和理解DPDK，太复杂了弄得想吐。对kubevirt和cni和网络和dpdk的理解是搞kubevirt dpdk的基础，对k8s的理解又是搞kubevirt的基础，对k8s的各种组件和k8s生态和开发方式的理解又是搞k8s的基础。没完没了的发散。发散到了一个intel的网络插件，一看代码发现简短简单，换个脑子，先梳理下intel userspace cni的源码，再继续搞KubeVirt去。

```bash
# intel userspace cni 大致目录结构，暂时不涉及vpp，忽略vpp的代码
├── cniovs
│   ├── cniovs.go
│   ├── cniovs_test.go
│   ├── localdb.go
│   ├── localdb_test.go
│   ├── ovsctrl_fake.go
│   ├── ovsctrl.go
│   └── ovsctrl_test.go
├── cnivpp
├── docker
│   ├── dpdk-app-centos
│   │   ├── docker-entrypoint.sh
│   │   ├── Dockerfile
│   │   ├── dpdk-args.c
│   │   ├── dpdk-args.h
│   │   ├── l3fwd_eal_init.txt
│   │   ├── l3fwd_parse_args.txt
│   │   ├── l3fwd_substitute.sh
│   │   ├── README.md
│   │   ├── testpmd_eal_init.txt
│   │   ├── testpmd_launch_args_parse.txt
│   │   └── testpmd_substitute.sh
│   ├── usrsp-app
│   │   └── usrsp-app.go
│   └── vpp-centos-userspace-cni
│       ├── 80-vpp.conf
│       ├── Dockerfile
│       ├── README.md
│       ├── startup.conf
│       └── vppcni.sh
├── examples
│   ├── crd-userspace-net-ovs-no-ipam.yaml
│   ├── ovs-vhost
│   │   ├── userspace-ovs-netAttach-1.yaml
│   │   ├── userspace-ovs-netAttach-2.yaml
│   │   ├── userspace-ovs-pod-1.yaml
│   │   └── userspace-ovs-pod-2.yaml
│   ├── pod-multi-vhost.yaml
│   └── vpp-memif-ping
│       ├── kubeConfig
│       │   ├── userspace-vpp-netAttach-1.yaml
│       │   ├── userspace-vpp-netAttach-2.yaml
│       │   ├── userspace-vpp-pod-1.yaml
│       │   └── userspace-vpp-pod-2.yaml
│       └── sharedDir
│           ├── userspace-vpp-netAttach-1.yaml
│           ├── userspace-vpp-netAttach-2.yaml
│           ├── userspace-vpp-pod-1.yaml
│           └── userspace-vpp-pod-2.yaml
├── logging
│   ├── logging.go
│   └── logging_test.go
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
│   ├── dpdk-docker-run.sh
│   └── usrsp-docker-run.sh
├── tests
│   ├── get-prefix.sh
│   ├── multus-sample.conf
│   └── vhostuser-sample.conf
├── userspace
│   ├── testdata
│   │   └── testdata.go
│   ├── userspace.go
│   └── userspace_test.go
└── usrspcni
    └── usrspcni.go
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

