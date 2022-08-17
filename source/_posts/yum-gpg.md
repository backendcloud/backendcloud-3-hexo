---
title: 创建一个带GPG-signed(gpgkey)的yum源
readmore: true
date: 2022-08-12 20:41:57
categories: 云原生
tags:
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

yum源的搭建参考之前发布的文章 {% post_link libvirt-compile %}

# Create a yum repository with custom GPG-signed RPM packages

## generate a GPG

```bash
[root@kubevirtci ~]# docker exec -ti libvirt-build bash
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
[root@c63843475281 libvirt-src]# cd /root/rpmbuild/RPMS/x86_64
[root@c63843475281 x86_64]# ls
libvirt-8.1.0-1.el8.x86_64.rpm                                    libvirt-daemon-driver-nwfilter-8.1.0-1.el8.x86_64.rpm                   libvirt-daemon-driver-storage-iscsi-8.1.0-1.el8.x86_64.rpm                   libvirt-debuginfo-8.1.0-1.el8.x86_64.rpm
libvirt-client-8.1.0-1.el8.x86_64.rpm                             libvirt-daemon-driver-nwfilter-debuginfo-8.1.0-1.el8.x86_64.rpm         libvirt-daemon-driver-storage-iscsi-debuginfo-8.1.0-1.el8.x86_64.rpm         libvirt-debugsource-8.1.0-1.el8.x86_64.rpm
libvirt-client-debuginfo-8.1.0-1.el8.x86_64.rpm                   libvirt-daemon-driver-qemu-8.1.0-1.el8.x86_64.rpm                       libvirt-daemon-driver-storage-iscsi-direct-8.1.0-1.el8.x86_64.rpm            libvirt-devel-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-8.1.0-1.el8.x86_64.rpm                             libvirt-daemon-driver-qemu-debuginfo-8.1.0-1.el8.x86_64.rpm             libvirt-daemon-driver-storage-iscsi-direct-debuginfo-8.1.0-1.el8.x86_64.rpm  libvirt-docs-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-config-network-8.1.0-1.el8.x86_64.rpm              libvirt-daemon-driver-secret-8.1.0-1.el8.x86_64.rpm                     libvirt-daemon-driver-storage-logical-8.1.0-1.el8.x86_64.rpm                 libvirt-libs-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-config-nwfilter-8.1.0-1.el8.x86_64.rpm             libvirt-daemon-driver-secret-debuginfo-8.1.0-1.el8.x86_64.rpm           libvirt-daemon-driver-storage-logical-debuginfo-8.1.0-1.el8.x86_64.rpm       libvirt-libs-debuginfo-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-debuginfo-8.1.0-1.el8.x86_64.rpm                   libvirt-daemon-driver-storage-8.1.0-1.el8.x86_64.rpm                    libvirt-daemon-driver-storage-mpath-8.1.0-1.el8.x86_64.rpm                   libvirt-lock-sanlock-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-driver-interface-8.1.0-1.el8.x86_64.rpm            libvirt-daemon-driver-storage-core-8.1.0-1.el8.x86_64.rpm               libvirt-daemon-driver-storage-mpath-debuginfo-8.1.0-1.el8.x86_64.rpm         libvirt-lock-sanlock-debuginfo-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-driver-interface-debuginfo-8.1.0-1.el8.x86_64.rpm  libvirt-daemon-driver-storage-core-debuginfo-8.1.0-1.el8.x86_64.rpm     libvirt-daemon-driver-storage-rbd-8.1.0-1.el8.x86_64.rpm                     libvirt-nss-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-driver-network-8.1.0-1.el8.x86_64.rpm              libvirt-daemon-driver-storage-disk-8.1.0-1.el8.x86_64.rpm               libvirt-daemon-driver-storage-rbd-debuginfo-8.1.0-1.el8.x86_64.rpm           libvirt-nss-debuginfo-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-driver-network-debuginfo-8.1.0-1.el8.x86_64.rpm    libvirt-daemon-driver-storage-disk-debuginfo-8.1.0-1.el8.x86_64.rpm     libvirt-daemon-driver-storage-scsi-8.1.0-1.el8.x86_64.rpm                    libvirt-wireshark-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-driver-nodedev-8.1.0-1.el8.x86_64.rpm              libvirt-daemon-driver-storage-gluster-8.1.0-1.el8.x86_64.rpm            libvirt-daemon-driver-storage-scsi-debuginfo-8.1.0-1.el8.x86_64.rpm          libvirt-wireshark-debuginfo-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-driver-nodedev-debuginfo-8.1.0-1.el8.x86_64.rpm    libvirt-daemon-driver-storage-gluster-debuginfo-8.1.0-1.el8.x86_64.rpm  libvirt-daemon-kvm-8.1.0-1.el8.x86_64.rpm                                    repodata
[root@c63843475281 x86_64]# gpg --gen-key
gpg (GnuPG) 2.2.20; Copyright (C) 2020 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

gpg: directory '/root/.gnupg' created
gpg: keybox '/root/.gnupg/pubring.kbx' created
Note: Use "gpg --full-generate-key" for a full featured key generation dialog.

GnuPG needs to construct a user ID to identify your key.

Real name: HANWEI
Email address: 
You selected this USER-ID:
    "HANWEI"

Change (N)ame, (E)mail, or (O)kay/(Q)uit? o
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
gpg: /root/.gnupg/trustdb.gpg: trustdb created
gpg: key A8191698A35A0504 marked as ultimately trusted
gpg: directory '/root/.gnupg/openpgp-revocs.d' created
gpg: revocation certificate stored as '/root/.gnupg/openpgp-revocs.d/FE12632135DB03D8DAE2F188A8191698A35A0504.rev'
public and secret key created and signed.

pub   rsa2048 2022-08-12 [SC] [expires: 2024-08-11]
      FE12632135DB03D8DAE2F188A8191698A35A0504
uid                      HANWEI
sub   rsa2048 2022-08-12 [E] [expires: 2024-08-11]

[root@c63843475281 x86_64]# 
```

