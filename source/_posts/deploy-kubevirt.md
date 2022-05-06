---
title: 部署 Kubernetes + KubeVirt 以及 KubeVirt的基本使用
date: 2022-05-06 14:17:28
categories: 云原生
tags:
- Kubernetes
- KubeVirt
---


# deploy Kubernetes


## 基础环境 - 所有机器上执行

```bash
#各个机器设置自己的域名
hostnamectl set-hostname xxxx

# 关闭防火墙，若在公有云部署，修改对应的安全组，放通所有端口，或者vpc下的k8s集群所在子网开启互信
systemctl stop firewalld
systemctl disable firewalld

# 将 SELinux 设置为 permissive 模式（相当于将其禁用）
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

#关闭swap
swapoff -a  
sed -ri 's/.*swap.*/#&/' /etc/fstab

#允许 iptables 检查桥接流量
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce-20.10.7 docker-ce-cli-20.10.7  containerd.io-1.4.6
systemctl start docker && systemctl enable docker && systemctl status docker

mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
"registry-mirrors": ["https://82m9ar63.mirror.aliyuncs.com"],
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {
"max-size": "100m"
},
"storage-driver": "overlay2"
}
EOF
systemctl daemon-reload
systemctl restart docker

```

## 安装kubelet、kubeadm、kubectl - 所有机器上执行

```bash
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
   http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF


sudo yum install -y kubelet-1.20.9 kubeadm-1.20.9 kubectl-1.20.9 --disableexcludes=kubernetes

sudo systemctl enable --now kubelet

```

## 下载各个机器需要的镜像 - 所有机器上执行

```bash
sudo tee ./images.sh <<-'EOF'
#!/bin/bash
images=(
kube-apiserver:v1.20.9
kube-proxy:v1.20.9
kube-controller-manager:v1.20.9
kube-scheduler:v1.20.9
coredns:1.7.0
etcd:3.4.13-0
pause:3.2
)
for imageName in ${images[@]} ; do
docker pull registry.cn-hangzhou.aliyuncs.com/lfy_k8s_images/$imageName
done
EOF
   
chmod +x ./images.sh && ./images.sh

#所有机器添加master域名映射，以下需要修改为自己的 本次部署的是但master节点，ip是 192.168.159.133 node节点仅一个，ip是 192.168.159.134
echo "192.168.159.133  cluster-endpoint k8s-master" >> /etc/hosts
echo "192.168.159.134  k8s-node01" >> /etc/hosts

```

## 初始化主节点 - master节点上执行

```bash
#主节点初始化
kubeadm init \
--apiserver-advertise-address=192.168.159.133 \
--control-plane-endpoint=cluster-endpoint \
--image-repository registry.cn-hangzhou.aliyuncs.com/lfy_k8s_images \
--kubernetes-version v1.20.9 \
--service-cidr=10.96.0.0/16 \
--pod-network-cidr=192.168.0.0/16

#所有网络范围不重叠
# 因为这次是虚拟机安装，虚拟机的网段是 192.168。159.0、24
# 所有要将 --pod-network-cidr=192.168.0.0/16 改成 --pod-network-cidr=10.97.0.0/16
# 所以下面的 calico.yaml 文件对应的也要改成一致
```

