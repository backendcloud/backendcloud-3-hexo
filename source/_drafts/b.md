```bash
 ⚡ root@centos9  ~/origin/kubevirt   release-0.53 ±  tree _out
_out
├── cmd
│   ├── cluster-profiler
│   │   └── cluster-profiler
│   ├── dump
│   │   └── dump
│   ├── perfscale-audit
│   │   └── perfscale-audit
│   ├── perfscale-load-generator
│   │   └── perfscale-load-generator
│   └── virtctl
│       ├── virtctl
│       ├── virtctl-v0.53.2-43-g8772b261b-darwin-amd64
│       ├── virtctl-v0.53.2-43-g8772b261b-linux-amd64
│       └── virtctl-v0.53.2-43-g8772b261b-windows-amd64.exe
├── digests
│   └── bazel-bin
│       ├── push-conformance.digest
│       ├── push-libguestfs.digest
│       ├── push-virt-api.digest
│       ├── push-virt-controller.digest
│       ├── push-virt-handler.digest
│       ├── push-virt-launcher.digest
│       └── push-virt-operator.digest
├── manifests
│   ├── release
│   │   ├── conformance.yaml
│   │   ├── demo-content.yaml
│   │   ├── kubevirt-cr.yaml
│   │   ├── kubevirt-operator.yaml
│   │   └── olm
│   │       ├── bundle
│   │       │   ├── kubevirt-crds.yaml
│   │       │   ├── kubevirtoperator.vmybuild7.clusterserviceversion.yaml
│   │       │   └── kubevirt-package.yaml
│   │       ├── kubevirt-csv-preconditions.yaml
│   │       ├── kubevirt-operatorsource.yaml
│   │       ├── kubevirt-subscription.yaml
│   │       └── operatorgroup.yaml
│   └── testing
│       ├── disks-images-provider.yaml
│       ├── rbac-for-testing.yaml
│       └── uploadproxy-nodeport.yaml
├── templates
│   └── manifests
│       ├── release
│       │   └── olm
│       │       └── bundle
│       └── testing
└── tests
    └── tools
        └── manifest-templator

21 directories, 30 files
```


```bash
 ✘ ⚡ root@backendcloud  ~/example/bazel-sample/docker   master ±  make docker-push
bazel run --define=IMAGE_TAG=v1.0.0 //cmd:image-push
INFO: Analyzed target //cmd:image-push (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //cmd:image-push up-to-date:
  bazel-bin/cmd/image-push.digest
  bazel-bin/cmd/image-push
INFO: Elapsed time: 0.209s, Critical Path: 0.00s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
2022/08/04 16:40:55 Error pushing image to 100.73.54.12:80/backendcloud/bazel-sample-cmd:v1.0.0: unable to push image to 100.73.54.12:80/backendcloud/bazel-sample-cmd:v1.0.0: Get "https://100.73.54.12:80/v2/": http: server gave HTTP response to HTTPS client
make: *** [Makefile:2: docker-push] Error 1
```


