title: Openstack运维常见问题记录(3)
date: 2018-09-29 20:28:32
categories:
- Openstack_op
tags:
- Openstack
- devops
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

执行glance命令报http 503错误

    HTTPServiceUnavailable: 503 Service Unavailable: No server is available to handle this request. (HTTP 503)
    503 Service Unavailable: No server is available to handle this request. (HTTP 503)

同事在装Openstack Pike的时候遇到的问题
通过看glance log，发现是rabbitmq没有工作
systemctl status 一下果然没有工作
部署文挡前面的都没有通过，就开始后面的工作，现在需要解决的问题变成为何rabbitmq不能正常工作

看了/var/log/rabbitmq/的log，有这么一段报错

    =ERROR REPORT==== 7-Sep-2018::11:09:01 ===
    Failed to start Ranch listener {acceptor,{0,0,0,0,0,0,0,0},5672} in ranch_tcp:listen([{port,
                                                                                           5672},
                                                                                          {ip,
                                                                                           {0,
                                                                                            0,
                                                                                            0,
                                                                                            0,
                                                                                            0,
                                                                                            0,
                                                                                            0,
                                                                                            0}},
                                                                                          inet6,
                                                                                          {backlog,
                                                                                           128},
                                                                                          {nodelay,
                                                                                           true},
                                                                                          {linger,
                                                                                           {true,
                                                                                            0}},
                                                                                          {exit_on_close,
                                                                                           false}]) for reason eaddrinuse (address already in use)

查看端口5672使用情况，# netstat -tunpl 发现haproxy在使用
rabbitmq自带集群管理，不需要用到haproxy
打开haoroxy的配置文件，发现下面内容没有注视掉

    listen rabbitmq
       option tcpka
       bind 10.144.85.238:5672
       server rabbitmq1 10.144.85.93:5672 check inter 5000 rise 2 fall 3
       server rabbitmq2 10.144.85.162:5672 check inter 5000 rise 2 fall 3 backup
       server rabbitmq3 10.144.85.163:5672 check inter 5000 rise 2 fall 3 backup
       mode tcp
       timeout client 48h
       timeout server 48h
       timeout connect 120s
       balance roundrobin

注释掉后，重启haproxy服务，再执行# netstat -tunpl，没有haproxy进程在占用5672端口

重启rabbitmq服务，还是报错，继续看log，有以下报错

    =WARNING REPORT==== 7-Sep-2018::13:48:17 ===
    Error while waiting for Mnesia tables: {timeout_waiting_for_tables,
                                            [rabbit_user,rabbit_user_permission,
                                             rabbit_vhost,rabbit_durable_route,
                                             rabbit_durable_exchange,
                                             rabbit_runtime_parameters,
                                             rabbit_durable_queue]}

<!-- more -->

解释如下:

    Alternatively, perhaps your mnesia dir (/var/lib/rabbitmq/mnesia/rabbit) 
    got into a a weird state. Try clearing it. 

即分布式数据库mnesia异常。

解决:
(1) 将/var/lib/rabbitmq/mnesia/下的数据库文件清空即可
(2) 重启节点

----


    Sep 27 16:00:00 controller1 haproxy-systemd-wrapper[22727]: [ALERT] 269/160000 (22729) : Error(s) found in configuration file : /etc/haproxy/haproxy.cfg
    Sep 27 16:00:00 controller1 haproxy-systemd-wrapper[22727]: [WARNING] 269/160000 (22729) : parsing [/etc/haproxy/haproxy.cfg:16] : 'option httplog' not usable with proxy 'rabbitmq' (needs 'mode http'). Falling back to 'option tcplog'.
    Sep 27 16:00:00 controller1 haproxy-systemd-wrapper[22727]: [WARNING] 269/160000 (22729) : config : 'option forwardfor' ignored for proxy 'rabbitmq' as it requires HTTP mode.
    Sep 27 16:00:00 controller1 haproxy-systemd-wrapper[22727]: [WARNING] 269/160000 (22729) : config : 'option forwardfor' ignored for proxy 'rdb_mysql' as it requires HTTP mode.
    Sep 27 16:00:00 controller1 haproxy-systemd-wrapper[22727]: [WARNING] 269/160000 (22729) : stats socket will not work as expected in multi-process mode (nbproc > 1), you should force process binding globally using 'stats bind-process' or per socket ...rocess' attribute.
    Sep 27 16:00:00 controller1 haproxy-systemd-wrapper[22727]: [ALERT] 269/160000 (22729) : Fatal errors found in configuration.

