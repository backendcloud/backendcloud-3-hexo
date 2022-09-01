---
title: Cilium完全替换kube-proxy
readmore: true
date: 2022-09-01 18:14:57
categories:
tags:
- kube-proxy
- Cilium
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

因为iptables的netfilter的低性能，Kubernetes的kube-proxy组件一直被诟病，Cilium和Calico都全面实现 kube-proxy 的功能，包括ClusterIP, NodePort, ExternalIPs 和 LoadBalancer，可以完全取代它的位置，同时提供更好的性能。

Cilium和Calico都支持把Kubernetes的kube-proxy组件给替换掉，本篇是介绍Cilium替换kube-proxy。

# 启动2节点的Kubernetes集群
```bash
[dev@centos9 ~]$ minikube start --vm-driver=podman --network-plugin=cni --nodes=2
* minikube v1.26.1 on Centos 9
* Using the podman driver based on user configuration
! With --network-plugin=cni, you will need to provide your own CNI. See --cni flag as a user-friendly alternative
* Using Podman driver with root privileges
* Starting control plane node minikube in cluster minikube
* Pulling base image ...
E0901 13:47:15.274484 1303088 cache.go:203] Error downloading kic artifacts:  not yet implemented, see issue #8426
* Creating podman container (CPUs=2, Memory=4000MB) ...
* Preparing Kubernetes v1.24.3 on Docker 20.10.17 ...
  - Generating certificates and keys ...
  - Booting up control plane ...
  - Configuring RBAC rules ...
* Configuring CNI (Container Networking Interface) ...
* Verifying Kubernetes components...
  - Using image gcr.io/k8s-minikube/storage-provisioner:v5
* Enabled addons: storage-provisioner, default-storageclass

* Starting worker node minikube-m02 in cluster minikube
* Pulling base image ...
E0901 13:47:42.095257 1303088 cache.go:203] Error downloading kic artifacts:  not yet implemented, see issue #8426
* Creating podman container (CPUs=2, Memory=4000MB) ...
* Found network options:
  - NO_PROXY=192.168.49.2
* Preparing Kubernetes v1.24.3 on Docker 20.10.17 ...
  - env NO_PROXY=192.168.49.2
* Verifying Kubernetes components...
* Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
[dev@centos9 ~]$ kubectl get nodes -o wide
NAME           STATUS   ROLES           AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION          CONTAINER-RUNTIME
minikube       Ready    control-plane   66s   v1.24.3   192.168.49.2   <none>        Ubuntu 20.04.4 LTS   5.14.0-115.el9.x86_64   docker://20.10.17
minikube-m02   Ready    <none>          37s   v1.24.3   192.168.49.3   <none>        Ubuntu 20.04.4 LTS   5.14.0-115.el9.x86_64   docker://20.10.17
[dev@centos9 ~]$ kubectl get pod -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   coredns-6d4b75cb6d-9trth           1/1     Running   0          96s
kube-system   etcd-minikube                      1/1     Running   0          109s
kube-system   kindnet-lt7zb                      1/1     Running   0          83s
kube-system   kindnet-w8wb5                      1/1     Running   0          96s
kube-system   kube-apiserver-minikube            1/1     Running   0          109s
kube-system   kube-controller-manager-minikube   1/1     Running   0          109s
kube-system   kube-proxy-crrhc                   1/1     Running   0          83s
kube-system   kube-proxy-gzf5l                   1/1     Running   0          96s
kube-system   kube-scheduler-minikube            1/1     Running   0          109s
kube-system   storage-provisioner                1/1     Running   0          107s
```

# 删除 kube-proxy组件
```bash
[dev@centos9 ~]$ kubectl -n kube-system delete ds kube-proxy
daemonset.apps "kube-proxy" deleted
[dev@centos9 ~]$ kubectl get cm -A
NAMESPACE         NAME                                 DATA   AGE
default           kube-root-ca.crt                     1      111s
kube-node-lease   kube-root-ca.crt                     1      111s
kube-public       cluster-info                         3      2m4s
kube-public       kube-root-ca.crt                     1      111s
kube-system       coredns                              1      2m4s
kube-system       extension-apiserver-authentication   6      2m7s
kube-system       kube-proxy                           2      2m4s
kube-system       kube-root-ca.crt                     1      111s
kube-system       kubeadm-config                       1      2m6s
kube-system       kubelet-config                       1      2m6s
[dev@centos9 ~]$ kubectl -n kube-system delete cm kube-proxy
configmap "kube-proxy" deleted
[dev@centos9 ~]$ kubectl get pod -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   coredns-6d4b75cb6d-9trth           1/1     Running   0          2m4s
kube-system   etcd-minikube                      1/1     Running   0          2m17s
kube-system   kindnet-lt7zb                      1/1     Running   0          111s
kube-system   kindnet-w8wb5                      1/1     Running   0          2m4s
kube-system   kube-apiserver-minikube            1/1     Running   0          2m17s
kube-system   kube-controller-manager-minikube   1/1     Running   0          2m17s
kube-system   kube-scheduler-minikube            1/1     Running   0          2m17s
kube-system   storage-provisioner                1/1     Running   0          2m15s
```

