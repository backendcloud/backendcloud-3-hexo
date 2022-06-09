---
title: KubeVirt macvtap虚拟机创建过程 自动实验
readmore: true
date: 2022-06-09 18:33:57
categories: 云原生
tags:
- KubeVirt
- macvtap
- macvtap-cni
- multus-cni
---

继续上篇 <a href="https://www.backendcloud.cn/2022/06/06/macvtap-lab/" target="_blank">https://www.backendcloud.cn/2022/06/06/macvtap-lab/</a>
上篇是纯手动，这篇是借助Kubernetes+KubeVirt自动。

# 部署Kubernetes+KubeVirt
> 部署Kubernetes参考： <a href="https://www.backendcloud.cn/2022/06/02/k8s-4-deploy/#KubeSpray" target="_blank">https://www.backendcloud.cn/2022/06/02/k8s-4-deploy/#KubeSpray</a>

> 用kubepray部署前可以修改配置文件打开multus cni选项

> 部署KubeVirt参考：<a href="https://www.backendcloud.cn/2022/05/06/deploy-kubevirt/#deploy-KubeVirt" target="_blank">https://www.backendcloud.cn/2022/05/06/deploy-kubevirt/#deploy-KubeVirt</a>

# 部署multus cni，macvtap cni，创建macvtap interface vm
```bash
[root@node1 ~]# curl https://raw.githubusercontent.com/kubevirt/macvtap-cni/main/examples/macvtap-deviceplugin-config-explicit.yaml
kind: ConfigMap
apiVersion: v1
metadata:
  name: macvtap-deviceplugin-config
data:
  DP_MACVTAP_CONF: >-
    [ {
        "name" : "dataplane",
        "lowerDevice" : "ens33",
        "mode": "bridge",
        "capacity" : 50
     } ]
[root@node1 ~]# kubectl apply -f https://raw.githubusercontent.com/kubevirt/macvtap-cni/main/examples/macvtap-deviceplugin-config-explicit.yaml
configmap/macvtap-deviceplugin-config created
[root@node1 ~]# curl https://raw.githubusercontent.com/kubevirt/macvtap-cni/main/manifests/macvtap.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: macvtap-cni
  namespace: default
spec:
  selector:
    matchLabels:
      name: macvtap-cni
  template:
    metadata:
      labels:
        name: macvtap-cni
    spec:
      hostNetwork: true
      hostPID: true
      priorityClassName: system-node-critical
      containers:
      - name: macvtap-cni
        command: ["/macvtap-deviceplugin", "-v", "3", "-logtostderr"]
        envFrom:
          - configMapRef:
              name: macvtap-deviceplugin-config
        image: quay.io/kubevirt/macvtap-cni:latest
        imagePullPolicy: Always
        resources:
          requests:
            cpu: "60m"
            memory: "30Mi"
        securityContext:
          privileged: true
        volumeMounts:
          - name: deviceplugin
            mountPath: /var/lib/kubelet/device-plugins
      initContainers:
      - name: install-cni
        command: ["cp", "/macvtap-cni", "/host/opt/cni/bin/macvtap"]
        image: quay.io/kubevirt/macvtap-cni:latest
        imagePullPolicy: Always
        resources:
          requests:
            cpu: "10m"
            memory: "15Mi"
        securityContext:
          privileged: true
        volumeMounts:
          - name: cni
            mountPath: /host/opt/cni/bin
            mountPropagation: Bidirectional
      volumes:
        - name: deviceplugin
          hostPath:
            path: /var/lib/kubelet/device-plugins
        - name: cni
          hostPath:
            path: /opt/cni/bin
[root@node1 ~]# kubectl apply -f https://raw.githubusercontent.com/kubevirt/macvtap-cni/main/manifests/macvtap.yaml
daemonset.apps/macvtap-cni created
[root@node1 ~]# kubectl get pods
NAME                READY   STATUS    RESTARTS   AGE
macvtap-cni-bz47n   1/1     Running   0          96s
[root@node1 ~]# cat nad.yaml 
kind: NetworkAttachmentDefinition
apiVersion: k8s.cni.cncf.io/v1
metadata:
  name: dataplane
  annotations:
    k8s.v1.cni.cncf.io/resourceName: macvtap.network.kubevirt.io/dataplane
spec:
  config: '{
      "cniVersion": "0.3.1",
      "name": "dataplane",
      "type": "macvtap",
      "mtu": 1500
    }'
[root@node1 ~]# kubectl create -f nad.yaml 
networkattachmentdefinition.k8s.cni.cncf.io/dataplane created
[root@node1 ~]# cat macvtap-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: macvtap-pod
  annotations:
    k8s.v1.cni.cncf.io/networks: dataplane
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["/bin/sleep", "1800"]
    resources:
      limits:
        macvtap.network.kubevirt.io/dataplane: 1 
[root@node1 ~]# kubectl create -f macvtap-pod.yaml 
pod/macvtap-pod created
[root@node1 ~]# kubectl get pod
NAME                READY   STATUS    RESTARTS   AGE
macvtap-cni-fzms6   1/1     Running   0          3m1s
macvtap-pod         1/1     Running   0          23s
[root@node1 ~]# kubectl exec -it macvtap-pod -- sh
/ # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
3: eth0@if10: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1450 qdisc noqueue 
    link/ether d2:fb:f6:e0:90:b7 brd ff:ff:ff:ff:ff:ff
    inet 10.233.90.9/32 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::d0fb:f6ff:fee0:90b7/64 scope link 
       valid_lft forever preferred_lft forever
9: net1@if2: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 16:5c:62:d6:17:f4 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::145c:62ff:fed6:17f4/64 scope link 
       valid_lft forever preferred_lft forever
/ # exit
[root@node1 ~]# cat macvtap-pod-with-mac.yaml
apiVersion: v1
kind: Pod
metadata:
  name: macvtap-pod-with-mac
  annotations:
    k8s.v1.cni.cncf.io/networks: |
      [
        {
          "name":"dataplane",
          "mac": "02:23:45:67:89:01"
        }
      ]
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["/bin/sleep", "1800"]
    resources:
      limits:
        macvtap.network.kubevirt.io/dataplane: 1 
[root@node1 ~]# kubectl create -f macvtap-pod-with-mac.yaml 
pod/macvtap-pod-with-mac created
[root@node1 ~]# kubectl get pod
NAME                   READY   STATUS    RESTARTS   AGE
macvtap-cni-fzms6      1/1     Running   0          7m52s
macvtap-pod            1/1     Running   0          5m14s
macvtap-pod-with-mac   1/1     Running   0          13s
[root@node1 ~]# kubectl exec -it macvtap-pod-with-mac -- sh
/ # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
3: eth0@if12: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1450 qdisc noqueue 
    link/ether 3a:c9:74:39:1b:a5 brd ff:ff:ff:ff:ff:ff
    inet 10.233.90.10/32 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::38c9:74ff:fe39:1ba5/64 scope link 
       valid_lft forever preferred_lft forever
11: net1@if2: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 02:23:45:67:89:01 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::23:45ff:fe67:8901/64 scope link 
       valid_lft forever preferred_lft forever
/ # exit
[root@node1 ~]# 
```
> 登录容器执行ip a后发现net1@if2的mac地址和macvtap-pod-with-mac.yaml一致。

