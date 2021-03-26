title: Openstack运维常见问题记录(2)
date: 2018-08-28 14:48:42
categories:
- Openstack_op

tags:
- Openstack
- devops

---

# 启动openvswitch报错

    [root@SRIOV03 ml2]#  systemctl start openvswitch.service
    A dependency job for openvswitch.service failed. See 'journalctl -xe' for details.
    [root@SRIOV03 ml2]# journalctl -xe
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit ovsdb-server.service has begun starting up.
    Aug 28 10:33:00 SRIOV03 runuser[6958]: PAM audit_open() failed: Permission denied
    Aug 28 10:33:00 SRIOV03 ovs-ctl[6929]: runuser: System error
    Aug 28 10:33:00 SRIOV03 ovs-ctl[6929]: /etc/openvswitch/conf.db does not exist ... (warning).
    Aug 28 10:33:00 SRIOV03 runuser[6960]: PAM audit_open() failed: Permission denied
    Aug 28 10:33:00 SRIOV03 ovs-ctl[6929]: Creating empty database /etc/openvswitch/conf.db runuser: System error
    Aug 28 10:33:00 SRIOV03 ovs-ctl[6929]: [FAILED]
    Aug 28 10:33:00 SRIOV03 systemd[1]: ovsdb-server.service: control process exited, code=exited status=1
    Aug 28 10:33:00 SRIOV03 systemd[1]: Failed to start Open vSwitch Database Unit.

可能是selinux有效，将其关闭

    # vim /etc/selinux/config 
    SELINUX=enforcing -> SELINUX=disabled
    # setenforce 0
    # getenforce 
    Permissive
    # systemctl restart openvswitch.service





# 生成vm报ethtool ens4f0错误

    2018-08-28 11:19:51.568 8034 DEBUG oslo_concurrency.processutils [req-cfeb820d-1167-4c32-a336-8fed1120556b - - - - -] u'ethtool ens4f0' failed. Not Retrying. execute /usr/lib/python2.7/site-packages/oslo_concurrency/processutils.py:452
    2018-08-28 11:19:51.568 8034 WARNING nova.virt.extrautils [req-cfeb820d-1167-4c32-a336-8fed1120556b - - - - -] When exec ethtool network card, exception occurs: Unexpected error while running command.

    /etc/nova/nova.conf
    nw_interface_name = ens4f0

改成数据平面的网卡即可




# 创建vm报qemu unexpectedly closed the monitor错误

    | fault                                | {"message": "internal error: qemu unexpectedly closed the monitor: 2018-08-28T04:08:03.821855Z qemu-kvm: -chardev pty,id=charserial0,logfile=/dev/fdset/2,logappend=on: char device redirected to /dev/pts/3 (label charserial0) |
    |                                      | 2018-08-28T04:08:04.024833Z qemu-kvm: -vnc ", "code": 500, "details": "  File \"/usr/lib/python2.7/site-packages/nova/compute/manager.py\", line 1856, in _do_build_and_run_instance                                             |
    |                                      |     filter_properties)                                                                                                                                                                                                           |
    |                                      |   File \"/usr/lib/python2.7/site-packages/nova/compute/manager.py\", line 2086, in _build_and_run_instance                                                                                                                       |
    |                                      |     instance_uuid=instance.uuid, reason=six.text_type(e))  

<!-- more -->

    # vim /var/log/libvirt/libvirtd.log 
    2018-08-28 04:29:31.302+0000: 11230: error : virNetSocketReadWire:1808 : End of file while reading data: Input/output error
    2018-08-28 04:36:25.462+0000: 11235: info : qemuDomainDefineXMLFlags:7286 : Creating domain 'instance-000007bc'
    2018-08-28 04:36:25.779+0000: 11230: error : qemuMonitorIORead:588 : Unable to read from monitor: Connection reset by peer
    2018-08-28 04:36:25.780+0000: 11230: error : qemuProcessReportLogError:1862 : internal error: qemu unexpectedly closed the monitor: 2018-08-28T04:36:25.720940Z qemu-kvm: -chardev pty,id=charserial0,logfile=/dev/fdset/2,logappend=on: char device redirected to /dev/pts/2 (label charserial0)
    2018-08-28T04:36:25.778613Z qemu-kvm: -vnc 10.144.85.92:0: Failed to start VNC server: Failed to bind socket: Cannot assign requested address
    2018-08-28 04:36:26.148+0000: 11239: info : qemuDomainUndefineFlags:7401 : Undefining domain 'instance-000007bc'


