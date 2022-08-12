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
[root@kubevirtci ~]# docker volume create rpms
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
rpms
[root@kubevirtci ~]# docker run -td -w /libvirt-src --security-opt label=disable --name libvirt-build -v $(pwd):/libvirt-src -v rpms:/root/rpmbuild/RPMS registry.gitlab.com/libvirt/libvirt/ci-centos-stream-8
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Trying to pull registry.gitlab.com/libvirt/libvirt/ci-centos-stream-8:latest...
Getting image source signatures
Copying blob 741a9542e264 done  
Copying blob 545277d80005 done  
Copying blob f70d60810c69 done  
Copying blob c0ffde05962c done  
Copying blob cae420f94528 done  
Copying config a19c77cd0c done  
Writing manifest to image destination
Storing signatures
94f7d255d315369b2ae0a5802548f93eeecfd7b4e96f244d99c7a6706a20430d
[root@kubevirtci ~]# docker exec -ti libvirt-build bash
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
[root@94f7d255d315 libvirt-src]# dnf update -y
...
  Verifying        : libverto-libevent-0.3.2-2.el8.x86_64                                                                                                                                                                                                           122/167 
  Verifying        : libverto-libevent-0.3.0-5.el8.x86_64                                                                                                                                                                                                           123/167 
  Verifying        : lvm2-8:2.03.14-5.el8.x86_64                                                                                                                                                                                                                    124/167 
  Verifying        : lvm2-8:2.03.14-3.el8.x86_64                                                                                                                                                                                                                    125/167 
  Verifying        : lvm2-libs-8:2.03.14-5.el8.x86_64                                                                                                                                                                                                               126/167 
  Verifying        : lvm2-libs-8:2.03.14-3.el8.x86_64                                                                                                                                                                                                               127/167 
  Verifying        : pam-1.3.1-22.el8.x86_64                                                                                                                                                                                                                        128/167 
  Verifying        : pam-1.3.1-21.el8.x86_64                                                                                                                                                                                                                        129/167 
  Verifying        : pam-devel-1.3.1-22.el8.x86_64                                                                                                                                                                                                                  130/167 
  Verifying        : pam-devel-1.3.1-21.el8.x86_64                                                                                                                                                                                                                  131/167 
  Verifying        : procps-ng-3.3.15-8.el8.x86_64                                                                                                                                                                                                                  132/167 
  Verifying        : procps-ng-3.3.15-7.el8.x86_64                                                                                                                                                                                                                  133/167 
  Verifying        : python3-dnf-4.7.0-11.el8.noarch                                                                                                                                                                                                                134/167 
  Verifying        : python3-dnf-4.7.0-10.el8.noarch                                                                                                                                                                                                                135/167 
  Verifying        : python3-dnf-plugins-core-4.0.21-14.el8.noarch                                                                                                                                                                                                  136/167 
  Verifying        : python3-dnf-plugins-core-4.0.21-12.el8.noarch                                                                                                                                                                                                  137/167 
  Verifying        : python3-hawkey-0.63.0-11.el8.x86_64                                                                                                                                                                                                            138/167 
  Verifying        : python3-hawkey-0.63.0-10.el8.x86_64                                                                                                                                                                                                            139/167 
  Verifying        : python3-libdnf-0.63.0-11.el8.x86_64                                                                                                                                                                                                            140/167 
  Verifying        : python3-libdnf-0.63.0-10.el8.x86_64                                                                                                                                                                                                            141/167 
  Verifying        : python3-librepo-1.14.2-3.el8.x86_64                                                                                                                                                                                                            142/167 
  Verifying        : python3-librepo-1.14.2-1.el8.x86_64                                                                                                                                                                                                            143/167 
  Verifying        : sanlock-lib-3.8.4-4.el8.x86_64                                                                                                                                                                                                                 144/167 
  Verifying        : sanlock-lib-3.8.4-3.el8.x86_64                                                                                                                                                                                                                 145/167 
  Verifying        : setup-2.12.2-7.el8.noarch                                                                                                                                                                                                                      146/167 
  Verifying        : setup-2.12.2-6.el8.noarch                                                                                                                                                                                                                      147/167 
  Verifying        : shadow-utils-2:4.6-17.el8.x86_64                                                                                                                                                                                                               148/167 
  Verifying        : shadow-utils-2:4.6-16.el8.x86_64                                                                                                                                                                                                               149/167 
  Verifying        : systemd-239-62.el8.x86_64                                                                                                                                                                                                                      150/167 
  Verifying        : systemd-239-59.el8.x86_64                                                                                                                                                                                                                      151/167 
  Verifying        : systemd-devel-239-62.el8.x86_64                                                                                                                                                                                                                152/167 
  Verifying        : systemd-devel-239-59.el8.x86_64                                                                                                                                                                                                                153/167 
  Verifying        : systemd-libs-239-62.el8.x86_64                                                                                                                                                                                                                 154/167 
  Verifying        : systemd-libs-239-59.el8.x86_64                                                                                                                                                                                                                 155/167 
  Verifying        : systemd-pam-239-62.el8.x86_64                                                                                                                                                                                                                  156/167 
  Verifying        : systemd-pam-239-59.el8.x86_64                                                                                                                                                                                                                  157/167 
  Verifying        : systemd-udev-239-62.el8.x86_64                                                                                                                                                                                                                 158/167 
  Verifying        : systemd-udev-239-59.el8.x86_64                                                                                                                                                                                                                 159/167 
  Verifying        : tar-2:1.30-6.el8.x86_64                                                                                                                                                                                                                        160/167 
  Verifying        : tar-2:1.30-5.el8.x86_64                                                                                                                                                                                                                        161/167 
  Verifying        : yum-4.7.0-11.el8.noarch                                                                                                                                                                                                                        162/167 
  Verifying        : yum-4.7.0-10.el8.noarch                                                                                                                                                                                                                        163/167 
  Verifying        : device-mapper-devel-8:1.02.181-5.el8.x86_64                                                                                                                                                                                                    164/167 
  Verifying        : device-mapper-devel-8:1.02.181-3.el8.x86_64                                                                                                                                                                                                    165/167 
  Verifying        : sanlock-devel-3.8.4-4.el8.x86_64                                                                                                                                                                                                               166/167 
  Verifying        : sanlock-devel-3.8.4-3.el8.x86_64                                                                                                                                                                                                               167/167 