查看node的macvtap资源：
```bash
[root@node1 ~]# kubectl describe node
Capacity:
  cpu:                                    4
  ephemeral-storage:                      125251836Ki
  hugepages-1Gi:                          0
  hugepages-2Mi:                          0
  macvtap.network.kubevirt.io/dataplane:  50
  memory:                                 15141680Ki
  pods:                                   110
Allocatable:
  cpu:                                    3800m
  ephemeral-storage:                      115432091867
  hugepages-1Gi:                          0
  hugepages-2Mi:                          0
  macvtap.network.kubevirt.io/dataplane:  50
  memory:                                 14514992Ki
  pods:                                   110
System Info:
  Machine ID:                 291c4d5a11c74407b8c7c40c2f64366e
  System UUID:                9E724D56-7BD3-A8D6-10E8-FECB3AC7D0BC
  Boot ID:                    8c342553-08ac-4795-9e98-3594f3ee9189
  Kernel Version:             3.10.0-1160.el7.x86_64
  OS Image:                   CentOS Linux 7 (Core)
  Operating System:           linux
  Architecture:               amd64
  Container Runtime Version:  containerd://1.6.4
  Kubelet Version:            v1.23.7
  Kube-Proxy Version:         v1.23.7
PodCIDR:                      10.233.64.0/24
PodCIDRs:                     10.233.64.0/24
Non-terminated Pods:          (13 in total)
  Namespace                   Name                                        CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
  ---------                   ----                                        ------------  ----------  ---------------  -------------  ---
  default                     macvtap-cni-fzms6                           60m (1%)      0 (0%)      30Mi (0%)        0 (0%)         15m
  default                     macvtap-pod                                 0 (0%)        0 (0%)      0 (0%)           0 (0%)         12m
  default                     macvtap-pod-with-mac                        0 (0%)        0 (0%)      0 (0%)           0 (0%)         7m41s
  kube-system                 calico-kube-controllers-6dd874f784-hvmvs    30m (0%)      1 (26%)     64M (0%)         256M (1%)      4d15h
  kube-system                 calico-node-vtqr7                           150m (3%)     300m (7%)   64M (0%)         500M (3%)      4d15h
  kube-system                 coredns-76b4fb4578-x6ts9                    100m (2%)     0 (0%)      70Mi (0%)        170Mi (1%)     4d15h
  kube-system                 dns-autoscaler-7874cf6bcf-kv825             20m (0%)      0 (0%)      10Mi (0%)        0 (0%)         4d15h
  kube-system                 kube-apiserver-node1                        250m (6%)     0 (0%)      0 (0%)           0 (0%)         4d15h
  kube-system                 kube-controller-manager-node1               200m (5%)     0 (0%)      0 (0%)           0 (0%)         4d15h
  kube-system                 kube-multus-ds-amd64-c5g9l                  100m (2%)     100m (2%)   90Mi (0%)        90Mi (0%)      4d15h
  kube-system                 kube-proxy-pxcb8                            0 (0%)        0 (0%)      0 (0%)           0 (0%)         4d15h
  kube-system                 kube-scheduler-node1                        100m (2%)     0 (0%)      0 (0%)           0 (0%)         4d15h
  kube-system                 nodelocaldns-twg9b                          100m (2%)     0 (0%)      70Mi (0%)        170Mi (1%)     4d15h
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource                               Requests       Limits
  --------                               --------       ------
  cpu                                    1110m (29%)    1400m (36%)
  memory                                 401480Ki (2%)  1206887680 (8%)
  ephemeral-storage                      0 (0%)         0 (0%)
  hugepages-1Gi                          0 (0%)         0 (0%)
  hugepages-2Mi                          0 (0%)         0 (0%)
  macvtap.network.kubevirt.io/dataplane  2              2
```

