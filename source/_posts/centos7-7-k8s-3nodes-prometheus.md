title: CentOS7.7部署k8s + Prometheus（1 master + 2 node）
date: 2020-04-16 13:46:34
categories:
- 容器
tags:
- CentOS7.7
- k8s
- Prometheus
---

k8s部署参考之前的文章 {% post_link centos7-7-k8s-3nodes %} 

# Prometheus部署

以下在master节点执行

    # git clone https://github.com/coreos/kube-prometheus.git

以下在master，work节点执行

    # docker pull registry.cn-hangzhou.aliyuncs.com/loong576/configmap-reload:v0.0.1
    # docker pull registry.cn-hangzhou.aliyuncs.com/loong576/alertmanager:v0.18.0
    # docker pull registry.cn-hangzhou.aliyuncs.com/loong576/kube-state-metrics:v1.8.0
    # docker pull registry.cn-hangzhou.aliyuncs.com/loong576/kube-rbac-proxy:v0.4.1
    # docker pull registry.cn-hangzhou.aliyuncs.com/loong576/node-exporter:v0.18.1
    # docker pull registry.cn-hangzhou.aliyuncs.com/loong576/k8s-prometheus-adapter-amd64:v0.5.0
    # docker pull registry.cn-hangzhou.aliyuncs.com/loong576/prometheus-config-reloader:v0.33.0
    # docker pull registry.cn-hangzhou.aliyuncs.com/loong576/prometheus:v2.11.0
    # docker pull registry.cn-hangzhou.aliyuncs.com/loong576/prometheus-operator:v0.33.0
    # docker pull registry.cn-hangzhou.aliyuncs.com/loong576/grafana:6.4.3
     
    # docker tag  registry.cn-hangzhou.aliyuncs.com/loong576/configmap-reload:v0.0.1 quay.io/coreos/configmap-reload:v0.0.1
    # docker tag registry.cn-hangzhou.aliyuncs.com/loong576/alertmanager:v0.18.0 quay.io/prometheus/alertmanager:v0.18.0
    # docker tag registry.cn-hangzhou.aliyuncs.com/loong576/kube-state-metrics:v1.8.0 quay.io/coreos/kube-state-metrics:v1.8.0
    # docker tag registry.cn-hangzhou.aliyuncs.com/loong576/kube-rbac-proxy:v0.4.1 quay.io/coreos/kube-rbac-proxy:v0.4.1
    # docker tag registry.cn-hangzhou.aliyuncs.com/loong576/node-exporter:v0.18.1  quay.io/prometheus/node-exporter:v0.18.1
    # docker tag  registry.cn-hangzhou.aliyuncs.com/loong576/k8s-prometheus-adapter-amd64:v0.5.0 quay.io/coreos/k8s-prometheus-adapter-amd64:v0.5.0
    # docker tag  registry.cn-hangzhou.aliyuncs.com/loong576/prometheus-config-reloader:v0.33.0 quay.io/coreos/prometheus-config-reloader:v0.33.0
    # docker tag registry.cn-hangzhou.aliyuncs.com/loong576/prometheus:v2.11.0 quay.io/prometheus/prometheus:v2.11.0
    # docker tag registry.cn-hangzhou.aliyuncs.com/loong576/prometheus-operator:v0.33.0  quay.io/coreos/prometheus-operator:v0.33.0
    # docker tag registry.cn-hangzhou.aliyuncs.com/loong576/grafana:6.4.3 grafana/grafana:6.4.3
     
    # docker rmi -f  registry.cn-hangzhou.aliyuncs.com/loong576/configmap-reload:v0.0.1
    # docker rmi -f registry.cn-hangzhou.aliyuncs.com/loong576/alertmanager:v0.18.0
    # docker  rmi -f  registry.cn-hangzhou.aliyuncs.com/loong576/kube-state-metrics:v1.8.0
    # docker  rmi -f  registry.cn-hangzhou.aliyuncs.com/loong576/kube-rbac-proxy:v0.4.1
    # docker  rmi -f  registry.cn-hangzhou.aliyuncs.com/loong576/node-exporter:v0.18.1
    # docker  rmi -f  registry.cn-hangzhou.aliyuncs.com/loong576/k8s-prometheus-adapter-amd64:v0.5.0
    # docker  rmi -f  registry.cn-hangzhou.aliyuncs.com/loong576/prometheus-config-reloader:v0.33.0
    # docker  rmi -f  registry.cn-hangzhou.aliyuncs.com/loong576/prometheus:v2.11.0
    # docker  rmi -f  registry.cn-hangzhou.aliyuncs.com/loong576/prometheus-operator:v0.33.0
    # docker  rmi -f  registry.cn-hangzhou.aliyuncs.com/loong576/grafana:6.4.3

    # docker images
    REPOSITORY                                    TAG                 IMAGE ID            CREATED             SIZE
    httpd                                         latest              8326be82abe6        2 weeks ago         166MB
    nginx                                         latest              ed21b7a8aee9        2 weeks ago         127MB
    quay.io/coreos/flannel                        v0.12.0-amd64       4e9f801d2217        4 weeks ago         52.8MB
    grafana/grafana                               6.4.3               a532fe3b344a        6 months ago        206MB
    quay.io/coreos/prometheus-operator            v0.33.0             9863649e193b        6 months ago        42.1MB
    quay.io/coreos/kube-state-metrics             v1.8.0              9bc8e75a1a21        6 months ago        33.6MB
    quay.io/coreos/prometheus-config-reloader     v0.33.0             2d95323c37d6        7 months ago        17.6MB
    quay.io/prometheus/prometheus                 v2.11.0             b97ed892eb23        9 months ago        126MB
    quay.io/prometheus/alertmanager               v0.18.0             ce3c87f17369        9 months ago        51.9MB
    quay.io/prometheus/node-exporter              v0.18.1             e5a616e4b9cf        10 months ago       22.9MB
    k8s.gcr.io/kube-proxy                         v1.14.2             5c24210246bb        11 months ago       82.1MB
    k8s.gcr.io/kube-apiserver                     v1.14.2             5eeff402b659        11 months ago       210MB
    k8s.gcr.io/kube-controller-manager            v1.14.2             8be94bdae139        11 months ago       158MB
    k8s.gcr.io/kube-scheduler                     v1.14.2             ee18f350636d        11 months ago       81.6MB
    quay.io/coreos/k8s-prometheus-adapter-amd64   v0.5.0              5f0fc84e586c        12 months ago       60.9MB
    quay.io/coreos/kube-rbac-proxy                v0.4.1              70eeaa7791f2        14 months ago       41.3MB
    k8s.gcr.io/coredns                            1.3.1               eb516548c180        15 months ago       40.3MB
    k8s.gcr.io/etcd                               3.3.10              2c4adeb21b4f        16 months ago       258MB
    k8s.gcr.io/pause                              3.1                 da86e6ba6ca1        2 years ago         742kB
    quay.io/coreos/configmap-reload               v0.0.1              3129a2ca29d7        3 years ago         4.79MB

