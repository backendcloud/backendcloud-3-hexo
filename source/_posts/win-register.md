title: windows虚拟机激活失败问题
date: 2017-05-04 22:21:24
categories: Openstack_op
tags:
- windows
---

# 问题调查

## 直接原因
关于Windows虚机激活的问题分析，进行调研后总结如下：Windows 虚机在使用KMS激活方式进行激活时其与KMS Server服务器的时间如果同步则激活成功，但经过我们调查发现，由于云环境中，windows虚机时间与物理机的时间存在偏差，所以导致激活失败。

## 具体时间偏差
Windows instance 有时候会发现操作系统时间总是慢 8 个小时，即使手工调整好时间和时区，下次 instance 重启后又会差 8 个小时。


## 为何出现时间偏差呢？

KVM 对 Linux 和 Windows 虚拟机在系统时间上处理有所不同，Windows 需要额外一些设置。
为何Linux 和 Windows 虚拟机在系统时间上处理有所不同呢？要了解下面三个概念。

### UTC时间 与 本地时间

UTC时间：又称世界标准时间、世界统一时间，UTC是以原子钟校准的，世界其它地区是以此为基准时间加上自己时区来设置其本地时间的

本地时间：由于处在不同的时区，本地时间一般与UTC是不同的，换算方法就是

本地时间 = UTC + 时区 或 UTC = 本地时间 - 时区
时区东为正，西为负，在中国，时区为东八区，也就是 +8区，本地时间都使用北京时间，在linux上显示就是 CST, 所以CST=UTC+(+8小时) 或 UTC=CST-(+8小时)



### guest OS时间保持

kvm技术是全虚拟化，guest OS并不需要做修改就可以直接运行，然而在计时方面却存在问题，guest OS计时的一种方式是通过时钟中断计数，进而换算得到，但host产生的时钟中断不能及时到达所有guest OS，因为guest OS中的中断并不是真正的硬件中断，它是由host注入的中断

许多网络应用，web中的sessions验证等，都会调用系统时间，guest OS中若时间有误，则会引起程序出错，为此，kvm给guest vms提供了一个半虚拟化时钟(kvm-clock),在RHEL5.5及其以上版本中，都使用了kvm-clock作为默认时钟源，可以在guest 中使用下面命令查看是否使用了kvm-clock

    cat /sys/devices/system/clocksource/clocksource0/current_clocksource
    kvm-clock

在kvm-clock方式下，guest OS不能直接访问Host时钟，Host把系统时间写入一个guest可以读取的内存页，这样guest就可以读取此内存页设置自身硬件时间，但是Host并不是实时更新时间到此内存页，而是在发生一个vm event(vm关机，重启等)时才更新，因此此种方式也不能保持guest时间准确无误



### libvirt中设置虚拟机硬件时钟

kvm虚拟机一般使用libvirt进行管理，在虚拟机配置的xml文件中，有关于虚拟机硬件时钟设置项

    <clock offset='localtime'>
    </clock>

clock的offset属性有"utc","localtime","timezone","variable"四个可选项

如果guest OS是Linux系统，应该选用"utc"，guest OS在启动时便会向host同步一次utc时间，然后根据/etc/localtime中设置的时区，来计算系统时间

如果guest OS是windows系统，则应该选用"localtime"，guest OS在启动时向host同步一次系统时间



# openstack云环境下的对策

知道了问题的前因后果，只需要在openstack上加以配置即可。分两类情况，新建的windows虚拟机和存量的windows虚拟机。



## 对于新建windows虚拟机

就是对已有的windows镜像和以后新建的windows镜像，添加os_type="windows"信息

    [root@build localhost]# glance image-update  --property os_type="windows" 1d2afd0f-9162-415c-ace3-97de254b6c9c
    1d2afd0f-9162-415c-ace3-97de254b6c9c 是vm id



## 对于存量的windows虚拟机

