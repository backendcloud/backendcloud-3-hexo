title: RAID
date: 2017-08-01 08:42:40
readmore: true
categories: Tools
tags:
- RAID
---

# RAID概念与实现方式

RAID（Redundant  Array  of  Independent  Disks）：独立冗余磁盘阵列，简称磁盘阵列。RAID是按照一定的形式和方案组织起来的存储设备，它比单个存储设备在速度、稳定性和存储能力上都有很大提高，并且具备一定的数据安全保护能力。



# 常用RAID级别与分类标准

RAID技术将多个单独的物理硬盘以不同的方式组合成一个逻辑硬盘，提高了硬盘的读写性能和数据安全性，根据不同的组合方式可以分为不同的RAID级别。 

RAID级别 | 描述
-------- | ----
RAID 0 | 数据条带化，无校验
RAID 1 | 数据镜像，无校验
RAID 3 | 数据条带化读写，校验信息存放于专用硬盘
RAID 5 | 数据条带化，校验信息分布式存放
RAID 6 | 数据条带化，分布式校验并提供两级冗余
RAID10 | 类似于RAID 0+1，区别在于先做RAID 1，后做RAID 0
RAID 50 | 先做RAID 5，后做RAID 0，能有效提高RAID 5的性能

## RAID 0 实现方式

![](/images/raid/raid-0.jpg)

## RAID 1 实现方式

![raid-1](/images/raid/raid-1.jpg)

## RAID 3 实现方式

![raid-3](/images/raid/raid-3.jpg)

## RAID 5 实现方式

![raid-5](/images/raid/raid-5.jpg)

## RAID 6 实现方式

RAID  6是带有两种分布存储的奇偶校验码的独立磁盘结构，它是RAID  5的一种扩展，采用两种奇偶校验方法，需要至少N+2个磁盘来构成阵列，一般用在数据可靠性、可用性要求极高的应用场合

常用的RAID 6技术有RAID6 P＋Q和RAID6 DP 

### RAID6 P+Q 实现方式

RAID6  P+Q需要计算出两个校验数据P和Q，当有两个数据丢失时，根据P和Q恢复出丢失的数据。校验数据P和Q是由以下公式计算得来的：

P=D0⊕ D1 ⊕ D2 ……
Q=(α⊗D0)⊕(β⊗D1)⊕(γ⊗D2)……

![raid-6pq](/images/raid/raid-6pq.jpg)

### RAID6 DP 实现方式

DP－Double  Parity，就是在RAID4所使用的一个行XOR校验磁盘的基础上又
增加了一个磁盘用于存放斜向的XOR校验信息

横向校验盘中P1—P4为各个数据盘中横向数据的校验信息
例：P0=D0 XOR D1 XOR D2 XOR D3

斜向校验盘中DP1—DP4为各个数据盘及横向校验盘的斜向数据校验信息  
例：DP0=D0 XOR D5 XOR D10XOR D15

![raid-6dp](/images/raid/raid-6dp.jpg)



# RAID 典型应用场景

RAID级别 | RAID 0 | RAID 1 | RAID 3 | RAID 5 /6 | RAID 10
-------- | ------ | ------ | ------ | --------- | -------
典型应用环境 | 迅速读写，安全性要求不高，如图形工作站等 | 随机数据写入，安全性要求高，如服务器、数据库存储领域 | 连续数据传输，安全性要求高，如视频编辑、大型数据库等 | 随机数据传输，安全性要求高，如金融、数据库、存储等 | 数据量大，安全性要求高，如银行、金融等领域



# RAID级别选择

从可靠性、性能和成本简单比较各RAID级别的优劣（相对而言），供在实际项目中选择时参考。

  | RAID 0 | RAID 1 | RAID 3 | RAID 5 | RAID 10 | RAID6
- | ------ | ------ | ------ | ------ | ------- | -----
可靠性 | ★ | ★★★★ | ★★ | ★★★ | ★★★★ | ★★★★
性能 | ★★★★ | ★★★★ | ★★★ | ★★★ | ★★★★ | ★★
成本 | ★★★★ | ★★ | ★★★ | ★★★ | ★★ | ★★ 



# RAID与LUN的关系

RAID由几个硬盘组成  ，从整体上看相当于有多个硬盘组成的一个大的物理卷

在物理卷的基础上可以按照指定容量创建一个或多个逻辑单元，这些逻辑单元称作LUN,可以做为映射给主机的基本块设备

![raid-lun](/images/raid/raid-lun.jpg)
