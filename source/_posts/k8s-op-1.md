---
title: Kubernetes 运维遇到的问题记录（1）
readmore: true
date: 2022-09-13 18:14:49
categories: 云原生
tags:
- 运维
---

# 问题：老应用不能通过kubectl exec进入，新应用不能创建

ssh进入集群节点，telnet 本机的 kubelete 的 服务端口 10250，可以。

从本机telnet其他节点的10250端口失败。

集群做了网络策略导致。需要放开10250端口策略。

测试环境中若集群所在节点是vm，可以通过Openstack关闭port-security解决：neutron port-update port-id-zzzzz --port-security_enabled=False

# 任务：修改pod-cidr-range（CNI：calico）

1. 安装calicoctl as a Kubernetes pod

```bash
# kubectl apply -f https://docs.projectcalico.org/manifests/calicoctl.yaml
# alias calicoctl="kubectl exec -i -n kube-system calicoctl -- /calicoctl "
```

2. 新增一个IP pool

```yaml
calicoctl create -f -<<EOF
apiVersion: projectcalico.org/v3
kind: IPPool
metadata:
  name: new-pool
spec:
  cidr: 10.0.0.0/8
  ipipMode: Always
  natOutgoing: true
EOF
```

calicoctl get ippool -o wide 可以看到多了一行

3. Disable 旧的 IP pool

calicoctl get ippool -o yaml > pool.yaml

vim pool.yaml , 修改或新增：`disabled: true`

```yaml
apiVersion: projectcalico.org/v3
kind: IPPool
metadata:
  name: default-ipv4-ippool
spec:
  cidr: 192.168.0.0/16
  ipipMode: Always
  natOutgoing: true
  disabled: true
```

calicoctl apply -f pool.yaml

4. 修改所有节点的podCIDR

```bash
$ kubectl get no kubeadm-0 -o yaml > file.yaml; sed -i "s~192.168.0.0/24~10.0.0.0/16~" file.yaml; kubectl delete no kubeadm-0 && kubectl create -f file.yaml
$ kubectl get no kubeadm-1 -o yaml > file.yaml; sed -i "s~192.168.1.0/24~10.1.0.0/16~" file.yaml; kubectl delete no kubeadm-1 && kubectl create -f file.yaml
$ kubectl get no kubeadm-2 -o yaml > file.yaml; sed -i "s~192.168.2.0/24~10.2.0.0/16~" file.yaml; kubectl delete no kubeadm-2 && kubectl create -f file.yaml 
```

5. 修改kubeadm-config和kube-proxy ConfigMap 以及 kube-controller-manager.yaml

kubectl -n kube-system edit cm kubeadm-config

kubectl -n kube-system edit cm kube-proxy

vim /etc/kubernetes/manifests/kube-controller-manager.yaml

修改 --cluster-cidr=xxx 的内容

6. 删除existing workloads using IPs from the disabled pool.（比如：集群部署时候在calico服务正常后第一个使用calico ip pool的coredns）

kubectl delete pod -n kube-system coredns-5495dd7c88-b2zcs

通过 calicoctl get wep --all-namespaces 检查新生成的coredns pod是否用了新的calico ip pool的ip。

7. 删除旧的IP pool

calicoctl delete pool default-ipv4-ippool

# 问题：Failed to mount API filesystems, freezing.

```bash
Failed to mount tmpfs at /run: Operation not permitted
Failed to mount cgroup at /sys/fs/cgroup/systemd: Operation not permitted
[!!!!!!] Failed to mount API filesystems, freezing.
# 解决方法：挂载宿主机的cgroup
docker run -it -d --name=centos7 --privileged=true -p 80:80 -v /sys/fs/cgroup:/sys/fs/cgroup:ro sevming/centos7:0.1
docker exec -it centos7 /bin/bash
systemctl status
```

> 若在容器中运行systemd，上面的方式不是一个好的方式，建议使用官方镜像： https://hub.docker.com/r/centos/systemd

# 问题：ingress通过hostport暴露端口30067不能访问

检查发现ingress controller使用的80端口，与haproxy冲突

# 问题：不同节点的pod间无法通讯

/proc/sys/net/ipv4/ip_forward为0，ip转发功能关闭导致无法访问pod，改成1解决。

# 问题：在pod所在节点可以访问service port，在pod中无法访问service port

pod中路由丢失，重启CNI网络插件，恢复pod路由信息。

# 问题：容器内访问不了集群节点的v6地址

calicoctl edit ippool default-ipv6-ippool

添加参数 natOutgoing: true

# Istio ipv4v6双栈部署有的环境ok，有的环境有问题（从客户端curl服务端）

通过抓取sidecar的15001端口，有问题的环境15001端口tcp握手会失败，不会有ack响应，但ok的环境tcp握手成功，请求正常处理。

有问题的环境内核版本不支持ipv6的iptables转发。ok的环境支持。

在host上也尝试类似的规则，如：

ip6tables -t nat -I OUTPUT -p tcp --dport 30022 -j REDIRECT --to-ports 22

然后验证

ssh fd15:4ba5:5a2b:1008:20c:29ff:fe7c:bcd1 -p 30022

如果转发正确，则可以ssh，否则就不行。

> istio就是通过把iptables把所有出方向的流量引到本地的15001，可以在host上也通过类似的配置进行测试，所有出方向到30022的流量，引到本地22. 原理和istio是一样的。