因为nova.conf中的vnc ip配置错误

    [vnc]
    enabled = True
    novncproxy_host = 10.144.85.92
    vncserver_proxyclient_address = 10.144.85.92
    vncserver_listen = 10.144.85.92
    novncproxy_base_url = http://10.144.85.238:6080/vnc_auto.html 



# 在新节点上可以生成vm，但登陆到vm，ip获取不到

可能是交换机vlan没有放通




# 并发创建虚机，有一些失败

在log中看到错误为rabbitmq不能端口连接不上

初步定位到是由于rabbitmq压力过大，导致rabbitmq 不能正常工作。现在采取一些措施来改善此情况。

①.把 rabbitmq 的集群的rabbitmq节点2 和节点3 由disc模式改为ram 模式。

②把rabbitmq 压力分散到3个rabbitmq节点。通过查看rabbitmq log 发现在没有修改之前，rabbitmq 压力主要在node01 上，其他两个节点几乎不会处理消息请求。

③把rabbitmq 监控的rate mode 功能关闭。这个rate mode功能监控消息队列中消息输速率。关闭对服务没有影响。

④nova-compute之前配置的[glance] api_servers=vip:9292，vip是管理网地址，当创建虚拟机等并发大时，会出现镜像下载占用管理网通道，导致rabbitmq等网络敏感服务消息阻塞，甚至消息超时，因此，将其api_servers配置为控制节点的存储地址，且把控制节点镜像服务由监听管理网改为监听存储网。

采取以上措施后，进行了测试

1.测试并发创建虚机100 个，虚机创建无一失败

2.测试并发创建卷100个，创建无一失败



# 一台控制节点内存使用率过高告警

一台控制节点内存使用率过高告警，发现是rabbitmq进程异常导致，消息队列中积压的消息过多导致内存增大无法释放，重启rabbitmq进程解决问题，最终解决问题需要修改rabbitmq配置文件，使得积压的消息存储在磁盘中而不是内存中。











# 对云主机进行resize操作没有成功

对一个vm做resize，即从一个小的flavor换一个大的flavor，没有成功

检查云主机所在节点的nova-compute.log

    2017-07-03 17:50:08.573 24296 TRACE oslo_messaging.rpc.dispatcher   File "/usr/lib/python2.7/site-packages/nova/compute/manager.py", line 6959, in _error_out_instance_on_exception
    2017-07-03 17:50:08.573 24296 TRACE oslo_messaging.rpc.dispatcher     raise error.inner_exception
    2017-07-03 17:50:08.573 24296 TRACE oslo_messaging.rpc.dispatcher ResizeError: Resize error: not able to execute ssh command: Unexpected error while running command.
    2017-07-03 17:50:08.573 24296 TRACE oslo_messaging.rpc.dispatcher Command: ssh 172.16.231.26 -p 22 mkdir -p /var/lib/nova/instances/54091e90-55f5-4f4d-8f66-31fbc787584f
    2017-07-03 17:50:08.573 24296 TRACE oslo_messaging.rpc.dispatcher Exit code: 255
    2017-07-03 17:50:08.573 24296 TRACE oslo_messaging.rpc.dispatcher Stdout: u''
    2017-07-03 17:50:08.573 24296 TRACE oslo_messaging.rpc.dispatcher Stderr: u'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\r\n@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @\r\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\r\nIT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!\r\nSomeone could be eavesdropping on you right now (man-in-the-middle attack)!\r\nIt is also possible that a host key has just been changed.\r\nThe fingerprint for the ECDSA key sent by the remote host is\nc8:0b:98:9d:8d:d8:14:89:e6:fe:97:66:22:4e:57:13.\r\nPlease contact your system administrator.\r\nAdd correct host key in /var/lib/nova/.ssh/known_hosts to get rid of this message.\r\nOffending ECDSA key in /var/lib/nova/.ssh/known_hosts:34\r\nPassword authentication is disabled to avoid man-in-the-middle attacks.\r\nKeyboard-interactive authentication is disabled to avoid man-in-the-middle attacks.\r\nPermission denied (publickey,gssapi-keyex,gssapi-with-mic,password).\r\n'



