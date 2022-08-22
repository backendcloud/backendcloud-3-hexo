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

```bash
# docker run libvirt-build container
docker volume create rpms
docker run -td -w /libvirt-src --security-opt label=disable --name libvirt-build -v $(pwd):/libvirt-src -v rpms:/root/rpmbuild/RPMS registry.gitlab.com/libvirt/libvirt/ci-centos-stream-8
docker exec -it libvirt-build bash
mkdir build
cd build
../autogen.sh 
make
# 若要构建rpm
rpmbuild -ba libvirt.spec
# 执行完后可以在/root/rpmbuild/RPMS查看生成的rpm包，执行createrepo创建rpm索引
# 若要安装
make install
```

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

# 替换qemu类似

```bash
make CUSTOM_REPO=rpm/custom-repo.yaml QEMU_VERSION=15:4.2.0-29.15.el8_2.bclinux.7 SINGLE_ARCH="x86_64" rpm-deps 
```

## 验证

```bash
kubectl apply -f https://kubevirt.io/labs/manifests/vm.yaml
virtctl start testvm
```

```bash
 ⚡ root@centos9  ~/my-github/kubevirt   release-0.53 ±  make && make push && make manifests
 ⚡ root@centos9  ~/my-github/kubevirt   release-0.53 ±  kubectl create -f _out/manifests/release/kubevirt-operator.yaml
 ⚡ root@centos9  ~/my-github/kubevirt   release-0.53 ±  kubectl create -f _out/manifests/release/kubevirt-cr.yaml
 ⚡ root@centos9  ~/my-github/kubevirt   release-0.53 ±  kubectl get pod -A
NAMESPACE            NAME                                         READY   STATUS    RESTARTS   AGE
default              virt-launcher-testvm-wqgt5                   2/2     Running   0          4m23s
kube-system          coredns-6d4b75cb6d-gdkmf                     1/1     Running   0          19h
kube-system          coredns-6d4b75cb6d-rxgdr                     1/1     Running   0          19h
kube-system          etcd-kind-control-plane                      1/1     Running   0          19h
kube-system          kindnet-9nxgd                                1/1     Running   0          19h
kube-system          kube-apiserver-kind-control-plane            1/1     Running   0          19h
kube-system          kube-controller-manager-kind-control-plane   1/1     Running   0          19h
kube-system          kube-proxy-n9cp4                             1/1     Running   0          19h
kube-system          kube-scheduler-kind-control-plane            1/1     Running   0          19h
kubevirt             virt-api-5c4989cb59-2pccn                    1/1     Running   0          82m
kubevirt             virt-api-5c4989cb59-kp448                    1/1     Running   0          82m
kubevirt             virt-controller-9dbc6fdb4-7nmwj              1/1     Running   0          78m
kubevirt             virt-controller-9dbc6fdb4-k8zp4              1/1     Running   0          78m
kubevirt             virt-handler-v8mkd                           1/1     Running   0          78m
kubevirt             virt-operator-548486b468-8h9cd               1/1     Running   0          83m
kubevirt             virt-operator-548486b468-cjkts               1/1     Running   0          83m
local-path-storage   local-path-provisioner-9cd9bd544-mzsb8       1/1     Running   0          19h
 ⚡ root@centos9  ~/my-github/kubevirt   release-0.53 ±  kubectl apply -f https://kubevirt.io/labs/manifests/vm.yaml
 ⚡ root@centos9  ~/my-github/kubevirt   release-0.53 ±  virtctl start testvm
 ⚡ root@centos9  ~/my-github/kubevirt   release-0.53 ±  kubectl get vmi
NAME     AGE   PHASE     IP            NODENAME             READY
testvm   93m   Running   10.244.0.62   kind-control-plane   True
 ⚡ root@centos9  ~/my-github/kubevirt   release-0.53 ±  kubectl get pod                                    
NAME                         READY   STATUS    RESTARTS   AGE
virt-launcher-testvm-wqgt5   2/2     Running   0          3m43s
 ⚡ root@centos9  ~/my-github/kubevirt   release-0.53 ±  kubectl exec -it virt-launcher-testvm-wqgt5 -- bash
bash-4.4# qemu-img -V
qemu-img version 4.2.0 (qemu-kvm-4.2.0-29.15.el8_2.bclinux.7)
Copyright (c) 2003-2019 Fabrice Bellard and the QEMU Project developers
bash-4.4# exit
 ⚡ root@centos9  ~/my-github/kubevirt   release-0.53 ±  kubectl delete vms testvm
```

# 目前kubevirt官方用的是8.0.0，替换libvirt到低版本6.0.0遇到了几个坑

## kubevirt部署阶段报错：virt-launcher pod初始化阶段报错 unknown feature amd-sev-es

virt-launcher pod初始化会启动一个virt-launtcher container，这个阶段报错如下：