# cluster-network-addons-operator 部署多个网络插件
```bash
# 部署以下网络插件
[root@localhost ~]# curl https://github.com/kubevirt/cluster-network-addons-operator/releases/download/v0.77.0/network-addons-config-example.cr.yaml
apiVersion: networkaddonsoperator.network.kubevirt.io/v1
kind: NetworkAddonsConfig
metadata:
  name: cluster
spec:
  multus: {}
  linuxBridge: {}
  kubeMacPool: {}
  ovs: {}
  macvtap: {}
  imagePullPolicy: Always
[root@localhost net.d]# kubectl apply -f https://github.com/kubevirt/cluster-network-addons-operator/releases/download/v0.77.0/namespace.yaml
namespace/cluster-network-addons created
[root@localhost net.d]# cd
[root@localhost ~]# kubectl apply -f https://github.com/kubevirt/cluster-network-addons-operator/releases/download/v0.77.0/network-addons-config.crd.yaml
customresourcedefinition.apiextensions.k8s.io/networkaddonsconfigs.networkaddonsoperator.network.kubevirt.io created
[root@localhost ~]# kubectl apply -f https://github.com/kubevirt/cluster-network-addons-operator/releases/download/v0.77.0/operator.yaml
serviceaccount/cluster-network-addons-operator created
clusterrole.rbac.authorization.k8s.io/cluster-network-addons-operator created
clusterrolebinding.rbac.authorization.k8s.io/cluster-network-addons-operator created
role.rbac.authorization.k8s.io/cluster-network-addons-operator created
rolebinding.rbac.authorization.k8s.io/cluster-network-addons-operator created
deployment.apps/cluster-network-addons-operator created
[root@localhost ~]# kubectl apply -f https://github.com/kubevirt/cluster-network-addons-operator/releases/download/v0.77.0/network-addons-config-example.cr.yaml
networkaddonsconfig.networkaddonsoperator.network.kubevirt.io/cluster created
[root@localhost ~]# kubectl wait networkaddonsconfig cluster --for condition=Available
^C
[root@localhost ~]# kubectl get pod -A
NAMESPACE                NAME                                                 READY   STATUS              RESTARTS   AGE
cluster-network-addons   bridge-marker-swlrn                                  0/1     ContainerCreating   0          4s
cluster-network-addons   cluster-network-addons-operator-7dd77c99f9-flrs2     0/2     ContainerCreating   0          27s
cluster-network-addons   kube-cni-linux-bridge-plugin-5r2j9                   0/1     ContainerCreating   0          4s
cluster-network-addons   kubemacpool-cert-manager-7bf5598748-hp4b9            0/1     ContainerCreating   0          4s
cluster-network-addons   kubemacpool-mac-controller-manager-b9886f757-w4sx8   0/2     ContainerCreating   0          4s
cluster-network-addons   macvtap-cni-tlcz5                                    0/1     Init:0/1            0          3s
cluster-network-addons   multus-dr2fp                                         0/1     ContainerCreating   0          4s
cluster-network-addons   ovs-cni-amd64-8ds2s                                  0/1     Init:0/1            0          3s
kube-system              calico-kube-controllers-6dd874f784-xw4hn             1/1     Running             0          3h13m
kube-system              calico-node-9g6m6                                    1/1     Running             0          3h13m
kube-system              coredns-76b4fb4578-tzbln                             1/1     Running             0          3h2m
kube-system              dns-autoscaler-7874cf6bcf-v9pml                      1/1     Running             0          3h13m
kube-system              kube-apiserver-node1                                 1/1     Running             1          3h14m
kube-system              kube-controller-manager-node1                        1/1     Running             1          3h14m
kube-system              kube-proxy-fnb9z                                     1/1     Running             0          3h13m
kube-system              kube-scheduler-node1                                 1/1     Running             1          3h14m
kube-system              nodelocaldns-zs2lc                                   1/1     Running             0          3h13m
kubevirt                 virt-api-667d949cc5-9qb9r                            1/1     Running             0          171m
kubevirt                 virt-api-667d949cc5-b9pgr                            1/1     Running             0          171m
kubevirt                 virt-controller-7f8f9f9c76-cbtvd                     1/1     Running             0          170m
kubevirt                 virt-controller-7f8f9f9c76-p6rrj                     1/1     Running             0          170m
kubevirt                 virt-handler-w9dms                                   1/1     Running             0          170m
kubevirt                 virt-operator-7d9c58f7cf-8b5ms                       1/1     Running             0          171m
kubevirt                 virt-operator-7d9c58f7cf-p5b5t                       1/1     Running             0          171m
# 等待一段时间
[root@localhost ~]# kubectl get pod -A
NAMESPACE                NAME                                                 READY   STATUS    RESTARTS   AGE
cluster-network-addons   bridge-marker-swlrn                                  1/1     Running   0          2m45s
cluster-network-addons   cluster-network-addons-operator-7dd77c99f9-flrs2     2/2     Running   0          3m8s
cluster-network-addons   kube-cni-linux-bridge-plugin-5r2j9                   1/1     Running   0          2m45s
cluster-network-addons   kubemacpool-cert-manager-7bf5598748-hp4b9            1/1     Running   0          2m45s
cluster-network-addons   kubemacpool-mac-controller-manager-b9886f757-w4sx8   2/2     Running   0          2m45s
cluster-network-addons   macvtap-cni-tlcz5                                    1/1     Running   0          2m44s
cluster-network-addons   multus-dr2fp                                         1/1     Running   0          2m45s
cluster-network-addons   ovs-cni-amd64-8ds2s                                  1/1     Running   0          2m44s
kube-system              calico-kube-controllers-6dd874f784-xw4hn             1/1     Running   0          3h16m
kube-system              calico-node-9g6m6                                    1/1     Running   0          3h16m
kube-system              coredns-76b4fb4578-tzbln                             1/1     Running   0          3h4m
kube-system              dns-autoscaler-7874cf6bcf-v9pml                      1/1     Running   0          3h15m
kube-system              kube-apiserver-node1                                 1/1     Running   1          3h16m
kube-system              kube-controller-manager-node1                        1/1     Running   1          3h16m
kube-system              kube-proxy-fnb9z                                     1/1     Running   0          3h16m
kube-system              kube-scheduler-node1                                 1/1     Running   1          3h16m
kube-system              nodelocaldns-zs2lc                                   1/1     Running   0          3h15m
kubevirt                 virt-api-667d949cc5-9qb9r                            1/1     Running   0          174m
kubevirt                 virt-api-667d949cc5-b9pgr                            1/1     Running   0          174m
kubevirt                 virt-controller-7f8f9f9c76-cbtvd                     1/1     Running   0          173m
kubevirt                 virt-controller-7f8f9f9c76-p6rrj                     1/1     Running   0          173m
kubevirt                 virt-handler-w9dms                                   1/1     Running   0          173m
kubevirt                 virt-operator-7d9c58f7cf-8b5ms                       1/1     Running   0          174m
kubevirt                 virt-operator-7d9c58f7cf-p5b5t                       1/1     Running   0          174m
```

