---
title: Kubernetes 运维记录（5）
readmore: true
date: 2023-01-11 13:01:06
categories: 云原生
tags:
- 运维
---

# 合理设置 Request 与 Limit

**所有容器都应该设置 request**

request 的值并不是指给容器实际分配的资源大小，它仅仅是给调度器看的，调度器会 "观察" 每个节点可以用于分配的资源有多少，也知道每个节点已经被分配了多少资源。被分配资源的大小就是节点上所有 Pod 中定义的容器 request 之和，它可以计算出节点剩余多少资源可以被分配(可分配资源减去已分配的 request 之和)。如果发现节点剩余可分配资源大小比当前要被调度的 Pod 的 reuqest 还小，那么就不会考虑调度到这个节点，反之，才可能调度。所以，如果不配置 request，那么调度器就不能知道节点大概被分配了多少资源出去，调度器得不到准确信息，也就无法做出合理的调度决策，很容易造成调度不合理，有些节点可能很闲，而有些节点可能很忙，甚至 NotReady。

节点资源不足时，会触发自动驱逐，将一些低优先级的 Pod 删除掉以释放资源让节点自愈。没有设置 request，limit 的 Pod 优先级最低，容易被驱逐；request 不等于 limit 的其次； request 等于 limit 的 Pod 优先级较高，不容易被驱逐。所以如果是重要的线上应用，不希望在节点故障时被驱逐导致线上业务受影响，就建议将 request 和 limit 设成一致。

所以，建议是给所有容器都设置 request，让调度器感知节点有多少资源被分配了，以便做出合理的调度决策，让集群节点的资源能够被合理的分配使用，避免陷入资源分配不均导致一些意外发生。

有时候我们会忘记给部分容器设置 request 与 limit，其实我们可以使用 LimitRange 来设置 namespace 的默认 request 与 limit 值，同时它也可以用来限制最小和最大的 request 与 limit。 示例:

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: mem-limit-range
  namespace: test
spec:
  limits:
  - default:
      memory: 512Mi
      cpu: 500m
    defaultRequest:
      memory: 256Mi
      cpu: 100m
    type: Container
```

**尽量避免使用过大的 request 与 limit**

如果你的服务使用单副本或者少量副本，给很大的 request 与 limit，让它分配到足够多的资源来支撑业务，那么某个副本故障对业务带来的影响可能就比较大，并且由于 request 较大，当集群内资源分配比较碎片化，如果这个 Pod 所在节点挂了，其它节点又没有一个有足够的剩余可分配资源能够满足这个 Pod 的 request 时，这个 Pod 就无法实现漂移，也就不能自愈，加重对业务的影响。

相反，建议尽量减小 request 与 limit，通过增加副本的方式来对你的服务支撑能力进行水平扩容，让你的系统更加灵活可靠。

若生产集群有用于测试的 namespace，如果不加以限制，可能导致集群负载过高，从而影响生产业务。可以使用 ResourceQuota 来限制测试 namespace 的 request 与 limit 的总大小。 示例:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: quota-test
  namespace: test
spec:
  hard:
    requests.cpu: "1"
    requests.memory: 1Gi
    limits.cpu: "2"
    limits.memory: 2Gi
```

# pod cpu绑核和绑定numa亲和性

```bash
# 驱逐节点
kubectl drain <NODE_NAME>
# 停止 kubelet
systemctl stop kubelet
# 修改 kubelet 参数
# 若仅需要pod cpu绑核，只要配置下面一个参数
--cpu-manager-policy=static
# 若绑定numa亲和性，要配置下面两个参数
--cpu-manager-policy=static
--topology-manager-policy=single-numa-node
# 删除旧的 CPU 管理器状态文件
rm var/lib/kubelet/cpu_manager_state
# 启动 kubelet
systemctl start kubelet
```

创建pod的时候，cpu request和limit严格一致。

验证可以通过在pod内创建一个进程，让pod所有的cpu都100%使用。然后登录pod所在node，用cpustats查看，cpu负荷100%的cpu都分布在同一个numa上。

若继续创建pod，即使cpu资源足够，若numa资源不够（就是没有任何一个numa可以满足pod的cpu数量的需求），pod也是无法启动的，状态会变为TopologyAffinityError。


# 高并发场景，扩大源端口范围

高并发场景，对于 client 来说会使用大量源端口，源端口范围从 net.ipv4.ip_local_port_range 这个内核参数中定义的区间随机选取，在高并发环境下，端口范围小容易导致源端口耗尽，使得部分连接异常。通常 Pod 源端口范围默认是 32768-60999，建议将其扩大，调整为 1024-65535: sysctl -w net.ipv4.ip_local_port_range="1024 65535"。

**两种说法：**
* 大部分文章都说这个值决定了客户端的一个 ip 可用的端口数量，即一个 ip 最多只能创建 60K 多一点的连接（1025-65535），如果要突破这个限制需要客户端机器绑定多个 ip。
* 还有部分文章说的是这个值决定的是 socket 四元组中的本地端口数量，即一个 ip 对同一个目标 ip+port 最多可以创建 60K 多一点连接，只要目标 ip 或端口不一样就可以使用相同的本地端口，不一定需要多个客户端 ip 就可以突破端口数量限制。