```bash
INFO: Repository libattr-0__2.4.48-3.el8.x86_64 instantiated at:
  /root/go/src/kubevirt.io/kubevirt/WORKSPACE:1813:4: in <toplevel>
Repository rule rpm defined at:
  /root/.cache/bazel/_bazel_root/6f347497f91c9a385dcd9294645b76e0/external/bazeldnf/internal/rpm.bzl:46:22: in <toplevel>
WARNING: Download from http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libattr-2.4.48-3.el8.x86_64.rpm failed: class com.google.devtools.build.lib.bazel.repository.downloader.UnrecoverableHttpException Checksum was a02e1344ccde1747501ceeeff37df4f18149fb79b435aa22add08cff6bab3a5a but wanted 3689cbd42ef7b83e3b1f3e0e57330ede4edf5224098f17e7cebc4f198cc9788d
WARNING: Download from https://storage.googleapis.com/builddeps/a02e1344ccde1747501ceeeff37df4f18149fb79b435aa22add08cff6bab3a5a failed: class com.google.devtools.build.lib.bazel.repository.downloader.UnrecoverableHttpException Checksum was a02e1344ccde1747501ceeeff37df4f18149fb79b435aa22add08cff6bab3a5a but wanted 3689cbd42ef7b83e3b1f3e0e57330ede4edf5224098f17e7cebc4f198cc9788d
ERROR: An error occurred during the fetch of repository 'libattr-0__2.4.48-3.el8.x86_64':
   Traceback (most recent call last):
        File "/root/.cache/bazel/_bazel_root/6f347497f91c9a385dcd9294645b76e0/external/bazeldnf/internal/rpm.bzl", line 29, column 37, in _rpm_impl
                download_info = ctx.download(
Error in download: java.io.IOException: Error downloading [http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libattr-2.4.48-3.el8.x86_64.rpm, https://storage.googleapis.com/builddeps/a02e1344ccde1747501ceeeff37df4f18149fb79b435aa22add08cff6bab3a5a] to /root/.cache/bazel/_bazel_root/6f347497f91c9a385dcd9294645b76e0/external/libattr-0__2.4.48-3.el8.x86_64/rpm/downloaded: Checksum was a02e1344ccde1747501ceeeff37df4f18149fb79b435aa22add08cff6bab3a5a but wanted 3689cbd42ef7b83e3b1f3e0e57330ede4edf5224098f17e7cebc4f198cc9788d
ERROR: Error fetching repository: Traceback (most recent call last):
        File "/root/.cache/bazel/_bazel_root/6f347497f91c9a385dcd9294645b76e0/external/bazeldnf/internal/rpm.bzl", line 29, column 37, in _rpm_impl
                download_info = ctx.download(
Error in download: java.io.IOException: Error downloading [http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libattr-2.4.48-3.el8.x86_64.rpm, https://storage.googleapis.com/builddeps/a02e1344ccde1747501ceeeff37df4f18149fb79b435aa22add08cff6bab3a5a] to /root/.cache/bazel/_bazel_root/6f347497f91c9a385dcd9294645b76e0/external/libattr-0__2.4.48-3.el8.x86_64/rpm/downloaded: Checksum was a02e1344ccde1747501ceeeff37df4f18149fb79b435aa22add08cff6bab3a5a but wanted 3689cbd42ef7b83e3b1f3e0e57330ede4edf5224098f17e7cebc4f198cc9788d
INFO: Repository libpkgconf-0__1.4.2-1.el8.x86_64 instantiated at:
  /root/go/src/kubevirt.io/kubevirt/WORKSPACE:2404:4: in <toplevel>
Repository rule rpm defined at:
  /root/.cache/bazel/_bazel_root/6f347497f91c9a385dcd9294645b76e0/external/bazeldnf/internal/rpm.bzl:46:22: in <toplevel>
INFO: Repository libtasn1-0__4.13-3.el8.x86_64 instantiated at:
  /root/go/src/kubevirt.io/kubevirt/WORKSPACE:2695:4: in <toplevel>
Repository rule rpm defined at:
  /root/.cache/bazel/_bazel_root/6f347497f91c9a385dcd9294645b76e0/external/bazeldnf/internal/rpm.bzl:46:22: in <toplevel>
INFO: Repository mpfr-0__3.1.6-1.el8.x86_64 instantiated at:
  /root/go/src/kubevirt.io/kubevirt/WORKSPACE:3109:4: in <toplevel>
Repository rule rpm defined at:
  /root/.cache/bazel/_bazel_root/6f347497f91c9a385dcd9294645b76e0/external/bazeldnf/internal/rpm.bzl:46:22: in <toplevel>
ERROR: /root/go/src/kubevirt.io/kubevirt/rpm/BUILD.bazel:1376:8: //rpm:libvirt-devel_x86_64 depends on @libattr-0__2.4.48-3.el8.x86_64//rpm:rpm in repository @libattr-0__2.4.48-3.el8.x86_64 which failed to fetch. no such package '@libattr-0__2.4.48-3.el8.x86_64//rpm': java.io.IOException: Error downloading [http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libattr-2.4.48-3.el8.x86_64.rpm, https://storage.googleapis.com/builddeps/a02e1344ccde1747501ceeeff37df4f18149fb79b435aa22add08cff6bab3a5a] to /root/.cache/bazel/_bazel_root/6f347497f91c9a385dcd9294645b76e0/external/libattr-0__2.4.48-3.el8.x86_64/rpm/downloaded: Checksum was a02e1344ccde1747501ceeeff37df4f18149fb79b435aa22add08cff6bab3a5a but wanted 3689cbd42ef7b83e3b1f3e0e57330ede4edf5224098f17e7cebc4f198cc9788d
ERROR: Analysis of target '//rpm:ldd_x86_64' failed; build aborted: Analysis failed
INFO: Elapsed time: 11.768s
INFO: 0 processes.
FAILED: Build did NOT complete successfully (8 packages loaded, 2 targets configured)
FAILED: Build did NOT complete successfully (8 packages loaded, 2 targets configured)
make: *** [Makefile:120: rpm-deps] Error 1
```

