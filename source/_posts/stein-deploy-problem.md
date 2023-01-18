title: Openstack Stein 部署遇到的问题
date: 2019-09-20 18:49:06
categories: Openstack_op
tags:
- Stein
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

OpenStack 的第 19 个版本 Stein，支持 5G 和边缘计算。
OpenStack Stein 强化裸机和网络管理性能，同时更快速的启动 Kubernetes 集群，还为边缘计算和 NFV 用例提供网络升级功能，增强了资源管理和跟踪性能。

**OS版本：CentOS 7.7 ( CentOS Linux release 7.7.1908 )**
**Openstack版本：Stein**

# compute节点部署完nova-compute，启动时卡住

查看nova-compute.log日志，报消息队列错误

```bash
2019-09-20 13:38:32.411 68483 INFO os_vif [-] Loaded VIF plugins: ovs, linux_bridge, noop
2019-09-20 13:38:32.878 68483 ERROR oslo.messaging._drivers.impl_rabbit [req-b955a570-83bc-4a14-966f-2eefe5a82579 - - - - -] Connection failed: [Errno 113] EHOSTUNREACH (retrying in 2.0 seconds): error: [Errno 113] EHOSTUNREACH
2019-09-20 13:38:34.888 68483 ERROR oslo.messaging._drivers.impl_rabbit [req-b955a570-83bc-4a14-966f-2eefe5a82579 - - - - -] Connection failed: [Errno 113] EHOSTUNREACH (retrying in 4.0 seconds): error: [Errno 113] EHOSTUNREACH
2019-09-20 13:38:38.899 68483 ERROR oslo.messaging._drivers.impl_rabbit [req-b955a570-83bc-4a14-966f-2eefe5a82579 - - - - -] Connection failed: [Errno 113] EHOSTUNREACH (retrying in 6.0 seconds): error: [Errno 113] EHOSTUNREACH
2019-09-20 13:38:44.912 68483 ERROR oslo.messaging._drivers.impl_rabbit [req-b955a570-83bc-4a14-966f-2eefe5a82579 - - - - -] Connection failed: [Errno 113] EHOSTUNREACH (retrying in 8.0 seconds): error: [Errno 113] EHOSTUNREACH
2019-09-20 13:38:52.931 68483 ERROR oslo.messaging._drivers.impl_rabbit [req-b955a570-83bc-4a14-966f-2eefe5a82579 - - - - -] Connection failed: [Errno 113] EHOSTUNREACH (retrying in 10.0 seconds): error: [Errno 113] EHOSTUNREACH
```

查看nova配置文件，rabbitmq配置正确的，登陆controller节点，查看nova服务的日志，并没有报消息队列的错误
对比controller节点和compute节点rabbitmq的配置，一样的，controller节点不报错，compute节点报错。而controller节点上部署了消息队列服务，想到可能是防火墙导致compute节点的nova服务不能访问controller节点的mq服务
查看，果然没有将防火墙关闭，关闭后问题解决。



# compute节点部署完nova-compute，执行nova service-list，计算节点服务正常，但是计算节点的nova日志报错，和资源有关，感觉是和placement服务有关

```bash
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager [req-128f79a5-8b18-471b-9967-aae3cfde3043 - - - - -] Error updating resources for node compute.: ResourceProviderRetrievalFailed: Failed to get resource provider with UUID 092506db-b8fe-49d3-a962-9182e0025dea
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager Traceback (most recent call last):
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager   File "/usr/lib/python2.7/site-packages/nova/compute/manager.py", line 8148, in _update_available_resource_for_node
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager     startup=startup)
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager   File "/usr/lib/python2.7/site-packages/nova/compute/resource_tracker.py", line 744, in update_available_resource
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager     self._update_available_resource(context, resources, startup=startup)
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager   File "/usr/lib/python2.7/site-packages/oslo_concurrency/lockutils.py", line 328, in inner
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager     return f(*args, **kwargs)
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager   File "/usr/lib/python2.7/site-packages/nova/compute/resource_tracker.py", line 825, in _update_available_resource
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager     self._update(context, cn, startup=startup)
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager   File "/usr/lib/python2.7/site-packages/nova/compute/resource_tracker.py", line 1032, in _update
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager     self._update_to_placement(context, compute_node, startup)
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager   File "/usr/lib/python2.7/site-packages/retrying.py", line 68, in wrapped_f
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager     return Retrying(*dargs, **dkw).call(f, *args, **kw)
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager   File "/usr/lib/python2.7/site-packages/retrying.py", line 223, in call
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager     return attempt.get(self._wrap_exception)
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager   File "/usr/lib/python2.7/site-packages/retrying.py", line 261, in get
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager     six.reraise(self.value[0], self.value[1], self.value[2])
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager   File "/usr/lib/python2.7/site-packages/retrying.py", line 217, in call
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager     attempt = Attempt(fn(*args, **kwargs), attempt_number, False)
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager   File "/usr/lib/python2.7/site-packages/nova/compute/resource_tracker.py", line 958, in _update_to_placement
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager     context, compute_node.uuid, name=compute_node.hypervisor_hostname)
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager   File "/usr/lib/python2.7/site-packages/nova/scheduler/client/report.py", line 873, in get_provider_tree_and_ensure_root
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager     parent_provider_uuid=parent_provider_uuid)
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager   File "/usr/lib/python2.7/site-packages/nova/scheduler/client/report.py", line 655, in _ensure_resource_provider
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager     rps_to_refresh = self._get_providers_in_tree(context, uuid)
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager   File "/usr/lib/python2.7/site-packages/nova/scheduler/client/report.py", line 71, in wrapper
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager     return f(self, *a, **k)
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager   File "/usr/lib/python2.7/site-packages/nova/scheduler/client/report.py", line 522, in _get_providers_in_tree
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager     raise exception.ResourceProviderRetrievalFailed(uuid=uuid)
2019-09-20 14:20:24.477 69378 ERROR nova.compute.manager ResourceProviderRetrievalFailed: Failed to get resource provider with UUID 092506db-b8fe-49d3-a962-9182e0025dea
```

