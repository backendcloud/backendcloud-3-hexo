---
title: KubeVirt替换virt-lantch中的libvirt的版本(高版本到低版本)
readmore: true
date: 2022-08-16 13:20:25
categories: 云原生
tags:
- KubeVirtCI
- KubeVirt
---

KubeVirt替换virt-lantch中的libvirt的版本 参考之前发布的文章{% post_link kubevirt-replace-libvirt %}

上面的文章是替换到更高的版本，替换高版本比较简单，直接加上yum repo，但有时候需要替换成低版本的libvirt，可能会遇到些坑。

# 下面用 replace libvirt v8.0.0 to v6.0.0 举例

> 编译 Libvirt 源码 并 创建yum源 参考之前发布的文章 {% post_link libvirt-compile %} (v6.0.0 的编译 自行 google)

## custom-repo.yaml 需要加上 libvirt v6.0.0 的yum源 以及epel

```bash
[root@kubevirtci kubevirt]# cat rpm/custom-repo.yaml 
repositories:
- arch: x86_64
  baseurl: http://10.88.0.65/x86_64/ # The IP corrisponds to the rpms-http-server container
  name: custom-build-x86_64
  gpgcheck: 0
  repo_gpgcheck: 0
  disabled: true
- arch: x86_64
  baseurl: https://kartolo.sby.datautama.net.id/EPEL/8/Everything/x86_64/
  name: centos/epel-x86_64
    #gpgkey: https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
- arch: aarch64
  baseurl: https://kartolo.sby.datautama.net.id/EPEL/8/Everything/aarch64/
  name: centos/epel-aarch64
    #gpgkey: https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
```

## hack/rpm-deps.sh 需要添加以下yum install

```bash
[root@kubevirtci kubevirt]# more hack/rpm-deps.sh 
...
centos_base="
  acl
  curl
  vim-minimal
  libcap-ng
  yajl
  libnl3
  audit-libs
  device-mapper-libs
  numactl-libs
  libxml2
  glib2
  cyrus-sasl-lib
  libssh
"
...
```

## 替换 rpm

```bash
make CUSTOM_REPO=rpm/custom-repo.yaml LIBVIRT_VERSION=0:6.0.0-1.el8 SINGLE_ARCH="x86_64" rpm-deps
```

## after replace libvirt v8.0.0 to v6.0.0 build kubevirt process ok：