```bash
[init] Using Kubernetes version: v1.20.9
[preflight] Running pre-flight checks
        [WARNING Firewalld]: firewalld is active, please ensure ports [6443 10250] are open or your cluster may not function correctly
        [WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd". Please follow the guide at https://kubernetes.io/docs/setup/cri/
        [WARNING SystemVerification]: this Docker version is not on the list of validated versions: 20.10.7. Latest validated version: 19.03
        [WARNING Hostname]: hostname "k8s-master" could not be reached
        [WARNING Hostname]: hostname "k8s-master": lookup k8s-master on 192.168.159.2:53: no such host
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [cluster-endpoint k8s-master kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.159.133]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [k8s-master localhost] and IPs [192.168.159.133 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [k8s-master localhost] and IPs [192.168.159.133 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 11.503023 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.20" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node k8s-master as control-plane by adding the labels "node-role.kubernetes.io/master=''" and "node-role.kubernetes.io/control-plane='' (deprecated)"
[mark-control-plane] Marking the node k8s-master as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[bootstrap-token] Using token: 6ibx3k.dwc77g1lgrmsdd3b
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join cluster-endpoint:6443 --token 6ibx3k.dwc77g1lgrmsdd3b \
    --discovery-token-ca-cert-hash sha256:241901cd93dd1e7c08f43316f2d6d6c968ac2d38e463509c234f301025d8d191 \
    --control-plane 

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join cluster-endpoint:6443 --token 6ibx3k.dwc77g1lgrmsdd3b \
    --discovery-token-ca-cert-hash sha256:241901cd93dd1e7c08f43316f2d6d6c968ac2d38e463509c234f301025d8d191

# 按照上条命令的返回信息提示 copy 下面几条命令 后就可以 看出node和pod信息了        
[root@localhost ~]# mkdir -p $HOME/.kube
[root@localhost ~]# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
[root@localhost ~]# sudo chown $(id -u):$(id -g) $HOME/.kube/config
[root@localhost ~]# kubectl get nodes
NAME         STATUS     ROLES                  AGE     VERSION
k8s-master   NotReady   control-plane,master   2m10s   v1.20.9
[root@localhost ~]# kubectl get pods -A
NAMESPACE     NAME                                 READY   STATUS    RESTARTS   AGE
kube-system   coredns-5897cd56c4-gnrrz             0/1     Pending   0          2m52s
kube-system   coredns-5897cd56c4-hwbc8             0/1     Pending   0          2m52s
kube-system   etcd-k8s-master                      1/1     Running   0          3m6s
kube-system   kube-apiserver-k8s-master            1/1     Running   0          3m6s
kube-system   kube-controller-manager-k8s-master   1/1     Running   0          3m6s
kube-system   kube-proxy-kklkn                     1/1     Running   0          2m52s
kube-system   kube-scheduler-k8s-master            1/1     Running   0          3m8s
[root@localhost ~]# 

# 状态没有全部正常因为网络插件还没有部署
```

## 安装网络组件 - master节点上执行

```bash
[root@localhost ~]# curl https://docs.projectcalico.org/manifests/calico.yaml -O
[root@localhost ~]# ls
anaconda-ks.cfg  calico.yaml  images.sh
[root@localhost ~]# cat calico.yaml |grep 192.168
            #   value: "192.168.0.0/16"
[root@localhost ~]# vi calico.yaml 
```

            # - name: CALICO_IPV4POOL_CIDR
            #   value: "192.168.0.0/16"

改成

            - name: CALICO_IPV4POOL_CIDR
              value: "10.97.0.0/16"

```bash
[root@localhost ~]# kubectl apply -f calico.yaml 
configmap/calico-config created
customresourcedefinition.apiextensions.k8s.io/bgpconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgppeers.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/blockaffinities.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/caliconodestatuses.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/clusterinformations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/felixconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/hostendpoints.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamblocks.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamconfigs.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamhandles.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ippools.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipreservations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/kubecontrollersconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networksets.crd.projectcalico.org created
clusterrole.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrolebinding.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrole.rbac.authorization.k8s.io/calico-node created
clusterrolebinding.rbac.authorization.k8s.io/calico-node created
daemonset.apps/calico-node created
serviceaccount/calico-node created
deployment.apps/calico-kube-controllers created
serviceaccount/calico-kube-controllers created
poddisruptionbudget.policy/calico-kube-controllers created

# 需要等待一会等 pod 都启动好
[root@localhost ~]# kubectl get node
NAME         STATUS   ROLES                  AGE   VERSION
k8s-master   Ready    control-plane,master   14m   v1.20.9
[root@localhost ~]# kubectl get pod -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-6fcb5c5bcf-wghrm   1/1     Running   0          3m23s
kube-system   calico-node-pj9rm                          1/1     Running   0          3m24s
kube-system   coredns-5897cd56c4-gnrrz                   1/1     Running   0          14m
kube-system   coredns-5897cd56c4-hwbc8                   1/1     Running   0          14m
kube-system   etcd-k8s-master                            1/1     Running   0          14m
kube-system   kube-apiserver-k8s-master                  1/1     Running   0          14m
kube-system   kube-controller-manager-k8s-master         1/1     Running   0          14m
kube-system   kube-proxy-kklkn                           1/1     Running   0          14m
kube-system   kube-scheduler-k8s-master                  1/1     Running   0          14m
[root@localhost ~]# 
```