要通过暴力修改数据库的办法，具体方案：
（1）   找出要修改的全部的存量windows虚拟机的uuid信息
（2）   进入nova数据库，修改instances表的windows虚拟机的os_type字段，将该字段修改为windows
例如修改windows vm id为f64bf83d-a9f0-4ec5-b481-e3e76e19b6bd 的vm的os_type字段为windows
update instances set os_type='windows' where uuid=' f64bf83d-a9f0-4ec5-b481-e3e76e19b6bd ';
（3）   检查os_type字段是否被修改成’windows’
例如select * from instances where uuid='f64bf83d-a9f0-4ec5-b481-e3e76e19b6bd';
（4）   硬重启虚机，需提前联系客户
    # nova reboot f64bf83d-a9f0-4ec5-b481-e3e76e19b6bd --hard –poll
重启原因：KVM 会获取修改后的数据库信息，更新 XML 配置，保证时间同步。



# 测试：nova boot生成的vm是否会带有image的keyword

    [root@NFJD-TESTVM-CORE-API-1 ~]# glance image-update --property os_type="windows" fb5bc637-c8ab-4999-9e88-da28561fed21
    +---------------------+--------------------------------------------------+
    | Property            | Value                                            |
    +---------------------+--------------------------------------------------+
    | checksum            | 8049db08971bec254be86067025d0c32                 |
    | container_format    | bare                                             |
    | created_at          | 2016-07-12T06:16:50Z                             |
    | direct_url          | sheepdog://fb5bc637-c8ab-4999-9e88-da28561fed21  |
    | disk_format         | qcow2                                            |
    | hw_qemu_guest_agent | yes                                              |
    | id                  | fb5bc637-c8ab-4999-9e88-da28561fed21             |
    | image.os_type       | windows                                          |
    | min_disk            | 0                                                |
    | min_ram             | 0                                                |
    | name                | Windows-Server-2008-R2-Enterprise-64bit-20160706 |
    | os_distro           | windows                                          |
    | os_type             | windows                                          |
    | owner               | 6c149dcd3cf64171b8dd972dd03bbac0                 |
    | protected           | False                                            |
    | size                | 10015539200                                      |
    | status              | active                                           |
    | tags                | []                                               |
    | updated_at          | 2017-05-05T03:42:50Z                             |
    | virtual_size        | None                                             |
    | visibility          | public                                           |
    +---------------------+--------------------------------------------------+
    [root@NFJD-TESTVM-CORE-API-1 ~]# nova image-show fb5bc637-c8ab-4999-9e88-da28561fed21
    +------------------------------+--------------------------------------------------+
    | Property                     | Value                                            |
    +------------------------------+--------------------------------------------------+
    | OS-EXT-IMG-SIZE:size         | 10015539200                                      |
    | created                      | 2016-07-12T06:16:50Z                             |
    | id                           | fb5bc637-c8ab-4999-9e88-da28561fed21             |
    | metadata hw_qemu_guest_agent | yes                                              |
    | metadata image.os_type       | windows                                          |
    | metadata os_distro           | windows                                          |
    | metadata os_type             | windows                                          |
    | minDisk                      | 0                                                |
    | minRam                       | 0                                                |
    | name                         | Windows-Server-2008-R2-Enterprise-64bit-20160706 |
    | progress                     | 100                                              |
    | status                       | ACTIVE                                           |
    | updated                      | 2017-05-05T03:42:50Z                             |
    +------------------------------+--------------------------------------------------+
    [root@NFJD-TESTVM-CORE-API-1 ~]# nova boot --image fb5bc637-c8ab-4999-9e88-da28561fed21 --flavor 3 --nic net-id=ee98ec6a-e1ed-43eb-9d0a-26080d277484 t4 --availability-zone nova:NFJD-TESTN-COMPUTE-3
    +--------------------------------------+-----------------------------------------------------------------------------------------+
    | Property                             | Value                                                                                   |
    +--------------------------------------+-----------------------------------------------------------------------------------------+
    | OS-DCF:diskConfig                    | MANUAL                                                                                  |
    | OS-EXT-AZ:availability_zone          | nova                                                                                    |
    | OS-EXT-SRV-ATTR:host                 | -                                                                                       |
    | OS-EXT-SRV-ATTR:hypervisor_hostname  | -                                                                                       |
    | OS-EXT-SRV-ATTR:instance_name        | instance-000056dc                                                                       |
    | OS-EXT-STS:power_state               | 0                                                                                       |
    | OS-EXT-STS:task_state                | scheduling                                                                              |
    | OS-EXT-STS:vm_state                  | building                                                                                |
    | OS-SRV-USG:launched_at               | -                                                                                       |
    | OS-SRV-USG:terminated_at             | -                                                                                       |
    | accessIPv4                           |                                                                                         |
    | accessIPv6                           |                                                                                         |
    | adminPass                            | DoLL3d65w7cN                                                                            |
    | config_drive                         |                                                                                         |
    | created                              | 2017-05-05T03:46:42Z                                                                    |
    | flavor                               | m1.medium (3)                                                                           |
    | hostId                               |                                                                                         |
    | id                                   | f64bf83d-a9f0-4ec5-b481-e3e76e19b6bd                                                    |
    | image                                | Windows-Server-2008-R2-Enterprise-64bit-20160706 (fb5bc637-c8ab-4999-9e88-da28561fed21) |
    | key_name                             | -                                                                                       |
    | metadata                             | {}                                                                                      |
    | name                                 | t4                                                                                      |
    | os-extended-volumes:volumes_attached | []                                                                                      |
    | progress                             | 0                                                                                       |
    | security_groups                      | default                                                                                 |
    | status                               | BUILD                                                                                   |
    | tenant_id                            | 6c149dcd3cf64171b8dd972dd03bbac0                                                        |
    | updated                              | 2017-05-05T03:46:43Z                                                                    |
    | user_id                              | 62f52135115f4898bd0d82c1f0cd632b                                                        |
    +--------------------------------------+-----------------------------------------------------------------------------------------+
    [root@NFJD-TESTVM-CORE-API-1 ~]# nova show t4
    +--------------------------------------+-----------------------------------------------------------------------------------------+
    | Property                             | Value                                                                                   |
    +--------------------------------------+-----------------------------------------------------------------------------------------+
    | OS-DCF:diskConfig                    | MANUAL                                                                                  |
    | OS-EXT-AZ:availability_zone          | nova                                                                                    |
    | OS-EXT-SRV-ATTR:host                 | NFJD-TESTN-COMPUTE-3                                                                    |
    | OS-EXT-SRV-ATTR:hypervisor_hostname  | NFJD-TESTN-COMPUTE-3                                                                    |
    | OS-EXT-SRV-ATTR:instance_name        | instance-000056dc                                                                       |
    | OS-EXT-STS:power_state               | 1                                                                                       |
    | OS-EXT-STS:task_state                | -                                                                                       |
    | OS-EXT-STS:vm_state                  | active                                                                                  |
    | OS-SRV-USG:launched_at               | 2017-05-05T03:46:50.000000                                                              |
    | OS-SRV-USG:terminated_at             | -                                                                                       |
    | accessIPv4                           |                                                                                         |
    | accessIPv6                           |                                                                                         |
    | config_drive                         | True                                                                                    |
    | created                              | 2017-05-05T03:46:42Z                                                                    |
    | flavor                               | m1.medium (3)                                                                           |
    | hostId                               | c34578f3d9c097be0d91fda237706199673ca7e5a87051f5aad24637                                |
    | id                                   | f64bf83d-a9f0-4ec5-b481-e3e76e19b6bd                                                    |
    | image                                | Windows-Server-2008-R2-Enterprise-64bit-20160706 (fb5bc637-c8ab-4999-9e88-da28561fed21) |
    | key_name                             | -                                                                                       |
    | metadata                             | {}                                                                                      |
    | name                                 | t4                                                                                      |
    | net001 network                       | 192.168.2.92                                                                            |
    | os-extended-volumes:volumes_attached | []                                                                                      |
    | progress                             | 0                                                                                       |
    | security_groups                      | default                                                                                 |
    | status                               | ACTIVE                                                                                  |
    | tenant_id                            | 6c149dcd3cf64171b8dd972dd03bbac0                                                        |
    | updated                              | 2017-05-05T03:46:51Z                                                                    |
    | user_id                              | 62f52135115f4898bd0d82c1f0cd632b                                                        |
    +--------------------------------------+-----------------------------------------------------------------------------------------+
    MySQL [nova]> select * from instances where uuid='f64bf83d-a9f0-4ec5-b481-e3e76e19b6bd';
    +---------------------+---------------------+------------+-------+-------------+----------------------------------+----------------------------------+--------------------------------------+-----------+------------+--------------+----------+----------+-------------+----------+-----------+-------+----------+----------------------+-----------+----------------+--------------+---------------------+---------------+--------------+---------------------+-------------------+--------+---------+----------------------+------------------+---------+--------------------------------------+--------------+------------------+--------------+--------------+--------------+------------+--------------------------+---------------------+----------+------------------+--------------------+-------------------+---------+--------------+-----------+----------------------+---------+-----------+---------+--------------------+
    | created_at          | updated_at          | deleted_at | id    | internal_id | user_id                          | project_id                       | image_ref                            | kernel_id | ramdisk_id | launch_index | key_name | key_data | power_state | vm_state | memory_mb | vcpus | hostname | host                 | user_data | reservation_id | scheduled_at | launched_at         | terminated_at | display_name | display_description | availability_zone | locked | os_type | launched_on          | instance_type_id | vm_mode | uuid                                 | architecture | root_device_name | access_ip_v4 | access_ip_v6 | config_drive | task_state | default_ephemeral_device | default_swap_device | progress | auto_disk_config | shutdown_terminate | disable_terminate | root_gb | ephemeral_gb | cell_name | node                 | deleted | locked_by | cleaned | ephemeral_key_uuid |
    +---------------------+---------------------+------------+-------+-------------+----------------------------------+----------------------------------+--------------------------------------+-----------+------------+--------------+----------+----------+-------------+----------+-----------+-------+----------+----------------------+-----------+----------------+--------------+---------------------+---------------+--------------+---------------------+-------------------+--------+---------+----------------------+------------------+---------+--------------------------------------+--------------+------------------+--------------+--------------+--------------+------------+--------------------------+---------------------+----------+------------------+--------------------+-------------------+---------+--------------+-----------+----------------------+---------+-----------+---------+--------------------+
    | 2017-05-05 03:46:42 | 2017-05-05 03:46:51 | NULL       | 22236 |        NULL | 62f52135115f4898bd0d82c1f0cd632b | 6c149dcd3cf64171b8dd972dd03bbac0 | fb5bc637-c8ab-4999-9e88-da28561fed21 |           |            |            0 | NULL     | NULL     |           1 | active   |      4096 |     2 | t4       | NFJD-TESTN-COMPUTE-3 | NULL      | r-ae2dhvll     | NULL         | 2017-05-05 03:46:50 | NULL          | t4           | t4                  | nova              |      0 | windows | NFJD-TESTN-COMPUTE-3 |                3 | NULL    | f64bf83d-a9f0-4ec5-b481-e3e76e19b6bd | NULL         | /dev/vda         | NULL         | NULL         | True         | NULL       | NULL                     | NULL                |        0 |                0 |                  0 |                 0 |      40 |            0 | NULL      | NFJD-TESTN-COMPUTE-3 |       0 | NULL      |       0 | NULL               |
    +---------------------+---------------------+------------+-------+-------------+----------------------------------+----------------------------------+--------------------------------------+-----------+------------+--------------+----------+----------+-------------+----------+-----------+-------+----------+----------------------+-----------+----------------+--------------+---------------------+---------------+--------------+---------------------+-------------------+--------+---------+----------------------+------------------+---------+--------------------------------------+--------------+------------------+--------------+--------------+--------------+------------+--------------------------+---------------------+----------+------------------+--------------------+-------------------+---------+--------------+-----------+----------------------+---------+-----------+---------+--------------------+
    1 row in set (0.00 sec)
    
    查看到nova数据库里instances表的os_type='windows'