```bash
[root@localhost ~]# kubectl apply -f nad-ovs.yaml 
networkattachmentdefinition.k8s.cni.cncf.io/ovs-vlan-100 created
[root@localhost ~]# cat nad-ovs.yaml 
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: ovs-vlan-100
spec:
  config: '{
      "cniVersion": "0.3.1",
      "type": "ovs",
      "bridge": "br1",
      "vlan": 100
    }'
[root@localhost ~]# kubectl get networkattachmentdefinition.k8s.cni.cncf.io 
NAME           AGE
ovs-vlan-100   2m38s
```

# 安装 ovs cni
```bash
#安装依赖：
[root@ovs02 ~]# yum install wget openssl-devel  python-sphinx gcc make python-devel openssl-devel kernel-devel graphviz kernel-debug-devel autoconf automake rpm-build redhat-rpm-config libtool python-twisted-core python-zope-interface PyQt4 desktop-file-utils libcap-ng-devel groff checkpolicy selinux-policy-devel gcc-c++ python-six unbound unbound-devel -y
#下载 ovs 压缩包：
[root@ovs02 ~]# wget https://www.openvswitch.org/releases/openvswitch-2.11.0.tar.gz --no-check-certificate
#构建 build 目录：
[root@ovs02 ~]# mkdir -p ~/rpmbuild/SOURCES
[root@ovs02 ~]# mv openvswitch-2.11.0.tar.gz /root/rpmbuild/SOURCES/
[root@ovs02 ~]# cd /root/rpmbuild/SOURCES/
[root@ovs02 ~]# tar -xvzf openvswitch-2.11.0.tar.gz
#构建 rpm 包：
[root@ovs02 ~]# rpmbuild -bb --nocheck openvswitch-2.11.0/rhel/openvswitch-fedora.spec
#安装 ovs：
[root@ovs02 ~]# yum localinstall /root/rpmbuild/RPMS/x86_64/openvswitch-2.11.0-1.el7.x86_64.rpm
#启动 ovs：
[root@ovs02 ~]# systemctl start openvswitch.service
[root@ovs02 ~]# systemctl enable openvswitch.service
Created symlink from /etc/systemd/system/multi-user.target.wants/openvswitch.service to /usr/lib/systemd/system/openvswitch.service.
[root@ovs02 ~]# 
[root@ovs02 ~]# ovs-vsctl --version
ovs-vsctl (Open vSwitch) 2.11.0
DB Schema 7.16.1
```

