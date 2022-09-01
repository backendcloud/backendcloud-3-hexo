---
title: Cilium install
readmore: true
date: 2022-09-01 13:25:10
categories: 云原生
tags:
- Cilium
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

# 背景
现代数据中心应用程序的开发已经转向微服务，微服务应用程序往往是高度动态的，高度不稳定的容器生命周期让传统的 Linux 网络安全方法（例如 iptables）应付不断更新的负载均衡表和访问控制列表劣势显现出来。

得利于Linux eBPF的发展，Cilium 利用 Linux eBPF，Cilium 保留了透明地插入安全可视性 + 强制执行的能力，但这种方式基于服务 /pod/ 容器标识（与传统系统中的 IP 地址识别相反），并且可以根据应用层进行过滤 （例如 HTTP）。因此，通过将安全性与寻址分离，Cilium 不仅可以在高度动态的环境中应用安全策略，而且除了提供传统的第 3 层和第 4 层分割之外，还可以通过在 HTTP 层运行来提供更强的安全隔离。

不止Cilium，其实Calico也有eBPF模式。Calico 从 v3.13 开始，集成了 eBPF 数据平面。

因为iptables的netfilter的低性能，Kubernetes的kube-proxy组件一直被诟病，Cilium和Calico都全面实现 kube-proxy 的功能，包括ClusterIP, NodePort, ExternalIPs 和 LoadBalancer，可以完全取代它的位置，同时提供更好的性能，Cilium和Calico都支持把Kubernetes的kube-proxy组件给替换掉。

另外Cilium的ClusterMesh可以跨多个集群，跨VPC，跨多数据中心，甚至跨Openstack，K8S集群 互联和配置网络策略。


# 启动2节点的Kubernetes集群
```bash
[dev@centos9 ~]$ minikube start --vm-driver=podman --network-plugin=cni --nodes=2
* minikube v1.26.1 on Centos 9
* Using the podman driver based on user configuration
! With --network-plugin=cni, you will need to provide your own CNI. See --cni flag as a user-friendly alternative
* Using Podman driver with root privileges
* Starting control plane node minikube in cluster minikube
* Pulling base image ...
E0901 09:20:52.559294  215553 cache.go:203] Error downloading kic artifacts:  not yet implemented, see issue #8426
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
E0901 09:21:24.042538  215553 cache.go:203] Error downloading kic artifacts:  not yet implemented, see issue #8426
* Creating podman container (CPUs=2, Memory=4000MB) ...
* Found network options:
  - NO_PROXY=192.168.49.2
* Preparing Kubernetes v1.24.3 on Docker 20.10.17 ...
  - env NO_PROXY=192.168.49.2
* Verifying Kubernetes components...
* Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
[dev@centos9 ~]$ kubectl get pod -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   coredns-6d4b75cb6d-8r5xp           1/1     Running   0          61s
kube-system   etcd-minikube                      1/1     Running   0          72s
kube-system   kindnet-cgqrd                      1/1     Running   0          62s
kube-system   kindnet-cnhbh                      1/1     Running   0          46s
kube-system   kube-apiserver-minikube            1/1     Running   0          72s
kube-system   kube-controller-manager-minikube   1/1     Running   0          72s
kube-system   kube-proxy-5w6fl                   1/1     Running   0          46s
kube-system   kube-proxy-qkh7d                   1/1     Running   0          62s
kube-system   kube-scheduler-minikube            1/1     Running   0          72s
kube-system   storage-provisioner                1/1     Running   0          71s
[dev@centos9 ~]$ kubectl get node -o wide
NAME           STATUS   ROLES           AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION          CONTAINER-RUNTIME
minikube       Ready    control-plane   76s   v1.24.3   192.168.49.2   <none>        Ubuntu 20.04.4 LTS   5.14.0-115.el9.x86_64   docker://20.10.17
minikube-m02   Ready    <none>          49s   v1.24.3   192.168.49.3   <none>        Ubuntu 20.04.4 LTS   5.14.0-115.el9.x86_64   docker://20.10.17
```

