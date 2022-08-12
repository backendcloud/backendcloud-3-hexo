---
title: bazeldnf 的简单使用
readmore: true
date: 2022-08-12 18:59:38
categories: 云原生
tags:
- Bazel
- bazeldnf
---

yum源的搭建参考之前发布的文章 {% post_link libvirt-compile %}

# fetch repo

```bash
[root@kubevirtci bazeldnf]# git clone https://github.com/rmohr/bazeldnf
[root@kubevirtci bazeldnf]# cd bazeldnf
[root@kubevirtci bazeldnf]# cat rpm/repo.yaml 
repositories:
- arch: x86_64
  baseurl: http://10.88.0.140:80/x86_64/
  name: centos/custom-build
- arch: x86_64
  baseurl: http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/
  name: centos/stream8-baseos-x86_64
  gpgkey: https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
- arch: x86_64
  baseurl: http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/
  name: centos/stream8-appstream-x86_64
  gpgkey: https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
- arch: x86_64
  baseurl: http://mirror.centos.org/centos/8-stream/PowerTools/x86_64/os/
  name: centos/stream8-powertools-x86_64
  gpgkey: https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
[root@kubevirtci bazeldnf]# touch rpm/BUILD.bazel
```

```bash
[root@kubevirtci bazeldnf]# bazelisk run //:bazeldnf -- fetch --repofile rpm/repo.yaml
INFO: Analyzed target //:bazeldnf (4 packages loaded, 196 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 1.174s, Critical Path: 0.01s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO[0000] Resolving repomd.xml from http://10.88.0.140:80/x86_64/repodata/repomd.xml 
INFO[0000] Loading primary file from http://10.88.0.140:80/x86_64/repodata/b32ad07ab44719bcf39ae9c7ff03e295b8b420f7fc772da9977f9e03b416fe02-primary.xml.gz 
INFO[0000] Resolving repomd.xml from http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/repodata/repomd.xml 
INFO[0000] Loading primary file from http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/repodata/0e0c5fca0529c8d38204394fab49269af56edb6f335a9336d4840bc0dea33774-primary.xml.gz 
INFO[0004] Resolving repomd.xml from http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/repodata/repomd.xml 
INFO[0004] Loading primary file from http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/repodata/bf0a4a8aaa71b19d46f50628f302ed84cf9c8723fe6ea427ccfcbcc153333202-primary.xml.gz 
INFO[0006] Resolving repomd.xml from http://mirror.centos.org/centos/8-stream/PowerTools/x86_64/os/repodata/repomd.xml 
INFO[0006] Loading primary file from http://mirror.centos.org/centos/8-stream/PowerTools/x86_64/os/repodata/0520cf71ca0379e3a94ff114d5028292f17b8518ad1e0b49fece03eff1ce6d5d-primary.xml.gz 
```

# create rpmtree for bazel