```bash
[root@kubevirtci kubevirt]# make
./hack/dockerized "hack/bazel-fmt.sh"
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
go version go1.17.8 linux/amd64
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.

Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
go version go1.17.8 linux/amd64
Sandbox is up to date
INFO: Analyzed target //vendor/mvdan.cc/sh/v3/cmd/shfmt:shfmt (75 packages loaded, 8347 targets configured).
INFO: Found 1 target...
Target //vendor/mvdan.cc/sh/v3/cmd/shfmt:shfmt up-to-date:
  bazel-bin/vendor/mvdan.cc/sh/v3/cmd/shfmt/shfmt_/shfmt
INFO: Elapsed time: 4.134s, Critical Path: 2.46s
INFO: 53 processes: 4 internal, 49 processwrapper-sandbox.
INFO: Build completed successfully, 53 total actions
INFO: Build completed successfully, 53 total actions
INFO: Analyzed target //:gazelle (35 packages loaded, 301 targets configured).
INFO: Found 1 target...
Target //:gazelle up-to-date:
  bazel-bin/gazelle-runner.bash
  bazel-bin/gazelle
INFO: Elapsed time: 13.118s, Critical Path: 12.68s
INFO: 52 processes: 12 internal, 40 processwrapper-sandbox.
INFO: Build completed successfully, 52 total actions
INFO: Build completed successfully, 52 total actions
INFO: Analyzed target //:goimports (10 packages loaded, 117 targets configured).
INFO: Found 1 target...
Target //:goimports up-to-date:
  bazel-bin/goimports.bash
INFO: Elapsed time: 1.203s, Critical Path: 1.01s
INFO: 16 processes: 4 internal, 12 processwrapper-sandbox.
INFO: Build completed successfully, 16 total actions
INFO: Build completed successfully, 16 total actions
INFO: Analyzed target //:buildifier (62 packages loaded, 291 targets configured).
INFO: Found 1 target...
Target //:buildifier up-to-date:
  bazel-bin/buildifier.bash
INFO: Elapsed time: 4.875s, Critical Path: 4.51s
INFO: 77 processes: 8 internal, 69 processwrapper-sandbox.
INFO: Build completed successfully, 77 total actions
INFO: Build completed successfully, 77 total actions
hack/dockerized "export BUILD_ARCH= && export DOCKER_TAG= && hack/bazel-fmt.sh && hack/bazel-build.sh"
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
go version go1.17.8 linux/amd64
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.

Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
go version go1.17.8 linux/amd64
Sandbox is up to date
INFO: Analyzed target //vendor/mvdan.cc/sh/v3/cmd/shfmt:shfmt (75 packages loaded, 8347 targets configured).
INFO: Found 1 target...
Target //vendor/mvdan.cc/sh/v3/cmd/shfmt:shfmt up-to-date:
  bazel-bin/vendor/mvdan.cc/sh/v3/cmd/shfmt/shfmt_/shfmt
INFO: Elapsed time: 1.433s, Critical Path: 0.31s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:gazelle (35 packages loaded, 301 targets configured).
INFO: Found 1 target...
Target //:gazelle up-to-date:
  bazel-bin/gazelle-runner.bash
  bazel-bin/gazelle
INFO: Elapsed time: 0.330s, Critical Path: 0.05s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:goimports (10 packages loaded, 44 targets configured).
INFO: Found 1 target...
Target //:goimports up-to-date:
  bazel-bin/goimports.bash
INFO: Elapsed time: 0.167s, Critical Path: 0.05s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:buildifier (62 packages loaded, 291 targets configured).
INFO: Found 1 target...
Target //:buildifier up-to-date:
  bazel-bin/buildifier.bash
INFO: Elapsed time: 0.222s, Critical Path: 0.07s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
Sandbox is up to date
INFO: Analyzed 94 targets (1322 packages loaded, 12134 targets configured).
INFO: Found 94 targets...
INFO: From Converting handlerbase_x86_64 to tar:
Flag shorthand -s has been deprecated, use --symlinks instead
INFO: From ImageLayer cmd/virt-handler/version-container-layer.tar:
Duplicate file in archive: ./etc/nsswitch.conf, picking first occurrence
Duplicate file in archive: ./etc/ethertypes, picking first occurrence
Duplicate file in archive: ./etc/group, picking first occurrence
Duplicate file in archive: ./etc/passwd, picking first occurrence
Duplicate file in archive: ./usr/share/licenses/systemd/LICENSE.LGPL2.1, picking first occurrence
INFO: From GoLink cmd/virt-controller/virt-controller_/virt-controller:
/tmp/go-link-4030436256/000020.o: In function `mygetgrouplist':
/usr/local/go/src/os/user/getgrouplist_unix.go:18: warning: Using 'getgrouplist' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-4030436256/000019.o: In function `mygetgrgid_r':
/usr/local/go/src/os/user/cgo_lookup_unix.go:40: warning: Using 'getgrgid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-4030436256/000019.o: In function `mygetgrnam_r':
/usr/local/go/src/os/user/cgo_lookup_unix.go:45: warning: Using 'getgrnam_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-4030436256/000019.o: In function `mygetpwnam_r':
/usr/local/go/src/os/user/cgo_lookup_unix.go:35: warning: Using 'getpwnam_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-4030436256/000019.o: In function `mygetpwuid_r':
/usr/local/go/src/os/user/cgo_lookup_unix.go:30: warning: Using 'getpwuid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-4030436256/000004.o: In function `_cgo_3c1cec0c9a4e_C2func_getaddrinfo':
/tmp/go-build/cgo-gcc-prolog:58: warning: Using 'getaddrinfo' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
INFO: From GoLink cmd/subresource-access-test/subresource-access-test_/subresource-access-test:
/tmp/go-link-3741595657/000020.o: In function `mygetgrouplist':
/usr/local/go/src/os/user/getgrouplist_unix.go:18: warning: Using 'getgrouplist' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-3741595657/000019.o: In function `mygetgrgid_r':
/usr/local/go/src/os/user/cgo_lookup_unix.go:40: warning: Using 'getgrgid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-3741595657/000019.o: In function `mygetgrnam_r':
/usr/local/go/src/os/user/cgo_lookup_unix.go:45: warning: Using 'getgrnam_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-3741595657/000019.o: In function `mygetpwnam_r':
/usr/local/go/src/os/user/cgo_lookup_unix.go:35: warning: Using 'getpwnam_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-3741595657/000019.o: In function `mygetpwuid_r':
/usr/local/go/src/os/user/cgo_lookup_unix.go:30: warning: Using 'getpwuid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-3741595657/000004.o: In function `_cgo_3c1cec0c9a4e_C2func_getaddrinfo':
/tmp/go-build/cgo-gcc-prolog:58: warning: Using 'getaddrinfo' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
INFO: From GoLink cmd/virt-api/virt-api_/virt-api:
/tmp/go-link-958141265/000020.o: In function `mygetgrouplist':
/usr/local/go/src/os/user/getgrouplist_unix.go:18: warning: Using 'getgrouplist' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-958141265/000019.o: In function `mygetgrgid_r':
/usr/local/go/src/os/user/cgo_lookup_unix.go:40: warning: Using 'getgrgid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-958141265/000019.o: In function `mygetgrnam_r':
/usr/local/go/src/os/user/cgo_lookup_unix.go:45: warning: Using 'getgrnam_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-958141265/000019.o: In function `mygetpwnam_r':
/usr/local/go/src/os/user/cgo_lookup_unix.go:35: warning: Using 'getpwnam_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-958141265/000019.o: In function `mygetpwuid_r':
/usr/local/go/src/os/user/cgo_lookup_unix.go:30: warning: Using 'getpwuid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-958141265/000004.o: In function `_cgo_3c1cec0c9a4e_C2func_getaddrinfo':
/tmp/go-build/cgo-gcc-prolog:58: warning: Using 'getaddrinfo' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
INFO: From GoLink cmd/virt-operator/virt-operator_/virt-operator:
/tmp/go-link-2076511816/000020.o: In function `mygetgrouplist':
/usr/local/go/src/os/user/getgrouplist_unix.go:18: warning: Using 'getgrouplist' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-2076511816/000019.o: In function `mygetgrgid_r':
/usr/local/go/src/os/user/cgo_lookup_unix.go:40: warning: Using 'getgrgid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-2076511816/000019.o: In function `mygetgrnam_r':
/usr/local/go/src/os/user/cgo_lookup_unix.go:45: warning: Using 'getgrnam_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-2076511816/000019.o: In function `mygetpwnam_r':
/usr/local/go/src/os/user/cgo_lookup_unix.go:35: warning: Using 'getpwnam_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-2076511816/000019.o: In function `mygetpwuid_r':
/usr/local/go/src/os/user/cgo_lookup_unix.go:30: warning: Using 'getpwuid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/tmp/go-link-2076511816/000004.o: In function `_cgo_3c1cec0c9a4e_C2func_getaddrinfo':
/tmp/go-build/cgo-gcc-prolog:58: warning: Using 'getaddrinfo' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
INFO: From Converting libguestfs-tools to tar:
Flag shorthand -s has been deprecated, use --symlinks instead
INFO: From ImageLayer cmd/libguestfs/version-container-layer.tar:
Duplicate file in archive: ./usr/share/licenses/systemd/LICENSE.LGPL2.1, picking first occurrence
Duplicate file in archive: ./usr/share/doc/xz/COPYING, picking first occurrence
INFO: From Converting launcherbase_x86_64 to tar:
Flag shorthand -s has been deprecated, use --symlinks instead
INFO: From ImageLayer cmd/virt-launcher/version-container-layer.tar:
Duplicate file in archive: ./etc/nsswitch.conf, picking first occurrence
Duplicate file in archive: ./etc/libvirt/libvirtd.conf, picking first occurrence
Duplicate file in archive: ./etc/libvirt/qemu.conf, picking first occurrence
Duplicate file in archive: ./etc/ethertypes, picking first occurrence
Duplicate file in archive: ./etc/group, picking first occurrence
Duplicate file in archive: ./etc/passwd, picking first occurrence
Duplicate file in archive: ./usr/share/licenses/systemd/LICENSE.LGPL2.1, picking first occurrence
Duplicate file in archive: ./usr/share/doc/xz/COPYING, picking first occurrence
INFO: Elapsed time: 378.275s, Critical Path: 59.26s
INFO: 4135 processes: 298 internal, 3837 processwrapper-sandbox.
INFO: Build completed successfully, 4135 total actions
INFO: Analyzed target //:build-dump (0 packages loaded, 1 target configured).
INFO: Found 1 target...
Target //:build-dump up-to-date:
  bazel-bin/dump-copier
