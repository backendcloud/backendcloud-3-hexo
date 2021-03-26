title: Openstack两组容易混淆的概念
date: 2018-08-16 15:08:05
categories:
- Openstack_op
tags:
- aggregation
- available zone
- numa
---

# 第一组：主机集合aggregation和可用域available zone(az)

## 主机集合aggregation

az是在region范围内的再次切分，只是工程上的独立，例如可以把一个机架上的机器划分在一个az中，划分az是为了提高容灾性和提供廉价的隔离服务。选择不同的region主要考虑哪个region靠近你的用户群体。

在新建虚拟机的时候，用户设置了希望将虚拟机放在az-1中，那么调度器将会选择属于这个az

## 可用域available zone(az)

host aggregate是管理员用来根据硬件资源的某一属性来对硬件进行划分的功能，只对管理员可见。

其主要功能就是实现根据某一属性来划分物理机，比如linux，windows区分；是否SSD高性能存储区分；是否高性能计算GPU区分等等。

## 区别总结

![jpg](/images/2concepts/5.jpg)

az是用户可见的，用户手动的来指定vm运行在哪些host上；Host aggregate是一种更智能的方式，是调度器可见的，影响调度策略的一个表达式。

## 如何将一个host加入az

不能直接通过命令将一个host加入az

<!-- more -->

可能是社区的开发人员意识到，让管理员通过配置的方式管理zone不太合适，不够灵活，所以在G版中将这一方式修改。就改用nova  aggregate-create 命令，在创建一个aggregate的同时，指定一个AZ。

    root@controller:~# nova help aggregate-create  
    usage: nova aggregate-create <name> [<availability-zone>]  
      
    Create a new aggregate with the specified details.  
      
    Positional arguments:  
      <name>               Name of aggregate.  
      <availability-zone>  The availability zone of the aggregate (optional).  

因此创建一个aggregate后，同时把它作为一个zone，此时aggregate=zone。因为大家知道，aggregate是管理员可见，普通用户不可见的对象，那么这个改变，就可以使普通用户能够通过使用zone的方式来使用aggregate。

创建完aggregate之后，向aggregate里加主机时，该主机就自动属于aggregate表示的zone。

## 相互关系

* 一个aggregation可以和一个az建立关联，也可以不和任何az建立关联
* 多个aggregation可以和同一个az建立关联，但反之不行
* 一个host只能加入一个az，不可同时加入多个az，但是一个host可以同时加入多个aggregation

```
[root@bc-controller-01 ~]# nova aggregate-list
+----+--------------+-------------------+--------------------------------------+
| Id | Name         | Availability Zone | UUID                                 |
+----+--------------+-------------------+--------------------------------------+
| 1  | SRIOV        | sriov             | f12d7b70-ea5b-4ce6-bad0-d7620e91eafa |
| 4  | gl-host-test | -                 | 2724fc88-9847-4524-877d-7114f8924115 |
| 6  | test-hostag1 | sriov             | 60741be3-dac1-400b-9e1d-d28d8504c8e8 |
| 9  | test-hostag2 | sriov             | 50115730-b48e-4e95-b492-cab9713a4557 |
| 15 | test-hostag3 | nova              | 020df897-6077-4547-860d-4799d4adc23c |
| 18 | DPDK         | dpdk              | 21b2c376-571b-4c29-a92c-16c1c246fcef |
+----+--------------+-------------------+--------------------------------------+
```

![jpg](/images/2concepts/1.png)
![jpg](/images/2concepts/2.png)
![jpg](/images/2concepts/3.png)
![jpg](/images/2concepts/4.png)

# 第二组：虚拟机的numa和物理机的numa

```
$ openstack flavor set aze-FLAVOR \
    --property hw:numa_nodes=2 \
    --property hw:numa_cpus.0=0,1 \-
    --property hw:numa_cpus.1=2,3 \
    --property hw:numa_mem.0=2048 \
    --property hw:numa_mem.1=2048 \
```

numa_cpus.0 numa_cpus.1 numa_mem.0 numa_mem.1 中的numa0，1都说的是虚拟机numa。不一定会分配给物理机的numa0，1，可能反着分配。
0,1 2,3 2048也是虚拟机的cpu编号和内存大小，具体落在哪个物理cpu和物理mem上是不能控制的。

