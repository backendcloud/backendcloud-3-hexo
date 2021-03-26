title: k8s支持容器核绑定
date: 2020-05-22 16:24:44
categories: 容器
tags:
- k8s
- Kubernetes
- cpu核绑定

---

找到应用对应的Pid，查看没有绑定到固定核上，而是在一个cpu池子里随机选。

    [root@paasm1 ~]# cat cpu-ram.yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: cpu-ram-demo
    spec:
      containers:
      - name: cpu-ram-demo-container
        image: registry.paas/library/nginx:1.15.9
        resources:
          requests:
            memory: "200Mi"
            cpu: "2"
          limits:
            memory: "200Mi"
            cpu: "2"
        volumeMounts:
          - mountPath: /etc/work
            name: host5490
      volumes:
      - hostPath:
            path: /docker_temp
        name: host5490
    [root@paasm1 ~]# kubectl create -f cpu-ram.yaml
    
    [root@paasn4 ~]# docker ps|grep demo
    9fe80681cc9d        8c9ca4d17702                              "nginx -g 'daemon of…"   25 seconds ago      Up 24 seconds                           k8s_cpu-ram-demo-container_cpu-ram-demo_default_380104ec-9bfc-11ea-a000-04bd7053eff0_0
    ae41406867d7        registry.paas/cmss/pause-amd64:3.1        "/pause"                 26 seconds ago      Up 25 seconds                           k8s_POD_cpu-ram-demo_default_380104ec-9bfc-11ea-a000-04bd7053eff0_0
    [root@paasn4 ~]# docker inspect 9fe80681cc9d|grep Pid
                "Pid": 118177,
                "PidMode": "",
                "PidsLimit": 0,
    [root@paasn4 ~]# taskset -c -p 118177
    pid 118177's current affinity list: 0-39


开启容器工作节点支持cpu核绑定特性：

    [root@paasn4 ~]# kubectl delete -f cpu-ram.yaml
    [root@paasn4 ~]# kubectl drain paasn4
    [root@paasn4 ~]# systemctl stop kubelet
    [root@paasn4 ~]# systemctl status kubelet
    [root@paasn4 ~]# mv /dcos/kubelet/cpu_manager_state /dcos/kubelet/bak_cpu_manager_state
    修改kubelet的启动参数，添加: --cpu-manager-policy=static 和 --kube-reserved=cpu=1（给cpu池子留点资源）
    [root@paasn4 ~]# vim /etc/systemd/system/kubelet.service
    [root@paasn4 ~]# systemctl daemon-reload
    [root@paasn4 ~]# systemctl start kubelet
    [root@paasn4 ~]# systemctl status kubelet
    [root@paasn4 ~]# kubectl uncordon  paasn4


找到应用对应的Pid，查看已绑定到固定核上。

    [root@paasn4 ~]# docker ps|grep demo
    8da22cd45eda        8c9ca4d17702                              "nginx -g 'daemon of…"   23 seconds ago      Up 22 seconds                           k8s_cpu-ram-demo-container_cpu-ram-demo_default_ef1a0d28-9bfc-11ea-a000-04bd7053eff0_0
    c81430f7ca4e        registry.paas/cmss/pause-amd64:3.1        "/pause"                 24 seconds ago      Up 22 seconds                           k8s_POD_cpu-ram-demo_default_ef1a0d28-9bfc-11ea-a000-04bd7053eff0_0
    [root@paasn4 ~]# docker inspect 8da22cd45eda|grep Pid
                "Pid": 123203,
                "PidMode": "",
                "PidsLimit": 0,
    [root@paasn4 ~]# taskset -c -p 123203
    pid 123203's current affinity list: 1,21