INFO: Elapsed time: 0.498s, Critical Path: 0.11s
INFO: 2 processes: 1 internal, 1 processwrapper-sandbox.
INFO: Build completed successfully, 2 total actions
INFO: Build completed successfully, 2 total actions
INFO: Analyzed target //:build-perfscale-audit (0 packages loaded, 1 target configured).
INFO: Found 1 target...
Target //:build-perfscale-audit up-to-date:
  bazel-bin/perfscale-audit-copier
INFO: Elapsed time: 0.311s, Critical Path: 0.05s
INFO: 2 processes: 1 internal, 1 processwrapper-sandbox.
INFO: Build completed successfully, 2 total actions
INFO: Build completed successfully, 2 total actions
INFO: Analyzed target //:build-perfscale-load-generator (0 packages loaded, 1 target configured).
INFO: Found 1 target...
Target //:build-perfscale-load-generator up-to-date:
  bazel-bin/perfscale-load-generator-copier
INFO: Elapsed time: 0.311s, Critical Path: 0.05s
INFO: 2 processes: 1 internal, 1 processwrapper-sandbox.
INFO: Build completed successfully, 2 total actions
INFO: Build completed successfully, 2 total actions
INFO: Analyzed target //:build-cluster-profiler (0 packages loaded, 1 target configured).
INFO: Found 1 target...
Target //:build-cluster-profiler up-to-date:
  bazel-bin/cluster-profiler-copier
