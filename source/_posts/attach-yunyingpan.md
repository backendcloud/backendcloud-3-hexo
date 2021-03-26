title: 挂载云硬盘
date: 2017-06-30 05:16:38
categories: Openstack_op
tags:
- 云硬盘
---

# 创建（订购）云硬盘

    [root@NFJD-PSC-BCEC-SV3 deployer]# cinder create 500 --volume-type fujitsu-ipsan --name 0630
    +---------------------------------------+--------------------------------------+
    |                Property               |                Value                 |
    +---------------------------------------+--------------------------------------+
    |              attachments              |                  []                  |
    |           availability_zone           |                 nova                 |
    |                bootable               |                false                 |
    |          consistencygroup_id          |                 None                 |
    |               created_at              |      2017-06-30T08:23:05.000000      |
    |              description              |                 None                 |
    |               encrypted               |                False                 |
    |                   id                  | 08d3018c-b1cd-4652-87ed-45a48a14b6f3 |
    |                metadata               |                  {}                  |
    |              multiattach              |                False                 |
    |                  name                 |                 0630                 |
    |      os-vol-tenant-attr:tenant_id     |   597854e23bfe46abb6178f786af12391   |
    |   os-volume-replication:driver_data   |                 None                 |
    | os-volume-replication:extended_status |                 None                 |
    |           replication_status          |               disabled               |
    |                  size                 |                 500                  |
    |              snapshot_id              |                 None                 |
    |              source_volid             |                 None                 |
    |                 status                |               creating               |
    |                user_id                |   622684c00210427091c7493f36aaa6cf   |
    |              volume_type              |            fujitsu-ipsan             |
    +---------------------------------------+--------------------------------------+

# 挂载云硬盘

已有云主机id 27b31829-326f-4029-a537-bb327303a32c

挂载云硬盘到云主机

    [root@NFJD-PSC-BCEC-SV3 deployer]# nova volume-attach 27b31829-326f-4029-a537-bb327303a32c 08d3018c-b1cd-4652-87ed-45a48a14b6f3
    +----------+--------------------------------------+
    | Property | Value                                |
    +----------+--------------------------------------+
    | device   | /dev/vdb                             |
    | id       | 08d3018c-b1cd-4652-87ed-45a48a14b6f3 |
    | serverId | 27b31829-326f-4029-a537-bb327303a32c |
    | volumeId | 08d3018c-b1cd-4652-87ed-45a48a14b6f3 |
    +----------+--------------------------------------+

挂载前后的fdisk -l命令执行结果对比，发现挂载云硬盘后，多出来了vdb
![1](/images/attach-yunyingpan/1.jpg)



# 分区

运行 fdisk /dev/vdb，对数据盘进行分区。根据提示，依次输入 n，p，1，两次回车，wq，分区就开始了。
![2](/images/attach-yunyingpan/2.jpg)

运行 fdisk -l 命令，查看新的分区。新分区 vdb1 已经创建好。如下面示例中的/dev/xvdb。
![3](/images/attach-yunyingpan/3.jpg)



# 格式化

运行 mkfs.ext3 /dev/xvdb1，对新分区进行格式化。格式化所需时间取决于数据盘大小。您也可自主决定选用其他文件格式，如 ext4 等。
![4](/images/attach-yunyingpan/4.jpg)

运行 echo /dev/xvdb1 /mnt ext3 defaults 0 0 >> /etc/fstab 写入新分区信息。完成后，可以使用 cat /etc/fstab 命令查看。
![5](/images/attach-yunyingpan/5.jpg)

通过命令mount -a，实现修改/etc/fstab后不重启且生效。然后执行 df -h 查看分区。如果出现数据盘信息，说明挂载成功，可以使用新分区了。
![6](/images/attach-yunyingpan/6.jpg)



# linux使用dd命令快速生成大文件

![7](/images/attach-yunyingpan/7.jpg)

dd命令可以轻易实现创建指定大小的文件，如

    dd if=/dev/zero of=test bs=1M count=1000

会生成一个1000M的test文件，文件内容为全0（因从/dev/zero中读取，/dev/zero为0源）

但是这样为实际写入硬盘，文件产生速度取决于硬盘读写速度，如果欲产生超大文件，速度很慢

在某种场景下，我们只想让文件系统认为存在一个超大文件在此，但是并不实际写入硬盘

则可以

    dd if=/dev/zero of=test bs=1M count=0 seek=100000

此时创建的文件在文件系统中的显示大小为100000MB，但是并不实际占用block，因此创建速度与内存速度相当

seek的作用是跳过输出文件中指定大小的部分，这就达到了创建大文件，但是并不实际写入的目的

当然，因为不实际写入硬盘，所以你在容量只有10G的硬盘上创建100G的此类文件都是可以的

