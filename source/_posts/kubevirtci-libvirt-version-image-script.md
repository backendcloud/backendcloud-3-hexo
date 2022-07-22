---
title: 打包指定libvirt版本的镜像脚本
readmore: true
date: 2022-07-22 18:42:23
categories: 云原生
tags:
- KubeVirt CI
---

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

比如修改libvirt的配置文件

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

```text
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
#时间戳和commit号的组合做i为tag
IMAGE_TAG="${GIT_TIMESTAMP}-${GIT_COMMIT}"
#在每一个以空格分开的架构前加上linux/
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