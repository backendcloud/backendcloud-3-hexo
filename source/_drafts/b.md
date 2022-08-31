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

# 容器生命周期

之前讲了Pod中容器的生命周期的两个钩子函数，PostStart与PreStop，其中PostStart是在容器创建后立即执行的，而PreStop这个钩子函数则是在容器终止之前执行的。除了上面这两个钩子函数以外，还有一项配置会影响到容器的生命周期的，那就是健康检查的探针。

在Kubernetes集群当中，我们可以通过配置liveness probe（存活探针）和readiness probe（可读性探针）来影响容器的生存周期。

* exec：执行一段命令
* http：检测某个 http 请求
* tcpSocket：使用此配置， kubelet 将尝试在指定端口上打开容器的套接字。如果可以建立连接，容器被认为是健康的，如果不能就认为是失败的。实际上就是检查端口


```yaml
apiVersion: v1
kind: Pod
metadata:
  name: liveness-exec
  labels:
    test: liveness
spec:
  containers:
  - name: liveness
    image: busybox
    args:
    - /bin/sh
    - -c
    - touch /tmp/healthy; sleep 30; rm -rf /tmp/healthy; sleep 600
    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/healthy
      initialDelaySeconds: 5
      periodSeconds: 5
```

kubectl describe pod liveness-exec

我们可以观察到容器是正常启动的，在隔一会儿，比如40s后，再查看下Pod的Event，在最下面有一条信息显示 liveness probe失败了，容器被删掉并重新创建。

然后通过kubectl get pod liveness-exec可以看到RESTARTS值加1了。