## generate a GPG file

```bash
[root@c63843475281 x86_64]# gpg --export -a HANWEI > RPM-GPG-KEY-HANWEI
[root@c63843475281 x86_64]# ls
libvirt-8.1.0-1.el8.x86_64.rpm                                    libvirt-daemon-driver-nwfilter-debuginfo-8.1.0-1.el8.x86_64.rpm         libvirt-daemon-driver-storage-iscsi-direct-8.1.0-1.el8.x86_64.rpm            libvirt-docs-8.1.0-1.el8.x86_64.rpm
libvirt-client-8.1.0-1.el8.x86_64.rpm                             libvirt-daemon-driver-qemu-8.1.0-1.el8.x86_64.rpm                       libvirt-daemon-driver-storage-iscsi-direct-debuginfo-8.1.0-1.el8.x86_64.rpm  libvirt-libs-8.1.0-1.el8.x86_64.rpm
libvirt-client-debuginfo-8.1.0-1.el8.x86_64.rpm                   libvirt-daemon-driver-qemu-debuginfo-8.1.0-1.el8.x86_64.rpm             libvirt-daemon-driver-storage-logical-8.1.0-1.el8.x86_64.rpm                 libvirt-libs-debuginfo-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-8.1.0-1.el8.x86_64.rpm                             libvirt-daemon-driver-secret-8.1.0-1.el8.x86_64.rpm                     libvirt-daemon-driver-storage-logical-debuginfo-8.1.0-1.el8.x86_64.rpm       libvirt-lock-sanlock-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-config-network-8.1.0-1.el8.x86_64.rpm              libvirt-daemon-driver-secret-debuginfo-8.1.0-1.el8.x86_64.rpm           libvirt-daemon-driver-storage-mpath-8.1.0-1.el8.x86_64.rpm                   libvirt-lock-sanlock-debuginfo-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-config-nwfilter-8.1.0-1.el8.x86_64.rpm             libvirt-daemon-driver-storage-8.1.0-1.el8.x86_64.rpm                    libvirt-daemon-driver-storage-mpath-debuginfo-8.1.0-1.el8.x86_64.rpm         libvirt-nss-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-debuginfo-8.1.0-1.el8.x86_64.rpm                   libvirt-daemon-driver-storage-core-8.1.0-1.el8.x86_64.rpm               libvirt-daemon-driver-storage-rbd-8.1.0-1.el8.x86_64.rpm                     libvirt-nss-debuginfo-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-driver-interface-8.1.0-1.el8.x86_64.rpm            libvirt-daemon-driver-storage-core-debuginfo-8.1.0-1.el8.x86_64.rpm     libvirt-daemon-driver-storage-rbd-debuginfo-8.1.0-1.el8.x86_64.rpm           libvirt-wireshark-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-driver-interface-debuginfo-8.1.0-1.el8.x86_64.rpm  libvirt-daemon-driver-storage-disk-8.1.0-1.el8.x86_64.rpm               libvirt-daemon-driver-storage-scsi-8.1.0-1.el8.x86_64.rpm                    libvirt-wireshark-debuginfo-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-driver-network-8.1.0-1.el8.x86_64.rpm              libvirt-daemon-driver-storage-disk-debuginfo-8.1.0-1.el8.x86_64.rpm     libvirt-daemon-driver-storage-scsi-debuginfo-8.1.0-1.el8.x86_64.rpm          repodata
libvirt-daemon-driver-network-debuginfo-8.1.0-1.el8.x86_64.rpm    libvirt-daemon-driver-storage-gluster-8.1.0-1.el8.x86_64.rpm            libvirt-daemon-kvm-8.1.0-1.el8.x86_64.rpm                                    RPM-GPG-KEY-HANWEI
libvirt-daemon-driver-nodedev-8.1.0-1.el8.x86_64.rpm              libvirt-daemon-driver-storage-gluster-debuginfo-8.1.0-1.el8.x86_64.rpm  libvirt-debuginfo-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-driver-nodedev-debuginfo-8.1.0-1.el8.x86_64.rpm    libvirt-daemon-driver-storage-iscsi-8.1.0-1.el8.x86_64.rpm              libvirt-debugsource-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-driver-nwfilter-8.1.0-1.el8.x86_64.rpm             libvirt-daemon-driver-storage-iscsi-debuginfo-8.1.0-1.el8.x86_64.rpm    libvirt-devel-8.1.0-1.el8.x86_64.rpm
```