# Cilium install
```bash
[dev@centos9 ~]$ helm repo add cilium https://helm.cilium.io/
"cilium" already exists with the same configuration, skipping
[dev@centos9 ~]$ helm install cilium cilium/cilium --version 1.9.18 \
    --namespace kube-system \
    --set kubeProxyReplacement=strict \
    --set k8sServiceHost=192.168.49.2 \
    --set k8sServicePort=8443
W0901 13:52:40.725154 1314269 warnings.go:70] spec.template.metadata.annotations[scheduler.alpha.kubernetes.io/critical-pod]: non-functional in v1.16+; use the "priorityClassName" field instead
NAME: cilium
LAST DEPLOYED: Thu Sep  1 13:52:40 2022
NAMESPACE: kube-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
You have successfully installed Cilium with Hubble.

Your release version is 1.9.18.

For any further help, visit https://docs.cilium.io/en/v1.9/gettinghelp
[dev@centos9 ~]$ kubectl get pod -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   cilium-822s8                       1/1     Running   0          3m41s
kube-system   cilium-operator-7c58cbbc4c-c9plf   1/1     Running   0          3m41s
kube-system   cilium-operator-7c58cbbc4c-fbzft   1/1     Running   0          3m41s
kube-system   cilium-rk8c7                       1/1     Running   0          3m41s
kube-system   coredns-6d4b75cb6d-9trth           1/1     Running   0          8m28s
kube-system   etcd-minikube                      1/1     Running   0          8m41s
kube-system   kindnet-lt7zb                      1/1     Running   0          8m15s
kube-system   kindnet-w8wb5                      1/1     Running   0          8m28s
kube-system   kube-apiserver-minikube            1/1     Running   0          8m41s
kube-system   kube-controller-manager-minikube   1/1     Running   0          8m41s
kube-system   kube-scheduler-minikube            1/1     Running   0          8m41s
kube-system   storage-provisioner                1/1     Running   0          8m39s
```

# 验证 Cilium 已经 完全替换掉了kube-proxy

## 进入cilium容器查看cilium状态详情
```bash
[dev@centos9 ~]$ kubectl exec -it -n kube-system cilium-822s8 -- cilium status | grep KubeProxyReplacement
Defaulted container "cilium-agent" out of: cilium-agent, mount-cgroup (init), clean-cilium-state (init)
KubeProxyReplacement:   Strict   [eth0 (Direct Routing)]
[dev@centos9 ~]$ kubectl exec -it -n kube-system cilium-822s8 -- cilium status --verbose
Defaulted container "cilium-agent" out of: cilium-agent, mount-cgroup (init), clean-cilium-state (init)
KVStore:                Ok   Disabled
Kubernetes:             Ok   1.24 (v1.24.3) [linux/amd64]
Kubernetes APIs:        ["cilium/v2::CiliumClusterwideNetworkPolicy", "cilium/v2::CiliumEndpoint", "cilium/v2::CiliumNetworkPolicy", "cilium/v2::CiliumNode", "core/v1::Namespace", "core/v1::Node", "core/v1::Pods", "core/v1::Service", "discovery/v1beta1::EndpointSlice", "networking.k8s.io/v1::NetworkPolicy"]
KubeProxyReplacement:   Strict   [eth0 (Direct Routing)]
Cilium:                 Ok   1.9.18 (v1.9.18-5f79f26)
NodeMonitor:            Listening for events on 128 CPUs with 64x4096 of shared memory
Cilium health daemon:   Ok   
IPAM:                   IPv4: 2/255 allocated from 10.0.0.0/24, 
Allocated addresses:
  10.0.0.180 (router)
  10.0.0.196 (health)
BandwidthManager:       Disabled
Host Routing:           BPF
Masquerading:           BPF       [eth0]   10.0.0.0/24
Clock Source for BPF:   jiffies   [1000 Hz]
Controller Status:      17/17 healthy
  Name                                  Last success   Last error   Count   Message
  cilium-health-ep                      19s ago        never        0       no error   
  dns-garbage-collector-job             37s ago        never        0       no error   
  endpoint-3305-regeneration-recovery   never          never        0       no error   
  endpoint-979-regeneration-recovery    never          never        0       no error   
  k8s-heartbeat                         7s ago         never        0       no error   
  metricsmap-bpf-prom-sync              2s ago         never        0       no error   
  neighbor-table-refresh                3m20s ago      never        0       no error   
  resolve-identity-3305                 3m19s ago      never        0       no error   
  resolve-identity-979                  3m20s ago      never        0       no error   
  sync-endpoints-and-host-ips           20s ago        never        0       no error   
  sync-lb-maps-with-k8s-services        3m20s ago      never        0       no error   
  sync-policymap-3305                   18s ago        never        0       no error   
  sync-policymap-979                    18s ago        never        0       no error   
  sync-to-k8s-ciliumendpoint (3305)     9s ago         never        0       no error   
  sync-to-k8s-ciliumendpoint (979)      0s ago         never        0       no error   
  template-dir-watcher                  never          never        0       no error   
  update-k8s-node-annotations           3m25s ago      never        0       no error   
Proxy Status:   OK, ip 10.0.0.180, 0 redirects active on ports 10000-20000
Hubble:         Ok   Current/Max Flows: 84/4096 (2.05%), Flows/s: 0.42   Metrics: Disabled
KubeProxyReplacement Details:
  Status:              Strict
  Protocols:           TCP, UDP
  Devices:             eth0 (Direct Routing)
  Mode:                SNAT
  Backend Selection:   Random
  Session Affinity:    Enabled
  XDP Acceleration:    Disabled
  Services:
  - ClusterIP:      Enabled
  - NodePort:       Enabled (Range: 30000-32767) 
  - LoadBalancer:   Enabled 
  - externalIPs:    Enabled 
  - HostPort:       Enabled
BPF Maps:   dynamic sizing: on (ratio: 0.002500)
  Name                          Size
  Non-TCP connection tracking   147475
  TCP connection tracking       294951
  Endpoint policy               65535
  Events                        128
  IP cache                      512000
  IP masquerading agent         16384
  IPv4 fragmentation            8192
  IPv4 service                  65536
  IPv6 service                  65536
  IPv4 service backend          65536
  IPv6 service backend          65536
  IPv4 service reverse NAT      65536
  IPv6 service reverse NAT      65536
  Metrics                       1024
  NAT                           294951
  Neighbor table                294951
  Global policy                 16384
  Per endpoint policy           65536
  Session affinity              65536
  Signal                        128
  Sockmap                       65535
  Sock reverse NAT              147475
  Tunnel                        65536
Cluster health:              1/2 reachable   (2022-09-01T05:56:12Z)
  Name                       IP              Node        Endpoints
  minikube-m02 (localhost)   192.168.49.3    reachable   reachable
  minikube                   192.168.49.2    reachable   unreachable
```