INFO: Elapsed time: 0.303s, Critical Path: 0.05s
INFO: 2 processes: 1 internal, 1 processwrapper-sandbox.
INFO: Build completed successfully, 2 total actions
INFO: Build completed successfully, 2 total actions
INFO: Analyzed target //:build-virtctl (0 packages loaded, 1 target configured).
INFO: Found 1 target...
Target //:build-virtctl up-to-date:
  bazel-bin/virtctl-copier
INFO: Elapsed time: 0.273s, Critical Path: 0.06s
INFO: 2 processes: 1 internal, 1 processwrapper-sandbox.
INFO: Build completed successfully, 2 total actions
INFO: Build completed successfully, 2 total actions
INFO: Analyzed target //:build-virtctl-amd64 (0 packages loaded, 1 target configured).
INFO: Found 1 target...
Target //:build-virtctl-amd64 up-to-date:
  bazel-bin/virtctl-copier-amd64
INFO: Elapsed time: 0.336s, Critical Path: 0.06s
INFO: 2 processes: 1 internal, 1 processwrapper-sandbox.
INFO: Build completed successfully, 2 total actions
INFO: Build completed successfully, 2 total actions
INFO: Analyzed target //:build-virtctl-darwin (0 packages loaded, 1 target configured).
INFO: Found 1 target...
Target //:build-virtctl-darwin up-to-date:
  bazel-bin/virtctl-copier-darwin
INFO: Elapsed time: 0.277s, Critical Path: 0.05s
INFO: 2 processes: 1 internal, 1 processwrapper-sandbox.
INFO: Build completed successfully, 2 total actions
INFO: Build completed successfully, 2 total actions
INFO: Analyzed target //:build-virtctl-windows (0 packages loaded, 1 target configured).
INFO: Found 1 target...
Target //:build-virtctl-windows up-to-date:
  bazel-bin/virtctl-copier-windows
INFO: Elapsed time: 0.306s, Critical Path: 0.05s
INFO: 2 processes: 1 internal, 1 processwrapper-sandbox.
INFO: Build completed successfully, 2 total actions
INFO: Build completed successfully, 2 total actions
hack/manifests.sh
Building manifests...
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
go version go1.17.8 linux/amd64
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.

Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
go version go1.17.8 linux/amd64
Sandbox is up to date
INFO: Analyzed target //:build-manifest-templator (637 packages loaded, 12017 targets configured).
INFO: Found 1 target...
Target //:build-manifest-templator up-to-date:
  bazel-bin/manifest-templator-copier
INFO: Elapsed time: 5.949s, Critical Path: 2.94s
INFO: 26 processes: 1 internal, 25 processwrapper-sandbox.
INFO: Build completed successfully, 26 total actions
INFO: Build completed successfully, 26 total actions
digest files not found: won't use shasums, falling back to tags
Done hack/manifests.sh
[root@kubevirtci kubevirt]#
```
