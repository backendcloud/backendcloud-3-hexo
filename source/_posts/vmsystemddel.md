title: vm被systemd删除
date: 2018-04-14 04:30:35
categories:
- Openstack_op
tags:
- qemu
- systemd
- selinux
---

    qemu-kvm: terminating on signal 15 from pid 2146 (/usr/sbin/libvirtd)  这是正常情况
    qemu-kvm: terminating on signal 15 from pid 1 (/usr/lib/systemd/systemd)    一开始不清楚qemu-kvm被systemd终止是发生在什么情况下？

发现计算节点重启后，所有的该节点上的vm被删除了，查看vm对应的qemu日志，qemu-kvm: terminating on signal 15 from pid 1 (/usr/lib/systemd/systemd)
<!-- more -->
与此同时，openvswitch服务出错，控制节点上执行neutron agent-list，计算节点的openvswitch-agent服务状态显示也不是笑脸了，是xxx

```bash
[root@EXTENV-194-18-2-14 ~]# systemctl status openvswitch
● openvswitch.service - Open vSwitch
   Loaded: loaded (/usr/lib/systemd/system/openvswitch.service; enabled; vendor preset: disabled)
   Active: inactive (dead)

Apr 11 10:48:20 EXTENV-194-18-2-14 systemd[1]: Dependency failed for Open vSwitch.
Apr 11 10:48:20 EXTENV-194-18-2-14 systemd[1]: Job openvswitch.service/start failed with result 'dependency'.

# vim /var/log/neutron/openvswitch-agent.log
2018-04-11 10:40:05.512 2726 ERROR neutron.agent.linux.async_process [-] Error received from [ovsdb-client monitor tcp:127.0.0.1:6640 Interface name,ofport,external_ids --format=json]: None
2018-04-11 10:40:05.513 2726 ERROR neutron.agent.linux.async_process [-] Process [ovsdb-client monitor tcp:127.0.0.1:6640 Interface name,ofport,external_ids --format=json] dies due to the error: None
```

根据报错信息网上查有可能是selinux开着。

    # getenforce
    Enforcing

果然开着，是因为selinux导致openvswitch服务不能起来，所有vm被删除

    # setenforce 0
    # getenforce
    Permissive
    # systemctl restart openvswitch
    # systemctl status openvswitch
    ● openvswitch.service - Open vSwitch
       Loaded: loaded (/usr/lib/systemd/system/openvswitch.service; enabled; vendor preset: disabled)
       Active: active (exited) since Wed 2018-04-11 11:17:20 CST; 5s ago
      Process: 4479 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
     Main PID: 4479 (code=exited, status=0/SUCCESS)

发现临时关闭selinux，setenforce 0，openvswitch服务起来了，检查下/etc/sysconfig/selinux文件发现SELINUX=disabled
重启，发现问题仍然存在
/etc/sysconfig/selinux配置了SELINUX=disabled，感觉就像selinux的配置文件不起作用
调查后才明白原因
link文件被scp传来的文本文件替换了
正常的/etc/sysconfig/selinux 配置文件是个link文件

    # ll /etc/sysconfig/selinux
    lrwxrwxrwx. 1 root root 19 Apr 11 09:23 /etc/sysconfig/selinux -> /etc/selinux/config