## 加入node节点

```bash
[root@localhost ~]# kubeadm join cluster-endpoint:6443 --token 6ibx3k.dwc77g1lgrmsdd3b \
    --discovery-token-ca-cert-hash sha256:241901cd93dd1e7c08f43316f2d6d6c968ac2d38e463509c234f301025d8d191

[root@k8s-node01 ~]# kubeadm join cluster-endpoint:6443 --token 6ibx3k.dwc77g1lgrmsdd3b     --discovery-token-ca-cert-hash sha256:241901cd93dd1e7c08f43316f2d6d6c968ac2d38e463509c234f301025d8d191
[preflight] Running pre-flight checks
        [WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd". Please follow the guide at https://kubernetes.io/docs/setup/cri/
        [WARNING SystemVerification]: this Docker version is not on the list of validated versions: 20.10.7. Latest validated version: 19.03
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.

[root@k8s-master ~]# kubectl get node
NAME         STATUS   ROLES                  AGE   VERSION
k8s-master   Ready    control-plane,master   30m   v1.20.9
k8s-node01   Ready    <none>                 63s   v1.20.9
[root@k8s-master ~]# kubectl get pod -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-6fcb5c5bcf-wghrm   1/1     Running   0          19m
kube-system   calico-node-6clkb                          1/1     Running   0          68s
kube-system   calico-node-pj9rm                          1/1     Running   0          19m
kube-system   coredns-5897cd56c4-gnrrz                   1/1     Running   0          30m
kube-system   coredns-5897cd56c4-hwbc8                   1/1     Running   0          30m
kube-system   etcd-k8s-master                            1/1     Running   0          30m
kube-system   kube-apiserver-k8s-master                  1/1     Running   0          30m
kube-system   kube-controller-manager-k8s-master         1/1     Running   0          30m
kube-system   kube-proxy-9zf4v                           1/1     Running   0          68s
kube-system   kube-proxy-kklkn                           1/1     Running   0          30m
kube-system   kube-scheduler-k8s-master                  1/1     Running   0          30m
[root@k8s-master ~]# 

# 若令牌忘记或过期，可以获取新令牌
[root@localhost ~]# kubeadm token create --print-join-command

```

## 部署dashboard

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml

```yaml
# Copyright 2017 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

apiVersion: v1
kind: Namespace
metadata:
  name: kubernetes-dashboard

---

apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard

---

kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  ports:
    - port: 443
      targetPort: 8443
  selector:
    k8s-app: kubernetes-dashboard

---

apiVersion: v1
kind: Secret
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard-certs
  namespace: kubernetes-dashboard
type: Opaque

---

apiVersion: v1
kind: Secret
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard-csrf
  namespace: kubernetes-dashboard
type: Opaque
data:
  csrf: ""

---

apiVersion: v1
kind: Secret
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard-key-holder
  namespace: kubernetes-dashboard
type: Opaque

---

kind: ConfigMap
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard-settings
  namespace: kubernetes-dashboard

---

kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
rules:
  # Allow Dashboard to get, update and delete Dashboard exclusive secrets.
  - apiGroups: [""]
    resources: ["secrets"]
    resourceNames: ["kubernetes-dashboard-key-holder", "kubernetes-dashboard-certs", "kubernetes-dashboard-csrf"]
    verbs: ["get", "update", "delete"]
    # Allow Dashboard to get and update 'kubernetes-dashboard-settings' config map.
  - apiGroups: [""]
    resources: ["configmaps"]
    resourceNames: ["kubernetes-dashboard-settings"]
    verbs: ["get", "update"]
    # Allow Dashboard to get metrics.
  - apiGroups: [""]
    resources: ["services"]
    resourceNames: ["heapster", "dashboard-metrics-scraper"]
    verbs: ["proxy"]
  - apiGroups: [""]
    resources: ["services/proxy"]
    resourceNames: ["heapster", "http:heapster:", "https:heapster:", "dashboard-metrics-scraper", "http:dashboard-metrics-scraper"]
    verbs: ["get"]

---

kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
rules:
  # Allow Metrics Scraper to get metrics from the Metrics server
  - apiGroups: ["metrics.k8s.io"]
    resources: ["pods", "nodes"]
    verbs: ["get", "list", "watch"]

---

apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: kubernetes-dashboard
subjects:
  - kind: ServiceAccount
    name: kubernetes-dashboard
    namespace: kubernetes-dashboard

---

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: kubernetes-dashboard
subjects:
  - kind: ServiceAccount
    name: kubernetes-dashboard
    namespace: kubernetes-dashboard

---

kind: Deployment
apiVersion: apps/v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      k8s-app: kubernetes-dashboard
  template:
    metadata:
      labels:
        k8s-app: kubernetes-dashboard
    spec:
      containers:
        - name: kubernetes-dashboard
          image: kubernetesui/dashboard:v2.3.1
          imagePullPolicy: Always
          ports:
            - containerPort: 8443
              protocol: TCP
          args:
            - --auto-generate-certificates
            - --namespace=kubernetes-dashboard
            # Uncomment the following line to manually specify Kubernetes API server Host
            # If not specified, Dashboard will attempt to auto discover the API server and connect
            # to it. Uncomment only if the default does not work.
            # - --apiserver-host=http://my-address:port
          volumeMounts:
            - name: kubernetes-dashboard-certs
              mountPath: /certs
              # Create on-disk volume to store exec logs
            - mountPath: /tmp
              name: tmp-volume
          livenessProbe:
            httpGet:
              scheme: HTTPS
              path: /
              port: 8443
            initialDelaySeconds: 30
            timeoutSeconds: 30
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
            runAsUser: 1001
            runAsGroup: 2001
      volumes:
        - name: kubernetes-dashboard-certs
          secret:
            secretName: kubernetes-dashboard-certs
        - name: tmp-volume
          emptyDir: {}
      serviceAccountName: kubernetes-dashboard
      nodeSelector:
        "kubernetes.io/os": linux
      # Comment the following tolerations if Dashboard must not be deployed on master
      tolerations:
        - key: node-role.kubernetes.io/master
          effect: NoSchedule

---

kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: dashboard-metrics-scraper
  name: dashboard-metrics-scraper
  namespace: kubernetes-dashboard
spec:
  ports:
    - port: 8000
      targetPort: 8000
  selector:
    k8s-app: dashboard-metrics-scraper

---

kind: Deployment
apiVersion: apps/v1
metadata:
  labels:
    k8s-app: dashboard-metrics-scraper
  name: dashboard-metrics-scraper
  namespace: kubernetes-dashboard
spec:
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      k8s-app: dashboard-metrics-scraper
  template:
    metadata:
      labels:
        k8s-app: dashboard-metrics-scraper
      annotations:
        seccomp.security.alpha.kubernetes.io/pod: 'runtime/default'
    spec:
      containers:
        - name: dashboard-metrics-scraper
          image: kubernetesui/metrics-scraper:v1.0.6
          ports:
            - containerPort: 8000
              protocol: TCP
          livenessProbe:
            httpGet:
              scheme: HTTP
              path: /
              port: 8000
            initialDelaySeconds: 30
            timeoutSeconds: 30
          volumeMounts:
          - mountPath: /tmp
            name: tmp-volume
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
            runAsUser: 1001
            runAsGroup: 2001
      serviceAccountName: kubernetes-dashboard
      nodeSelector:
        "kubernetes.io/os": linux
      # Comment the following tolerations if Dashboard must not be deployed on master
      tolerations:
        - key: node-role.kubernetes.io/master
          effect: NoSchedule
      volumes:
        - name: tmp-volume
          emptyDir: {}
```

    kubectl edit svc kubernetes-dashboard -n kubernetes-dashboard

> type: ClusterIP 改为 type: NodePort
> 访问： https://集群任意IP:端口      https://139.198.165.238:32759

```bash
#创建访问账号，准备一个yaml文件； vi dash.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
  
kubectl apply -f dash.yaml
#获取访问令牌
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"  
```

# deploy KubeVirt