```bash
[root@kubevirtci kubevirt]# make push
hack/dockerized "export BUILD_ARCH= && hack/bazel-fmt.sh && DOCKER_PREFIX=100.73.54.12:80/test DOCKER_TAG=mybuild8 DOCKER_TAG_ALT= IMAGE_PREFIX= IMAGE_PREFIX_ALT= KUBEVIRT_PROVIDER= PUSH_TARGETS='' ./hack/bazel-push-images.sh"
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
INFO: Analyzed target //vendor/mvdan.cc/sh/v3/cmd/shfmt:shfmt (75 packages loaded, 8347 targets configured).
INFO: Found 1 target...
Target //vendor/mvdan.cc/sh/v3/cmd/shfmt:shfmt up-to-date:
  bazel-bin/vendor/mvdan.cc/sh/v3/cmd/shfmt/shfmt_/shfmt
INFO: Elapsed time: 2.627s, Critical Path: 0.36s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:gazelle (35 packages loaded, 301 targets configured).
INFO: Found 1 target...
Target //:gazelle up-to-date:
  bazel-bin/gazelle-runner.bash
  bazel-bin/gazelle
INFO: Elapsed time: 0.422s, Critical Path: 0.05s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:goimports (10 packages loaded, 44 targets configured).
INFO: Found 1 target...
Target //:goimports up-to-date:
  bazel-bin/goimports.bash
INFO: Elapsed time: 0.197s, Critical Path: 0.05s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:buildifier (62 packages loaded, 291 targets configured).
INFO: Found 1 target...
Target //:buildifier up-to-date:
  bazel-bin/buildifier.bash
INFO: Elapsed time: 0.255s, Critical Path: 0.07s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
Sandbox is up to date
INFO: Build option --define has changed, discarding analysis cache.
INFO: Analyzed target //:push-other-images (698 packages loaded, 14054 targets configured).
INFO: Found 1 target...
Target //:push-other-images up-to-date:
  bazel-bin/push-other-images
INFO: Elapsed time: 3.010s, Critical Path: 0.10s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
2022/08/11 07:22:57 Error pushing image to 100.73.54.12:80/test/example-hook-sidecar:mybuild8: unable to push image to 100.73.54.12:80/test/example-hook-sidecar:mybuild8: Get "https://100.73.54.12:80/v2/": http: server gave HTTP response to HTTPS client
2022/08/11 07:22:57 Error pushing image to 100.73.54.12:80/test/example-cloudinit-hook-sidecar:mybuild8: unable to push image to 100.73.54.12:80/test/example-cloudinit-hook-sidecar:mybuild8: Get "https://100.73.54.12:80/v2/": http: server gave HTTP response to HTTPS client
2022/08/11 07:22:57 Error pushing image to 100.73.54.12:80/test/alpine-with-test-tooling-container-disk:mybuild8: unable to push image to 100.73.54.12:80/test/alpine-with-test-tooling-container-disk:mybuild8: Get "https://100.73.54.12:80/v2/": http: server gave HTTP response to HTTPS client
2022/08/11 07:22:57 Error pushing image to 100.73.54.12:80/test/subresource-access-test:mybuild8: unable to push image to 100.73.54.12:80/test/subresource-access-test:mybuild8: Get "https://100.73.54.12:80/v2/": http: server gave HTTP response to HTTPS client
2022/08/11 07:22:57 Error pushing image to 100.73.54.12:80/test/alpine-ext-kernel-boot-demo:mybuild8: unable to push image to 100.73.54.12:80/test/alpine-ext-kernel-boot-demo:mybuild8: Get "https://100.73.54.12:80/v2/": http: server gave HTTP response to HTTPS client
2022/08/11 07:22:57 Error pushing image to 100.73.54.12:80/test/winrmcli:mybuild8: unable to push image to 100.73.54.12:80/test/winrmcli:mybuild8: Get "https://100.73.54.12:80/v2/": http: server gave HTTP response to HTTPS client
2022/08/11 07:22:57 Error pushing image to 100.73.54.12:80/test/disks-images-provider:mybuild8: unable to push image to 100.73.54.12:80/test/disks-images-provider:mybuild8: Get "https://100.73.54.12:80/v2/": http: server gave HTTP response to HTTPS client
2022/08/11 07:22:57 Error pushing image to 100.73.54.12:80/test/alpine-container-disk-demo:mybuild8: unable to push image to 100.73.54.12:80/test/alpine-container-disk-demo:mybuild8: Get "https://100.73.54.12:80/v2/": http: server gave HTTP response to HTTPS client
2022/08/11 07:22:57 Error pushing image to 100.73.54.12:80/test/fedora-with-test-tooling-container-disk:mybuild8: unable to push image to 100.73.54.12:80/test/fedora-with-test-tooling-container-disk:mybuild8: Get "https://100.73.54.12:80/v2/": http: server gave HTTP response to HTTPS client
2022/08/11 07:22:57 Error pushing image to 100.73.54.12:80/test/virtio-container-disk:mybuild8: unable to push image to 100.73.54.12:80/test/virtio-container-disk:mybuild8: Get "https://100.73.54.12:80/v2/": http: server gave HTTP response to HTTPS client
2022/08/11 07:22:57 Error pushing image to 100.73.54.12:80/test/cirros-custom-container-disk-demo:mybuild8: unable to push image to 100.73.54.12:80/test/cirros-custom-container-disk-demo:mybuild8: Get "https://100.73.54.12:80/v2/": http: server gave HTTP response to HTTPS client
2022/08/11 07:22:57 Error pushing image to 100.73.54.12:80/test/fedora-realtime-container-disk:mybuild8: unable to push image to 100.73.54.12:80/test/fedora-realtime-container-disk:mybuild8: Get "https://100.73.54.12:80/v2/": http: server gave HTTP response to HTTPS client
2022/08/11 07:22:57 Error pushing image to 100.73.54.12:80/test/cirros-container-disk-demo:mybuild8: unable to push image to 100.73.54.12:80/test/cirros-container-disk-demo:mybuild8: Get "https://100.73.54.12:80/v2/": http: server gave HTTP response to HTTPS clientmake: *** [Makefile:31: bazel-push-images] Error 1
[root@kubevirtci kubevirt]# 
```

