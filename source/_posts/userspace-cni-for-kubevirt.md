---
title: intel userspace cni 适配 Kubevirt（workinprocess）
readmore: true
date: 2022-06-24 19:09:27
categories:
tags:
- DPDK
- userspace cni
- ovs cni
- KubeVirt
---

虽然KubeVirt还没官方支持DPDK，但intel userspace cni已经为KubeVirt做了一些适配。

主要是3点适配：
* vhost user client&server
* emptyDir
* ovs&qemu privilege

# vhost user client&server
kubevirt 使用DPDK需要用到intel的网络插件userspace cni，该插件使得ovs工作在client模式，kubevirt使得qemu工作在server模式。

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

> 关于 ovs&kubevirt vhost user client&server 参考 <a href="https://www.backendcloud.cn/2022/06/20/kubevirt-with-dpdk/#For-vhost-user-client-ports-Open-vSwitch-acts-as-the-client-and-QEMU-the-server" target="_blank">https://www.backendcloud.cn/2022/06/20/kubevirt-with-dpdk/#For-vhost-user-client-ports-Open-vSwitch-acts-as-the-client-and-QEMU-the-server</a>

# emptyDir
An empty directory can be used in the libvirt container, which
create vhostuser socket in a specific kubelet directory. Since
the directory length exceeds the limit 108 characheters, this
directory is mounted to a local directory in order to shorten
the vhostuser path added to ovs.

pkg/annotations/annotations.go
```go
func GetPodVolumeMountHostSharedDir(pod *v1.Pod) (string, error) {
	var hostSharedDir string
	@@ -71,7 +70,13 @@ func GetPodVolumeMountHostSharedDir(pod *v1.Pod) (string, error) {

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


> Why is the maximal path length allowed for unix-sockets on linux 108?
> 参考 https://www4.cs.fau.de/Services/Doc/C/libc.html#TOC189 
> 章节 Sockets - The File Namespace - Details of File Namespace

# ovs&qemu privilege
Also added a "group" name input for the vhostuser socket
so that when OvS is running as reduced privilege
openvswitch:hugetlbfs and qemu runs with group as
hugetlbfs, the vhostuser socket will be shareable between
them.
