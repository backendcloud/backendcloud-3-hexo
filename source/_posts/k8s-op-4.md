---
title: Kubernetes 运维遇到的问题记录（4）
readmore: true
date: 2023-01-10 13:01:06
categories: 云原生
tags:
- 运维
---

> 本篇的内容都基于 https://github.com/imroc/kubernetes-guide 整理

# 偶现 DNS 解析失败

Kubernetes 集群网络有很多种实现，有很大一部分都用到了 Linux 网桥：每个 Pod 的网卡都是 veth 设备，veth pair 的另一端连上宿主机上的网桥。由于网桥是虚拟的二层设备，同节点的 Pod 之间通信直接走二层转发，跨节点通信才会经过宿主机 eth0。

不管是 iptables 还是 ipvs 转发模式，Kubernetes 中访问 Service 都会进行 DNAT，将原本访问 ClusterIP:Port 的数据包 DNAT 成 Service 的某个 Endpoint (PodIP:Port)，然后内核将连接信息插入 conntrack 表以记录连接，目的端回包的时候内核从 conntrack 表匹配连接并反向 NAT，这样原路返回形成一个完整的连接链路。

但是 Linux 网桥是一个虚拟的二层转发设备，而 iptables conntrack 是在三层上，所以如果直接访问同一网桥内的地址，就会直接走二层转发，不经过 conntrack:
1. Pod 访问 Service，目的 IP 是 Cluster IP，不是网桥内的地址，走三层转发，会被 DNAT 成 PodIP:Port。
2. 如果 DNAT 后是转发到了同节点上的 Pod，目的 Pod 回包时发现目的 IP 在同一网桥上，就直接走二层转发了，没有调用 conntrack，导致回包时没有原路返回。

由于没有原路返回，客户端与服务端的通信就不在一个 "频道" 上，不认为处在同一个连接，也就无法正常通信。

常见的问题现象就是偶现 DNS 解析失败，当 coredns 所在节点上的 pod 解析 dns 时，dns 请求落到当前节点的 coredns pod 上时，就可能发生这个问题。

bridge-nf-call-iptables 这个内核参数 (置为 1)，表示 bridge 设备在二层转发时也去调用 iptables 配置的三层规则 (包含 conntrack)，所以开启这个参数就能够解决上述 Service 同节点通信问题，这也是为什么在 Kubernetes 环境中，大多都要求开启 bridge-nf-call-iptables 的原因。

```bash
sysctl -w net.bridge.bridge-nf-call-iptables=1
```

# 离线部署

国内网络环境导致国外的镜像下载不下来，或者部署环境不能连外网。这时候就需要离线部署。对于容器镜像这一部分，可以将需要的公共镜像仓库里的镜像同步到私有镜像仓库。

skepeo 是一个开源的容器镜像搬运工具，比较通用，各种镜像仓库都支持。

整理镜像列表。比如：

```bash
$ helm template -n monitoring -f kube-prometheus-stack.yaml ./kube-prometheus-stack | grep "image:" | awk -F 'image:' '{print $2}' | awk '{$1=$1;print}' | sed -e 's/^"//' -e 's/"$//' > images.txt
$ cat images.txt
quay.io/prometheus/node-exporter:v1.3.1
quay.io/kiwigrid/k8s-sidecar:1.19.2
quay.io/kiwigrid/k8s-sidecar:1.19.2
grafana/grafana:9.0.2
registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.5.0
quay.io/prometheus-operator/prometheus-operator:v0.57.0
quay.io/prometheus/alertmanager:v0.24.0
quay.io/prometheus/prometheus:v2.36.1
bats/bats:v1.4.1
k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
```

准备同步镜像脚本：

```bash
#! /bin/bash

DST_IMAGE_REPO="127.0.0.1:5000/prometheus"

cat images.txt | while read line
do
        # 若同步失败一直尝试直到成功，这里可以优化下，配置下最大尝试次数
        while :
        do
                skopeo sync --src=docker --dest=docker $line $DST_IMAGE_REPO
                if [ "$?" == "0" ]; then
                        break
                fi
        done
done
```

执行上面的同步镜像脚本前，若镜像仓库需要认证，首先要登录。不管是源和目的。

登录方法很简单，跟 docker login 一样，指定要登录的镜像仓库地址:

```bash
skopeo login registry
```

然后输入用户名密码即可。

# 优雅中止

pod中止的流程：
1. Pod 被删除，状态变为 Terminating。pod的yaml信息中的 Pod metadata 中的 deletionTimestamp 字段会被标记上删除时间。

2. kube-proxy watch 到了删除时间被标记就开始更新iptables或者ipvs的转发规则，将 Pod 从 service 的 endpoint 列表中摘除掉，新的流量不再转发到该 Pod。

3. kubelet watch 到了删除时间被标记就开始kubelet的 销毁 Pod 流程。