```bash
[root@kubevirtci bazeldnf]# bazelisk run //:bazeldnf -- rpmtree --public --nobest --name testimage_x86_64 --basesystem centos-stream-release --repofile rpm/repo.yaml libvirt-0:8.1.0-1.el8
INFO: Analyzed target //:bazeldnf (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 0.123s, Critical Path: 0.00s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO[0000] Loading packages.                            
INFO[0008] Initial reduction of involved packages.      
INFO[0009] Loading involved packages into the rpmtreer. 
INFO[0009] Loaded 5423 packages.                        
INFO[0009] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0009] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0009] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0009] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0009] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0010] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0010] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0010] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0010] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0010] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0010] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0010] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0010] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0010] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0010] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0010] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0010] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0010] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0010] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0010] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0010] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0010] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0010] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0010] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0010] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] Generated 25514 variables.                   
INFO[0010] Adding required packages to the rpmtreer.    
INFO[0010] Selecting libvirt: libvirt-0:8.1.0-1.el8     
INFO[0010] Selecting centos-stream-release: centos-stream-release-0:8.6-1.el8 
INFO[0010] Solving.                                     
INFO[0010] Loading the Partial weighted MAXSAT problem. 
INFO[0017] Solving the Partial weighted MAXSAT problem. 
INFO[0017] Solution with weight -198 found.             
INFO[0017] Picking selinux-policy-0:3.14.3-93.el8 instead of best candiate selinux-policy-0:3.14.3-105.el8 
INFO[0017] Picking selinux-policy-minimum-0:3.14.3-93.el8 instead of best candiate selinux-policy-minimum-0:3.14.3-105.el8 
INFO[0017] Writing bazel files.                         
Package                                         Version                                                         Size            Download Size
Installing:
 libvirt-daemon-driver-network                  0:8.1.0-1.el8                                                   680.65 K        181.42 K
 rpm                                            0:4.14.3-23.el8                                                 2.12 M          556.35 K
 ncurses-base                                   0:6.1-9.20180224.el8                                            314.23 K        83.08 K
 libidn2                                        0:2.2.0-1.el8                                                   293.60 K        96.02 K
 boost-system                                   0:1.66.0-13.el8                                                 22.68 K         18.68 K
 libarchive                                     0:3.3.3-4.el8                                                   840.36 K        368.60 K
 device-mapper-persistent-data                  0:0.9.0-7.el8                                                   3.37 M          949.31 K
 selinux-policy                                 0:3.14.3-93.el8                                                 26.06 K         659.85 K
 iptables                                       0:1.8.4-22.el8                                                  2.03 M          598.52 K
 libcollection                                  0:0.7.0-40.el8                                                  98.13 K         49.24 K
 cryptsetup-libs                                0:2.3.7-2.el8                                                   2.15 M          499.32 K
 mozjs60                                        0:60.9.0-4.el8                                                  23.73 M         6.93 M
 python3-pip-wheel                              0:9.0.3-22.el8                                                  930.56 K        916.30 K
 libvirt-daemon-driver-storage-disk             0:8.1.0-1.el8                                                   29.62 K         18.16 K
 systemd-udev                                   0:239-62.el8                                                    9.39 M          1.65 M
 libtpms                                        0:0.9.1-0.20211126git1ff6fe1f43.module_el8.6.0+1087+b42c8331    403.98 K        188.85 K
 lvm2-libs                                      8:2.03.14-5.el8                                                 2.80 M          1.24 M
 policycoreutils                                0:2.9-19.el8                                                    696.88 K        383.17 K
 nspr                                           0:4.34.0-3.el8                                                  323.61 K        146.38 K
 libbpf                                         0:0.5.0-1.el8                                                   308.74 K        139.97 K
 boost-date-time                                0:1.66.0-13.el8                                                 80.65 K         30.45 K
 iptables-libs                                  0:1.8.4-22.el8                                                  206.50 K        110.38 K
 libvirt-daemon-driver-storage-rbd              0:8.1.0-1.el8                                                   42.02 K         23.22 K
 dmidecode                                      1:3.3-4.el8                                                     230.33 K        94.38 K
 systemd-container                              0:239-62.el8                                                    1.72 M          780.39 K
 ca-certificates                                0:2021.2.50-82.el8                                              936.15 K        399.50 K
 python3-libselinux                             0:2.9-5.el8                                                     792.30 K        289.67 K
 libnghttp2                                     0:1.33.0-3.el8_2.1                                              169.26 K        79.21 K
 p11-kit                                        0:0.23.22-1.el8                                                 1.65 M          332.07 K
 libvirt-daemon-driver-qemu                     0:8.1.0-1.el8                                                   2.65 M          883.22 K
 policycoreutils-python-utils                   0:2.9-19.el8                                                    147.96 K        258.84 K
 pcre                                           0:8.42-6.el8                                                    512.34 K        215.63 K
 boost-atomic                                   0:1.66.0-13.el8                                                 9.94 K          14.47 K
 dbus-common                                    1:1.12.8-19.el8                                                 12.92 K         47.28 K
 crypto-policies-scripts                        0:20211116-1.gitae470d6.el8                                     204.40 K        85.20 K
 xz-libs                                        0:5.2.4-4.el8                                                   166.00 K        96.08 K
 libsigsegv                                     0:2.11-5.el8                                                    48.83 K         30.98 K
 pcre2                                          0:10.32-3.el8                                                   659.32 K        252.57 K
 quota                                          1:4.04-14.el8                                                   916.51 K        218.72 K
 systemd-pam                                    0:239-62.el8                                                    919.78 K        499.31 K
 gssproxy                                       0:0.8.0-21.el8                                                  272.12 K        122.28 K
 polkit                                         0:0.115-13.0.1.el8.2                                            417.58 K        157.70 K
 libvirt-daemon                                 0:8.1.0-1.el8                                                   1.62 M          369.44 K
 python3-setuptools-wheel                       0:39.2.0-6.el8                                                  348.48 K        295.73 K
 python3-setools                                0:4.3.0-3.el8                                                   2.75 M          639.22 K
 libuuid                                        0:2.32.1-35.el8                                                 36.42 K         99.23 K
 gettext                                        0:0.19.8.1-17.el8                                               5.45 M          1.12 M
 libsmartcols                                   0:2.32.1-35.el8                                                 249.71 K        182.16 K
 dbus-daemon                                    1:1.12.8-19.el8                                                 565.57 K        246.20 K
 gdbm                                           1:1.18-2.el8                                                    394.69 K        132.78 K
 libdb-utils                                    0:5.3.28-42.el8_4                                               379.20 K        153.24 K
 device-mapper-event-libs                       8:1.02.181-5.el8                                                55.88 K         276.56 K
 libvirt-daemon-config-nwfilter                 0:8.1.0-1.el8                                                   14.50 K         15.38 K
 platform-python-setuptools                     0:39.2.0-6.el8                                                  2.99 M          647.44 K
 nss-util                                       0:3.79.0-5.el8                                                  225.90 K        141.23 K
 diffutils                                      0:3.6-6.el8                                                     1.38 M          366.90 K
 swtpm-tools                                    0:0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331       275.40 K        121.56 K
 autogen-libopts                                0:5.18.12-8.el8                                                 151.05 K        76.80 K
 curl                                           0:7.61.1-25.el8                                                 703.48 K        360.54 K
 checkpolicy                                    0:2.9-1.el8                                                     1.77 M          356.58 K
 libmount                                       0:2.32.1-35.el8                                                 399.50 K        240.58 K
 polkit-pkla-compat                             0:0.1-12.el8                                                    100.51 K        46.97 K
 lua-libs                                       0:5.3.4-12.el8                                                  248.67 K        120.76 K
 elfutils-default-yama-scope                    0:0.187-4.el8                                                   2.09 K          52.83 K
 libcap-ng                                      0:0.7.11-1.el8                                                  52.67 K         34.19 K
 libpsl                                         0:0.20.2-6.el8                                                  71.92 K         62.86 K
 libnfnetlink                                   0:1.0.1-13.el8                                                  53.90 K         33.72 K
 boost-chrono                                   0:1.66.0-13.el8                                                 39.69 K         23.77 K
 libvirt-daemon-driver-nwfilter                 0:8.1.0-1.el8                                                   666.27 K        181.13 K
 python3-libsemanage                            0:2.9-8.el8                                                     455.32 K        131.26 K
 libtirpc                                       0:1.1.4-7.el8                                                   226.51 K        115.29 K
 kmod-libs                                      0:25-19.el8                                                     127.82 K        70.08 K
 glusterfs-cli                                  0:6.0-56.4.el8                                                  521.12 K        198.90 K
 libcom_err                                     0:1.45.6-5.el8                                                  62.58 K         50.52 K
 glusterfs                                      0:6.0-56.4.el8                                                  2.91 M          682.54 K
 boost-program-options                          0:1.66.0-13.el8                                                 537.02 K        144.13 K
 p11-kit-trust                                  0:0.23.22-1.el8                                                 473.54 K        140.29 K
 augeas-libs                                    0:1.12.0-7.el8                                                  1.43 M          447.30 K
 gzip                                           0:1.9-13.el8                                                    358.66 K        170.78 K
 pam                                            0:1.3.1-22.el8                                                  2.72 M          760.84 K
 expat                                          0:2.2.5-9.el8                                                   317.50 K        115.90 K
 libcap                                         0:2.48-4.el8                                                    169.93 K        75.80 K
 selinux-policy-minimum                         0:3.14.3-93.el8                                                 35.40 M         13.79 M
 basesystem                                     0:11-5.el8                                                      124             10.75 K
 libref_array                                   0:0.1.5-40.el8                                                  56.13 K         33.65 K
 libvirt-daemon-driver-interface                0:8.1.0-1.el8                                                   605.72 K        155.18 K
 gnutls-utils                                   0:3.6.16-4.el8                                                  1.52 M          356.62 K
 krb5-libs                                      0:1.18.2-21.el8                                                 2.25 M          860.54 K
 glusterfs-client-xlators                       0:6.0-56.4.el8                                                  4.32 M          904.10 K
 nettle                                         0:3.4.1-7.el8                                                   575.76 K        308.24 K
 cracklib-dicts                                 0:2.9.6-15.el8                                                  9.82 M          4.14 M
 lvm2                                           8:2.03.14-5.el8                                                 3.90 M          1.75 M
 libvirt-daemon-driver-storage-gluster          0:8.1.0-1.el8                                                   37.96 K         20.05 K
 libyaml                                        0:0.1.7-5.el8                                                   137.96 K        62.88 K
 libdb                                          0:5.3.28-42.el8_4                                               1.90 M          769.40 K
 setup                                          0:2.12.2-7.el8                                                  729.30 K        185.09 K
 coreutils-common                               0:8.30-13.el8                                                   9.93 M          2.09 M
 libnsl2                                        0:1.2.0-2.20180605git4a062cf.el8                                148.31 K        59.10 K
 cyrus-sasl                                     0:2.1.27-6.el8_5                                                156.32 K        98.72 K
 quota-nls                                      1:4.04-14.el8                                                   284.64 K        96.97 K
 libblkid                                       0:2.32.1-35.el8                                                 345.00 K        223.77 K
 libvirt-daemon-driver-storage-scsi             0:8.1.0-1.el8                                                   21.30 K         14.89 K
 nss-sysinit                                    0:3.79.0-5.el8                                                  15.46 K         75.57 K
 libseccomp                                     0:2.5.2-1.el8                                                   171.61 K        72.91 K
 dbus                                           1:1.12.8-19.el8                                                 124             42.43 K
 libiscsi                                       0:1.18.0-8.module_el8.6.0+983+a7505f3f                          232.50 K        91.55 K
 gdbm-libs                                      1:1.18-2.el8                                                    120.33 K        61.79 K
 keyutils                                       0:1.5.10-9.el8                                                  124.41 K        67.79 K
 centos-stream-release                          0:8.6-1.el8                                                     29.43 K         22.74 K
 python3-libs                                   0:3.6.8-47.el8                                                  32.78 M         8.23 M
 libsemanage                                    0:2.9-8.el8                                                     314.37 K        171.92 K
 ncurses                                        0:6.1-9.20180224.el8                                            596.08 K        396.27 K
 nss-softokn                                    0:3.79.0-5.el8                                                  3.87 M          1.26 M
 librdmacm                                      0:37.2-1.el8                                                    145.29 K        79.63 K
 libverto                                       0:0.3.2-2.el8                                                   28.70 K         24.60 K
 mpfr                                           0:3.1.6-1.el8                                                   614.92 K        226.70 K
 unbound-libs                                   0:1.16.0-2.el8                                                  1.55 M          580.36 K
 rpcbind                                        0:1.2.5-9.el8                                                   113.80 K        71.55 K
 libevent                                       0:2.1.8-5.el8                                                   925.20 K        259.53 K
 glusterfs-api                                  0:6.0-56.4.el8                                                  228.32 K        101.66 K
 libxslt                                        0:1.1.32-6.el8                                                  755.20 K        255.56 K
 device-mapper-event                            8:1.02.181-5.el8                                                49.62 K         277.71 K
 gmp                                            1:6.1.2-10.el8                                                  1.68 M          329.75 K
 python3-pyyaml                                 0:3.12-12.el8                                                   662.04 K        197.68 K
 device-mapper                                  8:1.02.181-5.el8                                                361.67 K        386.42 K
 numad                                          0:0.5-26.20150602git.el8                                        60.31 K         42.23 K
 dbus-libs                                      1:1.12.8-19.el8                                                 381.96 K        188.54 K
 boost-iostreams                                0:1.66.0-13.el8                                                 134.41 K        42.87 K
 python3-policycoreutils                        0:2.9-19.el8                                                    5.75 M          2.35 M
 python3-audit                                  0:3.0.7-4.el8                                                   337.20 K        88.90 K
 keyutils-libs                                  0:1.5.10-9.el8                                                  45.16 K         34.78 K
 gettext-libs                                   0:0.19.8.1-17.el8                                               1.62 M          321.58 K
 info                                           0:6.5-7.el8_5                                                   387.26 K        203.23 K
 libpwquality                                   0:1.4.4-3.el8                                                   409.00 K        109.43 K
 libverto-libev                                 0:0.3.2-2.el8                                                   13.04 K         16.53 K
 device-mapper-libs                             8:1.02.181-5.el8                                                416.88 K        419.54 K
 glibc-langpack-ur                              0:2.28-208.el8                                                  2.94 M          432.10 K
 libaio                                         0:0.3.112-1.el8                                                 98.80 K         33.41 K
 e2fsprogs-libs                                 0:1.45.6-5.el8                                                  522.62 K        238.70 K
 libacl                                         0:2.2.53-1.el8                                                  60.18 K         35.62 K
 util-linux                                     0:2.32.1-35.el8                                                 11.65 M         2.59 M
 cracklib                                       0:2.9.6-15.el8                                                  250.87 K        95.50 K
 parted                                         0:3.2-39.el8                                                    2.13 M          568.77 K
 dbus-tools                                     1:1.12.8-19.el8                                                 128.05 K        87.70 K
 libgomp                                        0:8.5.0-15.el8                                                  333.47 K        212.10 K
 lzo                                            0:2.08-14.el8                                                   200.48 K        70.85 K
 sed                                            0:4.5-5.el8                                                     773.39 K        305.33 K
 openssl-libs                                   1:1.1.1k-6.el8                                                  3.77 M          1.54 M
 audit-libs                                     0:3.0.7-4.el8                                                   310.77 K        125.88 K
 libicu                                         0:60.3-2.el8_1                                                  33.72 M         9.27 M
 libxml2                                        0:2.9.7-14.el8                                                  1.76 M          712.30 K
 libstdc++                                      0:8.5.0-15.el8                                                  1.86 M          464.94 K
 libnftnl                                       0:1.1.5-5.el8                                                   223.62 K        84.97 K
 libvirt-daemon-driver-nodedev                  0:8.1.0-1.el8                                                   636.30 K        166.16 K
 nfs-utils                                      1:2.3.3-56.el8                                                  1.66 M          526.79 K
 libcroco                                       0:0.6.12-4.el8_2.1                                              333.22 K        115.22 K
 libxcrypt                                      0:4.1.1-6.el8                                                   188.42 K        74.48 K
 iproute                                        0:5.18.0-1.el8                                                  2.51 M          827.78 K
 iproute-tc                                     0:5.18.0-1.el8                                                  910.20 K        477.10 K
 crypto-policies                                0:20211116-1.gitae470d6.el8                                     94.23 K         65.20 K
 glusterfs-libs                                 0:6.0-56.4.el8                                                  1.74 M          428.49 K
 gnutls                                         0:3.6.16-4.el8                                                  3.01 M          1.04 M
 iptables-ebtables                              0:1.8.4-22.el8                                                  15.23 K         73.78 K
 elfutils-libelf                                0:0.187-4.el8                                                   1.03 M          236.61 K
 isns-utils-libs                                0:0.99-1.el8                                                    631.88 K        107.48 K
 coreutils                                      0:8.30-13.el8                                                   6.15 M          1.27 M
 libvirt-daemon-driver-storage-iscsi-direct     0:8.1.0-1.el8                                                   25.50 K         17.08 K
 lz4-libs                                       0:1.8.3-3.el8_4                                                 122.25 K        67.35 K
 openldap                                       0:2.4.46-18.el8                                                 1.01 M          360.92 K
 libvirt                                        0:8.1.0-1.el8                                                   124             6.89 K
 bzip2                                          0:1.0.6-26.el8                                                  98.39 K         61.62 K
 nss                                            0:3.79.0-5.el8                                                  2.06 M          764.20 K
 swtpm                                          0:0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331       219.14 K        43.63 K
 qemu-img                                       15:6.2.0-12.module_el8.7.0+1140+ff0772f9                        8.57 M          2.25 M
 glibc                                          0:2.28-208.el8                                                  6.79 M          2.31 M
 sqlite-libs                                    0:3.26.0-15.el8                                                 1.17 M          594.68 K
 iscsi-initiator-utils-iscsiuio                 0:6.2.1.4-4.git095f59c.el8                                      190.95 K        102.82 K
 libsepol                                       0:2.9-3.el8                                                     762.65 K        348.04 K
 polkit-libs                                    0:0.115-13.0.1.el8.2                                            198.83 K        78.30 K
 libpciaccess                                   0:0.14-1.el8                                                    51.76 K         33.25 K
 libunistring                                   0:0.9.9-3.el8                                                   1.86 M          432.42 K
 publicsuffix-list-dafsa                        0:20180723-1.el8                                                65.24 K         57.47 K
 platform-python                                0:3.6.8-47.el8                                                  43.80 K         87.83 K
 mdevctl                                        0:1.1.0-2.el8                                                   2.05 M          772.85 K
 elfutils-libs                                  0:0.187-4.el8                                                   715.10 K        304.02 K
 libvirt-daemon-driver-secret                   0:8.1.0-1.el8                                                   569.48 K        143.64 K
 xz                                             0:5.2.4-4.el8                                                   431.14 K        156.84 K
 rpm-plugin-selinux                             0:4.14.3-23.el8                                                 12.75 K         79.46 K
 systemd-libs                                   0:239-62.el8                                                    4.59 M          1.16 M
 libvirt-daemon-driver-storage-mpath            0:8.1.0-1.el8                                                   12.85 K         12.51 K
 dnsmasq                                        0:2.79-23.el8                                                   670.11 K        328.25 K
 json-c                                         0:0.13.1-3.el8                                                  70.64 K         41.66 K
 libgcc                                         0:8.5.0-15.el8                                                  192.02 K        82.59 K
 yajl                                           0:2.1.0-11.el8                                                  85.42 K         41.67 K
 acl                                            0:2.2.53-1.el8                                                  209.64 K        82.99 K
 shadow-utils                                   2:4.6-17.el8                                                    4.13 M          1.29 M
 zlib                                           0:1.2.11-19.el8                                                 201.55 K        105.06 K
 centos-gpg-keys                                1:8-6.el8                                                       6.28 K          14.63 K
 libcurl                                        0:7.61.1-25.el8                                                 594.70 K        309.01 K
 iscsi-initiator-utils                          0:6.2.1.4-4.git095f59c.el8                                      1.81 M          386.82 K
 libgpg-error                                   0:1.31-1.el8                                                    908.91 K        247.52 K
 json-glib                                      0:1.4.4-1.el8                                                   541.04 K        147.74 K
 libfdisk                                       0:2.32.1-35.el8                                                 440.11 K        258.05 K
 rpm-libs                                       0:4.14.3-23.el8                                                 737.20 K        353.40 K
 libvirt-daemon-driver-storage                  0:8.1.0-1.el8                                                   124             6.77 K
 tzdata                                         0:2022a-2.el8                                                   2.18 M          485.40 K
 readline                                       0:7.0-10.el8                                                    468.61 K        204.02 K
 libattr                                        0:2.4.48-3.el8                                                  28.38 K         27.56 K
 cyrus-sasl-gssapi                              0:2.1.27-6.el8_5                                                42.86 K         51.06 K
 libgcrypt                                      0:1.8.5-7.el8                                                   1.27 M          473.84 K
 libvirt-client                                 0:8.1.0-1.el8                                                   1.02 M          365.76 K
 chkconfig                                      0:1.19.1-1.el8                                                  843.79 K        203.05 K
 libssh-config                                  0:0.9.6-3.el8                                                   816             19.75 K
 librbd1                                        1:12.2.7-9.el8                                                  4.64 M          1.14 M
 libutempter                                    0:1.1.6-14.el8                                                  54.63 K         32.46 K
 centos-stream-repos                            0:8-6.el8                                                       30.21 K         20.59 K
 libev                                          0:4.24-6.el8                                                    103.42 K        53.71 K
 libibverbs                                     0:37.2-1.el8                                                    1.02 M          393.71 K
 boost-random                                   0:1.66.0-13.el8                                                 39.07 K         22.85 K
 libvirt-daemon-config-network                  0:8.1.0-1.el8                                                   644             9.44 K
 boost-thread                                   0:1.66.0-13.el8                                                 183.57 K        60.11 K
 lzop                                           0:1.03-20.el8                                                   116.16 K        63.36 K
 hwdata                                         0:0.314-8.13.el8                                                8.87 M          1.82 M
 libffi                                         0:3.1-23.el8                                                    55.29 K         38.32 K
 nss-softokn-freebl                             0:3.79.0-5.el8                                                  813.46 K        406.99 K
 glib2                                          0:2.56.4-159.el8                                                12.30 M         2.61 M
 numactl-libs                                   0:2.0.12-13.el8                                                 52.09 K         36.99 K
 libvirt-libs                                   0:8.1.0-1.el8                                                   24.40 M         4.87 M
 libvirt-daemon-driver-storage-logical          0:8.1.0-1.el8                                                   29.59 K         18.98 K
 libpcap                                        14:1.9.1-5.el8                                                  387.00 K        172.74 K
 glibc-common                                   0:2.28-208.el8                                                  8.01 M          1.04 M
 libmnl                                         0:1.0.4-6.el8                                                   55.15 K         31.04 K
 boost-regex                                    0:1.66.0-13.el8                                                 1.18 M          287.33 K
 grep                                           0:3.1-6.el8                                                     845.03 K        280.36 K
 libselinux-utils                               0:2.9-5.el8                                                     328.67 K        248.57 K
 ncurses-libs                                   0:6.1-9.20180224.el8                                            958.61 K        341.76 K
 gnutls-dane                                    0:3.6.16-4.el8                                                  47.14 K         53.34 K
 cyrus-sasl-lib                                 0:2.1.27-6.el8_5                                                732.16 K        126.32 K
 librados2                                      1:12.2.7-9.el8                                                  12.86 M         3.04 M
 libnetfilter_conntrack                         0:1.0.6-5.el8                                                   166.47 K        66.28 K
 libvirt-daemon-driver-storage-iscsi            0:8.1.0-1.el8                                                   21.30 K         15.10 K
 popt                                           0:1.18-1.el8                                                    133.12 K        62.82 K
 brotli                                         0:1.0.6-3.el8                                                   1.53 M          330.87 K
 systemd                                        0:239-62.el8                                                    11.39 M         3.77 M
 bash                                           0:4.4.20-4.el8                                                  6.88 M          1.62 M
 libpath_utils                                  0:0.2.1-40.el8                                                  60.26 K         35.07 K
 libzstd                                        0:1.4.4-1.el8                                                   699.40 K        272.32 K
 psmisc                                         0:23.1-5.el8                                                    503.50 K        154.36 K
 libselinux                                     0:2.9-5.el8                                                     170.92 K        169.13 K
 gawk                                           0:4.2.1-4.el8                                                   2.72 M          1.19 M
 libini_config                                  0:1.3.1-40.el8                                                  156.25 K        72.16 K
 libtasn1                                       0:4.13-3.el8                                                    170.78 K        78.01 K
 bzip2-libs                                     0:1.0.6-26.el8                                                  78.42 K         49.10 K
 libnl3                                         0:3.7.0-1.el8                                                   1.06 M          345.42 K
 swtpm-libs                                     0:0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331       99.70 K         49.81 K
 libssh                                         0:0.9.6-3.el8                                                   519.94 K        221.38 K
 libvirt-daemon-driver-storage-core             0:8.1.0-1.el8                                                   741.98 K        200.92 K
 filesystem                                     0:3.8-6.el8                                                     215.45 K        1.14 M
 libnfsidmap                                    1:2.3.3-56.el8                                                  199.18 K        124.68 K
 kmod                                           0:25-19.el8                                                     249.21 K        129.17 K
 netcf-libs                                     0:0.2.8-12.module_el8.6.0+983+a7505f3f                          213.40 K        78.40 K
 libbasicobjects                                0:0.1.1-40.el8                                                  55.98 K         32.18 K
Ignoring:

Transaction Summary:
Installing 262 Packages 
Total download size: 138.73 M
Total install size: 455.55 M
```

# 检查 BUILD文件 是否都是libvirt-0:8.1.0-1.el8依赖的rpm