将haproxy.cfg的httplog改为tcplog即可

    Sep 27 16:03:19 controller1 haproxy-systemd-wrapper[23196]: [ALERT] 269/160319 (23197) : parsing [/etc/haproxy/haproxy.cfg:18] : unknown keyword 'optionhttp-server-close' in 'defaults' section
    Sep 27 16:03:19 controller1 haproxy-systemd-wrapper[23196]: [ALERT] 269/160319 (23197) : Error(s) found in configuration file : /etc/haproxy/haproxy.cfg
    Sep 27 16:03:19 controller1 haproxy-systemd-wrapper[23196]: [WARNING] 269/160319 (23197) : config : 'option forwardfor' ignored for proxy 'rabbitmq' as it requires HTTP mode.
    Sep 27 16:03:19 controller1 haproxy-systemd-wrapper[23196]: [WARNING] 269/160319 (23197) : config : 'option forwardfor' ignored for proxy 'rdb_mysql' as it requires HTTP mode.
    Sep 27 16:03:19 controller1 haproxy-systemd-wrapper[23196]: [WARNING] 269/160319 (23197) : stats socket will not work as expected in multi-process mode (nbproc > 1), you should force process binding globally using 'stats bind-process' or per socket ...rocess' attribute.

少了一个空格，将optionhttp-server-close改成option http-server-close

----

    Sep 27 16:04:18 controller1 systemd[1]: Starting HAProxy Load Balancer...
    Sep 27 16:04:18 controller1 haproxy-systemd-wrapper[23335]: haproxy-systemd-wrapper: executing /usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid -Ds
    Sep 27 16:04:18 controller1 haproxy-systemd-wrapper[23335]: [WARNING] 269/160418 (23336) : config : 'option forwardfor' ignored for proxy 'rabbitmq' as it requires HTTP mode.
    Sep 27 16:04:18 controller1 haproxy-systemd-wrapper[23335]: [WARNING] 269/160418 (23336) : config : 'option forwardfor' ignored for proxy 'rdb_mysql' as it requires HTTP mode.
    Sep 27 16:04:18 controller1 haproxy-systemd-wrapper[23335]: [WARNING] 269/160418 (23336) : stats socket will not work as expected in multi-process mode (nbproc > 1), you should force process binding globally using 'stats bind-process' or per socket ...rocess' attribute.
    Sep 27 16:04:18 controller1 haproxy-systemd-wrapper[23335]: [ALERT] 269/160418 (23336) : Starting proxy rabbitmq: cannot bind socket [194.18.2.10:5672]

5672是rabbitmq的端口号，rabbitmq自带集群管理，不需要借助haproxy，编辑haproxy.conf将rabbitmq那段注视掉

----

    2018-09-28 10:43:13.996 32177 ERROR nova Traceback (most recent call last):
    2018-09-28 10:43:13.996 32177 ERROR nova   File "/usr/bin/nova-novncproxy", line 10, in <module>
    2018-09-28 10:43:13.996 32177 ERROR nova     sys.exit(main())
    2018-09-28 10:43:13.996 32177 ERROR nova   File "/usr/lib/python2.7/site-packages/nova/cmd/novncproxy.py", line 41, in main
    2018-09-28 10:43:13.996 32177 ERROR nova     port=CONF.vnc.novncproxy_port)
    2018-09-28 10:43:13.996 32177 ERROR nova   File "/usr/lib/python2.7/site-packages/nova/cmd/baseproxy.py", line 67, in proxy
    2018-09-28 10:43:13.996 32177 ERROR nova     RequestHandlerClass=websocketproxy.NovaProxyRequestHandler
    2018-09-28 10:43:13.996 32177 ERROR nova   File "/usr/lib/python2.7/site-packages/websockify/websocket.py", line 973, in start_server
    2018-09-28 10:43:13.996 32177 ERROR nova     tcp_keepintvl=self.tcp_keepintvl)
    2018-09-28 10:43:13.996 32177 ERROR nova   File "/usr/lib/python2.7/site-packages/websockify/websocket.py", line 742, in socket
    2018-09-28 10:43:13.996 32177 ERROR nova     sock.listen(100)
    2018-09-28 10:43:13.996 32177 ERROR nova   File "/usr/lib64/python2.7/socket.py", line 224, in meth
    2018-09-28 10:43:13.996 32177 ERROR nova     return getattr(self._sock,name)(*args)
    2018-09-28 10:43:13.996 32177 ERROR nova error: [Errno 98] Address already in use



    [root@controller1 nova]# netstat -tunpl |grep 6080
    tcp        0      0 194.18.2.10:6080        0.0.0.0:*               LISTEN      24144/haproxy  


    nova.conf
    [vnc]
    novncproxy_host = 194.18.2.11
    vncserver_proxyclient_address = 194.18.2.11
    vncserver_listen = 194.18.2.11

