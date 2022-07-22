---
title: KubeVirt网络源码分析（3）- 虚拟机热迁移网络
readmore: false
date: 2022-05-30 18:30:24
categories: 云原生
tags:
- KubeVirt
- virt-lancher
- 网络
---

热迁移的流程非常复杂，本篇仅涉及热迁移的数据走的网络相关部分。

# 操作 - 热迁移的网络

虚拟机热迁移过程中很占用带宽，对网络稳定性要求也较高。为和可以原有的Kubernetes网络互不影响，生产环境最好有一套独立的网络给虚拟机热迁移使用。

这就意味着，每个Kubernetes工作节点至少要有两张网卡，所有用于热迁移的网口需要通过交换机实现互通。下面的例子将热迁移的网卡命名为eth1。

首先需要Kubernetes CNI multus 和 ipam whereabouts已经安装好。创建一个NetworkAttachmentDefinition。
```yaml
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: migration-network
  namespace: kubevirt
spec:
  config: '{
      "cniVersion": "0.3.1",
      "name": "migration-bridge",
      "type": "macvlan",
      "master": "eth1",
      "mode": "bridge",
      "ipam": {
        "type": "whereabouts",
        "range": "10.1.1.0/24"
      }
    }'
```
配置KubeVirt虚拟机热迁移流量走上面定义的独立网口。
```yaml
apiVersion: kubevirt.io/v1
kind: Kubevirt
metadata:
  name: kubevirt
  namespace: kubevirt
spec:
  configuration:
    developerConfiguration:
      featureGates:
      - LiveMigration
    migrations:
      network: migration-network
```

```bash
build@jed:~/kubevirt$ kubectl get vmis                                                                                                                                     
NAME             AGE   PHASE     IP               NODENAME   READY                                                                                                         
vmi-migratable   38s   Running   10.244.196.145   node01     True                                                                                                          
build@jed:~/kubevirt$ kubectl get vmis                                                                                                                                     
NAME             AGE   PHASE     IP              NODENAME   READY                                                                                                          
vmi-migratable   41s   Running   10.244.140.88   node02     False
build@jed:~/kubevirt$ kubectl get vmis -o yaml                                                                                                                             
```
```yaml
      targetDirectMigrationNodePorts:                                                                                                                                      
        "32899": 0                                                                                                                                                         
        "39497": 49153                                                                                                                                                     
        "42691": 49152                                                                                                                                                     
      targetNode: node02                                                                                                                                                   
      targetNodeAddress: 10.1.1.1                                                                                                                                          
      targetNodeDomainDetected: true                                                                                                                                       
      targetPod: virt-launcher-vmi-migratable-llcq5                                                                                                                        
    migrationTransport: Unix                                                                                                                                               
    nodeName: node02                                                                                                                                                       
    phase: Running 
```

# livvirt remote url

libvirt remote url格式如下：

    driver[+transport]://[username@][hostname][:port]/[path][?extraparameters]

# KubeVirt 源码分析 - 热迁移的网络

virt-handler 会判断当前的virt-hander所在node是热迁移的源节点还是目的节点，若是源节点，就开启源节点的proxy，若是目的节点，就开启目的节点的proxy。
```go
	if d.isPreMigrationTarget(vmi) {
		return d.vmUpdateHelperMigrationTarget(vmi)
	} else if d.isMigrationSource(vmi) {
		return d.vmUpdateHelperMigrationSource(vmi)
	} else {
		return d.vmUpdateHelperDefault(vmi, domainExists)
	}
```

## 若vmi的迁移状态不为空，vmi的源节点就是当前节点，目的节点不为空，迁移未完成，则进入热迁移的源节点准备流程`handleSourceMigrationProxy`

以下内容为付费内容，可在公众号上查看[文章](https://mp.weixin.qq.com/s/-QnZxl9gARm7w9s5TKiAjQ)