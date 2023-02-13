---
title: ChatGPT云原生开发实践 试用ChatGPT做Kubernetes Scheduler开发
readmore: false
date: 2023-02-13 12:15:05
categories: 云原生
tags:
---

在云原生领域选了个特定的领域开发：kubernetes调度器的开发，开发scheduler。

做了四个ChatGPT对云原生开发的demo，前两个是扔给ChatGPT 具体的scheduler的代码，让分析下代码。第三个是让ChatGPT写一段扩展scheduler代码。第四个是让ChatGPT写一个在生产环境中常提的一个扩展scheduler需求。

# demo1

用bash写了个最简的scheduler，pod启动前将该scheduler配置到yaml文件中，就可以避开调用kubernetes的默认或配置的scheduler，转而调用demo中写的scheduler。扔给ChatGPT分析，ChatGPT看看是否能读懂。

![](/images/chatgpt-scheduler/2023-02-13-11-29-04.png)

完全正确。

# demo2

这个demo，是调用的kubernetes官方的scheduler扩展接口写的一个调度器。 https://github.com/kubernetes-sigs/scheduler-plugins

整个项目扔给ChatGPT分析，ChatGPT看看是否能读懂。

![](/images/chatgpt-scheduler/2023-02-13-11-59-44.png)

完全正确。

# demo3

让ChatGPT写个kubernetes调度器。

![](/images/chatgpt-scheduler/2023-02-13-12-03-49.png)

![](/images/chatgpt-scheduler/2023-02-13-12-04-16.png)

# demo4

让ChatGPT写个kubernetes调度器。实现在生产环境中常提的一个扩展scheduler需求：根据节点的真实负载调度pod，而不是根据默认的pod request和node capacity（过滤和计算权重后）调度pod。

![](/images/chatgpt-scheduler/2023-02-13-12-20-45.png)

![](/images/chatgpt-scheduler/2023-02-13-12-21-10.png)

写了一半写不下去了，重新问，这次干脆用。。。省略了实现

![](/images/chatgpt-scheduler/2023-02-13-12-22-14.png)


demo1~3，作为生成开发kubernetes scheduler样例，ChatGPT处理得游刃有余。但处理有一定特殊需求的，就不太靠谱了。ChatGPT公开测试版本只机器学习到2021年的知识，并且还在迭代中，相信不久的未来处理demo4这种小需求的开发应该不成任何问题。