# 后端 ovs
```bash
#创建网桥
ovs-vsctl add-br br1
#创建multus ovs-cni网络定义
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: ovs-vlan-100
spec:
  config: '{
      "cniVersion": "0.3.1",
      "type": "ovs",
      "bridge": "br1",
      "vlan": 100
    }'
#vm yaml前端
      interfaces:
        - name: default
          masquerade: {}
        - name: ovs-net
          bridge: {}
#vm yaml后端 用ovs
  networks:
  - name: default
    pod: {} # Stock pod network
  - name: ovs-net
    multus: # Secondary multus network
      networkName: ovs-vlan-100
```

# 后端 macvlan
```bash
#NetworkAttachmentDefinition 
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: macvlan-test
spec:
  config: '{
      "type": "macvlan",
      "master": "eth0",
      "mode": "bridge",
      "ipam": {
        "type": "host-local",
        "subnet": "10.250.250.0/24"
      }
    }'
#vm yaml前端
      interfaces:
        - name: test1
          bridge: {}
#vm yaml后端macvlan
  networks:
  - name: test1
    multus: # Multus network as default
      default: true
      networkName: macvlan-test    
```

# 前端 macvtap
```bash
[root@node1 ~]# cat macvtap-config.yaml
kind: ConfigMap
apiVersion: v1
metadata:
  name: macvtap-deviceplugin-config
data:
  DP_MACVTAP_CONF: |
    [
        {
            "name"     : "dataplane",
            "master"   : "ens33",
            "mode"     : "bridge",
            "capacity" : 50
        },
    ]
[root@node1 ~]# cat macvtap-nad.yaml
kind: NetworkAttachmentDefinition
apiVersion: k8s.cni.cncf.io/v1
metadata:
  name: macvtapnetwork
  annotations:
    k8s.v1.cni.cncf.io/resourceName: macvtap.network.kubevirt.io/ens33
spec:
  config: '{
      "cniVersion": "0.3.1",
      "name": "dataplane",
      "type": "macvtap",
      "mtu": 1500
    }'
# vm 前端 macvtap
          interfaces:
          - macvtap: {}
            name: default
# vm 后端
      networks:
      - multus:
          networkName: macvtapnetwork
        name: default            
```

