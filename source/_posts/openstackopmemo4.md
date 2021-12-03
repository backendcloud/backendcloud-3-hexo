title: Openstack运维常见问题记录(4)
date: 2020-01-01 20:28:32
categories:
- Openstack_op
tags:
- Openstack
- devops
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

# 自动清除镜像缓存

在一台计算节点创建虚拟机，若是第一次在该节点创建次虚拟机，会先将镜像文件复制到该计算节点目录/var/lib/nova/instances/_base。长期下来，该目录会占用比较大的磁盘空间而要清理。

可以通过修改nova的配置文件来自动清理该缓存目录。

对比remove_unused_base_images=True设定前后的不同，即设定前多余镜像不会被自动清除，设定并重启nova-compute服务后，多余的镜像文件会被自动清理，且可以正常生成云主机。

**remove_unused_base_images=True设定前：**

<div>
<img src="/images/openstackopmemo4/1.png" align='left'>
</div>
<br>
<br>

其中镜像文件be32a717ae7ea3aa039131689864a325fd634c92是没有被使用的镜像文件。
等待一段时间，文件没有变化。

<!-- more -->

**remove_unused_base_images=True设定并重启nova-compute服务后:**

<div>
<img src="/images/openstackopmemo4/2.png" align='left'>
</div>
<br>
<br>

image_cache_manager_interval=5，remove_unused_original_minimum_age_seconds=3是为了缩短测试时间作的设定，实际生产环境分别是用默认值40分钟，设定值24*7小时，现在改成5秒，3秒。就是说不用此缩短测试时间的设定，生产环境是40分钟检查下image cache，超过24*7小时无用的base镜像才会被删除。
 
<div>
<img src="/images/openstackopmemo4/3.png" align='left'>
</div>
<br>
<br>
<br>
<br>

发现很快多余的镜像被自动删除了。
检查/var/log/nova/nova-compute.log，也找到了自动删除多余镜像的log：
 
    2017-02-07 16:01:51.678 14200 INFO nova.virt.libvirt.imagecache [req-ee1a7ad5-a021-4aad-b653-7db14191536e - - - - -] Active base files: /var/lib/nova/instances/_base/0522bc602608d45758d815b01a6899ff3e1e3e27 /var/lib/nova/instances/_base/dc1ed4ad70a573f2acea085b068b61f3cb99e195 /var/lib/nova/instances/_base/be32a717ae7ea3aa039131689864a325fd634c1c
    2017-02-07 16:01:51.678 14200 INFO nova.virt.libvirt.imagecache [req-ee1a7ad5-a021-4aad-b653-7db14191536e - - - - -] Removable base files: /var/lib/nova/instances/_base/be32a717ae7ea3aa039131689864a325fd634c92
    2017-02-07 16:01:51.679 14200 INFO nova.virt.libvirt.imagecache [req-ee1a7ad5-a021-4aad-b653-7db14191536e - - - - -] Removing base or swap file: /var/lib/nova/instances/_base/be32a717ae7ea3aa039131689864a325fd634c92



# has allocations against this compute host but is not found in the database

现象：
创建vm报错

    [root@EXTENV-194-18-2-16 nova]# cat nova-compute.log | grep 620cd801-8849-481a-80e0-2980b6c8dba6
    2018-08-23 15:23:36.136 3558 INFO nova.compute.resource_tracker [req-f76d5408-00f8-4a67-854e-ad3da2098811 - - - - -] Instance 620cd801-8849-481a-80e0-2980b6c8dba6 has allocations against this compute host but is not found in the database.

解决：

感觉是node的信息数据库不同步

nova show 出错的vm，报cell错误

    ####每次增加一个计算节点在控制节点需要执行：
    # su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova

问题解决。



# dashboard neutron报错 Invalid service catalog service: network

现象：
neutron服务是好的，命令行创建网络查看网络正常，就是dashboard不能查看网络相关的页面
dashboard neutron报错 Invalid service catalog service: network

