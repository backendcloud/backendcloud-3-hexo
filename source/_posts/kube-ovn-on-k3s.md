---
title: Kube-OVN 在 k3s 上的简单使用
readmore: true
date: 2022-09-14 12:51:17
categories: 云原生
tags:
- k3s
- Kube-OVN
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

# 部署 k3s （禁用 k3s 默认的网络策略控制器和flannel 的后端（默认是 VXLAN））

> 为了节省资源，也可以禁用 traefik Ingress 控制器。

```bash
[root@centos7 ~]# export INSTALL_K3S_VERSION=v1.23.8+k3s1
[root@centos7 ~]# curl -sfL https://get.k3s.io | sh -s - --flannel-backend=none --disable-network-policy --disable=traefik --write-kubeconfig-mode 644 --write-kubeconfig ~/.kube/config
[INFO]  Using v1.23.8+k3s1 as release
[INFO]  Downloading hash https://github.com/k3s-io/k3s/releases/download/v1.23.8+k3s1/sha256sum-amd64.txt
[INFO]  Downloading binary https://github.com/k3s-io/k3s/releases/download/v1.23.8+k3s1/k3s
[INFO]  Verifying binary download
[INFO]  Installing k3s to /usr/local/bin/k3s
Loaded plugins: fastestmirror, langpacks, product-id, search-disabled-repos, subscription-manager

This system is not registered with an entitlement server. You can use subscription-manager to register.

Loading mirror speeds from cached hostfile
 * base: mirrors.cqu.edu.cn
 * epel: mirror.01link.hk
 * extras: mirrors.huaweicloud.com
 * updates: ftp.sjtu.edu.cn
Package yum-utils-1.1.31-54.el7_8.noarch already installed and latest version
Nothing to do
Loaded plugins: fastestmirror, langpacks, product-id, subscription-manager

This system is not registered with an entitlement server. You can use subscription-manager to register.

Loaded plugins: fastestmirror, langpacks, product-id, search-disabled-repos, subscription-manager

This system is not registered with an entitlement server. You can use subscription-manager to register.

Loading mirror speeds from cached hostfile
 * base: mirrors.cqu.edu.cn
 * epel: mirror.01link.hk
 * extras: mirrors.huaweicloud.com
 * updates: mirrors.huaweicloud.com
rancher-k3s-common-stable                                                                                                                                                                                                                            | 2.9 kB  00:00:00     
Resolving Dependencies
--> Running transaction check
---> Package k3s-selinux.noarch 0:1.2-2.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

============================================================================================================================================================================================================================================================================ Package                                                        Arch                                                      Version                                                        Repository                                                                    Size
============================================================================================================================================================================================================================================================================Installing:
 k3s-selinux                                                    noarch                                                    1.2-2.el7                                                      rancher-k3s-common-stable                                                     16 k

Transaction Summary
============================================================================================================================================================================================================================================================================Install  1 Package

Total download size: 16 k
Installed size: 94 k
Downloading packages:
k3s-selinux-1.2-2.el7.noarch.rpm                                                                                                                                                                                                                     |  16 kB  00:00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : k3s-selinux-1.2-2.el7.noarch                                                                                                                                                                                                                             1/1 
  Verifying  : k3s-selinux-1.2-2.el7.noarch                                                                                                                                                                                                                             1/1 

Installed:
  k3s-selinux.noarch 0:1.2-2.el7                                                                                                                                                                                                                                            

Complete!
[INFO]  Skipping /usr/local/bin/kubectl symlink to k3s, command exists in PATH at /usr/bin/kubectl
[INFO]  Creating /usr/local/bin/crictl symlink to k3s
[INFO]  Creating /usr/local/bin/ctr symlink to k3s
[INFO]  Creating killall script /usr/local/bin/k3s-killall.sh
[INFO]  Creating uninstall script /usr/local/bin/k3s-uninstall.sh
[INFO]  env: Creating environment file /etc/systemd/system/k3s.service.env
[INFO]  systemd: Creating service file /etc/systemd/system/k3s.service
[INFO]  systemd: Enabling k3s unit
Created symlink from /etc/systemd/system/multi-user.target.wants/k3s.service to /etc/systemd/system/k3s.service.
[INFO]  systemd: Starting k3s
[root@centos7 ~]# kubectl get po -A
NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE
kube-system   local-path-provisioner-6c79684f77-6gr8q   0/1     Pending   0          3s
kube-system   coredns-d76bd69b-hqtf8                    0/1     Pending   0          3s
kube-system   metrics-server-7cd5fcb6b7-prxm7           0/1     Pending   0          3s
[root@centos7 ~]# kubectl get no
NAME      STATUS     ROLES                  AGE   VERSION
centos7   NotReady   control-plane,master   14s   v1.23.8+k3s1
```