## 启动nginx deployment 和 service，验证cilium 服务列表信息 和 nginx服务
```bash
[dev@centos9 ~]$ cd tt
[dev@centos9 tt]$ cat nginx.yaml 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx
spec:
  selector:
    matchLabels:
      run: my-nginx
  replicas: 2
  template:
    metadata:
      labels:
        run: my-nginx
    spec:
      containers:
      - name: my-nginx
        image: nginx
        ports:
        - containerPort: 80
[dev@centos9 tt]$ kubectl create -f nginx.yaml 
deployment.apps/my-nginx created
[dev@centos9 tt]$ kubectl get pod -o wide
NAME                       READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
my-nginx-df7bbf6f5-48phr   1/1     Running   0          55s   10.244.0.3   minikube       <none>           <none>
my-nginx-df7bbf6f5-5clvf   1/1     Running   0          55s   10.244.1.2   minikube-m02   <none>           <none>
[dev@centos9 tt]$ kubectl get pods -l run=my-nginx -o wide
NAME                       READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
my-nginx-df7bbf6f5-48phr   1/1     Running   0          66s   10.244.0.3   minikube       <none>           <none>
my-nginx-df7bbf6f5-5clvf   1/1     Running   0          66s   10.244.1.2   minikube-m02   <none>           <none>
[dev@centos9 tt]$ kubectl expose deployment my-nginx --type=NodePort --port=80
service/my-nginx exposed
[dev@centos9 tt]$ kubectl get svc my-nginx
NAME       TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
my-nginx   NodePort   10.99.99.54   <none>        80:31683/TCP   8s
[dev@centos9 tt]$ kubectl exec -it -n kube-system cilium-822s8 -- cilium service list
Defaulted container "cilium-agent" out of: cilium-agent, mount-cgroup (init), clean-cilium-state (init)
ID   Frontend             Service Type   Backend                  
1    10.96.0.1:443        ClusterIP      1 => 192.168.49.2:8443   
2    10.96.0.10:53        ClusterIP      1 => 10.244.0.2:53       
3    10.96.0.10:9153      ClusterIP      1 => 10.244.0.2:9153     
4    10.99.99.54:80       ClusterIP      1 => 10.244.1.2:80       
                                         2 => 10.244.0.3:80       
5    192.168.49.3:31683   NodePort       1 => 10.244.1.2:80       
                                         2 => 10.244.0.3:80       
6    0.0.0.0:31683        NodePort       1 => 10.244.1.2:80       
                                         2 => 10.244.0.3:80       
[dev@centos9 tt]$ minikube ssh
docker@minikube:~$ curl 192.168.49.2:31683
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
docker@minikube:~$ curl 192.168.49.3:31683
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```