```bash
controlplane $ export KUBEVIRT_VERSION=$(curl -s https://api.github.com/repos/kubevirt/kubevirt/releases/latest | jq -r .tag_name)
controlplane $ echo $KUBEVIRT_VERSION
v0.52.0
# 0.52 是最新版，但是这次部署的是 0.49
controlplane $ export KUBEVIRT_VERSION=v0.49.0

# deploy the KubeVirt Operator
controlplane $ kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-operator.yaml
namespace/kubevirt created
customresourcedefinition.apiextensions.k8s.io/kubevirts.kubevirt.io created
priorityclass.scheduling.k8s.io/kubevirt-cluster-critical created
clusterrole.rbac.authorization.k8s.io/kubevirt.io:operator created
serviceaccount/kubevirt-operator created
role.rbac.authorization.k8s.io/kubevirt-operator created
rolebinding.rbac.authorization.k8s.io/kubevirt-operator-rolebinding created
clusterrole.rbac.authorization.k8s.io/kubevirt-operator created
clusterrolebinding.rbac.authorization.k8s.io/kubevirt-operator created
deployment.apps/virt-operator created

# creating a Custom Resource
controlplane $ kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-cr.yaml
kubevirt.kubevirt.io/kubevirt created
# 实验条件限制 configure KubeVirt to use software emulation for virtualization，会导致低性能
controlplane $ kubectl -n kubevirt patch kubevirt kubevirt --type=merge --patch '{"spec":{"configuration":{"developerConfiguration":{"useEmulation":true}}}}'
kubevirt.kubevirt.io/kubevirt patched

controlplane $ kubectl get pods -n kubevirt
NAME                               READY   STATUS              RESTARTS   AGE
virt-api-8959bd8d6-h4wgf           1/1     Running             0          49s
virt-api-8959bd8d6-kq5gm           1/1     Running             0          50s
virt-controller-6fc6b9b7cf-4ftfc   0/1     ContainerCreating   0          19s
virt-controller-6fc6b9b7cf-8t8fw   0/1     Running             0          19s
virt-handler-2t4zb                 0/1     Init:0/1            0          19s
virt-operator-5c74687999-8769q     1/1     Running             0          2m9s
virt-operator-5c74687999-wp24r     1/1     Running             0          2m9s
controlplane $ kubectl get pods -n kubevirt
NAME                               READY   STATUS    RESTARTS   AGE
virt-api-8959bd8d6-h4wgf           1/1     Running   0          3m3s
virt-api-8959bd8d6-kq5gm           1/1     Running   0          3m4s
virt-controller-6fc6b9b7cf-4ftfc   1/1     Running   0          2m33s
virt-controller-6fc6b9b7cf-8t8fw   1/1     Running   0          2m33s
virt-handler-2t4zb                 1/1     Running   0          2m33s
virt-operator-5c74687999-8769q     1/1     Running   0          4m23s
virt-operator-5c74687999-wp24r     1/1     Running   0          4m23s

# 安装 virtctl
controlplane $ wget -O virtctl https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/virtctl-${KUBEVIRT_VERSION}-linux-amd64
--2022-05-06 06:15:07--  https://github.com/kubevirt/kubevirt/releases/download/v0.49.0/virtctl-v0.49.0-linux-amd64
Resolving github.com (github.com)... 140.82.121.4
Connecting to github.com (github.com)|140.82.121.4|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://objects.githubusercontent.com/github-production-release-asset-2e65be/76686583/1cacd2e3-3748-4498-a87b-6c0217cca458?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20220506%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220506T061509Z&X-Amz-Expires=300&X-Amz-Signature=fdd77e733da9bd98d2adc462718f125ca761d4a3c4325038bd63b61058483806&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=76686583&response-content-disposition=attachment%3B%20filename%3Dvirtctl-v0.49.0-linux-amd64&response-content-type=application%2Foctet-stream [following]
--2022-05-06 06:15:08--  https://objects.githubusercontent.com/github-production-release-asset-2e65be/76686583/1cacd2e3-3748-4498-a87b-6c0217cca458?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20220506%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220506T061509Z&X-Amz-Expires=300&X-Amz-Signature=fdd77e733da9bd98d2adc462718f125ca761d4a3c4325038bd63b61058483806&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=76686583&response-content-disposition=attachment%3B%20filename%3Dvirtctl-v0.49.0-linux-amd64&response-content-type=application%2Foctet-stream
Resolving objects.githubusercontent.com (objects.githubusercontent.com)... 185.199.111.133, 185.199.110.133, 185.199.109.133, ...
Connecting to objects.githubusercontent.com (objects.githubusercontent.com)|185.199.111.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 52294614 (50M) [application/octet-stream]
Saving to: ‘virtctl’

virtctl                            100%[==============================================================>]  49.87M  26.7MB/s    in 1.9s    

2022-05-06 06:15:10 (26.7 MB/s) - ‘virtctl’ saved [52294614/52294614]

controlplane $ chmod +x virtctl
controlplane $ ls
go  virtctl
```

