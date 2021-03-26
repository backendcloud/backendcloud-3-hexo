title: 虚拟机无法启动
date: 2018-04-14 03:15:39
categories:
- Openstack_op
tags:
- selinux
---

由于kvm所在的机器启用了SELINUX，后来将之关闭，关闭之后，发现kvm的虚拟机无法启动

# 现象
虚拟机无法启动

# 报错信息
启动过程中的报错信息如下：
<!-- more -->

```bash
[root@ESRoller ~]# virsh start zabbix
error: Failed to start domain zabbix
error: unsupported configuration: Unable to find security driver for label selinux

libvirt中的日志也提示报错：
[root@ESRoller ~]# tail -f /var/log/libvirt/libvirtd.log
2016-06-20 09:54:41.724+0000: 2388: error : qemuRemoveCgroup:754 : internal error Unable to find cgroup for zabbix
2016-06-20 09:54:41.724+0000: 2388: warning : qemuProcessStop:4403 : Failed to remove cgroup for zabbix
2016-06-20 09:54:41.725+0000: 2388: error : qemuAutostartDomain:284 : Failed to autostart VM 'zabbix': unsupported configuration: Unable to find security driver for label selinux
2016-06-20 09:54:41.734+0000: 2388: error : virSecurityManagerGenLabel:376 : unsupported configuration: Unable to find security driver for label selinux
2016-06-20 09:54:41.741+0000: 2388: error : qemuRemoveCgroup:754 : internal error Unable to find cgroup for roller
2016-06-20 09:54:41.741+0000: 2388: warning : qemuProcessStop:4403 : Failed to remove cgroup for roller
2016-06-20 09:54:41.742+0000: 2388: error : qemuAutostartDomain:284 : Failed to autostart VM 'roller': unsupported configuration: Unable to find security driver for label selinux
2016-06-20 09:59:07.548+0000: 2378: error : virSecurityManagerGenLabel:376 : unsupported configuration: Unable to find security driver for label selinux
2016-06-20 09:59:07.561+0000: 2378: error : qemuRemoveCgroup:754 : internal error Unable to find cgroup for zabbix
```

# 造成原因
  由于机器开机状态时，将SElinux的状态信息save在虚拟机中，导致SElinux关闭之后，虚拟找不到对应的label，从而导致vm启动失败。

# 解决方法
  virsh edit domain_name查看虚拟机的配置文件中，是否有selinux标签的相关设置，如果有，则将其删除，再启动vm。如果没有，则可能已经保存在vm状态中，将原有的状态删除即可(对应路径/var/lib/libvirt/qemu/save)，如下：

```bash
[root@ESRoller ~]# virsh managedsave-remove zabbix
Removed managedsave image for domain zabbix
 
[root@ESRoller ~]# virsh start zabbix
Domain zabbix started
 
[root@ESRoller ~]# virsh list 
 Id    Name                           State
----------------------------------------------------
 4     zabbix                         running
```

如果配置配置文件中有selinux相关的配置，将其删除，期配置类似于：

```bash
<seclabel type='dynamic' model='selinux' relabel='yes'>
    <label>system_u:system_r:svirt_t:s0:c625,c859</label>
    <imagelabel>system_u:object_r:svirt_image_t:s0:c625,c859</imagelabel>
</seclabel>
```