```bash
[root@kubevirtci ~]# cd bazeldnf/
[root@kubevirtci bazeldnf]# ls
bazel-bazeldnf  bazel-bin  bazel-out  bazel-testlogs  BUILD.bazel  cmd  def.bzl  deps.bzl  go.mod  go.sum  internal  Makefile  pkg  README.md  rpm  WORKSPACE
[root@kubevirtci bazeldnf]# cat rpm/BUILD.bazel 
rpmtree(
    name = "testimage_x86_64",
    rpms = [
        "@acl-0__2.2.53-1.el8.x86_64//rpm",
        "@audit-libs-0__3.0.7-4.el8.x86_64//rpm",
        "@augeas-libs-0__1.12.0-7.el8.x86_64//rpm",
        "@autogen-libopts-0__5.18.12-8.el8.x86_64//rpm",
        "@basesystem-0__11-5.el8.x86_64//rpm",
        "@bash-0__4.4.20-4.el8.x86_64//rpm",
        "@boost-atomic-0__1.66.0-13.el8.x86_64//rpm",
        "@boost-chrono-0__1.66.0-13.el8.x86_64//rpm",
        "@boost-date-time-0__1.66.0-13.el8.x86_64//rpm",
        "@boost-iostreams-0__1.66.0-13.el8.x86_64//rpm",
        "@boost-program-options-0__1.66.0-13.el8.x86_64//rpm",
        "@boost-random-0__1.66.0-13.el8.x86_64//rpm",
        "@boost-regex-0__1.66.0-13.el8.x86_64//rpm",
        "@boost-system-0__1.66.0-13.el8.x86_64//rpm",
        "@boost-thread-0__1.66.0-13.el8.x86_64//rpm",
        "@brotli-0__1.0.6-3.el8.x86_64//rpm",
        "@bzip2-0__1.0.6-26.el8.x86_64//rpm",
        "@bzip2-libs-0__1.0.6-26.el8.x86_64//rpm",
        "@ca-certificates-0__2021.2.50-82.el8.x86_64//rpm",
        "@centos-gpg-keys-1__8-6.el8.x86_64//rpm",
        "@centos-stream-release-0__8.6-1.el8.x86_64//rpm",
        "@centos-stream-repos-0__8-6.el8.x86_64//rpm",
        "@checkpolicy-0__2.9-1.el8.x86_64//rpm",
        "@chkconfig-0__1.19.1-1.el8.x86_64//rpm",
        "@coreutils-0__8.30-13.el8.x86_64//rpm",
        "@coreutils-common-0__8.30-13.el8.x86_64//rpm",
        "@cracklib-0__2.9.6-15.el8.x86_64//rpm",
        "@cracklib-dicts-0__2.9.6-15.el8.x86_64//rpm",
        "@crypto-policies-0__20211116-1.gitae470d6.el8.x86_64//rpm",
        "@crypto-policies-scripts-0__20211116-1.gitae470d6.el8.x86_64//rpm",
        "@cryptsetup-libs-0__2.3.7-2.el8.x86_64//rpm",
        "@curl-0__7.61.1-25.el8.x86_64//rpm",
        "@cyrus-sasl-0__2.1.27-6.el8_5.x86_64//rpm",
        "@cyrus-sasl-gssapi-0__2.1.27-6.el8_5.x86_64//rpm",
        "@cyrus-sasl-lib-0__2.1.27-6.el8_5.x86_64//rpm",
        "@dbus-1__1.12.8-19.el8.x86_64//rpm",
        "@dbus-common-1__1.12.8-19.el8.x86_64//rpm",
        "@dbus-daemon-1__1.12.8-19.el8.x86_64//rpm",
        "@dbus-libs-1__1.12.8-19.el8.x86_64//rpm",
        "@dbus-tools-1__1.12.8-19.el8.x86_64//rpm",
        "@device-mapper-8__1.02.181-5.el8.x86_64//rpm",
        "@device-mapper-event-8__1.02.181-5.el8.x86_64//rpm",
        "@device-mapper-event-libs-8__1.02.181-5.el8.x86_64//rpm",
        "@device-mapper-libs-8__1.02.181-5.el8.x86_64//rpm",
        "@device-mapper-persistent-data-0__0.9.0-7.el8.x86_64//rpm",
        "@diffutils-0__3.6-6.el8.x86_64//rpm",
        "@dmidecode-1__3.3-4.el8.x86_64//rpm",
        "@dnsmasq-0__2.79-23.el8.x86_64//rpm",
        "@e2fsprogs-libs-0__1.45.6-5.el8.x86_64//rpm",
        "@elfutils-default-yama-scope-0__0.187-4.el8.x86_64//rpm",
        "@elfutils-libelf-0__0.187-4.el8.x86_64//rpm",
        "@elfutils-libs-0__0.187-4.el8.x86_64//rpm",
        "@expat-0__2.2.5-9.el8.x86_64//rpm",
        "@filesystem-0__3.8-6.el8.x86_64//rpm",
        "@gawk-0__4.2.1-4.el8.x86_64//rpm",
        "@gdbm-1__1.18-2.el8.x86_64//rpm",
        "@gdbm-libs-1__1.18-2.el8.x86_64//rpm",
        "@gettext-0__0.19.8.1-17.el8.x86_64//rpm",
        "@gettext-libs-0__0.19.8.1-17.el8.x86_64//rpm",
        "@glib2-0__2.56.4-159.el8.x86_64//rpm",
        "@glibc-0__2.28-208.el8.x86_64//rpm",
        "@glibc-common-0__2.28-208.el8.x86_64//rpm",
        "@glibc-langpack-ur-0__2.28-208.el8.x86_64//rpm",
        "@glusterfs-0__6.0-56.4.el8.x86_64//rpm",
        "@glusterfs-api-0__6.0-56.4.el8.x86_64//rpm",
        "@glusterfs-cli-0__6.0-56.4.el8.x86_64//rpm",
        "@glusterfs-client-xlators-0__6.0-56.4.el8.x86_64//rpm",
        "@glusterfs-libs-0__6.0-56.4.el8.x86_64//rpm",
        "@gmp-1__6.1.2-10.el8.x86_64//rpm",
        "@gnutls-0__3.6.16-4.el8.x86_64//rpm",
        "@gnutls-dane-0__3.6.16-4.el8.x86_64//rpm",
        "@gnutls-utils-0__3.6.16-4.el8.x86_64//rpm",
        "@grep-0__3.1-6.el8.x86_64//rpm",
        "@gssproxy-0__0.8.0-21.el8.x86_64//rpm",
        "@gzip-0__1.9-13.el8.x86_64//rpm",
        "@hwdata-0__0.314-8.13.el8.x86_64//rpm",
        "@info-0__6.5-7.el8_5.x86_64//rpm",
        "@iproute-0__5.18.0-1.el8.x86_64//rpm",
        "@iproute-tc-0__5.18.0-1.el8.x86_64//rpm",
        "@iptables-0__1.8.4-22.el8.x86_64//rpm",
        "@iptables-ebtables-0__1.8.4-22.el8.x86_64//rpm",
        "@iptables-libs-0__1.8.4-22.el8.x86_64//rpm",
        "@iscsi-initiator-utils-0__6.2.1.4-4.git095f59c.el8.x86_64//rpm",
        "@iscsi-initiator-utils-iscsiuio-0__6.2.1.4-4.git095f59c.el8.x86_64//rpm",
        "@isns-utils-libs-0__0.99-1.el8.x86_64//rpm",
        "@json-c-0__0.13.1-3.el8.x86_64//rpm",
        "@json-glib-0__1.4.4-1.el8.x86_64//rpm",
        "@keyutils-0__1.5.10-9.el8.x86_64//rpm",
        "@keyutils-libs-0__1.5.10-9.el8.x86_64//rpm",
        "@kmod-0__25-19.el8.x86_64//rpm",
        "@kmod-libs-0__25-19.el8.x86_64//rpm",
        "@krb5-libs-0__1.18.2-21.el8.x86_64//rpm",
        "@libacl-0__2.2.53-1.el8.x86_64//rpm",
        "@libaio-0__0.3.112-1.el8.x86_64//rpm",
        "@libarchive-0__3.3.3-4.el8.x86_64//rpm",
        "@libattr-0__2.4.48-3.el8.x86_64//rpm",
        "@libbasicobjects-0__0.1.1-40.el8.x86_64//rpm",
        "@libblkid-0__2.32.1-35.el8.x86_64//rpm",
        "@libbpf-0__0.5.0-1.el8.x86_64//rpm",
        "@libcap-0__2.48-4.el8.x86_64//rpm",
        "@libcap-ng-0__0.7.11-1.el8.x86_64//rpm",
        "@libcollection-0__0.7.0-40.el8.x86_64//rpm",
        "@libcom_err-0__1.45.6-5.el8.x86_64//rpm",
        "@libcroco-0__0.6.12-4.el8_2.1.x86_64//rpm",
        "@libcurl-0__7.61.1-25.el8.x86_64//rpm",
        "@libdb-0__5.3.28-42.el8_4.x86_64//rpm",
        "@libdb-utils-0__5.3.28-42.el8_4.x86_64//rpm",
        "@libev-0__4.24-6.el8.x86_64//rpm",
        "@libevent-0__2.1.8-5.el8.x86_64//rpm",
        "@libfdisk-0__2.32.1-35.el8.x86_64//rpm",
        "@libffi-0__3.1-23.el8.x86_64//rpm",
        "@libgcc-0__8.5.0-15.el8.x86_64//rpm",
        "@libgcrypt-0__1.8.5-7.el8.x86_64//rpm",
        "@libgomp-0__8.5.0-15.el8.x86_64//rpm",
        "@libgpg-error-0__1.31-1.el8.x86_64//rpm",
        "@libibverbs-0__37.2-1.el8.x86_64//rpm",
        "@libicu-0__60.3-2.el8_1.x86_64//rpm",
        "@libidn2-0__2.2.0-1.el8.x86_64//rpm",
        "@libini_config-0__1.3.1-40.el8.x86_64//rpm",
        "@libiscsi-0__1.18.0-8.module_el8.6.0__plus__983__plus__a7505f3f.x86_64//rpm",
        "@libmnl-0__1.0.4-6.el8.x86_64//rpm",
        "@libmount-0__2.32.1-35.el8.x86_64//rpm",
        "@libnetfilter_conntrack-0__1.0.6-5.el8.x86_64//rpm",
        "@libnfnetlink-0__1.0.1-13.el8.x86_64//rpm",
        "@libnfsidmap-1__2.3.3-56.el8.x86_64//rpm",
        "@libnftnl-0__1.1.5-5.el8.x86_64//rpm",
        "@libnghttp2-0__1.33.0-3.el8_2.1.x86_64//rpm",
        "@libnl3-0__3.7.0-1.el8.x86_64//rpm",
        "@libnsl2-0__1.2.0-2.20180605git4a062cf.el8.x86_64//rpm",
        "@libpath_utils-0__0.2.1-40.el8.x86_64//rpm",
        "@libpcap-14__1.9.1-5.el8.x86_64//rpm",
        "@libpciaccess-0__0.14-1.el8.x86_64//rpm",
        "@libpsl-0__0.20.2-6.el8.x86_64//rpm",
        "@libpwquality-0__1.4.4-3.el8.x86_64//rpm",
        "@librados2-1__12.2.7-9.el8.x86_64//rpm",
        "@librbd1-1__12.2.7-9.el8.x86_64//rpm",
        "@librdmacm-0__37.2-1.el8.x86_64//rpm",
        "@libref_array-0__0.1.5-40.el8.x86_64//rpm",
        "@libseccomp-0__2.5.2-1.el8.x86_64//rpm",
        "@libselinux-0__2.9-5.el8.x86_64//rpm",
        "@libselinux-utils-0__2.9-5.el8.x86_64//rpm",
        "@libsemanage-0__2.9-8.el8.x86_64//rpm",
        "@libsepol-0__2.9-3.el8.x86_64//rpm",
        "@libsigsegv-0__2.11-5.el8.x86_64//rpm",
        "@libsmartcols-0__2.32.1-35.el8.x86_64//rpm",
        "@libssh-0__0.9.6-3.el8.x86_64//rpm",
        "@libssh-config-0__0.9.6-3.el8.x86_64//rpm",
        "@libstdc__plus____plus__-0__8.5.0-15.el8.x86_64//rpm",
        "@libtasn1-0__4.13-3.el8.x86_64//rpm",
        "@libtirpc-0__1.1.4-7.el8.x86_64//rpm",
        "@libtpms-0__0.9.1-0.20211126git1ff6fe1f43.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
        "@libunistring-0__0.9.9-3.el8.x86_64//rpm",
        "@libutempter-0__1.1.6-14.el8.x86_64//rpm",
        "@libuuid-0__2.32.1-35.el8.x86_64//rpm",
        "@libverto-0__0.3.2-2.el8.x86_64//rpm",
        "@libverto-libev-0__0.3.2-2.el8.x86_64//rpm",
        "@libvirt-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-client-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-config-network-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-config-nwfilter-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-interface-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-network-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-nodedev-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-nwfilter-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-qemu-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-secret-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-storage-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-storage-core-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-storage-disk-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-storage-gluster-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-storage-iscsi-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-storage-iscsi-direct-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-storage-logical-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-storage-mpath-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-storage-rbd-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-storage-scsi-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-libs-0__8.1.0-1.el8.x86_64//rpm",
        "@libxcrypt-0__4.1.1-6.el8.x86_64//rpm",
        "@libxml2-0__2.9.7-14.el8.x86_64//rpm",
        "@libxslt-0__1.1.32-6.el8.x86_64//rpm",
        "@libyaml-0__0.1.7-5.el8.x86_64//rpm",
        "@libzstd-0__1.4.4-1.el8.x86_64//rpm",
        "@lua-libs-0__5.3.4-12.el8.x86_64//rpm",
        "@lvm2-8__2.03.14-5.el8.x86_64//rpm",
        "@lvm2-libs-8__2.03.14-5.el8.x86_64//rpm",
        "@lz4-libs-0__1.8.3-3.el8_4.x86_64//rpm",
        "@lzo-0__2.08-14.el8.x86_64//rpm",
        "@lzop-0__1.03-20.el8.x86_64//rpm",
        "@mdevctl-0__1.1.0-2.el8.x86_64//rpm",
        "@mozjs60-0__60.9.0-4.el8.x86_64//rpm",
        "@mpfr-0__3.1.6-1.el8.x86_64//rpm",
        "@ncurses-0__6.1-9.20180224.el8.x86_64//rpm",
        "@ncurses-base-0__6.1-9.20180224.el8.x86_64//rpm",
        "@ncurses-libs-0__6.1-9.20180224.el8.x86_64//rpm",
        "@netcf-libs-0__0.2.8-12.module_el8.6.0__plus__983__plus__a7505f3f.x86_64//rpm",
        "@nettle-0__3.4.1-7.el8.x86_64//rpm",
        "@nfs-utils-1__2.3.3-56.el8.x86_64//rpm",
        "@nspr-0__4.34.0-3.el8.x86_64//rpm",
        "@nss-0__3.79.0-5.el8.x86_64//rpm",
        "@nss-softokn-0__3.79.0-5.el8.x86_64//rpm",
        "@nss-softokn-freebl-0__3.79.0-5.el8.x86_64//rpm",
        "@nss-sysinit-0__3.79.0-5.el8.x86_64//rpm",
        "@nss-util-0__3.79.0-5.el8.x86_64//rpm",
        "@numactl-libs-0__2.0.12-13.el8.x86_64//rpm",
        "@numad-0__0.5-26.20150602git.el8.x86_64//rpm",
        "@openldap-0__2.4.46-18.el8.x86_64//rpm",
        "@openssl-libs-1__1.1.1k-6.el8.x86_64//rpm",
        "@p11-kit-0__0.23.22-1.el8.x86_64//rpm",
        "@p11-kit-trust-0__0.23.22-1.el8.x86_64//rpm",
        "@pam-0__1.3.1-22.el8.x86_64//rpm",
        "@parted-0__3.2-39.el8.x86_64//rpm",
        "@pcre-0__8.42-6.el8.x86_64//rpm",
        "@pcre2-0__10.32-3.el8.x86_64//rpm",
        "@platform-python-0__3.6.8-47.el8.x86_64//rpm",
        "@platform-python-setuptools-0__39.2.0-6.el8.x86_64//rpm",
        "@policycoreutils-0__2.9-19.el8.x86_64//rpm",
        "@policycoreutils-python-utils-0__2.9-19.el8.x86_64//rpm",
        "@polkit-0__0.115-13.0.1.el8.2.x86_64//rpm",
        "@polkit-libs-0__0.115-13.0.1.el8.2.x86_64//rpm",
        "@polkit-pkla-compat-0__0.1-12.el8.x86_64//rpm",
        "@popt-0__1.18-1.el8.x86_64//rpm",
        "@psmisc-0__23.1-5.el8.x86_64//rpm",
        "@publicsuffix-list-dafsa-0__20180723-1.el8.x86_64//rpm",
        "@python3-audit-0__3.0.7-4.el8.x86_64//rpm",
        "@python3-libs-0__3.6.8-47.el8.x86_64//rpm",
        "@python3-libselinux-0__2.9-5.el8.x86_64//rpm",
        "@python3-libsemanage-0__2.9-8.el8.x86_64//rpm",
        "@python3-pip-wheel-0__9.0.3-22.el8.x86_64//rpm",
        "@python3-policycoreutils-0__2.9-19.el8.x86_64//rpm",
        "@python3-pyyaml-0__3.12-12.el8.x86_64//rpm",
        "@python3-setools-0__4.3.0-3.el8.x86_64//rpm",
        "@python3-setuptools-wheel-0__39.2.0-6.el8.x86_64//rpm",
        "@qemu-img-15__6.2.0-12.module_el8.7.0__plus__1140__plus__ff0772f9.x86_64//rpm",
        "@quota-1__4.04-14.el8.x86_64//rpm",
        "@quota-nls-1__4.04-14.el8.x86_64//rpm",
        "@readline-0__7.0-10.el8.x86_64//rpm",
        "@rpcbind-0__1.2.5-9.el8.x86_64//rpm",
        "@rpm-0__4.14.3-23.el8.x86_64//rpm",
        "@rpm-libs-0__4.14.3-23.el8.x86_64//rpm",
        "@rpm-plugin-selinux-0__4.14.3-23.el8.x86_64//rpm",
        "@sed-0__4.5-5.el8.x86_64//rpm",
        "@selinux-policy-0__3.14.3-93.el8.x86_64//rpm",
        "@selinux-policy-minimum-0__3.14.3-93.el8.x86_64//rpm",
        "@setup-0__2.12.2-7.el8.x86_64//rpm",
        "@shadow-utils-2__4.6-17.el8.x86_64//rpm",
        "@sqlite-libs-0__3.26.0-15.el8.x86_64//rpm",
        "@swtpm-0__0.7.0-1.20211109gitb79fd91.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
        "@swtpm-libs-0__0.7.0-1.20211109gitb79fd91.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
        "@swtpm-tools-0__0.7.0-1.20211109gitb79fd91.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
        "@systemd-0__239-62.el8.x86_64//rpm",
        "@systemd-container-0__239-62.el8.x86_64//rpm",
        "@systemd-libs-0__239-62.el8.x86_64//rpm",
        "@systemd-pam-0__239-62.el8.x86_64//rpm",
        "@systemd-udev-0__239-62.el8.x86_64//rpm",
        "@tzdata-0__2022a-2.el8.x86_64//rpm",
        "@unbound-libs-0__1.16.0-2.el8.x86_64//rpm",
        "@util-linux-0__2.32.1-35.el8.x86_64//rpm",
        "@xz-0__5.2.4-4.el8.x86_64//rpm",
        "@xz-libs-0__5.2.4-4.el8.x86_64//rpm",
        "@yajl-0__2.1.0-11.el8.x86_64//rpm",
        "@zlib-0__1.2.11-19.el8.x86_64//rpm",
    ],
    visibility = ["//visibility:public"],
)
```