# Mount the eBPF filesystem
```bash
[dev@centos9 ~]$ minikube ssh -n minikube -- sudo mount bpffs -t bpf /sys/fs/bpf
[dev@centos9 ~]$ minikube ssh -n minikube-m02 -- sudo mount bpffs -t bpf /sys/fs/bpf
```

> Cilium是基于eBPF，所以只能用于Linux系统，且对内核版本有一定的要求，centos7 默认的3点几的肯定不行，至少4.几以上，或5.几以上，具体参考官方文档。内核升级的步骤参见本篇最后的章节`附：CentOS内核升级`

# 安装Cilium

下面两种方式2选1安装即可：
## quick-install.yaml
```bash
[dev@centos9 ~]$ kubectl create -f https://raw.githubusercontent.com/cilium/cilium/v1.9/install/kubernetes/quick-install.yaml
serviceaccount/cilium created
serviceaccount/cilium-operator created
configmap/cilium-config created
clusterrole.rbac.authorization.k8s.io/cilium created
clusterrole.rbac.authorization.k8s.io/cilium-operator created
clusterrolebinding.rbac.authorization.k8s.io/cilium created
clusterrolebinding.rbac.authorization.k8s.io/cilium-operator created
Warning: spec.template.metadata.annotations[scheduler.alpha.kubernetes.io/critical-pod]: non-functional in v1.16+; use the "priorityClassName" field instead
daemonset.apps/cilium created
deployment.apps/cilium-operator created
[dev@centos9 ~]$ kubectl get pod -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   cilium-bnv9z                       1/1     Running   0          4m43s
kube-system   cilium-n5xpt                       1/1     Running   0          11m
kube-system   cilium-operator-d86cdbf88-ljfw8    1/1     Running   0          11m
kube-system   coredns-6d4b75cb6d-8r5xp           1/1     Running   0          16m
kube-system   etcd-minikube                      1/1     Running   0          17m
kube-system   kindnet-cgqrd                      1/1     Running   0          16m
kube-system   kindnet-cnhbh                      1/1     Running   0          16m
kube-system   kube-apiserver-minikube            1/1     Running   0          17m
kube-system   kube-controller-manager-minikube   1/1     Running   0          17m
kube-system   kube-proxy-5w6fl                   1/1     Running   0          16m
kube-system   kube-proxy-qkh7d                   1/1     Running   0          16m
kube-system   kube-scheduler-minikube            1/1     Running   0          17m
kube-system   storage-provisioner                1/1     Running   0          17m
```

## Cilium CLI
```bash
[root@centos7 ~]# CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/master/stable.txt)
[root@centos7 ~]# CLI_ARCH=amd64
[root@centos7 ~]# if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
[root@centos7 ~]# curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 23.1M  100 23.1M    0     0  1378k      0  0:00:17  0:00:17 --:--:-- 5047k
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100    92  100    92    0     0     91      0  0:00:01  0:00:01 --:--:-- 92000
[root@centos7 ~]# sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
cilium-linux-amd64.tar.gz: OK
[root@centos7 ~]# sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
cilium
[root@centos7 ~]# rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
rm: remove regular file ‘cilium-linux-amd64.tar.gz’? y
rm: remove regular file ‘cilium-linux-amd64.tar.gz.sha256sum’? y
[root@centos7 ~]# cilium install
🔮 Auto-detected Kubernetes kind: kind
✨ Running "kind" validation checks
✅ Detected kind version "0.14.0"
ℹ️  Using Cilium version 1.12.1
🔮 Auto-detected cluster name: kind-kind
🔮 Auto-detected datapath mode: tunnel
🔮 Auto-detected kube-proxy has been installed
ℹ️  helm template --namespace kube-system cilium cilium/cilium --version 1.12.1 --set cluster.id=0,cluster.name=kind-kind,encryption.nodeEncryption=false,ipam.mode=kubernetes,kubeProxyReplacement=disabled,operator.replicas=1,serviceAccounts.cilium.name=cilium,serviceAccounts.operator.name=cilium-operator,tunnel=vxlan
ℹ️  Storing helm values file in kube-system/cilium-cli-helm-values Secret
🔑 Found CA in secret cilium-ca
🔑 Generating certificates for Hubble...
🚀 Creating Service accounts...
🚀 Creating Cluster roles...
🚀 Creating ConfigMap for Cilium version 1.12.1...
🚀 Creating Agent DaemonSet...
🚀 Creating Operator Deployment...
⌛ Waiting for Cilium to be installed and ready...
♻️  Restarting unmanaged pods...
♻️  Restarted unmanaged pod kube-system/coredns-6d4b75cb6d-w9gtw
♻️  Restarted unmanaged pod kube-system/coredns-6d4b75cb6d-xlw4x
♻️  Restarted unmanaged pod local-path-storage/local-path-provisioner-9cd9bd544-vrnxd
✅ Cilium was successfully installed! Run 'cilium status' to view installation health
[root@centos7 ~]# cilium status
    /¯¯\
 /¯¯\__/¯¯\    Cilium:         OK
 \__/¯¯\__/    Operator:       OK
 /¯¯\__/¯¯\    Hubble:         disabled
 \__/¯¯\__/    ClusterMesh:    disabled
    \__/

Deployment       cilium-operator    
DaemonSet        cilium             
Containers:      cilium-operator    
                 cilium             
Cluster Pods:    0/0 managed by Cilium
```