3.1. 如果 Pod 中有 container 配置了 preStop Hook ，将会执行。

3.2. 发送 SIGTERM 信号给容器内主进程以通知容器进程开始优雅停止。

3.3. 等待 container 中的主进程完全停止，如果在 terminationGracePeriodSeconds 内 (默认 30s) 还未完全停止，就发送 SIGKILL 信号将其强制杀死。

3.4. 所有容器进程终止，清理 Pod 资源。

3.5. 通知 APIServer Pod 销毁完成，完成 Pod 删除。

Kubernetes只负责将SIGTERM 信号给容器内主进程。若业务进程不是主进程，则无法获得该信号，从而无法优雅中止。若业务进程虽然是主进程，但是业务代码没有接收SIGTERM 信号的处理逻辑，同样无法优雅中止。这时候可以利用 preStop Hook，等待一段时间或做些中止前的清理工作，通过配置层面的优雅中止代替业务代码层面的优雅中止。比如：

```yaml
        lifecycle:
          preStop:
            exec:
              command:
              - /clean.sh
```

```yaml
        lifecycle:
          preStop:
            exec:
              command:
              - sleep
              - 5s
```

业务代码处理 SIGTERM 信号，就是获取该信号，执行排水的业务逻辑。kube-proxy已经不再将新的流量转发到该Pod了，只要处理完存量的，用排水形象比喻。

下面是几种语言获取 SIGTERM 信号的代码样例。

**shell**

```bash
#!/bin/sh

## Redirecting Filehanders
ln -sf /proc/$$/fd/1 /log/stdout.log
ln -sf /proc/$$/fd/2 /log/stderr.log

## Pre execution handler
pre_execution_handler() {
  ## Pre Execution
  # TODO: put your pre execution steps here
  : # delete this nop
}

## Post execution handler
post_execution_handler() {
  ## Post Execution
  # TODO: put your post execution steps here
  : # delete this nop
}

## Sigterm Handler
sigterm_handler() { 
  if [ $pid -ne 0 ]; then
    # the above if statement is important because it ensures 
    # that the application has already started. without it you
    # could attempt cleanup steps if the application failed to
    # start, causing errors.
    kill -15 "$pid"
    wait "$pid"
    post_execution_handler
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

## Setup signal trap
# on callback execute the specified handler
trap 'sigterm_handler' SIGTERM

## Initialization
pre_execution_handler

## Start Process
# run process in background and record PID
>/log/stdout.log 2>/log/stderr.log "$@" &
pid="$!"
# Application can log to stdout/stderr, /log/stdout.log or /log/stderr.log

## Wait forever until app dies
wait "$pid"
return_code="$?"

## Cleanup
post_execution_handler
# echo the return code of the application
exit $return_code
```

**go**

```go
package main

import (
    "fmt"
    "os"
    "os/signal"
    "syscall"
)

func main() {

    sigs := make(chan os.Signal, 1)
    done := make(chan bool, 1)
    //registers the channel
    signal.Notify(sigs, syscall.SIGTERM)

    go func() {
        sig := <-sigs
        fmt.Println("Caught SIGTERM, shutting down")
        // Finish any outstanding requests, then...
        done <- true
    }()

    fmt.Println("Starting application")
    // Main logic goes here
    <-done
    fmt.Println("exiting")
}
```

**python**

```python
import signal, time, os

def shutdown(signum, frame):
    print('Caught SIGTERM, shutting down')
    # Finish any outstanding requests, then...
    exit(0)

if __name__ == '__main__':
    # Register handler
    signal.signal(signal.SIGTERM, shutdown)
    # Main logic goes here
```

**nodejs**

```js
process.on('SIGTERM', () => {
  console.log('The service is about to shut down!');
  
  // Finish any outstanding requests, then...
  process.exit(0); 
});
```

**java**

```java
import sun.misc.Signal;
import sun.misc.SignalHandler;
 
public class ExampleSignalHandler {
    public static void main(String... args) throws InterruptedException {
        final long start = System.nanoTime();
        Signal.handle(new Signal("TERM"), new SignalHandler() {
            public void handle(Signal sig) {
                System.out.format("\nProgram execution took %f seconds\n", (System.nanoTime() - start) / 1e9f);
                System.exit(0);
            }
        });
        int counter = 0;
        while(true) {
            System.out.println(counter++);
            Thread.sleep(500);
        }
    }
}
```

前面说的没有优雅中止的原因之一业务逻辑不是主进程，往往是因为采用了 /bin/sh -c my-app 这样的启动入口。 或者使用 /entrypoint.sh 这样的脚本文件作为入口，在脚本中再启动业务进程。容器主进程是 shell，业务进程是在 shell 中启动的，成为了 shell 进程的子进程。不做特别配置 shell是不会往自己的子进程传递 SIGTERM 信号的，从而导致业务进程不会触发停止逻辑。这时候只能等到 K8S 优雅停止超时时间 (terminationGracePeriodSeconds，默认 30s)，发送 SIGKILL 强制杀死 shell 及其子进程。