```bash
[root@centos7 ~]# curl -LO https://raw.githubusercontent.com/cilium/cilium/1.12.1/Documentation/gettingstarted/kind-config.yaml
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   161  100   161    0     0    177      0 --:--:-- --:--:-- --:--:--   176
[root@centos7 ~]# ls
anaconda-ks.cfg  kind-config.yaml
[root@centos7 ~]# cat kind-config.yaml 
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
networking:
  disableDefaultCNI: true
[root@centos7 ~]# kind create cluster --config=kind-config.yaml
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.24.0) 🖼
 ✓ Preparing nodes 📦 📦 📦 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️ 
 ✓ Installing StorageClass 💾 
 ✓ Joining worker nodes 🚜 
Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-kind

Have a question, bug, or feature request? Let us know! https://kind.sigs.k8s.io/#community 🙂
[root@centos7 ~]# kubectl get pod -A
NAMESPACE            NAME                                         READY   STATUS    RESTARTS   AGE
kube-system          coredns-6d4b75cb6d-w9gtw                     0/1     Pending   0          38s
kube-system          coredns-6d4b75cb6d-xlw4x                     0/1     Pending   0          38s
kube-system          etcd-kind-control-plane                      1/1     Running   0          54s
kube-system          kube-apiserver-kind-control-plane            1/1     Running   0          54s
kube-system          kube-controller-manager-kind-control-plane   1/1     Running   0          52s
kube-system          kube-proxy-42m86                             1/1     Running   0          32s
kube-system          kube-proxy-g6cfs                             1/1     Running   0          19s
kube-system          kube-proxy-j8vkj                             1/1     Running   0          19s
kube-system          kube-proxy-wl6qg                             1/1     Running   0          39s
kube-system          kube-scheduler-kind-control-plane            1/1     Running   0          52s
local-path-storage   local-path-provisioner-9cd9bd544-vrnxd       0/1     Pending   0          38s
[root@centos7 ~]# kubectl get node
NAME                 STATUS     ROLES           AGE   VERSION
kind-control-plane   NotReady   control-plane   58s   v1.24.0
kind-worker          NotReady   <none>          22s   v1.24.0
kind-worker2         NotReady   <none>          35s   v1.24.0
kind-worker3         NotReady   <none>          22s   v1.24.0
[root@centos7 ~]# CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/master/stable.txt)
[root@centos7 ~]# CLI_ARCH=amd64
[root@centos7 ~]# if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
[root@centos7 ~]# curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 23.1M  100 23.1M    0     0  1378k      0  0:00:17  0:00:17 --:--:-- 5047k
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100    92  100    92    0     0     91      0  0:00:01  0:00:01 --:--:-- 92000
[root@centos7 ~]# sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
cilium-linux-amd64.tar.gz: OK
[root@centos7 ~]# sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
cilium
[root@centos7 ~]# rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
rm: remove regular file ‘cilium-linux-amd64.tar.gz’? y
rm: remove regular file ‘cilium-linux-amd64.tar.gz.sha256sum’? y
[root@centos7 ~]# cilium install
🔮 Auto-detected Kubernetes kind: kind
✨ Running "kind" validation checks
✅ Detected kind version "0.14.0"
ℹ️  Using Cilium version 1.12.1
🔮 Auto-detected cluster name: kind-kind
🔮 Auto-detected datapath mode: tunnel
🔮 Auto-detected kube-proxy has been installed
ℹ️  helm template --namespace kube-system cilium cilium/cilium --version 1.12.1 --set cluster.id=0,cluster.name=kind-kind,encryption.nodeEncryption=false,ipam.mode=kubernetes,kubeProxyReplacement=disabled,operator.replicas=1,serviceAccounts.cilium.name=cilium,serviceAccounts.operator.name=cilium-operator,tunnel=vxlan
ℹ️  Storing helm values file in kube-system/cilium-cli-helm-values Secret
🔑 Found CA in secret cilium-ca
🔑 Generating certificates for Hubble...
🚀 Creating Service accounts...
🚀 Creating Cluster roles...
🚀 Creating ConfigMap for Cilium version 1.12.1...
🚀 Creating Agent DaemonSet...
🚀 Creating Operator Deployment...
⌛ Waiting for Cilium to be installed and ready...
    /¯¯\
 /¯¯\__/¯¯\    Cilium:         1 errors, 4 warnings
 \__/¯¯\__/    Operator:       OK
 /¯¯\__/¯¯\    Hubble:         disabled
 \__/¯¯\__/    ClusterMesh:    disabled
    \__/

Deployment        cilium-operator    Desired: 1, Ready: 1/1, Available: 1/1
DaemonSet         cilium             Desired: 4, Unavailable: 4/4
Containers:       cilium             Pending: 4
                  cilium-operator    Running: 1
Cluster Pods:     0/3 managed by Cilium
Image versions    cilium             quay.io/cilium/cilium:v1.12.1@sha256:ea2db1ee21b88127b5c18a96ad155c25485d0815a667ef77c2b7c7f31cab601b: 4
                  cilium-operator    quay.io/cilium/operator-generic:v1.12.1@sha256:93d5aaeda37d59e6c4325ff05030d7b48fabde6576478e3fdbfb9bb4a68ec4a1: 1
Errors:           cilium             cilium          4 pods of DaemonSet cilium are not ready
Warnings:         cilium             cilium-27zkc    pod is pending
                  cilium             cilium-72w59    pod is pending
                  cilium             cilium-ss4qs    pod is pending
                  cilium             cilium-wvbwh    pod is pending
↩️ Rolling back installation...

Error: Unable to install Cilium: timeout while waiting for status to become successful: context deadline exceeded
[root@centos7 ~]# uname -a
Linux centos7 3.10.0-1160.71.1.el7.x86_64 #1 SMP Tue Jun 28 15:37:28 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
[root@centos7 ~]# rpm -import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
[root@centos7 ~]# rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
Retrieving http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
Retrieving http://elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm
Preparing...                          ################################# [100%]
Updating / installing...
   1:elrepo-release-7.0-4.el7.elrepo  ################################# [100%]
[root@centos7 ~]# yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * elrepo-kernel: mirrors.tuna.tsinghua.edu.cn
elrepo-kernel                                                                                                                                                                                                                                        | 3.0 kB  00:00:00     
elrepo-kernel/primary_db                                                                                                                                                                                                                             | 2.1 MB  00:00:11     
Available Packages
elrepo-release.noarch                                                                                                                 7.0-6.el7.elrepo                                                                                                         elrepo-kernelkernel-lt.x86_64                                                                                                                      5.4.211-1.el7.elrepo                                                                                                     elrepo-kernelkernel-lt-devel.x86_64                                                                                                                5.4.211-1.el7.elrepo                                                                                                     elrepo-kernelkernel-lt-doc.noarch                                                                                                                  5.4.211-1.el7.elrepo                                                                                                     elrepo-kernelkernel-lt-headers.x86_64                                                                                                              5.4.211-1.el7.elrepo                                                                                                     elrepo-kernelkernel-lt-tools.x86_64                                                                                                                5.4.211-1.el7.elrepo                                                                                                     elrepo-kernelkernel-lt-tools-libs.x86_64                                                                                                           5.4.211-1.el7.elrepo                                                                                                     elrepo-kernelkernel-lt-tools-libs-devel.x86_64                                                                                                     5.4.211-1.el7.elrepo                                                                                                     elrepo-kernelkernel-ml.x86_64                                                                                                                      5.19.5-1.el7.elrepo                                                                                                      elrepo-kernelkernel-ml-devel.x86_64                                                                                                                5.19.5-1.el7.elrepo                                                                                                      elrepo-kernelkernel-ml-doc.noarch                                                                                                                  5.19.5-1.el7.elrepo                                                                                                      elrepo-kernelkernel-ml-headers.x86_64                                                                                                              5.19.5-1.el7.elrepo                                                                                                      elrepo-kernelkernel-ml-tools.x86_64                                                                                                                5.19.5-1.el7.elrepo                                                                                                      elrepo-kernelkernel-ml-tools-libs.x86_64                                                                                                           5.19.5-1.el7.elrepo                                                                                                      elrepo-kernelkernel-ml-tools-libs-devel.x86_64                                                                                                     5.19.5-1.el7.elrepo                                                                                                      elrepo-kernelperf.x86_64                                                                                                                           5.19.5-1.el7.elrepo                                                                                                      elrepo-kernelpython-perf.x86_64                                                                                                                    5.19.5-1.el7.elrepo                                                                                                      elrepo-kernel
[root@centos7 ~]# yum -y --enablerepo=elrepo-kernel install kernel-ml
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * base: mirrors.tuna.tsinghua.edu.cn
 * elrepo: mirrors.tuna.tsinghua.edu.cn
 * elrepo-kernel: mirrors.tuna.tsinghua.edu.cn
 * extras: mirror.xtom.com.hk
 * updates: mirror.xtom.com.hk
Resolving Dependencies
--> Running transaction check
---> Package kernel-ml.x86_64 0:5.19.5-1.el7.elrepo will be installed
--> Finished Dependency Resolution

Dependencies Resolved

============================================================================================================================================================================================================================================================================ Package                                                       Arch                                                       Version                                                                   Repository                                                         Size
============================================================================================================================================================================================================================================================================Installing:
 kernel-ml                                                     x86_64                                                     5.19.5-1.el7.elrepo                                                       elrepo-kernel                                                      59 M

Transaction Summary
============================================================================================================================================================================================================================================================================Install  1 Package

Total download size: 59 M
Installed size: 276 M
Downloading packages:
kernel-ml-5.19.5-1.el7.elrepo.x86_64.rpm                                                                                                                                                                                                             |  59 MB  00:00:56     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
Warning: RPMDB altered outside of yum.
  Installing : kernel-ml-5.19.5-1.el7.elrepo.x86_64                                                                                                                                                                                                                     1/1 
  Verifying  : kernel-ml-5.19.5-1.el7.elrepo.x86_64                                                                                                                                                                                                                     1/1 

Installed:
  kernel-ml.x86_64 0:5.19.5-1.el7.elrepo                                                                                                                                                                                                                                    

Complete!
[root@centos7 ~]# awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
CentOS Linux (5.19.5-1.el7.elrepo.x86_64) 7 (Core)
CentOS Linux (3.10.0-1160.71.1.el7.x86_64) 7 (Core)
CentOS Linux (0-rescue-90a82557faf04194905deabee3ad1267) 7 (Core)
[root@centos7 ~]# cat /etc/default/grub
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="rd.lvm.lv=centos/root rhgb quiet"
GRUB_DISABLE_RECOVERY="true"
# 最新的内核位于位置0
[root@centos7 ~]# vi /etc/default/grub
[root@centos7 ~]# cat /etc/default/grub
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=0
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="rd.lvm.lv=centos/root rhgb quiet"
GRUB_DISABLE_RECOVERY="true"
[root@centos7 ~]# grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.19.5-1.el7.elrepo.x86_64
Found initrd image: /boot/initramfs-5.19.5-1.el7.elrepo.x86_64.img
Found linux image: /boot/vmlinuz-3.10.0-1160.71.1.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-1160.71.1.el7.x86_64.img
Found linux image: /boot/vmlinuz-0-rescue-90a82557faf04194905deabee3ad1267
Found initrd image: /boot/initramfs-0-rescue-90a82557faf04194905deabee3ad1267.img
done
[root@centos7 ~]# reboot
# 重启完成后，检查默认的内核版本
[root@centos7 ~]# uname -a
Linux centos7 5.19.5-1.el7.elrepo.x86_64 #1 SMP PREEMPT_DYNAMIC Mon Aug 29 08:55:53 EDT 2022 x86_64 x86_64 x86_64 GNU/Linux
[root@centos7 ~]# cilium install
🔮 Auto-detected Kubernetes kind: kind
✨ Running "kind" validation checks
✅ Detected kind version "0.14.0"
ℹ️  Using Cilium version 1.12.1
🔮 Auto-detected cluster name: kind-kind
🔮 Auto-detected datapath mode: tunnel
🔮 Auto-detected kube-proxy has been installed
ℹ️  helm template --namespace kube-system cilium cilium/cilium --version 1.12.1 --set cluster.id=0,cluster.name=kind-kind,encryption.nodeEncryption=false,ipam.mode=kubernetes,kubeProxyReplacement=disabled,operator.replicas=1,serviceAccounts.cilium.name=cilium,serviceAccounts.operator.name=cilium-operator,tunnel=vxlan
ℹ️  Storing helm values file in kube-system/cilium-cli-helm-values Secret
🔑 Found CA in secret cilium-ca
🔑 Generating certificates for Hubble...
🚀 Creating Service accounts...
🚀 Creating Cluster roles...
🚀 Creating ConfigMap for Cilium version 1.12.1...
🚀 Creating Agent DaemonSet...
🚀 Creating Operator Deployment...
⌛ Waiting for Cilium to be installed and ready...
♻️  Restarting unmanaged pods...
♻️  Restarted unmanaged pod kube-system/coredns-6d4b75cb6d-w9gtw
♻️  Restarted unmanaged pod kube-system/coredns-6d4b75cb6d-xlw4x
♻️  Restarted unmanaged pod local-path-storage/local-path-provisioner-9cd9bd544-vrnxd
✅ Cilium was successfully installed! Run 'cilium status' to view installation health
[root@centos7 ~]# cilium status
    /¯¯\
 /¯¯\__/¯¯\    Cilium:         OK
 \__/¯¯\__/    Operator:       OK
 /¯¯\__/¯¯\    Hubble:         disabled
 \__/¯¯\__/    ClusterMesh:    disabled
    \__/

Deployment       cilium-operator    
DaemonSet        cilium             
Containers:      cilium-operator    
                 cilium             
Cluster Pods:    0/0 managed by Cilium
```