# 测试Cilium
```bash
[dev@centos9 ~]$ kubectl create ns cilium-test
namespace/cilium-test created
[dev@centos9 ~]$ kubectl apply -n cilium-test -f https://raw.githubusercontent.com/cilium/cilium/v1.9/examples/kubernetes/connectivity-check/connectivity-check.yaml
deployment.apps/echo-a created
deployment.apps/echo-b created
deployment.apps/echo-b-host created
deployment.apps/pod-to-a created
deployment.apps/pod-to-external-1111 created
deployment.apps/pod-to-a-denied-cnp created
deployment.apps/pod-to-a-allowed-cnp created
deployment.apps/pod-to-external-fqdn-allow-google-cnp created
deployment.apps/pod-to-b-multi-node-clusterip created
deployment.apps/pod-to-b-multi-node-headless created
deployment.apps/host-to-b-multi-node-clusterip created
deployment.apps/host-to-b-multi-node-headless created
deployment.apps/pod-to-b-multi-node-nodeport created
deployment.apps/pod-to-b-intra-node-nodeport created
service/echo-a created
service/echo-b created
service/echo-b-headless created
service/echo-b-host-headless created
ciliumnetworkpolicy.cilium.io/pod-to-a-denied-cnp created
ciliumnetworkpolicy.cilium.io/pod-to-a-allowed-cnp created
ciliumnetworkpolicy.cilium.io/pod-to-external-fqdn-allow-google-cnp created
[dev@centos9 ~]$ kubectl get pods -n cilium-test
NAME                                                     READY   STATUS    RESTARTS        AGE
echo-a-fcd7c5c-xnbsd                                     1/1     Running   0               4m47s
echo-b-5df8dc7749-m8m7s                                  1/1     Running   0               4m47s
echo-b-host-6cc69489b4-stj46                             1/1     Running   0               4m47s
host-to-b-multi-node-clusterip-954c7d9b8-9mkh6           0/1     Running   4 (31s ago)     4m46s
host-to-b-multi-node-headless-564779b9f8-z9z7z           0/1     Running   4 (20s ago)     4m46s
pod-to-a-6457cb8648-kks78                                1/1     Running   0               4m47s
pod-to-a-allowed-cnp-75f8cfb44d-lpzhg                    1/1     Running   0               4m47s
pod-to-a-denied-cnp-8478f9cc54-kq2js                     0/1     Running   4 (16s ago)     4m47s
pod-to-b-intra-node-nodeport-675fd4cb88-vqnps            1/1     Running   0               4m46s
pod-to-b-multi-node-clusterip-764f84b9d6-5h92v           1/1     Running   1 (3m46s ago)   4m47s
pod-to-b-multi-node-headless-6bbc875466-78b5t            1/1     Running   1 (3m36s ago)   4m46s
pod-to-b-multi-node-nodeport-f977df4b-wdzr6              1/1     Running   1 (3m22s ago)   4m46s
pod-to-external-1111-6d55c9d55b-w62r7                    1/1     Running   0               4m47s
pod-to-external-fqdn-allow-google-cnp-7b9b79d54b-qgh9b   0/1     Running   3 (9s ago)      4m47s
```