## Add the GPG signing details to your rpm environment

```bash
[root@c63843475281 x86_64]# rpm --import RPM-GPG-KEY-HANWEI
[root@c63843475281 x86_64]# rpm -q gpg-pubkey --qf '%{NAME}-%{VERSION}-%{RELEASE}\t%{SUMMARY}\n'
gpg-pubkey-fd431d51-4ae0493b    gpg(Red Hat, Inc. (release key 2) <security@redhat.com>)
gpg-pubkey-d4082792-5b32db75    gpg(Red Hat, Inc. (auxiliary key) <security@redhat.com>)
gpg-pubkey-8483c65d-5ccc5b19    gpg(CentOS (CentOS Official Signing Key) <security@centos.org>)
gpg-pubkey-2f86d6a1-5cf7cefb    gpg(Fedora EPEL (8) <epel@fedoraproject.org>)
gpg-pubkey-a35a0504-62f64af4    gpg(HANWEI)
[root@c63843475281 x86_64]# echo "%_signature gpg" > ~/.rpmmacros
[root@c63843475281 x86_64]# echo "%_gpg_name HANWEI" >> ~/.rpmmacros
[root@c63843475281 x86_64]# cat ~/.rpmmacros 
%_signature gpg
%_gpg_name HANWEI
```

## sign RPMs with the GPG key

### before sign

```bash
[root@c63843475281 x86_64]# rpm -qpi *.rpm | awk '/Signature/'
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
Signature   : (none)
```

### sign process