将管理vip改成本机的管理ip

----

    2018-09-29 10:41:55.593 17797 ERROR nova   File "/usr/lib/python2.7/site-packages/amqp/connection.py", line 473, in on_inbound_method
    2018-09-29 10:41:55.593 17797 ERROR nova     method_sig, payload, content,
    2018-09-29 10:41:55.593 17797 ERROR nova   File "/usr/lib/python2.7/site-packages/amqp/abstract_channel.py", line 142, in dispatch_method
    2018-09-29 10:41:55.593 17797 ERROR nova     listener(*args)
    2018-09-29 10:41:55.593 17797 ERROR nova   File "/usr/lib/python2.7/site-packages/amqp/connection.py", line 595, in _on_close
    2018-09-29 10:41:55.593 17797 ERROR nova     (class_id, method_id), ConnectionError)
    2018-09-29 10:41:55.593 17797 ERROR nova AccessRefused: (0, 0): (403) ACCESS_REFUSED - Login was refused using authentication mechanism AMQPLAIN. For details see the broker logfile.

openstack配置的rabbitmq用户不存在或者密码错，或者权限不足。

    [root@controller1 ~]# rabbitmqctl set_policy ha-all '^(?!amq\.).*' '{"ha-mode": "all"}'
    Setting policy "ha-all" for pattern "^(?!amq\\.).*" to "{\"ha-mode\": \"all\"}" with priority "0" ...
    [root@controller1 ~]# rabbitmqctl add_user rabbitMQ123 123456
    Creating user "rabbitMQ123" ...
    [root@controller1 ~]# rabbitmqctl set_permissions rabbitMQ123 ".*" ".*" ".*"
    Setting permissions for user "rabbitMQ123" in vhost "/" ...
    [root@controller1 ~]# 

----

    [root@compute1 neutron]# systemctl status neutron-openvswitch-agent.service
    ● neutron-openvswitch-agent.service - OpenStack Neutron Open vSwitch Agent
       Loaded: loaded (/usr/lib/systemd/system/neutron-openvswitch-agent.service; enabled; vendor preset: disabled)
       Active: failed (Result: start-limit) since Sat 2018-09-29 16:07:57 CST; 4min 5s ago
      Process: 23272 ExecStart=/usr/bin/neutron-openvswitch-agent --config-file /usr/share/neutron/neutron-dist.conf --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/openvswitch_agent.ini --config-dir /etc/neutron/conf.d/common --config-dir /etc/neutron/conf.d/neutron-openvswitch-agent --log-file /var/log/neutron/openvswitch-agent.log (code=exited, status=1/FAILURE)
      Process: 23266 ExecStartPre=/usr/bin/neutron-enable-bridge-firewall.sh (code=exited, status=0/SUCCESS)
     Main PID: 23272 (code=exited, status=1/FAILURE)


    utron-openvswitch-agent: sys.exit(main())
    Sep 29 16:07:58 compute3 neutron-openvswitch-agent: File "/usr/lib/python2.7/site-packages/neutron/cmd/eventlet/plugins/ovs_neutron_agent.py", line 20, in main
    Sep 29 16:07:58 compute3 neutron-openvswitch-agent: agent_main.main()
    Sep 29 16:07:58 compute3 neutron-openvswitch-agent: File "/usr/lib/python2.7/site-packages/neutron/plugins/ml2/drivers/openvswitch/agent/main.py", line 42, in main
    Sep 29 16:07:58 compute3 neutron-openvswitch-agent: common_config.init(sys.argv[1:])
    Sep 29 16:07:58 compute3 neutron-openvswitch-agent: File "/usr/lib/python2.7/site-packages/neutron/common/config.py", line 78, in init
    Sep 29 16:07:58 compute3 neutron-openvswitch-agent: **kwargs)
    Sep 29 16:07:58 compute3 neutron-openvswitch-agent: File "/usr/lib/python2.7/site-packages/oslo_config/cfg.py", line 2473, in __call__
    Sep 29 16:07:58 compute3 neutron-openvswitch-agent: self._namespace._files_permission_denied)
    Sep 29 16:07:58 compute3 neutron-openvswitch-agent: oslo_config.cfg.ConfigFilesPermissionDeniedError: Failed to open some config files: /etc/neutron/plugins/ml2/openvswitch_agent.ini

