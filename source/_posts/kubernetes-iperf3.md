---
title: iperf3测试Kubernetes Service的四层性能（上）
date: 2021-08-09 17:06:01
categories: 云原生
tags:
- iperf3
- Kubernetes
- Service
---

从docker hub下载一个iperf3的镜像
networkstatic/iperf3 - Docker Image | Docker Hub

```bash
docker run -it --rm -p 5201:5201 networkstatic/iperf3 --help
```

启动server端

```bash
docker run  -it --rm --name=iperf3-server -p 5201:5201 networkstatic/iperf3 -s
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
```

获取server端的ip

```bash
docker inspect --format "{{ .NetworkSettings.IPAddress }}" iperf3-server
(Returned) 172.17.0.163
```

启动client端

```bash
docker run  -it --rm networkstatic/iperf3 -c 172.17.0.163
```

```bash
Connecting to host 172.17.0.163, port 5201
[  4] local 172.17.0.191 port 51148 connected to 172.17.0.163 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec  4.16 GBytes  35.7 Gbits/sec    0    468 KBytes
[  4]   1.00-2.00   sec  4.10 GBytes  35.2 Gbits/sec    0    632 KBytes
[  4]   2.00-3.00   sec  4.28 GBytes  36.8 Gbits/sec    0   1.02 MBytes
[  4]   3.00-4.00   sec  4.25 GBytes  36.5 Gbits/sec    0   1.28 MBytes
[  4]   4.00-5.00   sec  4.20 GBytes  36.0 Gbits/sec    0   1.37 MBytes
[  4]   5.00-6.00   sec  4.23 GBytes  36.3 Gbits/sec    0   1.40 MBytes
[  4]   6.00-7.00   sec  4.17 GBytes  35.8 Gbits/sec    0   1.40 MBytes
[  4]   7.00-8.00   sec  4.14 GBytes  35.6 Gbits/sec    0   1.40 MBytes
[  4]   8.00-9.00   sec  4.29 GBytes  36.8 Gbits/sec    0   1.64 MBytes
[  4]   9.00-10.00  sec  4.15 GBytes  35.7 Gbits/sec    0   1.68 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-10.00  sec  42.0 GBytes  36.1 Gbits/sec    0             sender
[  4]   0.00-10.00  sec  42.0 GBytes  36.0 Gbits/sec                  receiver

iperf Done.
```

也可以将上面两步并一步执行

```bash
docker run  -it --rm networkstatic/iperf3 -c $(docker inspect --format "{{ .NetworkSettings.IPAddress }}" $(docker ps -ql))
```

github上有一个开源的项目测试Kubernetes Service性能的开源项目：https://github.com/Pharb/kubernetes-iperf3

```bash
# cd kubernetes-iperf3/
# tree
.
├── LICENSE
├── README.md
├── iperf3.sh
├── iperf3.yaml
├── network-policy.yaml
└── steps
    ├── cleanup.sh
    ├── run.sh
    └── setup.sh
```
iper3.yaml 定义了一个deployment，一个server pod，一个deployment对应的service，一组DaemonSet（分布在每个node节点的client pod）
```yaml
# cat iper3.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: iperf3-server-deployment
  labels:
    app: iperf3-server
spec:
  replicas: 1
  selector:
    matchLabels:
      app: iperf3-server
  template:
    metadata:
      labels:
        app: iperf3-server
    spec:
      affinity:
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 1
            preference:
              matchExpressions:
              - key: kubernetes.io/role
                operator: In
                values:
                - master
      #tolerations:
      #  - key: node-role.kubernetes.io/master
      #    operator: Exists
      #    effect: NoSchedule
      containers:
      - name: iperf3-server
        image: registry.paas/cmss/iperf3
        args: ['-s']
        ports:
        - containerPort: 5201
          name: server
      terminationGracePeriodSeconds: 0


---


apiVersion: v1
kind: Service
metadata:
  name: iperf3-server
spec:
  selector:
    app: iperf3-server
  ports:
  - protocol: TCP
    port: 5201
    targetPort: server
    
---
    
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: iperf3-clients
  labels:
    app: iperf3-client
spec:
  selector:
    matchLabels:
      app: iperf3-client
  template:
    metadata:
      labels:
        app: iperf3-client
    spec:
      #tolerations:
      #  - key: node-role.kubernetes.io/master
      #    operator: Exists
      #    effect: NoSchedule
      containers:
      - name: iperf3-client
        image: registry.paas/cmss/iperf3
        command: ['/bin/sh', '-c', 'sleep infinity']
        # To benchmark manually: kubectl exec iperf3-clients-jlfxq -- /bin/sh -c 'iperf3 -c iperf3-server'
      terminationGracePeriodSeconds: 0
```

