---
title: Istio getting-started
readmore: true
date: 2022-08-30 18:15:40
categories: 云原生
tags:
- Istio
---


# 创建集群
```bash
[root@centos7 ~]# kind create cluster
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.24.0) 🖼
 ✓ Preparing nodes 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️ 
 ✓ Installing CNI 🔌 
 ✓ Installing StorageClass 💾 
Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-kind

Thanks for using kind! 😊
[root@centos7 ~]# kubectl get node
NAME                 STATUS   ROLES           AGE   VERSION
kind-control-plane   Ready    control-plane   28s   v1.24.0
[root@centos7 ~]# kubectl get pod -A
NAMESPACE            NAME                                         READY   STATUS    RESTARTS   AGE
kube-system          coredns-6d4b75cb6d-7jw8j                     1/1     Running   0          12s
kube-system          coredns-6d4b75cb6d-w6h8k                     1/1     Running   0          12s
kube-system          etcd-kind-control-plane                      1/1     Running   0          27s
kube-system          kindnet-b74mg                                1/1     Running   0          13s
kube-system          kube-apiserver-kind-control-plane            1/1     Running   0          26s
kube-system          kube-controller-manager-kind-control-plane   1/1     Running   0          27s
kube-system          kube-proxy-cnvs4                             1/1     Running   0          13s
kube-system          kube-scheduler-kind-control-plane            1/1     Running   0          27s
local-path-storage   local-path-provisioner-9cd9bd544-fbph4       1/1     Running   0          12s
```

# 下载Istio
```bash
[root@centos7 ~]# curl -L https://istio.io/downloadIstio | sh -
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   101  100   101    0     0    234      0 --:--:-- --:--:-- --:--:--   235
100  4856  100  4856    0     0   3826      0  0:00:01  0:00:01 --:--:--  9829

Downloading istio-1.14.3 from https://github.com/istio/istio/releases/download/1.14.3/istio-1.14.3-linux-amd64.tar.gz ...

Istio 1.14.3 Download Complete!

Istio has been successfully downloaded into the istio-1.14.3 folder on your system.

Next Steps:
See https://istio.io/latest/docs/setup/install/ to add Istio to your Kubernetes cluster.

To configure the istioctl client tool for your workstation,
add the /root/istio-1.14.3/bin directory to your environment path variable with:
         export PATH="$PATH:/root/istio-1.14.3/bin"

Begin the Istio pre-installation check by running:
         istioctl x precheck 

Need more information? Visit https://istio.io/latest/docs/setup/install/ 
[root@centos7 ~]# ls
anaconda-ks.cfg  istio-1.14.3
[root@centos7 ~]# cd istio-1.14.3/
[root@centos7 istio-1.14.3]# ls
bin  LICENSE  manifests  manifest.yaml  README.md  samples  tools
[root@centos7 istio-1.14.3]# cd bin/
[root@centos7 bin]# mv istioctl /usr/bin/
```

# 安装Istio
```bash
[root@centos7 bin]# istioctl install --set profile=demo -y
✔ Istio core installed                                                                                                                                                                                                                                                      
✔ Istiod installed                                                                                                                                                                                                                                                          
✔ Ingress gateways installed                                                                                                                                                                                                                                                
✔ Egress gateways installed                                                                                                                                                                                                                                                 
✔ Installation complete                                                                                                                                                                                                                                                     Making this installation the default for injection and validation.

Thank you for installing Istio 1.14.  Please take a few minutes to tell us about your install/upgrade experience!  https://forms.gle/yEtCbt45FZ3VoDT5A
[root@centos7 bin]# kubectl label namespace default istio-injection=enabled
namespace/default labeled
```