**如何解决业务进程获取不到信号的问题**

1. 尽量不使用 shell 启动业务进程，直接启动业务进程
2. 如果一定要通过 shell 启动，需要一定的配置在 SHELL 中传递信号。


SHELL 中传递信号。具体有以下三种途径。
1. 使用 exec 启动

在 shell 中启动二进制的命令前加一个 exec 即可让该二进制启动的进程代替当前 shell 进程，即让新启动的进程成为主进程:

```bash
#! /bin/bash
...

exec /bin/yourapp # 脚本中执行二进制
```

2. 多进程场景: 使用 trap 传递信号

单个容器中需要启动多个业务进程，这时也只能通过 shell 启动，但无法使用上面的 exec 方式来传递信号，因为 exec 只能让一个进程替代当前 shell 成为主进程。

这个时候我们可以在 shell 中使用 trap 来捕获信号，当收到信号后触发回调函数来将信号通过 kill 传递给业务进程，脚本示例:

```bash
#! /bin/bash

/bin/app1 & pid1="$!" # 启动第一个业务进程并记录 pid
echo "app1 started with pid $pid1"

/bin/app2 & pid2="$!" # 启动第二个业务进程并记录 pid
echo "app2 started with pid $pid2"

handle_sigterm() {
  echo "[INFO] Received SIGTERM"
  kill -SIGTERM $pid1 $pid2 # 传递 SIGTERM 给业务进程
  wait $pid1 $pid2 # 等待所有业务进程完全终止
}
trap handle_sigterm SIGTERM # 捕获 SIGTERM 信号并回调 handle_sigterm 函数

wait # 等待回调执行完，主进程再退出
```

3. 完美方案: 使用 init 系统

前面一种方案实际是用脚本实现了一个极简的 init 系统 (或 supervisor) 来管理所有子进程，只不过它的逻辑很简陋，仅仅简单的透传指定信号给子进程，其实社区有更完善的方案，dumb-init 和 tini 都可以作为 init 进程，作为主进程 (PID 1) 在容器中启动，然后它再运行 shell 来执行我们指定的脚本 (shell 作为子进程)，shell 中启动的业务进程也成为它的子进程，当它收到信号时会将其传递给所有的子进程，从而也能完美解决 SHELL 无法传递信号问题，并且还有回收僵尸进程的能力。

这是以 dumb-init 为例制作镜像的 Dockerfile 示例:

```bash
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y dumb-init
ADD start.sh /
ADD app1 /bin/app1
ADD app2 /bin/app2
ENTRYPOINT ["dumb-init", "--"]
CMD ["/start.sh"]
```

这是以 tini 为例制作镜像的 Dockerfile 示例:

```bash
FROM ubuntu:22.04
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /tini /entrypoint.sh
ENTRYPOINT ["/tini", "--"]
CMD [ "/start.sh" ]
```

start.sh 脚本示例:

```bash
#! /bin/bash
/bin/app1 &
/bin/app2 &
wait
```

> 上面的操作都是因为没有遵循微服务的单个pod只运行单一业务进程原则所作的补救操作。

上面的所有方案都是针对已经关掉放水的阀门对排水作的优化。但实际上还有一种情况需要对k8s的service层面优化，就是到Pod 上的存量连接的存量请求还没处理完，直接将endpoint去掉（解绑）的话就可能造成请求异常。这时候期望的是，等待存量请求处理完，才真正解绑旧 Pod。

现在主流云厂商不仅支持kube-proxy转发到pod，也都支持了 LB 直通 Pod，即 LB 直接将流量转发给 Pod，不需要再经过集群内做一次转发。

腾讯云 TKE 官方针对四层 Service 和七层 Ingress 都提供了解决方案。

如果是四层 Service，在 Service 上加上这样的注解即可(前提是 Service 用了 CLB 直通 Pod 模式):

service.cloud.tencent.com/enable-grace-shutdown: "true"

> 参考官方文档 [Service 优雅停机](https://cloud.tencent.com/document/product/457/60064)

如果是七层 CLB 类型 Ingress，在 Ingress 上加上这样的注解即可(前提是 Service 用了 CLB 直通 Pod 模式):

ingress.cloud.tencent.com/enable-grace-shutdown: "true"

> 参考官方文档 [Ingress 优雅停机](https://cloud.tencent.com/document/product/457/60065)

阿里云 ACK 目前只针对四层 Service 提供了解决方案，通过注解开启优雅中断与设置中断超时时间:

service.beta.kubernetes.io/alibaba-cloud-loadbalancer-connection-drain: "on"
service.beta.kubernetes.io/alibaba-cloud-loadbalancer-connection-drain-timeout: "900"

> 参考官方文档 [通过Annotation配置负载均衡](https://help.aliyun.com/document_detail/86531.html)