title: OpenStack Pike dashboard noVNC 不能访问
date: 2018-04-14 05:18:22
categories:
- Openstack_op
tags:
- Pike
- noVNC
---
现象：openstack dashboard novnc不能查看，报Failed to connect to server (code: 1006)错误

查看日志：
3个controller节点的consoleauth日志信息如下：
token过期或者false

根据下面的vncproxy运行流程，应该是第10步nova-consoleauth cache的token和第14步的check token出错了。
<!-- more -->
VNC Proxy的功能：

* 将公网(public network)和私网(private network)隔离
* VNC client运行在公网上，VNCServer运行在私网上，VNC Proxy作为中间的桥梁将二者连接起来
* VNC Proxy通过token对VNC Client进行验证
* VNC Proxy不仅仅使得私网的访问更加安全，而且将具体的VNC Server的实现分离，可以支持不同Hypervisor的VNC Server但不影响用户体验

VNC Proxy的部署

* 在Controller节点上部署nova-consoleauth 进程，用于Token验证
* 在Controller节点上部署nova-novncproxy 服务，用户的VNC Client会直接连接这个服务
* Controller节点一般有两张网卡，连接到两个网络，一张用于外部访问，我们称为public network，或者API network，这张网卡的IP地址是外网IP，如图中172.24.1.1，另外一张网卡用于openstack各个模块之间的通信，称为management network，一般是内网IP，如图中10.10.10.2
* 在Compute节点上部署nova-compute，在nova.conf文件中有下面的配置
    * vnc_enabled=True
    * vncserver_listen=0.0.0.0 //VNC Server的监听地址
    * vncserver_proxyclient_address=10.10.10.2 //nova vnc proxy是通过内网IP来访问vnc server的，所以nova-compute会告知vnc proxy用这个IP来连接我。
    * novncproxy_base_url=http://172.24.1.1:6080/vnc_auto.html //这个url是返回给客户的url，因而里面的IP是外网IP

VNC Proxy的运行过程：

1.一个用户试图从浏览器里面打开连接到虚拟机的VNC Client
2.浏览器向nova-api发送请求，要求返回访问vnc的url
3.nova-api调用nova-compute的get vnc console方法，要求返回连接VNC的信息
4.nova-compute调用libvirt的get vnc console函数
5.libvirt会通过解析虚拟机运行的/etc/libvirt/qemu/instance-0000000c.xml文件来获得VNC Server的信息
6.libvirt将host, port等信息以json格式返回给nova-compute
7.nova-compute会随机生成一个UUID作为Token
8.nova-compute将libvirt返回的信息以及配置文件中的信息综合成connect_info返回给nova-api
9.nova-api会调用nova-consoleauth的authorize_console函数
10.nova-consoleauth会将instance –> token, token –> connect_info的信息cache起来
11.nova-api将connect_info中的access url信息返回给浏览器：http://172.24.1.1:6080/vnc_auto.html?token=7efaee3f-eada-4731-a87c-e173cbd25e98&title=helloworld%289169fdb2-5b74-46b1-9803-60d2926bd97c%29
12.浏览器会试图打开这个链接
13.这个链接会将请求发送给nova-novncproxy
14.nova-novncproxy调用nova-consoleauth的check_token函数
15.nova-consoleauth验证了这个token，将这个instance对应的connect_info返回给nova-novncproxy
16.nova-novncproxy通过connect_info中的host, port等信息，连接compute节点上的VNC Server，从而开始了proxy的工作

可能是控制节点高可用部署可能是memcache没配或者配错了
调查发现果然是配置项错了一个字母
/etc/nova/nova.conf中的配置项 `memcached_servers` 改成 `memcache_servers` 后novnc就可以访问了
感觉O版还是`memcached_`，到了P版就改成了`memcache_`

    Option memcached_servers is deprecated in Mitaka. Operators should use oslo.cache configuration instead. Specifically enabled option under [cache] section should be set to True and the url(s) for the memcached servers should be in [cache]/memcache_servers option.

    https://docs.openstack.org/oslo.cache/1.16.0/opts.html
    memcache_servers
    Type:   list
    Default:    localhost:11211
    Memcache servers in the format of “host:port”. (dogpile.cache.memcache and oslo_cache.memcache_pool backends only).