# Enable Hubble for Cluster

Hubble，它是专门为网络可视化设计，能够利用 Cilium 提供的 eBPF 数据路径，获得对 Kubernetes 应用和服务的网络流量的深度可见性。这些网络流量信息可以对接 Hubble CLI、UI 工具，可以通过交互式的方式快速进行问题诊断。除了 Hubble 自身的监控工具，还可以对接主流的云原生监控体系——Prometheus 和 Grafana，实现可扩展的监控策略。

## Hubble UI
```bash
[dev@centos9 ~]$ export CILIUM_NAMESPACE=kube-system
[dev@centos9 ~]$ kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/v1.9/install/kubernetes/quick-hubble-install.yaml
serviceaccount/hubble-generate-certs created
serviceaccount/hubble-relay created
serviceaccount/hubble-ui created
configmap/hubble-relay-config created
configmap/hubble-ui-nginx created
clusterrole.rbac.authorization.k8s.io/hubble-generate-certs created
clusterrole.rbac.authorization.k8s.io/hubble-ui created
clusterrolebinding.rbac.authorization.k8s.io/hubble-generate-certs created
clusterrolebinding.rbac.authorization.k8s.io/hubble-ui created
service/hubble-relay created
service/hubble-ui created
deployment.apps/hubble-relay created
deployment.apps/hubble-ui created
job.batch/hubble-generate-certs created
Warning: batch/v1beta1 CronJob is deprecated in v1.21+, unavailable in v1.25+; use batch/v1 CronJob
cronjob.batch/hubble-generate-certs created
[dev@centos9 ~]$ kubectl get pod -A
NAMESPACE     NAME                                                     READY   STATUS      RESTARTS        AGE
cilium-test   echo-a-fcd7c5c-28d6t                                     1/1     Running     0               5m53s
cilium-test   echo-b-5df8dc7749-9zgkr                                  1/1     Running     0               5m53s
cilium-test   echo-b-host-6cc69489b4-2njfh                             1/1     Running     0               5m53s
cilium-test   host-to-b-multi-node-clusterip-954c7d9b8-ngttx           0/1     Running     5 (47s ago)     5m52s
cilium-test   host-to-b-multi-node-headless-564779b9f8-7h5qt           0/1     Running     5 (47s ago)     5m52s
cilium-test   pod-to-a-6457cb8648-j2cvw                                1/1     Running     0               5m53s
cilium-test   pod-to-a-allowed-cnp-75f8cfb44d-whrqk                    1/1     Running     0               5m53s
cilium-test   pod-to-a-denied-cnp-8478f9cc54-fkb6m                     0/1     Running     5 (52s ago)     5m53s
cilium-test   pod-to-b-intra-node-nodeport-675fd4cb88-9b9kc            1/1     Running     0               5m52s
cilium-test   pod-to-b-multi-node-clusterip-764f84b9d6-m54n6           1/1     Running     0               5m53s
cilium-test   pod-to-b-multi-node-headless-6bbc875466-9zzlw            1/1     Running     1 (4m52s ago)   5m53s
cilium-test   pod-to-b-multi-node-nodeport-f977df4b-5njwn              1/1     Running     1 (4m49s ago)   5m52s
cilium-test   pod-to-external-1111-6d55c9d55b-vz7ff                    1/1     Running     0               5m53s
cilium-test   pod-to-external-fqdn-allow-google-cnp-7b9b79d54b-cpgc7   0/1     Running     5 (50s ago)     5m53s
kube-system   cilium-bnv9z                                             1/1     Running     0               31m
kube-system   cilium-n5xpt                                             1/1     Running     0               39m
kube-system   cilium-operator-d86cdbf88-ljfw8                          1/1     Running     0               39m
kube-system   coredns-6d4b75cb6d-8r5xp                                 1/1     Running     0               44m
kube-system   etcd-minikube                                            1/1     Running     0               44m
kube-system   hubble-generate-certs-nbhl5                              0/1     Completed   0               16m
kube-system   hubble-relay-864c8d4777-2qhzd                            1/1     Running     0               16m
kube-system   hubble-ui-7c8b69b78c-4975f                               2/2     Running     0               16m
kube-system   kindnet-cgqrd                                            1/1     Running     0               44m
kube-system   kindnet-cnhbh                                            1/1     Running     0               43m
kube-system   kube-apiserver-minikube                                  1/1     Running     0               44m
kube-system   kube-controller-manager-minikube                         1/1     Running     0               44m
kube-system   kube-proxy-5w6fl                                         1/1     Running     0               43m
kube-system   kube-proxy-qkh7d                                         1/1     Running     0               44m
kube-system   kube-scheduler-minikube                                  1/1     Running     0               44m
kube-system   storage-provisioner                                      1/1     Running     0               44m
[dev@centos9 ~]$ kubectl port-forward -n $CILIUM_NAMESPACE svc/hubble-ui --address 0.0.0.0 --address :: 12000:80
Forwarding from 0.0.0.0:12000 -> 8081
Forwarding from [::]:12000 -> 8081
```