```bash
#  cat iperf3.sh
#!/usr/bin/env bash
set -eu

cd $(dirname $0)

steps/setup.sh
steps/run.sh $@
steps/cleanup.sh
```

```bash
#  cat steps/cleanup.sh 
#!/usr/bin/env bash
set -eu

# 删除之前脚本创建的资源
kubectl delete --cascade -f iperf3.yaml
```

```bash
#  cat steps/setup.sh 
#!/usr/bin/env bash
set -eu

# 创建server pod，client pod，service
kubectl create -f iperf3.yaml

until $(kubectl get pods -l app=iperf3-server -o jsonpath='{.items[0].status.containerStatuses[0].ready}'); do
    echo "Waiting for iperf3 server to start..."
    sleep 5
done

# 直到server pod创建成功打印下面的内容
echo "Server is running"
echo
```

```bash
#  cat steps/run.sh 
#!/usr/bin/env bash
set -eu

# 获取每一个client pod名称
CLIENTS=$(kubectl get pods -l app=iperf3-client -o name | cut -d'/' -f2)

for POD in ${CLIENTS}; do
    until $(kubectl get pod ${POD} -o jsonpath='{.status.containerStatuses[0].ready}'); do
        echo "Waiting for ${POD} to start..."
        sleep 5
    done
    # 若client pod创建成功，获取pod所在的机器的ip
    HOST=$(kubectl get pod ${POD} -o jsonpath='{.status.hostIP}')
    echo ${POD}
    echo kubectl exec -it ${POD} -- iperf3 -c iperf3-server -T "Client on ${HOST}" $@
    # $@ 用于接收iperf3.sh命令行参数定制iperf3命令的参数
    # iperf3测试，server端为service的ClusterIP
    kubectl exec -it ${POD} -- iperf3 -c iperf3-server -T "Client on ${HOST}" $@
    echo
done
```

测试的log：
```bash
# ./iperf3.sh -t 5 -p 5201 -M 2000 -P 125 -b 0 >tt.log
# cat tt.log
deployment.apps/iperf3-server-deployment created
service/iperf3-server created
daemonset.apps/iperf3-clients created
Waiting for iperf3 server to start...
Server is running

iperf3-clients-d6n5s
kubectl exec -it iperf3-clients-d6n5s -- iperf3 -c iperf3-server -T Client on 192.168.10.3 -t 5 -p 5201 -M 2000 -P 125 -b 0
Client on 192.168.10.3:  Connecting to host iperf3-server, port 5201
Client on 192.168.10.3:  [  5] local 10.222.47.101 port 47900 connected to 10.233.32.233 port 5201
Client on 192.168.10.3:  [  7] local 10.222.47.101 port 47902 connected to 10.233.32.233 port 5201
Client on 192.168.10.3:  [  9] local 10.222.47.101 port 47904 connected to 10.233.32.233 port 5201
...(省略)
Client on 192.168.10.25:  [251]   0.00-5.00   sec  45.4 MBytes  76.1 Mbits/sec                  receiver
Client on 192.168.10.25:  [253]   0.00-5.00   sec  14.2 MBytes  23.8 Mbits/sec  415             sender
Client on 192.168.10.25:  [253]   0.00-5.00   sec  14.1 MBytes  23.6 Mbits/sec                  receiver
Client on 192.168.10.25:  [SUM]   0.00-5.00   sec  5.35 GBytes  9.20 Gbits/sec  62899             sender
Client on 192.168.10.25:  [SUM]   0.00-5.00   sec  5.29 GBytes  9.09 Gbits/sec                  receiver
Client on 192.168.10.25:  
Client on 192.168.10.25:  iperf Done.

deployment.apps "iperf3-server-deployment" deleted
service "iperf3-server" deleted
daemonset.apps "iperf3-clients" deleted
```
查看上面的完整日志内容 [tt.log](/files/kubernetes-iperf3/tt.log)


