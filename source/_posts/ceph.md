title: ceph数据存储的几个概念
date: 2018-09-05 17:32:47
categories:
- 基础篇
tags:
- vdbench


---

# Ceph映射机制
三次映射
File        ->  Object  ->    PG     ->              OSD
(ino,ono)   ->     oid     ->   pgid   ->   (osd1,osd2,osd3)
![ceph](/images/ceph/2.jpg)


# Failure Domain：故障域或隔离域

![ceph](/images/ceph/2.jpg)

最下面的蓝色长条可以看成一个个主机，里面的灰色圆柱形可以看成一个个OSD，紫色的cabinet可以也就是一个个机柜， 绿色的row可以看成一排机柜，顶端的root是我们的根节点，没有实际意义，你可以把它看成一个数据中心的意思，也可以看成一个机房的意思，不过只是起到了一个树状结构的根节点的作用。
CRUSH从root下的所有的row中选出一个row。
在刚刚的一个row下面的所有cabinet中，CRUSH选出三个cabinet。
在刚刚的三个cabinet下面的所有OSD中，CRUSH分别选出一个OSD。
这样做的根本意义在于，将数据平均分布在了这个集群里面的所有OSD上，同时，这样选择做到了三个OSD分布在三个不同的cabinet上。

# OSD的故障和处理办法：

1. OSD的故障种类：

      故障A：一个正常的OSD 因为所在的设备发生异常，导致OSD不能正常工作，这样OSD超过设定的时间 就会被 out出集群。

     故障B： 一个正常的OSD因为所在的设备发生异常，导致OSD不能正常工作，但是在设定的时间内，它又可以正常的工作，这时会添加会集群中。

2. OSD的故障处理：

     故障A：OSD上所有的PG，这些PG就会重新分配副本到其他OSD上。一个PG中包含的object数量是不限制的，这时会将PG中所有的object进行复制，可能会产生很大的数据复制。

     故障B：OSD又重新回到PG当中去，这时需要判断一下，如果OSD能够进行增量恢复则进行增量恢复，否则进行全量恢复。（增量恢复：是指恢复OSD出现异常的期间，PG内发生变化的object。全量恢复：是指将PG内的全部object进行恢复，方法同故障A的处理）。

需要全量恢复的操作叫做backfill操作。需要增量恢复的操作叫做recovery操作。

# 从快照中回滚对象数据testproject：

    # rados -p testpool put testobject /etc/hosts
    # rados -p testpool ls
    testobject
    # rados mksnap testsnap1 -p testpool
    # rados lssnap -p testpool
    # rados -p testpool rm testobject
    # rados -p testpool ls
    # rados -p testpool listsnaps testobject
    # rados rollback -p testpool testobject testsnap1
    # rados -p testpool ls
    testobject

# 在资源池testpool 中的对象数据testobject 的osd映射关系：

    ceph osd map testpool testobject

    osdmap e71 pool 'testpool' (6) object 'testobject'-
    -> pg 6.98824931 (6.31) -> up ([5,4,6], p5) acting ([5,4,6], p5)

e71是osd map 版本ID 71；对象testobject属于PG 6.31 ；
其数据分别分布在osd.5，osd.4,osd.6 上。

# 查看数据存储的物理位置：

1、`ceph osd tree` 查看osd【5，4，6】其中一个所在的节点
2、`ssh ceph-nodeN`，进入该节点     #osd.5所在的node节点
3、`df -h | grep -i ceph-5`找出该osd.5的物理存储位置 ,ceph-5是指osd.5
4、`cd /var/lib/ceph/osd/ceph-5/current`进入osd.5所在的物理存储文件夹
5、`ls -l |grep -i 6.31`找出和PG（6.31）相关的文件夹
6、`cd 6.31_head`进入该PG文件夹
7、`ls -l `就可以看到我们存储的testobject数据的详细信息

# vdbench
vdbench是存储性能测试的一个常用工具。

下载[vdbench50406.zip](/files/ceph/vdbench50406.zip)

使用方法：

例如8k随机读写

创建vm，将jdk和vdbench的文件夹传至vm

    # cat parmfile
    hd=default,vdbench=/root/tt,user=root,shell=ssh
    sd=sd1,lun=/dev/vdb,openflags=o_direct,threads=1
    wd=wd1,sd=sd1,xfersize=8k,readpct=50,seekpct=100
    rd=rd1,wd=wd1,iorate=max,elapsed=120,maxdata=5500g,interval=1,warmup=30

    # ./vdbench -f parmfile