# 附： macvlan实验
```bash
# 使用macvlan需要开启网卡的混杂模式
[root@localhost ~]# yum install -y net-tools
[root@localhost ~]# ifconfig
ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.159.137  netmask 255.255.255.0  broadcast 192.168.159.255
        inet6 fe80::c4e8:2243:ac4e:cd08  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:41:89:85  txqueuelen 1000  (Ethernet)
        RX packets 37846  bytes 50602163 (48.2 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 19172  bytes 1676426 (1.5 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

[root@localhost ~]# ifconfig ens33 promisc
[root@localhost ~]# ifconfig
ens33: flags=4419<UP,BROADCAST,RUNNING,PROMISC,MULTICAST>  mtu 1500
        inet 192.168.159.137  netmask 255.255.255.0  broadcast 192.168.159.255
        inet6 fe80::c4e8:2243:ac4e:cd08  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:41:89:85  txqueuelen 1000  (Ethernet)
        RX packets 37945  bytes 50609527 (48.2 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 19243  bytes 1683622 (1.6 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

# 查看内核是否开启macvlan模块，若没开启，需要开启
[root@localhost ~]# lsmod | grep macvlan
[root@localhost ~]# modprobe macvlan
[root@localhost ~]# lsmod | grep macvlan
macvlan                19239  0 
```

