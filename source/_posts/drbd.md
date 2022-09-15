---
title: DRBD 的部署和使用
readmore: false
date: 2022-09-15 12:54:52
categories: Tools
tags:
- DRBD
---

> DRBD 是早就淘汰的技术了。对于接触的都是新架构系统的读者可以直接跳过，本篇对象是仍需运维老系统的读者。

本篇安装的DRBD版本竟然是第53个用户，我也是无语了。

```bash
  --==  Thank you for participating in the global usage survey  ==--

The server's response is:

you are the 53th user to install this version
```

DRBD是一种存储高可用方案，通过两个服务器之间块设备从主设备同步到从设备实现的，正常时期应用读写都发生在主设备中，从设备只是用来同步主设备，当主设备坏了，可以切换至从设备，并应尽快再寻找新的备份设备。

DRBD的复制模式：
1. protocol A: 异步写入，只要本地磁盘写入完成，另外一份拷贝的数据包在发送队列中，则认为一个写操作过程完成。
2. protocol B: 半同步写入，只要本地磁盘写入完成，另外一份拷贝的数据包已经到达远程节点，则认为一个写操作过程完成。
3. protocol C: 同步写入，只有本地和远程节点的磁盘都已经确认了写操作完成，则认为一个写操作过程完成。

# centos7 部署DRBD

```bash
# step1（两节点都要执行）: 配置hosts文件，配置免密
[root@node1 ~]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

192.168.190.135 node1
192.168.190.136 node2
[root@node1 ~]# ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:0xnoKl68RoK/uM6xpPsTOiZBXklCatrt1N+vetByzrk root@node1
The key's randomart image is:
+---[RSA 2048]----+
|..               |
|.. .     .       |
|..o .   . .      |
|oo + . . . o     |
|+ o.o . S.o      |
|..oo...oooo      |
| ooooo+ .*..     |
|+=.=.o..  =.     |
|==Booo. .oEo.    |
+----[SHA256]-----+
[root@node1 ~]# ssh-copy-id -i ~/.ssh/id_rsa.pub node2
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@node2's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'node2'"
and check to make sure that only the key(s) you wanted were added.

[root@node1 ~]# ssh node2
Last login: Thu Sep 15 17:11:40 2022 from node1
[root@node2 ~]# 
```

```bash
# step2（两节点都要执行）：关闭防火墙，SELINUX，同步系统时间
[root@node1 ~]# systemctl stop firewalld
[root@node1 ~]# systemctl disable firewalld
Removed symlink /etc/systemd/system/multi-user.target.wants/firewalld.service.
Removed symlink /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
[root@node1 ~]# getenforce 
Enforcing
[root@node1 ~]# setenforce 0
[root@node1 ~]# getenforce 
Permissive
[root@node1 ~]# vi /etc/selinux/config
# 将SELINUX=enforcing改为SELINUX=disabled
# 同步系统时间
```

