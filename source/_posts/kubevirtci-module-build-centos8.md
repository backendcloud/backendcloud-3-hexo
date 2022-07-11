---
title: kubevirtci-module-build-centos8(workinprocess)
readmore: true
date: 2022-07-11 20:08:25
categories: 云原生
tags:
- KubeVirt CI
---




```bash
 ⚡ root@localhost  ~/kubevirtci/cluster-provision/centos8   main  bash build.sh 
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
STEP 1/15: FROM quay.io/fedora/fedora@sha256:38813cf0913241b7f13c7057e122f7c3cfa2e7c427dca3194f933d94612e280b
Trying to pull quay.io/fedora/fedora@sha256:38813cf0913241b7f13c7057e122f7c3cfa2e7c427dca3194f933d94612e280b...
Getting image source signatures
Copying blob 75f075168a24 skipped: already exists  
Copying config 3a66698e60 done  
Writing manifest to image destination
Storing signatures
STEP 2/15: ARG centos_version
--> fe04ebe1f9a
STEP 3/15: RUN dnf -y install jq iptables iproute dnsmasq qemu openssh-clients screen && dnf clean all
Fedora 36 - x86_64                              1.5 MB/s |  81 MB     00:53    
Fedora 36 openh264 (From Cisco) - x86_64        768  B/s | 2.5 kB     00:03    
Fedora Modular 36 - x86_64                      1.5 MB/s | 2.4 MB     00:01    
Fedora 36 - x86_64 - Updates                    529 kB/s |  21 MB     00:41    
Fedora Modular 36 - x86_64 - Updates            1.1 MB/s | 2.2 MB     00:02    
Dependencies resolved.
=================================================================================================
 Package                                 Arch    Version                           Repo      Size
=================================================================================================
Installing:
 dnsmasq                                 x86_64  2.86-9.fc36                       updates  340 k
 iproute                                 x86_64  5.15.0-2.fc36                     fedora   737 k
 iptables-legacy                         x86_64  1.8.7-15.fc36                     fedora    54 k
 ...
   xml-common-0.6.3-58.fc36.noarch                                               
  xz-5.2.5-9.fc36.x86_64                                                        
  yajl-2.1.0-18.fc36.x86_64                                                     

Complete!
42 files removed
--> 7a2a4e445bf
STEP 4/15: WORKDIR /
--> e3ef42c12ce
STEP 5/15: COPY vagrant.key /vagrant.key
--> 71ba916b3c3
STEP 6/15: RUN chmod 700 vagrant.key
--> 6cf4918c4dd
STEP 7/15: ENV DOCKERIZE_VERSION v0.6.1
--> 9447d1863a0
STEP 8/15: RUN curl -LO https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz   && tar -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz   && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz   && chmod u+x dockerize   && mv dockerize /usr/local/bin/
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 2935k  100 2935k    0     0  1681k      0  0:00:01  0:00:01 --:--:-- 3433k
dockerize
--> 2b3bf8a0844
STEP 9/15: COPY scripts/download_box.sh /
--> ba45bf5ddca
STEP 10/15: RUN echo "Centos8 version $centos_version"
Centos8 version 20210210.0
--> 1784a1e7905
STEP 11/15: ENV CENTOS_URL https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-Vagrant-8-$centos_version.x86_64.vagrant-libvirt.box
--> 4d559bfbd15
STEP 12/15: RUN /download_box.sh ${CENTOS_URL}
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0  902M    0  240k    0     0  36703      0  7:09:45  0:00:06  7:09:39 49329box.img
100  902M  100  902M    0     0   9.9M      0  0:01:30  0:01:30 --:--:-- 11.0M
--> 6a7046328a5
STEP 13/15: RUN curl -L -o /initrd.img http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/images/pxeboot/initrd.img
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 79.9M  100 79.9M    0     0  3508k      0  0:00:23  0:00:23 --:--:-- 4018k
--> 811f191d51f
STEP 14/15: RUN curl -L -o /vmlinuz http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/images/pxeboot/vmlinuz
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 10.0M  100 10.0M    0     0  5736k      0  0:00:01  0:00:01 --:--:-- 5740k
--> 3e9faad2966
STEP 15/15: COPY scripts/* /
COMMIT quay.io/kubevirtci/centos8
--> 05e579533e2
Successfully tagged quay.io/kubevirtci/centos8:latest
05e579533e2e04e16ba73d3bf556f48063c1604ea6fa084c8872522559ecbe41
 ⚡ root@localhost  ~/kubevirtci/cluster-provision/centos8   main  
```

本地生成了3.65G的 CentOS Stream 8镜像。

```bash
 ⚡ root@localhost  ~/kubevirtci/cluster-provision/centos8   main  docker images
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
REPOSITORY                                   TAG                   IMAGE ID      CREATED            SIZE
quay.io/kubevirtci/centos8                   latest                05e579533e2e  11 minutes ago     3.65 GB
```