网上搜下该问题，和权限有关

```bash
# vim /etc/httpd/conf.d/00-placement-api.conf
# add
<Directory /usr/bin>
    <IfVersion >= 2.4>
        Require all granted
    </IfVersion>
    <IfVersion < 2.4>
        Order allow,deny
        Allow from all
    </IfVersion>
</Directory>
# su -s /bin/sh -c "placement-manage db sync" placement
# systemctl restart httpd
```

修改后，问题解决



# sysctl: cannot stat /proc/sys/net/bridge/bridge-nf-call-iptables: No such file or directory

在/etc/sysctl.conf中添加：

```bash
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
执行sysctl -p 时出现：
[root@localhost ~]# sysctl -p
sysctl: cannot stat /proc/sys/net/bridge/bridge-nf-call-ip6tables: No such file or directory
sysctl: cannot stat /proc/sys/net/bridge/bridge-nf-call-iptables: No such file or directory
解决方法：

[root@localhost ~]# modprobe br_netfilter
[root@localhost ~]# sysctl -p
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
```

重启后模块失效，下面是开机自动加载模块的脚本

在/etc/新建rc.sysinit 文件

cat /etc/rc.sysinit

```bash
#!/bin/bash
for file in /etc/sysconfig/modules/*.modules ; do
[ -x $file ] && $file
done
在/etc/sysconfig/modules/目录下新建文件如下

cat /etc/sysconfig/modules/br_netfilter.modules
modprobe br_netfilter
增加权限

chmod 755 br_netfilter.modules
重启后 模块自动加载

[root@localhost ~]# lsmod |grep br_netfilter
br_netfilter           22209  0
bridge                136173  1 br_netfilter
```

# openstack虚拟机实例卡在系统引导，不能启动操作系统

显示
booting from hard disk...
GRUB

无论是网上下载的cirros镜像，还是自己安装再上载创建的linux，windows镜像，都不能启动，卡了一段时间，转战实体机，直接在裸机上安装linux，再安装openstack，一切正常，虚拟机实例都正常启动，（windows 都需安装virtio驱动）。

回过头来解决这个vmware上的虚拟机上安装的openstack不能启动实例操作系统的问题，确认了解决方向，就是虚拟磁盘格式和驱动程序的问题，通过 virsh edit XXXX 的方法，可见不能启动的虚拟机是采用virtio驱动程序

把它改为 <target dev='hdb'  bus='ide'>  再 virsh start XXX 启动虚拟机，可以正常启动，但很快，不到1分钟内实例被自动关闭，如且无论virsh edit XXX修改，还是修改 /etc/libvirt/qemu/instan-00000002.xml 这个虚拟机定义文件，在openstack界面启动实例后都自动恢复为原来的配置文件。

最后找到一个办法，直接修改镜像文件的参数属性，指定硬盘和网卡的属性：

    # openstack image set  --property hw_disk_bus=ide  --property hw_vif_model=e1000 <image-id>

这个命令修改硬盘属性为ide，网卡属性为e1000

再用这个修改属性后的镜像生成虚拟机实例，ok，能正常引导系统，能识别虚拟硬盘了。