分析原因

可能是计算节点的nova用户的host key改变了

对策

对所有计算节点 删除/var/lib/nova/.ssh/known_hosts 有关计算节点的行，重新用nova用户ssh互相登陆，新增host key并确保nova用户计算节点之间ssh都是互信的








# ceilometer安装好后，启动服务，状态出错


    [root@NFJD-TESTN-COMPUTE-2 ceilometer-2015.1.5]# systemctl restart openstack-ceilometer-compute.service
    [root@NFJD-TESTN-COMPUTE-2 ceilometer-2015.1.5]# systemctl status openstack-ceilometer-compute.service
    ● openstack-ceilometer-compute.service - OpenStack ceilometer compute agent
       Loaded: loaded (/usr/lib/systemd/system/openstack-ceilometer-compute.service; enabled; vendor preset: disabled)
       Active: failed (Result: exit-code) since Fri 2016-12-23 09:39:11 CST; 2s ago
      Process: 8420 ExecStart=/usr/bin/ceilometer-agent-compute --logfile /var/log/ceilometer/compute.log (code=exited, status=1/FAILURE)
     Main PID: 8420 (code=exited, status=1/FAILURE)
    
    Dec 23 09:39:11 NFJD-TESTN-COMPUTE-2 ceilometer-agent-compute[8420]: File "/usr/lib/python2.7/site-packages/ceilometer/cmd/polling.py", line 82, in main_compute
    Dec 23 09:39:11 NFJD-TESTN-COMPUTE-2 ceilometer-agent-compute[8420]: service.prepare_service()
    Dec 23 09:39:11 NFJD-TESTN-COMPUTE-2 ceilometer-agent-compute[8420]: File "/usr/lib/python2.7/site-packages/ceilometer/service.py", line 117, in prepare_service
    Dec 23 09:39:11 NFJD-TESTN-COMPUTE-2 ceilometer-agent-compute[8420]: cfg.CONF(argv[1:], project='ceilometer', validate_default_values=True)
    Dec 23 09:39:11 NFJD-TESTN-COMPUTE-2 ceilometer-agent-compute[8420]: File "/usr/lib/python2.7/site-packages/oslo_config/cfg.py", line 1860, in __call__
    Dec 23 09:39:11 NFJD-TESTN-COMPUTE-2 ceilometer-agent-compute[8420]: self._namespace._files_permission_denied)
    Dec 23 09:39:11 NFJD-TESTN-COMPUTE-2 ceilometer-agent-compute[8420]: oslo_config.cfg.ConfigFilesPermissionDeniedError: Failed to open some config files: /etc/ceilometer/ceilometer.conf
    Dec 23 09:39:11 NFJD-TESTN-COMPUTE-2 systemd[1]: openstack-ceilometer-compute.service: main process exited, code=exited, status=1/FAILURE
    Dec 23 09:39:11 NFJD-TESTN-COMPUTE-2 systemd[1]: Unit openstack-ceilometer-compute.service entered failed state.
    Dec 23 09:39:11 NFJD-TESTN-COMPUTE-2 systemd[1]: openstack-ceilometer-compute.service failed.

