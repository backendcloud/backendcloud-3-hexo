---
title: iSCSI 手动
readmore: true
date: 2022-09-16 20:20:11
categories: 云原生
tags:
- iSCSI
- Longhorn
---

Longhorn的部署和简单使用可以参考之前的文章：{% post_link k3s-install %} 最后一个章节。

Longhorn的代码分布在下面很多的代码仓库中：
* Longhorn Backing Image Manager：支持磁盘中镜像的下载、同步和删除
* Longhorn Engine：核心控制器/副本逻辑
* Longhorn Instance Manager：控制器/副本 实例生命周期管理
* Longhorn Manager：Longhorn 编排，包括 Kubernetes 的 CSI 驱动程序
* Longhorn Share Manager：将 Longhorn 卷公开为 ReadWriteMany 卷的 NFS provisioner(配置程序)
* Longhorn UI：Longhorn 仪表板

iSCSI用来暴露Longhorn提供的块设备。

下面做一个最基本的iSCSI的手动实验。两个节点，一个服务端target（192.168.126.137），一个客户端initiator。

```bash
[root@centos7-target ~]# lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   20G  0 disk 
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0   19G  0 part 
  ├─centos-root 253:0    0   17G  0 lvm  /
  └─centos-swap 253:1    0    2G  0 lvm  [SWAP]
sdb               8:16   0    6G  0 disk 
├─sdb1            8:17   0    3G  0 part 
└─sdb2            8:18   0    3G  0 part 
sr0              11:0    1 1024M  0 rom  
[root@centos7-target ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:e8:04:73 brd ff:ff:ff:ff:ff:ff
    inet 192.168.126.137/24 brd 192.168.126.255 scope global noprefixroute dynamic ens33
       valid_lft 1678sec preferred_lft 1678sec
    inet6 fe80::43f3:7bc2:a62e:f23d/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
[root@centos7-target ~]# rpm -qa|grep targetcli
[root@centos7-target ~]# yum install -y targetcli
[root@centos7-target ~]# rpm -qa|grep targetcli
targetcli-2.1.53-1.el7_9.noarch
[root@centos7-target ~]# targetcli
Warning: Could not load preferences file /root/.targetcli/prefs.bin.
targetcli shell version 2.1.53
Copyright 2011-2013 by Datera, Inc and others.
For help on commands, type 'help'.

/> ls
o- / ......................................................................................................................... [...]
  o- backstores .............................................................................................................. [...]
  | o- block .................................................................................................. [Storage Objects: 0]
  | o- fileio ................................................................................................. [Storage Objects: 0]
  | o- pscsi .................................................................................................. [Storage Objects: 0]
  | o- ramdisk ................................................................................................ [Storage Objects: 0]
  o- iscsi ............................................................................................................ [Targets: 0]
  o- loopback ......................................................................................................... [Targets: 0]
/> cd iscsi
/iscsi> ls
o- iscsi .............................................................................................................. [Targets: 0]
/iscsi> create wwn=iqn.2021-03.com.iscsi:server
Created target iqn.2021-03.com.iscsi:server.
Created TPG 1.
Global pref auto_add_default_portal=true
Created default portal listening on all IPs (0.0.0.0), port 3260.
/iscsi> ls
o- iscsi .............................................................................................................. [Targets: 1]
  o- iqn.2021-03.com.iscsi:server ........................................................................................ [TPGs: 1]
    o- tpg1 ................................................................................................. [no-gen-acls, no-auth]
      o- acls ............................................................................................................ [ACLs: 0]
      o- luns ............................................................................................................ [LUNs: 0]
      o- portals ...................................................................................................... [Portals: 1]
        o- 0.0.0.0:3260 ....................................................................................................... [OK]
/iscsi> cd iqn.2021-03.com.iscsi:server/tpg1/acls 
/iscsi/iqn.20...ver/tpg1/acls> create wwn=iqn.2021-03.com.iscsi:client
Created Node ACL for iqn.2021-03.com.iscsi:client
/iscsi/iqn.20...ver/tpg1/acls> cd iqn.2021-03.com.iscsi:client 
/iscsi/iqn.20....iscsi:client> set auth userid=username password=password
Parameter password is now 'password'.
Parameter userid is now 'username'.
/iscsi/iqn.20....iscsi:client> cd /backstores/block 
/backstores/block> create name=sdb1  dev=/dev/sdb1 
Created block storage object sdb1 using /dev/sdb1.
/backstores/block> create name=sdb2  dev=/dev/sdb2 
Created block storage object sdb2 using /dev/sdb2.
/backstores/block> cd /iscsi/iqn.2021-03.com.iscsi:server/tpg1/luns 
/iscsi/iqn.20...ver/tpg1/luns> ls
o- luns .................................................................................................................. [LUNs: 0]
/iscsi/iqn.20...ver/tpg1/luns> create /backstores/block/sdb1
Created LUN 0.
Created LUN 0->0 mapping in node ACL iqn.2021-03.com.iscsi:client
/iscsi/iqn.20...ver/tpg1/luns> create /backstores/block/sdb2
Created LUN 1.
Created LUN 1->1 mapping in node ACL iqn.2021-03.com.iscsi:client
/iscsi/iqn.20...ver/tpg1/luns> ls
o- luns .................................................................................................................. [LUNs: 2]
  o- lun0 .............................................................................. [block/sdb1 (/dev/sdb1) (default_tg_pt_gp)]
  o- lun1 .............................................................................. [block/sdb2 (/dev/sdb2) (default_tg_pt_gp)]
/iscsi/iqn.20...ver/tpg1/luns> exit
Global pref auto_save_on_exit=true
Configuration saved to /etc/target/saveconfig.json
[root@centos7-target ~]# systemctl stop firewalld
```