# 类似的，对于无法获取监控数据的虚机，使用以下办法修改虚机配置：

（1）联系提供镜像的同事确认虚机内已安装qemu-guest-agent 
（2）修改nova数据库改虚机字段：

    MariaDB [(none)]> use nova;
    MariaDB [nova]> insert into instance_system_metadata values(NULL,NULL,NULL,NULL,'2cf79497-d1ba-42c3-adf5-3b45c6927dfb','image_hw_qemu_guest_agent','yes',0);
    注： 2cf79497-d1ba-42c3-adf5-3b45c6927dfb 为对应instance的uuid
    检查：select * from instance_system_metadata where instance_uuid='3ce9d8b0-a0a3-48ed-ba54-415883f717e5';

（3）再修改虚机所用镜像

    # glance image-update xxx --property hw_qemu_guest_agent=yes --property hw_ovirt_guest_agent=yes

（4）硬重启虚机，需提前联系客户

    # nova reboot 2cf79497-d1ba-42c3-adf5-3b45c6927dfb --hard --poll



# 为何修改os_type='windows'会影响windows虚拟机的时间

## openstack会根据os_type的内容来决定提供给底下一层kvm的vm所需的xml内容

通过查询一台windows虚拟机和一台linux虚拟机来对比xml内容，确实windows vm为clock offset='localtime'  linux vm为clock offset='utc'