# KubeVirt 基本使用

KubeVirt目的是让虚拟机运行在容器中，下面就用下KubeVirt的几个基本操作：
* create & start 虚拟机
* vnc 登录 虚拟机
* stop & delete 虚拟机

```bash
# vm.yaml: 定义一个虚拟机
controlplane $ curl https://kubevirt.io/labs/manifests/vm.yaml
apiVersion: kubevirt.io/v1
kind: VirtualMachine
metadata:
  name: testvm
spec:
  running: false
  template:
    metadata:
      labels:
        kubevirt.io/size: small
        kubevirt.io/domain: testvm
    spec:
      domain:
        devices:
          disks:
            - name: containerdisk
              disk:
                bus: virtio
            - name: cloudinitdisk
              disk:
                bus: virtio
          interfaces:
          - name: default
            masquerade: {}
        resources:
          requests:
            memory: 64M
      networks:
      - name: default
        pod: {}
      volumes:
        - name: containerdisk
          containerDisk:
            image: quay.io/kubevirt/cirros-container-disk-demo
        - name: cloudinitdisk
          cloudInitNoCloud:
            userDataBase64: SGkuXG4=

# 创建一个虚拟机定义
controlplane $ kubectl apply -f https://kubevirt.io/labs/manifests/vm.yaml
virtualmachine.kubevirt.io/testvm created
controlplane $ kubectl get vms
NAME     AGE   STATUS    READY
testvm   2s    Stopped   False
controlplane $ kubectl get vms -o yaml testvm
apiVersion: kubevirt.io/v1
kind: VirtualMachine
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"kubevirt.io/v1","kind":"VirtualMachine","metadata":{"annotations":{},"name":"testvm","namespace":"default"},"spec":{"running":false,"template":{"metadata":{"labels":{"kubevirt.io/domain":"testvm","kubevirt.io/size":"small"}},"spec":{"domain":{"devices":{"disks":[{"disk":{"bus":"virtio"},"name":"containerdisk"},{"disk":{"bus":"virtio"},"name":"cloudinitdisk"}],"interfaces":[{"masquerade":{},"name":"default"}]},"resources":{"requests":{"memory":"64M"}}},"networks":[{"name":"default","pod":{}}],"volumes":[{"containerDisk":{"image":"quay.io/kubevirt/cirros-container-disk-demo"},"name":"containerdisk"},{"cloudInitNoCloud":{"userDataBase64":"SGkuXG4="},"name":"cloudinitdisk"}]}}}}
    kubevirt.io/latest-observed-api-version: v1
    kubevirt.io/storage-observed-api-version: v1alpha3
  creationTimestamp: "2022-05-06T06:32:17Z"
  generation: 1
  managedFields:
  - apiVersion: kubevirt.io/v1alpha3
    fieldsType: FieldsV1
    fieldsV1:
      f:metadata:
        f:annotations:
          f:kubevirt.io/latest-observed-api-version: {}
          f:kubevirt.io/storage-observed-api-version: {}
      f:status:
        .: {}
        f:conditions: {}
        f:printableStatus: {}
        f:volumeSnapshotStatuses: {}
    manager: Go-http-client
    operation: Update
    time: "2022-05-06T06:32:17Z"
  - apiVersion: kubevirt.io/v1
    fieldsType: FieldsV1
    fieldsV1:
      f:metadata:
        f:annotations:
          .: {}
          f:kubectl.kubernetes.io/last-applied-configuration: {}
      f:spec:
        .: {}
        f:running: {}
        f:template:
          .: {}
          f:metadata:
            .: {}
            f:labels:
              .: {}
              f:kubevirt.io/domain: {}
              f:kubevirt.io/size: {}
          f:spec:
            .: {}
            f:domain:
              .: {}
              f:devices:
                .: {}
                f:disks: {}
                f:interfaces: {}
              f:resources:
                .: {}
                f:requests:
                  .: {}
                  f:memory: {}
            f:networks: {}
            f:volumes: {}
    manager: kubectl
    operation: Update
    time: "2022-05-06T06:32:17Z"
  name: testvm
  namespace: default
  resourceVersion: "5996"
  selfLink: /apis/kubevirt.io/v1/namespaces/default/virtualmachines/testvm
  uid: 1b047ffb-6eeb-4fda-b081-169391886bfb
spec:
  running: false
  template:
    metadata:
      creationTimestamp: null
      labels:
        kubevirt.io/domain: testvm
        kubevirt.io/size: small
    spec:
      domain:
        devices:
          disks:
          - disk:
              bus: virtio
            name: containerdisk
          - disk:
              bus: virtio
            name: cloudinitdisk
          interfaces:
          - masquerade: {}
            name: default
        machine:
          type: q35
        resources:
          requests:
            memory: 64M
      networks:
      - name: default
        pod: {}
      volumes:
      - containerDisk:
          image: quay.io/kubevirt/cirros-container-disk-demo
        name: containerdisk
      - cloudInitNoCloud:
          userDataBase64: SGkuXG4=
        name: cloudinitdisk
status:
  conditions:
  - lastProbeTime: "2022-05-06T06:32:18Z"
    lastTransitionTime: "2022-05-06T06:32:18Z"
    message: VMI does not exist
    reason: VMINotExists
    status: "False"
    type: Ready
  printableStatus: Stopped
  volumeSnapshotStatuses:
  - enabled: false
    name: containerdisk
    reason: Snapshot is not supported for this volumeSource type [containerdisk]
  - enabled: false
    name: cloudinitdisk
    reason: Snapshot is not supported for this volumeSource type [cloudinitdisk]

# 开启虚拟机并检查状态
controlplane $ ./virtctl start testvm
VM testvm was scheduled to start

# 获取虚拟机信息
controlplane $ kubectl get vms
NAME     AGE   STATUS    READY
testvm   40s   Running   True

# 获取虚拟机实例信息
controlplane $ kubectl get vmis
NAME     AGE    PHASE     IP            NODENAME   READY
testvm   104s   Running   10.244.1.12   node01     True
controlplane $  kubectl get vmis -o yaml testvm
apiVersion: kubevirt.io/v1
kind: VirtualMachineInstance
metadata:
  annotations:
    kubevirt.io/latest-observed-api-version: v1
    kubevirt.io/storage-observed-api-version: v1alpha3
  creationTimestamp: "2022-05-06T06:32:38Z"
  finalizers:
  - kubevirt.io/virtualMachineControllerFinalize
  - foregroundDeleteVirtualMachine
  generation: 9
  labels:
    kubevirt.io/domain: testvm
    kubevirt.io/nodeName: node01
    kubevirt.io/size: small
  managedFields:
  - apiVersion: kubevirt.io/v1alpha3
    fieldsType: FieldsV1
    fieldsV1:
      f:metadata:
        f:annotations:
          .: {}
          f:kubevirt.io/latest-observed-api-version: {}
          f:kubevirt.io/storage-observed-api-version: {}
        f:finalizers: {}
        f:labels:
          .: {}
          f:kubevirt.io/domain: {}
          f:kubevirt.io/nodeName: {}
          f:kubevirt.io/size: {}
        f:ownerReferences: {}
      f:spec:
        .: {}
        f:domain:
          .: {}
          f:devices:
            .: {}
            f:disks: {}
            f:interfaces: {}
          f:firmware:
            .: {}
            f:uuid: {}
          f:machine:
            .: {}
            f:type: {}
          f:resources:
            .: {}
            f:requests:
              .: {}
              f:memory: {}
        f:networks: {}
        f:volumes: {}
      f:status:
        .: {}
        f:activePods:
          .: {}
          f:5ed78651-9f18-426f-a248-4bf7b2c8b003: {}
        f:conditions: {}
        f:guestOSInfo: {}
        f:interfaces: {}
        f:launcherContainerImageVersion: {}
        f:migrationMethod: {}
        f:migrationTransport: {}
        f:nodeName: {}
        f:phase: {}
        f:phaseTransitionTimestamps: {}
        f:qosClass: {}
        f:virtualMachineRevisionName: {}
        f:volumeStatus: {}
    manager: Go-http-client
    operation: Update
    time: "2022-05-06T06:32:47Z"
  name: testvm
  namespace: default
  ownerReferences:
  - apiVersion: kubevirt.io/v1
    blockOwnerDeletion: true
    controller: true
    kind: VirtualMachine
    name: testvm
    uid: 1b047ffb-6eeb-4fda-b081-169391886bfb
  resourceVersion: "6141"
  selfLink: /apis/kubevirt.io/v1/namespaces/default/virtualmachineinstances/testvm
  uid: 3721e713-37e9-4871-bb5e-aaad3ab5d44b
spec:
  domain:
    cpu:
      cores: 1
      model: host-model
      sockets: 1
      threads: 1
    devices:
      disks:
      - disk:
          bus: virtio
        name: containerdisk
      - disk:
          bus: virtio
        name: cloudinitdisk
      interfaces:
      - masquerade: {}
        name: default
    features:
      acpi:
        enabled: true
    firmware:
      uuid: 5a9fc181-957e-5c32-9e5a-2de5e9673531
    machine:
      type: q35
    resources:
      requests:
        memory: 64M
  networks:
  - name: default
    pod: {}
  volumes:
  - containerDisk:
      image: quay.io/kubevirt/cirros-container-disk-demo
      imagePullPolicy: Always
    name: containerdisk
  - cloudInitNoCloud:
      userDataBase64: SGkuXG4=
    name: cloudinitdisk
status:
  activePods:
    5ed78651-9f18-426f-a248-4bf7b2c8b003: node01
  conditions:
  - lastProbeTime: null
    lastTransitionTime: "2022-05-06T06:32:46Z"
    status: "True"
    type: Ready
  - lastProbeTime: null
    lastTransitionTime: null
    status: "True"
    type: LiveMigratable
  guestOSInfo: {}
  interfaces:
  - ipAddress: 10.244.1.12
    ipAddresses:
    - 10.244.1.12
    mac: 52:54:00:f8:cf:ce
    name: default
  launcherContainerImageVersion: quay.io/kubevirt/virt-launcher:v0.49.0
  migrationMethod: BlockMigration
  migrationTransport: Unix
  nodeName: node01
  phase: Running
  phaseTransitionTimestamps:
  - phase: Pending
    phaseTransitionTimestamp: "2022-05-06T06:32:39Z"
  - phase: Scheduling
    phaseTransitionTimestamp: "2022-05-06T06:32:39Z"
  - phase: Scheduled
    phaseTransitionTimestamp: "2022-05-06T06:32:46Z"
  - phase: Running
    phaseTransitionTimestamp: "2022-05-06T06:32:48Z"
  qosClass: Burstable
  virtualMachineRevisionName: revision-start-vm-1b047ffb-6eeb-4fda-b081-169391886bfb-2
  volumeStatus:
  - name: cloudinitdisk
    size: 1048576
    target: vdb
  - name: containerdisk
    target: vda

# vnc 登录 创建 的 虚拟机实例
controlplane $ ./virtctl console testvm
Successfully connected to testvm console. The escape sequence is ^]

login as 'cirros' user. default password: 'gocubsgo'. use 'sudo' for root.
testvm login: cirros
Password: 
$ pwd
/home/cirros
$ ls /
bin         home        lib64       mnt         root        tmp
boot        init        linuxrc     old-root    run         usr
dev         initrd.img  lost+found  opt         sbin        var
etc         lib         media       proc        sys         vmlinuz
$ exit

login as 'cirros' user. default password: 'gocubsgo'. use 'sudo' for root.
testvm login: controlplane $ 
controlplane $ ssh 10.224.1.12
^C
controlplane $ ./virtctl stop testvm
VM testvm was scheduled to stop
controlplane $ kubectl get vms
NAME     AGE     STATUS    READY
testvm   4m23s   Stopped   False
controlplane $ kubectl get vmis
NAME     AGE    PHASE       IP            NODENAME   READY
testvm   4m4s   Succeeded   10.244.1.12   node01     False
controlplane $ kubectl delete vms testvm
virtualmachine.kubevirt.io "testvm" deleted
controlplane $ kubectl get vms
No resources found in default namespace.
controlplane $ kubectl get vmis
No resources found in default namespace.
```