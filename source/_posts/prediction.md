title: OPNFV Prediction
date: 2016-06-11 16:11:10
categories:
  - NFV
tags:
  - OPNFV Prediction

---

# overview

部署灾害预测系统可以用来帮助NFV系统提前避免出现灾害。整个灾害预测系统由数据采集，灾害预测，灾害管理三个模块组成。

该项目目标是开发一个灾害预测框架，一个数据收集模型和一个dashboard。用户可以通过dashboard定义哪一种灾害需要被检测和那些数据需要被用来预测。

预测框架基于机器学习库（如：Weka, Spark ML lib）用户可以定义哪一种灾害需要被检测和那些数据需要被用来预测。预测器用来自动收集数据和执行相应的预测。




# 收集数据种类

Ceilometer和Monasca能够收集物理资源和虚拟资源的监视数据，但是不能监测应用和虚拟节点的数据。下面是一些例子（并不全面）
- vcpu中断时间，vcpu空闲时间，vcpu系统时间，vcpu用户时间
- 文件系统信息
- 内存使用率（分配的，未使用的，块大小，多少块已被使用，page交换）
- VNF的Hypervisor优先级
- 在使用中的加速技术（DPDK，SR-IOV等）




# 结构

整个灾害预测系统由数据采集，灾害预测，灾害管理三个模块组成，如下图所示。

                                 +-------------------+
                                 | Fault management  |
                                 | (e.g. doctor)     |
                                 +---------^---------+
                                           |
                                           |Failure notification
                                           |
                             +-------------+-------------+
                             | Predictor                 |
                             | (include training system) |
                             +-------------^-------------+
                                           |
    +------------------------------------------------------------------------------+
    |                                      |                                       |
    |          +---------------------------+                                       |
    |          |                           |                         Collector     |
    |  +-------+------+                +---+------+                                |
    |  |  Ceilometer  |                | Monasca  |                                |
    |  +--------------+                +---^------+                                |
    |                                      |                                       |
    |                                      |                                       |
    |                         +------------+-----------------+                     |
    |                         | Data collector               |                     |
    |                         | (e.g. zabbix, nagios, cacti) |                     |
    |                         +------------------------------+                     |
    |                                                                              |
    +------------------------------------------------------------------------------+

数据收集模块包含Ceilometer和Monasca（可被用于其他开源数据收集器的插件，如Zabbix, Nagios, Cacti）基于实时分析技术和机器学习技术。灾害预测器分析收集器收集来的数据，并自动判断是否有灾害将要发生。如果判断成立，灾害预测器发送通知给灾害管理模块。

