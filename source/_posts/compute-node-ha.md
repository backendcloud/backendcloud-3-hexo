title: compute node ha 主流开源实现
date: 2017-06-22 09:16:48
categories:
tags:
- HA
- masakari
---

# nova evacuate

各种实现方案基本无例外要调用nova的evacuate接口。

nova evacuate和热迁移很像。都是想实例从一个节点转移到另外一个节点。区别主要是热迁移在正常状态下进行的，疏散时在异常状态下进行的。用一个形象的比如就是热迁移发生在地震前从建筑物逃生出来，疏散发生在地震发生后，从被毁的建筑物里逃生出来。

但严格说来上面的比喻还不够严谨，准确说并不是从被毁的建筑物里逃生出来，而是被复活出来。

所以nova evacuate翻译成复活要比疏散更准确。


# masakari

日本电信NTT的开源项目masakari已经成为了Openstack的一个独立项目，该项目就是是专门做compute node ha的。

masakari的日文是まさかり，斧头的意思。准确说是板斧。就是周星驰电影斧头帮用的板斧。不知道，项目的发起人，几个日本人是否受此影响。

取名masakari就是发现故障位置，使用斧头帮最高绝技，一斧头精准扔过去，隔离斩断故障。

## detect 3 type of vm down

* unexpected vm down (monitoring libvirt's events)
* vm manager down (monitoring manager process)
* host down (using pacemaker)

## masakari 正在努力推进的新特性

1）现在只支持疏散active, stopped, error状态的vm
   以后可以加上去疏散更多状态的vm，如shelved, rescued, paused and suspended

2）现在监测到故障后的流程都是固定死的，要改变只能改变代码。
   以后可以通过编写yaml文件让用户自定义流程。



# compute node ha 其他用到的技术

* consul
* raft
* gossip



# compute node ha其他的相关开源项目

* Openstack Congress （策略即服务）
* pacemaker-remote （host monitor方案）
* mistral-evacuate （工作流程）


# 附录1：Gossip协议

在所有的Consul Agent之间（包括服务器模式和普通模式）运行着Gossip协议。服务器节点和普通Agent都会加入这个Gossip集群，收发Gossip消息。每隔一段时间，每个节点都会随机选择几个节点发送Gossip消息，其他节点会再次随机选择其他几个节点接力发送消息。这样一段时间过后，整个集群都能收到这条消息。

乍看上去觉得这种发送方式的效率很低，但在数学上已有论文论证过其可行性，并且Gossip协议已经是P2P网络中比较成熟的协议了。大家可以查看 Gossip的介绍 ，里面有一个模拟器，可以告诉你消息在集群里传播需要的时间和带宽。Gossip协议的最大的好处是，即使集群节点的数量增加，每个节点的负载也不会增加很多，几乎是恒定的。这就允许Consul管理的集群规模能横向扩展到数千个节点。



# 附录2：路径算法

为evacuate寻求最优路径。

不仅适用于compute node HA，还可以负载优化均衡

尝试设计迁移路径算法以优化vm所在节点的性能以实现硬件投资回报最大化。