```bash
[root@c63843475281 x86_64]# rpm --resign *.rpm
rpm: /usr/bin/rpmsign: No such file or directory
[root@c63843475281 x86_64]# yum install -y rpm-sign
Last metadata expiration check: 2:58:09 ago on Fri 12 Aug 2022 09:52:41 AM UTC.
Dependencies resolved.
====================================================================================================================================================================================================================================================================================== Package                                                            Architecture                                                     Version                                                                   Repository                                                        Size
======================================================================================================================================================================================================================================================================================Installing:
 rpm-sign                                                           x86_64                                                           4.14.3-23.el8                                                             baseos                                                            81 k

Transaction Summary
======================================================================================================================================================================================================================================================================================Install  1 Package

Total download size: 81 k
Installed size: 18 k
Downloading Packages:
rpm-sign-4.14.3-23.el8.x86_64.rpm                                                                                                                                                                                                                     278 kB/s |  81 kB     00:00    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------Total                                                                                                                                                                                                                                                  90 kB/s |  81 kB     00:00     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                                                                                              1/1 
  Installing       : rpm-sign-4.14.3-23.el8.x86_64                                                                                                                                                                                                                                1/1 
  Running scriptlet: rpm-sign-4.14.3-23.el8.x86_64                                                                                                                                                                                                                                1/1 
  Verifying        : rpm-sign-4.14.3-23.el8.x86_64                                                                                                                                                                                                                                1/1 

Installed:
  rpm-sign-4.14.3-23.el8.x86_64                                                                                                                                                                                                                                                       

Complete!
[root@c63843475281 x86_64]# rpm --resign *.rpm
libvirt-8.1.0-1.el8.x86_64.rpm:
libvirt-client-8.1.0-1.el8.x86_64.rpm:
libvirt-client-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-config-network-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-config-nwfilter-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-interface-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-interface-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-network-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-network-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-nodedev-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-nodedev-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-nwfilter-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-nwfilter-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-qemu-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-qemu-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-secret-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-secret-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-core-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-core-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-disk-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-disk-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-gluster-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-gluster-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-iscsi-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-iscsi-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-iscsi-direct-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-iscsi-direct-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-logical-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-logical-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-mpath-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-mpath-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-rbd-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-rbd-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-scsi-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-driver-storage-scsi-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-daemon-kvm-8.1.0-1.el8.x86_64.rpm:
libvirt-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-debugsource-8.1.0-1.el8.x86_64.rpm:
libvirt-devel-8.1.0-1.el8.x86_64.rpm:
libvirt-docs-8.1.0-1.el8.x86_64.rpm:
libvirt-libs-8.1.0-1.el8.x86_64.rpm:
libvirt-libs-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-lock-sanlock-8.1.0-1.el8.x86_64.rpm:
libvirt-lock-sanlock-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-nss-8.1.0-1.el8.x86_64.rpm:
libvirt-nss-debuginfo-8.1.0-1.el8.x86_64.rpm:
libvirt-wireshark-8.1.0-1.el8.x86_64.rpm:
libvirt-wireshark-debuginfo-8.1.0-1.el8.x86_64.rpm:
```

> 报错：rpm: /usr/bin/rpmsign: No such file or directory
>
> 缺少rpmsign工具，yum install -y rpm-sign 解决

### after sign (check)
```bash
[root@c63843475281 x86_64]# rpm -qpi *.rpm | awk '/Signature/'
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:25 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:28 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:28 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:29 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:29 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:29 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:29 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:30 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:30 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:30 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:30 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:31 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:31 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:31 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:31 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:32 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:32 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:32 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:32 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:33 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:33 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:33 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:33 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:34 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:34 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:34 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:34 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:35 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:35 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:35 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:35 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:36 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:36 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:36 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:36 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:37 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:37 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:37 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:37 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:38 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:38 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:38 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:38 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:39 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:39 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:39 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:39 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:40 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:40 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:40 PM UTC, Key ID a8191698a35a0504
Signature   : RSA/SHA256, Fri 12 Aug 2022 12:51:40 PM UTC, Key ID a8191698a35a0504
```

## set /etc/yum.rep.d/xxx.repo or repo.list or other...

```bash
[root@kubevirtci bazeldnf]# cat rpm/repo.yaml 
repositories:
- arch: x86_64
  baseurl: http://10.88.0.140:80/x86_64/
  name: centos/custom-build
  gpgkey: http://10.88.0.140:80/x86_64/RPM-GPG-KEY-HANWEI
```