<!-- more -->

以下在master节点执行

    # kubectl create -f manifests/setup
    namespace/monitoring created
    customresourcedefinition.apiextensions.k8s.io/alertmanagers.monitoring.coreos.com created
    customresourcedefinition.apiextensions.k8s.io/podmonitors.monitoring.coreos.com created
    customresourcedefinition.apiextensions.k8s.io/prometheuses.monitoring.coreos.com created
    customresourcedefinition.apiextensions.k8s.io/prometheusrules.monitoring.coreos.com created
    customresourcedefinition.apiextensions.k8s.io/servicemonitors.monitoring.coreos.com created
    customresourcedefinition.apiextensions.k8s.io/thanosrulers.monitoring.coreos.com created
    clusterrole.rbac.authorization.k8s.io/prometheus-operator created
    clusterrolebinding.rbac.authorization.k8s.io/prometheus-operator created
    deployment.apps/prometheus-operator created
    service/prometheus-operator created
    serviceaccount/prometheus-operator created
    #  kubectl create -f manifests/
    alertmanager.monitoring.coreos.com/main created
    secret/alertmanager-main created
    service/alertmanager-main created
    serviceaccount/alertmanager-main created
    servicemonitor.monitoring.coreos.com/alertmanager created
    secret/grafana-datasources created
    configmap/grafana-dashboard-apiserver created
    configmap/grafana-dashboard-cluster-total created
    configmap/grafana-dashboard-controller-manager created
    configmap/grafana-dashboard-k8s-resources-cluster created
    configmap/grafana-dashboard-k8s-resources-namespace created
    configmap/grafana-dashboard-k8s-resources-node created
    configmap/grafana-dashboard-k8s-resources-pod created
    configmap/grafana-dashboard-k8s-resources-workload created
    configmap/grafana-dashboard-k8s-resources-workloads-namespace created
    configmap/grafana-dashboard-kubelet created
    configmap/grafana-dashboard-namespace-by-pod created
    configmap/grafana-dashboard-namespace-by-workload created
    configmap/grafana-dashboard-node-cluster-rsrc-use created
    configmap/grafana-dashboard-node-rsrc-use created
    configmap/grafana-dashboard-nodes created
    configmap/grafana-dashboard-persistentvolumesusage created
    configmap/grafana-dashboard-pod-total created
    configmap/grafana-dashboard-prometheus-remote-write created
    configmap/grafana-dashboard-prometheus created
    configmap/grafana-dashboard-proxy created
    configmap/grafana-dashboard-scheduler created
    configmap/grafana-dashboard-statefulset created
    configmap/grafana-dashboard-workload-total created
    configmap/grafana-dashboards created
    deployment.apps/grafana created
    service/grafana created
    serviceaccount/grafana created
    servicemonitor.monitoring.coreos.com/grafana created
    clusterrole.rbac.authorization.k8s.io/kube-state-metrics created
    clusterrolebinding.rbac.authorization.k8s.io/kube-state-metrics created
    deployment.apps/kube-state-metrics created
    service/kube-state-metrics created
    serviceaccount/kube-state-metrics created
    servicemonitor.monitoring.coreos.com/kube-state-metrics created
    clusterrole.rbac.authorization.k8s.io/node-exporter created
    clusterrolebinding.rbac.authorization.k8s.io/node-exporter created
    daemonset.apps/node-exporter created
    service/node-exporter created
    serviceaccount/node-exporter created
    servicemonitor.monitoring.coreos.com/node-exporter created
    apiservice.apiregistration.k8s.io/v1beta1.metrics.k8s.io created
    clusterrole.rbac.authorization.k8s.io/prometheus-adapter created
    clusterrole.rbac.authorization.k8s.io/system:aggregated-metrics-reader created
    clusterrolebinding.rbac.authorization.k8s.io/prometheus-adapter created
    clusterrolebinding.rbac.authorization.k8s.io/resource-metrics:system:auth-delegator created
    clusterrole.rbac.authorization.k8s.io/resource-metrics-server-resources created
    configmap/adapter-config created
    deployment.apps/prometheus-adapter created
    rolebinding.rbac.authorization.k8s.io/resource-metrics-auth-reader created
    service/prometheus-adapter created
    serviceaccount/prometheus-adapter created
    clusterrole.rbac.authorization.k8s.io/prometheus-k8s created
    clusterrolebinding.rbac.authorization.k8s.io/prometheus-k8s created
    servicemonitor.monitoring.coreos.com/prometheus-operator created
    prometheus.monitoring.coreos.com/k8s created
    rolebinding.rbac.authorization.k8s.io/prometheus-k8s-config created
    rolebinding.rbac.authorization.k8s.io/prometheus-k8s created
    rolebinding.rbac.authorization.k8s.io/prometheus-k8s created
    rolebinding.rbac.authorization.k8s.io/prometheus-k8s created
    role.rbac.authorization.k8s.io/prometheus-k8s-config created
    role.rbac.authorization.k8s.io/prometheus-k8s created
    role.rbac.authorization.k8s.io/prometheus-k8s created
    role.rbac.authorization.k8s.io/prometheus-k8s created
    prometheusrule.monitoring.coreos.com/prometheus-k8s-rules created
    service/prometheus-k8s created
    serviceaccount/prometheus-k8s created
    servicemonitor.monitoring.coreos.com/prometheus created
    servicemonitor.monitoring.coreos.com/kube-apiserver created
    servicemonitor.monitoring.coreos.com/coredns created
    servicemonitor.monitoring.coreos.com/kube-controller-manager created
    servicemonitor.monitoring.coreos.com/kube-scheduler created
    servicemonitor.monitoring.coreos.com/kubelet created
    # kubectl get all -n monitoring
    NAME                                       READY   STATUS              RESTARTS   AGE
    pod/grafana-75d8c76bdd-nnltr               0/1     ContainerCreating   0          25s
    pod/kube-state-metrics-85f87d7cf4-9q9tv    0/3     ContainerCreating   0          25s
    pod/node-exporter-lnffn                    2/2     Running             0          25s
    pod/node-exporter-lxwrq                    2/2     Running             0          25s
    pod/node-exporter-xwcbq                    2/2     Running             0          25s
    pod/prometheus-adapter-8667948d79-7rs7r    1/1     Running             0          25s
    pod/prometheus-operator-5d968f877c-ppmm5   0/2     ContainerCreating   0          73s
    
    NAME                          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
    service/alertmanager-main     ClusterIP   10.111.225.139   <none>        9093/TCP            26s
    service/grafana               ClusterIP   10.102.151.3     <none>        3000/TCP            26s
    service/kube-state-metrics    ClusterIP   None             <none>        8443/TCP,9443/TCP   26s
    service/node-exporter         ClusterIP   None             <none>        9100/TCP            26s
    service/prometheus-adapter    ClusterIP   10.106.36.138    <none>        443/TCP             26s
    service/prometheus-k8s        ClusterIP   10.106.71.50     <none>        9090/TCP            25s
    service/prometheus-operator   ClusterIP   None             <none>        8443/TCP            74s
    
    NAME                           DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
    daemonset.apps/node-exporter   3         3         3       3            3           kubernetes.io/os=linux   26s
    
    NAME                                  READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/grafana               0/1     1            0           26s
    deployment.apps/kube-state-metrics    0/1     1            0           26s
    deployment.apps/prometheus-adapter    1/1     1            1           26s
    deployment.apps/prometheus-operator   0/1     1            0           74s
    
    NAME                                             DESIRED   CURRENT   READY   AGE
    replicaset.apps/grafana-75d8c76bdd               1         1         0       26s
    replicaset.apps/kube-state-metrics-85f87d7cf4    1         1         0       26s
    replicaset.apps/prometheus-adapter-8667948d79    1         1         1       26s
    replicaset.apps/prometheus-operator-5d968f877c   1         1         0       74s
    # kubectl get prometheus --all-namespaces -o wide
    NAMESPACE    NAME   VERSION   REPLICAS   AGE
    monitoring   k8s    v2.15.2   2          45s

更改访问方式

    # kubectl edit -n monitoring service prometheus-k8s
    # kubectl edit -n monitoring service grafana
    # kubectl edit -n monitoring service alertmanager-main
    分别修改service prometheus-k8s、grafana和alertmanager-main，service类型为NodePort，端口分别为30021、30022、30023。
    比如，在port: 9090下新增一行nodePort: 30021，将type: 后面的值修改成NodePort



# 页面展示

## 访问 Prometheus
![pic](/images/centos7-7-k8s-3nodes-prometheus/1.png)
![pic](/images/centos7-7-k8s-3nodes-prometheus/2.png)

## 访问 Grafana
用户名密码都为admin
![pic](/images/centos7-7-k8s-3nodes-prometheus/3.png)
![pic](/images/centos7-7-k8s-3nodes-prometheus/4.png)
![pic](/images/centos7-7-k8s-3nodes-prometheus/5.png)

## 访问 Alert Manager
![pic](/images/centos7-7-k8s-3nodes-prometheus/6.png)


# Prometheus 卸载

    # kubectl delete --ignore-not-found=true -f manifests/ -f manifests/setup