解决：
应该是Keystone没有正常配置。导致没有找到相关的Catalog信息。

    [root@EXTENV-194-18-2-11 ~]# openstack catalog list
    +-----------+-----------+-----------------------------------------------+
    | Name      | Type      | Endpoints                                     |
    +-----------+-----------+-----------------------------------------------+
    | placement | placement | RegionOne                                     |
    |           |           |   internal: http://nova-ha-vip:8778           |
    |           |           | RegionOne                                     |
    |           |           |   admin: http://nova-ha-vip:8778              |
    |           |           | RegionOne                                     |
    |           |           |   public: http://nova-ha-vip:8778             |
    |           |           |                                               |
    | keystone  | identity  | RegionOne                                     |
    |           |           |   public: http://keystone-ha-vip:5000/v3/     |
    |           |           | RegionOne                                     |
    |           |           |   internal: http://keystone-ha-vip:35357/v3/  |
    |           |           | RegionOne                                     |
    |           |           |   admin: http://keystone-ha-vip:35357/v3/     |
    |           |           |                                               |
    | glance    | image     | RegionOne                                     |
    |           |           |   admin: http://glance-ha-vip:9292            |
    |           |           | RegionOne                                     |
    |           |           |   internal: http://glance-ha-vip:9292         |
    |           |           | RegionOne                                     |
    |           |           |   public: http://glance-ha-vip:9292           |
    |           |           |                                               |
    | nova      | compute   | RegionOne                                     |
    |           |           |   public: http://nova-ha-vip:8774/v2.1        |
    |           |           | RegionOne                                     |
    |           |           |   admin: http://nova-ha-vip:8774/v2.1         |
    |           |           | RegionOne                                     |
    |           |           |   internal: http://nova-ha-vip:8774/v2.1      |
    |           |           |                                               |
    | neutron   | network   |                                               |
    | neutron   | network   | RegionOne                                     |
    |           |           |   public: http://neutron-server-ha-vip:9696   |
    |           |           | RegionOne                                     |
    |           |           |   admin: http://neutron-server-ha-vip:9696    |
    |           |           | RegionOne                                     |
    |           |           |   internal: http://neutron-server-ha-vip:9696 |
    |           |           |                                               |
    +-----------+-----------+-----------------------------------------------+

