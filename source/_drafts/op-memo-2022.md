---
title: op-memo-2022
readmore: true
date: 2022-09-19 10:24:36
categories:
tags:
---


# windows2012镜像使用virtio-SCSI磁盘驱动蓝屏问题

蓝屏是因为当时的镜像打的驱动是virtio的驱动，而磁盘设备所需的是scsi驱动，所以当时的镜像都会蓝屏，后来重制的镜像，磁盘驱动打的是scsi驱动，镜像上传时再加2个参数：hw_disk_bus=scsi，hw_scsi_model=virtio-scsi，后测试没有再蓝屏

制作镜像加载scsi驱动时注意选择磁盘驱动类型，要选择scsi模式，不要选择virtio模式