# 检查 WORKSPACE 是否都是libvirt-0:8.1.0-1.el8依赖的rpm

```bash
[root@kubevirtci bazeldnf]# cat WORKSPACE 
workspace(name = "bazeldnf")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "ac03931e56c3b229c145f1a8b2a2ad3e8d8f1af57e43ef28a26123362a1e3c7e",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.24.4/rules_go-v0.24.4.tar.gz",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.24.4/rules_go-v0.24.4.tar.gz",
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "b85f48fa105c4403326e9525ad2b2cc437babaa6e15a3fc0b1dbab0ab064bc7c",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.22.2/bazel-gazelle-v0.22.2.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.22.2/bazel-gazelle-v0.22.2.tar.gz",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")
load("//:deps.bzl", "bazeldnf_dependencies")

# gazelle:repository_macro deps.bzl%bazeldnf_dependencies
bazeldnf_dependencies()

go_rules_dependencies()

go_register_toolchains()

gazelle_dependencies()

http_archive(
    name = "com_google_protobuf",
    strip_prefix = "protobuf-main",
    urls = ["https://github.com/protocolbuffers/protobuf/archive/master.zip"],
)

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()

http_archive(
    name = "com_github_bazelbuild_buildtools",
    strip_prefix = "buildtools-master",
    url = "https://github.com/bazelbuild/buildtools/archive/master.zip",
)

load("//:deps.bzl", "rpm", "rpmtree")

rpm(
    name = "acl-0__2.2.53-1.el8.x86_64",
    sha256 = "227de6071cd3aeca7e10ad386beaf38737d081e06350d02208a3f6a2c9710385",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/acl-2.2.53-1.el8.x86_64.rpm"],
)

rpm(
    name = "audit-libs-0__3.0.7-4.el8.x86_64",
    sha256 = "b37099679b46f9a15d20b7c54fdd993388a8b84105f76869494c1be17140b512",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/audit-libs-3.0.7-4.el8.x86_64.rpm"],
)

rpm(
    name = "augeas-libs-0__1.12.0-7.el8.x86_64",
    sha256 = "672cf6c97f6aa00a0d5a39d20372501d6c6f40ac431083a499d89b7b25c84ba4",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/augeas-libs-1.12.0-7.el8.x86_64.rpm"],
)

rpm(
    name = "autogen-libopts-0__5.18.12-8.el8.x86_64",
    sha256 = "c73af033015bfbdbe8a43e162b098364d148517d394910f8db5d33b76b93aa48",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/autogen-libopts-5.18.12-8.el8.x86_64.rpm"],
)

rpm(
    name = "basesystem-0__11-5.el8.x86_64",
    sha256 = "48226934763e4c412c1eb65df314e6879720b4b1ebcb3d07c126c9526639cb68",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/basesystem-11-5.el8.noarch.rpm"],
)

rpm(
    name = "bash-0__4.4.20-4.el8.x86_64",
    sha256 = "a104837b8aea5214122cf09c2de436db8f528812c1361c39f2d7471343dc509b",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/bash-4.4.20-4.el8.x86_64.rpm"],
)

rpm(
    name = "boost-atomic-0__1.66.0-13.el8.x86_64",
    sha256 = "582e24b683cbefbd6281036c177cab913e9bfe76f6a183caae1eff70983d2569",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/boost-atomic-1.66.0-13.el8.x86_64.rpm"],
)

rpm(
    name = "boost-chrono-0__1.66.0-13.el8.x86_64",
    sha256 = "2d676a5e03854931f9a71a9ab32261dee9540b7fdd6c70a5fddf69bcea818882",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/boost-chrono-1.66.0-13.el8.x86_64.rpm"],
)

rpm(
    name = "boost-date-time-0__1.66.0-13.el8.x86_64",
    sha256 = "34100778783c5748230b82cd259418a4d266fcfb2bcb6f30e7b854f7fed90c8f",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/boost-date-time-1.66.0-13.el8.x86_64.rpm"],
)

rpm(
    name = "boost-iostreams-0__1.66.0-13.el8.x86_64",
    sha256 = "5a85438daaf569dfba73e4708ce9987a84245ce797b2102a06f2043c96a31beb",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/boost-iostreams-1.66.0-13.el8.x86_64.rpm"],
)

rpm(
    name = "boost-program-options-0__1.66.0-13.el8.x86_64",
    sha256 = "015a3d3a9c7fba7b4ec16cf73512308f9b457410598a24c1a24c50ad8f2ef2a3",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/boost-program-options-1.66.0-13.el8.x86_64.rpm"],
)

rpm(
    name = "boost-random-0__1.66.0-13.el8.x86_64",
    sha256 = "e7991373724e31b0bc6ecd4208f509f9674cbe16f45e5ae50a6fdbd2e5456e57",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/boost-random-1.66.0-13.el8.x86_64.rpm"],
)

rpm(
    name = "boost-regex-0__1.66.0-13.el8.x86_64",
    sha256 = "185a1a5f4c642b14c7a700b4c757f962f4d959dd5a3018c44e43b10071081bb8",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/boost-regex-1.66.0-13.el8.x86_64.rpm"],
)

rpm(
    name = "boost-system-0__1.66.0-13.el8.x86_64",
    sha256 = "9bce2a6d122e4afedf305e6811d8db89046812f7e13203eb83ec608af65b3ba4",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/boost-system-1.66.0-13.el8.x86_64.rpm"],
)

rpm(
    name = "boost-thread-0__1.66.0-13.el8.x86_64",
    sha256 = "fa1a547d4bb6b481b74afb73833c81e91e8813056500464dbaef8c172d00be74",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/boost-thread-1.66.0-13.el8.x86_64.rpm"],
)

rpm(
    name = "brotli-0__1.0.6-3.el8.x86_64",
    sha256 = "e4827f4a11cc1a0b14585f9f2984de80a185d2fd823be03dd128b04c7f0576c4",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/brotli-1.0.6-3.el8.x86_64.rpm"],
)

rpm(
    name = "bzip2-0__1.0.6-26.el8.x86_64",
    sha256 = "78596f457c3d737a97a4edfe9a03a01f593606379c281701ab7f7eba13ecaf18",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/bzip2-1.0.6-26.el8.x86_64.rpm"],
)

rpm(
    name = "bzip2-libs-0__1.0.6-26.el8.x86_64",
    sha256 = "19d66d152b745dbd49cea9d21c52aec0ec4d4321edef97a342acd3542404fa31",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/bzip2-libs-1.0.6-26.el8.x86_64.rpm"],
)

rpm(
    name = "ca-certificates-0__2021.2.50-82.el8.x86_64",
    sha256 = "1fad1d1f8b56e6967863aeb60f5fa3615e6a35b0f6532d8a23066e6823b50860",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/ca-certificates-2021.2.50-82.el8.noarch.rpm"],
)

rpm(
    name = "centos-gpg-keys-1__8-6.el8.x86_64",
    sha256 = "567dd699e703dc6f5fa6ddb5548bf0dbd3bda08a0a6b1d10b32fa19012409cd0",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/centos-gpg-keys-8-6.el8.noarch.rpm"],
)

rpm(
    name = "centos-stream-release-0__8.6-1.el8.x86_64",
    sha256 = "3b3b86cb51f62632995ace850fbed9efc65381d639f1e1c5ceeff7ccf2dd6151",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/centos-stream-release-8.6-1.el8.noarch.rpm"],
)

rpm(
    name = "centos-stream-repos-0__8-6.el8.x86_64",
    sha256 = "ff0a2d1fb5b00e9a26b05a82675d0dcdf0378ee5476f9ae765b32399c2ee561f",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/centos-stream-repos-8-6.el8.noarch.rpm"],
)

rpm(
    name = "checkpolicy-0__2.9-1.el8.x86_64",
    sha256 = "d5c283da0d2666742635754626263f6f78e273cd46d83d2d66ed43730a731685",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/checkpolicy-2.9-1.el8.x86_64.rpm"],
)

rpm(
    name = "chkconfig-0__1.19.1-1.el8.x86_64",
    sha256 = "561b5fdadd60370b5d0a91b7ed35df95d7f60650cbade8c7e744323982ac82db",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/chkconfig-1.19.1-1.el8.x86_64.rpm"],
)

rpm(
    name = "coreutils-0__8.30-13.el8.x86_64",
    sha256 = "ca43391669cf819158a6833e4fe26e4a4a453055105f280f77f2b467fc6b1e60",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/coreutils-8.30-13.el8.x86_64.rpm"],
)

rpm(
    name = "coreutils-common-0__8.30-13.el8.x86_64",
    sha256 = "a8fcf700f3e803ab8c4be88388a20c479e6491cdeb61a2282569c64fedb56303",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/coreutils-common-8.30-13.el8.x86_64.rpm"],
)

rpm(
    name = "cracklib-0__2.9.6-15.el8.x86_64",
    sha256 = "dbbc9e20caabc30070354d91f61f383081f6d658e09d3c09e6df8764559e5aca",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/cracklib-2.9.6-15.el8.x86_64.rpm"],
)

rpm(
    name = "cracklib-dicts-0__2.9.6-15.el8.x86_64",
    sha256 = "f1ce23ee43c747a35367dada19ca200a7758c50955ccc44aa946b86b647077ca",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/cracklib-dicts-2.9.6-15.el8.x86_64.rpm"],
)

rpm(
    name = "crypto-policies-0__20211116-1.gitae470d6.el8.x86_64",
    sha256 = "8fb69892af346bacf18e8f8e7e8098e09c6ef9547abab9c39f7e729db06c3d1e",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/crypto-policies-20211116-1.gitae470d6.el8.noarch.rpm"],
)

rpm(
    name = "crypto-policies-scripts-0__20211116-1.gitae470d6.el8.x86_64",
    sha256 = "48aec10d47ff16e8472c6e06ba742f7d34809a5d5a42e22e2847b8fe1bc08c74",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/crypto-policies-scripts-20211116-1.gitae470d6.el8.noarch.rpm"],
)

rpm(
    name = "cryptsetup-libs-0__2.3.7-2.el8.x86_64",
    sha256 = "6fe218c49155d7b22cd97156583b98d08abfbbffb61c32fe1965a0683ab7ed9e",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/cryptsetup-libs-2.3.7-2.el8.x86_64.rpm"],
)

rpm(
    name = "curl-0__7.61.1-25.el8.x86_64",
    sha256 = "6d5a740367b807f9cb102f9f3868ddd102c330944654a2903a016f651a6c25ed",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/curl-7.61.1-25.el8.x86_64.rpm"],
)

rpm(
    name = "cyrus-sasl-0__2.1.27-6.el8_5.x86_64",
    sha256 = "65a62affe9c99e597aabf117b8439a363761686c496723bc492dbfdcb6f60692",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/cyrus-sasl-2.1.27-6.el8_5.x86_64.rpm"],
)

rpm(
    name = "cyrus-sasl-gssapi-0__2.1.27-6.el8_5.x86_64",
    sha256 = "6c9a8d9adc93d1be7db41fe7327c4dcce144cefad3008e580f5e9cadb6155eb4",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/cyrus-sasl-gssapi-2.1.27-6.el8_5.x86_64.rpm"],
)

rpm(
    name = "cyrus-sasl-lib-0__2.1.27-6.el8_5.x86_64",
    sha256 = "5bd6e1201d8b10c6f01f500c43f63204f1d2ec8a4d8ce53c741e611c81ffb404",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/cyrus-sasl-lib-2.1.27-6.el8_5.x86_64.rpm"],
)

rpm(
    name = "dbus-1__1.12.8-19.el8.x86_64",
    sha256 = "35b04c739f1dbd507a5e01f63b0656633ee775e48b1019e30e8ef2322af6cf37",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/dbus-1.12.8-19.el8.x86_64.rpm"],
)

rpm(
    name = "dbus-common-1__1.12.8-19.el8.x86_64",
    sha256 = "aac8490975c287223e920d58276f6a08c89f92743245a7f2bf31b702b17a82a9",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/dbus-common-1.12.8-19.el8.noarch.rpm"],
)

rpm(
    name = "dbus-daemon-1__1.12.8-19.el8.x86_64",
    sha256 = "f383727b16b942eff210082244727c647f5199eb2cc8c9c2364ace4a803b15c6",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/dbus-daemon-1.12.8-19.el8.x86_64.rpm"],
)

rpm(
    name = "dbus-libs-1__1.12.8-19.el8.x86_64",
    sha256 = "7255b772dce5cab01aea54dff4545f03938dc1c9c54ff032060aa8b47c97a81b",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/dbus-libs-1.12.8-19.el8.x86_64.rpm"],
)

rpm(
    name = "dbus-tools-1__1.12.8-19.el8.x86_64",
    sha256 = "eae77812a48ccaf3bc04bf3c5ba1a1233ffbd108122637217b3c7eba9f5c077b",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/dbus-tools-1.12.8-19.el8.x86_64.rpm"],
)

rpm(
    name = "device-mapper-8__1.02.181-5.el8.x86_64",
    sha256 = "4f572e024d831b805e1ec860296643e6f102515dbefc40d5cd5b0cbffc1466e0",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/device-mapper-1.02.181-5.el8.x86_64.rpm"],
)

rpm(
    name = "device-mapper-event-8__1.02.181-5.el8.x86_64",
    sha256 = "ecad8f3eeda1c83ca42b38d512ad88ad1903d39aab7c416969e3bfe6e13141c7",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/device-mapper-event-1.02.181-5.el8.x86_64.rpm"],
)

rpm(
    name = "device-mapper-event-libs-8__1.02.181-5.el8.x86_64",
    sha256 = "1fb52aca0e2324830d4a9cc119c92a6abfd74be589d79f10f1eae857b72296ba",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/device-mapper-event-libs-1.02.181-5.el8.x86_64.rpm"],
)

rpm(
    name = "device-mapper-libs-8__1.02.181-5.el8.x86_64",
    sha256 = "892be3423740466692caf3f8beb9e82ec32e01660f462535f0b13ddd47506286",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/device-mapper-libs-1.02.181-5.el8.x86_64.rpm"],
)

rpm(
    name = "device-mapper-persistent-data-0__0.9.0-7.el8.x86_64",
    sha256 = "609c2bf12ce2994a0753177e334cde294a96750903c24d8583e7a0674c80485e",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/device-mapper-persistent-data-0.9.0-7.el8.x86_64.rpm"],
)

rpm(
    name = "diffutils-0__3.6-6.el8.x86_64",
    sha256 = "c515d78c64a93d8b469593bff5800eccd50f24b16697ab13bdce81238c38eb77",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/diffutils-3.6-6.el8.x86_64.rpm"],
)

rpm(
    name = "dmidecode-1__3.3-4.el8.x86_64",
    sha256 = "c1347fe2d5621a249ea230e9e8ff2774e538031070a225245154a75428ec67a5",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/dmidecode-3.3-4.el8.x86_64.rpm"],
)

rpm(
    name = "dnsmasq-0__2.79-23.el8.x86_64",
    sha256 = "6d9219a50607227e0c8bfc29c85dc5bb8e623f36aa1109ec74df5c247e024b88",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/dnsmasq-2.79-23.el8.x86_64.rpm"],
)

rpm(
    name = "e2fsprogs-libs-0__1.45.6-5.el8.x86_64",
    sha256 = "035c5ed68339e632907c3f952098cdc9181ab9138239473903000e6a50446d98",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/e2fsprogs-libs-1.45.6-5.el8.x86_64.rpm"],
)

rpm(
    name = "elfutils-default-yama-scope-0__0.187-4.el8.x86_64",
    sha256 = "3c89377bb7409293f0dc8ada62071fe2e3cf042ae2b5ca7cf09faf77394b5187",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/elfutils-default-yama-scope-0.187-4.el8.noarch.rpm"],
)

rpm(
    name = "elfutils-libelf-0__0.187-4.el8.x86_64",
    sha256 = "39d8cbfb137ca9044c258b5fa2129d2a953cc180cab225e843fd46a9267ee8a3",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/elfutils-libelf-0.187-4.el8.x86_64.rpm"],
)

rpm(
    name = "elfutils-libs-0__0.187-4.el8.x86_64",
    sha256 = "ab96131314dbe1ed50f6a2086c0103ceb2e981e71f644ef95d3334a624723a22",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/elfutils-libs-0.187-4.el8.x86_64.rpm"],
)

rpm(
    name = "expat-0__2.2.5-9.el8.x86_64",
    sha256 = "a24088d02bfc25fb2efc1cc8c92e716ead35b38c8a96e69d08a9c78a5782f0e8",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/expat-2.2.5-9.el8.x86_64.rpm"],
)

rpm(
    name = "filesystem-0__3.8-6.el8.x86_64",
    sha256 = "50bdb81d578914e0e88fe6b13550b4c30aac4d72f064fdcd78523df7dd2f64da",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/filesystem-3.8-6.el8.x86_64.rpm"],
)

rpm(
    name = "gawk-0__4.2.1-4.el8.x86_64",
    sha256 = "ff4438c2dff5bf933d7874fd55f131ca6ee067f8fb4324c89719d63e60b40aba",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/gawk-4.2.1-4.el8.x86_64.rpm"],
)

rpm(
    name = "gdbm-1__1.18-2.el8.x86_64",
    sha256 = "fa1751b26519b9637cf3f0a25ea1874eb2df005dde1e1371a3f13d0c9a38b9ca",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/gdbm-1.18-2.el8.x86_64.rpm"],
)

rpm(
    name = "gdbm-libs-1__1.18-2.el8.x86_64",
    sha256 = "eddcea96342c8cfaa60b79fc2c66cb8c5b0038c3b11855abe55e659b2cad6199",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/gdbm-libs-1.18-2.el8.x86_64.rpm"],
)

rpm(
    name = "gettext-0__0.19.8.1-17.el8.x86_64",
    sha256 = "829c842bbd79dca18d37198414626894c44e5b8faf0cce0054ca0ba6623ae136",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/gettext-0.19.8.1-17.el8.x86_64.rpm"],
)

rpm(
    name = "gettext-libs-0__0.19.8.1-17.el8.x86_64",
    sha256 = "ade52756aaf236e77dadd6cf97716821141c2759129ca7808524ab79607bb4c4",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/gettext-libs-0.19.8.1-17.el8.x86_64.rpm"],
)

rpm(
    name = "glib2-0__2.56.4-159.el8.x86_64",
    sha256 = "d4b34f328efd6f144c8c1bcb61b6faa1318c367302b9f95d5db84078ca96a730",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glib2-2.56.4-159.el8.x86_64.rpm"],
)

rpm(
    name = "glibc-0__2.28-208.el8.x86_64",
    sha256 = "3529387a82c3eda0825471697f6ad92f8e01f3a897afcba381081f9c33af3718",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glibc-2.28-208.el8.x86_64.rpm"],
)

rpm(
    name = "glibc-common-0__2.28-208.el8.x86_64",
    sha256 = "a585f4262ccf1f3a4cad345f128e256cc8dafbf54f92096e3466dbd359ec192a",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glibc-common-2.28-208.el8.x86_64.rpm"],
)

rpm(
    name = "glibc-langpack-ur-0__2.28-208.el8.x86_64",
    sha256 = "8983daaa062546b3aebcffd18d898e6286ae583c6e17d4a6d8d6abdb3a38f5cd",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glibc-langpack-ur-2.28-208.el8.x86_64.rpm"],
)

rpm(
    name = "glusterfs-0__6.0-56.4.el8.x86_64",
    sha256 = "83b47312daf82365b52b67523fb24fbe2cd48ff344e6a07df2845a920c309444",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glusterfs-6.0-56.4.el8.x86_64.rpm"],
)

rpm(
    name = "glusterfs-api-0__6.0-56.4.el8.x86_64",
    sha256 = "26926dfc4dc3fc8341cdf38fad0a4d23426c0b60521a7ef6f1a4142f8b9272dd",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/glusterfs-api-6.0-56.4.el8.x86_64.rpm"],
)

rpm(
    name = "glusterfs-cli-0__6.0-56.4.el8.x86_64",
    sha256 = "32a37a1e248acb2441f6b72996e6614b72984270373f1339f3c1d5bcbee29185",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/glusterfs-cli-6.0-56.4.el8.x86_64.rpm"],
)

rpm(
    name = "glusterfs-client-xlators-0__6.0-56.4.el8.x86_64",
    sha256 = "4e74285c078ca8b75ba3d995ac78f4eb8be69a743a333804550fd4de27dddf66",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glusterfs-client-xlators-6.0-56.4.el8.x86_64.rpm"],
)

rpm(
    name = "glusterfs-libs-0__6.0-56.4.el8.x86_64",
    sha256 = "82613d82932889856e109d734220e059adf67da0e946b77896f19d5d19f5bd16",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glusterfs-libs-6.0-56.4.el8.x86_64.rpm"],
)

rpm(
    name = "gmp-1__6.1.2-10.el8.x86_64",
    sha256 = "3b96e2c7d5cd4b49bfde8e52c8af6ff595c91438e50856e468f14a049d8511e2",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/gmp-6.1.2-10.el8.x86_64.rpm"],
)

rpm(
    name = "gnutls-0__3.6.16-4.el8.x86_64",
    sha256 = "51bae480875ce4f8dd76b0af177c88eb1bd33faa910dbd64e574ef8c7ada1d03",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/gnutls-3.6.16-4.el8.x86_64.rpm"],
)

rpm(
    name = "gnutls-dane-0__3.6.16-4.el8.x86_64",
    sha256 = "122d2a8e70c4cb857803e8b3673ca8dc572ba21ce790064abc4c99cca0f94b3f",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/gnutls-dane-3.6.16-4.el8.x86_64.rpm"],
)

rpm(
    name = "gnutls-utils-0__3.6.16-4.el8.x86_64",
    sha256 = "58bc517e7d159bffa96db5cb5fd132e7e1798b8685ebb35d22a62ab6db51ced7",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/gnutls-utils-3.6.16-4.el8.x86_64.rpm"],
)

rpm(
    name = "grep-0__3.1-6.el8.x86_64",
    sha256 = "3f8ffe48bb481a5db7cbe42bf73b839d872351811e5df41b2f6697c61a030487",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/grep-3.1-6.el8.x86_64.rpm"],
)

rpm(
    name = "gssproxy-0__0.8.0-21.el8.x86_64",
    sha256 = "05325a046fdc9ef34248053ae08cee10ed3422f481911dd21bad59fae3ddd22d",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/gssproxy-0.8.0-21.el8.x86_64.rpm"],
)

rpm(
    name = "gzip-0__1.9-13.el8.x86_64",
    sha256 = "1cc189e4991fc6b3526f7eebc9f798b8922e70d60a12ba499b6e0329eb473cea",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/gzip-1.9-13.el8.x86_64.rpm"],
)

rpm(
    name = "hwdata-0__0.314-8.13.el8.x86_64",
    sha256 = "ea7edd4cad34d86776670385c7b6e7661f3207f43913ab133b094a991c73a287",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/hwdata-0.314-8.13.el8.noarch.rpm"],
)

rpm(
    name = "info-0__6.5-7.el8_5.x86_64",
    sha256 = "63f03261cc8109b2fb61002ca50c93e52acb9cfd8382d139e8de6623394051e8",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/info-6.5-7.el8_5.x86_64.rpm"],
)

rpm(
    name = "iproute-0__5.18.0-1.el8.x86_64",
    sha256 = "7ae4b834f060d111db19fa3cf6f6266d4c6fb56992b0347145799d7ff9f03d3c",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/iproute-5.18.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "iproute-tc-0__5.18.0-1.el8.x86_64",
    sha256 = "bca80255b377f2a715c1fa2023485cd8fd03f2bab2a873faa0e5879082bca1c9",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/iproute-tc-5.18.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "iptables-0__1.8.4-22.el8.x86_64",
    sha256 = "8993bf1f075984412a57cf5b2c0110984a4dd1125d60048872c85f9c496f9e66",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/iptables-1.8.4-22.el8.x86_64.rpm"],
)

rpm(
    name = "iptables-ebtables-0__1.8.4-22.el8.x86_64",
    sha256 = "d0905111a766a7aa1bd0aff71dab248beb358f777ee02107c8e3834cc7f1a0cc",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/iptables-ebtables-1.8.4-22.el8.x86_64.rpm"],
)

rpm(
    name = "iptables-libs-0__1.8.4-22.el8.x86_64",
    sha256 = "84cef50494317f6e968c8a27134e6f442a1898b137715bd69573d6d72e7b6fb1",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/iptables-libs-1.8.4-22.el8.x86_64.rpm"],
)

rpm(
    name = "iscsi-initiator-utils-0__6.2.1.4-4.git095f59c.el8.x86_64",
    sha256 = "0a4c90baac48f116789645c8dc1351c6ede1dfa6c5664d09779f51858d2dde1c",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/iscsi-initiator-utils-6.2.1.4-4.git095f59c.el8.x86_64.rpm"],
)

rpm(
    name = "iscsi-initiator-utils-iscsiuio-0__6.2.1.4-4.git095f59c.el8.x86_64",
    sha256 = "7ac58a3b9990da620d568ff0b3cf7e3555f0bad5f2d9c86c771e84d5939e81e5",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/iscsi-initiator-utils-iscsiuio-6.2.1.4-4.git095f59c.el8.x86_64.rpm"],
)

rpm(
    name = "isns-utils-libs-0__0.99-1.el8.x86_64",
    sha256 = "5830a9484eb786849dd73fce6f2b20d5d42e779d687842f60c8b588c962e5e40",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/isns-utils-libs-0.99-1.el8.x86_64.rpm"],
)

rpm(
    name = "json-c-0__0.13.1-3.el8.x86_64",
    sha256 = "5035057553b61cb389c67aa2c29d99c8e0c1677369dad179d683942ccee90b3f",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/json-c-0.13.1-3.el8.x86_64.rpm"],
)

rpm(
    name = "json-glib-0__1.4.4-1.el8.x86_64",
    sha256 = "98a6386df94fc9595365c3ecbc630708420fa68d1774614a723dec4a55e84b9c",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/json-glib-1.4.4-1.el8.x86_64.rpm"],
)

rpm(
    name = "keyutils-0__1.5.10-9.el8.x86_64",
    sha256 = "4b6adc20f41b59b787291588a3de9182404199db575067282965878f693c40cc",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/keyutils-1.5.10-9.el8.x86_64.rpm"],
)

rpm(
    name = "keyutils-libs-0__1.5.10-9.el8.x86_64",
    sha256 = "423329269c719b96ada88a27325e1923e764a70672e0dc6817e22eff07a9af7b",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/keyutils-libs-1.5.10-9.el8.x86_64.rpm"],
)

rpm(
    name = "kmod-0__25-19.el8.x86_64",
    sha256 = "37c299fdaa42efb0d653ba5e22c83bd20833af1244b66ed6ea880e75c1672dd2",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/kmod-25-19.el8.x86_64.rpm"],
)

rpm(
    name = "kmod-libs-0__25-19.el8.x86_64",
    sha256 = "46a2ddc6067ed12089f04f2255c57117992807d707e280fc002f3ce786fc2abf",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/kmod-libs-25-19.el8.x86_64.rpm"],
)

rpm(
    name = "krb5-libs-0__1.18.2-21.el8.x86_64",
    sha256 = "b02dcbdc99f85926d6595bc3f7e24ba535b0e22ae7932e61a4ea8ab8fb4b35d9",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/krb5-libs-1.18.2-21.el8.x86_64.rpm"],
)

rpm(
    name = "libacl-0__2.2.53-1.el8.x86_64",
    sha256 = "4973664648b7ed9278bf29074ec6a60a9f660aa97c23a283750483f64429d5bb",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libacl-2.2.53-1.el8.x86_64.rpm"],
)

rpm(
    name = "libaio-0__0.3.112-1.el8.x86_64",
    sha256 = "2c63399bee449fb6e921671a9bbf3356fda73f890b578820f7d926202e98a479",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libaio-0.3.112-1.el8.x86_64.rpm"],
)

rpm(
    name = "libarchive-0__3.3.3-4.el8.x86_64",
    sha256 = "498b81c8c4f7fb75eccf6228776f0956c0f8c958cc3c6b45c61fdbf53ae6f039",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libarchive-3.3.3-4.el8.x86_64.rpm"],
)

rpm(
    name = "libattr-0__2.4.48-3.el8.x86_64",
    sha256 = "a02e1344ccde1747501ceeeff37df4f18149fb79b435aa22add08cff6bab3a5a",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libattr-2.4.48-3.el8.x86_64.rpm"],
)

rpm(
    name = "libbasicobjects-0__0.1.1-40.el8.x86_64",
    sha256 = "cc4c7d14093bc2dbd690aab88523ecc9dc1c90810191452b7e1ac756c99629ba",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libbasicobjects-0.1.1-40.el8.x86_64.rpm"],
)

rpm(
    name = "libblkid-0__2.32.1-35.el8.x86_64",
    sha256 = "e3b1fc548a77ff6d61ff30d22c30611c17e12af7a71c39ba2a5bfc41c6e0a48a",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libblkid-2.32.1-35.el8.x86_64.rpm"],
)

rpm(
    name = "libbpf-0__0.5.0-1.el8.x86_64",
    sha256 = "4d25308c27041d8a88a3340be12591e9bd46c9aebbe4195ee5d2f712d63ce033",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libbpf-0.5.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libcap-0__2.48-4.el8.x86_64",
    sha256 = "34f69bed9ae0f5ba314a62172e8cfd9cf6795cb0c3bd29f15d174fc2a0acbb5b",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libcap-2.48-4.el8.x86_64.rpm"],
)

rpm(
    name = "libcap-ng-0__0.7.11-1.el8.x86_64",
    sha256 = "15c3c696ec2e21f48e951f426d3c77b53b579605b8dd89843b35c9ab9b1d7e69",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libcap-ng-0.7.11-1.el8.x86_64.rpm"],
)

rpm(
    name = "libcollection-0__0.7.0-40.el8.x86_64",
    sha256 = "9282a11d3792e771dfef1df80c6234fa3845638e9a27b438362810f8dfc5d208",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libcollection-0.7.0-40.el8.x86_64.rpm"],
)

rpm(
    name = "libcom_err-0__1.45.6-5.el8.x86_64",
    sha256 = "4e4f13acac0477f0a121812107a9939ea2164eebab052813f1618d5b7df5d87a",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libcom_err-1.45.6-5.el8.x86_64.rpm"],
)

rpm(
    name = "libcroco-0__0.6.12-4.el8_2.1.x86_64",
    sha256 = "87f2a4d80cf4f6a958f3662c6a382edefc32a5ad2c364a7f3c40337cf2b1e8ba",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libcroco-0.6.12-4.el8_2.1.x86_64.rpm"],
)

rpm(
    name = "libcurl-0__7.61.1-25.el8.x86_64",
    sha256 = "7a087b29c8e3c63e3c5ad54861a3b8a2ba8ae4f340e127c3e84cf4835ebc95b8",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libcurl-7.61.1-25.el8.x86_64.rpm"],
)

rpm(
    name = "libdb-0__5.3.28-42.el8_4.x86_64",
    sha256 = "058f77432592f4337039cbb7a4e5f680020d8b85a477080c01d96a7728de6934",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libdb-5.3.28-42.el8_4.x86_64.rpm"],
)

rpm(
    name = "libdb-utils-0__5.3.28-42.el8_4.x86_64",
    sha256 = "ceb3dbd9e0d39d3e6b566eaf05359de4dd9a18d09da9238f2319f66f7cfebf7b",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libdb-utils-5.3.28-42.el8_4.x86_64.rpm"],
)

rpm(
    name = "libev-0__4.24-6.el8.x86_64",
    sha256 = "83549217540abd259f74b84d9359ab200c2cbe6e9b2e25a73d7236cf441aed4c",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/libev-4.24-6.el8.x86_64.rpm"],
)

rpm(
    name = "libevent-0__2.1.8-5.el8.x86_64",
    sha256 = "746bac6bb011a586d42bd82b2f8b25bac72c9e4bbd4c19a34cf88eadb1d83873",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libevent-2.1.8-5.el8.x86_64.rpm"],
)

rpm(
    name = "libfdisk-0__2.32.1-35.el8.x86_64",
    sha256 = "c58b8af815600c4d4370b3886dbdd3dce37cd78cc749025222fb8be19fb6f494",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libfdisk-2.32.1-35.el8.x86_64.rpm"],
)

rpm(
    name = "libffi-0__3.1-23.el8.x86_64",
    sha256 = "643d1b969c7fbcd55c523f779089f3f2fe8b105c719fd49c7edd1f142dfc2143",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libffi-3.1-23.el8.x86_64.rpm"],
)

rpm(
    name = "libgcc-0__8.5.0-15.el8.x86_64",
    sha256 = "e020248e0906263fc12ca404974d1ae7e23357ef2f73881e7f874f57290ac4d4",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libgcc-8.5.0-15.el8.x86_64.rpm"],
)

rpm(
    name = "libgcrypt-0__1.8.5-7.el8.x86_64",
    sha256 = "01541f1263532f80114111a44f797d6a8eed75744db997e85fddd021e636c5bb",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libgcrypt-1.8.5-7.el8.x86_64.rpm"],
)

rpm(
    name = "libgomp-0__8.5.0-15.el8.x86_64",
    sha256 = "9d17f906c5d6412344615999f23fec33e4b2232bf7c1b0871f3bec12f96ce897",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libgomp-8.5.0-15.el8.x86_64.rpm"],
)

rpm(
    name = "libgpg-error-0__1.31-1.el8.x86_64",
    sha256 = "845a0732d9d7a01b909124cd8293204764235c2d856227c7a74dfa0e38113e34",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libgpg-error-1.31-1.el8.x86_64.rpm"],
)

rpm(
    name = "libibverbs-0__37.2-1.el8.x86_64",
    sha256 = "146616aaa85d8b44dd554db70468e4237d88dd5f4335b40e3c28209554d86102",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libibverbs-37.2-1.el8.x86_64.rpm"],
)

rpm(
    name = "libicu-0__60.3-2.el8_1.x86_64",
    sha256 = "d703112d21afadf069e0ba6ef2a34b0ef760ccc969a2b7dd5d38761113c3d17e",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libicu-60.3-2.el8_1.x86_64.rpm"],
)

rpm(
    name = "libidn2-0__2.2.0-1.el8.x86_64",
    sha256 = "7e08785bd3cc0e09f9ab4bf600b98b705203d552cbb655269a939087987f1694",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libidn2-2.2.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libini_config-0__1.3.1-40.el8.x86_64",
    sha256 = "4822758f341f9cac045d5d55c57b2a6ae88d3fcfa2e882900af9dc11d5154427",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libini_config-1.3.1-40.el8.x86_64.rpm"],
)

rpm(
    name = "libiscsi-0__1.18.0-8.module_el8.6.0__plus__983__plus__a7505f3f.x86_64",
    sha256 = "77cd7d2f930f737ced7b548e23a37b21ef5bbd7ebc07e147a815b9b6ad76957e",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/libiscsi-1.18.0-8.module_el8.6.0+983+a7505f3f.x86_64.rpm"],
)

rpm(
    name = "libmnl-0__1.0.4-6.el8.x86_64",
    sha256 = "30fab73ee155f03dbbd99c1e30fe59dfba4ae8fdb2e7213451ccc36d6918bfcc",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libmnl-1.0.4-6.el8.x86_64.rpm"],
)

rpm(
    name = "libmount-0__2.32.1-35.el8.x86_64",
    sha256 = "07c12c19fdcf9b8756c3c67717519f22ff6f513dc3ec0246d8757d31023c158b",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libmount-2.32.1-35.el8.x86_64.rpm"],
)

rpm(
    name = "libnetfilter_conntrack-0__1.0.6-5.el8.x86_64",
    sha256 = "224100af3ecfc80c416796ec02c7c4dd113a38d42349d763485f3b42f260493f",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libnetfilter_conntrack-1.0.6-5.el8.x86_64.rpm"],
)

rpm(
    name = "libnfnetlink-0__1.0.1-13.el8.x86_64",
    sha256 = "cec98aa5fbefcb99715921b493b4f92d34c4eeb823e9c8741aa75e280def89f1",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libnfnetlink-1.0.1-13.el8.x86_64.rpm"],
)

rpm(
    name = "libnfsidmap-1__2.3.3-56.el8.x86_64",
    sha256 = "50b262a6fc3281c1f8f527148992da024eaa454ede2d6b6bc42d16c09d17a124",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libnfsidmap-2.3.3-56.el8.x86_64.rpm"],
)

rpm(
    name = "libnftnl-0__1.1.5-5.el8.x86_64",
    sha256 = "293e1f0f44a9c1d5dedbe831dff3049fad9e88c5f0e281d889f427603ac51fa6",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libnftnl-1.1.5-5.el8.x86_64.rpm"],
)

rpm(
    name = "libnghttp2-0__1.33.0-3.el8_2.1.x86_64",
    sha256 = "0126a384853d46484dec98601a4cb4ce58b2e0411f8f7ef09937174dd5975bac",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libnghttp2-1.33.0-3.el8_2.1.x86_64.rpm"],
)

rpm(
    name = "libnl3-0__3.7.0-1.el8.x86_64",
    sha256 = "9ce7aa4d7bd810448d9fb3aa85a66cca00950f7c2c59bc9721ced3e4f3ad2885",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libnl3-3.7.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libnsl2-0__1.2.0-2.20180605git4a062cf.el8.x86_64",
    sha256 = "5846c73edfa2ff673989728e9621cce6a1369eb2f8a269ac5205c381a10d327a",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libnsl2-1.2.0-2.20180605git4a062cf.el8.x86_64.rpm"],
)

rpm(
    name = "libpath_utils-0__0.2.1-40.el8.x86_64",
    sha256 = "df004d035a915323c8cdc36d2a59ddfbc9666712a2afcb90b1d0418a5cd779d1",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libpath_utils-0.2.1-40.el8.x86_64.rpm"],
)

rpm(
    name = "libpcap-14__1.9.1-5.el8.x86_64",
    sha256 = "7f429477c26b4650a3eca4a27b3972ff0857c843bdb4d8fcb02086da111ce5fd",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libpcap-1.9.1-5.el8.x86_64.rpm"],
)

rpm(
    name = "libpciaccess-0__0.14-1.el8.x86_64",
    sha256 = "759386be8f49257266ac614432b762b8e486a89aac5d5f7a581a0330efb59c77",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libpciaccess-0.14-1.el8.x86_64.rpm"],
)

rpm(
    name = "libpsl-0__0.20.2-6.el8.x86_64",
    sha256 = "6331739a255deef04005f1516e5f6a7991aebccec6d5f6b9fcf7ee9e059bad4d",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libpsl-0.20.2-6.el8.x86_64.rpm"],
)

rpm(
    name = "libpwquality-0__1.4.4-3.el8.x86_64",
    sha256 = "e42ec1259c966909507a6b4c4cd25b183268d4516dd9a8d60078c8a4b6df0014",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libpwquality-1.4.4-3.el8.x86_64.rpm"],
)

rpm(
    name = "librados2-1__12.2.7-9.el8.x86_64",
    sha256 = "26fc737517bc0b60150e662337000007299d7579376370bc9b907a7fe446a3f0",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/librados2-12.2.7-9.el8.x86_64.rpm"],
)

rpm(
    name = "librbd1-1__12.2.7-9.el8.x86_64",
    sha256 = "f149e46f0f6a31f1af8bdc52385098c66c4c9fa538b5087ed98c357077463128",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/librbd1-12.2.7-9.el8.x86_64.rpm"],
)

rpm(
    name = "librdmacm-0__37.2-1.el8.x86_64",
    sha256 = "ebee4a85de6732065dc0cfe2967613188964a26bcd276498e5f02a5c62797979",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/librdmacm-37.2-1.el8.x86_64.rpm"],
)

rpm(
    name = "libref_array-0__0.1.5-40.el8.x86_64",
    sha256 = "fe313a84d495537d5d1fc2aee3a0a22e1d2657578aae0aa9fcde2ac24fa6a4a2",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libref_array-0.1.5-40.el8.x86_64.rpm"],
)

rpm(
    name = "libseccomp-0__2.5.2-1.el8.x86_64",
    sha256 = "4a6322832274a9507108719de9af48406ee0fcfc54c9906b9450e1ae231ede4b",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libseccomp-2.5.2-1.el8.x86_64.rpm"],
)

rpm(
    name = "libselinux-0__2.9-5.el8.x86_64",
    sha256 = "89e54e0975b9c87c45d3478d9f8bcc3f19a90e9ef16062a524af4a8efc059e1f",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libselinux-2.9-5.el8.x86_64.rpm"],
)

rpm(
    name = "libselinux-utils-0__2.9-5.el8.x86_64",
    sha256 = "5063fe914f04ca203e3f28529021c40ef01ad8ed33330fafc0f658581a78b722",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libselinux-utils-2.9-5.el8.x86_64.rpm"],
)

rpm(
    name = "libsemanage-0__2.9-8.el8.x86_64",
    sha256 = "2f67675888470272c8e1d5944bead3a59a377a658ebb58636613056916ba7b13",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libsemanage-2.9-8.el8.x86_64.rpm"],
)

rpm(
    name = "libsepol-0__2.9-3.el8.x86_64",
    sha256 = "f91e372ffa25c4c82ae7e001565cf5ff73048c407083493555025fdb5fc4c14a",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libsepol-2.9-3.el8.x86_64.rpm"],
)

rpm(
    name = "libsigsegv-0__2.11-5.el8.x86_64",
    sha256 = "02d728cf74eb47005babeeab5ac68ca04472c643203a1faef0037b5f33710fe2",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libsigsegv-2.11-5.el8.x86_64.rpm"],
)

rpm(
    name = "libsmartcols-0__2.32.1-35.el8.x86_64",
    sha256 = "a07b2a63b2be6381af724b0c710f208520b475db81799c274459188b981bbf9d",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libsmartcols-2.32.1-35.el8.x86_64.rpm"],
)

rpm(
    name = "libssh-0__0.9.6-3.el8.x86_64",
    sha256 = "56db2bbc7028a0b031250b262a70d37de96edeb8832836e426d7a2b9d35bab12",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libssh-0.9.6-3.el8.x86_64.rpm"],
)

rpm(
    name = "libssh-config-0__0.9.6-3.el8.x86_64",
    sha256 = "e9e954ba21bac58e3aebaf52bf824758fe4c2ad09d75171b3009a214bd52bbec",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libssh-config-0.9.6-3.el8.noarch.rpm"],
)

rpm(
    name = "libstdc__plus____plus__-0__8.5.0-15.el8.x86_64",
    sha256 = "298bab1223dfa678e3fc567792e14dc8329b50bbf1d93a66bd287e7005da9fb0",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libstdc++-8.5.0-15.el8.x86_64.rpm"],
)

rpm(
    name = "libtasn1-0__4.13-3.el8.x86_64",
    sha256 = "e8d9697a8914226a2d3ed5a4523b85e8e70ac09cf90aae05395e6faee9858534",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libtasn1-4.13-3.el8.x86_64.rpm"],
)

rpm(
    name = "libtirpc-0__1.1.4-7.el8.x86_64",
    sha256 = "fe4dd02764dbb5a0369abaed181b2382e941b055e82485d9c5b2b8eca3cd2bda",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libtirpc-1.1.4-7.el8.x86_64.rpm"],
)

rpm(
    name = "libtpms-0__0.9.1-0.20211126git1ff6fe1f43.module_el8.6.0__plus__1087__plus__b42c8331.x86_64",
    sha256 = "cbe249e006aa70ba12707e0b7151164f4e4a50060d97e2be5eb139033e889b74",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/libtpms-0.9.1-0.20211126git1ff6fe1f43.module_el8.6.0+1087+b42c8331.x86_64.rpm"],
)

rpm(
    name = "libunistring-0__0.9.9-3.el8.x86_64",
    sha256 = "20bb189228afa589141d9c9d4ed457729d13c11608305387602d0b00ed0a3093",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libunistring-0.9.9-3.el8.x86_64.rpm"],
)

rpm(
    name = "libutempter-0__1.1.6-14.el8.x86_64",
    sha256 = "c8c54c56bff9ca416c3ba6bccac483fb66c81a53d93a19420088715018ed5169",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libutempter-1.1.6-14.el8.x86_64.rpm"],
)

rpm(
    name = "libuuid-0__2.32.1-35.el8.x86_64",
    sha256 = "b96be641cececacabbbe693de7c42dab86a9f0230e5108ec14493a8f3aefb859",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libuuid-2.32.1-35.el8.x86_64.rpm"],
)

rpm(
    name = "libverto-0__0.3.2-2.el8.x86_64",
    sha256 = "96b8ea32c5e9b3275788525ecbf35fd6ac1ae137754a2857503776512d4db58a",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libverto-0.3.2-2.el8.x86_64.rpm"],
)

rpm(
    name = "libverto-libev-0__0.3.2-2.el8.x86_64",
    sha256 = "cea0915f850f6fb3b3647302c89c03f8f572c767385b1aaa631b515776182a78",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/libverto-libev-0.3.2-2.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-0__8.1.0-1.el8.x86_64",
    sha256 = "76794e152bcd1afaf4234f5207f6d5ad64f959cd0912442a0ed95a0deb5ef1d6",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-client-0__8.1.0-1.el8.x86_64",
    sha256 = "28f9580e9869a57e5319e9eb686baf6ee0c8b78f060ca141b7b44fa63416810b",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-client-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-0__8.1.0-1.el8.x86_64",
    sha256 = "f3e045a9e5569028c17c6a3a337352e3dfdc6c6e458d1b59626f0e6d7c35a6bf",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-config-network-0__8.1.0-1.el8.x86_64",
    sha256 = "d7a334cefc2b1930690312b90fcbda31939375fbf772cf75b685d787faa3f6df",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-config-network-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-config-nwfilter-0__8.1.0-1.el8.x86_64",
    sha256 = "1324aa2a254e896ec93d0bc6dd46a5a5d914709bf31c593a9135b338dbbaeb0d",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-config-nwfilter-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-interface-0__8.1.0-1.el8.x86_64",
    sha256 = "adef3d44842fe6eb213372efc8a213dd1a691f31eb91786cd0a6d6079c35d41c",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-interface-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-network-0__8.1.0-1.el8.x86_64",
    sha256 = "411b737615343108a7c35be48daf2e5689a6a6c6bedda5b2ac5f4d2b6af4b8b9",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-network-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-nodedev-0__8.1.0-1.el8.x86_64",
    sha256 = "defa54d24aaa35a88cc25e32698b54a51e6166cc530db2229eea18e29ea507d4",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-nodedev-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-nwfilter-0__8.1.0-1.el8.x86_64",
    sha256 = "241ceaf3c48ee27e889e5da0fd30d59f38314a14cbfd71e856cb106aaf98a4ec",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-nwfilter-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-qemu-0__8.1.0-1.el8.x86_64",
    sha256 = "920f9b9cf2f5796557ccb9750edafb7b771b96507bce07ea643ec272f46245ec",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-qemu-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-secret-0__8.1.0-1.el8.x86_64",
    sha256 = "c3374b34763f7098f76e544d187994a35963bb6daa33bdd72861ca042396021a",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-secret-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-storage-0__8.1.0-1.el8.x86_64",
    sha256 = "57a3bd45057885ef1ec6dd24a57c44dadfe91beec12bc8a77ed63f26256f60d3",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-storage-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-storage-core-0__8.1.0-1.el8.x86_64",
    sha256 = "eef4039cbbe9fdb68ac978eb09e37e70327a882b02fd0d0bfb4d96291d83cfac",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-storage-core-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-storage-disk-0__8.1.0-1.el8.x86_64",
    sha256 = "6ed1f1880df78199ca67c4acf4ef4475bac86556d58d754738d13695277cc410",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-storage-disk-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-storage-gluster-0__8.1.0-1.el8.x86_64",
    sha256 = "9ce9eb261631d0dbaa87d87cea87b9f04ba1656f6ff2f513a17a4957708a337c",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-storage-gluster-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-storage-iscsi-0__8.1.0-1.el8.x86_64",
    sha256 = "a568cd8f64ecb332baf4c3702b5c2923f0385f35fe5538848dabea3a12e1a8db",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-storage-iscsi-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-storage-iscsi-direct-0__8.1.0-1.el8.x86_64",
    sha256 = "594e40db02436c1f578bad2bb6eb4b85e352cffc89a82f222c52201cdfed714a",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-storage-iscsi-direct-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-storage-logical-0__8.1.0-1.el8.x86_64",
    sha256 = "6880e9a1e955a84b5b7dbded9bee0a8c37c1d4c2cd551934b478a18cdb4151f4",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-storage-logical-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-storage-mpath-0__8.1.0-1.el8.x86_64",
    sha256 = "df5a5b3e30df3fdc35746f9823cf21d22c42931f1748e4ac51a7b43d33376767",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-storage-mpath-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-storage-rbd-0__8.1.0-1.el8.x86_64",
    sha256 = "efc34d2f9cce9be7a0629006a91528abd736fdbe8f7ec2ac90ac602c15913f3e",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-storage-rbd-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-storage-scsi-0__8.1.0-1.el8.x86_64",
    sha256 = "4e815de53712610eb362c310c27ccd3f57bf8fe2f3c1b4e5850677fdac8696d0",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-storage-scsi-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-libs-0__8.1.0-1.el8.x86_64",
    sha256 = "f60506097b2332ede702a948d3050c4c2b606daa7b0c2bcec088a4da11c62ac8",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-libs-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libxcrypt-0__4.1.1-6.el8.x86_64",
    sha256 = "645853feb85c921d979cb9cf9109663528429eda63cf5a1e31fe578d3d7e713a",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libxcrypt-4.1.1-6.el8.x86_64.rpm"],
)

rpm(
    name = "libxml2-0__2.9.7-14.el8.x86_64",
    sha256 = "029ee51b73e2c8396ff5481979f79f8ee50489b26592c864b84c07779fa175e3",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libxml2-2.9.7-14.el8.x86_64.rpm"],
)

rpm(
    name = "libxslt-0__1.1.32-6.el8.x86_64",
    sha256 = "250a8077296adcd83585002ff36684be416ba1481d7bd9ed96973e37b9137f00",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libxslt-1.1.32-6.el8.x86_64.rpm"],
)

rpm(
    name = "libyaml-0__0.1.7-5.el8.x86_64",
    sha256 = "00d537a434b1c2896dada83deb359d71fd005772031c73499c72f2cbd34521c5",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libyaml-0.1.7-5.el8.x86_64.rpm"],
)

rpm(
    name = "libzstd-0__1.4.4-1.el8.x86_64",
    sha256 = "7c2dc6044f13fe4ae04a4c1620da822a6be591b5129bf68ba98a3d8e9092f83b",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libzstd-1.4.4-1.el8.x86_64.rpm"],
)

rpm(
    name = "lua-libs-0__5.3.4-12.el8.x86_64",
    sha256 = "0268af0ee5754fb90fcf71b00fb737f1bf5b3c54c9ff312f13df8c2201311cfe",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/lua-libs-5.3.4-12.el8.x86_64.rpm"],
)

rpm(
    name = "lvm2-8__2.03.14-5.el8.x86_64",
    sha256 = "dfd7136f90ff3d420c90a8ef3a320fc214909bdc4163ceb9af64405782e91744",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/lvm2-2.03.14-5.el8.x86_64.rpm"],
)

rpm(
    name = "lvm2-libs-8__2.03.14-5.el8.x86_64",
    sha256 = "248212dfb76ab1aa9b197caaa73b48a97f530ee14d6825a0d53e7e3f1627116a",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/lvm2-libs-2.03.14-5.el8.x86_64.rpm"],
)

rpm(
    name = "lz4-libs-0__1.8.3-3.el8_4.x86_64",
    sha256 = "8ecac05bb0ec99f91026f2361f7443b9be3272582193a7836884ec473bf8f423",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/lz4-libs-1.8.3-3.el8_4.x86_64.rpm"],
)

rpm(
    name = "lzo-0__2.08-14.el8.x86_64",
    sha256 = "5c68635cb03533a38d4a42f6547c21a1d5f9952351bb01f3cf865d2621a6e634",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/lzo-2.08-14.el8.x86_64.rpm"],
)

rpm(
    name = "lzop-0__1.03-20.el8.x86_64",
    sha256 = "04eae61018a5be7656be832797016f97cd7b6e19d56f58cb658cd3969dedf2b0",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/lzop-1.03-20.el8.x86_64.rpm"],
)

rpm(
    name = "mdevctl-0__1.1.0-2.el8.x86_64",
    sha256 = "1d05bf0b9b60c05bece129b9ce3bb3b6e9153ac118d7f347371c4d0cad3f295c",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/mdevctl-1.1.0-2.el8.x86_64.rpm"],
)

rpm(
    name = "mozjs60-0__60.9.0-4.el8.x86_64",
    sha256 = "03b50a4ea5cf5655c67e2358fabb6e563eec4e7929e7fc6c4e92c92694f60fa0",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/mozjs60-60.9.0-4.el8.x86_64.rpm"],
)

rpm(
    name = "mpfr-0__3.1.6-1.el8.x86_64",
    sha256 = "e7f0c34f83c1ec2abb22951779e84d51e234c4ba0a05252e4ffd8917461891a5",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/mpfr-3.1.6-1.el8.x86_64.rpm"],
)

rpm(
    name = "ncurses-0__6.1-9.20180224.el8.x86_64",
    sha256 = "fc22ce73243e2f926e72967c28de57beabfa3720e51248b9a39e40207fbc6c8a",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/ncurses-6.1-9.20180224.el8.x86_64.rpm"],
)

rpm(
    name = "ncurses-base-0__6.1-9.20180224.el8.x86_64",
    sha256 = "41716536ea16798238ac89fbc3041b3f9dc80f9a64ea4b19d6e67ad2c909269a",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/ncurses-base-6.1-9.20180224.el8.noarch.rpm"],
)

rpm(
    name = "ncurses-libs-0__6.1-9.20180224.el8.x86_64",
    sha256 = "54609dd070a57a14a6103f0c06bea99bb0a4e568d1fbc6a22b8ba67c954d90bf",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/ncurses-libs-6.1-9.20180224.el8.x86_64.rpm"],
)

rpm(
    name = "netcf-libs-0__0.2.8-12.module_el8.6.0__plus__983__plus__a7505f3f.x86_64",
    sha256 = "e0a16e40b6cc6c803d2f1e49245d5b9000d915aa02663106cbd4195c99efdd56",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/netcf-libs-0.2.8-12.module_el8.6.0+983+a7505f3f.x86_64.rpm"],
)

rpm(
    name = "nettle-0__3.4.1-7.el8.x86_64",
    sha256 = "fe9a848502c595e0b7acc699d69c24b9c5ad0ac58a0b3933cd228f3633de31cb",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/nettle-3.4.1-7.el8.x86_64.rpm"],
)

rpm(
    name = "nfs-utils-1__2.3.3-56.el8.x86_64",
    sha256 = "a70e7057f04c1ab76f749aff0ed7b9db6f387ef87aa152ae43d354e83b4c74d5",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/nfs-utils-2.3.3-56.el8.x86_64.rpm"],
)

rpm(
    name = "nspr-0__4.34.0-3.el8.x86_64",
    sha256 = "d6bc88f314523b6929f6ef757395fe7a50ce240355c2dc701dfd34869b01f450",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/nspr-4.34.0-3.el8.x86_64.rpm"],
)

rpm(
    name = "nss-0__3.79.0-5.el8.x86_64",
    sha256 = "12b7e95871ae91c074029d4b094c50a2cde4989e32cb121b910dd5b1ac4e30ca",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/nss-3.79.0-5.el8.x86_64.rpm"],
)

rpm(
    name = "nss-softokn-0__3.79.0-5.el8.x86_64",
    sha256 = "3ef9c93e31c9bca0db443d4ea4ee7f48c82b17703d16cd0f1e179677e189350d",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/nss-softokn-3.79.0-5.el8.x86_64.rpm"],
)

rpm(
    name = "nss-softokn-freebl-0__3.79.0-5.el8.x86_64",
    sha256 = "6d8396a3f7d09950203288d350a60b1d8b8129e5d536b862cbfa478f677528cd",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/nss-softokn-freebl-3.79.0-5.el8.x86_64.rpm"],
)

rpm(
    name = "nss-sysinit-0__3.79.0-5.el8.x86_64",
    sha256 = "c22e5c5704771bb39c588b3423099f7dd87ae529dd17f6e6b5785e504e5deb5f",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/nss-sysinit-3.79.0-5.el8.x86_64.rpm"],
)

rpm(
    name = "nss-util-0__3.79.0-5.el8.x86_64",
    sha256 = "47f89c462e816998a0b74af85d4ef75188d86333fa6549831f71ca3172afda32",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/nss-util-3.79.0-5.el8.x86_64.rpm"],
)

rpm(
    name = "numactl-libs-0__2.0.12-13.el8.x86_64",
    sha256 = "b7b71ba34b3af893dc0acbb9d2228a2307da849d38e1c0007bd3d64f456640af",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/numactl-libs-2.0.12-13.el8.x86_64.rpm"],
)

rpm(
    name = "numad-0__0.5-26.20150602git.el8.x86_64",
    sha256 = "5d975c08273b1629683275c32f16e52ca8e37e6836598e211092c915d38878bf",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/numad-0.5-26.20150602git.el8.x86_64.rpm"],
)

rpm(
    name = "openldap-0__2.4.46-18.el8.x86_64",
    sha256 = "95327d6c83a370a12c125767403496435d20a94b70ee395eabfc356270d2ada9",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/openldap-2.4.46-18.el8.x86_64.rpm"],
)

rpm(
    name = "openssl-libs-1__1.1.1k-6.el8.x86_64",
    sha256 = "dd8e6b9311deaebebe81d959a61e60ee9068b8f76f234eefd39ff60c69dc94c8",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/openssl-libs-1.1.1k-6.el8.x86_64.rpm"],
)

rpm(
    name = "p11-kit-0__0.23.22-1.el8.x86_64",
    sha256 = "6a67c8721fe24af25ec56c6aae956a190d8463e46efed45adfbbd800086550c7",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/p11-kit-0.23.22-1.el8.x86_64.rpm"],
)

rpm(
    name = "p11-kit-trust-0__0.23.22-1.el8.x86_64",
    sha256 = "d218619a4859e002fe677703bc1767986314cd196ae2ac397ed057f3bec36516",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/p11-kit-trust-0.23.22-1.el8.x86_64.rpm"],
)

rpm(
    name = "pam-0__1.3.1-22.el8.x86_64",
    sha256 = "435bf0de1d95994530d596a93905394d066b8f0df0da360edce7dbe466ab3101",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/pam-1.3.1-22.el8.x86_64.rpm"],
)

rpm(
    name = "parted-0__3.2-39.el8.x86_64",
    sha256 = "2a9f8558c6c640d8f035004f3a9e607f6941e028785da562f01b61a142b5e282",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/parted-3.2-39.el8.x86_64.rpm"],
)

rpm(
    name = "pcre-0__8.42-6.el8.x86_64",
    sha256 = "876e9e99b0e50cb2752499045bafa903dd29e5c491d112daacef1ae16f614dad",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/pcre-8.42-6.el8.x86_64.rpm"],
)

rpm(
    name = "pcre2-0__10.32-3.el8.x86_64",
    sha256 = "2f865747024d26b91d5a9f2f35dd1b04e1039d64e772d0371b437145cd7beceb",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/pcre2-10.32-3.el8.x86_64.rpm"],
)

rpm(
    name = "platform-python-0__3.6.8-47.el8.x86_64",
    sha256 = "ead951c74984ba09c297c7286533b4b4ce2fcc18fa60102c760016e761a85a73",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/platform-python-3.6.8-47.el8.x86_64.rpm"],
)

rpm(
    name = "platform-python-setuptools-0__39.2.0-6.el8.x86_64",
    sha256 = "946ba273a3a3b6fdf140f3c03112918c0a556a5871c477f5dbbb98600e6ca557",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/platform-python-setuptools-39.2.0-6.el8.noarch.rpm"],
)

rpm(
    name = "policycoreutils-0__2.9-19.el8.x86_64",
    sha256 = "d2f2c3b827b279ff0117b04752cb6df2ed34bf82fdee6f3253f582bae0096e03",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/policycoreutils-2.9-19.el8.x86_64.rpm"],
)

rpm(
    name = "policycoreutils-python-utils-0__2.9-19.el8.x86_64",
    sha256 = "6630aa2e388e68f4c28adef15c4505fa7d315cdb176511818d539d2eb49b5da0",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/policycoreutils-python-utils-2.9-19.el8.noarch.rpm"],
)

rpm(
    name = "polkit-0__0.115-13.0.1.el8.2.x86_64",
    sha256 = "8bfccf9235747eb132c1d10c2f26b5544a0db078019eb7911b88522131e16dc8",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/polkit-0.115-13.0.1.el8.2.x86_64.rpm"],
)

rpm(
    name = "polkit-libs-0__0.115-13.0.1.el8.2.x86_64",
    sha256 = "d957da6b452f7b15830ad9a73176d4f04d9c3e26e119b7f3f4f4060087bb9082",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/polkit-libs-0.115-13.0.1.el8.2.x86_64.rpm"],
)

rpm(
    name = "polkit-pkla-compat-0__0.1-12.el8.x86_64",
    sha256 = "e7ee4b6d6456cb7da0332f5a6fb8a7c47df977bcf616f12f0455413765367e89",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/polkit-pkla-compat-0.1-12.el8.x86_64.rpm"],
)

rpm(
    name = "popt-0__1.18-1.el8.x86_64",
    sha256 = "3fc009f00388e66befab79be548ff3c7aa80ca70bd7f183d22f59137d8e2c2ae",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/popt-1.18-1.el8.x86_64.rpm"],
)

rpm(
    name = "psmisc-0__23.1-5.el8.x86_64",
    sha256 = "9d433d8c058e59c891c0852b95b3b87795ea30a85889c77ba0b12f965517d626",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/psmisc-23.1-5.el8.x86_64.rpm"],
)

rpm(
    name = "publicsuffix-list-dafsa-0__20180723-1.el8.x86_64",
    sha256 = "65ecf1e479dc2b2f7f09c2e86d7457043b3470b3eab3c4ee8909b50b0a669fc2",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/publicsuffix-list-dafsa-20180723-1.el8.noarch.rpm"],
)

rpm(
    name = "python3-audit-0__3.0.7-4.el8.x86_64",
    sha256 = "9b1b099aba60b188b29dae983994dce70a0c5887f75f0e1b1c794e95868fb6e2",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/python3-audit-3.0.7-4.el8.x86_64.rpm"],
)

rpm(
    name = "python3-libs-0__3.6.8-47.el8.x86_64",
    sha256 = "279a02854cd438f33d624c86cfa2b3c266f04eda7cb8a81d1d70970f8c6c90fa",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/python3-libs-3.6.8-47.el8.x86_64.rpm"],
)

rpm(
    name = "python3-libselinux-0__2.9-5.el8.x86_64",
    sha256 = "59ba5bf69953a5a2e902b0f08b7187b66d84968852d46a3579a059477547d1a0",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/python3-libselinux-2.9-5.el8.x86_64.rpm"],
)

rpm(
    name = "python3-libsemanage-0__2.9-8.el8.x86_64",
    sha256 = "dcba4ddc3769caa59be3c0844bfdcf9ede893c8cfe757efc814eb7955fc18499",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/python3-libsemanage-2.9-8.el8.x86_64.rpm"],
)

rpm(
    name = "python3-pip-wheel-0__9.0.3-22.el8.x86_64",
    sha256 = "772093492e290af496c3c8d4cf1d83d3288af49c4f0eb550f9c2489f96ecd89d",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/python3-pip-wheel-9.0.3-22.el8.noarch.rpm"],
)

rpm(
    name = "python3-policycoreutils-0__2.9-19.el8.x86_64",
    sha256 = "ed7e5244b90467cd6a569a6400d00b4a44b03f2c2a9d09eeb9a83592b63c2232",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/python3-policycoreutils-2.9-19.el8.noarch.rpm"],
)

rpm(
    name = "python3-pyyaml-0__3.12-12.el8.x86_64",
    sha256 = "525393e4d658e395c6280bd2ff4afe54999796c4722986325297ba4bfade3ea5",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/python3-pyyaml-3.12-12.el8.x86_64.rpm"],
)

rpm(
    name = "python3-setools-0__4.3.0-3.el8.x86_64",
    sha256 = "9851a70ab1371b4e86cdd268d36a7a87266c915fe7cb8a59ea8d422df320febf",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/python3-setools-4.3.0-3.el8.x86_64.rpm"],
)

rpm(
    name = "python3-setuptools-wheel-0__39.2.0-6.el8.x86_64",
    sha256 = "b19bd4f106ce301ee21c860183cc1c2ef9c09bdf495059bdf16e8d8ccc71bbe8",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/python3-setuptools-wheel-39.2.0-6.el8.noarch.rpm"],
)

rpm(
    name = "qemu-img-15__6.2.0-12.module_el8.7.0__plus__1140__plus__ff0772f9.x86_64",
    sha256 = "dc111b1573fa5d64de0d550e579a88de35eaf2f801df42b798d12978da5ba9cf",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/qemu-img-6.2.0-12.module_el8.7.0+1140+ff0772f9.x86_64.rpm"],
)

rpm(
    name = "quota-1__4.04-14.el8.x86_64",
    sha256 = "cce5f4086e7ecc31a12b753b5d0d97cb6d6c6f61e5c3066322449781ab1f63d0",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/quota-4.04-14.el8.x86_64.rpm"],
)

rpm(
    name = "quota-nls-1__4.04-14.el8.x86_64",
    sha256 = "bc7fc2028a29ac7a406719ed4f6740f6bf12c20961223c1e839a2a39069af38d",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/quota-nls-4.04-14.el8.noarch.rpm"],
)

rpm(
    name = "readline-0__7.0-10.el8.x86_64",
    sha256 = "fea868a7d82a7b6f392260ed4afb472dc4428fd71eab1456319f423a845b5084",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/readline-7.0-10.el8.x86_64.rpm"],
)

rpm(
    name = "rpcbind-0__1.2.5-9.el8.x86_64",
    sha256 = "64fec3cd98f3edd11dbc8b8f546726243df3da63866d88aa43a0591f840946c6",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/rpcbind-1.2.5-9.el8.x86_64.rpm"],
)

rpm(
    name = "rpm-0__4.14.3-23.el8.x86_64",
    sha256 = "4fa7a471aeba9b03daad1306a727fa12edb4b633f96a3da627495b24d6a4f185",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/rpm-4.14.3-23.el8.x86_64.rpm"],
)

rpm(
    name = "rpm-libs-0__4.14.3-23.el8.x86_64",
    sha256 = "59cdcaac989655b450a369c41282b2dc312a1e5b24f5be0233d15035a3682400",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/rpm-libs-4.14.3-23.el8.x86_64.rpm"],
)

rpm(
    name = "rpm-plugin-selinux-0__4.14.3-23.el8.x86_64",
    sha256 = "2f55d15cb498f2613ebaf6a59bc0303579ae5b80f6edfc3c0c226125b2d2ca30",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/rpm-plugin-selinux-4.14.3-23.el8.x86_64.rpm"],
)

rpm(
    name = "sed-0__4.5-5.el8.x86_64",
    sha256 = "5a09d6d967d12580c7e6ab92db35bcafd3426d6121ec60c78f54e3cd4961cd26",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/sed-4.5-5.el8.x86_64.rpm"],
)

rpm(
    name = "selinux-policy-0__3.14.3-93.el8.x86_64",
    sha256 = "8cbe5ec19344f77c23b407ff70e275e53e34af0fc52ad3f4c2c65dec0240a369",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/selinux-policy-3.14.3-93.el8.noarch.rpm"],
)

rpm(
    name = "selinux-policy-minimum-0__3.14.3-93.el8.x86_64",
    sha256 = "859f617275b4e61f9ae101cfeb7f05099dd313cf97bb42d41e69b8c9f1b5cb1a",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/selinux-policy-minimum-3.14.3-93.el8.noarch.rpm"],
)

rpm(
    name = "setup-0__2.12.2-7.el8.x86_64",
    sha256 = "0e5bdfebabb44848a9f37d2cc02a8a6a099b1c4c1644f4940718e55ce5b95464",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/setup-2.12.2-7.el8.noarch.rpm"],
)

rpm(
    name = "shadow-utils-2__4.6-17.el8.x86_64",
    sha256 = "fb3c71778fc23c4d3c91911c49e0a0d14c8a5192c431fc9ba07f2a14c938a172",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/shadow-utils-4.6-17.el8.x86_64.rpm"],
)

rpm(
    name = "sqlite-libs-0__3.26.0-15.el8.x86_64",
    sha256 = "46d01b59aba3aaccaf32731ada7323f62ae848fe17ff2bd020589f282b3ccac3",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/sqlite-libs-3.26.0-15.el8.x86_64.rpm"],
)

rpm(
    name = "swtpm-0__0.7.0-1.20211109gitb79fd91.module_el8.6.0__plus__1087__plus__b42c8331.x86_64",
    sha256 = "d062f5c3420aae57429124c44b9c204eea85d9e336f82b6a0b6b9b5b4043aa88",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/swtpm-0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331.x86_64.rpm"],
)

rpm(
    name = "swtpm-libs-0__0.7.0-1.20211109gitb79fd91.module_el8.6.0__plus__1087__plus__b42c8331.x86_64",
    sha256 = "75a44e4cb73b21d811c93a610dcc67c1f03215d5d8fdb6eff83c0e162b63f569",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/swtpm-libs-0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331.x86_64.rpm"],
)

rpm(
    name = "swtpm-tools-0__0.7.0-1.20211109gitb79fd91.module_el8.6.0__plus__1087__plus__b42c8331.x86_64",
    sha256 = "ac29006dfc30e4129a2ee0c11a08e32cec1e423bea26a473448507516d874c4b",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/swtpm-tools-0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331.x86_64.rpm"],
)

rpm(
    name = "systemd-0__239-62.el8.x86_64",
    sha256 = "49480ee9f4dc890144e9dc6609107b95c10e9af4e7e9576fc706f1ea278a562c",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/systemd-239-62.el8.x86_64.rpm"],
)

rpm(
    name = "systemd-container-0__239-62.el8.x86_64",
    sha256 = "964c9ff6b100572dc314c3f8b7bb1fde7a1f45cc76346945fc2bc60f4904f9b8",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/systemd-container-239-62.el8.x86_64.rpm"],
)

rpm(
    name = "systemd-libs-0__239-62.el8.x86_64",
    sha256 = "82c7321d5b3469a1add51514bf184b3a6b762d01a84eee053d039df055a8c775",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/systemd-libs-239-62.el8.x86_64.rpm"],
)

rpm(
    name = "systemd-pam-0__239-62.el8.x86_64",
    sha256 = "c225adc81575166631aa9dbc9cc642bd4a58613bd0e8b43c900e1c2de892c39a",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/systemd-pam-239-62.el8.x86_64.rpm"],
)

rpm(
    name = "systemd-udev-0__239-62.el8.x86_64",
    sha256 = "8cc2d02d51387f76468f9d25574138de8bd56631c98c2c358ac4ce265848751c",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/systemd-udev-239-62.el8.x86_64.rpm"],
)

rpm(
    name = "tzdata-0__2022a-2.el8.x86_64",
    sha256 = "0440f6795ede1959a5381056845a232db6991633aae371373e703d9c16e592e2",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/tzdata-2022a-2.el8.noarch.rpm"],
)

rpm(
    name = "unbound-libs-0__1.16.0-2.el8.x86_64",
    sha256 = "0ef7c208222374829233a615f364cb1c24980b812af2ee1aa3c064106b776256",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/unbound-libs-1.16.0-2.el8.x86_64.rpm"],
)

rpm(
    name = "util-linux-0__2.32.1-35.el8.x86_64",
    sha256 = "a61dd9d5e927c4a19209e9e975208484ae586cf163543e472e3d67b5d421f8d8",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/util-linux-2.32.1-35.el8.x86_64.rpm"],
)

rpm(
    name = "xz-0__5.2.4-4.el8.x86_64",
    sha256 = "99d7d4bfee1d5b55e08ee27c6869186531939f399d6c3ea33db191cae7e53f70",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/xz-5.2.4-4.el8.x86_64.rpm"],
)

rpm(
    name = "xz-libs-0__5.2.4-4.el8.x86_64",
    sha256 = "69d67ea8b4bd532f750ff0592f0098ace60470da0fd0e4056188fda37a268d42",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/xz-libs-5.2.4-4.el8.x86_64.rpm"],
)

rpm(
    name = "yajl-0__2.1.0-11.el8.x86_64",
    sha256 = "55a094ffe9f378ef465619bf6f60e9f26b672f67236883565fb893de7675c163",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/yajl-2.1.0-11.el8.x86_64.rpm"],
)

rpm(
    name = "zlib-0__1.2.11-19.el8.x86_64",
    sha256 = "439833454c91b662c1ed99eff65e4726d765e974f65faadaf1c29eb1281f28f9",
    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/zlib-1.2.11-19.el8.x86_64.rpm"],
)
```