conf文件没有权限，修改权限，状态ok。没有权限是因为用root用户从另一台可用的计算节点scp的配置文件。



    [root@NFJD-TESTN-COMPUTE-2 ceilometer-2015.1.5]# chown -R ceilometer:ceilometer /etc/ceilometer
    [root@NFJD-TESTN-COMPUTE-2 ceilometer]# systemctl restart openstack-ceilometer-compute.service
    [root@NFJD-TESTN-COMPUTE-2 ceilometer]# systemctl status openstack-ceilometer-compute.service
    ● openstack-ceilometer-compute.service - OpenStack ceilometer compute agent
       Loaded: loaded (/usr/lib/systemd/system/openstack-ceilometer-compute.service; enabled; vendor preset: disabled)
       Active: active (running) since Fri 2016-12-23 09:42:32 CST; 2s ago
     Main PID: 9459 (ceilometer-agen)
       CGroup: /system.slice/openstack-ceilometer-compute.service
               └─9459 /usr/bin/python /usr/bin/ceilometer-agent-compute --logfile /var/log/ceilometer/compute.log
    
    Dec 23 09:42:32 NFJD-TESTN-COMPUTE-2 systemd[1]: Started OpenStack ceilometer compute agent.
    Dec 23 09:42:32 NFJD-TESTN-COMPUTE-2 systemd[1]: Starting OpenStack ceilometer compute agent...

.. note:: 文件权限问题，如配置文件在更换后没有配置文件权限，例如本来是root:nova的文件所有者，被换成了root:root，一定会出现服务无法正常运行的问题。








# 版本太新导致引用包出错

    | fault                                | {"message": "Build of instance 15d9db88-d0a9-40a8-83e9-9ede3001b112 was re-scheduled: 'module' object has no attribute 'to_utf8'", "code": 500, "details": "  File \"/usr/lib/python2.7/site-packages/nova/compute/manager.py\", line 2258, in _do_build_and_run_instance |
    
    
    2017-05-25 11:30:34.529 32687 TRACE nova.compute.manager [instance: 15d9db88-d0a9-40a8-83e9-9ede3001b112]   File "/usr/lib/python2.7/site-packages/nova/utils.py", line 207, in execute
    2017-05-25 11:30:34.529 32687 TRACE nova.compute.manager [instance: 15d9db88-d0a9-40a8-83e9-9ede3001b112]     return processutils.execute(*cmd, **kwargs)
    2017-05-25 11:30:34.529 32687 TRACE nova.compute.manager [instance: 15d9db88-d0a9-40a8-83e9-9ede3001b112]   File "/usr/lib64/python2.7/site-packages/oslo_concurrency/processutils.py", line 287, in execute
    2017-05-25 11:30:34.529 32687 TRACE nova.compute.manager [instance: 15d9db88-d0a9-40a8-83e9-9ede3001b112]     process_input = encodeutils.to_utf8(process_input)
    2017-05-25 11:30:34.529 32687 TRACE nova.compute.manager [instance: 15d9db88-d0a9-40a8-83e9-9ede3001b112] AttributeError: 'module' object has no attribute 'to_utf8'
    2017-05-25 11:30:34.529 32687 TRACE nova.compute.manager [instance: 15d9db88-d0a9-40a8-83e9-9ede3001b112]
    2017-05-25 11:30:34.531 32687 INFO nova.compute.manager [req-22c24896-bcad-4464-a2ab-c019c45ac0e3 2a2a6d4700034e53a198dac0a71aab6e fe3e50d5fc274d29948ff7fd46b214dc - - -] [instance: 15d9db88-d0a9-40a8-83e9-9ede3001b112] Terminating instance
    
    
    [root@compute-power ~]# vim /usr/lib64/python2.7/site-packages/oslo_concurrency/processutils.py
    284     cwd = kwargs.pop('cwd', None)
    285     process_input = kwargs.pop('process_input', None)
    286     if process_input is not None:
    287         process_input = encodeutils.to_utf8(process_input)
    
    
    [root@compute-power ~]# pip show oslo.concurrency
    Name: oslo.concurrency
    Version: 3.20.0
    Summary: Oslo Concurrency library
    Home-page: http://docs.openstack.org/developer/oslo.concurrency
    Author: OpenStack
    Author-email: openstack-dev@lists.openstack.org
    License: UNKNOWN
    Location: /usr/lib64/python2.7/site-packages
    Requires: pbr, oslo.config, fasteners, oslo.i18n, oslo.utils, six, enum34
    
    
    [root@bc36-compute-3 oslo_concurrency]# pip show oslo.concurrency
    ---
    Name: oslo.concurrency
    Version: 1.8.2
    Location: /usr/lib/python2.7/site-packages
    Requires: 
    ...

oslo.concurrency版本太新，换成老版本解决问题。








# vm error

报错信息：

    Flavor's disk is too small for requested image. Flavor disk is 16106127360 bytes, image is 21474836480 bytes.].

说明创建vm时所使用的Flavor(云主机类型)的磁盘空间不满足image镜像要求！



# No valid host was found

2016-11-01 01:28:38.889 51843 WARNING nova.scheduler.utils [req-9eb2b8ec-216b-4073-95bd-1fbb51844faf 52ba7917bb284af7ad6ac313b7e8e948 0cd3632df93d48d6b2c24c67f70e56b8 - - -] Failed to compute_task_build_instances: No valid host was found. There are not enough hosts available.

这个问题产生的很大原因有：
* 计算节点的内存不足、CPU资源不够、硬盘空间资源不足造成的；将云主机类型规格调小点，发现就能创建成功。
* 网络配置不正确，造成创建虚拟机的时候获取ip失败；网络不通或防火墙引起。
* openstack-nova-compute服务状态问题。可以尝试重启控制节点的nova相关服务和计算节点的openstack-nova-compute服务；详细检查控制节点和计算节点的nova.conf配置是否有不当配置。
* 这个报错问题的原因很多，具体要查看/var/log/nova下的日志详细分析。重点是nova-compute.log、nova-conductor.log日志



# 在nova-scheduler和nova-compute的日志中查看到"ImageNotFound: Image 37aaedc7-6fe6-4fc8-b110-408d166b8e51 could not be found"的报错信息!

    root@controller ~]# /etc/init.d/openstack-glance-api status
    openstack-glance-api (pid  2222) is running...
    [root@controller ~]# /etc/init.d/openstack-glance-registry status
    openstack-glance-registry (pid  2694) is running...

