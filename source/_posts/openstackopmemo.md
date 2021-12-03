title: Openstack运维常见问题记录(1)
date: 2018-08-26 18:38:42
categories:
- Openstack_op

tags:
- Openstack
- devops

---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

# 故障处理流程


* 首先确定故障的资源ID，并判断故障发生的组件
* 查看对应组件的日志，根据故障资源ID进行搜索，找到相应的ERROR日志
* 如果ERROR日志又将问题指向了其他组件，则根据ERROR日志中的资源ID、时间、req-id等信息，其他组件继续查找问题，直到发现问题根源。
* 如果没有在日志中发现任何ERROR，有可能是网络不通，导致请求无法到达API，此时需要检查和API的连通性（如果使用VIP的话，需要分别检查和VIP的联通性和实IP的连通性）。
* 如果API中能找到相应请求，但是conductor/scheduler/compute没有找到相应日志，则有可能是MQ发生故障。
* 如果组件长时间没有任何日志刷新，有可能是组件进程挂掉或者处于僵死状态，可以尝试重启服务，或先打开Debug再重启服务。（对线上环境，重启服务操作需要首先报备，经甲方同意后再操作！）



# 创建vm报错

    [root@EXTENV-194-18-2-16 nova]# cat nova-compute.log | grep 620cd801-8849-481a-80e0-2980b6c8dba6
    2018-08-23 15:23:36.136 3558 INFO nova.compute.resource_tracker [req-f76d5408-00f8-4a67-854e-ad3da2098811 - - - - -] Instance 620cd801-8849-481a-80e0-2980b6c8dba6 has allocations against this compute host but is not found in the database.

分析：感觉是node的信息数据库不同步

nova show 出错的vm，包cell错误

    ####每次增加一个计算节点在控制节点需要执行：
    # su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova

问题解决。



# neutron服务是好的，命令行创建网络查看网络正常，就是dashboard不能查看网络相关的页面

dashboard 网络页面报错 Invalid service catalog service: network

<!-- more -->

分析：应该是Keystone没有正常配置。导致没有找到相关的Catalog信息。

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

所以把第一条没有url的数据删掉就好了，但是发现只有openstack catalog list，没有openstack catalog delete命令，后来查看keystone的配置文件keystone.conf发现如下配置
见[catalog]

从配置文件和一些资料看出catalog是从mysql里面读取的数据，然后从mysql的keystone库中的service表里找到了脏数据，然后知道了用openstack service delete去删除‘脏数据’，问题就解决了。

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
    [root@EXTENV-194-18-2-11 ~]#  openstack service delete e37085e8fb2a49c0921c2d24f5e4f9b5
    [root@EXTENV-194-18-2-11 ~]# systemctl restart httpd.service memcached.service



# 查看中文命名的镜像的时候，报错

    [root@NFJD-TESTVM-CORE-API-1 ~]# glance image-list
    'ascii' codec can't encode character u'\u5982' in position 1242: ordinal not in range(128)

分析：镜像名字有用中文命名的情况。

将export LC_ALL=zh_CN.UTF-8
添加到/etc/profile

同时注意source的文件中是否有export LC_ALL=C



# vm 生成失败

    2017-05-25 11:01:29.577 21880 TRACE nova.compute.manager [instance: 2c5a8e62-62d0-430d-8747-795350bb6939] ProcessExecutionError: Unexpected error while running command.
    2017-05-25 11:01:29.577 21880 TRACE nova.compute.manager [instance: 2c5a8e62-62d0-430d-8747-795350bb6939] Command: qemu-img convert -O raw /var/lib/nova/instances/_base/f5797db00aacfbe240bbfb0f53c2da80e4be6dfc.part /var/lib/nova/instances/_base/f5797db00aacfbe240bbfb0f53c2da80e4be6dfc.converted
    2017-05-25 11:01:29.577 21880 TRACE nova.compute.manager [instance: 2c5a8e62-62d0-430d-8747-795350bb6939] Exit code: 1
    2017-05-25 11:01:29.577 21880 TRACE nova.compute.manager [instance: 2c5a8e62-62d0-430d-8747-795350bb6939] Stdout: u''
    2017-05-25 11:01:29.577 21880 TRACE nova.compute.manager [instance: 2c5a8e62-62d0-430d-8747-795350bb6939] Stderr: u'qemu-img: error while writing sector 1569792: No space left on device\n'
    2017-05-25 11:01:29.577 21880 TRACE nova.compute.manager [instance: 2c5a8e62-62d0-430d-8747-795350bb6939]
    2017-05-25 11:01:29.580 21880 INFO nova.compute.manager [req-9fa74abf-bcc1-4b7e-aaef-2e17b593a356 6aa5df16b47442c58efde791abd60497 66458b9ead64409fb9d2e0f2c6d67d39 - - -] [instance: 2c5a8e62-62d0-430d-8747-795350bb6939] Terminating instance


    # df -h