```bash
# 创建两个 macvlan 子接口
[root@localhost ~]# ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens33: <BROADCAST,MULTICAST,PROMISC,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:41:89:85 brd ff:ff:ff:ff:ff:ff
[root@localhost ~]# ip link add link ens33 dev mac1 type macvlan mode bridge
[root@localhost ~]# ip link add link ens33 dev mac2 type macvlan mode bridge
[root@localhost ~]# ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens33: <BROADCAST,MULTICAST,PROMISC,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:41:89:85 brd ff:ff:ff:ff:ff:ff
3: mac1@ens33: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether a2:ae:ed:fa:34:be brd ff:ff:ff:ff:ff:ff
4: mac2@ens33: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 4a:a3:d3:8c:3d:94 brd ff:ff:ff:ff:ff:ff
# 创建两个 namespace
[root@localhost ~]# ip netns list
[root@localhost ~]# ip netns add ns1
[root@localhost ~]# ip netns add ns2
[root@localhost ~]# ip netns list
ns2
ns1
# 将两个子接口分别挂到两个 namespace 中
[root@localhost ~]# ip link set dev mac1 netns ns1
[root@localhost ~]# ip link set dev mac2 netns ns2
[root@localhost ~]# ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens33: <BROADCAST,MULTICAST,PROMISC,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:41:89:85 brd ff:ff:ff:ff:ff:ff
[root@localhost ~]# ip netns exec ns1 dhclient mac1
[root@localhost ~]# ip netns exec ns2 dhclient mac2
dhclient(8478) is already running - exiting. 

This version of ISC DHCP is based on the release available
on ftp.isc.org.  Features have been added and other changes
have been made to the base software release in order to make
it work better with this distribution.

Please report for this software via the CentOS Bugs Database:
    http://bugs.centos.org/

exiting.
[root@localhost ~]# kill -9 8478
[root@localhost ~]# ip netns exec ns2 dhclient mac2
[root@localhost ~]# ip netns exec ns1 ip link set dev mac1 up
[root@localhost ~]# ip netns exec ns2 ip link set dev mac2 up
[root@localhost ~]# ip netns exec ns1 ip a
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
3: mac1@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether a2:ae:ed:fa:34:be brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.159.138/24 brd 192.168.159.255 scope global dynamic mac1
       valid_lft 1714sec preferred_lft 1714sec
    inet6 fe80::a0ae:edff:fefa:34be/64 scope link 
       valid_lft forever preferred_lft forever
[root@localhost ~]# ip netns exec ns2 ip a
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
4: mac2@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 4a:a3:d3:8c:3d:94 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.159.139/24 brd 192.168.159.255 scope global dynamic mac2
       valid_lft 1745sec preferred_lft 1745sec
    inet6 fe80::48a3:d3ff:fe8c:3d94/64 scope link 
       valid_lft forever preferred_lft forever
[root@localhost ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,PROMISC,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:41:89:85 brd ff:ff:ff:ff:ff:ff
    inet 192.168.159.137/24 brd 192.168.159.255 scope global noprefixroute dynamic ens33
       valid_lft 1510sec preferred_lft 1510sec
    inet6 fe80::c4e8:2243:ac4e:cd08/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
可以ping通
[root@localhost ~]# ping 192.168.159.2
PING 192.168.159.2 (192.168.159.2) 56(84) bytes of data.
64 bytes from 192.168.159.2: icmp_seq=1 ttl=128 time=0.078 ms
64 bytes from 192.168.159.2: icmp_seq=2 ttl=128 time=0.418 ms
^C
--- 192.168.159.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 0.078/0.248/0.418/0.170 ms
[root@localhost ~]# ip netns exec ns1 ping 192.168.159.2
PING 192.168.159.2 (192.168.159.2) 56(84) bytes of data.
64 bytes from 192.168.159.2: icmp_seq=1 ttl=128 time=0.075 ms
64 bytes from 192.168.159.2: icmp_seq=2 ttl=128 time=0.429 ms
^C
--- 192.168.159.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 0.075/0.252/0.429/0.177 ms
[root@localhost ~]# ip netns exec ns2 ping 192.168.159.2
PING 192.168.159.2 (192.168.159.2) 56(84) bytes of data.
64 bytes from 192.168.159.2: icmp_seq=1 ttl=128 time=0.118 ms
64 bytes from 192.168.159.2: icmp_seq=2 ttl=128 time=0.398 ms
^C
--- 192.168.159.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 0.118/0.258/0.398/0.140 ms
[root@localhost ~]# curl www.backendcloud.cn
<html>
<head><title>301 Moved Permanently</title></head>
<body bgcolor="white">
<center><h1>301 Moved Permanently</h1></center>
<hr><center>nginx/1.6.3</center>
</body>
</html>
[root@localhost ~]# ip netns exec ns1 curl www.backendcloud.cn
<html>
<head><title>301 Moved Permanently</title></head>
<body bgcolor="white">
<center><h1>301 Moved Permanently</h1></center>
<hr><center>nginx/1.6.3</center>
</body>
</html>
[root@localhost ~]# ip netns exec ns2 curl www.backendcloud.cn
<html>
<head><title>301 Moved Permanently</title></head>
<body bgcolor="white">
<center><h1>301 Moved Permanently</h1></center>
<hr><center>nginx/1.6.3</center>
</body>
</html>
```
> 虚拟出来的网卡和原网卡一样，都可以ping通网关，也都可以上外网。感觉就是原网卡的多个分身且每个分身都有不同的mac地址和ip地址。