**验证实验：**

先设置 ip_local_port_range 的值为非常小的范围:

```bash
$ echo "61000 61001" | sudo tee /proc/sys/net/ipv4/ip_local_port_range
61000 61001

$ cat /proc/sys/net/ipv4/ip_local_port_range
61000       61001
```

**实验1：相同目标 ip 和相同目标端口下的端口数量限制**

```bash
$ nohup nc 123.125.114.144 80 -v &
[1] 16196
$ nohup: ignoring input and appending output to 'nohup.out'

$ nohup nc 123.125.114.144 80 -v &
[2] 16197
$ nohup: ignoring input and appending output to 'nohup.out'

$ ss -ant |grep 10.0.2.15:61
ESTAB   0        0                10.0.2.15:61001       123.125.114.144:80
ESTAB   0        0                10.0.2.15:61000       123.125.114.144:80

# 然后再创建第三个连接，此时预期应该会失败，因为超出的端口数量现在:

$ nc 123.125.114.144 80 -v
nc: connect to 123.125.114.144 port 80 (tcp) failed: Cannot assign requested address
```

**实验2：相同目标 ip 不同目标端口**

```bash
$ nohup nc 123.125.114.144 443 -v &
[3] 16215
$ nohup: ignoring input and appending output to 'nohup.out'

$ nohup nc 123.125.114.144 443 -v &
[4] 16216
$ nohup: ignoring input and appending output to 'nohup.out'

$ ss -ant |grep 10.0.2.15:61
ESTAB   0        0                10.0.2.15:61001       123.125.114.144:443
ESTAB   0        0                10.0.2.15:61001       123.125.114.144:80
ESTAB   0        0                10.0.2.15:61000       123.125.114.144:443
ESTAB   0        0                10.0.2.15:61000       123.125.114.144:80

# 可以看到相同目标 ip 不同目标端口下，每个目标端口都有一个独立的端口限制，即，相同源 ip 的源端口是可以相同的。

# 按照推测这两个目标端口应该只能创建四个连接，下面试试看:

$ nc 123.125.114.144 443 -v
nc: connect to 123.125.114.144 port 443 (tcp) failed: Cannot assign requested address
```

**实验3：多个目标 ip 相同目标端口**

```bash
$ nohup nc 220.181.57.216 80 -v &
[5] 16222
$ nohup: ignoring input and appending output to 'nohup.out'

$ nohup nc 220.181.57.216 80 -v &
[6] 16223
$ nohup: ignoring input and appending output to 'nohup.out'

$ nc 220.181.57.216 80 -v
nc: connect to 220.181.57.216 port 80 (tcp) failed: Cannot assign requested address

$ ss -ant |grep :80
SYN-SENT  0        1               10.0.2.15:61001       220.181.57.216:80
SYN-SENT  0        1               10.0.2.15:61000       220.181.57.216:80
SYN-SENT  0        1               10.0.2.15:61001      123.125.114.144:80
SYN-SENT  0        1               10.0.2.15:61000      123.125.114.144:80
```

**实验4：多个目标 ip 不同目标端口**

```bash
# 按照前面的经验两个 ip 加两个端口应该只能创建 8 个连接
$ nohup nc 123.125.114.144 80 -v &

$ nohup nc 123.125.114.144 80 -v &

$ nc 123.125.114.144 80 -v
nc: connect to 123.125.114.144 port 80 (tcp) failed: Cannot assign requested address

$ nohup nc 123.125.114.144 443 -v &

$ nohup nc 123.125.114.144 443 -v &

$ nc 123.125.114.144 443 -v
nc: connect to 123.125.114.144 port 443 (tcp) failed: Cannot assign requested address

$ nohup nc 220.181.57.216 80 -v &

$ nohup nc 220.181.57.216 80 -v &

$ nc 220.181.57.216 80 -v
nc: connect to 220.181.57.216 port 80 (tcp) failed: Cannot assign requested address

$ nohup nc 220.181.57.216 443 -v &

$ nohup nc 220.181.57.216 443 -v &

$ nc 220.181.57.216 443 -v
nc: connect to 220.181.57.216 port 443 (tcp) failed: Cannot assign requested address

$ ss -ant |grep 10.0.2.15:61
SYN-SENT  0        1               10.0.2.15:61001       220.181.57.216:80
ESTAB     0        0               10.0.2.15:61001      123.125.114.144:443
ESTAB     0        0               10.0.2.15:61000       220.181.57.216:443
SYN-SENT  0        1               10.0.2.15:61000       220.181.57.216:80
SYN-SENT  0        1               10.0.2.15:61001      123.125.114.144:80
ESTAB     0        0               10.0.2.15:61000      123.125.114.144:443
SYN-SENT  0        1               10.0.2.15:61000      123.125.114.144:80
ESTAB     0        0               10.0.2.15:61001       220.181.57.216:443
# 可以看到确实如预期的只能创建8个连接。
```

**总结**