文件权限归属出错。

    [root@controller1 neutron]# ll /etc/neutron/plugins/ml2/openvswitch_agent.ini
    -rw-r----- 1 root neutron 241 Sep 29 15:47 /etc/neutron/plugins/ml2/openvswitch_agent.ini

    [root@compute2 ~]# ll /etc/neutron/plugins/ml2/openvswitch_agent.ini
    -rw-r----- 1 root root 242 Sep 29 16:07 /etc/neutron/plugins/ml2/openvswitch_agent.ini


----


    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [req-6812937f-30f2-4f49-8303-d1425ebb1357 5563b2f9c80a40729c969df2f3ed71ef 1ada390dc6fb4fe790bcf38777822682 - default default] [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525] Instance failed to spawn: TypeError: 'NoneType' object is not iterable
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525] Traceback (most recent call last):
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/nova/compute/manager.py", line 2192, in _build_resources
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     yield resources
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/nova/compute/manager.py", line 2007, in _build_and_run_instance
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     block_device_info=block_device_info)
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/nova/virt/libvirt/driver.py", line 2802, in spawn
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     block_device_info=block_device_info)
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/nova/virt/libvirt/driver.py", line 3240, in _create_image
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     fallback_from_host)
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/nova/virt/libvirt/driver.py", line 3331, in _create_and_inject_local_root
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     instance, size, fallback_from_host)
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/nova/virt/libvirt/driver.py", line 6987, in _try_fetch_image_cache
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     size=size)
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/nova/virt/libvirt/imagebackend.py", line 241, in cache
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     *args, **kwargs)
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/nova/virt/libvirt/imagebackend.py", line 595, in create_image
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     prepare_template(target=base, *args, **kwargs)
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/oslo_concurrency/lockutils.py", line 271, in inner
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     return f(*args, **kwargs)
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/nova/virt/libvirt/imagebackend.py", line 237, in fetch_func_sync
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     fetch_func(target=target, *args, **kwargs)
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/nova/virt/libvirt/utils.py", line 446, in fetch_image
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     images.fetch_to_raw(context, image_id, target)
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/nova/virt/images.py", line 144, in fetch_to_raw
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     fetch(context, image_href, path_tmp)
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/nova/virt/images.py", line 135, in fetch
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     IMAGE_API.download(context, image_href, dest_path=path)
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/nova/image/api.py", line 184, in download
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     dst_path=dest_path)
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/nova/image/glance.py", line 366, in download
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     {'path': dst_path, 'exception': ex})
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/oslo_utils/excutils.py", line 220, in __exit__
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     self.force_reraise()
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/oslo_utils/excutils.py", line 196, in force_reraise
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     six.reraise(self.type_, self.value, self.tb)
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]   File "/usr/lib/python2.7/site-packages/nova/image/glance.py", line 350, in download
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525]     for chunk in image_chunks:
    2018-09-29 16:27:58.982 18928 ERROR nova.compute.manager [instance: dc3db2cd-4473-4d13-9ecf-4f602e457525] TypeError: 'NoneType' object is not iterable