外界要和ns1的网卡192.168.159.138和ns2的192.168.159.139通信，都会经过host网卡192.168.159.137，所以host网卡要开启混杂模式，不然就会丢掉138和139的ip包。

> 混杂模式是指一台机器的网卡能够接收所有经过它的数据流，而不论其目的地址是否是它。

![](/images/macvtap-auto/eb212f1f.png)

MACVLAN 会根据收到包的目的 MAC 地址判断这个包需要交给哪个虚拟网卡。配合 network namespace 使用，可以构建这样的网络：

![](/images/macvtap-auto/511a32bc.png)

由于 macvlan 与 eth0 处于不同的 namespace，拥有不同的 network stack，这样使用可以不需要建立 bridge 在 virtual namespace 里面使用网络。

MACVTAP 是对 MACVLAN的改进，把 MACVLAN 与 TAP 设备的特点综合一下，使用 MACVLAN 的方式收发数据包，但是收到的包不交给 network stack 处理，而是生成一个 /dev/tapX 文件，交给这个文件：

![](/images/macvtap-auto/e236b0cd.png)

由于 MACVLAN 是工作在 MAC 层的，所以 MACVTAP 也只能工作在 MAC 层，不会有 MACVTUN 这样的设备。TAP 设备与 TUN 设备工作方式完全相同，区别在于：

* TUN 设备的 /dev/tunX 文件收发的是 IP 层数据包，只能工作在 IP 层，无法与物理网卡做 bridge，但是可以通过三层交换（如 ip_forward）与物理网卡连通。
* TAP 设备的 /dev/tapX 文件收发的是 MAC 层数据包，拥有 MAC 层功能，可以与物理网卡做 bridge，支持 MAC 层广播。