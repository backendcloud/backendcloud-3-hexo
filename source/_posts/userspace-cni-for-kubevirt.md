---
title: intel userspace cni 适配 Kubevirt
readmore: true
date: 2022-06-24 19:09:27
categories:
tags:
- DPDK
- userspace cni
- ovs cni
- KubeVirt
---

# intel userspace cni 适配 Kubevirt

虽然KubeVirt还没官方支持DPDK，但intel userspace cni已经为KubeVirt做了一些适配。

有以下3点适配：
* vhost user client&server
* emptyDir
* ovs&qemu privilege

## vhost user client&server
kubevirt 使用DPDK需要用到intel的网络插件userspace cni，该插件使得ovs工作在client模式，kubevirt使得qemu工作在server模式。

> 关于 ovs&kubevirt vhost user client&server 参考 <a href="https://www.backendcloud.cn/2022/06/20/kubevirt-with-dpdk/#For-vhost-user-client-ports-Open-vSwitch-acts-as-the-client-and-QEMU-the-server" target="_blank">https://www.backendcloud.cn/2022/06/20/kubevirt-with-dpdk/#For-vhost-user-client-ports-Open-vSwitch-acts-as-the-client-and-QEMU-the-server</a>

> 本篇是关于intel userspace cni，所以本篇只涉及ovs工作在client模式，qemu工作在server模式参考 <a href="https://www.backendcloud.cn/2022/06/20/kubevirt-with-dpdk/" target="_blank">https://www.backendcloud.cn/2022/06/20/kubevirt-with-dpdk/</a>

cniovs/ovsctrl.go
```go
func createVhostPort(sock_dir string, sock_name string, client bool, bridge_name string) (string, error) {
	var err error
	type_str := "type=dpdkvhostuser"
	if client {
		type_str = "type=dpdkvhostuserclient"
	}
	// COMMAND: ovs-vsctl add-port <bridge_name> <sock_name> -- set Interface <sock_name> type=<dpdkvhostuser|dpdkvhostuserclient>
	cmd := "ovs-vsctl"
	args := []string{"add-port", bridge_name, sock_name, "--", "set", "Interface", sock_name, type_str}

	if client == true {
		socketarg := "options:vhost-server-path=" + sock_dir
		if sock_dir[len(sock_dir)-1] != '/' {
			socketarg += "/"
		}
		socketarg += sock_name
		logging.Debugf("Additional string: %s", socketarg)

		args = append(args, socketarg)
	}
	if _, err = execCommand(cmd, args); err != nil {
		return "", err
	}
	if client == false {
		// Determine the location OvS uses for Sockets. Default location can be
		// overwritten with environmental variable: OVS_SOCKDIR
		ovs_socket_dir, ok := os.LookupEnv("OVS_SOCKDIR")
		if ok == false {
			ovs_socket_dir = defaultOvSSocketDir
		}
		// Move socket to defined dir for easier mounting
		err = os.Rename(ovs_socket_dir+sock_name, sock_dir+sock_name)
		if err != nil {
			logging.Errorf("Rename ERROR: %v", err)
			err = nil
			//deleteVhostPort(sock_name, bridge_name)
		}
	}
	return sock_name, err
}
```

> 上面代码只需要关注client == true的部分，另一种client == false已经废弃，execCommand(cmd, args)方法执行了ovs-vsctl add-port COMMAND: ovs-vsctl add-port <bridge_name> <sock_name> -- set Interface <sock_name> type=<dpdkvhostuser|dpdkvhostuserclient>

## emptyDir
volumeMount.HostPath.Path基础上增加volumeMount.EmptyDir提供给libevirt容器podvolumemount使用，emptyDir用于创建vhostuser socket

