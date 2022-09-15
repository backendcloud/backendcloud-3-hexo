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

# Issue：修改pod-cidr-range（CNI：calico）

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

# Istio ipv4 v6 双栈部署有的环境ok，有的环境有问题（从客户端curl服务端）

通过抓取sidecar的15001端口，有问题的环境15001端口tcp握手会失败，不会有ack响应，但ok的环境tcp握手成功，请求正常处理。

有问题的环境内核版本不支持ipv6的iptables转发。ok的环境内核支持。所以可以通过升级内核版本解决。

在host上也尝试类似的规则，如：

ip6tables -t nat -I OUTPUT -p tcp --dport 30022 -j REDIRECT --to-ports 22

然后验证

ssh fd15:4ba5:5a2b:1008:20c:29ff:fe7c:bcd1 -p 30022

如果转发正确，则可以ssh，否则就不行。

> istio就是通过把iptables把所有出方向的流量引到本地的15001，可以在host上也通过类似的配置进行测试，所有出方向到30022的流量，引到本地22. 原理和istio是一样的。

# Issue： 证书处理

```bash
# 检查证书有效期
[root@kubevirt ~]# kubeadm certs check-expiration
[check-expiration] Reading configuration from the cluster...
[check-expiration] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
W0914 16:43:35.868627   31135 utils.go:69] The recommended value for "clusterDNS" in "KubeletConfiguration" is: [10.233.0.10]; the provided value is: [169.254.25.10]

CERTIFICATE                EXPIRES                  RESIDUAL TIME   CERTIFICATE AUTHORITY   EXTERNALLY MANAGED
admin.conf                 May 25, 2023 09:01 UTC   253d                                    no      
apiserver                  May 25, 2023 09:01 UTC   253d            ca                      no      
apiserver-kubelet-client   May 25, 2023 09:01 UTC   253d            ca                      no      
controller-manager.conf    May 25, 2023 09:01 UTC   253d                                    no      
front-proxy-client         May 25, 2023 09:01 UTC   253d            front-proxy-ca          no      
scheduler.conf             May 25, 2023 09:01 UTC   253d                                    no      

CERTIFICATE AUTHORITY   EXPIRES                  RESIDUAL TIME   EXTERNALLY MANAGED
ca                      May 22, 2032 09:01 UTC   9y              no      
front-proxy-ca          May 22, 2032 09:01 UTC   9y              no      
# 检查证书是否做自动续期
[root@kubevirt ~]# kubectl get cm -o yaml -n kube-system kubeadm-config | grep RotateKubeletServerCertificate
        feature-gates: RotateKubeletServerCertificate=true,TTLAfterFinished=true,ExpandCSIVolumes=true,CSIStorageCapacity=true
        feature-gates: RotateKubeletServerCertificate=true,TTLAfterFinished=true,ExpandCSIVolumes=true,CSIStorageCapacity=true
        feature-gates: RotateKubeletServerCertificate=true,TTLAfterFinished=true,ExpandCSIVolumes=true,CSIStorageCapacity=true
[root@kubevirt ~]# kubectl get no
NAME       STATUS   ROLES                         AGE    VERSION
kubevirt   Ready    control-plane,master,worker   111d   v1.21.5
# 更新证书有效期(下面的方法只适用于 Kubernetes 1.21和以上版本)
[root@kubevirt ~]# kubeadm certs renew all
[renew] Reading configuration from the cluster...
[renew] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
W0914 16:45:30.798557   46420 utils.go:69] The recommended value for "clusterDNS" in "KubeletConfiguration" is: [10.233.0.10]; the provided value is: [169.254.25.10]

certificate embedded in the kubeconfig file for the admin to use and for kubeadm itself renewed
certificate for serving the Kubernetes API renewed
certificate for the API server to connect to kubelet renewed
certificate embedded in the kubeconfig file for the controller manager to use renewed
certificate for the front proxy client renewed
certificate embedded in the kubeconfig file for the scheduler manager to use renewed

Done renewing certificates. You must restart the kube-apiserver, kube-controller-manager, kube-scheduler and etcd, so that they can use the new certificates.
[root@kubevirt ~]# kubeadm certs check-expiration
[check-expiration] Reading configuration from the cluster...
[check-expiration] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
W0914 16:45:44.191471   48482 utils.go:69] The recommended value for "clusterDNS" in "KubeletConfiguration" is: [10.233.0.10]; the provided value is: [169.254.25.10]

CERTIFICATE                EXPIRES                  RESIDUAL TIME   CERTIFICATE AUTHORITY   EXTERNALLY MANAGED
admin.conf                 Sep 14, 2023 08:45 UTC   364d                                    no      
apiserver                  Sep 14, 2023 08:45 UTC   364d            ca                      no      
apiserver-kubelet-client   Sep 14, 2023 08:45 UTC   364d            ca                      no      
controller-manager.conf    Sep 14, 2023 08:45 UTC   364d                                    no      
front-proxy-client         Sep 14, 2023 08:45 UTC   364d            front-proxy-ca          no      
scheduler.conf             Sep 14, 2023 08:45 UTC   364d                                    no      

CERTIFICATE AUTHORITY   EXPIRES                  RESIDUAL TIME   EXTERNALLY MANAGED
ca                      May 22, 2032 09:01 UTC   9y              no      
front-proxy-ca          May 22, 2032 09:01 UTC   9y              no  
# 发现一年内到期证书已经更新到一年后的今天

# 更新配置为证书到期自动续期
[root@kubevirt manifests]# pwd
/etc/kubernetes/manifests
[root@kubevirt manifests]# grep RotateKubeletServerCertificate *
kube-apiserver.yaml:    - --feature-gates=RotateKubeletServerCertificate=true,TTLAfterFinished=true,ExpandCSIVolumes=true,CSIStorageCapacity=true
kube-controller-manager.yaml:    - --feature-gates=RotateKubeletServerCertificate=true,TTLAfterFinished=true,ExpandCSIVolumes=true,CSIStorageCapacity=true
kube-scheduler.yaml:    - --feature-gates=RotateKubeletServerCertificate=true,TTLAfterFinished=true,ExpandCSIVolumes=true,CSIStorageCapacity=true
# 检查配置文件，是否为`--feature-gates=RotateKubeletServerCertificate=true`,不是就修改。
```

# 问题：[emerg] bind() to 0.0.0.0:801 failed (13: Permission denied)

kubectl logs -f pod-xxx 报错：

[emerg] bind() to 0.0.0.0:801 failed (13: Permission denied)

检查异常pod日志，提示权限不足。

进入pod发现是以非root用户启动的：

```bash
[root@centos7 ~]# kubectl exec  ingress-nginx-controller-7b768967bc-fd2hg -ningress-nginx -- id
uid=101(www-data) gid=82(www-data)
```

`sysctl -a|grep unprivileged_port`没有搜到任何信息，说明该参数的值是默认值1024 (1到1023的进程号预留给root用户使用，默认值1024)，所以801端口报权限不足。

2个对策（2选1）：
1. `sysctl -w net.ipv4.ip_unprivileged_port_start=400` （通过sysctl -w的方式只能使参数立即生效（临时生效），如果要永久生效需要将参数配置到/etc/sysctl.conf）
2. 容器用1024或更大的端口