状态正常
 
    [root@controller ~]# glance image-list
    +--------------------------------------+---------------+-------------+------------------+-------------+--------+
    | ID                                   | Name          | Disk Format | Container Format | Size        | Status |
    +--------------------------------------+---------------+-------------+------------------+-------------+--------+
    | 37aaedc7-6fe6-4fc8-b110-408d166b8e51 | cirrors       | qcow2       | bare             | 13200896    | active |
    +--------------------------------------+---------------+-------------+------------------+-------------+--------+

正常工作，尝试upload一个镜像，也能够正常创建vm，原因何在呢？？

因为在运维过程中，修改过glance的默认路径由/var/lib/glance/images修改为/data1/glance,并且将/var/lib/glance/images下的镜像都mv至/data1/glance下了，而此时尽管数据已经前已过去了，但是image的元数据信息却牢牢的记录在glance的image_locations表中，查看得知:

    mysql> select * from glance.image_locations where image_id='37aaedc7-6fe6-4fc8-b110-408d166b8e51'\G;                                                                        
    *************************** 1. row ***************************
            id: 37
      image_id: 37aaedc7-6fe6-4fc8-b110-408d166b8e51
         value: file:///var/lib/glance/images/37aaedc7-6fe6-4fc8-b110-408d166b8e51    #元凶
    created_at: 2015-12-21 06:10:24
    updated_at: 2015-12-21 06:10:24
    deleted_at: NULL
       deleted: 0
     meta_data: {}
        status: active
    1 row in set (0.00 sec)

真像:原来原有目录/var/lib/glance/images目录下的镜像都已经mv至/data1/glance下，而数据库中却依旧记录着就的路径内容，从而，衍生的一个问题：当nova尝试启动一台instance的时候，nova会到instance镜像缓存路径，默认/var/lib/nova/_base下查找是否有该镜像，如果没有则向glance发起result api请求，请求下载指定image的镜像到本地，glance则根据数据库中image_locations所定义的值去查找镜像，从而导致失败！
解决方法:更新glance的元数据信息

    mysql> update glance.image_locations set value='file:///data1/glance/37aaedc7-6fe6-4fc8-b110-408d166b8e51' where image_id='37aaedc7-6fe6-4fc8-b110-408d166b8e51'\G;             
    Query OK, 1 row affected (0.05 sec)
    Rows matched: 1  Changed: 1  Warnings: 0
 