# 部署和测试示例应用Bookinfo
```bash
[root@centos7 bin]# cd ..
[root@centos7 istio-1.14.3]# kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
service/details created
serviceaccount/bookinfo-details created
deployment.apps/details-v1 created
service/ratings created
serviceaccount/bookinfo-ratings created
deployment.apps/ratings-v1 created
service/reviews created
serviceaccount/bookinfo-reviews created
deployment.apps/reviews-v1 created
deployment.apps/reviews-v2 created
deployment.apps/reviews-v3 created
service/productpage created
serviceaccount/bookinfo-productpage created
deployment.apps/productpage-v1 created
[root@centos7 istio-1.14.3]# kubectl get svc
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
details       ClusterIP   10.96.25.203    <none>        9080/TCP   2m5s
kubernetes    ClusterIP   10.96.0.1       <none>        443/TCP    8m9s
productpage   ClusterIP   10.96.111.255   <none>        9080/TCP   2m5s
ratings       ClusterIP   10.96.168.90    <none>        9080/TCP   2m5s
reviews       ClusterIP   10.96.62.22     <none>        9080/TCP   2m5s
[root@centos7 istio-1.14.3]# kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
details-v1-b48c969c5-kksz5        2/2     Running   0          2m11s
productpage-v1-74fdfbd7c7-5zwnm   2/2     Running   0          2m11s
ratings-v1-b74b895c5-l58q2        2/2     Running   0          2m11s
reviews-v1-68b4dcbdb9-gc622       2/2     Running   0          2m11s
reviews-v2-565bcd7987-hdgl7       2/2     Running   0          2m11s
reviews-v3-d88774f9c-hbgwc        2/2     Running   0          2m11s
[root@centos7 istio-1.14.3]# kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -s productpage:9080/productpage | grep -o "<title>.*</title>"
<title>Simple Bookstore App</title>
```

# 对外开放应用程序

**把应用关联到 Istio 网关：**

```bash
[root@centos7 istio-1.14.3]# kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
gateway.networking.istio.io/bookinfo-gateway created
virtualservice.networking.istio.io/bookinfo created
```

**确保配置文件没有问题：**

```bash
[root@centos7 istio-1.14.3]# istioctl analyze

✔ No validation issues found when analyzing namespace: default.
[root@centos7 istio-1.14.3]# kubectl get svc istio-ingressgateway -n istio-system
NAME                   TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)                                                                      AGE
istio-ingressgateway   LoadBalancer   10.96.92.180   <pending>     15021:30478/TCP,80:31309/TCP,443:32600/TCP,31400:31566/TCP,15443:30176/TCP   13m
```

> EXTERNAL-IP 一直是 <pending> 状态， 因为沙盒环境没有提供可作为入站流量网关的外部负载均衡。 在这个情况下，可以用服务（Service）的 节点端口 访问网关。

```bash
[root@centos7 istio-1.14.3]# export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
[root@centos7 istio-1.14.3]# export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
[root@centos7 istio-1.14.3]# docker ps
CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS          PORTS                       NAMES
abf3ae7ba9f4   kindest/node:v1.24.0   "/usr/local/bin/entr…"   21 minutes ago   Up 21 minutes   127.0.0.1:37305->6443/tcp   kind-control-plane
[root@centos7 istio-1.14.3]# docker inspect abf3ae7ba9f4|grep IPAdd
            "SecondaryIPAddresses": null,
            "IPAddress": "",
                    "IPAddress": "172.18.0.2",
[root@centos7 istio-1.14.3]# export INGRESS_HOST=172.18.0.2
[root@centos7 istio-1.14.3]# export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
[root@centos7 istio-1.14.3]# echo "http://$GATEWAY_URL/productpage"
http://172.18.0.2:31309/productpage
```

![](/images/istio-getting-started/2022-08-30-16-43-39.png)

# 安装 Kiali 和其他插件

```bash
[root@centos7 istio-1.14.3]# kubectl apply -f samples/addons
serviceaccount/grafana created
configmap/grafana created
service/grafana created
deployment.apps/grafana created
configmap/istio-grafana-dashboards created
configmap/istio-services-grafana-dashboards created
deployment.apps/jaeger created
service/tracing created
service/zipkin created
service/jaeger-collector created
serviceaccount/kiali created
configmap/kiali created
clusterrole.rbac.authorization.k8s.io/kiali-viewer created
clusterrole.rbac.authorization.k8s.io/kiali created
clusterrolebinding.rbac.authorization.k8s.io/kiali created
role.rbac.authorization.k8s.io/kiali-controlplane created
rolebinding.rbac.authorization.k8s.io/kiali-controlplane created
service/kiali created
deployment.apps/kiali created
serviceaccount/prometheus created
configmap/prometheus created
clusterrole.rbac.authorization.k8s.io/prometheus created
clusterrolebinding.rbac.authorization.k8s.io/prometheus created
service/prometheus created
deployment.apps/prometheus created
[root@centos7 istio-1.14.3]# kubectl rollout status deployment/kiali -n istio-system
Waiting for deployment "kiali" rollout to finish: 0 of 1 updated replicas are available...
deployment "kiali" successfully rolled out
istioctl dashboard kiali
```

# 访问 Kiali 仪表板

![](/images/istio-getting-started/2022-08-30-16-57-15.png)

![](/images/istio-getting-started/2022-08-30-16-53-28.png)