The `<clock>` element is used to determine how the guest virtual machine clock is synchronized with the host physical machine clock. The clock element has the following attributes:

`offset` determines how the guest virtual machine clock is offset from the host physical machine clock. 

### windows虚拟机

    [root@NFJD-TESTVM-CORE-API-1 ~]# nova show t4
    +--------------------------------------+-----------------------------------------------------------------------------------------+
    | Property                             | Value                                                                                   |
    +--------------------------------------+-----------------------------------------------------------------------------------------+
    | OS-DCF:diskConfig                    | MANUAL                                                                                  |
    | OS-EXT-AZ:availability_zone          | nova                                                                                    |
    | OS-EXT-SRV-ATTR:host                 | NFJD-TESTN-COMPUTE-3                                                                    |
    | OS-EXT-SRV-ATTR:hypervisor_hostname  | NFJD-TESTN-COMPUTE-3                                                                    |
    | OS-EXT-SRV-ATTR:instance_name        | instance-000056dc                                                                       |
    | OS-EXT-STS:power_state               | 1                                                                                       |
    | OS-EXT-STS:task_state                | -                                                                                       |
    | OS-EXT-STS:vm_state                  | active                                                                                  |
    | OS-SRV-USG:launched_at               | 2017-05-05T03:46:50.000000                                                              |
    | OS-SRV-USG:terminated_at             | -                                                                                       |
    | accessIPv4                           |                                                                                         |
    | accessIPv6                           |                                                                                         |
    | config_drive                         | True                                                                                    |
    | created                              | 2017-05-05T03:46:42Z                                                                    |
    | flavor                               | m1.medium (3)                                                                           |
    | hostId                               | c34578f3d9c097be0d91fda237706199673ca7e5a87051f5aad24637                                |
    | id                                   | f64bf83d-a9f0-4ec5-b481-e3e76e19b6bd                                                    |
    | image                                | Windows-Server-2008-R2-Enterprise-64bit-20160706 (fb5bc637-c8ab-4999-9e88-da28561fed21) |
    | key_name                             | -                                                                                       |
    | metadata                             | {}                                                                                      |
    | name                                 | t4                                                                                      |
    | net001 network                       | 192.168.2.92                                                                            |
    | os-extended-volumes:volumes_attached | []                                                                                      |
    | progress                             | 0                                                                                       |
    | security_groups                      | default                                                                                 |
    | status                               | ACTIVE                                                                                  |
    | tenant_id                            | 6c149dcd3cf64171b8dd972dd03bbac0                                                        |
    | updated                              | 2017-05-05T03:46:51Z                                                                    |
    | user_id                              | 62f52135115f4898bd0d82c1f0cd632b                                                        |
    +--------------------------------------+-----------------------------------------------------------------------------------------+
    [root@NFJD-TESTN-COMPUTE-3 ~]# virsh dumpxml instance-000056dc
    ...
      <clock offset='localtime'>
        <timer name='pit' tickpolicy='delay'/>
        <timer name='rtc' tickpolicy='catchup'/>
        <timer name='hpet' present='no'/>
      </clock>
    ...



