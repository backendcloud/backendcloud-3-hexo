---
title: 用于打包指定libvirt版本的镜像的脚本
readmore: true
date: 2022-07-22 18:42:23
categories: 云原生
tags:
- KubeVirt CI
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

# 编写Dockfile的模板文件

```bash
 ⚡ root@localhost  ~/libvirt   master  cat Dockerfile.in 
FROM fedora:@FEDORA_VERSION@

LABEL maintainer="The KubeVirt Project <kubevirt-dev@googlegroups.com>"

RUN dnf install -y dnf-plugins-core && \
    dnf copr enable -y @kubevirt/libvirt-@LIBVIRT_SOURCE_VERSION@ && \
    dnf copr enable -y @kubevirt/qemu-kvm-@QEMU_SOURCE_VERSION@ && \
    dnf copr enable -y @kubevirt/seabios-@SEABIOS_SOURCE_VERSION@ && \
    dnf install -y \
        libvirt-daemon-driver-qemu-@LIBVIRT_BINARY_VERSION@ \
        libvirt-client-@LIBVIRT_BINARY_VERSION@ \
        libvirt-daemon-driver-storage-core-@LIBVIRT_BINARY_VERSION@ \
        qemu-kvm-@QEMU_BINARY_VERSION@ \
        seabios-bin-@SEABIOS_BINARY_VERSION@ \
        seavgabios-bin-@SEABIOS_BINARY_VERSION@ \
        xorriso \
        selinux-policy selinux-policy-targeted \
        nftables \
        iptables \
        procps-ng \
        findutils \
        augeas && \
    dnf update -y libgcrypt && \
    dnf clean all && \
    for qemu in \
        /usr/bin/qemu-system-aarch64 \
        /usr/bin/qemu-system-ppc64 \
        /usr/bin/qemu-system-s390x \
        /usr/bin/qemu-system-x86_64 \
        /usr/libexec/qemu-kvm; \
    do \
        test -f "$qemu" || continue; \
        # Allow qemu to bind to privileged ports \
        # From: https://github.com/kubevirt/kubevirt/pull/1138 \
        setcap CAP_NET_BIND_SERVICE=+eip "$qemu" && \
        break; \
    done

COPY augconf /augconf
RUN augtool -f /augconf
```

在分析替换掉模板文件中的版本号并编译上传镜像的脚本前先提下上面文件中的`augtool -f /augconf`和`setcap CAP_NET_BIND_SERVICE=+eip`。

# augeas

Augeas是一个配置文件编辑工具。

> http://augeas.net/
> 
> https://github.com/hercules-team/augeas

## install

    dnf install -y augeas

## 使用

比如修改libvirt的配置文件:

```bash
⚡ root@localhost  ~/libvirt   master  cat augconf 
 Enable unauthenticated tcp
set /files/etc/libvirt/libvirtd.conf/listen_tls 0
set /files/etc/libvirt/libvirtd.conf/listen_tcp 1
set /files/etc/libvirt/libvirtd.conf/auth_tcp none

# Listen on all interfaces for now
set /files/etc/libvirt/qemu.conf/stdio_handler logd
set /files/etc/libvirt/qemu.conf/spice_listen 0.0.0.0
set /files/etc/libvirt/qemu.conf/vnc_listen 0.0.0.0
set /files/etc/libvirt/qemu.conf/vnc_tls 0
set /files/etc/libvirt/qemu.conf/vnc_sasl 0

# Fixate user and group
set /files/etc/libvirt/qemu.conf/user qemu
set /files/etc/libvirt/qemu.conf/group qemu
set /files/etc/libvirt/qemu.conf/dynamic_ownership 1
set /files/etc/libvirt/qemu.conf/remember_owner 0

# Workaround libvirt bug in /dev/ handling
set /files/etc/libvirt/qemu.conf/namespaces

# Disable cgroups
set /files/etc/libvirt/qemu.conf/cgroup_controllers

# Have virtlogd log to stderr
set /files/etc/libvirt/virtlogd.conf/log_outputs 2:stderr

# Important to save
save
⚡ root@localhost  ~/libvirt   master  augtool -f augconf
```

# setcap CAP_NET_BIND_SERVICE=+eip

```bash
Capabilities的主要思想在于分割root用户的特权，即将root的特权分割成不同的能力，每种能力代表一定的特权操作。例如：能力CAP_SYS_MODULE表示用户能够加载(或卸载)内核模块的特权操作，而CAP_SETUID表示用户能够修改进程用户身份的特权操作。在Capbilities中系统将根据进程拥有的能力来进行特权操作的访问控制。
    在Capilities中，只有进程和可执行文件才具有能力，每个进程拥有三组能力集，分别称为cap_effective, cap_inheritable, cap_permitted(分别简记为:pE,pI,pP)，其中cap_permitted表示进程所拥有的最大能力集；cap_effective表示进程当前可用的能力集，可以看做是cap_permitted的一个子集；而cap_inheitable则表示进程可以传递给其子进程的能力集。系统根据进程的cap_effective能力集进行访问控制，cap_effective为cap_permitted的子集，进程可以通过取消cap_effective中的某些能力来放弃进程的一些特权。可执行文件也拥有三组能力集，对应于进程的三组能力集，分别称为cap_effective, cap_allowed 和 cap_forced（分别简记为fE,fI,fP），其中，cap_allowed表示程序运行时可从原进程的cap_inheritable中集成的能力集，cap_forced表示运行文件时必须拥有才能完成其服务的能力集；而cap_effective则表示文件开始运行时可以使用的能力。
Linux内核中Capabilities的实现机制
     Linux内核从2.2版本开始，就加进的Capabilities的概念与机制，并随着版本升高逐步得到改进。在linux中，root权限被分割成一下29中能力：
CAP_CHOWN:修改文件属主的权限
CAP_DAC_OVERRIDE:忽略文件的DAC访问限制
CAP_DAC_READ_SEARCH:忽略文件读及目录搜索的DAC访问限制
CAP_FOWNER：忽略文件属主ID必须和进程用户ID相匹配的限制
CAP_FSETID:允许设置文件的setuid位
CAP_KILL:允许对不属于自己的进程发送信号
CAP_SETGID:允许改变进程的组ID
CAP_SETUID:允许改变进程的用户ID
CAP_SETPCAP:允许向其他进程转移能力以及删除其他进程的能力
CAP_LINUX_IMMUTABLE:允许修改文件的IMMUTABLE和APPEND属性标志
CAP_NET_BIND_SERVICE:允许绑定到小于1024的端口
CAP_NET_BROADCAST:允许网络广播和多播访问
CAP_NET_ADMIN:允许执行网络管理任务
CAP_NET_RAW:允许使用原始套接字
CAP_IPC_LOCK:允许锁定共享内存片段
CAP_IPC_OWNER:忽略IPC所有权检查
CAP_SYS_MODULE:允许插入和删除内核模块
CAP_SYS_RAWIO:允许直接访问/devport,/dev/mem,/dev/kmem及原始块设备
CAP_SYS_CHROOT:允许使用chroot()系统调用
CAP_SYS_PTRACE:允许跟踪任何进程
CAP_SYS_PACCT:允许执行进程的BSD式审计
CAP_SYS_ADMIN:允许执行系统管理任务，如加载或卸载文件系统、设置磁盘配额等
CAP_SYS_BOOT:允许重新启动系统
CAP_SYS_NICE:允许提升优先级及设置其他进程的优先级
CAP_SYS_RESOURCE:忽略资源限制
CAP_SYS_TIME:允许改变系统时钟
CAP_SYS_TTY_CONFIG:允许配置TTY设备
CAP_MKNOD:允许使用mknod()系统调用
CAP_LEASE:允许修改文件锁的FL_LEASE标志
```

设置可以非ROOT用户启动 1024以下端口 `setcap CAP_NET_BIND_SERVICE=+eip "$qemu"`。

# 脚本（注解已添加在代码中）
```bash
#!/bin/bash

set -xe

# 默认镜像名称，默认libvirt版本号，若要修改默认版本号，可修改环境变量或者命令行设置变量值，特别注意的修改默认值需要将对应变量名称的"CONF_"去掉。
CONF_IMAGE_NAME="kubevirt/libvirt"

CONF_FEDORA_VERSION="32"
CONF_LIBVIRT_VERSION="6.6.0-8.el8"
CONF_QEMU_VERSION="5.1.0-16.el8"
CONF_SEABIOS_VERSION="1.14.0-1.el8"

CONF_TARGET_ARCHITECTURES="amd64"

# Apply overrides from the environment 若环境变量或命令未配置该变量则用默认值
IMAGE_NAME="${IMAGE_NAME:-$CONF_IMAGE_NAME}"
FEDORA_VERSION="${CONF_FEDORA_VERSION:-$CONF_FEDORA_VERSION}"
LIBVIRT_VERSION="${LIBVIRT_VERSION:-$CONF_LIBVIRT_VERSION}"
QEMU_VERSION="${QEMU_VERSION:-$CONF_QEMU_VERSION}"
SEABIOS_VERSION="${SEABIOS_VERSION:-$CONF_SEABIOS_VERSION}"
TARGET_ARCHITECTURES="${TARGET_ARCHITECTURES:-$CONF_TARGET_ARCHITECTURES}"

GIT_UNIX_TIMESTAMP=$(git show --format='%ct' | head -1)
GIT_TIMESTAMP=$(date --date="@${GIT_UNIX_TIMESTAMP}" '+%Y%m%d')
GIT_COMMIT=$(git describe --always)
#时间戳和commit号的组合作为tag
IMAGE_TAG="${GIT_TIMESTAMP}-${GIT_COMMIT}"
#在每一个以空格分开的架构前加上"linux/"
DOCKER_PLATFORMS="linux/$(echo "${TARGET_ARCHITECTURES}" | sed "s: :,linux/:g")"

die() {
    echo "$@" >&2
    exit 1
}

#将centos的el8/el9替换成fedora的大版本号，包括替换安装包和fedora的大版本号不一致的情况
_make_binary_version() {
    local package_version="$1"
    local os_version="$2"

    # Strip the .fc* or .el* suffix, if present
    package_version="${package_version%.fc*}"
    package_version="${package_version%.el*}"

    echo "${package_version}.fc${os_version}"
}

# 根据Dockerfile模板和版本号信息生成Dockerfile文件
prepare_dockerfile() {
    # Source and binary versions might differ, because we might for
    # example rebuild a SRPM coming from Fedora 34 on Fedora 32
    LIBVIRT_SOURCE_VERSION="${LIBVIRT_VERSION}"
    QEMU_SOURCE_VERSION="${QEMU_VERSION}"
    SEABIOS_SOURCE_VERSION="${SEABIOS_VERSION}"
    LIBVIRT_BINARY_VERSION="$(_make_binary_version "${LIBVIRT_VERSION}" "${FEDORA_VERSION}")"
    QEMU_BINARY_VERSION="$(_make_binary_version "${QEMU_VERSION}" "${FEDORA_VERSION}")"
    SEABIOS_BINARY_VERSION="$(_make_binary_version "${SEABIOS_VERSION}" "${FEDORA_VERSION}")"

    # We need to do this instead of using the ARG feature because buildx
    # doesn't currently behave correctly when cross-building containers
    # that use that feature: preprocessing the file ourselves works
    # around that limitation
    sed -e "s/@FEDORA_VERSION@/${FEDORA_VERSION}/g" \
        -e "s/@LIBVIRT_SOURCE_VERSION@/${LIBVIRT_SOURCE_VERSION}/g" \
        -e "s/@LIBVIRT_BINARY_VERSION@/${LIBVIRT_BINARY_VERSION}/g" \
        -e "s/@QEMU_SOURCE_VERSION@/${QEMU_SOURCE_VERSION}/g" \
        -e "s/@QEMU_BINARY_VERSION@/${QEMU_BINARY_VERSION}/g" \
        -e "s/@SEABIOS_SOURCE_VERSION@/${SEABIOS_SOURCE_VERSION}/g" \
        -e "s/@SEABIOS_BINARY_VERSION@/${SEABIOS_BINARY_VERSION}/g" \
        <Dockerfile.in >Dockerfile
}

# 打包镜像，分单平台打包和多平台打包buildx
build_container() {
    local tag="$1"
    local platform="$2"
    local builder="$3"
    local push="$4"

    case "${builder}" in
    BUILDER_BUILDX)
        docker buildx build \
               --progress=plain \
               --platform="${platform}" \
               --tag "${tag}" \
               .
        ;;
    BUILDER_BUILD)
        docker build \
               --tag "${tag}" \
               .
        ;;
    *)
        die "build_container: Invalid argument"
        ;;
    esac
}

push_container() {
    local tag="$1"
    local platform="$2"
    local builder="$3"
    local push="$4"

    case "${push}" in
    PUSH_DOCKER)
        push_arg="--load"
        ;;
    PUSH_REGISTRY)
        push_arg="--push"
        ;;
    *)
        die "push_container: Invalid argument"
        ;;
    esac

    case "${builder}" in
    BUILDER_BUILDX)
        docker buildx build \
               --progress=plain \
               "${push_arg}" \
               --platform="${platform}" \
               --tag "${tag}" \
               .
        ;;
    BUILDER_BUILD)
        docker build \
               --tag "${tag}" \
               .
        if test "${push}" = PUSH_REGISTRY; then
            docker push "${tag}"
        fi
        ;;
    esac
}

#删除镜像
delete_container() {
    local tag="$1"
    local platform="$2"
    local builder="$3"
    local push="$4"

    case "${push}" in
    PUSH_DOCKER)
        ;;
    *)
        die "delete_container: Invalid argument"
        ;;
    esac

    docker rmi "${tag}"
}

#起容器测试镜像里的qemu和libvirt是否安装正常
test_container() {
    local tag="$1"
    local platform="$2"
    local builder="$3"
    local push="$4"

    docker run \
           --rm \
           --platform="${platform}" \
           "${tag}" \
           uname -m
    docker run \
           --rm \
           --platform="${platform}" \
           "${tag}" \
           libvirtd --version
    docker run \
           --rm \
           --platform="${platform}" \
           "${tag}" \
           sh -c '
               set -e; \
               for qemu in \
                   /usr/bin/qemu-system-aarch64 \
                   /usr/bin/qemu-system-ppc64 \
                   /usr/bin/qemu-system-s390x \
                   /usr/bin/qemu-system-x86_64 \
                   /usr/libexec/qemu-kvm; \
               do \
                   test -f "$qemu" || continue; \
                   "$qemu" --version && break; \
               done
           '
}

build_and_test_containers() {
    local tag
    local platform
    local arch

    # We need to build for one architecture at a time because buildx
    # can't currently export multi-architecture containers to the Docker
    # daemon, so we wouldn't be able to test the results otherwise. The
    # deploy step will reuse the cached layers, so we're not wasting any
    # extra time building twice nor are we uploading contents that we
    # haven't made sure actually works
    for arch in ${TARGET_ARCHITECTURES}; do
        tag="${IMAGE_NAME}:${IMAGE_TAG}.${arch}"
        platform="linux/${arch}"

        build_container "${tag}" "${platform}" BUILDER_BUILDX PUSH_DOCKER
        push_container "${tag}" "${platform}" BUILDER_BUILDX PUSH_DOCKER
        test_container "${tag}" "${platform}" BUILDER_BUILDX PUSH_DOCKER
        delete_container "${tag}" "${platform}" BUILDER_BUILDX PUSH_DOCKER
    done
}
build_and_test_containers
```

 

# run

一次失败的执行：
```bash
Enabling a Copr repository. Please note that this repository is not part
of the main distribution, and quality may vary.

The Fedora Project does not exercise any power over the contents of
this repository beyond the rules outlined in the Copr FAQ at
<https://docs.pagure.org/copr.copr/user_documentation.html#what-i-can-build-in-copr>,
and packages are not held to any quality or security level.

Please do not file bug reports about these packages in Fedora
Bugzilla. In case of problems, contact the owner of this repository.
Error: This repository does not have any builds yet so you cannot enable it now.
```
> 估计因这种情况报的bug太多了，提示不要上传bug了，查查自己指定的dnf用的仓库是否存在。