```bash
[root@centos7-client ~]# lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   20G  0 disk 
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0   19G  0 part 
  ├─centos-root 253:0    0   17G  0 lvm  /
  └─centos-swap 253:1    0    2G  0 lvm  [SWAP]
sr0              11:0    1 1024M  0 rom  
[root@centos7-client ~]# rpm -qa|grep initiator
[root@centos7-client ~]# yum install -y iscsi-initiator-utils
[root@centos7-client ~]# rpm -qa|grep initiator
iscsi-initiator-utils-iscsiuio-6.2.0.874-22.el7_9.x86_64
iscsi-initiator-utils-6.2.0.874-22.el7_9.x86_64
[root@centos7-client ~]# vi /etc/iscsi/initiatorname.iscsi 
[root@centos7-client ~]# cat /etc/iscsi/initiatorname.iscsi 
InitiatorName=iqn.2021-03.com.iscsi:client
[root@centos7-client ~]# vi /etc/iscsi/iscsid.conf
[root@centos7-client ~]# systemctl restart iscsid 
[root@centos7-client ~]# iscsiadm -m discovery -t sendtargets -p 192.168.126.137 -discover
iscsiadm: Login failed to authenticate with target 
iscsiadm: discovery login to 192.168.126.137 rejected: initiator failed authorization
iscsiadm: Could not perform SendTargets discovery: iSCSI login failed due to authorization failure
[root@centos7-client ~]# vi /etc/iscsi/iscsid.conf
...
node.session.auth.username = username
node.session.auth.password = password
...
[root@centos7-client ~]# iscsiadm -m discovery -t sendtargets -p 192.168.126.137 -discover
192.168.126.137:3260,1 iqn.2021-03.com.iscsi:server
[root@centos7-client ~]# iscsiadm -m node -p 192.168.126.137 -l
Logging in to [iface: default, target: iqn.2021-03.com.iscsi:server, portal: 192.168.126.137,3260] (multiple)
Login to [iface: default, target: iqn.2021-03.com.iscsi:server, portal: 192.168.126.137,3260] successful.
[root@centos7-client ~]# lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   20G  0 disk 
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0   19G  0 part 
  ├─centos-root 253:0    0   17G  0 lvm  /
  └─centos-swap 253:1    0    2G  0 lvm  [SWAP]
sdb               8:16   0    3G  0 disk 
sdc               8:32   0    3G  0 disk 
sr0              11:0    1 1024M  0 rom  
[root@centos7-client ~]# lsscsi
[0:0:0:0]    disk    VMware,  VMware Virtual S 1.0   /dev/sda 
[2:0:0:0]    cd/dvd  NECVMWar VMware IDE CDR10 1.00  /dev/sr0 
[3:0:0:0]    disk    LIO-ORG  sdb1             4.0   /dev/sdb 
[3:0:0:1]    disk    LIO-ORG  sdb2             4.0   /dev/sdc 
```

> 至此从服务端（target）map过来的新磁盘已分区，并且创建了文件系统，切挂载到客户端（initiator）并且能被使用。