> 此时检查 pod 和 node 会发现都处于 Pending 状态，这是因为还没安装 CNI。

# 安装 Kube-OVN

```bash
[root@centos7 ~]# wget https://raw.githubusercontent.com/kubeovn/kube-ovn/release-1.10/dist/images/install.sh
--2022-09-14 09:37:29--  https://raw.githubusercontent.com/kubeovn/kube-ovn/release-1.10/dist/images/install.sh
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.108.133
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.108.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 120793 (118K) [text/plain]
Saving to: ‘install.sh’

100%[==================================================================================================================================================================================================================================>] 120,793     --.-K/s   in 0.1s    

2022-09-14 09:37:30 (1.08 MB/s) - ‘install.sh’ saved [120793/120793]

[root@centos7 ~]# bash install.sh
-------------------------------
Kube-OVN Version:     v1.10.6
Default Network Mode: geneve
Default Subnet CIDR:  10.16.0.0/16
Join Subnet CIDR:     100.64.0.0/16
Enable SVC LB:        true
Enable Networkpolicy: true
Enable EIP and SNAT:  true
Enable Mirror:        false
-------------------------------
[Step 1/6] Label kube-ovn-master node and label datapath type
node/centos7 labeled
-------------------------------

[Step 2/6] Install OVN components
Install OVN DB in 192.168.190.133,
customresourcedefinition.apiextensions.k8s.io/vpc-nat-gateways.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/iptables-eips.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/iptables-fip-rules.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/iptables-dnat-rules.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/iptables-snat-rules.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/vpcs.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/ips.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/vips.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/subnets.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/vlans.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/provider-networks.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/security-groups.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/htbqoses.kubeovn.io created
serviceaccount/ovn created
clusterrole.rbac.authorization.k8s.io/system:ovn created
clusterrolebinding.rbac.authorization.k8s.io/ovn created
service/ovn-nb created
service/ovn-sb created
service/ovn-northd created
deployment.apps/ovn-central created
daemonset.apps/ovs-ovn created
Waiting for deployment "ovn-central" rollout to finish: 0 of 1 updated replicas are available...
deployment "ovn-central" successfully rolled out
-------------------------------

[Step 3/6] Install Kube-OVN
deployment.apps/kube-ovn-controller created
daemonset.apps/kube-ovn-cni created
daemonset.apps/kube-ovn-pinger created
deployment.apps/kube-ovn-monitor created
service/kube-ovn-monitor created
service/kube-ovn-pinger created
service/kube-ovn-controller created
service/kube-ovn-cni created
Waiting for deployment "kube-ovn-controller" rollout to finish: 0 of 1 updated replicas are available...
deployment "kube-ovn-controller" successfully rolled out
Waiting for daemon set "kube-ovn-cni" rollout to finish: 0 of 1 updated pods are available...
daemon set "kube-ovn-cni" successfully rolled out
-------------------------------

[Step 4/6] Delete pod that not in host network mode
pod "local-path-provisioner-6c79684f77-6gr8q" deleted
pod "metrics-server-7cd5fcb6b7-prxm7" deleted
pod "coredns-d76bd69b-hqtf8" deleted
pod "kube-ovn-pinger-mrd4l" deleted
daemon set "kube-ovn-pinger" successfully rolled out
deployment "coredns" successfully rolled out
-------------------------------

[Step 5/6] Install kubectl plugin
-------------------------------

[Step 6/6] Run network diagnose
NAME              CREATED AT
vpcs.kubeovn.io   2022-09-14T01:38:14Z
NAME                          CREATED AT
vpc-nat-gateways.kubeovn.io   2022-09-14T01:38:14Z
NAME                 CREATED AT
subnets.kubeovn.io   2022-09-14T01:38:14Z
NAME             CREATED AT
ips.kubeovn.io   2022-09-14T01:38:14Z
NAME               CREATED AT
vlans.kubeovn.io   2022-09-14T01:38:14Z
NAME                           CREATED AT
provider-networks.kubeovn.io   2022-09-14T01:38:14Z
NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
kube-dns   ClusterIP   10.43.0.10   <none>        53/UDP,53/TCP,9153/TCP   7m11s
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.43.0.1    <none>        443/TCP   7m15s
NAME   SECRETS   AGE
ovn    1         2m4s
NAME         CREATED AT
system:ovn   2022-09-14T01:38:14Z
NAME   ROLE                     AGE
ovn    ClusterRole/system:ovn   2m4s
NAME      STATUS   ROLES                  AGE    VERSION        INTERNAL-IP       EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION                CONTAINER-RUNTIME
centos7   Ready    control-plane,master   7m4s   v1.23.8+k3s1   192.168.190.133   <none>        CentOS Linux 7 (Core)   3.10.0-1160.76.1.el7.x86_64   containerd://1.5.13-k3s1
switch 67e3aeee-9fe2-4722-9778-27b4e382f1f0 (join)
    port join-ovn-cluster
        type: router
        router-port: ovn-cluster-join
    port node-centos7
        addresses: ["00:00:00:72:12:B7 100.64.0.2"]
switch 66aa7f8b-5526-44cc-8edc-9a1b010ea684 (ovn-default)
    port metrics-server-7cd5fcb6b7-58xj7.kube-system
        addresses: ["00:00:00:5A:2A:2F 10.16.0.7"]
    port local-path-provisioner-6c79684f77-zr9fx.kube-system
        addresses: ["00:00:00:02:11:03 10.16.0.6"]
    port kube-ovn-pinger-s7cjv.kube-system
        addresses: ["00:00:00:BA:EF:7C 10.16.0.9"]
    port ovn-default-ovn-cluster
        type: router
        router-port: ovn-cluster-ovn-default
    port coredns-d76bd69b-7t9jb.kube-system
        addresses: ["00:00:00:DE:F7:A4 10.16.0.8"]
router 3ead6079-d708-46d3-98d8-b43312e128ae (ovn-cluster)
    port ovn-cluster-ovn-default
        mac: "00:00:00:E8:28:1F"
        networks: ["10.16.0.1/16"]
    port ovn-cluster-join
        mac: "00:00:00:77:7C:5C"
        networks: ["100.64.0.1/16"]
Routing Policies
     31000                            ip4.dst == 10.16.0.0/16           allow
     31000                           ip4.dst == 100.64.0.0/16           allow
     30000                         ip4.dst == 192.168.190.133         reroute                100.64.0.2
     29000                ip4.src == $ovn.default.centos7_ip4         reroute                100.64.0.2
IPv4 Routes
Route Table <main>:
                0.0.0.0/0                100.64.0.1 dst-ip
UUID                                    LB                  PROTO      VIP                   IPs
34df7fe2-ca0e-4060-8b3e-dd7c6fc2b29a    cluster-tcp-load    tcp        10.43.0.10:53         10.16.0.8:53
                                                            tcp        10.43.0.10:9153       10.16.0.8:9153
                                                            tcp        10.43.0.1:443         192.168.190.133:6443
                                                            tcp        10.43.20.90:8080      10.16.0.9:8080
                                                            tcp        10.43.209.155:6642    192.168.190.133:6642
                                                            tcp        10.43.251.8:10660     192.168.190.133:10660
                                                            tcp        10.43.255.251:6643    192.168.190.133:6643
                                                            tcp        10.43.84.40:6641      192.168.190.133:6641
                                                            tcp        10.43.85.116:10665    192.168.190.133:10665
                                                            tcp        10.43.85.245:10661    192.168.190.133:10661
83dd5107-466a-4983-add6-da49b8e39b2f    cluster-udp-load    udp        10.43.0.10:53         10.16.0.8:53
_uuid               : 5337495c-008e-43fb-b463-fe5298f0234f
action              : drop
direction           : to-lport
external_ids        : {}
label               : 0
log                 : false
match               : "outport==@ovn.sg.kubeovn_deny_all && ip"
meter               : []
name                : []
options             : {}
priority            : 2003
severity            : []

_uuid               : 418cb28c-aa4f-47b5-96f0-3d42f0bbdb35
action              : drop
direction           : from-lport
external_ids        : {}
label               : 0
log                 : false
match               : "inport==@ovn.sg.kubeovn_deny_all && ip"
meter               : []
name                : []
options             : {}
priority            : 2003
severity            : []
Chassis "44d5e7fb-c137-4aad-865e-c02e429fc913"
    hostname: centos7
    Encap geneve
        ip: "192.168.190.133"
        options: {csum="true"}
    Port_Binding kube-ovn-pinger-s7cjv.kube-system
    Port_Binding node-centos7
    Port_Binding coredns-d76bd69b-7t9jb.kube-system
    Port_Binding metrics-server-7cd5fcb6b7-58xj7.kube-system
    Port_Binding local-path-provisioner-6c79684f77-zr9fx.kube-system
Defaulted container "cni-server" out of: cni-server, install-cni (init)
command terminated with exit code 7
centos7 kube-proxy's health check failed
```