```bash
[root@kubevirtci kubevirt]# export DOCKER_PREFIX=117.226.132.83:5000/test
[root@kubevirtci kubevirt]# docker push
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Error: accepts between 1 and 2 arg(s), received 0
[root@kubevirtci kubevirt]# make push
hack/dockerized "export BUILD_ARCH= && hack/bazel-fmt.sh && DOCKER_PREFIX=117.226.132.83:5000/test DOCKER_TAG=mybuild8 DOCKER_TAG_ALT= IMAGE_PREFIX= IMAGE_PREFIX_ALT= KUBEVIRT_PROVIDER= PUSH_TARGETS='' ./hack/bazel-push-images.sh"
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
INFO: Analyzed target //vendor/mvdan.cc/sh/v3/cmd/shfmt:shfmt (75 packages loaded, 8347 targets configured).
INFO: Found 1 target...
Target //vendor/mvdan.cc/sh/v3/cmd/shfmt:shfmt up-to-date:
  bazel-bin/vendor/mvdan.cc/sh/v3/cmd/shfmt/shfmt_/shfmt
INFO: Elapsed time: 1.852s, Critical Path: 0.33s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:gazelle (35 packages loaded, 301 targets configured).
INFO: Found 1 target...
Target //:gazelle up-to-date:
  bazel-bin/gazelle-runner.bash
  bazel-bin/gazelle
INFO: Elapsed time: 0.421s, Critical Path: 0.06s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:goimports (10 packages loaded, 44 targets configured).
INFO: Found 1 target...
Target //:goimports up-to-date:
  bazel-bin/goimports.bash
INFO: Elapsed time: 0.214s, Critical Path: 0.06s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO: Analyzed target //:buildifier (62 packages loaded, 291 targets configured).
INFO: Found 1 target...
Target //:buildifier up-to-date:
  bazel-bin/buildifier.bash
INFO: Elapsed time: 0.247s, Critical Path: 0.07s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
Sandbox is up to date
INFO: Build option --define has changed, discarding analysis cache.
INFO: Analyzed target //:push-other-images (830 packages loaded, 14054 targets configured).
INFO: Found 1 target...
Target //:push-other-images up-to-date:
  bazel-bin/push-other-images
INFO: Elapsed time: 2.471s, Critical Path: 0.10s
INFO: 16 processes: 16 internal.
INFO: Build completed successfully, 16 total actions
INFO: Build completed successfully, 16 total actions
2022/08/11 08:29:02 Successfully pushed Docker image to 117.226.132.83:5000/test/cirros-custom-container-disk-demo:mybuild8
2022/08/11 08:29:03 Successfully pushed Docker image to 117.226.132.83:5000/test/subresource-access-test:mybuild8
2022/08/11 08:29:07 Successfully pushed Docker image to 117.226.132.83:5000/test/cirros-container-disk-demo:mybuild8
2022/08/11 08:29:29 Successfully pushed Docker image to 117.226.132.83:5000/test/example-cloudinit-hook-sidecar:mybuild8
2022/08/11 08:29:30 Successfully pushed Docker image to 117.226.132.83:5000/test/alpine-with-test-tooling-container-disk:mybuild8
2022/08/11 08:29:36 Successfully pushed Docker image to 117.226.132.83:5000/test/nfs-server:mybuild8
2022/08/11 08:29:51 Successfully pushed Docker image to 117.226.132.83:5000/test/vm-killer:mybuild8
2022/08/11 08:29:52 Successfully pushed Docker image to 117.226.132.83:5000/test/winrmcli:mybuild8
2022/08/11 08:29:53 Successfully pushed Docker image to 117.226.132.83:5000/test/alpine-ext-kernel-boot-demo:mybuild8
2022/08/11 08:29:57 Successfully pushed Docker image to 117.226.132.83:5000/test/disks-images-provider:mybuild8
2022/08/11 08:30:11 Successfully pushed Docker image to 117.226.132.83:5000/test/alpine-container-disk-demo:mybuild8
2022/08/11 08:30:12 Successfully pushed Docker image to 117.226.132.83:5000/test/example-hook-sidecar:mybuild8
2022/08/11 08:31:00 Successfully pushed Docker image to 117.226.132.83:5000/test/fedora-with-test-tooling-container-disk:mybuild8
2022/08/11 08:31:03 Successfully pushed Docker image to 117.226.132.83:5000/test/virtio-container-disk:mybuild8
2022/08/11 08:32:27 Successfully pushed Docker image to 117.226.132.83:5000/test/fedora-realtime-container-disk:mybuild8
INFO: Analyzed target //:push-virt-operator (245 packages loaded, 1710 targets configured).
INFO: Found 1 target...
Target //:push-virt-operator up-to-date:
  bazel-bin/push-virt-operator.digest
  bazel-bin/push-virt-operator
INFO: Elapsed time: 4.569s, Critical Path: 3.77s
INFO: 13 processes: 6 internal, 7 processwrapper-sandbox.
INFO: Build completed successfully, 13 total actions
INFO: Build completed successfully, 13 total actions
2022/08/11 08:32:36 Successfully pushed Docker image to 117.226.132.83:5000/test/virt-operator:mybuild8
INFO: Analyzed target //:push-virt-api (20 packages loaded, 316 targets configured).
INFO: Found 1 target...
Target //:push-virt-api up-to-date:
  bazel-bin/push-virt-api.digest
  bazel-bin/push-virt-api
INFO: Elapsed time: 2.638s, Critical Path: 2.35s
INFO: 9 processes: 4 internal, 5 processwrapper-sandbox.
INFO: Build completed successfully, 9 total actions
INFO: Build completed successfully, 9 total actions
2022/08/11 08:32:42 Successfully pushed Docker image to 117.226.132.83:5000/test/virt-api:mybuild8
INFO: Analyzed target //:push-virt-controller (22 packages loaded, 76 targets configured).
INFO: Found 1 target...
Target //:push-virt-controller up-to-date:
  bazel-bin/push-virt-controller.digest
  bazel-bin/push-virt-controller
INFO: Elapsed time: 2.739s, Critical Path: 2.54s
INFO: 9 processes: 4 internal, 5 processwrapper-sandbox.
INFO: Build completed successfully, 9 total actions
INFO: Build completed successfully, 9 total actions
2022/08/11 08:32:48 Successfully pushed Docker image to 117.226.132.83:5000/test/virt-controller:mybuild8
INFO: Analyzed target //:push-virt-handler (135 packages loaded, 1004 targets configured).
INFO: Found 1 target...
Target //:push-virt-handler up-to-date:
  bazel-bin/push-virt-handler.digest
  bazel-bin/push-virt-handler
INFO: Elapsed time: 8.759s, Critical Path: 8.32s
INFO: 9 processes: 4 internal, 5 processwrapper-sandbox.
INFO: Build completed successfully, 9 total actions
INFO: Build completed successfully, 9 total actions
2022/08/11 08:33:08 Successfully pushed Docker image to 117.226.132.83:5000/test/virt-handler:mybuild8
INFO: Analyzed target //:push-virt-launcher (90 packages loaded, 311 targets configured).
INFO: Found 1 target...
Target //:push-virt-launcher up-to-date:
  bazel-bin/push-virt-launcher.digest
  bazel-bin/push-virt-launcher
INFO: Elapsed time: 12.097s, Critical Path: 11.82s
INFO: 9 processes: 4 internal, 5 processwrapper-sandbox.
INFO: Build completed successfully, 9 total actions
INFO: Build completed successfully, 9 total actions
2022/08/11 08:33:35 Successfully pushed Docker image to 117.226.132.83:5000/test/virt-launcher:mybuild8
INFO: Analyzed target //:push-conformance (113 packages loaded, 856 targets configured).
INFO: Found 1 target...
Target //:push-conformance up-to-date:
  bazel-bin/push-conformance.digest
  bazel-bin/push-conformance
INFO: Elapsed time: 14.488s, Critical Path: 13.17s
INFO: 44 processes: 6 internal, 38 processwrapper-sandbox.
INFO: Build completed successfully, 44 total actions
INFO: Build completed successfully, 44 total actions
2022/08/11 08:33:57 Successfully pushed Docker image to 117.226.132.83:5000/test/conformance:mybuild8
INFO: Analyzed target //:push-libguestfs (63 packages loaded, 131 targets configured).
INFO: Found 1 target...
Target //:push-libguestfs up-to-date:
  bazel-bin/push-libguestfs.digest
  bazel-bin/push-libguestfs
INFO: Elapsed time: 16.198s, Critical Path: 15.94s
INFO: 9 processes: 4 internal, 5 processwrapper-sandbox.
INFO: Build completed successfully, 9 total actions
INFO: Build completed successfully, 9 total actions
2022/08/11 08:34:31 Successfully pushed Docker image to 117.226.132.83:5000/test/libguestfs-tools:mybuild8
```