完整的一次正常的执行：
```bash
 ⚡ root@centos9  ~/libvirt   master ±  IMAGE_NAME=localhost:5000/my-libvirt ./hack/local-build.sh

+ source hack/common.sh
++ source hack/config
+++ CONF_IMAGE_NAME=kubevirt/libvirt
+++ CONF_FEDORA_VERSION=32
+++ CONF_LIBVIRT_VERSION=6.6.0-13.el8
+++ CONF_QEMU_VERSION=5.1.0-16.el8
+++ CONF_SEABIOS_VERSION=1.14.0-1.el8
+++ CONF_TARGET_ARCHITECTURES=amd64
++ IMAGE_NAME=localhost:5000/my-libvirt
++ FEDORA_VERSION=32
++ LIBVIRT_VERSION=6.6.0-13.el8
++ QEMU_VERSION=5.1.0-16.el8
++ SEABIOS_VERSION=1.14.0-1.el8
++ TARGET_ARCHITECTURES=amd64
+++ git show --format=%ct
+++ head -1
++ GIT_UNIX_TIMESTAMP=1629303956
+++ date --date=@1629303956 +%Y%m%d
++ GIT_TIMESTAMP=20210819
+++ git describe --always
++ GIT_COMMIT=f506def
++ IMAGE_TAG=20210819-f506def
+++ echo amd64
+++ sed 's: :,linux/:g'
++ DOCKER_PLATFORMS=linux/amd64
+ tag=localhost:5000/my-libvirt:20210819-f506def
+ platform=linux/amd64
+ prepare_dockerfile
+ LIBVIRT_SOURCE_VERSION=6.6.0-13.el8
+ QEMU_SOURCE_VERSION=5.1.0-16.el8
+ SEABIOS_SOURCE_VERSION=1.14.0-1.el8
++ _make_binary_version 6.6.0-13.el8 32
++ local package_version=6.6.0-13.el8
++ local os_version=32
++ package_version=6.6.0-13.el8
++ package_version=6.6.0-13
++ echo 6.6.0-13.fc32
+ LIBVIRT_BINARY_VERSION=6.6.0-13.fc32
++ _make_binary_version 5.1.0-16.el8 32
++ local package_version=5.1.0-16.el8
++ local os_version=32
++ package_version=5.1.0-16.el8
++ package_version=5.1.0-16
++ echo 5.1.0-16.fc32
+ QEMU_BINARY_VERSION=5.1.0-16.fc32
++ _make_binary_version 1.14.0-1.el8 32
++ local package_version=1.14.0-1.el8
++ local os_version=32
++ package_version=1.14.0-1.el8
++ package_version=1.14.0-1
++ echo 1.14.0-1.fc32
+ SEABIOS_BINARY_VERSION=1.14.0-1.fc32
+ sed -e s/@FEDORA_VERSION@/32/g -e s/@LIBVIRT_SOURCE_VERSION@/6.6.0-13.el8/g -e s/@LIBVIRT_BINARY_VERSION@/6.6.0-13.fc32/g -e s/@QEMU_SOURCE_VERSION@/5.1.0-16.el8/g -e s/@QEMU_BINARY_VERSION@/5.1.0-16.fc32/g -e s/@SEABIOS_SOURCE_VERSION@/1.1/@SEABIOS_BINARY_VERSION@/1.14.0-1.fc32/g
+ build_and_test_containers
+ local tag
+ local platform
+ local arch
+ for arch in ${TARGET_ARCHITECTURES}
+ tag=localhost:5000/my-libvirt:20210819-f506def.amd64
+ platform=linux/amd64
+ build_container localhost:5000/my-libvirt:20210819-f506def.amd64 linux/amd64 BUILDER_BUILDX PUSH_DOCKER
+ local tag=localhost:5000/my-libvirt:20210819-f506def.amd64
+ local platform=linux/amd64
+ local builder=BUILDER_BUILDX
+ local push=PUSH_DOCKER
+ case "${builder}" in
+ docker buildx build --progress=plain --platform=linux/amd64 --tag localhost:5000/my-libvirt:20210819-f506def.amd64 .
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
STEP 1/5: FROM fedora:32
STEP 2/5: LABEL maintainer="The KubeVirt Project <kubevirt-dev@googlegroups.com>"
--> 0575ea56c74
STEP 3/5: RUN dnf install -y dnf-plugins-core &&     dnf install -y         libvirt-daemon-driver-qemu         libvirt-client         libvirt-daemon-driver-storage-core         qemu-kvm         seabios-bin         seavgabios-bin         xorriux-policy selinux-policy-targeted         nftables         iptables         procps-ng         findutils         augeas &&     dnf update -y libgcrypt &&     dnf clean all &&     for qemu in         /usr/bin/qemu-system-aarch64         /usr/bic64         /usr/bin/qemu-system-s390x         /usr/bin/qemu-system-x86_64         /usr/libexec/qemu-kvm;     do         test -f "$qemu" || continue;         setcap CAP_NET_BIND_SERVICE=+eip "$qemu" &&         break;     done
Fedora 32 openh264 (From Cisco) - x86_64        1.6 kB/s | 2.5 kB     00:01    
Fedora Modular 32 - x86_64                      1.6 MB/s | 4.9 MB     00:03    
Fedora Modular 32 - x86_64 - Updates            2.3 MB/s | 4.6 MB     00:02    
Fedora 32 - x86_64 - Updates                    5.5 MB/s |  30 MB     00:05    
Fedora 32 - x86_64                              6.2 MB/s |  70 MB     00:11    
Dependencies resolved.
================================================================================
 Package                      Arch       Version              Repository   Size
================================================================================
Installing:
 dnf-plugins-core             noarch     4.0.18-1.fc32        updates      33 k
Installing dependencies:
 python3-dateutil             noarch     1:2.8.0-8.fc32       fedora      291 k
 python3-distro               noarch     1.4.0-5.fc32         fedora       35 k
 python3-dnf-plugins-core     noarch     4.0.18-1.fc32        updates     191 k
 python3-setuptools           noarch     41.6.0-2.fc32        fedora      588 k
 python3-six                  noarch     1.14.0-2.fc32        fedora       36 k

Transaction Summary
================================================================================
Install  6 Packages

Total download size: 1.1 M
Installed size: 4.6 M
Downloading Packages:
(1/6): python3-dateutil-2.8.0-8.fc32.noarch.rpm 254 kB/s | 291 kB     00:01    
(2/6): python3-distro-1.4.0-5.fc32.noarch.rpm   347 kB/s |  35 kB     00:00    
(3/6): python3-dnf-plugins-core-4.0.18-1.fc32.n 144 kB/s | 191 kB     00:01    
(4/6): dnf-plugins-core-4.0.18-1.fc32.noarch.rp  25 kB/s |  33 kB     00:01    
(5/6): python3-six-1.14.0-2.fc32.noarch.rpm     300 kB/s |  36 kB     00:00    
(6/6): python3-setuptools-41.6.0-2.fc32.noarch. 2.4 MB/s | 588 kB     00:00    
--------------------------------------------------------------------------------
Total                                           460 kB/s | 1.1 MB     00:02     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                        1/1 
  Installing       : python3-six-1.14.0-2.fc32.noarch                       1/6 
  Installing       : python3-dateutil-1:2.8.0-8.fc32.noarch                 2/6 
  Installing       : python3-setuptools-41.6.0-2.fc32.noarch                3/6 
  Installing       : python3-distro-1.4.0-5.fc32.noarch                     4/6 
  Installing       : python3-dnf-plugins-core-4.0.18-1.fc32.noarch          5/6 
  Installing       : dnf-plugins-core-4.0.18-1.fc32.noarch                  6/6 
  Running scriptlet: dnf-plugins-core-4.0.18-1.fc32.noarch                  6/6 
  Verifying        : dnf-plugins-core-4.0.18-1.fc32.noarch                  1/6 
  Verifying        : python3-dnf-plugins-core-4.0.18-1.fc32.noarch          2/6 
  Verifying        : python3-dateutil-1:2.8.0-8.fc32.noarch                 3/6 
  Verifying        : python3-distro-1.4.0-5.fc32.noarch                     4/6 
  Verifying        : python3-setuptools-41.6.0-2.fc32.noarch                5/6 
  Verifying        : python3-six-1.14.0-2.fc32.noarch                       6/6 

Installed:
  dnf-plugins-core-4.0.18-1.fc32.noarch                                         
  python3-dateutil-1:2.8.0-8.fc32.noarch                                        
  python3-distro-1.4.0-5.fc32.noarch                                            
  python3-dnf-plugins-core-4.0.18-1.fc32.noarch                                 
  python3-setuptools-41.6.0-2.fc32.noarch                                       
  python3-six-1.14.0-2.fc32.noarch                                              

Complete!
Last metadata expiration check: 0:00:27 ago on Fri Jul 22 05:23:22 2022.
Dependencies resolved.
=============================================================================================
 Package                              Arch    Version                          Repo      Size
=============================================================================================
Installing:
 augeas                               x86_64  1.12.0-3.fc32                    fedora    50 k
 findutils                            x86_64  1:4.7.0-4.fc32                   updates  552 k
 iptables                             x86_64  1.8.4-9.fc32                     updates  106 k
 libvirt-client                       x86_64  6.1.0-4.fc32                     updates  331 k
 libvirt-daemon-driver-qemu           x86_64  6.1.0-4.fc32                     updates  820 k
 libvirt-daemon-driver-storage-core   x86_64  6.1.0-4.fc32                     updates  213 k
 nftables                             x86_64  1:0.9.3-4.fc32                   updates  321 k
 procps-ng                            x86_64  3.3.16-2.fc32                    updates  336 k
 qemu-kvm                             x86_64  2:4.2.1-1.fc32                   updates   11 k
 seabios-bin                          noarch  1.13.0-2.fc32                    fedora   160 k
 seavgabios-bin                       noarch  1.13.0-2.fc32                    fedora    36 k
 selinux-policy                       noarch  3.14.5-46.fc32                   updates   74 k
 selinux-policy-targeted              noarch  3.14.5-46.fc32                   updates  8.0 M
 xorriso                              x86_64  1.5.4-2.fc32                     updates  315 k
Upgrading:
 pcre2                                x86_64  10.36-4.fc32                     updates  233 k
 pcre2-syntax                         noarch  10.36-4.fc32                     updates  142 k
 python3-rpm                          x86_64  4.15.1.1-1.fc32.1                updates   94 k
 rpm                                  x86_64  4.15.1.1-1.fc32.1                updates  495 k
 rpm-build-libs                       x86_64  4.15.1.1-1.fc32.1                updates   93 k
 rpm-libs                             x86_64  4.15.1.1-1.fc32.1                updates  298 k
 rpm-sign-libs                        x86_64  4.15.1.1-1.fc32.1                updates   22 k
 systemd                              x86_64  245.9-1.fc32                     updates  4.2 M
 systemd-libs                         x86_64  245.9-1.fc32                     updates  556 k
 systemd-pam                          x86_64  245.9-1.fc32                     updates  297 k
 systemd-rpm-macros                   noarch  245.9-1.fc32                     updates   22 k
Installing dependencies:
 SDL2                                 x86_64  2.0.12-1.fc32                    fedora   518 k
 adwaita-cursor-theme                 noarch  3.36.1-1.fc32                    updates  623 k
 adwaita-icon-theme                   noarch  3.36.1-1.fc32                    updates   11 M
 alsa-lib                             x86_64  1.2.3.2-1.fc32                   updates  474 k
 at-spi2-atk                          x86_64  2.34.2-1.fc32                    fedora    90 k
 at-spi2-core                         x86_64  2.36.1-1.fc32                    updates  174 k
 atk                                  x86_64  2.36.0-1.fc32                    fedora   273 k
 augeas-libs                          x86_64  1.12.0-3.fc32                    fedora   419 k
 autogen-libopts                      x86_64  5.18.16-4.fc32                   fedora    76 k
 avahi-libs                           x86_64  0.7-24.fc32                      updates   63 k
 bluez-libs                           x86_64  5.55-1.fc32                      updates   89 k
 brlapi                               x86_64  0.7.0-14.fc32                    updates  161 k
 brltty                               x86_64  6.0-14.fc32                      updates  1.4 M
 bzip2                                x86_64  1.0.8-2.fc32                     fedora    52 k
 cairo                                x86_64  1.16.0-8.fc32                    updates  712 k
 cairo-gobject                        x86_64  1.16.0-8.fc32                    updates   19 k
 capstone                             x86_64  4.0.2-2.fc32                     updates  888 k
 cdparanoia-libs                      x86_64  10.2-31.fc32                     fedora    54 k
 colord-libs                          x86_64  1.4.4-4.fc32                     fedora   235 k
 cups-libs                            x86_64  1:2.3.3op2-5.fc32                updates  276 k
 cyrus-sasl                           x86_64  2.1.27-4.fc32                    fedora    72 k
 cyrus-sasl-gssapi                    x86_64  2.1.27-4.fc32                    fedora    25 k
 dbus-libs                            x86_64  1:1.12.20-1.fc32                 updates  163 k
 dejavu-sans-fonts                    noarch  2.37-8.fc32                      updates  1.3 M
 device-mapper-multipath-libs         x86_64  0.8.2-4.fc32                     updates  262 k
 diffutils                            x86_64  3.7-4.fc32                       fedora   397 k
 dmidecode                            x86_64  1:3.2-5.fc32                     fedora    88 k
 e2fsprogs-libs                       x86_64  1.45.5-3.fc32                    fedora   218 k
 edk2-ovmf                            noarch  20200801stable-1.fc32            updates  3.4 M
 flac-libs                            x86_64  1.3.3-2.fc32                     fedora   224 k
 fontconfig                           x86_64  2.13.92-9.fc32                   updates  265 k
 fonts-filesystem                     noarch  2.0.3-1.fc32                     fedora   7.8 k
 freetype                             x86_64  2.10.4-1.fc32                    updates  392 k
 fribidi                              x86_64  1.0.9-1.fc32                     fedora    85 k
 gdk-pixbuf2                          x86_64  2.40.0-2.fc32                    fedora   464 k
 gdk-pixbuf2-modules                  x86_64  2.40.0-2.fc32                    fedora    99 k
 gettext                              x86_64  0.21-1.fc32                      updates  1.1 M
 gettext-libs                         x86_64  0.21-1.fc32                      updates  304 k
 glib-networking                      x86_64  2.64.3-1.fc32                    updates  160 k
 glusterfs                            x86_64  7.9-1.fc32                       updates  659 k
 glusterfs-api                        x86_64  7.9-1.fc32                       updates   95 k
 glusterfs-client-xlators             x86_64  7.9-1.fc32                       updates  840 k
 glusterfs-libs                       x86_64  7.9-1.fc32                       updates  432 k
 gnutls-dane                          x86_64  3.6.15-1.fc32                    updates   31 k
 gnutls-utils                         x86_64  3.6.15-1.fc32                    updates  347 k
 graphene                             x86_64  1.10.4-1.fc32                    updates   64 k
 graphite2                            x86_64  1.3.14-1.fc32                    updates  103 k
 gsettings-desktop-schemas            x86_64  3.36.1-1.fc32                    updates  670 k
 gsm                                  x86_64  1.0.18-6.fc32                    fedora    33 k
 gssproxy                             x86_64  0.8.2-8.fc32                     fedora   114 k
 gstreamer1                           x86_64  1.16.2-2.fc32                    fedora   1.3 M
 gstreamer1-plugins-base              x86_64  1.16.2-3.fc32                    updates  2.0 M
 gtk-update-icon-cache                x86_64  3.24.28-2.fc32                   updates   33 k
 gtk3                                 x86_64  3.24.28-2.fc32                   updates  4.8 M
 harfbuzz                             x86_64  2.6.4-3.fc32                     fedora   599 k
 hicolor-icon-theme                   noarch  0.17-8.fc32                      fedora    44 k
 hwdata                               noarch  0.347-1.fc32                     updates  1.5 M
 iproute                              x86_64  5.9.0-1.fc32                     updates  676 k
 iproute-tc                           x86_64  5.9.0-1.fc32                     updates  432 k
 ipxe-roms-qemu                       noarch  20190125-4.git36a4c85f.fc32      fedora   1.7 M
 iso-codes                            noarch  4.4-2.fc32                       fedora   3.3 M
 jansson                              x86_64  2.12-5.fc32                      fedora    44 k
 jasper-libs                          x86_64  2.0.26-2.fc32                    updates  152 k
 jbigkit-libs                         x86_64  2.1-18.fc32                      fedora    53 k
 json-glib                            x86_64  1.4.4-4.fc32                     fedora   144 k
 kde-filesystem                       x86_64  4-63.fc32                        fedora    43 k
 keyutils                             x86_64  1.6-4.fc32                       fedora    63 k
 kf5-filesystem                       x86_64  5.75.0-1.fc32                    updates   11 k
 kmod                                 x86_64  27-1.fc32                        fedora   124 k
 langpacks-core-font-en               noarch  3.0-3.fc32                       fedora   9.4 k
 lcms2                                x86_64  2.9-7.fc32                       fedora   167 k
 libICE                               x86_64  1.0.10-3.fc32                    fedora    71 k
 libSM                                x86_64  1.2.3-5.fc32                     fedora    42 k
 libX11                               x86_64  1.6.12-1.fc32                    updates  659 k
 libX11-common                        noarch  1.6.12-1.fc32                    updates  153 k
 libX11-xcb                           x86_64  1.6.12-1.fc32                    updates   11 k
 libXau                               x86_64  1.0.9-3.fc32                     fedora    31 k
 libXcomposite                        x86_64  0.4.5-2.fc32                     fedora    23 k
 libXcursor                           x86_64  1.2.0-2.fc32                     fedora    30 k
 libXdamage                           x86_64  1.1.5-2.fc32                     fedora    22 k
 libXext                              x86_64  1.3.4-3.fc32                     fedora    39 k
 libXfixes                            x86_64  5.0.3-11.fc32                    fedora    19 k
 libXft                               x86_64  2.3.3-3.fc32                     fedora    64 k
 libXi                                x86_64  1.7.10-3.fc32                    fedora    38 k
 libXinerama                          x86_64  1.1.4-5.fc32                     fedora    14 k
 libXrandr                            x86_64  1.5.2-3.fc32                     fedora    27 k
 libXrender                           x86_64  0.9.10-11.fc32                   fedora    27 k
 libXtst                              x86_64  1.2.3-11.fc32                    fedora    20 k
 libXv                                x86_64  1.0.11-11.fc32                   fedora    18 k
 libXxf86vm                           x86_64  1.1.4-13.fc32                    fedora    18 k
 libaio                               x86_64  0.3.111-7.fc32                   fedora    24 k
 libasyncns                           x86_64  0.8-18.fc32                      fedora    30 k
 libbasicobjects                      x86_64  0.1.1-44.fc32                    fedora    26 k
 libburn                              x86_64  1.5.4-2.fc32                     updates  177 k
 libcacard                            x86_64  3:2.7.0-4.fc32                   fedora    53 k
 libcollection                        x86_64  0.7.0-44.fc32                    fedora    44 k
 libdatrie                            x86_64  0.2.9-11.fc32                    fedora    32 k
 libdrm                               x86_64  2.4.102-1.fc32                   updates  159 k
 libepoxy                             x86_64  1.5.4-2.fc32                     fedora   249 k
 libev                                x86_64  4.31-2.fc32                      fedora    55 k
 libevent                             x86_64  2.1.8-8.fc32                     fedora   254 k
 libfdt                               x86_64  1.6.0-1.fc32                     fedora    33 k
 libglvnd                             x86_64  1:1.3.2-1.fc32                   updates  143 k
 libglvnd-egl                         x86_64  1:1.3.2-1.fc32                   updates   44 k
 libglvnd-gles                        x86_64  1:1.3.2-1.fc32                   updates   36 k
 libglvnd-glx                         x86_64  1:1.3.2-1.fc32                   updates  157 k
 libgusb                              x86_64  0.3.5-1.fc32                     updates   50 k
 libibumad                            x86_64  33.0-2.fc32                      updates   26 k
 libibverbs                           x86_64  33.0-2.fc32                      updates  338 k
 libicu                               x86_64  65.1-2.fc32                      fedora   9.6 M
 libini_config                        x86_64  1.3.1-44.fc32                    fedora    67 k
 libiscsi                             x86_64  1.18.0-9.fc32                    fedora    90 k
 libisoburn                           x86_64  1.5.4-2.fc32                     updates  428 k
 libisofs                             x86_64  1.5.4-1.fc32                     updates  226 k
 libjpeg-turbo                        x86_64  2.0.4-3.fc32                     updates  168 k
 libmodman                            x86_64  2.0.1-21.fc32                    fedora    34 k
 libnfs                               x86_64  4.0.0-2.fc32                     fedora   142 k
 libnfsidmap                          x86_64  1:2.5.3-1.fc32                   updates   73 k
 libnftnl                             x86_64  1.1.5-2.fc32                     fedora    83 k
 libnl3                               x86_64  3.5.0-2.fc32                     fedora   330 k
 libogg                               x86_64  2:1.3.4-2.fc32                   fedora    33 k
 libpath_utils                        x86_64  0.2.1-44.fc32                    fedora    29 k
 libpciaccess                         x86_64  0.16-2.fc32                      fedora    27 k
 libpmem                              x86_64  1.8-2.fc32                       fedora    94 k
 libpng                               x86_64  2:1.6.37-3.fc32                  fedora   116 k
 libproxy                             x86_64  0.4.15-19.fc32                   updates   72 k
 librados2                            x86_64  2:14.2.21-1.fc32                 updates  3.4 M
 librbd1                              x86_64  2:14.2.21-1.fc32                 updates  1.7 M
 librdmacm                            x86_64  33.0-2.fc32                      updates   72 k
 libref_array                         x86_64  0.1.5-44.fc32                    fedora    27 k
 libselinux-utils                     x86_64  3.0-5.fc32                       updates  159 k
 libslirp                             x86_64  4.3.1-3.fc32                     updates   70 k
 libsndfile                           x86_64  1.0.31-3.fc32                    updates  213 k
 libsoup                              x86_64  2.70.0-1.fc32                    fedora   388 k
 libssh2                              x86_64  1.9.0-5.fc32                     fedora   119 k
 libtextstyle                         x86_64  0.21-1.fc32                      updates  124 k
 libthai                              x86_64  0.1.28-4.fc32                    fedora   213 k
 libtheora                            x86_64  1:1.1.1-25.fc32                  fedora   175 k
 libtiff                              x86_64  4.1.0-3.fc32                     updates  189 k
 libverto-libev                       x86_64  0.3.0-9.fc32                     fedora    13 k
 libvirt-bash-completion              x86_64  6.1.0-4.fc32                     updates   11 k
 libvirt-daemon                       x86_64  6.1.0-4.fc32                     updates  318 k
 libvirt-libs                         x86_64  6.1.0-4.fc32                     updates  4.2 M
 libvisual                            x86_64  1:0.4.0-28.fc32                  fedora   148 k
 libvorbis                            x86_64  1:1.3.6-6.fc32                   fedora   199 k
 libwayland-client                    x86_64  1.18.0-1.fc32                    fedora    35 k
 libwayland-cursor                    x86_64  1.18.0-1.fc32                    fedora    20 k
 libwayland-egl                       x86_64  1.18.0-1.fc32                    fedora    13 k
 libwayland-server                    x86_64  1.18.0-1.fc32                    fedora    43 k
 libwebp                              x86_64  1.2.0-1.fc32                     updates  277 k
 libwsman1                            x86_64  2.6.8-12.fc32                    fedora   139 k
 libxcb                               x86_64  1.13.1-4.fc32                    fedora   231 k
 libxkbcommon                         x86_64  0.10.0-2.fc32                    fedora   121 k
 libxshmfence                         x86_64  1.3-6.fc32                       fedora    12 k
 linux-atm-libs                       x86_64  2.5.1-26.fc32                    fedora    38 k
 lttng-ust                            x86_64  2.11.0-4.fc32                    fedora   277 k
 lzo                                  x86_64  2.10-2.fc32                      fedora    67 k
 lzop                                 x86_64  1.04-3.fc32                      fedora    60 k
 mesa-libEGL                          x86_64  20.2.3-1.fc32                    updates  123 k
 mesa-libGL                           x86_64  20.2.3-1.fc32                    updates  182 k
 mesa-libgbm                          x86_64  20.2.3-1.fc32                    updates   43 k
 mesa-libglapi                        x86_64  20.2.3-1.fc32                    updates   53 k
 mozjs60                              x86_64  60.9.0-5.fc32                    fedora   6.6 M
 nfs-utils                            x86_64  1:2.5.3-1.fc32                   updates  458 k
 nmap-ncat                            x86_64  2:7.80-4.fc32                    updates  236 k
 nspr                                 x86_64  4.30.0-1.fc32                    updates  138 k
 nss                                  x86_64  3.63.0-1.fc32                    updates  687 k
 nss-softokn                          x86_64  3.63.0-1.fc32                    updates  450 k
 nss-softokn-freebl                   x86_64  3.63.0-1.fc32                    updates  330 k
 nss-sysinit                          x86_64  3.63.0-1.fc32                    updates   19 k
 nss-util                             x86_64  3.63.0-1.fc32                    updates   90 k
 numactl-libs                         x86_64  2.0.12-4.fc32                    fedora    30 k
 numad                                x86_64  0.5-31.20150602git.fc32          fedora    40 k
 opus                                 x86_64  1.3.1-3.fc32                     fedora   216 k
 orc                                  x86_64  0.4.31-2.fc32                    fedora   185 k
 pango                                x86_64  1.44.7-2.fc32                    fedora   293 k
 parted                               x86_64  3.3-3.fc32                       fedora   591 k
 pciutils                             x86_64  3.7.0-3.fc32                     updates   93 k
 pciutils-libs                        x86_64  3.7.0-3.fc32                     updates   42 k
 pcre2-utf32                          x86_64  10.36-4.fc32                     updates  199 k
 pixman                               x86_64  0.40.0-1.fc32                    updates  270 k
 policycoreutils                      x86_64  3.0-2.fc32                       fedora   210 k
 polkit                               x86_64  0.116-7.fc32                     fedora   146 k
 polkit-libs                          x86_64  0.116-7.fc32                     fedora    68 k
 polkit-pkla-compat                   x86_64  0.1-16.fc32                      fedora    45 k
 psmisc                               x86_64  23.3-3.fc32                      fedora   159 k
 pulseaudio-libs                      x86_64  14.0-1.fc32                      updates  690 k
 qemu-audio-alsa                      x86_64  2:4.2.1-1.fc32                   updates   21 k
 qemu-audio-oss                       x86_64  2:4.2.1-1.fc32                   updates   20 k
 qemu-audio-pa                        x86_64  2:4.2.1-1.fc32                   updates   21 k
 qemu-audio-sdl                       x86_64  2:4.2.1-1.fc32                   updates   18 k
 qemu-block-curl                      x86_64  2:4.2.1-1.fc32                   updates   23 k
 qemu-block-dmg                       x86_64  2:4.2.1-1.fc32                   updates   16 k
 qemu-block-gluster                   x86_64  2:4.2.1-1.fc32                   updates   25 k
 qemu-block-iscsi                     x86_64  2:4.2.1-1.fc32                   updates   31 k
 qemu-block-nfs                       x86_64  2:4.2.1-1.fc32                   updates   23 k
 qemu-block-rbd                       x86_64  2:4.2.1-1.fc32                   updates   24 k
 qemu-block-ssh                       x86_64  2:4.2.1-1.fc32                   updates   26 k
 qemu-common                          x86_64  2:4.2.1-1.fc32                   updates  1.3 M
 qemu-img                             x86_64  2:4.2.1-1.fc32                   updates  1.1 M
 qemu-system-x86                      x86_64  2:4.2.1-1.fc32                   updates   12 k
 qemu-system-x86-core                 x86_64  2:4.2.1-1.fc32                   updates  6.4 M
 qemu-ui-curses                       x86_64  2:4.2.1-1.fc32                   updates   25 k
 qemu-ui-gtk                          x86_64  2:4.2.1-1.fc32                   updates   37 k
 qemu-ui-sdl                          x86_64  2:4.2.1-1.fc32                   updates   28 k
 qemu-ui-spice-app                    x86_64  2:4.2.1-1.fc32                   updates   18 k
 quota                                x86_64  1:4.05-10.fc32                   updates  189 k
 quota-nls                            noarch  1:4.05-10.fc32                   updates   77 k
 rdma-core                            x86_64  33.0-2.fc32                      updates   56 k
 rest                                 x86_64  0.8.1-7.fc32                     fedora    69 k
 rpcbind                              x86_64  1.2.5-5.rc1.fc32.1               fedora    60 k
 rpm-plugin-selinux                   x86_64  4.15.1.1-1.fc32.1                updates   17 k
 sgabios-bin                          noarch  1:0.20180715git-4.fc32           fedora    10 k
 shared-mime-info                     x86_64  1.15-3.fc32                      fedora   303 k
 snappy                               x86_64  1.1.8-2.fc32                     fedora    33 k
 spice-server                         x86_64  0.14.3-1.fc32                    fedora   416 k
 systemd-container                    x86_64  245.9-1.fc32                     updates  478 k
 unbound-libs                         x86_64  1.10.1-1.fc32                    updates  528 k
 usbredir                             x86_64  0.9.0-1.fc32                     updates   48 k
 userspace-rcu                        x86_64  0.11.1-3.fc32                    fedora   104 k
 virglrenderer                        x86_64  0.8.2-1.20200212git7d204f39.fc32 fedora   191 k
 vte-profile                          x86_64  0.60.4-1.fc32                    updates   14 k
 vte291                               x86_64  0.60.4-1.fc32                    updates  309 k
 xen-libs                             x86_64  4.13.3-1.fc32                    updates  617 k
 xen-licenses                         x86_64  4.13.3-1.fc32                    updates   47 k
 xkeyboard-config                     noarch  2.29-1.fc32                      fedora   772 k
 xml-common                           noarch  0.6.3-54.fc32                    fedora    31 k
 xz                                   x86_64  5.2.5-1.fc32                     fedora   187 k
 yajl                                 x86_64  2.1.0-14.fc32                    fedora    38 k
Installing weak dependencies:
 abattis-cantarell-fonts              noarch  0.201-2.fc32                     fedora   336 k
 adobe-source-code-pro-fonts          noarch  2.030.1.050-8.fc32               fedora   834 k
 compat-f32-dejavu-sans-fonts         noarch  2.37-8.fc32                      updates  8.5 k
 dconf                                x86_64  0.36.0-1.fc32                    fedora   110 k

Transaction Summary
=============================================================================================
Install  247 Packages
Upgrade   11 Packages

Total download size: 119 M
Downloading Packages:
(1/258): alsa-lib-1.2.3.2-1.fc32.x86_64.rpm     448 kB/s | 474 kB     00:01    
(2/258): adwaita-cursor-theme-3.36.1-1.fc32.noa 495 kB/s | 623 kB     00:01    
(3/258): at-spi2-core-2.36.1-1.fc32.x86_64.rpm  289 kB/s | 174 kB     00:00    
(4/258): avahi-libs-0.7-24.fc32.x86_64.rpm      153 kB/s |  63 kB     00:00    
(5/258): adwaita-icon-theme-3.36.1-1.fc32.noarc 5.8 MB/s |  11 MB     00:01    
(6/258): bluez-libs-5.55-1.fc32.x86_64.rpm      259 kB/s |  89 kB     00:00    
(7/258): brlapi-0.7.0-14.fc32.x86_64.rpm        378 kB/s | 161 kB     00:00    
(8/258): brltty-6.0-14.fc32.x86_64.rpm          4.8 MB/s | 1.4 MB     00:00    
(9/258): capstone-4.0.2-2.fc32.x86_64.rpm       4.3 MB/s | 888 kB     00:00    
(10/258): cairo-gobject-1.16.0-8.fc32.x86_64.rp  81 kB/s |  19 kB     00:00    
(11/258): cups-libs-2.3.3op2-5.fc32.x86_64.rpm  2.1 MB/s | 276 kB     00:00    
(12/258): compat-f32-dejavu-sans-fonts-2.37-8.f  43 kB/s | 8.5 kB     00:00    
(13/258): dbus-libs-1.12.20-1.fc32.x86_64.rpm   1.3 MB/s | 163 kB     00:00    
(14/258): device-mapper-multipath-libs-0.8.2-4. 2.0 MB/s | 262 kB     00:00    
(15/258): cairo-1.16.0-8.fc32.x86_64.rpm        567 kB/s | 712 kB     00:01    
(16/258): edk2-ovmf-20200801stable-1.fc32.noarc 5.6 MB/s | 3.4 MB     00:00    
(17/258): fontconfig-2.13.92-9.fc32.x86_64.rpm  1.8 MB/s | 265 kB     00:00    
(18/258): freetype-2.10.4-1.fc32.x86_64.rpm     2.5 MB/s | 392 kB     00:00    
(19/258): dejavu-sans-fonts-2.37-8.fc32.noarch. 1.1 MB/s | 1.3 MB     00:01    
(20/258): gettext-0.21-1.fc32.x86_64.rpm        4.5 MB/s | 1.1 MB     00:00    
(21/258): findutils-4.7.0-4.fc32.x86_64.rpm     805 kB/s | 552 kB     00:00    
(22/258): glib-networking-2.64.3-1.fc32.x86_64. 1.3 MB/s | 160 kB     00:00    
(23/258): gettext-libs-0.21-1.fc32.x86_64.rpm   973 kB/s | 304 kB     00:00    
(24/258): glusterfs-api-7.9-1.fc32.x86_64.rpm   888 kB/s |  95 kB     00:00    
(25/258): glusterfs-libs-7.9-1.fc32.x86_64.rpm  2.6 MB/s | 432 kB     00:00    
(26/258): gnutls-dane-3.6.15-1.fc32.x86_64.rpm  286 kB/s |  31 kB     00:00    
(27/258): gnutls-utils-3.6.15-1.fc32.x86_64.rpm 1.9 MB/s | 347 kB     00:00    
(28/258): glusterfs-7.9-1.fc32.x86_64.rpm       1.1 MB/s | 659 kB     00:00    
(29/258): glusterfs-client-xlators-7.9-1.fc32.x 1.7 MB/s | 840 kB     00:00    
(30/258): graphene-1.10.4-1.fc32.x86_64.rpm     422 kB/s |  64 kB     00:00    
(31/258): graphite2-1.3.14-1.fc32.x86_64.rpm    565 kB/s | 103 kB     00:00    
(32/258): gtk-update-icon-cache-3.24.28-2.fc32. 136 kB/s |  33 kB     00:00    
(33/258): gstreamer1-plugins-base-1.16.2-3.fc32 2.2 MB/s | 2.0 MB     00:00    
(34/258): gsettings-desktop-schemas-3.36.1-1.fc 397 kB/s | 670 kB     00:01    
(35/258): hwdata-0.347-1.fc32.noarch.rpm        722 kB/s | 1.5 MB     00:02    
(36/258): iproute-tc-5.9.0-1.fc32.x86_64.rpm     53 kB/s | 432 kB     00:08    
(37/258): iproute-5.9.0-1.fc32.x86_64.rpm        69 kB/s | 676 kB     00:09    
(38/258): iptables-1.8.4-9.fc32.x86_64.rpm       16 kB/s | 106 kB     00:06    
(39/258): jasper-libs-2.0.26-2.fc32.x86_64.rpm   22 kB/s | 152 kB     00:06    
(40/258): gtk3-3.24.28-2.fc32.x86_64.rpm        261 kB/s | 4.8 MB     00:18    
(41/258): kf5-filesystem-5.75.0-1.fc32.x86_64.r 2.2 kB/s |  11 kB     00:05    
(42/258): libX11-xcb-1.6.12-1.fc32.x86_64.rpm    13 kB/s |  11 kB     00:00    
(43/258): libX11-1.6.12-1.fc32.x86_64.rpm        97 kB/s | 659 kB     00:06    
(44/258): libburn-1.5.4-2.fc32.x86_64.rpm        71 kB/s | 177 kB     00:02    
(45/258): libX11-common-1.6.12-1.fc32.noarch.rp  15 kB/s | 153 kB     00:10    
(46/258): libdrm-2.4.102-1.fc32.x86_64.rpm       29 kB/s | 159 kB     00:05    
(47/258): libglvnd-egl-1.3.2-1.fc32.x86_64.rpm   49 kB/s |  44 kB     00:00    
(48/258): libglvnd-1.3.2-1.fc32.x86_64.rpm       32 kB/s | 143 kB     00:04    
(49/258): libglvnd-gles-1.3.2-1.fc32.x86_64.rpm 338 kB/s |  36 kB     00:00    
(50/258): libibumad-33.0-2.fc32.x86_64.rpm      253 kB/s |  26 kB     00:00    
(51/258): libgusb-0.3.5-1.fc32.x86_64.rpm       456 kB/s |  50 kB     00:00    
(52/258): libglvnd-glx-1.3.2-1.fc32.x86_64.rpm  818 kB/s | 157 kB     00:00    
(53/258): libisofs-1.5.4-1.fc32.x86_64.rpm      1.4 MB/s | 226 kB     00:00    
(54/258): libibverbs-33.0-2.fc32.x86_64.rpm     1.5 MB/s | 338 kB     00:00    
(55/258): libisoburn-1.5.4-2.fc32.x86_64.rpm    1.8 MB/s | 428 kB     00:00    
(56/258): libjpeg-turbo-2.0.4-3.fc32.x86_64.rpm 1.3 MB/s | 168 kB     00:00    
(57/258): libnfsidmap-2.5.3-1.fc32.x86_64.rpm   658 kB/s |  73 kB     00:00    
(58/258): libproxy-0.4.15-19.fc32.x86_64.rpm    681 kB/s |  72 kB     00:00    
(59/258): librdmacm-33.0-2.fc32.x86_64.rpm      601 kB/s |  72 kB     00:00    
(60/258): libselinux-utils-3.0-5.fc32.x86_64.rp 612 kB/s | 159 kB     00:00    
(61/258): librbd1-14.2.21-1.fc32.x86_64.rpm     2.9 MB/s | 1.7 MB     00:00    
(62/258): libsndfile-1.0.31-3.fc32.x86_64.rpm   1.6 MB/s | 213 kB     00:00    
(63/258): librados2-14.2.21-1.fc32.x86_64.rpm   4.2 MB/s | 3.4 MB     00:00    
(64/258): libtextstyle-0.21-1.fc32.x86_64.rpm   1.1 MB/s | 124 kB     00:00    
(65/258): libslirp-4.3.1-3.fc32.x86_64.rpm      137 kB/s |  70 kB     00:00    
(66/258): libtiff-4.1.0-3.fc32.x86_64.rpm       1.2 MB/s | 189 kB     00:00    
(67/258): libvirt-bash-completion-6.1.0-4.fc32. 119 kB/s |  11 kB     00:00    
(68/258): libvirt-daemon-6.1.0-4.fc32.x86_64.rp 1.2 MB/s | 318 kB     00:00    
(69/258): libvirt-daemon-driver-qemu-6.1.0-4.fc 3.1 MB/s | 820 kB     00:00    
(70/258): libvirt-client-6.1.0-4.fc32.x86_64.rp 1.1 MB/s | 331 kB     00:00    
(71/258): libvirt-daemon-driver-storage-core-6. 1.4 MB/s | 213 kB     00:00    
(72/258): mesa-libEGL-20.2.3-1.fc32.x86_64.rpm  846 kB/s | 123 kB     00:00    
(73/258): mesa-libGL-20.2.3-1.fc32.x86_64.rpm   845 kB/s | 182 kB     00:00    
(74/258): libwebp-1.2.0-1.fc32.x86_64.rpm       522 kB/s | 277 kB     00:00    
(75/258): libvirt-libs-6.1.0-4.fc32.x86_64.rpm  6.5 MB/s | 4.2 MB     00:00    
(76/258): mesa-libgbm-20.2.3-1.fc32.x86_64.rpm  325 kB/s |  43 kB     00:00    
(77/258): mesa-libglapi-20.2.3-1.fc32.x86_64.rp 312 kB/s |  53 kB     00:00    
(78/258): nfs-utils-2.5.3-1.fc32.x86_64.rpm     1.7 MB/s | 458 kB     00:00    
(79/258): nftables-0.9.3-4.fc32.x86_64.rpm      1.2 MB/s | 321 kB     00:00    
(80/258): nspr-4.30.0-1.fc32.x86_64.rpm         1.1 MB/s | 138 kB     00:00    
(81/258): nmap-ncat-7.80-4.fc32.x86_64.rpm      685 kB/s | 236 kB     00:00    
(82/258): nss-softokn-3.63.0-1.fc32.x86_64.rpm  2.6 MB/s | 450 kB     00:00    
(83/258): nss-sysinit-3.63.0-1.fc32.x86_64.rpm  157 kB/s |  19 kB     00:00    
(84/258): nss-softokn-freebl-3.63.0-1.fc32.x86_ 830 kB/s | 330 kB     00:00    
(85/258): nss-util-3.63.0-1.fc32.x86_64.rpm     588 kB/s |  90 kB     00:00    
(86/258): nss-3.63.0-1.fc32.x86_64.rpm          1.0 MB/s | 687 kB     00:00    
(87/258): pciutils-libs-3.7.0-3.fc32.x86_64.rpm 354 kB/s |  42 kB     00:00    
(88/258): pciutils-3.7.0-3.fc32.x86_64.rpm      491 kB/s |  93 kB     00:00    
(89/258): pixman-0.40.0-1.fc32.x86_64.rpm       1.8 MB/s | 270 kB     00:00    
(90/258): pcre2-utf32-10.36-4.fc32.x86_64.rpm   853 kB/s | 199 kB     00:00    
(91/258): qemu-audio-alsa-4.2.1-1.fc32.x86_64.r 166 kB/s |  21 kB     00:00    
(92/258): pulseaudio-libs-14.0-1.fc32.x86_64.rp 2.2 MB/s | 690 kB     00:00    
(93/258): procps-ng-3.3.16-2.fc32.x86_64.rpm    808 kB/s | 336 kB     00:00    
(94/258): qemu-audio-oss-4.2.1-1.fc32.x86_64.rp 151 kB/s |  20 kB     00:00    
(95/258): qemu-audio-pa-4.2.1-1.fc32.x86_64.rpm 210 kB/s |  21 kB     00:00    
(96/258): qemu-audio-sdl-4.2.1-1.fc32.x86_64.rp 173 kB/s |  18 kB     00:00    
(97/258): qemu-block-curl-4.2.1-1.fc32.x86_64.r 201 kB/s |  23 kB     00:00    
(98/258): qemu-block-dmg-4.2.1-1.fc32.x86_64.rp 161 kB/s |  16 kB     00:00    
(99/258): qemu-block-gluster-4.2.1-1.fc32.x86_6 233 kB/s |  25 kB     00:00    
(100/258): qemu-block-iscsi-4.2.1-1.fc32.x86_64 279 kB/s |  31 kB     00:00    
(101/258): qemu-block-nfs-4.2.1-1.fc32.x86_64.r 200 kB/s |  23 kB     00:00    
(102/258): qemu-block-rbd-4.2.1-1.fc32.x86_64.r 196 kB/s |  24 kB     00:00    
(103/258): qemu-block-ssh-4.2.1-1.fc32.x86_64.r 214 kB/s |  26 kB     00:00    
(104/258): qemu-kvm-4.2.1-1.fc32.x86_64.rpm      80 kB/s |  11 kB     00:00    
(105/258): qemu-common-4.2.1-1.fc32.x86_64.rpm  4.6 MB/s | 1.3 MB     00:00    
(106/258): qemu-system-x86-4.2.1-1.fc32.x86_64. 113 kB/s |  12 kB     00:00    
(107/258): qemu-ui-curses-4.2.1-1.fc32.x86_64.r  61 kB/s |  25 kB     00:00    
(108/258): qemu-img-4.2.1-1.fc32.x86_64.rpm     909 kB/s | 1.1 MB     00:01    
(109/258): qemu-system-x86-core-4.2.1-1.fc32.x8 6.7 MB/s | 6.4 MB     00:00    
(110/258): qemu-ui-gtk-4.2.1-1.fc32.x86_64.rpm   64 kB/s |  37 kB     00:00    
(111/258): qemu-ui-sdl-4.2.1-1.fc32.x86_64.rpm  250 kB/s |  28 kB     00:00    
(112/258): qemu-ui-spice-app-4.2.1-1.fc32.x86_6 185 kB/s |  18 kB     00:00    
(113/258): rdma-core-33.0-2.fc32.x86_64.rpm     515 kB/s |  56 kB     00:00    
(114/258): quota-nls-4.05-10.fc32.noarch.rpm    539 kB/s |  77 kB     00:00    
(115/258): rpm-plugin-selinux-4.15.1.1-1.fc32.1 168 kB/s |  17 kB     00:00    
(116/258): selinux-policy-3.14.5-46.fc32.noarch 509 kB/s |  74 kB     00:00    
(117/258): systemd-container-245.9-1.fc32.x86_6 829 kB/s | 478 kB     00:00    
(118/258): selinux-policy-targeted-3.14.5-46.fc 7.2 MB/s | 8.0 MB     00:01    
(119/258): unbound-libs-1.10.1-1.fc32.x86_64.rp 1.0 MB/s | 528 kB     00:00    
(120/258): usbredir-0.9.0-1.fc32.x86_64.rpm     430 kB/s |  48 kB     00:00    
(121/258): vte-profile-0.60.4-1.fc32.x86_64.rpm 141 kB/s |  14 kB     00:00    
(122/258): vte291-0.60.4-1.fc32.x86_64.rpm      1.8 MB/s | 309 kB     00:00    
(123/258): xen-licenses-4.13.3-1.fc32.x86_64.rp 455 kB/s |  47 kB     00:00    
(124/258): xen-libs-4.13.3-1.fc32.x86_64.rpm    1.5 MB/s | 617 kB     00:00    
(125/258): xorriso-1.5.4-2.fc32.x86_64.rpm      1.8 MB/s | 315 kB     00:00    
(126/258): quota-4.05-10.fc32.x86_64.rpm         95 kB/s | 189 kB     00:01    
(127/258): abattis-cantarell-fonts-0.201-2.fc32 2.3 MB/s | 336 kB     00:00    
(128/258): at-spi2-atk-2.34.2-1.fc32.x86_64.rpm 741 kB/s |  90 kB     00:00    
(129/258): SDL2-2.0.12-1.fc32.x86_64.rpm        1.6 MB/s | 518 kB     00:00    
(130/258): atk-2.36.0-1.fc32.x86_64.rpm         1.9 MB/s | 273 kB     00:00    
(131/258): augeas-1.12.0-3.fc32.x86_64.rpm      435 kB/s |  50 kB     00:00    
(132/258): autogen-libopts-5.18.16-4.fc32.x86_6 564 kB/s |  76 kB     00:00    
(133/258): augeas-libs-1.12.0-3.fc32.x86_64.rpm 2.6 MB/s | 419 kB     00:00    
(134/258): bzip2-1.0.8-2.fc32.x86_64.rpm        437 kB/s |  52 kB     00:00    
(135/258): cdparanoia-libs-10.2-31.fc32.x86_64. 501 kB/s |  54 kB     00:00    
(136/258): cyrus-sasl-2.1.27-4.fc32.x86_64.rpm  596 kB/s |  72 kB     00:00    
(137/258): colord-libs-1.4.4-4.fc32.x86_64.rpm  1.2 MB/s | 235 kB     00:00    
(138/258): cyrus-sasl-gssapi-2.1.27-4.fc32.x86_ 248 kB/s |  25 kB     00:00    
(139/258): dconf-0.36.0-1.fc32.x86_64.rpm       751 kB/s | 110 kB     00:00    
(140/258): diffutils-3.7-4.fc32.x86_64.rpm      2.6 MB/s | 397 kB     00:00    
(141/258): dmidecode-3.2-5.fc32.x86_64.rpm      650 kB/s |  88 kB     00:00    
(142/258): e2fsprogs-libs-1.45.5-3.fc32.x86_64. 1.6 MB/s | 218 kB     00:00    
(143/258): fonts-filesystem-2.0.3-1.fc32.noarch  71 kB/s | 7.8 kB     00:00    
(144/258): flac-libs-1.3.3-2.fc32.x86_64.rpm    1.2 MB/s | 224 kB     00:00    
(145/258): fribidi-1.0.9-1.fc32.x86_64.rpm      795 kB/s |  85 kB     00:00    
(146/258): gdk-pixbuf2-modules-2.40.0-2.fc32.x8 817 kB/s |  99 kB     00:00    
(147/258): gdk-pixbuf2-2.40.0-2.fc32.x86_64.rpm 1.7 MB/s | 464 kB     00:00    
(148/258): gsm-1.0.18-6.fc32.x86_64.rpm         331 kB/s |  33 kB     00:00    
(149/258): gssproxy-0.8.2-8.fc32.x86_64.rpm     732 kB/s | 114 kB     00:00    
(150/258): gstreamer1-1.16.2-2.fc32.x86_64.rpm  5.0 MB/s | 1.3 MB     00:00    
(151/258): hicolor-icon-theme-0.17-8.fc32.noarc 406 kB/s |  44 kB     00:00    
(152/258): harfbuzz-2.6.4-3.fc32.x86_64.rpm     2.2 MB/s | 599 kB     00:00    
(153/258): ipxe-roms-qemu-20190125-4.git36a4c85 4.1 MB/s | 1.7 MB     00:00    
(154/258): jansson-2.12-5.fc32.x86_64.rpm       390 kB/s |  44 kB     00:00    
(155/258): jbigkit-libs-2.1-18.fc32.x86_64.rpm  482 kB/s |  53 kB     00:00    
(156/258): json-glib-1.4.4-4.fc32.x86_64.rpm    1.1 MB/s | 144 kB     00:00    
(157/258): kde-filesystem-4-63.fc32.x86_64.rpm  366 kB/s |  43 kB     00:00    
(158/258): adobe-source-code-pro-fonts-2.030.1. 288 kB/s | 834 kB     00:02    
(159/258): keyutils-1.6-4.fc32.x86_64.rpm       544 kB/s |  63 kB     00:00    
(160/258): iso-codes-4.4-2.fc32.noarch.rpm      3.3 MB/s | 3.3 MB     00:00    
(161/258): langpacks-core-font-en-3.0-3.fc32.no  93 kB/s | 9.4 kB     00:00    
(162/258): lcms2-2.9-7.fc32.x86_64.rpm          1.0 MB/s | 167 kB     00:00    
(163/258): libICE-1.0.10-3.fc32.x86_64.rpm      609 kB/s |  71 kB     00:00    
(164/258): libSM-1.2.3-5.fc32.x86_64.rpm        397 kB/s |  42 kB     00:00    
(165/258): libXau-1.0.9-3.fc32.x86_64.rpm       292 kB/s |  31 kB     00:00    
(166/258): libXcomposite-0.4.5-2.fc32.x86_64.rp 179 kB/s |  23 kB     00:00    
(167/258): kmod-27-1.fc32.x86_64.rpm            247 kB/s | 124 kB     00:00    
(168/258): libXcursor-1.2.0-2.fc32.x86_64.rpm   264 kB/s |  30 kB     00:00    
(169/258): libXdamage-1.1.5-2.fc32.x86_64.rpm   214 kB/s |  22 kB     00:00    
(170/258): libXext-1.3.4-3.fc32.x86_64.rpm      354 kB/s |  39 kB     00:00    
(171/258): libXfixes-5.0.3-11.fc32.x86_64.rpm   173 kB/s |  19 kB     00:00    
(172/258): libXft-2.3.3-3.fc32.x86_64.rpm       545 kB/s |  64 kB     00:00    
(173/258): libXinerama-1.1.4-5.fc32.x86_64.rpm  132 kB/s |  14 kB     00:00    
(174/258): libXi-1.7.10-3.fc32.x86_64.rpm       340 kB/s |  38 kB     00:00    
(175/258): libXrandr-1.5.2-3.fc32.x86_64.rpm    266 kB/s |  27 kB     00:00    
(176/258): libXrender-0.9.10-11.fc32.x86_64.rpm 256 kB/s |  27 kB     00:00    
(177/258): libXtst-1.2.3-11.fc32.x86_64.rpm     195 kB/s |  20 kB     00:00    
(178/258): libXv-1.0.11-11.fc32.x86_64.rpm      167 kB/s |  18 kB     00:00    
(179/258): libXxf86vm-1.1.4-13.fc32.x86_64.rpm  178 kB/s |  18 kB     00:00    
(180/258): libaio-0.3.111-7.fc32.x86_64.rpm     236 kB/s |  24 kB     00:00    
(181/258): libasyncns-0.8-18.fc32.x86_64.rpm    286 kB/s |  30 kB     00:00    
(182/258): libbasicobjects-0.1.1-44.fc32.x86_64 241 kB/s |  26 kB     00:00    
(183/258): libcacard-2.7.0-4.fc32.x86_64.rpm    492 kB/s |  53 kB     00:00    
(184/258): libcollection-0.7.0-44.fc32.x86_64.r 437 kB/s |  44 kB     00:00    
(185/258): libdatrie-0.2.9-11.fc32.x86_64.rpm   269 kB/s |  32 kB     00:00    
(186/258): libepoxy-1.5.4-2.fc32.x86_64.rpm     1.8 MB/s | 249 kB     00:00    
(187/258): libev-4.31-2.fc32.x86_64.rpm         552 kB/s |  55 kB     00:00    
(188/258): libfdt-1.6.0-1.fc32.x86_64.rpm       322 kB/s |  33 kB     00:00    
(189/258): libevent-2.1.8-8.fc32.x86_64.rpm     1.3 MB/s | 254 kB     00:00    
(190/258): libini_config-1.3.1-44.fc32.x86_64.r 593 kB/s |  67 kB     00:00    
(191/258): libiscsi-1.18.0-9.fc32.x86_64.rpm    737 kB/s |  90 kB     00:00    
(192/258): libmodman-2.0.1-21.fc32.x86_64.rpm   313 kB/s |  34 kB     00:00    
(193/258): libnfs-4.0.0-2.fc32.x86_64.rpm       1.0 MB/s | 142 kB     00:00    
(194/258): libnftnl-1.1.5-2.fc32.x86_64.rpm     659 kB/s |  83 kB     00:00    
(195/258): libogg-1.3.4-2.fc32.x86_64.rpm       235 kB/s |  33 kB     00:00    
(196/258): libnl3-3.5.0-2.fc32.x86_64.rpm       1.5 MB/s | 330 kB     00:00    
(197/258): libpath_utils-0.2.1-44.fc32.x86_64.r 227 kB/s |  29 kB     00:00    
(198/258): libpciaccess-0.16-2.fc32.x86_64.rpm  238 kB/s |  27 kB     00:00    
(199/258): libpmem-1.8-2.fc32.x86_64.rpm        772 kB/s |  94 kB     00:00    
(200/258): libpng-1.6.37-3.fc32.x86_64.rpm      788 kB/s | 116 kB     00:00    
(201/258): libref_array-0.1.5-44.fc32.x86_64.rp 210 kB/s |  27 kB     00:00    
(202/258): libsoup-2.70.0-1.fc32.x86_64.rpm     1.1 MB/s | 388 kB     00:00    
(203/258): libssh2-1.9.0-5.fc32.x86_64.rpm      348 kB/s | 119 kB     00:00    
(204/258): libthai-0.1.28-4.fc32.x86_64.rpm     1.4 MB/s | 213 kB     00:00    
(205/258): libverto-libev-0.3.0-9.fc32.x86_64.r  97 kB/s |  13 kB     00:00    
(206/258): libicu-65.1-2.fc32.x86_64.rpm        6.4 MB/s | 9.6 MB     00:01    
(207/258): libvisual-0.4.0-28.fc32.x86_64.rpm   1.1 MB/s | 148 kB     00:00    
(208/258): libvorbis-1.3.6-6.fc32.x86_64.rpm    1.2 MB/s | 199 kB     00:00    
(209/258): libtheora-1.1.1-25.fc32.x86_64.rpm   402 kB/s | 175 kB     00:00    
(210/258): libwayland-client-1.18.0-1.fc32.x86_ 354 kB/s |  35 kB     00:00    
(211/258): libwayland-cursor-1.18.0-1.fc32.x86_ 208 kB/s |  20 kB     00:00    
(212/258): libwayland-egl-1.18.0-1.fc32.x86_64. 107 kB/s |  13 kB     00:00    
(213/258): libwayland-server-1.18.0-1.fc32.x86_ 362 kB/s |  43 kB     00:00    
(214/258): libwsman1-2.6.8-12.fc32.x86_64.rpm   1.2 MB/s | 139 kB     00:00    
(215/258): libxkbcommon-0.10.0-2.fc32.x86_64.rp 1.0 MB/s | 121 kB     00:00    
(216/258): libxshmfence-1.3-6.fc32.x86_64.rpm   122 kB/s |  12 kB     00:00    
(217/258): linux-atm-libs-2.5.1-26.fc32.x86_64. 330 kB/s |  38 kB     00:00    
(218/258): lttng-ust-2.11.0-4.fc32.x86_64.rpm   1.9 MB/s | 277 kB     00:00    
(219/258): lzo-2.10-2.fc32.x86_64.rpm           585 kB/s |  67 kB     00:00    
(220/258): lzop-1.04-3.fc32.x86_64.rpm          579 kB/s |  60 kB     00:00    
(221/258): libxcb-1.13.1-4.fc32.x86_64.rpm      545 kB/s | 231 kB     00:00    
(222/258): numactl-libs-2.0.12-4.fc32.x86_64.rp 245 kB/s |  30 kB     00:00    
(223/258): numad-0.5-31.20150602git.fc32.x86_64 247 kB/s |  40 kB     00:00    
(224/258): opus-1.3.1-3.fc32.x86_64.rpm         1.3 MB/s | 216 kB     00:00    
(225/258): pango-1.44.7-2.fc32.x86_64.rpm       1.7 MB/s | 293 kB     00:00    
(226/258): orc-0.4.31-2.fc32.x86_64.rpm         570 kB/s | 185 kB     00:00    
(227/258): parted-3.3-3.fc32.x86_64.rpm         1.8 MB/s | 591 kB     00:00    
(228/258): policycoreutils-3.0-2.fc32.x86_64.rp 586 kB/s | 210 kB     00:00    
(229/258): polkit-0.116-7.fc32.x86_64.rpm       908 kB/s | 146 kB     00:00    
(230/258): polkit-libs-0.116-7.fc32.x86_64.rpm  324 kB/s |  68 kB     00:00    
(231/258): polkit-pkla-compat-0.1-16.fc32.x86_6 272 kB/s |  45 kB     00:00    
(232/258): mozjs60-60.9.0-5.fc32.x86_64.rpm     5.6 MB/s | 6.6 MB     00:01    
(233/258): rest-0.8.1-7.fc32.x86_64.rpm         486 kB/s |  69 kB     00:00    
(234/258): rpcbind-1.2.5-5.rc1.fc32.1.x86_64.rp 435 kB/s |  60 kB     00:00    
(235/258): psmisc-23.3-3.fc32.x86_64.rpm        530 kB/s | 159 kB     00:00    
(236/258): seabios-bin-1.13.0-2.fc32.noarch.rpm 997 kB/s | 160 kB     00:00    
(237/258): seavgabios-bin-1.13.0-2.fc32.noarch. 269 kB/s |  36 kB     00:00    
(238/258): sgabios-bin-0.20180715git-4.fc32.noa  95 kB/s |  10 kB     00:00    
(239/258): snappy-1.1.8-2.fc32.x86_64.rpm       294 kB/s |  33 kB     00:00    
(240/258): shared-mime-info-1.15-3.fc32.x86_64. 2.1 MB/s | 303 kB     00:00    
(241/258): userspace-rcu-0.11.1-3.fc32.x86_64.r 869 kB/s | 104 kB     00:00    
(242/258): virglrenderer-0.8.2-1.20200212git7d2 1.4 MB/s | 191 kB     00:00    
(243/258): xml-common-0.6.3-54.fc32.noarch.rpm  305 kB/s |  31 kB     00:00    
(244/258): xkeyboard-config-2.29-1.fc32.noarch. 3.1 MB/s | 772 kB     00:00    
(245/258): xz-5.2.5-1.fc32.x86_64.rpm           1.3 MB/s | 187 kB     00:00    
(246/258): spice-server-0.14.3-1.fc32.x86_64.rp 894 kB/s | 416 kB     00:00    
(247/258): yajl-2.1.0-14.fc32.x86_64.rpm        363 kB/s |  38 kB     00:00    
(248/258): pcre2-10.36-4.fc32.x86_64.rpm        1.8 MB/s | 233 kB     00:00    
(249/258): python3-rpm-4.15.1.1-1.fc32.1.x86_64 846 kB/s |  94 kB     00:00    
(250/258): pcre2-syntax-10.36-4.fc32.noarch.rpm 645 kB/s | 142 kB     00:00    
(251/258): rpm-4.15.1.1-1.fc32.1.x86_64.rpm     3.0 MB/s | 495 kB     00:00    
(252/258): rpm-build-libs-4.15.1.1-1.fc32.1.x86 873 kB/s |  93 kB     00:00    
(253/258): rpm-sign-libs-4.15.1.1-1.fc32.1.x86_ 206 kB/s |  22 kB     00:00    
(254/258): rpm-libs-4.15.1.1-1.fc32.1.x86_64.rp 693 kB/s | 298 kB     00:00    
(255/258): systemd-libs-245.9-1.fc32.x86_64.rpm 1.5 MB/s | 556 kB     00:00    
(256/258): systemd-rpm-macros-245.9-1.fc32.noar 170 kB/s |  22 kB     00:00    
(257/258): systemd-245.9-1.fc32.x86_64.rpm      5.7 MB/s | 4.2 MB     00:00    
(258/258): systemd-pam-245.9-1.fc32.x86_64.rpm  870 kB/s | 297 kB     00:00    
--------------------------------------------------------------------------------
Total                                           2.3 MB/s | 119 MB     00:52     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Running scriptlet: selinux-policy-targeted-3.14.5-46.fc32.noarch          1/1 
  Preparing        :                                                        1/1 
  Running scriptlet: systemd-libs-245.9-1.fc32.x86_64                       1/1 
  Upgrading        : systemd-libs-245.9-1.fc32.x86_64                     1/269 
  Running scriptlet: systemd-libs-245.9-1.fc32.x86_64                     1/269 
  Installing       : dbus-libs-1:1.12.20-1.fc32.x86_64                    2/269 
  Installing       : libnl3-3.5.0-2.fc32.x86_64                           3/269 
  Installing       : nspr-4.30.0-1.fc32.x86_64                            4/269 
  Installing       : numactl-libs-2.0.12-4.fc32.x86_64                    5/269 
  Installing       : libpng-2:1.6.37-3.fc32.x86_64                        6/269 
  Installing       : freetype-2.10.4-1.fc32.x86_64                        7/269 
  Installing       : yajl-2.1.0-14.fc32.x86_64                            8/269 
  Installing       : libogg-2:1.3.4-2.fc32.x86_64                         9/269 
  Installing       : libepoxy-1.5.4-2.fc32.x86_64                        10/269 
  Installing       : atk-2.36.0-1.fc32.x86_64                            11/269 
  Installing       : pixman-0.40.0-1.fc32.x86_64                         12/269 
  Installing       : libjpeg-turbo-2.0.4-3.fc32.x86_64                   13/269 
  Installing       : nss-util-3.63.0-1.fc32.x86_64                       14/269 
  Installing       : libwsman1-2.6.8-12.fc32.x86_64                      15/269 
  Installing       : libwayland-client-1.18.0-1.fc32.x86_64              16/269 
  Installing       : libssh2-1.9.0-5.fc32.x86_64                         17/269 
  Installing       : fonts-filesystem-2.0.3-1.fc32.noarch                18/269 
  Installing       : libX11-xcb-1.6.12-1.fc32.x86_64                     19/269 
  Installing       : glusterfs-libs-7.9-1.fc32.x86_64                    20/269 
  Installing       : dejavu-sans-fonts-2.37-8.fc32.noarch                21/269 
  Upgrading        : rpm-libs-4.15.1.1-1.fc32.1.x86_64                   22/269 
  Upgrading        : rpm-4.15.1.1-1.fc32.1.x86_64                        23/269 
  Installing       : opus-1.3.1-3.fc32.x86_64                            24/269 
  Installing       : libaio-0.3.111-7.fc32.x86_64                        25/269 
  Installing       : fribidi-1.0.9-1.fc32.x86_64                         26/269 
  Installing       : SDL2-2.0.12-1.fc32.x86_64                           27/269 
  Installing       : libglvnd-1:1.3.2-1.fc32.x86_64                      28/269 
  Installing       : alsa-lib-1.2.3.2-1.fc32.x86_64                      29/269 
  Installing       : qemu-img-2:4.2.1-1.fc32.x86_64                      30/269 
  Installing       : libwayland-cursor-1.18.0-1.fc32.x86_64              31/269 
  Installing       : libvorbis-1:1.3.6-6.fc32.x86_64                     32/269 
  Installing       : polkit-libs-0.116-7.fc32.x86_64                     33/269 
  Upgrading        : pcre2-syntax-10.36-4.fc32.noarch                    34/269 
  Upgrading        : pcre2-10.36-4.fc32.x86_64                           35/269 
  Installing       : userspace-rcu-0.11.1-3.fc32.x86_64                  36/269 
  Installing       : lttng-ust-2.11.0-4.fc32.x86_64                      37/269 
  Installing       : orc-0.4.31-2.fc32.x86_64                            38/269 
  Installing       : lzo-2.10-2.fc32.x86_64                              39/269 
  Installing       : libxshmfence-1.3-6.fc32.x86_64                      40/269 
  Installing       : libwayland-server-1.18.0-1.fc32.x86_64              41/269 
  Installing       : libwayland-egl-1.18.0-1.fc32.x86_64                 42/269 
  Installing       : libref_array-0.1.5-44.fc32.x86_64                   43/269 
  Installing       : libevent-2.1.8-8.fc32.x86_64                        44/269 
  Installing       : libICE-1.0.10-3.fc32.x86_64                         45/269 
  Installing       : kmod-27-1.fc32.x86_64                               46/269 
  Installing       : gstreamer1-1.16.2-2.fc32.x86_64                     47/269 
  Installing       : e2fsprogs-libs-1.45.5-3.fc32.x86_64                 48/269 
  Installing       : diffutils-3.7-4.fc32.x86_64                         49/269 
  Installing       : mesa-libglapi-20.2.3-1.fc32.x86_64                  50/269 
  Installing       : libtextstyle-0.21-1.fc32.x86_64                     51/269 
  Installing       : hwdata-0.347-1.fc32.noarch                          52/269 
  Installing       : bluez-libs-5.55-1.fc32.x86_64                       53/269 
  Installing       : libpciaccess-0.16-2.fc32.x86_64                     54/269 
  Installing       : libdrm-2.4.102-1.fc32.x86_64                        55/269 
  Installing       : mesa-libgbm-20.2.3-1.fc32.x86_64                    56/269 
  Installing       : gettext-libs-0.21-1.fc32.x86_64                     57/269 
  Installing       : gettext-0.21-1.fc32.x86_64                          58/269 
  Installing       : libSM-1.2.3-5.fc32.x86_64                           59/269 
  Running scriptlet: unbound-libs-1.10.1-1.fc32.x86_64                   60/269 
  Installing       : unbound-libs-1.10.1-1.fc32.x86_64                   60/269 
  Running scriptlet: unbound-libs-1.10.1-1.fc32.x86_64                   60/269 
Created symlink /etc/systemd/system/timers.target.wants/unbound-anchor.timer → /usr/lib/systemd/system/unbound-anchor.timer.

  Installing       : gnutls-dane-3.6.15-1.fc32.x86_64                    61/269 
  Installing       : lzop-1.04-3.fc32.x86_64                             62/269 
  Installing       : device-mapper-multipath-libs-0.8.2-4.fc32.x86_64    63/269 
  Installing       : libselinux-utils-3.0-5.fc32.x86_64                  64/269 
  Installing       : policycoreutils-3.0-2.fc32.x86_64                   65/269 
  Running scriptlet: policycoreutils-3.0-2.fc32.x86_64                   65/269 
Created symlink /etc/systemd/system/sysinit.target.wants/selinux-autorelabel-mark.service → /usr/lib/systemd/system/selinux-autorelabel-mark.service.

  Installing       : rpm-plugin-selinux-4.15.1.1-1.fc32.1.x86_64         66/269 
  Installing       : selinux-policy-3.14.5-46.fc32.noarch                67/269 
  Running scriptlet: selinux-policy-3.14.5-46.fc32.noarch                67/269 
  Running scriptlet: selinux-policy-targeted-3.14.5-46.fc32.noarch       68/269 
  Installing       : selinux-policy-targeted-3.14.5-46.fc32.noarch       68/269 
  Running scriptlet: selinux-policy-targeted-3.14.5-46.fc32.noarch       68/269 
  Installing       : pcre2-utf32-10.36-4.fc32.x86_64                     69/269 
  Installing       : kde-filesystem-4-63.fc32.x86_64                     70/269 
  Upgrading        : rpm-build-libs-4.15.1.1-1.fc32.1.x86_64             71/269 
  Upgrading        : rpm-sign-libs-4.15.1.1-1.fc32.1.x86_64              72/269 
  Installing       : langpacks-core-font-en-3.0-3.fc32.noarch            73/269 
  Installing       : fontconfig-2.13.92-9.fc32.x86_64                    74/269 
  Running scriptlet: fontconfig-2.13.92-9.fc32.x86_64                    74/269 
  Installing       : glusterfs-client-xlators-7.9-1.fc32.x86_64          75/269 
  Installing       : abattis-cantarell-fonts-0.201-2.fc32.noarch         76/269 
  Installing       : adobe-source-code-pro-fonts-2.030.1.050-8.fc32.n    77/269 
  Installing       : gsettings-desktop-schemas-3.36.1-1.fc32.x86_64      78/269 
  Installing       : nss-softokn-freebl-3.63.0-1.fc32.x86_64             79/269 
  Installing       : nss-softokn-3.63.0-1.fc32.x86_64                    80/269 
  Installing       : nss-3.63.0-1.fc32.x86_64                            81/269 
  Running scriptlet: nss-3.63.0-1.fc32.x86_64                            81/269 
  Installing       : nss-sysinit-3.63.0-1.fc32.x86_64                    82/269 
  Installing       : libcacard-3:2.7.0-4.fc32.x86_64                     83/269 
  Installing       : jasper-libs-2.0.26-2.fc32.x86_64                    84/269 
  Installing       : flac-libs-1.3.3-2.fc32.x86_64                       85/269 
  Installing       : libtheora-1:1.1.1-25.fc32.x86_64                    86/269 
  Installing       : avahi-libs-0.7-24.fc32.x86_64                       87/269 
  Installing       : cups-libs-1:2.3.3op2-5.fc32.x86_64                  88/269 
  Upgrading        : systemd-rpm-macros-245.9-1.fc32.noarch              89/269 
  Installing       : xz-5.2.5-1.fc32.x86_64                              90/269 
  Running scriptlet: xml-common-0.6.3-54.fc32.noarch                     91/269 
  Installing       : xml-common-0.6.3-54.fc32.noarch                     91/269 
  Installing       : iso-codes-4.4-2.fc32.noarch                         92/269 
  Installing       : xkeyboard-config-2.29-1.fc32.noarch                 93/269 
  Installing       : libxkbcommon-0.10.0-2.fc32.x86_64                   94/269 
  Upgrading        : systemd-pam-245.9-1.fc32.x86_64                     95/269 
  Running scriptlet: systemd-245.9-1.fc32.x86_64                         96/269 
  Upgrading        : systemd-245.9-1.fc32.x86_64                         96/269 
  Running scriptlet: systemd-245.9-1.fc32.x86_64                         96/269 
  Running scriptlet: glusterfs-7.9-1.fc32.x86_64                         97/269 
  Installing       : glusterfs-7.9-1.fc32.x86_64                         97/269 
  Running scriptlet: glusterfs-7.9-1.fc32.x86_64                         97/269 
  Installing       : glusterfs-api-7.9-1.fc32.x86_64                     98/269 
  Installing       : systemd-container-245.9-1.fc32.x86_64               99/269 
  Running scriptlet: cyrus-sasl-2.1.27-4.fc32.x86_64                    100/269 
  Installing       : cyrus-sasl-2.1.27-4.fc32.x86_64                    100/269 
  Running scriptlet: cyrus-sasl-2.1.27-4.fc32.x86_64                    100/269 
  Installing       : numad-0.5-31.20150602git.fc32.x86_64               101/269 
  Running scriptlet: numad-0.5-31.20150602git.fc32.x86_64               101/269 
  Running scriptlet: rpcbind-1.2.5-5.rc1.fc32.1.x86_64                  102/269 
  Installing       : rpcbind-1.2.5-5.rc1.fc32.1.x86_64                  102/269 
  Running scriptlet: rpcbind-1.2.5-5.rc1.fc32.1.x86_64                  102/269 
  Installing       : snappy-1.1.8-2.fc32.x86_64                         103/269 
  Installing       : shared-mime-info-1.15-3.fc32.x86_64                104/269 
  Running scriptlet: shared-mime-info-1.15-3.fc32.x86_64                104/269 
  Installing       : gdk-pixbuf2-2.40.0-2.fc32.x86_64                   105/269 
  Installing       : gtk-update-icon-cache-3.24.28-2.fc32.x86_64        106/269 
  Installing       : sgabios-bin-1:0.20180715git-4.fc32.noarch          107/269 
  Installing       : seavgabios-bin-1.13.0-2.fc32.noarch                108/269 
  Installing       : seabios-bin-1.13.0-2.fc32.noarch                   109/269 
  Installing       : psmisc-23.3-3.fc32.x86_64                          110/269 
  Installing       : parted-3.3-3.fc32.x86_64                           111/269 
  Installing       : mozjs60-60.9.0-5.fc32.x86_64                       112/269 
  Running scriptlet: polkit-0.116-7.fc32.x86_64                         113/269 
  Installing       : polkit-0.116-7.fc32.x86_64                         113/269 
  Running scriptlet: polkit-0.116-7.fc32.x86_64                         113/269 
  Installing       : polkit-pkla-compat-0.1-16.fc32.x86_64              114/269 
  Installing       : linux-atm-libs-2.5.1-26.fc32.x86_64                115/269 
  Installing       : iproute-tc-5.9.0-1.fc32.x86_64                     116/269 
  Installing       : iproute-5.9.0-1.fc32.x86_64                        117/269 
  Installing       : libvisual-1:0.4.0-28.fc32.x86_64                   118/269 
  Installing       : libpmem-1.8-2.fc32.x86_64                          119/269 
  Installing       : libpath_utils-0.2.1-44.fc32.x86_64                 120/269 
  Installing       : libnftnl-1.1.5-2.fc32.x86_64                       121/269 
  Installing       : libnfs-4.0.0-2.fc32.x86_64                         122/269 
  Installing       : libmodman-2.0.1-21.fc32.x86_64                     123/269 
  Installing       : libproxy-0.4.15-19.fc32.x86_64                     124/269 
  Installing       : glib-networking-2.64.3-1.fc32.x86_64               125/269 
  Installing       : libsoup-2.70.0-1.fc32.x86_64                       126/269 
  Installing       : rest-0.8.1-7.fc32.x86_64                           127/269 
  Installing       : libicu-65.1-2.fc32.x86_64                          128/269 
  Installing       : libfdt-1.6.0-1.fc32.x86_64                         129/269 
  Installing       : libev-4.31-2.fc32.x86_64                           130/269 
  Installing       : libverto-libev-0.3.0-9.fc32.x86_64                 131/269 
  Installing       : libdatrie-0.2.9-11.fc32.x86_64                     132/269 
  Installing       : libthai-0.1.28-4.fc32.x86_64                       133/269 
  Installing       : libcollection-0.7.0-44.fc32.x86_64                 134/269 
  Installing       : libbasicobjects-0.1.1-44.fc32.x86_64               135/269 
  Installing       : libini_config-1.3.1-44.fc32.x86_64                 136/269 
  Installing       : gssproxy-0.8.2-8.fc32.x86_64                       137/269 
  Running scriptlet: gssproxy-0.8.2-8.fc32.x86_64                       137/269 
  Installing       : libasyncns-0.8-18.fc32.x86_64                      138/269 
  Installing       : libXau-1.0.9-3.fc32.x86_64                         139/269 
  Installing       : libxcb-1.13.1-4.fc32.x86_64                        140/269 
  Installing       : libglvnd-egl-1:1.3.2-1.fc32.x86_64                 141/269 
  Installing       : mesa-libEGL-20.2.3-1.fc32.x86_64                   142/269 
  Installing       : libglvnd-gles-1:1.3.2-1.fc32.x86_64                143/269 
  Installing       : lcms2-2.9-7.fc32.x86_64                            144/269 
  Installing       : keyutils-1.6-4.fc32.x86_64                         145/269 
  Installing       : json-glib-1.4.4-4.fc32.x86_64                      146/269 
  Installing       : jbigkit-libs-2.1-18.fc32.x86_64                    147/269 
  Installing       : jansson-2.12-5.fc32.x86_64                         148/269 
  Installing       : ipxe-roms-qemu-20190125-4.git36a4c85f.fc32.noarc   149/269 
  Installing       : hicolor-icon-theme-0.17-8.fc32.noarch              150/269 
  Installing       : gsm-1.0.18-6.fc32.x86_64                           151/269 
  Installing       : libsndfile-1.0.31-3.fc32.x86_64                    152/269 
  Installing       : dmidecode-1:3.2-5.fc32.x86_64                      153/269 
  Installing       : dconf-0.36.0-1.fc32.x86_64                         154/269 
  Installing       : cyrus-sasl-gssapi-2.1.27-4.fc32.x86_64             155/269 
  Installing       : libvirt-libs-6.1.0-4.fc32.x86_64                   156/269 
  Running scriptlet: libvirt-libs-6.1.0-4.fc32.x86_64                   156/269 
  Installing       : cdparanoia-libs-10.2-31.fc32.x86_64                157/269 
  Installing       : bzip2-1.0.8-2.fc32.x86_64                          158/269 
  Installing       : autogen-libopts-5.18.16-4.fc32.x86_64              159/269 
  Installing       : gnutls-utils-3.6.15-1.fc32.x86_64                  160/269 
  Installing       : augeas-libs-1.12.0-3.fc32.x86_64                   161/269 
  Installing       : xen-licenses-4.13.3-1.fc32.x86_64                  162/269 
  Installing       : xen-libs-4.13.3-1.fc32.x86_64                      163/269 
  Installing       : vte-profile-0.60.4-1.fc32.x86_64                   164/269 
  Installing       : usbredir-0.9.0-1.fc32.x86_64                       165/269 
  Installing       : quota-nls-1:4.05-10.fc32.noarch                    166/269 
  Installing       : quota-1:4.05-10.fc32.x86_64                        167/269 
  Installing       : pciutils-libs-3.7.0-3.fc32.x86_64                  168/269 
  Installing       : pciutils-3.7.0-3.fc32.x86_64                       169/269 
  Installing       : rdma-core-33.0-2.fc32.x86_64                       170/269 
  Running scriptlet: rdma-core-33.0-2.fc32.x86_64                       170/269 
  Installing       : libibverbs-33.0-2.fc32.x86_64                      171/269 
  Installing       : librdmacm-33.0-2.fc32.x86_64                       172/269 
  Installing       : librados2-2:14.2.21-1.fc32.x86_64                  173/269 
  Running scriptlet: librados2-2:14.2.21-1.fc32.x86_64                  173/269 
  Installing       : librbd1-2:14.2.21-1.fc32.x86_64                    174/269 
  Running scriptlet: librbd1-2:14.2.21-1.fc32.x86_64                    174/269 
  Installing       : libiscsi-1.18.0-9.fc32.x86_64                      175/269 
  Running scriptlet: libiscsi-1.18.0-9.fc32.x86_64                      175/269 
  Installing       : libibumad-33.0-2.fc32.x86_64                       176/269 
  Installing       : nmap-ncat-2:7.80-4.fc32.x86_64                     177/269 
  Running scriptlet: libvirt-daemon-6.1.0-4.fc32.x86_64                 178/269 
  Installing       : libvirt-daemon-6.1.0-4.fc32.x86_64                 178/269 
  Running scriptlet: libvirt-daemon-6.1.0-4.fc32.x86_64                 178/269 
Created symlink /etc/systemd/system/multi-user.target.wants/libvirtd.service → /usr/lib/systemd/system/libvirtd.service.
Created symlink /etc/systemd/system/sockets.target.wants/virtlockd.socket → /usr/lib/systemd/system/virtlockd.socket.
Created symlink /etc/systemd/system/sockets.target.wants/virtlogd.socket → /usr/lib/systemd/system/virtlogd.socket.
Created symlink /etc/systemd/system/sockets.target.wants/libvirtd.socket → /usr/lib/systemd/system/libvirtd.socket.
Created symlink /etc/systemd/system/sockets.target.wants/libvirtd-ro.socket → /usr/lib/systemd/system/libvirtd-ro.socket.

  Installing       : libwebp-1.2.0-1.fc32.x86_64                        179/269 
  Installing       : libtiff-4.1.0-3.fc32.x86_64                        180/269 
  Installing       : gdk-pixbuf2-modules-2.40.0-2.fc32.x86_64           181/269 
  Installing       : libvirt-bash-completion-6.1.0-4.fc32.x86_64        182/269 
  Installing       : libslirp-4.3.1-3.fc32.x86_64                       183/269 
  Installing       : libnfsidmap-1:2.5.3-1.fc32.x86_64                  184/269 
  Running scriptlet: nfs-utils-1:2.5.3-1.fc32.x86_64                    185/269 
  Installing       : nfs-utils-1:2.5.3-1.fc32.x86_64                    185/269 
  Running scriptlet: nfs-utils-1:2.5.3-1.fc32.x86_64                    185/269 
System has not been booted with systemd as init system (PID 1). Can't operate.
Failed to connect to bus: Host is down

System has not been booted with systemd as init system (PID 1). Can't operate.
Failed to connect to bus: Host is down

  Installing       : libisofs-1.5.4-1.fc32.x86_64                       186/269 
  Installing       : libgusb-0.3.5-1.fc32.x86_64                        187/269 
  Installing       : colord-libs-1.4.4-4.fc32.x86_64                    188/269 
  Installing       : libburn-1.5.4-2.fc32.x86_64                        189/269 
  Installing       : libisoburn-1.5.4-2.fc32.x86_64                     190/269 
  Installing       : libX11-common-1.6.12-1.fc32.noarch                 191/269 
  Installing       : libX11-1.6.12-1.fc32.x86_64                        192/269 
  Installing       : libXext-1.3.4-3.fc32.x86_64                        193/269 
  Installing       : libXrender-0.9.10-11.fc32.x86_64                   194/269 
  Installing       : cairo-1.16.0-8.fc32.x86_64                         195/269 
  Installing       : libXfixes-5.0.3-11.fc32.x86_64                     196/269 
  Installing       : cairo-gobject-1.16.0-8.fc32.x86_64                 197/269 
  Installing       : libXdamage-1.1.5-2.fc32.x86_64                     198/269 
  Installing       : libXi-1.7.10-3.fc32.x86_64                         199/269 
  Installing       : libXtst-1.2.3-11.fc32.x86_64                       200/269 
  Running scriptlet: brlapi-0.7.0-14.fc32.x86_64                        201/269 
  Installing       : brlapi-0.7.0-14.fc32.x86_64                        201/269 
  Running scriptlet: brlapi-0.7.0-14.fc32.x86_64                        201/269 
  Installing       : brltty-6.0-14.fc32.x86_64                          202/269 
  Running scriptlet: brltty-6.0-14.fc32.x86_64                          202/269 
  Installing       : virglrenderer-0.8.2-1.20200212git7d204f39.fc32.x   203/269 
  Installing       : qemu-common-2:4.2.1-1.fc32.x86_64                  204/269 
  Running scriptlet: qemu-common-2:4.2.1-1.fc32.x86_64                  204/269 
  Installing       : qemu-audio-alsa-2:4.2.1-1.fc32.x86_64              205/269 
  Installing       : qemu-audio-oss-2:4.2.1-1.fc32.x86_64               206/269 
  Installing       : qemu-audio-sdl-2:4.2.1-1.fc32.x86_64               207/269 
  Installing       : qemu-block-curl-2:4.2.1-1.fc32.x86_64              208/269 
  Installing       : qemu-block-dmg-2:4.2.1-1.fc32.x86_64               209/269 
  Installing       : qemu-block-gluster-2:4.2.1-1.fc32.x86_64           210/269 
  Installing       : qemu-block-iscsi-2:4.2.1-1.fc32.x86_64             211/269 
  Installing       : qemu-block-nfs-2:4.2.1-1.fc32.x86_64               212/269 
  Installing       : qemu-block-rbd-2:4.2.1-1.fc32.x86_64               213/269 
  Installing       : qemu-block-ssh-2:4.2.1-1.fc32.x86_64               214/269 
  Installing       : qemu-ui-curses-2:4.2.1-1.fc32.x86_64               215/269 
  Installing       : qemu-ui-spice-app-2:4.2.1-1.fc32.x86_64            216/269 
  Installing       : at-spi2-core-2.36.1-1.fc32.x86_64                  217/269 
  Installing       : at-spi2-atk-2.34.2-1.fc32.x86_64                   218/269 
  Installing       : pulseaudio-libs-14.0-1.fc32.x86_64                 219/269 
  Installing       : qemu-audio-pa-2:4.2.1-1.fc32.x86_64                220/269 
  Installing       : libXcursor-1.2.0-2.fc32.x86_64                     221/269 
  Installing       : libXft-2.3.3-3.fc32.x86_64                         222/269 
  Installing       : libXrandr-1.5.2-3.fc32.x86_64                      223/269 
  Installing       : libXinerama-1.1.4-5.fc32.x86_64                    224/269 
  Installing       : libXv-1.0.11-11.fc32.x86_64                        225/269 
  Installing       : libXxf86vm-1.1.4-13.fc32.x86_64                    226/269 
  Installing       : libglvnd-glx-1:1.3.2-1.fc32.x86_64                 227/269 
  Installing       : mesa-libGL-20.2.3-1.fc32.x86_64                    228/269 
  Installing       : libXcomposite-0.4.5-2.fc32.x86_64                  229/269 
  Installing       : kf5-filesystem-5.75.0-1.fc32.x86_64                230/269 
  Installing       : graphite2-1.3.14-1.fc32.x86_64                     231/269 
  Installing       : harfbuzz-2.6.4-3.fc32.x86_64                       232/269 
  Installing       : pango-1.44.7-2.fc32.x86_64                         233/269 
  Installing       : graphene-1.10.4-1.fc32.x86_64                      234/269 
  Installing       : gstreamer1-plugins-base-1.16.2-3.fc32.x86_64       235/269 
  Installing       : spice-server-0.14.3-1.fc32.x86_64                  236/269 
  Installing       : edk2-ovmf-20200801stable-1.fc32.noarch             237/269 
  Installing       : capstone-4.0.2-2.fc32.x86_64                       238/269 
  Installing       : qemu-system-x86-core-2:4.2.1-1.fc32.x86_64         239/269 
  Installing       : adwaita-cursor-theme-3.36.1-1.fc32.noarch          240/269 
  Installing       : adwaita-icon-theme-3.36.1-1.fc32.noarch            241/269 
  Installing       : gtk3-3.24.28-2.fc32.x86_64                         242/269 
  Installing       : vte291-0.60.4-1.fc32.x86_64                        243/269 
  Installing       : qemu-ui-gtk-2:4.2.1-1.fc32.x86_64                  244/269 
  Installing       : qemu-ui-sdl-2:4.2.1-1.fc32.x86_64                  245/269 
  Installing       : qemu-system-x86-2:4.2.1-1.fc32.x86_64              246/269 
  Installing       : qemu-kvm-2:4.2.1-1.fc32.x86_64                     247/269 
  Installing       : xorriso-1.5.4-2.fc32.x86_64                        248/269 
  Running scriptlet: xorriso-1.5.4-2.fc32.x86_64                        248/269 
  Installing       : libvirt-daemon-driver-storage-core-6.1.0-4.fc32.   249/269 
  Installing       : libvirt-client-6.1.0-4.fc32.x86_64                 250/269 
  Running scriptlet: libvirt-client-6.1.0-4.fc32.x86_64                 250/269 
  Running scriptlet: libvirt-daemon-driver-qemu-6.1.0-4.fc32.x86_64     251/269 
  Installing       : libvirt-daemon-driver-qemu-6.1.0-4.fc32.x86_64     251/269 
  Installing       : augeas-1.12.0-3.fc32.x86_64                        252/269 
  Installing       : nftables-1:0.9.3-4.fc32.x86_64                     253/269 
  Running scriptlet: nftables-1:0.9.3-4.fc32.x86_64                     253/269 
  Upgrading        : python3-rpm-4.15.1.1-1.fc32.1.x86_64               254/269 
  Installing       : compat-f32-dejavu-sans-fonts-2.37-8.fc32.noarch    255/269 
  Installing       : procps-ng-3.3.16-2.fc32.x86_64                     256/269 
  Installing       : iptables-1.8.4-9.fc32.x86_64                       257/269 
  Running scriptlet: iptables-1.8.4-9.fc32.x86_64                       257/269 
  Installing       : findutils-1:4.7.0-4.fc32.x86_64                    258/269 
  Cleanup          : python3-rpm-4.15.1-3.fc32.1.x86_64                 259/269 
  Running scriptlet: systemd-245.8-2.fc32.x86_64                        260/269 
  Cleanup          : systemd-245.8-2.fc32.x86_64                        260/269 
  Cleanup          : rpm-build-libs-4.15.1-3.fc32.1.x86_64              261/269 
  Cleanup          : rpm-sign-libs-4.15.1-3.fc32.1.x86_64               262/269 
  Cleanup          : systemd-rpm-macros-245.8-2.fc32.noarch             263/269 
  Cleanup          : rpm-4.15.1-3.fc32.1.x86_64                         264/269 
  Cleanup          : rpm-libs-4.15.1-3.fc32.1.x86_64                    265/269 
  Cleanup          : pcre2-10.36-1.fc32.x86_64                          266/269 
  Cleanup          : pcre2-syntax-10.36-1.fc32.noarch                   267/269 
  Cleanup          : systemd-libs-245.8-2.fc32.x86_64                   268/269 
  Cleanup          : systemd-pam-245.8-2.fc32.x86_64                    269/269 
  Running scriptlet: selinux-policy-targeted-3.14.5-46.fc32.noarch      269/269 
  Running scriptlet: dconf-0.36.0-1.fc32.x86_64                         269/269 
  Running scriptlet: libvirt-daemon-6.1.0-4.fc32.x86_64                 269/269 
  Running scriptlet: systemd-pam-245.8-2.fc32.x86_64                    269/269 
  Verifying        : adwaita-cursor-theme-3.36.1-1.fc32.noarch            1/269 
  Verifying        : adwaita-icon-theme-3.36.1-1.fc32.noarch              2/269 
  Verifying        : alsa-lib-1.2.3.2-1.fc32.x86_64                       3/269 
  Verifying        : at-spi2-core-2.36.1-1.fc32.x86_64                    4/269 
  Verifying        : avahi-libs-0.7-24.fc32.x86_64                        5/269 
  Verifying        : bluez-libs-5.55-1.fc32.x86_64                        6/269 
  Verifying        : brlapi-0.7.0-14.fc32.x86_64                          7/269 
  Verifying        : brltty-6.0-14.fc32.x86_64                            8/269 
  Verifying        : cairo-1.16.0-8.fc32.x86_64                           9/269 
  Verifying        : cairo-gobject-1.16.0-8.fc32.x86_64                  10/269 
  Verifying        : capstone-4.0.2-2.fc32.x86_64                        11/269 
  Verifying        : compat-f32-dejavu-sans-fonts-2.37-8.fc32.noarch     12/269 
  Verifying        : cups-libs-1:2.3.3op2-5.fc32.x86_64                  13/269 
  Verifying        : dbus-libs-1:1.12.20-1.fc32.x86_64                   14/269 
  Verifying        : dejavu-sans-fonts-2.37-8.fc32.noarch                15/269 
  Verifying        : device-mapper-multipath-libs-0.8.2-4.fc32.x86_64    16/269 
  Verifying        : edk2-ovmf-20200801stable-1.fc32.noarch              17/269 
  Verifying        : findutils-1:4.7.0-4.fc32.x86_64                     18/269 
  Verifying        : fontconfig-2.13.92-9.fc32.x86_64                    19/269 
  Verifying        : freetype-2.10.4-1.fc32.x86_64                       20/269 
  Verifying        : gettext-0.21-1.fc32.x86_64                          21/269 
  Verifying        : gettext-libs-0.21-1.fc32.x86_64                     22/269 
  Verifying        : glib-networking-2.64.3-1.fc32.x86_64                23/269 
  Verifying        : glusterfs-7.9-1.fc32.x86_64                         24/269 
  Verifying        : glusterfs-api-7.9-1.fc32.x86_64                     25/269 
  Verifying        : glusterfs-client-xlators-7.9-1.fc32.x86_64          26/269 
  Verifying        : glusterfs-libs-7.9-1.fc32.x86_64                    27/269 
  Verifying        : gnutls-dane-3.6.15-1.fc32.x86_64                    28/269 
  Verifying        : gnutls-utils-3.6.15-1.fc32.x86_64                   29/269 
  Verifying        : graphene-1.10.4-1.fc32.x86_64                       30/269 
  Verifying        : graphite2-1.3.14-1.fc32.x86_64                      31/269 
  Verifying        : gsettings-desktop-schemas-3.36.1-1.fc32.x86_64      32/269 
  Verifying        : gstreamer1-plugins-base-1.16.2-3.fc32.x86_64        33/269 
  Verifying        : gtk-update-icon-cache-3.24.28-2.fc32.x86_64         34/269 
  Verifying        : gtk3-3.24.28-2.fc32.x86_64                          35/269 
  Verifying        : hwdata-0.347-1.fc32.noarch                          36/269 
  Verifying        : iproute-5.9.0-1.fc32.x86_64                         37/269 
  Verifying        : iproute-tc-5.9.0-1.fc32.x86_64                      38/269 
  Verifying        : iptables-1.8.4-9.fc32.x86_64                        39/269 
  Verifying        : jasper-libs-2.0.26-2.fc32.x86_64                    40/269 
  Verifying        : kf5-filesystem-5.75.0-1.fc32.x86_64                 41/269 
  Verifying        : libX11-1.6.12-1.fc32.x86_64                         42/269 
  Verifying        : libX11-common-1.6.12-1.fc32.noarch                  43/269 
  Verifying        : libX11-xcb-1.6.12-1.fc32.x86_64                     44/269 
  Verifying        : libburn-1.5.4-2.fc32.x86_64                         45/269 
  Verifying        : libdrm-2.4.102-1.fc32.x86_64                        46/269 
  Verifying        : libglvnd-1:1.3.2-1.fc32.x86_64                      47/269 
  Verifying        : libglvnd-egl-1:1.3.2-1.fc32.x86_64                  48/269 
  Verifying        : libglvnd-gles-1:1.3.2-1.fc32.x86_64                 49/269 
  Verifying        : libglvnd-glx-1:1.3.2-1.fc32.x86_64                  50/269 
  Verifying        : libgusb-0.3.5-1.fc32.x86_64                         51/269 
  Verifying        : libibumad-33.0-2.fc32.x86_64                        52/269 
  Verifying        : libibverbs-33.0-2.fc32.x86_64                       53/269 
  Verifying        : libisoburn-1.5.4-2.fc32.x86_64                      54/269 
  Verifying        : libisofs-1.5.4-1.fc32.x86_64                        55/269 
  Verifying        : libjpeg-turbo-2.0.4-3.fc32.x86_64                   56/269 
  Verifying        : libnfsidmap-1:2.5.3-1.fc32.x86_64                   57/269 
  Verifying        : libproxy-0.4.15-19.fc32.x86_64                      58/269 
  Verifying        : librados2-2:14.2.21-1.fc32.x86_64                   59/269 
  Verifying        : librbd1-2:14.2.21-1.fc32.x86_64                     60/269 
  Verifying        : librdmacm-33.0-2.fc32.x86_64                        61/269 
  Verifying        : libselinux-utils-3.0-5.fc32.x86_64                  62/269 
  Verifying        : libslirp-4.3.1-3.fc32.x86_64                        63/269 
  Verifying        : libsndfile-1.0.31-3.fc32.x86_64                     64/269 
  Verifying        : libtextstyle-0.21-1.fc32.x86_64                     65/269 
  Verifying        : libtiff-4.1.0-3.fc32.x86_64                         66/269 
  Verifying        : libvirt-bash-completion-6.1.0-4.fc32.x86_64         67/269 
  Verifying        : libvirt-client-6.1.0-4.fc32.x86_64                  68/269 
  Verifying        : libvirt-daemon-6.1.0-4.fc32.x86_64                  69/269 
  Verifying        : libvirt-daemon-driver-qemu-6.1.0-4.fc32.x86_64      70/269 
  Verifying        : libvirt-daemon-driver-storage-core-6.1.0-4.fc32.    71/269 
  Verifying        : libvirt-libs-6.1.0-4.fc32.x86_64                    72/269 
  Verifying        : libwebp-1.2.0-1.fc32.x86_64                         73/269 
  Verifying        : mesa-libEGL-20.2.3-1.fc32.x86_64                    74/269 
  Verifying        : mesa-libGL-20.2.3-1.fc32.x86_64                     75/269 
  Verifying        : mesa-libgbm-20.2.3-1.fc32.x86_64                    76/269 
  Verifying        : mesa-libglapi-20.2.3-1.fc32.x86_64                  77/269 
  Verifying        : nfs-utils-1:2.5.3-1.fc32.x86_64                     78/269 
  Verifying        : nftables-1:0.9.3-4.fc32.x86_64                      79/269 
  Verifying        : nmap-ncat-2:7.80-4.fc32.x86_64                      80/269 
  Verifying        : nspr-4.30.0-1.fc32.x86_64                           81/269 
  Verifying        : nss-3.63.0-1.fc32.x86_64                            82/269 
  Verifying        : nss-softokn-3.63.0-1.fc32.x86_64                    83/269 
  Verifying        : nss-softokn-freebl-3.63.0-1.fc32.x86_64             84/269 
  Verifying        : nss-sysinit-3.63.0-1.fc32.x86_64                    85/269 
  Verifying        : nss-util-3.63.0-1.fc32.x86_64                       86/269 
  Verifying        : pciutils-3.7.0-3.fc32.x86_64                        87/269 
  Verifying        : pciutils-libs-3.7.0-3.fc32.x86_64                   88/269 
  Verifying        : pcre2-utf32-10.36-4.fc32.x86_64                     89/269 
  Verifying        : pixman-0.40.0-1.fc32.x86_64                         90/269 
  Verifying        : procps-ng-3.3.16-2.fc32.x86_64                      91/269 
  Verifying        : pulseaudio-libs-14.0-1.fc32.x86_64                  92/269 
  Verifying        : qemu-audio-alsa-2:4.2.1-1.fc32.x86_64               93/269 
  Verifying        : qemu-audio-oss-2:4.2.1-1.fc32.x86_64                94/269 
  Verifying        : qemu-audio-pa-2:4.2.1-1.fc32.x86_64                 95/269 
  Verifying        : qemu-audio-sdl-2:4.2.1-1.fc32.x86_64                96/269 
  Verifying        : qemu-block-curl-2:4.2.1-1.fc32.x86_64               97/269 
  Verifying        : qemu-block-dmg-2:4.2.1-1.fc32.x86_64                98/269 
  Verifying        : qemu-block-gluster-2:4.2.1-1.fc32.x86_64            99/269 
  Verifying        : qemu-block-iscsi-2:4.2.1-1.fc32.x86_64             100/269 
  Verifying        : qemu-block-nfs-2:4.2.1-1.fc32.x86_64               101/269 
  Verifying        : qemu-block-rbd-2:4.2.1-1.fc32.x86_64               102/269 
  Verifying        : qemu-block-ssh-2:4.2.1-1.fc32.x86_64               103/269 
  Verifying        : qemu-common-2:4.2.1-1.fc32.x86_64                  104/269 
  Verifying        : qemu-img-2:4.2.1-1.fc32.x86_64                     105/269 
  Verifying        : qemu-kvm-2:4.2.1-1.fc32.x86_64                     106/269 
  Verifying        : qemu-system-x86-2:4.2.1-1.fc32.x86_64              107/269 
  Verifying        : qemu-system-x86-core-2:4.2.1-1.fc32.x86_64         108/269 
  Verifying        : qemu-ui-curses-2:4.2.1-1.fc32.x86_64               109/269 
  Verifying        : qemu-ui-gtk-2:4.2.1-1.fc32.x86_64                  110/269 
  Verifying        : qemu-ui-sdl-2:4.2.1-1.fc32.x86_64                  111/269 
  Verifying        : qemu-ui-spice-app-2:4.2.1-1.fc32.x86_64            112/269 
  Verifying        : quota-1:4.05-10.fc32.x86_64                        113/269 
  Verifying        : quota-nls-1:4.05-10.fc32.noarch                    114/269 
  Verifying        : rdma-core-33.0-2.fc32.x86_64                       115/269 
  Verifying        : rpm-plugin-selinux-4.15.1.1-1.fc32.1.x86_64        116/269 
  Verifying        : selinux-policy-3.14.5-46.fc32.noarch               117/269 
  Verifying        : selinux-policy-targeted-3.14.5-46.fc32.noarch      118/269 
  Verifying        : systemd-container-245.9-1.fc32.x86_64              119/269 
  Verifying        : unbound-libs-1.10.1-1.fc32.x86_64                  120/269 
  Verifying        : usbredir-0.9.0-1.fc32.x86_64                       121/269 
  Verifying        : vte-profile-0.60.4-1.fc32.x86_64                   122/269 
  Verifying        : vte291-0.60.4-1.fc32.x86_64                        123/269 
  Verifying        : xen-libs-4.13.3-1.fc32.x86_64                      124/269 
  Verifying        : xen-licenses-4.13.3-1.fc32.x86_64                  125/269 
  Verifying        : xorriso-1.5.4-2.fc32.x86_64                        126/269 
  Verifying        : SDL2-2.0.12-1.fc32.x86_64                          127/269 
  Verifying        : abattis-cantarell-fonts-0.201-2.fc32.noarch        128/269 
  Verifying        : adobe-source-code-pro-fonts-2.030.1.050-8.fc32.n   129/269 
  Verifying        : at-spi2-atk-2.34.2-1.fc32.x86_64                   130/269 
  Verifying        : atk-2.36.0-1.fc32.x86_64                           131/269 
  Verifying        : augeas-1.12.0-3.fc32.x86_64                        132/269 
  Verifying        : augeas-libs-1.12.0-3.fc32.x86_64                   133/269 
  Verifying        : autogen-libopts-5.18.16-4.fc32.x86_64              134/269 
  Verifying        : bzip2-1.0.8-2.fc32.x86_64                          135/269 
  Verifying        : cdparanoia-libs-10.2-31.fc32.x86_64                136/269 
  Verifying        : colord-libs-1.4.4-4.fc32.x86_64                    137/269 
  Verifying        : cyrus-sasl-2.1.27-4.fc32.x86_64                    138/269 
  Verifying        : cyrus-sasl-gssapi-2.1.27-4.fc32.x86_64             139/269 
  Verifying        : dconf-0.36.0-1.fc32.x86_64                         140/269 
  Verifying        : diffutils-3.7-4.fc32.x86_64                        141/269 
  Verifying        : dmidecode-1:3.2-5.fc32.x86_64                      142/269 
  Verifying        : e2fsprogs-libs-1.45.5-3.fc32.x86_64                143/269 
  Verifying        : flac-libs-1.3.3-2.fc32.x86_64                      144/269 
  Verifying        : fonts-filesystem-2.0.3-1.fc32.noarch               145/269 
  Verifying        : fribidi-1.0.9-1.fc32.x86_64                        146/269 
  Verifying        : gdk-pixbuf2-2.40.0-2.fc32.x86_64                   147/269 
  Verifying        : gdk-pixbuf2-modules-2.40.0-2.fc32.x86_64           148/269 
  Verifying        : gsm-1.0.18-6.fc32.x86_64                           149/269 
  Verifying        : gssproxy-0.8.2-8.fc32.x86_64                       150/269 
  Verifying        : gstreamer1-1.16.2-2.fc32.x86_64                    151/269 
  Verifying        : harfbuzz-2.6.4-3.fc32.x86_64                       152/269 
  Verifying        : hicolor-icon-theme-0.17-8.fc32.noarch              153/269 
  Verifying        : ipxe-roms-qemu-20190125-4.git36a4c85f.fc32.noarc   154/269 
  Verifying        : iso-codes-4.4-2.fc32.noarch                        155/269 
  Verifying        : jansson-2.12-5.fc32.x86_64                         156/269 
  Verifying        : jbigkit-libs-2.1-18.fc32.x86_64                    157/269 
  Verifying        : json-glib-1.4.4-4.fc32.x86_64                      158/269 
  Verifying        : kde-filesystem-4-63.fc32.x86_64                    159/269 
  Verifying        : keyutils-1.6-4.fc32.x86_64                         160/269 
  Verifying        : kmod-27-1.fc32.x86_64                              161/269 
  Verifying        : langpacks-core-font-en-3.0-3.fc32.noarch           162/269 
  Verifying        : lcms2-2.9-7.fc32.x86_64                            163/269 
  Verifying        : libICE-1.0.10-3.fc32.x86_64                        164/269 
  Verifying        : libSM-1.2.3-5.fc32.x86_64                          165/269 
  Verifying        : libXau-1.0.9-3.fc32.x86_64                         166/269 
  Verifying        : libXcomposite-0.4.5-2.fc32.x86_64                  167/269 
  Verifying        : libXcursor-1.2.0-2.fc32.x86_64                     168/269 
  Verifying        : libXdamage-1.1.5-2.fc32.x86_64                     169/269 
  Verifying        : libXext-1.3.4-3.fc32.x86_64                        170/269 
  Verifying        : libXfixes-5.0.3-11.fc32.x86_64                     171/269 
  Verifying        : libXft-2.3.3-3.fc32.x86_64                         172/269 
  Verifying        : libXi-1.7.10-3.fc32.x86_64                         173/269 
  Verifying        : libXinerama-1.1.4-5.fc32.x86_64                    174/269 
  Verifying        : libXrandr-1.5.2-3.fc32.x86_64                      175/269 
  Verifying        : libXrender-0.9.10-11.fc32.x86_64                   176/269 
  Verifying        : libXtst-1.2.3-11.fc32.x86_64                       177/269 
  Verifying        : libXv-1.0.11-11.fc32.x86_64                        178/269 
  Verifying        : libXxf86vm-1.1.4-13.fc32.x86_64                    179/269 
  Verifying        : libaio-0.3.111-7.fc32.x86_64                       180/269 
  Verifying        : libasyncns-0.8-18.fc32.x86_64                      181/269 
  Verifying        : libbasicobjects-0.1.1-44.fc32.x86_64               182/269 
  Verifying        : libcacard-3:2.7.0-4.fc32.x86_64                    183/269 
  Verifying        : libcollection-0.7.0-44.fc32.x86_64                 184/269 
  Verifying        : libdatrie-0.2.9-11.fc32.x86_64                     185/269 
  Verifying        : libepoxy-1.5.4-2.fc32.x86_64                       186/269 
  Verifying        : libev-4.31-2.fc32.x86_64                           187/269 
  Verifying        : libevent-2.1.8-8.fc32.x86_64                       188/269 
  Verifying        : libfdt-1.6.0-1.fc32.x86_64                         189/269 
  Verifying        : libicu-65.1-2.fc32.x86_64                          190/269 
  Verifying        : libini_config-1.3.1-44.fc32.x86_64                 191/269 
  Verifying        : libiscsi-1.18.0-9.fc32.x86_64                      192/269 
  Verifying        : libmodman-2.0.1-21.fc32.x86_64                     193/269 
  Verifying        : libnfs-4.0.0-2.fc32.x86_64                         194/269 
  Verifying        : libnftnl-1.1.5-2.fc32.x86_64                       195/269 
  Verifying        : libnl3-3.5.0-2.fc32.x86_64                         196/269 
  Verifying        : libogg-2:1.3.4-2.fc32.x86_64                       197/269 
  Verifying        : libpath_utils-0.2.1-44.fc32.x86_64                 198/269 
  Verifying        : libpciaccess-0.16-2.fc32.x86_64                    199/269 
  Verifying        : libpmem-1.8-2.fc32.x86_64                          200/269 
  Verifying        : libpng-2:1.6.37-3.fc32.x86_64                      201/269 
  Verifying        : libref_array-0.1.5-44.fc32.x86_64                  202/269 
  Verifying        : libsoup-2.70.0-1.fc32.x86_64                       203/269 
  Verifying        : libssh2-1.9.0-5.fc32.x86_64                        204/269 
  Verifying        : libthai-0.1.28-4.fc32.x86_64                       205/269 
  Verifying        : libtheora-1:1.1.1-25.fc32.x86_64                   206/269 
  Verifying        : libverto-libev-0.3.0-9.fc32.x86_64                 207/269 
  Verifying        : libvisual-1:0.4.0-28.fc32.x86_64                   208/269 
  Verifying        : libvorbis-1:1.3.6-6.fc32.x86_64                    209/269 
  Verifying        : libwayland-client-1.18.0-1.fc32.x86_64             210/269 
  Verifying        : libwayland-cursor-1.18.0-1.fc32.x86_64             211/269 
  Verifying        : libwayland-egl-1.18.0-1.fc32.x86_64                212/269 
  Verifying        : libwayland-server-1.18.0-1.fc32.x86_64             213/269 
  Verifying        : libwsman1-2.6.8-12.fc32.x86_64                     214/269 
  Verifying        : libxcb-1.13.1-4.fc32.x86_64                        215/269 
  Verifying        : libxkbcommon-0.10.0-2.fc32.x86_64                  216/269 
  Verifying        : libxshmfence-1.3-6.fc32.x86_64                     217/269 
  Verifying        : linux-atm-libs-2.5.1-26.fc32.x86_64                218/269 
  Verifying        : lttng-ust-2.11.0-4.fc32.x86_64                     219/269 
  Verifying        : lzo-2.10-2.fc32.x86_64                             220/269 
  Verifying        : lzop-1.04-3.fc32.x86_64                            221/269 
  Verifying        : mozjs60-60.9.0-5.fc32.x86_64                       222/269 
  Verifying        : numactl-libs-2.0.12-4.fc32.x86_64                  223/269 
  Verifying        : numad-0.5-31.20150602git.fc32.x86_64               224/269 
  Verifying        : opus-1.3.1-3.fc32.x86_64                           225/269 
  Verifying        : orc-0.4.31-2.fc32.x86_64                           226/269 
  Verifying        : pango-1.44.7-2.fc32.x86_64                         227/269 
  Verifying        : parted-3.3-3.fc32.x86_64                           228/269 
  Verifying        : policycoreutils-3.0-2.fc32.x86_64                  229/269 
  Verifying        : polkit-0.116-7.fc32.x86_64                         230/269 
  Verifying        : polkit-libs-0.116-7.fc32.x86_64                    231/269 
  Verifying        : polkit-pkla-compat-0.1-16.fc32.x86_64              232/269 
  Verifying        : psmisc-23.3-3.fc32.x86_64                          233/269 
  Verifying        : rest-0.8.1-7.fc32.x86_64                           234/269 
  Verifying        : rpcbind-1.2.5-5.rc1.fc32.1.x86_64                  235/269 
  Verifying        : seabios-bin-1.13.0-2.fc32.noarch                   236/269 
  Verifying        : seavgabios-bin-1.13.0-2.fc32.noarch                237/269 
  Verifying        : sgabios-bin-1:0.20180715git-4.fc32.noarch          238/269 
  Verifying        : shared-mime-info-1.15-3.fc32.x86_64                239/269 
  Verifying        : snappy-1.1.8-2.fc32.x86_64                         240/269 
  Verifying        : spice-server-0.14.3-1.fc32.x86_64                  241/269 
  Verifying        : userspace-rcu-0.11.1-3.fc32.x86_64                 242/269 
  Verifying        : virglrenderer-0.8.2-1.20200212git7d204f39.fc32.x   243/269 
  Verifying        : xkeyboard-config-2.29-1.fc32.noarch                244/269 
  Verifying        : xml-common-0.6.3-54.fc32.noarch                    245/269 
  Verifying        : xz-5.2.5-1.fc32.x86_64                             246/269 
  Verifying        : yajl-2.1.0-14.fc32.x86_64                          247/269 
  Verifying        : pcre2-10.36-4.fc32.x86_64                          248/269 
  Verifying        : pcre2-10.36-1.fc32.x86_64                          249/269 
  Verifying        : pcre2-syntax-10.36-4.fc32.noarch                   250/269 
  Verifying        : pcre2-syntax-10.36-1.fc32.noarch                   251/269 
  Verifying        : python3-rpm-4.15.1.1-1.fc32.1.x86_64               252/269 
  Verifying        : python3-rpm-4.15.1-3.fc32.1.x86_64                 253/269 
  Verifying        : rpm-4.15.1.1-1.fc32.1.x86_64                       254/269 
  Verifying        : rpm-4.15.1-3.fc32.1.x86_64                         255/269 
  Verifying        : rpm-build-libs-4.15.1.1-1.fc32.1.x86_64            256/269 
  Verifying        : rpm-build-libs-4.15.1-3.fc32.1.x86_64              257/269 
  Verifying        : rpm-libs-4.15.1.1-1.fc32.1.x86_64                  258/269 
  Verifying        : rpm-libs-4.15.1-3.fc32.1.x86_64                    259/269 
  Verifying        : rpm-sign-libs-4.15.1.1-1.fc32.1.x86_64             260/269 
  Verifying        : rpm-sign-libs-4.15.1-3.fc32.1.x86_64               261/269 
  Verifying        : systemd-245.9-1.fc32.x86_64                        262/269 
  Verifying        : systemd-245.8-2.fc32.x86_64                        263/269 
  Verifying        : systemd-libs-245.9-1.fc32.x86_64                   264/269 
  Verifying        : systemd-libs-245.8-2.fc32.x86_64                   265/269 
  Verifying        : systemd-pam-245.9-1.fc32.x86_64                    266/269 
  Verifying        : systemd-pam-245.8-2.fc32.x86_64                    267/269 
  Verifying        : systemd-rpm-macros-245.9-1.fc32.noarch             268/269 
  Verifying        : systemd-rpm-macros-245.8-2.fc32.noarch             269/269 

Upgraded:
  pcre2-10.36-4.fc32.x86_64                 pcre2-syntax-10.36-4.fc32.noarch   
  python3-rpm-4.15.1.1-1.fc32.1.x86_64      rpm-4.15.1.1-1.fc32.1.x86_64       
  rpm-build-libs-4.15.1.1-1.fc32.1.x86_64   rpm-libs-4.15.1.1-1.fc32.1.x86_64  
  rpm-sign-libs-4.15.1.1-1.fc32.1.x86_64    systemd-245.9-1.fc32.x86_64        
  systemd-libs-245.9-1.fc32.x86_64          systemd-pam-245.9-1.fc32.x86_64    
  systemd-rpm-macros-245.9-1.fc32.noarch   

Installed:
  SDL2-2.0.12-1.fc32.x86_64                                                     
  abattis-cantarell-fonts-0.201-2.fc32.noarch                                   
  adobe-source-code-pro-fonts-2.030.1.050-8.fc32.noarch                         
  adwaita-cursor-theme-3.36.1-1.fc32.noarch                                     
  adwaita-icon-theme-3.36.1-1.fc32.noarch                                       
  alsa-lib-1.2.3.2-1.fc32.x86_64                                                
  at-spi2-atk-2.34.2-1.fc32.x86_64                                              
  at-spi2-core-2.36.1-1.fc32.x86_64                                             
  atk-2.36.0-1.fc32.x86_64                                                      
  augeas-1.12.0-3.fc32.x86_64                                                   
  augeas-libs-1.12.0-3.fc32.x86_64                                              
  autogen-libopts-5.18.16-4.fc32.x86_64                                         
  avahi-libs-0.7-24.fc32.x86_64                                                 
  bluez-libs-5.55-1.fc32.x86_64                                                 
  brlapi-0.7.0-14.fc32.x86_64                                                   
  brltty-6.0-14.fc32.x86_64                                                     
  bzip2-1.0.8-2.fc32.x86_64                                                     
  cairo-1.16.0-8.fc32.x86_64                                                    
  cairo-gobject-1.16.0-8.fc32.x86_64                                            
  capstone-4.0.2-2.fc32.x86_64                                                  
  cdparanoia-libs-10.2-31.fc32.x86_64                                           
  colord-libs-1.4.4-4.fc32.x86_64                                               
  compat-f32-dejavu-sans-fonts-2.37-8.fc32.noarch                               
  cups-libs-1:2.3.3op2-5.fc32.x86_64                                            
  cyrus-sasl-2.1.27-4.fc32.x86_64                                               
  cyrus-sasl-gssapi-2.1.27-4.fc32.x86_64                                        
  dbus-libs-1:1.12.20-1.fc32.x86_64                                             
  dconf-0.36.0-1.fc32.x86_64                                                    
  dejavu-sans-fonts-2.37-8.fc32.noarch                                          
  device-mapper-multipath-libs-0.8.2-4.fc32.x86_64                              
  diffutils-3.7-4.fc32.x86_64                                                   
  dmidecode-1:3.2-5.fc32.x86_64                                                 
  e2fsprogs-libs-1.45.5-3.fc32.x86_64                                           
  edk2-ovmf-20200801stable-1.fc32.noarch                                        
  findutils-1:4.7.0-4.fc32.x86_64                                               
  flac-libs-1.3.3-2.fc32.x86_64                                                 
  fontconfig-2.13.92-9.fc32.x86_64                                              
  fonts-filesystem-2.0.3-1.fc32.noarch                                          
  freetype-2.10.4-1.fc32.x86_64                                                 
  fribidi-1.0.9-1.fc32.x86_64                                                   
  gdk-pixbuf2-2.40.0-2.fc32.x86_64                                              
  gdk-pixbuf2-modules-2.40.0-2.fc32.x86_64                                      
  gettext-0.21-1.fc32.x86_64                                                    
  gettext-libs-0.21-1.fc32.x86_64                                               
  glib-networking-2.64.3-1.fc32.x86_64                                          
  glusterfs-7.9-1.fc32.x86_64                                                   
  glusterfs-api-7.9-1.fc32.x86_64                                               
  glusterfs-client-xlators-7.9-1.fc32.x86_64                                    
  glusterfs-libs-7.9-1.fc32.x86_64                                              
  gnutls-dane-3.6.15-1.fc32.x86_64                                              
  gnutls-utils-3.6.15-1.fc32.x86_64                                             
  graphene-1.10.4-1.fc32.x86_64                                                 
  graphite2-1.3.14-1.fc32.x86_64                                                
  gsettings-desktop-schemas-3.36.1-1.fc32.x86_64                                
  gsm-1.0.18-6.fc32.x86_64                                                      
  gssproxy-0.8.2-8.fc32.x86_64                                                  
  gstreamer1-1.16.2-2.fc32.x86_64                                               
  gstreamer1-plugins-base-1.16.2-3.fc32.x86_64                                  
  gtk-update-icon-cache-3.24.28-2.fc32.x86_64                                   
  gtk3-3.24.28-2.fc32.x86_64                                                    
  harfbuzz-2.6.4-3.fc32.x86_64                                                  
  hicolor-icon-theme-0.17-8.fc32.noarch                                         
  hwdata-0.347-1.fc32.noarch                                                    
  iproute-5.9.0-1.fc32.x86_64                                                   
  iproute-tc-5.9.0-1.fc32.x86_64                                                
  iptables-1.8.4-9.fc32.x86_64                                                  
  ipxe-roms-qemu-20190125-4.git36a4c85f.fc32.noarch                             
  iso-codes-4.4-2.fc32.noarch                                                   
  jansson-2.12-5.fc32.x86_64                                                    
  jasper-libs-2.0.26-2.fc32.x86_64                                              
  jbigkit-libs-2.1-18.fc32.x86_64                                               
  json-glib-1.4.4-4.fc32.x86_64                                                 
  kde-filesystem-4-63.fc32.x86_64                                               
  keyutils-1.6-4.fc32.x86_64                                                    
  kf5-filesystem-5.75.0-1.fc32.x86_64                                           
  kmod-27-1.fc32.x86_64                                                         
  langpacks-core-font-en-3.0-3.fc32.noarch                                      
  lcms2-2.9-7.fc32.x86_64                                                       
  libICE-1.0.10-3.fc32.x86_64                                                   
  libSM-1.2.3-5.fc32.x86_64                                                     
  libX11-1.6.12-1.fc32.x86_64                                                   
  libX11-common-1.6.12-1.fc32.noarch                                            
  libX11-xcb-1.6.12-1.fc32.x86_64                                               
  libXau-1.0.9-3.fc32.x86_64                                                    
  libXcomposite-0.4.5-2.fc32.x86_64                                             
  libXcursor-1.2.0-2.fc32.x86_64                                                
  libXdamage-1.1.5-2.fc32.x86_64                                                
  libXext-1.3.4-3.fc32.x86_64                                                   
  libXfixes-5.0.3-11.fc32.x86_64                                                
  libXft-2.3.3-3.fc32.x86_64                                                    
  libXi-1.7.10-3.fc32.x86_64                                                    
  libXinerama-1.1.4-5.fc32.x86_64                                               
  libXrandr-1.5.2-3.fc32.x86_64                                                 
  libXrender-0.9.10-11.fc32.x86_64                                              
  libXtst-1.2.3-11.fc32.x86_64                                                  
  libXv-1.0.11-11.fc32.x86_64                                                   
  libXxf86vm-1.1.4-13.fc32.x86_64                                               
  libaio-0.3.111-7.fc32.x86_64                                                  
  libasyncns-0.8-18.fc32.x86_64                                                 
  libbasicobjects-0.1.1-44.fc32.x86_64                                          
  libburn-1.5.4-2.fc32.x86_64                                                   
  libcacard-3:2.7.0-4.fc32.x86_64                                               
  libcollection-0.7.0-44.fc32.x86_64                                            
  libdatrie-0.2.9-11.fc32.x86_64                                                
  libdrm-2.4.102-1.fc32.x86_64                                                  
  libepoxy-1.5.4-2.fc32.x86_64                                                  
  libev-4.31-2.fc32.x86_64                                                      
  libevent-2.1.8-8.fc32.x86_64                                                  
  libfdt-1.6.0-1.fc32.x86_64                                                    
  libglvnd-1:1.3.2-1.fc32.x86_64                                                
  libglvnd-egl-1:1.3.2-1.fc32.x86_64                                            
  libglvnd-gles-1:1.3.2-1.fc32.x86_64                                           
  libglvnd-glx-1:1.3.2-1.fc32.x86_64                                            
  libgusb-0.3.5-1.fc32.x86_64                                                   
  libibumad-33.0-2.fc32.x86_64                                                  
  libibverbs-33.0-2.fc32.x86_64                                                 
  libicu-65.1-2.fc32.x86_64                                                     
  libini_config-1.3.1-44.fc32.x86_64                                            
  libiscsi-1.18.0-9.fc32.x86_64                                                 
  libisoburn-1.5.4-2.fc32.x86_64                                                
  libisofs-1.5.4-1.fc32.x86_64                                                  
  libjpeg-turbo-2.0.4-3.fc32.x86_64                                             
  libmodman-2.0.1-21.fc32.x86_64                                                
  libnfs-4.0.0-2.fc32.x86_64                                                    
  libnfsidmap-1:2.5.3-1.fc32.x86_64                                             
  libnftnl-1.1.5-2.fc32.x86_64                                                  
  libnl3-3.5.0-2.fc32.x86_64                                                    
  libogg-2:1.3.4-2.fc32.x86_64                                                  
  libpath_utils-0.2.1-44.fc32.x86_64                                            
  libpciaccess-0.16-2.fc32.x86_64                                               
  libpmem-1.8-2.fc32.x86_64                                                     
  libpng-2:1.6.37-3.fc32.x86_64                                                 
  libproxy-0.4.15-19.fc32.x86_64                                                
  librados2-2:14.2.21-1.fc32.x86_64                                             
  librbd1-2:14.2.21-1.fc32.x86_64                                               
  librdmacm-33.0-2.fc32.x86_64                                                  
  libref_array-0.1.5-44.fc32.x86_64                                             
  libselinux-utils-3.0-5.fc32.x86_64                                            
  libslirp-4.3.1-3.fc32.x86_64                                                  
  libsndfile-1.0.31-3.fc32.x86_64                                               
  libsoup-2.70.0-1.fc32.x86_64                                                  
  libssh2-1.9.0-5.fc32.x86_64                                                   
  libtextstyle-0.21-1.fc32.x86_64                                               
  libthai-0.1.28-4.fc32.x86_64                                                  
  libtheora-1:1.1.1-25.fc32.x86_64                                              
  libtiff-4.1.0-3.fc32.x86_64                                                   
  libverto-libev-0.3.0-9.fc32.x86_64                                            
  libvirt-bash-completion-6.1.0-4.fc32.x86_64                                   
  libvirt-client-6.1.0-4.fc32.x86_64                                            
  libvirt-daemon-6.1.0-4.fc32.x86_64                                            
  libvirt-daemon-driver-qemu-6.1.0-4.fc32.x86_64                                
  libvirt-daemon-driver-storage-core-6.1.0-4.fc32.x86_64                        
  libvirt-libs-6.1.0-4.fc32.x86_64                                              
  libvisual-1:0.4.0-28.fc32.x86_64                                              
  libvorbis-1:1.3.6-6.fc32.x86_64                                               
  libwayland-client-1.18.0-1.fc32.x86_64                                        
  libwayland-cursor-1.18.0-1.fc32.x86_64                                        
  libwayland-egl-1.18.0-1.fc32.x86_64                                           
  libwayland-server-1.18.0-1.fc32.x86_64                                        
  libwebp-1.2.0-1.fc32.x86_64                                                   
  libwsman1-2.6.8-12.fc32.x86_64                                                
  libxcb-1.13.1-4.fc32.x86_64                                                   
  libxkbcommon-0.10.0-2.fc32.x86_64                                             
  libxshmfence-1.3-6.fc32.x86_64                                                
  linux-atm-libs-2.5.1-26.fc32.x86_64                                           
  lttng-ust-2.11.0-4.fc32.x86_64                                                
  lzo-2.10-2.fc32.x86_64                                                        
  lzop-1.04-3.fc32.x86_64                                                       
  mesa-libEGL-20.2.3-1.fc32.x86_64                                              
  mesa-libGL-20.2.3-1.fc32.x86_64                                               
  mesa-libgbm-20.2.3-1.fc32.x86_64                                              
  mesa-libglapi-20.2.3-1.fc32.x86_64                                            
  mozjs60-60.9.0-5.fc32.x86_64                                                  
  nfs-utils-1:2.5.3-1.fc32.x86_64                                               
  nftables-1:0.9.3-4.fc32.x86_64                                                
  nmap-ncat-2:7.80-4.fc32.x86_64                                                
  nspr-4.30.0-1.fc32.x86_64                                                     
  nss-3.63.0-1.fc32.x86_64                                                      
  nss-softokn-3.63.0-1.fc32.x86_64                                              
  nss-softokn-freebl-3.63.0-1.fc32.x86_64                                       
  nss-sysinit-3.63.0-1.fc32.x86_64                                              
  nss-util-3.63.0-1.fc32.x86_64                                                 
  numactl-libs-2.0.12-4.fc32.x86_64                                             
  numad-0.5-31.20150602git.fc32.x86_64                                          
  opus-1.3.1-3.fc32.x86_64                                                      
  orc-0.4.31-2.fc32.x86_64                                                      
  pango-1.44.7-2.fc32.x86_64                                                    
  parted-3.3-3.fc32.x86_64                                                      
  pciutils-3.7.0-3.fc32.x86_64                                                  
  pciutils-libs-3.7.0-3.fc32.x86_64                                             
  pcre2-utf32-10.36-4.fc32.x86_64                                               
  pixman-0.40.0-1.fc32.x86_64                                                   
  policycoreutils-3.0-2.fc32.x86_64                                             
  polkit-0.116-7.fc32.x86_64                                                    
  polkit-libs-0.116-7.fc32.x86_64                                               
  polkit-pkla-compat-0.1-16.fc32.x86_64                                         
  procps-ng-3.3.16-2.fc32.x86_64                                                
  psmisc-23.3-3.fc32.x86_64                                                     
  pulseaudio-libs-14.0-1.fc32.x86_64                                            
  qemu-audio-alsa-2:4.2.1-1.fc32.x86_64                                         
  qemu-audio-oss-2:4.2.1-1.fc32.x86_64                                          
  qemu-audio-pa-2:4.2.1-1.fc32.x86_64                                           
  qemu-audio-sdl-2:4.2.1-1.fc32.x86_64                                          
  qemu-block-curl-2:4.2.1-1.fc32.x86_64                                         
  qemu-block-dmg-2:4.2.1-1.fc32.x86_64                                          
  qemu-block-gluster-2:4.2.1-1.fc32.x86_64                                      
  qemu-block-iscsi-2:4.2.1-1.fc32.x86_64                                        
  qemu-block-nfs-2:4.2.1-1.fc32.x86_64                                          
  qemu-block-rbd-2:4.2.1-1.fc32.x86_64                                          
  qemu-block-ssh-2:4.2.1-1.fc32.x86_64                                          
  qemu-common-2:4.2.1-1.fc32.x86_64                                             
  qemu-img-2:4.2.1-1.fc32.x86_64                                                
  qemu-kvm-2:4.2.1-1.fc32.x86_64                                                
  qemu-system-x86-2:4.2.1-1.fc32.x86_64                                         
  qemu-system-x86-core-2:4.2.1-1.fc32.x86_64                                    
  qemu-ui-curses-2:4.2.1-1.fc32.x86_64                                          
  qemu-ui-gtk-2:4.2.1-1.fc32.x86_64                                             
  qemu-ui-sdl-2:4.2.1-1.fc32.x86_64                                             
  qemu-ui-spice-app-2:4.2.1-1.fc32.x86_64                                       
  quota-1:4.05-10.fc32.x86_64                                                   
  quota-nls-1:4.05-10.fc32.noarch                                               
  rdma-core-33.0-2.fc32.x86_64                                                  
  rest-0.8.1-7.fc32.x86_64                                                      
  rpcbind-1.2.5-5.rc1.fc32.1.x86_64                                             
  rpm-plugin-selinux-4.15.1.1-1.fc32.1.x86_64                                   
  seabios-bin-1.13.0-2.fc32.noarch                                              
  seavgabios-bin-1.13.0-2.fc32.noarch                                           
  selinux-policy-3.14.5-46.fc32.noarch                                          
  selinux-policy-targeted-3.14.5-46.fc32.noarch                                 
  sgabios-bin-1:0.20180715git-4.fc32.noarch                                     
  shared-mime-info-1.15-3.fc32.x86_64                                           
  snappy-1.1.8-2.fc32.x86_64                                                    
  spice-server-0.14.3-1.fc32.x86_64                                             
  systemd-container-245.9-1.fc32.x86_64                                         
  unbound-libs-1.10.1-1.fc32.x86_64                                             
  usbredir-0.9.0-1.fc32.x86_64                                                  
  userspace-rcu-0.11.1-3.fc32.x86_64                                            
  virglrenderer-0.8.2-1.20200212git7d204f39.fc32.x86_64                         
  vte-profile-0.60.4-1.fc32.x86_64                                              
  vte291-0.60.4-1.fc32.x86_64                                                   
  xen-libs-4.13.3-1.fc32.x86_64                                                 
  xen-licenses-4.13.3-1.fc32.x86_64                                             
  xkeyboard-config-2.29-1.fc32.noarch                                           
  xml-common-0.6.3-54.fc32.noarch                                               
  xorriso-1.5.4-2.fc32.x86_64                                                   
  xz-5.2.5-1.fc32.x86_64                                                        
  yajl-2.1.0-14.fc32.x86_64                                                     

Complete!
Last metadata expiration check: 0:01:31 ago on Fri Jul 22 05:23:22 2022.
Dependencies resolved.
Nothing to do.
Complete!
42 files removed
--> c7f65106054
STEP 4/5: COPY augconf /augconf
--> a1849632a16
STEP 5/5: RUN augtool -f /augconf
Saved 3 file(s)
COMMIT localhost:5000/my-libvirt:20210819-f506def.amd64
--> e73664d2e89
[Warning] one or more build args were not consumed: [TARGETARCH TARGETOS TARGETPLATFORM]
Successfully tagged localhost:5000/my-libvirt:20210819-f506def.amd64
e73664d2e89faa6ce9b6a0a88ccefba9ceed8cf6ab84e3c4d8846199d5aa35b3
+ push_container localhost:5000/my-libvirt:20210819-f506def.amd64 linux/amd64 BUILDER_BUILDX PUSH_DOCKER
+ local tag=localhost:5000/my-libvirt:20210819-f506def.amd64
+ local platform=linux/amd64
+ local builder=BUILDER_BUILDX
+ local push=PUSH_DOCKER
+ case "${push}" in
+ push_arg=--load
+ case "${builder}" in
+ docker buildx build --progress=plain --load --platform=linux/amd64 --tag localhost:5000/my-libvirt:20210819-f506def.amd64 .
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
STEP 1/5: FROM fedora:32
STEP 2/5: LABEL maintainer="The KubeVirt Project <kubevirt-dev@googlegroups.com>"
--> Using cache 0575ea56c7432bf12843743788fcfe70982bd552b89bc660aa587dba5dd34265
--> 0575ea56c74
STEP 3/5: RUN dnf install -y dnf-plugins-core &&     dnf install -y         libvirt-daemon-driver-qemu         libvirt-client         libvirt-daemon-driver-storage-core         qemu-kvm         seabios-bin         seavgabios-bin         xorriux-policy selinux-policy-targeted         nftables         iptables         procps-ng         findutils         augeas &&     dnf update -y libgcrypt &&     dnf clean all &&     for qemu in         /usr/bin/qemu-system-aarch64         /usr/bic64         /usr/bin/qemu-system-s390x         /usr/bin/qemu-system-x86_64         /usr/libexec/qemu-kvm;     do         test -f "$qemu" || continue;         setcap CAP_NET_BIND_SERVICE=+eip "$qemu" &&         break;     done
--> Using cache c7f65106054c1ae0599e581e6b671af8d6398450f866c1908559c093c78092e2
--> c7f65106054
STEP 4/5: COPY augconf /augconf
--> Using cache a1849632a16308a0c29542b96cd022bb352a8dbd3cd12a3900194d5aaf8ebb6c
--> a1849632a16
STEP 5/5: RUN augtool -f /augconf
--> Using cache e73664d2e89faa6ce9b6a0a88ccefba9ceed8cf6ab84e3c4d8846199d5aa35b3
COMMIT localhost:5000/my-libvirt:20210819-f506def.amd64
--> e73664d2e89
[Warning] one or more build args were not consumed: [TARGETARCH TARGETOS TARGETPLATFORM]
Successfully tagged localhost:5000/my-libvirt:20210819-f506def.amd64
e73664d2e89faa6ce9b6a0a88ccefba9ceed8cf6ab84e3c4d8846199d5aa35b3
+ test_container localhost:5000/my-libvirt:20210819-f506def.amd64 linux/amd64 BUILDER_BUILDX PUSH_DOCKER
+ local tag=localhost:5000/my-libvirt:20210819-f506def.amd64
+ local platform=linux/amd64
+ local builder=BUILDER_BUILDX
+ local push=PUSH_DOCKER
+ docker run --rm --platform=linux/amd64 localhost:5000/my-libvirt:20210819-f506def.amd64 uname -m
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
x86_64
+ docker run --rm --platform=linux/amd64 localhost:5000/my-libvirt:20210819-f506def.amd64 libvirtd --version
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
libvirtd (libvirt) 6.1.0
+ docker run --rm --platform=linux/amd64 localhost:5000/my-libvirt:20210819-f506def.amd64 sh -c '
               set -e; \
               for qemu in \
                   /usr/bin/qemu-system-aarch64 \
                   /usr/bin/qemu-system-ppc64 \
                   /usr/bin/qemu-system-s390x \
                   /usr/bin/qemu-system-x86_64 \
                   /usr/libexec/qemu-kvm; \
               do \
                   test -f "$qemu" || continue; \
                   "$qemu" --version && break; \
               done
           '
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
QEMU emulator version 4.2.1 (qemu-4.2.1-1.fc32)
Copyright (c) 2003-2019 Fabrice Bellard and the QEMU Project developers
+ delete_container localhost:5000/my-libvirt:20210819-f506def.amd64 linux/amd64 BUILDER_BUILDX PUSH_DOCKER
+ local tag=localhost:5000/my-libvirt:20210819-f506def.amd64
+ local platform=linux/amd64
+ local builder=BUILDER_BUILDX
+ local push=PUSH_DOCKER
+ case "${push}" in
+ docker rmi localhost:5000/my-libvirt:20210819-f506def.amd64
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Untagged: localhost:5000/my-libvirt:20210819-f506def.amd64
Deleted: e73664d2e89faa6ce9b6a0a88ccefba9ceed8cf6ab84e3c4d8846199d5aa35b3
Deleted: a1849632a16308a0c29542b96cd022bb352a8dbd3cd12a3900194d5aaf8ebb6c
Deleted: c7f65106054c1ae0599e581e6b671af8d6398450f866c1908559c093c78092e2
Deleted: 0575ea56c7432bf12843743788fcfe70982bd552b89bc660aa587dba5dd34265
```