# 检查状态

```bash
[root@centos7 ~]# kubectl get no -o wide
NAME      STATUS   ROLES                  AGE   VERSION        INTERNAL-IP       EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION                CONTAINER-RUNTIME
centos7   Ready    control-plane,master   15m   v1.23.8+k3s1   192.168.190.133   <none>        CentOS Linux 7 (Core)   3.10.0-1160.76.1.el7.x86_64   containerd://1.5.13-k3s1
[root@centos7 ~]# kubectl get po -A
NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE
kube-system   ovs-ovn-k4rlg                             1/1     Running   0          10m
kube-system   kube-ovn-controller-db7d548b5-6h5c5       1/1     Running   0          10m
kube-system   kube-ovn-monitor-5f8f5dbfc-5qsh2          1/1     Running   0          9m59s
kube-system   ovn-central-979fc8d55-w8zm5               1/1     Running   0          10m
kube-system   kube-ovn-cni-nf5gb                        1/1     Running   0          10m
kube-system   local-path-provisioner-6c79684f77-zr9fx   1/1     Running   0          9m24s
kube-system   coredns-d76bd69b-7t9jb                    1/1     Running   0          8m45s
kube-system   kube-ovn-pinger-s7cjv                     1/1     Running   0          8m43s
kube-system   metrics-server-7cd5fcb6b7-58xj7           1/1     Running   0          8m47s
[root@centos7 ~]# kubectl get Subnet
NAME          PROVIDER   VPC           PROTOCOL   CIDR            PRIVATE   NAT    DEFAULT   GATEWAYTYPE   V4USED   V4AVAILABLE   V6USED   V6AVAILABLE   EXCLUDEIPS
join          ovn        ovn-cluster   IPv4       100.64.0.0/16                              distributed   1        65532         0        0             ["100.64.0.1"]
ovn-default   ovn        ovn-cluster   IPv4       10.16.0.0/16              true   true      distributed   4        65529         0        0             ["10.16.0.1"]
[root@centos7 ~]# cat install.sh 
...
REGISTRY="kubeovn"
VERSION="v1.10.6"
IMAGE_PULL_POLICY="IfNotPresent"
POD_CIDR="10.16.0.0/16"                # Do NOT overlap with NODE/SVC/JOIN CIDR
POD_GATEWAY="10.16.0.1"
SVC_CIDR="10.96.0.0/12"                # Do NOT overlap with NODE/POD/JOIN CIDR
JOIN_CIDR="100.64.0.0/16"              # Do NOT overlap with NODE/POD/SVC CIDR
...
```

