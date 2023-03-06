---
title: Serverless的演进历程
readmore: true
date: 2023-03-06 19:06:51
categories: 云原生
tags:
- Serverless

---

# 物理机走向虚拟机

我们不能忽视了 IaaS 先辈们在前面的披荆斩棘：从提供物理机到提供虚拟机或者其他基础资源作为服务提供给用户。

经过十几年的发展，IaaS 已经比较成熟，各种基础资源，如 ECS、VPC、EBS 等已经深入人心。

# 容器化

早在 2008 年，Google 就推出了 App Engine 服务，想打造一个开发平台，让开发者只需要编写业务代码就可以在 App Engine 上面运行。这个思想过于超前，开发者还不能完全接受。直到 2013 年 Docker 的诞生，Docker 镜像将应该依赖的环境和应用打包成一个压缩文件，这个文件可以在任何安装了 Docker 的机器上面直接运行，解决了应用从开发、测试到生产各个环节部署问题，并且能够保障环境的一致性。Docker 真正实现了“Build once, Run anywhere”。

# Kubernetes

最初的 Docker 是单机版本，面对大规模部署的场景时需要一套管理平台，就像 OpenStack 管理 VM 一样。

Kubernetes 淘汰了Mesos、Swarm 等，在容器管理平台上实现了一统江湖。

云原生的生态开始围绕 Kubernetes 蓬勃发展。

# 公有云托管 Kubernetes

虽然 Kubernetes 实现了一统江湖，Kubernetes 的运维却并非那么容易。在这种背景下，公有云尝试纷纷推出了云上 Kubernetes 托管服务。就是将 Kubernetes 管理组件的安装和运维托管给公有云，使用 弹性虚拟机 或者裸金属作为 Kubernetes 的计算节点，极大地减少了 Kubernetes 用户的使用成本。用户从云平台获取一个 kubeconfig 文件便可以直接通过 kubectl 命令行或者 Restful API 管理集群。

如果需要扩容集群容量，只需要调整 ECS 个数，新创建的 ECS 会自动注册到 Kubernetes Master。不仅如此，ACK 还支持一键升级集群版本和各种插件。ACK 将繁杂的运维工作转移到云上，并且借助云的弹性能力，可以做到分钟级别的资源扩展。

# Serverless - 将免运维和弹性容器服务进行到底

如果集群里面运行任务大部分都是长期运行并且资源需求是固定的任务，使用 上面的方案 没有问题，但如果是大量 job 类型的任务或者存在突发流量的情况，这种临时扩容虚拟机后，在虚拟机上启用容器方案在弹性方面有所欠缺。

Serverless可以实现超级弹性，实现按量计费，极大减少云产品的经济支出。无感知运维节点，让devops范式去掉ops，专注dev，专注业务的开发。

Serverless中的核心是工作节点的无服务器化，主流的业界方案是采用virtual kubelet。对于全是突发业务，弹性业务的应用可以采取全Serverless的方案，对于部分固定任务，部分弹性任务，可以采用上一个方案和Serverless混合的方案。

当然Serverless不仅仅包含工作节点的无服务器化，因为是高度弹性的业务，会高频反复起停pod，所以还有高性能网络的实现，启动镜像的精简，镜像的快照实现快速启动，事件通知扩缩容，网络预加载等等技术来锦上添花。