发现磁盘所剩不多了

对策：清理磁盘 




# 疏散失败

执行了个nova疏散命令，疏散不了，nova show 报这个错误：共享存储的状态不对。就是nova instances目录不具备共享存储，如没有配置了ceph共享存储，但是在执行nova evacuate命令的时候还是带了共享存储的参数。

    | fault                                | {"message": "Invalid state of instance files on shared storage", "code": 500, "details": "  File \"/usr/lib/python2.7/site-packages/nova/compute/manager.py\", line 354, in decorated_function |
    |                                      |     return function(self, context, *args, **kwargs)                                                                                                                                            |
    |                                      |   File \"/usr/lib/python2.7/site-packages/nova/compute/manager.py\", line 3031, in rebuild_instance                                                                                            |
    |                                      |     _(\"Invalid state of instance files on shared\"                                                                                                                                            |
    |                                      | ", "created": "2017-05-17T01:25:17Z"}       



# 有一定的概率无法显示控制台

操作步骤：控制台-虚拟机，点击虚拟机名称，点击【控制台】

预期结果：正常显示console页面

实际结果：有一定概率页面提示“Failed to connect to server”，点击在新窗口打开，可以打开console页面

nova控制节点的配置问题，其配置文件中memcache以及rabbitmq的hosts配置不对





# 在dashboard界面上，用镜像centos7、flavor--2，创建虚机error。并且抛出的错误是no host，即没有找到合适的调度节点。


若flavor的大小比镜像要求的还小，则会报错。

但又一次出现满足上述条件也报错。

有可能用的flavor被创建不合法的extra_specs

    OS-FLV-DISABLED:disabled  False
    OS-FLV-EXT-DATA:ephemeral   0
    disk    20
    extra_specs {"xxx": "123", "yyy": "321"}

而过滤选项又开启了ComputeCapabilitiesFilter过滤器。







# import error

glance register.log报错：

    2017-05-08 03:18:55.890 3185 ERROR glance.common.config [-] Unable to load glance-registry-keystone from configuration file /usr/share/glance/glance-registry-dist-paste.ini.
    Got: ImportError('No module named simplegeneric',)

/usr/lib/python2.7/site-packages/simplegeneric.py 没有读权限，被谁给改了






# keystone报错

Permission denied: AH00072: make_sock: could not bind to address [::]:5000


    [root@controller0 ~]# systemctl start httpd.service
    Job for httpd.service failed because the control process exited with error code. See "systemctl status httpd.service" and "journalctl -xe" for details.
    [root@controller0 ~]# systemctl status httpd.service
    ● httpd.service - The Apache HTTP Server
       Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
       Active: failed (Result: exit-code) since Sat 2016-05-28 20:22:34 EDT; 11s ago
         Docs: man:httpd(8)
               man:apachectl(8)
      Process: 4501 ExecStop=/bin/kill -WINCH ${MAINPID} (code=exited, status=1/FAILURE)
      Process: 4499 ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND (code=exited, status=1/FAILURE)
     Main PID: 4499 (code=exited, status=1/FAILURE)
    
    May 28 20:22:34 controller0 httpd[4499]: (13)Permission denied: AH00072: make_sock: could not bind to address [::]:5000
    May 28 20:22:34 controller0 httpd[4499]: (13)Permission denied: AH00072: make_sock: could not bind to address 0.0.0.0:5000

可能是防火墙的配置问题或者selinux
若防火墙没有问题，检查selinux

检查selinux状态

1 [root@controller0 ~]# getenforce 
2 enforcing                                     #如果不为disabled 则表示为selinux正常运行

SELINUX=enforcing 改为 selinux=distabled
重启reboot



# re-scheduled: Not authorized for image


CLI报错：

    | fault                                | {"message": "Build of instance d5739cf7-9830-47fd-9a75-e9b1cb4bb421 was re-scheduled: Not authorized for image dcd85799-92f6-4294-91ec-48670a218651.", "code": 500, "details": "  File \"/usr/lib/python2.7/site-packages/nova/compute/manager.py\", line 2258, in _do_build_and_run_instance |

登陆到该计算节点，也报错

    2017-05-18 15:01:24.867 40639 TRACE nova.compute.manager [instance: d5739cf7-9830-47fd-9a75-e9b1cb4bb421] ImageNotAuthorized: Not authorized for image dcd85799-92f6-4294-91ec-48670a218651.
    2017-05-18 15:01:24.867 40639 TRACE nova.compute.manager [instance: d5739cf7-9830-47fd-9a75-e9b1cb4bb421]

于是在 /etc/nova/nova.conf中 增加 
    [DEFAULT]
    auth_strategy=keyston
    少了个e
    应该是:
    [DEFAULT]
    auth_strategy=keystone








# libvirtError: unsupported configuration: IDE controllers are unsupported for this     QEMU binary or machine type

    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f] Traceback (most recent call last):
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]   File "/usr/lib/python2.7/site-packages/nova/compute/manager.py", line 2483, in _build_resources
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]     yield resources
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]   File "/usr/lib/python2.7/site-packages/nova/compute/manager.py", line 2355, in _build_and_run_instance
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]     block_device_info=block_device_info)
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]   File "/usr/lib/python2.7/site-packages/nova/virt/libvirt/driver.py", line 2704, in spawn
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]     block_device_info=block_device_info)
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]   File "/usr/lib/python2.7/site-packages/nova/virt/libvirt/driver.py", line 4758, in _create_domain_and_network
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]     power_on=power_on)
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]   File "/usr/lib/python2.7/site-packages/nova/virt/libvirt/driver.py", line 4689, in _create_domain
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]     LOG.error(err)
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]   File "/usr/lib/python2.7/site-packages/oslo_utils/excutils.py", line 85, in __exit__
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]     six.reraise(self.type_, self.value, self.tb)
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]   File "/usr/lib/python2.7/site-packages/nova/virt/libvirt/driver.py", line 4679, in _create_domain
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]     domain.createWithFlags(launch_flags)
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]   File "/usr/lib/python2.7/site-packages/eventlet/tpool.py", line 186, in doit
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]     result = proxy_call(self._autowrap, f, *args, **kwargs)
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]   File "/usr/lib/python2.7/site-packages/eventlet/tpool.py", line 144, in proxy_call
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]     rv = execute(f, *args, **kwargs)
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]   File "/usr/lib/python2.7/site-packages/eventlet/tpool.py", line 125, in execute
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]     six.reraise(c, e, tb)
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]   File "/usr/lib/python2.7/site-packages/eventlet/tpool.py", line 83, in tworker
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]     rv = meth(*args, **kwargs)
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]   File "/usr/lib64/python2.7/site-packages/libvirt.py", line 1065, in createWithFlags
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f]     if ret == -1: raise libvirtError ('virDomainCreateWithFlags() failed', dom=self)
    2017-05-18 15:06:09.522 41033 TRACE nova.compute.manager [instance: c348b942-4553-4023-bbcb-296f3b1bf14f] libvirtError: unsupported configuration: IDE controllers are unsupported for this QEMU binary or machine type