glance用了本地存储，glance-api在三个节点上启用，并配置了haproxy。
将haproxy对应位置，注释掉两个节点即可

    listen glance_api
    bind 194.18.2.10:9292
    balance roundrobin
    option httplog
    server glance1 194.18.2.11:9292 check inter 2000 rise 2 fall 3
    #server glance2 194.18.2.12:9292 check inter 2000 rise 2 fall 3
    #server glance3 194.18.2.13:9292 check inter 2000 rise 2 fall 3

----

    2018-09-30 15:38:28.505 17135 ERROR cinder   File "/usr/lib/python2.7/site-packages/pymysql/cursors.py", line 322, in _query
    2018-09-30 15:38:28.505 17135 ERROR cinder     conn.query(q)
    2018-09-30 15:38:28.505 17135 ERROR cinder   File "/usr/lib/python2.7/site-packages/pymysql/connections.py", line 856, in query
    2018-09-30 15:38:28.505 17135 ERROR cinder     self._affected_rows = self._read_query_result(unbuffered=unbuffered)
    2018-09-30 15:38:28.505 17135 ERROR cinder   File "/usr/lib/python2.7/site-packages/pymysql/connections.py", line 1057, in _read_query_result
    2018-09-30 15:38:28.505 17135 ERROR cinder     result.read()
    2018-09-30 15:38:28.505 17135 ERROR cinder   File "/usr/lib/python2.7/site-packages/pymysql/connections.py", line 1340, in read
    2018-09-30 15:38:28.505 17135 ERROR cinder     first_packet = self.connection._read_packet()
    2018-09-30 15:38:28.505 17135 ERROR cinder   File "/usr/lib/python2.7/site-packages/pymysql/connections.py", line 1014, in _read_packet
    2018-09-30 15:38:28.505 17135 ERROR cinder     packet.check_error()
    2018-09-30 15:38:28.505 17135 ERROR cinder   File "/usr/lib/python2.7/site-packages/pymysql/connections.py", line 393, in check_error
    2018-09-30 15:38:28.505 17135 ERROR cinder     err.raise_mysql_exception(self._data)
    2018-09-30 15:38:28.505 17135 ERROR cinder   File "/usr/lib/python2.7/site-packages/pymysql/err.py", line 107, in raise_mysql_exception
    2018-09-30 15:38:28.505 17135 ERROR cinder     raise errorclass(errno, errval)
    2018-09-30 15:38:28.505 17135 ERROR cinder ProgrammingError: (pymysql.err.ProgrammingError) (1146, u"Table 'cinder.services' doesn't exist") [SQL: u'SELECT services.created_at AS services_created_at, services.deleted_at AS services_deleted_at, services.deleted AS services_deleted, services.id AS services_id, services.cluster_name AS services_cluster_name, services.host AS services_host, services.`binary` AS services_binary, services.updated_at AS services_updated_at, services.topic AS services_topic, services.report_count AS services_report_count, services.disabled AS services_disabled, services.availability_zone AS services_availability_zone, services.disabled_reason AS services_disabled_reason, services.modified_at AS services_modified_at, services.rpc_current_version AS services_rpc_current_version, services.object_current_version AS services_object_current_version, services.replication_status AS services_replication_status, services.active_backend_id AS services_active_backend_id, services.frozen AS services_frozen \nFROM services \nWHERE services.deleted = false AND services.`binary` = %(binary_1)s'] [parameters: {u'binary_1': 'cinder-scheduler'}]

cinder api，volume，scheduer三个日志文件都报如上错误，像是cinder服务连接数据库出错

首先查看cinder.conf中数据库连接的信息配置有没有错误，确认配置无误后。

查看不到cinder服务的端口号

    [root@controller2 opt]# netstat -tunpl |grep 8776
    [root@controller2 opt]# 

登陆数据库也查不到cinder的表数据

    MariaDB [(none)]> use cinder;
    Database changed
    MariaDB [cinder]> show tables;
    Empty set (0.01 sec)

    MariaDB [cinder]>

重新执行下面的命令后，恢复正常，可能该命令没有执行或者执行错节点了。

    # su -s /bin/sh -c "cinder-manage db sync" cinder

