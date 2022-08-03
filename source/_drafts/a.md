```bash
 ✘ ⚡ root@centos9  ~/origin/kubevirt   release-0.53  make rpm-deps
SYNC_VENDOR=true hack/dockerized "CUSTOM_REPO= SINGLE_ARCH= LIBVIRT_VERSION= QEMU_VERSION= SEABIOS_VERSION= EDK2_VERSION= LIBGUESTFS_VERSION= ./hack/rpm-deps.sh"
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
+ source hack/common.sh
++ '[' -f cluster-up/hack/common.sh ']'
++ source cluster-up/hack/common.sh
+++ '[' -z '' ']'
+++++ dirname 'cluster-up/hack/common.sh[0]'
++++ cd cluster-up/hack/../
+++++ pwd
++++ echo /root/go/src/kubevirt.io/kubevirt/cluster-up/
+++ KUBEVIRTCI_PATH=/root/go/src/kubevirt.io/kubevirt/cluster-up/
+++ '[' -z '' ']'
+++++ dirname 'cluster-up/hack/common.sh[0]'
++++ cd cluster-up/hack/../../
+++++ pwd
++++ echo /root/go/src/kubevirt.io/kubevirt/_ci-configs
+++ KUBEVIRTCI_CONFIG_PATH=/root/go/src/kubevirt.io/kubevirt/_ci-configs
+++ KUBEVIRTCI_CLUSTER_PATH=/root/go/src/kubevirt.io/kubevirt/cluster-up//cluster
+++ KUBEVIRT_PROVIDER=k8s-1.21
+++ KUBEVIRT_NUM_NODES=1
+++ KUBEVIRT_MEMORY_SIZE=5120M
+++ KUBEVIRT_NUM_SECONDARY_NICS=0
+++ KUBEVIRT_DEPLOY_ISTIO=false
+++ KUBEVIRT_DEPLOY_NFS_CSI=false
+++ KUBEVIRT_DEPLOY_PROMETHEUS=false
+++ KUBEVIRT_DEPLOY_PROMETHEUS_ALERTMANAGER=false
+++ KUBEVIRT_DEPLOY_GRAFANA=false
+++ KUBEVIRT_CGROUPV2=false
+++ KUBEVIRT_DEPLOY_CDI=false
+++ KUBEVIRT_SWAP_ON=false
+++ KUBEVIRT_UNLIMITEDSWAP=false
+++ '[' -z '' ']'
+++ KUBEVIRT_PROVIDER_EXTRA_ARGS=' --ocp-port 8443'
+++ provider_prefix=k8s-1.21
+++ job_prefix=kubevirt
+++ mkdir -p /root/go/src/kubevirt.io/kubevirt/_ci-configs/k8s-1.21
+++ KUBEVIRTCI_TAG=2204150103-bd2586d
++ export 'GOFLAGS= -mod=vendor'
++ GOFLAGS=' -mod=vendor'
++++ dirname 'hack/common.sh[0]'
+++ cd hack/../
+++ pwd
++ KUBEVIRT_DIR=/root/go/src/kubevirt.io/kubevirt
++ OUT_DIR=/root/go/src/kubevirt.io/kubevirt/_out
++ SANDBOX_DIR=/root/go/src/kubevirt.io/kubevirt/.bazeldnf/sandbox
++ VENDOR_DIR=/root/go/src/kubevirt.io/kubevirt/vendor
++ CMD_OUT_DIR=/root/go/src/kubevirt.io/kubevirt/_out/cmd
++ TESTS_OUT_DIR=/root/go/src/kubevirt.io/kubevirt/_out/tests
++ APIDOCS_OUT_DIR=/root/go/src/kubevirt.io/kubevirt/_out/apidocs
++ ARTIFACTS=/root/go/src/kubevirt.io/kubevirt/_out/artifacts
++ DIGESTS_DIR=/root/go/src/kubevirt.io/kubevirt/_out/digests
++ MANIFESTS_OUT_DIR=/root/go/src/kubevirt.io/kubevirt/_out/manifests
++ MANIFEST_TEMPLATES_OUT_DIR=/root/go/src/kubevirt.io/kubevirt/_out/templates/manifests
++ PYTHON_CLIENT_OUT_DIR=/root/go/src/kubevirt.io/kubevirt/_out/client-python
+++ uname -m
++ ARCHITECTURE=x86_64
+++ uname -m
++ HOST_ARCHITECTURE=x86_64
++ KUBEVIRT_NO_BAZEL=false
++ OPERATOR_MANIFEST_PATH=/root/go/src/kubevirt.io/kubevirt/_out/manifests/release/kubevirt-operator.yaml
++ TESTING_MANIFEST_PATH=/root/go/src/kubevirt.io/kubevirt/_out/manifests/testing
+++ determine_cri_bin
+++ '[' '' = podman ']'
+++ '[' '' = docker ']'
+++ curl --unix-socket /podman/podman.sock http://d/v3.0.0/libpod/info
+++ docker ps
+++ echo ''
++ KUBEVIRT_CRI=
+++ kubevirt_version
+++ '[' -n '' ']'
+++ '[' -d /root/go/src/kubevirt.io/kubevirt/.git ']'
++++ git describe --always --tags
+++ echo v0.53.2-43-g8772b261b
++ KUBEVIRT_VERSION=v0.53.2-43-g8772b261b
++ DOCKER_CA_CERT_FILE=
++ DOCKERIZED_CUSTOM_CA_PATH=/etc/pki/ca-trust/source/anchors/custom-ca.crt
+ source hack/bootstrap.sh
++ set -e
++ [[ hack/bootstrap.sh == \.\/\h\a\c\k\/\r\p\m\-\d\e\p\s\.\s\h ]]
++ KUBEVIRT_NO_BAZEL=false
+++ uname -m
++ HOST_ARCHITECTURE=x86_64
++ sandbox_root=/root/go/src/kubevirt.io/kubevirt/.bazeldnf/sandbox/default/root
++ sandbox_hash=1c65c791715e97377c36a3be1b7edd35c99dd9ef
++ '[' false '!=' true ']'
++ kubevirt::bootstrap::regenerate x86_64
++ kubevirt::bootstrap::sandbox_exists
++ ls /root/go/src/kubevirt.io/kubevirt/.bazeldnf/sandbox/1c65c791715e97377c36a3be1b7edd35c99dd9ef
++ kubevirt::bootstrap::sandbox_config
++ cat
++ echo 'Sandbox is up to date'
Sandbox is up to date
++ return
+ source hack/config.sh
++ unset binaries docker_images docker_tag docker_tag_alt image_prefix image_prefix_alt manifest_templates namespace image_pull_policy verbosity csv_version package_name
++ source hack/config-default.sh
+++ binaries='cmd/virt-operator cmd/virt-controller cmd/virt-launcher cmd/virt-handler cmd/virtctl cmd/fake-qemu-process cmd/virt-api cmd/subresource-access-test cmd/example-hook-sidecar cmd/example-cloudinit-hook-sidecar cmd/virt-chroot'
+++ docker_images='cmd/virt-operator cmd/virt-controller cmd/virt-launcher cmd/virt-handler cmd/virt-api images/disks-images-provider images/vm-killer images/nfs-server cmd/subresource-access-test images/winrmcli cmd/example-hook-sidecar cmd/example-cloudinit-hook-sidecar tests/conformance'
+++ docker_tag=latest
+++ docker_tag_alt=
+++ image_prefix=
+++ image_prefix_alt=
+++ namespace=kubevirt
+++ deploy_testing_infra=false
+++ csv_namespace=placeholder
+++ cdi_namespace=cdi
+++ image_pull_policy=IfNotPresent
+++ verbosity=2
+++ package_name=kubevirt-dev
+++ kubevirtci_git_hash=2204150103-bd2586d
+++ conn_check_ipv4_address=
+++ conn_check_ipv6_address=
+++ conn_check_dns=
+++ migration_network_nic=eth1
+++ infra_replicas=2
+++ default_csv_version=0.0.0
+++ default_csv_version=0.0.0
+++ [[ 0.0.0 == v* ]]
+++ csv_version=0.0.0
++ source cluster-up/hack/config.sh
+++ unset docker_prefix master_ip network_provider kubeconfig manifest_docker_prefix
+++ KUBEVIRT_PROVIDER=k8s-1.21
+++ source /root/go/src/kubevirt.io/kubevirt/cluster-up/hack/config-default.sh
++++ docker_prefix=kubevirt
++++ master_ip=192.168.200.2
++++ network_provider=flannel
+++ test -f /root/go/src/kubevirt.io/kubevirt/_ci-configs/k8s-1.21/config-provider-k8s-1.21.sh
+++ export docker_prefix master_ip network_provider kubeconfig manifest_docker_prefix
++ export binaries docker_images docker_tag docker_tag_alt image_prefix image_prefix_alt manifest_templates namespace image_pull_policy verbosity csv_version package_name
+ LIBVIRT_VERSION=0:8.0.0-2.module_el8.6.0+1087+b42c8331
+ QEMU_VERSION=15:6.2.0-5.module_el8.6.0+1087+b42c8331
+ SEABIOS_VERSION=0:1.15.0-1.module_el8.6.0+1087+b42c8331
+ EDK2_VERSION=0:20220126gitbb1bba3d77-2.el8
+ LIBGUESTFS_VERSION=1:1.44.0-5.module_el8.6.0+1087+b42c8331
+ SINGLE_ARCH=
+ bazeldnf_repos='--repofile rpm/repo.yaml'
+ '[' '' ']'
+ centos_base='
  acl
  curl
  vim-minimal
'
+ centos_extra='
  coreutils-single
  glibc-minimal-langpack
  libcurl-minimal
'
+ bazel run --config=x86_64 //:bazeldnf -- fetch --repofile rpm/repo.yaml
INFO: Analyzed target //:bazeldnf (132 packages loaded, 8499 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 1.159s, Critical Path: 0.32s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO[0000] Resolving repomd.xml from http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/repodata/repomd.xml 
INFO[0000] Loading primary file from http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/repodata/c4f303b15bec05a7a6ac0d52840f58985f4ff7cf9ef6040723daf5a1aae15a27-primary.xml.gz 
INFO[0215] Resolving repomd.xml from http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/repodata/repomd.xml 
INFO[0217] Loading primary file from http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/repodata/d5a26174ec0e5c302aa29a422551a9db0c49c0652e3e8e2a855bc564ce19b287-primary.xml.gz 
INFO[0413] Resolving repomd.xml from http://mirror.centos.org/centos/8-stream/PowerTools/x86_64/os/repodata/repomd.xml 
INFO[0413] Loading primary file from http://mirror.centos.org/centos/8-stream/PowerTools/x86_64/os/repodata/c1df5c2cf48c3eb7e6fd404fc853f84683275a08e7f1e8640236114772801ed6-primary.xml.gz 
INFO[0449] Resolving repomd.xml from http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/repodata/repomd.xml 
INFO[0450] Loading primary file from http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/repodata/736f799f53aab445735a3642cfdc7c87dd63df13d63ae1d33c65e17f46d7fef6-primary.xml.gz 
INFO[0780] Resolving repomd.xml from http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/repodata/repomd.xml 
INFO[0780] Loading primary file from http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/repodata/9c2f3dda70cf5c642a4bd88feaaa87ff5478467bd255d94735dbe0458c747e42-primary.xml.gz 
INFO[0843] Resolving repomd.xml from http://mirror.centos.org/centos/8-stream/PowerTools/aarch64/os/repodata/repomd.xml 
INFO[0844] Loading primary file from http://mirror.centos.org/centos/8-stream/PowerTools/aarch64/os/repodata/8461122866ece304480042c5d5a532d01fd9d6b6e3ed43b6eafbd6fd76ce896b-primary.xml.gz 
+ testimage_base='
  device-mapper
  e2fsprogs
  iputils
  nmap-ncat
  procps-ng
  qemu-img-15:6.2.0-5.module_el8.6.0+1087+b42c8331
  util-linux
  which
'
+ libvirtdevel_base='
  libvirt-devel-0:8.0.0-2.module_el8.6.0+1087+b42c8331
'
+ libvirtdevel_extra='
  keyutils-libs
  krb5-libs
  libmount
  lz4-libs
'
+ sandbox_base='
  findutils
  gcc
  glibc-static
  python36
  sssd-client
'
+ launcherbase_base='
  libvirt-client-0:8.0.0-2.module_el8.6.0+1087+b42c8331
  libvirt-daemon-driver-qemu-0:8.0.0-2.module_el8.6.0+1087+b42c8331
  qemu-kvm-core-15:6.2.0-5.module_el8.6.0+1087+b42c8331
'
+ launcherbase_x86_64='
  edk2-ovmf-0:20220126gitbb1bba3d77-2.el8
  qemu-kvm-hw-usbredir-15:6.2.0-5.module_el8.6.0+1087+b42c8331
  seabios-0:1.15.0-1.module_el8.6.0+1087+b42c8331
'
+ launcherbase_aarch64='
  edk2-aarch64-0:20220126gitbb1bba3d77-2.el8
'
+ launcherbase_extra='
  ethtool
  findutils
  iptables
  nftables
  nmap-ncat
  procps-ng
  selinux-policy
  selinux-policy-targeted
  tar
  xorriso
'
+ handler_base='
  qemu-img-15:6.2.0-5.module_el8.6.0+1087+b42c8331
'
+ handlerbase_extra='
  findutils
  iproute
  iptables
  nftables
  procps-ng
  selinux-policy
  selinux-policy-targeted
  tar
  util-linux
  xorriso
'
+ libguestfstools_base='
  file
  libguestfs-tools-1:1.44.0-5.module_el8.6.0+1087+b42c8331
  libvirt-daemon-driver-qemu-0:8.0.0-2.module_el8.6.0+1087+b42c8331
  qemu-kvm-core-15:6.2.0-5.module_el8.6.0+1087+b42c8331
  seabios-0:1.15.0-1.module_el8.6.0+1087+b42c8331
  tar
'
+ libguestfstools_x86_64='
  edk2-ovmf-0:20220126gitbb1bba3d77-2.el8
'
+ '[' -z '' ']'
+ bazel run --config=x86_64 //:bazeldnf -- rpmtree --public --nobest --name testimage_x86_64 --basesystem centos-stream-release --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal device-mapper e2fsprogs iputils nmap-ncat procps-ng qemu-img-15:6.2.0-5.module_el8.6.0+1087+b42c8331 util-linux which
INFO: Analyzed target //:bazeldnf (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 0.115s, Critical Path: 0.03s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Running command line: bazel-bin/bazeldnf.bash rpmtree --public --nobest --name testimage_x86_64 --basesystem centos-stream-release --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal device-mapper e2fsp
INFO: Build completed successfully, 1 total action
INFO[0000] Loading packages.                            
INFO[0006] Initial reduction of involved packages.      
INFO[0006] Loading involved packages into the rpmtreer. 
INFO[0006] Loaded 4673 packages.                        
INFO[0006] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0006] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0006] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0006] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0006] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0006] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0006] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0006] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0006] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0006] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0006] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0006] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0006] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0006] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0006] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0006] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0006] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0006] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0006] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0006] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0006] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0006] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] Generated 15644 variables.                   
INFO[0007] Adding required packages to the rpmtreer.    
INFO[0007] Selecting acl: acl-0:2.2.53-1.el8            
INFO[0007] Selecting curl: curl-0:7.61.1-25.el8         
INFO[0007] Selecting vim-minimal: vim-minimal-2:8.0.1763-19.el8.4 
INFO[0007] Selecting coreutils-single: coreutils-single-0:8.30-13.el8 
INFO[0007] Selecting glibc-minimal-langpack: glibc-minimal-langpack-0:2.28-208.el8 
INFO[0007] Selecting libcurl-minimal: libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] Selecting device-mapper: device-mapper-8:1.02.181-3.el8 
INFO[0007] Selecting e2fsprogs: e2fsprogs-0:1.45.6-5.el8 
INFO[0007] Selecting iputils: iputils-0:20180629-10.el8 
INFO[0007] Selecting nmap-ncat: nmap-ncat-2:7.70-7.el8  
INFO[0007] Selecting procps-ng: procps-ng-0:3.3.15-7.el8 
INFO[0007] Selecting qemu-img: qemu-img-15:6.2.0-5.module_el8.6.0+1087+b42c8331 
INFO[0007] Selecting util-linux: util-linux-0:2.32.1-35.el8 
INFO[0007] Selecting which: which-0:2.21-18.el8         
INFO[0007] Selecting centos-stream-release: centos-stream-release-0:8.6-1.el8 
INFO[0007] Solving.                                     
INFO[0007] Loading the Partial weighted MAXSAT problem. 
INFO[0011] Solving the Partial weighted MAXSAT problem. 
INFO[0011] Solution with weight 0 found.                
INFO[0011] Writing bazel files.                         
Package				Version					Size		Download Size
Installing:										
 ca-certificates		0:2021.2.50-82.el8			936.15 K	399.50 K
 chkconfig			0:1.19.1-1.el8				843.79 K	203.05 K
 libss				0:1.45.6-5.el8				78.76 K		55.24 K
 zlib				0:1.2.11-19.el8				201.55 K	105.06 K
 mozjs60			0:60.9.0-4.el8				23.73 M		6.93 M
 libstdc++			0:8.5.0-15.el8				1.86 M		464.94 K
 libtirpc			0:1.1.4-7.el8				226.51 K	115.29 K
 libverto			0:0.3.2-2.el8				28.70 K		24.60 K
 centos-gpg-keys		1:8-6.el8				6.28 K		14.63 K
 libblkid			0:2.32.1-35.el8				345.00 K	223.77 K
 centos-stream-release		0:8.6-1.el8				29.43 K		22.74 K
 polkit				0:0.115-13.0.1.el8.2			417.58 K	157.70 K
 ncurses-base			0:6.1-9.20180224.el8			314.23 K	83.08 K
 systemd-pam			0:239-60.el8				919.54 K	496.20 K
 systemd-libs			0:239-60.el8				4.58 M		1.15 M
 which				0:2.21-18.el8				85.60 K		50.68 K
 e2fsprogs			0:1.45.6-5.el8				4.37 M		1.07 M
 glib2				0:2.56.4-159.el8			12.30 M		2.61 M
 libtasn1			0:4.13-3.el8				170.78 K	78.01 K
 libsepol			0:2.9-3.el8				762.65 K	348.04 K
 expat				0:2.2.5-9.el8				317.50 K	115.90 K
 libuuid			0:2.32.1-35.el8				36.42 K		99.23 K
 libcom_err			0:1.45.6-5.el8				62.58 K		50.52 K
 elfutils-default-yama-scope	0:0.187-4.el8				2.09 K		52.83 K
 iputils			0:20180629-10.el8			337.33 K	151.87 K
 krb5-libs			0:1.18.2-21.el8				2.25 M		860.54 K
 keyutils-libs			0:1.5.10-9.el8				45.16 K		34.78 K
 glibc				0:2.28-208.el8				6.79 M		2.31 M
 centos-stream-repos		0:8-6.el8				30.21 K		20.59 K
 polkit-libs			0:0.115-13.0.1.el8.2			198.83 K	78.30 K
 libutempter			0:1.1.6-14.el8				54.63 K		32.46 K
 libselinux			0:2.9-5.el8				170.92 K	169.13 K
 crypto-policies		0:20211116-1.gitae470d6.el8		94.23 K		65.20 K
 libcap				0:2.48-4.el8				169.93 K	75.80 K
 elfutils-libelf		0:0.187-4.el8				1.03 M		236.61 K
 libgcc				0:8.5.0-15.el8				192.02 K	82.59 K
 info				0:6.5-7.el8_5				387.26 K	203.23 K
 grep				0:3.1-6.el8				845.03 K	280.36 K
 dbus-common			1:1.12.8-19.el8				12.92 K		47.28 K
 libxcrypt			0:4.1.1-6.el8				188.42 K	74.48 K
 pcre				0:8.42-6.el8				512.34 K	215.63 K
 openssl-libs			1:1.1.1k-6.el8				3.77 M		1.54 M
 libpcap			14:1.9.1-5.el8				387.00 K	172.74 K
 libzstd			0:1.4.4-1.el8				699.40 K	272.32 K
 gawk				0:4.2.1-4.el8				2.72 M		1.19 M
 libsmartcols			0:2.32.1-35.el8				249.71 K	182.16 K
 xz-libs			0:5.2.4-4.el8				166.00 K	96.08 K
 libacl				0:2.2.53-1.el8				60.18 K		35.62 K
 libmount			0:2.32.1-35.el8				399.50 K	240.58 K
 procps-ng			0:3.3.15-7.el8				914.03 K	336.80 K
 libcap-ng			0:0.7.11-1.el8				52.67 K		34.19 K
 e2fsprogs-libs			0:1.45.6-5.el8				522.62 K	238.70 K
 cryptsetup-libs		0:2.3.7-2.el8				2.15 M		499.32 K
 libdb				0:5.3.28-42.el8_4			1.90 M		769.40 K
 p11-kit-trust			0:0.23.22-1.el8				473.54 K	140.29 K
 nmap-ncat			2:7.70-7.el8				495.56 K	242.40 K
 libpwquality			0:1.4.4-3.el8				409.00 K	109.43 K
 libidn2			0:2.2.0-1.el8				293.60 K	96.02 K
 libunistring			0:0.9.9-3.el8				1.86 M		432.42 K
 tzdata				0:2022a-2.el8				2.18 M		485.40 K
 dbus				1:1.12.8-19.el8				124		42.43 K
 kmod-libs			0:25-19.el8				127.82 K	70.08 K
 filesystem			0:3.8-6.el8				215.45 K	1.14 M
 elfutils-libs			0:0.187-4.el8				715.10 K	304.02 K
 acl				0:2.2.53-1.el8				209.64 K	82.99 K
 shadow-utils			2:4.6-16.el8				4.13 M		1.29 M
 curl				0:7.61.1-25.el8				703.48 K	360.54 K
 pam				0:1.3.1-22.el8				2.72 M		760.84 K
 device-mapper-libs		8:1.02.181-3.el8			416.90 K	419.34 K
 libcurl-minimal		0:7.61.1-25.el8				557.43 K	295.36 K
 glibc-minimal-langpack		0:2.28-208.el8				124		64.48 K
 vim-minimal			2:8.0.1763-19.el8.4			1.19 M		588.76 K
 nettle				0:3.4.1-7.el8				575.76 K	308.24 K
 libaio				0:0.3.112-1.el8				98.80 K		33.41 K
 mpfr				0:3.1.6-1.el8				614.92 K	226.70 K
 bash				0:4.4.20-4.el8				6.88 M		1.62 M
 lz4-libs			0:1.8.3-3.el8_4				122.25 K	67.35 K
 dbus-libs			1:1.12.8-19.el8				381.96 K	188.54 K
 gmp				1:6.1.2-10.el8				1.68 M		329.75 K
 bzip2-libs			0:1.0.6-26.el8				78.42 K		49.10 K
 libgcrypt			0:1.8.5-7.el8				1.27 M		473.84 K
 util-linux			0:2.32.1-35.el8				11.65 M		2.59 M
 fuse-libs			0:2.9.7-16.el8				307.08 K	104.79 K
 json-c				0:0.13.1-3.el8				70.64 K		41.66 K
 setup				0:2.12.2-7.el8				729.30 K	185.09 K
 popt				0:1.18-1.el8				133.12 K	62.82 K
 cracklib-dicts			0:2.9.6-15.el8				9.82 M		4.14 M
 libnghttp2			0:1.33.0-3.el8_2.1			169.26 K	79.21 K
 coreutils-single		0:8.30-13.el8				1.38 M		644.08 K
 dbus-tools			1:1.12.8-19.el8				128.05 K	87.70 K
 libfdisk			0:2.32.1-35.el8				440.11 K	258.05 K
 cracklib			0:2.9.6-15.el8				250.87 K	95.50 K
 libsigsegv			0:2.11-5.el8				48.83 K		30.98 K
 sed				0:4.5-5.el8				773.39 K	305.33 K
 ncurses-libs			0:6.1-9.20180224.el8			958.61 K	341.76 K
 device-mapper			8:1.02.181-3.el8			361.68 K	386.22 K
 libattr			0:2.4.48-3.el8				28.38 K		27.56 K
 libffi				0:3.1-23.el8				55.29 K		38.32 K
 dbus-daemon			1:1.12.8-19.el8				565.57 K	246.20 K
 libgpg-error			0:1.31-1.el8				908.91 K	247.52 K
 libnsl2			0:1.2.0-2.20180605git4a062cf.el8	148.31 K	59.10 K
 readline			0:7.0-10.el8				468.61 K	204.02 K
 timedatex			0:0.5-3.el8				57.87 K		33.10 K
 audit-libs			0:3.0.7-4.el8				310.77 K	125.88 K
 basesystem			0:11-5.el8				124		10.75 K
 pcre2				0:10.32-3.el8				659.32 K	252.57 K
 qemu-img			15:6.2.0-5.module_el8.6.0+1087+b42c8331	8.57 M		2.25 M
 libsemanage			0:2.9-8.el8				314.37 K	171.92 K
 libseccomp			0:2.5.2-1.el8				171.61 K	72.91 K
 libibverbs			0:37.2-1.el8				1.02 M		393.71 K
 glibc-common			0:2.28-208.el8				8.01 M		1.04 M
 systemd			0:239-60.el8				11.38 M		3.77 M
 p11-kit			0:0.23.22-1.el8				1.65 M		332.07 K
 gzip				0:1.9-13.el8				358.66 K	170.78 K
 polkit-pkla-compat		0:0.1-12.el8				100.51 K	46.97 K
 libnl3				0:3.7.0-1.el8				1.06 M		345.42 K
 gnutls				0:3.6.16-4.el8				3.01 M		1.04 M
Ignoring:										
											
Transaction Summary:									
Installing 117 Packages 								
Total download size: 55.92 M								
Total install size: 174.37 M								
+ bazel run --config=x86_64 //:bazeldnf -- rpmtree --public --nobest --name libvirt-devel_x86_64 --basesystem centos-stream-release --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal libvirt-devel-0:8.0.0-2.module_el8.6.0+1087+b42c8331 keyutils-libs krb5-libs libmount lz4-libs
INFO: Analyzed target //:bazeldnf (4 packages loaded, 148 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 0.734s, Critical Path: 0.04s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Running command line: bazel-bin/bazeldnf.bash rpmtree --public --nobest --name libvirt-devel_x86_64 --basesystem centos-stream-release --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal libvirt-devel-0
INFO: Build completed successfully, 1 total action
INFO[0000] Loading packages.                            
INFO[0007] Initial reduction of involved packages.      
INFO[0007] Loading involved packages into the rpmtreer. 
INFO[0007] Loaded 4662 packages.                        
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0008] Generated 15468 variables.                   
INFO[0008] Adding required packages to the rpmtreer.    
INFO[0008] Selecting acl: acl-0:2.2.53-1.el8            
INFO[0008] Selecting curl: curl-0:7.61.1-25.el8         
INFO[0008] Selecting vim-minimal: vim-minimal-2:8.0.1763-19.el8.4 
INFO[0008] Selecting coreutils-single: coreutils-single-0:8.30-13.el8 
INFO[0008] Selecting glibc-minimal-langpack: glibc-minimal-langpack-0:2.28-208.el8 
INFO[0008] Selecting libcurl-minimal: libcurl-minimal-0:7.61.1-25.el8 
INFO[0008] Selecting libvirt-devel: libvirt-devel-0:8.0.0-2.module_el8.6.0+1087+b42c8331 
INFO[0008] Selecting keyutils-libs: keyutils-libs-0:1.5.10-9.el8 
INFO[0008] Selecting krb5-libs: krb5-libs-0:1.18.2-21.el8 
INFO[0008] Selecting libmount: libmount-0:2.32.1-35.el8 
INFO[0008] Selecting lz4-libs: lz4-libs-0:1.8.3-3.el8_4 
INFO[0008] Selecting centos-stream-release: centos-stream-release-0:8.6-1.el8 
INFO[0008] Solving.                                     
INFO[0008] Loading the Partial weighted MAXSAT problem. 
INFO[0012] Solving the Partial weighted MAXSAT problem. 
INFO[0012] Solution with weight 1501 found.             
INFO[0012] Picking libvirt-libs-0:8.0.0-2.module_el8.6.0+1087+b42c8331 instead of best candiate libvirt-libs-0:8.0.0-6.module_el8.7.0+1140+ff0772f9 
INFO[0012] Writing bazel files.                         
Package				Version					Size		Download Size
Installing:										
 bzip2-libs			0:1.0.6-26.el8				78.42 K		49.10 K
 polkit				0:0.115-13.0.1.el8.2			417.58 K	157.70 K
 libpkgconf			0:1.4.2-1.el8				69.30 K		35.61 K
 libssh				0:0.9.6-3.el8				519.94 K	221.38 K
 libcap-ng			0:0.7.11-1.el8				52.67 K		34.19 K
 libstdc++			0:8.5.0-15.el8				1.86 M		464.94 K
 grep				0:3.1-6.el8				845.03 K	280.36 K
 keyutils-libs			0:1.5.10-9.el8				45.16 K		34.78 K
 json-c				0:0.13.1-3.el8				70.64 K		41.66 K
 libgcrypt			0:1.8.5-7.el8				1.27 M		473.84 K
 shadow-utils			2:4.6-16.el8				4.13 M		1.29 M
 libfdisk			0:2.32.1-35.el8				440.11 K	258.05 K
 libcap				0:2.48-4.el8				169.93 K	75.80 K
 dbus				1:1.12.8-19.el8				124		42.43 K
 device-mapper			8:1.02.181-3.el8			361.68 K	386.22 K
 lz4-libs			0:1.8.3-3.el8_4				122.25 K	67.35 K
 polkit-pkla-compat		0:0.1-12.el8				100.51 K	46.97 K
 libsepol			0:2.9-3.el8				762.65 K	348.04 K
 chkconfig			0:1.19.1-1.el8				843.79 K	203.05 K
 ncurses-libs			0:6.1-9.20180224.el8			958.61 K	341.76 K
 krb5-libs			0:1.18.2-21.el8				2.25 M		860.54 K
 centos-stream-release		0:8.6-1.el8				29.43 K		22.74 K
 libunistring			0:0.9.9-3.el8				1.86 M		432.42 K
 libuuid			0:2.32.1-35.el8				36.42 K		99.23 K
 libpwquality			0:1.4.4-3.el8				409.00 K	109.43 K
 libvirt-libs			0:8.0.0-2.module_el8.6.0+1087+b42c8331	24.49 M		4.94 M
 kmod-libs			0:25-19.el8				127.82 K	70.08 K
 ca-certificates		0:2021.2.50-82.el8			936.15 K	399.50 K
 libcurl-minimal		0:7.61.1-25.el8				557.43 K	295.36 K
 libvirt-devel			0:8.0.0-2.module_el8.6.0+1087+b42c8331	1.47 M		250.44 K
 libcom_err			0:1.45.6-5.el8				62.58 K		50.52 K
 basesystem			0:11-5.el8				124		10.75 K
 openldap			0:2.4.46-18.el8				1.01 M		360.92 K
 p11-kit-trust			0:0.23.22-1.el8				473.54 K	140.29 K
 popt				0:1.18-1.el8				133.12 K	62.82 K
 gzip				0:1.9-13.el8				358.66 K	170.78 K
 audit-libs			0:3.0.7-4.el8				310.77 K	125.88 K
 pam				0:1.3.1-22.el8				2.72 M		760.84 K
 cryptsetup-libs		0:2.3.7-2.el8				2.15 M		499.32 K
 p11-kit			0:0.23.22-1.el8				1.65 M		332.07 K
 systemd-libs			0:239-60.el8				4.58 M		1.15 M
 yajl				0:2.1.0-11.el8				85.42 K		41.67 K
 libxml2			0:2.9.7-14.el8				1.76 M		712.30 K
 cyrus-sasl-gssapi		0:2.1.27-6.el8_5			42.86 K		51.06 K
 libtasn1			0:4.13-3.el8				170.78 K	78.01 K
 centos-gpg-keys		1:8-6.el8				6.28 K		14.63 K
 libsigsegv			0:2.11-5.el8				48.83 K		30.98 K
 libffi				0:3.1-23.el8				55.29 K		38.32 K
 info				0:6.5-7.el8_5				387.26 K	203.23 K
 polkit-libs			0:0.115-13.0.1.el8.2			198.83 K	78.30 K
 cracklib			0:2.9.6-15.el8				250.87 K	95.50 K
 glibc-minimal-langpack		0:2.28-208.el8				124		64.48 K
 pkgconf-m4			0:1.4.2-1.el8				14.60 K		17.44 K
 dbus-daemon			1:1.12.8-19.el8				565.57 K	246.20 K
 curl				0:7.61.1-25.el8				703.48 K	360.54 K
 libgpg-error			0:1.31-1.el8				908.91 K	247.52 K
 systemd-pam			0:239-60.el8				919.54 K	496.20 K
 mozjs60			0:60.9.0-4.el8				23.73 M		6.93 M
 device-mapper-libs		8:1.02.181-3.el8			416.90 K	419.34 K
 dbus-libs			1:1.12.8-19.el8				381.96 K	188.54 K
 dbus-common			1:1.12.8-19.el8				12.92 K		47.28 K
 libselinux			0:2.9-5.el8				170.92 K	169.13 K
 coreutils-single		0:8.30-13.el8				1.38 M		644.08 K
 numactl-libs			0:2.0.12-13.el8				52.09 K		36.99 K
 libdb				0:5.3.28-42.el8_4			1.90 M		769.40 K
 pcre2				0:10.32-3.el8				659.32 K	252.57 K
 libidn2			0:2.2.0-1.el8				293.60 K	96.02 K
 cyrus-sasl			0:2.1.27-6.el8_5			156.32 K	98.72 K
 vim-minimal			2:8.0.1763-19.el8.4			1.19 M		588.76 K
 xz-libs			0:5.2.4-4.el8				166.00 K	96.08 K
 libsemanage			0:2.9-8.el8				314.37 K	171.92 K
 libgcc				0:8.5.0-15.el8				192.02 K	82.59 K
 dbus-tools			1:1.12.8-19.el8				128.05 K	87.70 K
 gnutls				0:3.6.16-4.el8				3.01 M		1.04 M
 libnsl2			0:1.2.0-2.20180605git4a062cf.el8	148.31 K	59.10 K
 libattr			0:2.4.48-3.el8				28.38 K		27.56 K
 pkgconf-pkg-config		0:1.4.2-1.el8				3.93 K		15.59 K
 libnghttp2			0:1.33.0-3.el8_2.1			169.26 K	79.21 K
 nettle				0:3.4.1-7.el8				575.76 K	308.24 K
 libmount			0:2.32.1-35.el8				399.50 K	240.58 K
 readline			0:7.0-10.el8				468.61 K	204.02 K
 glibc-common			0:2.28-208.el8				8.01 M		1.04 M
 gmp				1:6.1.2-10.el8				1.68 M		329.75 K
 pcre				0:8.42-6.el8				512.34 K	215.63 K
 expat				0:2.2.5-9.el8				317.50 K	115.90 K
 tzdata				0:2022a-2.el8				2.18 M		485.40 K
 libssh-config			0:0.9.6-3.el8				816		19.75 K
 libzstd			0:1.4.4-1.el8				699.40 K	272.32 K
 libseccomp			0:2.5.2-1.el8				171.61 K	72.91 K
 filesystem			0:3.8-6.el8				215.45 K	1.14 M
 elfutils-libs			0:0.187-4.el8				715.10 K	304.02 K
 libblkid			0:2.32.1-35.el8				345.00 K	223.77 K
 libnl3				0:3.7.0-1.el8				1.06 M		345.42 K
 util-linux			0:2.32.1-35.el8				11.65 M		2.59 M
 libutempter			0:1.1.6-14.el8				54.63 K		32.46 K
 libacl				0:2.2.53-1.el8				60.18 K		35.62 K
 glibc				0:2.28-208.el8				6.79 M		2.31 M
 cyrus-sasl-lib			0:2.1.27-6.el8_5			732.16 K	126.32 K
 centos-stream-repos		0:8-6.el8				30.21 K		20.59 K
 libtirpc			0:1.1.4-7.el8				226.51 K	115.29 K
 gawk				0:4.2.1-4.el8				2.72 M		1.19 M
 libverto			0:0.3.2-2.el8				28.70 K		24.60 K
 mpfr				0:3.1.6-1.el8				614.92 K	226.70 K
 sed				0:4.5-5.el8				773.39 K	305.33 K
 elfutils-libelf		0:0.187-4.el8				1.03 M		236.61 K
 elfutils-default-yama-scope	0:0.187-4.el8				2.09 K		52.83 K
 libsmartcols			0:2.32.1-35.el8				249.71 K	182.16 K
 setup				0:2.12.2-7.el8				729.30 K	185.09 K
 timedatex			0:0.5-3.el8				57.87 K		33.10 K
 bash				0:4.4.20-4.el8				6.88 M		1.62 M
 pkgconf			0:1.4.2-1.el8				65.14 K		38.95 K
 acl				0:2.2.53-1.el8				209.64 K	82.99 K
 crypto-policies		0:20211116-1.gitae470d6.el8		94.23 K		65.20 K
 systemd			0:239-60.el8				11.38 M		3.77 M
 openssl-libs			1:1.1.1k-6.el8				3.77 M		1.54 M
 cracklib-dicts			0:2.9.6-15.el8				9.82 M		4.14 M
 zlib				0:1.2.11-19.el8				201.55 K	105.06 K
 glib2				0:2.56.4-159.el8			12.30 M		2.61 M
 libxcrypt			0:4.1.1-6.el8				188.42 K	74.48 K
 ncurses-base			0:6.1-9.20180224.el8			314.23 K	83.08 K
Ignoring:										
											
Transaction Summary:									
Installing 120 Packages 								
Total download size: 57.80 M								
Total install size: 187.66 M								
+ bazel run --config=x86_64 //:bazeldnf -- rpmtree --public --nobest --name sandboxroot_x86_64 --basesystem centos-stream-release --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal findutils gcc glibc-static python36 sssd-client
INFO: Analyzed target //:bazeldnf (4 packages loaded, 148 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 0.745s, Critical Path: 0.04s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Running command line: bazel-bin/bazeldnf.bash rpmtree --public --nobest --name sandboxroot_x86_64 --basesystem centos-stream-release --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal findutils gcc gli
INFO: Build completed successfully, 1 total action
INFO[0000] Loading packages.                            
INFO[0006] Initial reduction of involved packages.      
INFO[0006] Loading involved packages into the rpmtreer. 
INFO[0006] Loaded 4733 packages.                        
INFO[0006] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0006] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0006] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0006] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0006] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0006] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0006] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0006] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0006] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0006] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] Generated 13775 variables.                   
INFO[0007] Adding required packages to the rpmtreer.    
INFO[0007] Selecting acl: acl-0:2.2.53-1.el8            
INFO[0007] Selecting curl: curl-0:7.61.1-25.el8         
INFO[0007] Selecting vim-minimal: vim-minimal-2:8.0.1763-19.el8.4 
INFO[0007] Selecting coreutils-single: coreutils-single-0:8.30-13.el8 
INFO[0007] Selecting glibc-minimal-langpack: glibc-minimal-langpack-0:2.28-208.el8 
INFO[0007] Selecting libcurl-minimal: libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] Selecting findutils: findutils-1:4.6.0-20.el8 
INFO[0007] Selecting gcc: gcc-0:8.5.0-15.el8            
INFO[0007] Selecting glibc-static: glibc-static-0:2.28-208.el8 
INFO[0007] Selecting python36: python36-0:3.6.8-38.module_el8.5.0+895+a459eca8 
INFO[0007] Selecting sssd-client: sssd-client-0:2.7.3-1.el8 
INFO[0007] Selecting centos-stream-release: centos-stream-release-0:8.6-1.el8 
INFO[0007] Solving.                                     
INFO[0007] Loading the Partial weighted MAXSAT problem. 
INFO[0010] Solving the Partial weighted MAXSAT problem. 
INFO[0010] Solution with weight 0 found.                
INFO[0010] Writing bazel files.                         
Package				Version					Size		Download Size
Installing:										
 expat				0:2.2.5-9.el8				317.50 K	115.90 K
 libpwquality			0:1.4.4-3.el8				409.00 K	109.43 K
 bash				0:4.4.20-4.el8				6.88 M		1.62 M
 libsigsegv			0:2.11-5.el8				48.83 K		30.98 K
 centos-gpg-keys		1:8-6.el8				6.28 K		14.63 K
 sssd-client			0:2.7.3-1.el8				343.60 K	237.16 K
 pam				0:1.3.1-22.el8				2.72 M		760.84 K
 filesystem			0:3.8-6.el8				215.45 K	1.14 M
 libattr			0:2.4.48-3.el8				28.38 K		27.56 K
 libacl				0:2.2.53-1.el8				60.18 K		35.62 K
 findutils			1:4.6.0-20.el8				1.83 M		540.71 K
 libverto			0:0.3.2-2.el8				28.70 K		24.60 K
 pcre				0:8.42-6.el8				512.34 K	215.63 K
 centos-stream-release		0:8.6-1.el8				29.43 K		22.74 K
 gmp				1:6.1.2-10.el8				1.68 M		329.75 K
 python3-pip-wheel		0:9.0.3-22.el8				930.56 K	916.30 K
 libnsl2			0:1.2.0-2.20180605git4a062cf.el8	148.31 K	59.10 K
 libffi				0:3.1-23.el8				55.29 K		38.32 K
 libxcrypt			0:4.1.1-6.el8				188.42 K	74.48 K
 zlib				0:1.2.11-19.el8				201.55 K	105.06 K
 tzdata				0:2022a-2.el8				2.18 M		485.40 K
 python3-setuptools-wheel	0:39.2.0-6.el8				348.48 K	295.73 K
 glibc-headers			0:2.28-208.el8				2.09 M		497.07 K
 coreutils-single		0:8.30-13.el8				1.38 M		644.08 K
 sqlite-libs			0:3.26.0-15.el8				1.17 M		594.68 K
 p11-kit			0:0.23.22-1.el8				1.65 M		332.07 K
 libmpc				0:1.1.0-9.1.el8				128.70 K	62.40 K
 gdbm-libs			1:1.18-2.el8				120.33 K	61.79 K
 glibc				0:2.28-208.el8				6.79 M		2.31 M
 pkgconf-m4			0:1.4.2-1.el8				14.60 K		17.44 K
 gdbm				1:1.18-2.el8				394.69 K	132.78 K
 bzip2-libs			0:1.0.6-26.el8				78.42 K		49.10 K
 isl				0:0.16.1-6.el8				3.27 M		861.18 K
 grep				0:3.1-6.el8				845.03 K	280.36 K
 audit-libs			0:3.0.7-4.el8				310.77 K	125.88 K
 xz-libs			0:5.2.4-4.el8				166.00 K	96.08 K
 vim-minimal			2:8.0.1763-19.el8.4			1.19 M		588.76 K
 binutils			0:2.30-117.el8				24.97 M		6.09 M
 chkconfig			0:1.19.1-1.el8				843.79 K	203.05 K
 glibc-minimal-langpack		0:2.28-208.el8				124		64.48 K
 libpkgconf			0:1.4.2-1.el8				69.30 K		35.61 K
 libcurl-minimal		0:7.61.1-25.el8				557.43 K	295.36 K
 popt				0:1.18-1.el8				133.12 K	62.82 K
 cracklib-dicts			0:2.9.6-15.el8				9.82 M		4.14 M
 ca-certificates		0:2021.2.50-82.el8			936.15 K	399.50 K
 krb5-libs			0:1.18.2-21.el8				2.25 M		860.54 K
 platform-python		0:3.6.8-47.el8				43.80 K		87.83 K
 sed				0:4.5-5.el8				773.39 K	305.33 K
 libdb				0:5.3.28-42.el8_4			1.90 M		769.40 K
 python3-pip			0:9.0.3-22.el8				4.17 K		20.57 K
 libsss_nss_idmap		0:2.7.3-1.el8				95.18 K		136.98 K
 gcc				0:8.5.0-15.el8				61.78 M		24.59 M
 python3-setuptools		0:39.2.0-6.el8				463.97 K	166.50 K
 libcap				0:2.48-4.el8				169.93 K	75.80 K
 libcap-ng			0:0.7.11-1.el8				52.67 K		34.19 K
 glibc-common			0:2.28-208.el8				8.01 M		1.04 M
 readline			0:7.0-10.el8				468.61 K	204.02 K
 keyutils-libs			0:1.5.10-9.el8				45.16 K		34.78 K
 libselinux			0:2.9-5.el8				170.92 K	169.13 K
 platform-python-setuptools	0:39.2.0-6.el8				2.99 M		647.44 K
 libsss_idmap			0:2.7.3-1.el8				73.06 K		128.45 K
 libgcc				0:8.5.0-15.el8				192.02 K	82.59 K
 python36			0:3.6.8-38.module_el8.5.0+895+a459eca8	14.15 K		19.81 K
 libxcrypt-devel		0:4.1.1-6.el8				26.52 K		25.81 K
 mpfr				0:3.1.6-1.el8				614.92 K	226.70 K
 acl				0:2.2.53-1.el8				209.64 K	82.99 K
 openssl-libs			1:1.1.1k-6.el8				3.77 M		1.54 M
 gawk				0:4.2.1-4.el8				2.72 M		1.19 M
 setup				0:2.12.2-7.el8				729.30 K	185.09 K
 cpp				0:8.5.0-15.el8				29.69 M		10.94 M
 ncurses-base			0:6.1-9.20180224.el8			314.23 K	83.08 K
 cracklib			0:2.9.6-15.el8				250.87 K	95.50 K
 glibc-devel			0:2.28-208.el8				243.91 K	83.06 K
 p11-kit-trust			0:0.23.22-1.el8				473.54 K	140.29 K
 info				0:6.5-7.el8_5				387.26 K	203.23 K
 centos-stream-repos		0:8-6.el8				30.21 K		20.59 K
 libnghttp2			0:1.33.0-3.el8_2.1			169.26 K	79.21 K
 basesystem			0:11-5.el8				124		10.75 K
 libgomp			0:8.5.0-15.el8				333.47 K	212.10 K
 libxcrypt-static		0:4.1.1-6.el8				325.45 K	57.56 K
 glibc-static			0:2.28-208.el8				25.92 M		2.17 M
 libsepol			0:2.9-3.el8				762.65 K	348.04 K
 libstdc++			0:8.5.0-15.el8				1.86 M		464.94 K
 libtasn1			0:4.13-3.el8				170.78 K	78.01 K
 curl				0:7.61.1-25.el8				703.48 K	360.54 K
 python3-libs			0:3.6.8-47.el8				32.78 M		8.23 M
 platform-python-pip		0:9.0.3-22.el8				7.29 M		1.69 M
 gzip				0:1.9-13.el8				358.66 K	170.78 K
 ncurses-libs			0:6.1-9.20180224.el8			958.61 K	341.76 K
 pkgconf-pkg-config		0:1.4.2-1.el8				3.93 K		15.59 K
 libcom_err			0:1.45.6-5.el8				62.58 K		50.52 K
 pkgconf			0:1.4.2-1.el8				65.14 K		38.95 K
 kernel-headers			0:4.18.0-408.el8			5.61 M		10.32 M
 libtirpc			0:1.1.4-7.el8				226.51 K	115.29 K
 pcre2				0:10.32-3.el8				659.32 K	252.57 K
 crypto-policies		0:20211116-1.gitae470d6.el8		94.23 K		65.20 K
Ignoring:										
											
Transaction Summary:									
Installing 96 Packages 									
Total download size: 94.41 M								
Total install size: 273.39 M								
+ bazel run --config=x86_64 //:bazeldnf -- rpmtree --public --nobest --name launcherbase_x86_64 --basesystem centos-stream-release --force-ignore-with-dependencies '^mozjs60' --force-ignore-with-dependencies python --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal libvirt-client-0:8.0.0-2.module_el8.6.0+1087+b42c8331 libvirt-daemon-driver-qemu-0:8.0.0-2.module_el8.6.0+1087+b42c8331 qemu-kvm-core-15:6.2.0-5.module_el8.6.0+1087+b42c8331 edk2-ovmf-0:20220126gitbb1bba3d77-2.el8 qemu-kvm-hw-usbredir-15:6.2.0-5.module_el8.6.0+1087+b42c8331 seabios-0:1.15.0-1.module_el8.6.0+1087+b42c8331 ethtool findutils iptables nftables nmap-ncat procps-ng selinux-policy selinux-policy-targeted tar xorriso
INFO: Analyzed target //:bazeldnf (4 packages loaded, 148 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 0.699s, Critical Path: 0.03s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Running command line: bazel-bin/bazeldnf.bash rpmtree --public --nobest --name launcherbase_x86_64 --basesystem centos-stream-release --force-ignore-with-dependencies '^mozjs60' --force-ignore-with-dependencies python --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal libvirt-client-0:8.0.0-2.module_el8.6.0+1087+b42c8331 libvirt-daemon-driver-qemu-0:8.0.0-2.module_el8.6.0+1087+b42c8331 qemu-kvm-core-15:6.2.0-5.module_el8.6.0+1087+b42c8331 edk2-ovmf-0:2022
INFO: Build completed successfully, 1 total action
INFO[0000] Loading packages.                            
INFO[0006] Initial reduction of involved packages.      
INFO[0007] Loading involved packages into the rpmtreer. 
WARN[0007] Package python3-policycoreutils-0:2.9-15.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-37.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-0:3.9.13-1.module_el8.7.0+1178+0ba51308 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-audit-0:3.0.7-3.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-38.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-pip-wheel-0:20.2.4-6.module_el8.6.0+930+10acc06f is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-44.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-setuptools-wheel-0:41.6.0-5.module_el8.5.0+896+eb9e77ba is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-libs-0:3.9.6-1.module_el8.5.0+872+ab54e8e5 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-libs-0:3.8.8-4.module_el8.5.0+896+eb9e77ba is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-libs-0:3.8.8-3.module_el8.5.0+871+689c57c1 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-pip-wheel-0:9.0.3-20.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-47.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libselinux-0:2.9-5.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-setools-0:4.3.0-2.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-38.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-setuptools-wheel-0:50.3.2-4.module_el8.5.0+897+68c4c210 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-0:3.9.2-1.module_el8.5.0+738+dc19af12 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-41.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-setuptools-wheel-0:39.2.0-6.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-0:3.8.8-3.module_el8.5.0+871+689c57c1 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-setuptools-wheel-0:39.0.1-13.module_el8.5.0+743+cd2f5d28 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-0:2.7.18-11.module_el8.7.0+1179+42dadd5f is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-libs-0:3.9.7-1.module_el8.6.0+930+10acc06f is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-40.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-pip-wheel-0:19.3.1-2.module_el8.5.0+831+7c139a3b is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-0:3.8.8-4.module_el8.5.0+896+eb9e77ba is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-37.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-audit-0:3.0-0.17.20191104git1c2f876.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-setuptools-wheel-0:50.3.2-3.module_el8.5.0+738+dc19af12 is forcefully ignored by regex 'python'. 
WARN[0007] Package policycoreutils-python-utils-0:2.9-17.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-45.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-pip-wheel-0:19.3.1-3.module_el8.5.0+855+e844d92d is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-47.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-0:2.7.18-4.module_el8.5.0+743+cd2f5d28 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-libs-0:3.8.12-1.module_el8.6.0+929+89303463 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-libs-0:3.8.8-1.module_el8.5.0+758+421c7348 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-libs-0:3.9.13-1.module_el8.7.0+1178+0ba51308 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-pip-wheel-0:19.3.1-6.module_el8.7.0+1184+30eba247 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-0:3.9.2-2.module_el8.5.0+766+33a59395 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-pip-wheel-0:9.0.3-22.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-libs-0:2.7.18-11.module_el8.7.0+1179+42dadd5f is forcefully ignored by regex 'python'. 
WARN[0007] Package policycoreutils-python-utils-0:2.9-19.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-policycoreutils-0:2.9-17.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-setuptools-wheel-0:41.6.0-4.module_el8.5.0+742+dbad1979 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-pip-wheel-0:19.3.1-1.module_el8.5.0+742+dbad1979 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-setools-0:4.3.0-3.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-libs-0:2.7.18-5.module_el8.5.0+763+a555e7f1 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-libs-0:3.9.6-2.module_el8.5.0+897+68c4c210 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-0:3.8.8-1.module_el8.5.0+758+421c7348 is forcefully ignored by regex 'python'. 
WARN[0007] Package policycoreutils-python-utils-0:2.9-15.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-0:2.7.18-10.module_el8.6.0+1092+a03304bb is forcefully ignored by regex 'python'. 
WARN[0007] Package policycoreutils-python-utils-0:2.9-16.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-39.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-pip-wheel-0:20.2.4-4.module_el8.5.0+832+b0e10cdc is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-40.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-pip-wheel-0:19.3.1-5.module_el8.6.0+960+f11a9b17 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-0:2.7.18-7.module_el8.5.0+894+1c54b371 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-0:2.7.17-1.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-pip-wheel-0:9.0.3-19.module_el8.6.0+987+71f62bb6 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-policycoreutils-0:2.9-14.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-libs-0:2.7.17-1.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-policycoreutils-0:2.9-19.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-libs-0:3.9.2-1.module_el8.5.0+738+dc19af12 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-pip-wheel-0:20.2.4-7.module_el8.6.0+961+ca697fb5 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-pip-wheel-0:9.0.3-18.module_el8.4.0+642+1dc4fb01 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-42.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-setuptools-0:39.2.0-6.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-libs-0:2.7.18-8.module_el8.6.0+940+9e7326fe is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-libs-0:3.8.8-2.module_el8.5.0+765+e829a51d is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-libs-0:2.7.18-6.module_el8.5.0+772+8dae0bfd is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-pip-wheel-0:9.0.3-18.module_el8.5.0+743+cd2f5d28 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-setuptools-wheel-0:39.0.1-13.module_el8.4.0+642+1dc4fb01 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-for-tests-0:2.7.17-1.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-0:3.8.12-1.module_el8.6.0+929+89303463 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-0:3.9.6-1.module_el8.5.0+872+ab54e8e5 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-41.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-policycoreutils-0:2.9-18.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-42.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-0:2.7.18-8.module_el8.6.0+940+9e7326fe is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libsemanage-0:2.9-6.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-pip-wheel-0:19.3.1-4.module_el8.5.0+896+eb9e77ba is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-0:3.8.6-3.module_el8.5.0+742+dbad1979 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-46.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-audit-0:3.0.7-1.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-libs-0:3.8.6-3.module_el8.5.0+742+dbad1979 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-46.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-0:3.9.7-1.module_el8.6.0+930+10acc06f is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-setuptools-wheel-0:50.3.2-4.module_el8.6.0+930+10acc06f is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-setuptools-wheel-0:41.6.0-5.module_el8.6.0+929+89303463 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-libs-0:2.7.18-10.module_el8.6.0+1092+a03304bb is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-0:3.8.13-1.module_el8.7.0+1177+19c53253 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-39.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-44.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-0:2.7.18-6.module_el8.5.0+772+8dae0bfd is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-libs-0:2.7.18-7.module_el8.5.0+894+1c54b371 is forcefully ignored by regex 'python'. 
WARN[0007] Package policycoreutils-python-utils-0:2.9-14.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-45.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-policycoreutils-0:2.9-16.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-libs-0:2.7.18-4.module_el8.5.0+743+cd2f5d28 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-audit-0:3.0.7-4.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-pip-wheel-0:9.0.3-19.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-pip-wheel-0:20.2.4-5.module_el8.5.0+859+e98e3670 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-pip-wheel-0:20.2.4-6.module_el8.5.0+897+68c4c210 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libsemanage-0:2.9-8.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-pip-wheel-0:19.3.1-4.module_el8.6.0+929+89303463 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-0:3.9.6-2.module_el8.5.0+897+68c4c210 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-audit-0:3.0.7-2.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package mozjs60-0:60.9.0-4.el8 is forcefully ignored by regex '^mozjs60'. 
WARN[0007] Package policycoreutils-python-utils-0:2.9-18.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-0:2.7.18-5.module_el8.5.0+763+a555e7f1 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-pip-wheel-0:20.2.4-3.module_el8.5.0+738+dc19af12 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-libs-0:3.9.2-2.module_el8.5.0+766+33a59395 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-libs-0:3.8.13-1.module_el8.7.0+1177+19c53253 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-0:3.8.8-2.module_el8.5.0+765+e829a51d is forcefully ignored by regex 'python'. 
INFO[0007] Loaded 5149 packages.                        
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] Generated 22652 variables.                   
INFO[0007] Adding required packages to the rpmtreer.    
INFO[0007] Selecting acl: acl-0:2.2.53-1.el8            
INFO[0007] Selecting curl: curl-0:7.61.1-25.el8         
INFO[0007] Selecting vim-minimal: vim-minimal-2:8.0.1763-19.el8.4 
INFO[0007] Selecting coreutils-single: coreutils-single-0:8.30-13.el8 
INFO[0007] Selecting glibc-minimal-langpack: glibc-minimal-langpack-0:2.28-208.el8 
INFO[0007] Selecting libcurl-minimal: libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] Selecting libvirt-client: libvirt-client-0:8.0.0-2.module_el8.6.0+1087+b42c8331 
INFO[0007] Selecting libvirt-daemon-driver-qemu: libvirt-daemon-driver-qemu-0:8.0.0-2.module_el8.6.0+1087+b42c8331 
INFO[0007] Selecting qemu-kvm-core: qemu-kvm-core-15:6.2.0-5.module_el8.6.0+1087+b42c8331 
INFO[0007] Selecting edk2-ovmf: edk2-ovmf-0:20220126gitbb1bba3d77-2.el8 
INFO[0007] Selecting qemu-kvm-hw-usbredir: qemu-kvm-hw-usbredir-15:6.2.0-5.module_el8.6.0+1087+b42c8331 
INFO[0007] Selecting seabios: seabios-0:1.15.0-1.module_el8.6.0+1087+b42c8331 
INFO[0007] Selecting ethtool: ethtool-2:5.13-2.el8      
INFO[0007] Selecting findutils: findutils-1:4.6.0-20.el8 
INFO[0007] Selecting iptables: iptables-0:1.8.4-22.el8  
INFO[0007] Selecting nftables: nftables-1:0.9.3-26.el8  
INFO[0007] Selecting nmap-ncat: nmap-ncat-2:7.70-7.el8  
INFO[0007] Selecting procps-ng: procps-ng-0:3.3.15-7.el8 
INFO[0007] Selecting selinux-policy: selinux-policy-0:3.14.3-104.el8 
INFO[0007] Selecting selinux-policy-targeted: selinux-policy-targeted-0:3.14.3-104.el8 
INFO[0007] Selecting tar: tar-2:1.30-6.el8              
INFO[0007] Selecting xorriso: xorriso-0:1.4.8-4.el8     
INFO[0007] Selecting centos-stream-release: centos-stream-release-0:8.6-1.el8 
INFO[0007] Solving.                                     
INFO[0007] Loading the Partial weighted MAXSAT problem. 
INFO[0014] Solving the Partial weighted MAXSAT problem. 
INFO[0014] Solution with weight 9206 found.             
INFO[0014] Picking libvirt-daemon-0:8.0.0-2.module_el8.6.0+1087+b42c8331 instead of best candiate libvirt-daemon-0:8.0.0-6.module_el8.7.0+1140+ff0772f9 
INFO[0014] Picking libvirt-libs-0:8.0.0-2.module_el8.6.0+1087+b42c8331 instead of best candiate libvirt-libs-0:8.0.0-6.module_el8.7.0+1140+ff0772f9 
INFO[0014] Picking seavgabios-bin-0:1.15.0-1.module_el8.6.0+1087+b42c8331 instead of best candiate seavgabios-bin-0:1.16.0-1.module_el8.7.0+1140+ff0772f9 
INFO[0014] Picking seabios-bin-0:1.15.0-1.module_el8.6.0+1087+b42c8331 instead of best candiate seabios-bin-0:1.16.0-1.module_el8.7.0+1140+ff0772f9 
INFO[0014] Picking qemu-img-15:6.2.0-5.module_el8.6.0+1087+b42c8331 instead of best candiate qemu-img-15:6.2.0-12.module_el8.7.0+1140+ff0772f9 
INFO[0014] Picking qemu-kvm-common-15:6.2.0-5.module_el8.6.0+1087+b42c8331 instead of best candiate qemu-kvm-common-15:6.2.0-12.module_el8.7.0+1140+ff0772f9 
INFO[0014] Writing bazel files.                         
Package				Version								Size		Download Size
Installing:													
 kmod				0:25-19.el8							249.21 K	129.17 K
 centos-stream-release		0:8.6-1.el8							29.43 K		22.74 K
 libfdt				0:1.6.0-1.el8							56.46 K		32.62 K
 libdb-utils			0:5.3.28-42.el8_4						379.20 K	153.24 K
 iptables-libs			0:1.8.4-22.el8							206.50 K	110.38 K
 libsemanage			0:2.9-8.el8							314.37 K	171.92 K
 libmount			0:2.32.1-35.el8							399.50 K	240.58 K
 tzdata				0:2022a-2.el8							2.18 M		485.40 K
 libvirt-daemon-driver-qemu	0:8.0.0-2.module_el8.6.0+1087+b42c8331				2.66 M		941.22 K
 dbus-tools			1:1.12.8-19.el8							128.05 K	87.70 K
 yajl				0:2.1.0-11.el8							85.42 K		41.67 K
 libverto			0:0.3.2-2.el8							28.70 K		24.60 K
 libsmartcols			0:2.32.1-35.el8							249.71 K	182.16 K
 dmidecode			1:3.3-4.el8							230.33 K	94.38 K
 libsepol			0:2.9-3.el8							762.65 K	348.04 K
 qemu-kvm-core			15:6.2.0-5.module_el8.6.0+1087+b42c8331				17.31 M		3.52 M
 libvirt-daemon			0:8.0.0-2.module_el8.6.0+1087+b42c8331				1.62 M		425.96 K
 polkit-pkla-compat		0:0.1-12.el8							100.51 K	46.97 K
 dbus-common			1:1.12.8-19.el8							12.92 K		47.28 K
 libxkbcommon			0:0.9.1-1.el8							276.03 K	118.56 K
 nmap-ncat			2:7.70-7.el8							495.56 K	242.40 K
 systemd-container		0:239-60.el8							1.72 M		776.64 K
 libffi				0:3.1-23.el8							55.29 K		38.32 K
 lua-libs			0:5.3.4-12.el8							248.67 K	120.76 K
 gettext-libs			0:0.19.8.1-17.el8						1.62 M		321.58 K
 unbound-libs			0:1.16.0-2.el8							1.55 M		580.36 K
 tar				2:1.30-6.el8							2.89 M		858.43 K
 bzip2				0:1.0.6-26.el8							98.39 K		61.62 K
 device-mapper			8:1.02.181-3.el8						361.68 K	386.22 K
 filesystem			0:3.8-6.el8							215.45 K	1.14 M
 nettle				0:3.4.1-7.el8							575.76 K	308.24 K
 edk2-ovmf			0:20220126gitbb1bba3d77-2.el8					12.12 M		3.79 M
 zlib				0:1.2.11-19.el8							201.55 K	105.06 K
 elfutils-libs			0:0.187-4.el8							715.10 K	304.02 K
 dbus				1:1.12.8-19.el8							124		42.43 K
 libstdc++			0:8.5.0-15.el8							1.86 M		464.94 K
 gnutls				0:3.6.16-4.el8							3.01 M		1.04 M
 libvirt-libs			0:8.0.0-2.module_el8.6.0+1087+b42c8331				24.49 M		4.94 M
 autogen-libopts		0:5.18.12-8.el8							151.05 K	76.80 K
 seavgabios-bin			0:1.15.0-1.module_el8.6.0+1087+b42c8331				216.22 K	44.16 K
 chkconfig			0:1.19.1-1.el8							843.79 K	203.05 K
 polkit-libs			0:0.115-13.0.1.el8.2						198.83 K	78.30 K
 cracklib			0:2.9.6-15.el8							250.87 K	95.50 K
 libevent			0:2.1.8-5.el8							925.20 K	259.53 K
 curl				0:7.61.1-25.el8							703.48 K	360.54 K
 sed				0:4.5-5.el8							773.39 K	305.33 K
 ncurses-base			0:6.1-9.20180224.el8						314.23 K	83.08 K
 cyrus-sasl			0:2.1.27-6.el8_5						156.32 K	98.72 K
 seabios			0:1.15.0-1.module_el8.6.0+1087+b42c8331				44.06 K		32.07 K
 pixman				0:0.38.4-2.el8							698.60 K	263.56 K
 swtpm				0:0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331	219.14 K	43.63 K
 libpmem			0:1.11.1-1.module_el8.6.0+1088+6891f51c				425.45 K	114.69 K
 basesystem			0:11-5.el8							124		10.75 K
 device-mapper-multipath-libs	0:0.8.4-26.el8							814.34 K	336.80 K
 libnsl2			0:1.2.0-2.20180605git4a062cf.el8				148.31 K	59.10 K
 ndctl-libs			0:71.1-4.el8							207.68 K	81.70 K
 libssh-config			0:0.9.6-3.el8							816		19.75 K
 pcre2				0:10.32-3.el8							659.32 K	252.57 K
 libisoburn			0:1.4.8-4.el8							1.10 M		419.54 K
 lzo				0:2.08-14.el8							200.48 K	70.85 K
 lzop				0:1.03-20.el8							116.16 K	63.36 K
 nftables			1:0.9.3-26.el8							849.14 K	332.34 K
 glibc				0:2.28-208.el8							6.79 M		2.31 M
 libselinux-utils		0:2.9-5.el8							328.67 K	248.57 K
 glib2				0:2.56.4-159.el8						12.30 M		2.61 M
 libsigsegv			0:2.11-5.el8							48.83 K		30.98 K
 libisofs			0:1.4.8-3.el8							501.01 K	226.26 K
 libbpf				0:0.5.0-1.el8							308.74 K	139.97 K
 numad				0:0.5-26.20150602git.el8					60.31 K		42.23 K
 systemd-pam			0:239-60.el8							919.54 K	496.20 K
 libattr			0:2.4.48-3.el8							28.38 K		27.56 K
 setup				0:2.12.2-7.el8							729.30 K	185.09 K
 glibc-minimal-langpack		0:2.28-208.el8							124		64.48 K
 libxcrypt			0:4.1.1-6.el8							188.42 K	74.48 K
 swtpm-tools			0:0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331	275.40 K	121.56 K
 lz4-libs			0:1.8.3-3.el8_4							122.25 K	67.35 K
 libidn2			0:2.2.0-1.el8							293.60 K	96.02 K
 grep				0:3.1-6.el8							845.03 K	280.36 K
 xz-libs			0:5.2.4-4.el8							166.00 K	96.08 K
 centos-gpg-keys		1:8-6.el8							6.28 K		14.63 K
 numactl-libs			0:2.0.12-13.el8							52.09 K		36.99 K
 p11-kit-trust			0:0.23.22-1.el8							473.54 K	140.29 K
 popt				0:1.18-1.el8							133.12 K	62.82 K
 libnl3				0:3.7.0-1.el8							1.06 M		345.42 K
 acl				0:2.2.53-1.el8							209.64 K	82.99 K
 polkit				0:0.115-13.0.1.el8.2						417.58 K	157.70 K
 timedatex			0:0.5-3.el8							57.87 K		33.10 K
 bash				0:4.4.20-4.el8							6.88 M		1.62 M
 libcom_err			0:1.45.6-5.el8							62.58 K		50.52 K
 libnftnl			0:1.1.5-5.el8							223.62 K	84.97 K
 swtpm-libs			0:0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331	99.70 K		49.81 K
 libnfnetlink			0:1.0.1-13.el8							53.90 K		33.72 K
 pam				0:1.3.1-22.el8							2.72 M		760.84 K
 libarchive			0:3.3.3-4.el8							840.36 K	368.60 K
 libburn			0:1.4.8-3.el8							380.83 K	177.44 K
 libcroco			0:0.6.12-4.el8_2.1						333.22 K	115.22 K
 libcap-ng			0:0.7.11-1.el8							52.67 K		34.19 K
 libpcap			14:1.9.1-5.el8							387.00 K	172.74 K
 jansson			0:2.14-1.el8							85.16 K		48.52 K
 gzip				0:1.9-13.el8							358.66 K	170.78 K
 snappy				0:1.1.8-3.el8							62.25 K		37.95 K
 openssl-libs			1:1.1.1k-6.el8							3.77 M		1.54 M
 psmisc				0:23.1-5.el8							503.50 K	154.36 K
 libutempter			0:1.1.6-14.el8							54.63 K		32.46 K
 rpm				0:4.14.3-23.el8							2.12 M		556.35 K
 krb5-libs			0:1.18.2-21.el8							2.25 M		860.54 K
 libnghttp2			0:1.33.0-3.el8_2.1						169.26 K	79.21 K
 dbus-daemon			1:1.12.8-19.el8							565.57 K	246.20 K
 ipxe-roms-qemu			0:20181214-9.git133f4c47.el8					2.71 M		1.29 M
 userspace-rcu			0:0.10.1-4.el8							332.03 K	103.22 K
 pcre				0:8.42-6.el8							512.34 K	215.63 K
 findutils			1:4.6.0-20.el8							1.83 M		540.71 K
 systemd-libs			0:239-60.el8							4.58 M		1.15 M
 bzip2-libs			0:1.0.6-26.el8							78.42 K		49.10 K
 p11-kit			0:0.23.22-1.el8							1.65 M		332.07 K
 gnutls-dane			0:3.6.16-4.el8							47.14 K		53.34 K
 gmp				1:6.1.2-10.el8							1.68 M		329.75 K
 coreutils-single		0:8.30-13.el8							1.38 M		644.08 K
 libfdisk			0:2.32.1-35.el8							440.11 K	258.05 K
 ncurses-libs			0:6.1-9.20180224.el8						958.61 K	341.76 K
 libibverbs			0:37.2-1.el8							1.02 M		393.71 K
 diffutils			0:3.6-6.el8							1.38 M		366.90 K
 libvirt-client			0:8.0.0-2.module_el8.6.0+1087+b42c8331				1.02 M		421.06 K
 iptables			0:1.8.4-22.el8							2.03 M		598.52 K
 libzstd			0:1.4.4-1.el8							699.40 K	272.32 K
 json-c				0:0.13.1-3.el8							70.64 K		41.66 K
 libgcc				0:8.5.0-15.el8							192.02 K	82.59 K
 dbus-libs			1:1.12.8-19.el8							381.96 K	188.54 K
 libxml2			0:2.9.7-14.el8							1.76 M		712.30 K
 seabios-bin			0:1.15.0-1.module_el8.6.0+1087+b42c8331				393.76 K	139.44 K
 xz				0:5.2.4-4.el8							431.14 K	156.84 K
 libselinux			0:2.9-5.el8							170.92 K	169.13 K
 iproute			0:5.18.0-1.el8							2.51 M		827.78 K
 selinux-policy			0:3.14.3-104.el8						26.06 K		665.72 K
 gawk				0:4.2.1-4.el8							2.72 M		1.19 M
 openldap			0:2.4.46-18.el8							1.01 M		360.92 K
 libcap				0:2.48-4.el8							169.93 K	75.80 K
 libtpms			0:0.9.1-0.20211126git1ff6fe1f43.module_el8.6.0+1087+b42c8331	403.98 K	188.85 K
 cracklib-dicts			0:2.9.6-15.el8							9.82 M		4.14 M
 systemd			0:239-60.el8							11.38 M		3.77 M
 glibc-common			0:2.28-208.el8							8.01 M		1.04 M
 device-mapper-libs		8:1.02.181-3.el8						416.90 K	419.34 K
 libusbx			0:1.0.23-4.el8							155.92 K	76.05 K
 sqlite-libs			0:3.26.0-15.el8							1.17 M		594.68 K
 libaio				0:0.3.112-1.el8							98.80 K		33.41 K
 libunistring			0:0.9.9-3.el8							1.86 M		432.42 K
 cryptsetup-libs		0:2.3.7-2.el8							2.15 M		499.32 K
 qemu-kvm-hw-usbredir		15:6.2.0-5.module_el8.6.0+1087+b42c8331				68.22 K		184.44 K
 elfutils-default-yama-scope	0:0.187-4.el8							2.09 K		52.83 K
 libacl				0:2.2.53-1.el8							60.18 K		35.62 K
 mpfr				0:3.1.6-1.el8							614.92 K	226.70 K
 gettext			0:0.19.8.1-17.el8						5.45 M		1.12 M
 ca-certificates		0:2021.2.50-82.el8						936.15 K	399.50 K
 selinux-policy-targeted	0:3.14.3-104.el8						44.06 M		15.87 M
 libuuid			0:2.32.1-35.el8							36.42 K		99.23 K
 libseccomp			0:2.5.2-1.el8							171.61 K	72.91 K
 usbredir			0:0.12.0-1.el8							111.05 K	53.16 K
 procps-ng			0:3.3.15-7.el8							914.03 K	336.80 K
 audit-libs			0:3.0.7-4.el8							310.77 K	125.88 K
 libpwquality			0:1.4.4-3.el8							409.00 K	109.43 K
 libpng				2:1.6.34-5.el8							236.65 K	128.98 K
 cyrus-sasl-lib			0:2.1.27-6.el8_5						732.16 K	126.32 K
 libtirpc			0:1.1.4-7.el8							226.51 K	115.29 K
 info				0:6.5-7.el8_5							387.26 K	203.23 K
 libcurl-minimal		0:7.61.1-25.el8							557.43 K	295.36 K
 shadow-utils			2:4.6-16.el8							4.13 M		1.29 M
 cyrus-sasl-gssapi		0:2.1.27-6.el8_5						42.86 K		51.06 K
 libblkid			0:2.32.1-35.el8							345.00 K	223.77 K
 libmnl				0:1.0.4-6.el8							55.15 K		31.04 K
 ethtool			2:5.13-2.el8							665.77 K	225.93 K
 readline			0:7.0-10.el8							468.61 K	204.02 K
 policycoreutils		0:2.9-19.el8							696.88 K	383.17 K
 libdb				0:5.3.28-42.el8_4						1.90 M		769.40 K
 expat				0:2.2.5-9.el8							317.50 K	115.90 K
 sgabios-bin			1:0.20170427git-3.module_el8.6.0+983+a7505f3f			4.50 K		13.73 K
 daxctl-libs			0:71.1-4.el8							80.62 K		42.85 K
 util-linux			0:2.32.1-35.el8							11.65 M		2.59 M
 libgcrypt			0:1.8.5-7.el8							1.27 M		473.84 K
 gnutls-utils			0:3.6.16-4.el8							1.52 M		356.62 K
 xorriso			0:1.4.8-4.el8							281.61 K	288.19 K
 libtasn1			0:4.13-3.el8							170.78 K	78.01 K
 elfutils-libelf		0:0.187-4.el8							1.03 M		236.61 K
 rpm-libs			0:4.14.3-23.el8							737.20 K	353.40 K
 rpm-plugin-selinux		0:4.14.3-23.el8							12.75 K		79.46 K
 librdmacm			0:37.2-1.el8							145.29 K	79.63 K
 crypto-policies		0:20211116-1.gitae470d6.el8					94.23 K		65.20 K
 libnetfilter_conntrack		0:1.0.6-5.el8							166.47 K	66.28 K
 keyutils-libs			0:1.5.10-9.el8							45.16 K		34.78 K
 json-glib			0:1.4.4-1.el8							541.04 K	147.74 K
 libgomp			0:8.5.0-15.el8							333.47 K	212.10 K
 qemu-img			15:6.2.0-5.module_el8.6.0+1087+b42c8331				8.57 M		2.25 M
 libssh				0:0.9.6-3.el8							519.94 K	221.38 K
 vim-minimal			2:8.0.1763-19.el8.4						1.19 M		588.76 K
 centos-stream-repos		0:8-6.el8							30.21 K		20.59 K
 xkeyboard-config		0:2.28-1.el8							5.74 M		800.95 K
 qemu-kvm-common		15:6.2.0-5.module_el8.6.0+1087+b42c8331				3.71 M		1.09 M
 libgpg-error			0:1.31-1.el8							908.91 K	247.52 K
 kmod-libs			0:25-19.el8							127.82 K	70.08 K
 iproute-tc			0:5.18.0-1.el8							910.20 K	477.10 K
Ignoring:													
 policycoreutils-python-utils	0:2.9-19.el8							147.96 K	258.84 K
 mozjs60			0:60.9.0-4.el8							23.73 M		6.93 M
 python3-libs			0:3.6.8-47.el8							32.78 M		8.23 M
 platform-python		0:3.6.8-47.el8							43.80 K		87.83 K
														
Transaction Summary:												
Installing 199 Packages 											
Total download size: 98.54 M											
Total install size: 309.13 M											
+ bazel run --config=x86_64 //:bazeldnf -- rpmtree --public --nobest --name handlerbase_x86_64 --basesystem centos-stream-release --force-ignore-with-dependencies python --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal qemu-img-15:6.2.0-5.module_el8.6.0+1087+b42c8331 findutils iproute iptables nftables procps-ng selinux-policy selinux-policy-targeted tar util-linux xorriso
INFO: Analyzed target //:bazeldnf (4 packages loaded, 148 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 0.689s, Critical Path: 0.03s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Running command line: bazel-bin/bazeldnf.bash rpmtree --public --nobest --name handlerbase_x86_64 --basesystem centos-stream-release --force-ignore-with-dependencies python --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-la
INFO: Build completed successfully, 1 total action
INFO[0000] Loading packages.                            
INFO[0006] Initial reduction of involved packages.      
INFO[0007] Loading involved packages into the rpmtreer. 
WARN[0007] Package python2-0:2.7.18-5.module_el8.5.0+763+a555e7f1 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-38.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-0:2.7.18-6.module_el8.5.0+772+8dae0bfd is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-0:3.9.7-1.module_el8.6.0+930+10acc06f is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-libs-0:3.8.6-3.module_el8.5.0+742+dbad1979 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-pip-wheel-0:20.2.4-4.module_el8.5.0+832+b0e10cdc is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-setools-0:4.3.0-2.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-libs-0:3.9.6-2.module_el8.5.0+897+68c4c210 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-pip-wheel-0:9.0.3-22.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libsemanage-0:2.9-8.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-0:2.7.18-11.module_el8.7.0+1179+42dadd5f is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-audit-0:3.0-0.17.20191104git1c2f876.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-audit-0:3.0.7-3.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-47.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-libs-0:2.7.18-5.module_el8.5.0+763+a555e7f1 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-0:3.8.6-3.module_el8.5.0+742+dbad1979 is forcefully ignored by regex 'python'. 
WARN[0007] Package policycoreutils-python-utils-0:2.9-16.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-policycoreutils-0:2.9-14.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-41.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package policycoreutils-python-utils-0:2.9-17.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-37.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-0:3.9.2-2.module_el8.5.0+766+33a59395 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-pip-wheel-0:20.2.4-6.module_el8.6.0+930+10acc06f is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-libs-0:2.7.18-8.module_el8.6.0+940+9e7326fe is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-pip-wheel-0:9.0.3-19.module_el8.6.0+987+71f62bb6 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-libs-0:3.8.12-1.module_el8.6.0+929+89303463 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-pip-wheel-0:9.0.3-20.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-libs-0:2.7.18-7.module_el8.5.0+894+1c54b371 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-for-tests-0:2.7.17-1.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-pip-wheel-0:9.0.3-18.module_el8.5.0+743+cd2f5d28 is forcefully ignored by regex 'python'. 
WARN[0007] Package policycoreutils-python-utils-0:2.9-15.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-0:3.9.13-1.module_el8.7.0+1178+0ba51308 is forcefully ignored by regex 'python'. 
WARN[0007] Package policycoreutils-python-utils-0:2.9-18.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-libs-0:3.9.2-1.module_el8.5.0+738+dc19af12 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-pip-wheel-0:19.3.1-4.module_el8.5.0+896+eb9e77ba is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-setuptools-wheel-0:39.0.1-13.module_el8.5.0+743+cd2f5d28 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-setuptools-wheel-0:50.3.2-4.module_el8.6.0+930+10acc06f is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-libs-0:2.7.18-11.module_el8.7.0+1179+42dadd5f is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-0:2.7.18-7.module_el8.5.0+894+1c54b371 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-setuptools-0:39.2.0-6.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-pip-wheel-0:20.2.4-7.module_el8.6.0+961+ca697fb5 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-audit-0:3.0.7-1.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-44.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-setuptools-wheel-0:39.2.0-6.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-pip-wheel-0:20.2.4-5.module_el8.5.0+859+e98e3670 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-0:2.7.17-1.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-libs-0:3.8.8-4.module_el8.5.0+896+eb9e77ba is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-pip-wheel-0:19.3.1-4.module_el8.6.0+929+89303463 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-45.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-policycoreutils-0:2.9-17.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-audit-0:3.0.7-2.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-setools-0:4.3.0-3.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-44.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libsemanage-0:2.9-6.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-policycoreutils-0:2.9-15.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-pip-wheel-0:19.3.1-3.module_el8.5.0+855+e844d92d is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-pip-wheel-0:19.3.1-6.module_el8.7.0+1184+30eba247 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-45.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-0:3.8.8-3.module_el8.5.0+871+689c57c1 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-setuptools-wheel-0:41.6.0-4.module_el8.5.0+742+dbad1979 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-40.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-0:2.7.18-8.module_el8.6.0+940+9e7326fe is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-42.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-libs-0:2.7.18-6.module_el8.5.0+772+8dae0bfd is forcefully ignored by regex 'python'. 
WARN[0007] Package policycoreutils-python-utils-0:2.9-14.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-39.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-0:3.8.8-4.module_el8.5.0+896+eb9e77ba is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-pip-wheel-0:19.3.1-5.module_el8.6.0+960+f11a9b17 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-libs-0:3.8.8-3.module_el8.5.0+871+689c57c1 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-46.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-libs-0:3.9.6-1.module_el8.5.0+872+ab54e8e5 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-0:2.7.18-10.module_el8.6.0+1092+a03304bb is forcefully ignored by regex 'python'. 
WARN[0007] Package policycoreutils-python-utils-0:2.9-19.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-audit-0:3.0.7-4.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-39.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-0:3.9.6-2.module_el8.5.0+897+68c4c210 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-pip-wheel-0:20.2.4-3.module_el8.5.0+738+dc19af12 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-setuptools-wheel-0:41.6.0-5.module_el8.5.0+896+eb9e77ba is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-pip-wheel-0:19.3.1-2.module_el8.5.0+831+7c139a3b is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-0:3.9.6-1.module_el8.5.0+872+ab54e8e5 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-policycoreutils-0:2.9-16.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-libs-0:3.9.13-1.module_el8.7.0+1178+0ba51308 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-setuptools-wheel-0:41.6.0-5.module_el8.6.0+929+89303463 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-setuptools-wheel-0:39.0.1-13.module_el8.4.0+642+1dc4fb01 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-0:3.8.13-1.module_el8.7.0+1177+19c53253 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-libs-0:2.7.18-4.module_el8.5.0+743+cd2f5d28 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-37.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-46.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-libs-0:3.8.13-1.module_el8.7.0+1177+19c53253 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-47.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-0:3.8.12-1.module_el8.6.0+929+89303463 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-42.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-libs-0:3.8.8-2.module_el8.5.0+765+e829a51d is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-libs-0:3.8.8-1.module_el8.5.0+758+421c7348 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-pip-wheel-0:20.2.4-6.module_el8.5.0+897+68c4c210 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-libs-0:3.9.2-2.module_el8.5.0+766+33a59395 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-40.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-policycoreutils-0:2.9-19.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-libs-0:2.7.18-10.module_el8.6.0+1092+a03304bb is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-policycoreutils-0:2.9-18.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-pip-wheel-0:19.3.1-1.module_el8.5.0+742+dbad1979 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-setuptools-wheel-0:50.3.2-3.module_el8.5.0+738+dc19af12 is forcefully ignored by regex 'python'. 
WARN[0007] Package platform-python-0:3.6.8-38.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-0:3.8.8-1.module_el8.5.0+758+421c7348 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libselinux-0:2.9-5.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-setuptools-wheel-0:50.3.2-4.module_el8.5.0+897+68c4c210 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-pip-wheel-0:9.0.3-19.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-libs-0:2.7.17-1.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-0:2.7.18-4.module_el8.5.0+743+cd2f5d28 is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-libs-0:3.9.7-1.module_el8.6.0+930+10acc06f is forcefully ignored by regex 'python'. 
WARN[0007] Package python39-0:3.9.2-1.module_el8.5.0+738+dc19af12 is forcefully ignored by regex 'python'. 
WARN[0007] Package python3-libs-0:3.6.8-41.el8 is forcefully ignored by regex 'python'. 
WARN[0007] Package python38-0:3.8.8-2.module_el8.5.0+765+e829a51d is forcefully ignored by regex 'python'. 
WARN[0007] Package python2-pip-wheel-0:9.0.3-18.module_el8.4.0+642+1dc4fb01 is forcefully ignored by regex 'python'. 
INFO[0007] Loaded 4981 packages.                        
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0007] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0007] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0007] Generated 20979 variables.                   
INFO[0007] Adding required packages to the rpmtreer.    
INFO[0007] Selecting acl: acl-0:2.2.53-1.el8            
INFO[0007] Selecting curl: curl-0:7.61.1-25.el8         
INFO[0007] Selecting vim-minimal: vim-minimal-2:8.0.1763-19.el8.4 
INFO[0007] Selecting coreutils-single: coreutils-single-0:8.30-13.el8 
INFO[0007] Selecting glibc-minimal-langpack: glibc-minimal-langpack-0:2.28-208.el8 
INFO[0007] Selecting libcurl-minimal: libcurl-minimal-0:7.61.1-25.el8 
INFO[0007] Selecting qemu-img: qemu-img-15:6.2.0-5.module_el8.6.0+1087+b42c8331 
INFO[0007] Selecting findutils: findutils-1:4.6.0-20.el8 
INFO[0007] Selecting iproute: iproute-0:5.18.0-1.el8    
INFO[0007] Selecting iptables: iptables-0:1.8.4-22.el8  
INFO[0007] Selecting nftables: nftables-1:0.9.3-26.el8  
INFO[0007] Selecting procps-ng: procps-ng-0:3.3.15-7.el8 
INFO[0007] Selecting selinux-policy: selinux-policy-0:3.14.3-104.el8 
INFO[0007] Selecting selinux-policy-targeted: selinux-policy-targeted-0:3.14.3-104.el8 
INFO[0007] Selecting tar: tar-2:1.30-6.el8              
INFO[0007] Selecting util-linux: util-linux-0:2.32.1-35.el8 
INFO[0007] Selecting xorriso: xorriso-0:1.4.8-4.el8     
INFO[0007] Selecting centos-stream-release: centos-stream-release-0:8.6-1.el8 
INFO[0007] Solving.                                     
INFO[0007] Loading the Partial weighted MAXSAT problem. 
INFO[0013] Solving the Partial weighted MAXSAT problem. 
INFO[0013] Solution with weight 0 found.                
INFO[0013] Writing bazel files.                         
Package				Version					Size		Download Size
Installing:										
 mpfr				0:3.1.6-1.el8				614.92 K	226.70 K
 libburn			0:1.4.8-3.el8				380.83 K	177.44 K
 libibverbs			0:37.2-1.el8				1.02 M		393.71 K
 libzstd			0:1.4.4-1.el8				699.40 K	272.32 K
 procps-ng			0:3.3.15-7.el8				914.03 K	336.80 K
 glibc				0:2.28-208.el8				6.79 M		2.31 M
 glibc-minimal-langpack		0:2.28-208.el8				124		64.48 K
 gzip				0:1.9-13.el8				358.66 K	170.78 K
 lz4-libs			0:1.8.3-3.el8_4				122.25 K	67.35 K
 libnsl2			0:1.2.0-2.20180605git4a062cf.el8	148.31 K	59.10 K
 libsemanage			0:2.9-8.el8				314.37 K	171.92 K
 libverto			0:0.3.2-2.el8				28.70 K		24.60 K
 libnghttp2			0:1.33.0-3.el8_2.1			169.26 K	79.21 K
 libarchive			0:3.3.3-4.el8				840.36 K	368.60 K
 libffi				0:3.1-23.el8				55.29 K		38.32 K
 xz-libs			0:5.2.4-4.el8				166.00 K	96.08 K
 centos-stream-repos		0:8-6.el8				30.21 K		20.59 K
 glibc-common			0:2.28-208.el8				8.01 M		1.04 M
 pcre2				0:10.32-3.el8				659.32 K	252.57 K
 ncurses-base			0:6.1-9.20180224.el8			314.23 K	83.08 K
 ncurses-libs			0:6.1-9.20180224.el8			958.61 K	341.76 K
 libcap-ng			0:0.7.11-1.el8				52.67 K		34.19 K
 selinux-policy			0:3.14.3-104.el8			26.06 K		665.72 K
 rpm				0:4.14.3-23.el8				2.12 M		556.35 K
 cracklib-dicts			0:2.9.6-15.el8				9.82 M		4.14 M
 libcom_err			0:1.45.6-5.el8				62.58 K		50.52 K
 keyutils-libs			0:1.5.10-9.el8				45.16 K		34.78 K
 libdb-utils			0:5.3.28-42.el8_4			379.20 K	153.24 K
 sqlite-libs			0:3.26.0-15.el8				1.17 M		594.68 K
 libaio				0:0.3.112-1.el8				98.80 K		33.41 K
 libattr			0:2.4.48-3.el8				28.38 K		27.56 K
 libgcrypt			0:1.8.5-7.el8				1.27 M		473.84 K
 centos-stream-release		0:8.6-1.el8				29.43 K		22.74 K
 vim-minimal			2:8.0.1763-19.el8.4			1.19 M		588.76 K
 readline			0:7.0-10.el8				468.61 K	204.02 K
 nftables			1:0.9.3-26.el8				849.14 K	332.34 K
 tar				2:1.30-6.el8				2.89 M		858.43 K
 libutempter			0:1.1.6-14.el8				54.63 K		32.46 K
 libselinux			0:2.9-5.el8				170.92 K	169.13 K
 libacl				0:2.2.53-1.el8				60.18 K		35.62 K
 coreutils-single		0:8.30-13.el8				1.38 M		644.08 K
 libxml2			0:2.9.7-14.el8				1.76 M		712.30 K
 libpcap			14:1.9.1-5.el8				387.00 K	172.74 K
 libxcrypt			0:4.1.1-6.el8				188.42 K	74.48 K
 libnfnetlink			0:1.0.1-13.el8				53.90 K		33.72 K
 pcre				0:8.42-6.el8				512.34 K	215.63 K
 libunistring			0:0.9.9-3.el8				1.86 M		432.42 K
 pam				0:1.3.1-22.el8				2.72 M		760.84 K
 libmount			0:2.32.1-35.el8				399.50 K	240.58 K
 selinux-policy-targeted	0:3.14.3-104.el8			44.06 M		15.87 M
 crypto-policies		0:20211116-1.gitae470d6.el8		94.23 K		65.20 K
 psmisc				0:23.1-5.el8				503.50 K	154.36 K
 bzip2-libs			0:1.0.6-26.el8				78.42 K		49.10 K
 filesystem			0:3.8-6.el8				215.45 K	1.14 M
 gnutls				0:3.6.16-4.el8				3.01 M		1.04 M
 rpm-libs			0:4.14.3-23.el8				737.20 K	353.40 K
 chkconfig			0:1.19.1-1.el8				843.79 K	203.05 K
 policycoreutils		0:2.9-19.el8				696.88 K	383.17 K
 ca-certificates		0:2021.2.50-82.el8			936.15 K	399.50 K
 openssl-libs			1:1.1.1k-6.el8				3.77 M		1.54 M
 basesystem			0:11-5.el8				124		10.75 K
 libdb				0:5.3.28-42.el8_4			1.90 M		769.40 K
 libtasn1			0:4.13-3.el8				170.78 K	78.01 K
 libsepol			0:2.9-3.el8				762.65 K	348.04 K
 libgpg-error			0:1.31-1.el8				908.91 K	247.52 K
 popt				0:1.18-1.el8				133.12 K	62.82 K
 libbpf				0:0.5.0-1.el8				308.74 K	139.97 K
 cracklib			0:2.9.6-15.el8				250.87 K	95.50 K
 qemu-img			15:6.2.0-5.module_el8.6.0+1087+b42c8331	8.57 M		2.25 M
 libcurl-minimal		0:7.61.1-25.el8				557.43 K	295.36 K
 systemd-libs			0:239-60.el8				4.58 M		1.15 M
 shadow-utils			2:4.6-16.el8				4.13 M		1.29 M
 libpwquality			0:1.4.4-3.el8				409.00 K	109.43 K
 audit-libs			0:3.0.7-4.el8				310.77 K	125.88 K
 libisofs			0:1.4.8-3.el8				501.01 K	226.26 K
 iptables-libs			0:1.8.4-22.el8				206.50 K	110.38 K
 libsmartcols			0:2.32.1-35.el8				249.71 K	182.16 K
 xorriso			0:1.4.8-4.el8				281.61 K	288.19 K
 libcap				0:2.48-4.el8				169.93 K	75.80 K
 iproute			0:5.18.0-1.el8				2.51 M		827.78 K
 libisoburn			0:1.4.8-4.el8				1.10 M		419.54 K
 jansson			0:2.14-1.el8				85.16 K		48.52 K
 libgcc				0:8.5.0-15.el8				192.02 K	82.59 K
 rpm-plugin-selinux		0:4.14.3-23.el8				12.75 K		79.46 K
 p11-kit-trust			0:0.23.22-1.el8				473.54 K	140.29 K
 nettle				0:3.4.1-7.el8				575.76 K	308.24 K
 acl				0:2.2.53-1.el8				209.64 K	82.99 K
 libmnl				0:1.0.4-6.el8				55.15 K		31.04 K
 krb5-libs			0:1.18.2-21.el8				2.25 M		860.54 K
 libblkid			0:2.32.1-35.el8				345.00 K	223.77 K
 glib2				0:2.56.4-159.el8			12.30 M		2.61 M
 findutils			1:4.6.0-20.el8				1.83 M		540.71 K
 gmp				1:6.1.2-10.el8				1.68 M		329.75 K
 libidn2			0:2.2.0-1.el8				293.60 K	96.02 K
 libnftnl			0:1.1.5-5.el8				223.62 K	84.97 K
 info				0:6.5-7.el8_5				387.26 K	203.23 K
 libtirpc			0:1.1.4-7.el8				226.51 K	115.29 K
 grep				0:3.1-6.el8				845.03 K	280.36 K
 libfdisk			0:2.32.1-35.el8				440.11 K	258.05 K
 libnetfilter_conntrack		0:1.0.6-5.el8				166.47 K	66.28 K
 zlib				0:1.2.11-19.el8				201.55 K	105.06 K
 iptables			0:1.8.4-22.el8				2.03 M		598.52 K
 libuuid			0:2.32.1-35.el8				36.42 K		99.23 K
 sed				0:4.5-5.el8				773.39 K	305.33 K
 libselinux-utils		0:2.9-5.el8				328.67 K	248.57 K
 gawk				0:4.2.1-4.el8				2.72 M		1.19 M
 p11-kit			0:0.23.22-1.el8				1.65 M		332.07 K
 tzdata				0:2022a-2.el8				2.18 M		485.40 K
 util-linux			0:2.32.1-35.el8				11.65 M		2.59 M
 centos-gpg-keys		1:8-6.el8				6.28 K		14.63 K
 curl				0:7.61.1-25.el8				703.48 K	360.54 K
 libnl3				0:3.7.0-1.el8				1.06 M		345.42 K
 lua-libs			0:5.3.4-12.el8				248.67 K	120.76 K
 bash				0:4.4.20-4.el8				6.88 M		1.62 M
 libsigsegv			0:2.11-5.el8				48.83 K		30.98 K
 elfutils-libelf		0:0.187-4.el8				1.03 M		236.61 K
 setup				0:2.12.2-7.el8				729.30 K	185.09 K
 diffutils			0:3.6-6.el8				1.38 M		366.90 K
Ignoring:										
											
Transaction Summary:									
Installing 118 Packages 								
Total download size: 64.87 M								
Total install size: 191.82 M								
+ bazel run //:bazeldnf -- rpmtree --public --nobest --name libguestfs-tools --basesystem centos-stream-release acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal file libguestfs-tools-1:1.44.0-5.module_el8.6.0+1087+b42c8331 libvirt-daemon-driver-qemu-0:8.0.0-2.module_el8.6.0+1087+b42c8331 qemu-kvm-core-15:6.2.0-5.module_el8.6.0+1087+b42c8331 seabios-0:1.15.0-1.module_el8.6.0+1087+b42c8331 tar edk2-ovmf-0:20220126gitbb1bba3d77-2.el8 --repofile rpm/repo.yaml --force-ignore-with-dependencies '^(kernel-|linux-firmware)' --force-ignore-with-dependencies '^(python[3]{0,1}-)' --force-ignore-with-dependencies '^mozjs60' --force-ignore-with-dependencies '^(libvirt-daemon-kvm|swtpm)' --force-ignore-with-dependencies '^(man-db|mandoc)' --force-ignore-with-dependencies '^dbus'
INFO: Build option --platforms has changed, discarding analysis cache.
INFO: Analyzed target //:bazeldnf (132 packages loaded, 8497 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 0.895s, Critical Path: 0.04s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Running command line: bazel-bin/bazeldnf.bash rpmtree --public --nobest --name libguestfs-tools --basesystem centos-stream-release acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal file libguestfs-tools-1:1.44.0-5.module_el8.6.0+1087+b42c8331 libvirt-daemon-driver-qemu-0:8.0.0-2.module_el8.6.0+1087+b42c8331 qemu-kvm-core-15:6.2.0-5.module_el8.6.0+1087+b42c8331 seabios-0:1.15.0-1.module_el8.6.0+1087+b42c8331 tar edk2-ovmf-0:20220126gitbb1bba3d77-2.el8 --repofile rpm/repo.yaml --force-ignore-with-dependencies '^(kernel-|linux-firmware)' --force-ignore-with-dependencies '^(python[3]{0,1}-)' --force-ignore-with-dependencies '^mozjs60' --force-ignore-with-dependencies '^(libvirt-daemon-kvm|swtpm)' --force-ignore-with-dependencies '^(man
INFO: Build completed successfully, 1 total action
INFO[0000] Loading packages.                            
INFO[0006] Initial reduction of involved packages.      
INFO[0008] Loading involved packages into the rpmtreer. 
WARN[0008] Package python3-dnf-plugins-core-0:4.0.21-3.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-core-0:4.18.0-408.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-libdnf-0:0.63.0-7.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-rpm-0:4.14.3-22.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-305.25.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-dnf-0:4.7.0-7.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-394.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-libs-0:3.6.8-45.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-policycoreutils-0:2.9-15.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-dnf-plugins-core-0:4.0.21-7.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-libsemanage-0:2.9-8.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-hawkey-0:0.55.0-7.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package dbus-common-1:1.12.8-18.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package python3-rpm-0:4.14.3-15.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-modules-0:4.18.0-394.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-audit-0:3.0.7-3.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package linux-firmware-0:20211119-105.gitf5d51956.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-headers-0:4.18.0-315.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-core-0:4.18.0-338.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package dbus-daemon-1:1.12.8-18.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package python3-rpm-0:4.14.3-19.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package libvirt-daemon-kvm-0:6.0.0-35.module_el8.5.0+746+bbd5d70c is forcefully ignored by regex '^(libvirt-daemon-kvm|swtpm)'. 
WARN[0008] Package python3-libcomps-0:0.1.18-1.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-policycoreutils-0:2.9-16.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-0:4.18.0-373.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-headers-0:4.18.0-348.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-dnf-0:4.7.0-10.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package dbus-libs-1:1.12.8-14.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package python3-hawkey-0:0.63.0-1.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-headers-0:4.18.0-348.2.1.el8_5 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-305.10.2.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package dbus-daemon-1:1.12.8-13.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package kernel-headers-0:4.18.0-305.12.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-dnf-0:4.7.0-2.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package dbus-common-1:1.12.8-13.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package kernel-headers-0:4.18.0-373.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-core-0:4.18.0-358.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package man-db-0:2.7.6.1-18.el8 is forcefully ignored by regex '^(man-db|mandoc)'. 
WARN[0008] Package python3-policycoreutils-0:2.9-19.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-gpg-0:1.13.1-11.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-libcomps-0:0.1.11-5.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-core-0:4.18.0-348.2.1.el8_5 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-0:4.18.0-305.10.2.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-core-0:4.18.0-383.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-0:4.18.0-348.7.1.el8_5 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-policycoreutils-0:2.9-17.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-pip-wheel-0:9.0.3-22.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package dbus-tools-1:1.12.8-13.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package kernel-core-0:4.18.0-315.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-0:4.18.0-365.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-338.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package libvirt-daemon-kvm-0:7.10.0-1.module_el8.6.0+1046+bd8eec5e is forcefully ignored by regex '^(libvirt-daemon-kvm|swtpm)'. 
WARN[0008] Package python3-pip-wheel-0:9.0.3-19.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-pyparsing-0:2.1.10-7.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-hawkey-0:0.63.0-3.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-libs-0:3.6.8-39.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-libdnf-0:0.63.0-8.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-setools-0:4.3.0-2.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-modules-0:4.18.0-338.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-policycoreutils-0:2.9-14.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-373.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package swtpm-libs-0:0.6.0-2.20210607gitea627b3.module_el8.6.0+983+a7505f3f is forcefully ignored by regex '^(libvirt-daemon-kvm|swtpm)'. 
WARN[0008] Package kernel-0:4.18.0-383.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-dnf-0:4.7.0-9.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-modules-0:4.18.0-373.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package linux-firmware-0:20201218-102.git05789708.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-libdnf-0:0.63.0-1.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-core-0:4.18.0-365.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-modules-0:4.18.0-305.12.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-core-0:4.18.0-331.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-305.17.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package libvirt-daemon-kvm-0:8.0.0-2.module_el8.6.0+1087+b42c8331 is forcefully ignored by regex '^(libvirt-daemon-kvm|swtpm)'. 
WARN[0008] Package kernel-0:4.18.0-348.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package libvirt-daemon-kvm-0:8.0.0-6.module_el8.7.0+1140+ff0772f9 is forcefully ignored by regex '^(libvirt-daemon-kvm|swtpm)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-408.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-hawkey-0:0.63.0-5.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-gpg-0:1.13.1-9.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-0:4.18.0-338.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-modules-0:4.18.0-348.7.1.el8_5 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-libs-0:3.6.8-42.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-headers-0:4.18.0-338.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-0:4.18.0-305.25.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-libcomps-0:0.1.16-2.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-libdnf-0:0.63.0-4.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package swtpm-libs-0:0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331 is forcefully ignored by regex '^(libvirt-daemon-kvm|swtpm)'. 
WARN[0008] Package kernel-core-0:4.18.0-305.10.2.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-365.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package dbus-common-1:1.12.8-14.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package python3-libs-0:3.6.8-44.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package swtpm-0:0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331 is forcefully ignored by regex '^(libvirt-daemon-kvm|swtpm)'. 
WARN[0008] Package dbus-daemon-1:1.12.8-14.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package python-rpm-macros-0:3-42.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-pip-wheel-0:9.0.3-20.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-348.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-audit-0:3.0-0.17.20191104git1c2f876.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package linux-firmware-0:20220210-106.git6342082c.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-core-0:4.18.0-305.17.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-rpm-0:4.14.3-20.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-dnf-plugins-core-0:4.0.21-1.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package dbus-tools-1:1.12.8-14.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package kernel-headers-0:4.18.0-394.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-383.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-modules-0:4.18.0-315.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-rpm-0:4.14.3-21.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-hawkey-0:0.63.0-4.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-326.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package dbus-1:1.12.8-13.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package linux-firmware-0:20220210-107.git6342082c.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package dbus-tools-1:1.12.8-19.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package kernel-core-0:4.18.0-348.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-libs-0:3.6.8-46.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-modules-0:4.18.0-348.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package dbus-1:1.12.8-19.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package linux-firmware-0:20210702-103.gitd79c2677.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-0:4.18.0-305.19.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-headers-0:4.18.0-358.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-libdnf-0:0.63.0-10.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-0:4.18.0-305.12.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-hawkey-0:0.63.0-2.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-libselinux-0:2.9-5.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-358.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-hawkey-0:0.63.0-9.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-dnf-plugins-core-0:4.0.21-2.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-core-0:4.18.0-305.19.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-0:4.18.0-326.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-modules-0:4.18.0-305.17.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-hawkey-0:0.63.0-11.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package dbus-daemon-1:1.12.8-18.el8.1 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package python3-dnf-plugins-core-0:4.0.18-4.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-setools-0:4.3.0-3.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-rt-core-0:4.18.0-315.rt7.96.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-libdnf-0:0.63.0-2.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-rpm-0:4.14.3-23.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package dbus-libs-1:1.12.8-18.el8.1 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package python3-dnf-0:4.7.0-1.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-setuptools-wheel-0:39.2.0-6.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-modules-0:4.18.0-331.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-rpm-0:4.14.3-18.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-modules-0:4.18.0-408.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-hawkey-0:0.63.0-7.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-libs-0:3.6.8-41.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package libvirt-daemon-kvm-0:6.0.0-36.module_el8.5.0+821+97472045 is forcefully ignored by regex '^(libvirt-daemon-kvm|swtpm)'. 
WARN[0008] Package kernel-0:4.18.0-394.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-dnf-0:4.7.0-3.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-audit-0:3.0.7-2.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-rt-core-0:4.18.0-331.rt7.112.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python-rpm-macros-0:3-41.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-modules-0:4.18.0-383.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-core-0:4.18.0-326.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-libdnf-0:0.55.0-7.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-331.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-headers-0:4.18.0-348.7.1.el8_5 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package dbus-tools-1:1.12.8-18.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package kernel-0:4.18.0-331.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-policycoreutils-0:2.9-18.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-rpm-macros-0:3-41.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package dbus-common-1:1.12.8-18.el8.1 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package dbus-1:1.12.8-18.el8.1 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package python3-dnf-plugins-core-0:4.0.21-8.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-six-0:1.11.0-8.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-dnf-0:4.7.0-5.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-libs-0:3.6.8-37.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-headers-0:4.18.0-365.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-headers-0:4.18.0-326.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-0:4.18.0-305.17.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package swtpm-0:0.6.0-2.20210607gitea627b3.module_el8.6.0+983+a7505f3f is forcefully ignored by regex '^(libvirt-daemon-kvm|swtpm)'. 
WARN[0008] Package kernel-modules-0:4.18.0-305.10.2.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-305.19.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package dbus-glib-0:0.110-2.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package dbus-libs-1:1.12.8-19.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package kernel-0:4.18.0-315.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-348.2.1.el8_5 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python-srpm-macros-0:3-42.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-core-0:4.18.0-305.25.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-dnf-0:4.7.0-8.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-dnf-0:4.7.0-4.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package libvirt-daemon-kvm-0:7.9.0-1.module_el8.6.0+983+a7505f3f is forcefully ignored by regex '^(libvirt-daemon-kvm|swtpm)'. 
WARN[0008] Package kernel-modules-0:4.18.0-305.25.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-libs-0:3.6.8-38.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-dnf-0:4.7.0-11.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-libdnf-0:0.63.0-9.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-headers-0:4.18.0-305.19.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package dbus-libs-1:1.12.8-18.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package python3-dnf-plugins-core-0:4.0.21-14.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-dnf-plugins-core-0:4.0.21-11.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-dnf-plugins-core-0:4.0.21-10.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-hawkey-0:0.63.0-8.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-dnf-plugins-core-0:4.0.21-12.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-headers-0:4.18.0-383.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-audit-0:3.0.7-1.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-pyyaml-0:3.12-12.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-rt-core-0:4.18.0-338.rt7.119.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-rpm-0:4.14.3-14.el8_4 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-libsemanage-0:2.9-6.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-core-0:4.18.0-305.12.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-modules-0:4.18.0-365.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-rpm-0:4.14.3-17.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package linux-firmware-0:20220713-109.gitdfa29317.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-libdnf-0:0.63.0-5.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-modules-0:4.18.0-326.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package swtpm-tools-0:0.6.0-2.20210607gitea627b3.module_el8.6.0+983+a7505f3f is forcefully ignored by regex '^(libvirt-daemon-kvm|swtpm)'. 
WARN[0008] Package python3-dnf-0:4.4.2-11.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package dbus-libs-1:1.12.8-13.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package kernel-core-0:4.18.0-348.7.1.el8_5 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-libcomps-0:0.1.16-1.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package dbus-daemon-1:1.12.8-19.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package kernel-0:4.18.0-348.2.1.el8_5 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-modules-0:4.18.0-305.19.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package man-db-0:2.7.6.1-17.el8 is forcefully ignored by regex '^(man-db|mandoc)'. 
WARN[0008] Package dbus-common-1:1.12.8-19.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package dbus-tools-1:1.12.8-18.el8.1 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package kernel-headers-0:4.18.0-305.25.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-hawkey-0:0.63.0-10.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package swtpm-tools-0:0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331 is forcefully ignored by regex '^(libvirt-daemon-kvm|swtpm)'. 
WARN[0008] Package python3-libdnf-0:0.63.0-3.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-dbus-0:1.2.4-15.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-rt-core-0:4.18.0-348.rt7.130.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-modules-0:4.18.0-348.2.1.el8_5 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-core-0:4.18.0-373.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-libs-0:3.6.8-40.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-headers-0:4.18.0-305.10.2.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-libdnf-0:0.63.0-11.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-305.12.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-audit-0:3.0.7-4.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-rpm-0:4.14.3-13.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-0:4.18.0-408.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-headers-0:4.18.0-305.17.1.el8_4 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-core-0:4.18.0-394.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-modules-0:4.18.0-358.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package mozjs60-0:60.9.0-4.el8 is forcefully ignored by regex '^mozjs60'. 
WARN[0008] Package python3-dnf-plugins-core-0:4.0.21-6.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python3-libs-0:3.6.8-47.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package python-srpm-macros-0:3-41.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package dbus-1:1.12.8-18.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package python3-gpg-0:1.13.1-7.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-headers-0:4.18.0-331.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-348.7.1.el8_5 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package kernel-0:4.18.0-358.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-rpm-macros-0:3-42.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
WARN[0008] Package kernel-debug-core-0:4.18.0-315.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package dbus-1:1.12.8-14.el8 is forcefully ignored by regex '^dbus'. 
WARN[0008] Package kernel-headers-0:4.18.0-408.el8 is forcefully ignored by regex '^(kernel-|linux-firmware)'. 
WARN[0008] Package python3-dateutil-1:2.6.1-6.el8 is forcefully ignored by regex '^(python[3]{0,1}-)'. 
INFO[0008] Loaded 6956 packages.                        
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Benchmark-0:1.23-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Benchmark-0:1.23-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Benchmark-0:1.23-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Benchmark-0:1.23-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-less-0:0.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-less-0:0.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-less-0:0.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-less-0:0.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] python3-dnf-plugins-core-0:4.0.18-4.el8 conflicts with dnf-0:4.7.0-9.el8 
INFO[0008] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0008] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0008] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0008] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0008] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0008] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0008] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0008] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0008] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0008] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0008] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-DynaLoader-0:1.47-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-DynaLoader-0:1.47-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-DynaLoader-0:1.47-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-DynaLoader-0:1.47-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-SelectSaver-0:1.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-SelectSaver-0:1.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-SelectSaver-0:1.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-SelectSaver-0:1.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Term-ReadLine-0:1.17-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Term-ReadLine-0:1.17-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Term-ReadLine-0:1.17-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Term-ReadLine-0:1.17-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0008] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0008] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0008] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0008] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-Thread-0:3.05-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-Thread-0:3.05-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Thread-0:3.05-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-Thread-0:3.05-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-sigtrap-0:1.09-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-sigtrap-0:1.09-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-sigtrap-0:1.09-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-sigtrap-0:1.09-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Tie-Memoize-0:1.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Tie-Memoize-0:1.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Tie-Memoize-0:1.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Tie-Memoize-0:1.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-DBM_Filter-0:0.06-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-DBM_Filter-0:0.06-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-DBM_Filter-0:0.06-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-DBM_Filter-0:0.06-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-FileCache-0:1.10-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-FileCache-0:1.10-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-FileCache-0:1.10-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-FileCache-0:1.10-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-lib-0:0.65-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-lib-0:0.65-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-lib-0:0.65-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-lib-0:0.65-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Time-0:1.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Time-0:1.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Time-0:1.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Time-0:1.03-471.module_el8.6.0+1070+343f8e3c 
WARN[0008] Package qemu-kvm-15:4.2.0-48.module_el8.5.0+746+bbd5d70c requires qemu-kvm-core-EQ-15:4.2.0-48.module_el8.5.0+746+bbd5d70c, but only got [qemu-kvm-core-15:6.2.0-5.module_el8.6.0+1087+b42c8331(qemu-kvm-core)] 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-ph-0:5.32.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-ph-0:5.32.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-ph-0:5.32.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-ph-0:5.32.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Thread-Semaphore-0:2.13-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Thread-Semaphore-0:2.13-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Thread-Semaphore-0:2.13-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Thread-Semaphore-0:2.13-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] python3-dnf-plugins-core-0:4.0.18-4.el8 conflicts with dnf-0:4.7.0-3.el8 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-I18N-LangTags-0:0.44-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-I18N-LangTags-0:0.44-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-I18N-LangTags-0:0.44-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-I18N-LangTags-0:0.44-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Class-Struct-0:0.66-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Class-Struct-0:0.66-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Class-Struct-0:0.66-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Class-Struct-0:0.66-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-FileHandle-0:2.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-FileHandle-0:2.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-FileHandle-0:2.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-FileHandle-0:2.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-vars-0:1.05-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-vars-0:1.05-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-vars-0:1.05-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-vars-0:1.05-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-diagnostics-0:1.37-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-diagnostics-0:1.37-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-diagnostics-0:1.37-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-diagnostics-0:1.37-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-utils-0:5.26.3-421.el8 conflicts with perl-diagnostics-0:1.37-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-utils-0:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-diagnostics-0:1.37-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-utils-0:5.26.3-420.el8 conflicts with perl-diagnostics-0:1.37-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-utils-0:5.26.3-419.el8 conflicts with perl-diagnostics-0:1.37-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-Dumpvalue-0:2.27-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-Dumpvalue-0:2.27-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-Dumpvalue-0:2.27-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Dumpvalue-0:2.27-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-vmsish-0:1.04-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-vmsish-0:1.04-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-vmsish-0:1.04-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-vmsish-0:1.04-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] python3-dnf-plugins-core-0:4.0.18-4.el8 conflicts with dnf-0:4.7.0-10.el8 
INFO[0008] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0008] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0008] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0008] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0008] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0008] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0008] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0008] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0008] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0008] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0008] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-overload-0:1.31-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-overload-0:1.31-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-overload-0:1.31-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-overload-0:1.31-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Tie-File-0:1.06-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Tie-File-0:1.06-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Tie-File-0:1.06-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Tie-File-0:1.06-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-mro-0:1.23-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-mro-0:1.23-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-mro-0:1.23-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-mro-0:1.23-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-meta-notation-0:5.32.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-meta-notation-0:5.32.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-meta-notation-0:5.32.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-meta-notation-0:5.32.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-subs-0:1.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-subs-0:1.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-subs-0:1.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-subs-0:1.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Tie-RefHash-0:1.39-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Tie-RefHash-0:1.39-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Tie-RefHash-0:1.39-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Tie-RefHash-0:1.39-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-FindBin-0:1.51-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-FindBin-0:1.51-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-FindBin-0:1.51-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-FindBin-0:1.51-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-filetest-0:1.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-filetest-0:1.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-filetest-0:1.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-filetest-0:1.03-471.module_el8.6.0+1070+343f8e3c 
WARN[0008] Package qemu-kvm-15:6.1.0-5.module_el8.6.0+1040+0ae94936 requires qemu-kvm-core-EQ-15:6.1.0-5.module_el8.6.0+1040+0ae94936, but only got [qemu-kvm-core-15:6.2.0-5.module_el8.6.0+1087+b42c8331(qemu-kvm-core)] 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Hash-Util-FieldHash-0:1.20-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Hash-Util-FieldHash-0:1.20-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Hash-Util-FieldHash-0:1.20-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Hash-Util-FieldHash-0:1.20-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0008] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0008] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0008] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0008] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0008] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0008] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0008] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0008] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0008] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0008] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-IPC-Open3-0:1.21-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-IPC-Open3-0:1.21-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-IPC-Open3-0:1.21-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-IPC-Open3-0:1.21-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-NEXT-0:0.67-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-NEXT-0:0.67-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-NEXT-0:0.67-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-NEXT-0:0.67-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-locale-0:1.09-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-locale-0:1.09-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-locale-0:1.09-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-locale-0:1.09-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] python3-dnf-plugins-core-0:4.0.18-4.el8 conflicts with dnf-0:4.7.0-2.el8 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-File-Basename-0:2.85-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-File-Basename-0:2.85-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-File-Basename-0:2.85-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-File-Basename-0:2.85-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] python3-dnf-plugins-core-0:4.0.18-4.el8 conflicts with dnf-0:4.7.0-8.el8 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-English-0:1.11-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-English-0:1.11-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-English-0:1.11-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-English-0:1.11-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-Tie-0:4.6-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-Tie-0:4.6-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-Tie-0:4.6-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Tie-0:4.6-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Term-Complete-0:1.403-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Term-Complete-0:1.403-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Term-Complete-0:1.403-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Term-Complete-0:1.403-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-debugger-0:1.56-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-debugger-0:1.56-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-debugger-0:1.56-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-debugger-0:1.56-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Search-Dict-0:1.07-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Search-Dict-0:1.07-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Search-Dict-0:1.07-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Search-Dict-0:1.07-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Net-0:1.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Net-0:1.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Net-0:1.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Net-0:1.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] python3-dnf-plugins-core-0:4.0.18-4.el8 conflicts with dnf-0:4.7.0-4.el8 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-encoding-warnings-0:0.13-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-encoding-warnings-0:0.13-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-encoding-warnings-0:0.13-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-encoding-warnings-0:0.13-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-ODBM_File-0:1.16-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-ODBM_File-0:1.16-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-ODBM_File-0:1.16-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-ODBM_File-0:1.16-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-B-0:1.80-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-B-0:1.80-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-B-0:1.80-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-B-0:1.80-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-Symbol-0:1.08-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-Symbol-0:1.08-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Symbol-0:1.08-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-Symbol-0:1.08-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-I18N-Langinfo-0:0.19-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-I18N-Langinfo-0:0.19-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-I18N-Langinfo-0:0.19-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-I18N-Langinfo-0:0.19-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Safe-0:2.41-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Safe-0:2.41-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Safe-0:2.41-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Safe-0:2.41-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0008] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0008] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0008] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0008] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0008] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0008] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0008] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0008] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0008] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0008] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
WARN[0008] Package qemu-kvm-15:4.2.0-52.module_el8.5.0+853+a4d5519d requires qemu-kvm-core-EQ-15:4.2.0-52.module_el8.5.0+853+a4d5519d, but only got [qemu-kvm-core-15:6.2.0-5.module_el8.6.0+1087+b42c8331(qemu-kvm-core)] 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-Pod-Functions-0:1.13-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-Pod-Functions-0:1.13-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-Pod-Functions-0:1.13-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Pod-Functions-0:1.13-471.module_el8.6.0+1070+343f8e3c 
WARN[0008] Package qemu-kvm-15:6.2.0-12.module_el8.7.0+1140+ff0772f9 requires qemu-kvm-core-EQ-15:6.2.0-12.module_el8.7.0+1140+ff0772f9, but only got [qemu-kvm-core-15:6.2.0-5.module_el8.6.0+1087+b42c8331(qemu-kvm-core)] 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Config-Extensions-0:0.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Config-Extensions-0:0.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Config-Extensions-0:0.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Config-Extensions-0:0.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-if-0:0.60.800-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-if-0:0.60.800-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-if-0:0.60.800-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-if-0:0.60.800-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-File-DosGlob-0:1.12-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-File-DosGlob-0:1.12-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-File-DosGlob-0:1.12-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-File-DosGlob-0:1.12-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0008] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0008] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0008] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0008] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-File-Copy-0:2.34-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-File-Copy-0:2.34-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-File-Copy-0:2.34-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-File-Copy-0:2.34-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-File-stat-0:1.09-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-File-stat-0:1.09-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-File-stat-0:1.09-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-File-stat-0:1.09-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] python3-dnf-plugins-core-0:4.0.18-4.el8 conflicts with dnf-0:4.7.0-11.el8 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-Unicode-UCD-0:0.75-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-Unicode-UCD-0:0.75-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-Unicode-UCD-0:0.75-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Unicode-UCD-0:0.75-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0008] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0008] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0008] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0008] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Fcntl-0:1.13-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Fcntl-0:1.13-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Fcntl-0:1.13-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Fcntl-0:1.13-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] python3-dnf-plugins-core-0:4.0.18-4.el8 conflicts with dnf-0:4.7.0-5.el8 
INFO[0008] python3-dnf-plugins-core-0:4.0.18-4.el8 conflicts with dnf-0:4.7.0-7.el8 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-User-pwent-0:1.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-User-pwent-0:1.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-User-pwent-0:1.03-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-User-pwent-0:1.03-471.module_el8.6.0+1070+343f8e3c 
WARN[0008] Package qemu-kvm-15:4.2.0-51.module_el8.5.0+821+97472045 requires qemu-kvm-core-EQ-15:4.2.0-51.module_el8.5.0+821+97472045, but only got [qemu-kvm-core-15:6.2.0-5.module_el8.6.0+1087+b42c8331(qemu-kvm-core)] 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-AutoSplit-0:5.74-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-AutoSplit-0:5.74-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-AutoSplit-0:5.74-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-AutoSplit-0:5.74-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-blib-0:1.07-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-blib-0:1.07-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-blib-0:1.07-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-blib-0:1.07-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-autouse-0:1.11-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-autouse-0:1.11-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-autouse-0:1.11-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-autouse-0:1.11-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-base-0:2.27-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-base-0:2.27-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-base-0:2.27-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-base-0:2.27-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-419.el8 conflicts with perl-sort-0:2.04-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-sort-0:2.04-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-420.el8 conflicts with perl-sort-0:2.04-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-4:5.26.3-421.el8 conflicts with perl-sort-0:2.04-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-deprecate-0:0.04-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-deprecate-0:0.04-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-deprecate-0:0.04-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-deprecate-0:0.04-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Sys-Hostname-0:1.23-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Sys-Hostname-0:1.23-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Sys-Hostname-0:1.23-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Sys-Hostname-0:1.23-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Getopt-Std-0:1.12-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Getopt-Std-0:1.12-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Getopt-Std-0:1.12-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Getopt-Std-0:1.12-471.module_el8.6.0+1070+343f8e3c 
INFO[0008] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0008] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0008] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0008] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0008] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0008] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0008] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0008] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0008] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0008] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0008] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0009] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Hash-Util-0:0.23-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Hash-Util-0:0.23-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Hash-Util-0:0.23-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Hash-Util-0:0.23-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0009] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0009] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0009] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0009] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0009] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-I18N-Collate-0:1.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-I18N-Collate-0:1.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-I18N-Collate-0:1.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-I18N-Collate-0:1.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] libX11-0:1.6.8-4.el8 conflicts with libX11-xcb-0:1.6.8-5.el8 
INFO[0009] perl-4:5.26.3-420.el8 conflicts with perl-AutoLoader-0:5.74-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.26.3-421.el8 conflicts with perl-AutoLoader-0:5.74-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.26.3-419.el8 conflicts with perl-AutoLoader-0:5.74-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-AutoLoader-0:5.74-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.26.3-420.el8 conflicts with perl-fields-0:2.27-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.26.3-421.el8 conflicts with perl-fields-0:2.27-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.26.3-419.el8 conflicts with perl-fields-0:2.27-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-fields-0:2.27-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-File-Find-0:1.37-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-File-Find-0:1.37-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-File-Find-0:1.37-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-File-Find-0:1.37-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-ExtUtils-Constant-0:0.25-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-ExtUtils-Constant-0:0.25-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-ExtUtils-Constant-0:0.25-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-ExtUtils-Constant-0:0.25-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0009] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0009] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0009] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0009] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0009] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0009] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0009] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0009] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0009] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0009] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0009] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-NDBM_File-0:1.15-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-NDBM_File-0:1.15-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-NDBM_File-0:1.15-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-NDBM_File-0:1.15-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] python3-dnf-plugins-core-0:4.0.18-4.el8 conflicts with dnf-0:4.7.0-1.el8 
INFO[0009] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-overloading-0:0.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-overloading-0:0.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-overloading-0:0.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-overloading-0:0.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.26.3-419.el8 conflicts with perl-File-Compare-0:1.100.600-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-File-Compare-0:1.100.600-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.26.3-420.el8 conflicts with perl-File-Compare-0:1.100.600-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.26.3-421.el8 conflicts with perl-File-Compare-0:1.100.600-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0009] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0009] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0009] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0009] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-12.el8 
WARN[0009] Package qemu-kvm-15:6.1.0-4.module_el8.6.0+983+a7505f3f requires qemu-kvm-core-EQ-15:6.1.0-4.module_el8.6.0+983+a7505f3f, but only got [qemu-kvm-core-15:6.2.0-5.module_el8.6.0+1087+b42c8331(qemu-kvm-core)] 
INFO[0009] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-GDBM_File-0:1.18-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-GDBM_File-0:1.18-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-GDBM_File-0:1.18-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-GDBM_File-0:1.18-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Opcode-0:1.48-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Opcode-0:1.48-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Opcode-0:1.48-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Opcode-0:1.48-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-Text-Abbrev-0:1.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-Text-Abbrev-0:1.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-Text-Abbrev-0:1.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-Text-Abbrev-0:1.02-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-421.el8 conflicts with perl-POSIX-0:1.94-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-POSIX-0:1.94-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-419.el8 conflicts with perl-POSIX-0:1.94-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-interpreter-4:5.26.3-420.el8 conflicts with perl-POSIX-0:1.94-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.26.3-420.el8 conflicts with perl-DirHandle-0:1.05-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.26.3-421.el8 conflicts with perl-DirHandle-0:1.05-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.26.3-419.el8 conflicts with perl-DirHandle-0:1.05-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-DirHandle-0:1.05-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.26.3-420.el8 conflicts with perl-doc-0:5.32.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.26.3-421.el8 conflicts with perl-doc-0:5.32.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.26.3-419.el8 conflicts with perl-doc-0:5.32.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] perl-4:5.24.4-404.module_el8.1.0+229+cd132df8 conflicts with perl-doc-0:5.32.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0009] Generated 31478 variables.                   
INFO[0009] Adding required packages to the rpmtreer.    
INFO[0009] Selecting acl: acl-0:2.2.53-1.el8            
INFO[0009] Selecting curl: curl-0:7.61.1-25.el8         
INFO[0009] Selecting vim-minimal: vim-minimal-2:8.0.1763-19.el8.4 
INFO[0009] Selecting coreutils-single: coreutils-single-0:8.30-13.el8 
INFO[0009] Selecting glibc-minimal-langpack: glibc-minimal-langpack-0:2.28-208.el8 
INFO[0009] Selecting libcurl-minimal: libcurl-minimal-0:7.61.1-25.el8 
INFO[0009] Selecting file: file-0:5.33-20.el8           
INFO[0009] Selecting libguestfs-tools: libguestfs-tools-1:1.44.0-5.module_el8.6.0+1087+b42c8331 
INFO[0009] Selecting libvirt-daemon-driver-qemu: libvirt-daemon-driver-qemu-0:8.0.0-2.module_el8.6.0+1087+b42c8331 
INFO[0009] Selecting qemu-kvm-core: qemu-kvm-core-15:6.2.0-5.module_el8.6.0+1087+b42c8331 
INFO[0009] Selecting seabios: seabios-0:1.15.0-1.module_el8.6.0+1087+b42c8331 
INFO[0009] Selecting tar: tar-2:1.30-6.el8              
INFO[0009] Selecting edk2-ovmf: edk2-ovmf-0:20220126gitbb1bba3d77-2.el8 
INFO[0009] Selecting centos-stream-release: centos-stream-release-0:8.6-1.el8 
INFO[0009] Solving.                                     
INFO[0009] Loading the Partial weighted MAXSAT problem. 
INFO[0025] Solving the Partial weighted MAXSAT problem. 
INFO[0025] Solution with weight 72541 found.            
INFO[0025] Picking libvirt-libs-0:8.0.0-2.module_el8.6.0+1087+b42c8331 instead of best candiate libvirt-libs-0:8.0.0-6.module_el8.7.0+1140+ff0772f9 
INFO[0025] Picking perl-Socket-4:2.027-3.el8 instead of best candiate perl-Socket-4:2.031-1.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-Encode-4:2.97-3.el8 instead of best candiate perl-Encode-4:3.08-461.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-constant-0:1.33-396.el8 instead of best candiate perl-constant-0:1.33-1001.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-Pod-Simple-1:3.35-395.el8 instead of best candiate perl-Pod-Simple-1:3.42-1.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking libguestfs-tools-c-1:1.44.0-5.module_el8.6.0+1087+b42c8331 instead of best candiate libguestfs-tools-c-1:1.44.0-6.module_el8.7.0+1140+ff0772f9 
INFO[0025] Picking perl-Pod-Usage-4:1.69-395.el8 instead of best candiate perl-Pod-Usage-4:2.01-1.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-Sys-Guestfs-1:1.44.0-5.module_el8.6.0+1087+b42c8331 instead of best candiate perl-Sys-Guestfs-1:1.44.0-6.module_el8.7.0+1140+ff0772f9 
INFO[0025] Picking perl-Term-Cap-0:1.17-395.el8 instead of best candiate perl-Term-Cap-0:1.17-396.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-Getopt-Long-1:2.50-4.el8 instead of best candiate perl-Getopt-Long-1:2.52-1.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-Scalar-List-Utils-3:1.49-2.el8 instead of best candiate perl-Scalar-List-Utils-4:1.55-457.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-libs-4:5.26.3-421.el8 instead of best candiate perl-libs-4:5.32.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-threads-shared-0:1.58-2.el8 instead of best candiate perl-threads-shared-0:1.61-457.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-Errno-0:1.28-421.el8 instead of best candiate perl-Errno-0:1.30-471.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-IO-0:1.38-421.el8 instead of best candiate perl-IO-0:1.43-471.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-HTTP-Tiny-0:0.074-1.el8 instead of best candiate perl-HTTP-Tiny-0:0.078-1.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-Unicode-Normalize-0:1.25-396.el8 instead of best candiate perl-Unicode-Normalize-0:1.27-458.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-macros-4:5.26.3-421.el8 instead of best candiate perl-macros-4:5.32.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-Carp-0:1.42-396.el8 instead of best candiate perl-Carp-0:1.50-439.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-Term-ANSIColor-0:4.06-396.el8 instead of best candiate perl-Term-ANSIColor-0:5.01-458.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking qemu-kvm-common-15:6.2.0-5.module_el8.6.0+1087+b42c8331 instead of best candiate qemu-kvm-common-15:6.2.0-12.module_el8.7.0+1140+ff0772f9 
INFO[0025] Picking perl-File-Path-0:2.15-2.el8 instead of best candiate perl-File-Path-0:2.16-439.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking seavgabios-bin-0:1.15.0-1.module_el8.6.0+1087+b42c8331 instead of best candiate seavgabios-bin-0:1.16.0-1.module_el8.7.0+1140+ff0772f9 
INFO[0025] Picking qemu-img-15:6.2.0-5.module_el8.6.0+1087+b42c8331 instead of best candiate qemu-img-15:6.2.0-12.module_el8.7.0+1140+ff0772f9 
INFO[0025] Picking perl-Time-Local-1:1.280-1.el8 instead of best candiate perl-Time-Local-2:1.300-4.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-PathTools-0:3.74-1.el8 instead of best candiate perl-PathTools-0:3.78-439.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-Pod-Perldoc-0:3.28-396.el8 instead of best candiate perl-Pod-Perldoc-0:3.28.01-443.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-threads-1:2.21-2.el8 instead of best candiate perl-threads-1:2.25-457.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-podlators-0:4.11-1.el8 instead of best candiate perl-podlators-1:4.14-457.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-MIME-Base64-0:3.15-396.el8 instead of best candiate perl-MIME-Base64-0:3.15-1001.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-Text-Tabs+Wrap-0:2013.0523-395.el8 instead of best candiate perl-Text-Tabs+Wrap-0:2013.0523-396.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-Pod-Escapes-1:1.07-395.el8 instead of best candiate perl-Pod-Escapes-1:1.07-396.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-File-Temp-0:0.230.600-1.el8 instead of best candiate perl-File-Temp-1:0.231.100-1.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-parent-1:0.237-1.el8 instead of best candiate perl-parent-1:0.238-457.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-Exporter-0:5.72-396.el8 instead of best candiate perl-Exporter-0:5.74-458.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking libvirt-daemon-0:8.0.0-2.module_el8.6.0+1087+b42c8331 instead of best candiate libvirt-daemon-0:8.0.0-6.module_el8.7.0+1140+ff0772f9 
INFO[0025] Picking perl-Text-ParseWords-0:3.30-395.el8 instead of best candiate perl-Text-ParseWords-0:3.30-396.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-Storable-1:3.11-3.el8 instead of best candiate perl-Storable-1:3.21-457.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking perl-interpreter-4:5.26.3-421.el8 instead of best candiate perl-interpreter-4:5.32.1-471.module_el8.6.0+1070+343f8e3c 
INFO[0025] Picking libguestfs-1:1.44.0-5.module_el8.6.0+1087+b42c8331 instead of best candiate libguestfs-1:1.44.0-6.module_el8.7.0+1140+ff0772f9 
INFO[0025] Picking seabios-bin-0:1.15.0-1.module_el8.6.0+1087+b42c8331 instead of best candiate seabios-bin-0:1.16.0-1.module_el8.7.0+1140+ff0772f9 
INFO[0025] Writing bazel files.                         
Package				Version								Size		Download Size
Installing:													
 lz4-libs			0:1.8.3-3.el8_4							122.25 K	67.35 K
 seabios			0:1.15.0-1.module_el8.6.0+1087+b42c8331				44.06 K		32.07 K
 libpwquality			0:1.4.4-3.el8							409.00 K	109.43 K
 libvirt-libs			0:8.0.0-2.module_el8.6.0+1087+b42c8331				24.49 M		4.94 M
 timedatex			0:0.5-3.el8							57.87 K		33.10 K
 hexedit			0:1.2.13-12.el8							76.73 K		47.16 K
 glib2				0:2.56.4-159.el8						12.30 M		2.61 M
 npth				0:1.5-4.el8							49.09 K		26.80 K
 setup				0:2.12.2-7.el8							729.30 K	185.09 K
 perl-Socket			4:2.027-3.el8							129.15 K	60.25 K
 perl-Encode			4:2.97-3.el8							10.22 M		1.55 M
 perl-constant			0:1.33-396.el8							28.27 K		25.90 K
 libcroco			0:0.6.12-4.el8_2.1						333.22 K	115.22 K
 libnsl2			0:1.2.0-2.20180605git4a062cf.el8				148.31 K	59.10 K
 openssl-libs			1:1.1.1k-6.el8							3.77 M		1.54 M
 libibverbs			0:37.2-1.el8							1.02 M		393.71 K
 libcurl-minimal		0:7.61.1-25.el8							557.43 K	295.36 K
 libcap				0:2.48-4.el8							169.93 K	75.80 K
 libxml2			0:2.9.7-14.el8							1.76 M		712.30 K
 perl-hivex			0:1.3.18-23.module_el8.6.0+983+a7505f3f				108.80 K	62.54 K
 perl-Pod-Simple		1:3.35-395.el8							553.22 K	218.12 K
 libguestfs-tools-c		1:1.44.0-5.module_el8.6.0+1087+b42c8331				27.84 M		5.88 M
 lvm2				8:2.03.14-3.el8							3.88 M		1.74 M
 crypto-policies		0:20211116-1.gitae470d6.el8					94.23 K		65.20 K
 libblkid			0:2.32.1-35.el8							345.00 K	223.77 K
 gnutls				0:3.6.16-4.el8							3.01 M		1.04 M
 libpcap			14:1.9.1-5.el8							387.00 K	172.74 K
 info				0:6.5-7.el8_5							387.26 K	203.23 K
 device-mapper-event-libs	8:1.02.181-3.el8						56.02 K		276.42 K
 fuse-libs			0:2.9.7-16.el8							307.08 K	104.79 K
 readline			0:7.0-10.el8							468.61 K	204.02 K
 perl-Pod-Usage			4:1.69-395.el8							51.02 K		35.20 K
 expat				0:2.2.5-9.el8							317.50 K	115.90 K
 cryptsetup-libs		0:2.3.7-2.el8							2.15 M		499.32 K
 ndctl-libs			0:71.1-4.el8							207.68 K	81.70 K
 sgabios-bin			1:0.20170427git-3.module_el8.6.0+983+a7505f3f			4.50 K		13.73 K
 bzip2-libs			0:1.0.6-26.el8							78.42 K		49.10 K
 libksba			0:1.3.5-7.el8							345.59 K	137.87 K
 fuse				0:2.9.7-16.el8							211.11 K	84.82 K
 libsepol			0:2.9-3.el8							762.65 K	348.04 K
 perl-Sys-Guestfs		1:1.44.0-5.module_el8.6.0+1087+b42c8331				1.28 M		324.21 K
 perl-Term-Cap			0:1.17-395.el8							31.17 K		23.31 K
 xkeyboard-config		0:2.28-1.el8							5.74 M		800.95 K
 hivex				0:1.3.18-23.module_el8.6.0+983+a7505f3f				269.18 K	115.81 K
 lvm2-libs			8:2.03.14-3.el8							2.78 M		1.24 M
 perl-Getopt-Long		1:2.50-4.el8							142.07 K	64.43 K
 perl-Scalar-List-Utils		3:1.49-2.el8							128.04 K	69.42 K
 elfutils-libelf		0:0.187-4.el8							1.03 M		236.61 K
 bzip2				0:1.0.6-26.el8							98.39 K		61.62 K
 perl-libs			4:5.26.3-421.el8						6.19 M		1.63 M
 perl-threads-shared		0:1.58-2.el8							80.55 K		48.78 K
 libusbx			0:1.0.23-4.el8							155.92 K	76.05 K
 perl-Errno			0:1.28-421.el8							9.91 K		78.19 K
 perl-IO			0:1.38-421.el8							144.05 K	145.57 K
 libguestfs-tools		1:1.44.0-5.module_el8.6.0+1087+b42c8331				32.37 K		28.62 K
 libassuan			0:2.5.1-3.el8							205.14 K	84.73 K
 json-c				0:0.13.1-3.el8							70.64 K		41.66 K
 libsemanage			0:2.9-8.el8							314.37 K	171.92 K
 less				0:530-1.el8							348.35 K	168.15 K
 cracklib			0:2.9.6-15.el8							250.87 K	95.50 K
 gawk				0:4.2.1-4.el8							2.72 M		1.19 M
 lua-libs			0:5.3.4-12.el8							248.67 K	120.76 K
 libacl				0:2.2.53-1.el8							60.18 K		35.62 K
 edk2-ovmf			0:20220126gitbb1bba3d77-2.el8					12.12 M		3.79 M
 device-mapper			8:1.02.181-3.el8						361.68 K	386.22 K
 iproute			0:5.18.0-1.el8							2.51 M		827.78 K
 augeas-libs			0:1.12.0-7.el8							1.43 M		447.30 K
 basesystem			0:11-5.el8							124		10.75 K
 libattr			0:2.4.48-3.el8							28.38 K		27.56 K
 libgcrypt			0:1.8.5-7.el8							1.27 M		473.84 K
 libfdt				0:1.6.0-1.el8							56.46 K		32.62 K
 ipxe-roms-qemu			0:20181214-9.git133f4c47.el8					2.71 M		1.29 M
 gettext-libs			0:0.19.8.1-17.el8						1.62 M		321.58 K
 pcre				0:8.42-6.el8							512.34 K	215.63 K
 glibc-minimal-langpack		0:2.28-208.el8							124		64.48 K
 lzo				0:2.08-14.el8							200.48 K	70.85 K
 curl				0:7.61.1-25.el8							703.48 K	360.54 K
 libdb-utils			0:5.3.28-42.el8_4						379.20 K	153.24 K
 cracklib-dicts			0:2.9.6-15.el8							9.82 M		4.14 M
 perl-HTTP-Tiny			0:0.074-1.el8							151.26 K	59.52 K
 libaio				0:0.3.112-1.el8							98.80 K		33.41 K
 libstdc++			0:8.5.0-15.el8							1.86 M		464.94 K
 ncurses			0:6.1-9.20180224.el8						596.08 K	396.27 K
 perl-Unicode-Normalize		0:1.25-396.el8							639.92 K	83.80 K
 libtasn1			0:4.13-3.el8							170.78 K	78.01 K
 glibc				0:2.28-208.el8							6.79 M		2.31 M
 openldap			0:2.4.46-18.el8							1.01 M		360.92 K
 perl-macros			4:5.26.3-421.el8						5.46 K		74.11 K
 gzip				0:1.9-13.el8							358.66 K	170.78 K
 gnupg2				0:2.2.20-2.el8							9.95 M		2.52 M
 libpmem			0:1.11.1-1.module_el8.6.0+1088+6891f51c				425.45 K	114.69 K
 zlib				0:1.2.11-19.el8							201.55 K	105.06 K
 perl-Carp			0:1.42-396.el8							43.00 K		30.87 K
 qemu-kvm-core			15:6.2.0-5.module_el8.6.0+1087+b42c8331				17.31 M		3.52 M
 filesystem			0:3.8-6.el8							215.45 K	1.14 M
 snappy				0:1.1.8-3.el8							62.25 K		37.95 K
 perl-Term-ANSIColor		0:4.06-396.el8							91.32 K		47.05 K
 qemu-kvm-common		15:6.2.0-5.module_el8.6.0+1087+b42c8331				3.71 M		1.09 M
 rpm				0:4.14.3-23.el8							2.12 M		556.35 K
 gdbm-libs			1:1.18-2.el8							120.33 K	61.79 K
 perl-File-Path			0:2.15-2.el8							65.95 K		39.05 K
 ncurses-libs			0:6.1-9.20180224.el8						958.61 K	341.76 K
 iproute-tc			0:5.18.0-1.el8							910.20 K	477.10 K
 groff-base			0:1.22.3-18.el8							4.25 M		1.06 M
 vim-minimal			2:8.0.1763-19.el8.4						1.19 M		588.76 K
 mpfr				0:3.1.6-1.el8							614.92 K	226.70 K
 seavgabios-bin			0:1.15.0-1.module_el8.6.0+1087+b42c8331				216.22 K	44.16 K
 libseccomp			0:2.5.2-1.el8							171.61 K	72.91 K
 sed				0:4.5-5.el8							773.39 K	305.33 K
 jansson			0:2.14-1.el8							85.16 K		48.52 K
 polkit-pkla-compat		0:0.1-12.el8							100.51 K	46.97 K
 systemd-libs			0:239-60.el8							4.58 M		1.15 M
 qemu-img			15:6.2.0-5.module_el8.6.0+1087+b42c8331				8.57 M		2.25 M
 libsmartcols			0:2.32.1-35.el8							249.71 K	182.16 K
 libnghttp2			0:1.33.0-3.el8_2.1						169.26 K	79.21 K
 libxcrypt			0:4.1.1-6.el8							188.42 K	74.48 K
 coreutils-single		0:8.30-13.el8							1.38 M		644.08 K
 grep				0:3.1-6.el8							845.03 K	280.36 K
 polkit				0:0.115-13.0.1.el8.2						417.58 K	157.70 K
 fuse-common			0:3.3.0-16.el8							5.90 K		22.63 K
 centos-gpg-keys		1:8-6.el8							6.28 K		14.63 K
 cyrus-sasl			0:2.1.27-6.el8_5						156.32 K	98.72 K
 perl-Time-Local		1:1.280-1.el8							61.41 K		34.34 K
 systemd-pam			0:239-60.el8							919.54 K	496.20 K
 libssh				0:0.9.6-3.el8							519.94 K	221.38 K
 ncurses-base			0:6.1-9.20180224.el8						314.23 K	83.08 K
 rpm-libs			0:4.14.3-23.el8							737.20 K	353.40 K
 perl-PathTools			0:3.74-1.el8							187.53 K	92.16 K
 cyrus-sasl-gssapi		0:2.1.27-6.el8_5						42.86 K		51.06 K
 libmnl				0:1.0.4-6.el8							55.15 K		31.04 K
 libssh-config			0:0.9.6-3.el8							816		19.75 K
 libmount			0:2.32.1-35.el8							399.50 K	240.58 K
 platform-python-setuptools	0:39.2.0-6.el8							2.99 M		647.44 K
 perl-Pod-Perldoc		0:3.28-396.el8							174.92 K	88.47 K
 device-mapper-multipath-libs	0:0.8.4-26.el8							814.34 K	336.80 K
 numad				0:0.5-26.20150602git.el8					60.31 K		42.23 K
 keyutils-libs			0:1.5.10-9.el8							45.16 K		34.78 K
 perl-threads			1:2.21-2.el8							111.32 K	62.65 K
 libnl3				0:3.7.0-1.el8							1.06 M		345.42 K
 libzstd			0:1.4.4-1.el8							699.40 K	272.32 K
 perl-libintl-perl		0:1.29-2.el8							4.39 M		836.40 K
 tar				2:1.30-6.el8							2.89 M		858.43 K
 perl-podlators			0:4.11-1.el8							291.87 K	120.79 K
 xz-libs			0:5.2.4-4.el8							166.00 K	96.08 K
 file-libs			0:5.33-20.el8							6.39 M		555.90 K
 yajl				0:2.1.0-11.el8							85.42 K		41.67 K
 libxkbcommon			0:0.9.1-1.el8							276.03 K	118.56 K
 perl-MIME-Base64		0:3.15-396.el8							43.78 K		31.36 K
 xz				0:5.2.4-4.el8							431.14 K	156.84 K
 file				0:5.33-20.el8							95.12 K		78.54 K
 libgcc				0:8.5.0-15.el8							192.02 K	82.59 K
 libunistring			0:0.9.9-3.el8							1.86 M		432.42 K
 p11-kit-trust			0:0.23.22-1.el8							473.54 K	140.29 K
 libutempter			0:1.1.6-14.el8							54.63 K		32.46 K
 perl-Text-Tabs+Wrap		0:2013.0523-395.el8						26.19 K		24.69 K
 perl-Pod-Escapes		1:1.07-395.el8							26.79 K		20.99 K
 centos-stream-repos		0:8-6.el8							30.21 K		20.59 K
 device-mapper-libs		8:1.02.181-3.el8						416.90 K	419.34 K
 acl				0:2.2.53-1.el8							209.64 K	82.99 K
 centos-stream-release		0:8.6-1.el8							29.43 K		22.74 K
 bash				0:4.4.20-4.el8							6.88 M		1.62 M
 libbpf				0:0.5.0-1.el8							308.74 K	139.97 K
 perl-File-Temp			0:0.230.600-1.el8						166.38 K	64.05 K
 perl-parent			1:0.237-1.el8							9.90 K		20.48 K
 shadow-utils			2:4.6-16.el8							4.13 M		1.29 M
 libfdisk			0:2.32.1-35.el8							440.11 K	258.05 K
 which				0:2.21-18.el8							85.60 K		50.68 K
 popt				0:1.18-1.el8							133.12 K	62.82 K
 systemd-container		0:239-60.el8							1.72 M		776.64 K
 libsigsegv			0:2.11-5.el8							48.83 K		30.98 K
 libcap-ng			0:0.7.11-1.el8							52.67 K		34.19 K
 libidn2			0:2.2.0-1.el8							293.60 K	96.02 K
 dmidecode			1:3.3-4.el8							230.33 K	94.38 K
 perl-Exporter			0:5.72-396.el8							57.06 K		34.78 K
 krb5-libs			0:1.18.2-21.el8							2.25 M		860.54 K
 pixman				0:0.38.4-2.el8							698.60 K	263.56 K
 libffi				0:3.1-23.el8							55.29 K		38.32 K
 device-mapper-event		8:1.02.181-3.el8						49.62 K		277.48 K
 cyrus-sasl-lib			0:2.1.27-6.el8_5						732.16 K	126.32 K
 libvirt-daemon-driver-qemu	0:8.0.0-2.module_el8.6.0+1087+b42c8331				2.66 M		941.22 K
 p11-kit			0:0.23.22-1.el8							1.65 M		332.07 K
 libvirt-daemon			0:8.0.0-2.module_el8.6.0+1087+b42c8331				1.62 M		425.96 K
 psmisc				0:23.1-5.el8							503.50 K	154.36 K
 pcre2				0:10.32-3.el8							659.32 K	252.57 K
 kmod-libs			0:25-19.el8							127.82 K	70.08 K
 audit-libs			0:3.0.7-4.el8							310.77 K	125.88 K
 perl-Text-ParseWords		0:3.30-395.el8							14.15 K		18.31 K
 polkit-libs			0:0.115-13.0.1.el8.2						198.83 K	78.30 K
 sqlite-libs			0:3.26.0-15.el8							1.17 M		594.68 K
 systemd			0:239-60.el8							11.38 M		3.77 M
 kmod				0:25-19.el8							249.21 K	129.17 K
 perl-Storable			1:3.11-3.el8							223.88 K	100.63 K
 ca-certificates		0:2021.2.50-82.el8						936.15 K	399.50 K
 libconfig			0:1.5-9.el8							219.43 K	70.82 K
 userspace-rcu			0:0.10.1-4.el8							332.03 K	103.22 K
 glibc-common			0:2.28-208.el8							8.01 M		1.04 M
 libtirpc			0:1.1.4-7.el8							226.51 K	115.29 K
 gettext			0:0.19.8.1-17.el8						5.45 M		1.12 M
 iptables-libs			0:1.8.4-22.el8							206.50 K	110.38 K
 lzop				0:1.03-20.el8							116.16 K	63.36 K
 pam				0:1.3.1-22.el8							2.72 M		760.84 K
 libcom_err			0:1.45.6-5.el8							62.58 K		50.52 K
 librdmacm			0:37.2-1.el8							145.29 K	79.63 K
 numactl-libs			0:2.0.12-13.el8							52.09 K		36.99 K
 libselinux			0:2.9-5.el8							170.92 K	169.13 K
 perl-interpreter		4:5.26.3-421.el8						14.53 M		6.62 M
 device-mapper-persistent-data	0:0.9.0-7.el8							3.37 M		949.31 K
 libuuid			0:2.32.1-35.el8							36.42 K		99.23 K
 elfutils-default-yama-scope	0:0.187-4.el8							2.09 K		52.83 K
 chkconfig			0:1.19.1-1.el8							843.79 K	203.05 K
 daxctl-libs			0:71.1-4.el8							80.62 K		42.85 K
 tzdata				0:2022a-2.el8							2.18 M		485.40 K
 libverto			0:0.3.2-2.el8							28.70 K		24.60 K
 libgpg-error			0:1.31-1.el8							908.91 K	247.52 K
 elfutils-libs			0:0.187-4.el8							715.10 K	304.02 K
 libguestfs			1:1.44.0-5.module_el8.6.0+1087+b42c8331				2.56 M		787.46 K
 seabios-bin			0:1.15.0-1.module_el8.6.0+1087+b42c8331				393.76 K	139.44 K
 gmp				1:6.1.2-10.el8							1.68 M		329.75 K
 libpng				2:1.6.34-5.el8							236.65 K	128.98 K
 util-linux			0:2.32.1-35.el8							11.65 M		2.59 M
 libgomp			0:8.5.0-15.el8							333.47 K	212.10 K
 libarchive			0:3.3.3-4.el8							840.36 K	368.60 K
 nettle				0:3.4.1-7.el8							575.76 K	308.24 K
 platform-python		0:3.6.8-47.el8							43.80 K		87.83 K
 libdb				0:5.3.28-42.el8_4						1.90 M		769.40 K
Ignoring:													
 dbus				1:1.12.8-19.el8							124		42.43 K
 python3-libs			0:3.6.8-47.el8							32.78 M		8.23 M
 libvirt-daemon-kvm		0:8.0.0-6.module_el8.7.0+1140+ff0772f9				124		64.28 K
 kernel				0:4.18.0-408.el8						124		8.95 M
 python3-setuptools-wheel	0:39.2.0-6.el8							348.48 K	295.73 K
 python3-pip-wheel		0:9.0.3-22.el8							930.56 K	916.30 K
 mozjs60			0:60.9.0-4.el8							23.73 M		6.93 M
 swtpm-tools			0:0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331	275.40 K	121.56 K
 man-db				0:2.7.6.1-18.el8						2.08 M		908.33 K
														
Transaction Summary:												
Installing 225 Packages 											
Total download size: 104.99 M											
Total install size: 354.08 M											
+ bazel run --config=x86_64 //:bazeldnf -- prune
INFO: Build option --platforms has changed, discarding analysis cache.
INFO: Analyzed target //:bazeldnf (131 packages loaded, 8499 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 0.835s, Critical Path: 0.04s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO[0000] Done.                                        
+ bazel run --config=x86_64 //rpm:ldd_x86_64
INFO: Analyzed target //rpm:ldd_x86_64 (159 packages loaded, 1342 targets configured).
INFO: Found 1 target...
Target //rpm:ldd_x86_64 up-to-date:
  bazel-bin/rpm/ldd_x86_64.bash
INFO: Elapsed time: 17.081s, Critical Path: 9.62s
INFO: 5 processes: 4 internal, 1 processwrapper-sandbox.
INFO: Build completed successfully, 5 total actions
INFO: Build completed successfully, 5 total actions
INFO[0000] Done.                                        
+ rm /root/go/src/kubevirt.io/kubevirt/.bazeldnf/sandbox -rf
+ kubevirt::bootstrap::regenerate x86_64
+ kubevirt::bootstrap::sandbox_exists
+ ls /root/go/src/kubevirt.io/kubevirt/.bazeldnf/sandbox/1c65c791715e97377c36a3be1b7edd35c99dd9ef
+ echo 'Regenerating sandbox'
Regenerating sandbox
+ cd /root/go/src/kubevirt.io/kubevirt
+ rm /root/go/src/kubevirt.io/kubevirt/.bazeldnf/sandbox -rf
+ rm .bazeldnf/sandbox.bazelrc -f
+ KUBEVIRT_BOOTSTRAPPING=true
+ bazel run --config x86_64 //rpm:sandbox_x86_64
INFO: Build option --incompatible_enable_cc_toolchain_resolution has changed, discarding analysis cache.
INFO: Analyzed target //rpm:sandbox_x86_64 (29 packages loaded, 9645 targets configured).
INFO: Found 1 target...
INFO: From Converting sandboxroot_x86_64 to tar:
Flag shorthand -s has been deprecated, use --symlinks instead
Target //rpm:sandbox_x86_64 up-to-date:
  bazel-bin/rpm/sandbox_x86_64.bash
INFO: Elapsed time: 174.260s, Critical Path: 13.93s
INFO: 16 processes: 4 internal, 12 processwrapper-sandbox.
INFO: Build completed successfully, 16 total actions
INFO: Build completed successfully, 16 total actions
+ bazel clean
INFO: Starting clean (this may take a while). Consider using --async if the clean takes more than several minutes.
++ kubevirt::bootstrap::sha256
++ cd /root/go/src/kubevirt.io/kubevirt
++ sha256sum rpm/BUILD.bazel
++ head -c 40
+ local sha=0d77b1de1fbf4047cc1579cf3e5158ef933b2448
+ sed -i '/^[[:blank:]]*sandbox_hash[[:blank:]]*=/s/=.*/="0d77b1de1fbf4047cc1579cf3e5158ef933b2448"/' hack/bootstrap.sh
+ touch /root/go/src/kubevirt.io/kubevirt/.bazeldnf/sandbox/0d77b1de1fbf4047cc1579cf3e5158ef933b2448
+ kubevirt::bootstrap::sandbox_config
+ cat
+ '[' -z '' ']'
+ bazel run --config=x86_64 //:bazeldnf -- rpmtree --public --nobest --name testimage_aarch64 --arch aarch64 --basesystem centos-stream-release --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal device-mapper e2fsprogs iputils nmap-ncat procps-ng qemu-img-15:6.2.0-5.module_el8.6.0+1087+b42c8331 util-linux which
INFO: Analyzed target //:bazeldnf (132 packages loaded, 8499 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 5.567s, Critical Path: 4.30s
INFO: 121 processes: 11 internal, 110 processwrapper-sandbox.
INFO: Build completed successfully, 121 total actions
INFO: Running command line: bazel-bin/bazeldnf.bash rpmtree --public --nobest --name testimage_aarch64 --arch aarch64 --basesystem centos-stream-release --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal dev
INFO: Build completed successfully, 121 total actions
INFO[0000] Loading packages.                            
INFO[0005] Initial reduction of involved packages.      
INFO[0005] Loading involved packages into the rpmtreer. 
INFO[0005] Loaded 4673 packages.                        
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] Generated 15389 variables.                   
INFO[0005] Adding required packages to the rpmtreer.    
INFO[0005] Selecting acl: acl-0:2.2.53-1.el8            
INFO[0005] Selecting curl: curl-0:7.61.1-25.el8         
INFO[0005] Selecting vim-minimal: vim-minimal-2:8.0.1763-19.el8.4 
INFO[0005] Selecting coreutils-single: coreutils-single-0:8.30-13.el8 
INFO[0005] Selecting glibc-minimal-langpack: glibc-minimal-langpack-0:2.28-208.el8 
INFO[0005] Selecting libcurl-minimal: libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] Selecting device-mapper: device-mapper-8:1.02.181-3.el8 
INFO[0005] Selecting e2fsprogs: e2fsprogs-0:1.45.6-5.el8 
INFO[0005] Selecting iputils: iputils-0:20180629-10.el8 
INFO[0005] Selecting nmap-ncat: nmap-ncat-2:7.70-7.el8  
INFO[0005] Selecting procps-ng: procps-ng-0:3.3.15-7.el8 
INFO[0005] Selecting qemu-img: qemu-img-15:6.2.0-5.module_el8.6.0+1087+b42c8331 
INFO[0005] Selecting util-linux: util-linux-0:2.32.1-35.el8 
INFO[0005] Selecting which: which-0:2.21-18.el8         
INFO[0005] Selecting centos-stream-release: centos-stream-release-0:8.6-1.el8 
INFO[0005] Solving.                                     
INFO[0005] Loading the Partial weighted MAXSAT problem. 
INFO[0009] Solving the Partial weighted MAXSAT problem. 
INFO[0009] Solution with weight 0 found.                
INFO[0009] Writing bazel files.                         
Package				Version					Size		Download Size
Installing:										
 ca-certificates		0:2021.2.50-82.el8			936.15 K	399.50 K
 libunistring			0:0.9.9-3.el8				1.84 M		420.63 K
 centos-gpg-keys		1:8-6.el8				6.28 K		14.63 K
 elfutils-default-yama-scope	0:0.187-4.el8				2.09 K		52.83 K
 libidn2			0:2.2.0-1.el8				304.65 K	95.56 K
 glib2				0:2.56.4-159.el8			12.84 M		2.55 M
 util-linux			0:2.32.1-35.el8				15.27 M		2.59 M
 setup				0:2.12.2-7.el8				729.30 K	185.09 K
 grep				0:3.1-6.el8				871.31 K	274.63 K
 elfutils-libs			0:0.187-4.el8				768.57 K	294.51 K
 readline			0:7.0-10.el8				523.94 K	197.65 K
 libss				0:1.45.6-5.el8				115.58 K	54.81 K
 openssl-libs			1:1.1.1k-6.el8				3.66 M		1.41 M
 libverto			0:0.3.2-2.el8				73.15 K		24.13 K
 json-c				0:0.13.1-3.el8				74.52 K		40.92 K
 which				0:2.21-18.el8				126.27 K	49.83 K
 glibc-minimal-langpack		0:2.28-208.el8				124		64.45 K
 ncurses-base			0:6.1-9.20180224.el8			314.23 K	83.08 K
 libseccomp			0:2.5.2-1.el8				179.57 K	71.57 K
 p11-kit-trust			0:0.23.22-1.el8				546.52 K	137.01 K
 libxcrypt			0:4.1.1-6.el8				188.21 K	74.94 K
 dbus-common			1:1.12.8-19.el8				12.92 K		47.28 K
 libnghttp2			0:1.33.0-3.el8_2.1			214.14 K	76.43 K
 libcap-ng			0:0.7.11-1.el8				97.04 K		33.56 K
 device-mapper-libs		8:1.02.181-3.el8			457.66 K	406.88 K
 mpfr				0:3.1.6-1.el8				660.59 K	219.65 K
 libpwquality			0:1.4.4-3.el8				624.92 K	108.67 K
 nettle				0:3.4.1-7.el8				607.74 K	314.69 K
 systemd-libs			0:239-60.el8				4.62 M		1.06 M
 e2fsprogs			0:1.45.6-5.el8				5.01 M		1.05 M
 libtasn1			0:4.13-3.el8				227.56 K	76.57 K
 nmap-ncat			2:7.70-7.el8				532.07 K	230.88 K
 chkconfig			0:1.19.1-1.el8				900.22 K	201.57 K
 acl				0:2.2.53-1.el8				339.09 K	82.04 K
 gmp				1:6.1.2-10.el8				1.56 M		275.14 K
 procps-ng			0:3.3.15-7.el8				1.73 M		335.05 K
 glibc-common			0:2.28-208.el8				8.32 M		1.03 M
 p11-kit			0:0.23.22-1.el8				1.79 M		313.39 K
 libstdc++			0:8.5.0-15.el8				1.86 M		434.54 K
 libcurl-minimal		0:7.61.1-25.el8				540.82 K	278.08 K
 dbus-daemon			1:1.12.8-19.el8				752.14 K	239.03 K
 audit-libs			0:3.0.7-4.el8				302.21 K	121.25 K
 pcre2				0:10.32-3.el8				704.00 K	224.40 K
 polkit-libs			0:0.115-13.0.1.el8.2			231.32 K	75.95 K
 crypto-policies		0:20211116-1.gitae470d6.el8		94.23 K		65.20 K
 info				0:6.5-7.el8_5				435.78 K	195.90 K
 elfutils-libelf		0:0.187-4.el8				1.06 M		235.12 K
 libattr			0:2.4.48-3.el8				73.02 K		27.35 K
 libuuid			0:2.32.1-35.el8				73.13 K		98.53 K
 libffi				0:3.1-23.el8				87.61 K		37.32 K
 libfdisk			0:2.32.1-35.el8				439.62 K	248.02 K
 krb5-libs			0:1.18.2-21.el8				2.47 M		838.16 K
 libnsl2			0:1.2.0-2.20180605git4a062cf.el8	183.15 K	56.46 K
 pam				0:1.3.1-22.el8				5.66 M		755.23 K
 libselinux			0:2.9-5.el8				207.84 K	165.61 K
 polkit-pkla-compat		0:0.1-12.el8				181.69 K	46.32 K
 sed				0:4.5-5.el8				793.54 K	301.66 K
 libgcc				0:8.5.0-15.el8				228.30 K	75.52 K
 libdb				0:5.3.28-42.el8_4			1.76 M		703.36 K
 gnutls				0:3.6.16-4.el8				3.02 M		961.79 K
 cracklib			0:2.9.6-15.el8				450.20 K	95.20 K
 dbus				1:1.12.8-19.el8				124		42.40 K
 libzstd			0:1.4.4-1.el8				621.24 K	246.07 K
 libutempter			0:1.1.6-14.el8				168.88 K	32.61 K
 dbus-tools			1:1.12.8-19.el8				319.71 K	86.43 K
 vim-minimal			2:8.0.1763-19.el8.4			1.27 M		556.98 K
 libsepol			0:2.9-3.el8				770.35 K	328.54 K
 mozjs60			0:60.9.0-4.el8				22.03 M		6.34 M
 lz4-libs			0:1.8.3-3.el8_4				138.43 K	64.50 K
 basesystem			0:11-5.el8				124		10.75 K
 gawk				0:4.2.1-4.el8				3.55 M		1.16 M
 bash				0:4.4.20-4.el8				6.97 M		1.60 M
 timedatex			0:0.5-3.el8				94.40 K		32.77 K
 libcap				0:2.48-4.el8				519.20 K	74.90 K
 qemu-img			15:6.2.0-5.module_el8.6.0+1087+b42c8331	8.66 M		2.14 M
 systemd			0:239-60.el8				13.71 M		3.46 M
 libaio				0:0.3.112-1.el8				210.35 K	33.36 K
 coreutils-single		0:8.30-13.el8				1.47 M		609.90 K
 xz-libs			0:5.2.4-4.el8				207.34 K	92.70 K
 iputils			0:20180629-10.el8			568.56 K	150.63 K
 glibc				0:2.28-208.el8				6.44 M		1.89 M
 centos-stream-repos		0:8-6.el8				30.21 K		20.59 K
 zlib				0:1.2.11-19.el8				238.24 K	102.92 K
 cryptsetup-libs		0:2.3.7-2.el8				2.17 M		483.95 K
 centos-stream-release		0:8.6-1.el8				29.43 K		22.74 K
 libblkid			0:2.32.1-35.el8				406.42 K	217.51 K
 gzip				0:1.9-13.el8				399.30 K	168.60 K
 libpcap			14:1.9.1-5.el8				411.10 K	164.80 K
 device-mapper			8:1.02.181-3.el8			450.39 K	382.30 K
 kmod-libs			0:25-19.el8				164.34 K	67.49 K
 libnl3				0:3.7.0-1.el8				1.28 M		324.26 K
 e2fsprogs-libs			0:1.45.6-5.el8				587.38 K	232.26 K
 libsmartcols			0:2.32.1-35.el8				298.79 K	177.60 K
 keyutils-libs			0:1.5.10-9.el8				98.24 K		34.62 K
 filesystem			0:3.8-6.el8				215.45 K	1.14 M
 libacl				0:2.2.53-1.el8				90.82 K		34.67 K
 tzdata				0:2022a-2.el8				2.18 M		485.40 K
 fuse-libs			0:2.9.7-16.el8				368.20 K	100.04 K
 shadow-utils			2:4.6-16.el8				4.72 M		1.27 M
 libmount			0:2.32.1-35.el8				432.32 K	233.36 K
 libsigsegv			0:2.11-5.el8				101.68 K	30.92 K
 pcre				0:8.42-6.el8				569.29 K	191.54 K
 systemd-pam			0:239-60.el8				946.18 K	458.13 K
 cracklib-dicts			0:2.9.6-15.el8				9.82 M		4.14 M
 dbus-libs			1:1.12.8-19.el8				434.86 K	180.00 K
 curl				0:7.61.1-25.el8				736.16 K	356.51 K
 libgpg-error			0:1.31-1.el8				944.39 K	245.33 K
 libibverbs			0:37.2-1.el8				1.41 M		371.03 K
 libsemanage			0:2.9-8.el8				310.00 K	167.22 K
 expat				0:2.2.5-9.el8				309.03 K	106.08 K
 ncurses-libs			0:6.1-9.20180224.el8			1.25 M		317.99 K
 polkit				0:0.115-13.0.1.el8.2			652.45 K	153.68 K
 libgcrypt			0:1.8.5-7.el8				904.04 K	400.58 K
 libcom_err			0:1.45.6-5.el8				115.71 K	50.26 K
 bzip2-libs			0:1.0.6-26.el8				77.97 K		49.31 K
 libtirpc			0:1.1.4-7.el8				283.69 K	111.68 K
 popt				0:1.18-1.el8				149.27 K	61.62 K
Ignoring:										
											
Transaction Summary:									
Installing 117 Packages 								
Total download size: 53.24 M								
Total install size: 189.99 M								
+ bazel run --config=x86_64 //:bazeldnf -- rpmtree --public --nobest --name libvirt-devel_aarch64 --arch aarch64 --basesystem centos-stream-release --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal libvirt-devel-0:8.0.0-2.module_el8.6.0+1087+b42c8331 keyutils-libs krb5-libs libmount lz4-libs
INFO: Analyzed target //:bazeldnf (4 packages loaded, 148 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 0.714s, Critical Path: 0.04s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Running command line: bazel-bin/bazeldnf.bash rpmtree --public --nobest --name libvirt-devel_aarch64 --arch aarch64 --basesystem centos-stream-release --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal
INFO: Build completed successfully, 1 total action
INFO[0000] Loading packages.                            
INFO[0005] Initial reduction of involved packages.      
INFO[0005] Loading involved packages into the rpmtreer. 
INFO[0005] Loaded 4662 packages.                        
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0006] Generated 15213 variables.                   
INFO[0006] Adding required packages to the rpmtreer.    
INFO[0006] Selecting acl: acl-0:2.2.53-1.el8            
INFO[0006] Selecting curl: curl-0:7.61.1-25.el8         
INFO[0006] Selecting vim-minimal: vim-minimal-2:8.0.1763-19.el8.4 
INFO[0006] Selecting coreutils-single: coreutils-single-0:8.30-13.el8 
INFO[0006] Selecting glibc-minimal-langpack: glibc-minimal-langpack-0:2.28-208.el8 
INFO[0006] Selecting libcurl-minimal: libcurl-minimal-0:7.61.1-25.el8 
INFO[0006] Selecting libvirt-devel: libvirt-devel-0:8.0.0-2.module_el8.6.0+1087+b42c8331 
INFO[0006] Selecting keyutils-libs: keyutils-libs-0:1.5.10-9.el8 
INFO[0006] Selecting krb5-libs: krb5-libs-0:1.18.2-21.el8 
INFO[0006] Selecting libmount: libmount-0:2.32.1-35.el8 
INFO[0006] Selecting lz4-libs: lz4-libs-0:1.8.3-3.el8_4 
INFO[0006] Selecting centos-stream-release: centos-stream-release-0:8.6-1.el8 
INFO[0006] Solving.                                     
INFO[0006] Loading the Partial weighted MAXSAT problem. 
INFO[0010] Solving the Partial weighted MAXSAT problem. 
INFO[0010] Solution with weight 1501 found.             
INFO[0010] Picking libvirt-libs-0:8.0.0-2.module_el8.6.0+1087+b42c8331 instead of best candiate libvirt-libs-0:8.0.0-6.module_el8.7.0+1140+ff0772f9 
INFO[0010] Writing bazel files.                         
Package				Version					Size		Download Size
Installing:										
 setup				0:2.12.2-7.el8				729.30 K	185.09 K
 json-c				0:0.13.1-3.el8				74.52 K		40.92 K
 libsepol			0:2.9-3.el8				770.35 K	328.54 K
 grep				0:3.1-6.el8				871.31 K	274.63 K
 systemd			0:239-60.el8				13.71 M		3.46 M
 openssl-libs			1:1.1.1k-6.el8				3.66 M		1.41 M
 ncurses-base			0:6.1-9.20180224.el8			314.23 K	83.08 K
 libutempter			0:1.1.6-14.el8				168.88 K	32.61 K
 libcom_err			0:1.45.6-5.el8				115.71 K	50.26 K
 libunistring			0:0.9.9-3.el8				1.84 M		420.63 K
 expat				0:2.2.5-9.el8				309.03 K	106.08 K
 libssh-config			0:0.9.6-3.el8				816		19.75 K
 kmod-libs			0:25-19.el8				164.34 K	67.49 K
 libcap				0:2.48-4.el8				519.20 K	74.90 K
 acl				0:2.2.53-1.el8				339.09 K	82.04 K
 libsmartcols			0:2.32.1-35.el8				298.79 K	177.60 K
 libidn2			0:2.2.0-1.el8				304.65 K	95.56 K
 vim-minimal			2:8.0.1763-19.el8.4			1.27 M		556.98 K
 libseccomp			0:2.5.2-1.el8				179.57 K	71.57 K
 libssh				0:0.9.6-3.el8				531.82 K	211.88 K
 basesystem			0:11-5.el8				124		10.75 K
 device-mapper			8:1.02.181-3.el8			450.39 K	382.30 K
 centos-gpg-keys		1:8-6.el8				6.28 K		14.63 K
 glibc				0:2.28-208.el8				6.44 M		1.89 M
 device-mapper-libs		8:1.02.181-3.el8			457.66 K	406.88 K
 libsigsegv			0:2.11-5.el8				101.68 K	30.92 K
 libnghttp2			0:1.33.0-3.el8_2.1			214.14 K	76.43 K
 gmp				1:6.1.2-10.el8				1.56 M		275.14 K
 libtirpc			0:1.1.4-7.el8				283.69 K	111.68 K
 keyutils-libs			0:1.5.10-9.el8				98.24 K		34.62 K
 libmount			0:2.32.1-35.el8				432.32 K	233.36 K
 cryptsetup-libs		0:2.3.7-2.el8				2.17 M		483.95 K
 elfutils-libs			0:0.187-4.el8				768.57 K	294.51 K
 filesystem			0:3.8-6.el8				215.45 K	1.14 M
 libselinux			0:2.9-5.el8				207.84 K	165.61 K
 curl				0:7.61.1-25.el8				736.16 K	356.51 K
 libstdc++			0:8.5.0-15.el8				1.86 M		434.54 K
 libcap-ng			0:0.7.11-1.el8				97.04 K		33.56 K
 elfutils-libelf		0:0.187-4.el8				1.06 M		235.12 K
 openldap			0:2.4.46-18.el8				1.07 M		347.27 K
 mpfr				0:3.1.6-1.el8				660.59 K	219.65 K
 polkit-pkla-compat		0:0.1-12.el8				181.69 K	46.32 K
 libuuid			0:2.32.1-35.el8				73.13 K		98.53 K
 libnsl2			0:1.2.0-2.20180605git4a062cf.el8	183.15 K	56.46 K
 bash				0:4.4.20-4.el8				6.97 M		1.60 M
 libxcrypt			0:4.1.1-6.el8				188.21 K	74.94 K
 coreutils-single		0:8.30-13.el8				1.47 M		609.90 K
 libgcc				0:8.5.0-15.el8				228.30 K	75.52 K
 pkgconf			0:1.4.2-1.el8				97.46 K		38.24 K
 lz4-libs			0:1.8.3-3.el8_4				138.43 K	64.50 K
 chkconfig			0:1.19.1-1.el8				900.22 K	201.57 K
 libnl3				0:3.7.0-1.el8				1.28 M		324.26 K
 libacl				0:2.2.53-1.el8				90.82 K		34.67 K
 dbus				1:1.12.8-19.el8				124		42.40 K
 tzdata				0:2022a-2.el8				2.18 M		485.40 K
 popt				0:1.18-1.el8				149.27 K	61.62 K
 xz-libs			0:5.2.4-4.el8				207.34 K	92.70 K
 nettle				0:3.4.1-7.el8				607.74 K	314.69 K
 util-linux			0:2.32.1-35.el8				15.27 M		2.59 M
 crypto-policies		0:20211116-1.gitae470d6.el8		94.23 K		65.20 K
 ca-certificates		0:2021.2.50-82.el8			936.15 K	399.50 K
 libgcrypt			0:1.8.5-7.el8				904.04 K	400.58 K
 centos-stream-repos		0:8-6.el8				30.21 K		20.59 K
 cyrus-sasl-gssapi		0:2.1.27-6.el8_5			71.53 K		50.17 K
 readline			0:7.0-10.el8				523.94 K	197.65 K
 libpwquality			0:1.4.4-3.el8				624.92 K	108.67 K
 centos-stream-release		0:8.6-1.el8				29.43 K		22.74 K
 libdb				0:5.3.28-42.el8_4			1.76 M		703.36 K
 glibc-minimal-langpack		0:2.28-208.el8				124		64.45 K
 glibc-common			0:2.28-208.el8				8.32 M		1.03 M
 libvirt-devel			0:8.0.0-2.module_el8.6.0+1087+b42c8331	1.47 M		250.43 K
 libffi				0:3.1-23.el8				87.61 K		37.32 K
 cracklib-dicts			0:2.9.6-15.el8				9.82 M		4.14 M
 timedatex			0:0.5-3.el8				94.40 K		32.77 K
 glib2				0:2.56.4-159.el8			12.84 M		2.55 M
 dbus-tools			1:1.12.8-19.el8				319.71 K	86.43 K
 libtasn1			0:4.13-3.el8				227.56 K	76.57 K
 p11-kit-trust			0:0.23.22-1.el8				546.52 K	137.01 K
 gnutls				0:3.6.16-4.el8				3.02 M		961.79 K
 pcre2				0:10.32-3.el8				704.00 K	224.40 K
 dbus-libs			1:1.12.8-19.el8				434.86 K	180.00 K
 sed				0:4.5-5.el8				793.54 K	301.66 K
 p11-kit			0:0.23.22-1.el8				1.79 M		313.39 K
 info				0:6.5-7.el8_5				435.78 K	195.90 K
 libpkgconf			0:1.4.2-1.el8				76.68 K		34.52 K
 systemd-libs			0:239-60.el8				4.62 M		1.06 M
 libzstd			0:1.4.4-1.el8				621.24 K	246.07 K
 polkit				0:0.115-13.0.1.el8.2			652.45 K	153.68 K
 yajl				0:2.1.0-11.el8				223.14 K	40.51 K
 audit-libs			0:3.0.7-4.el8				302.21 K	121.25 K
 cracklib			0:2.9.6-15.el8				450.20 K	95.20 K
 systemd-pam			0:239-60.el8				946.18 K	458.13 K
 pkgconf-pkg-config		0:1.4.2-1.el8				3.93 K		15.57 K
 krb5-libs			0:1.18.2-21.el8				2.47 M		838.16 K
 dbus-daemon			1:1.12.8-19.el8				752.14 K	239.03 K
 libvirt-libs			0:8.0.0-2.module_el8.6.0+1087+b42c8331	24.37 M		4.74 M
 libblkid			0:2.32.1-35.el8				406.42 K	217.51 K
 dbus-common			1:1.12.8-19.el8				12.92 K		47.28 K
 polkit-libs			0:0.115-13.0.1.el8.2			231.32 K	75.95 K
 libfdisk			0:2.32.1-35.el8				439.62 K	248.02 K
 numactl-libs			0:2.0.12-13.el8				72.46 K		36.50 K
 pkgconf-m4			0:1.4.2-1.el8				14.60 K		17.44 K
 libxml2			0:2.9.7-14.el8				1.85 M		668.31 K
 libcurl-minimal		0:7.61.1-25.el8				540.82 K	278.08 K
 mozjs60			0:60.9.0-4.el8				22.03 M		6.34 M
 libattr			0:2.4.48-3.el8				73.02 K		27.35 K
 shadow-utils			2:4.6-16.el8				4.72 M		1.27 M
 gawk				0:4.2.1-4.el8				3.55 M		1.16 M
 zlib				0:1.2.11-19.el8				238.24 K	102.92 K
 cyrus-sasl			0:2.1.27-6.el8_5			297.91 K	98.06 K
 elfutils-default-yama-scope	0:0.187-4.el8				2.09 K		52.83 K
 libverto			0:0.3.2-2.el8				73.15 K		24.13 K
 cyrus-sasl-lib			0:2.1.27-6.el8_5			935.64 K	125.34 K
 bzip2-libs			0:1.0.6-26.el8				77.97 K		49.31 K
 gzip				0:1.9-13.el8				399.30 K	168.60 K
 libsemanage			0:2.9-8.el8				310.00 K	167.22 K
 pcre				0:8.42-6.el8				569.29 K	191.54 K
 ncurses-libs			0:6.1-9.20180224.el8			1.25 M		317.99 K
 libgpg-error			0:1.31-1.el8				944.39 K	245.33 K
 pam				0:1.3.1-22.el8				5.66 M		755.23 K
Ignoring:										
											
Transaction Summary:									
Installing 120 Packages 								
Total download size: 55.02 M								
Total install size: 201.33 M								
+ bazel run --config=x86_64 //:bazeldnf -- rpmtree --public --nobest --name sandboxroot_aarch64 --arch aarch64 --basesystem centos-stream-release --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal findutils gcc glibc-static python36 sssd-client
INFO: Analyzed target //:bazeldnf (4 packages loaded, 148 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 0.687s, Critical Path: 0.03s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Running command line: bazel-bin/bazeldnf.bash rpmtree --public --nobest --name sandboxroot_aarch64 --arch aarch64 --basesystem centos-stream-release --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal f
INFO: Build completed successfully, 1 total action
INFO[0000] Loading packages.                            
INFO[0004] Initial reduction of involved packages.      
INFO[0005] Loading involved packages into the rpmtreer. 
INFO[0005] Loaded 4775 packages.                        
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] Generated 13628 variables.                   
INFO[0005] Adding required packages to the rpmtreer.    
INFO[0005] Selecting acl: acl-0:2.2.53-1.el8            
INFO[0005] Selecting curl: curl-0:7.61.1-25.el8         
INFO[0005] Selecting vim-minimal: vim-minimal-2:8.0.1763-19.el8.4 
INFO[0005] Selecting coreutils-single: coreutils-single-0:8.30-13.el8 
INFO[0005] Selecting glibc-minimal-langpack: glibc-minimal-langpack-0:2.28-208.el8 
INFO[0005] Selecting libcurl-minimal: libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] Selecting findutils: findutils-1:4.6.0-20.el8 
INFO[0005] Selecting gcc: gcc-0:8.5.0-15.el8            
INFO[0005] Selecting glibc-static: glibc-static-0:2.28-208.el8 
INFO[0005] Selecting python36: python36-0:3.6.8-38.module_el8.5.0+895+a459eca8 
INFO[0005] Selecting sssd-client: sssd-client-0:2.7.3-1.el8 
INFO[0005] Selecting centos-stream-release: centos-stream-release-0:8.6-1.el8 
INFO[0005] Solving.                                     
INFO[0005] Loading the Partial weighted MAXSAT problem. 
INFO[0009] Solving the Partial weighted MAXSAT problem. 
INFO[0009] Solution with weight 0 found.                
INFO[0009] Writing bazel files.                         
Package				Version					Size		Download Size
Installing:										
 libffi				0:3.1-23.el8				87.61 K		37.32 K
 cracklib			0:2.9.6-15.el8				450.20 K	95.20 K
 libxcrypt-devel		0:4.1.1-6.el8				26.52 K		25.78 K
 readline			0:7.0-10.el8				523.94 K	197.65 K
 libattr			0:2.4.48-3.el8				73.02 K		27.35 K
 libnghttp2			0:1.33.0-3.el8_2.1			214.14 K	76.43 K
 vim-minimal			2:8.0.1763-19.el8.4			1.27 M		556.98 K
 openssl-libs			1:1.1.1k-6.el8				3.66 M		1.41 M
 sqlite-libs			0:3.26.0-15.el8				1.16 M		562.98 K
 centos-gpg-keys		1:8-6.el8				6.28 K		14.63 K
 libdb				0:5.3.28-42.el8_4			1.76 M		703.36 K
 libsepol			0:2.9-3.el8				770.35 K	328.54 K
 centos-stream-release		0:8.6-1.el8				29.43 K		22.74 K
 python3-libs			0:3.6.8-47.el8				35.27 M		8.07 M
 platform-python		0:3.6.8-47.el8				101.15 K	87.88 K
 p11-kit			0:0.23.22-1.el8				1.79 M		313.39 K
 glibc-headers			0:2.28-208.el8				2.04 M		487.73 K
 sed				0:4.5-5.el8				793.54 K	301.66 K
 centos-stream-repos		0:8-6.el8				30.21 K		20.59 K
 libnsl2			0:1.2.0-2.20180605git4a062cf.el8	183.15 K	56.46 K
 pam				0:1.3.1-22.el8				5.66 M		755.23 K
 python3-pip			0:9.0.3-22.el8				4.17 K		20.57 K
 pkgconf-m4			0:1.4.2-1.el8				14.60 K		17.44 K
 python3-pip-wheel		0:9.0.3-22.el8				930.56 K	916.30 K
 sssd-client			0:2.7.3-1.el8				652.45 K	233.07 K
 libtasn1			0:4.13-3.el8				227.56 K	76.57 K
 glibc-static			0:2.28-208.el8				21.39 M		1.65 M
 libpwquality			0:1.4.4-3.el8				624.92 K	108.67 K
 pkgconf-pkg-config		0:1.4.2-1.el8				3.93 K		15.57 K
 krb5-libs			0:1.18.2-21.el8				2.47 M		838.16 K
 ncurses-libs			0:6.1-9.20180224.el8			1.25 M		317.99 K
 libasan			0:8.5.0-15.el8				1.48 M		395.77 K
 libubsan			0:8.5.0-15.el8				353.81 K	147.55 K
 libselinux			0:2.9-5.el8				207.84 K	165.61 K
 setup				0:2.12.2-7.el8				729.30 K	185.09 K
 libacl				0:2.2.53-1.el8				90.82 K		34.67 K
 ncurses-base			0:6.1-9.20180224.el8			314.23 K	83.08 K
 pcre				0:8.42-6.el8				569.29 K	191.54 K
 libxcrypt-static		0:4.1.1-6.el8				328.38 K	58.97 K
 crypto-policies		0:20211116-1.gitae470d6.el8		94.23 K		65.20 K
 basesystem			0:11-5.el8				124		10.75 K
 pcre2				0:10.32-3.el8				704.00 K	224.40 K
 platform-python-pip		0:9.0.3-22.el8				7.29 M		1.69 M
 libgomp			0:8.5.0-15.el8				369.95 K	204.15 K
 findutils			1:4.6.0-20.el8				1.86 M		537.62 K
 ca-certificates		0:2021.2.50-82.el8			936.15 K	399.50 K
 gdbm				1:1.18-2.el8				520.19 K	130.71 K
 libcurl-minimal		0:7.61.1-25.el8				540.82 K	278.08 K
 grep				0:3.1-6.el8				871.31 K	274.63 K
 acl				0:2.2.53-1.el8				339.09 K	82.04 K
 libsigsegv			0:2.11-5.el8				101.68 K	30.92 K
 libsss_idmap			0:2.7.3-1.el8				113.41 K	128.32 K
 pkgconf			0:1.4.2-1.el8				97.46 K		38.24 K
 bzip2-libs			0:1.0.6-26.el8				77.97 K		49.31 K
 filesystem			0:3.8-6.el8				215.45 K	1.14 M
 tzdata				0:2022a-2.el8				2.18 M		485.40 K
 glibc-minimal-langpack		0:2.28-208.el8				124		64.45 K
 gcc				0:8.5.0-15.el8				49.64 M		20.31 M
 libstdc++			0:8.5.0-15.el8				1.86 M		434.54 K
 mpfr				0:3.1.6-1.el8				660.59 K	219.65 K
 libxcrypt			0:4.1.1-6.el8				188.21 K	74.94 K
 curl				0:7.61.1-25.el8				736.16 K	356.51 K
 libtirpc			0:1.1.4-7.el8				283.69 K	111.68 K
 python3-setuptools-wheel	0:39.2.0-6.el8				348.48 K	295.73 K
 python3-setuptools		0:39.2.0-6.el8				463.97 K	166.50 K
 bash				0:4.4.20-4.el8				6.97 M		1.60 M
 libverto			0:0.3.2-2.el8				73.15 K		24.13 K
 isl				0:0.16.1-6.el8				3.28 M		796.45 K
 expat				0:2.2.5-9.el8				309.03 K	106.08 K
 glibc-common			0:2.28-208.el8				8.32 M		1.03 M
 audit-libs			0:3.0.7-4.el8				302.21 K	121.25 K
 coreutils-single		0:8.30-13.el8				1.47 M		609.90 K
 binutils			0:2.30-117.el8				27.56 M		6.35 M
 chkconfig			0:1.19.1-1.el8				900.22 K	201.57 K
 cpp				0:8.5.0-15.el8				24.08 M		9.37 M
 libcom_err			0:1.45.6-5.el8				115.71 K	50.26 K
 kernel-headers			0:4.18.0-408.el8			5.50 M		10.30 M
 keyutils-libs			0:1.5.10-9.el8				98.24 K		34.62 K
 gawk				0:4.2.1-4.el8				3.55 M		1.16 M
 libgcc				0:8.5.0-15.el8				228.30 K	75.52 K
 gmp				1:6.1.2-10.el8				1.56 M		275.14 K
 info				0:6.5-7.el8_5				435.78 K	195.90 K
 libcap-ng			0:0.7.11-1.el8				97.04 K		33.56 K
 popt				0:1.18-1.el8				149.27 K	61.62 K
 gdbm-libs			1:1.18-2.el8				177.42 K	60.45 K
 zlib				0:1.2.11-19.el8				238.24 K	102.92 K
 xz-libs			0:5.2.4-4.el8				207.34 K	92.70 K
 libsss_nss_idmap		0:2.7.3-1.el8				115.50 K	136.22 K
 gzip				0:1.9-13.el8				399.30 K	168.60 K
 glibc				0:2.28-208.el8				6.44 M		1.89 M
 python36			0:3.6.8-38.module_el8.5.0+895+a459eca8	14.15 K		19.78 K
 p11-kit-trust			0:0.23.22-1.el8				546.52 K	137.01 K
 glibc-devel			0:2.28-208.el8				211.05 K	81.47 K
 platform-python-setuptools	0:39.2.0-6.el8				2.99 M		647.44 K
 cracklib-dicts			0:2.9.6-15.el8				9.82 M		4.14 M
 libpkgconf			0:1.4.2-1.el8				76.68 K		34.52 K
 libmpc				0:1.1.0-9.1.el8				153.15 K	61.39 K
 libatomic			0:8.5.0-15.el8				71.14 K		25.88 K
 libcap				0:2.48-4.el8				519.20 K	74.90 K
Ignoring:										
											
Transaction Summary:									
Installing 99 Packages 									
Total download size: 87.49 M								
Total install size: 265.00 M								
+ bazel run --config=x86_64 //:bazeldnf -- rpmtree --public --nobest --name launcherbase_aarch64 --arch aarch64 --basesystem centos-stream-release --force-ignore-with-dependencies '^mozjs60' --force-ignore-with-dependencies python --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal libvirt-client-0:8.0.0-2.module_el8.6.0+1087+b42c8331 libvirt-daemon-driver-qemu-0:8.0.0-2.module_el8.6.0+1087+b42c8331 qemu-kvm-core-15:6.2.0-5.module_el8.6.0+1087+b42c8331 edk2-aarch64-0:20220126gitbb1bba3d77-2.el8 ethtool findutils iptables nftables nmap-ncat procps-ng selinux-policy selinux-policy-targeted tar xorriso
INFO: Analyzed target //:bazeldnf (4 packages loaded, 148 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 0.636s, Critical Path: 0.04s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Running command line: bazel-bin/bazeldnf.bash rpmtree --public --nobest --name launcherbase_aarch64 --arch aarch64 --basesystem centos-stream-release --force-ignore-with-dependencies '^mozjs60' --force-ignore-with-dependencies python --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal libvirt-client-0:8.0.0-2.module_el8.6.0+1087+b42c8331 libvirt-daemon-driver-qemu-0:8.0.0-2.module_el8.6.0+1087+b42c8331 qemu-kvm-core-15:6.2.0-5.module_el8.6.0+1087+b42c8331 
INFO: Build completed successfully, 1 total action
INFO[0000] Loading packages.                            
INFO[0004] Initial reduction of involved packages.      
INFO[0005] Loading involved packages into the rpmtreer. 
WARN[0005] Package python3-setools-0:4.3.0-2.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-setuptools-wheel-0:39.0.1-13.module_el8.5.0+743+cd2f5d28 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-0:2.7.18-6.module_el8.5.0+772+8dae0bfd is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-45.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-pip-wheel-0:19.3.1-2.module_el8.5.0+831+7c139a3b is forcefully ignored by regex 'python'. 
WARN[0005] Package policycoreutils-python-utils-0:2.9-17.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-policycoreutils-0:2.9-17.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-setuptools-wheel-0:41.6.0-5.module_el8.5.0+896+eb9e77ba is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-0:2.7.18-5.module_el8.5.0+763+a555e7f1 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-0:2.7.18-8.module_el8.6.0+940+9e7326fe is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-libs-0:3.8.6-3.module_el8.5.0+742+dbad1979 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-0:3.9.2-1.module_el8.5.0+738+dc19af12 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-0:2.7.17-1.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-0:3.8.6-3.module_el8.5.0+742+dbad1979 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-0:3.9.7-1.module_el8.6.0+930+10acc06f is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-pip-wheel-0:19.3.1-5.module_el8.6.0+960+f11a9b17 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-libs-0:3.9.7-1.module_el8.6.0+930+10acc06f is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-pip-wheel-0:19.3.1-4.module_el8.5.0+896+eb9e77ba is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-0:3.9.13-1.module_el8.7.0+1178+0ba51308 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-setuptools-wheel-0:39.2.0-6.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-42.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-41.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package policycoreutils-python-utils-0:2.9-18.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-0:3.8.8-1.module_el8.5.0+758+421c7348 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-0:2.7.18-7.module_el8.5.0+894+1c54b371 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-0:3.9.6-2.module_el8.5.0+897+68c4c210 is forcefully ignored by regex 'python'. 
WARN[0005] Package policycoreutils-python-utils-0:2.9-14.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-policycoreutils-0:2.9-18.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-42.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libselinux-0:2.9-5.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-46.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-0:2.7.18-10.module_el8.6.0+1092+a03304bb is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-policycoreutils-0:2.9-16.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-libs-0:3.8.8-2.module_el8.5.0+765+e829a51d is forcefully ignored by regex 'python'. 
WARN[0005] Package policycoreutils-python-utils-0:2.9-15.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-0:3.8.8-2.module_el8.5.0+765+e829a51d is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-policycoreutils-0:2.9-15.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-pip-wheel-0:19.3.1-1.module_el8.5.0+742+dbad1979 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-44.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-pip-wheel-0:9.0.3-19.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-libs-0:3.8.13-1.module_el8.7.0+1177+19c53253 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-libs-0:2.7.18-6.module_el8.5.0+772+8dae0bfd is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-setuptools-wheel-0:41.6.0-4.module_el8.5.0+742+dbad1979 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-policycoreutils-0:2.9-19.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-libs-0:2.7.18-11.module_el8.7.0+1179+42dadd5f is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-libs-0:3.9.6-1.module_el8.5.0+872+ab54e8e5 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-libs-0:3.9.2-2.module_el8.5.0+766+33a59395 is forcefully ignored by regex 'python'. 
WARN[0005] Package policycoreutils-python-utils-0:2.9-16.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-45.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-0:3.8.8-4.module_el8.5.0+896+eb9e77ba is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-audit-0:3.0.7-2.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-libs-0:2.7.18-8.module_el8.6.0+940+9e7326fe is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-pip-wheel-0:9.0.3-22.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-audit-0:3.0.7-1.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-pip-wheel-0:9.0.3-19.module_el8.6.0+987+71f62bb6 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-pip-wheel-0:20.2.4-5.module_el8.5.0+859+e98e3670 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-pip-wheel-0:20.2.4-6.module_el8.6.0+930+10acc06f is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-libs-0:3.8.12-1.module_el8.6.0+929+89303463 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-pip-wheel-0:19.3.1-4.module_el8.6.0+929+89303463 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-libs-0:3.8.8-3.module_el8.5.0+871+689c57c1 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-setuptools-wheel-0:39.0.1-13.module_el8.4.0+642+1dc4fb01 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-0:2.7.18-11.module_el8.7.0+1179+42dadd5f is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-libs-0:2.7.18-7.module_el8.5.0+894+1c54b371 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-pip-wheel-0:9.0.3-18.module_el8.4.0+642+1dc4fb01 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-for-tests-0:2.7.17-1.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-0:3.9.6-1.module_el8.5.0+872+ab54e8e5 is forcefully ignored by regex 'python'. 
WARN[0005] Package mozjs60-0:60.9.0-4.el8 is forcefully ignored by regex '^mozjs60'. 
WARN[0005] Package python3-policycoreutils-0:2.9-14.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-libs-0:3.8.8-1.module_el8.5.0+758+421c7348 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-pip-wheel-0:20.2.4-3.module_el8.5.0+738+dc19af12 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-libs-0:2.7.17-1.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-setuptools-wheel-0:50.3.2-3.module_el8.5.0+738+dc19af12 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-37.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package policycoreutils-python-utils-0:2.9-19.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-38.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-audit-0:3.0.7-3.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-libs-0:3.8.8-4.module_el8.5.0+896+eb9e77ba is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-pip-wheel-0:9.0.3-20.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-libs-0:3.9.2-1.module_el8.5.0+738+dc19af12 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-audit-0:3.0.7-4.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-47.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-audit-0:3.0-0.17.20191104git1c2f876.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-0:3.8.12-1.module_el8.6.0+929+89303463 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-0:3.8.8-3.module_el8.5.0+871+689c57c1 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-40.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-0:3.8.13-1.module_el8.7.0+1177+19c53253 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-pip-wheel-0:19.3.1-3.module_el8.5.0+855+e844d92d is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-setuptools-wheel-0:50.3.2-4.module_el8.5.0+897+68c4c210 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libsemanage-0:2.9-6.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-39.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-41.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-37.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-0:2.7.18-4.module_el8.5.0+743+cd2f5d28 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-setuptools-wheel-0:50.3.2-4.module_el8.6.0+930+10acc06f is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-setools-0:4.3.0-3.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-0:3.9.2-2.module_el8.5.0+766+33a59395 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libsemanage-0:2.9-8.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-pip-wheel-0:9.0.3-18.module_el8.5.0+743+cd2f5d28 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-39.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-47.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-libs-0:2.7.18-4.module_el8.5.0+743+cd2f5d28 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-pip-wheel-0:20.2.4-4.module_el8.5.0+832+b0e10cdc is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-pip-wheel-0:20.2.4-6.module_el8.5.0+897+68c4c210 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-libs-0:3.9.6-2.module_el8.5.0+897+68c4c210 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-setuptools-0:39.2.0-6.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-pip-wheel-0:20.2.4-7.module_el8.6.0+961+ca697fb5 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-setuptools-wheel-0:41.6.0-5.module_el8.6.0+929+89303463 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-38.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-pip-wheel-0:19.3.1-6.module_el8.7.0+1184+30eba247 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-libs-0:2.7.18-10.module_el8.6.0+1092+a03304bb is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-40.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-libs-0:2.7.18-5.module_el8.5.0+763+a555e7f1 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-46.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-44.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-libs-0:3.9.13-1.module_el8.7.0+1178+0ba51308 is forcefully ignored by regex 'python'. 
INFO[0005] Loaded 5119 packages.                        
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] Generated 22224 variables.                   
INFO[0005] Adding required packages to the rpmtreer.    
INFO[0005] Selecting acl: acl-0:2.2.53-1.el8            
INFO[0005] Selecting curl: curl-0:7.61.1-25.el8         
INFO[0005] Selecting vim-minimal: vim-minimal-2:8.0.1763-19.el8.4 
INFO[0005] Selecting coreutils-single: coreutils-single-0:8.30-13.el8 
INFO[0005] Selecting glibc-minimal-langpack: glibc-minimal-langpack-0:2.28-208.el8 
INFO[0005] Selecting libcurl-minimal: libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] Selecting libvirt-client: libvirt-client-0:8.0.0-2.module_el8.6.0+1087+b42c8331 
INFO[0005] Selecting libvirt-daemon-driver-qemu: libvirt-daemon-driver-qemu-0:8.0.0-2.module_el8.6.0+1087+b42c8331 
INFO[0005] Selecting qemu-kvm-core: qemu-kvm-core-15:6.2.0-5.module_el8.6.0+1087+b42c8331 
INFO[0005] Selecting edk2-aarch64: edk2-aarch64-0:20220126gitbb1bba3d77-2.el8 
INFO[0005] Selecting ethtool: ethtool-2:5.13-2.el8      
INFO[0005] Selecting findutils: findutils-1:4.6.0-20.el8 
INFO[0005] Selecting iptables: iptables-0:1.8.4-22.el8  
INFO[0005] Selecting nftables: nftables-1:0.9.3-26.el8  
INFO[0005] Selecting nmap-ncat: nmap-ncat-2:7.70-7.el8  
INFO[0005] Selecting procps-ng: procps-ng-0:3.3.15-7.el8 
INFO[0005] Selecting selinux-policy: selinux-policy-0:3.14.3-104.el8 
INFO[0005] Selecting selinux-policy-targeted: selinux-policy-targeted-0:3.14.3-104.el8 
INFO[0005] Selecting tar: tar-2:1.30-6.el8              
INFO[0005] Selecting xorriso: xorriso-0:1.4.8-4.el8     
INFO[0005] Selecting centos-stream-release: centos-stream-release-0:8.6-1.el8 
INFO[0005] Solving.                                     
INFO[0005] Loading the Partial weighted MAXSAT problem. 
INFO[0013] Solving the Partial weighted MAXSAT problem. 
INFO[0013] Solution with weight 5804 found.             
INFO[0013] Picking qemu-kvm-common-15:6.2.0-5.module_el8.6.0+1087+b42c8331 instead of best candiate qemu-kvm-common-15:6.2.0-12.module_el8.7.0+1140+ff0772f9 
INFO[0013] Picking qemu-img-15:6.2.0-5.module_el8.6.0+1087+b42c8331 instead of best candiate qemu-img-15:6.2.0-12.module_el8.7.0+1140+ff0772f9 
INFO[0013] Picking libvirt-libs-0:8.0.0-2.module_el8.6.0+1087+b42c8331 instead of best candiate libvirt-libs-0:8.0.0-6.module_el8.7.0+1140+ff0772f9 
INFO[0013] Picking libvirt-daemon-0:8.0.0-2.module_el8.6.0+1087+b42c8331 instead of best candiate libvirt-daemon-0:8.0.0-6.module_el8.7.0+1140+ff0772f9 
INFO[0013] Writing bazel files.                         
Package				Version								Size		Download Size
Installing:													
 centos-stream-repos		0:8-6.el8							30.21 K		20.59 K
 elfutils-default-yama-scope	0:0.187-4.el8							2.09 K		52.83 K
 systemd			0:239-60.el8							13.71 M		3.46 M
 gawk				0:4.2.1-4.el8							3.55 M		1.16 M
 timedatex			0:0.5-3.el8							94.40 K		32.77 K
 bzip2				0:1.0.6-26.el8							183.73 K	61.12 K
 gnutls				0:3.6.16-4.el8							3.02 M		961.79 K
 libtasn1			0:4.13-3.el8							227.56 K	76.57 K
 glibc-minimal-langpack		0:2.28-208.el8							124		64.45 K
 libburn			0:1.4.8-3.el8							404.30 K	167.04 K
 cyrus-sasl-lib			0:2.1.27-6.el8_5						935.64 K	125.34 K
 lzop				0:1.03-20.el8							176.58 K	62.03 K
 libnl3				0:3.7.0-1.el8							1.28 M		324.26 K
 selinux-policy			0:3.14.3-104.el8						26.06 K		665.72 K
 polkit-libs			0:0.115-13.0.1.el8.2						231.32 K	75.95 K
 popt				0:1.18-1.el8							149.27 K	61.62 K
 grep				0:3.1-6.el8							871.31 K	274.63 K
 lua-libs			0:5.3.4-12.el8							272.89 K	114.71 K
 qemu-kvm-common		15:6.2.0-5.module_el8.6.0+1087+b42c8331				4.12 M		1.05 M
 libnsl2			0:1.2.0-2.20180605git4a062cf.el8				183.15 K	56.46 K
 libattr			0:2.4.48-3.el8							73.02 K		27.35 K
 libgomp			0:8.5.0-15.el8							369.95 K	204.15 K
 libtirpc			0:1.1.4-7.el8							283.69 K	111.68 K
 bzip2-libs			0:1.0.6-26.el8							77.97 K		49.31 K
 filesystem			0:3.8-6.el8							215.45 K	1.14 M
 libbpf				0:0.5.0-1.el8							337.31 K	134.79 K
 gmp				1:6.1.2-10.el8							1.56 M		275.14 K
 libffi				0:3.1-23.el8							87.61 K		37.32 K
 ncurses-base			0:6.1-9.20180224.el8						314.23 K	83.08 K
 rpm-libs			0:4.14.3-23.el8							756.91 K	336.00 K
 libsigsegv			0:2.11-5.el8							101.68 K	30.92 K
 userspace-rcu			0:0.10.1-4.el8							592.17 K	100.36 K
 libnetfilter_conntrack		0:1.0.6-5.el8							169.10 K	62.68 K
 glibc-common			0:2.28-208.el8							8.32 M		1.03 M
 libpcap			14:1.9.1-5.el8							411.10 K	164.80 K
 libusbx			0:1.0.23-4.el8							180.35 K	74.36 K
 polkit				0:0.115-13.0.1.el8.2						652.45 K	153.68 K
 readline			0:7.0-10.el8							523.94 K	197.65 K
 libdb-utils			0:5.3.28-42.el8_4						1.09 M		151.46 K
 dbus-daemon			1:1.12.8-19.el8							752.14 K	239.03 K
 iptables			0:1.8.4-22.el8							9.02 M		595.80 K
 snappy				0:1.1.8-3.el8							86.34 K		36.96 K
 libzstd			0:1.4.4-1.el8							621.24 K	246.07 K
 procps-ng			0:3.3.15-7.el8							1.73 M		335.05 K
 cyrus-sasl-gssapi		0:2.1.27-6.el8_5						71.53 K		50.17 K
 ethtool			2:5.13-2.el8							694.28 K	217.23 K
 tzdata				0:2022a-2.el8							2.18 M		485.40 K
 device-mapper-libs		8:1.02.181-3.el8						457.66 K	406.88 K
 polkit-pkla-compat		0:0.1-12.el8							181.69 K	46.32 K
 json-c				0:0.13.1-3.el8							74.52 K		40.92 K
 lz4-libs			0:1.8.3-3.el8_4							138.43 K	64.50 K
 libtpms			0:0.9.1-0.20211126git1ff6fe1f43.module_el8.6.0+1087+b42c8331	424.62 K	184.37 K
 libibverbs			0:37.2-1.el8							1.41 M		371.03 K
 device-mapper			8:1.02.181-3.el8						450.39 K	382.30 K
 acl				0:2.2.53-1.el8							339.09 K	82.04 K
 centos-stream-release		0:8.6-1.el8							29.43 K		22.74 K
 pixman				0:0.38.4-2.el8							406.68 K	152.44 K
 gnutls-utils			0:3.6.16-4.el8							1.87 M		349.33 K
 dbus-common			1:1.12.8-19.el8							12.92 K		47.28 K
 nmap-ncat			2:7.70-7.el8							532.07 K	230.88 K
 qemu-img			15:6.2.0-5.module_el8.6.0+1087+b42c8331				8.66 M		2.14 M
 libxcrypt			0:4.1.1-6.el8							188.21 K	74.94 K
 sqlite-libs			0:3.26.0-15.el8							1.16 M		562.98 K
 libevent			0:2.1.8-5.el8							1.14 M		244.75 K
 libgpg-error			0:1.31-1.el8							944.39 K	245.33 K
 kmod-libs			0:25-19.el8							164.34 K	67.49 K
 ca-certificates		0:2021.2.50-82.el8						936.15 K	399.50 K
 pcre				0:8.42-6.el8							569.29 K	191.54 K
 dbus-tools			1:1.12.8-19.el8							319.71 K	86.43 K
 xz				0:5.2.4-4.el8							537.22 K	156.23 K
 cyrus-sasl			0:2.1.27-6.el8_5						297.91 K	98.06 K
 libisofs			0:1.4.8-3.el8							515.71 K	214.10 K
 libpng				2:1.6.34-5.el8							219.26 K	121.96 K
 libxml2			0:2.9.7-14.el8							1.85 M		668.31 K
 curl				0:7.61.1-25.el8							736.16 K	356.51 K
 systemd-pam			0:239-60.el8							946.18 K	458.13 K
 libvirt-libs			0:8.0.0-2.module_el8.6.0+1087+b42c8331				24.37 M		4.74 M
 selinux-policy-targeted	0:3.14.3-104.el8						44.06 M		15.87 M
 libcurl-minimal		0:7.61.1-25.el8							540.82 K	278.08 K
 libutempter			0:1.1.6-14.el8							168.88 K	32.61 K
 glib2				0:2.56.4-159.el8						12.84 M		2.55 M
 psmisc				0:23.1-5.el8							699.81 K	146.90 K
 util-linux			0:2.32.1-35.el8							15.27 M		2.59 M
 info				0:6.5-7.el8_5							435.78 K	195.90 K
 iproute			0:5.18.0-1.el8							3.09 M		823.60 K
 autogen-libopts		0:5.18.12-8.el8							150.73 K	73.83 K
 nftables			1:0.9.3-26.el8							919.44 K	319.79 K
 unbound-libs			0:1.16.0-2.el8							1.54 M		540.13 K
 pcre2				0:10.32-3.el8							704.00 K	224.40 K
 libarchive			0:3.3.3-4.el8							864.67 K	348.29 K
 swtpm-libs			0:0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331	140.44 K	48.35 K
 kmod				0:25-19.el8							289.87 K	125.78 K
 openssl-libs			1:1.1.1k-6.el8							3.66 M		1.41 M
 libblkid			0:2.32.1-35.el8							406.42 K	217.51 K
 dbus				1:1.12.8-19.el8							124		42.40 K
 swtpm-tools			0:0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331	453.76 K	115.95 K
 vim-minimal			2:8.0.1763-19.el8.4						1.27 M		556.98 K
 p11-kit-trust			0:0.23.22-1.el8							546.52 K	137.01 K
 xz-libs			0:5.2.4-4.el8							207.34 K	92.70 K
 swtpm				0:0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331	251.62 K	43.29 K
 libcom_err			0:1.45.6-5.el8							115.71 K	50.26 K
 pam				0:1.3.1-22.el8							5.66 M		755.23 K
 libselinux			0:2.9-5.el8							207.84 K	165.61 K
 p11-kit			0:0.23.22-1.el8							1.79 M		313.39 K
 libmnl				0:1.0.4-6.el8							99.87 K		30.55 K
 libunistring			0:0.9.9-3.el8							1.84 M		420.63 K
 setup				0:2.12.2-7.el8							729.30 K	185.09 K
 libssh				0:0.9.6-3.el8							531.82 K	211.88 K
 edk2-aarch64			0:20220126gitbb1bba3d77-2.el8					206.35 M	5.88 M
 diffutils			0:3.6-6.el8							1.46 M		360.62 K
 libstdc++			0:8.5.0-15.el8							1.86 M		434.54 K
 openldap			0:2.4.46-18.el8							1.07 M		347.27 K
 audit-libs			0:3.0.7-4.el8							302.21 K	121.25 K
 libsmartcols			0:2.32.1-35.el8							298.79 K	177.60 K
 gettext			0:0.19.8.1-17.el8						6.26 M		1.10 M
 centos-gpg-keys		1:8-6.el8							6.28 K		14.63 K
 xkeyboard-config		0:2.28-1.el8							5.74 M		800.95 K
 libnghttp2			0:1.33.0-3.el8_2.1						214.14 K	76.43 K
 libcap				0:2.48-4.el8							519.20 K	74.90 K
 libvirt-client			0:8.0.0-2.module_el8.6.0+1087+b42c8331				1.04 M		388.57 K
 basesystem			0:11-5.el8							124		10.75 K
 rpm-plugin-selinux		0:4.14.3-23.el8							69.78 K		79.38 K
 cracklib-dicts			0:2.9.6-15.el8							9.82 M		4.14 M
 systemd-container		0:239-60.el8							1.86 M		709.43 K
 gzip				0:1.9-13.el8							399.30 K	168.60 K
 libfdisk			0:2.32.1-35.el8							439.62 K	248.02 K
 tar				2:1.30-6.el8							2.91 M		849.38 K
 crypto-policies		0:20211116-1.gitae470d6.el8					94.23 K		65.20 K
 libgcrypt			0:1.8.5-7.el8							904.04 K	400.58 K
 xorriso			0:1.4.8-4.el8							338.63 K	288.18 K
 gnutls-dane			0:3.6.16-4.el8							71.38 K		51.56 K
 libfdt				0:1.6.0-1.el8							89.00 K		32.71 K
 libgcc				0:8.5.0-15.el8							228.30 K	75.52 K
 gettext-libs			0:0.19.8.1-17.el8						1.74 M		303.11 K
 shadow-utils			2:4.6-16.el8							4.72 M		1.27 M
 libverto			0:0.3.2-2.el8							73.15 K		24.13 K
 libvirt-daemon-driver-qemu	0:8.0.0-2.module_el8.6.0+1087+b42c8331				2.57 M		818.50 K
 rpm				0:4.14.3-23.el8							2.38 M		555.93 K
 libxkbcommon			0:0.9.1-1.el8							279.88 K	114.19 K
 cryptsetup-libs		0:2.3.7-2.el8							2.17 M		483.95 K
 findutils			1:4.6.0-20.el8							1.86 M		537.62 K
 libmount			0:2.32.1-35.el8							432.32 K	233.36 K
 libcap-ng			0:0.7.11-1.el8							97.04 K		33.56 K
 libidn2			0:2.2.0-1.el8							304.65 K	95.56 K
 libisoburn			0:1.4.8-4.el8							1.07 M		393.43 K
 librdmacm			0:37.2-1.el8							213.84 K	77.00 K
 glibc				0:2.28-208.el8							6.44 M		1.89 M
 sed				0:4.5-5.el8							793.54 K	301.66 K
 qemu-kvm-core			15:6.2.0-5.module_el8.6.0+1087+b42c8331				15.66 M		3.71 M
 mpfr				0:3.1.6-1.el8							660.59 K	219.65 K
 libnfnetlink			0:1.0.1-13.el8							90.45 K		33.18 K
 libaio				0:0.3.112-1.el8							210.35 K	33.36 K
 policycoreutils		0:2.9-19.el8							1.32 M		382.58 K
 libsemanage			0:2.9-8.el8							310.00 K	167.22 K
 libpwquality			0:1.4.4-3.el8							624.92 K	108.67 K
 lzo				0:2.08-14.el8							193.76 K	65.80 K
 libseccomp			0:2.5.2-1.el8							179.57 K	71.57 K
 numactl-libs			0:2.0.12-13.el8							72.46 K		36.50 K
 numad				0:0.5-26.20150602git.el8					76.34 K		41.07 K
 iproute-tc			0:5.18.0-1.el8							990.97 K	471.56 K
 libcroco			0:0.6.12-4.el8_2.1						398.23 K	110.90 K
 libdb				0:5.3.28-42.el8_4						1.76 M		703.36 K
 elfutils-libelf		0:0.187-4.el8							1.06 M		235.12 K
 elfutils-libs			0:0.187-4.el8							768.57 K	294.51 K
 systemd-libs			0:239-60.el8							4.62 M		1.06 M
 chkconfig			0:1.19.1-1.el8							900.22 K	201.57 K
 device-mapper-multipath-libs	0:0.8.4-26.el8							2.15 M		326.25 K
 libselinux-utils		0:2.9-5.el8							1.14 M		246.59 K
 libuuid			0:2.32.1-35.el8							73.13 K		98.53 K
 libnftnl			0:1.1.5-5.el8							227.20 K	81.62 K
 libvirt-daemon			0:8.0.0-2.module_el8.6.0+1087+b42c8331				2.01 M		405.65 K
 libacl				0:2.2.53-1.el8							90.82 K		34.67 K
 dbus-libs			1:1.12.8-19.el8							434.86 K	180.00 K
 yajl				0:2.1.0-11.el8							223.14 K	40.51 K
 coreutils-single		0:8.30-13.el8							1.47 M		609.90 K
 libssh-config			0:0.9.6-3.el8							816		19.75 K
 cracklib			0:2.9.6-15.el8							450.20 K	95.20 K
 bash				0:4.4.20-4.el8							6.97 M		1.60 M
 jansson			0:2.14-1.el8							97.26 K		48.30 K
 expat				0:2.2.5-9.el8							309.03 K	106.08 K
 zlib				0:1.2.11-19.el8							238.24 K	102.92 K
 krb5-libs			0:1.18.2-21.el8							2.47 M		838.16 K
 keyutils-libs			0:1.5.10-9.el8							98.24 K		34.62 K
 nettle				0:3.4.1-7.el8							607.74 K	314.69 K
 libsepol			0:2.9-3.el8							770.35 K	328.54 K
 iptables-libs			0:1.8.4-22.el8							422.24 K	107.70 K
 ncurses-libs			0:6.1-9.20180224.el8						1.25 M		317.99 K
 json-glib			0:1.4.4-1.el8							572.98 K	143.38 K
Ignoring:													
 policycoreutils-python-utils	0:2.9-19.el8							147.96 K	258.84 K
 mozjs60			0:60.9.0-4.el8							22.03 M		6.34 M
 python3-libs			0:3.6.8-47.el8							35.27 M		8.07 M
 platform-python		0:3.6.8-47.el8							101.15 K	87.88 K
														
Transaction Summary:												
Installing 188 Packages 											
Total download size: 95.62 M											
Total install size: 529.59 M											
+ bazel run --config=x86_64 //:bazeldnf -- rpmtree --public --nobest --name handlerbase_aarch64 --arch aarch64 --basesystem centos-stream-release --force-ignore-with-dependencies python --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single glibc-minimal-langpack libcurl-minimal qemu-img-15:6.2.0-5.module_el8.6.0+1087+b42c8331 findutils iproute iptables nftables procps-ng selinux-policy selinux-policy-targeted tar util-linux xorriso
INFO: Analyzed target //:bazeldnf (4 packages loaded, 148 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 0.688s, Critical Path: 0.04s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Running command line: bazel-bin/bazeldnf.bash rpmtree --public --nobest --name handlerbase_aarch64 --arch aarch64 --basesystem centos-stream-release --force-ignore-with-dependencies python --repofile rpm/repo.yaml acl curl vim-minimal coreutils-single 
INFO: Build completed successfully, 1 total action
INFO[0000] Loading packages.                            
INFO[0004] Initial reduction of involved packages.      
INFO[0005] Loading involved packages into the rpmtreer. 
WARN[0005] Package python3-audit-0:3.0-0.17.20191104git1c2f876.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-0:2.7.17-1.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libsemanage-0:2.9-6.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-libs-0:3.8.12-1.module_el8.6.0+929+89303463 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-0:3.8.13-1.module_el8.7.0+1177+19c53253 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-pip-wheel-0:19.3.1-4.module_el8.6.0+929+89303463 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-pip-wheel-0:19.3.1-1.module_el8.5.0+742+dbad1979 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-setuptools-wheel-0:41.6.0-5.module_el8.5.0+896+eb9e77ba is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-setools-0:4.3.0-2.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-for-tests-0:2.7.17-1.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-44.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-audit-0:3.0.7-3.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-libs-0:3.8.6-3.module_el8.5.0+742+dbad1979 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-libs-0:3.9.6-1.module_el8.5.0+872+ab54e8e5 is forcefully ignored by regex 'python'. 
WARN[0005] Package policycoreutils-python-utils-0:2.9-14.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-pip-wheel-0:20.2.4-7.module_el8.6.0+961+ca697fb5 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-39.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-47.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-policycoreutils-0:2.9-18.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-pip-wheel-0:19.3.1-2.module_el8.5.0+831+7c139a3b is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-0:2.7.18-6.module_el8.5.0+772+8dae0bfd is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-0:3.9.6-2.module_el8.5.0+897+68c4c210 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-40.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-41.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-libs-0:3.8.13-1.module_el8.7.0+1177+19c53253 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-policycoreutils-0:2.9-19.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-setuptools-wheel-0:50.3.2-3.module_el8.5.0+738+dc19af12 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-0:3.8.12-1.module_el8.6.0+929+89303463 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-0:2.7.18-10.module_el8.6.0+1092+a03304bb is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libsemanage-0:2.9-8.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-libs-0:3.8.8-1.module_el8.5.0+758+421c7348 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-0:3.8.8-3.module_el8.5.0+871+689c57c1 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-libs-0:2.7.18-6.module_el8.5.0+772+8dae0bfd is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-libs-0:3.8.8-3.module_el8.5.0+871+689c57c1 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-audit-0:3.0.7-4.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-0:3.9.2-1.module_el8.5.0+738+dc19af12 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-policycoreutils-0:2.9-15.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-40.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-pip-wheel-0:19.3.1-3.module_el8.5.0+855+e844d92d is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-0:3.9.7-1.module_el8.6.0+930+10acc06f is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-pip-wheel-0:9.0.3-18.module_el8.5.0+743+cd2f5d28 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-libs-0:2.7.17-1.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-0:3.8.6-3.module_el8.5.0+742+dbad1979 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-0:2.7.18-8.module_el8.6.0+940+9e7326fe is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-setuptools-wheel-0:41.6.0-4.module_el8.5.0+742+dbad1979 is forcefully ignored by regex 'python'. 
WARN[0005] Package policycoreutils-python-utils-0:2.9-15.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-pip-wheel-0:19.3.1-4.module_el8.5.0+896+eb9e77ba is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-libs-0:3.9.13-1.module_el8.7.0+1178+0ba51308 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-pip-wheel-0:20.2.4-3.module_el8.5.0+738+dc19af12 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-0:2.7.18-11.module_el8.7.0+1179+42dadd5f is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-41.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-libs-0:2.7.18-8.module_el8.6.0+940+9e7326fe is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-0:3.9.2-2.module_el8.5.0+766+33a59395 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-pip-wheel-0:20.2.4-6.module_el8.5.0+897+68c4c210 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-42.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-pip-wheel-0:9.0.3-22.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package policycoreutils-python-utils-0:2.9-19.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-setuptools-wheel-0:41.6.0-5.module_el8.6.0+929+89303463 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-libs-0:3.9.6-2.module_el8.5.0+897+68c4c210 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-pip-wheel-0:9.0.3-19.module_el8.6.0+987+71f62bb6 is forcefully ignored by regex 'python'. 
WARN[0005] Package policycoreutils-python-utils-0:2.9-18.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-libs-0:2.7.18-11.module_el8.7.0+1179+42dadd5f is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libselinux-0:2.9-5.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-libs-0:3.9.7-1.module_el8.6.0+930+10acc06f is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-libs-0:2.7.18-7.module_el8.5.0+894+1c54b371 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-pip-wheel-0:19.3.1-5.module_el8.6.0+960+f11a9b17 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-0:3.8.8-1.module_el8.5.0+758+421c7348 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-setuptools-wheel-0:50.3.2-4.module_el8.5.0+897+68c4c210 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-policycoreutils-0:2.9-17.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-libs-0:2.7.18-4.module_el8.5.0+743+cd2f5d28 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-pip-wheel-0:20.2.4-5.module_el8.5.0+859+e98e3670 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-37.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-setuptools-0:39.2.0-6.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-46.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-libs-0:3.9.2-1.module_el8.5.0+738+dc19af12 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-libs-0:2.7.18-5.module_el8.5.0+763+a555e7f1 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-libs-0:3.9.2-2.module_el8.5.0+766+33a59395 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-42.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-setools-0:4.3.0-3.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-libs-0:3.8.8-4.module_el8.5.0+896+eb9e77ba is forcefully ignored by regex 'python'. 
WARN[0005] Package policycoreutils-python-utils-0:2.9-17.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-setuptools-wheel-0:39.0.1-13.module_el8.4.0+642+1dc4fb01 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-pip-wheel-0:9.0.3-20.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-0:3.9.6-1.module_el8.5.0+872+ab54e8e5 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-audit-0:3.0.7-1.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-setuptools-wheel-0:50.3.2-4.module_el8.6.0+930+10acc06f is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-policycoreutils-0:2.9-16.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-38.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-pip-wheel-0:20.2.4-6.module_el8.6.0+930+10acc06f is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-0:2.7.18-7.module_el8.5.0+894+1c54b371 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-0:2.7.18-4.module_el8.5.0+743+cd2f5d28 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-policycoreutils-0:2.9-14.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-0:2.7.18-5.module_el8.5.0+763+a555e7f1 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-39.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-0:3.9.13-1.module_el8.7.0+1178+0ba51308 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-pip-wheel-0:9.0.3-19.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python39-pip-wheel-0:20.2.4-4.module_el8.5.0+832+b0e10cdc is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-setuptools-wheel-0:39.2.0-6.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package policycoreutils-python-utils-0:2.9-16.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-pip-wheel-0:9.0.3-18.module_el8.4.0+642+1dc4fb01 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-46.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-0:3.8.8-2.module_el8.5.0+765+e829a51d is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-audit-0:3.0.7-2.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-47.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-libs-0:3.8.8-2.module_el8.5.0+765+e829a51d is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-45.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-45.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-0:3.8.8-4.module_el8.5.0+896+eb9e77ba is forcefully ignored by regex 'python'. 
WARN[0005] Package python38-pip-wheel-0:19.3.1-6.module_el8.7.0+1184+30eba247 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-setuptools-wheel-0:39.0.1-13.module_el8.5.0+743+cd2f5d28 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-38.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python3-libs-0:3.6.8-44.el8 is forcefully ignored by regex 'python'. 
WARN[0005] Package python2-libs-0:2.7.18-10.module_el8.6.0+1092+a03304bb is forcefully ignored by regex 'python'. 
WARN[0005] Package platform-python-0:3.6.8-37.el8 is forcefully ignored by regex 'python'. 
INFO[0005] Loaded 4981 packages.                        
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0005] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0005] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0005] Generated 20681 variables.                   
INFO[0005] Adding required packages to the rpmtreer.    
INFO[0005] Selecting acl: acl-0:2.2.53-1.el8            
INFO[0005] Selecting curl: curl-0:7.61.1-25.el8         
INFO[0005] Selecting vim-minimal: vim-minimal-2:8.0.1763-19.el8.4 
INFO[0005] Selecting coreutils-single: coreutils-single-0:8.30-13.el8 
INFO[0005] Selecting glibc-minimal-langpack: glibc-minimal-langpack-0:2.28-208.el8 
INFO[0005] Selecting libcurl-minimal: libcurl-minimal-0:7.61.1-25.el8 
INFO[0005] Selecting qemu-img: qemu-img-15:6.2.0-5.module_el8.6.0+1087+b42c8331 
INFO[0005] Selecting findutils: findutils-1:4.6.0-20.el8 
INFO[0005] Selecting iproute: iproute-0:5.18.0-1.el8    
INFO[0005] Selecting iptables: iptables-0:1.8.4-22.el8  
INFO[0005] Selecting nftables: nftables-1:0.9.3-26.el8  
INFO[0005] Selecting procps-ng: procps-ng-0:3.3.15-7.el8 
INFO[0005] Selecting selinux-policy: selinux-policy-0:3.14.3-104.el8 
INFO[0005] Selecting selinux-policy-targeted: selinux-policy-targeted-0:3.14.3-104.el8 
INFO[0005] Selecting tar: tar-2:1.30-6.el8              
INFO[0005] Selecting util-linux: util-linux-0:2.32.1-35.el8 
INFO[0005] Selecting xorriso: xorriso-0:1.4.8-4.el8     
INFO[0005] Selecting centos-stream-release: centos-stream-release-0:8.6-1.el8 
INFO[0005] Solving.                                     
INFO[0005] Loading the Partial weighted MAXSAT problem. 
INFO[0011] Solving the Partial weighted MAXSAT problem. 
INFO[0011] Solution with weight 0 found.                
INFO[0011] Writing bazel files.                         
Package				Version					Size		Download Size
Installing:										
 libpwquality			0:1.4.4-3.el8				624.92 K	108.67 K
 libnfnetlink			0:1.0.1-13.el8				90.45 K		33.18 K
 libfdisk			0:2.32.1-35.el8				439.62 K	248.02 K
 pam				0:1.3.1-22.el8				5.66 M		755.23 K
 popt				0:1.18-1.el8				149.27 K	61.62 K
 iptables			0:1.8.4-22.el8				9.02 M		595.80 K
 centos-gpg-keys		1:8-6.el8				6.28 K		14.63 K
 audit-libs			0:3.0.7-4.el8				302.21 K	121.25 K
 nettle				0:3.4.1-7.el8				607.74 K	314.69 K
 ncurses-base			0:6.1-9.20180224.el8			314.23 K	83.08 K
 libsigsegv			0:2.11-5.el8				101.68 K	30.92 K
 libverto			0:0.3.2-2.el8				73.15 K		24.13 K
 gzip				0:1.9-13.el8				399.30 K	168.60 K
 pcre2				0:10.32-3.el8				704.00 K	224.40 K
 libcurl-minimal		0:7.61.1-25.el8				540.82 K	278.08 K
 vim-minimal			2:8.0.1763-19.el8.4			1.27 M		556.98 K
 cracklib-dicts			0:2.9.6-15.el8				9.82 M		4.14 M
 glib2				0:2.56.4-159.el8			12.84 M		2.55 M
 libmount			0:2.32.1-35.el8				432.32 K	233.36 K
 xorriso			0:1.4.8-4.el8				338.63 K	288.18 K
 libpcap			14:1.9.1-5.el8				411.10 K	164.80 K
 lz4-libs			0:1.8.3-3.el8_4				138.43 K	64.50 K
 libibverbs			0:37.2-1.el8				1.41 M		371.03 K
 libblkid			0:2.32.1-35.el8				406.42 K	217.51 K
 keyutils-libs			0:1.5.10-9.el8				98.24 K		34.62 K
 p11-kit-trust			0:0.23.22-1.el8				546.52 K	137.01 K
 libtasn1			0:4.13-3.el8				227.56 K	76.57 K
 libaio				0:0.3.112-1.el8				210.35 K	33.36 K
 libarchive			0:3.3.3-4.el8				864.67 K	348.29 K
 lua-libs			0:5.3.4-12.el8				272.89 K	114.71 K
 bash				0:4.4.20-4.el8				6.97 M		1.60 M
 openssl-libs			1:1.1.1k-6.el8				3.66 M		1.41 M
 selinux-policy			0:3.14.3-104.el8			26.06 K		665.72 K
 info				0:6.5-7.el8_5				435.78 K	195.90 K
 libnetfilter_conntrack		0:1.0.6-5.el8				169.10 K	62.68 K
 util-linux			0:2.32.1-35.el8				15.27 M		2.59 M
 diffutils			0:3.6-6.el8				1.46 M		360.62 K
 rpm-libs			0:4.14.3-23.el8				756.91 K	336.00 K
 zlib				0:1.2.11-19.el8				238.24 K	102.92 K
 libnl3				0:3.7.0-1.el8				1.28 M		324.26 K
 glibc				0:2.28-208.el8				6.44 M		1.89 M
 glibc-common			0:2.28-208.el8				8.32 M		1.03 M
 gawk				0:4.2.1-4.el8				3.55 M		1.16 M
 tar				2:1.30-6.el8				2.91 M		849.38 K
 libnftnl			0:1.1.5-5.el8				227.20 K	81.62 K
 libattr			0:2.4.48-3.el8				73.02 K		27.35 K
 centos-stream-release		0:8.6-1.el8				29.43 K		22.74 K
 libisoburn			0:1.4.8-4.el8				1.07 M		393.43 K
 shadow-utils			2:4.6-16.el8				4.72 M		1.27 M
 libcap				0:2.48-4.el8				519.20 K	74.90 K
 p11-kit			0:0.23.22-1.el8				1.79 M		313.39 K
 libdb				0:5.3.28-42.el8_4			1.76 M		703.36 K
 gmp				1:6.1.2-10.el8				1.56 M		275.14 K
 crypto-policies		0:20211116-1.gitae470d6.el8		94.23 K		65.20 K
 pcre				0:8.42-6.el8				569.29 K	191.54 K
 libcom_err			0:1.45.6-5.el8				115.71 K	50.26 K
 libbpf				0:0.5.0-1.el8				337.31 K	134.79 K
 libisofs			0:1.4.8-3.el8				515.71 K	214.10 K
 libsepol			0:2.9-3.el8				770.35 K	328.54 K
 libsmartcols			0:2.32.1-35.el8				298.79 K	177.60 K
 libacl				0:2.2.53-1.el8				90.82 K		34.67 K
 libmnl				0:1.0.4-6.el8				99.87 K		30.55 K
 psmisc				0:23.1-5.el8				699.81 K	146.90 K
 xz-libs			0:5.2.4-4.el8				207.34 K	92.70 K
 nftables			1:0.9.3-26.el8				919.44 K	319.79 K
 libxml2			0:2.9.7-14.el8				1.85 M		668.31 K
 libgpg-error			0:1.31-1.el8				944.39 K	245.33 K
 elfutils-libelf		0:0.187-4.el8				1.06 M		235.12 K
 ncurses-libs			0:6.1-9.20180224.el8			1.25 M		317.99 K
 libgcrypt			0:1.8.5-7.el8				904.04 K	400.58 K
 libsemanage			0:2.9-8.el8				310.00 K	167.22 K
 qemu-img			15:6.2.0-5.module_el8.6.0+1087+b42c8331	8.66 M		2.14 M
 procps-ng			0:3.3.15-7.el8				1.73 M		335.05 K
 libnsl2			0:1.2.0-2.20180605git4a062cf.el8	183.15 K	56.46 K
 coreutils-single		0:8.30-13.el8				1.47 M		609.90 K
 glibc-minimal-langpack		0:2.28-208.el8				124		64.45 K
 libburn			0:1.4.8-3.el8				404.30 K	167.04 K
 libuuid			0:2.32.1-35.el8				73.13 K		98.53 K
 libffi				0:3.1-23.el8				87.61 K		37.32 K
 ca-certificates		0:2021.2.50-82.el8			936.15 K	399.50 K
 cracklib			0:2.9.6-15.el8				450.20 K	95.20 K
 filesystem			0:3.8-6.el8				215.45 K	1.14 M
 libdb-utils			0:5.3.28-42.el8_4			1.09 M		151.46 K
 libxcrypt			0:4.1.1-6.el8				188.21 K	74.94 K
 readline			0:7.0-10.el8				523.94 K	197.65 K
 sqlite-libs			0:3.26.0-15.el8				1.16 M		562.98 K
 tzdata				0:2022a-2.el8				2.18 M		485.40 K
 libutempter			0:1.1.6-14.el8				168.88 K	32.61 K
 libzstd			0:1.4.4-1.el8				621.24 K	246.07 K
 grep				0:3.1-6.el8				871.31 K	274.63 K
 libgcc				0:8.5.0-15.el8				228.30 K	75.52 K
 findutils			1:4.6.0-20.el8				1.86 M		537.62 K
 mpfr				0:3.1.6-1.el8				660.59 K	219.65 K
 rpm				0:4.14.3-23.el8				2.38 M		555.93 K
 policycoreutils		0:2.9-19.el8				1.32 M		382.58 K
 basesystem			0:11-5.el8				124		10.75 K
 rpm-plugin-selinux		0:4.14.3-23.el8				69.78 K		79.38 K
 libcap-ng			0:0.7.11-1.el8				97.04 K		33.56 K
 jansson			0:2.14-1.el8				97.26 K		48.30 K
 libnghttp2			0:1.33.0-3.el8_2.1			214.14 K	76.43 K
 sed				0:4.5-5.el8				793.54 K	301.66 K
 bzip2-libs			0:1.0.6-26.el8				77.97 K		49.31 K
 krb5-libs			0:1.18.2-21.el8				2.47 M		838.16 K
 acl				0:2.2.53-1.el8				339.09 K	82.04 K
 selinux-policy-targeted	0:3.14.3-104.el8			44.06 M		15.87 M
 libidn2			0:2.2.0-1.el8				304.65 K	95.56 K
 chkconfig			0:1.19.1-1.el8				900.22 K	201.57 K
 curl				0:7.61.1-25.el8				736.16 K	356.51 K
 centos-stream-repos		0:8-6.el8				30.21 K		20.59 K
 setup				0:2.12.2-7.el8				729.30 K	185.09 K
 libselinux-utils		0:2.9-5.el8				1.14 M		246.59 K
 libunistring			0:0.9.9-3.el8				1.84 M		420.63 K
 iproute			0:5.18.0-1.el8				3.09 M		823.60 K
 libtirpc			0:1.1.4-7.el8				283.69 K	111.68 K
 iptables-libs			0:1.8.4-22.el8				422.24 K	107.70 K
 gnutls				0:3.6.16-4.el8				3.02 M		961.79 K
 libselinux			0:2.9-5.el8				207.84 K	165.61 K
 systemd-libs			0:239-60.el8				4.62 M		1.06 M
Ignoring:										
											
Transaction Summary:									
Installing 118 Packages 								
Total download size: 63.04 M								
Total install size: 215.61 M								
+ bazel run --config=x86_64 //:bazeldnf -- prune
INFO: Analyzed target //:bazeldnf (4 packages loaded, 148 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 0.652s, Critical Path: 0.04s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO[0000] Done.                                        
+ bazel run --config=x86_64 //rpm:ldd_aarch64
INFO: Analyzed target //rpm:ldd_aarch64 (159 packages loaded, 1342 targets configured).
INFO: Found 1 target...
Target //rpm:ldd_aarch64 up-to-date:
  bazel-bin/rpm/ldd_aarch64.bash
INFO: Elapsed time: 75.449s, Critical Path: 13.73s
INFO: 178 processes: 8 internal, 170 processwrapper-sandbox.
INFO: Build completed successfully, 178 total actions
INFO: Build completed successfully, 178 total actions
INFO[0000] Done.                                        
+ rm /root/go/src/kubevirt.io/kubevirt/.bazeldnf/sandbox -rf
+ kubevirt::bootstrap::regenerate aarch64
+ kubevirt::bootstrap::sandbox_exists
+ ls /root/go/src/kubevirt.io/kubevirt/.bazeldnf/sandbox/1c65c791715e97377c36a3be1b7edd35c99dd9ef
+ echo 'Regenerating sandbox'
Regenerating sandbox
+ cd /root/go/src/kubevirt.io/kubevirt
+ rm /root/go/src/kubevirt.io/kubevirt/.bazeldnf/sandbox -rf
+ rm .bazeldnf/sandbox.bazelrc -f
+ KUBEVIRT_BOOTSTRAPPING=true
+ bazel run --config x86_64 //rpm:sandbox_aarch64
INFO: Build option --incompatible_enable_cc_toolchain_resolution has changed, discarding analysis cache.
INFO: Analyzed target //rpm:sandbox_aarch64 (32 packages loaded, 9651 targets configured).
INFO: Found 1 target...
INFO: From Converting sandboxroot_aarch64 to tar:
Flag shorthand -s has been deprecated, use --symlinks instead
Target //rpm:sandbox_aarch64 up-to-date:
  bazel-bin/rpm/sandbox_aarch64.bash
INFO: Elapsed time: 312.569s, Critical Path: 13.77s
INFO: 16 processes: 4 internal, 12 processwrapper-sandbox.
INFO: Build completed successfully, 16 total actions
INFO: Build completed successfully, 16 total actions
+ bazel clean
INFO: Starting clean (this may take a while). Consider using --async if the clean takes more than several minutes.
++ kubevirt::bootstrap::sha256
++ cd /root/go/src/kubevirt.io/kubevirt
++ sha256sum rpm/BUILD.bazel
++ head -c 40
+ local sha=62d9399d36a7dfea7bbf29e9d689a08a9286cee4
+ sed -i '/^[[:blank:]]*sandbox_hash[[:blank:]]*=/s/=.*/="62d9399d36a7dfea7bbf29e9d689a08a9286cee4"/' hack/bootstrap.sh
+ touch /root/go/src/kubevirt.io/kubevirt/.bazeldnf/sandbox/62d9399d36a7dfea7bbf29e9d689a08a9286cee4
+ kubevirt::bootstrap::sandbox_config
+ cat
```



```bash
 ⚡ root@centos9  ~/origin/kubevirt   release-0.53 ±  git diff
 ✘ ⚡ root@centos9  ~/origin/kubevirt   release-0.53 ±  git diff >a
 ⚡ root@centos9  ~/origin/kubevirt   release-0.53 ±  cat a
diff --git a/WORKSPACE b/WORKSPACE
index 21eba8055..5dc99e556 100644
--- a/WORKSPACE
+++ b/WORKSPACE
@@ -467,21 +467,15 @@ rpm(
 )
 
 rpm(
-    name = "audit-libs-0__3.0.7-3.el8.aarch64",
-    sha256 = "df094b9ea62785c1ce14222ea8a8d0602a28e4b7f3fd3940371571f28ae17a11",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/audit-libs-3.0.7-3.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/df094b9ea62785c1ce14222ea8a8d0602a28e4b7f3fd3940371571f28ae17a11",
-    ],
+    name = "audit-libs-0__3.0.7-4.el8.aarch64",
+    sha256 = "2b05f70005d024a2b540a56afd9e05729c07c9dee120ff01100a21e21781f017",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/audit-libs-3.0.7-4.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "audit-libs-0__3.0.7-3.el8.x86_64",
-    sha256 = "e1d06e220a9e4cb02bea882c776b3b8e639e82e341b6c5c207ce355a9430f429",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/audit-libs-3.0.7-3.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/e1d06e220a9e4cb02bea882c776b3b8e639e82e341b6c5c207ce355a9430f429",
-    ],
+    name = "audit-libs-0__3.0.7-4.el8.x86_64",
+    sha256 = "b37099679b46f9a15d20b7c54fdd993388a8b84105f76869494c1be17140b512",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/audit-libs-3.0.7-4.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -530,39 +524,27 @@ rpm(
 )
 
 rpm(
-    name = "bash-0__4.4.20-3.el8.aarch64",
-    sha256 = "e5cbf67dbddd24bd6f40e980a9185827c6480a30cea408733dc0b22241fd5d96",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/bash-4.4.20-3.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/e5cbf67dbddd24bd6f40e980a9185827c6480a30cea408733dc0b22241fd5d96",
-    ],
+    name = "bash-0__4.4.20-4.el8.aarch64",
+    sha256 = "cb47111790ede91e0f1fb34817a27123a97e0304e7f7b6df06731fd391859f45",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/bash-4.4.20-4.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "bash-0__4.4.20-3.el8.x86_64",
-    sha256 = "f5da563e3446ecf16a12813b885b57243cb6181a5def815bf4cafaa35a0eefc5",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/bash-4.4.20-3.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/f5da563e3446ecf16a12813b885b57243cb6181a5def815bf4cafaa35a0eefc5",
-    ],
+    name = "bash-0__4.4.20-4.el8.x86_64",
+    sha256 = "a104837b8aea5214122cf09c2de436db8f528812c1361c39f2d7471343dc509b",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/bash-4.4.20-4.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "binutils-0__2.30-113.el8.aarch64",
-    sha256 = "c4fcd3a97572a10f58a11fbe30d48736feb706dc5f4aa5645203cd5d1a85921a",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/binutils-2.30-113.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/c4fcd3a97572a10f58a11fbe30d48736feb706dc5f4aa5645203cd5d1a85921a",
-    ],
+    name = "binutils-0__2.30-117.el8.aarch64",
+    sha256 = "10cc7e5ae3939eb78ef345127f05428eb003482c91dff1506121bde6228ed55f",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/binutils-2.30-117.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "binutils-0__2.30-113.el8.x86_64",
-    sha256 = "7ea573580f796cf4ca5e8a7e1a1850dbf7249c2fcfce999f9794e7b8583407d7",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/binutils-2.30-113.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/7ea573580f796cf4ca5e8a7e1a1850dbf7249c2fcfce999f9794e7b8583407d7",
-    ],
+    name = "binutils-0__2.30-117.el8.x86_64",
+    sha256 = "d5c059ff1e586a5c7f581f916529f715b24d89bdf77e831f930306957f8870ed",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/binutils-2.30-117.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -692,39 +674,27 @@ rpm(
 )
 
 rpm(
-    name = "coreutils-single-0__8.30-12.el8.aarch64",
-    sha256 = "2a72f27d58b3e9364a872fb089322a570477fc108ceeb5d304a2b831ab6f3e23",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/coreutils-single-8.30-12.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/2a72f27d58b3e9364a872fb089322a570477fc108ceeb5d304a2b831ab6f3e23",
-    ],
+    name = "coreutils-single-0__8.30-13.el8.aarch64",
+    sha256 = "0f560179f5b79ee62e0d71efb8d67f0d8eca9b31b752064a507c1052985e1251",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/coreutils-single-8.30-13.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "coreutils-single-0__8.30-12.el8.x86_64",
-    sha256 = "2eb9c891de4f7281c7068351ffab36f93a8fa1e9d16b694c70968ed1a66a5f04",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/coreutils-single-8.30-12.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/2eb9c891de4f7281c7068351ffab36f93a8fa1e9d16b694c70968ed1a66a5f04",
-    ],
+    name = "coreutils-single-0__8.30-13.el8.x86_64",
+    sha256 = "8a8a3a45697389d029d439711c65969408ebbf4ba4d7c573d6dbe6f2b26b439d",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/coreutils-single-8.30-13.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "cpp-0__8.5.0-10.el8.aarch64",
-    sha256 = "3ec614e10d86b81e246bea2e7fdf0fc204d4509380588ac32efe47a108138c0d",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/cpp-8.5.0-10.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/3ec614e10d86b81e246bea2e7fdf0fc204d4509380588ac32efe47a108138c0d",
-    ],
+    name = "cpp-0__8.5.0-15.el8.aarch64",
+    sha256 = "36bb703e9305764b2075c56d79f98d4ff86a8a9dbcb59c2ce2a8eef37b4b98a2",
+    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/cpp-8.5.0-15.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "cpp-0__8.5.0-10.el8.x86_64",
-    sha256 = "85a491bdcbe175ca8e7d98bca8f6f7b200f8e04ad9dcbda150aa0743d3534a3b",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/cpp-8.5.0-10.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/85a491bdcbe175ca8e7d98bca8f6f7b200f8e04ad9dcbda150aa0743d3534a3b",
-    ],
+    name = "cpp-0__8.5.0-15.el8.x86_64",
+    sha256 = "1484662ef1bc1e6770c2aa8be9753e73bac8a5623c3841b6f27809c1b53989b5",
+    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/cpp-8.5.0-15.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -800,21 +770,15 @@ rpm(
 )
 
 rpm(
-    name = "curl-0__7.61.1-22.el8.aarch64",
-    sha256 = "522b718e08eb3ef7c2b9af21e84c624f503b72b533a1bc5c8f70d7d302e87e93",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/curl-7.61.1-22.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/522b718e08eb3ef7c2b9af21e84c624f503b72b533a1bc5c8f70d7d302e87e93",
-    ],
+    name = "curl-0__7.61.1-25.el8.aarch64",
+    sha256 = "56d7d77a32456f4c6b84ae4c6251d7ddfe2fb7097f9ecf8ba5e5834f7b7611c7",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/curl-7.61.1-25.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "curl-0__7.61.1-22.el8.x86_64",
-    sha256 = "3dd394e5b9403846d3068978bbe63f76b30a1d6801a7b3a93bbb3a9e64881e53",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/curl-7.61.1-22.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/3dd394e5b9403846d3068978bbe63f76b30a1d6801a7b3a93bbb3a9e64881e53",
-    ],
+    name = "curl-0__7.61.1-25.el8.x86_64",
+    sha256 = "6d5a740367b807f9cb102f9f3868ddd102c330944654a2903a016f651a6c25ed",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/curl-7.61.1-25.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -872,102 +836,69 @@ rpm(
 )
 
 rpm(
-    name = "daxctl-libs-0__71.1-3.el8.x86_64",
-    sha256 = "772d44fa92d450ce1733a27efc88b05d002662b5e29ded358ee9275ac6c2e99b",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/daxctl-libs-71.1-3.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/772d44fa92d450ce1733a27efc88b05d002662b5e29ded358ee9275ac6c2e99b",
-    ],
+    name = "daxctl-libs-0__71.1-4.el8.x86_64",
+    sha256 = "332af3c063fdb03d95632dc5010712c4e9ca7416f3049c901558c5aa0c6e445b",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/daxctl-libs-71.1-4.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "dbus-1__1.12.8-18.el8.aarch64",
-    sha256 = "aaea0456f0340129d8ca09489bc1508d1bcdd6cf9af8fedaed419f014a92b621",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/dbus-1.12.8-18.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/aaea0456f0340129d8ca09489bc1508d1bcdd6cf9af8fedaed419f014a92b621",
-    ],
+    name = "dbus-1__1.12.8-19.el8.aarch64",
+    sha256 = "17a00a6a87fb07b3ff1541e42319bfa38a281a0f74b16010ae6e41037a0bcb53",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/dbus-1.12.8-19.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "dbus-1__1.12.8-18.el8.x86_64",
-    sha256 = "4e53bf1c32bb4a2d2162fa34095e13ad6db7b61be4c4b2a260e72b9e090e50d4",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/dbus-1.12.8-18.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/4e53bf1c32bb4a2d2162fa34095e13ad6db7b61be4c4b2a260e72b9e090e50d4",
-    ],
+    name = "dbus-1__1.12.8-19.el8.x86_64",
+    sha256 = "35b04c739f1dbd507a5e01f63b0656633ee775e48b1019e30e8ef2322af6cf37",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/dbus-1.12.8-19.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "dbus-common-1__1.12.8-18.el8.aarch64",
-    sha256 = "8d707fd0fd2c7152148d7cf058f03c8ddaac6b458c77ca046fe860b0c7a83ec1",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/dbus-common-1.12.8-18.el8.noarch.rpm",
-        "https://storage.googleapis.com/builddeps/8d707fd0fd2c7152148d7cf058f03c8ddaac6b458c77ca046fe860b0c7a83ec1",
-    ],
+    name = "dbus-common-1__1.12.8-19.el8.aarch64",
+    sha256 = "aac8490975c287223e920d58276f6a08c89f92743245a7f2bf31b702b17a82a9",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/dbus-common-1.12.8-19.el8.noarch.rpm"],
 )
 
 rpm(
-    name = "dbus-common-1__1.12.8-18.el8.x86_64",
-    sha256 = "8d707fd0fd2c7152148d7cf058f03c8ddaac6b458c77ca046fe860b0c7a83ec1",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/dbus-common-1.12.8-18.el8.noarch.rpm",
-        "https://storage.googleapis.com/builddeps/8d707fd0fd2c7152148d7cf058f03c8ddaac6b458c77ca046fe860b0c7a83ec1",
-    ],
+    name = "dbus-common-1__1.12.8-19.el8.x86_64",
+    sha256 = "aac8490975c287223e920d58276f6a08c89f92743245a7f2bf31b702b17a82a9",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/dbus-common-1.12.8-19.el8.noarch.rpm"],
 )
 
 rpm(
-    name = "dbus-daemon-1__1.12.8-18.el8.aarch64",
-    sha256 = "98456fd3ab85f77190a759639ed342d11499cd695f518d551001fef381c61451",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/dbus-daemon-1.12.8-18.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/98456fd3ab85f77190a759639ed342d11499cd695f518d551001fef381c61451",
-    ],
+    name = "dbus-daemon-1__1.12.8-19.el8.aarch64",
+    sha256 = "b4d0b8eb5f65f9739109050a84feda6eea99099556dbf946d3d5be8ae801fb17",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/dbus-daemon-1.12.8-19.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "dbus-daemon-1__1.12.8-18.el8.x86_64",
-    sha256 = "ca1217252fae51339f8f30f753763332aaae528cd719484921d21130274b6fa6",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/dbus-daemon-1.12.8-18.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/ca1217252fae51339f8f30f753763332aaae528cd719484921d21130274b6fa6",
-    ],
+    name = "dbus-daemon-1__1.12.8-19.el8.x86_64",
+    sha256 = "f383727b16b942eff210082244727c647f5199eb2cc8c9c2364ace4a803b15c6",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/dbus-daemon-1.12.8-19.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "dbus-libs-1__1.12.8-18.el8.aarch64",
-    sha256 = "60a44cc0f7f0592cf43e62d4682ac9166b095031ec541de26746c421ead8f865",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/dbus-libs-1.12.8-18.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/60a44cc0f7f0592cf43e62d4682ac9166b095031ec541de26746c421ead8f865",
-    ],
+    name = "dbus-libs-1__1.12.8-19.el8.aarch64",
+    sha256 = "6e59ed0aae536a2d8af9279fb9b263bb1e60c3501acd395584b67dc2d0bf668d",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/dbus-libs-1.12.8-19.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "dbus-libs-1__1.12.8-18.el8.x86_64",
-    sha256 = "f060a852fe69fd60727d8f13054dee778f40803a6a945bf0c4da1eb4322aae0e",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/dbus-libs-1.12.8-18.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/f060a852fe69fd60727d8f13054dee778f40803a6a945bf0c4da1eb4322aae0e",
-    ],
+    name = "dbus-libs-1__1.12.8-19.el8.x86_64",
+    sha256 = "7255b772dce5cab01aea54dff4545f03938dc1c9c54ff032060aa8b47c97a81b",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/dbus-libs-1.12.8-19.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "dbus-tools-1__1.12.8-18.el8.aarch64",
-    sha256 = "eeda2f4870339df12e346fd51871f5fc68d0fdd6c8c9d54018bef86377e09bd3",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/dbus-tools-1.12.8-18.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/eeda2f4870339df12e346fd51871f5fc68d0fdd6c8c9d54018bef86377e09bd3",
-    ],
+    name = "dbus-tools-1__1.12.8-19.el8.aarch64",
+    sha256 = "90634aa2ac243dbed52d88f20a04afcf8b2298a175d8eb115fedf04fe77af21f",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/dbus-tools-1.12.8-19.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "dbus-tools-1__1.12.8-18.el8.x86_64",
-    sha256 = "e9d060063165b110317d6450e20d563b3f1f9fff3026396b19ea37cf119b9709",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/dbus-tools-1.12.8-18.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/e9d060063165b110317d6450e20d563b3f1f9fff3026396b19ea37cf119b9709",
-    ],
+    name = "dbus-tools-1__1.12.8-19.el8.x86_64",
+    sha256 = "eae77812a48ccaf3bc04bf3c5ba1a1233ffbd108122637217b3c7eba9f5c077b",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/dbus-tools-1.12.8-19.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -1025,30 +956,21 @@ rpm(
 )
 
 rpm(
-    name = "device-mapper-multipath-libs-0__0.8.4-22.el8.aarch64",
-    sha256 = "7708a81c9f31f336db959467d20b9fbe84011e272981f7ddd1d3dc6a753bae8f",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/device-mapper-multipath-libs-0.8.4-22.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/7708a81c9f31f336db959467d20b9fbe84011e272981f7ddd1d3dc6a753bae8f",
-    ],
+    name = "device-mapper-multipath-libs-0__0.8.4-26.el8.aarch64",
+    sha256 = "cca401deac042f41d5a76cdfd0ef26080848300cb98a767e5a307a3ac7cd303b",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/device-mapper-multipath-libs-0.8.4-26.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "device-mapper-multipath-libs-0__0.8.4-22.el8.x86_64",
-    sha256 = "c8bdf23638bd01c0d890a6b7bbbea006f00838489566aafb8791441f9169c90d",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/device-mapper-multipath-libs-0.8.4-22.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/c8bdf23638bd01c0d890a6b7bbbea006f00838489566aafb8791441f9169c90d",
-    ],
+    name = "device-mapper-multipath-libs-0__0.8.4-26.el8.x86_64",
+    sha256 = "4a0da6f2c4c8bee5cd3b0eb8fa8995c8ceeb93d695f4255071df5de7bd03d8a3",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/device-mapper-multipath-libs-0.8.4-26.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "device-mapper-persistent-data-0__0.9.0-6.el8.x86_64",
-    sha256 = "09d84aeab48bdc6091b30f578a4d5d88e80467aac5dc1b1ac8454e4db77a8e58",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/device-mapper-persistent-data-0.9.0-6.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/09d84aeab48bdc6091b30f578a4d5d88e80467aac5dc1b1ac8454e4db77a8e58",
-    ],
+    name = "device-mapper-persistent-data-0__0.9.0-7.el8.x86_64",
+    sha256 = "609c2bf12ce2994a0753177e334cde294a96750903c24d8583e7a0674c80485e",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/device-mapper-persistent-data-0.9.0-7.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -1079,39 +1001,27 @@ rpm(
 )
 
 rpm(
-    name = "e2fsprogs-0__1.45.6-4.el8.aarch64",
-    sha256 = "96d85610e63841ddb0d4c36f14602445a9d24bf5049cf3f428ff311cc92932d2",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/e2fsprogs-1.45.6-4.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/96d85610e63841ddb0d4c36f14602445a9d24bf5049cf3f428ff311cc92932d2",
-    ],
+    name = "e2fsprogs-0__1.45.6-5.el8.aarch64",
+    sha256 = "b916de2e7ea8fc3b0b381e0afe4353ab401b82885cea5afec0551232beb30fe2",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/e2fsprogs-1.45.6-5.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "e2fsprogs-0__1.45.6-4.el8.x86_64",
-    sha256 = "d1fa2762f56073b85bf746f4cfb584c3f28f45751d1e7d9d05dc351277ba597f",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/e2fsprogs-1.45.6-4.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/d1fa2762f56073b85bf746f4cfb584c3f28f45751d1e7d9d05dc351277ba597f",
-    ],
+    name = "e2fsprogs-0__1.45.6-5.el8.x86_64",
+    sha256 = "baa1ec089da85bf196f6e1e135727bb540f27ee7fe39d08bb17b712e59f4db8a",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/e2fsprogs-1.45.6-5.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "e2fsprogs-libs-0__1.45.6-4.el8.aarch64",
-    sha256 = "a4c9f5f88a709b5a9ffe9fe423e918abdc9406e5ff9611a5f4fc99491a9ac41e",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/e2fsprogs-libs-1.45.6-4.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/a4c9f5f88a709b5a9ffe9fe423e918abdc9406e5ff9611a5f4fc99491a9ac41e",
-    ],
+    name = "e2fsprogs-libs-0__1.45.6-5.el8.aarch64",
+    sha256 = "0ec196d820abc43432cfa52c887c880b27b63619c6785dc30daed0e091c5bb76",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/e2fsprogs-libs-1.45.6-5.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "e2fsprogs-libs-0__1.45.6-4.el8.x86_64",
-    sha256 = "170a2e73c617c6ca46e9b74b44fee82e8f304eec3266b1447ade188c4fccade4",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/e2fsprogs-libs-1.45.6-4.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/170a2e73c617c6ca46e9b74b44fee82e8f304eec3266b1447ade188c4fccade4",
-    ],
+    name = "e2fsprogs-libs-0__1.45.6-5.el8.x86_64",
+    sha256 = "035c5ed68339e632907c3f952098cdc9181ab9138239473903000e6a50446d98",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/e2fsprogs-libs-1.45.6-5.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -1133,93 +1043,63 @@ rpm(
 )
 
 rpm(
-    name = "elfutils-default-yama-scope-0__0.186-1.el8.aarch64",
-    sha256 = "69d582121cd34ab51b1557543d0beaea62bcc5e624ea1c68a2c5bb0351955314",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/elfutils-default-yama-scope-0.186-1.el8.noarch.rpm",
-        "https://storage.googleapis.com/builddeps/69d582121cd34ab51b1557543d0beaea62bcc5e624ea1c68a2c5bb0351955314",
-    ],
+    name = "elfutils-default-yama-scope-0__0.187-4.el8.aarch64",
+    sha256 = "3c89377bb7409293f0dc8ada62071fe2e3cf042ae2b5ca7cf09faf77394b5187",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/elfutils-default-yama-scope-0.187-4.el8.noarch.rpm"],
 )
 
 rpm(
-    name = "elfutils-default-yama-scope-0__0.186-1.el8.x86_64",
-    sha256 = "69d582121cd34ab51b1557543d0beaea62bcc5e624ea1c68a2c5bb0351955314",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/elfutils-default-yama-scope-0.186-1.el8.noarch.rpm",
-        "https://storage.googleapis.com/builddeps/69d582121cd34ab51b1557543d0beaea62bcc5e624ea1c68a2c5bb0351955314",
-    ],
+    name = "elfutils-default-yama-scope-0__0.187-4.el8.x86_64",
+    sha256 = "3c89377bb7409293f0dc8ada62071fe2e3cf042ae2b5ca7cf09faf77394b5187",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/elfutils-default-yama-scope-0.187-4.el8.noarch.rpm"],
 )
 
 rpm(
-    name = "elfutils-libelf-0__0.186-1.el8.aarch64",
-    sha256 = "8a9bc73377accf3b11ef38cad26a12f47c247f76994be3919c09c64211d1b207",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/elfutils-libelf-0.186-1.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/8a9bc73377accf3b11ef38cad26a12f47c247f76994be3919c09c64211d1b207",
-    ],
+    name = "elfutils-libelf-0__0.187-4.el8.aarch64",
+    sha256 = "bfdfc37f2dd1052d4067937724a6ef6a9858a9c1b3c1aacf1e9085a83e99e1b4",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/elfutils-libelf-0.187-4.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "elfutils-libelf-0__0.186-1.el8.x86_64",
-    sha256 = "4901abdc87d933d5000724e40dd0c6f196a23eaf2792b82dff33b07be740e53c",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/elfutils-libelf-0.186-1.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/4901abdc87d933d5000724e40dd0c6f196a23eaf2792b82dff33b07be740e53c",
-    ],
+    name = "elfutils-libelf-0__0.187-4.el8.x86_64",
+    sha256 = "39d8cbfb137ca9044c258b5fa2129d2a953cc180cab225e843fd46a9267ee8a3",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/elfutils-libelf-0.187-4.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "elfutils-libs-0__0.186-1.el8.aarch64",
-    sha256 = "19c4c1075d093e905f1dcc6b04f0d471d1eb9f2e959a1398e12cf80a5b548402",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/elfutils-libs-0.186-1.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/19c4c1075d093e905f1dcc6b04f0d471d1eb9f2e959a1398e12cf80a5b548402",
-    ],
+    name = "elfutils-libs-0__0.187-4.el8.aarch64",
+    sha256 = "682c1b9f11d68cdec87ea746ea0d5861f3afcf2159aa732854625bfa180bbaee",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/elfutils-libs-0.187-4.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "elfutils-libs-0__0.186-1.el8.x86_64",
-    sha256 = "a913dec09e866e860fb5d67cbcab73ae861ec44a0758ec4c0810f975dfebdfd5",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/elfutils-libs-0.186-1.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/a913dec09e866e860fb5d67cbcab73ae861ec44a0758ec4c0810f975dfebdfd5",
-    ],
+    name = "elfutils-libs-0__0.187-4.el8.x86_64",
+    sha256 = "ab96131314dbe1ed50f6a2086c0103ceb2e981e71f644ef95d3334a624723a22",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/elfutils-libs-0.187-4.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "ethtool-2__5.13-1.el8.aarch64",
-    sha256 = "c00518a0294c75119072266aaa855ad95e4e1f065a4b22f3f7f65707ee097eec",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/ethtool-5.13-1.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/c00518a0294c75119072266aaa855ad95e4e1f065a4b22f3f7f65707ee097eec",
-    ],
+    name = "ethtool-2__5.13-2.el8.aarch64",
+    sha256 = "5bdb69b9c4161ba3d4846082686ee8edce640b7c6ff0bbf1c1eae12084661c24",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/ethtool-5.13-2.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "ethtool-2__5.13-1.el8.x86_64",
-    sha256 = "9e0d3a7f05fc84bf4be7972c3614816088fd560da52e512708943808c4fee48d",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/ethtool-5.13-1.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/9e0d3a7f05fc84bf4be7972c3614816088fd560da52e512708943808c4fee48d",
-    ],
+    name = "ethtool-2__5.13-2.el8.x86_64",
+    sha256 = "f1af67b33961ddf98360e5ce855910d2dee534bffe953068f27ad96b846a2fb7",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/ethtool-5.13-2.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "expat-0__2.2.5-8.el8.aarch64",
-    sha256 = "b6e3560421c52ffaa9a734ab70bb5ceed00561242c4e3ef55619d2414cb5b14e",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/expat-2.2.5-8.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/b6e3560421c52ffaa9a734ab70bb5ceed00561242c4e3ef55619d2414cb5b14e",
-    ],
+    name = "expat-0__2.2.5-9.el8.aarch64",
+    sha256 = "4ca97fb015687a8f2ac442f581d1c42154662b4336e0f34c71be2659cb716fc8",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/expat-2.2.5-9.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "expat-0__2.2.5-8.el8.x86_64",
-    sha256 = "fc462f45be250d21f4725532894db52c84255ced89e5eaabe5e960529e53156f",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/expat-2.2.5-8.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/fc462f45be250d21f4725532894db52c84255ced89e5eaabe5e960529e53156f",
-    ],
+    name = "expat-0__2.2.5-9.el8.x86_64",
+    sha256 = "a24088d02bfc25fb2efc1cc8c92e716ead35b38c8a96e69d08a9c78a5782f0e8",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/expat-2.2.5-9.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -1277,39 +1157,27 @@ rpm(
 )
 
 rpm(
-    name = "fuse-0__2.9.7-15.el8.x86_64",
-    sha256 = "0481dacad282f75a53b5f82efa423f2ab442a083c93d7bc33bce2ebd83f0db27",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/fuse-2.9.7-15.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/0481dacad282f75a53b5f82efa423f2ab442a083c93d7bc33bce2ebd83f0db27",
-    ],
+    name = "fuse-0__2.9.7-16.el8.x86_64",
+    sha256 = "c208aa2f2f216a2172b1d9fa82bcad1b201e62f9a3101f4d52fb3de54ed28596",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/fuse-2.9.7-16.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "fuse-common-0__3.3.0-15.el8.x86_64",
-    sha256 = "16f7dd63da612abc6352e07c05aadccfbef628ecbd157b125c43b3ef41b9e187",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/fuse-common-3.3.0-15.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/16f7dd63da612abc6352e07c05aadccfbef628ecbd157b125c43b3ef41b9e187",
-    ],
+    name = "fuse-common-0__3.3.0-16.el8.x86_64",
+    sha256 = "d637dfd117080f52f1a60444b6c09aaf65a535844cacce05945d1d691b8d7043",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/fuse-common-3.3.0-16.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "fuse-libs-0__2.9.7-15.el8.aarch64",
-    sha256 = "251bc5e032c2243ef9b9efaa68f299779c3611dbada1cd467962d38e37d9dea4",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/fuse-libs-2.9.7-15.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/251bc5e032c2243ef9b9efaa68f299779c3611dbada1cd467962d38e37d9dea4",
-    ],
+    name = "fuse-libs-0__2.9.7-16.el8.aarch64",
+    sha256 = "6970abceb1e040a2a37a13faeaf2a4204c79a57d5bc8273ed276b385be813afb",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/fuse-libs-2.9.7-16.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "fuse-libs-0__2.9.7-15.el8.x86_64",
-    sha256 = "b5665a359e4bd6b27ba97ec32a4c60c866a14853e6feb604f8a3e6dffcdc6f64",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/fuse-libs-2.9.7-15.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/b5665a359e4bd6b27ba97ec32a4c60c866a14853e6feb604f8a3e6dffcdc6f64",
-    ],
+    name = "fuse-libs-0__2.9.7-16.el8.x86_64",
+    sha256 = "77fff0f92a55307b7df2334bc9cc2998c024586abd96286a251919b0509f0473",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/fuse-libs-2.9.7-16.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -1331,57 +1199,39 @@ rpm(
 )
 
 rpm(
-    name = "gcc-0__8.5.0-10.el8.aarch64",
-    sha256 = "a1406b454d5467c15f891f96bb92c5802c43da4098029fab1c0cc94490f7a6ee",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/gcc-8.5.0-10.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/a1406b454d5467c15f891f96bb92c5802c43da4098029fab1c0cc94490f7a6ee",
-    ],
+    name = "gcc-0__8.5.0-15.el8.aarch64",
+    sha256 = "347dbe82b51689eda62164b0ffdabb2dadf26f170c7430c32936d3ee87a67693",
+    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/gcc-8.5.0-15.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "gcc-0__8.5.0-10.el8.x86_64",
-    sha256 = "d9f477f9c2fcd6ed9e0e274dcd2eb9342d2f24d8cd29a782496a8542b62c12a1",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/gcc-8.5.0-10.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/d9f477f9c2fcd6ed9e0e274dcd2eb9342d2f24d8cd29a782496a8542b62c12a1",
-    ],
+    name = "gcc-0__8.5.0-15.el8.x86_64",
+    sha256 = "3ff2903895a5b75d737de8926ddfb31d01e05be07ab60b11ad168b761b14e9fc",
+    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/gcc-8.5.0-15.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "gdbm-1__1.18-1.el8.aarch64",
-    sha256 = "b7d0b4b922429354ffe7ddac90c8cd448229571b8d8e4c342110edadfe809f99",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/gdbm-1.18-1.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/b7d0b4b922429354ffe7ddac90c8cd448229571b8d8e4c342110edadfe809f99",
-    ],
+    name = "gdbm-1__1.18-2.el8.aarch64",
+    sha256 = "c032e3863180bb2247ddc0e02cd54be72099137af21452e2dc25ddd03f9a5395",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/gdbm-1.18-2.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "gdbm-1__1.18-1.el8.x86_64",
-    sha256 = "76d81e433a5291df491d2e289de9b33d4e5b98dcf48fd0a003c2767415d3e0aa",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/gdbm-1.18-1.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/76d81e433a5291df491d2e289de9b33d4e5b98dcf48fd0a003c2767415d3e0aa",
-    ],
+    name = "gdbm-1__1.18-2.el8.x86_64",
+    sha256 = "fa1751b26519b9637cf3f0a25ea1874eb2df005dde1e1371a3f13d0c9a38b9ca",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/gdbm-1.18-2.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "gdbm-libs-1__1.18-1.el8.aarch64",
-    sha256 = "a7d04ae40ad91ba0ea93e4971a35585638f6adf8dbe1ed4849f643b6b64a5871",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/gdbm-libs-1.18-1.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/a7d04ae40ad91ba0ea93e4971a35585638f6adf8dbe1ed4849f643b6b64a5871",
-    ],
+    name = "gdbm-libs-1__1.18-2.el8.aarch64",
+    sha256 = "bdb64aec2a4ea8a2c70652cd57e5f88353079042402e7662e0e89934d3737562",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/gdbm-libs-1.18-2.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "gdbm-libs-1__1.18-1.el8.x86_64",
-    sha256 = "3a3cb5a11f8e844cd1bf7c0e7bb6c12cc63e743029df50916ce7e6a9f8a4e169",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/gdbm-libs-1.18-1.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/3a3cb5a11f8e844cd1bf7c0e7bb6c12cc63e743029df50916ce7e6a9f8a4e169",
-    ],
+    name = "gdbm-libs-1__1.18-2.el8.x86_64",
+    sha256 = "eddcea96342c8cfaa60b79fc2c66cb8c5b0038c3b11855abe55e659b2cad6199",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/gdbm-libs-1.18-2.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -1421,129 +1271,87 @@ rpm(
 )
 
 rpm(
-    name = "glib2-0__2.56.4-158.el8.aarch64",
-    sha256 = "1a0d575a73b98550a79497c8bd43f78e58fd6fcb441697eb907c6d02d21762fe",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/glib2-2.56.4-158.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/1a0d575a73b98550a79497c8bd43f78e58fd6fcb441697eb907c6d02d21762fe",
-    ],
+    name = "glib2-0__2.56.4-159.el8.aarch64",
+    sha256 = "daac37a432b09faa6dd1e330c3595f6a70c53bff23a71fbce8df33c72e9fde24",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/glib2-2.56.4-159.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "glib2-0__2.56.4-158.el8.x86_64",
-    sha256 = "4543844c3ebdc85d8c0facaeb9de9e0cda324995fd62e084ffdbf238204fa529",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glib2-2.56.4-158.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/4543844c3ebdc85d8c0facaeb9de9e0cda324995fd62e084ffdbf238204fa529",
-    ],
+    name = "glib2-0__2.56.4-159.el8.x86_64",
+    sha256 = "d4b34f328efd6f144c8c1bcb61b6faa1318c367302b9f95d5db84078ca96a730",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glib2-2.56.4-159.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "glibc-0__2.28-196.el8.aarch64",
-    sha256 = "dee4f7b1f9037326a556fac3df8c75a3eb7c94588f97572b02ec7d0709419ce1",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/glibc-2.28-196.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/dee4f7b1f9037326a556fac3df8c75a3eb7c94588f97572b02ec7d0709419ce1",
-    ],
+    name = "glibc-0__2.28-208.el8.aarch64",
+    sha256 = "4e03038e95b2c9b380b2767b1f0144eeb596aff00a431e325fc3534b80a7a0a1",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/glibc-2.28-208.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "glibc-0__2.28-196.el8.x86_64",
-    sha256 = "9d4a523c7f1dc910dcfee05436913163bc20cfec2eecbc7df47cbec84eb9c13e",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glibc-2.28-196.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/9d4a523c7f1dc910dcfee05436913163bc20cfec2eecbc7df47cbec84eb9c13e",
-    ],
+    name = "glibc-0__2.28-208.el8.x86_64",
+    sha256 = "3529387a82c3eda0825471697f6ad92f8e01f3a897afcba381081f9c33af3718",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glibc-2.28-208.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "glibc-common-0__2.28-196.el8.aarch64",
-    sha256 = "f242e05a485ba75abad1f1603f9b96491cd341cfaf414f3e9c74acd7c92cba59",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/glibc-common-2.28-196.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/f242e05a485ba75abad1f1603f9b96491cd341cfaf414f3e9c74acd7c92cba59",
-    ],
+    name = "glibc-common-0__2.28-208.el8.aarch64",
+    sha256 = "f4ce83dc2efac25d1e30c1953a1876a3c5f50fc9a4a7f58a8da13ec99d40243b",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/glibc-common-2.28-208.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "glibc-common-0__2.28-196.el8.x86_64",
-    sha256 = "d62fbc7f71e45eb372dce0f3bd5eed17a289bdb799fb8c320df8815936086be4",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glibc-common-2.28-196.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/d62fbc7f71e45eb372dce0f3bd5eed17a289bdb799fb8c320df8815936086be4",
-    ],
+    name = "glibc-common-0__2.28-208.el8.x86_64",
+    sha256 = "a585f4262ccf1f3a4cad345f128e256cc8dafbf54f92096e3466dbd359ec192a",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glibc-common-2.28-208.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "glibc-devel-0__2.28-196.el8.aarch64",
-    sha256 = "476db1bc0d1a90d797fa8bd30521f35b8fe085c62b36011795b14f6c2472aabc",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/glibc-devel-2.28-196.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/476db1bc0d1a90d797fa8bd30521f35b8fe085c62b36011795b14f6c2472aabc",
-    ],
+    name = "glibc-devel-0__2.28-208.el8.aarch64",
+    sha256 = "2faa2af7573fd93eec6128f13ce1e304113a4de34966f4a2dc329f9d1997594a",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/glibc-devel-2.28-208.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "glibc-devel-0__2.28-196.el8.x86_64",
-    sha256 = "9705b7666a78a74d66cfc4f00873e1aea91f2fb22de6014e0e75f84ba4f9292e",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glibc-devel-2.28-196.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/9705b7666a78a74d66cfc4f00873e1aea91f2fb22de6014e0e75f84ba4f9292e",
-    ],
+    name = "glibc-devel-0__2.28-208.el8.x86_64",
+    sha256 = "86cd1bccb68aab0e9ae39cdb747065df4529405e7a4ae0b7e36b32d5442b372f",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glibc-devel-2.28-208.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "glibc-headers-0__2.28-196.el8.aarch64",
-    sha256 = "8a081f43089330ad60a02b2bb07c904c0ce65681ffa78f41c4ca7b5d5b31c4cc",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/glibc-headers-2.28-196.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/8a081f43089330ad60a02b2bb07c904c0ce65681ffa78f41c4ca7b5d5b31c4cc",
-    ],
+    name = "glibc-headers-0__2.28-208.el8.aarch64",
+    sha256 = "2e212bdea807cdb84d2fee6114630eb579b3f9eb4f59e655fae1c78f0ed7f593",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/glibc-headers-2.28-208.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "glibc-headers-0__2.28-196.el8.x86_64",
-    sha256 = "d1dc39c928742ac93775bac00f09a7a44ed379cb74832802f4c2a30bc0353cb2",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glibc-headers-2.28-196.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/d1dc39c928742ac93775bac00f09a7a44ed379cb74832802f4c2a30bc0353cb2",
-    ],
+    name = "glibc-headers-0__2.28-208.el8.x86_64",
+    sha256 = "e7407fbe62a15be3cb5908494abf88e2b5ca8af7ea2f43d4a95d30198db1ae91",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glibc-headers-2.28-208.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "glibc-minimal-langpack-0__2.28-196.el8.aarch64",
-    sha256 = "eaa257aa231c15ad9e80e8f4ead75e8d569d5b3e1e8a0dd25907728af5325cd6",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/glibc-minimal-langpack-2.28-196.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/eaa257aa231c15ad9e80e8f4ead75e8d569d5b3e1e8a0dd25907728af5325cd6",
-    ],
+    name = "glibc-minimal-langpack-0__2.28-208.el8.aarch64",
+    sha256 = "0f9ce08544295951b1bff828ddf1296d2608de1a0d784f83910e2205ebe8faea",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/glibc-minimal-langpack-2.28-208.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "glibc-minimal-langpack-0__2.28-196.el8.x86_64",
-    sha256 = "34422bbe4561e2af74a22258ca623e6b6b69d00db357a6343693181c0f56cc77",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glibc-minimal-langpack-2.28-196.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/34422bbe4561e2af74a22258ca623e6b6b69d00db357a6343693181c0f56cc77",
-    ],
+    name = "glibc-minimal-langpack-0__2.28-208.el8.x86_64",
+    sha256 = "ff3cecdc1a59e9ae843e9f3a4f4f195b0d75ea36b337cd403b0b2f82287f3a81",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/glibc-minimal-langpack-2.28-208.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "glibc-static-0__2.28-196.el8.aarch64",
-    sha256 = "c72c02ea55555dc782a942f2c135d6a84e2613e6caaaa68155ad23fd6c38594a",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/PowerTools/aarch64/os/Packages/glibc-static-2.28-196.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/c72c02ea55555dc782a942f2c135d6a84e2613e6caaaa68155ad23fd6c38594a",
-    ],
+    name = "glibc-static-0__2.28-208.el8.aarch64",
+    sha256 = "6ef41b3231619ef931b19fd85d39791388e144955e376443b649ec402ee7c5e6",
+    urls = ["http://mirror.centos.org/centos/8-stream/PowerTools/aarch64/os/Packages/glibc-static-2.28-208.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "glibc-static-0__2.28-196.el8.x86_64",
-    sha256 = "4efe4a0a1404f4707904c934b5128b96b8fab1303b9b4096acb4b93bdba61684",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/PowerTools/x86_64/os/Packages/glibc-static-2.28-196.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/4efe4a0a1404f4707904c934b5128b96b8fab1303b9b4096acb4b93bdba61684",
-    ],
+    name = "glibc-static-0__2.28-208.el8.x86_64",
+    sha256 = "66adbff3121d8eb58d97f145771d64abd5b31323d731d8984df7d267dba4b352",
+    urls = ["http://mirror.centos.org/centos/8-stream/PowerTools/x86_64/os/Packages/glibc-static-2.28-208.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -1655,21 +1463,15 @@ rpm(
 )
 
 rpm(
-    name = "gzip-0__1.9-12.el8.aarch64",
-    sha256 = "1fe57a2d38c0d449efd06fa3e498e49f1952829f612d657418a7496458c0cb7c",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/gzip-1.9-12.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/1fe57a2d38c0d449efd06fa3e498e49f1952829f612d657418a7496458c0cb7c",
-    ],
+    name = "gzip-0__1.9-13.el8.aarch64",
+    sha256 = "80ee79fb497c43c06d3c54bf432e6391c5ae19ae43241111f3be4113ea49fa96",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/gzip-1.9-13.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "gzip-0__1.9-12.el8.x86_64",
-    sha256 = "6d995888083240517e8eb5e0c8d8c22e63ac46de3b4bcd3c61e14959558800dd",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/gzip-1.9-12.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/6d995888083240517e8eb5e0c8d8c22e63ac46de3b4bcd3c61e14959558800dd",
-    ],
+    name = "gzip-0__1.9-13.el8.x86_64",
+    sha256 = "1cc189e4991fc6b3526f7eebc9f798b8922e70d60a12ba499b6e0329eb473cea",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/gzip-1.9-13.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -1709,39 +1511,27 @@ rpm(
 )
 
 rpm(
-    name = "iproute-0__5.15.0-4.el8.aarch64",
-    sha256 = "7c3686caf211f1116e27c1741bc75b81c6470cdd2d64ba7f0136cd50258e8596",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/iproute-5.15.0-4.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/7c3686caf211f1116e27c1741bc75b81c6470cdd2d64ba7f0136cd50258e8596",
-    ],
+    name = "iproute-0__5.18.0-1.el8.aarch64",
+    sha256 = "7ec84f47ebaed2388e48e27d9566a43609c7c384bbfbc3f0497c6bc314f618a5",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/iproute-5.18.0-1.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "iproute-0__5.15.0-4.el8.x86_64",
-    sha256 = "0c993f3ce27eb9b7bfd93890e0a0994ba5465d37c1dea6e1a42a7ea70ab21519",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/iproute-5.15.0-4.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/0c993f3ce27eb9b7bfd93890e0a0994ba5465d37c1dea6e1a42a7ea70ab21519",
-    ],
+    name = "iproute-0__5.18.0-1.el8.x86_64",
+    sha256 = "7ae4b834f060d111db19fa3cf6f6266d4c6fb56992b0347145799d7ff9f03d3c",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/iproute-5.18.0-1.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "iproute-tc-0__5.15.0-4.el8.aarch64",
-    sha256 = "fb99523c7b2c55bdf950b5171da8ac85773c4b043c56eb38e120dfcf598132d3",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/iproute-tc-5.15.0-4.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/fb99523c7b2c55bdf950b5171da8ac85773c4b043c56eb38e120dfcf598132d3",
-    ],
+    name = "iproute-tc-0__5.18.0-1.el8.aarch64",
+    sha256 = "8696d818b8ead9df0a2d66cf8e1fe03affd19899dd86e451267603faade5a161",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/iproute-tc-5.18.0-1.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "iproute-tc-0__5.15.0-4.el8.x86_64",
-    sha256 = "e2d0c2be40ab4624692aba02ca88e73b5ea9c1def3f495d2ff3b707b5c1a6678",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/iproute-tc-5.15.0-4.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/e2d0c2be40ab4624692aba02ca88e73b5ea9c1def3f495d2ff3b707b5c1a6678",
-    ],
+    name = "iproute-tc-0__5.18.0-1.el8.x86_64",
+    sha256 = "bca80255b377f2a715c1fa2023485cd8fd03f2bab2a873faa0e5879082bca1c9",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/iproute-tc-5.18.0-1.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -1799,12 +1589,9 @@ rpm(
 )
 
 rpm(
-    name = "ipxe-roms-qemu-0__20181214-8.git133f4c47.el8.x86_64",
-    sha256 = "36d152d9372177f7418c609e71b3a3b3c683a505df85d1d1c43b1730955ff024",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/ipxe-roms-qemu-20181214-8.git133f4c47.el8.noarch.rpm",
-        "https://storage.googleapis.com/builddeps/36d152d9372177f7418c609e71b3a3b3c683a505df85d1d1c43b1730955ff024",
-    ],
+    name = "ipxe-roms-qemu-0__20181214-9.git133f4c47.el8.x86_64",
+    sha256 = "73679ab2ab87aef03d9a0c0a071a4697cf3fef70e0fd3a05f1cb5b74319c70be",
+    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/ipxe-roms-qemu-20181214-9.git133f4c47.el8.noarch.rpm"],
 )
 
 rpm(
@@ -1880,21 +1667,15 @@ rpm(
 )
 
 rpm(
-    name = "kernel-headers-0__4.18.0-373.el8.aarch64",
-    sha256 = "7dab3837db18521dad358712dda851e36f471e84dd61daa737852a5c07f2f89d",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/kernel-headers-4.18.0-373.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/7dab3837db18521dad358712dda851e36f471e84dd61daa737852a5c07f2f89d",
-    ],
+    name = "kernel-headers-0__4.18.0-408.el8.aarch64",
+    sha256 = "208e7b141b8ad93ee6bd748f5c4117ed5a947b4ff48071d4fcdb826670aad76a",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/kernel-headers-4.18.0-408.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "kernel-headers-0__4.18.0-373.el8.x86_64",
-    sha256 = "11f9f0f1b84097a93ff74811c688a9b57cf28f4a5b13646b203681adc1c3b8d2",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/kernel-headers-4.18.0-373.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/11f9f0f1b84097a93ff74811c688a9b57cf28f4a5b13646b203681adc1c3b8d2",
-    ],
+    name = "kernel-headers-0__4.18.0-408.el8.x86_64",
+    sha256 = "9f8784bf9b19f7e10f404bad73adc1ab520df781760ee7f9fbbf1192d8bff0c4",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/kernel-headers-4.18.0-408.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -1952,21 +1733,15 @@ rpm(
 )
 
 rpm(
-    name = "krb5-libs-0__1.18.2-14.el8.aarch64",
-    sha256 = "965eef9e09df948fc4a7fc4628111cb4e8018dd1e3496e56970c2e1909349dc6",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/krb5-libs-1.18.2-14.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/965eef9e09df948fc4a7fc4628111cb4e8018dd1e3496e56970c2e1909349dc6",
-    ],
+    name = "krb5-libs-0__1.18.2-21.el8.aarch64",
+    sha256 = "30f23e30b9e0de1c62a6b1d9f7031f7d5b263b458ad43c43915ea41a34711a92",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/krb5-libs-1.18.2-21.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "krb5-libs-0__1.18.2-14.el8.x86_64",
-    sha256 = "898e38dba327b96336006633042ff6e138fbcafca248192ad0b43257c1d16904",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/krb5-libs-1.18.2-14.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/898e38dba327b96336006633042ff6e138fbcafca248192ad0b43257c1d16904",
-    ],
+    name = "krb5-libs-0__1.18.2-21.el8.x86_64",
+    sha256 = "b02dcbdc99f85926d6595bc3f7e24ba535b0e22ae7932e61a4ea8ab8fb4b35d9",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/krb5-libs-1.18.2-21.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -2015,30 +1790,21 @@ rpm(
 )
 
 rpm(
-    name = "libarchive-0__3.3.3-3.el8_5.aarch64",
-    sha256 = "01a00cc3d5239857ae9cbfa2005581c850a6f47e343cf523b7961d951e7df0bd",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libarchive-3.3.3-3.el8_5.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/01a00cc3d5239857ae9cbfa2005581c850a6f47e343cf523b7961d951e7df0bd",
-    ],
+    name = "libarchive-0__3.3.3-4.el8.aarch64",
+    sha256 = "0dd36d8de0c8f40cbb01d9d1fc072eebf28967302b1eed287d7ad958aa383673",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libarchive-3.3.3-4.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "libarchive-0__3.3.3-3.el8_5.x86_64",
-    sha256 = "461f8d0def774d7b3b99cdc3ad2e9b8c6216f34f3b70d38fb9af75607da6e1f3",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libarchive-3.3.3-3.el8_5.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/461f8d0def774d7b3b99cdc3ad2e9b8c6216f34f3b70d38fb9af75607da6e1f3",
-    ],
+    name = "libarchive-0__3.3.3-4.el8.x86_64",
+    sha256 = "498b81c8c4f7fb75eccf6228776f0956c0f8c958cc3c6b45c61fdbf53ae6f039",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libarchive-3.3.3-4.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "libasan-0__8.5.0-10.el8.aarch64",
-    sha256 = "472418043a744026d32844adde3b9e798f098430b4f4a88cf3d9e4285c3a1a71",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libasan-8.5.0-10.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/472418043a744026d32844adde3b9e798f098430b4f4a88cf3d9e4285c3a1a71",
-    ],
+    name = "libasan-0__8.5.0-15.el8.aarch64",
+    sha256 = "34e627e042580439b22395344a15dbfb7fe0ce7a93530217ce38134278084c60",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libasan-8.5.0-15.el8.aarch64.rpm"],
 )
 
 rpm(
@@ -2051,12 +1817,9 @@ rpm(
 )
 
 rpm(
-    name = "libatomic-0__8.5.0-10.el8.aarch64",
-    sha256 = "370b70040c3f15e4ca6a75bef0fe841c9dd419eb7100ca84cdb722a079755956",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libatomic-8.5.0-10.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/370b70040c3f15e4ca6a75bef0fe841c9dd419eb7100ca84cdb722a079755956",
-    ],
+    name = "libatomic-0__8.5.0-15.el8.aarch64",
+    sha256 = "58ea796ac4166da751068de1e250378e83b016586e08e2b2fb85d5903387f3b4",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libatomic-8.5.0-15.el8.aarch64.rpm"],
 )
 
 rpm(
@@ -2096,21 +1859,15 @@ rpm(
 )
 
 rpm(
-    name = "libbpf-0__0.4.0-3.el8.aarch64",
-    sha256 = "d1b96b4e5da6bd14ac8354c9ff70e910108313dc46fcad406e63695a956eec3e",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libbpf-0.4.0-3.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/d1b96b4e5da6bd14ac8354c9ff70e910108313dc46fcad406e63695a956eec3e",
-    ],
+    name = "libbpf-0__0.5.0-1.el8.aarch64",
+    sha256 = "1ecce335e1821b021b9fcfc8ffe1093a75f474249503510cf2bc499c61848cbb",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libbpf-0.5.0-1.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "libbpf-0__0.4.0-3.el8.x86_64",
-    sha256 = "186eb41dd1bdf2955287e36e9a20bd254e03d19d7457e1dc3c503d89b08bbb44",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libbpf-0.4.0-3.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/186eb41dd1bdf2955287e36e9a20bd254e03d19d7457e1dc3c503d89b08bbb44",
-    ],
+    name = "libbpf-0__0.5.0-1.el8.x86_64",
+    sha256 = "4d25308c27041d8a88a3340be12591e9bd46c9aebbe4195ee5d2f712d63ce033",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libbpf-0.5.0-1.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -2132,21 +1889,15 @@ rpm(
 )
 
 rpm(
-    name = "libcap-0__2.48-2.el8.aarch64",
-    sha256 = "5d2c94c1d54cfdd4fb02287e3c93be0a7ccef6ac0dc1e36a0d8782044a8d5014",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libcap-2.48-2.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/5d2c94c1d54cfdd4fb02287e3c93be0a7ccef6ac0dc1e36a0d8782044a8d5014",
-    ],
+    name = "libcap-0__2.48-4.el8.aarch64",
+    sha256 = "f1fb5fe3b85ce5016a7882ccd9640b80f8fd6fbad1c44dc02076a8cdf33fc33d",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libcap-2.48-4.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "libcap-0__2.48-2.el8.x86_64",
-    sha256 = "187b54e8368f1687f53ec15580b78f085f080690d17ee4f566967e74d257840e",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libcap-2.48-2.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/187b54e8368f1687f53ec15580b78f085f080690d17ee4f566967e74d257840e",
-    ],
+    name = "libcap-0__2.48-4.el8.x86_64",
+    sha256 = "34f69bed9ae0f5ba314a62172e8cfd9cf6795cb0c3bd29f15d174fc2a0acbb5b",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libcap-2.48-4.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -2168,21 +1919,15 @@ rpm(
 )
 
 rpm(
-    name = "libcom_err-0__1.45.6-4.el8.aarch64",
-    sha256 = "95dae7eac2c71a81db407091368965995ce27d385792589daf3a9b6ff4a440c3",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libcom_err-1.45.6-4.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/95dae7eac2c71a81db407091368965995ce27d385792589daf3a9b6ff4a440c3",
-    ],
+    name = "libcom_err-0__1.45.6-5.el8.aarch64",
+    sha256 = "bdd5ab69772a43725e1f8397e8142094bdd28b21b65ff02da74a8fc986424f3c",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libcom_err-1.45.6-5.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "libcom_err-0__1.45.6-4.el8.x86_64",
-    sha256 = "c104457cb87ec3fa38fb1b839a7c68a2167d9da69116af7e74850db00a6e5c06",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libcom_err-1.45.6-4.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/c104457cb87ec3fa38fb1b839a7c68a2167d9da69116af7e74850db00a6e5c06",
-    ],
+    name = "libcom_err-0__1.45.6-5.el8.x86_64",
+    sha256 = "4e4f13acac0477f0a121812107a9939ea2164eebab052813f1618d5b7df5d87a",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libcom_err-1.45.6-5.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -2213,21 +1958,15 @@ rpm(
 )
 
 rpm(
-    name = "libcurl-minimal-0__7.61.1-22.el8.aarch64",
-    sha256 = "175a4530f5139bd05a3ececdaeb24de882166ca541e29c1f4b9415aef787fc2f",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libcurl-minimal-7.61.1-22.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/175a4530f5139bd05a3ececdaeb24de882166ca541e29c1f4b9415aef787fc2f",
-    ],
+    name = "libcurl-minimal-0__7.61.1-25.el8.aarch64",
+    sha256 = "2852cffc539a2178e52304b24c83ded856a7da3dbc76c0f21c7db522c72b03b1",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libcurl-minimal-7.61.1-25.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "libcurl-minimal-0__7.61.1-22.el8.x86_64",
-    sha256 = "28b062f4d5d39535aa7fd20ffe2a5fbd25fa4c84782445c3d936ccc9db3dba19",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libcurl-minimal-7.61.1-22.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/28b062f4d5d39535aa7fd20ffe2a5fbd25fa4c84782445c3d936ccc9db3dba19",
-    ],
+    name = "libcurl-minimal-0__7.61.1-25.el8.x86_64",
+    sha256 = "06783b8a7201001f657e6800e4b0c646025e1963e0f806fed6f2d2e6234824b1",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libcurl-minimal-7.61.1-25.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -2339,57 +2078,39 @@ rpm(
 )
 
 rpm(
-    name = "libgcc-0__8.5.0-10.el8.aarch64",
-    sha256 = "efafc69402d1f9b195c7946e20e0c285da44ddb151f2a67e58275b228e077094",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libgcc-8.5.0-10.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/efafc69402d1f9b195c7946e20e0c285da44ddb151f2a67e58275b228e077094",
-    ],
+    name = "libgcc-0__8.5.0-15.el8.aarch64",
+    sha256 = "f62a7bd6b2ce584a9ee3561513053372db492efd867333b27f7ba9a3844ff553",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libgcc-8.5.0-15.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "libgcc-0__8.5.0-10.el8.x86_64",
-    sha256 = "8b92c47d3fee8eeb1314e96096605f46bcc2985292b9210d0e9947dbe3ab9867",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libgcc-8.5.0-10.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/8b92c47d3fee8eeb1314e96096605f46bcc2985292b9210d0e9947dbe3ab9867",
-    ],
+    name = "libgcc-0__8.5.0-15.el8.x86_64",
+    sha256 = "e020248e0906263fc12ca404974d1ae7e23357ef2f73881e7f874f57290ac4d4",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libgcc-8.5.0-15.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "libgcrypt-0__1.8.5-6.el8.aarch64",
-    sha256 = "e51932a986acc83e12f81396d532b58aacfa2b553fee84f1e62ffada1029bfd8",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libgcrypt-1.8.5-6.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/e51932a986acc83e12f81396d532b58aacfa2b553fee84f1e62ffada1029bfd8",
-    ],
+    name = "libgcrypt-0__1.8.5-7.el8.aarch64",
+    sha256 = "88a32029615cc5986884cbab1b5c137e455b9ef08b23c6219b9ec9b42079be88",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libgcrypt-1.8.5-7.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "libgcrypt-0__1.8.5-6.el8.x86_64",
-    sha256 = "f53997b3c5a858b3f2c640b1a2f2fcc1ba9f698bf12ae1b6ff5097d9095caa5e",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libgcrypt-1.8.5-6.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/f53997b3c5a858b3f2c640b1a2f2fcc1ba9f698bf12ae1b6ff5097d9095caa5e",
-    ],
+    name = "libgcrypt-0__1.8.5-7.el8.x86_64",
+    sha256 = "01541f1263532f80114111a44f797d6a8eed75744db997e85fddd021e636c5bb",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libgcrypt-1.8.5-7.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "libgomp-0__8.5.0-10.el8.aarch64",
-    sha256 = "51097c11b92a117bdfad4c9de90e6bc16437c15e024347f1ca2c44c6e18a6d70",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libgomp-8.5.0-10.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/51097c11b92a117bdfad4c9de90e6bc16437c15e024347f1ca2c44c6e18a6d70",
-    ],
+    name = "libgomp-0__8.5.0-15.el8.aarch64",
+    sha256 = "edb71029b4d451240f53399652c872035ebab3237bfa4d416e010be58bc8a056",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libgomp-8.5.0-15.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "libgomp-0__8.5.0-10.el8.x86_64",
-    sha256 = "7df9487d1f8cef4e33663656cfa20ef0963838a52f107ddf5037e83e209ceb46",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libgomp-8.5.0-10.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/7df9487d1f8cef4e33663656cfa20ef0963838a52f107ddf5037e83e209ceb46",
-    ],
+    name = "libgomp-0__8.5.0-15.el8.x86_64",
+    sha256 = "9d17f906c5d6412344615999f23fec33e4b2232bf7c1b0871f3bec12f96ce897",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libgomp-8.5.0-15.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -2645,21 +2366,15 @@ rpm(
 )
 
 rpm(
-    name = "libnl3-0__3.5.0-1.el8.aarch64",
-    sha256 = "851a9cebfb68b8c301231b1121f573311fbb165ace0f4b1a599fa42f80113df9",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libnl3-3.5.0-1.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/851a9cebfb68b8c301231b1121f573311fbb165ace0f4b1a599fa42f80113df9",
-    ],
+    name = "libnl3-0__3.7.0-1.el8.aarch64",
+    sha256 = "8c8dd63daf7ad4c6322a4316fceb256f1cfd2d8244bce515bbae539b4314a643",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libnl3-3.7.0-1.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "libnl3-0__3.5.0-1.el8.x86_64",
-    sha256 = "21c65dbf3b506a37828b13c205077f4b70fddb4b1d1c929dec01661238108059",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libnl3-3.5.0-1.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/21c65dbf3b506a37828b13c205077f4b70fddb4b1d1c929dec01661238108059",
-    ],
+    name = "libnl3-0__3.7.0-1.el8.x86_64",
+    sha256 = "9ce7aa4d7bd810448d9fb3aa85a66cca00950f7c2c59bc9721ced3e4f3ad2885",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libnl3-3.7.0-1.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -2906,21 +2621,15 @@ rpm(
 )
 
 rpm(
-    name = "libss-0__1.45.6-4.el8.aarch64",
-    sha256 = "3f3d3f55c22217d36ba97567313f408792663585fd7706a96a263d8ea15313c8",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libss-1.45.6-4.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/3f3d3f55c22217d36ba97567313f408792663585fd7706a96a263d8ea15313c8",
-    ],
+    name = "libss-0__1.45.6-5.el8.aarch64",
+    sha256 = "68b0f490ced8811f8b25423c7bd2d81b26301317e4445705c4b280283a50b8e9",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libss-1.45.6-5.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "libss-0__1.45.6-4.el8.x86_64",
-    sha256 = "3b16247cd139649b8a12897b3330d2ec22f9e6e504a4ed244c4c91a0315b48ed",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libss-1.45.6-4.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/3b16247cd139649b8a12897b3330d2ec22f9e6e504a4ed244c4c91a0315b48ed",
-    ],
+    name = "libss-0__1.45.6-5.el8.x86_64",
+    sha256 = "f489f5eaaddbdedae046e4ddfe93947cdd636533ca8d35820bf5c92ae5dd3037",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libss-1.45.6-5.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -2960,57 +2669,39 @@ rpm(
 )
 
 rpm(
-    name = "libsss_idmap-0__2.6.2-3.el8.aarch64",
-    sha256 = "c2e0c1fd4fc7bd9e94fd4c4045ff471fab2da708e7c2edf358d8e24ad802f2ac",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libsss_idmap-2.6.2-3.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/c2e0c1fd4fc7bd9e94fd4c4045ff471fab2da708e7c2edf358d8e24ad802f2ac",
-    ],
+    name = "libsss_idmap-0__2.7.3-1.el8.aarch64",
+    sha256 = "93bb0f876d19b1cfa61acceaf725cc72d35fe341ab4972a9dfd588ed3a563d2e",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libsss_idmap-2.7.3-1.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "libsss_idmap-0__2.6.2-3.el8.x86_64",
-    sha256 = "caecf3323a99f74342c702d6d0386f949656737fe431986ed4c18ab77e426a2e",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libsss_idmap-2.6.2-3.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/caecf3323a99f74342c702d6d0386f949656737fe431986ed4c18ab77e426a2e",
-    ],
+    name = "libsss_idmap-0__2.7.3-1.el8.x86_64",
+    sha256 = "c67192ac47a37c6000365e297ce779382b6d7aeea08123e4dd41ec55862cae60",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libsss_idmap-2.7.3-1.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "libsss_nss_idmap-0__2.6.2-3.el8.aarch64",
-    sha256 = "904c174cbfb67a6030795723ba36827ec1a50214039f20498c036d2fd080151b",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libsss_nss_idmap-2.6.2-3.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/904c174cbfb67a6030795723ba36827ec1a50214039f20498c036d2fd080151b",
-    ],
+    name = "libsss_nss_idmap-0__2.7.3-1.el8.aarch64",
+    sha256 = "256d5b1d23bab41df0150964b9c45892beeebb07fa8345e27ffcf92ae5a4b6d9",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libsss_nss_idmap-2.7.3-1.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "libsss_nss_idmap-0__2.6.2-3.el8.x86_64",
-    sha256 = "93489a8061898be4a1c1b6a40032d5d956d4086a6296f5a216254ff41409bffe",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libsss_nss_idmap-2.6.2-3.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/93489a8061898be4a1c1b6a40032d5d956d4086a6296f5a216254ff41409bffe",
-    ],
+    name = "libsss_nss_idmap-0__2.7.3-1.el8.x86_64",
+    sha256 = "79993021c6316be516e930ee871dab5ca672a3649e8605add1d3d620f954a7fa",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libsss_nss_idmap-2.7.3-1.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "libstdc__plus____plus__-0__8.5.0-10.el8.aarch64",
-    sha256 = "eec79512e887485aa60a55f5efed8ee84691f3464fff5467efac3b16a31cfe4b",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libstdc++-8.5.0-10.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/eec79512e887485aa60a55f5efed8ee84691f3464fff5467efac3b16a31cfe4b",
-    ],
+    name = "libstdc__plus____plus__-0__8.5.0-15.el8.aarch64",
+    sha256 = "91d6f78ddeab3c6df90479eeca76e77450605983619a54c01faaa8ede3767214",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libstdc++-8.5.0-15.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "libstdc__plus____plus__-0__8.5.0-10.el8.x86_64",
-    sha256 = "353c910c4a489cde1b2d7db91fc02e9847188600a2841c70934676a4358341e9",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libstdc++-8.5.0-10.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/353c910c4a489cde1b2d7db91fc02e9847188600a2841c70934676a4358341e9",
-    ],
+    name = "libstdc__plus____plus__-0__8.5.0-15.el8.x86_64",
+    sha256 = "298bab1223dfa678e3fc567792e14dc8329b50bbf1d93a66bd287e7005da9fb0",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libstdc++-8.5.0-15.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -3032,21 +2723,15 @@ rpm(
 )
 
 rpm(
-    name = "libtirpc-0__1.1.4-6.el8.aarch64",
-    sha256 = "34e53a718ae7b0fed25eb90780853d08dd1d2b8095545bad557e974d5e3c1498",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libtirpc-1.1.4-6.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/34e53a718ae7b0fed25eb90780853d08dd1d2b8095545bad557e974d5e3c1498",
-    ],
+    name = "libtirpc-0__1.1.4-7.el8.aarch64",
+    sha256 = "b8e1ecf3484660710fed69be5b185ad955b8458d5012a71172cd15fbb9001083",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libtirpc-1.1.4-7.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "libtirpc-0__1.1.4-6.el8.x86_64",
-    sha256 = "aebbff9c7bce81a83874da0d90529a6cdb4db841790165c510c1260abeb382d4",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libtirpc-1.1.4-6.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/aebbff9c7bce81a83874da0d90529a6cdb4db841790165c510c1260abeb382d4",
-    ],
+    name = "libtirpc-0__1.1.4-7.el8.x86_64",
+    sha256 = "fe4dd02764dbb5a0369abaed181b2382e941b055e82485d9c5b2b8eca3cd2bda",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libtirpc-1.1.4-7.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -3068,12 +2753,9 @@ rpm(
 )
 
 rpm(
-    name = "libubsan-0__8.5.0-10.el8.aarch64",
-    sha256 = "27a453616cae4817ab7ed53182de132ba100dcfbfdc1a2cd46751d0b37516b1f",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libubsan-8.5.0-10.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/27a453616cae4817ab7ed53182de132ba100dcfbfdc1a2cd46751d0b37516b1f",
-    ],
+    name = "libubsan-0__8.5.0-15.el8.aarch64",
+    sha256 = "f17b6540d94e217baf503abe38e9ff08132872c7d35c15048e8891fe0cefedb1",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libubsan-8.5.0-15.el8.aarch64.rpm"],
 )
 
 rpm(
@@ -3149,21 +2831,15 @@ rpm(
 )
 
 rpm(
-    name = "libverto-0__0.3.0-5.el8.aarch64",
-    sha256 = "446f45706d78e80d4057d9d55dda32ce1cb823b2ca4dfe50f0ca5b515238130d",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libverto-0.3.0-5.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/446f45706d78e80d4057d9d55dda32ce1cb823b2ca4dfe50f0ca5b515238130d",
-    ],
+    name = "libverto-0__0.3.2-2.el8.aarch64",
+    sha256 = "1a8478fe342782d95f29253a2845bdb3e88ced25b5e6b029cecc52a43df1932b",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libverto-0.3.2-2.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "libverto-0__0.3.0-5.el8.x86_64",
-    sha256 = "f95f673fc9236dc712270a343807cdac06297d847001e78cd707482c751b2d0d",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libverto-0.3.0-5.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/f95f673fc9236dc712270a343807cdac06297d847001e78cd707482c751b2d0d",
-    ],
+    name = "libverto-0__0.3.2-2.el8.x86_64",
+    sha256 = "96b8ea32c5e9b3275788525ecbf35fd6ac1ae137754a2857503776512d4db58a",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libverto-0.3.2-2.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -3329,21 +3005,15 @@ rpm(
 )
 
 rpm(
-    name = "libxml2-0__2.9.7-13.el8.aarch64",
-    sha256 = "d16391b31f95c9ce5a6d90bbf2739b00af4cfa6e6cd530afb0e00645d19d2490",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libxml2-2.9.7-13.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/d16391b31f95c9ce5a6d90bbf2739b00af4cfa6e6cd530afb0e00645d19d2490",
-    ],
+    name = "libxml2-0__2.9.7-14.el8.aarch64",
+    sha256 = "e9cfed7ab4e4fbce2d0e170b80c1cb3ebf199386350e12a851b2ced13b3b0cc1",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/libxml2-2.9.7-14.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "libxml2-0__2.9.7-13.el8.x86_64",
-    sha256 = "9fc2d5878e949d73ee91c7bb26c52204c9e8c749f3eabd96507629db1c155650",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libxml2-2.9.7-13.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/9fc2d5878e949d73ee91c7bb26c52204c9e8c749f3eabd96507629db1c155650",
-    ],
+    name = "libxml2-0__2.9.7-14.el8.x86_64",
+    sha256 = "029ee51b73e2c8396ff5481979f79f8ee50489b26592c864b84c07779fa175e3",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/libxml2-2.9.7-14.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -3454,6 +3124,18 @@ rpm(
     ],
 )
 
+rpm(
+    name = "mozjs60-0__60.9.0-4.el8.aarch64",
+    sha256 = "8a1da341e022af37e9861bb2e8f2b045ad0b36cd783547c0dee08b8097e73c80",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/mozjs60-60.9.0-4.el8.aarch64.rpm"],
+)
+
+rpm(
+    name = "mozjs60-0__60.9.0-4.el8.x86_64",
+    sha256 = "03b50a4ea5cf5655c67e2358fabb6e563eec4e7929e7fc6c4e92c92694f60fa0",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/mozjs60-60.9.0-4.el8.x86_64.rpm"],
+)
+
 rpm(
     name = "mpfr-0__3.1.6-1.el8.aarch64",
     sha256 = "97a998a1b93c21bf070f9a9a1dbb525234b00fccedfe67de8967cd9ec7132eb1",
@@ -3518,12 +3200,9 @@ rpm(
 )
 
 rpm(
-    name = "ndctl-libs-0__71.1-3.el8.x86_64",
-    sha256 = "a2d43111debbe48a2e2cd85a6df94cd861abe24ac4d2da3058e9946252909f43",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/ndctl-libs-71.1-3.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/a2d43111debbe48a2e2cd85a6df94cd861abe24ac4d2da3058e9946252909f43",
-    ],
+    name = "ndctl-libs-0__71.1-4.el8.x86_64",
+    sha256 = "d1518d8f29a72c8c9501f67929258405cf25fd4be365fd905acc57b846d49c8a",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/ndctl-libs-71.1-4.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -3545,39 +3224,27 @@ rpm(
 )
 
 rpm(
-    name = "nftables-1__0.9.3-25.el8.aarch64",
-    sha256 = "d32533e4808558a2ab59c4a7c1509c1416eea58f7156e071dda1c4713d66d2c9",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/nftables-0.9.3-25.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/d32533e4808558a2ab59c4a7c1509c1416eea58f7156e071dda1c4713d66d2c9",
-    ],
+    name = "nftables-1__0.9.3-26.el8.aarch64",
+    sha256 = "22cacdb52fb6a31659789b5190f8e6db27ca1dddd9b67f3c6b2c1db917ef882f",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/nftables-0.9.3-26.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "nftables-1__0.9.3-25.el8.x86_64",
-    sha256 = "a51f6f6a29df621eb4ef227912918598604871aa7e09c456088810d61f1e10c5",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/nftables-0.9.3-25.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/a51f6f6a29df621eb4ef227912918598604871aa7e09c456088810d61f1e10c5",
-    ],
+    name = "nftables-1__0.9.3-26.el8.x86_64",
+    sha256 = "813d7c361e77b394f6f05fb29983c3ee6c2dd2e8fe8b857e2bdb6b9914e0c129",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/nftables-0.9.3-26.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "nmap-ncat-2__7.70-6.el8.aarch64",
-    sha256 = "541ddb604ddf8405ae552528ec05ac559f963fe5628de2b11354cbc8d7ce1ed0",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/nmap-ncat-7.70-6.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/541ddb604ddf8405ae552528ec05ac559f963fe5628de2b11354cbc8d7ce1ed0",
-    ],
+    name = "nmap-ncat-2__7.70-7.el8.aarch64",
+    sha256 = "a1da5a886825ef4cb2342db821cf1da3133860a99fd436b113affbd0e8dd9f81",
+    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/nmap-ncat-7.70-7.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "nmap-ncat-2__7.70-6.el8.x86_64",
-    sha256 = "1397e8c7ef1a7b3680cd8119b1e231db1a5ee0a5202e6e557f2e9082a92761ca",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/nmap-ncat-7.70-6.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/1397e8c7ef1a7b3680cd8119b1e231db1a5ee0a5202e6e557f2e9082a92761ca",
-    ],
+    name = "nmap-ncat-2__7.70-7.el8.x86_64",
+    sha256 = "e782a31f7f62d0a92188190970e6d8b9df56c8bd79fd7c84b527bd2e3689ea22",
+    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/nmap-ncat-7.70-7.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -3698,21 +3365,15 @@ rpm(
 )
 
 rpm(
-    name = "pam-0__1.3.1-16.el8.aarch64",
-    sha256 = "e40de16b3a574426a6220e81e4bc522a06e2093d7b742c39bf2bca745eff5d96",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/pam-1.3.1-16.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/e40de16b3a574426a6220e81e4bc522a06e2093d7b742c39bf2bca745eff5d96",
-    ],
+    name = "pam-0__1.3.1-22.el8.aarch64",
+    sha256 = "b900edf1f702460be4a6b2e402e02887068fe9172b88256660b8c20b89a772d5",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/pam-1.3.1-22.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "pam-0__1.3.1-16.el8.x86_64",
-    sha256 = "b38d198bb4a224f7c79b1e66a1576998bea774f7266349c5178eb0c086da1722",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/pam-1.3.1-16.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/b38d198bb4a224f7c79b1e66a1576998bea774f7266349c5178eb0c086da1722",
-    ],
+    name = "pam-0__1.3.1-22.el8.x86_64",
+    sha256 = "435bf0de1d95994530d596a93905394d066b8f0df0da360edce7dbe466ab3101",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/pam-1.3.1-22.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -3734,21 +3395,15 @@ rpm(
 )
 
 rpm(
-    name = "pcre2-0__10.32-2.el8.aarch64",
-    sha256 = "3a386eca4550def1fef05213ddc8fe082e589a2fe2898f634265fbe8fe828296",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/pcre2-10.32-2.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/3a386eca4550def1fef05213ddc8fe082e589a2fe2898f634265fbe8fe828296",
-    ],
+    name = "pcre2-0__10.32-3.el8.aarch64",
+    sha256 = "b8e4367f28a53ec70a6b8a329a5bda886374eddde5f55c9467e1783d4158b5d1",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/pcre2-10.32-3.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "pcre2-0__10.32-2.el8.x86_64",
-    sha256 = "fb29d2bd46a98affd617bbb243bb117ebbb3d074a6455036abb2aa5b507cce62",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/pcre2-10.32-2.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/fb29d2bd46a98affd617bbb243bb117ebbb3d074a6455036abb2aa5b507cce62",
-    ],
+    name = "pcre2-0__10.32-3.el8.x86_64",
+    sha256 = "2f865747024d26b91d5a9f2f35dd1b04e1039d64e772d0371b437145cd7beceb",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/pcre2-10.32-3.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -4139,21 +3794,15 @@ rpm(
 )
 
 rpm(
-    name = "platform-python-0__3.6.8-46.el8.aarch64",
-    sha256 = "ba6b0bd85835dec5b836379d6bc08cb6463740bc6fb219783c1959a1609abc96",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/platform-python-3.6.8-46.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/ba6b0bd85835dec5b836379d6bc08cb6463740bc6fb219783c1959a1609abc96",
-    ],
+    name = "platform-python-0__3.6.8-47.el8.aarch64",
+    sha256 = "43ffa547514ccad75bc69b6fdc402cc133234b33da4a62ddacc3c51ebf738fd0",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/platform-python-3.6.8-47.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "platform-python-0__3.6.8-46.el8.x86_64",
-    sha256 = "4e4d9887c993b14fc89debcef1b1d4cc84a10cd3209f80e1e2f1746630d3b0a0",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/platform-python-3.6.8-46.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/4e4d9887c993b14fc89debcef1b1d4cc84a10cd3209f80e1e2f1746630d3b0a0",
-    ],
+    name = "platform-python-0__3.6.8-47.el8.x86_64",
+    sha256 = "ead951c74984ba09c297c7286533b4b4ce2fcc18fa60102c760016e761a85a73",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/platform-python-3.6.8-47.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -4211,39 +3860,27 @@ rpm(
 )
 
 rpm(
-    name = "polkit-0__0.115-13.el8_5.1.aarch64",
-    sha256 = "aabd3fa1c44fec3a95d5a9fe4b880a84a42a47723f440102ec098dc119e3f41e",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/polkit-0.115-13.el8_5.1.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/aabd3fa1c44fec3a95d5a9fe4b880a84a42a47723f440102ec098dc119e3f41e",
-    ],
+    name = "polkit-0__0.115-13.0.1.el8.2.aarch64",
+    sha256 = "eef4d3b177ff36c7f1781fcb456bef44169484a29f5931f268486f15933e4b24",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/polkit-0.115-13.0.1.el8.2.aarch64.rpm"],
 )
 
 rpm(
-    name = "polkit-0__0.115-13.el8_5.1.x86_64",
-    sha256 = "cd873179894c7fc92ca30493f11bc00ca3505111bba32be0c54f0d4a49d5100d",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/polkit-0.115-13.el8_5.1.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/cd873179894c7fc92ca30493f11bc00ca3505111bba32be0c54f0d4a49d5100d",
-    ],
+    name = "polkit-0__0.115-13.0.1.el8.2.x86_64",
+    sha256 = "8bfccf9235747eb132c1d10c2f26b5544a0db078019eb7911b88522131e16dc8",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/polkit-0.115-13.0.1.el8.2.x86_64.rpm"],
 )
 
 rpm(
-    name = "polkit-libs-0__0.115-13.el8_5.1.aarch64",
-    sha256 = "2ffe101b6f52d38686ce9ec5ed61f5952f7a9191c601c7617292cc717bbc497d",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/polkit-libs-0.115-13.el8_5.1.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/2ffe101b6f52d38686ce9ec5ed61f5952f7a9191c601c7617292cc717bbc497d",
-    ],
+    name = "polkit-libs-0__0.115-13.0.1.el8.2.aarch64",
+    sha256 = "dc74d77dfeb155b2708820c9a1d5cbb2c4c29de2c3a1cb76d0987e6bbbf40c9a",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/polkit-libs-0.115-13.0.1.el8.2.aarch64.rpm"],
 )
 
 rpm(
-    name = "polkit-libs-0__0.115-13.el8_5.1.x86_64",
-    sha256 = "5ad7045e373ec2bf1b32f287fd62019f6a319b79da71da789b83e376f8ba92f6",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/polkit-libs-0.115-13.el8_5.1.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/5ad7045e373ec2bf1b32f287fd62019f6a319b79da71da789b83e376f8ba92f6",
-    ],
+    name = "polkit-libs-0__0.115-13.0.1.el8.2.x86_64",
+    sha256 = "d957da6b452f7b15830ad9a73176d4f04d9c3e26e119b7f3f4f4060087bb9082",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/polkit-libs-0.115-13.0.1.el8.2.x86_64.rpm"],
 )
 
 rpm(
@@ -4319,21 +3956,15 @@ rpm(
 )
 
 rpm(
-    name = "python3-libs-0__3.6.8-46.el8.aarch64",
-    sha256 = "f6f0d7ae6da1c5aaff569343d1ed847145771a5ad79597263580080c7d9f68d7",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/python3-libs-3.6.8-46.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/f6f0d7ae6da1c5aaff569343d1ed847145771a5ad79597263580080c7d9f68d7",
-    ],
+    name = "python3-libs-0__3.6.8-47.el8.aarch64",
+    sha256 = "1ec95b8b8d4e226558d193bd46d3e928c143e41e5c0403a8868f872f7a7d2ad1",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/python3-libs-3.6.8-47.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "python3-libs-0__3.6.8-46.el8.x86_64",
-    sha256 = "17f436a19acbd6c1341e0541eb70e67bfe02dd0e27f6ec347820b20e7b6a99ed",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/python3-libs-3.6.8-46.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/17f436a19acbd6c1341e0541eb70e67bfe02dd0e27f6ec347820b20e7b6a99ed",
-    ],
+    name = "python3-libs-0__3.6.8-47.el8.x86_64",
+    sha256 = "279a02854cd438f33d624c86cfa2b3c266f04eda7cb8a81d1d70970f8c6c90fa",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/python3-libs-3.6.8-47.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -4508,57 +4139,39 @@ rpm(
 )
 
 rpm(
-    name = "rpm-0__4.14.3-22.el8.aarch64",
-    sha256 = "f6041be8308c9c08aa22457e80faee8a59b0102af9cad5eff204cab34556a8a9",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/rpm-4.14.3-22.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/f6041be8308c9c08aa22457e80faee8a59b0102af9cad5eff204cab34556a8a9",
-    ],
+    name = "rpm-0__4.14.3-23.el8.aarch64",
+    sha256 = "d803f082920abc401f44b7220ce96f6f2b070b06dcfe6b5c34573b8c7bcc5267",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/rpm-4.14.3-23.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "rpm-0__4.14.3-22.el8.x86_64",
-    sha256 = "ec3fa04c94fc6184b6294368d474986f0374c7b6071ccb6ef77e47b1739ad028",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/rpm-4.14.3-22.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/ec3fa04c94fc6184b6294368d474986f0374c7b6071ccb6ef77e47b1739ad028",
-    ],
+    name = "rpm-0__4.14.3-23.el8.x86_64",
+    sha256 = "4fa7a471aeba9b03daad1306a727fa12edb4b633f96a3da627495b24d6a4f185",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/rpm-4.14.3-23.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "rpm-libs-0__4.14.3-22.el8.aarch64",
-    sha256 = "d074e25a5ad66fa0fb4643e09f233f3c9f0a39c82543c9a1e46d86a12bc65b70",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/rpm-libs-4.14.3-22.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/d074e25a5ad66fa0fb4643e09f233f3c9f0a39c82543c9a1e46d86a12bc65b70",
-    ],
+    name = "rpm-libs-0__4.14.3-23.el8.aarch64",
+    sha256 = "26fdda368fc8c50c774cebd9ddf4786ced58d8ee9b12e5ce57113205d147f0a1",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/rpm-libs-4.14.3-23.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "rpm-libs-0__4.14.3-22.el8.x86_64",
-    sha256 = "3c8dc8955bbca23b89a3a6e4b9e3d52e36cf6939be1539b9dd0c88b1fac96b17",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/rpm-libs-4.14.3-22.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/3c8dc8955bbca23b89a3a6e4b9e3d52e36cf6939be1539b9dd0c88b1fac96b17",
-    ],
+    name = "rpm-libs-0__4.14.3-23.el8.x86_64",
+    sha256 = "59cdcaac989655b450a369c41282b2dc312a1e5b24f5be0233d15035a3682400",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/rpm-libs-4.14.3-23.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "rpm-plugin-selinux-0__4.14.3-22.el8.aarch64",
-    sha256 = "3ece997a5a9be644cc0cc771cbbf5977d1e21cac6f0b4dc8c954da318c8d7757",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/rpm-plugin-selinux-4.14.3-22.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/3ece997a5a9be644cc0cc771cbbf5977d1e21cac6f0b4dc8c954da318c8d7757",
-    ],
+    name = "rpm-plugin-selinux-0__4.14.3-23.el8.aarch64",
+    sha256 = "66c8e46bde5c784c083c7e674f72edb493394c9dedf59e7b40600968f083ca5c",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/rpm-plugin-selinux-4.14.3-23.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "rpm-plugin-selinux-0__4.14.3-22.el8.x86_64",
-    sha256 = "4219822d511660432cb3dafd532b5a2e63f106e68115f1b15693dca62cdea0ab",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/rpm-plugin-selinux-4.14.3-22.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/4219822d511660432cb3dafd532b5a2e63f106e68115f1b15693dca62cdea0ab",
-    ],
+    name = "rpm-plugin-selinux-0__4.14.3-23.el8.x86_64",
+    sha256 = "2f55d15cb498f2613ebaf6a59bc0303579ae5b80f6edfc3c0c226125b2d2ca30",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/rpm-plugin-selinux-4.14.3-23.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -4607,57 +4220,39 @@ rpm(
 )
 
 rpm(
-    name = "selinux-policy-0__3.14.3-95.el8.aarch64",
-    sha256 = "de590d28c13c0110f3722f143087d4d9b96ac44e589e7d1294c001b4f1526cf7",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/selinux-policy-3.14.3-95.el8.noarch.rpm",
-        "https://storage.googleapis.com/builddeps/de590d28c13c0110f3722f143087d4d9b96ac44e589e7d1294c001b4f1526cf7",
-    ],
+    name = "selinux-policy-0__3.14.3-104.el8.aarch64",
+    sha256 = "db43f71c5f7b1b23a64c00377fbf83e9d32d408175a85617bcc45004f3a49fe6",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/selinux-policy-3.14.3-104.el8.noarch.rpm"],
 )
 
 rpm(
-    name = "selinux-policy-0__3.14.3-95.el8.x86_64",
-    sha256 = "de590d28c13c0110f3722f143087d4d9b96ac44e589e7d1294c001b4f1526cf7",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/selinux-policy-3.14.3-95.el8.noarch.rpm",
-        "https://storage.googleapis.com/builddeps/de590d28c13c0110f3722f143087d4d9b96ac44e589e7d1294c001b4f1526cf7",
-    ],
+    name = "selinux-policy-0__3.14.3-104.el8.x86_64",
+    sha256 = "db43f71c5f7b1b23a64c00377fbf83e9d32d408175a85617bcc45004f3a49fe6",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/selinux-policy-3.14.3-104.el8.noarch.rpm"],
 )
 
 rpm(
-    name = "selinux-policy-targeted-0__3.14.3-95.el8.aarch64",
-    sha256 = "da53ecdc4c7919d7ba8b65d66b0ef5be780bc43a64932b2b249bf7f7951fdbae",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/selinux-policy-targeted-3.14.3-95.el8.noarch.rpm",
-        "https://storage.googleapis.com/builddeps/da53ecdc4c7919d7ba8b65d66b0ef5be780bc43a64932b2b249bf7f7951fdbae",
-    ],
+    name = "selinux-policy-targeted-0__3.14.3-104.el8.aarch64",
+    sha256 = "8db38c49ae25ad49ef8b1cd7c7bbc28bcaaee9983c311d6fdfe841c6e1a05518",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/selinux-policy-targeted-3.14.3-104.el8.noarch.rpm"],
 )
 
 rpm(
-    name = "selinux-policy-targeted-0__3.14.3-95.el8.x86_64",
-    sha256 = "da53ecdc4c7919d7ba8b65d66b0ef5be780bc43a64932b2b249bf7f7951fdbae",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/selinux-policy-targeted-3.14.3-95.el8.noarch.rpm",
-        "https://storage.googleapis.com/builddeps/da53ecdc4c7919d7ba8b65d66b0ef5be780bc43a64932b2b249bf7f7951fdbae",
-    ],
+    name = "selinux-policy-targeted-0__3.14.3-104.el8.x86_64",
+    sha256 = "8db38c49ae25ad49ef8b1cd7c7bbc28bcaaee9983c311d6fdfe841c6e1a05518",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/selinux-policy-targeted-3.14.3-104.el8.noarch.rpm"],
 )
 
 rpm(
-    name = "setup-0__2.12.2-6.el8.aarch64",
-    sha256 = "9e540fe1fcf866ba1e738e012eef5459d34cca30385df73973e6fc7c6eadb55f",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/setup-2.12.2-6.el8.noarch.rpm",
-        "https://storage.googleapis.com/builddeps/9e540fe1fcf866ba1e738e012eef5459d34cca30385df73973e6fc7c6eadb55f",
-    ],
+    name = "setup-0__2.12.2-7.el8.aarch64",
+    sha256 = "0e5bdfebabb44848a9f37d2cc02a8a6a099b1c4c1644f4940718e55ce5b95464",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/setup-2.12.2-7.el8.noarch.rpm"],
 )
 
 rpm(
-    name = "setup-0__2.12.2-6.el8.x86_64",
-    sha256 = "9e540fe1fcf866ba1e738e012eef5459d34cca30385df73973e6fc7c6eadb55f",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/setup-2.12.2-6.el8.noarch.rpm",
-        "https://storage.googleapis.com/builddeps/9e540fe1fcf866ba1e738e012eef5459d34cca30385df73973e6fc7c6eadb55f",
-    ],
+    name = "setup-0__2.12.2-7.el8.x86_64",
+    sha256 = "0e5bdfebabb44848a9f37d2cc02a8a6a099b1c4c1644f4940718e55ce5b95464",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/setup-2.12.2-7.el8.noarch.rpm"],
 )
 
 rpm(
@@ -4724,21 +4319,15 @@ rpm(
 )
 
 rpm(
-    name = "sssd-client-0__2.6.2-3.el8.aarch64",
-    sha256 = "564d76d558e20a9a025eec9961a9197a724ca417c7b3ecd6b3286dd6264bb450",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/sssd-client-2.6.2-3.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/564d76d558e20a9a025eec9961a9197a724ca417c7b3ecd6b3286dd6264bb450",
-    ],
+    name = "sssd-client-0__2.7.3-1.el8.aarch64",
+    sha256 = "e7815948862ecfbcaddd3a0dfcaa4bd72c1a7124e917aa1f55ce235ae3feaa32",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/sssd-client-2.7.3-1.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "sssd-client-0__2.6.2-3.el8.x86_64",
-    sha256 = "62fdb1d51af61221578d8b15de17aef54121f450f09d3c7490b0a16d3655e69d",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/sssd-client-2.6.2-3.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/62fdb1d51af61221578d8b15de17aef54121f450f09d3c7490b0a16d3655e69d",
-    ],
+    name = "sssd-client-0__2.7.3-1.el8.x86_64",
+    sha256 = "0916816b030d37b71689b92da9e13856bab7fb6db0846c8fd2ddb7b712d1951c",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/sssd-client-2.7.3-1.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -4796,129 +4385,99 @@ rpm(
 )
 
 rpm(
-    name = "systemd-0__239-58.el8.aarch64",
-    sha256 = "d3388e47444ce1e624930ea6c1e2aef04c7571045ac459d0ee317163c20d6cbe",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/systemd-239-58.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/d3388e47444ce1e624930ea6c1e2aef04c7571045ac459d0ee317163c20d6cbe",
-    ],
+    name = "systemd-0__239-60.el8.aarch64",
+    sha256 = "f75c419f46870e9759675a8a8cceec02794c72eaa1bc28ca51c7fc518157a021",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/systemd-239-60.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "systemd-0__239-58.el8.x86_64",
-    sha256 = "0a373ef0d76dc8cfa755ebd390f9897e563970e840de337248f61840731d42cc",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/systemd-239-58.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/0a373ef0d76dc8cfa755ebd390f9897e563970e840de337248f61840731d42cc",
-    ],
+    name = "systemd-0__239-60.el8.x86_64",
+    sha256 = "4284bc7c2225148ec296662363d6cab58717d4cf614e66e093ee7a39ab721f8e",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/systemd-239-60.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "systemd-container-0__239-58.el8.aarch64",
-    sha256 = "f878467aa636e18793bf88aa2522896c1cc2c673102aed5a5f1c064d9c4c0dbd",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/systemd-container-239-58.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/f878467aa636e18793bf88aa2522896c1cc2c673102aed5a5f1c064d9c4c0dbd",
-    ],
+    name = "systemd-container-0__239-60.el8.aarch64",
+    sha256 = "45d5a32fcfe9ce5e16542763ba5915d99408a43af3ac09e77d03f4987944f1e0",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/systemd-container-239-60.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "systemd-container-0__239-58.el8.x86_64",
-    sha256 = "6ad9bf6369f0f7df0331440f900f1e5ce2f302ef3619240375144a030e49e2d2",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/systemd-container-239-58.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/6ad9bf6369f0f7df0331440f900f1e5ce2f302ef3619240375144a030e49e2d2",
-    ],
+    name = "systemd-container-0__239-60.el8.x86_64",
+    sha256 = "e8742b0cee3cb54e9ee51050bef9425c9be5dbcb60529b1e278499f50fc6a2d3",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/systemd-container-239-60.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "systemd-libs-0__239-58.el8.aarch64",
-    sha256 = "2e016e9b5cd5f61142f48c834e792e93ef6cbee3c1f4865a361ceeac9f53bf63",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/systemd-libs-239-58.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/2e016e9b5cd5f61142f48c834e792e93ef6cbee3c1f4865a361ceeac9f53bf63",
-    ],
+    name = "systemd-libs-0__239-60.el8.aarch64",
+    sha256 = "3deddfb8091d8e9f4c3b1f315857d965ea8c05e18429605072fa96fa65152a6c",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/systemd-libs-239-60.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "systemd-libs-0__239-58.el8.x86_64",
-    sha256 = "a48d2d7b308723d997d69397dc26cdc552caa2dc1a368a5c079827d2ee17ee2c",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/systemd-libs-239-58.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/a48d2d7b308723d997d69397dc26cdc552caa2dc1a368a5c079827d2ee17ee2c",
-    ],
+    name = "systemd-libs-0__239-60.el8.x86_64",
+    sha256 = "8fa4f5566b768901b9eaadf07d0153cc5ffe6c06eaa9558173841b082ee2be67",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/systemd-libs-239-60.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "systemd-pam-0__239-58.el8.aarch64",
-    sha256 = "8f46c794df6d67ec5e70c7e7bd38e58018601305497a7bc3e450f2253b04b3dd",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/systemd-pam-239-58.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/8f46c794df6d67ec5e70c7e7bd38e58018601305497a7bc3e450f2253b04b3dd",
-    ],
+    name = "systemd-pam-0__239-60.el8.aarch64",
+    sha256 = "a16e866dccf819f255684124bc66a1d15ee677b1981d2b99e38212999184d9d5",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/systemd-pam-239-60.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "systemd-pam-0__239-58.el8.x86_64",
-    sha256 = "32c0f886890f175632aae1fd16a88346362de8fe6d7c3d8b55f74edaa05caf0c",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/systemd-pam-239-58.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/32c0f886890f175632aae1fd16a88346362de8fe6d7c3d8b55f74edaa05caf0c",
-    ],
+    name = "systemd-pam-0__239-60.el8.x86_64",
+    sha256 = "88966e7d4fe4f3865517acf0c3f4b5b605bd592f28e07302813f87fa8fea5060",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/systemd-pam-239-60.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "tar-2__1.30-5.el8.aarch64",
-    sha256 = "3d527d861793fe3a74b6254540068e8b846e6df20d75754df39904e67f1e569f",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/tar-1.30-5.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/3d527d861793fe3a74b6254540068e8b846e6df20d75754df39904e67f1e569f",
-    ],
+    name = "tar-2__1.30-6.el8.aarch64",
+    sha256 = "ef568db2a1acf8da0aa45c2378fd517150d3c878b025c0c5e030471ddb548772",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/tar-1.30-6.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "tar-2__1.30-5.el8.x86_64",
-    sha256 = "ed1f7ab0225df75734034cb2aea426c48c089f2bd476ec66b66af879437c5393",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/tar-1.30-5.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/ed1f7ab0225df75734034cb2aea426c48c089f2bd476ec66b66af879437c5393",
-    ],
+    name = "tar-2__1.30-6.el8.x86_64",
+    sha256 = "3c58fd72932efeccda39578fd55a37d9544a1f64c0ffeebad1c2741fba55fda2",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/tar-1.30-6.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "tzdata-0__2022a-1.el8.aarch64",
-    sha256 = "34f9baf88eab928ac48f98b5786c640f535b58ff5e25cffa19904e2a419dcc26",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/tzdata-2022a-1.el8.noarch.rpm",
-        "https://storage.googleapis.com/builddeps/34f9baf88eab928ac48f98b5786c640f535b58ff5e25cffa19904e2a419dcc26",
-    ],
+    name = "timedatex-0__0.5-3.el8.aarch64",
+    sha256 = "f6078b759fafad2208d3e572cec9fbfb473dea334bc7a90583811f451d493cef",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/timedatex-0.5-3.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "tzdata-0__2022a-1.el8.x86_64",
-    sha256 = "34f9baf88eab928ac48f98b5786c640f535b58ff5e25cffa19904e2a419dcc26",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/tzdata-2022a-1.el8.noarch.rpm",
-        "https://storage.googleapis.com/builddeps/34f9baf88eab928ac48f98b5786c640f535b58ff5e25cffa19904e2a419dcc26",
-    ],
+    name = "timedatex-0__0.5-3.el8.x86_64",
+    sha256 = "6fc3208be9c78bf1f843f9f7d4d3f04096f116dc056285142235bf76472ba382",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/timedatex-0.5-3.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "unbound-libs-0__1.7.3-17.el8.aarch64",
-    sha256 = "406140d0a2d6fe921875898b24b91376870fb9ab1b1baf7778cff060bbbe0d72",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/unbound-libs-1.7.3-17.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/406140d0a2d6fe921875898b24b91376870fb9ab1b1baf7778cff060bbbe0d72",
-    ],
+    name = "tzdata-0__2022a-2.el8.aarch64",
+    sha256 = "0440f6795ede1959a5381056845a232db6991633aae371373e703d9c16e592e2",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/tzdata-2022a-2.el8.noarch.rpm"],
 )
 
 rpm(
-    name = "unbound-libs-0__1.7.3-17.el8.x86_64",
-    sha256 = "9a5380195d24327a8a2e059395d7902f9bc3b771275afe1533702998dc5be364",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/unbound-libs-1.7.3-17.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/9a5380195d24327a8a2e059395d7902f9bc3b771275afe1533702998dc5be364",
-    ],
+    name = "tzdata-0__2022a-2.el8.x86_64",
+    sha256 = "0440f6795ede1959a5381056845a232db6991633aae371373e703d9c16e592e2",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/tzdata-2022a-2.el8.noarch.rpm"],
+)
+
+rpm(
+    name = "unbound-libs-0__1.16.0-2.el8.aarch64",
+    sha256 = "280dbefbd2d57d9fc8c39e6822f1bf65694a6c25ebcbec2fbafcb5ac5319649f",
+    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/unbound-libs-1.16.0-2.el8.aarch64.rpm"],
+)
+
+rpm(
+    name = "unbound-libs-0__1.16.0-2.el8.x86_64",
+    sha256 = "0ef7c208222374829233a615f364cb1c24980b812af2ee1aa3c064106b776256",
+    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/unbound-libs-1.16.0-2.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -4967,39 +4526,27 @@ rpm(
 )
 
 rpm(
-    name = "vim-minimal-2__8.0.1763-16.el8_5.12.aarch64",
-    sha256 = "cd5d66305cdf4fea908c7781d24befded311c6e1f48c7ce851d0aebf538c9e6b",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/vim-minimal-8.0.1763-16.el8_5.12.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/cd5d66305cdf4fea908c7781d24befded311c6e1f48c7ce851d0aebf538c9e6b",
-    ],
+    name = "vim-minimal-2__8.0.1763-19.el8.4.aarch64",
+    sha256 = "4a921c33ca497386a80d4f6ace2ec54bc8e568c83f6197daa9a0f29b8a97fe1d",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/vim-minimal-8.0.1763-19.el8.4.aarch64.rpm"],
 )
 
 rpm(
-    name = "vim-minimal-2__8.0.1763-16.el8_5.12.x86_64",
-    sha256 = "c5ba3f44fe4a19b6a15cf1c80d7f9db8be336e0b475cad1a397276c7ca668501",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/vim-minimal-8.0.1763-16.el8_5.12.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/c5ba3f44fe4a19b6a15cf1c80d7f9db8be336e0b475cad1a397276c7ca668501",
-    ],
+    name = "vim-minimal-2__8.0.1763-19.el8.4.x86_64",
+    sha256 = "8d1659cf14095e2a82da7b2b7c21e5b62fda058590ea66b9e3d33a6794449e2c",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/vim-minimal-8.0.1763-19.el8.4.x86_64.rpm"],
 )
 
 rpm(
-    name = "which-0__2.21-17.el8.aarch64",
-    sha256 = "35332bb903317e2300555f439b0eddd412f8731ce04e74a9272cfd7232c84f81",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/which-2.21-17.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/35332bb903317e2300555f439b0eddd412f8731ce04e74a9272cfd7232c84f81",
-    ],
+    name = "which-0__2.21-18.el8.aarch64",
+    sha256 = "c27e749065a42c812467155241ee9eedfcaae0f08f4cec952aa65194e98723d7",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/which-2.21-18.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "which-0__2.21-17.el8.x86_64",
-    sha256 = "0d761d50ec6ab263dde637c37b876b994f4a5394f6e2b3036e84563b66b75a3d",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/which-2.21-17.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/0d761d50ec6ab263dde637c37b876b994f4a5394f6e2b3036e84563b66b75a3d",
-    ],
+    name = "which-0__2.21-18.el8.x86_64",
+    sha256 = "0e4d5ee4cbea952903ee4febb1450caf92bf3c2d6ecac9d0dd8ac8611e9ff4db",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/which-2.21-18.el8.x86_64.rpm"],
 )
 
 rpm(
@@ -5039,73 +4586,49 @@ rpm(
 )
 
 rpm(
-    name = "xz-0__5.2.4-3.el8.aarch64",
-    sha256 = "b9a899e715019e7002600005bcb2a9dd7b089eaef9c55c3764c326d745ad681f",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/xz-5.2.4-3.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/b9a899e715019e7002600005bcb2a9dd7b089eaef9c55c3764c326d745ad681f",
-    ],
+    name = "xz-0__5.2.4-4.el8.aarch64",
+    sha256 = "c30b066af6b844602964858ef77b995e944ffbdd7a153a9c5c7fc30fd802b926",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/xz-5.2.4-4.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "xz-0__5.2.4-3.el8.x86_64",
-    sha256 = "02f10beaf61212427e0cd57140d050948eea0b533cf432d7bc4c10266c8b33db",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/xz-5.2.4-3.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/02f10beaf61212427e0cd57140d050948eea0b533cf432d7bc4c10266c8b33db",
-    ],
+    name = "xz-0__5.2.4-4.el8.x86_64",
+    sha256 = "99d7d4bfee1d5b55e08ee27c6869186531939f399d6c3ea33db191cae7e53f70",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/xz-5.2.4-4.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "xz-libs-0__5.2.4-3.el8.aarch64",
-    sha256 = "8f141db26834b1ec60028790b130d00b14b7fda256db0df1e51b7ba8d3d40c7b",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/xz-libs-5.2.4-3.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/8f141db26834b1ec60028790b130d00b14b7fda256db0df1e51b7ba8d3d40c7b",
-    ],
+    name = "xz-libs-0__5.2.4-4.el8.aarch64",
+    sha256 = "9498f961afe361c5f9e0eea0ce64f11071b1cb1afe30636cb888d109737ea16f",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/xz-libs-5.2.4-4.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "xz-libs-0__5.2.4-3.el8.x86_64",
-    sha256 = "61553db2c5d1da168da53ec285de14d00ce91bb02dd902a1688725cf37a7b1a2",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/xz-libs-5.2.4-3.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/61553db2c5d1da168da53ec285de14d00ce91bb02dd902a1688725cf37a7b1a2",
-    ],
+    name = "xz-libs-0__5.2.4-4.el8.x86_64",
+    sha256 = "69d67ea8b4bd532f750ff0592f0098ace60470da0fd0e4056188fda37a268d42",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/xz-libs-5.2.4-4.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "yajl-0__2.1.0-10.el8.aarch64",
-    sha256 = "255e74b387f5e9b517d82cd00f3b62af88b32054095be91a63b3e5eb5db34939",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/yajl-2.1.0-10.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/255e74b387f5e9b517d82cd00f3b62af88b32054095be91a63b3e5eb5db34939",
-    ],
+    name = "yajl-0__2.1.0-11.el8.aarch64",
+    sha256 = "3ae671d2c8bfd1f53ea706e3969dd2dafd5a2960371e8b6f6083fb345985a491",
+    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/yajl-2.1.0-11.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "yajl-0__2.1.0-10.el8.x86_64",
-    sha256 = "a7797aa70d6a35116ec3253523dc91d1b08df44bad7442b94af07bb6c0a661f0",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/yajl-2.1.0-10.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/a7797aa70d6a35116ec3253523dc91d1b08df44bad7442b94af07bb6c0a661f0",
-    ],
+    name = "yajl-0__2.1.0-11.el8.x86_64",
+    sha256 = "55a094ffe9f378ef465619bf6f60e9f26b672f67236883565fb893de7675c163",
+    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/yajl-2.1.0-11.el8.x86_64.rpm"],
 )
 
 rpm(
-    name = "zlib-0__1.2.11-17.el8.aarch64",
-    sha256 = "19223c1996366de6f38c38f5d0163368fbff9c29149bb925ffe8d2eba79b239c",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/zlib-1.2.11-17.el8.aarch64.rpm",
-        "https://storage.googleapis.com/builddeps/19223c1996366de6f38c38f5d0163368fbff9c29149bb925ffe8d2eba79b239c",
-    ],
+    name = "zlib-0__1.2.11-19.el8.aarch64",
+    sha256 = "4fe374ebed682fa00ac065080b6cef94b7fcfc5d422d77a4cfdf5eb878c60ced",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/aarch64/os/Packages/zlib-1.2.11-19.el8.aarch64.rpm"],
 )
 
 rpm(
-    name = "zlib-0__1.2.11-17.el8.x86_64",
-    sha256 = "a604ffec838794e53b7721e4f113dbd780b5a0765f200df6c41ea19018fa7ea6",
-    urls = [
-        "http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/zlib-1.2.11-17.el8.x86_64.rpm",
-        "https://storage.googleapis.com/builddeps/a604ffec838794e53b7721e4f113dbd780b5a0765f200df6c41ea19018fa7ea6",
-    ],
+    name = "zlib-0__1.2.11-19.el8.x86_64",
+    sha256 = "439833454c91b662c1ed99eff65e4726d765e974f65faadaf1c29eb1281f28f9",
+    urls = ["http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/zlib-1.2.11-19.el8.x86_64.rpm"],
 )
diff --git a/hack/bootstrap.sh b/hack/bootstrap.sh
index cf1525e0d..9e5b93152 100755
--- a/hack/bootstrap.sh
+++ b/hack/bootstrap.sh
@@ -26,7 +26,7 @@ KUBEVIRT_NO_BAZEL=${KUBEVIRT_NO_BAZEL:-false}
 HOST_ARCHITECTURE="$(uname -m)"
 
 sandbox_root=${SANDBOX_DIR}/default/root
-sandbox_hash="1c65c791715e97377c36a3be1b7edd35c99dd9ef"
+sandbox_hash="62d9399d36a7dfea7bbf29e9d689a08a9286cee4"
 
 function kubevirt::bootstrap::regenerate() {
     (
diff --git a/rpm/BUILD.bazel b/rpm/BUILD.bazel
index 75da4fbf2..38b8d21da 100644
--- a/rpm/BUILD.bazel
+++ b/rpm/BUILD.bazel
@@ -51,57 +51,57 @@ rpmtree(
     name = "handlerbase_aarch64",
     rpms = [
         "@acl-0__2.2.53-1.el8.aarch64//rpm",
-        "@audit-libs-0__3.0.7-3.el8.aarch64//rpm",
+        "@audit-libs-0__3.0.7-4.el8.aarch64//rpm",
         "@basesystem-0__11-5.el8.aarch64//rpm",
-        "@bash-0__4.4.20-3.el8.aarch64//rpm",
+        "@bash-0__4.4.20-4.el8.aarch64//rpm",
         "@bzip2-libs-0__1.0.6-26.el8.aarch64//rpm",
         "@ca-certificates-0__2021.2.50-82.el8.aarch64//rpm",
         "@centos-gpg-keys-1__8-6.el8.aarch64//rpm",
         "@centos-stream-release-0__8.6-1.el8.aarch64//rpm",
         "@centos-stream-repos-0__8-6.el8.aarch64//rpm",
         "@chkconfig-0__1.19.1-1.el8.aarch64//rpm",
-        "@coreutils-single-0__8.30-12.el8.aarch64//rpm",
+        "@coreutils-single-0__8.30-13.el8.aarch64//rpm",
         "@cracklib-0__2.9.6-15.el8.aarch64//rpm",
         "@cracklib-dicts-0__2.9.6-15.el8.aarch64//rpm",
         "@crypto-policies-0__20211116-1.gitae470d6.el8.aarch64//rpm",
-        "@curl-0__7.61.1-22.el8.aarch64//rpm",
+        "@curl-0__7.61.1-25.el8.aarch64//rpm",
         "@diffutils-0__3.6-6.el8.aarch64//rpm",
-        "@elfutils-libelf-0__0.186-1.el8.aarch64//rpm",
+        "@elfutils-libelf-0__0.187-4.el8.aarch64//rpm",
         "@filesystem-0__3.8-6.el8.aarch64//rpm",
         "@findutils-1__4.6.0-20.el8.aarch64//rpm",
         "@gawk-0__4.2.1-4.el8.aarch64//rpm",
-        "@glib2-0__2.56.4-158.el8.aarch64//rpm",
-        "@glibc-0__2.28-196.el8.aarch64//rpm",
-        "@glibc-common-0__2.28-196.el8.aarch64//rpm",
-        "@glibc-minimal-langpack-0__2.28-196.el8.aarch64//rpm",
+        "@glib2-0__2.56.4-159.el8.aarch64//rpm",
+        "@glibc-0__2.28-208.el8.aarch64//rpm",
+        "@glibc-common-0__2.28-208.el8.aarch64//rpm",
+        "@glibc-minimal-langpack-0__2.28-208.el8.aarch64//rpm",
         "@gmp-1__6.1.2-10.el8.aarch64//rpm",
         "@gnutls-0__3.6.16-4.el8.aarch64//rpm",
         "@grep-0__3.1-6.el8.aarch64//rpm",
-        "@gzip-0__1.9-12.el8.aarch64//rpm",
+        "@gzip-0__1.9-13.el8.aarch64//rpm",
         "@info-0__6.5-7.el8_5.aarch64//rpm",
-        "@iproute-0__5.15.0-4.el8.aarch64//rpm",
+        "@iproute-0__5.18.0-1.el8.aarch64//rpm",
         "@iptables-0__1.8.4-22.el8.aarch64//rpm",
         "@iptables-libs-0__1.8.4-22.el8.aarch64//rpm",
         "@jansson-0__2.14-1.el8.aarch64//rpm",
         "@keyutils-libs-0__1.5.10-9.el8.aarch64//rpm",
-        "@krb5-libs-0__1.18.2-14.el8.aarch64//rpm",
+        "@krb5-libs-0__1.18.2-21.el8.aarch64//rpm",
         "@libacl-0__2.2.53-1.el8.aarch64//rpm",
         "@libaio-0__0.3.112-1.el8.aarch64//rpm",
-        "@libarchive-0__3.3.3-3.el8_5.aarch64//rpm",
+        "@libarchive-0__3.3.3-4.el8.aarch64//rpm",
         "@libattr-0__2.4.48-3.el8.aarch64//rpm",
         "@libblkid-0__2.32.1-35.el8.aarch64//rpm",
-        "@libbpf-0__0.4.0-3.el8.aarch64//rpm",
+        "@libbpf-0__0.5.0-1.el8.aarch64//rpm",
         "@libburn-0__1.4.8-3.el8.aarch64//rpm",
-        "@libcap-0__2.48-2.el8.aarch64//rpm",
+        "@libcap-0__2.48-4.el8.aarch64//rpm",
         "@libcap-ng-0__0.7.11-1.el8.aarch64//rpm",
-        "@libcom_err-0__1.45.6-4.el8.aarch64//rpm",
-        "@libcurl-minimal-0__7.61.1-22.el8.aarch64//rpm",
+        "@libcom_err-0__1.45.6-5.el8.aarch64//rpm",
+        "@libcurl-minimal-0__7.61.1-25.el8.aarch64//rpm",
         "@libdb-0__5.3.28-42.el8_4.aarch64//rpm",
         "@libdb-utils-0__5.3.28-42.el8_4.aarch64//rpm",
         "@libfdisk-0__2.32.1-35.el8.aarch64//rpm",
         "@libffi-0__3.1-23.el8.aarch64//rpm",
-        "@libgcc-0__8.5.0-10.el8.aarch64//rpm",
-        "@libgcrypt-0__1.8.5-6.el8.aarch64//rpm",
+        "@libgcc-0__8.5.0-15.el8.aarch64//rpm",
+        "@libgcrypt-0__1.8.5-7.el8.aarch64//rpm",
         "@libgpg-error-0__1.31-1.el8.aarch64//rpm",
         "@libibverbs-0__37.2-1.el8.aarch64//rpm",
         "@libidn2-0__2.2.0-1.el8.aarch64//rpm",
@@ -113,7 +113,7 @@ rpmtree(
         "@libnfnetlink-0__1.0.1-13.el8.aarch64//rpm",
         "@libnftnl-0__1.1.5-5.el8.aarch64//rpm",
         "@libnghttp2-0__1.33.0-3.el8_2.1.aarch64//rpm",
-        "@libnl3-0__3.5.0-1.el8.aarch64//rpm",
+        "@libnl3-0__3.7.0-1.el8.aarch64//rpm",
         "@libnsl2-0__1.2.0-2.20180605git4a062cf.el8.aarch64//rpm",
         "@libpcap-14__1.9.1-5.el8.aarch64//rpm",
         "@libpwquality-0__1.4.4-3.el8.aarch64//rpm",
@@ -124,13 +124,13 @@ rpmtree(
         "@libsigsegv-0__2.11-5.el8.aarch64//rpm",
         "@libsmartcols-0__2.32.1-35.el8.aarch64//rpm",
         "@libtasn1-0__4.13-3.el8.aarch64//rpm",
-        "@libtirpc-0__1.1.4-6.el8.aarch64//rpm",
+        "@libtirpc-0__1.1.4-7.el8.aarch64//rpm",
         "@libunistring-0__0.9.9-3.el8.aarch64//rpm",
         "@libutempter-0__1.1.6-14.el8.aarch64//rpm",
         "@libuuid-0__2.32.1-35.el8.aarch64//rpm",
-        "@libverto-0__0.3.0-5.el8.aarch64//rpm",
+        "@libverto-0__0.3.2-2.el8.aarch64//rpm",
         "@libxcrypt-0__4.1.1-6.el8.aarch64//rpm",
-        "@libxml2-0__2.9.7-13.el8.aarch64//rpm",
+        "@libxml2-0__2.9.7-14.el8.aarch64//rpm",
         "@libzstd-0__1.4.4-1.el8.aarch64//rpm",
         "@lua-libs-0__5.3.4-12.el8.aarch64//rpm",
         "@lz4-libs-0__1.8.3-3.el8_4.aarch64//rpm",
@@ -138,36 +138,36 @@ rpmtree(
         "@ncurses-base-0__6.1-9.20180224.el8.aarch64//rpm",
         "@ncurses-libs-0__6.1-9.20180224.el8.aarch64//rpm",
         "@nettle-0__3.4.1-7.el8.aarch64//rpm",
-        "@nftables-1__0.9.3-25.el8.aarch64//rpm",
+        "@nftables-1__0.9.3-26.el8.aarch64//rpm",
         "@openssl-libs-1__1.1.1k-6.el8.aarch64//rpm",
         "@p11-kit-0__0.23.22-1.el8.aarch64//rpm",
         "@p11-kit-trust-0__0.23.22-1.el8.aarch64//rpm",
-        "@pam-0__1.3.1-16.el8.aarch64//rpm",
+        "@pam-0__1.3.1-22.el8.aarch64//rpm",
         "@pcre-0__8.42-6.el8.aarch64//rpm",
-        "@pcre2-0__10.32-2.el8.aarch64//rpm",
+        "@pcre2-0__10.32-3.el8.aarch64//rpm",
         "@policycoreutils-0__2.9-19.el8.aarch64//rpm",
         "@popt-0__1.18-1.el8.aarch64//rpm",
         "@procps-ng-0__3.3.15-7.el8.aarch64//rpm",
         "@psmisc-0__23.1-5.el8.aarch64//rpm",
         "@qemu-img-15__6.2.0-5.module_el8.6.0__plus__1087__plus__b42c8331.aarch64//rpm",
         "@readline-0__7.0-10.el8.aarch64//rpm",
-        "@rpm-0__4.14.3-22.el8.aarch64//rpm",
-        "@rpm-libs-0__4.14.3-22.el8.aarch64//rpm",
-        "@rpm-plugin-selinux-0__4.14.3-22.el8.aarch64//rpm",
+        "@rpm-0__4.14.3-23.el8.aarch64//rpm",
+        "@rpm-libs-0__4.14.3-23.el8.aarch64//rpm",
+        "@rpm-plugin-selinux-0__4.14.3-23.el8.aarch64//rpm",
         "@sed-0__4.5-5.el8.aarch64//rpm",
-        "@selinux-policy-0__3.14.3-95.el8.aarch64//rpm",
-        "@selinux-policy-targeted-0__3.14.3-95.el8.aarch64//rpm",
-        "@setup-0__2.12.2-6.el8.aarch64//rpm",
+        "@selinux-policy-0__3.14.3-104.el8.aarch64//rpm",
+        "@selinux-policy-targeted-0__3.14.3-104.el8.aarch64//rpm",
+        "@setup-0__2.12.2-7.el8.aarch64//rpm",
         "@shadow-utils-2__4.6-16.el8.aarch64//rpm",
         "@sqlite-libs-0__3.26.0-15.el8.aarch64//rpm",
-        "@systemd-libs-0__239-58.el8.aarch64//rpm",
-        "@tar-2__1.30-5.el8.aarch64//rpm",
-        "@tzdata-0__2022a-1.el8.aarch64//rpm",
+        "@systemd-libs-0__239-60.el8.aarch64//rpm",
+        "@tar-2__1.30-6.el8.aarch64//rpm",
+        "@tzdata-0__2022a-2.el8.aarch64//rpm",
         "@util-linux-0__2.32.1-35.el8.aarch64//rpm",
-        "@vim-minimal-2__8.0.1763-16.el8_5.12.aarch64//rpm",
+        "@vim-minimal-2__8.0.1763-19.el8.4.aarch64//rpm",
         "@xorriso-0__1.4.8-4.el8.aarch64//rpm",
-        "@xz-libs-0__5.2.4-3.el8.aarch64//rpm",
-        "@zlib-0__1.2.11-17.el8.aarch64//rpm",
+        "@xz-libs-0__5.2.4-4.el8.aarch64//rpm",
+        "@zlib-0__1.2.11-19.el8.aarch64//rpm",
     ],
     symlinks = {
         "/var/run": "../run",
@@ -180,57 +180,57 @@ rpmtree(
     name = "handlerbase_x86_64",
     rpms = [
         "@acl-0__2.2.53-1.el8.x86_64//rpm",
-        "@audit-libs-0__3.0.7-3.el8.x86_64//rpm",
+        "@audit-libs-0__3.0.7-4.el8.x86_64//rpm",
         "@basesystem-0__11-5.el8.x86_64//rpm",
-        "@bash-0__4.4.20-3.el8.x86_64//rpm",
+        "@bash-0__4.4.20-4.el8.x86_64//rpm",
         "@bzip2-libs-0__1.0.6-26.el8.x86_64//rpm",
         "@ca-certificates-0__2021.2.50-82.el8.x86_64//rpm",
         "@centos-gpg-keys-1__8-6.el8.x86_64//rpm",
         "@centos-stream-release-0__8.6-1.el8.x86_64//rpm",
         "@centos-stream-repos-0__8-6.el8.x86_64//rpm",
         "@chkconfig-0__1.19.1-1.el8.x86_64//rpm",
-        "@coreutils-single-0__8.30-12.el8.x86_64//rpm",
+        "@coreutils-single-0__8.30-13.el8.x86_64//rpm",
         "@cracklib-0__2.9.6-15.el8.x86_64//rpm",
         "@cracklib-dicts-0__2.9.6-15.el8.x86_64//rpm",
         "@crypto-policies-0__20211116-1.gitae470d6.el8.x86_64//rpm",
-        "@curl-0__7.61.1-22.el8.x86_64//rpm",
+        "@curl-0__7.61.1-25.el8.x86_64//rpm",
         "@diffutils-0__3.6-6.el8.x86_64//rpm",
-        "@elfutils-libelf-0__0.186-1.el8.x86_64//rpm",
+        "@elfutils-libelf-0__0.187-4.el8.x86_64//rpm",
         "@filesystem-0__3.8-6.el8.x86_64//rpm",
         "@findutils-1__4.6.0-20.el8.x86_64//rpm",
         "@gawk-0__4.2.1-4.el8.x86_64//rpm",
-        "@glib2-0__2.56.4-158.el8.x86_64//rpm",
-        "@glibc-0__2.28-196.el8.x86_64//rpm",
-        "@glibc-common-0__2.28-196.el8.x86_64//rpm",
-        "@glibc-minimal-langpack-0__2.28-196.el8.x86_64//rpm",
+        "@glib2-0__2.56.4-159.el8.x86_64//rpm",
+        "@glibc-0__2.28-208.el8.x86_64//rpm",
+        "@glibc-common-0__2.28-208.el8.x86_64//rpm",
+        "@glibc-minimal-langpack-0__2.28-208.el8.x86_64//rpm",
         "@gmp-1__6.1.2-10.el8.x86_64//rpm",
         "@gnutls-0__3.6.16-4.el8.x86_64//rpm",
         "@grep-0__3.1-6.el8.x86_64//rpm",
-        "@gzip-0__1.9-12.el8.x86_64//rpm",
+        "@gzip-0__1.9-13.el8.x86_64//rpm",
         "@info-0__6.5-7.el8_5.x86_64//rpm",
-        "@iproute-0__5.15.0-4.el8.x86_64//rpm",
+        "@iproute-0__5.18.0-1.el8.x86_64//rpm",
         "@iptables-0__1.8.4-22.el8.x86_64//rpm",
         "@iptables-libs-0__1.8.4-22.el8.x86_64//rpm",
         "@jansson-0__2.14-1.el8.x86_64//rpm",
         "@keyutils-libs-0__1.5.10-9.el8.x86_64//rpm",
-        "@krb5-libs-0__1.18.2-14.el8.x86_64//rpm",
+        "@krb5-libs-0__1.18.2-21.el8.x86_64//rpm",
         "@libacl-0__2.2.53-1.el8.x86_64//rpm",
         "@libaio-0__0.3.112-1.el8.x86_64//rpm",
-        "@libarchive-0__3.3.3-3.el8_5.x86_64//rpm",
+        "@libarchive-0__3.3.3-4.el8.x86_64//rpm",
         "@libattr-0__2.4.48-3.el8.x86_64//rpm",
         "@libblkid-0__2.32.1-35.el8.x86_64//rpm",
-        "@libbpf-0__0.4.0-3.el8.x86_64//rpm",
+        "@libbpf-0__0.5.0-1.el8.x86_64//rpm",
         "@libburn-0__1.4.8-3.el8.x86_64//rpm",
-        "@libcap-0__2.48-2.el8.x86_64//rpm",
+        "@libcap-0__2.48-4.el8.x86_64//rpm",
         "@libcap-ng-0__0.7.11-1.el8.x86_64//rpm",
-        "@libcom_err-0__1.45.6-4.el8.x86_64//rpm",
-        "@libcurl-minimal-0__7.61.1-22.el8.x86_64//rpm",
+        "@libcom_err-0__1.45.6-5.el8.x86_64//rpm",
+        "@libcurl-minimal-0__7.61.1-25.el8.x86_64//rpm",
         "@libdb-0__5.3.28-42.el8_4.x86_64//rpm",
         "@libdb-utils-0__5.3.28-42.el8_4.x86_64//rpm",
         "@libfdisk-0__2.32.1-35.el8.x86_64//rpm",
         "@libffi-0__3.1-23.el8.x86_64//rpm",
-        "@libgcc-0__8.5.0-10.el8.x86_64//rpm",
-        "@libgcrypt-0__1.8.5-6.el8.x86_64//rpm",
+        "@libgcc-0__8.5.0-15.el8.x86_64//rpm",
+        "@libgcrypt-0__1.8.5-7.el8.x86_64//rpm",
         "@libgpg-error-0__1.31-1.el8.x86_64//rpm",
         "@libibverbs-0__37.2-1.el8.x86_64//rpm",
         "@libidn2-0__2.2.0-1.el8.x86_64//rpm",
@@ -242,7 +242,7 @@ rpmtree(
         "@libnfnetlink-0__1.0.1-13.el8.x86_64//rpm",
         "@libnftnl-0__1.1.5-5.el8.x86_64//rpm",
         "@libnghttp2-0__1.33.0-3.el8_2.1.x86_64//rpm",
-        "@libnl3-0__3.5.0-1.el8.x86_64//rpm",
+        "@libnl3-0__3.7.0-1.el8.x86_64//rpm",
         "@libnsl2-0__1.2.0-2.20180605git4a062cf.el8.x86_64//rpm",
         "@libpcap-14__1.9.1-5.el8.x86_64//rpm",
         "@libpwquality-0__1.4.4-3.el8.x86_64//rpm",
@@ -253,13 +253,13 @@ rpmtree(
         "@libsigsegv-0__2.11-5.el8.x86_64//rpm",
         "@libsmartcols-0__2.32.1-35.el8.x86_64//rpm",
         "@libtasn1-0__4.13-3.el8.x86_64//rpm",
-        "@libtirpc-0__1.1.4-6.el8.x86_64//rpm",
+        "@libtirpc-0__1.1.4-7.el8.x86_64//rpm",
         "@libunistring-0__0.9.9-3.el8.x86_64//rpm",
         "@libutempter-0__1.1.6-14.el8.x86_64//rpm",
         "@libuuid-0__2.32.1-35.el8.x86_64//rpm",
-        "@libverto-0__0.3.0-5.el8.x86_64//rpm",
+        "@libverto-0__0.3.2-2.el8.x86_64//rpm",
         "@libxcrypt-0__4.1.1-6.el8.x86_64//rpm",
-        "@libxml2-0__2.9.7-13.el8.x86_64//rpm",
+        "@libxml2-0__2.9.7-14.el8.x86_64//rpm",
         "@libzstd-0__1.4.4-1.el8.x86_64//rpm",
         "@lua-libs-0__5.3.4-12.el8.x86_64//rpm",
         "@lz4-libs-0__1.8.3-3.el8_4.x86_64//rpm",
@@ -267,36 +267,36 @@ rpmtree(
         "@ncurses-base-0__6.1-9.20180224.el8.x86_64//rpm",
         "@ncurses-libs-0__6.1-9.20180224.el8.x86_64//rpm",
         "@nettle-0__3.4.1-7.el8.x86_64//rpm",
-        "@nftables-1__0.9.3-25.el8.x86_64//rpm",
+        "@nftables-1__0.9.3-26.el8.x86_64//rpm",
         "@openssl-libs-1__1.1.1k-6.el8.x86_64//rpm",
         "@p11-kit-0__0.23.22-1.el8.x86_64//rpm",
         "@p11-kit-trust-0__0.23.22-1.el8.x86_64//rpm",
-        "@pam-0__1.3.1-16.el8.x86_64//rpm",
+        "@pam-0__1.3.1-22.el8.x86_64//rpm",
         "@pcre-0__8.42-6.el8.x86_64//rpm",
-        "@pcre2-0__10.32-2.el8.x86_64//rpm",
+        "@pcre2-0__10.32-3.el8.x86_64//rpm",
         "@policycoreutils-0__2.9-19.el8.x86_64//rpm",
         "@popt-0__1.18-1.el8.x86_64//rpm",
         "@procps-ng-0__3.3.15-7.el8.x86_64//rpm",
         "@psmisc-0__23.1-5.el8.x86_64//rpm",
         "@qemu-img-15__6.2.0-5.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@readline-0__7.0-10.el8.x86_64//rpm",
-        "@rpm-0__4.14.3-22.el8.x86_64//rpm",
-        "@rpm-libs-0__4.14.3-22.el8.x86_64//rpm",
-        "@rpm-plugin-selinux-0__4.14.3-22.el8.x86_64//rpm",
+        "@rpm-0__4.14.3-23.el8.x86_64//rpm",
+        "@rpm-libs-0__4.14.3-23.el8.x86_64//rpm",
+        "@rpm-plugin-selinux-0__4.14.3-23.el8.x86_64//rpm",
         "@sed-0__4.5-5.el8.x86_64//rpm",
-        "@selinux-policy-0__3.14.3-95.el8.x86_64//rpm",
-        "@selinux-policy-targeted-0__3.14.3-95.el8.x86_64//rpm",
-        "@setup-0__2.12.2-6.el8.x86_64//rpm",
+        "@selinux-policy-0__3.14.3-104.el8.x86_64//rpm",
+        "@selinux-policy-targeted-0__3.14.3-104.el8.x86_64//rpm",
+        "@setup-0__2.12.2-7.el8.x86_64//rpm",
         "@shadow-utils-2__4.6-16.el8.x86_64//rpm",
         "@sqlite-libs-0__3.26.0-15.el8.x86_64//rpm",
-        "@systemd-libs-0__239-58.el8.x86_64//rpm",
-        "@tar-2__1.30-5.el8.x86_64//rpm",
-        "@tzdata-0__2022a-1.el8.x86_64//rpm",
+        "@systemd-libs-0__239-60.el8.x86_64//rpm",
+        "@tar-2__1.30-6.el8.x86_64//rpm",
+        "@tzdata-0__2022a-2.el8.x86_64//rpm",
         "@util-linux-0__2.32.1-35.el8.x86_64//rpm",
-        "@vim-minimal-2__8.0.1763-16.el8_5.12.x86_64//rpm",
+        "@vim-minimal-2__8.0.1763-19.el8.4.x86_64//rpm",
         "@xorriso-0__1.4.8-4.el8.x86_64//rpm",
-        "@xz-libs-0__5.2.4-3.el8.x86_64//rpm",
-        "@zlib-0__1.2.11-17.el8.x86_64//rpm",
+        "@xz-libs-0__5.2.4-4.el8.x86_64//rpm",
+        "@zlib-0__1.2.11-19.el8.x86_64//rpm",
     ],
     symlinks = {
         "/var/run": "../run",
@@ -314,10 +314,10 @@ rpmtree(
     },
     rpms = [
         "@acl-0__2.2.53-1.el8.aarch64//rpm",
-        "@audit-libs-0__3.0.7-3.el8.aarch64//rpm",
+        "@audit-libs-0__3.0.7-4.el8.aarch64//rpm",
         "@autogen-libopts-0__5.18.12-8.el8.aarch64//rpm",
         "@basesystem-0__11-5.el8.aarch64//rpm",
-        "@bash-0__4.4.20-3.el8.aarch64//rpm",
+        "@bash-0__4.4.20-4.el8.aarch64//rpm",
         "@bzip2-0__1.0.6-26.el8.aarch64//rpm",
         "@bzip2-libs-0__1.0.6-26.el8.aarch64//rpm",
         "@ca-certificates-0__2021.2.50-82.el8.aarch64//rpm",
@@ -325,48 +325,48 @@ rpmtree(
         "@centos-stream-release-0__8.6-1.el8.aarch64//rpm",
         "@centos-stream-repos-0__8-6.el8.aarch64//rpm",
         "@chkconfig-0__1.19.1-1.el8.aarch64//rpm",
-        "@coreutils-single-0__8.30-12.el8.aarch64//rpm",
+        "@coreutils-single-0__8.30-13.el8.aarch64//rpm",
         "@cracklib-0__2.9.6-15.el8.aarch64//rpm",
         "@cracklib-dicts-0__2.9.6-15.el8.aarch64//rpm",
         "@crypto-policies-0__20211116-1.gitae470d6.el8.aarch64//rpm",
         "@cryptsetup-libs-0__2.3.7-2.el8.aarch64//rpm",
-        "@curl-0__7.61.1-22.el8.aarch64//rpm",
+        "@curl-0__7.61.1-25.el8.aarch64//rpm",
         "@cyrus-sasl-0__2.1.27-6.el8_5.aarch64//rpm",
         "@cyrus-sasl-gssapi-0__2.1.27-6.el8_5.aarch64//rpm",
         "@cyrus-sasl-lib-0__2.1.27-6.el8_5.aarch64//rpm",
-        "@dbus-1__1.12.8-18.el8.aarch64//rpm",
-        "@dbus-common-1__1.12.8-18.el8.aarch64//rpm",
-        "@dbus-daemon-1__1.12.8-18.el8.aarch64//rpm",
-        "@dbus-libs-1__1.12.8-18.el8.aarch64//rpm",
-        "@dbus-tools-1__1.12.8-18.el8.aarch64//rpm",
+        "@dbus-1__1.12.8-19.el8.aarch64//rpm",
+        "@dbus-common-1__1.12.8-19.el8.aarch64//rpm",
+        "@dbus-daemon-1__1.12.8-19.el8.aarch64//rpm",
+        "@dbus-libs-1__1.12.8-19.el8.aarch64//rpm",
+        "@dbus-tools-1__1.12.8-19.el8.aarch64//rpm",
         "@device-mapper-8__1.02.181-3.el8.aarch64//rpm",
         "@device-mapper-libs-8__1.02.181-3.el8.aarch64//rpm",
-        "@device-mapper-multipath-libs-0__0.8.4-22.el8.aarch64//rpm",
+        "@device-mapper-multipath-libs-0__0.8.4-26.el8.aarch64//rpm",
         "@diffutils-0__3.6-6.el8.aarch64//rpm",
         "@edk2-aarch64-0__20220126gitbb1bba3d77-2.el8.aarch64//rpm",
-        "@elfutils-default-yama-scope-0__0.186-1.el8.aarch64//rpm",
-        "@elfutils-libelf-0__0.186-1.el8.aarch64//rpm",
-        "@elfutils-libs-0__0.186-1.el8.aarch64//rpm",
-        "@ethtool-2__5.13-1.el8.aarch64//rpm",
-        "@expat-0__2.2.5-8.el8.aarch64//rpm",
+        "@elfutils-default-yama-scope-0__0.187-4.el8.aarch64//rpm",
+        "@elfutils-libelf-0__0.187-4.el8.aarch64//rpm",
+        "@elfutils-libs-0__0.187-4.el8.aarch64//rpm",
+        "@ethtool-2__5.13-2.el8.aarch64//rpm",
+        "@expat-0__2.2.5-9.el8.aarch64//rpm",
         "@filesystem-0__3.8-6.el8.aarch64//rpm",
         "@findutils-1__4.6.0-20.el8.aarch64//rpm",
         "@gawk-0__4.2.1-4.el8.aarch64//rpm",
         "@gettext-0__0.19.8.1-17.el8.aarch64//rpm",
         "@gettext-libs-0__0.19.8.1-17.el8.aarch64//rpm",
-        "@glib2-0__2.56.4-158.el8.aarch64//rpm",
-        "@glibc-0__2.28-196.el8.aarch64//rpm",
-        "@glibc-common-0__2.28-196.el8.aarch64//rpm",
-        "@glibc-minimal-langpack-0__2.28-196.el8.aarch64//rpm",
+        "@glib2-0__2.56.4-159.el8.aarch64//rpm",
+        "@glibc-0__2.28-208.el8.aarch64//rpm",
+        "@glibc-common-0__2.28-208.el8.aarch64//rpm",
+        "@glibc-minimal-langpack-0__2.28-208.el8.aarch64//rpm",
         "@gmp-1__6.1.2-10.el8.aarch64//rpm",
         "@gnutls-0__3.6.16-4.el8.aarch64//rpm",
         "@gnutls-dane-0__3.6.16-4.el8.aarch64//rpm",
         "@gnutls-utils-0__3.6.16-4.el8.aarch64//rpm",
         "@grep-0__3.1-6.el8.aarch64//rpm",
-        "@gzip-0__1.9-12.el8.aarch64//rpm",
+        "@gzip-0__1.9-13.el8.aarch64//rpm",
         "@info-0__6.5-7.el8_5.aarch64//rpm",
-        "@iproute-0__5.15.0-4.el8.aarch64//rpm",
-        "@iproute-tc-0__5.15.0-4.el8.aarch64//rpm",
+        "@iproute-0__5.18.0-1.el8.aarch64//rpm",
+        "@iproute-tc-0__5.18.0-1.el8.aarch64//rpm",
         "@iptables-0__1.8.4-22.el8.aarch64//rpm",
         "@iptables-libs-0__1.8.4-22.el8.aarch64//rpm",
         "@jansson-0__2.14-1.el8.aarch64//rpm",
@@ -375,28 +375,28 @@ rpmtree(
         "@keyutils-libs-0__1.5.10-9.el8.aarch64//rpm",
         "@kmod-0__25-19.el8.aarch64//rpm",
         "@kmod-libs-0__25-19.el8.aarch64//rpm",
-        "@krb5-libs-0__1.18.2-14.el8.aarch64//rpm",
+        "@krb5-libs-0__1.18.2-21.el8.aarch64//rpm",
         "@libacl-0__2.2.53-1.el8.aarch64//rpm",
         "@libaio-0__0.3.112-1.el8.aarch64//rpm",
-        "@libarchive-0__3.3.3-3.el8_5.aarch64//rpm",
+        "@libarchive-0__3.3.3-4.el8.aarch64//rpm",
         "@libattr-0__2.4.48-3.el8.aarch64//rpm",
         "@libblkid-0__2.32.1-35.el8.aarch64//rpm",
-        "@libbpf-0__0.4.0-3.el8.aarch64//rpm",
+        "@libbpf-0__0.5.0-1.el8.aarch64//rpm",
         "@libburn-0__1.4.8-3.el8.aarch64//rpm",
-        "@libcap-0__2.48-2.el8.aarch64//rpm",
+        "@libcap-0__2.48-4.el8.aarch64//rpm",
         "@libcap-ng-0__0.7.11-1.el8.aarch64//rpm",
-        "@libcom_err-0__1.45.6-4.el8.aarch64//rpm",
+        "@libcom_err-0__1.45.6-5.el8.aarch64//rpm",
         "@libcroco-0__0.6.12-4.el8_2.1.aarch64//rpm",
-        "@libcurl-minimal-0__7.61.1-22.el8.aarch64//rpm",
+        "@libcurl-minimal-0__7.61.1-25.el8.aarch64//rpm",
         "@libdb-0__5.3.28-42.el8_4.aarch64//rpm",
         "@libdb-utils-0__5.3.28-42.el8_4.aarch64//rpm",
         "@libevent-0__2.1.8-5.el8.aarch64//rpm",
         "@libfdisk-0__2.32.1-35.el8.aarch64//rpm",
         "@libfdt-0__1.6.0-1.el8.aarch64//rpm",
         "@libffi-0__3.1-23.el8.aarch64//rpm",
-        "@libgcc-0__8.5.0-10.el8.aarch64//rpm",
-        "@libgcrypt-0__1.8.5-6.el8.aarch64//rpm",
-        "@libgomp-0__8.5.0-10.el8.aarch64//rpm",
+        "@libgcc-0__8.5.0-15.el8.aarch64//rpm",
+        "@libgcrypt-0__1.8.5-7.el8.aarch64//rpm",
+        "@libgomp-0__8.5.0-15.el8.aarch64//rpm",
         "@libgpg-error-0__1.31-1.el8.aarch64//rpm",
         "@libibverbs-0__37.2-1.el8.aarch64//rpm",
         "@libidn2-0__2.2.0-1.el8.aarch64//rpm",
@@ -408,7 +408,7 @@ rpmtree(
         "@libnfnetlink-0__1.0.1-13.el8.aarch64//rpm",
         "@libnftnl-0__1.1.5-5.el8.aarch64//rpm",
         "@libnghttp2-0__1.33.0-3.el8_2.1.aarch64//rpm",
-        "@libnl3-0__3.5.0-1.el8.aarch64//rpm",
+        "@libnl3-0__3.7.0-1.el8.aarch64//rpm",
         "@libnsl2-0__1.2.0-2.20180605git4a062cf.el8.aarch64//rpm",
         "@libpcap-14__1.9.1-5.el8.aarch64//rpm",
         "@libpng-2__1.6.34-5.el8.aarch64//rpm",
@@ -423,22 +423,22 @@ rpmtree(
         "@libsmartcols-0__2.32.1-35.el8.aarch64//rpm",
         "@libssh-0__0.9.6-3.el8.aarch64//rpm",
         "@libssh-config-0__0.9.6-3.el8.aarch64//rpm",
-        "@libstdc__plus____plus__-0__8.5.0-10.el8.aarch64//rpm",
+        "@libstdc__plus____plus__-0__8.5.0-15.el8.aarch64//rpm",
         "@libtasn1-0__4.13-3.el8.aarch64//rpm",
-        "@libtirpc-0__1.1.4-6.el8.aarch64//rpm",
+        "@libtirpc-0__1.1.4-7.el8.aarch64//rpm",
         "@libtpms-0__0.9.1-0.20211126git1ff6fe1f43.module_el8.6.0__plus__1087__plus__b42c8331.aarch64//rpm",
         "@libunistring-0__0.9.9-3.el8.aarch64//rpm",
         "@libusbx-0__1.0.23-4.el8.aarch64//rpm",
         "@libutempter-0__1.1.6-14.el8.aarch64//rpm",
         "@libuuid-0__2.32.1-35.el8.aarch64//rpm",
-        "@libverto-0__0.3.0-5.el8.aarch64//rpm",
+        "@libverto-0__0.3.2-2.el8.aarch64//rpm",
         "@libvirt-client-0__8.0.0-2.module_el8.6.0__plus__1087__plus__b42c8331.aarch64//rpm",
         "@libvirt-daemon-0__8.0.0-2.module_el8.6.0__plus__1087__plus__b42c8331.aarch64//rpm",
         "@libvirt-daemon-driver-qemu-0__8.0.0-2.module_el8.6.0__plus__1087__plus__b42c8331.aarch64//rpm",
         "@libvirt-libs-0__8.0.0-2.module_el8.6.0__plus__1087__plus__b42c8331.aarch64//rpm",
         "@libxcrypt-0__4.1.1-6.el8.aarch64//rpm",
         "@libxkbcommon-0__0.9.1-1.el8.aarch64//rpm",
-        "@libxml2-0__2.9.7-13.el8.aarch64//rpm",
+        "@libxml2-0__2.9.7-14.el8.aarch64//rpm",
         "@libzstd-0__1.4.4-1.el8.aarch64//rpm",
         "@lua-libs-0__5.3.4-12.el8.aarch64//rpm",
         "@lz4-libs-0__1.8.3-3.el8_4.aarch64//rpm",
@@ -448,21 +448,21 @@ rpmtree(
         "@ncurses-base-0__6.1-9.20180224.el8.aarch64//rpm",
         "@ncurses-libs-0__6.1-9.20180224.el8.aarch64//rpm",
         "@nettle-0__3.4.1-7.el8.aarch64//rpm",
-        "@nftables-1__0.9.3-25.el8.aarch64//rpm",
-        "@nmap-ncat-2__7.70-6.el8.aarch64//rpm",
+        "@nftables-1__0.9.3-26.el8.aarch64//rpm",
+        "@nmap-ncat-2__7.70-7.el8.aarch64//rpm",
         "@numactl-libs-0__2.0.12-13.el8.aarch64//rpm",
         "@numad-0__0.5-26.20150602git.el8.aarch64//rpm",
         "@openldap-0__2.4.46-18.el8.aarch64//rpm",
         "@openssl-libs-1__1.1.1k-6.el8.aarch64//rpm",
         "@p11-kit-0__0.23.22-1.el8.aarch64//rpm",
         "@p11-kit-trust-0__0.23.22-1.el8.aarch64//rpm",
-        "@pam-0__1.3.1-16.el8.aarch64//rpm",
+        "@pam-0__1.3.1-22.el8.aarch64//rpm",
         "@pcre-0__8.42-6.el8.aarch64//rpm",
-        "@pcre2-0__10.32-2.el8.aarch64//rpm",
+        "@pcre2-0__10.32-3.el8.aarch64//rpm",
         "@pixman-0__0.38.4-2.el8.aarch64//rpm",
         "@policycoreutils-0__2.9-19.el8.aarch64//rpm",
-        "@polkit-0__0.115-13.el8_5.1.aarch64//rpm",
-        "@polkit-libs-0__0.115-13.el8_5.1.aarch64//rpm",
+        "@polkit-0__0.115-13.0.1.el8.2.aarch64//rpm",
+        "@polkit-libs-0__0.115-13.0.1.el8.2.aarch64//rpm",
         "@polkit-pkla-compat-0__0.1-12.el8.aarch64//rpm",
         "@popt-0__1.18-1.el8.aarch64//rpm",
         "@procps-ng-0__3.3.15-7.el8.aarch64//rpm",
@@ -471,35 +471,36 @@ rpmtree(
         "@qemu-kvm-common-15__6.2.0-5.module_el8.6.0__plus__1087__plus__b42c8331.aarch64//rpm",
         "@qemu-kvm-core-15__6.2.0-5.module_el8.6.0__plus__1087__plus__b42c8331.aarch64//rpm",
         "@readline-0__7.0-10.el8.aarch64//rpm",
-        "@rpm-0__4.14.3-22.el8.aarch64//rpm",
-        "@rpm-libs-0__4.14.3-22.el8.aarch64//rpm",
-        "@rpm-plugin-selinux-0__4.14.3-22.el8.aarch64//rpm",
+        "@rpm-0__4.14.3-23.el8.aarch64//rpm",
+        "@rpm-libs-0__4.14.3-23.el8.aarch64//rpm",
+        "@rpm-plugin-selinux-0__4.14.3-23.el8.aarch64//rpm",
         "@sed-0__4.5-5.el8.aarch64//rpm",
-        "@selinux-policy-0__3.14.3-95.el8.aarch64//rpm",
-        "@selinux-policy-targeted-0__3.14.3-95.el8.aarch64//rpm",
-        "@setup-0__2.12.2-6.el8.aarch64//rpm",
+        "@selinux-policy-0__3.14.3-104.el8.aarch64//rpm",
+        "@selinux-policy-targeted-0__3.14.3-104.el8.aarch64//rpm",
+        "@setup-0__2.12.2-7.el8.aarch64//rpm",
         "@shadow-utils-2__4.6-16.el8.aarch64//rpm",
         "@snappy-0__1.1.8-3.el8.aarch64//rpm",
         "@sqlite-libs-0__3.26.0-15.el8.aarch64//rpm",
         "@swtpm-0__0.7.0-1.20211109gitb79fd91.module_el8.6.0__plus__1087__plus__b42c8331.aarch64//rpm",
         "@swtpm-libs-0__0.7.0-1.20211109gitb79fd91.module_el8.6.0__plus__1087__plus__b42c8331.aarch64//rpm",
         "@swtpm-tools-0__0.7.0-1.20211109gitb79fd91.module_el8.6.0__plus__1087__plus__b42c8331.aarch64//rpm",
-        "@systemd-0__239-58.el8.aarch64//rpm",
-        "@systemd-container-0__239-58.el8.aarch64//rpm",
-        "@systemd-libs-0__239-58.el8.aarch64//rpm",
-        "@systemd-pam-0__239-58.el8.aarch64//rpm",
-        "@tar-2__1.30-5.el8.aarch64//rpm",
-        "@tzdata-0__2022a-1.el8.aarch64//rpm",
-        "@unbound-libs-0__1.7.3-17.el8.aarch64//rpm",
+        "@systemd-0__239-60.el8.aarch64//rpm",
+        "@systemd-container-0__239-60.el8.aarch64//rpm",
+        "@systemd-libs-0__239-60.el8.aarch64//rpm",
+        "@systemd-pam-0__239-60.el8.aarch64//rpm",
+        "@tar-2__1.30-6.el8.aarch64//rpm",
+        "@timedatex-0__0.5-3.el8.aarch64//rpm",
+        "@tzdata-0__2022a-2.el8.aarch64//rpm",
+        "@unbound-libs-0__1.16.0-2.el8.aarch64//rpm",
         "@userspace-rcu-0__0.10.1-4.el8.aarch64//rpm",
         "@util-linux-0__2.32.1-35.el8.aarch64//rpm",
-        "@vim-minimal-2__8.0.1763-16.el8_5.12.aarch64//rpm",
+        "@vim-minimal-2__8.0.1763-19.el8.4.aarch64//rpm",
         "@xkeyboard-config-0__2.28-1.el8.aarch64//rpm",
         "@xorriso-0__1.4.8-4.el8.aarch64//rpm",
-        "@xz-0__5.2.4-3.el8.aarch64//rpm",
-        "@xz-libs-0__5.2.4-3.el8.aarch64//rpm",
-        "@yajl-0__2.1.0-10.el8.aarch64//rpm",
-        "@zlib-0__1.2.11-17.el8.aarch64//rpm",
+        "@xz-0__5.2.4-4.el8.aarch64//rpm",
+        "@xz-libs-0__5.2.4-4.el8.aarch64//rpm",
+        "@yajl-0__2.1.0-11.el8.aarch64//rpm",
+        "@zlib-0__1.2.11-19.el8.aarch64//rpm",
     ],
     symlinks = {
         "/var/run": "../run",
@@ -518,10 +519,10 @@ rpmtree(
     },
     rpms = [
         "@acl-0__2.2.53-1.el8.x86_64//rpm",
-        "@audit-libs-0__3.0.7-3.el8.x86_64//rpm",
+        "@audit-libs-0__3.0.7-4.el8.x86_64//rpm",
         "@autogen-libopts-0__5.18.12-8.el8.x86_64//rpm",
         "@basesystem-0__11-5.el8.x86_64//rpm",
-        "@bash-0__4.4.20-3.el8.x86_64//rpm",
+        "@bash-0__4.4.20-4.el8.x86_64//rpm",
         "@bzip2-0__1.0.6-26.el8.x86_64//rpm",
         "@bzip2-libs-0__1.0.6-26.el8.x86_64//rpm",
         "@ca-certificates-0__2021.2.50-82.el8.x86_64//rpm",
@@ -529,81 +530,81 @@ rpmtree(
         "@centos-stream-release-0__8.6-1.el8.x86_64//rpm",
         "@centos-stream-repos-0__8-6.el8.x86_64//rpm",
         "@chkconfig-0__1.19.1-1.el8.x86_64//rpm",
-        "@coreutils-single-0__8.30-12.el8.x86_64//rpm",
+        "@coreutils-single-0__8.30-13.el8.x86_64//rpm",
         "@cracklib-0__2.9.6-15.el8.x86_64//rpm",
         "@cracklib-dicts-0__2.9.6-15.el8.x86_64//rpm",
         "@crypto-policies-0__20211116-1.gitae470d6.el8.x86_64//rpm",
         "@cryptsetup-libs-0__2.3.7-2.el8.x86_64//rpm",
-        "@curl-0__7.61.1-22.el8.x86_64//rpm",
+        "@curl-0__7.61.1-25.el8.x86_64//rpm",
         "@cyrus-sasl-0__2.1.27-6.el8_5.x86_64//rpm",
         "@cyrus-sasl-gssapi-0__2.1.27-6.el8_5.x86_64//rpm",
         "@cyrus-sasl-lib-0__2.1.27-6.el8_5.x86_64//rpm",
-        "@daxctl-libs-0__71.1-3.el8.x86_64//rpm",
-        "@dbus-1__1.12.8-18.el8.x86_64//rpm",
-        "@dbus-common-1__1.12.8-18.el8.x86_64//rpm",
-        "@dbus-daemon-1__1.12.8-18.el8.x86_64//rpm",
-        "@dbus-libs-1__1.12.8-18.el8.x86_64//rpm",
-        "@dbus-tools-1__1.12.8-18.el8.x86_64//rpm",
+        "@daxctl-libs-0__71.1-4.el8.x86_64//rpm",
+        "@dbus-1__1.12.8-19.el8.x86_64//rpm",
+        "@dbus-common-1__1.12.8-19.el8.x86_64//rpm",
+        "@dbus-daemon-1__1.12.8-19.el8.x86_64//rpm",
+        "@dbus-libs-1__1.12.8-19.el8.x86_64//rpm",
+        "@dbus-tools-1__1.12.8-19.el8.x86_64//rpm",
         "@device-mapper-8__1.02.181-3.el8.x86_64//rpm",
         "@device-mapper-libs-8__1.02.181-3.el8.x86_64//rpm",
-        "@device-mapper-multipath-libs-0__0.8.4-22.el8.x86_64//rpm",
+        "@device-mapper-multipath-libs-0__0.8.4-26.el8.x86_64//rpm",
         "@diffutils-0__3.6-6.el8.x86_64//rpm",
         "@dmidecode-1__3.3-4.el8.x86_64//rpm",
         "@edk2-ovmf-0__20220126gitbb1bba3d77-2.el8.x86_64//rpm",
-        "@elfutils-default-yama-scope-0__0.186-1.el8.x86_64//rpm",
-        "@elfutils-libelf-0__0.186-1.el8.x86_64//rpm",
-        "@elfutils-libs-0__0.186-1.el8.x86_64//rpm",
-        "@ethtool-2__5.13-1.el8.x86_64//rpm",
-        "@expat-0__2.2.5-8.el8.x86_64//rpm",
+        "@elfutils-default-yama-scope-0__0.187-4.el8.x86_64//rpm",
+        "@elfutils-libelf-0__0.187-4.el8.x86_64//rpm",
+        "@elfutils-libs-0__0.187-4.el8.x86_64//rpm",
+        "@ethtool-2__5.13-2.el8.x86_64//rpm",
+        "@expat-0__2.2.5-9.el8.x86_64//rpm",
         "@filesystem-0__3.8-6.el8.x86_64//rpm",
         "@findutils-1__4.6.0-20.el8.x86_64//rpm",
         "@gawk-0__4.2.1-4.el8.x86_64//rpm",
         "@gettext-0__0.19.8.1-17.el8.x86_64//rpm",
         "@gettext-libs-0__0.19.8.1-17.el8.x86_64//rpm",
-        "@glib2-0__2.56.4-158.el8.x86_64//rpm",
-        "@glibc-0__2.28-196.el8.x86_64//rpm",
-        "@glibc-common-0__2.28-196.el8.x86_64//rpm",
-        "@glibc-minimal-langpack-0__2.28-196.el8.x86_64//rpm",
+        "@glib2-0__2.56.4-159.el8.x86_64//rpm",
+        "@glibc-0__2.28-208.el8.x86_64//rpm",
+        "@glibc-common-0__2.28-208.el8.x86_64//rpm",
+        "@glibc-minimal-langpack-0__2.28-208.el8.x86_64//rpm",
         "@gmp-1__6.1.2-10.el8.x86_64//rpm",
         "@gnutls-0__3.6.16-4.el8.x86_64//rpm",
         "@gnutls-dane-0__3.6.16-4.el8.x86_64//rpm",
         "@gnutls-utils-0__3.6.16-4.el8.x86_64//rpm",
         "@grep-0__3.1-6.el8.x86_64//rpm",
-        "@gzip-0__1.9-12.el8.x86_64//rpm",
+        "@gzip-0__1.9-13.el8.x86_64//rpm",
         "@info-0__6.5-7.el8_5.x86_64//rpm",
-        "@iproute-0__5.15.0-4.el8.x86_64//rpm",
-        "@iproute-tc-0__5.15.0-4.el8.x86_64//rpm",
+        "@iproute-0__5.18.0-1.el8.x86_64//rpm",
+        "@iproute-tc-0__5.18.0-1.el8.x86_64//rpm",
         "@iptables-0__1.8.4-22.el8.x86_64//rpm",
         "@iptables-libs-0__1.8.4-22.el8.x86_64//rpm",
-        "@ipxe-roms-qemu-0__20181214-8.git133f4c47.el8.x86_64//rpm",
+        "@ipxe-roms-qemu-0__20181214-9.git133f4c47.el8.x86_64//rpm",
         "@jansson-0__2.14-1.el8.x86_64//rpm",
         "@json-c-0__0.13.1-3.el8.x86_64//rpm",
         "@json-glib-0__1.4.4-1.el8.x86_64//rpm",
         "@keyutils-libs-0__1.5.10-9.el8.x86_64//rpm",
         "@kmod-0__25-19.el8.x86_64//rpm",
         "@kmod-libs-0__25-19.el8.x86_64//rpm",
-        "@krb5-libs-0__1.18.2-14.el8.x86_64//rpm",
+        "@krb5-libs-0__1.18.2-21.el8.x86_64//rpm",
         "@libacl-0__2.2.53-1.el8.x86_64//rpm",
         "@libaio-0__0.3.112-1.el8.x86_64//rpm",
-        "@libarchive-0__3.3.3-3.el8_5.x86_64//rpm",
+        "@libarchive-0__3.3.3-4.el8.x86_64//rpm",
         "@libattr-0__2.4.48-3.el8.x86_64//rpm",
         "@libblkid-0__2.32.1-35.el8.x86_64//rpm",
-        "@libbpf-0__0.4.0-3.el8.x86_64//rpm",
+        "@libbpf-0__0.5.0-1.el8.x86_64//rpm",
         "@libburn-0__1.4.8-3.el8.x86_64//rpm",
-        "@libcap-0__2.48-2.el8.x86_64//rpm",
+        "@libcap-0__2.48-4.el8.x86_64//rpm",
         "@libcap-ng-0__0.7.11-1.el8.x86_64//rpm",
-        "@libcom_err-0__1.45.6-4.el8.x86_64//rpm",
+        "@libcom_err-0__1.45.6-5.el8.x86_64//rpm",
         "@libcroco-0__0.6.12-4.el8_2.1.x86_64//rpm",
-        "@libcurl-minimal-0__7.61.1-22.el8.x86_64//rpm",
+        "@libcurl-minimal-0__7.61.1-25.el8.x86_64//rpm",
         "@libdb-0__5.3.28-42.el8_4.x86_64//rpm",
         "@libdb-utils-0__5.3.28-42.el8_4.x86_64//rpm",
         "@libevent-0__2.1.8-5.el8.x86_64//rpm",
         "@libfdisk-0__2.32.1-35.el8.x86_64//rpm",
         "@libfdt-0__1.6.0-1.el8.x86_64//rpm",
         "@libffi-0__3.1-23.el8.x86_64//rpm",
-        "@libgcc-0__8.5.0-10.el8.x86_64//rpm",
-        "@libgcrypt-0__1.8.5-6.el8.x86_64//rpm",
-        "@libgomp-0__8.5.0-10.el8.x86_64//rpm",
+        "@libgcc-0__8.5.0-15.el8.x86_64//rpm",
+        "@libgcrypt-0__1.8.5-7.el8.x86_64//rpm",
+        "@libgomp-0__8.5.0-15.el8.x86_64//rpm",
         "@libgpg-error-0__1.31-1.el8.x86_64//rpm",
         "@libibverbs-0__37.2-1.el8.x86_64//rpm",
         "@libidn2-0__2.2.0-1.el8.x86_64//rpm",
@@ -615,7 +616,7 @@ rpmtree(
         "@libnfnetlink-0__1.0.1-13.el8.x86_64//rpm",
         "@libnftnl-0__1.1.5-5.el8.x86_64//rpm",
         "@libnghttp2-0__1.33.0-3.el8_2.1.x86_64//rpm",
-        "@libnl3-0__3.5.0-1.el8.x86_64//rpm",
+        "@libnl3-0__3.7.0-1.el8.x86_64//rpm",
         "@libnsl2-0__1.2.0-2.20180605git4a062cf.el8.x86_64//rpm",
         "@libpcap-14__1.9.1-5.el8.x86_64//rpm",
         "@libpmem-0__1.11.1-1.module_el8.6.0__plus__1088__plus__6891f51c.x86_64//rpm",
@@ -631,22 +632,22 @@ rpmtree(
         "@libsmartcols-0__2.32.1-35.el8.x86_64//rpm",
         "@libssh-0__0.9.6-3.el8.x86_64//rpm",
         "@libssh-config-0__0.9.6-3.el8.x86_64//rpm",
-        "@libstdc__plus____plus__-0__8.5.0-10.el8.x86_64//rpm",
+        "@libstdc__plus____plus__-0__8.5.0-15.el8.x86_64//rpm",
         "@libtasn1-0__4.13-3.el8.x86_64//rpm",
-        "@libtirpc-0__1.1.4-6.el8.x86_64//rpm",
+        "@libtirpc-0__1.1.4-7.el8.x86_64//rpm",
         "@libtpms-0__0.9.1-0.20211126git1ff6fe1f43.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@libunistring-0__0.9.9-3.el8.x86_64//rpm",
         "@libusbx-0__1.0.23-4.el8.x86_64//rpm",
         "@libutempter-0__1.1.6-14.el8.x86_64//rpm",
         "@libuuid-0__2.32.1-35.el8.x86_64//rpm",
-        "@libverto-0__0.3.0-5.el8.x86_64//rpm",
+        "@libverto-0__0.3.2-2.el8.x86_64//rpm",
         "@libvirt-client-0__8.0.0-2.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@libvirt-daemon-0__8.0.0-2.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@libvirt-daemon-driver-qemu-0__8.0.0-2.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@libvirt-libs-0__8.0.0-2.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@libxcrypt-0__4.1.1-6.el8.x86_64//rpm",
         "@libxkbcommon-0__0.9.1-1.el8.x86_64//rpm",
-        "@libxml2-0__2.9.7-13.el8.x86_64//rpm",
+        "@libxml2-0__2.9.7-14.el8.x86_64//rpm",
         "@libzstd-0__1.4.4-1.el8.x86_64//rpm",
         "@lua-libs-0__5.3.4-12.el8.x86_64//rpm",
         "@lz4-libs-0__1.8.3-3.el8_4.x86_64//rpm",
@@ -655,23 +656,23 @@ rpmtree(
         "@mpfr-0__3.1.6-1.el8.x86_64//rpm",
         "@ncurses-base-0__6.1-9.20180224.el8.x86_64//rpm",
         "@ncurses-libs-0__6.1-9.20180224.el8.x86_64//rpm",
-        "@ndctl-libs-0__71.1-3.el8.x86_64//rpm",
+        "@ndctl-libs-0__71.1-4.el8.x86_64//rpm",
         "@nettle-0__3.4.1-7.el8.x86_64//rpm",
-        "@nftables-1__0.9.3-25.el8.x86_64//rpm",
-        "@nmap-ncat-2__7.70-6.el8.x86_64//rpm",
+        "@nftables-1__0.9.3-26.el8.x86_64//rpm",
+        "@nmap-ncat-2__7.70-7.el8.x86_64//rpm",
         "@numactl-libs-0__2.0.12-13.el8.x86_64//rpm",
         "@numad-0__0.5-26.20150602git.el8.x86_64//rpm",
         "@openldap-0__2.4.46-18.el8.x86_64//rpm",
         "@openssl-libs-1__1.1.1k-6.el8.x86_64//rpm",
         "@p11-kit-0__0.23.22-1.el8.x86_64//rpm",
         "@p11-kit-trust-0__0.23.22-1.el8.x86_64//rpm",
-        "@pam-0__1.3.1-16.el8.x86_64//rpm",
+        "@pam-0__1.3.1-22.el8.x86_64//rpm",
         "@pcre-0__8.42-6.el8.x86_64//rpm",
-        "@pcre2-0__10.32-2.el8.x86_64//rpm",
+        "@pcre2-0__10.32-3.el8.x86_64//rpm",
         "@pixman-0__0.38.4-2.el8.x86_64//rpm",
         "@policycoreutils-0__2.9-19.el8.x86_64//rpm",
-        "@polkit-0__0.115-13.el8_5.1.x86_64//rpm",
-        "@polkit-libs-0__0.115-13.el8_5.1.x86_64//rpm",
+        "@polkit-0__0.115-13.0.1.el8.2.x86_64//rpm",
+        "@polkit-libs-0__0.115-13.0.1.el8.2.x86_64//rpm",
         "@polkit-pkla-compat-0__0.1-12.el8.x86_64//rpm",
         "@popt-0__1.18-1.el8.x86_64//rpm",
         "@procps-ng-0__3.3.15-7.el8.x86_64//rpm",
@@ -681,16 +682,16 @@ rpmtree(
         "@qemu-kvm-core-15__6.2.0-5.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@qemu-kvm-hw-usbredir-15__6.2.0-5.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@readline-0__7.0-10.el8.x86_64//rpm",
-        "@rpm-0__4.14.3-22.el8.x86_64//rpm",
-        "@rpm-libs-0__4.14.3-22.el8.x86_64//rpm",
-        "@rpm-plugin-selinux-0__4.14.3-22.el8.x86_64//rpm",
+        "@rpm-0__4.14.3-23.el8.x86_64//rpm",
+        "@rpm-libs-0__4.14.3-23.el8.x86_64//rpm",
+        "@rpm-plugin-selinux-0__4.14.3-23.el8.x86_64//rpm",
         "@seabios-0__1.15.0-1.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@seabios-bin-0__1.15.0-1.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@seavgabios-bin-0__1.15.0-1.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@sed-0__4.5-5.el8.x86_64//rpm",
-        "@selinux-policy-0__3.14.3-95.el8.x86_64//rpm",
-        "@selinux-policy-targeted-0__3.14.3-95.el8.x86_64//rpm",
-        "@setup-0__2.12.2-6.el8.x86_64//rpm",
+        "@selinux-policy-0__3.14.3-104.el8.x86_64//rpm",
+        "@selinux-policy-targeted-0__3.14.3-104.el8.x86_64//rpm",
+        "@setup-0__2.12.2-7.el8.x86_64//rpm",
         "@sgabios-bin-1__0.20170427git-3.module_el8.6.0__plus__983__plus__a7505f3f.x86_64//rpm",
         "@shadow-utils-2__4.6-16.el8.x86_64//rpm",
         "@snappy-0__1.1.8-3.el8.x86_64//rpm",
@@ -698,23 +699,24 @@ rpmtree(
         "@swtpm-0__0.7.0-1.20211109gitb79fd91.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@swtpm-libs-0__0.7.0-1.20211109gitb79fd91.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@swtpm-tools-0__0.7.0-1.20211109gitb79fd91.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
-        "@systemd-0__239-58.el8.x86_64//rpm",
-        "@systemd-container-0__239-58.el8.x86_64//rpm",
-        "@systemd-libs-0__239-58.el8.x86_64//rpm",
-        "@systemd-pam-0__239-58.el8.x86_64//rpm",
-        "@tar-2__1.30-5.el8.x86_64//rpm",
-        "@tzdata-0__2022a-1.el8.x86_64//rpm",
-        "@unbound-libs-0__1.7.3-17.el8.x86_64//rpm",
+        "@systemd-0__239-60.el8.x86_64//rpm",
+        "@systemd-container-0__239-60.el8.x86_64//rpm",
+        "@systemd-libs-0__239-60.el8.x86_64//rpm",
+        "@systemd-pam-0__239-60.el8.x86_64//rpm",
+        "@tar-2__1.30-6.el8.x86_64//rpm",
+        "@timedatex-0__0.5-3.el8.x86_64//rpm",
+        "@tzdata-0__2022a-2.el8.x86_64//rpm",
+        "@unbound-libs-0__1.16.0-2.el8.x86_64//rpm",
         "@usbredir-0__0.12.0-1.el8.x86_64//rpm",
         "@userspace-rcu-0__0.10.1-4.el8.x86_64//rpm",
         "@util-linux-0__2.32.1-35.el8.x86_64//rpm",
-        "@vim-minimal-2__8.0.1763-16.el8_5.12.x86_64//rpm",
+        "@vim-minimal-2__8.0.1763-19.el8.4.x86_64//rpm",
         "@xkeyboard-config-0__2.28-1.el8.x86_64//rpm",
         "@xorriso-0__1.4.8-4.el8.x86_64//rpm",
-        "@xz-0__5.2.4-3.el8.x86_64//rpm",
-        "@xz-libs-0__5.2.4-3.el8.x86_64//rpm",
-        "@yajl-0__2.1.0-10.el8.x86_64//rpm",
-        "@zlib-0__1.2.11-17.el8.x86_64//rpm",
+        "@xz-0__5.2.4-4.el8.x86_64//rpm",
+        "@xz-libs-0__5.2.4-4.el8.x86_64//rpm",
+        "@yajl-0__2.1.0-11.el8.x86_64//rpm",
+        "@zlib-0__1.2.11-19.el8.x86_64//rpm",
     ],
     symlinks = {
         "/var/run": "../run",
@@ -730,10 +732,10 @@ rpmtree(
     name = "libguestfs-tools",
     rpms = [
         "@acl-0__2.2.53-1.el8.x86_64//rpm",
-        "@audit-libs-0__3.0.7-3.el8.x86_64//rpm",
+        "@audit-libs-0__3.0.7-4.el8.x86_64//rpm",
         "@augeas-libs-0__1.12.0-7.el8.x86_64//rpm",
         "@basesystem-0__11-5.el8.x86_64//rpm",
-        "@bash-0__4.4.20-3.el8.x86_64//rpm",
+        "@bash-0__4.4.20-4.el8.x86_64//rpm",
         "@bzip2-0__1.0.6-26.el8.x86_64//rpm",
         "@bzip2-libs-0__1.0.6-26.el8.x86_64//rpm",
         "@ca-certificates-0__2021.2.50-82.el8.x86_64//rpm",
@@ -741,83 +743,83 @@ rpmtree(
         "@centos-stream-release-0__8.6-1.el8.x86_64//rpm",
         "@centos-stream-repos-0__8-6.el8.x86_64//rpm",
         "@chkconfig-0__1.19.1-1.el8.x86_64//rpm",
-        "@coreutils-single-0__8.30-12.el8.x86_64//rpm",
+        "@coreutils-single-0__8.30-13.el8.x86_64//rpm",
         "@cracklib-0__2.9.6-15.el8.x86_64//rpm",
         "@cracklib-dicts-0__2.9.6-15.el8.x86_64//rpm",
         "@crypto-policies-0__20211116-1.gitae470d6.el8.x86_64//rpm",
         "@cryptsetup-libs-0__2.3.7-2.el8.x86_64//rpm",
-        "@curl-0__7.61.1-22.el8.x86_64//rpm",
+        "@curl-0__7.61.1-25.el8.x86_64//rpm",
         "@cyrus-sasl-0__2.1.27-6.el8_5.x86_64//rpm",
         "@cyrus-sasl-gssapi-0__2.1.27-6.el8_5.x86_64//rpm",
         "@cyrus-sasl-lib-0__2.1.27-6.el8_5.x86_64//rpm",
-        "@daxctl-libs-0__71.1-3.el8.x86_64//rpm",
+        "@daxctl-libs-0__71.1-4.el8.x86_64//rpm",
         "@device-mapper-8__1.02.181-3.el8.x86_64//rpm",
         "@device-mapper-event-8__1.02.181-3.el8.x86_64//rpm",
         "@device-mapper-event-libs-8__1.02.181-3.el8.x86_64//rpm",
         "@device-mapper-libs-8__1.02.181-3.el8.x86_64//rpm",
-        "@device-mapper-multipath-libs-0__0.8.4-22.el8.x86_64//rpm",
-        "@device-mapper-persistent-data-0__0.9.0-6.el8.x86_64//rpm",
+        "@device-mapper-multipath-libs-0__0.8.4-26.el8.x86_64//rpm",
+        "@device-mapper-persistent-data-0__0.9.0-7.el8.x86_64//rpm",
         "@dmidecode-1__3.3-4.el8.x86_64//rpm",
         "@edk2-ovmf-0__20220126gitbb1bba3d77-2.el8.x86_64//rpm",
-        "@elfutils-default-yama-scope-0__0.186-1.el8.x86_64//rpm",
-        "@elfutils-libelf-0__0.186-1.el8.x86_64//rpm",
-        "@elfutils-libs-0__0.186-1.el8.x86_64//rpm",
-        "@expat-0__2.2.5-8.el8.x86_64//rpm",
+        "@elfutils-default-yama-scope-0__0.187-4.el8.x86_64//rpm",
+        "@elfutils-libelf-0__0.187-4.el8.x86_64//rpm",
+        "@elfutils-libs-0__0.187-4.el8.x86_64//rpm",
+        "@expat-0__2.2.5-9.el8.x86_64//rpm",
         "@file-0__5.33-20.el8.x86_64//rpm",
         "@file-libs-0__5.33-20.el8.x86_64//rpm",
         "@filesystem-0__3.8-6.el8.x86_64//rpm",
-        "@fuse-0__2.9.7-15.el8.x86_64//rpm",
-        "@fuse-common-0__3.3.0-15.el8.x86_64//rpm",
-        "@fuse-libs-0__2.9.7-15.el8.x86_64//rpm",
+        "@fuse-0__2.9.7-16.el8.x86_64//rpm",
+        "@fuse-common-0__3.3.0-16.el8.x86_64//rpm",
+        "@fuse-libs-0__2.9.7-16.el8.x86_64//rpm",
         "@gawk-0__4.2.1-4.el8.x86_64//rpm",
-        "@gdbm-libs-1__1.18-1.el8.x86_64//rpm",
+        "@gdbm-libs-1__1.18-2.el8.x86_64//rpm",
         "@gettext-0__0.19.8.1-17.el8.x86_64//rpm",
         "@gettext-libs-0__0.19.8.1-17.el8.x86_64//rpm",
-        "@glib2-0__2.56.4-158.el8.x86_64//rpm",
-        "@glibc-0__2.28-196.el8.x86_64//rpm",
-        "@glibc-common-0__2.28-196.el8.x86_64//rpm",
-        "@glibc-minimal-langpack-0__2.28-196.el8.x86_64//rpm",
+        "@glib2-0__2.56.4-159.el8.x86_64//rpm",
+        "@glibc-0__2.28-208.el8.x86_64//rpm",
+        "@glibc-common-0__2.28-208.el8.x86_64//rpm",
+        "@glibc-minimal-langpack-0__2.28-208.el8.x86_64//rpm",
         "@gmp-1__6.1.2-10.el8.x86_64//rpm",
         "@gnupg2-0__2.2.20-2.el8.x86_64//rpm",
         "@gnutls-0__3.6.16-4.el8.x86_64//rpm",
         "@grep-0__3.1-6.el8.x86_64//rpm",
         "@groff-base-0__1.22.3-18.el8.x86_64//rpm",
-        "@gzip-0__1.9-12.el8.x86_64//rpm",
+        "@gzip-0__1.9-13.el8.x86_64//rpm",
         "@hexedit-0__1.2.13-12.el8.x86_64//rpm",
         "@hivex-0__1.3.18-23.module_el8.6.0__plus__983__plus__a7505f3f.x86_64//rpm",
         "@info-0__6.5-7.el8_5.x86_64//rpm",
-        "@iproute-0__5.15.0-4.el8.x86_64//rpm",
-        "@iproute-tc-0__5.15.0-4.el8.x86_64//rpm",
+        "@iproute-0__5.18.0-1.el8.x86_64//rpm",
+        "@iproute-tc-0__5.18.0-1.el8.x86_64//rpm",
         "@iptables-libs-0__1.8.4-22.el8.x86_64//rpm",
-        "@ipxe-roms-qemu-0__20181214-8.git133f4c47.el8.x86_64//rpm",
+        "@ipxe-roms-qemu-0__20181214-9.git133f4c47.el8.x86_64//rpm",
         "@jansson-0__2.14-1.el8.x86_64//rpm",
         "@json-c-0__0.13.1-3.el8.x86_64//rpm",
         "@keyutils-libs-0__1.5.10-9.el8.x86_64//rpm",
         "@kmod-0__25-19.el8.x86_64//rpm",
         "@kmod-libs-0__25-19.el8.x86_64//rpm",
-        "@krb5-libs-0__1.18.2-14.el8.x86_64//rpm",
+        "@krb5-libs-0__1.18.2-21.el8.x86_64//rpm",
         "@less-0__530-1.el8.x86_64//rpm",
         "@libacl-0__2.2.53-1.el8.x86_64//rpm",
         "@libaio-0__0.3.112-1.el8.x86_64//rpm",
-        "@libarchive-0__3.3.3-3.el8_5.x86_64//rpm",
+        "@libarchive-0__3.3.3-4.el8.x86_64//rpm",
         "@libassuan-0__2.5.1-3.el8.x86_64//rpm",
         "@libattr-0__2.4.48-3.el8.x86_64//rpm",
         "@libblkid-0__2.32.1-35.el8.x86_64//rpm",
-        "@libbpf-0__0.4.0-3.el8.x86_64//rpm",
-        "@libcap-0__2.48-2.el8.x86_64//rpm",
+        "@libbpf-0__0.5.0-1.el8.x86_64//rpm",
+        "@libcap-0__2.48-4.el8.x86_64//rpm",
         "@libcap-ng-0__0.7.11-1.el8.x86_64//rpm",
-        "@libcom_err-0__1.45.6-4.el8.x86_64//rpm",
+        "@libcom_err-0__1.45.6-5.el8.x86_64//rpm",
         "@libconfig-0__1.5-9.el8.x86_64//rpm",
         "@libcroco-0__0.6.12-4.el8_2.1.x86_64//rpm",
-        "@libcurl-minimal-0__7.61.1-22.el8.x86_64//rpm",
+        "@libcurl-minimal-0__7.61.1-25.el8.x86_64//rpm",
         "@libdb-0__5.3.28-42.el8_4.x86_64//rpm",
         "@libdb-utils-0__5.3.28-42.el8_4.x86_64//rpm",
         "@libfdisk-0__2.32.1-35.el8.x86_64//rpm",
         "@libfdt-0__1.6.0-1.el8.x86_64//rpm",
         "@libffi-0__3.1-23.el8.x86_64//rpm",
-        "@libgcc-0__8.5.0-10.el8.x86_64//rpm",
-        "@libgcrypt-0__1.8.5-6.el8.x86_64//rpm",
-        "@libgomp-0__8.5.0-10.el8.x86_64//rpm",
+        "@libgcc-0__8.5.0-15.el8.x86_64//rpm",
+        "@libgcrypt-0__1.8.5-7.el8.x86_64//rpm",
+        "@libgomp-0__8.5.0-15.el8.x86_64//rpm",
         "@libgpg-error-0__1.31-1.el8.x86_64//rpm",
         "@libguestfs-1__1.44.0-5.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@libguestfs-tools-1__1.44.0-5.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
@@ -828,7 +830,7 @@ rpmtree(
         "@libmnl-0__1.0.4-6.el8.x86_64//rpm",
         "@libmount-0__2.32.1-35.el8.x86_64//rpm",
         "@libnghttp2-0__1.33.0-3.el8_2.1.x86_64//rpm",
-        "@libnl3-0__3.5.0-1.el8.x86_64//rpm",
+        "@libnl3-0__3.7.0-1.el8.x86_64//rpm",
         "@libnsl2-0__1.2.0-2.20180605git4a062cf.el8.x86_64//rpm",
         "@libpcap-14__1.9.1-5.el8.x86_64//rpm",
         "@libpmem-0__1.11.1-1.module_el8.6.0__plus__1088__plus__6891f51c.x86_64//rpm",
@@ -843,20 +845,20 @@ rpmtree(
         "@libsmartcols-0__2.32.1-35.el8.x86_64//rpm",
         "@libssh-0__0.9.6-3.el8.x86_64//rpm",
         "@libssh-config-0__0.9.6-3.el8.x86_64//rpm",
-        "@libstdc__plus____plus__-0__8.5.0-10.el8.x86_64//rpm",
+        "@libstdc__plus____plus__-0__8.5.0-15.el8.x86_64//rpm",
         "@libtasn1-0__4.13-3.el8.x86_64//rpm",
-        "@libtirpc-0__1.1.4-6.el8.x86_64//rpm",
+        "@libtirpc-0__1.1.4-7.el8.x86_64//rpm",
         "@libunistring-0__0.9.9-3.el8.x86_64//rpm",
         "@libusbx-0__1.0.23-4.el8.x86_64//rpm",
         "@libutempter-0__1.1.6-14.el8.x86_64//rpm",
         "@libuuid-0__2.32.1-35.el8.x86_64//rpm",
-        "@libverto-0__0.3.0-5.el8.x86_64//rpm",
+        "@libverto-0__0.3.2-2.el8.x86_64//rpm",
         "@libvirt-daemon-0__8.0.0-2.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@libvirt-daemon-driver-qemu-0__8.0.0-2.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@libvirt-libs-0__8.0.0-2.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@libxcrypt-0__4.1.1-6.el8.x86_64//rpm",
         "@libxkbcommon-0__0.9.1-1.el8.x86_64//rpm",
-        "@libxml2-0__2.9.7-13.el8.x86_64//rpm",
+        "@libxml2-0__2.9.7-14.el8.x86_64//rpm",
         "@libzstd-0__1.4.4-1.el8.x86_64//rpm",
         "@lua-libs-0__5.3.4-12.el8.x86_64//rpm",
         "@lvm2-8__2.03.14-3.el8.x86_64//rpm",
@@ -868,7 +870,7 @@ rpmtree(
         "@ncurses-0__6.1-9.20180224.el8.x86_64//rpm",
         "@ncurses-base-0__6.1-9.20180224.el8.x86_64//rpm",
         "@ncurses-libs-0__6.1-9.20180224.el8.x86_64//rpm",
-        "@ndctl-libs-0__71.1-3.el8.x86_64//rpm",
+        "@ndctl-libs-0__71.1-4.el8.x86_64//rpm",
         "@nettle-0__3.4.1-7.el8.x86_64//rpm",
         "@npth-0__1.5-4.el8.x86_64//rpm",
         "@numactl-libs-0__2.0.12-13.el8.x86_64//rpm",
@@ -877,9 +879,9 @@ rpmtree(
         "@openssl-libs-1__1.1.1k-6.el8.x86_64//rpm",
         "@p11-kit-0__0.23.22-1.el8.x86_64//rpm",
         "@p11-kit-trust-0__0.23.22-1.el8.x86_64//rpm",
-        "@pam-0__1.3.1-16.el8.x86_64//rpm",
+        "@pam-0__1.3.1-22.el8.x86_64//rpm",
         "@pcre-0__8.42-6.el8.x86_64//rpm",
-        "@pcre2-0__10.32-2.el8.x86_64//rpm",
+        "@pcre2-0__10.32-3.el8.x86_64//rpm",
         "@perl-Carp-0__1.42-396.el8.x86_64//rpm",
         "@perl-Encode-4__2.97-3.el8.x86_64//rpm",
         "@perl-Errno-0__1.28-421.el8.x86_64//rpm",
@@ -916,10 +918,10 @@ rpmtree(
         "@perl-threads-1__2.21-2.el8.x86_64//rpm",
         "@perl-threads-shared-0__1.58-2.el8.x86_64//rpm",
         "@pixman-0__0.38.4-2.el8.x86_64//rpm",
-        "@platform-python-0__3.6.8-46.el8.x86_64//rpm",
+        "@platform-python-0__3.6.8-47.el8.x86_64//rpm",
         "@platform-python-setuptools-0__39.2.0-6.el8.x86_64//rpm",
-        "@polkit-0__0.115-13.el8_5.1.x86_64//rpm",
-        "@polkit-libs-0__0.115-13.el8_5.1.x86_64//rpm",
+        "@polkit-0__0.115-13.0.1.el8.2.x86_64//rpm",
+        "@polkit-libs-0__0.115-13.0.1.el8.2.x86_64//rpm",
         "@polkit-pkla-compat-0__0.1-12.el8.x86_64//rpm",
         "@popt-0__1.18-1.el8.x86_64//rpm",
         "@psmisc-0__23.1-5.el8.x86_64//rpm",
@@ -927,32 +929,33 @@ rpmtree(
         "@qemu-kvm-common-15__6.2.0-5.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@qemu-kvm-core-15__6.2.0-5.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@readline-0__7.0-10.el8.x86_64//rpm",
-        "@rpm-0__4.14.3-22.el8.x86_64//rpm",
-        "@rpm-libs-0__4.14.3-22.el8.x86_64//rpm",
+        "@rpm-0__4.14.3-23.el8.x86_64//rpm",
+        "@rpm-libs-0__4.14.3-23.el8.x86_64//rpm",
         "@seabios-0__1.15.0-1.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@seabios-bin-0__1.15.0-1.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@seavgabios-bin-0__1.15.0-1.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@sed-0__4.5-5.el8.x86_64//rpm",
-        "@setup-0__2.12.2-6.el8.x86_64//rpm",
+        "@setup-0__2.12.2-7.el8.x86_64//rpm",
         "@sgabios-bin-1__0.20170427git-3.module_el8.6.0__plus__983__plus__a7505f3f.x86_64//rpm",
         "@shadow-utils-2__4.6-16.el8.x86_64//rpm",
         "@snappy-0__1.1.8-3.el8.x86_64//rpm",
         "@sqlite-libs-0__3.26.0-15.el8.x86_64//rpm",
-        "@systemd-0__239-58.el8.x86_64//rpm",
-        "@systemd-container-0__239-58.el8.x86_64//rpm",
-        "@systemd-libs-0__239-58.el8.x86_64//rpm",
-        "@systemd-pam-0__239-58.el8.x86_64//rpm",
-        "@tar-2__1.30-5.el8.x86_64//rpm",
-        "@tzdata-0__2022a-1.el8.x86_64//rpm",
+        "@systemd-0__239-60.el8.x86_64//rpm",
+        "@systemd-container-0__239-60.el8.x86_64//rpm",
+        "@systemd-libs-0__239-60.el8.x86_64//rpm",
+        "@systemd-pam-0__239-60.el8.x86_64//rpm",
+        "@tar-2__1.30-6.el8.x86_64//rpm",
+        "@timedatex-0__0.5-3.el8.x86_64//rpm",
+        "@tzdata-0__2022a-2.el8.x86_64//rpm",
         "@userspace-rcu-0__0.10.1-4.el8.x86_64//rpm",
         "@util-linux-0__2.32.1-35.el8.x86_64//rpm",
-        "@vim-minimal-2__8.0.1763-16.el8_5.12.x86_64//rpm",
-        "@which-0__2.21-17.el8.x86_64//rpm",
+        "@vim-minimal-2__8.0.1763-19.el8.4.x86_64//rpm",
+        "@which-0__2.21-18.el8.x86_64//rpm",
         "@xkeyboard-config-0__2.28-1.el8.x86_64//rpm",
-        "@xz-0__5.2.4-3.el8.x86_64//rpm",
-        "@xz-libs-0__5.2.4-3.el8.x86_64//rpm",
-        "@yajl-0__2.1.0-10.el8.x86_64//rpm",
-        "@zlib-0__1.2.11-17.el8.x86_64//rpm",
+        "@xz-0__5.2.4-4.el8.x86_64//rpm",
+        "@xz-libs-0__5.2.4-4.el8.x86_64//rpm",
+        "@yajl-0__2.1.0-11.el8.x86_64//rpm",
+        "@zlib-0__1.2.11-19.el8.x86_64//rpm",
     ],
     symlinks = {
         "/var/run": "../run",
@@ -966,67 +969,67 @@ rpmtree(
     name = "libvirt-devel_aarch64",
     rpms = [
         "@acl-0__2.2.53-1.el8.aarch64//rpm",
-        "@audit-libs-0__3.0.7-3.el8.aarch64//rpm",
+        "@audit-libs-0__3.0.7-4.el8.aarch64//rpm",
         "@basesystem-0__11-5.el8.aarch64//rpm",
-        "@bash-0__4.4.20-3.el8.aarch64//rpm",
+        "@bash-0__4.4.20-4.el8.aarch64//rpm",
         "@bzip2-libs-0__1.0.6-26.el8.aarch64//rpm",
         "@ca-certificates-0__2021.2.50-82.el8.aarch64//rpm",
         "@centos-gpg-keys-1__8-6.el8.aarch64//rpm",
         "@centos-stream-release-0__8.6-1.el8.aarch64//rpm",
         "@centos-stream-repos-0__8-6.el8.aarch64//rpm",
         "@chkconfig-0__1.19.1-1.el8.aarch64//rpm",
-        "@coreutils-single-0__8.30-12.el8.aarch64//rpm",
+        "@coreutils-single-0__8.30-13.el8.aarch64//rpm",
         "@cracklib-0__2.9.6-15.el8.aarch64//rpm",
         "@cracklib-dicts-0__2.9.6-15.el8.aarch64//rpm",
         "@crypto-policies-0__20211116-1.gitae470d6.el8.aarch64//rpm",
         "@cryptsetup-libs-0__2.3.7-2.el8.aarch64//rpm",
-        "@curl-0__7.61.1-22.el8.aarch64//rpm",
+        "@curl-0__7.61.1-25.el8.aarch64//rpm",
         "@cyrus-sasl-0__2.1.27-6.el8_5.aarch64//rpm",
         "@cyrus-sasl-gssapi-0__2.1.27-6.el8_5.aarch64//rpm",
         "@cyrus-sasl-lib-0__2.1.27-6.el8_5.aarch64//rpm",
-        "@dbus-1__1.12.8-18.el8.aarch64//rpm",
-        "@dbus-common-1__1.12.8-18.el8.aarch64//rpm",
-        "@dbus-daemon-1__1.12.8-18.el8.aarch64//rpm",
-        "@dbus-libs-1__1.12.8-18.el8.aarch64//rpm",
-        "@dbus-tools-1__1.12.8-18.el8.aarch64//rpm",
+        "@dbus-1__1.12.8-19.el8.aarch64//rpm",
+        "@dbus-common-1__1.12.8-19.el8.aarch64//rpm",
+        "@dbus-daemon-1__1.12.8-19.el8.aarch64//rpm",
+        "@dbus-libs-1__1.12.8-19.el8.aarch64//rpm",
+        "@dbus-tools-1__1.12.8-19.el8.aarch64//rpm",
         "@device-mapper-8__1.02.181-3.el8.aarch64//rpm",
         "@device-mapper-libs-8__1.02.181-3.el8.aarch64//rpm",
-        "@elfutils-default-yama-scope-0__0.186-1.el8.aarch64//rpm",
-        "@elfutils-libelf-0__0.186-1.el8.aarch64//rpm",
-        "@elfutils-libs-0__0.186-1.el8.aarch64//rpm",
-        "@expat-0__2.2.5-8.el8.aarch64//rpm",
+        "@elfutils-default-yama-scope-0__0.187-4.el8.aarch64//rpm",
+        "@elfutils-libelf-0__0.187-4.el8.aarch64//rpm",
+        "@elfutils-libs-0__0.187-4.el8.aarch64//rpm",
+        "@expat-0__2.2.5-9.el8.aarch64//rpm",
         "@filesystem-0__3.8-6.el8.aarch64//rpm",
         "@gawk-0__4.2.1-4.el8.aarch64//rpm",
-        "@glib2-0__2.56.4-158.el8.aarch64//rpm",
-        "@glibc-0__2.28-196.el8.aarch64//rpm",
-        "@glibc-common-0__2.28-196.el8.aarch64//rpm",
-        "@glibc-minimal-langpack-0__2.28-196.el8.aarch64//rpm",
+        "@glib2-0__2.56.4-159.el8.aarch64//rpm",
+        "@glibc-0__2.28-208.el8.aarch64//rpm",
+        "@glibc-common-0__2.28-208.el8.aarch64//rpm",
+        "@glibc-minimal-langpack-0__2.28-208.el8.aarch64//rpm",
         "@gmp-1__6.1.2-10.el8.aarch64//rpm",
         "@gnutls-0__3.6.16-4.el8.aarch64//rpm",
         "@grep-0__3.1-6.el8.aarch64//rpm",
-        "@gzip-0__1.9-12.el8.aarch64//rpm",
+        "@gzip-0__1.9-13.el8.aarch64//rpm",
         "@info-0__6.5-7.el8_5.aarch64//rpm",
         "@json-c-0__0.13.1-3.el8.aarch64//rpm",
         "@keyutils-libs-0__1.5.10-9.el8.aarch64//rpm",
         "@kmod-libs-0__25-19.el8.aarch64//rpm",
-        "@krb5-libs-0__1.18.2-14.el8.aarch64//rpm",
+        "@krb5-libs-0__1.18.2-21.el8.aarch64//rpm",
         "@libacl-0__2.2.53-1.el8.aarch64//rpm",
         "@libattr-0__2.4.48-3.el8.aarch64//rpm",
         "@libblkid-0__2.32.1-35.el8.aarch64//rpm",
-        "@libcap-0__2.48-2.el8.aarch64//rpm",
+        "@libcap-0__2.48-4.el8.aarch64//rpm",
         "@libcap-ng-0__0.7.11-1.el8.aarch64//rpm",
-        "@libcom_err-0__1.45.6-4.el8.aarch64//rpm",
-        "@libcurl-minimal-0__7.61.1-22.el8.aarch64//rpm",
+        "@libcom_err-0__1.45.6-5.el8.aarch64//rpm",
+        "@libcurl-minimal-0__7.61.1-25.el8.aarch64//rpm",
         "@libdb-0__5.3.28-42.el8_4.aarch64//rpm",
         "@libfdisk-0__2.32.1-35.el8.aarch64//rpm",
         "@libffi-0__3.1-23.el8.aarch64//rpm",
-        "@libgcc-0__8.5.0-10.el8.aarch64//rpm",
-        "@libgcrypt-0__1.8.5-6.el8.aarch64//rpm",
+        "@libgcc-0__8.5.0-15.el8.aarch64//rpm",
+        "@libgcrypt-0__1.8.5-7.el8.aarch64//rpm",
         "@libgpg-error-0__1.31-1.el8.aarch64//rpm",
         "@libidn2-0__2.2.0-1.el8.aarch64//rpm",
         "@libmount-0__2.32.1-35.el8.aarch64//rpm",
         "@libnghttp2-0__1.33.0-3.el8_2.1.aarch64//rpm",
-        "@libnl3-0__3.5.0-1.el8.aarch64//rpm",
+        "@libnl3-0__3.7.0-1.el8.aarch64//rpm",
         "@libnsl2-0__1.2.0-2.20180605git4a062cf.el8.aarch64//rpm",
         "@libpkgconf-0__1.4.2-1.el8.aarch64//rpm",
         "@libpwquality-0__1.4.4-3.el8.aarch64//rpm",
@@ -1038,18 +1041,20 @@ rpmtree(
         "@libsmartcols-0__2.32.1-35.el8.aarch64//rpm",
         "@libssh-0__0.9.6-3.el8.aarch64//rpm",
         "@libssh-config-0__0.9.6-3.el8.aarch64//rpm",
+        "@libstdc__plus____plus__-0__8.5.0-15.el8.aarch64//rpm",
         "@libtasn1-0__4.13-3.el8.aarch64//rpm",
-        "@libtirpc-0__1.1.4-6.el8.aarch64//rpm",
+        "@libtirpc-0__1.1.4-7.el8.aarch64//rpm",
         "@libunistring-0__0.9.9-3.el8.aarch64//rpm",
         "@libutempter-0__1.1.6-14.el8.aarch64//rpm",
         "@libuuid-0__2.32.1-35.el8.aarch64//rpm",
-        "@libverto-0__0.3.0-5.el8.aarch64//rpm",
+        "@libverto-0__0.3.2-2.el8.aarch64//rpm",
         "@libvirt-devel-0__8.0.0-2.module_el8.6.0__plus__1087__plus__b42c8331.aarch64//rpm",
         "@libvirt-libs-0__8.0.0-2.module_el8.6.0__plus__1087__plus__b42c8331.aarch64//rpm",
         "@libxcrypt-0__4.1.1-6.el8.aarch64//rpm",
-        "@libxml2-0__2.9.7-13.el8.aarch64//rpm",
+        "@libxml2-0__2.9.7-14.el8.aarch64//rpm",
         "@libzstd-0__1.4.4-1.el8.aarch64//rpm",
         "@lz4-libs-0__1.8.3-3.el8_4.aarch64//rpm",
+        "@mozjs60-0__60.9.0-4.el8.aarch64//rpm",
         "@mpfr-0__3.1.6-1.el8.aarch64//rpm",
         "@ncurses-base-0__6.1-9.20180224.el8.aarch64//rpm",
         "@ncurses-libs-0__6.1-9.20180224.el8.aarch64//rpm",
@@ -1059,26 +1064,30 @@ rpmtree(
         "@openssl-libs-1__1.1.1k-6.el8.aarch64//rpm",
         "@p11-kit-0__0.23.22-1.el8.aarch64//rpm",
         "@p11-kit-trust-0__0.23.22-1.el8.aarch64//rpm",
-        "@pam-0__1.3.1-16.el8.aarch64//rpm",
+        "@pam-0__1.3.1-22.el8.aarch64//rpm",
         "@pcre-0__8.42-6.el8.aarch64//rpm",
-        "@pcre2-0__10.32-2.el8.aarch64//rpm",
+        "@pcre2-0__10.32-3.el8.aarch64//rpm",
         "@pkgconf-0__1.4.2-1.el8.aarch64//rpm",
         "@pkgconf-m4-0__1.4.2-1.el8.aarch64//rpm",
         "@pkgconf-pkg-config-0__1.4.2-1.el8.aarch64//rpm",
+        "@polkit-0__0.115-13.0.1.el8.2.aarch64//rpm",
+        "@polkit-libs-0__0.115-13.0.1.el8.2.aarch64//rpm",
+        "@polkit-pkla-compat-0__0.1-12.el8.aarch64//rpm",
         "@popt-0__1.18-1.el8.aarch64//rpm",
         "@readline-0__7.0-10.el8.aarch64//rpm",
         "@sed-0__4.5-5.el8.aarch64//rpm",
-        "@setup-0__2.12.2-6.el8.aarch64//rpm",
+        "@setup-0__2.12.2-7.el8.aarch64//rpm",
         "@shadow-utils-2__4.6-16.el8.aarch64//rpm",
-        "@systemd-0__239-58.el8.aarch64//rpm",
-        "@systemd-libs-0__239-58.el8.aarch64//rpm",
-        "@systemd-pam-0__239-58.el8.aarch64//rpm",
-        "@tzdata-0__2022a-1.el8.aarch64//rpm",
+        "@systemd-0__239-60.el8.aarch64//rpm",
+        "@systemd-libs-0__239-60.el8.aarch64//rpm",
+        "@systemd-pam-0__239-60.el8.aarch64//rpm",
+        "@timedatex-0__0.5-3.el8.aarch64//rpm",
+        "@tzdata-0__2022a-2.el8.aarch64//rpm",
         "@util-linux-0__2.32.1-35.el8.aarch64//rpm",
-        "@vim-minimal-2__8.0.1763-16.el8_5.12.aarch64//rpm",
-        "@xz-libs-0__5.2.4-3.el8.aarch64//rpm",
-        "@yajl-0__2.1.0-10.el8.aarch64//rpm",
-        "@zlib-0__1.2.11-17.el8.aarch64//rpm",
+        "@vim-minimal-2__8.0.1763-19.el8.4.aarch64//rpm",
+        "@xz-libs-0__5.2.4-4.el8.aarch64//rpm",
+        "@yajl-0__2.1.0-11.el8.aarch64//rpm",
+        "@zlib-0__1.2.11-19.el8.aarch64//rpm",
     ],
     visibility = ["//visibility:public"],
 )
@@ -1087,67 +1096,67 @@ rpmtree(
     name = "libvirt-devel_x86_64",
     rpms = [
         "@acl-0__2.2.53-1.el8.x86_64//rpm",
-        "@audit-libs-0__3.0.7-3.el8.x86_64//rpm",
+        "@audit-libs-0__3.0.7-4.el8.x86_64//rpm",
         "@basesystem-0__11-5.el8.x86_64//rpm",
-        "@bash-0__4.4.20-3.el8.x86_64//rpm",
+        "@bash-0__4.4.20-4.el8.x86_64//rpm",
         "@bzip2-libs-0__1.0.6-26.el8.x86_64//rpm",
         "@ca-certificates-0__2021.2.50-82.el8.x86_64//rpm",
         "@centos-gpg-keys-1__8-6.el8.x86_64//rpm",
         "@centos-stream-release-0__8.6-1.el8.x86_64//rpm",
         "@centos-stream-repos-0__8-6.el8.x86_64//rpm",
         "@chkconfig-0__1.19.1-1.el8.x86_64//rpm",
-        "@coreutils-single-0__8.30-12.el8.x86_64//rpm",
+        "@coreutils-single-0__8.30-13.el8.x86_64//rpm",
         "@cracklib-0__2.9.6-15.el8.x86_64//rpm",
         "@cracklib-dicts-0__2.9.6-15.el8.x86_64//rpm",
         "@crypto-policies-0__20211116-1.gitae470d6.el8.x86_64//rpm",
         "@cryptsetup-libs-0__2.3.7-2.el8.x86_64//rpm",
-        "@curl-0__7.61.1-22.el8.x86_64//rpm",
+        "@curl-0__7.61.1-25.el8.x86_64//rpm",
         "@cyrus-sasl-0__2.1.27-6.el8_5.x86_64//rpm",
         "@cyrus-sasl-gssapi-0__2.1.27-6.el8_5.x86_64//rpm",
         "@cyrus-sasl-lib-0__2.1.27-6.el8_5.x86_64//rpm",
-        "@dbus-1__1.12.8-18.el8.x86_64//rpm",
-        "@dbus-common-1__1.12.8-18.el8.x86_64//rpm",
-        "@dbus-daemon-1__1.12.8-18.el8.x86_64//rpm",
-        "@dbus-libs-1__1.12.8-18.el8.x86_64//rpm",
-        "@dbus-tools-1__1.12.8-18.el8.x86_64//rpm",
+        "@dbus-1__1.12.8-19.el8.x86_64//rpm",
+        "@dbus-common-1__1.12.8-19.el8.x86_64//rpm",
+        "@dbus-daemon-1__1.12.8-19.el8.x86_64//rpm",
+        "@dbus-libs-1__1.12.8-19.el8.x86_64//rpm",
+        "@dbus-tools-1__1.12.8-19.el8.x86_64//rpm",
         "@device-mapper-8__1.02.181-3.el8.x86_64//rpm",
         "@device-mapper-libs-8__1.02.181-3.el8.x86_64//rpm",
-        "@elfutils-default-yama-scope-0__0.186-1.el8.x86_64//rpm",
-        "@elfutils-libelf-0__0.186-1.el8.x86_64//rpm",
-        "@elfutils-libs-0__0.186-1.el8.x86_64//rpm",
-        "@expat-0__2.2.5-8.el8.x86_64//rpm",
+        "@elfutils-default-yama-scope-0__0.187-4.el8.x86_64//rpm",
+        "@elfutils-libelf-0__0.187-4.el8.x86_64//rpm",
+        "@elfutils-libs-0__0.187-4.el8.x86_64//rpm",
+        "@expat-0__2.2.5-9.el8.x86_64//rpm",
         "@filesystem-0__3.8-6.el8.x86_64//rpm",
         "@gawk-0__4.2.1-4.el8.x86_64//rpm",
-        "@glib2-0__2.56.4-158.el8.x86_64//rpm",
-        "@glibc-0__2.28-196.el8.x86_64//rpm",
-        "@glibc-common-0__2.28-196.el8.x86_64//rpm",
-        "@glibc-minimal-langpack-0__2.28-196.el8.x86_64//rpm",
+        "@glib2-0__2.56.4-159.el8.x86_64//rpm",
+        "@glibc-0__2.28-208.el8.x86_64//rpm",
+        "@glibc-common-0__2.28-208.el8.x86_64//rpm",
+        "@glibc-minimal-langpack-0__2.28-208.el8.x86_64//rpm",
         "@gmp-1__6.1.2-10.el8.x86_64//rpm",
         "@gnutls-0__3.6.16-4.el8.x86_64//rpm",
         "@grep-0__3.1-6.el8.x86_64//rpm",
-        "@gzip-0__1.9-12.el8.x86_64//rpm",
+        "@gzip-0__1.9-13.el8.x86_64//rpm",
         "@info-0__6.5-7.el8_5.x86_64//rpm",
         "@json-c-0__0.13.1-3.el8.x86_64//rpm",
         "@keyutils-libs-0__1.5.10-9.el8.x86_64//rpm",
         "@kmod-libs-0__25-19.el8.x86_64//rpm",
-        "@krb5-libs-0__1.18.2-14.el8.x86_64//rpm",
+        "@krb5-libs-0__1.18.2-21.el8.x86_64//rpm",
         "@libacl-0__2.2.53-1.el8.x86_64//rpm",
         "@libattr-0__2.4.48-3.el8.x86_64//rpm",
         "@libblkid-0__2.32.1-35.el8.x86_64//rpm",
-        "@libcap-0__2.48-2.el8.x86_64//rpm",
+        "@libcap-0__2.48-4.el8.x86_64//rpm",
         "@libcap-ng-0__0.7.11-1.el8.x86_64//rpm",
-        "@libcom_err-0__1.45.6-4.el8.x86_64//rpm",
-        "@libcurl-minimal-0__7.61.1-22.el8.x86_64//rpm",
+        "@libcom_err-0__1.45.6-5.el8.x86_64//rpm",
+        "@libcurl-minimal-0__7.61.1-25.el8.x86_64//rpm",
         "@libdb-0__5.3.28-42.el8_4.x86_64//rpm",
         "@libfdisk-0__2.32.1-35.el8.x86_64//rpm",
         "@libffi-0__3.1-23.el8.x86_64//rpm",
-        "@libgcc-0__8.5.0-10.el8.x86_64//rpm",
-        "@libgcrypt-0__1.8.5-6.el8.x86_64//rpm",
+        "@libgcc-0__8.5.0-15.el8.x86_64//rpm",
+        "@libgcrypt-0__1.8.5-7.el8.x86_64//rpm",
         "@libgpg-error-0__1.31-1.el8.x86_64//rpm",
         "@libidn2-0__2.2.0-1.el8.x86_64//rpm",
         "@libmount-0__2.32.1-35.el8.x86_64//rpm",
         "@libnghttp2-0__1.33.0-3.el8_2.1.x86_64//rpm",
-        "@libnl3-0__3.5.0-1.el8.x86_64//rpm",
+        "@libnl3-0__3.7.0-1.el8.x86_64//rpm",
         "@libnsl2-0__1.2.0-2.20180605git4a062cf.el8.x86_64//rpm",
         "@libpkgconf-0__1.4.2-1.el8.x86_64//rpm",
         "@libpwquality-0__1.4.4-3.el8.x86_64//rpm",
@@ -1159,18 +1168,20 @@ rpmtree(
         "@libsmartcols-0__2.32.1-35.el8.x86_64//rpm",
         "@libssh-0__0.9.6-3.el8.x86_64//rpm",
         "@libssh-config-0__0.9.6-3.el8.x86_64//rpm",
+        "@libstdc__plus____plus__-0__8.5.0-15.el8.x86_64//rpm",
         "@libtasn1-0__4.13-3.el8.x86_64//rpm",
-        "@libtirpc-0__1.1.4-6.el8.x86_64//rpm",
+        "@libtirpc-0__1.1.4-7.el8.x86_64//rpm",
         "@libunistring-0__0.9.9-3.el8.x86_64//rpm",
         "@libutempter-0__1.1.6-14.el8.x86_64//rpm",
         "@libuuid-0__2.32.1-35.el8.x86_64//rpm",
-        "@libverto-0__0.3.0-5.el8.x86_64//rpm",
+        "@libverto-0__0.3.2-2.el8.x86_64//rpm",
         "@libvirt-devel-0__8.0.0-2.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@libvirt-libs-0__8.0.0-2.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@libxcrypt-0__4.1.1-6.el8.x86_64//rpm",
-        "@libxml2-0__2.9.7-13.el8.x86_64//rpm",
+        "@libxml2-0__2.9.7-14.el8.x86_64//rpm",
         "@libzstd-0__1.4.4-1.el8.x86_64//rpm",
         "@lz4-libs-0__1.8.3-3.el8_4.x86_64//rpm",
+        "@mozjs60-0__60.9.0-4.el8.x86_64//rpm",
         "@mpfr-0__3.1.6-1.el8.x86_64//rpm",
         "@ncurses-base-0__6.1-9.20180224.el8.x86_64//rpm",
         "@ncurses-libs-0__6.1-9.20180224.el8.x86_64//rpm",
@@ -1180,26 +1191,30 @@ rpmtree(
         "@openssl-libs-1__1.1.1k-6.el8.x86_64//rpm",
         "@p11-kit-0__0.23.22-1.el8.x86_64//rpm",
         "@p11-kit-trust-0__0.23.22-1.el8.x86_64//rpm",
-        "@pam-0__1.3.1-16.el8.x86_64//rpm",
+        "@pam-0__1.3.1-22.el8.x86_64//rpm",
         "@pcre-0__8.42-6.el8.x86_64//rpm",
-        "@pcre2-0__10.32-2.el8.x86_64//rpm",
+        "@pcre2-0__10.32-3.el8.x86_64//rpm",
         "@pkgconf-0__1.4.2-1.el8.x86_64//rpm",
         "@pkgconf-m4-0__1.4.2-1.el8.x86_64//rpm",
         "@pkgconf-pkg-config-0__1.4.2-1.el8.x86_64//rpm",
+        "@polkit-0__0.115-13.0.1.el8.2.x86_64//rpm",
+        "@polkit-libs-0__0.115-13.0.1.el8.2.x86_64//rpm",
+        "@polkit-pkla-compat-0__0.1-12.el8.x86_64//rpm",
         "@popt-0__1.18-1.el8.x86_64//rpm",
         "@readline-0__7.0-10.el8.x86_64//rpm",
         "@sed-0__4.5-5.el8.x86_64//rpm",
-        "@setup-0__2.12.2-6.el8.x86_64//rpm",
+        "@setup-0__2.12.2-7.el8.x86_64//rpm",
         "@shadow-utils-2__4.6-16.el8.x86_64//rpm",
-        "@systemd-0__239-58.el8.x86_64//rpm",
-        "@systemd-libs-0__239-58.el8.x86_64//rpm",
-        "@systemd-pam-0__239-58.el8.x86_64//rpm",
-        "@tzdata-0__2022a-1.el8.x86_64//rpm",
+        "@systemd-0__239-60.el8.x86_64//rpm",
+        "@systemd-libs-0__239-60.el8.x86_64//rpm",
+        "@systemd-pam-0__239-60.el8.x86_64//rpm",
+        "@timedatex-0__0.5-3.el8.x86_64//rpm",
+        "@tzdata-0__2022a-2.el8.x86_64//rpm",
         "@util-linux-0__2.32.1-35.el8.x86_64//rpm",
-        "@vim-minimal-2__8.0.1763-16.el8_5.12.x86_64//rpm",
-        "@xz-libs-0__5.2.4-3.el8.x86_64//rpm",
-        "@yajl-0__2.1.0-10.el8.x86_64//rpm",
-        "@zlib-0__1.2.11-17.el8.x86_64//rpm",
+        "@vim-minimal-2__8.0.1763-19.el8.4.x86_64//rpm",
+        "@xz-libs-0__5.2.4-4.el8.x86_64//rpm",
+        "@yajl-0__2.1.0-11.el8.x86_64//rpm",
+        "@zlib-0__1.2.11-19.el8.x86_64//rpm",
     ],
     visibility = ["//visibility:public"],
 )
@@ -1208,55 +1223,55 @@ rpmtree(
     name = "sandboxroot_aarch64",
     rpms = [
         "@acl-0__2.2.53-1.el8.aarch64//rpm",
-        "@audit-libs-0__3.0.7-3.el8.aarch64//rpm",
+        "@audit-libs-0__3.0.7-4.el8.aarch64//rpm",
         "@basesystem-0__11-5.el8.aarch64//rpm",
-        "@bash-0__4.4.20-3.el8.aarch64//rpm",
-        "@binutils-0__2.30-113.el8.aarch64//rpm",
+        "@bash-0__4.4.20-4.el8.aarch64//rpm",
+        "@binutils-0__2.30-117.el8.aarch64//rpm",
         "@bzip2-libs-0__1.0.6-26.el8.aarch64//rpm",
         "@ca-certificates-0__2021.2.50-82.el8.aarch64//rpm",
         "@centos-gpg-keys-1__8-6.el8.aarch64//rpm",
         "@centos-stream-release-0__8.6-1.el8.aarch64//rpm",
         "@centos-stream-repos-0__8-6.el8.aarch64//rpm",
         "@chkconfig-0__1.19.1-1.el8.aarch64//rpm",
-        "@coreutils-single-0__8.30-12.el8.aarch64//rpm",
-        "@cpp-0__8.5.0-10.el8.aarch64//rpm",
+        "@coreutils-single-0__8.30-13.el8.aarch64//rpm",
+        "@cpp-0__8.5.0-15.el8.aarch64//rpm",
         "@cracklib-0__2.9.6-15.el8.aarch64//rpm",
         "@cracklib-dicts-0__2.9.6-15.el8.aarch64//rpm",
         "@crypto-policies-0__20211116-1.gitae470d6.el8.aarch64//rpm",
-        "@curl-0__7.61.1-22.el8.aarch64//rpm",
-        "@expat-0__2.2.5-8.el8.aarch64//rpm",
+        "@curl-0__7.61.1-25.el8.aarch64//rpm",
+        "@expat-0__2.2.5-9.el8.aarch64//rpm",
         "@filesystem-0__3.8-6.el8.aarch64//rpm",
         "@findutils-1__4.6.0-20.el8.aarch64//rpm",
         "@gawk-0__4.2.1-4.el8.aarch64//rpm",
-        "@gcc-0__8.5.0-10.el8.aarch64//rpm",
-        "@gdbm-1__1.18-1.el8.aarch64//rpm",
-        "@gdbm-libs-1__1.18-1.el8.aarch64//rpm",
-        "@glibc-0__2.28-196.el8.aarch64//rpm",
-        "@glibc-common-0__2.28-196.el8.aarch64//rpm",
-        "@glibc-devel-0__2.28-196.el8.aarch64//rpm",
-        "@glibc-headers-0__2.28-196.el8.aarch64//rpm",
-        "@glibc-minimal-langpack-0__2.28-196.el8.aarch64//rpm",
-        "@glibc-static-0__2.28-196.el8.aarch64//rpm",
+        "@gcc-0__8.5.0-15.el8.aarch64//rpm",
+        "@gdbm-1__1.18-2.el8.aarch64//rpm",
+        "@gdbm-libs-1__1.18-2.el8.aarch64//rpm",
+        "@glibc-0__2.28-208.el8.aarch64//rpm",
+        "@glibc-common-0__2.28-208.el8.aarch64//rpm",
+        "@glibc-devel-0__2.28-208.el8.aarch64//rpm",
+        "@glibc-headers-0__2.28-208.el8.aarch64//rpm",
+        "@glibc-minimal-langpack-0__2.28-208.el8.aarch64//rpm",
+        "@glibc-static-0__2.28-208.el8.aarch64//rpm",
         "@gmp-1__6.1.2-10.el8.aarch64//rpm",
         "@grep-0__3.1-6.el8.aarch64//rpm",
-        "@gzip-0__1.9-12.el8.aarch64//rpm",
+        "@gzip-0__1.9-13.el8.aarch64//rpm",
         "@info-0__6.5-7.el8_5.aarch64//rpm",
         "@isl-0__0.16.1-6.el8.aarch64//rpm",
-        "@kernel-headers-0__4.18.0-373.el8.aarch64//rpm",
+        "@kernel-headers-0__4.18.0-408.el8.aarch64//rpm",
         "@keyutils-libs-0__1.5.10-9.el8.aarch64//rpm",
-        "@krb5-libs-0__1.18.2-14.el8.aarch64//rpm",
+        "@krb5-libs-0__1.18.2-21.el8.aarch64//rpm",
         "@libacl-0__2.2.53-1.el8.aarch64//rpm",
-        "@libasan-0__8.5.0-10.el8.aarch64//rpm",
-        "@libatomic-0__8.5.0-10.el8.aarch64//rpm",
+        "@libasan-0__8.5.0-15.el8.aarch64//rpm",
+        "@libatomic-0__8.5.0-15.el8.aarch64//rpm",
         "@libattr-0__2.4.48-3.el8.aarch64//rpm",
-        "@libcap-0__2.48-2.el8.aarch64//rpm",
+        "@libcap-0__2.48-4.el8.aarch64//rpm",
         "@libcap-ng-0__0.7.11-1.el8.aarch64//rpm",
-        "@libcom_err-0__1.45.6-4.el8.aarch64//rpm",
-        "@libcurl-minimal-0__7.61.1-22.el8.aarch64//rpm",
+        "@libcom_err-0__1.45.6-5.el8.aarch64//rpm",
+        "@libcurl-minimal-0__7.61.1-25.el8.aarch64//rpm",
         "@libdb-0__5.3.28-42.el8_4.aarch64//rpm",
         "@libffi-0__3.1-23.el8.aarch64//rpm",
-        "@libgcc-0__8.5.0-10.el8.aarch64//rpm",
-        "@libgomp-0__8.5.0-10.el8.aarch64//rpm",
+        "@libgcc-0__8.5.0-15.el8.aarch64//rpm",
+        "@libgomp-0__8.5.0-15.el8.aarch64//rpm",
         "@libmpc-0__1.1.0-9.1.el8.aarch64//rpm",
         "@libnghttp2-0__1.33.0-3.el8_2.1.aarch64//rpm",
         "@libnsl2-0__1.2.0-2.20180605git4a062cf.el8.aarch64//rpm",
@@ -1265,13 +1280,13 @@ rpmtree(
         "@libselinux-0__2.9-5.el8.aarch64//rpm",
         "@libsepol-0__2.9-3.el8.aarch64//rpm",
         "@libsigsegv-0__2.11-5.el8.aarch64//rpm",
-        "@libsss_idmap-0__2.6.2-3.el8.aarch64//rpm",
-        "@libsss_nss_idmap-0__2.6.2-3.el8.aarch64//rpm",
-        "@libstdc__plus____plus__-0__8.5.0-10.el8.aarch64//rpm",
+        "@libsss_idmap-0__2.7.3-1.el8.aarch64//rpm",
+        "@libsss_nss_idmap-0__2.7.3-1.el8.aarch64//rpm",
+        "@libstdc__plus____plus__-0__8.5.0-15.el8.aarch64//rpm",
         "@libtasn1-0__4.13-3.el8.aarch64//rpm",
-        "@libtirpc-0__1.1.4-6.el8.aarch64//rpm",
-        "@libubsan-0__8.5.0-10.el8.aarch64//rpm",
-        "@libverto-0__0.3.0-5.el8.aarch64//rpm",
+        "@libtirpc-0__1.1.4-7.el8.aarch64//rpm",
+        "@libubsan-0__8.5.0-15.el8.aarch64//rpm",
+        "@libverto-0__0.3.2-2.el8.aarch64//rpm",
         "@libxcrypt-0__4.1.1-6.el8.aarch64//rpm",
         "@libxcrypt-devel-0__4.1.1-6.el8.aarch64//rpm",
         "@libxcrypt-static-0__4.1.1-6.el8.aarch64//rpm",
@@ -1281,17 +1296,17 @@ rpmtree(
         "@openssl-libs-1__1.1.1k-6.el8.aarch64//rpm",
         "@p11-kit-0__0.23.22-1.el8.aarch64//rpm",
         "@p11-kit-trust-0__0.23.22-1.el8.aarch64//rpm",
-        "@pam-0__1.3.1-16.el8.aarch64//rpm",
+        "@pam-0__1.3.1-22.el8.aarch64//rpm",
         "@pcre-0__8.42-6.el8.aarch64//rpm",
-        "@pcre2-0__10.32-2.el8.aarch64//rpm",
+        "@pcre2-0__10.32-3.el8.aarch64//rpm",
         "@pkgconf-0__1.4.2-1.el8.aarch64//rpm",
         "@pkgconf-m4-0__1.4.2-1.el8.aarch64//rpm",
         "@pkgconf-pkg-config-0__1.4.2-1.el8.aarch64//rpm",
-        "@platform-python-0__3.6.8-46.el8.aarch64//rpm",
+        "@platform-python-0__3.6.8-47.el8.aarch64//rpm",
         "@platform-python-pip-0__9.0.3-22.el8.aarch64//rpm",
         "@platform-python-setuptools-0__39.2.0-6.el8.aarch64//rpm",
         "@popt-0__1.18-1.el8.aarch64//rpm",
-        "@python3-libs-0__3.6.8-46.el8.aarch64//rpm",
+        "@python3-libs-0__3.6.8-47.el8.aarch64//rpm",
         "@python3-pip-0__9.0.3-22.el8.aarch64//rpm",
         "@python3-pip-wheel-0__9.0.3-22.el8.aarch64//rpm",
         "@python3-setuptools-0__39.2.0-6.el8.aarch64//rpm",
@@ -1299,13 +1314,13 @@ rpmtree(
         "@python36-0__3.6.8-38.module_el8.5.0__plus__895__plus__a459eca8.aarch64//rpm",
         "@readline-0__7.0-10.el8.aarch64//rpm",
         "@sed-0__4.5-5.el8.aarch64//rpm",
-        "@setup-0__2.12.2-6.el8.aarch64//rpm",
+        "@setup-0__2.12.2-7.el8.aarch64//rpm",
         "@sqlite-libs-0__3.26.0-15.el8.aarch64//rpm",
-        "@sssd-client-0__2.6.2-3.el8.aarch64//rpm",
-        "@tzdata-0__2022a-1.el8.aarch64//rpm",
-        "@vim-minimal-2__8.0.1763-16.el8_5.12.aarch64//rpm",
-        "@xz-libs-0__5.2.4-3.el8.aarch64//rpm",
-        "@zlib-0__1.2.11-17.el8.aarch64//rpm",
+        "@sssd-client-0__2.7.3-1.el8.aarch64//rpm",
+        "@tzdata-0__2022a-2.el8.aarch64//rpm",
+        "@vim-minimal-2__8.0.1763-19.el8.4.aarch64//rpm",
+        "@xz-libs-0__5.2.4-4.el8.aarch64//rpm",
+        "@zlib-0__1.2.11-19.el8.aarch64//rpm",
     ],
     symlinks = {
         "/var/run": "../run",
@@ -1320,53 +1335,53 @@ rpmtree(
     name = "sandboxroot_x86_64",
     rpms = [
         "@acl-0__2.2.53-1.el8.x86_64//rpm",
-        "@audit-libs-0__3.0.7-3.el8.x86_64//rpm",
+        "@audit-libs-0__3.0.7-4.el8.x86_64//rpm",
         "@basesystem-0__11-5.el8.x86_64//rpm",
-        "@bash-0__4.4.20-3.el8.x86_64//rpm",
-        "@binutils-0__2.30-113.el8.x86_64//rpm",
+        "@bash-0__4.4.20-4.el8.x86_64//rpm",
+        "@binutils-0__2.30-117.el8.x86_64//rpm",
         "@bzip2-libs-0__1.0.6-26.el8.x86_64//rpm",
         "@ca-certificates-0__2021.2.50-82.el8.x86_64//rpm",
         "@centos-gpg-keys-1__8-6.el8.x86_64//rpm",
         "@centos-stream-release-0__8.6-1.el8.x86_64//rpm",
         "@centos-stream-repos-0__8-6.el8.x86_64//rpm",
         "@chkconfig-0__1.19.1-1.el8.x86_64//rpm",
-        "@coreutils-single-0__8.30-12.el8.x86_64//rpm",
-        "@cpp-0__8.5.0-10.el8.x86_64//rpm",
+        "@coreutils-single-0__8.30-13.el8.x86_64//rpm",
+        "@cpp-0__8.5.0-15.el8.x86_64//rpm",
         "@cracklib-0__2.9.6-15.el8.x86_64//rpm",
         "@cracklib-dicts-0__2.9.6-15.el8.x86_64//rpm",
         "@crypto-policies-0__20211116-1.gitae470d6.el8.x86_64//rpm",
-        "@curl-0__7.61.1-22.el8.x86_64//rpm",
-        "@expat-0__2.2.5-8.el8.x86_64//rpm",
+        "@curl-0__7.61.1-25.el8.x86_64//rpm",
+        "@expat-0__2.2.5-9.el8.x86_64//rpm",
         "@filesystem-0__3.8-6.el8.x86_64//rpm",
         "@findutils-1__4.6.0-20.el8.x86_64//rpm",
         "@gawk-0__4.2.1-4.el8.x86_64//rpm",
-        "@gcc-0__8.5.0-10.el8.x86_64//rpm",
-        "@gdbm-1__1.18-1.el8.x86_64//rpm",
-        "@gdbm-libs-1__1.18-1.el8.x86_64//rpm",
-        "@glibc-0__2.28-196.el8.x86_64//rpm",
-        "@glibc-common-0__2.28-196.el8.x86_64//rpm",
-        "@glibc-devel-0__2.28-196.el8.x86_64//rpm",
-        "@glibc-headers-0__2.28-196.el8.x86_64//rpm",
-        "@glibc-minimal-langpack-0__2.28-196.el8.x86_64//rpm",
-        "@glibc-static-0__2.28-196.el8.x86_64//rpm",
+        "@gcc-0__8.5.0-15.el8.x86_64//rpm",
+        "@gdbm-1__1.18-2.el8.x86_64//rpm",
+        "@gdbm-libs-1__1.18-2.el8.x86_64//rpm",
+        "@glibc-0__2.28-208.el8.x86_64//rpm",
+        "@glibc-common-0__2.28-208.el8.x86_64//rpm",
+        "@glibc-devel-0__2.28-208.el8.x86_64//rpm",
+        "@glibc-headers-0__2.28-208.el8.x86_64//rpm",
+        "@glibc-minimal-langpack-0__2.28-208.el8.x86_64//rpm",
+        "@glibc-static-0__2.28-208.el8.x86_64//rpm",
         "@gmp-1__6.1.2-10.el8.x86_64//rpm",
         "@grep-0__3.1-6.el8.x86_64//rpm",
-        "@gzip-0__1.9-12.el8.x86_64//rpm",
+        "@gzip-0__1.9-13.el8.x86_64//rpm",
         "@info-0__6.5-7.el8_5.x86_64//rpm",
         "@isl-0__0.16.1-6.el8.x86_64//rpm",
-        "@kernel-headers-0__4.18.0-373.el8.x86_64//rpm",
+        "@kernel-headers-0__4.18.0-408.el8.x86_64//rpm",
         "@keyutils-libs-0__1.5.10-9.el8.x86_64//rpm",
-        "@krb5-libs-0__1.18.2-14.el8.x86_64//rpm",
+        "@krb5-libs-0__1.18.2-21.el8.x86_64//rpm",
         "@libacl-0__2.2.53-1.el8.x86_64//rpm",
         "@libattr-0__2.4.48-3.el8.x86_64//rpm",
-        "@libcap-0__2.48-2.el8.x86_64//rpm",
+        "@libcap-0__2.48-4.el8.x86_64//rpm",
         "@libcap-ng-0__0.7.11-1.el8.x86_64//rpm",
-        "@libcom_err-0__1.45.6-4.el8.x86_64//rpm",
-        "@libcurl-minimal-0__7.61.1-22.el8.x86_64//rpm",
+        "@libcom_err-0__1.45.6-5.el8.x86_64//rpm",
+        "@libcurl-minimal-0__7.61.1-25.el8.x86_64//rpm",
         "@libdb-0__5.3.28-42.el8_4.x86_64//rpm",
         "@libffi-0__3.1-23.el8.x86_64//rpm",
-        "@libgcc-0__8.5.0-10.el8.x86_64//rpm",
-        "@libgomp-0__8.5.0-10.el8.x86_64//rpm",
+        "@libgcc-0__8.5.0-15.el8.x86_64//rpm",
+        "@libgomp-0__8.5.0-15.el8.x86_64//rpm",
         "@libmpc-0__1.1.0-9.1.el8.x86_64//rpm",
         "@libnghttp2-0__1.33.0-3.el8_2.1.x86_64//rpm",
         "@libnsl2-0__1.2.0-2.20180605git4a062cf.el8.x86_64//rpm",
@@ -1375,12 +1390,12 @@ rpmtree(
         "@libselinux-0__2.9-5.el8.x86_64//rpm",
         "@libsepol-0__2.9-3.el8.x86_64//rpm",
         "@libsigsegv-0__2.11-5.el8.x86_64//rpm",
-        "@libsss_idmap-0__2.6.2-3.el8.x86_64//rpm",
-        "@libsss_nss_idmap-0__2.6.2-3.el8.x86_64//rpm",
-        "@libstdc__plus____plus__-0__8.5.0-10.el8.x86_64//rpm",
+        "@libsss_idmap-0__2.7.3-1.el8.x86_64//rpm",
+        "@libsss_nss_idmap-0__2.7.3-1.el8.x86_64//rpm",
+        "@libstdc__plus____plus__-0__8.5.0-15.el8.x86_64//rpm",
         "@libtasn1-0__4.13-3.el8.x86_64//rpm",
-        "@libtirpc-0__1.1.4-6.el8.x86_64//rpm",
-        "@libverto-0__0.3.0-5.el8.x86_64//rpm",
+        "@libtirpc-0__1.1.4-7.el8.x86_64//rpm",
+        "@libverto-0__0.3.2-2.el8.x86_64//rpm",
         "@libxcrypt-0__4.1.1-6.el8.x86_64//rpm",
         "@libxcrypt-devel-0__4.1.1-6.el8.x86_64//rpm",
         "@libxcrypt-static-0__4.1.1-6.el8.x86_64//rpm",
@@ -1390,17 +1405,17 @@ rpmtree(
         "@openssl-libs-1__1.1.1k-6.el8.x86_64//rpm",
         "@p11-kit-0__0.23.22-1.el8.x86_64//rpm",
         "@p11-kit-trust-0__0.23.22-1.el8.x86_64//rpm",
-        "@pam-0__1.3.1-16.el8.x86_64//rpm",
+        "@pam-0__1.3.1-22.el8.x86_64//rpm",
         "@pcre-0__8.42-6.el8.x86_64//rpm",
-        "@pcre2-0__10.32-2.el8.x86_64//rpm",
+        "@pcre2-0__10.32-3.el8.x86_64//rpm",
         "@pkgconf-0__1.4.2-1.el8.x86_64//rpm",
         "@pkgconf-m4-0__1.4.2-1.el8.x86_64//rpm",
         "@pkgconf-pkg-config-0__1.4.2-1.el8.x86_64//rpm",
-        "@platform-python-0__3.6.8-46.el8.x86_64//rpm",
+        "@platform-python-0__3.6.8-47.el8.x86_64//rpm",
         "@platform-python-pip-0__9.0.3-22.el8.x86_64//rpm",
         "@platform-python-setuptools-0__39.2.0-6.el8.x86_64//rpm",
         "@popt-0__1.18-1.el8.x86_64//rpm",
-        "@python3-libs-0__3.6.8-46.el8.x86_64//rpm",
+        "@python3-libs-0__3.6.8-47.el8.x86_64//rpm",
         "@python3-pip-0__9.0.3-22.el8.x86_64//rpm",
         "@python3-pip-wheel-0__9.0.3-22.el8.x86_64//rpm",
         "@python3-setuptools-0__39.2.0-6.el8.x86_64//rpm",
@@ -1408,13 +1423,13 @@ rpmtree(
         "@python36-0__3.6.8-38.module_el8.5.0__plus__895__plus__a459eca8.x86_64//rpm",
         "@readline-0__7.0-10.el8.x86_64//rpm",
         "@sed-0__4.5-5.el8.x86_64//rpm",
-        "@setup-0__2.12.2-6.el8.x86_64//rpm",
+        "@setup-0__2.12.2-7.el8.x86_64//rpm",
         "@sqlite-libs-0__3.26.0-15.el8.x86_64//rpm",
-        "@sssd-client-0__2.6.2-3.el8.x86_64//rpm",
-        "@tzdata-0__2022a-1.el8.x86_64//rpm",
-        "@vim-minimal-2__8.0.1763-16.el8_5.12.x86_64//rpm",
-        "@xz-libs-0__5.2.4-3.el8.x86_64//rpm",
-        "@zlib-0__1.2.11-17.el8.x86_64//rpm",
+        "@sssd-client-0__2.7.3-1.el8.x86_64//rpm",
+        "@tzdata-0__2022a-2.el8.x86_64//rpm",
+        "@vim-minimal-2__8.0.1763-19.el8.4.x86_64//rpm",
+        "@xz-libs-0__5.2.4-4.el8.x86_64//rpm",
+        "@zlib-0__1.2.11-19.el8.x86_64//rpm",
     ],
     symlinks = {
         "/var/run": "../run",
@@ -1429,70 +1444,70 @@ rpmtree(
     name = "testimage_aarch64",
     rpms = [
         "@acl-0__2.2.53-1.el8.aarch64//rpm",
-        "@audit-libs-0__3.0.7-3.el8.aarch64//rpm",
+        "@audit-libs-0__3.0.7-4.el8.aarch64//rpm",
         "@basesystem-0__11-5.el8.aarch64//rpm",
-        "@bash-0__4.4.20-3.el8.aarch64//rpm",
+        "@bash-0__4.4.20-4.el8.aarch64//rpm",
         "@bzip2-libs-0__1.0.6-26.el8.aarch64//rpm",
         "@ca-certificates-0__2021.2.50-82.el8.aarch64//rpm",
         "@centos-gpg-keys-1__8-6.el8.aarch64//rpm",
         "@centos-stream-release-0__8.6-1.el8.aarch64//rpm",
         "@centos-stream-repos-0__8-6.el8.aarch64//rpm",
         "@chkconfig-0__1.19.1-1.el8.aarch64//rpm",
-        "@coreutils-single-0__8.30-12.el8.aarch64//rpm",
+        "@coreutils-single-0__8.30-13.el8.aarch64//rpm",
         "@cracklib-0__2.9.6-15.el8.aarch64//rpm",
         "@cracklib-dicts-0__2.9.6-15.el8.aarch64//rpm",
         "@crypto-policies-0__20211116-1.gitae470d6.el8.aarch64//rpm",
         "@cryptsetup-libs-0__2.3.7-2.el8.aarch64//rpm",
-        "@curl-0__7.61.1-22.el8.aarch64//rpm",
-        "@dbus-1__1.12.8-18.el8.aarch64//rpm",
-        "@dbus-common-1__1.12.8-18.el8.aarch64//rpm",
-        "@dbus-daemon-1__1.12.8-18.el8.aarch64//rpm",
-        "@dbus-libs-1__1.12.8-18.el8.aarch64//rpm",
-        "@dbus-tools-1__1.12.8-18.el8.aarch64//rpm",
+        "@curl-0__7.61.1-25.el8.aarch64//rpm",
+        "@dbus-1__1.12.8-19.el8.aarch64//rpm",
+        "@dbus-common-1__1.12.8-19.el8.aarch64//rpm",
+        "@dbus-daemon-1__1.12.8-19.el8.aarch64//rpm",
+        "@dbus-libs-1__1.12.8-19.el8.aarch64//rpm",
+        "@dbus-tools-1__1.12.8-19.el8.aarch64//rpm",
         "@device-mapper-8__1.02.181-3.el8.aarch64//rpm",
         "@device-mapper-libs-8__1.02.181-3.el8.aarch64//rpm",
-        "@e2fsprogs-0__1.45.6-4.el8.aarch64//rpm",
-        "@e2fsprogs-libs-0__1.45.6-4.el8.aarch64//rpm",
-        "@elfutils-default-yama-scope-0__0.186-1.el8.aarch64//rpm",
-        "@elfutils-libelf-0__0.186-1.el8.aarch64//rpm",
-        "@elfutils-libs-0__0.186-1.el8.aarch64//rpm",
-        "@expat-0__2.2.5-8.el8.aarch64//rpm",
+        "@e2fsprogs-0__1.45.6-5.el8.aarch64//rpm",
+        "@e2fsprogs-libs-0__1.45.6-5.el8.aarch64//rpm",
+        "@elfutils-default-yama-scope-0__0.187-4.el8.aarch64//rpm",
+        "@elfutils-libelf-0__0.187-4.el8.aarch64//rpm",
+        "@elfutils-libs-0__0.187-4.el8.aarch64//rpm",
+        "@expat-0__2.2.5-9.el8.aarch64//rpm",
         "@filesystem-0__3.8-6.el8.aarch64//rpm",
-        "@fuse-libs-0__2.9.7-15.el8.aarch64//rpm",
+        "@fuse-libs-0__2.9.7-16.el8.aarch64//rpm",
         "@gawk-0__4.2.1-4.el8.aarch64//rpm",
-        "@glib2-0__2.56.4-158.el8.aarch64//rpm",
-        "@glibc-0__2.28-196.el8.aarch64//rpm",
-        "@glibc-common-0__2.28-196.el8.aarch64//rpm",
-        "@glibc-minimal-langpack-0__2.28-196.el8.aarch64//rpm",
+        "@glib2-0__2.56.4-159.el8.aarch64//rpm",
+        "@glibc-0__2.28-208.el8.aarch64//rpm",
+        "@glibc-common-0__2.28-208.el8.aarch64//rpm",
+        "@glibc-minimal-langpack-0__2.28-208.el8.aarch64//rpm",
         "@gmp-1__6.1.2-10.el8.aarch64//rpm",
         "@gnutls-0__3.6.16-4.el8.aarch64//rpm",
         "@grep-0__3.1-6.el8.aarch64//rpm",
-        "@gzip-0__1.9-12.el8.aarch64//rpm",
+        "@gzip-0__1.9-13.el8.aarch64//rpm",
         "@info-0__6.5-7.el8_5.aarch64//rpm",
         "@iputils-0__20180629-10.el8.aarch64//rpm",
         "@json-c-0__0.13.1-3.el8.aarch64//rpm",
         "@keyutils-libs-0__1.5.10-9.el8.aarch64//rpm",
         "@kmod-libs-0__25-19.el8.aarch64//rpm",
-        "@krb5-libs-0__1.18.2-14.el8.aarch64//rpm",
+        "@krb5-libs-0__1.18.2-21.el8.aarch64//rpm",
         "@libacl-0__2.2.53-1.el8.aarch64//rpm",
         "@libaio-0__0.3.112-1.el8.aarch64//rpm",
         "@libattr-0__2.4.48-3.el8.aarch64//rpm",
         "@libblkid-0__2.32.1-35.el8.aarch64//rpm",
-        "@libcap-0__2.48-2.el8.aarch64//rpm",
+        "@libcap-0__2.48-4.el8.aarch64//rpm",
         "@libcap-ng-0__0.7.11-1.el8.aarch64//rpm",
-        "@libcom_err-0__1.45.6-4.el8.aarch64//rpm",
-        "@libcurl-minimal-0__7.61.1-22.el8.aarch64//rpm",
+        "@libcom_err-0__1.45.6-5.el8.aarch64//rpm",
+        "@libcurl-minimal-0__7.61.1-25.el8.aarch64//rpm",
         "@libdb-0__5.3.28-42.el8_4.aarch64//rpm",
         "@libfdisk-0__2.32.1-35.el8.aarch64//rpm",
         "@libffi-0__3.1-23.el8.aarch64//rpm",
-        "@libgcc-0__8.5.0-10.el8.aarch64//rpm",
-        "@libgcrypt-0__1.8.5-6.el8.aarch64//rpm",
+        "@libgcc-0__8.5.0-15.el8.aarch64//rpm",
+        "@libgcrypt-0__1.8.5-7.el8.aarch64//rpm",
         "@libgpg-error-0__1.31-1.el8.aarch64//rpm",
         "@libibverbs-0__37.2-1.el8.aarch64//rpm",
         "@libidn2-0__2.2.0-1.el8.aarch64//rpm",
         "@libmount-0__2.32.1-35.el8.aarch64//rpm",
         "@libnghttp2-0__1.33.0-3.el8_2.1.aarch64//rpm",
-        "@libnl3-0__3.5.0-1.el8.aarch64//rpm",
+        "@libnl3-0__3.7.0-1.el8.aarch64//rpm",
         "@libnsl2-0__1.2.0-2.20180605git4a062cf.el8.aarch64//rpm",
         "@libpcap-14__1.9.1-5.el8.aarch64//rpm",
         "@libpwquality-0__1.4.4-3.el8.aarch64//rpm",
@@ -1502,43 +1517,49 @@ rpmtree(
         "@libsepol-0__2.9-3.el8.aarch64//rpm",
         "@libsigsegv-0__2.11-5.el8.aarch64//rpm",
         "@libsmartcols-0__2.32.1-35.el8.aarch64//rpm",
-        "@libss-0__1.45.6-4.el8.aarch64//rpm",
+        "@libss-0__1.45.6-5.el8.aarch64//rpm",
+        "@libstdc__plus____plus__-0__8.5.0-15.el8.aarch64//rpm",
         "@libtasn1-0__4.13-3.el8.aarch64//rpm",
-        "@libtirpc-0__1.1.4-6.el8.aarch64//rpm",
+        "@libtirpc-0__1.1.4-7.el8.aarch64//rpm",
         "@libunistring-0__0.9.9-3.el8.aarch64//rpm",
         "@libutempter-0__1.1.6-14.el8.aarch64//rpm",
         "@libuuid-0__2.32.1-35.el8.aarch64//rpm",
-        "@libverto-0__0.3.0-5.el8.aarch64//rpm",
+        "@libverto-0__0.3.2-2.el8.aarch64//rpm",
         "@libxcrypt-0__4.1.1-6.el8.aarch64//rpm",
         "@libzstd-0__1.4.4-1.el8.aarch64//rpm",
         "@lz4-libs-0__1.8.3-3.el8_4.aarch64//rpm",
+        "@mozjs60-0__60.9.0-4.el8.aarch64//rpm",
         "@mpfr-0__3.1.6-1.el8.aarch64//rpm",
         "@ncurses-base-0__6.1-9.20180224.el8.aarch64//rpm",
         "@ncurses-libs-0__6.1-9.20180224.el8.aarch64//rpm",
         "@nettle-0__3.4.1-7.el8.aarch64//rpm",
-        "@nmap-ncat-2__7.70-6.el8.aarch64//rpm",
+        "@nmap-ncat-2__7.70-7.el8.aarch64//rpm",
         "@openssl-libs-1__1.1.1k-6.el8.aarch64//rpm",
         "@p11-kit-0__0.23.22-1.el8.aarch64//rpm",
         "@p11-kit-trust-0__0.23.22-1.el8.aarch64//rpm",
-        "@pam-0__1.3.1-16.el8.aarch64//rpm",
+        "@pam-0__1.3.1-22.el8.aarch64//rpm",
         "@pcre-0__8.42-6.el8.aarch64//rpm",
-        "@pcre2-0__10.32-2.el8.aarch64//rpm",
+        "@pcre2-0__10.32-3.el8.aarch64//rpm",
+        "@polkit-0__0.115-13.0.1.el8.2.aarch64//rpm",
+        "@polkit-libs-0__0.115-13.0.1.el8.2.aarch64//rpm",
+        "@polkit-pkla-compat-0__0.1-12.el8.aarch64//rpm",
         "@popt-0__1.18-1.el8.aarch64//rpm",
         "@procps-ng-0__3.3.15-7.el8.aarch64//rpm",
         "@qemu-img-15__6.2.0-5.module_el8.6.0__plus__1087__plus__b42c8331.aarch64//rpm",
         "@readline-0__7.0-10.el8.aarch64//rpm",
         "@sed-0__4.5-5.el8.aarch64//rpm",
-        "@setup-0__2.12.2-6.el8.aarch64//rpm",
+        "@setup-0__2.12.2-7.el8.aarch64//rpm",
         "@shadow-utils-2__4.6-16.el8.aarch64//rpm",
-        "@systemd-0__239-58.el8.aarch64//rpm",
-        "@systemd-libs-0__239-58.el8.aarch64//rpm",
-        "@systemd-pam-0__239-58.el8.aarch64//rpm",
-        "@tzdata-0__2022a-1.el8.aarch64//rpm",
+        "@systemd-0__239-60.el8.aarch64//rpm",
+        "@systemd-libs-0__239-60.el8.aarch64//rpm",
+        "@systemd-pam-0__239-60.el8.aarch64//rpm",
+        "@timedatex-0__0.5-3.el8.aarch64//rpm",
+        "@tzdata-0__2022a-2.el8.aarch64//rpm",
         "@util-linux-0__2.32.1-35.el8.aarch64//rpm",
-        "@vim-minimal-2__8.0.1763-16.el8_5.12.aarch64//rpm",
-        "@which-0__2.21-17.el8.aarch64//rpm",
-        "@xz-libs-0__5.2.4-3.el8.aarch64//rpm",
-        "@zlib-0__1.2.11-17.el8.aarch64//rpm",
+        "@vim-minimal-2__8.0.1763-19.el8.4.aarch64//rpm",
+        "@which-0__2.21-18.el8.aarch64//rpm",
+        "@xz-libs-0__5.2.4-4.el8.aarch64//rpm",
+        "@zlib-0__1.2.11-19.el8.aarch64//rpm",
     ],
     symlinks = {
         "/var/run": "../run",
@@ -1551,70 +1572,70 @@ rpmtree(
     name = "testimage_x86_64",
     rpms = [
         "@acl-0__2.2.53-1.el8.x86_64//rpm",
-        "@audit-libs-0__3.0.7-3.el8.x86_64//rpm",
+        "@audit-libs-0__3.0.7-4.el8.x86_64//rpm",
         "@basesystem-0__11-5.el8.x86_64//rpm",
-        "@bash-0__4.4.20-3.el8.x86_64//rpm",
+        "@bash-0__4.4.20-4.el8.x86_64//rpm",
         "@bzip2-libs-0__1.0.6-26.el8.x86_64//rpm",
         "@ca-certificates-0__2021.2.50-82.el8.x86_64//rpm",
         "@centos-gpg-keys-1__8-6.el8.x86_64//rpm",
         "@centos-stream-release-0__8.6-1.el8.x86_64//rpm",
         "@centos-stream-repos-0__8-6.el8.x86_64//rpm",
         "@chkconfig-0__1.19.1-1.el8.x86_64//rpm",
-        "@coreutils-single-0__8.30-12.el8.x86_64//rpm",
+        "@coreutils-single-0__8.30-13.el8.x86_64//rpm",
         "@cracklib-0__2.9.6-15.el8.x86_64//rpm",
         "@cracklib-dicts-0__2.9.6-15.el8.x86_64//rpm",
         "@crypto-policies-0__20211116-1.gitae470d6.el8.x86_64//rpm",
         "@cryptsetup-libs-0__2.3.7-2.el8.x86_64//rpm",
-        "@curl-0__7.61.1-22.el8.x86_64//rpm",
-        "@dbus-1__1.12.8-18.el8.x86_64//rpm",
-        "@dbus-common-1__1.12.8-18.el8.x86_64//rpm",
-        "@dbus-daemon-1__1.12.8-18.el8.x86_64//rpm",
-        "@dbus-libs-1__1.12.8-18.el8.x86_64//rpm",
-        "@dbus-tools-1__1.12.8-18.el8.x86_64//rpm",
+        "@curl-0__7.61.1-25.el8.x86_64//rpm",
+        "@dbus-1__1.12.8-19.el8.x86_64//rpm",
+        "@dbus-common-1__1.12.8-19.el8.x86_64//rpm",
+        "@dbus-daemon-1__1.12.8-19.el8.x86_64//rpm",
+        "@dbus-libs-1__1.12.8-19.el8.x86_64//rpm",
+        "@dbus-tools-1__1.12.8-19.el8.x86_64//rpm",
         "@device-mapper-8__1.02.181-3.el8.x86_64//rpm",
         "@device-mapper-libs-8__1.02.181-3.el8.x86_64//rpm",
-        "@e2fsprogs-0__1.45.6-4.el8.x86_64//rpm",
-        "@e2fsprogs-libs-0__1.45.6-4.el8.x86_64//rpm",
-        "@elfutils-default-yama-scope-0__0.186-1.el8.x86_64//rpm",
-        "@elfutils-libelf-0__0.186-1.el8.x86_64//rpm",
-        "@elfutils-libs-0__0.186-1.el8.x86_64//rpm",
-        "@expat-0__2.2.5-8.el8.x86_64//rpm",
+        "@e2fsprogs-0__1.45.6-5.el8.x86_64//rpm",
+        "@e2fsprogs-libs-0__1.45.6-5.el8.x86_64//rpm",
+        "@elfutils-default-yama-scope-0__0.187-4.el8.x86_64//rpm",
+        "@elfutils-libelf-0__0.187-4.el8.x86_64//rpm",
+        "@elfutils-libs-0__0.187-4.el8.x86_64//rpm",
+        "@expat-0__2.2.5-9.el8.x86_64//rpm",
         "@filesystem-0__3.8-6.el8.x86_64//rpm",
-        "@fuse-libs-0__2.9.7-15.el8.x86_64//rpm",
+        "@fuse-libs-0__2.9.7-16.el8.x86_64//rpm",
         "@gawk-0__4.2.1-4.el8.x86_64//rpm",
-        "@glib2-0__2.56.4-158.el8.x86_64//rpm",
-        "@glibc-0__2.28-196.el8.x86_64//rpm",
-        "@glibc-common-0__2.28-196.el8.x86_64//rpm",
-        "@glibc-minimal-langpack-0__2.28-196.el8.x86_64//rpm",
+        "@glib2-0__2.56.4-159.el8.x86_64//rpm",
+        "@glibc-0__2.28-208.el8.x86_64//rpm",
+        "@glibc-common-0__2.28-208.el8.x86_64//rpm",
+        "@glibc-minimal-langpack-0__2.28-208.el8.x86_64//rpm",
         "@gmp-1__6.1.2-10.el8.x86_64//rpm",
         "@gnutls-0__3.6.16-4.el8.x86_64//rpm",
         "@grep-0__3.1-6.el8.x86_64//rpm",
-        "@gzip-0__1.9-12.el8.x86_64//rpm",
+        "@gzip-0__1.9-13.el8.x86_64//rpm",
         "@info-0__6.5-7.el8_5.x86_64//rpm",
         "@iputils-0__20180629-10.el8.x86_64//rpm",
         "@json-c-0__0.13.1-3.el8.x86_64//rpm",
         "@keyutils-libs-0__1.5.10-9.el8.x86_64//rpm",
         "@kmod-libs-0__25-19.el8.x86_64//rpm",
-        "@krb5-libs-0__1.18.2-14.el8.x86_64//rpm",
+        "@krb5-libs-0__1.18.2-21.el8.x86_64//rpm",
         "@libacl-0__2.2.53-1.el8.x86_64//rpm",
         "@libaio-0__0.3.112-1.el8.x86_64//rpm",
         "@libattr-0__2.4.48-3.el8.x86_64//rpm",
         "@libblkid-0__2.32.1-35.el8.x86_64//rpm",
-        "@libcap-0__2.48-2.el8.x86_64//rpm",
+        "@libcap-0__2.48-4.el8.x86_64//rpm",
         "@libcap-ng-0__0.7.11-1.el8.x86_64//rpm",
-        "@libcom_err-0__1.45.6-4.el8.x86_64//rpm",
-        "@libcurl-minimal-0__7.61.1-22.el8.x86_64//rpm",
+        "@libcom_err-0__1.45.6-5.el8.x86_64//rpm",
+        "@libcurl-minimal-0__7.61.1-25.el8.x86_64//rpm",
         "@libdb-0__5.3.28-42.el8_4.x86_64//rpm",
         "@libfdisk-0__2.32.1-35.el8.x86_64//rpm",
         "@libffi-0__3.1-23.el8.x86_64//rpm",
-        "@libgcc-0__8.5.0-10.el8.x86_64//rpm",
-        "@libgcrypt-0__1.8.5-6.el8.x86_64//rpm",
+        "@libgcc-0__8.5.0-15.el8.x86_64//rpm",
+        "@libgcrypt-0__1.8.5-7.el8.x86_64//rpm",
         "@libgpg-error-0__1.31-1.el8.x86_64//rpm",
         "@libibverbs-0__37.2-1.el8.x86_64//rpm",
         "@libidn2-0__2.2.0-1.el8.x86_64//rpm",
         "@libmount-0__2.32.1-35.el8.x86_64//rpm",
         "@libnghttp2-0__1.33.0-3.el8_2.1.x86_64//rpm",
-        "@libnl3-0__3.5.0-1.el8.x86_64//rpm",
+        "@libnl3-0__3.7.0-1.el8.x86_64//rpm",
         "@libnsl2-0__1.2.0-2.20180605git4a062cf.el8.x86_64//rpm",
         "@libpcap-14__1.9.1-5.el8.x86_64//rpm",
         "@libpwquality-0__1.4.4-3.el8.x86_64//rpm",
@@ -1624,43 +1645,49 @@ rpmtree(
         "@libsepol-0__2.9-3.el8.x86_64//rpm",
         "@libsigsegv-0__2.11-5.el8.x86_64//rpm",
         "@libsmartcols-0__2.32.1-35.el8.x86_64//rpm",
-        "@libss-0__1.45.6-4.el8.x86_64//rpm",
+        "@libss-0__1.45.6-5.el8.x86_64//rpm",
+        "@libstdc__plus____plus__-0__8.5.0-15.el8.x86_64//rpm",
         "@libtasn1-0__4.13-3.el8.x86_64//rpm",
-        "@libtirpc-0__1.1.4-6.el8.x86_64//rpm",
+        "@libtirpc-0__1.1.4-7.el8.x86_64//rpm",
         "@libunistring-0__0.9.9-3.el8.x86_64//rpm",
         "@libutempter-0__1.1.6-14.el8.x86_64//rpm",
         "@libuuid-0__2.32.1-35.el8.x86_64//rpm",
-        "@libverto-0__0.3.0-5.el8.x86_64//rpm",
+        "@libverto-0__0.3.2-2.el8.x86_64//rpm",
         "@libxcrypt-0__4.1.1-6.el8.x86_64//rpm",
         "@libzstd-0__1.4.4-1.el8.x86_64//rpm",
         "@lz4-libs-0__1.8.3-3.el8_4.x86_64//rpm",
+        "@mozjs60-0__60.9.0-4.el8.x86_64//rpm",
         "@mpfr-0__3.1.6-1.el8.x86_64//rpm",
         "@ncurses-base-0__6.1-9.20180224.el8.x86_64//rpm",
         "@ncurses-libs-0__6.1-9.20180224.el8.x86_64//rpm",
         "@nettle-0__3.4.1-7.el8.x86_64//rpm",
-        "@nmap-ncat-2__7.70-6.el8.x86_64//rpm",
+        "@nmap-ncat-2__7.70-7.el8.x86_64//rpm",
         "@openssl-libs-1__1.1.1k-6.el8.x86_64//rpm",
         "@p11-kit-0__0.23.22-1.el8.x86_64//rpm",
         "@p11-kit-trust-0__0.23.22-1.el8.x86_64//rpm",
-        "@pam-0__1.3.1-16.el8.x86_64//rpm",
+        "@pam-0__1.3.1-22.el8.x86_64//rpm",
         "@pcre-0__8.42-6.el8.x86_64//rpm",
-        "@pcre2-0__10.32-2.el8.x86_64//rpm",
+        "@pcre2-0__10.32-3.el8.x86_64//rpm",
+        "@polkit-0__0.115-13.0.1.el8.2.x86_64//rpm",
+        "@polkit-libs-0__0.115-13.0.1.el8.2.x86_64//rpm",
+        "@polkit-pkla-compat-0__0.1-12.el8.x86_64//rpm",
         "@popt-0__1.18-1.el8.x86_64//rpm",
         "@procps-ng-0__3.3.15-7.el8.x86_64//rpm",
         "@qemu-img-15__6.2.0-5.module_el8.6.0__plus__1087__plus__b42c8331.x86_64//rpm",
         "@readline-0__7.0-10.el8.x86_64//rpm",
         "@sed-0__4.5-5.el8.x86_64//rpm",
-        "@setup-0__2.12.2-6.el8.x86_64//rpm",
+        "@setup-0__2.12.2-7.el8.x86_64//rpm",
         "@shadow-utils-2__4.6-16.el8.x86_64//rpm",
-        "@systemd-0__239-58.el8.x86_64//rpm",
-        "@systemd-libs-0__239-58.el8.x86_64//rpm",
-        "@systemd-pam-0__239-58.el8.x86_64//rpm",
-        "@tzdata-0__2022a-1.el8.x86_64//rpm",
+        "@systemd-0__239-60.el8.x86_64//rpm",
+        "@systemd-libs-0__239-60.el8.x86_64//rpm",
+        "@systemd-pam-0__239-60.el8.x86_64//rpm",
+        "@timedatex-0__0.5-3.el8.x86_64//rpm",
+        "@tzdata-0__2022a-2.el8.x86_64//rpm",
         "@util-linux-0__2.32.1-35.el8.x86_64//rpm",
-        "@vim-minimal-2__8.0.1763-16.el8_5.12.x86_64//rpm",
-        "@which-0__2.21-17.el8.x86_64//rpm",
-        "@xz-libs-0__5.2.4-3.el8.x86_64//rpm",
-        "@zlib-0__1.2.11-17.el8.x86_64//rpm",
+        "@vim-minimal-2__8.0.1763-19.el8.4.x86_64//rpm",
+        "@which-0__2.21-18.el8.x86_64//rpm",
+        "@xz-libs-0__5.2.4-4.el8.x86_64//rpm",
+        "@zlib-0__1.2.11-19.el8.x86_64//rpm",
     ],
     symlinks = {
         "/var/run": "../run",
```