> 发现装好Kube-OVN后默认有一个subnet，且改subnet的CIDR范围和部署脚本中的配置一致。

至此 k3s 和 kube-ovn 就安装完成了，下面简单体验下 kube-ovn 的功能。

# Kube-OVN 的简单使用 - 创建一个子网并在改子网上创建一个pod

创建一个新的namespace：another，并让改namespace归属于新创建的子网another-subnet  10.66.0.0/16 下。

```bash
[root@centos7 ~]# kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: null
  name: another
---
apiVersion: kubeovn.io/v1
kind: Subnet
metadata:
  name: another-subnet
spec:
  protocol: IPv4
  cidrBlock: 10.66.0.0/16
  excludeIps:
  - 10.66.0.1
  gateway: 10.66.0.1
  gatewayType: distributed
  natOutgoing: true
  namespaces:
  - another
EOF
namespace/another created
subnet.kubeovn.io/another-subnet created
[root@centos7 ~]# kubectl get Subnet
NAME             PROVIDER   VPC           PROTOCOL   CIDR            PRIVATE   NAT    DEFAULT   GATEWAYTYPE   V4USED   V4AVAILABLE   V6USED   V6AVAILABLE   EXCLUDEIPS
join             ovn        ovn-cluster   IPv4       100.64.0.0/16                              distributed   1        65532         0        0             ["100.64.0.1"]
ovn-default      ovn        ovn-cluster   IPv4       10.16.0.0/16              true   true      distributed   4        65529         0        0             ["10.16.0.1"]
another-subnet   ovn        ovn-cluster   IPv4       10.66.0.0/16              true             distributed   0        65533         0        0             ["10.66.0.1"]
```

