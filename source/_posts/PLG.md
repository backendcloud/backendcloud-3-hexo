---
title: PLG 实现 Kubernetes Pod 日志收集和展示
date: 2021-12-01 17:48:46
readmore: true
categories: 云原生
tags:
- Kubernetes
- Pod
- PLG
---

> 阅读本文章前先阅读 https://kubernetes.io/zh/docs/concepts/cluster-administration/logging/

之前写过一篇 {% post_link pod-log-collect 关于 Fluentd设计了一套日志架构用于实现 Kubernetes Pod 日志收集 文章 %}，鉴于EFK已经不是现在的主流日志架构，研究了另外一套更加主流的日志系统 promtail + loki + Grafana 。

# 为何要引入日志系统

Kubernetes Pod本身会产生日志，可以查看到相应的日志，为何要引入日志系统？

一来为了日志可靠性，因为应用突然挂了，这个时候我们就无法查到相关的日志了，所以需要引入日志系统，统一收集日志。

二来规模大了后，获取，集中管理，存储，索引，查询，展示都是问题，需要一个系统解决方案。

# promtail + loki + Grafana 日志架构

![](/images/PLG/8ee9281f.png)
PLG日志系统由以下3个部分组成：
* Promtail是专为Loki定制的客户端，负责收集日志并将其发送Loki。
* Loki是主服务器，负责存储日志和处理查询。
* Grafana用于UI展示（可以自己开发前端页面来替代）。

PLG日志架构转为Kubernetes Pod日志量身定制，是Kubernetes Pod日志唯一不二的选择。相比ELK/EFK的优点很明显。
![](/images/PLG/1.png)
另外由于Kubernetes的告警和监控是基于Prometheus的，使用ELK的话，就需要在Kibana和Grafana之间切换，影响用户体验。所以 ，loki的第一目的就是最小化度量和日志的切换成本，有助于减少异常事件的响应时间和提高用户的体验。

# Loki架构

![](/images/PLG/2.png)

* Promtail开源客户端负责采集并上报日志；
* Distributor：日志写入入口，将数据转发到Ingester；
* Ingester：日志的写入服务，缓存并写入日志内容和索引到底层存储；
* Querier：日志读取服务，执行搜索请求。


## 读写

日志数据的写主要依托的是Distributor和Ingester两个组件，整体的流程如下：

![](/images/PLG/3.png)


## Distributor

一旦promtail收集日志并将其发送给loki，Distributor就是第一个接收日志的组件。由于日志的写入量可能很大，所以不能在它们传入时将它们写入数据库。这会毁掉数据库。我们需要批处理和压缩数据。

Loki通过构建压缩数据块来实现这一点，方法是在日志进入时对其进行gzip操作，组件ingester是一个有状态的组件，负责构建和刷新chunck，当chunk达到一定的数量或者时间后，刷新到存储中去。每个流的日志对应一个ingester，当日志到达Distributor后，根据元数据和hash算法计算出应该到哪个ingester上面。

![](/images/PLG/4.png)

此外，为了冗余和弹性，我们将其复制n（默认情况下为3）次。


## Ingester

Ingester接收到日志并开始构建chunk：

![](/images/PLG/5.png)

基本上就是将日志进行压缩并附加到chunk上面。一旦chunk“填满”（数据达到一定数量或者过了一定期限），ingester将其刷新到数据库。我们对块和索引使用单独的数据库，因为它们存储的数据类型不同。

![](/images/PLG/6.png)

刷新一个chunk之后，ingester然后创建一个新的空chunk并将新条目添加到该chunk中。


## Querier

读取就非常简单了，由Querier负责给定一个时间范围和标签选择器，Querier查看索引以确定哪些块匹配，并通过greps将结果显示出来。它还从Ingester获取尚未刷新的最新数据。

对于每个查询，一个查询器将为您显示所有相关日志。实现了查询并行化，提供分布式grep，使即使是大型查询也是足够的。

![](/images/PLG/7.png)

