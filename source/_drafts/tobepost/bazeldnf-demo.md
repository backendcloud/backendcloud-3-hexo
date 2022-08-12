

# 举例：KubeVirt替换libvirt的版本

创建rpm/custom-repo.yaml 文件，并执行make rpm-deps

```bash
[root@kubevirtci kubevirt]# cat rpm/custom-repo.yaml 
repositories:
- arch: x86_64
  baseurl: http://10.88.0.140:80/x86_64/ # The IP corrisponds to the rpms-http-server container
  name: custom-build
  gpgcheck: 0
  repo_gpgcheck: 0
  disabled: true
[root@kubevirtci kubevirt]# make CUSTOM_REPO=rpm/custom-repo.yaml LIBVIRT_VERSION=0:8.1.0-1.el8 SINGLE_ARCH="x86_64" rpm-deps
```

BUILD文件的libvirt相关的部分会被自动替换成所需的libvirt版本

```bash
        "@libvirt-client-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-qemu-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-libs-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-qemu-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-libs-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-devel-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-libs-0__8.1.0-1.el8.x86_64//rpm",
```

WORKSPACE文件libvirt相关的部分会被自动替换成所需的libvirt版本

```bash
rpm(
    name = "libvirt-client-0__8.1.0-1.el8.x86_64",
    sha256 = "28f9580e9869a57e5319e9eb686baf6ee0c8b78f060ca141b7b44fa63416810b",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-client-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-0__7.10.0-1.module_el8.6.0__plus__1046__plus__bd8eec5e.aarch64",
    sha256 = "28f67832b4a5192ebcc6c4dde1020629d7c29cb8e572f18f96520bcc6341cf9e",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/libvirt-daemon-7.10.0-1.module_el8.6.0+1046+bd8eec5e.aarch64.rpm"],
)

rpm(
    name = "libvirt-daemon-0__8.1.0-1.el8.x86_64",
    sha256 = "f3e045a9e5569028c17c6a3a337352e3dfdc6c6e458d1b59626f0e6d7c35a6bf",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-qemu-0__7.10.0-1.module_el8.6.0__plus__1046__plus__bd8eec5e.aarch64",
    sha256 = "68bf0a1e9cd263d0d71ac74a06d263ce3e961ad04df345ac58e87566e521c553",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/libvirt-daemon-driver-qemu-7.10.0-1.module_el8.6.0+1046+bd8eec5e.aarch64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-qemu-0__8.1.0-1.el8.x86_64",
    sha256 = "920f9b9cf2f5796557ccb9750edafb7b771b96507bce07ea643ec272f46245ec",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-qemu-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-devel-0__7.10.0-1.module_el8.6.0__plus__1046__plus__bd8eec5e.aarch64",
    sha256 = "07f8a02c8de60700f95073f256ff7da55c3f041251140c14832ce5fe92df3fb1",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/libvirt-devel-7.10.0-1.module_el8.6.0+1046+bd8eec5e.aarch64.rpm"],
)

rpm(
    name = "libvirt-devel-0__8.1.0-1.el8.x86_64",
    sha256 = "6e6dc61acb4dabd93e7ef20103d4820447e7e8d055909ae8f4c625e91dcf56af",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-devel-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-libs-0__7.10.0-1.module_el8.6.0__plus__1046__plus__bd8eec5e.aarch64",
    sha256 = "ed9803fbaccc81266aa990aab0f1a4bf96b520700226991f6e1fe69e0724e14d",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/libvirt-libs-7.10.0-1.module_el8.6.0+1046+bd8eec5e.aarch64.rpm"],
)

rpm(
    name = "libvirt-libs-0__8.1.0-1.el8.x86_64",
    sha256 = "f60506097b2332ede702a948d3050c4c2b606daa7b0c2bcec088a4da11c62ac8",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-libs-8.1.0-1.el8.x86_64.rpm"],
)
```

```bash

```


# bazeldnf

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