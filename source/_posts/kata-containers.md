title: Kata Containers
date: 2017-12-08 00:27:10
categories:
- NFV
tags:
- Kata Containers
- Intel Clear Container
- Serverless

---

# 奥斯汀时间2017年12月5日 开源容器项目Kata Containers 发布

美国德克萨斯州，奥斯汀时间2017年12月5日——KubeCon/CloudNativeCon 2017北美峰会上，OpenStack基金会发布了最新开源容器项目Kata Containers，旨在将虚拟机（VM）的安全优势与容器的速度和可管理性统一起来。

Kata Containers设计为硬件无关，与Open Container Initiative（OCI）标准、Kubernetes容器运行时接口（CRI）兼容，Kata Containers提供直接在裸机上运行容器管理工具并实现工作负载强安全隔离的能力。与当前标准的在虚拟基础设施上运行容器的方式相比，其性能更高，启动速度更快，更具成本效益。
<!-- more -->
# Kata容器，英特尔Clear Containers的下一个演变

当英特尔在2015年推出Clear Container项目时，目标是通过英特尔®虚拟化技术（VT）解决容器内部的安全问题。使用英特尔®虚拟化技术，能够将容器作为轻量级虚拟机（VM）启动，提供了一个可选的运行时间，可与Kubernetes 和Docker 等常用容器环境互操作。

英特尔®Clear Container表明，安全性和性能不必是一个折衷，将硬件隔离的安全性与容器的性能可以兼得。从那以后，其他公司也采用了类似的方法来处理容器。

奥斯汀时间2017年12月5日，OpenStack基金会宣布了Kata容器。这标志着Clear Containers进化的下一个步骤：创建一个开放的治理结构，将该项目与Hyper和RunV技术所倡导的类似努力相融合。

Kata Containers作为OpenStack基金会的一个开放源代码项目，作为其最近扩展的包含OpenStack核心项目的章程的一部分。这个项目肯定会促进标准化和创新，从而推动容器技术的快速发展。已经有将近20家公司同意在Kata Containers上共同合作。

Kata容器也将在多个基础架构和容器编排和规范社区中集成和兼容：Kubernetes，Docker，Open Container Initiative（OCI），Container Runtime Interface（CRI），容器网络接口（CNI），QEMU，KVM，HyperV和OpenStack。

# Kata Containers - 容器的速度，虚拟机的安全

![](/images/kata/1.jpg)

Kata Containers是一种轻量级虚拟机的新颖实现无缝集成在容器生态系统中。Kata Containers同容器一样轻而快，并与容器结合管理层，同时也提供了虚拟机的安全优势。

Kata Containers是两个现有的开源项目合并：英特尔Clear Containers和Hyper runV。新项目汇集了最好的这两种技术都具有重构虚拟化，容器原生应用程序的共同愿景，为了提供容器的速度，和虚拟机的安全。

![](/images/kata/2.jpg)

Kata Containers从每个项目的优势中受益。Intel Clear Containers专注于性能（<100ms启动时间）和增强安全性，而hyper runV优先于技术无关支持许多不同的CPU架构和管理程序。通过合并这些项目，Clear Containers提供了卓越的最终用户体验性能和兼容性，统一开发者社区，并加速功能开发以解决未来的使用案例。

行业转向容器在安全方面提出了独特的挑战，用户工作负载在多租户不受信任的环境中。Kata Containers使用开源虚拟机管理程序作为每个容器的隔离边界（或一个容器中的容器的集合）;这种方法解决了与现有的裸机容器解决方案共同的内核困境。

Kata Containers是非常适合按需，基于事件的部署，如无服务器功能，连续整合/持续交付，以及更长时间运行的Web服务器应用。开发者不再需要知道任何事情下面的基础或执行任何类型的容量规划之前启动他们的容器工作量。Kata Containers交付增强安全性，可扩展性和更高的资源利用率，同时导致整体简化的堆栈。

# Kata Containers使用案例：

## CAAS

提供简单的Container-as-a-Service功能，最终用户不需要学习或管理一个COE（Kubernetes，Swarm，OpenShift）。

## NFV (Network Functions Virtualization)

提供所需的多租户和安全性基于容器的VNF部署。

## Dev/Test

允许开发人员专注于编码和屏蔽底层的复杂。

## CI/CD (Continuous Integration/Continuous Delivery)

理想的CI / CD，往往是让随机的持续集成和部署的负荷，应用在闲置资源上。

## Serverless

可以用本地无服务器的基础平台。

## 边缘计算

符合独特的安全要求和小规模部署的边缘计算节点

## Cloud Multi-tenanted environments

提供在云中运行容器所需的安全性。

![](/images/kata/3.jpg)
![](/images/kata/4.jpg)
![](/images/kata/5.jpg)
![](/images/kata/6.jpg)
![](/images/kata/7.jpg)
![](/images/kata/8.jpg)
![](/images/kata/p1.jpg)
![](/images/kata/p2.jpg)
![](/images/kata/p3.jpg)
![](/images/kata/p4.jpg)
![](/images/kata/p5.jpg)
![](/images/kata/p6.jpg)
![](/images/kata/p7.jpg)
