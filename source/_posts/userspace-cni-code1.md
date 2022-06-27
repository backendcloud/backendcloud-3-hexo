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

最近搞KubeVirt的代码和理解DPDK，太复杂了弄得想吐。对kubevirt和cni和网络和dpdk的理解是搞kubevirt dpdk的基础，对k8s的理解又是搞kubevirt的基础，对k8s的各种组件和k8s生态和开发方式的理解又是搞k8s的基础。没完没了的发散。发散到了一个intel的网络插件，一看代码发现简短简单，换个脑子，先梳理下intel userspace cni的源码，继续搞KubeVirt去。

```bash
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
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"path"
	"testing"

	"github.com/intel/userspace-cni-network-plugin/pkg/annotations"
	"github.com/intel/userspace-cni-network-plugin/userspace/testdata"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestSaveConfig(t *testing.T) {
	args := testdata.GetTestArgs()

	testCases := []struct {
		name string
		data *OvsSavedData
	}{
		{
			name: "save and load data 1",
			data: &OvsSavedData{Vhostname: "vhost0", VhostMac: "fe:ed:de:ad:be:ef", IfMac: "co:co:ca:fe:da:da"},
		},
		{
			name: "save and load data 2",
			data: &OvsSavedData{VhostMac: "fe:ed:de:ad:be:ef", IfMac: "co:co:ca:fe:da:da"},
		},
		{
			name: "save and load data 3",
			data: &OvsSavedData{VhostMac: "fe:ed:de:ad:be:ef"},
		},
		{
			name: "save and load data 4",
			data: &OvsSavedData{},
		},
	}
	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			var data OvsSavedData
			require.NoError(t, SaveConfig(nil, args, tc.data), "Unexpected error")
			require.NoError(t, LoadConfig(nil, args, &data), "Can't read stored data")
			assert.Equal(t, tc.data, &data, "Unexpected data retrieved")
		})

	}
}

func TestLoadConfig(t *testing.T) {
	args := testdata.GetTestArgs()

	testCases := []struct {
		name     string
		jsonFile string
		expErr   error
		expData  *OvsSavedData
	}{
		// test error cases; Successful config load is tested by TestSaveConfig
		{
			name:     "no file with saved data",
			jsonFile: "none",
			expErr:   nil,
			expData:  &OvsSavedData{},
		},
		{
			name:     "fail to load corrupted JSON",
			jsonFile: "corrupted",
			expErr:   errors.New("ERROR: Failed to parse"),
			expData:  &OvsSavedData{},
		},
		{
			name:     "fail to read broken file",
			jsonFile: "directory",
			expErr:   errors.New("ERROR: Failed to read"),
			expData:  &OvsSavedData{},
		},
	}
	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			localDir := annotations.DefaultLocalCNIDir
			fileName := fmt.Sprintf("local-%s-%s.json", args.ContainerID[:12], args.IfName)
			if _, err := os.Stat(localDir); err != nil {
				require.NoError(t, os.MkdirAll(localDir, 0700), "Can't create data dir")
				defer os.RemoveAll(localDir)
			}
			path := path.Join(localDir, fileName)

			switch tc.jsonFile {
			case "none":
				require.NoFileExists(t, path, "Saved configuration shall not exist")
			case "corrupted":
				require.NoError(t, ioutil.WriteFile(path, []byte("{"), 0644), "Can't create test file")
				defer os.Remove(path)
			case "directory":
				require.NoError(t, os.Mkdir(path, 0700), "Can't create test dir")
				defer os.RemoveAll(path)
			}
			var data OvsSavedData
			err := LoadConfig(nil, args, &data)
			if tc.expErr == nil {
				assert.Equal(t, tc.expErr, err, "Unexpected result")
			} else {
				require.Error(t, err, "Unexpected result")
				assert.Contains(t, err.Error(), tc.expErr.Error(), "Unexpected result")
			}
			assert.Equal(t, tc.expData, &data, "Unexpected result")
		})

	}
}
```