那么是否就可以说前言中的第一种说法就是错的呢，查了一下资料其实也不能说第一种说法是错误的：
* 当系统的内核版本小于 3.2 时，第一种说法是正确的
* 当系统的内核版本大于等于 3.2 时，第二种说法是正确的

前面的实验都是在 内核版本大于3.2 的环境下操作的，所以印证的是第二种说法。

# Pod亲和反亲和，Pod 拓扑分布约束

将 Pod 打散调度到不同地方，可避免因软硬件故障、光纤故障、断电或自然灾害等因素导致服务不可用，以实现服务的高可用部署。

Kubernetes 支持两种方式将 Pod 打散调度:
* Pod 反亲和 (Pod Anti-Affinity)
* Pod 拓扑分布约束 (Pod Topology Spread Constraints)

topologySpreadConstraints 比 podAntiAffinity 功能更强，提供了提供更精细的调度控制，我们可以理解成 topologySpreadConstraints 是 podAntiAffinity 的升级版。

**将 Pod 强制打散调度到不同节点上(强反亲和)，以避免单点故障**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - topologyKey: kubernetes.io/hostname
            labelSelector:
              matchLabels:
                app: nginx
      containers:
      - name: nginx
        image: nginx
```

* `labelSelector.matchLabels` 替换成选中 Pod 实际使用的 label。
* `topologyKey`: 节点的某个 label 的 key，能代表节点所处拓扑域，可以用 [Well-Known Labels](https://kubernetes.io/docs/reference/labels-annotations-taints/#failure-domainbetakubernetesioregion)，常用的是 `kubernetes.io/hostname` (节点维度)、`topology.kubernetes.io/zone` (可用区/机房 维度)。也可以自行手动为节点打上自定义的 label 来定义拓扑域，比如 `rack` (机架维度)、`machine` (物理机维度)、`switch` (交换机维度)。
* 若不希望用强制，可以使用弱反亲和，让 Pod 尽量调度到不同节点:
  ```yaml
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - podAffinityTerm:
        topologyKey: kubernetes.io/hostname
      weight: 100
  ```

**将 Pod 强制打散调度到不同可用区(机房)，以实现跨机房容灾**

将 `kubernetes.io/hostname` 换成 `topology.kubernetes.io/zone`，其余同上。


**将 Pod 最大程度上均匀的打散调度到各个节点上**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      topologySpreadConstraints:
      - maxSkew: 1
        topologyKey: kubernetes.io/hostname
        whenUnsatisfiable: DoNotSchedule
        labelSelector:
        - matchLabels:
            app: nginx
      containers:
      - name: nginx
        image: nginx
```

* `topologyKey`: 与 podAntiAffinity 中配置类似。
* `labelSelector`: 与 podAntiAffinity 中配置类似，只是这里可以支持选中多组 pod 的 label。
* `maxSkew`: 必须是大于零的整数，表示能容忍不同拓扑域中 Pod 数量差异的最大值。这里的 1 意味着只允许相差 1 个 Pod。
* `whenUnsatisfiable`: 指示不满足条件时如何处理。`DoNotSchedule` 不调度 (保持 Pending)，类似强反亲和；`ScheduleAnyway` 表示要调度，类似弱反亲和；

以上配置连起来解释: 将所有 nginx 的 Pod 严格均匀打散调度到不同节点上，不同节点上 nginx 的副本数量最多只能相差 1 个，如果有节点因其它因素无法调度更多的 Pod (比如资源不足)，那么就让剩余的 nginx 副本 Pending。

**将 Pod 尽量均匀的打散调度到各个节点上，不强制** (DoNotSchedule 改为 ScheduleAnyway):

```yaml
    spec:
      topologySpreadConstraints:
      - maxSkew: 1
        topologyKey: kubernetes.io/hostname
        whenUnsatisfiable: ScheduleAnyway
        labelSelector:
        - matchLabels:
            app: nginx
```

如果集群节点支持跨可用区，也可以 **将 Pod 尽量均匀的打散调度到各个可用区** 以实现更高级别的高可用 (topologyKey 改为 `topology.kubernetes.io/zone`):

```yaml
    spec:
      topologySpreadConstraints:
      - maxSkew: 1
        topologyKey: topology.kubernetes.io/zone
        whenUnsatisfiable: ScheduleAnyway
        labelSelector:
        - matchLabels:
            app: nginx
```

更进一步地，可以 **将 Pod 尽量均匀的打散调度到各个可用区的同时，在可用区内部各节点也尽量打散**:

```yaml
    spec:
      topologySpreadConstraints:
      - maxSkew: 1
        topologyKey: topology.kubernetes.io/zone
        whenUnsatisfiable: ScheduleAnyway
        labelSelector:
        - matchLabels:
            app: nginx
      - maxSkew: 1
        topologyKey: kubernetes.io/hostname
        whenUnsatisfiable: ScheduleAnyway
        labelSelector:
        - matchLabels:
            app: nginx
```

*参考资料：*
* https://github.com/imroc/kubernetes-guide
* https://mozillazg.com/2019/05/linux-what-net.ipv4.ip_local_port_range-effect-or-mean.html