所以把第一条neutron没有url的数据删掉就好了，但是发现只有openstack catalog list，没有openstack catalog delete命令，后来查看keystone的配置文件keystone.conf发现如下配置
见[catalog]
从配置文件看出catalog是从mysql里面读取的数据，然后从mysql的keystone库中的service表里找到了脏数据，然后知道了用openstack service delete去删除‘脏数据’，问题就解决了。

    MariaDB [keystone]> select * from service;
    +----------------------------------+-----------+---------+-------------------------------------------------------------+
    | id                               | type      | enabled | extra                                                       |
    +----------------------------------+-----------+---------+-------------------------------------------------------------+
    | 520f6bf8564240be9678c4ef25305cad | placement |       1 | {"description": "OpenStack Placement", "name": "placement"} |
    | 960580852a594c078e68fe3683e35db5 | identity  |       1 | {"name": "keystone"}                                        |
    | 98ed18fcd8104732919bb5869a5a6dc2 | image     |       1 | {"description": "OpenStack Image", "name": "glance"}        |
    | abef1b9469d94d3ab9f27c8ed72a5a48 | compute   |       1 | {"description": "OpenStack Compute", "name": "nova"}        |
    | e37085e8fb2a49c0921c2d24f5e4f9b5 | network   |       1 | {"description": "OpenStack Networking", "name": "neutron"}  |
    | f1b661407ce04f79bc24605fa59bb74c | network   |       1 | {"description": "OpenStack Networking", "name": "neutron"}  |
    +----------------------------------+-----------+---------+-------------------------------------------------------------+
    6 rows in set (0.00 sec)
    
    MariaDB [keystone]> select * from endpoint;
    +----------------------------------+--------------------+-----------+----------------------------------+-----------------------------------+-------+---------+-----------+
    | id                               | legacy_endpoint_id | interface | service_id                       | url                               | extra | enabled | region_id |
    +----------------------------------+--------------------+-----------+----------------------------------+-----------------------------------+-------+---------+-----------+
    | 142cb619cd2242828b0c9394d5baaea1 | NULL               | public    | f1b661407ce04f79bc24605fa59bb74c | http://neutron-server-ha-vip:9696 | {}    |       1 | RegionOne |
    | 2252d3ef840b4c5aa1184ebe8d6094f1 | NULL               | public    | abef1b9469d94d3ab9f27c8ed72a5a48 | http://nova-ha-vip:8774/v2.1      | {}    |       1 | RegionOne |
    | 476654c6e7dd4d22b290de451e3afda0 | NULL               | admin     | abef1b9469d94d3ab9f27c8ed72a5a48 | http://nova-ha-vip:8774/v2.1      | {}    |       1 | RegionOne |
    | 562a5d5443af4dfab6760204d0adf3bf | NULL               | internal  | 520f6bf8564240be9678c4ef25305cad | http://nova-ha-vip:8778           | {}    |       1 | RegionOne |
    | 58bd5f09811a4ebcb62a4b51fb7ae444 | NULL               | admin     | f1b661407ce04f79bc24605fa59bb74c | http://neutron-server-ha-vip:9696 | {}    |       1 | RegionOne |
    | 600811f8ccaf42669d4d83b897af3933 | NULL               | admin     | 520f6bf8564240be9678c4ef25305cad | http://nova-ha-vip:8778           | {}    |       1 | RegionOne |
    | 80683f619efb41dcbb6796ea04f16159 | NULL               | internal  | f1b661407ce04f79bc24605fa59bb74c | http://neutron-server-ha-vip:9696 | {}    |       1 | RegionOne |
    | 8e0a684607294a729f87d7d8b1a639ca | NULL               | public    | 520f6bf8564240be9678c4ef25305cad | http://nova-ha-vip:8778           | {}    |       1 | RegionOne |
    | 9ef0f18d891e45608ffc41985dc6afa6 | NULL               | public    | 960580852a594c078e68fe3683e35db5 | http://keystone-ha-vip:5000/v3/   | {}    |       1 | RegionOne |
    | a0b10cb04a5b4ca3859aaf2ea4ca2a3b | NULL               | admin     | 98ed18fcd8104732919bb5869a5a6dc2 | http://glance-ha-vip:9292         | {}    |       1 | RegionOne |
    | c53979becccc44f1813e9f50a619af7e | NULL               | internal  | 960580852a594c078e68fe3683e35db5 | http://keystone-ha-vip:35357/v3/  | {}    |       1 | RegionOne |
    | dadbb8dc218245bbba8c9a34237413ec | NULL               | internal  | 98ed18fcd8104732919bb5869a5a6dc2 | http://glance-ha-vip:9292         | {}    |       1 | RegionOne |
    | f4034b8c086a451caed52ac51a761fb0 | NULL               | public    | 98ed18fcd8104732919bb5869a5a6dc2 | http://glance-ha-vip:9292         | {}    |       1 | RegionOne |
    | fc150884825544baaf4912f14e76f51a | NULL               | internal  | abef1b9469d94d3ab9f27c8ed72a5a48 | http://nova-ha-vip:8774/v2.1      | {}    |       1 | RegionOne |
    | fc7132052063438895674fd7b840db68 | NULL               | admin     | 960580852a594c078e68fe3683e35db5 | http://keystone-ha-vip:35357/v3/  | {}    |       1 | RegionOne |
    +----------------------------------+--------------------+-----------+----------------------------------+-----------------------------------+-------+---------+-----------+
    15 rows in set (0.00 sec)
    
    [root@EXTENV-194-18-2-11 ~]#  openstack service list
    +----------------------------------+-----------+-----------+
    | ID                               | Name      | Type      |
    +----------------------------------+-----------+-----------+
    | 520f6bf8564240be9678c4ef25305cad | placement | placement |
    | 960580852a594c078e68fe3683e35db5 | keystone  | identity  |
    | 98ed18fcd8104732919bb5869a5a6dc2 | glance    | image     |
    | abef1b9469d94d3ab9f27c8ed72a5a48 | nova      | compute   |
    | e37085e8fb2a49c0921c2d24f5e4f9b5 | neutron   | network   |
    | f1b661407ce04f79bc24605fa59bb74c | neutron   | network   |
    +----------------------------------+-----------+-----------+
    [root@EXTENV-194-18-2-11 ~]# openstack service delete e37085e8fb2a49c0921c2d24f5e4f9b5
    [root@EXTENV-194-18-2-11 ~]# systemctl restart httpd.service memcached.service


# **系列文章链接**
- {% post_link openstackopmemo3 Openstack运维常见问题记录(3) %}
- {% post_link openstackopmemo2 Openstack运维常见问题记录(2) %}
- {% post_link openstackopmemo Openstack运维常见问题记录(1) %}
