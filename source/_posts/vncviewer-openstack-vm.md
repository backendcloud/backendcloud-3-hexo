title: 网络不通的情况下，不通过dashboard，在未装图形化系统上查看openstack 创建的vm
date: 2016-08-18 13:49:11
categories: Openstack_op
tags:
- vnc

---

一般登陆openstack 创建的虚拟机投一些命令可以直接通过ssh vm所在网络的ip登陆该vm。

若网络不通的情况，就会通过dashboard 的 vnc页面 进入vm操作或者配置网络重启网络服务
也可以到vm所在的computer节点通过virt-manager，就是KVM的界面登陆

但是这两只种情况，前者需要安装dashboard，对于非用户的开发人员，一般都是在CLI下操作。后者需要安装带图形化界面的操作系统，往往computer节点开始安装操作系统的时候是最小安装。

现在介绍一种通过远程vnc查看openstack 创建的虚拟机的方法


vm所在的computer节点不是带图形化界面的操作系统没有关系，只要远程登陆的机器上是即可。在远程机器上安装vncviewer



    # yum install tigervnc
    Loaded plugins: langpacks, product-id, subscription-manager
    This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
    InstallMedia                                                           | 4.1 kB  00:00:00     
    Resolving Dependencies
    --> Running transaction check
    ---> Package tigervnc.x86_64 0:1.3.1-3.el7 will be installed
    --> Processing Dependency: tigervnc-icons for package: tigervnc-1.3.1-3.el7.x86_64
    --> Processing Dependency: libfltk.so.1.3()(64bit) for package: tigervnc-1.3.1-3.el7.x86_64
    --> Processing Dependency: libfltk_images.so.1.3()(64bit) for package: tigervnc-1.3.1-3.el7.x86_64
    --> Running transaction check
    ---> Package fltk.x86_64 0:1.3.0-13.el7 will be installed
    ---> Package tigervnc-icons.noarch 0:1.3.1-3.el7 will be installed
    --> Finished Dependency Resolution
    
    Dependencies Resolved
    
    ==============================================================================================
     Package                 Arch            Version                  Repository             Size
    ==============================================================================================
    Installing:
     tigervnc                x86_64          1.3.1-3.el7              InstallMedia          210 k
    Installing for dependencies:
     fltk                    x86_64          1.3.0-13.el7             InstallMedia          654 k
     tigervnc-icons          noarch          1.3.1-3.el7              InstallMedia           35 k
    
    Transaction Summary
    ==============================================================================================
    Install  1 Package (+2 Dependent packages)
    
    Total size: 899 k
    Total download size: 245 k
    Installed size: 2.1 M
    Is this ok [y/d/N]: y
    Downloading packages:
    No Presto metadata available for InstallMedia
    (1/2): tigervnc-icons-1.3.1-3.el7.noarch.rpm                           |  35 kB  00:00:00     
    (2/2): tigervnc-1.3.1-3.el7.x86_64.rpm                                 | 210 kB  00:00:00     
    ----------------------------------------------------------------------------------------------
    Total                                                         2.9 MB/s | 245 kB  00:00:00     
    Running transaction check
    Running transaction test
    Transaction test succeeded
    Running transaction
      Installing : fltk-1.3.0-13.el7.x86_64                                                   1/3 
      Installing : tigervnc-icons-1.3.1-3.el7.noarch                                          2/3 
      Installing : tigervnc-1.3.1-3.el7.x86_64                                                3/3 
      Verifying  : tigervnc-1.3.1-3.el7.x86_64                                                1/3 
      Verifying  : tigervnc-icons-1.3.1-3.el7.noarch                                          2/3 
      Verifying  : fltk-1.3.0-13.el7.x86_64                                                   3/3 
    
    Installed:
      tigervnc.x86_64 0:1.3.1-3.el7                                                               
    
    Dependency Installed:
      fltk.x86_64 0:1.3.0-13.el7                tigervnc-icons.noarch 0:1.3.1-3.el7               
    
    Complete!