## Hubble CLI
```bash
[dev@centos9 ~]$ export HUBBLE_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/hubble/master/stable.txt)
[dev@centos9 ~]$ curl -LO "https://github.com/cilium/hubble/releases/download/$HUBBLE_VERSION/hubble-linux-amd64.tar.gz"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 7130k  100 7130k    0     0  2423k      0  0:00:02  0:00:02 --:--:-- 3531k
[dev@centos9 ~]$ tar zxf hubble-linux-amd64.tar.gz
[dev@centos9 ~]$ ls
hubble  hubble-linux-amd64.tar.gz
[dev@centos9 ~]$ sudo mv hubble /usr/local/bin
[sudo] password for dev: 
[dev@centos9 ~]$ export CILIUM_NAMESPACE=kube-system
[dev@centos9 ~]$ kubectl port-forward -n $CILIUM_NAMESPACE svc/hubble-relay --address 0.0.0.0 --address :: 4245:80
Forwarding from 0.0.0.0:4245 -> 4245
Forwarding from [::]:4245 -> 4245
 ⚡ root@centos9  ~  hubble --server localhost:4245 status
Healthcheck (via localhost:4245): Ok
Current/Max Flows: 2,048/8,192 (25.00%)
Flows/s: 0.99
Connected Nodes: 2/2
 ⚡ root@centos9  ~  hubble --server localhost:4245 observe
Sep  1 02:11:54.727: 192.168.49.3:42312 (host) <- 10.0.0.81:4240 (health) to-stack FORWARDED (TCP Flags: ACK)
Sep  1 02:11:54.727: 192.168.49.3:42312 (host) -> 10.0.0.81:4240 (health) to-endpoint FORWARDED (TCP Flags: ACK)
Sep  1 02:11:54.727: 192.168.49.3:48586 (world) -> 10.0.1.254:4240 (health) to-endpoint FORWARDED (TCP Flags: RST)
Sep  1 02:11:57.287: 192.168.49.2:44294 (remote-node) <> 10.0.0.81:4240 (health) to-overlay FORWARDED (TCP Flags: SYN)
Sep  1 02:11:57.288: 192.168.49.2:44294 (remote-node) <- 10.0.0.81:4240 (health) to-stack FORWARDED (TCP Flags: SYN, ACK)
Sep  1 02:11:57.288: 192.168.49.2:44294 (world) -> 10.0.0.81:4240 (health) to-endpoint FORWARDED (TCP Flags: RST)
Sep  1 02:11:57.800: 192.168.49.2:34456 (host) <- 10.0.1.254:4240 (health) to-stack FORWARDED (TCP Flags: ACK)
Sep  1 02:11:57.800: 192.168.49.2:34456 (host) -> 10.0.1.254:4240 (health) to-endpoint FORWARDED (TCP Flags: ACK)
Sep  1 02:12:09.575: 192.168.49.3:42312 (host) -> 10.0.0.81:4240 (health) to-endpoint FORWARDED (TCP Flags: ACK)
Sep  1 02:12:09.576: 192.168.49.3:42312 (host) <- 10.0.0.81:4240 (health) to-stack FORWARDED (TCP Flags: ACK)
Sep  1 02:12:10.698: 192.168.49.2:34456 (host) -> 10.0.1.254:4240 (health) to-endpoint FORWARDED (TCP Flags: ACK, PSH)
Sep  1 02:12:10.699: 192.168.49.2:34456 (host) <- 10.0.1.254:4240 (health) to-stack FORWARDED (TCP Flags: ACK, PSH)
Sep  1 02:12:25.448: 192.168.49.3:42312 (host) <- 10.0.0.81:4240 (health) to-stack FORWARDED (TCP Flags: ACK)
Sep  1 02:12:25.448: 192.168.49.3:42312 (host) -> 10.0.0.81:4240 (health) to-endpoint FORWARDED (TCP Flags: ACK)
Sep  1 02:12:27.495: 192.168.49.2:34456 (host) <- 10.0.1.254:4240 (health) to-stack FORWARDED (TCP Flags: ACK)
Sep  1 02:12:27.495: 192.168.49.2:34456 (host) -> 10.0.1.254:4240 (health) to-endpoint FORWARDED (TCP Flags: ACK)
Sep  1 02:12:38.296: 192.168.49.3:42312 (host) -> 10.0.0.81:4240 (health) to-endpoint FORWARDED (TCP Flags: ACK, PSH)
Sep  1 02:12:38.297: 192.168.49.3:42312 (host) <- 10.0.0.81:4240 (health) to-stack FORWARDED (TCP Flags: ACK, PSH)
Sep  1 02:12:39.219: 192.168.49.3:41780 (remote-node) <> 10.0.1.254:4240 (health) to-overlay FORWARDED (TCP Flags: SYN)
Sep  1 02:12:39.220: 192.168.49.3:41780 (remote-node) -> 10.0.1.254:4240 (health) to-endpoint FORWARDED (TCP Flags: SYN)
Sep  1 02:12:39.220: 192.168.49.3:41780 (remote-node) <- 10.0.1.254:4240 (health) to-stack FORWARDED (TCP Flags: SYN, ACK)
Sep  1 02:12:39.220: 192.168.49.3:41780 (world) -> 10.0.1.254:4240 (health) to-endpoint FORWARDED (TCP Flags: RST)
Sep  1 02:12:39.221: 192.168.49.3 (host) -> 10.0.0.81 (health) to-endpoint FORWARDED (ICMPv4 EchoRequest)
Sep  1 02:12:39.221: 192.168.49.3 (host) <- 10.0.0.81 (health) to-stack FORWARDED (ICMPv4 EchoReply)
Sep  1 02:12:39.221: 192.168.49.3 (remote-node) <> 10.0.1.254 (health) to-overlay FORWARDED (ICMPv4 EchoRequest)
Sep  1 02:12:39.222: 192.168.49.3 (remote-node) -> 10.0.1.254 (health) to-endpoint FORWARDED (ICMPv4 EchoRequest)
Sep  1 02:12:39.222: 192.168.49.3 (remote-node) <- 10.0.1.254 (health) to-stack FORWARDED (ICMPv4 EchoReply)
Sep  1 02:12:40.232: 192.168.49.3:41780 (remote-node) <> 10.0.1.254:4240 (health) to-overlay FORWARDED (TCP Flags: SYN)
Sep  1 02:12:40.233: 192.168.49.3:41780 (world) -> 10.0.1.254:4240 (health) to-endpoint FORWARDED (TCP Flags: RST)
Sep  1 02:12:41.978: 192.168.49.2:48502 (remote-node) <> 10.0.0.81:4240 (health) to-overlay FORWARDED (TCP Flags: SYN)
Sep  1 02:12:41.978: 192.168.49.2:48502 (remote-node) -> 10.0.0.81:4240 (health) to-endpoint FORWARDED (TCP Flags: SYN)
Sep  1 02:12:41.978: 192.168.49.2:48502 (remote-node) <- 10.0.0.81:4240 (health) to-stack FORWARDED (TCP Flags: SYN, ACK)
Sep  1 02:12:41.978: 192.168.49.2:48502 (world) -> 10.0.0.81:4240 (health) to-endpoint FORWARDED (TCP Flags: RST)
Sep  1 02:12:41.979: 192.168.49.2 (remote-node) <> 10.0.0.81 (health) to-overlay FORWARDED (ICMPv4 EchoRequest)
Sep  1 02:12:41.979: 192.168.49.2 (remote-node) -> 10.0.0.81 (health) to-endpoint FORWARDED (ICMPv4 EchoRequest)
Sep  1 02:12:41.979: 192.168.49.2 (remote-node) <- 10.0.0.81 (health) to-stack FORWARDED (ICMPv4 EchoReply)
Sep  1 02:12:41.983: 192.168.49.2 (host) -> 10.0.1.254 (health) to-endpoint FORWARDED (ICMPv4 EchoRequest)
Sep  1 02:12:41.983: 192.168.49.2 (host) <- 10.0.1.254 (health) to-stack FORWARDED (ICMPv4 EchoReply)
Sep  1 02:12:42.280: 192.168.49.3:41780 (world) -> 10.0.1.254:4240 (health) to-endpoint FORWARDED (TCP Flags: RST)
Sep  1 02:12:42.343: 192.168.49.2:34456 (host) -> 10.0.1.254:4240 (health) to-endpoint FORWARDED (TCP Flags: ACK)
```