重建虚拟机，故障解决！！！



# 使用config drive 设定了ip，导致ip冲突不能创建vm

    2017-06-22 11:58:50.819 18449 INFO nova.virt.libvirt.driver [req-4edc310f-8382-43ce-a021-8f04c55d5a51 25380a8cde624ae2998224074d4092ee 1cca7b8b0e0d47cb8d6eda06837960ed - - -] [instance: fb28867f-da0f-48f9-b8f8-33704c845117] Using config drive
    ...
    2017-06-22 11:59:16.686 18449 TRACE nova.compute.manager [instance: fb28867f-da0f-48f9-b8f8-33704c845117] FixedIpAlreadyInUse: Fixed IP 172.16.1.4 is already in use.
    2017-06-22 11:59:16.686 18449 TRACE nova.compute.manager [instance: fb28867f-da0f-48f9-b8f8-33704c845117]
    2017-06-22 11:59:16.690 18449 INFO nova.compute.manager [req-4edc310f-8382-43ce-a021-8f04c55d5a51 25380a8cde624ae2998224074d4092ee 1cca7b8b0e0d47cb8d6eda06837960ed - - -] [instance: fb28867f-da0f-48f9-b8f8-33704c845117] Terminating instance
    2017-06-22 11:59:16.698 18449 INFO nova.virt.libvirt.driver [-] [instance: fb28867f-da0f-48f9-b8f8-33704c845117] During wait destroy, instance disappeared.
    2017-06-22 11:59:16.708 18449 INFO nova.virt.libvirt.driver [req-4edc310f-8382-43ce-a021-8f04c55d5a51 25380a8cde624ae2998224074d4092ee 1cca7b8b0e0d47cb8d6eda06837960ed - - -] [instance: fb28867f-da0f-48f9-b8f8-33704c845117] Deleting instance files /var/lib/nova/instances/fb28867f-da0f-48f9-b8f8-33704c845117_del
    2017-06-22 11:59:16.708 18449 INFO nova.virt.libvirt.driver [req-4edc310f-8382-43ce-a021-8f04c55d5a51 25380a8cde624ae2998224074d4092ee 1cca7b8b0e0d47cb8d6eda06837960ed - - -] [instance: fb28867f-da0f-48f9-b8f8-33704c845117] Deletion of /var/lib/nova/instances/fb28867f-da0f-48f9-b8f8-33704c845117_del complete














# 挂载卸载卷失败

    2017-05-09 14:19:13.957 12778 TRACE oslo_messaging.rpc.dispatcher VolumeDeviceNotFound: Volume device not found at [u'/dev/disk/by-path/ip-10.11.23.132:3260-iscsi-iqn.2000-09.com.fujitsu:storage-system.eternus-dx400:00C0C1P0-lun-78', u'/dev/disk/by-path/ip-10.11.23.133:3260-iscsi-iqn.2000-09.com.fujitsu:storage-system.eternus-dx400:00C1C1P0-lun-78'].

查了下可以正常挂载的节点的路由，发现compute-2节点的路由丢了，

    10.11.23.128    10.11.231.1     255.255.255.128 UG    0      0        0 enp17s0f0.607
    10.11.231.0     0.0.0.0         255.255.255.0   U     0      0        0 enp17s0f0.607

添加路由之后，可以成功挂载和卸载

    [root@NFJD-TESTN-COMPUTE-2 ~]# ip a|grep 607
    [root@NFJD-TESTN-COMPUTE-2 ~]# ip link add link enp17s0f0 name enp17s0f0.607 type vlan id 607
    [root@NFJD-TESTN-COMPUTE-2 ~]# ip link set up enp17s0f0.607
    [root@NFJD-TESTN-COMPUTE-2 ~]# ifconfig enp17s0f0 0.0.0.0
    [root@NFJD-TESTN-COMPUTE-2 ~]# ifconfig enp17s0f0.607 10.11.231.26 netmask 255.255.255.0
    [root@NFJD-TESTN-COMPUTE-2 ~]# route add -net 10.11.23.128/25 gw 10.11.231.1 dev enp17s0f0.607
    [root@NFJD-TESTN-COMPUTE-2 ~]# ip a|grep 607
    27: enp17s0f0.607@enp17s0f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1600 qdisc noqueue state UP 
        inet 10.11.231.26/24 brd 10.11.231.255 scope global enp17s0f0.607