```bash
# step3（两节点都要执行）：安装和配置DRBD
[root@node1 ~]# yum install -y epel-release
[root@node1 ~]# yum install -y drbd
[root@node1 ~]# dd if=/dev/zero of=/dev/sdb1 bs=2024k count=1024
dd: error writing ‘/dev/sdb1’: No space left on device
989+0 records in
988+0 records out
2048978944 bytes (2.0 GB) copied, 1.48152 s, 1.4 GB/s
[root@node1 drbd.d]# mv /etc/drbd.d/global_common.conf /etc/drbd.d/global_common.conf.orig
[root@node1 drbd.d]# vi /etc/drbd.d/global_common.conf
[root@node1 drbd.d]# cat /etc/drbd.d/global_common.conf
global {
 usage-count  yes;
}
common {
 net {
  protocol C;
 }
}
[root@node1 drbd.d]# vi /etc/drbd.d/test.res
[root@node1 drbd.d]# cat /etc/drbd.d/test.res
resource test {
        on node1 {
                device /dev/drbd0;
                disk /dev/sdb1;
                        meta-disk internal;
                        address 192.168.190.135:7789;
        }
        on node2  {
                device /dev/drbd0;
                        disk /dev/sdb1;
                        meta-disk internal;
                        address 192.168.190.136:7789;
        }
}
[root@node1 ~]# fdisk /dev/sdb
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0xa63a1d3c.

Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): 
Using default response p
Partition number (1-4, default 1): 
First sector (2048-6291455, default 2048): 
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-6291455, default 6291455): 
Using default value 6291455
Partition 1 of type Linux and of size 3 GiB is set

Command (m for help): p

Disk /dev/sdb: 3221 MB, 3221225472 bytes, 6291456 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0xa63a1d3c

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048     6291455     3144704   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
[root@node1 ~]# partx /dev/sdb
NR START     END SECTORS SIZE NAME UUID
 1  2048 6291455 6289408   3G      
[root@node1 ~]# drbdadm create-md test
modinfo: ERROR: Module drbd not found.
modinfo: ERROR: Module drbd not found.
initializing activity log
initializing bitmap (96 KB) to all zero
Writing meta data...
New drbd meta data block successfully created.
[root@node1 ~]# drbdadm up test
modinfo: ERROR: Module drbd not found.
modinfo: ERROR: Module drbd not found.
modprobe: FATAL: Module drbd not found.
Failed to modprobe drbd (No such file or directory)
Command 'drbdsetup new-resource test 1' terminated with exit code 20
[root@node1 ~]# lsmod | grep drbd
[root@node1 ~]# modprobe drbd
modprobe: FATAL: Module drbd not found.
```

上面报错是因为内核中没有drbd模块，可通过升级内核版本解决，升级完后需要重启。升级内核的步骤参考：{% post_link cilium-install %} 最后一个章节。

```bash
[root@node1 ~]# uname -a
Linux node1 5.19.8-1.el7.elrepo.x86_64 #1 SMP PREEMPT_DYNAMIC Tue Sep 6 15:12:14 EDT 2022 x86_64 x86_64 x86_64 GNU/Linux
[root@node1 ~]# modprobe drbd
[root@node1 ~]# lsmod |grep drbd
drbd                  389120  0 
lru_cache              16384  1 drbd
libcrc32c              16384  2 xfs,drbd
[root@node1 ~]# drbdadm up test
No valid meta data found
[root@node1 ~]# drbdadm create-md test
You want me to create a v08 style flexible-size internal meta data block.
There appears to be a v09 flexible-size internal meta data block
already in place on /dev/sdb1 at byte offset 3220172800

Valid v09 meta-data found, convert to v08?
[need to type 'yes' to confirm] yes

Writing meta data...
New drbd meta data block successfully created.
success
[root@node1 ~]# drbdadm up test
[root@node1 ~]# lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sdb               8:16   0    3G  0 disk 
└─sdb1            8:17   0    3G  0 part 
  └─drbd0       147:0    0    3G  1 disk 
sr0              11:0    1 1024M  0 rom  
sda               8:0    0   20G  0 disk 
├─sda2            8:2    0   19G  0 part 
│ ├─centos-swap 253:1    0    2G  0 lvm  [SWAP]
│ └─centos-root 253:0    0   17G  0 lvm  /
└─sda1            8:1    0    1G  0 part /boot
[root@node1 ~]# drbdadm status test
test role:Secondary
  disk:Inconsistent
  peer role:Secondary
    replication:Established peer-disk:Inconsistent

[root@node1 ~]# drbdsetup status test --verbose --statistics
test role:Secondary suspended:no
    write-ordering:flush
  volume:0 minor:0 disk:Inconsistent
      size:3144572 read:0 written:0 al-writes:8 bm-writes:0 upper-pending:0 lower-pending:0 al-suspended:no blocked:no
  peer connection:Connected role:Secondary congested:no
    volume:0 replication:Established peer-disk:Inconsistent resync-suspended:no
        received:0 sent:0 out-of-sync:3144572 pending:0 unacked:0
```