登陆controller节点，查看需要vnc查看的vm的详细信息
```
    [root@localhost ~(keystone_admin)]# nova list
    +--------------------------------------+------+--------+------------+-------------+---------------+
    | ID                                   | Name | Status | Task State | Power State | Networks      |
    +--------------------------------------+------+--------+------------+-------------+---------------+
    | 7a47e769-acd0-45bd-b807-f01059c3b002 | hhh  | ACTIVE | -          | Running     | abc=10.0.0.15 |
    +--------------------------------------+------+--------+------------+-------------+---------------+
    [root@localhost ~(keystone_admin)]# nova show hhh
    +--------------------------------------+----------------------------------------------------------+
    | Property                             | Value                                                    |
    +--------------------------------------+----------------------------------------------------------+
    | OS-DCF:diskConfig                    | MANUAL                                                   |
    | OS-EXT-AZ:availability_zone          | nova                                                     |
    | OS-EXT-SRV-ATTR:host                 | localhost                                                |
    | OS-EXT-SRV-ATTR:hypervisor_hostname  | localhost                                                |
    | OS-EXT-SRV-ATTR:instance_name        | instance-0000000d                                        |
    | OS-EXT-STS:power_state               | 1                                                        |
    | OS-EXT-STS:task_state                | -                                                        |
    | OS-EXT-STS:vm_state                  | active                                                   |
    | OS-SRV-USG:launched_at               | 2016-08-18T19:15:24.000000                               |
    | OS-SRV-USG:terminated_at             | -                                                        |
    | abc network                          | 10.0.0.15                                                |
    | accessIPv4                           |                                                          |
    | accessIPv6                           |                                                          |
    | config_drive                         |                                                          |
    | created                              | 2016-08-18T19:15:20Z                                     |
    | flavor                               | m1.large (4)                                             |
    | hostId                               | 58d0a60d000fe966e7c6bd13be84abac721a5f825a4aa62b14cb8d3b |
    | id                                   | 7a47e769-acd0-45bd-b807-f01059c3b002                     |
    | image                                | ggg (fd4842a5-deca-4252-ac6f-d06b1e452eb8)               |
    | key_name                             | -                                                        |
    | metadata                             | {}                                                       |
    | name                                 | hhh                                                      |
    | os-extended-volumes:volumes_attached | []                                                       |
    | progress                             | 0                                                        |
    | security_groups                      | default                                                  |
    | status                               | ACTIVE                                                   |
    | tenant_id                            | 2f30485c331a4f27b4fdd8938aa9bb15                         |
    | updated                              | 2016-08-18T19:15:24Z                                     |
    | user_id                              | 352e4067d6fd4cfd90311e76f0dd763c                         |
    +--------------------------------------+----------------------------------------------------------+
```
查到第15行
    OS-EXT-SRV-ATTR:instance_name        | instance-0000000d
信息



登陆该vm所在计算节点上查询该vm的KVM的实例分配的vnc端口号

    [root@localhost dev(keystone_admin)]# virsh vncdisplay instance-0000000d
    :0


远程打开nvcviewer，地址输入xx.xx.xx.xx:0      （xx.xx.xx.xx是该vm所在计算节点ip地址）
即可vnc查看openstack 创建的虚拟机 


若不能vnc查看，确认防火墙是否关闭或者开放vnc访问的端口号

    [root@localhost dev(keystone_admin)]# service iptables status
    Redirecting to /bin/systemctl status  iptables.service
    ● iptables.service - IPv4 firewall with iptables
       Loaded: loaded (/usr/lib/systemd/system/iptables.service; enabled; vendor preset: disabled)
       Active: active (exited) since Wed 2016-08-17 23:49:47 JST; 1 day 4h ago
      Process: 740 ExecStart=/usr/libexec/iptables/iptables.init start (code=exited, status=0/SUCCESS)
     Main PID: 740 (code=exited, status=0/SUCCESS)
       CGroup: /system.slice/iptables.service
    
    Aug 17 23:49:46 localhost.localdomain systemd[1]: Starting IPv4 firewall with iptables...
    Aug 17 23:49:47 localhost.localdomain iptables.init[740]: iptables: Applying firewall ru...]
    Aug 17 23:49:47 localhost.localdomain systemd[1]: Started IPv4 firewall with iptables.
    Hint: Some lines were ellipsized, use -l to show in full.
    [root@localhost dev(keystone_admin)]# service iptables stop
    Redirecting to /bin/systemctl stop  iptables.service
    [root@localhost dev(keystone_admin)]# service iptables status
    Redirecting to /bin/systemctl status  iptables.service
    ● iptables.service - IPv4 firewall with iptables
       Loaded: loaded (/usr/lib/systemd/system/iptables.service; enabled; vendor preset: disabled)
       Active: failed (Result: exit-code) since Fri 2016-08-19 04:27:42 JST; 1s ago
      Process: 2453 ExecStop=/usr/libexec/iptables/iptables.init stop (code=exited, status=5)
      Process: 740 ExecStart=/usr/libexec/iptables/iptables.init start (code=exited, status=0/SUCCESS)
     Main PID: 740 (code=exited, status=0/SUCCESS)
    
    Aug 17 23:49:47 localhost.localdomain iptables.init[740]: iptables: Applying firewall ru...]
    Aug 17 23:49:47 localhost.localdomain systemd[1]: Started IPv4 firewall with iptables.
    Aug 19 04:27:41 localhost systemd[1]: Stopping IPv4 firewall with iptables...
    Aug 19 04:27:41 localhost iptables.init[2453]: iptables: Setting chains to policy ACCEP... ]
    Aug 19 04:27:41 localhost iptables.init[2453]: iptables: Flushing firewall rules: [  OK  ]
    Aug 19 04:27:41 localhost iptables.init[2453]: iptables: Unloading modules:  iptable_fi...D]
    Aug 19 04:27:42 localhost systemd[1]: iptables.service: control process exited, code=e...s=5
    Aug 19 04:27:42 localhost systemd[1]: Stopped IPv4 firewall with iptables.
    Aug 19 04:27:42 localhost systemd[1]: Unit iptables.service entered failed state.
    Aug 19 04:27:42 localhost systemd[1]: iptables.service failed.
    Hint: Some lines were ellipsized, use -l to show in full.