将IDE改成virtio



# qemu-kvm: Cirrus VGA not available


    | fault                                | {"message": "Build of instance a1feb48a-b5f5-48ab-93a7-838bb46573fb was re-scheduled: internal error: process exited while connecting to monitor: 2017-05-18T10:33:34.222333Z qemu-kvm: Cirrus VGA not available", "code": 500, "details": "  File \"/usr/lib/python2.7/site-packages/nova/compute/manager.py\", line 2258, in _do_build_and_run_instance |


power架构的机器不支持Cirrus VGA








# 默认路由不能删除

默认路由怎么也删除不掉

有两个service确认下状态是否正常。network和NetworkManager












# dashboard访问卡顿


定位到dashboard卡的原因是应为nova卡，

nova卡顿是因为nova无法与memcached建立连接，

进一步定位到memcached默认的最大连接数是1024，目前已达到最大连接数。

解决办法为编辑 /etc/sysconfig/memcached

参数修改为：

    PORT="11211"
    USER="memcached"
    MAXCONN="65536"
    CACHESIZE="1024"
    OPTIONS=""

重启memcached


# task_state一直处于scheduling

nova boot 执行某一个节点生成vm， task_state一直处于scheduling，vm_state一直处于building，有可能是强制调度的节点的nova-compute state down了。


# Access denied for user 'nova'@'%' to database 'nova_api'

初始化nova_api数据库的时候
初始化数据库

    su -s /bin/sh -c "nova-manage api_db sync" nova

报错：

    Access denied for user 'nova'@'%' to database 'nova_api'

root用户进入数据库，执行
    
    > GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY '2267593eb27be7c414fc';

解决











# 所有节点disk不足，返回0可用host

到该节点df -h发现磁盘空间剩余很多。nova判断节点的磁盘空间不是根据ll判断的，而是根据vm和其他数据一共占用的空间来计算的。

如：


    [root@NFJD-PSC-IBMN-SV356 10d31bfa-961d-44ea-b554-7575315a8e2e]# ll -h
    total 679M
    -rw-rw---- 1 root root  16K Nov 17 17:32 console.log
    -rw-r--r-- 1 root root 679M Nov 18 10:07 disk
    -rw-r--r-- 1 qemu qemu 422K Nov 17 17:24 disk.config
    -rw-r--r-- 1 nova nova  162 Nov 17 17:24 disk.info
    -rw-r--r-- 1 nova nova 3.4K Nov 17 17:24 libvirt.xml
    [root@NFJD-PSC-IBMN-SV356 10d31bfa-961d-44ea-b554-7575315a8e2e]# qemu-img info disk
    image: disk
    file format: qcow2
    virtual size: 40G (42949672960 bytes)
    disk size: 678M
    cluster_size: 65536
    backing file: /var/lib/nova/instances/_base/af019e4c89c44506c068ada379c040848416510e
    Format specific information:
        compat: 1.1
        lazy refcounts: false

ll 这个文件出来的是600多兆，但是nova统计是按40G来统计的。因为nova代码要统计的是disk_over_committed。nova会把统计的磁盘信息存放在nova数据库的表compute_nodes中提供给调度器。

这里的virtual size减去disk size，便是over_commit_size。

可以看到，这里仅仅对qcow2格式的镜像做了overcommit处理，其它文件的over_commit_size等于0。

在nova调度服务的DiskFilter里面，用到了disk_allocation_ratio对磁盘资源做了超分，它和这里的overcommit不是一个概念，它是从控制节点角度看到的超额使用，而计算节点看不到，overcommit是计算节点看到了磁盘qcow2压缩格式之后所得到的结果，它最终上报的剩余空间是扣除了假设qcow2镜像文件解压之后的实际结果。所以会遇到实际上报的剩余空间小于肉眼看到的空间大小。

如果管理员部署时指定了计算节点，则不走调度流程，就会把虚拟机硬塞给该计算节点，强行占用了已经归入超额分配计划的空间，则最终可能导致计算节点上报的磁盘资源为负数。并且将来随着虚拟机实际占用的磁盘空间越来越大，最终可能就导致计算节点硬盘空间不足了。












# novnc打不开问题定位

可能compute的防火墙被改了

在 /etc/sysconfig/iptables 添加


    -A INPUT -p tcp --dport 5900:6100 -j ACCEPT










# qemu-ga由于找不到对应的虚拟串行字符设备而启动失败，提示找不到channel

glance image-update --property hw_qemu_guest_agent=yes $IMAGE_ID# ... 其他属性配置
务必设置property的hw_qemu_guest_agent=yes,否则libvert启动虚拟机时不会生成qemu-ga配置项，导致虚拟机内部的qemu-ga由于找不到对应的虚拟串行字符设备而启动失败，提示找不到channel。