### linux虚拟机

    [root@NFJD-TESTVM-CORE-API-1 ~]# nova show t1
    +--------------------------------------+-------------------------------------------------------------------+
    | Property                             | Value                                                             |
    +--------------------------------------+-------------------------------------------------------------------+
    | OS-DCF:diskConfig                    | MANUAL                                                            |
    | OS-EXT-AZ:availability_zone          | nova                                                              |
    | OS-EXT-SRV-ATTR:host                 | NFJD-TESTN-COMPUTE-1                                              |
    | OS-EXT-SRV-ATTR:hypervisor_hostname  | NFJD-TESTN-COMPUTE-1                                              |
    | OS-EXT-SRV-ATTR:instance_name        | instance-000056d9                                                 |
    | OS-EXT-STS:power_state               | 1                                                                 |
    | OS-EXT-STS:task_state                | -                                                                 |
    | OS-EXT-STS:vm_state                  | active                                                            |
    | OS-SRV-USG:launched_at               | 2017-05-05T02:44:20.000000                                        |
    | OS-SRV-USG:terminated_at             | -                                                                 |
    | accessIPv4                           |                                                                   |
    | accessIPv6                           |                                                                   |
    | config_drive                         | True                                                              |
    | created                              | 2017-05-05T02:44:11Z                                              |
    | flavor                               | m1.medium (3)                                                     |
    | hostId                               | f091880caebe68654030e5df4825e49548af0037454e5723961bfc3d          |
    | id                                   | 6316dc6e-2fb0-4d72-8e99-ad5749efc295                              |
    | image                                | CentOS-7.1-x86_64-20161018 (8aaf1759-9fb4-4ba9-8cff-1743eb824c5f) |
    | key_name                             | -                                                                 |
    | metadata                             | {}                                                                |
    | name                                 | t1                                                                |
    | net001 network                       | 192.168.2.90                                                      |
    | os-extended-volumes:volumes_attached | []                                                                |
    | progress                             | 0                                                                 |
    | security_groups                      | default                                                           |
    | status                               | ACTIVE                                                            |
    | tenant_id                            | 6c149dcd3cf64171b8dd972dd03bbac0                                  |
    | updated                              | 2017-05-05T03:36:09Z                                              |
    | user_id                              | 62f52135115f4898bd0d82c1f0cd632b                                  |
    +--------------------------------------+-------------------------------------------------------------------+
    [root@NFJD-TESTN-COMPUTE-1 ~]# virsh dumpxml instance-000056d9
    ...
      <clock offset='utc'>
        <timer name='pit' tickpolicy='delay'/>
        <timer name='rtc' tickpolicy='catchup'/>
        <timer name='hpet' present='no'/>
      </clock>
    ...



## 分析相关的nova代码

```Python
# nova/virt/libvirt/driver.py

def _set_clock(self, guest, os_type, image_meta, virt_type):
    # NOTE(mikal): Microsoft Windows expects the clock to be in
    # "localtime". If the clock is set to UTC, then you can use a
    # registry key to let windows know, but Microsoft says this is
    # buggy in http://support.microsoft.com/kb/2687252
    clk = vconfig.LibvirtConfigGuestClock()
    if os_type == 'windows':
        LOG.info(_LI('Configuring timezone for windows instance to '
                     'localtime'))
        clk.offset = 'localtime'  # 在os_type为windows的时候clk.offset设置为localtime
    else:
        clk.offset = 'utc'
    guest.set_clock(clk)  # 在os_type为linux的时候clk.offset设置为utc

    if virt_type == "kvm":
        self._set_kvm_timers(clk, os_type, image_meta)
```