pkg/annotations/annotations.go
```go
const (
    ...
	volMntKeySharedDir      = "shared-dir"
	DefaultHostkubeletPodBaseDir  = "/var/lib/kubelet/pods/"
	DefaultHostEmptyDirVolumeName = "volumes/kubernetes.io~empty-dir/"
)

func GetPodVolumeMountHostSharedDir(pod *v1.Pod) (string, error) {
	var hostSharedDir string
	logging.Verbosef("GetPodVolumeMountSharedDir: type=%T Volumes=%v", pod.Spec.Volumes, pod.Spec.Volumes)
	if len(pod.Spec.Volumes) == 0 {
		return hostSharedDir, &NoSharedDirProvidedError{"Error: No Volumes. Need \"shared-dir\" in podSpec \"Volumes\""}
	}

	for _, volumeMount := range pod.Spec.Volumes {
		if volumeMount.Name == volMntKeySharedDir {
			if volumeMount.HostPath != nil {
				hostSharedDir = volumeMount.HostPath.Path
			} else if volumeMount.EmptyDir != nil {
				hostSharedDir = DefaultHostkubeletPodBaseDir + string(pod.UID) + "/" + DefaultHostEmptyDirVolumeName + volMntKeySharedDir
			} else {
				return hostSharedDir, &NoSharedDirProvidedError{"Error: Volume is invalid"}
			}
			break
		}
	}
	if len(hostSharedDir) == 0 {
		return hostSharedDir, &NoSharedDirProvidedError{"Error: No shared-dir. Need \"shared-dir\" in podSpec \"Volumes\""}
	}
	return hostSharedDir, nil
}
```
> host提供给VolumeMount的host volume增加emptyDir，命名看上去很长 DefaultHostkubeletPodBaseDir + string(pod.UID) + "/" + DefaultHostEmptyDirVolumeName + volMntKeySharedDir
>
> unix socket有108长度的限制，可以通过下面一段代码mount的一个短的path来缩短host user socket path长度。

cniovs/cniovs.go
```go
const (
	defaultBridge               = "br0"
	DefaultHostVhostuserBaseDir = "/var/lib/vhost_sockets/"
)

func getShortSharedDir(sharedDir string) string {
	// sun_path for unix domain socket has a array size of 108
	// When the sharedDir path length greater than 89 (108 - 19)
	// 19 is the possible vhostuser socke file name length "/abcdefghijkl-net99" (1 + 12 + 1 + 3 + 2)
	if len(sharedDir) >= 89 && strings.Contains(sharedDir, "empty-dir") {
		// Format - /var/lib/kubelet/pods/<podID>/volumes/kubernetes.io~empty-dir/shared-dir
		parts := strings.Split(sharedDir, "/")
		podID := parts[5]
		newSharedDir := DefaultHostVhostuserBaseDir + podID
		logging.Infof("getShortSharedDir: Short shared directory: %s", newSharedDir)
		return newSharedDir
	}
	return sharedDir

}

func createSharedDir(sharedDir, oldSharedDir string) error {
	var err error

	_, err = os.Stat(sharedDir)
	if os.IsNotExist(err) {
		err = os.MkdirAll(sharedDir, 0750)
		if err != nil {
			logging.Errorf("createSharedDir: Failed to create dir (%s): %v", sharedDir, err)
			return err
		}

		if strings.Contains(sharedDir, DefaultHostVhostuserBaseDir) {
			logging.Debugf("createSharedDir: Mount from %s to %s", oldSharedDir, sharedDir)
			err = unix.Mount(oldSharedDir, sharedDir, "", unix.MS_BIND, "")
			if err != nil {
				logging.Errorf("createSharedDir: Failed to bind mout: %s", err)
				return err
			}
		}
		return nil

	}
	return err
}
```


> Why is the maximal path length allowed for unix-sockets on linux 108?
> 参考 https://www4.cs.fau.de/Services/Doc/C/libc.html#TOC189
> 章节 Sockets - The File Namespace - Details of File Namespace

## ovs&qemu privilege
conf.HostConf.VhostConf.Group 配置一个"group"名称，默认配置为"hugetlbfs"，用于vhostuser socket的权限设定。让ovs和qemu用户在同一个用户组中，使得vhostuser socket在他们中可以共享，避免出现低权限访问不了高权限的情况。

```go
func setSharedDirGroup(sharedDir string, group string) error {
	groupInfo, err := user.LookupGroup(group)
	if err != nil {
		return err
	}

	logging.Debugf("setSharedDirGroup: group %s's gid is %s", group, groupInfo.Gid)
	gid, err := strconv.Atoi(groupInfo.Gid)
	if err != nil {
		return err
	}

	err = os.Chown(DefaultHostVhostuserBaseDir, -1, gid)
	if err != nil {
		return err
	}

	err = os.Chown(sharedDir, -1, gid)
	if err != nil {
		return err
	}
	return nil
}

func addLocalDeviceVhost(conf *types.NetConf, args *skel.CmdArgs, actualSharedDir string, data *OvsSavedData) error {
	...
	group := conf.HostConf.VhostConf.Group
	if group != "" {
		err = setSharedDirGroup(sharedDir, group)
		if err != nil {
			logging.Errorf("addLocalDeviceVhost: Failed to set shared dir group: %v", err)
			return err
		}
	}
	...
}
```