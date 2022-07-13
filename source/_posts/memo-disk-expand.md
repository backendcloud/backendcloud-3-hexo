---
title: 一次 VMWare Disk 扩容记录
readmore: true
date: 2022-07-13 18:28:22
categories: Tools
tags:
---

# VMWare扩容

VMWare虚拟机的磁盘快满了，Podman占用的空间太大，准备清理下Podman的空间，然后给磁盘扩下容。

```bash
 ⚡ root@centos9  ~  podman system df     
TYPE           TOTAL       ACTIVE      SIZE        RECLAIMABLE
Images         2           0           4.243GB     4.243GB (100%)
Containers     0           0           0B          0B (0%)
Local Volumes  1           0           23.29GB     23.29GB (100%)
```

Podman占空间的主要是镜像文件和本地卷，分别做下清理

```bash
podman system prune -a
podman volume prune
```

清理后：
```bash
 ⚡ root@centos9  ~  podman system df
TYPE           TOTAL       ACTIVE      SIZE        RECLAIMABLE
Images         0           0           0B          0B (0%)
Containers     0           0           0B          0B (0%)
Local Volumes  0           0           0B          0B (0%)
```

虚拟机关机后，VMWare软件虚拟机设置-硬盘-扩展，将硬盘从原来的90G扩容到200G。

VMWare这一步很简单，主要是下面虚拟机的配置。

由于新扩容的空间是未分区的空间，还需要CentOS中配置下。

# CenOS查看未分区的空间
```bash
 ⚡ root@centos9  ~  lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda           8:0    0  200G  0 disk 
├─sda1        8:1    0    2M  0 part 
├─sda2        8:2    0  300M  0 part /boot
└─sda3        8:3    0 89.7G  0 part 
  └─cs-root 253:0    0 89.7G  0 lvm  /
sr0          11:0    1 91.8M  0 rom  
sr1          11:1    1  8.1G  0 rom  
 ✘ ⚡ root@centos9  ~  fdisk /dev/sda

Welcome to fdisk (util-linux 2.37.4).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

This disk is currently in use - repartitioning is probably a bad idea.
It's recommended to umount all file systems, and swapoff all swap
partitions on this disk.


Command (m for help): p

Disk /dev/sda: 200 GiB, 214748364800 bytes, 419430400 sectors
Disk model: VMware Virtual S
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xad5e0be1

Device     Boot  Start       End   Sectors  Size Id Type
/dev/sda1         2048      6143      4096    2M 83 Linux
/dev/sda2  *      6144    620543    614400  300M 83 Linux
/dev/sda3       620544 188743679 188123136 89.7G 8e Linux LVM

Command (m for help): 
 ✘ ⚡ root@centos9  ~  fdisk /dev/sda

Welcome to fdisk (util-linux 2.37.4).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

This disk is currently in use - repartitioning is probably a bad idea.
It's recommended to umount all file systems, and swapoff all swap
partitions on this disk.


Command (m for help): F

Unpartitioned space /dev/sda: 110 GiB, 118111600640 bytes, 230686720 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes

    Start       End   Sectors  Size
188743680 419430399 230686720  110G

Command (m for help): 
```

# 思路

有两个思路，第一个思路：用`fdisk`新建分区，`mkfs`格式化新建分区，然后`pvcreate`将新建的分区创建物理卷，再利用`lvextend`将物理卷合并到原来的卷组中。这样做总感觉文件存放在两个拼接的分区性能受影响。

于是又了另一个思路：将未分区的空间合并到已分区的空间。就是将110G的未分配空间合并到/dev/sda3

```bash
 parted ---pretend-input-tty /dev/sda resizepart 3 100%;
 partx -u /dev/sda; pvresize /dev/sda3;
 lvextend -r cs/root /dev/sda3
```

具体操作日志：
```bash
 ⚡ root@centos9  ~  parted ---pretend-input-tty /dev/sda resizepart 3 100%;
Information: You may need to update /etc/fstab.

 ⚡ root@centos9  ~  partx -u /dev/sda; pvresize /dev/sda3;
  Physical volume "/dev/sda3" changed
  1 physical volume(s) resized or updated / 0 physical volume(s) not resized
 ⚡ root@centos9  ~  lvextend -r cs-root /dev/sda3
  Please specify a logical volume path.
  Run `lvextend --help' for more information.
 ✘ ⚡ root@centos9  ~  lvextend -r cs/root /dev/sda3
  Size of logical volume cs/root changed from 89.70 GiB (22964 extents) to 199.70 GiB (51124 extents).
  Logical volume cs/root successfully resized.
meta-data=/dev/mapper/cs-root    isize=512    agcount=4, agsize=5878784 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=1 inobtcount=1
data     =                       bsize=4096   blocks=23515136, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=11482, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 23515136 to 52350976
 ⚡ root@centos9  ~  lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda           8:0    0   200G  0 disk 
├─sda1        8:1    0     2M  0 part 
├─sda2        8:2    0   300M  0 part /boot
└─sda3        8:3    0 199.7G  0 part 
  └─cs-root 253:0    0 199.7G  0 lvm  /
sr0          11:0    1  91.8M  0 rom  
sr1          11:1    1   8.1G  0 rom 
```