>可以参考官方文档 [Loki’s Architecture](https://grafana.com/docs/loki/latest/architecture/) 进一步深入了解。最后，一句话形容下Loki就是like Prometheus, but for logs。


# PLG 部署

	#  helm upgrade --install loki --namespace=loki grafana/loki-stack  --set grafana.enabled=true
	Release "loki" does not exist. Installing it now.
	Error: failed to download "grafana/loki-stack”

如果在中国、并且很难从官方 DockerHub 上拉镜像，那么可以使用托管在阿里云上的镜像仓库：

	#  helm upgrade --install loki --namespace=loki grafana/loki-stack  --set grafana.enabled=true --set  manager.image.repository=openkruise-registry.cn-hangzhou.cr.aliyuncs.com/openkruise/kruise-manager
	
	Release "loki" does not exist. Installing it now.
	NAME: loki
	LAST DEPLOYED: Wed Dec  1 15:34:23 2021
	NAMESPACE: loki
	STATUS: deployed
	REVISION: 1
	NOTES:
	The Loki stack has been deployed to your cluster. Loki can now be added as a datasource in Grafana.
	
	See http://docs.grafana.org/features/datasources/loki/ for more detail.


# 查询PLG服务状态
```bash
# kubectl -n loki get all
NAME                                READY   STATUS    RESTARTS   AGE
pod/loki-0                          1/1     Running   0          27m
pod/loki-grafana-688db6c776-s8lxc   1/1     Running   0          27m
pod/loki-promtail-2g6dp             1/1     Running   0          27m
pod/loki-promtail-2th87             1/1     Running   0          27m
pod/loki-promtail-46rbc             1/1     Running   0          27m
pod/loki-promtail-8zljs             1/1     Running   0          27m
pod/loki-promtail-gn8hf             1/1     Running   0          27m
pod/loki-promtail-mc44v             1/1     Running   0          27m

NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/loki            ClusterIP   10.233.5.180    <none>        3100/TCP   27m
service/loki-grafana    ClusterIP   10.233.13.165   <none>        80/TCP     27m
service/loki-headless   ClusterIP   None            <none>        3100/TCP   27m

NAME                           DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/loki-promtail   6         6         6       6            6           <none>          27m

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/loki-grafana   1/1     1            1           27m

NAME                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/loki-grafana-688db6c776   1         1         1       27m

NAME                    READY   AGE
statefulset.apps/loki   1/1     27m
```

可以看到通过Helm部署后自动完成了Promtail + Loki + Grafana组合的安装，其中Promtail部署模式为daemonset，在每个计算节点上都有部署，来收集节点以及Pod上的日志信息

Loki本身默认是通过statefulset的方式部署，这是为了避免在数据摄入组件崩溃时丢失索引，因此官方建议将Loki通过statefulset运行，并使用持久化存储来存储索引文件。

接下来，访问Grafana UI界面来查看部署结果。首先，通过以下命令获取Grafana管理员的密码：

	$ kubectl get secret --namespace loki loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

然后通过以下命令转发Grafana的接口，以便通过Web UI进行访问。默认情况下，端口转发的地址localhost，可以根据kubectl所在实例的情况补充设置–address <IP地址>。

	$ kubectl port-forward --namespace loki service/loki-grafana 3000:80



# 登录展示页面
由于PLG部署在Kubernetes中，Kubernetes的Service是内部ip，做了个端口映射，让外网可以访问Grafana UI。
![](/images/kubernetes-api/2.jpeg)
这里顺便提下，推荐一个巨好用的流程图工具： https://whimsical.com/
把上面手写的图用该工具重做下就是下面的效果。
![](/images/PLG/8.png)
该工具是我用过的最好用的免费工具，所以推荐下。该工具和Notion结合非常好，Notion对其有特别的支持。

	# nohup ssh -N -g -L 33043:10.233.13.165:80 36.133.53.67 -p22 2>&1 &

![](/images/PLG/c6e21f4c.png)
![](/images/PLG/08c87182.png)
![](/images/PLG/12071104.png)