```bash
⚡ root@centos9  ~  kubectl get pod -A
NAMESPACE            NAME                                         READY   STATUS                  RESTARTS        AGE
kube-system          coredns-6d4b75cb6d-gdkmf                     1/1     Running                 0               2d13h
kube-system          coredns-6d4b75cb6d-rxgdr                     1/1     Running                 0               2d13h
kube-system          etcd-kind-control-plane                      1/1     Running                 0               2d13h
kube-system          kindnet-9nxgd                                1/1     Running                 0               2d13h
kube-system          kube-apiserver-kind-control-plane            1/1     Running                 0               2d13h
kube-system          kube-controller-manager-kind-control-plane   1/1     Running                 6 (25m ago)     2d13h
kube-system          kube-proxy-n9cp4                             1/1     Running                 0               2d13h
kube-system          kube-scheduler-kind-control-plane            1/1     Running                 5 (27m ago)     2d13h
kubevirt             virt-api-85d7dd8964-fzrrk                    1/1     Running                 0               35h
kubevirt             virt-api-85d7dd8964-scsn6                    1/1     Running                 0               35h
kubevirt             virt-controller-7cf7978d86-978nn             1/1     Running                 4 (27m ago)     35h
kubevirt             virt-controller-7cf7978d86-jbq8r             1/1     Running                 2 (25m ago)     35h
kubevirt             virt-handler-jr9nv                           0/1     Init:CrashLoopBackOff   415 (43s ago)   35h
kubevirt             virt-operator-689fcf46b5-88x9b               1/1     Running                 4 (27m ago)     35h
kubevirt             virt-operator-689fcf46b5-wzwmx               1/1     Running                 2 (38m ago)     35h
local-path-storage   local-path-provisioner-9cd9bd544-mzsb8       1/1     Running                 0               2d13h
 ⚡ root@centos9  ~  kubectl logs -n kubevirt virt-handler-jr9nv -c virt-launcher
error: failed to get emulator capabilities
error: internal error: unknown feature amd-sev-es
 ⚡ root@centos9  ~  kubectl logs -n kubevirt virt-handler-jr9nv                 
Defaulted container "virt-handler" out of: virt-handler, virt-launcher (init)
Error from server (BadRequest): container "virt-handler" in pod "virt-handler-jr9nv" is waiting to start: PodInitializing
```

原因： Open Virtual Machine Firmware 和 libvirt 不兼容。

对策：libvirt6.0.0 版本太老了，替换个老版本的 Open Virtual Machine Firmware 即可。

## kubevirt部署成功，启动vm报错 virt-handler server error. command SyncVMI failed: "LibvirtError(Code=38, Domain=0, Message='Cannot set interface MTU on 'tap0': Operation not permitted')"

部署kubevirt
```bash
make CUSTOM_REPO=rpm/custom-repo.yaml QEMU_VERSION=15:4.2.0-29.15.el8_2.bclinux.7 LIBVIRT_VERSION=0:6.0.0-25.19.el8_2.bclinux EDK2_VERSION=0:20200602gitca407c7246bf-4.el8 LIBGUESTFS_VERSION=1:1.40.2-27.module_el8.5.0+746+bbd5d70c SINGLE_ARCH="x86_64" rpm-deps
make && make push && make manifests
kubectl create -f _out/manifests/release/kubevirt-operator.yaml
kubectl create -f _out/manifests/release/kubevirt-cr.yaml
```

创建虚拟机
```bash
kubectl apply -f https://kubevirt.io/labs/manifests/vm.yaml
virtctl start testvm
```

虚拟机一直处于调度状态，登录virt-launtcher pod 执行virsh list --all发现vm没有启动成功，看了下libvert qemu日志没有啥有用的信息。describe virt-launtcher pod 发现如下信息：
```bash
Events:
  Type     Reason            Age                   From                       Message
  ----     ------            ----                  ----                       -------
  Normal   SuccessfulCreate  2m49s                 virtualmachine-controller  Created virtual machine pod virt-launcher-testvm-grxs5
  Warning  SyncFailed        79s (x16 over 2m42s)  virt-handler               server error. command SyncVMI failed: "LibvirtError(Code=38, Domain=0, Message='Cannot set interface MTU on 'tap0': Operation not permitted')"
```

不确定，就是感觉是下面的原因： 新版本的libvirt已经修复  Patches have been pushed upstream to support an unprivileged libvirtd using pre-created standard tap and macvtap devices

https://bugzilla.redhat.com/show_bug.cgi?id=1905929

https://bugzilla.redhat.com/show_bug.cgi?id=1723367

> kubevirt就别用libvirt6.0.0了，官方就没支持过，问题层出不穷。可以考虑替换官方支持过的版本或者和官方跨度不大的版本或者更高的版本，就别用老掉牙的老版本了。
