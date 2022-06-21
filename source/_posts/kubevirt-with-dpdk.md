---
title: KubeVirt with DPDK
readmore: true
date: 2022-06-20 19:47:49
categories: 云原生
tags:
- KubeVirt
- DPDK
- userspace-cni
---

Kubernetes优秀的架构设计，借助multus cni + intel userspace cni 可以屏蔽了DPDK底层的复杂，让KubeVirt 支持DPDK变得比较容易。

因为 e2e验证 等原因，KubeVirt社区至今未加入对DPDK支持，本篇试着在最新版的KubeVirt v0.53加入DPDK功能。

# network Phase1 & Phase2

|  | Phase1                                                                                                                                                                                                                                                 | Phase2                                                                                                                                                                          |
|--|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 权限 | 大（privileged networking configuration）                                                                                                                                                                                                                                                      | 小（unprivileged networking configuration）                                                                                                                                                                               |
| 发生场所 | the virt-handler process                                                                                                                                                                                                                                           |  virt-launcher process                                                                                                                                                                    |
| 主要功能 | 第一步是决定改使用哪种 BindMechanism，一旦 BindMechanism 确定，则依次调用以下方法：<br>1. discoverPodNetworkInterface：获取 Pod 网卡设备相关的信息，包括 IP 地址，路由，网关等信息<br>2. preparePodNetworkInterfaces：基于前面获取的信息，配置网络<br>3. setCachedInterface：缓存接口信息在内存中<br>4. setCachedVIF：在文件系统中持久化 VIF 对象 | 和Phase1一样Phase2 也会选择正确的 BindMechanism，然后取得 Phase1 的配置信息（by loading cached VIF object）。基于 VIF 信息， proceed to decorate the domain xml configuration of the VM it will encapsulate |

DPDK不需要Phase1做任何事情，因为不需要获取Pod的网络信息，也不需要缓存Pod的网络和配置vm的网络。

Phase2是基于Phase1的后续，所以DPDK也不需要Phase2做任何事情。

```go
func (l *podNIC) PlugPhase1() error {

	...
	if l.vmiSpecIface.Vhostuser != nil {
		return nil
	}
	...
```

```go
func (l *podNIC) PlugPhase2(domain *api.Domain) error {

	...
	if l.vmiSpecIface.Vhostuser != nil {
		return nil
	}
	...
```

# 准备Pod with DPDK mainifest
pkg/virt-controller/services/template.go
```go
const VhostuserSocketDir = "/var/lib/cni/usrcni/"
const OvsRunDirDefault = "/var/run/openvswitch/"
const PodNetInfoDefault = "/etc/podnetinfo"

func addVhostuserVolumes(volumeMounts *[]k8sv1.VolumeMount, volumes *[]k8sv1.Volume) {
	// "shared-dir" volume name will be used by userspace cni to place the vhostuser socket file`
	*volumeMounts = append(*volumeMounts, k8sv1.VolumeMount{
		Name:      "shared-dir",
		MountPath: VhostuserSocketDir,
	})

	*volumes = append(*volumes, k8sv1.Volume{
		Name: "shared-dir",
		VolumeSource: k8sv1.VolumeSource{
			EmptyDir: &k8sv1.EmptyDirVolumeSource{
				Medium: k8sv1.StorageMediumDefault,
			},
		},
	})

	// Libvirt uses ovs-vsctl commands to get interface stats
	*volumeMounts = append(*volumeMounts, k8sv1.VolumeMount{
		Name:      "ovs-run-dir",
		MountPath: OvsRunDirDefault,
	})
	*volumes = append(*volumes, k8sv1.Volume{
		Name: "ovs-run-dir",
		VolumeSource: k8sv1.VolumeSource{
			HostPath: &k8sv1.HostPathVolumeSource{
				Path: OvsRunDirDefault,
			},
		},
	})
}

func addPodInfoVolumes(volumeMounts *[]k8sv1.VolumeMount, volumes *[]k8sv1.Volume) {
	// userspace cni will set the vhostuser socket details in annotations, app-netutil helper
	// will parse annotations from /etc/podnetinfo to get the interface details of
	// vhostuser socket (which will be added to VM xml)
	*volumeMounts = append(*volumeMounts, k8sv1.VolumeMount{
		Name: "podinfo",
		// TODO: (skramaja): app-netutil expects path to be /etc/podnetinfo, make it customizable
		MountPath: PodNetInfoDefault,
	})
	*volumes = append(*volumes, k8sv1.Volume{
		Name: "podinfo",
		VolumeSource: k8sv1.VolumeSource{
			DownwardAPI: &k8sv1.DownwardAPIVolumeSource{
				Items: []k8sv1.DownwardAPIVolumeFile{
					{
						Path: "labels",
						FieldRef: &k8sv1.ObjectFieldSelector{
							APIVersion: "v1",
							FieldPath:  "metadata.labels",
						},
					},
					{
						Path: "annotations",
						FieldRef: &k8sv1.ObjectFieldSelector{
							APIVersion: "v1",
							FieldPath:  "metadata.annotations",
						},
					},
				},
			},
		},
	})
}

