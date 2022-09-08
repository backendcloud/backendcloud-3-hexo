---
title: Docker Storage Driver - Overlay2
readmore: true
date: 2022-09-08 18:53:18
categories: 云原生
tags:
- Docker
- Storage Driver
---

# Overlay2

Linux提供了一种叫做联合文件系统的文件系统，它具备如下特性：

* 联合挂载：将多个目录按层次组合，一并挂载到一个联合挂载点。
* 写时复制：对联合挂载点的修改不会影响到底层的多个目录，而是使用其他目录记录修改的操作。

目前有多种文件系统可以被当作联合文件系统，实现如上的功能：overlay2，aufs，devicemapper，btrfs，zfs，vfs等等。而overlay2是docker目前推荐的文件系统：https://docs.docker.com/storage/storagedriver/select-storage-driver/

overlay2包括lowerdir，upperdir和merged三个层次，其中：
* lowerdir：表示较为底层的目录，修改联合挂载点不会影响到lowerdir。
* upperdir：表示较为上层的目录，修改联合挂载点会在upperdir同步修改。
* merged：是lowerdir和upperdir合并后的联合挂载点。
* workdir：用来存放挂载后的临时文件与间接文件。


# Docker 实验

```bash
[root@centos7 kubevirt]# docker run -d -p 5000:5000 --restart=always --name registry registry:2
Unable to find image 'registry:2' locally
Trying to pull repository docker.io/library/registry ... 
2: Pulling from docker.io/library/registry
213ec9aee27d: Pull complete 
5299e6f78605: Pull complete 
4c2fb79b7ce6: Pull complete 
74a97d2d84d9: Pull complete 
44c4c74a95e4: Pull complete 
Digest: sha256:83bb78d7b28f1ac99c68133af32c93e9a1c149bcd3cb6e683a3ee56e312f1c96
Status: Downloaded newer image for docker.io/registry:2
e9a3182ce19660264984b9c057e5cb01f8f3c478e515c3401117a856555bda74
[root@centos7 kubevirt]# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
e9a3182ce196        registry:2          "/entrypoint.sh /e..."   21 seconds ago      Up 21 seconds       0.0.0.0:5000->5000/tcp   registry
[root@centos7 kubevirt]# mount|grep overlay
/dev/mapper/centos-root on /var/lib/docker/overlay2 type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
overlay on /var/lib/docker/overlay2/f408abdbfe2c3fe90f84d50f16028bdcb3d865f7df23cce976bca77fc18e831c/merged type overlay (rw,relatime,context="system_u:object_r:container_file_t:s0:c88,c409",lowerdir=/var/lib/docker/overlay2/l/OLAQ7MQOXXNBFCPAZASEMGFRDT:/var/lib/docker/overlay2/l/OZ67SUB6WSDZ4WQDST6VRSAEFY:/var/lib/docker/overlay2/l/B52RB5YUGJXWBNNH7VOBZQZBLI:/var/lib/docker/overlay2/l/4ALOBU24OQJXJVNXCA5U52PCSV:/var/lib/docker/overlay2/l/3RDVYPKAIOMN6N6AU4CKFKWLTJ:/var/lib/docker/overlay2/l/2BWTKA2E4FN6DCMNHDMNAV5PRL,upperdir=/var/lib/docker/overlay2/f408abdbfe2c3fe90f84d50f16028bdcb3d865f7df23cce976bca77fc18e831c/diff,workdir=/var/lib/docker/overlay2/f408abdbfe2c3fe90f84d50f16028bdcb3d865f7df23cce976bca77fc18e831c/work)
```



可以看到：
* 联合挂载点merged：/var/lib/docker/overlay2/f408abdbfe2c3fe90f84d50f16028bdcb3d865f7df23cce976bca77fc18e831c/merged
* lowerdir：/var/lib/docker/overlay2/l/OLAQ7MQOXXNBFCPAZASEMGFRDT:/var/lib/docker/overlay2/l/OZ67SUB6WSDZ4WQDST6VRSAEFY:/var/lib/docker/overlay2/l/B52RB5YUGJXWBNNH7VOBZQZBLI:/var/lib/docker/overlay2/l/4ALOBU24OQJXJVNXCA5U52PCSV:/var/lib/docker/overlay2/l/3RDVYPKAIOMN6N6AU4CKFKWLTJ:/var/lib/docker/overlay2/l/2BWTKA2E4FN6DCMNHDMNAV5PRL
* upperdir：/var/lib/docker/overlay2/f408abdbfe2c3fe90f84d50f16028bdcb3d865f7df23cce976bca77fc18e831c/diff
* workdir：/var/lib/docker/overlay2/f408abdbfe2c3fe90f84d50f16028bdcb3d865f7df23cce976bca77fc18e831c/work




# 手动挂载实验

```bash
[root@centos7 tt]# tree
.
├── lower1
│   ├── a
│   └── b
├── lower2
│   └── a
├── merged
├── upper
│   └── c
└── work
    └── work

6 directories, 4 files
[root@centos7 tt]# mount -t overlay overlay -o lowerdir=lower1:lower2,upperdir=upper,workdir=work merged
[root@centos7 tt]# mount|grep overlay
/dev/mapper/centos-root on /var/lib/docker/overlay2 type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
overlay on /var/lib/docker/overlay2/f408abdbfe2c3fe90f84d50f16028bdcb3d865f7df23cce976bca77fc18e831c/merged type overlay (rw,relatime,context="system_u:object_r:container_file_t:s0:c88,c409",lowerdir=/var/lib/docker/overlay2/l/OLAQ7MQOXXNBFCPAZASEMGFRDT:/var/lib/docker/overlay2/l/OZ67SUB6WSDZ4WQDST6VRSAEFY:/var/lib/docker/overlay2/l/B52RB5YUGJXWBNNH7VOBZQZBLI:/var/lib/docker/overlay2/l/4ALOBU24OQJXJVNXCA5U52PCSV:/var/lib/docker/overlay2/l/3RDVYPKAIOMN6N6AU4CKFKWLTJ:/var/lib/docker/overlay2/l/2BWTKA2E4FN6DCMNHDMNAV5PRL,upperdir=/var/lib/docker/overlay2/f408abdbfe2c3fe90f84d50f16028bdcb3d865f7df23cce976bca77fc18e831c/diff,workdir=/var/lib/docker/overlay2/f408abdbfe2c3fe90f84d50f16028bdcb3d865f7df23cce976bca77fc18e831c/work)
overlay on /root/tt/merged type overlay (rw,relatime,seclabel,lowerdir=lower1:lower2,upperdir=upper,workdir=work)
[root@centos7 tt]# for i in `ls merged`;do echo $i: `cat merged/$i`;done
a: in lower1
b: in lower1
c: in upper
```

> 可以看到，从merged视角，位于lower2的a文件被lower1的a文件覆盖；b文件位于lower1，c文件位于upper，符合从高到低upper->lower1->lower2的层次结构。

在merged目录添加一个文件d, upper目录自动会对应增加文件d。
```bash
[root@centos7 tt]# touch merged/d
[root@centos7 tt]# tree
.
├── lower1
│   ├── a
│   └── b
├── lower2
│   └── a
├── merged
│   ├── a
│   ├── b
│   ├── c
│   └── d
├── upper
│   ├── c
│   └── d
└── work
    └── work

6 directories, 9 files
```