```bash
#  grep SUM tt.log 
Client on 192.168.10.3:  [SUM]   0.00-1.00   sec  1.11 GBytes  9.52 Gbits/sec  15808             
Client on 192.168.10.3:  [SUM]   1.00-2.00   sec  1.06 GBytes  9.13 Gbits/sec  11143             
Client on 192.168.10.3:  [SUM]   2.00-3.00   sec  1.07 GBytes  9.15 Gbits/sec  11298             
Client on 192.168.10.3:  [SUM]   3.00-4.00   sec  1.06 GBytes  9.14 Gbits/sec  10923             
Client on 192.168.10.3:  [SUM]   4.00-5.00   sec  1.07 GBytes  9.18 Gbits/sec  9166             
Client on 192.168.10.3:  [SUM]   0.00-5.00   sec  5.37 GBytes  9.22 Gbits/sec  58338             sender
Client on 192.168.10.3:  [SUM]   0.00-5.04   sec  5.35 GBytes  9.12 Gbits/sec                  receiver
Client on 192.168.10.9:  [SUM]   0.00-1.06   sec  3.04 GBytes  24.7 Gbits/sec   97             
Client on 192.168.10.9:  [SUM]   1.06-2.03   sec  2.59 GBytes  22.9 Gbits/sec    0             
Client on 192.168.10.9:  [SUM]   2.03-3.03   sec  3.02 GBytes  25.9 Gbits/sec   12             
Client on 192.168.10.9:  [SUM]   3.03-4.01   sec  2.56 GBytes  22.3 Gbits/sec  293             
Client on 192.168.10.9:  [SUM]   4.01-5.05   sec  3.05 GBytes  25.3 Gbits/sec  212             
Client on 192.168.10.9:  [SUM]   0.00-5.05   sec  14.3 GBytes  24.3 Gbits/sec  614             sender
Client on 192.168.10.9:  [SUM]   0.00-5.05   sec  14.2 GBytes  24.2 Gbits/sec                  receiver
Client on 192.168.10.5:  [SUM]   0.00-1.00   sec  1.11 GBytes  9.57 Gbits/sec  14776             
Client on 192.168.10.5:  [SUM]   1.00-2.00   sec  1.07 GBytes  9.16 Gbits/sec  12169             
Client on 192.168.10.5:  [SUM]   2.00-3.00   sec  1.07 GBytes  9.16 Gbits/sec  10104             
Client on 192.168.10.5:  [SUM]   3.00-4.00   sec  1.06 GBytes  9.13 Gbits/sec  10532             
Client on 192.168.10.5:  [SUM]   4.00-5.00   sec  1.06 GBytes  9.14 Gbits/sec  10034             
Client on 192.168.10.5:  [SUM]   0.00-5.00   sec  5.37 GBytes  9.23 Gbits/sec  57615             sender
Client on 192.168.10.5:  [SUM]   0.00-5.02   sec  5.33 GBytes  9.12 Gbits/sec                  receiver
Client on 192.168.10.25:  [SUM]   0.00-1.00   sec  1.11 GBytes  9.52 Gbits/sec  16004             
Client on 192.168.10.25:  [SUM]   1.00-2.00   sec  1.06 GBytes  9.11 Gbits/sec  13149             
Client on 192.168.10.25:  [SUM]   2.00-3.00   sec  1.06 GBytes  9.13 Gbits/sec  11389             
Client on 192.168.10.25:  [SUM]   3.00-4.00   sec  1.06 GBytes  9.11 Gbits/sec  11071             
Client on 192.168.10.25:  [SUM]   4.00-5.00   sec  1.06 GBytes  9.13 Gbits/sec  11286             
Client on 192.168.10.25:  [SUM]   0.00-5.00   sec  5.35 GBytes  9.20 Gbits/sec  62899             sender
Client on 192.168.10.25:  [SUM]   0.00-5.00   sec  5.29 GBytes  9.09 Gbits/sec                  receiver
```

测下来：
1）iperf3工具并发数1～125对结果没啥影响，都接近单个10G网卡的带宽极限
2）若client pod和server pod在同一个node，数据不出node，传输带宽和网络网卡无关

起16个iperf3客户端模拟并发数2000的后续文章 {% post_link kubernetes-iperf3-2 iperf3测试Kubernetes Service的四层性能（下） %}