func (t *templateService) renderLaunchManifest(vmi *v1.VirtualMachineInstance, imageIDs map[string]string, tempPod bool) (*k8sv1.Pod, error) {
	...
	if util.IsVhostuserVmi(vmi) {
		...
		addVhostuserVolumes(&volumeMounts, &volumes)
		addPodInfoVolumes(&volumeMounts, &volumes)
		...
	}
	...
```

> 生成类似下面的pod yaml

```yaml
      volumes:
        - name: vhostuser-sockets
          emptyDir: {}
      containers:
        - name: vm
          image: vm-vhostuser:latest
          volumeMounts:
            - name: vhostuser-sockets
              mountPath: /var/run/vm
```

# 准备libvirt xml define
pkg/virt-launcher/virtwrap/converter/network.go
```go
		...
		} else if iface.Vhostuser != nil {
			networks := map[string]*v1.Network{}
			cniNetworks := map[string]int{}
			multusNetworkIndex := 1
			for _, network := range vmi.Spec.Networks {
				numberOfSources := 0
				if network.Pod != nil {
					numberOfSources++
				}
				if network.Multus != nil {
					if network.Multus.Default {
						// default network is eth0
						cniNetworks[network.Name] = 0
					} else {
						cniNetworks[network.Name] = multusNetworkIndex
						multusNetworkIndex++
					}
					numberOfSources++
				}
				if numberOfSources == 0 {
					return nil, fmt.Errorf("fail network %s must have a network type", network.Name)
				} else if numberOfSources > 1 {
					return nil, fmt.Errorf("fail network %s must have only one network type", network.Name)
				}
				networks[network.Name] = network.DeepCopy()
			}

			domainIface.Type = "vhostuser"
			interfaceName := GetPodInterfaceName(networks, cniNetworks, iface.Name)
			vhostPath, vhostMode, err := getVhostuserInfo(interfaceName, c)
			if err != nil {
				log.Log.Errorf("Failed to get vhostuser interface info: %v", err)
				return nil, err
			}
			vhostPathParts := strings.Split(vhostPath, "/")
			vhostDevice := vhostPathParts[len(vhostPathParts)-1]
			domainIface.Source = api.InterfaceSource{
				Type: "unix",
				Path: vhostPath,
				Mode: vhostMode,
			}
			domainIface.Target = &api.InterfaceTarget{
				Device: vhostDevice,
			}
			//var vhostuserQueueSize uint32 = 1024
			domainIface.Driver = &api.InterfaceDriver{
				//RxQueueSize: &vhostuserQueueSize,
				//TxQueueSize: &vhostuserQueueSize,
			}
		}
```

```go
func getVhostuserInfo(ifaceName string, c *ConverterContext) (string, string, error) {
	if c.PodNetInterfaces == nil {
		err := fmt.Errorf("PodNetInterfaces cannot be nil for vhostuser interface")
		return "", "", err
	}
	for _, iface := range c.PodNetInterfaces.Interface {
		if iface.DeviceType == "vhost" && iface.NetworkStatus.Interface == ifaceName {
			return iface.NetworkStatus.DeviceInfo.VhostUser.Path, iface.NetworkStatus.DeviceInfo.VhostUser.Mode, nil
		}
	}
	err := fmt.Errorf("Unable to get vhostuser interface info for %s", ifaceName)
	return "", "", err
}

func GetPodInterfaceName(networks map[string]*v1.Network, cniNetworks map[string]int, ifaceName string) string {
	if networks[ifaceName].Multus != nil && !networks[ifaceName].Multus.Default {
		// multus pod interfaces named netX
		return fmt.Sprintf("net%d", cniNetworks[ifaceName])
	} else {
		return PodInterfaceNameDefault
	}
}
```

> 生成类似下面的libvrit xml define

```xml
        <interface type='vhostuser'>
          <mac address='00:00:00:0A:30:89'/>
          <source type='unix' path='/var/run/vm/sock' mode='server'/>
           <model type='virtio'/>
          <driver queues='2'>
            <host mrg_rxbuf='off'/>
          </driver>
        </interface>
```

# 变更KubeVirt API

staging/src/kubevirt.io/api/core/v1/schema.go
```go
type InterfaceBindingMethod struct {
	Bridge     *InterfaceBridge     `json:"bridge,omitempty"`
	Slirp      *InterfaceSlirp      `json:"slirp,omitempty"`
	Masquerade *InterfaceMasquerade `json:"masquerade,omitempty"`
	SRIOV      *InterfaceSRIOV      `json:"sriov,omitempty"`
	Vhostuser  *InterfaceVhostuser  `json:"vhostuser,omitempty"`
	Macvtap    *InterfaceMacvtap    `json:"macvtap,omitempty"`
}
```

```go
type InterfaceVhostuser struct{}
```

> 支持类似下面的CRD

```yaml
apiVersion: kubevirt.io/v1
kind: VirtualMachineInstance
metadata:
  name: vm-trex-1
spec:
  domain:
    devices:
      interfaces:
      - name: default
        masquerade: {}
      - name: vhost-user-net-1
        vhostuser: {}
  networks:
  - name: default
    pod: {}
  - name: vhost-user-net-1
    multus:
      networkName: userspace-ovs-net-1
```

> 感觉KubeVirt增加DPDK不是很复杂，只是在KubeVirt自动化流程上多加点DPDK相关的pod yaml部分，vm define xml部分。关键是对DPDK功能的验证，今后再开一篇补上验证相关的内容。