# 使用DRBD

> 之前的部署步骤都是两个节点都需要执行的，下面的步骤都是单节点执行

```bash
[root@node1 ~]# drbdadm primary --force test
[root@node1 ~]# drbdadm status test
test role:Primary
  disk:UpToDate
  peer role:Secondary
    replication:SyncSource peer-disk:Inconsistent done:0.34
# 现在两节点正在同步，完成0.34%，等待一段时间，完成98.96%
[root@node1 ~]# drbdadm status test
test role:Primary
  disk:UpToDate
  peer role:Secondary
    replication:SyncSource peer-disk:Inconsistent done:98.96
# 再等待一段时间，完成同步
[root@node1 ~]# drbdadm status test
test role:Primary
  disk:UpToDate
  peer role:Secondary
    replication:Established peer-disk:UpToDate
```

```bash
[root@node1 ~]# mkfs -t ext4 /dev/drbd0
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
196608 inodes, 786143 blocks
39307 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=805306368
24 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done 

[root@node1 ~]# mkdir -p /mnt/DRDB_PRI/
[root@node1 ~]# mount /dev/drbd0 /mnt/DRDB_PRI/
[root@node1 ~]# cd /mnt/DRDB_PRI/
[root@node1 DRDB_PRI]# ls
lost+found
[root@node1 DRDB_PRI]# touch a b c
[root@node1 DRDB_PRI]# mkdir d e f
[root@node1 DRDB_PRI]# ls
a  b  c  d  e  f  lost+found
[root@node1 DRDB_PRI]# cd 
[root@node1 ~]# umount /mnt/DRDB_PRI/
[root@node1 ~]# drbdadm secondary test
```

上面在node1为主设备的时候，创建了一些文件和文件夹。现在切换成node2为主设备，发现数据都同步过来了。

```bash
[root@node2 ~]# drbdadm primary test
[root@node2 ~]# mkdir -p /mnt/DRDB_SEC/
[root@node2 ~]# mount /dev/drbd0 /mnt/DRDB_SEC/
[root@node2 ~]# cd /mnt/DRDB_SEC/
[root@node2 DRDB_SEC]# ls
a  b  c  d  e  f  lost+found
```

# DRBD的应用：云主机的高可用存储方案

云主机的系统盘是放在本地存储上的（用的是所在节点的硬盘），一旦云主机所在节点硬盘故障了，可以通过nova的疏散命令，将云主机疏散至DRBD的备份从节点上，从而实现云主机的高可用。

例如：两个计算节点compute313或compute314，compute313的多块硬盘一块为主设备，compute314的多块硬盘一块为从设备，组成一对设备。compute313节点的硬盘坏了，且宕机且系统无法恢复。

将需要恢复的云主机的目录（目录名是云主机的uuid），cp 6fceaf2f-e201-4165-ba3a-f5d9c78160ab /var/lib/nova/instances/，多个云主机就复制多个目录。然后执行疏散命令 nova evacuate [instance uuid] [目的计算节点] –on-shared-storage 。

将上面的步骤写成程序就是云主机的高可用组件比如Openstack Masakari等。

# 附

本篇部署DRBD的步骤中的`step2（两节点都要执行）：关闭防火墙，SELINUX`，的方式是采用最便捷的方式：直接关闭。实际中还需要使用防火墙和selinux服务，可以通过下面的方式加入drbd的配置：

```bash
# 两个节点都执行
semanage permissive -a drbd_t

# node1执行
firewall-cmd --permanent --add-rich-rule='rule family="ipv4"  source address="192.168.190.136" port port="7789" protocol="tcp" accept'
firewall-cmd --reload

# node2执行
firewall-cmd --permanent --add-rich-rule='rule family="ipv4"  source address="192.168.190.135" port port="7789" protocol="tcp" accept'
firewall-cmd --reload
```