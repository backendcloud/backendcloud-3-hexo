---
title: KubeVirt重新打包部署流程
readmore: true
date: 2022-06-22 18:27:37
categories: 云原生
tags:
- make
- KubeVirt
---

修改KubeVirt的源码后需要重新部署，流程是：打包编译，生成docker image，push到镜像仓库，用生成的镜像部署到Kubernetes上。
* make 打包编译
* make push 上传镜像至镜像仓库
* make manifests 生成kubevirt-operator.yaml和kubevirt-operator.yaml两个文件用于部署

部署KubeVirt很简单，两条命令

    kubectl create -f kubevirt-operator.yaml
    kubectl create -f kubevirt-cr.yaml

配置push的镜像仓库和tag，镜像仓库用docker hub的自己的账号backendcloud。

    export DOCKER_PREFIX=backendcloud
    export DOCKER_TAG=mybuild5

> os：centos7 容器环境：docker跑成功。os：用最新的centos stream 9，容器环境：用Podman代替docker，跑了几次才成功，看了下报错，都是网络问题导致。大家都懂的国内网络原因。
>
> 以下是用centos stream 9，podman 执行make && make push && make manifests的日志

```bash
[root@centos9 kubevirt]# make && make push && make manifests
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
INFO: Elapsed time: 1.151s, Critical Path: 0.20s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:gazelle (35 packages loaded, 301 targets configured).
INFO: Found 1 target...
Target //:gazelle up-to-date:
  bazel-bin/gazelle-runner.bash
  bazel-bin/gazelle
INFO: Elapsed time: 0.282s, Critical Path: 0.06s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:goimports (10 packages loaded, 44 targets configured).
INFO: Found 1 target...
Target //:goimports up-to-date:
  bazel-bin/goimports.bash
INFO: Elapsed time: 0.132s, Critical Path: 0.03s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:buildifier (62 packages loaded, 291 targets configured).
INFO: Found 1 target...
Target //:buildifier up-to-date:
  bazel-bin/buildifier.bash
INFO: Elapsed time: 0.142s, Critical Path: 0.04s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
hack/dockerized "export BUILD_ARCH= && export DOCKER_TAG=mybuild5 && hack/bazel-fmt.sh && hack/bazel-build.sh"
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
INFO: Elapsed time: 1.151s, Critical Path: 0.29s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:gazelle (35 packages loaded, 301 targets configured).
INFO: Found 1 target...
Target //:gazelle up-to-date:
  bazel-bin/gazelle-runner.bash
  bazel-bin/gazelle
INFO: Elapsed time: 0.226s, Critical Path: 0.04s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:goimports (10 packages loaded, 44 targets configured).
INFO: Found 1 target...
Target //:goimports up-to-date:
  bazel-bin/goimports.bash
INFO: Elapsed time: 0.167s, Critical Path: 0.03s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:buildifier (62 packages loaded, 291 targets configured).
INFO: Found 1 target...
Target //:buildifier up-to-date:
  bazel-bin/buildifier.bash
INFO: Elapsed time: 0.147s, Critical Path: 0.04s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
Sandbox is up to date
INFO: Analyzed 94 targets (1322 packages loaded, 12133 targets configured).
INFO: Found 94 targets...
INFO: Elapsed time: 5.183s, Critical Path: 0.13s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:build-dump (0 packages loaded, 1 target configured).
INFO: Found 1 target...
Target //:build-dump up-to-date:
  bazel-bin/dump-copier
INFO: Elapsed time: 0.283s, Critical Path: 0.03s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:build-perfscale-audit (0 packages loaded, 1 target configured).
INFO: Found 1 target...
Target //:build-perfscale-audit up-to-date:
  bazel-bin/perfscale-audit-copier
INFO: Elapsed time: 0.240s, Critical Path: 0.04s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:build-perfscale-load-generator (0 packages loaded, 1 target configured).
INFO: Found 1 target...
Target //:build-perfscale-load-generator up-to-date:
  bazel-bin/perfscale-load-generator-copier
INFO: Elapsed time: 0.252s, Critical Path: 0.03s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:build-cluster-profiler (0 packages loaded, 1 target configured).
INFO: Found 1 target...
Target //:build-cluster-profiler up-to-date:
  bazel-bin/cluster-profiler-copier
INFO: Elapsed time: 0.271s, Critical Path: 0.04s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:build-virtctl (0 packages loaded, 1 target configured).
INFO: Found 1 target...
Target //:build-virtctl up-to-date:
  bazel-bin/virtctl-copier
INFO: Elapsed time: 0.204s, Critical Path: 0.03s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:build-virtctl-amd64 (0 packages loaded, 1 target configured).
INFO: Found 1 target...
Target //:build-virtctl-amd64 up-to-date:
  bazel-bin/virtctl-copier-amd64
INFO: Elapsed time: 0.299s, Critical Path: 0.04s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:build-virtctl-darwin (0 packages loaded, 1 target configured).
INFO: Found 1 target...
Target //:build-virtctl-darwin up-to-date:
  bazel-bin/virtctl-copier-darwin
INFO: Elapsed time: 0.227s, Critical Path: 0.03s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:build-virtctl-windows (0 packages loaded, 1 target configured).
INFO: Found 1 target...
Target //:build-virtctl-windows up-to-date:
  bazel-bin/virtctl-copier-windows
INFO: Elapsed time: 0.281s, Critical Path: 0.03s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
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
INFO: Elapsed time: 2.168s, Critical Path: 0.34s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
Done hack/manifests.sh
hack/dockerized "export BUILD_ARCH= && hack/bazel-fmt.sh && DOCKER_PREFIX=backendcloud DOCKER_TAG=mybuild5 DOCKER_TAG_ALT= IMAGE_PREFIX= IMAGE_PREFIX_ALT= KUBEVIRT_PROVIDER= PUSH_TARGETS='' ./hack/bazel-push-images.sh"
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
INFO: Elapsed time: 1.276s, Critical Path: 0.25s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:gazelle (35 packages loaded, 301 targets configured).
INFO: Found 1 target...
Target //:gazelle up-to-date:
  bazel-bin/gazelle-runner.bash
  bazel-bin/gazelle
INFO: Elapsed time: 0.175s, Critical Path: 0.03s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:goimports (10 packages loaded, 44 targets configured).
INFO: Found 1 target...
Target //:goimports up-to-date:
  bazel-bin/goimports.bash
INFO: Elapsed time: 0.198s, Critical Path: 0.06s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:buildifier (62 packages loaded, 291 targets configured).
INFO: Found 1 target...
Target //:buildifier up-to-date:
  bazel-bin/buildifier.bash
INFO: Elapsed time: 0.163s, Critical Path: 0.04s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
Sandbox is up to date
INFO: Build option --define has changed, discarding analysis cache.
INFO: Analyzed target //:push-other-images (698 packages loaded, 14054 targets configured).
INFO: Found 1 target...
Target //:push-other-images up-to-date:
  bazel-bin/push-other-images
INFO: Elapsed time: 2.026s, Critical Path: 0.03s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
2022/06/22 09:22:09 Successfully pushed Docker image to backendcloud/virtio-container-disk:mybuild5
2022/06/22 09:22:09 Successfully pushed Docker image to backendcloud/cirros-container-disk-demo:mybuild5
2022/06/22 09:22:09 Successfully pushed Docker image to backendcloud/cirros-custom-container-disk-demo:mybuild5
2022/06/22 09:22:09 Successfully pushed Docker image to backendcloud/alpine-container-disk-demo:mybuild5
2022/06/22 09:22:09 Successfully pushed Docker image to backendcloud/example-cloudinit-hook-sidecar:mybuild5
2022/06/22 09:22:09 Successfully pushed Docker image to backendcloud/disks-images-provider:mybuild5
2022/06/22 09:22:09 Successfully pushed Docker image to backendcloud/fedora-with-test-tooling-container-disk:mybuild5
2022/06/22 09:22:09 Successfully pushed Docker image to backendcloud/winrmcli:mybuild5
2022/06/22 09:22:09 Successfully pushed Docker image to backendcloud/example-hook-sidecar:mybuild5
2022/06/22 09:22:09 Successfully pushed Docker image to backendcloud/vm-killer:mybuild5
2022/06/22 09:22:09 Successfully pushed Docker image to backendcloud/fedora-realtime-container-disk:mybuild5
2022/06/22 09:22:09 Successfully pushed Docker image to backendcloud/alpine-with-test-tooling-container-disk:mybuild5
2022/06/22 09:22:09 Successfully pushed Docker image to backendcloud/subresource-access-test:mybuild5
2022/06/22 09:22:09 Successfully pushed Docker image to backendcloud/alpine-ext-kernel-boot-demo:mybuild5
2022/06/22 09:22:09 Successfully pushed Docker image to backendcloud/nfs-server:mybuild5
INFO: Analyzed target //:push-virt-operator (245 packages loaded, 1709 targets configured).
INFO: Found 1 target...
Target //:push-virt-operator up-to-date:
  bazel-bin/push-virt-operator.digest
  bazel-bin/push-virt-operator
INFO: Elapsed time: 1.047s, Critical Path: 0.03s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
2022/06/22 09:22:14 Successfully pushed Docker image to backendcloud/virt-operator:mybuild5
INFO: Analyzed target //:push-virt-api (20 packages loaded, 316 targets configured).
INFO: Found 1 target...
Target //:push-virt-api up-to-date:
  bazel-bin/push-virt-api.digest
  bazel-bin/push-virt-api
INFO: Elapsed time: 0.280s, Critical Path: 0.06s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
2022/06/22 09:22:19 Successfully pushed Docker image to backendcloud/virt-api:mybuild5
INFO: Analyzed target //:push-virt-controller (22 packages loaded, 76 targets configured).
INFO: Found 1 target...
Target //:push-virt-controller up-to-date:
  bazel-bin/push-virt-controller.digest
  bazel-bin/push-virt-controller
INFO: Elapsed time: 0.195s, Critical Path: 0.04s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
2022/06/22 09:22:23 Successfully pushed Docker image to backendcloud/virt-controller:mybuild5
INFO: Analyzed target //:push-virt-handler (135 packages loaded, 1004 targets configured).
INFO: Found 1 target...
Target //:push-virt-handler up-to-date:
  bazel-bin/push-virt-handler.digest
  bazel-bin/push-virt-handler
INFO: Elapsed time: 0.451s, Critical Path: 0.03s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
2022/06/22 09:22:28 Successfully pushed Docker image to backendcloud/virt-handler:mybuild5
INFO: Analyzed target //:push-virt-launcher (90 packages loaded, 311 targets configured).
INFO: Found 1 target...
Target //:push-virt-launcher up-to-date:
  bazel-bin/push-virt-launcher.digest
  bazel-bin/push-virt-launcher
INFO: Elapsed time: 0.233s, Critical Path: 0.05s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
2022/06/22 09:22:32 Successfully pushed Docker image to backendcloud/virt-launcher:mybuild5
INFO: Analyzed target //:push-conformance (113 packages loaded, 856 targets configured).
INFO: Found 1 target...
Target //:push-conformance up-to-date:
  bazel-bin/push-conformance.digest
  bazel-bin/push-conformance
INFO: Elapsed time: 0.346s, Critical Path: 0.04s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
2022/06/22 09:22:36 Successfully pushed Docker image to backendcloud/conformance:mybuild5
INFO: Analyzed target //:push-libguestfs (63 packages loaded, 131 targets configured).
INFO: Found 1 target...
Target //:push-libguestfs up-to-date:
  bazel-bin/push-libguestfs.digest
  bazel-bin/push-libguestfs
INFO: Elapsed time: 0.230s, Critical Path: 0.03s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
2022/06/22 09:22:40 Successfully pushed Docker image to backendcloud/libguestfs-tools:mybuild5
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
INFO: Build option --define has changed, discarding analysis cache.
INFO: Analyzed target //:build-manifest-templator (637 packages loaded, 12017 targets configured).
INFO: Found 1 target...
Target //:build-manifest-templator up-to-date:
  bazel-bin/manifest-templator-copier
INFO: Elapsed time: 2.260s, Critical Path: 0.32s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
Done hack/manifests.sh
```