# 附：CentOS内核升级
```bash
[root@centos7 ~]# uname -a
Linux centos7 3.10.0-1160.71.1.el7.x86_64 #1 SMP Tue Jun 28 15:37:28 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
[root@centos7 ~]# rpm -import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
[root@centos7 ~]# rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
Retrieving http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
Retrieving http://elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm
Preparing...                          ################################# [100%]
Updating / installing...
   1:elrepo-release-7.0-4.el7.elrepo  ################################# [100%]
[root@centos7 ~]# yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * elrepo-kernel: mirrors.tuna.tsinghua.edu.cn
elrepo-kernel                                                                                                                                                                                                                                        | 3.0 kB  00:00:00     
elrepo-kernel/primary_db                                                                                                                                                                                                                             | 2.1 MB  00:00:11     
Available Packages
elrepo-release.noarch                                                                                                                 7.0-6.el7.elrepo                                                                                                         elrepo-kernelkernel-lt.x86_64                                                                                                                      5.4.211-1.el7.elrepo                                                                                                     elrepo-kernelkernel-lt-devel.x86_64                                                                                                                5.4.211-1.el7.elrepo                                                                                                     elrepo-kernelkernel-lt-doc.noarch                                                                                                                  5.4.211-1.el7.elrepo                                                                                                     elrepo-kernelkernel-lt-headers.x86_64                                                                                                              5.4.211-1.el7.elrepo                                                                                                     elrepo-kernelkernel-lt-tools.x86_64                                                                                                                5.4.211-1.el7.elrepo                                                                                                     elrepo-kernelkernel-lt-tools-libs.x86_64                                                                                                           5.4.211-1.el7.elrepo                                                                                                     elrepo-kernelkernel-lt-tools-libs-devel.x86_64                                                                                                     5.4.211-1.el7.elrepo                                                                                                     elrepo-kernelkernel-ml.x86_64                                                                                                                      5.19.5-1.el7.elrepo                                                                                                      elrepo-kernelkernel-ml-devel.x86_64                                                                                                                5.19.5-1.el7.elrepo                                                                                                      elrepo-kernelkernel-ml-doc.noarch                                                                                                                  5.19.5-1.el7.elrepo                                                                                                      elrepo-kernelkernel-ml-headers.x86_64                                                                                                              5.19.5-1.el7.elrepo                                                                                                      elrepo-kernelkernel-ml-tools.x86_64                                                                                                                5.19.5-1.el7.elrepo                                                                                                      elrepo-kernelkernel-ml-tools-libs.x86_64                                                                                                           5.19.5-1.el7.elrepo                                                                                                      elrepo-kernelkernel-ml-tools-libs-devel.x86_64                                                                                                     5.19.5-1.el7.elrepo                                                                                                      elrepo-kernelperf.x86_64                                                                                                                           5.19.5-1.el7.elrepo                                                                                                      elrepo-kernelpython-perf.x86_64                                                                                                                    5.19.5-1.el7.elrepo                                                                                                      elrepo-kernel
[root@centos7 ~]# yum -y --enablerepo=elrepo-kernel install kernel-ml
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * base: mirrors.tuna.tsinghua.edu.cn
 * elrepo: mirrors.tuna.tsinghua.edu.cn
 * elrepo-kernel: mirrors.tuna.tsinghua.edu.cn
 * extras: mirror.xtom.com.hk
 * updates: mirror.xtom.com.hk
Resolving Dependencies
--> Running transaction check
---> Package kernel-ml.x86_64 0:5.19.5-1.el7.elrepo will be installed
--> Finished Dependency Resolution

Dependencies Resolved

============================================================================================================================================================================================================================================================================ Package                                                       Arch                                                       Version                                                                   Repository                                                         Size
============================================================================================================================================================================================================================================================================Installing:
 kernel-ml                                                     x86_64                                                     5.19.5-1.el7.elrepo                                                       elrepo-kernel                                                      59 M

Transaction Summary
============================================================================================================================================================================================================================================================================Install  1 Package

Total download size: 59 M
Installed size: 276 M
Downloading packages:
kernel-ml-5.19.5-1.el7.elrepo.x86_64.rpm                                                                                                                                                                                                             |  59 MB  00:00:56     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
Warning: RPMDB altered outside of yum.
  Installing : kernel-ml-5.19.5-1.el7.elrepo.x86_64                                                                                                                                                                                                                     1/1 
  Verifying  : kernel-ml-5.19.5-1.el7.elrepo.x86_64                                                                                                                                                                                                                     1/1 

Installed:
  kernel-ml.x86_64 0:5.19.5-1.el7.elrepo                                                                                                                                                                                                                                    

Complete!
[root@centos7 ~]# awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
CentOS Linux (5.19.5-1.el7.elrepo.x86_64) 7 (Core)
CentOS Linux (3.10.0-1160.71.1.el7.x86_64) 7 (Core)
CentOS Linux (0-rescue-90a82557faf04194905deabee3ad1267) 7 (Core)
[root@centos7 ~]# cat /etc/default/grub
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="rd.lvm.lv=centos/root rhgb quiet"
GRUB_DISABLE_RECOVERY="true"
# 最新的内核位于位置0
[root@centos7 ~]# vi /etc/default/grub
[root@centos7 ~]# cat /etc/default/grub
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=0
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="rd.lvm.lv=centos/root rhgb quiet"
GRUB_DISABLE_RECOVERY="true"
[root@centos7 ~]# grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.19.5-1.el7.elrepo.x86_64
Found initrd image: /boot/initramfs-5.19.5-1.el7.elrepo.x86_64.img
Found linux image: /boot/vmlinuz-3.10.0-1160.71.1.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-1160.71.1.el7.x86_64.img
Found linux image: /boot/vmlinuz-0-rescue-90a82557faf04194905deabee3ad1267
Found initrd image: /boot/initramfs-0-rescue-90a82557faf04194905deabee3ad1267.img
done
[root@centos7 ~]# reboot
# 重启完成后，检查默认的内核版本
[root@centos7 ~]# uname -a
Linux centos7 5.19.5-1.el7.elrepo.x86_64 #1 SMP PREEMPT_DYNAMIC Mon Aug 29 08:55:53 EDT 2022 x86_64 x86_64 x86_64 GNU/Linux
```

> CentOS7的内核从3.10升级到了最新的5.19版本