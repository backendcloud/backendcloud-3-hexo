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