```bash
[root@centos7 ~]# kind create cluster --config - <<EOF
> kind: Cluster
> apiVersion: kind.x-k8s.io/v1alpha4
> networking:
>   disableDefaultCNI: true   # do not install kindnet
>   kubeProxyMode: none       # do not run kube-proxy
> nodes:
> - role: control-plane
> - role: worker
> - role: worker
> - role: worker
> EOF
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.24.0) 🖼
 ✓ Preparing nodes 📦 📦 📦 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️ 
 ✓ Installing StorageClass 💾 
 ✓ Joining worker nodes 🚜 
Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-kind

Not sure what to do next? 😅  Check out https://kind.sigs.k8s.io/docs/user/quick-start/
[root@centos7 ~]# kubectl get pod -A
NAMESPACE            NAME                                         READY   STATUS    RESTARTS   AGE
kube-system          coredns-6d4b75cb6d-c7mx5                     0/1     Pending   0          17m
kube-system          coredns-6d4b75cb6d-kzjc6                     0/1     Pending   0          17m
kube-system          etcd-kind-control-plane                      1/1     Running   0          18m
kube-system          kube-apiserver-kind-control-plane            1/1     Running   0          18m
kube-system          kube-controller-manager-kind-control-plane   1/1     Running   0          18m
kube-system          kube-scheduler-kind-control-plane            1/1     Running   0          18m
local-path-storage   local-path-provisioner-9cd9bd544-bgg62       0/1     Pending   0          17m
[root@centos7 ~]# kubectl get node -o wide
NAME                 STATUS     ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION               CONTAINER-RUNTIME
kind-control-plane   NotReady   control-plane   18m   v1.24.0   172.18.0.2    <none>        Ubuntu 21.10   5.19.5-1.el7.elrepo.x86_64   containerd://1.6.4
kind-worker          NotReady   <none>          17m   v1.24.0   172.18.0.5    <none>        Ubuntu 21.10   5.19.5-1.el7.elrepo.x86_64   containerd://1.6.4
kind-worker2         NotReady   <none>          17m   v1.24.0   172.18.0.4    <none>        Ubuntu 21.10   5.19.5-1.el7.elrepo.x86_64   containerd://1.6.4
kind-worker3         NotReady   <none>          17m   v1.24.0   172.18.0.3    <none>        Ubuntu 21.10   5.19.5-1.el7.elrepo.x86_64   containerd://1.6.4
[root@centos7 ~]# helm upgrade --install --namespace kube-system --repo https://helm.cilium.io cilium cilium --values - <<EOF
> kubeProxyReplacement: strict
> hostServices:
>   enabled: false
> externalIPs:
>   enabled: true
> nodePort:
>   enabled: true
> hostPort:
>   enabled: true
> image:
>   pullPolicy: IfNotPresent
> ipam:
>   mode: kubernetes
> hubble:
>   enabled: true
>   relay:
>     enabled: true
> EOF
Release "cilium" does not exist. Installing it now.
Error: unable to build kubernetes objects from release manifest: error validating "": error validating data: unknown object type "nil" in ConfigMap.data.host-reachable-services-protos
[root@centos7 ~]# helm upgrade --install --namespace kube-system --repo https://helm.cilium.io cilium cilium --values - <<EOF
kubeProxyReplacement: strict
hostServices:
  enabled: false
externalIPs:
  enabled: true
nodePort:
  enabled: true
hostPort:
  enabled: true
image:
  pullPolicy: IfNotPresent
ipam:
  mode: kubernetes
hubble:
  enabled: true
  relay:
    enabled: true
EOF
Release "cilium" does not exist. Installing it now.
Error: unable to build kubernetes objects from release manifest: error validating "": error validating data: unknown object type "nil" in ConfigMap.data.host-reachable-services-protos
[root@centos7 ~]# helm upgrade --install --namespace kube-system --repo https://helm.cilium.io cilium cilium --values - <<EOF
> kubeProxyReplacement: strict
> hostServices:
>   enabled: false
> externalIPs:
>   enabled: true
> nodePort:
>   enabled: true
> hostPort:
>   enabled: true
> image:
>   pullPolicy: IfNotPresent
> ipam:
>   mode: kubernetes
> hubble:
>   enabled: true
>   relay:
>     enabled: true
> EOF
Release "cilium" does not exist. Installing it now.
Error: unable to build kubernetes objects from release manifest: error validating "": error validating data: unknown object type "nil" in ConfigMap.data.host-reachable-services-protos
[root@centos7 ~]# helm upgrade --install --namespace kube-system --repo https://helm.cilium.io cilium cilium --version 1.11.1 --values - <<EOF
kubeProxyReplacement: strict
hostServices:
  enabled: false
externalIPs:
  enabled: true
nodePort:
  enabled: true
hostPort:
  enabled: true
image:
  pullPolicy: IfNotPresent
ipam:
  mode: kubernetes
hubble:
  enabled: true
  relay:
    enabled: true
EOF

Release "cilium" does not exist. Installing it now.
W0831 09:48:19.750782  132599 warnings.go:70] spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[1].matchExpressions[0].key: beta.kubernetes.io/os is deprecated since v1.14; use "kubernetes.io/os" instead
W0831 09:48:19.750863  132599 warnings.go:70] spec.template.metadata.annotations[scheduler.alpha.kubernetes.io/critical-pod]: non-functional in v1.16+; use the "priorityClassName" field instead
NAME: cilium
LAST DEPLOYED: Wed Aug 31 09:48:18 2022
NAMESPACE: kube-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
You have successfully installed Cilium with Hubble Relay.

Your release version is 1.11.1.

For any further help, visit https://docs.cilium.io/en/v1.11/gettinghelp
[root@centos7 ~]# kubectl get pod -A
NAMESPACE            NAME                                         READY   STATUS              RESTARTS        AGE
kube-system          cilium-dhxgv                                 0/1     CrashLoopBackOff    5 (2m9s ago)    12m
kube-system          cilium-gvh9n                                 0/1     CrashLoopBackOff    5 (2m8s ago)    12m
kube-system          cilium-kvljw                                 0/1     CrashLoopBackOff    5 (101s ago)    12m
kube-system          cilium-nb5xg                                 0/1     CrashLoopBackOff    5 (2m10s ago)   12m
kube-system          cilium-operator-6fc45b598b-7t58w             0/1     CrashLoopBackOff    5 (2m25s ago)   12m
kube-system          cilium-operator-6fc45b598b-slc6x             0/1     CrashLoopBackOff    5 (78s ago)     12m
kube-system          coredns-6d4b75cb6d-c7mx5                     0/1     ContainerCreating   0               37m
kube-system          coredns-6d4b75cb6d-kzjc6                     0/1     ContainerCreating   0               37m
kube-system          etcd-kind-control-plane                      1/1     Running             0               37m
kube-system          hubble-relay-65d7c5cb84-wxtm4                0/1     ContainerCreating   0               12m
kube-system          kube-apiserver-kind-control-plane            1/1     Running             0               37m
kube-system          kube-controller-manager-kind-control-plane   1/1     Running             0               37m
kube-system          kube-scheduler-kind-control-plane            1/1     Running             0               37m
local-path-storage   local-path-provisioner-9cd9bd544-bgg62       0/1     ContainerCreating   0               37m
[root@centos7 ~]# kubectl logs cilium-dhxgv -nkube-system
...
level=info msg="Auto-disabling \"enable-bpf-clock-probe\" feature since KERNEL_HZ cannot be determined" error="Cannot probe CONFIG_HZ" subsys=daemon
level=info msg="Using autogenerated IPv4 allocation range" subsys=node v4Prefix=10.2.0.0/16
level=info msg="Disabled support for IPv4 fragments due to missing kernel support for BPF LRU maps" subsys=daemon
level=info msg="Initializing daemon" subsys=daemon
level=info msg="Establishing connection to apiserver" host="https://10.96.0.1:443" subsys=k8s
level=error msg="Unable to contact k8s api-server" error="Get \"https://10.96.0.1:443/api/v1/namespaces/kube-system\": read tcp 172.18.0.2:58124->10.96.0.1:443: read: connection reset by peer" ipAddr="https://10.96.0.1:443" subsys=k8s
level=fatal msg="Unable to initialize Kubernetes subsystem" error="unable to create k8s client: unable to create k8s client: Get \"https://10.96.0.1:443/api/v1/namespaces/kube-system\": read tcp 172.18.0.2:58124->10.96.0.1:443: read: connection reset by peer" subsys=daemon
```