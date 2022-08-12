---
title: KubeVirt替换virt-lantch中的libvirt的版本
readmore: true
date: 2022-08-12 18:49:38
categories: 云原生
tags:
- KubeVirtCI
- KubeVirt
---

编译 Libvirt 源码 并 创建yum源 参考之前发布的文章 {% post_link libvirt-compile %}

接下来：创建rpm/custom-repo.yaml 文件，并执行make rpm-deps

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