可以查看到刚刚创建的子网，ipv4的使用数还是0，下面在改子网下创建一个pod（curl客户端）。并在default命名空间（对应着默认的子网ovn-default  10.16.0.0/16创建一个pod（python的httpd服务端））。

```bash
[root@centos7 ~]# kubectl run curl --image rancher/curl --command sleep 1d -n another
pod/curl created
[root@centos7 ~]# kubectl get po -o wide -n another
NAME   READY   STATUS    RESTARTS   AGE   IP          NODE      NOMINATED NODE   READINESS GATES
curl   1/1     Running   0          44s   10.66.0.2   centos7   <none>           <none>
[root@centos7 ~]# kubectl run pipy --image flomesh/pipy:latest -n default
pod/pipy created
[root@centos7 ~]# kubectl get po -o wide
NAME   READY   STATUS    RESTARTS   AGE   IP           NODE      NOMINATED NODE   READINESS GATES
pipy   1/1     Running   0          27s   10.16.0.10   centos7   <none>           <none>
[root@centos7 ~]# kubectl get Subnet
NAME             PROVIDER   VPC           PROTOCOL   CIDR            PRIVATE   NAT    DEFAULT   GATEWAYTYPE   V4USED   V4AVAILABLE   V6USED   V6AVAILABLE   EXCLUDEIPS
join             ovn        ovn-cluster   IPv4       100.64.0.0/16                              distributed   1        65532         0        0             ["100.64.0.1"]
another-subnet   ovn        ovn-cluster   IPv4       10.66.0.0/16              true             distributed   1        65532         0        0             ["10.66.0.1"]
ovn-default      ovn        ovn-cluster   IPv4       10.16.0.0/16              true   true      distributed   5        65528         0        0             ["10.16.0.1"]
[root@centos7 ~]# kubectl exec -it curl -n another -- curl -i 10.16.0.10:8080
HTTP/1.1 200 OK
content-length: 11
connection: keep-alive

Hi, there!
```

查看子网信息，由于在两个子网分别创建了pod，ipv4使用数各自增加了1。客户端可以访问服务端。

# Kube-OVN 的简单使用 - 使用 Kube-OVN 的 ACL 规则

在默认子网上创建一条ACL规则，drop掉来自10.66.0.0/16的数据包。发现客户端已不能访问服务端。

```bash
[root@centos7 ~]# kubectl edit subnet ovn-default
subnet.kubeovn.io/ovn-default edited
# 在sepc: 最后加上一段
  acls:
  - action: drop
    direction: from-lport
    match: ip4.src == 10.66.0.0/16 && ip
    priority: 1002
[root@centos7 ~]# kubectl exec -it curl -n another -- curl -i 10.16.0.10:8080 --connect-timeout 2
curl: (28) Connection timed out after 2001 milliseconds
command terminated with exit code 28
```

下面是edit后的子网信息：

```yaml
apiVersion: kubeovn.io/v1
kind: Subnet
metadata:
  creationTimestamp: "2022-09-14T01:39:01Z"
  finalizers:
  - kube-ovn-controller
  generation: 1
  name: ovn-default
  resourceVersion: "2239"
  uid: 18f4374f-bf83-44eb-b551-ada43af4bad8
spec:
  cidrBlock: 10.16.0.0/16
  default: true
  excludeIps:
  - 10.16.0.1
  gateway: 10.16.0.1
  gatewayType: distributed
  natOutgoing: true
  protocol: IPv4
  provider: ovn
  vpc: ovn-cluster
  acls:
  - action: drop
    direction: from-lport
    match: ip4.src == 10.66.0.0/16 && ip
    priority: 1002  
status:
  activateGateway: ""
  conditions:
  - lastTransitionTime: "2022-09-14T01:39:07Z"
    lastUpdateTime: "2022-09-14T01:39:08Z"
    reason: ResetLogicalSwitchAclSuccess
    status: "True"
    type: Validated
  - lastTransitionTime: "2022-09-14T01:39:07Z"
    lastUpdateTime: "2022-09-14T01:39:07Z"
    reason: ResetLogicalSwitchAclSuccess
    status: "True"
    type: Ready
  - lastTransitionTime: "2022-09-14T01:39:07Z"
    lastUpdateTime: "2022-09-14T01:39:07Z"
    message: Not Observed
    reason: Init
    status: Unknown
    type: Error
  dhcpV4OptionsUUID: ""
  dhcpV6OptionsUUID: ""
  v4availableIPs: 65528
  v4usingIPs: 5
  v6availableIPs: 0
  v6usingIPs: 0
```