Upgraded:
  alsa-lib-1.2.7.2-1.el8.x86_64                          annobin-10.67-3.el8.x86_64                        cpp-8.5.0-15.el8.x86_64                           cups-libs-1:2.2.6-50.el8.x86_64                               curl-7.61.1-25.el8.x86_64                       
  dbus-1:1.12.8-19.el8.x86_64                            dbus-common-1:1.12.8-19.el8.noarch                dbus-daemon-1:1.12.8-19.el8.x86_64                dbus-libs-1:1.12.8-19.el8.x86_64                              dbus-tools-1:1.12.8-19.el8.x86_64               
  device-mapper-8:1.02.181-5.el8.x86_64                  device-mapper-devel-8:1.02.181-5.el8.x86_64       device-mapper-event-8:1.02.181-5.el8.x86_64       device-mapper-event-libs-8:1.02.181-5.el8.x86_64              device-mapper-libs-8:1.02.181-5.el8.x86_64      
  device-mapper-persistent-data-0.9.0-7.el8.x86_64       dnf-4.7.0-11.el8.noarch                           dnf-data-4.7.0-11.el8.noarch                      dnf-plugins-core-4.0.21-14.el8.noarch                         gcc-8.5.0-15.el8.x86_64                         
  gcc-c++-8.5.0-15.el8.x86_64                            gcc-plugin-annobin-8.5.0-15.el8.x86_64            gdbm-1:1.18-2.el8.x86_64                          gdbm-libs-1:1.18-2.el8.x86_64                                 glibc-2.28-208.el8.x86_64                       
  glibc-common-2.28-208.el8.x86_64                       glibc-devel-2.28-208.el8.x86_64                   glibc-gconv-extra-2.28-208.el8.x86_64             glibc-headers-2.28-208.el8.x86_64                             glibc-langpack-en-2.28-208.el8.x86_64           
  glibc-minimal-langpack-2.28-208.el8.x86_64             grub2-common-1:2.02-129.el8.noarch                grub2-tools-1:2.02-129.el8.x86_64                 grub2-tools-minimal-1:2.02-129.el8.x86_64                     gssproxy-0.8.0-21.el8.x86_64                    
  kernel-headers-4.18.0-408.el8.x86_64                   krb5-devel-1.18.2-21.el8.x86_64                   krb5-libs-1.18.2-21.el8.x86_64                    libarchive-3.3.3-4.el8.x86_64                                 libatomic-8.5.0-15.el8.x86_64                   
  libcurl-7.61.1-25.el8.x86_64                           libcurl-devel-7.61.1-25.el8.x86_64                libdnf-0.63.0-11.el8.x86_64                       libgcc-8.5.0-15.el8.x86_64                                    libgomp-8.5.0-15.el8.x86_64                     
  libkadm5-1.18.2-21.el8.x86_64                          libnl3-3.7.0-1.el8.x86_64                         libnl3-cli-3.7.0-1.el8.x86_64                     libnl3-devel-3.7.0-1.el8.x86_64                               librepo-1.14.2-3.el8.x86_64                     
  libstdc++-8.5.0-15.el8.x86_64                          libstdc++-devel-8.5.0-15.el8.x86_64               libverto-0.3.2-2.el8.x86_64                       libverto-devel-0.3.2-2.el8.x86_64                             libverto-libevent-0.3.2-2.el8.x86_64            
  lvm2-8:2.03.14-5.el8.x86_64                            lvm2-libs-8:2.03.14-5.el8.x86_64                  pam-1.3.1-22.el8.x86_64                           pam-devel-1.3.1-22.el8.x86_64                                 procps-ng-3.3.15-8.el8.x86_64                   
  python-rpm-macros-3-43.el8.noarch                      python-srpm-macros-3-43.el8.noarch                python3-dnf-4.7.0-11.el8.noarch                   python3-dnf-plugins-core-4.0.21-14.el8.noarch                 python3-hawkey-0.63.0-11.el8.x86_64             
  python3-libdnf-0.63.0-11.el8.x86_64                    python3-librepo-1.14.2-3.el8.x86_64               python3-rpm-macros-3-43.el8.noarch                ruby-libs-2.5.9-110.module_el8.6.0+1187+541216eb.x86_64       sanlock-devel-3.8.4-4.el8.x86_64                
  sanlock-lib-3.8.4-4.el8.x86_64                         setup-2.12.2-7.el8.noarch                         shadow-utils-2:4.6-17.el8.x86_64                  systemd-239-62.el8.x86_64                                     systemd-devel-239-62.el8.x86_64                 
  systemd-libs-239-62.el8.x86_64                         systemd-pam-239-62.el8.x86_64                     systemd-udev-239-62.el8.x86_64                    tar-2:1.30-6.el8.x86_64                                       unbound-libs-1.16.0-2.el8.x86_64                
  yum-4.7.0-11.el8.noarch                               
Installed:
  grub2-tools-efi-1:2.02-129.el8.x86_64                grub2-tools-extra-1:2.02-129.el8.x86_64                python3-unbound-1.16.0-2.el8.x86_64                rpm-plugin-systemd-inhibit-4.14.3-23.el8.x86_64                sqlite-3.26.0-15.el8.x86_64               

Complete!
[root@94f7d255d315 libvirt-src]# 
```