# vm挂载卷的时候失败

nova compute节点的nova-compute.log报错如下：

    2017-05-09 15:18:01.952 10888 ERROR nova.virt.block_device [req-344ed875-4bc4-40bf-95e3-a0ff48df6059 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] [instance: ddcf7976-b282-45ac-a167-9865178ed629] Driver failed to attach volume 88442395-87d9-41f1-b9d8-0df4b941846a at /dev/vdc
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629] Traceback (most recent call last):
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629]   File "/usr/lib/python2.7/site-packages/nova/virt/block_device.py", line 276, in attach
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629]     device_type=self['device_type'], encryption=encryption)
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629]   File "/usr/lib/python2.7/site-packages/nova/virt/libvirt/driver.py", line 1210, in attach_volume
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629]     self._connect_volume(connection_info, disk_info)
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629]   File "/usr/lib/python2.7/site-packages/nova/virt/libvirt/driver.py", line 1157, in _connect_volume
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629]     driver.connect_volume(connection_info, disk_info)
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629]   File "/usr/lib/python2.7/site-packages/oslo_concurrency/lockutils.py", line 445, in inner
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629]     return f(*args, **kwargs)
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629]   File "/usr/lib/python2.7/site-packages/nova/virt/libvirt/volume.py", line 505, in connect_volume
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629]     if self.use_multipath:
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629]   File "/usr/lib/python2.7/site-packages/nova/virt/libvirt/volume.py", line 505, in connect_volume
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629]     if self.use_multipath:
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629]   File "/usr/lib64/python2.7/bdb.py", line 49, in trace_dispatch
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629]     return self.dispatch_line(frame)
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629]   File "/usr/lib64/python2.7/bdb.py", line 68, in dispatch_line
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629]     if self.quitting: raise BdbQuit
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629] BdbQuit
    2017-05-09 15:18:01.952 10888 TRACE nova.virt.block_device [instance: ddcf7976-b282-45ac-a167-9865178ed629]

可能谁debug代码的时候加完断点，忘记把断点删除了
去代码中查找，果然如此
删除断点，重启服务，测试可以挂载卷

# 创建vm时报host doesn't support passthrough错误

    | fault                                | {"message": "unsupported configuration: host doesn't support passthrough of host PCI devices", "code": 500, "details": "  File \"/usr/lib/python2.7/site-packages/nova/compute/manager.py\", line 1856, in _do_build_and_run_instance |
    |                                      |     filter_properties) 

这个错误有可能由于母机VT-d (或 IOMMU)未开启导致。
确保"intel_iommu=on"启动参数已经按上文叙述开启。

发现已经修改了/etc/default/grub文件

配置计算节点的/etc/default/grub文件，在GRUB_CMDLINE_LINUX中添加intel_iommu=on来激活VT-d功能，重启物理机

    $ cat /etc/default/grub
    GRUB_TIMEOUT=5
    GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
    GRUB_DEFAULT=saved
    GRUB_DISABLE_SUBMENU=true
    GRUB_TERMINAL_OUTPUT="console"
    GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=bclinux/root rd.lvm.lv=bclinux/swap intel_iommu=on rhgb quiet"
    GRUB_DISABLE_RECOVERY="true"

但是没有重启，不重启不生效

重启后可以正常生成sriov虚拟机

对于intel的cpu和amd的cpu,在grub配置上是不同的,具体的配置请参考文章:http://pve.proxmox.com/wiki/Pci_passthrough

更新grub

在编辑完grub文件后,需要更新

    grub2-mkconfig   # fedora arch centos
    update-grub            # ubuntu debian

重启电脑,使其生效

    # cat /proc/cmdline

