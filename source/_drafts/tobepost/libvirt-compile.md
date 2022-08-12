---
title: libvirt-compile
readmore: true
date: 2022-08-12 18:40:38
categories:
tags:
---


# 背景

有时候需要测试特定版本的libvirt或者需要测试自己修改过的libvirt。这时候就需要重新编译libvirt，并做成yum源

# step1：checkout libvirt 官方仓库的某个版本

```bash
[root@kubevirtci ~]# git clone https://www.github.com/libvirt/libvirt
Cloning into 'libvirt'...
warning: redirecting to https://github.com/libvirt/libvirt.git/
remote: Enumerating objects: 403220, done.
remote: Counting objects: 100% (2403/2403), done.
remote: Compressing objects: 100% (481/481), done.
remote: Total 403220 (delta 2061), reused 2133 (delta 1922), pack-reused 400817
Receiving objects: 100% (403220/403220), 724.13 MiB | 10.53 MiB/s, done.
Resolving deltas: 100% (345691/345691), done.
[root@kubevirtci ~]# cd libvirt/
[root@kubevirtci libvirt]# git tag
[root@kubevirtci libvirt]# git checkout -b v8.1.0 v8.1.0
Switched to a new branch 'v8.1.0
```

# step2：创建libvirt build容器并进入
```bash
[root@kubevirtci libvirt]# docker volume create rpms
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
rpms
[root@kubevirtci libvirt]# docker run -td -w /libvirt-src --security-opt label=disable --name libvirt-build -v $(pwd):/libvirt-src -v rpms:/root/rpmbuild/RPMS registry.gitlab.com/libvirt/libvirt/ci-centos-stream-8
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
c638434752817bd6ec866cb0b33ddcb17c251655f9bcb0ec8e0cebdc15bb50ea
[root@kubevirtci libvirt]# docker exec -ti libvirt-build bash
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
[root@c63843475281 libvirt-src]# 
```

```bash
[root@c63843475281 libvirt-src]# dnf update -y
[root@c63843475281 libvirt-src]# meson build
The Meson build system
Version: 0.58.2
Source dir: /libvirt-src
Build dir: /libvirt-src/build
Build type: native build
Project name: libvirt
Project version: 8.1.0
C compiler for the host machine: ccache cc (gcc 8.5.0 "cc (GCC) 8.5.0 20210514 (Red Hat 8.5.0-15)")
C linker for the host machine: cc ld.bfd 2.30-117
Host machine cpu family: x86_64
Host machine cpu: x86_64
Configuring configmake.h using configuration
Checking for size of "ptrdiff_t" : 8
Checking for size of "size_t" : 8
Compiler for C supports arguments -Werror: YES 
Compiler for C supports arguments -fasynchronous-unwind-tables: YES 
Compiler for C supports arguments -fexceptions: YES 
Compiler for C supports arguments -fipa-pure-const: YES 
Compiler for C supports arguments -fno-common: YES 
Compiler for C supports arguments -Wabsolute-value: NO 
Compiler for C supports arguments -Waddress: YES 
Compiler for C supports arguments -Waddress-of-packed-member: NO 
Compiler for C supports arguments -Waggressive-loop-optimizations: YES 
Compiler for C supports arguments -Walloc-size-larger-than=9223372036854775807: YES 
Compiler for C supports arguments -Walloca: YES 
Compiler for C supports arguments -Warray-bounds=2: YES 
Compiler for C supports arguments -Wattribute-alias=2: NO 
Compiler for C supports arguments -Wattribute-warning: NO 
Compiler for C supports arguments -Wattributes: YES 
Compiler for C supports arguments -Wbool-compare: YES 
Compiler for C supports arguments -Wbool-operation: YES 
Compiler for C supports arguments -Wbuiltin-declaration-mismatch: YES 
Compiler for C supports arguments -Wbuiltin-macro-redefined: YES 
Compiler for C supports arguments -Wcannot-profile: NO 
Compiler for C supports arguments -Wcast-align: YES 
Compiler for C supports arguments -Wcast-align=strict: YES 
Compiler for C supports arguments -Wno-cast-function-type: YES 
Compiler for C supports arguments -Wchar-subscripts: YES 
Compiler for C supports arguments -Wclobbered: YES 
Compiler for C supports arguments -Wcomment: YES 
Compiler for C supports arguments -Wcomments: YES 
Compiler for C supports arguments -Wcoverage-mismatch: YES 
Compiler for C supports arguments -Wcpp: YES 
Compiler for C supports arguments -Wdangling-else: YES 
Compiler for C supports arguments -Wdate-time: YES 
Compiler for C supports arguments -Wdeclaration-after-statement: YES 
Compiler for C supports arguments -Wdeprecated-declarations: YES 
Compiler for C supports arguments -Wdesignated-init: YES 
Compiler for C supports arguments -Wdiscarded-array-qualifiers: YES 
Compiler for C supports arguments -Wdiscarded-qualifiers: YES 
Compiler for C supports arguments -Wdiv-by-zero: YES 
Compiler for C supports arguments -Wduplicated-cond: YES 
Compiler for C supports arguments -Wduplicate-decl-specifier: YES 
Compiler for C supports arguments -Wempty-body: YES 
Compiler for C supports arguments -Wendif-labels: YES 
Compiler for C supports arguments -Wexpansion-to-defined: YES 
Compiler for C supports arguments -Wformat-contains-nul: YES 
Compiler for C supports arguments -Wformat-extra-args: YES 
Compiler for C supports arguments -Wno-format-nonliteral: YES 
Compiler for C supports arguments -Wformat-overflow=2: YES 
Compiler for C supports arguments -Wformat-security: YES 
Compiler for C supports arguments -Wno-format-truncation: YES 
Compiler for C supports arguments -Wformat-y2k: YES 
Compiler for C supports arguments -Wformat-zero-length: YES 
Compiler for C supports arguments -Wframe-address: YES 
Compiler for C supports arguments -Wframe-larger-than=4096: YES 
Compiler for C supports arguments -Wfree-nonheap-object: YES 
Compiler for C supports arguments -Whsa: YES 
Compiler for C supports arguments -Wif-not-aligned: YES 
Compiler for C supports arguments -Wignored-attributes: YES 
Compiler for C supports arguments -Wignored-qualifiers: YES 
Compiler for C supports arguments -Wimplicit: YES 
Compiler for C supports arguments -Wimplicit-fallthrough=5: YES 
Compiler for C supports arguments -Wimplicit-function-declaration: YES 
Compiler for C supports arguments -Wimplicit-int: YES 
Compiler for C supports arguments -Wincompatible-pointer-types: YES 
Compiler for C supports arguments -Winit-self: YES 
Compiler for C supports arguments -Winline: YES 
Compiler for C supports arguments -Wint-conversion: YES 
Compiler for C supports arguments -Wint-in-bool-context: YES 
Compiler for C supports arguments -Wint-to-pointer-cast: YES 
Compiler for C supports arguments -Winvalid-memory-model: YES 
Compiler for C supports arguments -Winvalid-pch: YES 
Compiler for C supports arguments -Wjump-misses-init: YES 
Compiler for C supports arguments -Wlogical-not-parentheses: YES 
Compiler for C supports arguments -Wlogical-op: YES 
Compiler for C supports arguments -Wmain: YES 
Compiler for C supports arguments -Wmaybe-uninitialized: YES 
Compiler for C supports arguments -Wmemset-elt-size: YES 
Compiler for C supports arguments -Wmemset-transposed-args: YES 
Compiler for C supports arguments -Wmisleading-indentation: YES 
Compiler for C supports arguments -Wmissing-attributes: YES 
Compiler for C supports arguments -Wmissing-braces: YES 
Compiler for C supports arguments -Wmissing-declarations: YES 
Compiler for C supports arguments -Wmissing-field-initializers: YES 
Compiler for C supports arguments -Wmissing-include-dirs: YES 
Compiler for C supports arguments -Wmissing-parameter-type: YES 
Compiler for C supports arguments -Wmissing-profile: NO 
Compiler for C supports arguments -Wmissing-prototypes: YES 
Compiler for C supports arguments -Wmultichar: YES 
Compiler for C supports arguments -Wmultistatement-macros: YES 
Compiler for C supports arguments -Wnarrowing: YES 
Compiler for C supports arguments -Wnested-externs: YES 
Compiler for C supports arguments -Wnonnull: YES 
Compiler for C supports arguments -Wnonnull-compare: YES 
Compiler for C supports arguments -Wnormalized=nfc: YES 
Compiler for C supports arguments -Wnull-dereference: YES 
Compiler for C supports arguments -Wodr: YES 
Compiler for C supports arguments -Wold-style-declaration: YES 
Compiler for C supports arguments -Wold-style-definition: YES 
Compiler for C supports arguments -Wopenmp-simd: YES 
Compiler for C supports arguments -Woverflow: YES 
Compiler for C supports arguments -Woverride-init: YES 
Compiler for C supports arguments -Wpacked-bitfield-compat: YES 
Compiler for C supports arguments -Wpacked-not-aligned: YES 
Compiler for C supports arguments -Wparentheses: YES 
Compiler for C supports arguments -Wpointer-arith: YES 
Compiler for C supports arguments -Wpointer-compare: YES 
Compiler for C supports arguments -Wpointer-sign: YES 
Compiler for C supports arguments -Wpointer-to-int-cast: YES 
Compiler for C supports arguments -Wpragmas: YES 
Compiler for C supports arguments -Wpsabi: YES 
Compiler for C supports arguments -Wrestrict: YES 
Compiler for C supports arguments -Wreturn-local-addr: YES 
Compiler for C supports arguments -Wreturn-type: YES 
Compiler for C supports arguments -Wscalar-storage-order: YES 
Compiler for C supports arguments -Wsequence-point: YES 
Compiler for C supports arguments -Wshadow: YES 
Compiler for C supports arguments -Wshift-count-negative: YES 
Compiler for C supports arguments -Wshift-count-overflow: YES 
Compiler for C supports arguments -Wshift-negative-value: YES 
Compiler for C supports arguments -Wshift-overflow=2: YES 
Compiler for C supports arguments -Wno-sign-compare: YES 
Compiler for C supports arguments -Wsizeof-array-argument: YES 
Compiler for C supports arguments -Wsizeof-pointer-div: YES 
Compiler for C supports arguments -Wsizeof-pointer-memaccess: YES 
Compiler for C supports arguments -Wstrict-aliasing: YES 
Compiler for C supports arguments -Wstrict-prototypes: YES 
Compiler for C supports arguments -Wstringop-overflow=2: YES 
Compiler for C supports arguments -Wstringop-truncation: YES 
Compiler for C supports arguments -Wsuggest-attribute=cold: YES 
Compiler for C supports arguments -Wno-suggest-attribute=const: YES 
Compiler for C supports arguments -Wsuggest-attribute=format: YES 
Compiler for C supports arguments -Wsuggest-attribute=noreturn: YES 
Compiler for C supports arguments -Wno-suggest-attribute=pure: YES 
Compiler for C supports arguments -Wsuggest-final-methods: YES 
Compiler for C supports arguments -Wsuggest-final-types: YES 
Compiler for C supports arguments -Wswitch: YES 
Compiler for C supports arguments -Wswitch-bool: YES 
Compiler for C supports arguments -Wswitch-enum: YES 
Compiler for C supports arguments -Wswitch-unreachable: YES 
Compiler for C supports arguments -Wsync-nand: YES 
Compiler for C supports arguments -Wtautological-compare: YES 
Compiler for C supports arguments -Wtrampolines: YES 
Compiler for C supports arguments -Wtrigraphs: YES 
Compiler for C supports arguments -Wtype-limits: YES 
Compiler for C supports arguments -Wno-typedef-redefinition: NO 
Compiler for C supports arguments -Wuninitialized: YES 
Compiler for C supports arguments -Wunknown-pragmas: YES 
Compiler for C supports arguments -Wunused: YES 
Compiler for C supports arguments -Wunused-but-set-parameter: YES 
Compiler for C supports arguments -Wunused-but-set-variable: YES 
Compiler for C supports arguments -Wunused-const-variable=2: YES 
Compiler for C supports arguments -Wunused-function: YES 
Compiler for C supports arguments -Wunused-label: YES 
Compiler for C supports arguments -Wunused-local-typedefs: YES 
Compiler for C supports arguments -Wunused-parameter: YES 
Compiler for C supports arguments -Wunused-result: YES 
Compiler for C supports arguments -Wunused-value: YES 
Compiler for C supports arguments -Wunused-variable: YES 
Compiler for C supports arguments -Wvarargs: YES 
Compiler for C supports arguments -Wvariadic-macros: YES 
Compiler for C supports arguments -Wvector-operation-performance: YES 
Compiler for C supports arguments -Wvla: YES 
Compiler for C supports arguments -Wvolatile-register-var: YES 
Compiler for C supports arguments -Wwrite-strings: YES 
Compiler for C supports arguments -fstack-protector-strong: YES 
First supported argument: -fstack-protector-strong
Checking if "-Wdouble-promotion" compiles: YES 
meson.build:475: WARNING: Consider using the built-in werror option instead of using "-Werror".
Compiler for C supports arguments -Wsuggest-attribute=format: YES (cached)
Compiler for C supports arguments -Wframe-larger-than=262144: YES 
Compiler for C supports link arguments -Wl,-z,relro: YES 
Compiler for C supports link arguments -Wl,-z,now: YES 
Compiler for C supports link arguments -Wl,-z,nodelete: YES 
Compiler for C supports link arguments -Wl,-z,defs: YES 
Compiler for C supports link arguments -Wl,--no-copy-dt-needed-entries: YES 
Compiler for C supports link arguments -Wl,--version-script=/libvirt-src/src/libvirt_qemu.syms: YES 
Compiler for C supports link arguments -Wl,-export-dynamic: YES 
First supported link argument: -Wl,-export-dynamic
Checking for function "elf_aux_info" : NO 
Checking for function "fallocate" : YES 
Checking for function "getauxval" : YES 
Checking for function "getegid" : YES 
Checking for function "geteuid" : YES 
Checking for function "getgid" : YES 
Checking for function "getifaddrs" : YES 
Checking for function "getmntent_r" : YES 
Checking for function "getpwuid_r" : YES 
Checking for function "getrlimit" : YES 
Checking for function "getuid" : YES 
Checking for function "getutxid" : YES 
Checking for function "if_indextoname" : YES 
Checking for function "mmap" : YES 
Checking for function "newlocale" : YES 
Checking for function "pipe2" : YES 
Checking for function "posix_fallocate" : YES 
Checking for function "posix_memalign" : YES 
Checking for function "prlimit" : YES 
Checking for function "sched_setscheduler" : YES 
Checking for function "setgroups" : YES 
Checking for function "setns" : YES 
Checking for function "setrlimit" : YES 
Checking for function "symlink" : YES 
Checking for function "sysctlbyname" : NO 
Checking for function "__lxstat" : YES 
Checking for function "__lxstat64" : YES 
Checking for function "__xstat" : YES 
Checking for function "__xstat64" : YES 
Checking for function "lstat" : YES 
Checking for function "lstat64" : YES 
Checking for function "stat" : YES 
Checking for function "stat64" : YES 
Header <sys/stat.h> has symbol "__lxstat" : YES 
Header <sys/stat.h> has symbol "__lxstat64" : NO 
Header <sys/stat.h> has symbol "__xstat" : YES 
Header <sys/stat.h> has symbol "__xstat64" : NO 
Header <sys/stat.h> has symbol "lstat" : YES 
Header <sys/stat.h> has symbol "lstat64" : NO 
Header <sys/stat.h> has symbol "stat" : YES 
Header <sys/stat.h> has symbol "stat64" : NO 
Has header "asm/hwcap.h" : NO 
Has header "ifaddrs.h" : YES 
Has header "libtasn1.h" : YES 
Has header "linux/kvm.h" : YES 
Has header "linux/magic.h" : YES 
Has header "mntent.h" : YES 
Has header "net/ethernet.h" : YES 
Has header "net/if.h" : YES 
Has header "pty.h" : YES 
Has header "pwd.h" : YES 
Has header "sched.h" : YES 
Has header "sys/auxv.h" : YES 
Has header "sys/ioctl.h" : YES 
Has header "sys/mount.h" : YES 
Has header "sys/syscall.h" : YES 
Has header "sys/ucred.h" : NO 
Has header "syslog.h" : YES 
Has header "util.h" : NO 
Has header "xlocale.h" : NO 
Has header "linux/devlink.h" : YES 
Has header "linux/param.h" : YES 
Has header "linux/sockios.h" : YES 
Has header "linux/if_bridge.h" : YES 
Has header "linux/if_tun.h" : YES 
Header <endian.h> has symbol "htole64" : YES 
Header <linux/ethtool.h> has symbol "ETH_FLAG_TXVLAN" : YES 
Header <linux/ethtool.h> has symbol "ETH_FLAG_NTUPLE" : YES 
Header <linux/ethtool.h> has symbol "ETH_FLAG_RXHASH" : YES 
Header <linux/ethtool.h> has symbol "ETH_FLAG_LRO" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_GGSO" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_GGRO" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_GFLAGS" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_GFEATURES" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_SCOALESCE" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_GCOALESCE" : YES 
Header <linux/if_vlan.h> has symbol "GET_VLAN_VID_CMD" : YES 
Header <unistd.h> has symbol "SEEK_HOLE" : YES 
Header <net/if_dl.h> has symbol "link_addr" : NO 
Header <sched.h> has symbol "cpu_set_t" : YES 
Header <linux/devlink.h> has symbol "DEVLINK_CMD_ESWITCH_GET" : YES 
Header <linux/vhost.h> has symbol "VHOST_VSOCK_SET_GUEST_CID" : YES 
Header <linux/bpf.h> has symbol "BPF_PROG_QUERY" : YES 
Header <linux/bpf.h> has symbol "BPF_CGROUP_DEVICE" : YES 
Header <net/if_bridgevar.h> has symbol "BRDGSFD" : NO 
Header <sys/cpuset.h> has symbol "cpuset_getaffinity" : NO 
Header <mach/clock.h> has symbol "clock_serv_t" : NO 
Checking for type "struct ifreq" : YES 
Checking for type "struct sockpeercred" : NO 
Checking whether type "struct ifreq" has member "ifr_newname" : YES 
Checking whether type "struct ifreq" has member "ifr_ifindex" : YES 
Checking whether type "struct ifreq" has member "ifr_index" : NO 
Checking whether type "struct ifreq" has member "ifr_hwaddr" : YES 
Checking for size of "long" : 8
Program perl found: YES (/usr/bin/perl)
Program python3 found: YES (/usr/bin/python3)
Program xmllint found: YES (/usr/bin/xmllint)
Program xsltproc found: YES (/usr/bin/xsltproc)
Program rpcgen found: YES (/usr/bin/rpcgen)
Program augparse found: YES (/usr/bin/augparse)
Program dmidecode found: YES (/usr/sbin/dmidecode)
Program ebtables found: YES (/usr/sbin/ebtables)
Program flake8 found: YES (/usr/bin/flake8)
Program ip found: YES (/usr/sbin/ip)
Program ip6tables found: YES (/usr/sbin/ip6tables)
Program iptables found: YES (/usr/sbin/iptables)
Program iscsiadm found: YES (/usr/sbin/iscsiadm)
Program mdevctl found: NO
Program mm-ctl found: NO
Program modprobe found: YES (/usr/sbin/modprobe)
Program ovs-vsctl found: NO
Program pdwtags found: YES (/usr/bin/pdwtags)
Program rmmod found: YES (/usr/sbin/rmmod)
Program scrub found: YES (/usr/bin/scrub)
Program tc found: YES (/usr/sbin/tc)
Program udevadm found: YES (/usr/sbin/udevadm)
Found pkg-config: /usr/bin/pkg-config (1.4.2)
Run-time dependency libtirpc found: YES 1.1.4
Library acl found: YES
Did not find CMake 'cmake'
Found CMake: NO
Run-time dependency libapparmor found: NO (tried pkgconfig and cmake)
Library attr found: YES
Run-time dependency audit found: YES 3.0.7
Run-time dependency bash-completion found: YES 2.7
Run-time dependency blkid found: YES 2.32.1
Run-time dependency libcap-ng found: YES 0.7.11
Run-time dependency libcurl found: YES 7.61.1
Run-time dependency devmapper found: YES 1.02.181
Library dl found: YES
Has header "dlfcn.h" : YES 
Run-time dependency fuse found: YES 2.9.7
Run-time dependency glib-2.0 found: YES 2.56.4
Run-time dependency gobject-2.0 found: YES 2.56.4
Run-time dependency gio-unix-2.0 found: YES 2.56.4
Run-time dependency glusterfs-api found: YES 7.6.0
Run-time dependency gnutls found: YES 3.6.16
Run-time dependency libiscsi found: YES 1.18.0
Run-time dependency libnl-3.0 found: YES 3.7.0
Run-time dependency libnl-route-3.0 found: YES 3.7.0
Run-time dependency libparted found: YES 3.2
Run-time dependency pcap found: YES 1.9.1
Run-time dependency libssh found: YES 0.9.6
Checking for function "ssh_get_server_publickey" with dependency libssh: YES 
Checking for function "ssh_session_is_known_server" with dependency libssh: YES 
Checking for function "ssh_session_update_known_hosts" with dependency libssh: YES 
Run-time dependency libssh2 found: YES 1.9.0
Run-time dependency libxml-2.0 found: YES 2.9.7
Library m found: YES
Run-time dependency netcf found: YES 0.2.8
Checking for function "gettext" : YES 
Has header "libintl.h" : YES 
Program xgettext found: YES (/usr/bin/xgettext)
Program msgfmt found: YES (/usr/bin/msgfmt)
Program msgmerge found: YES (/usr/bin/msgmerge)
Library numa found: YES
Run-time dependency openwsman found: YES 2.6.5
Run-time dependency parallels-sdk found: NO (tried pkgconfig and cmake)
Run-time dependency pciaccess found: YES 0.14
Library rbd found: YES
Library rados found: YES
Checking for function "rbd_get_features" with dependency -lrbd: YES 
Checking for function "rbd_list2" with dependency -lrbd: NO 
Run-time dependency readline found: NO (tried pkgconfig and cmake)
Library readline found: YES
Header <readline/readline.h> has symbol "rl_completion_quote_character" : YES 
Run-time dependency libsanlock_client found: YES 3.8.4
Checking for function "sanlock_strerror" with dependency libsanlock_client: YES 
Run-time dependency libsasl2 found: YES 2.1.27
Run-time dependency libselinux found: YES 2.9
Run-time dependency threads found: YES
Run-time dependency libudev found: YES 239
Library util found: YES
Run-time dependency wireshark found: YES 2.6.2
Has header "wireshark/ws_version.h" : NO 
Run-time dependency yajl found: YES 2.1.0
Program pkcheck found: YES (/usr/bin/pkcheck)
Run-time dependency xenlight found: NO (tried pkgconfig and cmake)
Checking if "lxc support" compiles: YES 
Program qemu-bridge-helper found: NO
Program qemu-pr-helper found: NO
Program slirp-helper found: NO
Program dbus-daemon found: YES (/usr/bin/dbus-daemon)
Has header "mntent.h" : YES (cached)
Program mount found: YES (/usr/bin/mount)
Program umount found: YES (/usr/bin/umount)
Program mkfs found: YES (/usr/sbin/mkfs)
Program showmount found: YES (/usr/sbin/showmount)
Program pvcreate found: YES (/usr/sbin/pvcreate)
Program vgcreate found: YES (/usr/sbin/vgcreate)
Program lvcreate found: YES (/usr/sbin/lvcreate)
Program pvremove found: YES (/usr/sbin/pvremove)
Program vgremove found: YES (/usr/sbin/vgremove)
Program lvremove found: YES (/usr/sbin/lvremove)
Program lvchange found: YES (/usr/sbin/lvchange)
Program vgchange found: YES (/usr/sbin/vgchange)
Program vgscan found: YES (/usr/sbin/vgscan)
Program pvs found: YES (/usr/sbin/pvs)
Program vgs found: YES (/usr/sbin/vgs)
Program lvs found: YES (/usr/sbin/lvs)
Program dog found: NO
Program dtrace found: YES (/usr/bin/dtrace)
Program systemctl found: YES (/usr/bin/systemctl)
Has header "nss.h" : YES 
Checking for type "struct gaih_addrtuple" : YES 
Checking for type "ns_mtab" : NO 
Program numad found: YES (/usr/bin/numad)
Program apibuild.py found: YES (/libvirt-src/scripts/apibuild.py)
Program augeas-gentest.py found: YES (/libvirt-src/scripts/augeas-gentest.py)
Program check-aclperms.py found: YES (/libvirt-src/scripts/check-aclperms.py)
Program check-aclrules.py found: YES (/libvirt-src/scripts/check-aclrules.py)
Program check-driverimpls.py found: YES (/libvirt-src/scripts/check-driverimpls.py)
Program check-drivername.py found: YES (/usr/libexec/platform-python /libvirt-src/scripts/check-drivername.py)
Program check-file-access.py found: YES (/libvirt-src/scripts/check-file-access.py)
Program check-remote-protocol.py found: YES (/usr/libexec/platform-python /libvirt-src/scripts/check-remote-protocol.py)
Program check-symfile.py found: YES (/libvirt-src/scripts/check-symfile.py)
Program check-symsorting.py found: YES (/libvirt-src/scripts/check-symsorting.py)
Program dtrace2systemtap.py found: YES (/libvirt-src/scripts/dtrace2systemtap.py)
Program esx_vi_generator.py found: YES (/libvirt-src/scripts/esx_vi_generator.py)
Program genaclperms.py found: YES (/libvirt-src/scripts/genaclperms.py)
Program genpolkit.py found: YES (/libvirt-src/scripts/genpolkit.py)
Program gensystemtap.py found: YES (/libvirt-src/scripts/gensystemtap.py)
Program group-qemu-caps.py found: YES (/libvirt-src/scripts/group-qemu-caps.py)
Program header-ifdef.py found: YES (/usr/libexec/platform-python /libvirt-src/scripts/header-ifdef.py)
Program hvsupport.py found: YES (/libvirt-src/scripts/hvsupport.py)
Program hyperv_wmi_generator.py found: YES (/libvirt-src/scripts/hyperv_wmi_generator.py)
Program meson-dist.py found: YES (/libvirt-src/scripts/meson-dist.py)
Program meson-gen-authors.py found: YES (/libvirt-src/scripts/meson-gen-authors.py)
Program meson-gen-def.py found: YES (/libvirt-src/scripts/meson-gen-def.py)
Program meson-gen-sym.py found: YES (/libvirt-src/scripts/meson-gen-sym.py)
Program meson-install-dirs.py found: YES (/usr/libexec/platform-python /libvirt-src/scripts/meson-install-dirs.py)
Program meson-install-symlink.py found: YES (/usr/libexec/platform-python /libvirt-src/scripts/meson-install-symlink.py)
Program meson-install-web.py found: YES (/libvirt-src/scripts/meson-install-web.py)
Program meson-python.sh found: YES (/libvirt-src/scripts/meson-python.sh)
Program meson-timestamp.py found: YES (/libvirt-src/scripts/meson-timestamp.py)
Program mock-noinline.py found: YES (/usr/libexec/platform-python /libvirt-src/scripts/mock-noinline.py)
Program prohibit-duplicate-header.py found: YES (/usr/libexec/platform-python /libvirt-src/scripts/prohibit-duplicate-header.py)
Configuring libvirt-common.h using configuration
Program env found: YES (/usr/bin/env)
Program env found: YES (/usr/bin/env)
Program /libvirt-src/src/keycodemapdb/tools/keymap-gen found: YES (/libvirt-src/src/keycodemapdb/tools/keymap-gen)
Program genprotocol.pl found: YES (/libvirt-src/src/rpc/genprotocol.pl)
Program gendispatch.pl found: YES (/libvirt-src/src/rpc/gendispatch.pl)
Configuring libvirtd.conf.tmp with command
Configuring libvirtd.aug.tmp with command
Configuring test_libvirtd.aug.tmp with command
Configuring virtd.conf.tmp with command
Configuring virtd.aug.tmp with command
Configuring test_virtd.aug.tmp with command
Configuring libvirtd.qemu.logrotate using configuration
Configuring libvirtd.lxc.logrotate using configuration
Configuring libvirtd.libxl.logrotate using configuration
Configuring libvirtd.logrotate using configuration
Program /libvirt-src/scripts/meson-python.sh found: YES (/libvirt-src/scripts/meson-python.sh)
Program env found: YES (/usr/bin/env)
Program env found: YES (/usr/bin/env)
Configuring libvirtd.conf using configuration
Configuring libvirtd.aug using configuration
Configuring test_libvirtd.aug.tmp using configuration
Configuring virtproxyd.conf using configuration
Configuring virtproxyd.aug using configuration
Configuring test_virtproxyd.aug.tmp using configuration
Configuring virtinterfaced.conf using configuration
Configuring virtinterfaced.aug using configuration
Configuring test_virtinterfaced.aug.tmp using configuration
Configuring virtnetworkd.conf using configuration
Configuring virtnetworkd.aug using configuration
Configuring test_virtnetworkd.aug.tmp using configuration
Configuring virtnodedevd.conf using configuration
Configuring virtnodedevd.aug using configuration
Configuring test_virtnodedevd.aug.tmp using configuration
Configuring virtnwfilterd.conf using configuration
Configuring virtnwfilterd.aug using configuration
Configuring test_virtnwfilterd.aug.tmp using configuration
Configuring virtsecretd.conf using configuration
Configuring virtsecretd.aug using configuration
Configuring test_virtsecretd.aug.tmp using configuration
Configuring virtstoraged.conf using configuration
Configuring virtstoraged.aug using configuration
Configuring test_virtstoraged.aug.tmp using configuration
Configuring virtlxcd.conf using configuration
Configuring virtlxcd.aug using configuration
Configuring test_virtlxcd.aug.tmp using configuration
Configuring virtchd.conf using configuration
Configuring virtchd.aug using configuration
Configuring test_virtchd.aug.tmp using configuration
Configuring virtqemud.conf using configuration
Configuring virtqemud.aug using configuration
Configuring test_virtqemud.aug.tmp using configuration
Configuring virtvboxd.conf using configuration
Configuring virtvboxd.aug using configuration
Configuring test_virtvboxd.aug.tmp using configuration
Configuring libvirtd.service using configuration
Configuring libvirtd.socket using configuration
Configuring libvirtd-ro.socket using configuration
Configuring libvirtd-admin.socket using configuration
Configuring libvirtd-tcp.socket using configuration
Configuring libvirtd-tls.socket using configuration
Configuring virtproxyd.service using configuration
Configuring virtproxyd.socket using configuration
Configuring virtproxyd-ro.socket using configuration
Configuring virtproxyd-admin.socket using configuration
Configuring virtproxyd-tcp.socket using configuration
Configuring virtproxyd-tls.socket using configuration
Configuring virtinterfaced.service using configuration
Configuring virtinterfaced.socket using configuration
Configuring virtinterfaced-ro.socket using configuration
Configuring virtinterfaced-admin.socket using configuration
Configuring virtlockd.service using configuration
Configuring virtlockd.socket using configuration
Configuring virtlockd-admin.socket using configuration
Configuring virtlogd.service using configuration
Configuring virtlogd.socket using configuration
Configuring virtlogd-admin.socket using configuration
Configuring virtnetworkd.service using configuration
Configuring virtnetworkd.socket using configuration
Configuring virtnetworkd-ro.socket using configuration
Configuring virtnetworkd-admin.socket using configuration
Configuring virtnodedevd.service using configuration
Configuring virtnodedevd.socket using configuration
Configuring virtnodedevd-ro.socket using configuration
Configuring virtnodedevd-admin.socket using configuration
Configuring virtnwfilterd.service using configuration
Configuring virtnwfilterd.socket using configuration
Configuring virtnwfilterd-ro.socket using configuration
Configuring virtnwfilterd-admin.socket using configuration
Configuring virtsecretd.service using configuration
Configuring virtsecretd.socket using configuration
Configuring virtsecretd-ro.socket using configuration
Configuring virtsecretd-admin.socket using configuration
Configuring virtstoraged.service using configuration
Configuring virtstoraged.socket using configuration
Configuring virtstoraged-ro.socket using configuration
Configuring virtstoraged-admin.socket using configuration
Configuring virtlxcd.service using configuration
Configuring virtlxcd.socket using configuration
Configuring virtlxcd-ro.socket using configuration
Configuring virtlxcd-admin.socket using configuration
Configuring virtchd.service using configuration
Configuring virtchd.socket using configuration
Configuring virtchd-ro.socket using configuration
Configuring virtchd-admin.socket using configuration
Configuring virtqemud.service using configuration
Configuring virtqemud.socket using configuration
Configuring virtqemud-ro.socket using configuration
Configuring virtqemud-admin.socket using configuration
Configuring virtvboxd.service using configuration
Configuring virtvboxd.socket using configuration
Configuring virtvboxd-ro.socket using configuration
Configuring virtvboxd-admin.socket using configuration
Program /libvirt-src/scripts/meson-python.sh found: YES (/libvirt-src/scripts/meson-python.sh)
Configuring libvirt-lxc.pc using configuration
Configuring libvirt-qemu.pc using configuration
Configuring libvirt.pc using configuration
Configuring virt-xml-validate using configuration
Configuring virt-pki-validate using configuration
Configuring virt-sanlock-cleanup using configuration
Configuring libvirt-guests.sh using configuration
Configuring libvirt-guests.service using configuration
Configuring virsh using configuration
Configuring virt-admin using configuration
Program util/genxdrstub.pl found: YES (/libvirt-src/tools/wireshark/util/genxdrstub.pl)
Library tasn1 found: YES
Program libvirtd-fail found: YES (/libvirt-src/tests/libvirtd-fail)
Program libvirtd-pool found: YES (/libvirt-src/tests/libvirtd-pool)
Program virsh-auth found: YES (/libvirt-src/tests/virsh-auth)
Program virsh-checkpoint found: YES (/libvirt-src/tests/virsh-checkpoint)
Program virsh-cpuset found: YES (/libvirt-src/tests/virsh-cpuset)
Program virsh-define-dev-segfault found: YES (/libvirt-src/tests/virsh-define-dev-segfault)
Program virsh-int-overflow found: YES (/libvirt-src/tests/virsh-int-overflow)
Program virsh-optparse found: YES (/libvirt-src/tests/virsh-optparse)
Program virsh-output found: YES (/libvirt-src/tests/virsh-output)
Program virsh-read-bufsiz found: YES (/libvirt-src/tests/virsh-read-bufsiz)
Program virsh-read-non-seekable found: YES (/libvirt-src/tests/virsh-read-non-seekable)
Program virsh-schedinfo found: YES (/libvirt-src/tests/virsh-schedinfo)
Program virsh-self-test found: YES (/libvirt-src/tests/virsh-self-test)
Program virsh-snapshot found: YES (/libvirt-src/tests/virsh-snapshot)
Program virsh-start found: YES (/libvirt-src/tests/virsh-start)
Program virsh-undefine found: YES (/libvirt-src/tests/virsh-undefine)
Program virsh-uriprecedence found: YES (/libvirt-src/tests/virsh-uriprecedence)
Program virsh-vcpupin found: YES (/libvirt-src/tests/virsh-vcpupin)
Program virt-admin-self-test found: YES (/libvirt-src/tests/virt-admin-self-test)
Configuring POTFILES using configuration
Program rst2html5 found: YES (/usr/bin/rst2html5)
Program rst2man found: YES (/usr/bin/rst2man)
Configuring index.rst using configuration
Configuring virsh.rst using configuration
Configuring virt-admin.rst using configuration
Configuring virt-host-validate.rst using configuration
Configuring virt-login-shell.rst using configuration
Configuring virt-pki-query-dn.rst using configuration
Configuring virt-pki-validate.rst using configuration
Configuring virt-qemu-run.rst using configuration
Configuring virt-xml-validate.rst using configuration
Configuring libvirt-guests.rst using configuration
Configuring libvirtd.rst using configuration
Configuring virt-sanlock-cleanup.rst using configuration
Configuring virt-ssh-helper.rst using configuration
Configuring virtbhyved.rst using configuration
Configuring virtinterfaced.rst using configuration
Configuring virtlockd.rst using configuration
Configuring virtlogd.rst using configuration
Configuring virtlxcd.rst using configuration
Configuring virtnetworkd.rst using configuration
Configuring virtnodedevd.rst using configuration
Configuring virtnwfilterd.rst using configuration
Configuring virtproxyd.rst using configuration
Configuring virtqemud.rst using configuration
Configuring virtsecretd.rst using configuration
Configuring virtstoraged.rst using configuration
Configuring virtvboxd.rst using configuration
Configuring virtvzd.rst using configuration
Configuring virtxend.rst using configuration
Program make found: YES
Program sed found: YES (/usr/bin/sed)
Program grep found: YES (/usr/bin/grep)
Configuring Makefile using configuration
Configuring libvirt.pc using configuration
Configuring libvirt-qemu.pc using configuration
Configuring libvirt-lxc.pc using configuration
Configuring libvirt-admin.pc using configuration
Configuring libvirt.spec using configuration
Configuring mingw-libvirt.spec using configuration
Configuring AUTHORS.rst using configuration
Program /libvirt-src/scripts/meson-python.sh found: YES (/libvirt-src/scripts/meson-python.sh)
Program /libvirt-src/scripts/meson-python.sh found: YES (/libvirt-src/scripts/meson-python.sh)
Configuring meson-config.h using configuration
Configuring run using configuration
Configuring .color_coded using configuration
Configuring .ycm_extra_conf.py using configuration
Build targets in project: 617

libvirt 8.1.0

  Drivers
    QEMU               : YES
    OpenVZ             : YES
    VMware             : YES
    VBox               : YES
    libxl              : NO
    LXC                : YES
    Cloud-Hypervisor   : YES
    ESX                : YES
    Hyper-V            : YES
    vz                 : NO
    Bhyve              : NO
    Test               : YES
    Remote             : YES
    Network            : YES
    Libvirtd           : YES
    Interface          : YES

  Storage Drivers
    Dir                : YES
    FS                 : YES
    NetFS              : YES
    LVM                : YES
    iSCSI              : YES
    iscsi-direct       : YES
    SCSI               : YES
    mpath              : YES
    Disk               : YES
    RBD                : YES
    Sheepdog           : NO
    Gluster            : YES
    ZFS                : YES
    Virtuozzo storage  : YES

  Security Drivers
    SELinux            : YES
    AppArmor           : NO

  Driver Loadable Modules
    driver_modules     : YES

  Libraries
    acl                : YES
    apparmor           : NO
    attr               : YES
    audit              : YES
    bash_completion    : YES
    blkid              : YES
    capng              : YES
    curl               : YES
    devmapper          : YES
    dlopen             : YES
    fuse               : YES
    glusterfs          : YES
    libiscsi           : YES
    libkvm             : NO
    libnl              : YES
    libparted          : YES
    libpcap            : YES
    libssh             : YES
    libssh2            : YES
    libutil            : YES
    netcf              : YES
    NLS                : YES
    numactl            : YES
    openwsman          : YES
    parallels-sdk      : NO
    pciaccess          : YES
    polkit             : YES
    rbd                : YES
    readline           : YES
    sanlock            : YES
    sasl               : YES
    selinux            : YES
    udev               : YES
    xdr                : YES
    yajl               : YES

  Windows
    MinGW              : NO
    windres            : NO

  Test suite
    Expensive          : NO
    Coverage           : NO

  Miscellaneous
    Warning Flags      : -Werror -fasynchronous-unwind-tables -fexceptions -fipa-pure-const -fno-common -Waddress -Waggressive-loop-optimizations -Walloc-size-larger-than=9223372036854775807 -Walloca -Warray-bounds=2 -Wattributes -Wbool-compare -Wbool-operation
                         -Wbuiltin-declaration-mismatch -Wbuiltin-macro-redefined -Wcast-align -Wcast-align=strict -Wno-cast-function-type -Wchar-subscripts -Wclobbered -Wcomment -Wcomments -Wcoverage-mismatch -Wcpp -Wdangling-else -Wdate-time
                         -Wdeclaration-after-statement -Wdeprecated-declarations -Wdesignated-init -Wdiscarded-array-qualifiers -Wdiscarded-qualifiers -Wdiv-by-zero -Wduplicated-cond -Wduplicate-decl-specifier -Wempty-body -Wendif-labels -Wexpansion-to-defined
                         -Wformat-contains-nul -Wformat-extra-args -Wno-format-nonliteral -Wformat-overflow=2 -Wformat-security -Wno-format-truncation -Wformat-y2k -Wformat-zero-length -Wframe-address -Wframe-larger-than=4096 -Wfree-nonheap-object -Whsa
                         -Wif-not-aligned -Wignored-attributes -Wignored-qualifiers -Wimplicit -Wimplicit-fallthrough=5 -Wimplicit-function-declaration -Wimplicit-int -Wincompatible-pointer-types -Winit-self -Winline -Wint-conversion -Wint-in-bool-context
                         -Wint-to-pointer-cast -Winvalid-memory-model -Winvalid-pch -Wjump-misses-init -Wlogical-not-parentheses -Wlogical-op -Wmain -Wmaybe-uninitialized -Wmemset-elt-size -Wmemset-transposed-args -Wmisleading-indentation -Wmissing-attributes
                         -Wmissing-braces -Wmissing-declarations -Wmissing-field-initializers -Wmissing-include-dirs -Wmissing-parameter-type -Wmissing-prototypes -Wmultichar -Wmultistatement-macros -Wnarrowing -Wnested-externs -Wnonnull -Wnonnull-compare
                         -Wnormalized=nfc -Wnull-dereference -Wodr -Wold-style-declaration -Wold-style-definition -Wopenmp-simd -Woverflow -Woverride-init -Wpacked-bitfield-compat -Wpacked-not-aligned -Wparentheses -Wpointer-arith -Wpointer-compare -Wpointer-sign
                         -Wpointer-to-int-cast -Wpragmas -Wpsabi -Wrestrict -Wreturn-local-addr -Wreturn-type -Wscalar-storage-order -Wsequence-point -Wshadow -Wshift-count-negative -Wshift-count-overflow -Wshift-negative-value -Wshift-overflow=2 -Wno-sign-compare
                         -Wsizeof-array-argument -Wsizeof-pointer-div -Wsizeof-pointer-memaccess -Wstrict-aliasing -Wstrict-prototypes -Wstringop-overflow=2 -Wstringop-truncation -Wsuggest-attribute=cold -Wno-suggest-attribute=const -Wsuggest-attribute=format
                         -Wsuggest-attribute=noreturn -Wno-suggest-attribute=pure -Wsuggest-final-methods -Wsuggest-final-types -Wswitch -Wswitch-bool -Wswitch-enum -Wswitch-unreachable -Wsync-nand -Wtautological-compare -Wtrampolines -Wtrigraphs -Wtype-limits
                         -Wuninitialized -Wunknown-pragmas -Wunused -Wunused-but-set-parameter -Wunused-but-set-variable -Wunused-const-variable=2 -Wunused-function -Wunused-label -Wunused-local-typedefs -Wunused-parameter -Wunused-result -Wunused-value
                         -Wunused-variable -Wvarargs -Wvariadic-macros -Wvector-operation-performance -Wvla -Wvolatile-register-var -Wwrite-strings -fstack-protector-strong -Wdouble-promotion
    docs               : YES
    tests              : YES
    DTrace             : YES
    firewalld          : YES
    firewalld-zone     : YES
    nss                : YES
    numad              : YES
    Init script        : systemd
    Char device locks  : /var/lock
    Loader/NVRAM       : 
    pm_utils           : NO
    virt-login-shell   : YES
    virt-host-validate : YES
    TLS priority       : NORMAL

  Developer Tools
    wireshark_dissector: YES

  Privileges
    QEMU               : qemu:qemu

Found ninja-1.8.2 at /usr/bin/ninja
```

```bash
[root@c63843475281 libvirt-src]# ninja -C build dist
ninja: Entering directory `build'
[0/1] Creating source packages
Cloning into '/libvirt-src/build/meson-dist/libvirt-8.1.0'...
done.
Submodule 'keycodemapdb' (https://gitlab.com/keycodemap/keycodemapdb.git) registered for path 'src/keycodemapdb'
Cloning into '/libvirt-src/build/meson-dist/libvirt-8.1.0/src/keycodemapdb'...
Submodule path 'src/keycodemapdb': checked out '27acf0ef828bf719b2053ba398b195829413dbdd'
Running custom dist script '/libvirt-src/scripts/meson-python.sh /usr/bin/python3 /libvirt-src/scripts/meson-dist.py /libvirt-src/build libvirt.spec'
Running custom dist script '/libvirt-src/scripts/meson-python.sh /usr/bin/python3 /libvirt-src/scripts/meson-dist.py /libvirt-src/build AUTHORS.rst'
Testing distribution package /libvirt-src/build/meson-dist/libvirt-8.1.0.tar.xz
The Meson build system
Version: 0.58.2
Source dir: /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0
Build dir: /libvirt-src/build/meson-private/dist-build
Build type: native build
Project name: libvirt
Project version: 8.1.0
C compiler for the host machine: ccache cc (gcc 8.5.0 "cc (GCC) 8.5.0 20210514 (Red Hat 8.5.0-15)")
C linker for the host machine: cc ld.bfd 2.30-117
Host machine cpu family: x86_64
Host machine cpu: x86_64
Configuring configmake.h using configuration
Checking for size of "ptrdiff_t" : 8
Checking for size of "size_t" : 8
Compiler for C supports arguments -fasynchronous-unwind-tables: YES 
Compiler for C supports arguments -fexceptions: YES 
Compiler for C supports arguments -fipa-pure-const: YES 
Compiler for C supports arguments -fno-common: YES 
Compiler for C supports arguments -Wabsolute-value: NO 
Compiler for C supports arguments -Waddress: YES 
Compiler for C supports arguments -Waddress-of-packed-member: NO 
Compiler for C supports arguments -Waggressive-loop-optimizations: YES 
Compiler for C supports arguments -Walloc-size-larger-than=9223372036854775807: YES 
Compiler for C supports arguments -Walloca: YES 
Compiler for C supports arguments -Warray-bounds=2: YES 
Compiler for C supports arguments -Wattribute-alias=2: NO 
Compiler for C supports arguments -Wattribute-warning: NO 
Compiler for C supports arguments -Wattributes: YES 
Compiler for C supports arguments -Wbool-compare: YES 
Compiler for C supports arguments -Wbool-operation: YES 
Compiler for C supports arguments -Wbuiltin-declaration-mismatch: YES 
Compiler for C supports arguments -Wbuiltin-macro-redefined: YES 
Compiler for C supports arguments -Wcannot-profile: NO 
Compiler for C supports arguments -Wcast-align: YES 
Compiler for C supports arguments -Wcast-align=strict: YES 
Compiler for C supports arguments -Wno-cast-function-type: YES 
Compiler for C supports arguments -Wchar-subscripts: YES 
Compiler for C supports arguments -Wclobbered: YES 
Compiler for C supports arguments -Wcomment: YES 
Compiler for C supports arguments -Wcomments: YES 
Compiler for C supports arguments -Wcoverage-mismatch: YES 
Compiler for C supports arguments -Wcpp: YES 
Compiler for C supports arguments -Wdangling-else: YES 
Compiler for C supports arguments -Wdate-time: YES 
Compiler for C supports arguments -Wdeclaration-after-statement: YES 
Compiler for C supports arguments -Wdeprecated-declarations: YES 
Compiler for C supports arguments -Wdesignated-init: YES 
Compiler for C supports arguments -Wdiscarded-array-qualifiers: YES 
Compiler for C supports arguments -Wdiscarded-qualifiers: YES 
Compiler for C supports arguments -Wdiv-by-zero: YES 
Compiler for C supports arguments -Wduplicated-cond: YES 
Compiler for C supports arguments -Wduplicate-decl-specifier: YES 
Compiler for C supports arguments -Wempty-body: YES 
Compiler for C supports arguments -Wendif-labels: YES 
Compiler for C supports arguments -Wexpansion-to-defined: YES 
Compiler for C supports arguments -Wformat-contains-nul: YES 
Compiler for C supports arguments -Wformat-extra-args: YES 
Compiler for C supports arguments -Wno-format-nonliteral: YES 
Compiler for C supports arguments -Wformat-overflow=2: YES 
Compiler for C supports arguments -Wformat-security: YES 
Compiler for C supports arguments -Wno-format-truncation: YES 
Compiler for C supports arguments -Wformat-y2k: YES 
Compiler for C supports arguments -Wformat-zero-length: YES 
Compiler for C supports arguments -Wframe-address: YES 
Compiler for C supports arguments -Wframe-larger-than=4096: YES 
Compiler for C supports arguments -Wfree-nonheap-object: YES 
Compiler for C supports arguments -Whsa: YES 
Compiler for C supports arguments -Wif-not-aligned: YES 
Compiler for C supports arguments -Wignored-attributes: YES 
Compiler for C supports arguments -Wignored-qualifiers: YES 
Compiler for C supports arguments -Wimplicit: YES 
Compiler for C supports arguments -Wimplicit-fallthrough=5: YES 
Compiler for C supports arguments -Wimplicit-function-declaration: YES 
Compiler for C supports arguments -Wimplicit-int: YES 
Compiler for C supports arguments -Wincompatible-pointer-types: YES 
Compiler for C supports arguments -Winit-self: YES 
Compiler for C supports arguments -Winline: YES 
Compiler for C supports arguments -Wint-conversion: YES 
Compiler for C supports arguments -Wint-in-bool-context: YES 
Compiler for C supports arguments -Wint-to-pointer-cast: YES 
Compiler for C supports arguments -Winvalid-memory-model: YES 
Compiler for C supports arguments -Winvalid-pch: YES 
Compiler for C supports arguments -Wjump-misses-init: YES 
Compiler for C supports arguments -Wlogical-not-parentheses: YES 
Compiler for C supports arguments -Wlogical-op: YES 
Compiler for C supports arguments -Wmain: YES 
Compiler for C supports arguments -Wmaybe-uninitialized: YES 
Compiler for C supports arguments -Wmemset-elt-size: YES 
Compiler for C supports arguments -Wmemset-transposed-args: YES 
Compiler for C supports arguments -Wmisleading-indentation: YES 
Compiler for C supports arguments -Wmissing-attributes: YES 
Compiler for C supports arguments -Wmissing-braces: YES 
Compiler for C supports arguments -Wmissing-declarations: YES 
Compiler for C supports arguments -Wmissing-field-initializers: YES 
Compiler for C supports arguments -Wmissing-include-dirs: YES 
Compiler for C supports arguments -Wmissing-parameter-type: YES 
Compiler for C supports arguments -Wmissing-profile: NO 
Compiler for C supports arguments -Wmissing-prototypes: YES 
Compiler for C supports arguments -Wmultichar: YES 
Compiler for C supports arguments -Wmultistatement-macros: YES 
Compiler for C supports arguments -Wnarrowing: YES 
Compiler for C supports arguments -Wnested-externs: YES 
Compiler for C supports arguments -Wnonnull: YES 
Compiler for C supports arguments -Wnonnull-compare: YES 
Compiler for C supports arguments -Wnormalized=nfc: YES 
Compiler for C supports arguments -Wnull-dereference: YES 
Compiler for C supports arguments -Wodr: YES 
Compiler for C supports arguments -Wold-style-declaration: YES 
Compiler for C supports arguments -Wold-style-definition: YES 
Compiler for C supports arguments -Wopenmp-simd: YES 
Compiler for C supports arguments -Woverflow: YES 
Compiler for C supports arguments -Woverride-init: YES 
Compiler for C supports arguments -Wpacked-bitfield-compat: YES 
Compiler for C supports arguments -Wpacked-not-aligned: YES 
Compiler for C supports arguments -Wparentheses: YES 
Compiler for C supports arguments -Wpointer-arith: YES 
Compiler for C supports arguments -Wpointer-compare: YES 
Compiler for C supports arguments -Wpointer-sign: YES 
Compiler for C supports arguments -Wpointer-to-int-cast: YES 
Compiler for C supports arguments -Wpragmas: YES 
Compiler for C supports arguments -Wpsabi: YES 
Compiler for C supports arguments -Wrestrict: YES 
Compiler for C supports arguments -Wreturn-local-addr: YES 
Compiler for C supports arguments -Wreturn-type: YES 
Compiler for C supports arguments -Wscalar-storage-order: YES 
Compiler for C supports arguments -Wsequence-point: YES 
Compiler for C supports arguments -Wshadow: YES 
Compiler for C supports arguments -Wshift-count-negative: YES 
Compiler for C supports arguments -Wshift-count-overflow: YES 
Compiler for C supports arguments -Wshift-negative-value: YES 
Compiler for C supports arguments -Wshift-overflow=2: YES 
Compiler for C supports arguments -Wno-sign-compare: YES 
Compiler for C supports arguments -Wsizeof-array-argument: YES 
Compiler for C supports arguments -Wsizeof-pointer-div: YES 
Compiler for C supports arguments -Wsizeof-pointer-memaccess: YES 
Compiler for C supports arguments -Wstrict-aliasing: YES 
Compiler for C supports arguments -Wstrict-prototypes: YES 
Compiler for C supports arguments -Wstringop-overflow=2: YES 
Compiler for C supports arguments -Wstringop-truncation: YES 
Compiler for C supports arguments -Wsuggest-attribute=cold: YES 
Compiler for C supports arguments -Wno-suggest-attribute=const: YES 
Compiler for C supports arguments -Wsuggest-attribute=format: YES 
Compiler for C supports arguments -Wsuggest-attribute=noreturn: YES 
Compiler for C supports arguments -Wno-suggest-attribute=pure: YES 
Compiler for C supports arguments -Wsuggest-final-methods: YES 
Compiler for C supports arguments -Wsuggest-final-types: YES 
Compiler for C supports arguments -Wswitch: YES 
Compiler for C supports arguments -Wswitch-bool: YES 
Compiler for C supports arguments -Wswitch-enum: YES 
Compiler for C supports arguments -Wswitch-unreachable: YES 
Compiler for C supports arguments -Wsync-nand: YES 
Compiler for C supports arguments -Wtautological-compare: YES 
Compiler for C supports arguments -Wtrampolines: YES 
Compiler for C supports arguments -Wtrigraphs: YES 
Compiler for C supports arguments -Wtype-limits: YES 
Compiler for C supports arguments -Wno-typedef-redefinition: NO 
Compiler for C supports arguments -Wuninitialized: YES 
Compiler for C supports arguments -Wunknown-pragmas: YES 
Compiler for C supports arguments -Wunused: YES 
Compiler for C supports arguments -Wunused-but-set-parameter: YES 
Compiler for C supports arguments -Wunused-but-set-variable: YES 
Compiler for C supports arguments -Wunused-const-variable=2: YES 
Compiler for C supports arguments -Wunused-function: YES 
Compiler for C supports arguments -Wunused-label: YES 
Compiler for C supports arguments -Wunused-local-typedefs: YES 
Compiler for C supports arguments -Wunused-parameter: YES 
Compiler for C supports arguments -Wunused-result: YES 
Compiler for C supports arguments -Wunused-value: YES 
Compiler for C supports arguments -Wunused-variable: YES 
Compiler for C supports arguments -Wvarargs: YES 
Compiler for C supports arguments -Wvariadic-macros: YES 
Compiler for C supports arguments -Wvector-operation-performance: YES 
Compiler for C supports arguments -Wvla: YES 
Compiler for C supports arguments -Wvolatile-register-var: YES 
Compiler for C supports arguments -Wwrite-strings: YES 
Compiler for C supports arguments -fstack-protector-strong: YES 
First supported argument: -fstack-protector-strong
Checking if "-Wdouble-promotion" compiles: YES 
Compiler for C supports arguments -Wsuggest-attribute=format: YES (cached)
Compiler for C supports arguments -Wframe-larger-than=262144: YES 
Compiler for C supports link arguments -Wl,-z,relro: YES 
Compiler for C supports link arguments -Wl,-z,now: YES 
Compiler for C supports link arguments -Wl,-z,nodelete: YES 
Compiler for C supports link arguments -Wl,-z,defs: YES 
Compiler for C supports link arguments -Wl,--no-copy-dt-needed-entries: YES 
Compiler for C supports link arguments -Wl,--version-script=/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/libvirt_qemu.syms: YES 
Compiler for C supports link arguments -Wl,-export-dynamic: YES 
First supported link argument: -Wl,-export-dynamic
Checking for function "elf_aux_info" : NO 
Checking for function "fallocate" : YES 
Checking for function "getauxval" : YES 
Checking for function "getegid" : YES 
Checking for function "geteuid" : YES 
Checking for function "getgid" : YES 
Checking for function "getifaddrs" : YES 
Checking for function "getmntent_r" : YES 
Checking for function "getpwuid_r" : YES 
Checking for function "getrlimit" : YES 
Checking for function "getuid" : YES 
Checking for function "getutxid" : YES 
Checking for function "if_indextoname" : YES 
Checking for function "mmap" : YES 
Checking for function "newlocale" : YES 
Checking for function "pipe2" : YES 
Checking for function "posix_fallocate" : YES 
Checking for function "posix_memalign" : YES 
Checking for function "prlimit" : YES 
Checking for function "sched_setscheduler" : YES 
Checking for function "setgroups" : YES 
Checking for function "setns" : YES 
Checking for function "setrlimit" : YES 
Checking for function "symlink" : YES 
Checking for function "sysctlbyname" : NO 
Checking for function "__lxstat" : YES 
Checking for function "__lxstat64" : YES 
Checking for function "__xstat" : YES 
Checking for function "__xstat64" : YES 
Checking for function "lstat" : YES 
Checking for function "lstat64" : YES 
Checking for function "stat" : YES 
Checking for function "stat64" : YES 
Header <sys/stat.h> has symbol "__lxstat" : YES 
Header <sys/stat.h> has symbol "__lxstat64" : NO 
Header <sys/stat.h> has symbol "__xstat" : YES 
Header <sys/stat.h> has symbol "__xstat64" : NO 
Header <sys/stat.h> has symbol "lstat" : YES 
Header <sys/stat.h> has symbol "lstat64" : NO 
Header <sys/stat.h> has symbol "stat" : YES 
Header <sys/stat.h> has symbol "stat64" : NO 
Has header "asm/hwcap.h" : NO 
Has header "ifaddrs.h" : YES 
Has header "libtasn1.h" : YES 
Has header "linux/kvm.h" : YES 
Has header "linux/magic.h" : YES 
Has header "mntent.h" : YES 
Has header "net/ethernet.h" : YES 
Has header "net/if.h" : YES 
Has header "pty.h" : YES 
Has header "pwd.h" : YES 
Has header "sched.h" : YES 
Has header "sys/auxv.h" : YES 
Has header "sys/ioctl.h" : YES 
Has header "sys/mount.h" : YES 
Has header "sys/syscall.h" : YES 
Has header "sys/ucred.h" : NO 
Has header "syslog.h" : YES 
Has header "util.h" : NO 
Has header "xlocale.h" : NO 
Has header "linux/devlink.h" : YES 
Has header "linux/param.h" : YES 
Has header "linux/sockios.h" : YES 
Has header "linux/if_bridge.h" : YES 
Has header "linux/if_tun.h" : YES 
Header <endian.h> has symbol "htole64" : YES 
Header <linux/ethtool.h> has symbol "ETH_FLAG_TXVLAN" : YES 
Header <linux/ethtool.h> has symbol "ETH_FLAG_NTUPLE" : YES 
Header <linux/ethtool.h> has symbol "ETH_FLAG_RXHASH" : YES 
Header <linux/ethtool.h> has symbol "ETH_FLAG_LRO" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_GGSO" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_GGRO" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_GFLAGS" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_GFEATURES" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_SCOALESCE" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_GCOALESCE" : YES 
Header <linux/if_vlan.h> has symbol "GET_VLAN_VID_CMD" : YES 
Header <unistd.h> has symbol "SEEK_HOLE" : YES 
Header <net/if_dl.h> has symbol "link_addr" : NO 
Header <sched.h> has symbol "cpu_set_t" : YES 
Header <linux/devlink.h> has symbol "DEVLINK_CMD_ESWITCH_GET" : YES 
Header <linux/vhost.h> has symbol "VHOST_VSOCK_SET_GUEST_CID" : YES 
Header <linux/bpf.h> has symbol "BPF_PROG_QUERY" : YES 
Header <linux/bpf.h> has symbol "BPF_CGROUP_DEVICE" : YES 
Header <net/if_bridgevar.h> has symbol "BRDGSFD" : NO 
Header <sys/cpuset.h> has symbol "cpuset_getaffinity" : NO 
Header <mach/clock.h> has symbol "clock_serv_t" : NO 
Checking for type "struct ifreq" : YES 
Checking for type "struct sockpeercred" : NO 
Checking whether type "struct ifreq" has member "ifr_newname" : YES 
Checking whether type "struct ifreq" has member "ifr_ifindex" : YES 
Checking whether type "struct ifreq" has member "ifr_index" : NO 
Checking whether type "struct ifreq" has member "ifr_hwaddr" : YES 
Checking for size of "long" : 8
Program perl found: YES (/usr/bin/perl)
Program python3 found: YES (/usr/bin/python3)
Program xmllint found: YES (/usr/bin/xmllint)
Program xsltproc found: YES (/usr/bin/xsltproc)
Program rpcgen found: YES (/usr/bin/rpcgen)
Program augparse found: YES (/usr/bin/augparse)
Program dmidecode found: YES (/usr/sbin/dmidecode)
Program ebtables found: YES (/usr/sbin/ebtables)
Program flake8 found: YES (/usr/bin/flake8)
Program ip found: YES (/usr/sbin/ip)
Program ip6tables found: YES (/usr/sbin/ip6tables)
Program iptables found: YES (/usr/sbin/iptables)
Program iscsiadm found: YES (/usr/sbin/iscsiadm)
Program mdevctl found: NO
Program mm-ctl found: NO
Program modprobe found: YES (/usr/sbin/modprobe)
Program ovs-vsctl found: NO
Program pdwtags found: YES (/usr/bin/pdwtags)
Program rmmod found: YES (/usr/sbin/rmmod)
Program scrub found: YES (/usr/bin/scrub)
Program tc found: YES (/usr/sbin/tc)
Program udevadm found: YES (/usr/sbin/udevadm)
Found pkg-config: /usr/bin/pkg-config (1.4.2)
Run-time dependency libtirpc found: YES 1.1.4
Library acl found: YES
Did not find CMake 'cmake'
Found CMake: NO
Run-time dependency libapparmor found: NO (tried pkgconfig and cmake)
Library attr found: YES
Run-time dependency audit found: YES 3.0.7
Run-time dependency bash-completion found: YES 2.7
Run-time dependency blkid found: YES 2.32.1
Run-time dependency libcap-ng found: YES 0.7.11
Run-time dependency libcurl found: YES 7.61.1
Run-time dependency devmapper found: YES 1.02.181
Library dl found: YES
Has header "dlfcn.h" : YES 
Run-time dependency fuse found: YES 2.9.7
Run-time dependency glib-2.0 found: YES 2.56.4
Run-time dependency gobject-2.0 found: YES 2.56.4
Run-time dependency gio-unix-2.0 found: YES 2.56.4
Run-time dependency glusterfs-api found: YES 7.6.0
Run-time dependency gnutls found: YES 3.6.16
Run-time dependency libiscsi found: YES 1.18.0
Run-time dependency libnl-3.0 found: YES 3.7.0
Run-time dependency libnl-route-3.0 found: YES 3.7.0
Run-time dependency libparted found: YES 3.2
Run-time dependency pcap found: YES 1.9.1
Run-time dependency libssh found: YES 0.9.6
Checking for function "ssh_get_server_publickey" with dependency libssh: YES 
Checking for function "ssh_session_is_known_server" with dependency libssh: YES 
Checking for function "ssh_session_update_known_hosts" with dependency libssh: YES 
Run-time dependency libssh2 found: YES 1.9.0
Run-time dependency libxml-2.0 found: YES 2.9.7
Library m found: YES
Run-time dependency netcf found: YES 0.2.8
Checking for function "gettext" : YES 
Has header "libintl.h" : YES 
Program xgettext found: YES (/usr/bin/xgettext)
Program msgfmt found: YES (/usr/bin/msgfmt)
Program msgmerge found: YES (/usr/bin/msgmerge)
Library numa found: YES
Run-time dependency openwsman found: YES 2.6.5
Run-time dependency parallels-sdk found: NO (tried pkgconfig and cmake)
Run-time dependency pciaccess found: YES 0.14
Library rbd found: YES
Library rados found: YES
Checking for function "rbd_get_features" with dependency -lrbd: YES 
Checking for function "rbd_list2" with dependency -lrbd: NO 
Run-time dependency readline found: NO (tried pkgconfig and cmake)
Library readline found: YES
Header <readline/readline.h> has symbol "rl_completion_quote_character" : YES 
Run-time dependency libsanlock_client found: YES 3.8.4
Checking for function "sanlock_strerror" with dependency libsanlock_client: YES 
Run-time dependency libsasl2 found: YES 2.1.27
Run-time dependency libselinux found: YES 2.9
Run-time dependency threads found: YES
Run-time dependency libudev found: YES 239
Library util found: YES
Run-time dependency wireshark found: YES 2.6.2
Has header "wireshark/ws_version.h" : NO 
Run-time dependency yajl found: YES 2.1.0
Program pkcheck found: YES (/usr/bin/pkcheck)
Run-time dependency xenlight found: NO (tried pkgconfig and cmake)
Checking if "lxc support" compiles: YES 
Program qemu-bridge-helper found: NO
Program qemu-pr-helper found: NO
Program slirp-helper found: NO
Program dbus-daemon found: YES (/usr/bin/dbus-daemon)
Has header "mntent.h" : YES (cached)
Program mount found: YES (/usr/bin/mount)
Program umount found: YES (/usr/bin/umount)
Program mkfs found: YES (/usr/sbin/mkfs)
Program showmount found: YES (/usr/sbin/showmount)
Program pvcreate found: YES (/usr/sbin/pvcreate)
Program vgcreate found: YES (/usr/sbin/vgcreate)
Program lvcreate found: YES (/usr/sbin/lvcreate)
Program pvremove found: YES (/usr/sbin/pvremove)
Program vgremove found: YES (/usr/sbin/vgremove)
Program lvremove found: YES (/usr/sbin/lvremove)
Program lvchange found: YES (/usr/sbin/lvchange)
Program vgchange found: YES (/usr/sbin/vgchange)
Program vgscan found: YES (/usr/sbin/vgscan)
Program pvs found: YES (/usr/sbin/pvs)
Program vgs found: YES (/usr/sbin/vgs)
Program lvs found: YES (/usr/sbin/lvs)
Program dog found: NO
Program dtrace found: YES (/usr/bin/dtrace)
Program systemctl found: YES (/usr/bin/systemctl)
Has header "nss.h" : YES 
Checking for type "struct gaih_addrtuple" : YES 
Checking for type "ns_mtab" : NO 
Program numad found: YES (/usr/bin/numad)
Program apibuild.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/apibuild.py)
Program augeas-gentest.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/augeas-gentest.py)
Program check-aclperms.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/check-aclperms.py)
Program check-aclrules.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/check-aclrules.py)
Program check-driverimpls.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/check-driverimpls.py)
Program check-drivername.py found: YES (/usr/libexec/platform-python /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/check-drivername.py)
Program check-file-access.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/check-file-access.py)
Program check-remote-protocol.py found: YES (/usr/libexec/platform-python /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/check-remote-protocol.py)
Program check-symfile.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/check-symfile.py)
Program check-symsorting.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/check-symsorting.py)
Program dtrace2systemtap.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/dtrace2systemtap.py)
Program esx_vi_generator.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/esx_vi_generator.py)
Program genaclperms.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/genaclperms.py)
Program genpolkit.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/genpolkit.py)
Program gensystemtap.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/gensystemtap.py)
Program group-qemu-caps.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/group-qemu-caps.py)
Program header-ifdef.py found: YES (/usr/libexec/platform-python /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/header-ifdef.py)
Program hvsupport.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/hvsupport.py)
Program hyperv_wmi_generator.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/hyperv_wmi_generator.py)
Program meson-dist.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/meson-dist.py)
Program meson-gen-authors.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/meson-gen-authors.py)
Program meson-gen-def.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/meson-gen-def.py)
Program meson-gen-sym.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/meson-gen-sym.py)
Program meson-install-dirs.py found: YES (/usr/libexec/platform-python /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/meson-install-dirs.py)
Program meson-install-symlink.py found: YES (/usr/libexec/platform-python /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/meson-install-symlink.py)
Program meson-install-web.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/meson-install-web.py)
Program meson-python.sh found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/meson-python.sh)
Program meson-timestamp.py found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/meson-timestamp.py)
Program mock-noinline.py found: YES (/usr/libexec/platform-python /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/mock-noinline.py)
Program prohibit-duplicate-header.py found: YES (/usr/libexec/platform-python /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/prohibit-duplicate-header.py)
Configuring libvirt-common.h using configuration
Program env found: YES (/usr/bin/env)
Program env found: YES (/usr/bin/env)
Program /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/keycodemapdb/tools/keymap-gen found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/keycodemapdb/tools/keymap-gen)
Program genprotocol.pl found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/rpc/genprotocol.pl)
Program gendispatch.pl found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/rpc/gendispatch.pl)
Configuring libvirtd.conf.tmp with command
Configuring libvirtd.aug.tmp with command
Configuring test_libvirtd.aug.tmp with command
Configuring virtd.conf.tmp with command
Configuring virtd.aug.tmp with command
Configuring test_virtd.aug.tmp with command
Configuring libvirtd.qemu.logrotate using configuration
Configuring libvirtd.lxc.logrotate using configuration
Configuring libvirtd.libxl.logrotate using configuration
Configuring libvirtd.logrotate using configuration
Program /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/meson-python.sh found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/meson-python.sh)
Program env found: YES (/usr/bin/env)
Program env found: YES (/usr/bin/env)
Configuring libvirtd.conf using configuration
Configuring libvirtd.aug using configuration
Configuring test_libvirtd.aug.tmp using configuration
Configuring virtproxyd.conf using configuration
Configuring virtproxyd.aug using configuration
Configuring test_virtproxyd.aug.tmp using configuration
Configuring virtinterfaced.conf using configuration
Configuring virtinterfaced.aug using configuration
Configuring test_virtinterfaced.aug.tmp using configuration
Configuring virtnetworkd.conf using configuration
Configuring virtnetworkd.aug using configuration
Configuring test_virtnetworkd.aug.tmp using configuration
Configuring virtnodedevd.conf using configuration
Configuring virtnodedevd.aug using configuration
Configuring test_virtnodedevd.aug.tmp using configuration
Configuring virtnwfilterd.conf using configuration
Configuring virtnwfilterd.aug using configuration
Configuring test_virtnwfilterd.aug.tmp using configuration
Configuring virtsecretd.conf using configuration
Configuring virtsecretd.aug using configuration
Configuring test_virtsecretd.aug.tmp using configuration
Configuring virtstoraged.conf using configuration
Configuring virtstoraged.aug using configuration
Configuring test_virtstoraged.aug.tmp using configuration
Configuring virtlxcd.conf using configuration
Configuring virtlxcd.aug using configuration
Configuring test_virtlxcd.aug.tmp using configuration
Configuring virtchd.conf using configuration
Configuring virtchd.aug using configuration
Configuring test_virtchd.aug.tmp using configuration
Configuring virtqemud.conf using configuration
Configuring virtqemud.aug using configuration
Configuring test_virtqemud.aug.tmp using configuration
Configuring virtvboxd.conf using configuration
Configuring virtvboxd.aug using configuration
Configuring test_virtvboxd.aug.tmp using configuration
Configuring libvirtd.service using configuration
Configuring libvirtd.socket using configuration
Configuring libvirtd-ro.socket using configuration
Configuring libvirtd-admin.socket using configuration
Configuring libvirtd-tcp.socket using configuration
Configuring libvirtd-tls.socket using configuration
Configuring virtproxyd.service using configuration
Configuring virtproxyd.socket using configuration
Configuring virtproxyd-ro.socket using configuration
Configuring virtproxyd-admin.socket using configuration
Configuring virtproxyd-tcp.socket using configuration
Configuring virtproxyd-tls.socket using configuration
Configuring virtinterfaced.service using configuration
Configuring virtinterfaced.socket using configuration
Configuring virtinterfaced-ro.socket using configuration
Configuring virtinterfaced-admin.socket using configuration
Configuring virtlockd.service using configuration
Configuring virtlockd.socket using configuration
Configuring virtlockd-admin.socket using configuration
Configuring virtlogd.service using configuration
Configuring virtlogd.socket using configuration
Configuring virtlogd-admin.socket using configuration
Configuring virtnetworkd.service using configuration
Configuring virtnetworkd.socket using configuration
Configuring virtnetworkd-ro.socket using configuration
Configuring virtnetworkd-admin.socket using configuration
Configuring virtnodedevd.service using configuration
Configuring virtnodedevd.socket using configuration
Configuring virtnodedevd-ro.socket using configuration
Configuring virtnodedevd-admin.socket using configuration
Configuring virtnwfilterd.service using configuration
Configuring virtnwfilterd.socket using configuration
Configuring virtnwfilterd-ro.socket using configuration
Configuring virtnwfilterd-admin.socket using configuration
Configuring virtsecretd.service using configuration
Configuring virtsecretd.socket using configuration
Configuring virtsecretd-ro.socket using configuration
Configuring virtsecretd-admin.socket using configuration
Configuring virtstoraged.service using configuration
Configuring virtstoraged.socket using configuration
Configuring virtstoraged-ro.socket using configuration
Configuring virtstoraged-admin.socket using configuration
Configuring virtlxcd.service using configuration
Configuring virtlxcd.socket using configuration
Configuring virtlxcd-ro.socket using configuration
Configuring virtlxcd-admin.socket using configuration
Configuring virtchd.service using configuration
Configuring virtchd.socket using configuration
Configuring virtchd-ro.socket using configuration
Configuring virtchd-admin.socket using configuration
Configuring virtqemud.service using configuration
Configuring virtqemud.socket using configuration
Configuring virtqemud-ro.socket using configuration
Configuring virtqemud-admin.socket using configuration
Configuring virtvboxd.service using configuration
Configuring virtvboxd.socket using configuration
Configuring virtvboxd-ro.socket using configuration
Configuring virtvboxd-admin.socket using configuration
Program /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/meson-python.sh found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/meson-python.sh)
Configuring libvirt-lxc.pc using configuration
Configuring libvirt-qemu.pc using configuration
Configuring libvirt.pc using configuration
Configuring virt-xml-validate using configuration
Configuring virt-pki-validate using configuration
Configuring virt-sanlock-cleanup using configuration
Configuring libvirt-guests.sh using configuration
Configuring libvirt-guests.service using configuration
Configuring virsh using configuration
Configuring virt-admin using configuration
Program util/genxdrstub.pl found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tools/wireshark/util/genxdrstub.pl)
Library tasn1 found: YES
Program libvirtd-fail found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/libvirtd-fail)
Program libvirtd-pool found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/libvirtd-pool)
Program virsh-auth found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/virsh-auth)
Program virsh-checkpoint found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/virsh-checkpoint)
Program virsh-cpuset found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/virsh-cpuset)
Program virsh-define-dev-segfault found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/virsh-define-dev-segfault)
Program virsh-int-overflow found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/virsh-int-overflow)
Program virsh-optparse found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/virsh-optparse)
Program virsh-output found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/virsh-output)
Program virsh-read-bufsiz found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/virsh-read-bufsiz)
Program virsh-read-non-seekable found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/virsh-read-non-seekable)
Program virsh-schedinfo found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/virsh-schedinfo)
Program virsh-self-test found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/virsh-self-test)
Program virsh-snapshot found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/virsh-snapshot)
Program virsh-start found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/virsh-start)
Program virsh-undefine found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/virsh-undefine)
Program virsh-uriprecedence found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/virsh-uriprecedence)
Program virsh-vcpupin found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/virsh-vcpupin)
Program virt-admin-self-test found: YES (/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tests/virt-admin-self-test)
Configuring POTFILES using configuration
Program rst2html5 found: YES (/usr/bin/rst2html5)
Program rst2man found: YES (/usr/bin/rst2man)
Configuring index.rst using configuration
Configuring virsh.rst using configuration
Configuring virt-admin.rst using configuration
Configuring virt-host-validate.rst using configuration
Configuring virt-login-shell.rst using configuration
Configuring virt-pki-query-dn.rst using configuration
Configuring virt-pki-validate.rst using configuration
Configuring virt-qemu-run.rst using configuration
Configuring virt-xml-validate.rst using configuration
Configuring libvirt-guests.rst using configuration
Configuring libvirtd.rst using configuration
Configuring virt-sanlock-cleanup.rst using configuration
Configuring virt-ssh-helper.rst using configuration
Configuring virtbhyved.rst using configuration
Configuring virtinterfaced.rst using configuration
Configuring virtlockd.rst using configuration
Configuring virtlogd.rst using configuration
Configuring virtlxcd.rst using configuration
Configuring virtnetworkd.rst using configuration
Configuring virtnodedevd.rst using configuration
Configuring virtnwfilterd.rst using configuration
Configuring virtproxyd.rst using configuration
Configuring virtqemud.rst using configuration
Configuring virtsecretd.rst using configuration
Configuring virtstoraged.rst using configuration
Configuring virtvboxd.rst using configuration
Configuring virtvzd.rst using configuration
Configuring virtxend.rst using configuration
Program make found: YES
Program sed found: YES (/usr/bin/sed)
Program grep found: YES (/usr/bin/grep)
Configuring Makefile using configuration
Configuring libvirt.pc using configuration
Configuring libvirt-qemu.pc using configuration
Configuring libvirt-lxc.pc using configuration
Configuring libvirt-admin.pc using configuration
Configuring meson-config.h using configuration
Configuring run using configuration
Configuring .color_coded using configuration
Configuring .ycm_extra_conf.py using configuration
Build targets in project: 617

libvirt 8.1.0

  Drivers
    QEMU               : YES
    OpenVZ             : YES
    VMware             : YES
    VBox               : YES
    libxl              : NO
    LXC                : YES
    Cloud-Hypervisor   : YES
    ESX                : YES
    Hyper-V            : YES
    vz                 : NO
    Bhyve              : NO
    Test               : YES
    Remote             : YES
    Network            : YES
    Libvirtd           : YES
    Interface          : YES

  Storage Drivers
    Dir                : YES
    FS                 : YES
    NetFS              : YES
    LVM                : YES
    iSCSI              : YES
    iscsi-direct       : YES
    SCSI               : YES
    mpath              : YES
    Disk               : YES
    RBD                : YES
    Sheepdog           : NO
    Gluster            : YES
    ZFS                : YES
    Virtuozzo storage  : YES

  Security Drivers
    SELinux            : YES
    AppArmor           : NO

  Driver Loadable Modules
    driver_modules     : YES

  Libraries
    acl                : YES
    apparmor           : NO
    attr               : YES
    audit              : YES
    bash_completion    : YES
    blkid              : YES
    capng              : YES
    curl               : YES
    devmapper          : YES
    dlopen             : YES
    fuse               : YES
    glusterfs          : YES
    libiscsi           : YES
    libkvm             : NO
    libnl              : YES
    libparted          : YES
    libpcap            : YES
    libssh             : YES
    libssh2            : YES
    libutil            : YES
    netcf              : YES
    NLS                : YES
    numactl            : YES
    openwsman          : YES
    parallels-sdk      : NO
    pciaccess          : YES
    polkit             : YES
    rbd                : YES
    readline           : YES
    sanlock            : YES
    sasl               : YES
    selinux            : YES
    udev               : YES
    xdr                : YES
    yajl               : YES

  Windows
    MinGW              : NO
    windres            : NO

  Test suite
    Expensive          : YES
    Coverage           : NO

  Miscellaneous
    Warning Flags      : -fasynchronous-unwind-tables -fexceptions -fipa-pure-const -fno-common -Waddress -Waggressive-loop-optimizations -Walloc-size-larger-than=9223372036854775807 -Walloca -Warray-bounds=2 -Wattributes -Wbool-compare -Wbool-operation
                         -Wbuiltin-declaration-mismatch -Wbuiltin-macro-redefined -Wcast-align -Wcast-align=strict -Wno-cast-function-type -Wchar-subscripts -Wclobbered -Wcomment -Wcomments -Wcoverage-mismatch -Wcpp -Wdangling-else -Wdate-time
                         -Wdeclaration-after-statement -Wdeprecated-declarations -Wdesignated-init -Wdiscarded-array-qualifiers -Wdiscarded-qualifiers -Wdiv-by-zero -Wduplicated-cond -Wduplicate-decl-specifier -Wempty-body -Wendif-labels -Wexpansion-to-defined
                         -Wformat-contains-nul -Wformat-extra-args -Wno-format-nonliteral -Wformat-overflow=2 -Wformat-security -Wno-format-truncation -Wformat-y2k -Wformat-zero-length -Wframe-address -Wframe-larger-than=4096 -Wfree-nonheap-object -Whsa
                         -Wif-not-aligned -Wignored-attributes -Wignored-qualifiers -Wimplicit -Wimplicit-fallthrough=5 -Wimplicit-function-declaration -Wimplicit-int -Wincompatible-pointer-types -Winit-self -Winline -Wint-conversion -Wint-in-bool-context
                         -Wint-to-pointer-cast -Winvalid-memory-model -Winvalid-pch -Wjump-misses-init -Wlogical-not-parentheses -Wlogical-op -Wmain -Wmaybe-uninitialized -Wmemset-elt-size -Wmemset-transposed-args -Wmisleading-indentation -Wmissing-attributes
                         -Wmissing-braces -Wmissing-declarations -Wmissing-field-initializers -Wmissing-include-dirs -Wmissing-parameter-type -Wmissing-prototypes -Wmultichar -Wmultistatement-macros -Wnarrowing -Wnested-externs -Wnonnull -Wnonnull-compare
                         -Wnormalized=nfc -Wnull-dereference -Wodr -Wold-style-declaration -Wold-style-definition -Wopenmp-simd -Woverflow -Woverride-init -Wpacked-bitfield-compat -Wpacked-not-aligned -Wparentheses -Wpointer-arith -Wpointer-compare -Wpointer-sign
                         -Wpointer-to-int-cast -Wpragmas -Wpsabi -Wrestrict -Wreturn-local-addr -Wreturn-type -Wscalar-storage-order -Wsequence-point -Wshadow -Wshift-count-negative -Wshift-count-overflow -Wshift-negative-value -Wshift-overflow=2 -Wno-sign-compare
                         -Wsizeof-array-argument -Wsizeof-pointer-div -Wsizeof-pointer-memaccess -Wstrict-aliasing -Wstrict-prototypes -Wstringop-overflow=2 -Wstringop-truncation -Wsuggest-attribute=cold -Wno-suggest-attribute=const -Wsuggest-attribute=format
                         -Wsuggest-attribute=noreturn -Wno-suggest-attribute=pure -Wsuggest-final-methods -Wsuggest-final-types -Wswitch -Wswitch-bool -Wswitch-enum -Wswitch-unreachable -Wsync-nand -Wtautological-compare -Wtrampolines -Wtrigraphs -Wtype-limits
                         -Wuninitialized -Wunknown-pragmas -Wunused -Wunused-but-set-parameter -Wunused-but-set-variable -Wunused-const-variable=2 -Wunused-function -Wunused-label -Wunused-local-typedefs -Wunused-parameter -Wunused-result -Wunused-value
                         -Wunused-variable -Wvarargs -Wvariadic-macros -Wvector-operation-performance -Wvla -Wvolatile-register-var -Wwrite-strings -fstack-protector-strong -Wdouble-promotion
    docs               : YES
    tests              : YES
    DTrace             : YES
    firewalld          : YES
    firewalld-zone     : YES
    nss                : YES
    numad              : YES
    Init script        : systemd
    Char device locks  : /var/lock
    Loader/NVRAM       : 
    pm_utils           : NO
    virt-login-shell   : YES
    virt-host-validate : YES
    TLS priority       : NORMAL

  Developer Tools
    wireshark_dissector: YES

  Privileges
    QEMU               : qemu:qemu

Found ninja-1.8.2 at /usr/bin/ninja
[1334/1334] Generating virkeyname-win32.html with a custom command (wrapped by meson to capture output)
[0/1] Running all tests.
  1/175 check-aclperms                           OK              0.03s
  2/175 check-admin-symfile                      OK              0.04s
  3/175 check-symsorting                         OK              0.05s
  4/175 check-admin-symsorting                   OK              0.03s
  5/175 check-drivername                         OK              0.04s
  6/175 check-admin-drivername                   OK              0.04s
  7/175 check-symfile                            OK              0.10s
  8/175 check-augeas-libvirt_lockd               OK              0.03s
  9/175 check-augeas-libvirt_sanlock             OK              0.02s
 10/175 check-augeas-virtlockd                   OK              0.02s
 11/175 check-augeas-virtlogd                    OK              0.03s
 12/175 check-augeas-libvirtd_lxc                OK              0.03s
 13/175 check-augeas-libvirtd                    OK              0.08s
 14/175 check-augeas-virtproxyd                  OK              0.07s
 15/175 check-aclrules                           OK              0.25s
 16/175 check-augeas-libvirtd_qemu               OK              0.19s
 17/175 check-driverimpls                        OK              0.29s
 18/175 check-augeas-virtinterfaced              OK              0.06s
 19/175 check-augeas-virtnetworkd                OK              0.06s
 20/175 check-augeas-virtnodedevd                OK              0.07s
 21/175 check-augeas-virtnwfilterd               OK              0.08s
 22/175 check-augeas-virtstoraged                OK              0.06s
 23/175 check-augeas-virtsecretd                 OK              0.07s
 24/175 check-augeas-virtlxcd                    OK              0.06s
 25/175 check-augeas-virtchd                     OK              0.06s
 26/175 check-augeas-virtqemud                   OK              0.06s
 27/175 check-augeas-virtvboxd                   OK              0.05s
 28/175 check-virnetprotocol                     OK              0.06s
 29/175 check-virkeepaliveprotocol               OK              0.05s
 30/175 check-qemu_protocol                      OK              0.04s
 31/175 check-lxc_protocol                       OK              0.04s
 32/175 check-admin_protocol                     OK              0.05s
 33/175 check-lock_protocol                      OK              0.05s
 34/175 check-lxc_monitor_protocol               OK              0.05s
 35/175 check-remote_protocol                    OK              0.12s
 36/175 domainconftest                           OK              0.03s
 37/175 genericxml2xmltest                       OK              0.12s
 38/175 interfacexml2xmltest                     OK              0.02s
 39/175 metadatatest                             OK              0.02s
 40/175 networkxml2xmlupdatetest                 OK              0.03s
 41/175 nodedevxml2xmltest                       OK              0.02s
 42/175 nwfilterxml2xmltest                      OK              0.02s
 43/175 objecteventtest                          OK              0.02s
 44/175 seclabeltest                             OK              0.02s
 45/175 secretxml2xmltest                        OK              0.02s
 46/175 shunloadtest                             OK              0.02s
 47/175 sockettest                               OK              0.02s
 48/175 storagevolxml2xmltest                    OK              0.02s
 49/175 sysinfotest                              OK              0.02s
 50/175 utiltest                                 OK              0.03s
 51/175 viralloctest                             OK              0.02s
 52/175 domaincapstest                           OK              0.47s
 53/175 virauthconfigtest                        OK              0.02s
 54/175 virbitmaptest                            OK              0.02s
 55/175 virbuftest                               OK              0.02s
 56/175 vircapstest                              OK              0.02s
 57/175 virconftest                              OK              0.01s
 58/175 vircryptotest                            OK              0.03s
 59/175 vircgrouptest                            OK              0.06s
 60/175 virendiantest                            OK              0.02s
 61/175 virerrortest                             OK              0.02s
 62/175 virfilecachetest                         OK              0.03s
 63/175 virfirewalltest                          OK              0.03s
 64/175 virfiletest                              OK              0.08s
 65/175 virhostcputest                           OK              0.04s
 66/175 viridentitytest                          OK              0.03s
 67/175 viriscsitest                             OK              0.03s
 68/175 virkeycodetest                           OK              0.02s
 69/175 virhostdevtest                           OK              0.10s
 70/175 virkmodtest                              OK              0.02s
 71/175 virlockspacetest                         OK              0.02s
 72/175 virlogtest                               OK              0.02s
 73/175 virnetworkportxml2xmltest                OK              0.02s
 74/175 virnetdevtest                            OK              0.03s
 75/175 virnwfilterbindingxml2xmltest            OK              0.02s
 76/175 virportallocatortest                     OK              0.03s
 77/175 virpcitest                               OK              0.05s
 78/175 virrotatingfiletest                      OK              0.02s
 79/175 cputest                                  OK              1.07s
 80/175 virstringtest                            OK              0.03s
 81/175 virsystemdtest                           OK              0.04s
 82/175 virtimetest                              OK              0.03s
 83/175 virtypedparamtest                        OK              0.02s
 84/175 viruritest                               OK              0.02s
 85/175 virpcivpdtest                            OK              0.03s
 86/175 vshtabletest                             OK              0.02s
 87/175 virmigtest                               OK              0.03s
 88/175 fchosttest                               OK              0.04s
 89/175 scsihosttest                             OK              0.02s
 90/175 vircaps2xmltest                          OK              0.06s
 91/175 virnetdevbandwidthtest                   OK              0.03s
 92/175 virprocessstattest                       OK              0.02s
 93/175 virresctrltest                           OK              0.02s
 94/175 virscsitest                              OK              0.02s
 95/175 virusbtest                               OK              0.03s
 96/175 virnetdevopenvswitchtest                 OK              0.03s
 97/175 esxutilstest                             OK              0.02s
 98/175 eventtest                                OK              0.42s
 99/175 fdstreamtest                             OK              0.02s
100/175 virdriverconnvalidatetest                OK              0.01s
101/175 virdrivermoduletest                      OK              0.08s
102/175 lxcconf2xmltest                          OK              0.02s
103/175 lxcxml2xmltest                           OK              0.02s
104/175 networkxml2conftest                      OK              0.04s
105/175 networkxml2firewalltest                  OK              0.03s
106/175 networkxml2xmltest                       OK              0.04s
107/175 nodedevmdevctltest                       OK              0.03s
108/175 nsstest                                  OK              0.03s
109/175 nssguesttest                             OK              0.03s
110/175 virshtest                                OK              1.54s
111/175 nwfilterebiptablestest                   OK              0.03s
112/175 openvzutilstest                          OK              0.02s
113/175 virpolkittest                            OK              0.04s
114/175 nwfilterxml2firewalltest                 OK              0.08s
115/175 qemublocktest                            OK              0.11s
116/175 commandtest                              OK              2.70s
117/175 virschematest                            OK              1.81s
118/175 qemucaps2xmltest                         OK              0.10s
119/175 qemucommandutiltest                      OK              0.02s
120/175 qemudomaincheckpointxml2xmltest          OK              0.14s
121/175 qemudomainsnapshotxml2xmltest            OK              0.02s
122/175 qemufirmwaretest                         OK              0.02s
123/175 qemuhotplugtest                          OK              0.29s
124/175 qemumemlocktest                          OK              0.05s
125/175 qemumigparamstest                        OK              0.05s
126/175 qemumigrationcookiexmltest               OK              0.04s
127/175 qemucapabilitiesnumbering                OK              0.86s
128/175 qemumonitorjsontest                      OK              0.32s
129/175 qemustatusxml2xmltest                    OK              0.04s
130/175 qemuvhostusertest                        OK              0.02s
131/175 qemucapabilitiestest                     OK              1.43s
132/175 qemusecuritytest                         OK              0.56s
133/175 virnetdaemontest                         OK              0.05s
134/175 virnetmessagetest                        OK              0.02s
135/175 virnetserverclienttest                   OK              0.03s
136/175 virnetsockettest                         OK              0.12s
137/175 qemuxml2xmltest                          OK              0.65s
138/175 virnettlssessiontest                     OK              0.26s
139/175 securityselinuxtest                      OK              0.02s
140/175 securityselinuxlabeltest                 OK              0.03s
141/175 storagepoolcapstest                      OK              0.02s
142/175 storagepoolxml2argvtest                  OK              0.06s
143/175 storagepoolxml2xmltest                   OK              0.06s
144/175 storagevolxml2argvtest                   OK              0.02s
145/175 virstorageutiltest                       OK              0.02s
146/175 virstoragetest                           OK              0.09s
147/175 vboxsnapshotxmltest                      OK              0.02s
148/175 vmwarevertest                            OK              0.01s
149/175 vmx2xmltest                              OK              0.03s
150/175 xml2vmxtest                              OK              0.03s
151/175 virjsontest                              OK              0.02s
152/175 virmacmaptest                            OK              0.01s
153/175 libvirtd-fail                            OK              0.04s
154/175 virnettlscontexttest                     OK              1.18s
155/175 libvirtd-pool                            OK              0.05s
156/175 virsh-auth                               OK              0.05s
157/175 virsh-cpuset                             OK              0.06s
158/175 virsh-define-dev-segfault                OK              0.04s
159/175 virsh-int-overflow                       OK              0.04s
160/175 virsh-checkpoint                         OK              0.25s
161/175 qemuxml2argvtest                         OK              1.98s
162/175 virsh-read-bufsiz                        OK              0.08s
163/175 virsh-read-non-seekable                  OK              0.05s
164/175 virsh-schedinfo                          OK              0.04s
165/175 virsh-self-test                          OK              0.04s
166/175 virsh-snapshot                           OK              0.13s
167/175 virsh-start                              OK              0.04s
168/175 virsh-undefine                           OK              0.07s
169/175 virsh-uriprecedence                      OK              0.13s
170/175 virsh-vcpupin                            OK              0.16s
171/175 virt-admin-self-test                     OK              0.03s
172/175 check-html                               OK              0.04s
173/175 virsh-output                             OK              1.13s
174/175 virsh-optparse                           OK              1.79s
175/175 qemuagenttest                            OK              6.05s


Ok:                 175 
Expected Fail:      0   
Fail:               0   
Unexpected Pass:    0   
Skipped:            0   
Timeout:            0   

Full log written to /libvirt-src/build/meson-private/dist-build/meson-logs/testlog.txt
[0/1] Installing files.
Installing src/libvirt_probes.stp to /libvirt-src/build/meson-private/dist-install/usr/local/share/systemtap/tapset
Installing src/access/org.libvirt.api.policy to /libvirt-src/build/meson-private/dist-install/usr/local/share/polkit-1/actions
Installing src/qemu/libvirt_qemu_probes.stp to /libvirt-src/build/meson-private/dist-install/usr/local/share/systemtap/tapset
Installing src/libvirt.so.0.8001.0 to /libvirt-src/build/meson-private/dist-install/usr/local/lib64
Installing src/libvirt-qemu.so.0.8001.0 to /libvirt-src/build/meson-private/dist-install/usr/local/lib64
Installing src/libvirt-lxc.so.0.8001.0 to /libvirt-src/build/meson-private/dist-install/usr/local/lib64
Installing src/libvirt-admin.so.0.8001.0 to /libvirt-src/build/meson-private/dist-install/usr/local/lib64
Installing src/libvirt_driver_interface.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/connection-driver
Installing src/lockd.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/lock-driver
Installing src/sanlock.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/lock-driver
Installing src/libvirt_driver_network.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/connection-driver
Installing src/libvirt_driver_nodedev.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/connection-driver
Installing src/libvirt_driver_nwfilter.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/connection-driver
Installing src/libvirt_driver_secret.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/connection-driver
Installing src/libvirt_driver_storage.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/connection-driver
Installing src/libvirt_storage_backend_fs.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/storage-backend
Installing src/libvirt_storage_backend_disk.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/storage-backend
Installing src/libvirt_storage_backend_gluster.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/storage-backend
Installing src/libvirt_storage_backend_iscsi.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/storage-backend
Installing src/libvirt_storage_backend_iscsi-direct.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/storage-backend
Installing src/libvirt_storage_backend_logical.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/storage-backend
Installing src/libvirt_storage_backend_mpath.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/storage-backend
Installing src/libvirt_storage_backend_rbd.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/storage-backend
Installing src/libvirt_storage_backend_scsi.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/storage-backend
Installing src/libvirt_storage_backend_vstorage.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/storage-backend
Installing src/libvirt_storage_backend_zfs.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/storage-backend
Installing src/libvirt_storage_file_fs.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/storage-file
Installing src/libvirt_storage_file_gluster.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/storage-file
Installing src/libvirt_driver_lxc.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/connection-driver
Installing src/libvirt_driver_ch.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/connection-driver
Installing src/libvirt_driver_qemu.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/connection-driver
Installing src/libvirt_driver_vbox.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/libvirt/connection-driver
Installing src/libvirtd to /libvirt-src/build/meson-private/dist-install/usr/local/sbin
Installing src/virtproxyd to /libvirt-src/build/meson-private/dist-install/usr/local/sbin
Installing src/virtinterfaced to /libvirt-src/build/meson-private/dist-install/usr/local/sbin
Installing src/virtlockd to /libvirt-src/build/meson-private/dist-install/usr/local/sbin
Installing src/virtlogd to /libvirt-src/build/meson-private/dist-install/usr/local/sbin
Installing src/virtnetworkd to /libvirt-src/build/meson-private/dist-install/usr/local/sbin
Installing src/virtnodedevd to /libvirt-src/build/meson-private/dist-install/usr/local/sbin
Installing src/virtnwfilterd to /libvirt-src/build/meson-private/dist-install/usr/local/sbin
Installing src/virtsecretd to /libvirt-src/build/meson-private/dist-install/usr/local/sbin
Installing src/virtstoraged to /libvirt-src/build/meson-private/dist-install/usr/local/sbin
Installing src/virtlxcd to /libvirt-src/build/meson-private/dist-install/usr/local/sbin
Installing src/virtchd to /libvirt-src/build/meson-private/dist-install/usr/local/sbin
Installing src/virtqemud to /libvirt-src/build/meson-private/dist-install/usr/local/sbin
Installing src/virtvboxd to /libvirt-src/build/meson-private/dist-install/usr/local/sbin
Installing src/libvirt_iohelper to /libvirt-src/build/meson-private/dist-install/usr/local/libexec
Installing src/virt-ssh-helper to /libvirt-src/build/meson-private/dist-install/usr/local/bin
Installing src/libvirt_sanlock_helper to /libvirt-src/build/meson-private/dist-install/usr/local/libexec
Installing src/libvirt_leaseshelper to /libvirt-src/build/meson-private/dist-install/usr/local/libexec
Installing src/libvirt_parthelper to /libvirt-src/build/meson-private/dist-install/usr/local/libexec
Installing src/libvirt_lxc to /libvirt-src/build/meson-private/dist-install/usr/local/libexec
Installing src/virt-qemu-run to /libvirt-src/build/meson-private/dist-install/usr/local/bin
Installing src/test_libvirt_lockd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/test_libvirt_sanlock.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/test_virtlockd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/test_virtlogd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/test_libvirtd_lxc.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/test_libvirtd_qemu.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/test_libvirtd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/test_virtproxyd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/test_virtinterfaced.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/test_virtnetworkd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/test_virtnodedevd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/test_virtnwfilterd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/test_virtsecretd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/test_virtstoraged.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/test_virtlxcd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/test_virtchd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/test_virtqemud.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/test_virtvboxd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses/tests
Installing src/libvirt_functions.stp to /libvirt-src/build/meson-private/dist-install/usr/local/share/systemtap/tapset
Installing tools/virt-host-validate to /libvirt-src/build/meson-private/dist-install/usr/local/bin
Installing tools/virt-login-shell to /libvirt-src/build/meson-private/dist-install/usr/local/bin
Installing tools/virt-login-shell-helper to /libvirt-src/build/meson-private/dist-install/usr/local/libexec
Installing tools/virsh to /libvirt-src/build/meson-private/dist-install/usr/local/bin
Installing tools/virt-admin to /libvirt-src/build/meson-private/dist-install/usr/local/bin
Installing tools/virt-pki-query-dn to /libvirt-src/build/meson-private/dist-install/usr/local/bin
Installing tools/nss/libnss_libvirt.so.2 to /libvirt-src/build/meson-private/dist-install/usr/local/lib64
Installing tools/nss/libnss_libvirt_guest.so.2 to /libvirt-src/build/meson-private/dist-install/usr/local/lib64
Installing tools/wireshark/src/libvirt.so to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/wireshark/plugins/2.6/epan
Installing docs/libvirt-api.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/api
Installing docs/libvirt-lxc-api.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/api
Installing docs/libvirt-qemu-api.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/api
Installing docs/libvirt-admin-api.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/api
Installing docs/404.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/bugs.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/cgroups.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/contact.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/contribute.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/csharp.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/dbus.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/devguide.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/docs.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/downloads.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/drivers.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/drvbhyve.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/drvesx.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/drvhyperv.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/drvlxc.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/drvnodedev.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/drvopenvz.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/drvremote.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/drvsecret.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/drvtest.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/drvvbox.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/drvvirtuozzo.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/drvvmware.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/drvxen.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/errors.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/firewall.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/formatcaps.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/formatdomaincaps.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/format.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/formatnetwork.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/formatnetworkport.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/formatnode.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/formatnwfilter.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/formatsecret.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/formatsnapshot.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/formatstoragecaps.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/formatstorageencryption.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/goals.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/governance.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/hooks.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/index.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/internals.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/java.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/logging.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/nss.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/pci-hotplug.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/php.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/python.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/remote.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/securityprocess.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/storage.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/strategy.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/support.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/testapi.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/testsuites.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/testtck.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/tlscerts.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/uri.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/virshcmdref.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/windows.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/aclpolkit.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/advanced-tests.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/api_extension.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/api.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/apps.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/auditlog.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/auth.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/bindings.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/best-practices.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/ci.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/coding-style.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/committer-guidelines.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/compiling.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/daemons.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/developer-tooling.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/drvqemu.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/drvch.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/formatbackup.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/formatcheckpoint.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/formatdomain.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/formatstorage.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/glib-adoption.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/hacking.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/libvirt-go.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/libvirt-go-xml.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/macos.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/migration.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/newreposetup.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/pci-addresses.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/platforms.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/programming-languages.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/styleguide.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/submitting-patches.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/acl.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/hvsupport.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/news.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing docs/go/libvirt.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/go
Installing docs/go/libvirtxml.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/go
Installing docs/html/index.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/libvirt-libvirt-common.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/libvirt-libvirt-domain.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/libvirt-libvirt-domain-checkpoint.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/libvirt-libvirt-domain-snapshot.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/libvirt-libvirt-event.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/libvirt-libvirt-host.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/libvirt-libvirt-interface.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/libvirt-libvirt-network.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/libvirt-libvirt-nodedev.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/libvirt-libvirt-nwfilter.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/libvirt-libvirt-secret.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/libvirt-libvirt-storage.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/libvirt-libvirt-stream.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/libvirt-virterror.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/index-admin.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/libvirt-libvirt-admin.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/index-lxc.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/libvirt-libvirt-lxc.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/index-qemu.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/html/libvirt-libvirt-qemu.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing docs/internals/command.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/internals
Installing docs/internals/eventloop.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/internals
Installing docs/internals/locking.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/internals
Installing docs/internals/rpc.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/internals
Installing docs/kbase/backing_chains.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/debuglogs.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/domainstatecapture.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/incrementalbackupinternals.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/index.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/kvm-realtime.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/launch_security_sev.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/live_full_disk_backup.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/locking-lockd.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/locking.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/locking-sanlock.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/memorydevices.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/merging_disk_image_chains.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/migrationinternals.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/qemu-core-dump.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/qemu-passthrough-security.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/rpm-deployment.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/s390_protected_virt.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/secureusage.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/systemtap.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/kbase/virtiofs.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/kbase
Installing docs/manpages/virsh.1 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man1
Installing docs/manpages/virt-admin.1 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man1
Installing docs/manpages/virt-host-validate.1 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man1
Installing docs/manpages/virt-login-shell.1 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man1
Installing docs/manpages/virt-pki-query-dn.1 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man1
Installing docs/manpages/virt-pki-validate.1 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man1
Installing docs/manpages/virt-qemu-run.1 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man1
Installing docs/manpages/virt-xml-validate.1 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man1
Installing docs/manpages/libvirt-guests.8 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man8
Installing docs/manpages/libvirtd.8 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man8
Installing docs/manpages/virt-sanlock-cleanup.8 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man8
Installing docs/manpages/virt-ssh-helper.8 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man8
Installing docs/manpages/virtinterfaced.8 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man8
Installing docs/manpages/virtlockd.8 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man8
Installing docs/manpages/virtlogd.8 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man8
Installing docs/manpages/virtlxcd.8 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man8
Installing docs/manpages/virtnetworkd.8 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man8
Installing docs/manpages/virtnodedevd.8 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man8
Installing docs/manpages/virtnwfilterd.8 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man8
Installing docs/manpages/virtproxyd.8 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man8
Installing docs/manpages/virtqemud.8 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man8
Installing docs/manpages/virtsecretd.8 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man8
Installing docs/manpages/virtstoraged.8 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man8
Installing docs/manpages/virtvboxd.8 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man8
Installing docs/manpages/virkeycode-atset1.7 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man7
Installing docs/manpages/virkeycode-atset2.7 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man7
Installing docs/manpages/virkeycode-atset3.7 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man7
Installing docs/manpages/virkeycode-linux.7 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man7
Installing docs/manpages/virkeycode-osx.7 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man7
Installing docs/manpages/virkeycode-qnum.7 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man7
Installing docs/manpages/virkeycode-usb.7 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man7
Installing docs/manpages/virkeycode-win32.7 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man7
Installing docs/manpages/virkeycode-xtkbd.7 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man7
Installing docs/manpages/virkeyname-linux.7 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man7
Installing docs/manpages/virkeyname-osx.7 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man7
Installing docs/manpages/virkeyname-win32.7 to /libvirt-src/build/meson-private/dist-install/usr/local/share/man/man7
Installing docs/manpages/index.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virsh.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virt-admin.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virt-host-validate.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virt-login-shell.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virt-pki-query-dn.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virt-pki-validate.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virt-qemu-run.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virt-xml-validate.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/libvirt-guests.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/libvirtd.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virt-sanlock-cleanup.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virt-ssh-helper.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virtbhyved.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virtinterfaced.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virtlockd.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virtlogd.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virtlxcd.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virtnetworkd.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virtnodedevd.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virtnwfilterd.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virtproxyd.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virtqemud.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virtsecretd.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virtstoraged.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virtvboxd.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virtvzd.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virtxend.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virkeycode-atset1.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virkeycode-atset2.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virkeycode-atset3.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virkeycode-linux.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virkeycode-osx.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virkeycode-qnum.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virkeycode-usb.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virkeycode-win32.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virkeycode-xtkbd.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virkeyname-linux.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virkeyname-osx.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing docs/manpages/virkeyname-win32.html to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/manpages
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/include/libvirt/libvirt-admin.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/include/libvirt/libvirt-domain-checkpoint.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/include/libvirt/libvirt-domain.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/include/libvirt/libvirt-domain-snapshot.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/include/libvirt/libvirt-event.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/include/libvirt/libvirt.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/include/libvirt/libvirt-host.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/include/libvirt/libvirt-interface.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/include/libvirt/libvirt-lxc.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/include/libvirt/libvirt-network.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/include/libvirt/libvirt-nodedev.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/include/libvirt/libvirt-nwfilter.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/include/libvirt/libvirt-qemu.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/include/libvirt/libvirt-secret.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/include/libvirt/libvirt-storage.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/include/libvirt/libvirt-stream.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/include/libvirt/virterror.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-build/include/libvirt/libvirt-common.h to /libvirt-src/build/meson-private/dist-install/usr/local/include/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/arm_cortex-a53.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/arm_cortex-a57.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/arm_cortex-a72.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/arm_Falkor.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/arm_FT-2000plus.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/arm_features.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/arm_Kunpeng-920.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/arm_Tengyun-S2500.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/arm_ThunderX299xx.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/arm_vendors.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/index.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/ppc64_POWER6.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/ppc64_POWER7.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/ppc64_POWER8.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/ppc64_POWER9.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/ppc64_POWERPC_e5500.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/ppc64_POWERPC_e6500.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/ppc64_vendors.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_486.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_athlon.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Broadwell-IBRS.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Broadwell-noTSX-IBRS.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Broadwell-noTSX.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Broadwell.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Cascadelake-Server-noTSX.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Cascadelake-Server.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Conroe.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Cooperlake.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_core2duo.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_coreduo.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_cpu64-rhel5.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_cpu64-rhel6.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Dhyana.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_EPYC-IBPB.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_EPYC.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_EPYC-Milan.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_EPYC-Rome.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_features.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Haswell-IBRS.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Haswell-noTSX-IBRS.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Haswell-noTSX.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Haswell.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Icelake-Client-noTSX.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Icelake-Client.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Icelake-Server-noTSX.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Icelake-Server.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_IvyBridge-IBRS.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_IvyBridge.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_kvm32.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_kvm64.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_n270.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Nehalem-IBRS.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Nehalem.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Opteron_G1.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Opteron_G2.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Opteron_G3.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Opteron_G4.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Opteron_G5.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Penryn.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_pentium.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_pentium2.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_pentium3.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_pentiumpro.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_phenom.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_qemu32.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_qemu64.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_SandyBridge-IBRS.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_SandyBridge.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Skylake-Client-IBRS.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Skylake-Client-noTSX-IBRS.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Skylake-Client.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Skylake-Server-IBRS.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Skylake-Server-noTSX-IBRS.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Skylake-Server.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Snowridge.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_vendors.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Westmere-IBRS.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/cpu_map/x86_Westmere.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/cpu_map
Installing /libvirt-src/build/meson-private/dist-build/src/remote/libvirtd.qemu.logrotate to /libvirt-src/build/meson-private/dist-install/usr/local/etc/logrotate.d
Installing /libvirt-src/build/meson-private/dist-build/src/remote/libvirtd.lxc.logrotate to /libvirt-src/build/meson-private/dist-install/usr/local/etc/logrotate.d
Installing /libvirt-src/build/meson-private/dist-build/src/remote/libvirtd.libxl.logrotate to /libvirt-src/build/meson-private/dist-install/usr/local/etc/logrotate.d
Installing /libvirt-src/build/meson-private/dist-build/src/remote/libvirtd.logrotate to /libvirt-src/build/meson-private/dist-install/usr/local/etc/logrotate.d
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/remote/libvirtd.sysctl to /libvirt-src/build/meson-private/dist-install/usr/local/lib/sysctl.d
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/remote/libvirtd.policy to /libvirt-src/build/meson-private/dist-install/usr/local/share/polkit-1/actions
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/remote/libvirtd.rules to /libvirt-src/build/meson-private/dist-install/usr/local/share/polkit-1/rules.d
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/remote/libvirtd.sasl to /libvirt-src/build/meson-private/dist-install/usr/local/etc/sasl2
Installing /libvirt-src/build/meson-private/dist-build/src/network/default.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/qemu/networks
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/network/libvirt.zone to /libvirt-src/build/meson-private/dist-install/usr/local/lib/firewalld/zones
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/allow-arp.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/allow-dhcp-server.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/allow-dhcp.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/allow-dhcpv6-server.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/allow-dhcpv6.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/allow-incoming-ipv4.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/allow-incoming-ipv6.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/allow-ipv4.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/allow-ipv6.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/clean-traffic-gateway.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/clean-traffic.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/no-arp-ip-spoofing.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/no-arp-mac-spoofing.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/no-arp-spoofing.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/no-ip-multicast.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/no-ip-spoofing.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/no-ipv6-multicast.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/no-ipv6-spoofing.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/no-mac-broadcast.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/no-mac-spoofing.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/no-other-l2-traffic.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/no-other-rarp-traffic.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/qemu-announce-self-rarp.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/nwfilter/xml/qemu-announce-self.xml to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt/nwfilter
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/qemu/postcopy-migration.sysctl to /libvirt-src/build/meson-private/dist-install/usr/local/lib/sysctl.d
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/test/test-screenshot.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/admin/libvirt-admin.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-build/src/locking/qemu-lockd.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-build/src/locking/qemu-sanlock.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/locking/virtlockd.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/logging/virtlogd.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/lxc/lxc.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/qemu/qemu.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/libvirt.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/locking/libvirt_lockd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/locking/libvirt_sanlock.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/locking/virtlockd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/logging/virtlogd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/lxc/libvirtd_lxc.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/qemu/libvirtd_qemu.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-build/src/libvirtd.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-build/src/libvirtd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-build/src/virtproxyd.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-build/src/virtproxyd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-build/src/virtinterfaced.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-build/src/virtinterfaced.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-build/src/virtnetworkd.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-build/src/virtnetworkd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-build/src/virtnodedevd.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-build/src/virtnodedevd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-build/src/virtnwfilterd.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-build/src/virtnwfilterd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-build/src/virtsecretd.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-build/src/virtsecretd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-build/src/virtstoraged.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-build/src/virtstoraged.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-build/src/virtlxcd.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-build/src/virtlxcd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-build/src/virtchd.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-build/src/virtchd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-build/src/virtqemud.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-build/src/virtqemud.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-build/src/virtvboxd.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-build/src/virtvboxd.aug to /libvirt-src/build/meson-private/dist-install/usr/local/share/augeas/lenses
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/src/remote/virt-guest-shutdown.target to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/libvirtd.service to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/libvirtd.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/libvirtd-ro.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/libvirtd-admin.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/libvirtd-tcp.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/libvirtd-tls.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtproxyd.service to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtproxyd.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtproxyd-ro.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtproxyd-admin.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtproxyd-tcp.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtproxyd-tls.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtinterfaced.service to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtinterfaced.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtinterfaced-ro.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtinterfaced-admin.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtlockd.service to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtlockd.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtlockd-admin.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtlogd.service to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtlogd.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtlogd-admin.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtnetworkd.service to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtnetworkd.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtnetworkd-ro.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtnetworkd-admin.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtnodedevd.service to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtnodedevd.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtnodedevd-ro.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtnodedevd-admin.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtnwfilterd.service to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtnwfilterd.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtnwfilterd-ro.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtnwfilterd-admin.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtsecretd.service to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtsecretd.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtsecretd-ro.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtsecretd-admin.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtstoraged.service to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtstoraged.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtstoraged-ro.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtstoraged-admin.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtlxcd.service to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtlxcd.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtlxcd-ro.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtlxcd-admin.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtchd.service to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtchd.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtchd-ro.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtchd-admin.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtqemud.service to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtqemud.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtqemud-ro.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtqemud-admin.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtvboxd.service to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtvboxd.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtvboxd-ro.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/src/virtvboxd-admin.socket to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/tools/virt-login-shell.conf to /libvirt-src/build/meson-private/dist-install/usr/local/etc/libvirt
Installing /libvirt-src/build/meson-private/dist-build/tools/virt-xml-validate to /libvirt-src/build/meson-private/dist-install/usr/local/bin
Installing /libvirt-src/build/meson-private/dist-build/tools/virt-pki-validate to /libvirt-src/build/meson-private/dist-install/usr/local/bin
Installing /libvirt-src/build/meson-private/dist-build/tools/virt-sanlock-cleanup to /libvirt-src/build/meson-private/dist-install/usr/local/sbin
Installing /libvirt-src/build/meson-private/dist-build/tools/libvirt-guests.sh to /libvirt-src/build/meson-private/dist-install/usr/local/libexec
Installing /libvirt-src/build/meson-private/dist-build/tools/libvirt-guests.service to /libvirt-src/build/meson-private/dist-install/usr/local/lib/systemd/system
Installing /libvirt-src/build/meson-private/dist-build/tools/bash-completion/virsh to /libvirt-src/build/meson-private/dist-install/usr/local/share/bash-completion/completions
Installing /libvirt-src/build/meson-private/dist-build/tools/bash-completion/virt-admin to /libvirt-src/build/meson-private/dist-install/usr/local/share/bash-completion/completions
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/c/admin/client_close.c to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/c/admin
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/c/admin/client_info.c to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/c/admin
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/c/admin/client_limits.c to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/c/admin
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/c/admin/list_clients.c to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/c/admin
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/c/admin/list_servers.c to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/c/admin
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/c/admin/logging.c to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/c/admin
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/c/admin/threadpool_params.c to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/c/admin
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/c/domain/dommigrate.c to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/c/domain
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/c/domain/domtop.c to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/c/domain
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/c/domain/info1.c to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/c/domain
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/c/domain/rename.c to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/c/domain
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/c/domain/suspend.c to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/c/domain
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/c/misc/event-test.c to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/c/misc
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/c/misc/hellolibvirt.c to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/c/misc
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/c/misc/openauth.c to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/c/misc
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/polkit/libvirt-acl.rules to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/polkit
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/sh/virt-lxc-convert to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/sh
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/systemtap/rpc-monitor.stp to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/systemtap
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/systemtap/qemu-monitor.stp to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/systemtap
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/systemtap/lock-debug.stp to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/systemtap
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/systemtap/events.stp to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/systemtap
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/storage/pool-dir.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/storage
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/storage/pool-fs.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/storage
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/storage/pool-logical.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/storage
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/storage/pool-netfs.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/storage
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/storage/vol-cow.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/storage
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/storage/vol-qcow.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/storage
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/storage/vol-qcow2.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/storage
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/storage/vol-raw.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/storage
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/storage/vol-sparse.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/storage
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/storage/vol-vmdk.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/storage
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/test/testdev.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/test
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/test/testnodeinline.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/test
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/test/testdomfc4.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/test
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/test/testdomfv0.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/test
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/test/testnode.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/test
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/test/testnetdef.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/test
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/test/testvol.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/test
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/test/testnetpriv.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/test
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/examples/xml/test/testpool.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/examples/xml/test
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/android-chrome-192x192.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/android-chrome-256x256.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/apple-touch-icon.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/browserconfig.xml to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/favicon.ico to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/favicon-16x16.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/favicon-32x32.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/manifest.json to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/mstile-150x150.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/css/fonts.css to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/css
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/css/generic.css to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/css
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/css/libvirt.css to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/css
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/css/main.css to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/css
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/css/mobile.css to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/css
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/fonts/LICENSE.rst to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/fonts
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/fonts/overpass-bold-italic.woff to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/fonts
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/fonts/overpass-bold.woff to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/fonts
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/fonts/overpass-italic.woff to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/fonts
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/fonts/overpass-light-italic.woff to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/fonts
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/fonts/overpass-light.woff to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/fonts
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/fonts/overpass-mono-bold.woff to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/fonts
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/fonts/overpass-mono-light.woff to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/fonts
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/fonts/overpass-mono-regular.woff to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/fonts
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/fonts/overpass-mono-semibold.woff to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/fonts
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/fonts/overpass-regular.woff to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/fonts
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/html/home.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/html/left.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/html/right.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/html/up.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/html
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/images/event_loop_simple.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/images
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/images/event_loop_worker.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/images
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/images/libvirt-daemon-arch.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/images
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/images/libvirt-driver-arch.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/images
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/images/libvirt-object-model.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/images
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/images/libvirt-virConnect-example.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/images
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/images/migration-managed-direct.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/images
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/images/migration-managed-p2p.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/images
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/images/migration-native.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/images
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/images/migration-tunnel.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/images
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/images/migration-unmanaged-direct.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/images
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/js/main.js to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/js
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-banner-dark-256.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-banner-dark-800.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-banner-dark.svg to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-banner-light-256.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-banner-light-800.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-banner-light.svg to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-base.svg to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-square-128.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-square-192.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-square-256.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-square-96.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-square-powered-128.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-square-powered-192.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-square-powered-256.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-square-powered-96.png to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-square-powered.svg to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-square.svg to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-sticker-hexagon.svg to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/logos/logo-sticker-square.svg to /libvirt-src/build/meson-private/dist-install/usr/local/share/doc/libvirt/html/logos
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/basictypes.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/capability.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/cpu.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/cputypes.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/domainbackup.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/domaincaps.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/domaincheckpoint.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/domaincommon.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/domain.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/domainsnapshot.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/interface.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/networkcommon.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/networkport.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/network.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/nodedev.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/nwfilterbinding.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/nwfilter_params.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/nwfilter.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/secret.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/storagecommon.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/storagepoolcaps.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/storagepool.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/docs/schemas/storagevol.rng to /libvirt-src/build/meson-private/dist-install/usr/local/share/libvirt/schemas
Installing /libvirt-src/build/meson-private/dist-build/libvirt.pc to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/pkgconfig
Installing /libvirt-src/build/meson-private/dist-build/libvirt-qemu.pc to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/pkgconfig
Installing /libvirt-src/build/meson-private/dist-build/libvirt-lxc.pc to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/pkgconfig
Installing /libvirt-src/build/meson-private/dist-build/libvirt-admin.pc to /libvirt-src/build/meson-private/dist-install/usr/local/lib64/pkgconfig
Running custom install script '/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/meson-python.sh /usr/bin/python3 /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/meson-install-symlink.py /usr/local/etc/libvirt/qemu/networks/autostart ../default.xml default.xml'
Running custom install script '/libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/meson-python.sh /usr/bin/python3 /libvirt-src/build/meson-private/dist-unpack/libvirt-8.1.0/scripts/meson-install-dirs.py /usr/local/etc/libvirt /var/local/log/libvirt /var/local/run/libvirt /var/local/run/libvirt/common /var/local/run/libvirt/interface /var/local/lib/libvirt/lockd /var/local/lib/libvirt/lockd/files /var/local/run/libvirt/lockd /var/local/lib/libvirt/sanlock /usr/local/etc/libvirt/qemu/networks /usr/local/etc/libvirt/qemu/networks/autostart /var/local/lib/libvirt/network /var/local/lib/libvirt/dnsmasq /var/local/run/libvirt/network /var/local/run/libvirt/nodedev /usr/local/etc/libvirt/nwfilter /var/local/run/libvirt/nwfilter-binding /var/local/run/libvirt/nwfilter /usr/local/etc/libvirt/secrets /var/local/run/libvirt/secrets /usr/local/etc/libvirt/storage /usr/local/etc/libvirt/storage/autostart /var/local/run/libvirt/storage /usr/local/etc/libvirt/lxc /usr/local/etc/libvirt/lxc/autostart /var/local/lib/libvirt/lxc /var/local/log/libvirt/lxc /var/local/run/libvirt/lxc /var/local/lib/libvirt/ch /var/local/log/libvirt/ch /var/local/run/libvirt/ch /usr/local/etc/libvirt/qemu /usr/local/etc/libvirt/qemu/autostart /var/local/cache/libvirt/qemu /var/local/lib/libvirt/qemu /var/local/lib/libvirt/qemu/channel /var/local/lib/libvirt/qemu/channel/target /var/local/lib/libvirt/qemu/checkpoint /var/local/lib/libvirt/qemu/dump /var/local/lib/libvirt/qemu/nvram /var/local/lib/libvirt/qemu/ram /var/local/lib/libvirt/qemu/save /var/local/lib/libvirt/qemu/snapshot /var/local/lib/libvirt/swtpm /var/local/log/libvirt/qemu /var/local/log/swtpm/libvirt/qemu /var/local/run/libvirt/qemu /var/local/run/libvirt/qemu/dbus /var/local/run/libvirt/qemu/slirp /var/local/run/libvirt/qemu/swtpm /var/local/cache/libvirt /var/local/lib/libvirt/images /var/local/lib/libvirt/filesystems /var/local/lib/libvirt/boot'
Running custom install script '/usr/bin/meson --internal gettext install --subdir=po --localedir=share/locale --pkgname=libvirt'
Distribution package /libvirt-src/build/meson-dist/libvirt-8.1.0.tar.xz tested
Created meson-dist/libvirt-8.1.0.tar.xz
```

```bash
[root@c63843475281 libvirt-src]# dnf install -y createrepo hostname
Last metadata expiration check: 1:20:29 ago on Fri 12 Aug 2022 09:52:41 AM UTC.
Dependencies resolved.
====================================================================================================================================================================================================================================================================================== Package                                                                  Architecture                                                  Version                                                                Repository                                                        Size
======================================================================================================================================================================================================================================================================================Installing:
 createrepo_c                                                             x86_64                                                        0.17.7-6.el8                                                           appstream                                                         89 k
 hostname                                                                 x86_64                                                        3.20-7.el8.0.1                                                         baseos                                                            32 k
Installing dependencies:
 createrepo_c-libs                                                        x86_64                                                        0.17.7-6.el8                                                           appstream                                                        116 k
 drpm                                                                     x86_64                                                        0.4.1-3.el8                                                            appstream                                                         68 k

Transaction Summary
======================================================================================================================================================================================================================================================================================Install  4 Packages

Total download size: 306 k
Installed size: 622 k
Downloading Packages:
(1/4): drpm-0.4.1-3.el8.x86_64.rpm                                                                                                                                                                                                                    187 kB/s |  68 kB     00:00    
(2/4): createrepo_c-libs-0.17.7-6.el8.x86_64.rpm                                                                                                                                                                                                      305 kB/s | 116 kB     00:00    
(3/4): createrepo_c-0.17.7-6.el8.x86_64.rpm                                                                                                                                                                                                           223 kB/s |  89 kB     00:00    
[MIRROR] hostname-3.20-7.el8.0.1.x86_64.rpm: Interrupted by header callback: Server reports Content-Length: 1136 but expected size is: 32892                                                                                                                                         
(4/4): hostname-3.20-7.el8.0.1.x86_64.rpm                                                                                                                                                                                                              51 kB/s |  32 kB     00:00    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------Total                                                                                                                                                                                                                                                 5.8 kB/s | 306 kB     00:52     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                                                                                              1/1 
  Installing       : drpm-0.4.1-3.el8.x86_64                                                                                                                                                                                                                                      1/4 
  Installing       : createrepo_c-libs-0.17.7-6.el8.x86_64                                                                                                                                                                                                                        2/4 
  Installing       : createrepo_c-0.17.7-6.el8.x86_64                                                                                                                                                                                                                             3/4 
  Installing       : hostname-3.20-7.el8.0.1.x86_64                                                                                                                                                                                                                               4/4 
  Running scriptlet: hostname-3.20-7.el8.0.1.x86_64                                                                                                                                                                                                                               4/4 
  Verifying        : createrepo_c-0.17.7-6.el8.x86_64                                                                                                                                                                                                                             1/4 
  Verifying        : createrepo_c-libs-0.17.7-6.el8.x86_64                                                                                                                                                                                                                        2/4 
  Verifying        : drpm-0.4.1-3.el8.x86_64                                                                                                                                                                                                                                      3/4 
  Verifying        : hostname-3.20-7.el8.0.1.x86_64                                                                                                                                                                                                                               4/4 

Installed:
  createrepo_c-0.17.7-6.el8.x86_64                                      createrepo_c-libs-0.17.7-6.el8.x86_64                                      drpm-0.4.1-3.el8.x86_64                                      hostname-3.20-7.el8.0.1.x86_64                                     

Complete!
[root@c63843475281 libvirt-src]# rpmbuild -ta /libvirt-src/build/meson-dist/libvirt-*.tar.xz
Executing(%prep): /bin/sh -e /var/tmp/rpm-tmp.dALIRC
+ umask 022
+ cd /root/rpmbuild/BUILD
+ cd /root/rpmbuild/BUILD
+ rm -rf libvirt-8.1.0
+ /usr/bin/xz -dc /libvirt-src/build/meson-dist/libvirt-8.1.0.tar.xz
+ /usr/bin/tar -xof -
+ STATUS=0
+ '[' 0 -ne 0 ']'
+ cd libvirt-8.1.0
+ /usr/bin/chmod -Rf a+rX,u+w,g-w,o-w .
+ /usr/bin/git init -q
+ /usr/bin/git config user.name rpm-build
+ /usr/bin/git config user.email '<rpm-build>'
+ /usr/bin/git add .
+ /usr/bin/git commit -q --allow-empty -a --author 'rpm-build <rpm-build>' -m 'libvirt-8.1.0 base'
+ exit 0
Executing(%build): /bin/sh -e /var/tmp/rpm-tmp.au0Mwa
+ umask 022
+ cd /root/rpmbuild/BUILD
+ cd libvirt-8.1.0
++ stat --printf=%Y /root/rpmbuild/SPECS/libvirt.spec
+ export SOURCE_DATE_EPOCH=1660302961
+ SOURCE_DATE_EPOCH=1660302961
+ CFLAGS='-O2 -g -pipe -Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS -fexceptions -fstack-protector-strong -grecord-gcc-switches -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1 -m64 -mtune=generic -fasynchronous-unwind-tables -fstack-clash-protection -fcf-protection'
+ export CFLAGS
+ CXXFLAGS='-O2 -g -pipe -Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS -fexceptions -fstack-protector-strong -grecord-gcc-switches -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1 -m64 -mtune=generic -fasynchronous-unwind-tables -fstack-clash-protection -fcf-protection'
+ export CXXFLAGS
+ FFLAGS='-O2 -g -pipe -Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS -fexceptions -fstack-protector-strong -grecord-gcc-switches -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1 -m64 -mtune=generic -fasynchronous-unwind-tables -fstack-clash-protection -fcf-protection -I/usr/lib64/gfortran/modules'
+ export FFLAGS
+ FCFLAGS='-O2 -g -pipe -Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS -fexceptions -fstack-protector-strong -grecord-gcc-switches -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1 -m64 -mtune=generic -fasynchronous-unwind-tables -fstack-clash-protection -fcf-protection -I/usr/lib64/gfortran/modules'
+ export FCFLAGS
+ LDFLAGS='-Wl,-z,relro  -Wl,-z,now -specs=/usr/lib/rpm/redhat/redhat-hardened-ld'
+ export LDFLAGS
+ /usr/bin/meson --buildtype=plain --prefix=/usr --libdir=/usr/lib64 --libexecdir=/usr/libexec --bindir=/usr/bin --sbindir=/usr/sbin --includedir=/usr/include --datadir=/usr/share --mandir=/usr/share/man --infodir=/usr/share/info --localedir=/usr/share/locale --sysconfdir=/etc --localstatedir=/var --sharedstatedir=/var/lib --wrap-mode=nodownload --auto-features=enabled . x86_64-redhat-linux-gnu -Drunstatedir=/run -Ddriver_qemu=enabled -Ddriver_openvz=disabled -Ddriver_lxc=disabled -Ddriver_vbox=disabled -Ddriver_libxl=disabled -Dsasl=enabled -Dpolkit=enabled -Ddriver_libvirtd=enabled -Ddriver_remote=enabled -Ddriver_test=enabled -Ddriver_esx=enabled -Dcurl=enabled -Ddriver_hyperv=disabled -Dopenwsman=disabled -Ddriver_vmware=disabled -Ddriver_vz=disabled -Ddriver_bhyve=disabled -Ddriver_ch=disabled -Dremote_default_mode=legacy -Ddriver_interface=enabled -Ddriver_network=enabled -Dstorage_fs=enabled -Dstorage_lvm=enabled -Dstorage_iscsi=enabled -Dstorage_iscsi_direct=enabled -Dlibiscsi=enabled -Dstorage_scsi=enabled -Dstorage_disk=enabled -Dstorage_mpath=enabled -Dstorage_rbd=enabled -Dstorage_sheepdog=disabled -Dstorage_gluster=enabled -Dglusterfs=enabled -Dstorage_zfs=disabled -Dstorage_vstorage=disabled -Dnumactl=enabled -Dnumad=enabled -Dcapng=enabled -Dfuse=disabled -Dnetcf=enabled -Dselinux=enabled -Dselinux_mount=/sys/fs/selinux -Dapparmor=disabled -Dapparmor_profiles=disabled -Dsecdriver_apparmor=disabled -Dudev=enabled -Dyajl=enabled -Dsanlock=enabled -Dlibpcap=enabled -Dlibnl=enabled -Daudit=enabled -Ddtrace=enabled -Dfirewalld=enabled -Dfirewalld_zone=enabled -Dwireshark_dissector=enabled -Dlibssh=enabled -Dlibssh2=disabled -Dpm_utils=disabled -Dnss=enabled '-Dpackager=Unknown, 2022-08-12-11:16:01, c63843475281' -Dpackager_version=1.el8 -Dqemu_user=qemu -Dqemu_group=qemu -Dqemu_moddir=/usr/lib64/qemu -Dqemu_datadir=/usr/share/qemu -Dtls_priority=@LIBVIRT,SYSTEM -Dwerror=true -Dexpensive_tests=enabled -Dinit_script=systemd -Ddocs=enabled -Dtests=enabled -Drpath=disabled -Dlogin_shell=disabled
The Meson build system
Version: 0.58.2
Source dir: /root/rpmbuild/BUILD/libvirt-8.1.0
Build dir: /root/rpmbuild/BUILD/libvirt-8.1.0/x86_64-redhat-linux-gnu
Build type: native build
Project name: libvirt
Project version: 8.1.0
C compiler for the host machine: ccache cc (gcc 8.5.0 "cc (GCC) 8.5.0 20210514 (Red Hat 8.5.0-15)")
C linker for the host machine: cc ld.bfd 2.30-117
Host machine cpu family: x86_64
Host machine cpu: x86_64
Configuring configmake.h using configuration
Checking for size of "ptrdiff_t" : 8
Checking for size of "size_t" : 8
Compiler for C supports arguments -fasynchronous-unwind-tables: YES 
Compiler for C supports arguments -fexceptions: YES 
Compiler for C supports arguments -fipa-pure-const: YES 
Compiler for C supports arguments -fno-common: YES 
Compiler for C supports arguments -Wabsolute-value: NO 
Compiler for C supports arguments -Waddress: YES 
Compiler for C supports arguments -Waddress-of-packed-member: NO 
Compiler for C supports arguments -Waggressive-loop-optimizations: YES 
Compiler for C supports arguments -Walloc-size-larger-than=9223372036854775807: YES 
Compiler for C supports arguments -Walloca: YES 
Compiler for C supports arguments -Warray-bounds=2: YES 
Compiler for C supports arguments -Wattribute-alias=2: NO 
Compiler for C supports arguments -Wattribute-warning: NO 
Compiler for C supports arguments -Wattributes: YES 
Compiler for C supports arguments -Wbool-compare: YES 
Compiler for C supports arguments -Wbool-operation: YES 
Compiler for C supports arguments -Wbuiltin-declaration-mismatch: YES 
Compiler for C supports arguments -Wbuiltin-macro-redefined: YES 
Compiler for C supports arguments -Wcannot-profile: NO 
Compiler for C supports arguments -Wcast-align: YES 
Compiler for C supports arguments -Wcast-align=strict: YES 
Compiler for C supports arguments -Wno-cast-function-type: YES 
Compiler for C supports arguments -Wchar-subscripts: YES 
Compiler for C supports arguments -Wclobbered: YES 
Compiler for C supports arguments -Wcomment: YES 
Compiler for C supports arguments -Wcomments: YES 
Compiler for C supports arguments -Wcoverage-mismatch: YES 
Compiler for C supports arguments -Wcpp: YES 
Compiler for C supports arguments -Wdangling-else: YES 
Compiler for C supports arguments -Wdate-time: YES 
Compiler for C supports arguments -Wdeclaration-after-statement: YES 
Compiler for C supports arguments -Wdeprecated-declarations: YES 
Compiler for C supports arguments -Wdesignated-init: YES 
Compiler for C supports arguments -Wdiscarded-array-qualifiers: YES 
Compiler for C supports arguments -Wdiscarded-qualifiers: YES 
Compiler for C supports arguments -Wdiv-by-zero: YES 
Compiler for C supports arguments -Wduplicated-cond: YES 
Compiler for C supports arguments -Wduplicate-decl-specifier: YES 
Compiler for C supports arguments -Wempty-body: YES 
Compiler for C supports arguments -Wendif-labels: YES 
Compiler for C supports arguments -Wexpansion-to-defined: YES 
Compiler for C supports arguments -Wformat-contains-nul: YES 
Compiler for C supports arguments -Wformat-extra-args: YES 
Compiler for C supports arguments -Wno-format-nonliteral: YES 
Compiler for C supports arguments -Wformat-overflow=2: YES 
Compiler for C supports arguments -Wformat-security: YES 
Compiler for C supports arguments -Wno-format-truncation: YES 
Compiler for C supports arguments -Wformat-y2k: YES 
Compiler for C supports arguments -Wformat-zero-length: YES 
Compiler for C supports arguments -Wframe-address: YES 
Compiler for C supports arguments -Wframe-larger-than=4096: YES 
Compiler for C supports arguments -Wfree-nonheap-object: YES 
Compiler for C supports arguments -Whsa: YES 
Compiler for C supports arguments -Wif-not-aligned: YES 
Compiler for C supports arguments -Wignored-attributes: YES 
Compiler for C supports arguments -Wignored-qualifiers: YES 
Compiler for C supports arguments -Wimplicit: YES 
Compiler for C supports arguments -Wimplicit-fallthrough=5: YES 
Compiler for C supports arguments -Wimplicit-function-declaration: YES 
Compiler for C supports arguments -Wimplicit-int: YES 
Compiler for C supports arguments -Wincompatible-pointer-types: YES 
Compiler for C supports arguments -Winit-self: YES 
Compiler for C supports arguments -Winline: YES 
Compiler for C supports arguments -Wint-conversion: YES 
Compiler for C supports arguments -Wint-in-bool-context: YES 
Compiler for C supports arguments -Wint-to-pointer-cast: YES 
Compiler for C supports arguments -Winvalid-memory-model: YES 
Compiler for C supports arguments -Winvalid-pch: YES 
Compiler for C supports arguments -Wjump-misses-init: YES 
Compiler for C supports arguments -Wlogical-not-parentheses: YES 
Compiler for C supports arguments -Wlogical-op: YES 
Compiler for C supports arguments -Wmain: YES 
Compiler for C supports arguments -Wmaybe-uninitialized: YES 
Compiler for C supports arguments -Wmemset-elt-size: YES 
Compiler for C supports arguments -Wmemset-transposed-args: YES 
Compiler for C supports arguments -Wmisleading-indentation: YES 
Compiler for C supports arguments -Wmissing-attributes: YES 
Compiler for C supports arguments -Wmissing-braces: YES 
Compiler for C supports arguments -Wmissing-declarations: YES 
Compiler for C supports arguments -Wmissing-field-initializers: YES 
Compiler for C supports arguments -Wmissing-include-dirs: YES 
Compiler for C supports arguments -Wmissing-parameter-type: YES 
Compiler for C supports arguments -Wmissing-profile: NO 
Compiler for C supports arguments -Wmissing-prototypes: YES 
Compiler for C supports arguments -Wmultichar: YES 
Compiler for C supports arguments -Wmultistatement-macros: YES 
Compiler for C supports arguments -Wnarrowing: YES 
Compiler for C supports arguments -Wnested-externs: YES 
Compiler for C supports arguments -Wnonnull: YES 
Compiler for C supports arguments -Wnonnull-compare: YES 
Compiler for C supports arguments -Wnormalized=nfc: YES 
Compiler for C supports arguments -Wnull-dereference: YES 
Compiler for C supports arguments -Wodr: YES 
Compiler for C supports arguments -Wold-style-declaration: YES 
Compiler for C supports arguments -Wold-style-definition: YES 
Compiler for C supports arguments -Wopenmp-simd: YES 
Compiler for C supports arguments -Woverflow: YES 
Compiler for C supports arguments -Woverride-init: YES 
Compiler for C supports arguments -Wpacked-bitfield-compat: YES 
Compiler for C supports arguments -Wpacked-not-aligned: YES 
Compiler for C supports arguments -Wparentheses: YES 
Compiler for C supports arguments -Wpointer-arith: YES 
Compiler for C supports arguments -Wpointer-compare: YES 
Compiler for C supports arguments -Wpointer-sign: YES 
Compiler for C supports arguments -Wpointer-to-int-cast: YES 
Compiler for C supports arguments -Wpragmas: YES 
Compiler for C supports arguments -Wpsabi: YES 
Compiler for C supports arguments -Wrestrict: YES 
Compiler for C supports arguments -Wreturn-local-addr: YES 
Compiler for C supports arguments -Wreturn-type: YES 
Compiler for C supports arguments -Wscalar-storage-order: YES 
Compiler for C supports arguments -Wsequence-point: YES 
Compiler for C supports arguments -Wshadow: YES 
Compiler for C supports arguments -Wshift-count-negative: YES 
Compiler for C supports arguments -Wshift-count-overflow: YES 
Compiler for C supports arguments -Wshift-negative-value: YES 
Compiler for C supports arguments -Wshift-overflow=2: YES 
Compiler for C supports arguments -Wno-sign-compare: YES 
Compiler for C supports arguments -Wsizeof-array-argument: YES 
Compiler for C supports arguments -Wsizeof-pointer-div: YES 
Compiler for C supports arguments -Wsizeof-pointer-memaccess: YES 
Compiler for C supports arguments -Wstrict-aliasing: YES 
Compiler for C supports arguments -Wstrict-prototypes: YES 
Compiler for C supports arguments -Wstringop-overflow=2: YES 
Compiler for C supports arguments -Wstringop-truncation: YES 
Compiler for C supports arguments -Wsuggest-attribute=cold: YES 
Compiler for C supports arguments -Wno-suggest-attribute=const: YES 
Compiler for C supports arguments -Wsuggest-attribute=format: YES 
Compiler for C supports arguments -Wsuggest-attribute=noreturn: YES 
Compiler for C supports arguments -Wno-suggest-attribute=pure: YES 
Compiler for C supports arguments -Wsuggest-final-methods: YES 
Compiler for C supports arguments -Wsuggest-final-types: YES 
Compiler for C supports arguments -Wswitch: YES 
Compiler for C supports arguments -Wswitch-bool: YES 
Compiler for C supports arguments -Wswitch-enum: YES 
Compiler for C supports arguments -Wswitch-unreachable: YES 
Compiler for C supports arguments -Wsync-nand: YES 
Compiler for C supports arguments -Wtautological-compare: YES 
Compiler for C supports arguments -Wtrampolines: YES 
Compiler for C supports arguments -Wtrigraphs: YES 
Compiler for C supports arguments -Wtype-limits: YES 
Compiler for C supports arguments -Wno-typedef-redefinition: NO 
Compiler for C supports arguments -Wuninitialized: YES 
Compiler for C supports arguments -Wunknown-pragmas: YES 
Compiler for C supports arguments -Wunused: YES 
Compiler for C supports arguments -Wunused-but-set-parameter: YES 
Compiler for C supports arguments -Wunused-but-set-variable: YES 
Compiler for C supports arguments -Wunused-const-variable=2: YES 
Compiler for C supports arguments -Wunused-function: YES 
Compiler for C supports arguments -Wunused-label: YES 
Compiler for C supports arguments -Wunused-local-typedefs: YES 
Compiler for C supports arguments -Wunused-parameter: YES 
Compiler for C supports arguments -Wunused-result: YES 
Compiler for C supports arguments -Wunused-value: YES 
Compiler for C supports arguments -Wunused-variable: YES 
Compiler for C supports arguments -Wvarargs: YES 
Compiler for C supports arguments -Wvariadic-macros: YES 
Compiler for C supports arguments -Wvector-operation-performance: YES 
Compiler for C supports arguments -Wvla: YES 
Compiler for C supports arguments -Wvolatile-register-var: YES 
Compiler for C supports arguments -Wwrite-strings: YES 
Compiler for C supports arguments -fstack-protector-strong: YES 
First supported argument: -fstack-protector-strong
Checking if "-Wdouble-promotion" compiles: YES 
Compiler for C supports arguments -Wsuggest-attribute=format: YES (cached)
Compiler for C supports arguments -Wframe-larger-than=262144: YES 
Compiler for C supports link arguments -Wl,-z,relro: YES 
Compiler for C supports link arguments -Wl,-z,now: YES 
Compiler for C supports link arguments -Wl,-z,nodelete: YES 
Compiler for C supports link arguments -Wl,-z,defs: YES 
Compiler for C supports link arguments -Wl,--no-copy-dt-needed-entries: YES 
Compiler for C supports link arguments -Wl,--version-script=/root/rpmbuild/BUILD/libvirt-8.1.0/src/libvirt_qemu.syms: YES 
Compiler for C supports link arguments -Wl,-export-dynamic: YES 
First supported link argument: -Wl,-export-dynamic
Checking for function "elf_aux_info" : NO 
Checking for function "fallocate" : YES 
Checking for function "getauxval" : YES 
Checking for function "getegid" : YES 
Checking for function "geteuid" : YES 
Checking for function "getgid" : YES 
Checking for function "getifaddrs" : YES 
Checking for function "getmntent_r" : YES 
Checking for function "getpwuid_r" : YES 
Checking for function "getrlimit" : YES 
Checking for function "getuid" : YES 
Checking for function "getutxid" : YES 
Checking for function "if_indextoname" : YES 
Checking for function "mmap" : YES 
Checking for function "newlocale" : YES 
Checking for function "pipe2" : YES 
Checking for function "posix_fallocate" : YES 
Checking for function "posix_memalign" : YES 
Checking for function "prlimit" : YES 
Checking for function "sched_setscheduler" : YES 
Checking for function "setgroups" : YES 
Checking for function "setns" : YES 
Checking for function "setrlimit" : YES 
Checking for function "symlink" : YES 
Checking for function "sysctlbyname" : NO 
Checking for function "__lxstat" : YES 
Checking for function "__lxstat64" : YES 
Checking for function "__xstat" : YES 
Checking for function "__xstat64" : YES 
Checking for function "lstat" : YES 
Checking for function "lstat64" : YES 
Checking for function "stat" : YES 
Checking for function "stat64" : YES 
Header <sys/stat.h> has symbol "__lxstat" : YES 
Header <sys/stat.h> has symbol "__lxstat64" : NO 
Header <sys/stat.h> has symbol "__xstat" : YES 
Header <sys/stat.h> has symbol "__xstat64" : NO 
Header <sys/stat.h> has symbol "lstat" : YES 
Header <sys/stat.h> has symbol "lstat64" : NO 
Header <sys/stat.h> has symbol "stat" : YES 
Header <sys/stat.h> has symbol "stat64" : NO 
Has header "asm/hwcap.h" : NO 
Has header "ifaddrs.h" : YES 
Has header "libtasn1.h" : YES 
Has header "linux/kvm.h" : YES 
Has header "linux/magic.h" : YES 
Has header "mntent.h" : YES 
Has header "net/ethernet.h" : YES 
Has header "net/if.h" : YES 
Has header "pty.h" : YES 
Has header "pwd.h" : YES 
Has header "sched.h" : YES 
Has header "sys/auxv.h" : YES 
Has header "sys/ioctl.h" : YES 
Has header "sys/mount.h" : YES 
Has header "sys/syscall.h" : YES 
Has header "sys/ucred.h" : NO 
Has header "syslog.h" : YES 
Has header "util.h" : NO 
Has header "xlocale.h" : NO 
Has header "linux/devlink.h" : YES 
Has header "linux/param.h" : YES 
Has header "linux/sockios.h" : YES 
Has header "linux/if_bridge.h" : YES 
Has header "linux/if_tun.h" : YES 
Header <endian.h> has symbol "htole64" : YES 
Header <linux/ethtool.h> has symbol "ETH_FLAG_TXVLAN" : YES 
Header <linux/ethtool.h> has symbol "ETH_FLAG_NTUPLE" : YES 
Header <linux/ethtool.h> has symbol "ETH_FLAG_RXHASH" : YES 
Header <linux/ethtool.h> has symbol "ETH_FLAG_LRO" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_GGSO" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_GGRO" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_GFLAGS" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_GFEATURES" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_SCOALESCE" : YES 
Header <linux/ethtool.h> has symbol "ETHTOOL_GCOALESCE" : YES 
Header <linux/if_vlan.h> has symbol "GET_VLAN_VID_CMD" : YES 
Header <unistd.h> has symbol "SEEK_HOLE" : YES 
Header <net/if_dl.h> has symbol "link_addr" : NO 
Header <sched.h> has symbol "cpu_set_t" : YES 
Header <linux/devlink.h> has symbol "DEVLINK_CMD_ESWITCH_GET" : YES 
Header <linux/vhost.h> has symbol "VHOST_VSOCK_SET_GUEST_CID" : YES 
Header <linux/bpf.h> has symbol "BPF_PROG_QUERY" : YES 
Header <linux/bpf.h> has symbol "BPF_CGROUP_DEVICE" : YES 
Header <net/if_bridgevar.h> has symbol "BRDGSFD" : NO 
Header <sys/cpuset.h> has symbol "cpuset_getaffinity" : NO 
Header <mach/clock.h> has symbol "clock_serv_t" : NO 
Checking for type "struct ifreq" : YES 
Checking for type "struct sockpeercred" : NO 
Checking whether type "struct ifreq" has member "ifr_newname" : YES 
Checking whether type "struct ifreq" has member "ifr_ifindex" : YES 
Checking whether type "struct ifreq" has member "ifr_index" : NO 
Checking whether type "struct ifreq" has member "ifr_hwaddr" : YES 
Checking for size of "long" : 8
Program perl found: YES (/usr/bin/perl)
Program python3 found: YES (/usr/bin/python3)
Program xmllint found: YES (/usr/bin/xmllint)
Program xsltproc found: YES (/usr/bin/xsltproc)
Program rpcgen found: YES (/usr/bin/rpcgen)
Program augparse found: YES (/usr/bin/augparse)
Program dmidecode found: YES (/usr/sbin/dmidecode)
Program ebtables found: YES (/usr/sbin/ebtables)
Program flake8 found: YES (/usr/bin/flake8)
Program ip found: YES (/usr/sbin/ip)
Program ip6tables found: YES (/usr/sbin/ip6tables)
Program iptables found: YES (/usr/sbin/iptables)
Program iscsiadm found: YES (/usr/sbin/iscsiadm)
Program mdevctl found: NO
Program mm-ctl found: NO
Program modprobe found: YES (/usr/sbin/modprobe)
Program ovs-vsctl found: NO
Program pdwtags found: YES (/usr/bin/pdwtags)
Program rmmod found: YES (/usr/sbin/rmmod)
Program scrub found: YES (/usr/bin/scrub)
Program tc found: YES (/usr/sbin/tc)
Program udevadm found: YES (/usr/sbin/udevadm)
Found pkg-config: /usr/bin/pkg-config (1.4.2)
Run-time dependency libtirpc found: YES 1.1.4
Library acl found: YES
Dependency libapparmor skipped: feature apparmor disabled
Library attr found: YES
Run-time dependency audit found: YES 3.0.7
Run-time dependency bash-completion found: YES 2.7
Run-time dependency blkid found: YES 2.32.1
Run-time dependency libcap-ng found: YES 0.7.11
Run-time dependency libcurl found: YES 7.61.1
Run-time dependency devmapper found: YES 1.02.181
Library dl found: YES
Has header "dlfcn.h" : YES 
Dependency fuse skipped: feature fuse disabled
Run-time dependency glib-2.0 found: YES 2.56.4
Run-time dependency gobject-2.0 found: YES 2.56.4
Run-time dependency gio-unix-2.0 found: YES 2.56.4
Run-time dependency glusterfs-api found: YES 7.6.0
Run-time dependency gnutls found: YES 3.6.16
Run-time dependency libiscsi found: YES 1.18.0
Run-time dependency libnl-3.0 found: YES 3.7.0
Run-time dependency libnl-route-3.0 found: YES 3.7.0
Run-time dependency libparted found: YES 3.2
Run-time dependency pcap found: YES 1.9.1
Run-time dependency libssh found: YES 0.9.6
Checking for function "ssh_get_server_publickey" with dependency libssh: YES 
Checking for function "ssh_session_is_known_server" with dependency libssh: YES 
Checking for function "ssh_session_update_known_hosts" with dependency libssh: YES 
Dependency libssh2 skipped: feature libssh2 disabled
Run-time dependency libxml-2.0 found: YES 2.9.7
Library m found: YES
Run-time dependency netcf found: YES 0.2.8
Checking for function "gettext" : YES 
Has header "libintl.h" : YES 
Program xgettext found: YES (/usr/bin/xgettext)
Program msgfmt found: YES (/usr/bin/msgfmt)
Program msgmerge found: YES (/usr/bin/msgmerge)
Library numa found: YES
Dependency openwsman skipped: feature openwsman disabled
Did not find CMake 'cmake'
Found CMake: NO
Run-time dependency parallels-sdk found: NO (tried pkgconfig and cmake)
Run-time dependency pciaccess found: YES 0.14
Library rbd found: YES
Library rados found: YES
Checking for function "rbd_get_features" with dependency -lrbd: YES 
Checking for function "rbd_list2" with dependency -lrbd: NO 
Run-time dependency readline found: NO (tried pkgconfig and cmake)
Library readline found: YES
Header <readline/readline.h> has symbol "rl_completion_quote_character" : YES 
Run-time dependency libsanlock_client found: YES 3.8.4
Checking for function "sanlock_strerror" with dependency libsanlock_client: YES 
Run-time dependency libsasl2 found: YES 2.1.27
Run-time dependency libselinux found: YES 2.9
Run-time dependency threads found: YES
Run-time dependency libudev found: YES 239
Library util found: YES
Run-time dependency wireshark found: YES 2.6.2
Has header "wireshark/ws_version.h" : NO 
Run-time dependency yajl found: YES 2.1.0
Program qemu-bridge-helper found: NO
Program qemu-pr-helper found: NO
Program slirp-helper found: NO
Program dbus-daemon found: YES (/usr/bin/dbus-daemon)
Has header "mntent.h" : YES (cached)
Program mount found: YES (/usr/bin/mount)
Program umount found: YES (/usr/bin/umount)
Program mkfs found: YES (/usr/sbin/mkfs)
Program showmount found: YES (/usr/sbin/showmount)
Program pvcreate found: YES (/usr/sbin/pvcreate)
Program vgcreate found: YES (/usr/sbin/vgcreate)
Program lvcreate found: YES (/usr/sbin/lvcreate)
Program pvremove found: YES (/usr/sbin/pvremove)
Program vgremove found: YES (/usr/sbin/vgremove)
Program lvremove found: YES (/usr/sbin/lvremove)
Program lvchange found: YES (/usr/sbin/lvchange)
Program vgchange found: YES (/usr/sbin/vgchange)
Program vgscan found: YES (/usr/sbin/vgscan)
Program pvs found: YES (/usr/sbin/pvs)
Program vgs found: YES (/usr/sbin/vgs)
Program lvs found: YES (/usr/sbin/lvs)
Program dtrace found: YES (/usr/bin/dtrace)
Has header "nss.h" : YES 
Checking for type "struct gaih_addrtuple" : YES 
Checking for type "ns_mtab" : NO 
Program numad found: YES (/usr/bin/numad)
Program apibuild.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/apibuild.py)
Program augeas-gentest.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/augeas-gentest.py)
Program check-aclperms.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/check-aclperms.py)
Program check-aclrules.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/check-aclrules.py)
Program check-driverimpls.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/check-driverimpls.py)
Program check-drivername.py found: YES (/usr/libexec/platform-python /root/rpmbuild/BUILD/libvirt-8.1.0/scripts/check-drivername.py)
Program check-file-access.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/check-file-access.py)
Program check-remote-protocol.py found: YES (/usr/libexec/platform-python /root/rpmbuild/BUILD/libvirt-8.1.0/scripts/check-remote-protocol.py)
Program check-symfile.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/check-symfile.py)
Program check-symsorting.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/check-symsorting.py)
Program dtrace2systemtap.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/dtrace2systemtap.py)
Program esx_vi_generator.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/esx_vi_generator.py)
Program genaclperms.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/genaclperms.py)
Program genpolkit.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/genpolkit.py)
Program gensystemtap.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/gensystemtap.py)
Program group-qemu-caps.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/group-qemu-caps.py)
Program header-ifdef.py found: YES (/usr/libexec/platform-python /root/rpmbuild/BUILD/libvirt-8.1.0/scripts/header-ifdef.py)
Program hvsupport.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/hvsupport.py)
Program hyperv_wmi_generator.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/hyperv_wmi_generator.py)
Program meson-dist.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-dist.py)
Program meson-gen-authors.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-gen-authors.py)
Program meson-gen-def.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-gen-def.py)
Program meson-gen-sym.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-gen-sym.py)
Program meson-install-dirs.py found: YES (/usr/libexec/platform-python /root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-install-dirs.py)
Program meson-install-symlink.py found: YES (/usr/libexec/platform-python /root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-install-symlink.py)
Program meson-install-web.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-install-web.py)
Program meson-python.sh found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-python.sh)
Program meson-timestamp.py found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-timestamp.py)
Program mock-noinline.py found: YES (/usr/libexec/platform-python /root/rpmbuild/BUILD/libvirt-8.1.0/scripts/mock-noinline.py)
Program prohibit-duplicate-header.py found: YES (/usr/libexec/platform-python /root/rpmbuild/BUILD/libvirt-8.1.0/scripts/prohibit-duplicate-header.py)
Configuring libvirt-common.h using configuration
Program env found: YES (/usr/bin/env)
Program env found: YES (/usr/bin/env)
Program /root/rpmbuild/BUILD/libvirt-8.1.0/src/keycodemapdb/tools/keymap-gen found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/src/keycodemapdb/tools/keymap-gen)
Program genprotocol.pl found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/src/rpc/genprotocol.pl)
Program gendispatch.pl found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/src/rpc/gendispatch.pl)
Configuring libvirtd.conf.tmp with command
Configuring libvirtd.aug.tmp with command
Configuring test_libvirtd.aug.tmp with command
Configuring virtd.conf.tmp with command
Configuring virtd.aug.tmp with command
Configuring test_virtd.aug.tmp with command
Configuring libvirtd.qemu.logrotate using configuration
Configuring libvirtd.lxc.logrotate using configuration
Configuring libvirtd.libxl.logrotate using configuration
Configuring libvirtd.logrotate using configuration
Program /root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-python.sh found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-python.sh)
Program env found: YES (/usr/bin/env)
Program env found: YES (/usr/bin/env)
Configuring libvirtd.conf using configuration
Configuring libvirtd.aug using configuration
Configuring test_libvirtd.aug.tmp using configuration
Configuring virtproxyd.conf using configuration
Configuring virtproxyd.aug using configuration
Configuring test_virtproxyd.aug.tmp using configuration
Configuring virtinterfaced.conf using configuration
Configuring virtinterfaced.aug using configuration
Configuring test_virtinterfaced.aug.tmp using configuration
Configuring virtnetworkd.conf using configuration
Configuring virtnetworkd.aug using configuration
Configuring test_virtnetworkd.aug.tmp using configuration
Configuring virtnodedevd.conf using configuration
Configuring virtnodedevd.aug using configuration
Configuring test_virtnodedevd.aug.tmp using configuration
Configuring virtnwfilterd.conf using configuration
Configuring virtnwfilterd.aug using configuration
Configuring test_virtnwfilterd.aug.tmp using configuration
Configuring virtsecretd.conf using configuration
Configuring virtsecretd.aug using configuration
Configuring test_virtsecretd.aug.tmp using configuration
Configuring virtstoraged.conf using configuration
Configuring virtstoraged.aug using configuration
Configuring test_virtstoraged.aug.tmp using configuration
Configuring virtqemud.conf using configuration
Configuring virtqemud.aug using configuration
Configuring test_virtqemud.aug.tmp using configuration
Configuring libvirtd.service using configuration
Configuring libvirtd.socket using configuration
Configuring libvirtd-ro.socket using configuration
Configuring libvirtd-admin.socket using configuration
Configuring libvirtd-tcp.socket using configuration
Configuring libvirtd-tls.socket using configuration
Configuring virtproxyd.service using configuration
Configuring virtproxyd.socket using configuration
Configuring virtproxyd-ro.socket using configuration
Configuring virtproxyd-admin.socket using configuration
Configuring virtproxyd-tcp.socket using configuration
Configuring virtproxyd-tls.socket using configuration
Configuring virtinterfaced.service using configuration
Configuring virtinterfaced.socket using configuration
Configuring virtinterfaced-ro.socket using configuration
Configuring virtinterfaced-admin.socket using configuration
Configuring virtlockd.service using configuration
Configuring virtlockd.socket using configuration
Configuring virtlockd-admin.socket using configuration
Configuring virtlogd.service using configuration
Configuring virtlogd.socket using configuration
Configuring virtlogd-admin.socket using configuration
Configuring virtnetworkd.service using configuration
Configuring virtnetworkd.socket using configuration
Configuring virtnetworkd-ro.socket using configuration
Configuring virtnetworkd-admin.socket using configuration
Configuring virtnodedevd.service using configuration
Configuring virtnodedevd.socket using configuration
Configuring virtnodedevd-ro.socket using configuration
Configuring virtnodedevd-admin.socket using configuration
Configuring virtnwfilterd.service using configuration
Configuring virtnwfilterd.socket using configuration
Configuring virtnwfilterd-ro.socket using configuration
Configuring virtnwfilterd-admin.socket using configuration
Configuring virtsecretd.service using configuration
Configuring virtsecretd.socket using configuration
Configuring virtsecretd-ro.socket using configuration
Configuring virtsecretd-admin.socket using configuration
Configuring virtstoraged.service using configuration
Configuring virtstoraged.socket using configuration
Configuring virtstoraged-ro.socket using configuration
Configuring virtstoraged-admin.socket using configuration
Configuring virtqemud.service using configuration
Configuring virtqemud.socket using configuration
Configuring virtqemud-ro.socket using configuration
Configuring virtqemud-admin.socket using configuration
Program /root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-python.sh found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-python.sh)
Configuring libvirt-lxc.pc using configuration
Configuring libvirt-qemu.pc using configuration
Configuring libvirt.pc using configuration
Configuring virt-xml-validate using configuration
Configuring virt-pki-validate using configuration
Configuring virt-sanlock-cleanup using configuration
Configuring libvirt-guests.sh using configuration
Configuring libvirt-guests.service using configuration
Configuring virsh using configuration
Configuring virt-admin using configuration
Program util/genxdrstub.pl found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tools/wireshark/util/genxdrstub.pl)
Library tasn1 found: YES
Program libvirtd-fail found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/libvirtd-fail)
Program libvirtd-pool found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/libvirtd-pool)
Program virsh-auth found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/virsh-auth)
Program virsh-checkpoint found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/virsh-checkpoint)
Program virsh-cpuset found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/virsh-cpuset)
Program virsh-define-dev-segfault found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/virsh-define-dev-segfault)
Program virsh-int-overflow found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/virsh-int-overflow)
Program virsh-optparse found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/virsh-optparse)
Program virsh-output found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/virsh-output)
Program virsh-read-bufsiz found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/virsh-read-bufsiz)
Program virsh-read-non-seekable found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/virsh-read-non-seekable)
Program virsh-schedinfo found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/virsh-schedinfo)
Program virsh-self-test found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/virsh-self-test)
Program virsh-snapshot found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/virsh-snapshot)
Program virsh-start found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/virsh-start)
Program virsh-undefine found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/virsh-undefine)
Program virsh-uriprecedence found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/virsh-uriprecedence)
Program virsh-vcpupin found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/virsh-vcpupin)
Program virt-admin-self-test found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/tests/virt-admin-self-test)
Configuring POTFILES using configuration
Program rst2html5 found: YES (/usr/bin/rst2html5)
Program rst2man found: YES (/usr/bin/rst2man)
Configuring index.rst using configuration
Configuring virsh.rst using configuration
Configuring virt-admin.rst using configuration
Configuring virt-host-validate.rst using configuration
Configuring virt-login-shell.rst using configuration
Configuring virt-pki-query-dn.rst using configuration
Configuring virt-pki-validate.rst using configuration
Configuring virt-qemu-run.rst using configuration
Configuring virt-xml-validate.rst using configuration
Configuring libvirt-guests.rst using configuration
Configuring libvirtd.rst using configuration
Configuring virt-sanlock-cleanup.rst using configuration
Configuring virt-ssh-helper.rst using configuration
Configuring virtbhyved.rst using configuration
Configuring virtinterfaced.rst using configuration
Configuring virtlockd.rst using configuration
Configuring virtlogd.rst using configuration
Configuring virtlxcd.rst using configuration
Configuring virtnetworkd.rst using configuration
Configuring virtnodedevd.rst using configuration
Configuring virtnwfilterd.rst using configuration
Configuring virtproxyd.rst using configuration
Configuring virtqemud.rst using configuration
Configuring virtsecretd.rst using configuration
Configuring virtstoraged.rst using configuration
Configuring virtvboxd.rst using configuration
Configuring virtvzd.rst using configuration
Configuring virtxend.rst using configuration
Program make found: YES
Program sed found: YES (/usr/bin/sed)
Program grep found: YES (/usr/bin/grep)
Configuring Makefile using configuration
Configuring libvirt.pc using configuration
Configuring libvirt-qemu.pc using configuration
Configuring libvirt-lxc.pc using configuration
Configuring libvirt-admin.pc using configuration
Configuring libvirt.spec using configuration
Configuring mingw-libvirt.spec using configuration
Configuring AUTHORS.rst using configuration
Program /root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-python.sh found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-python.sh)
Program /root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-python.sh found: YES (/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-python.sh)
Configuring meson-config.h using configuration
Configuring run using configuration
Configuring .color_coded using configuration
Configuring .ycm_extra_conf.py using configuration
Build targets in project: 587

libvirt 8.1.0

  Drivers
    QEMU               : YES
    OpenVZ             : NO
    VMware             : NO
    VBox               : NO
    libxl              : NO
    LXC                : NO
    Cloud-Hypervisor   : NO
    ESX                : YES
    Hyper-V            : NO
    vz                 : NO
    Bhyve              : NO
    Test               : YES
    Remote             : YES
    Network            : YES
    Libvirtd           : YES
    Interface          : YES

  Storage Drivers
    Dir                : YES
    FS                 : YES
    NetFS              : YES
    LVM                : YES
    iSCSI              : YES
    iscsi-direct       : YES
    SCSI               : YES
    mpath              : YES
    Disk               : YES
    RBD                : YES
    Sheepdog           : NO
    Gluster            : YES
    ZFS                : NO
    Virtuozzo storage  : NO

  Security Drivers
    SELinux            : YES
    AppArmor           : NO

  Driver Loadable Modules
    driver_modules     : YES

  Libraries
    acl                : YES
    apparmor           : NO
    attr               : YES
    audit              : YES
    bash_completion    : YES
    blkid              : YES
    capng              : YES
    curl               : YES
    devmapper          : YES
    dlopen             : YES
    fuse               : NO
    glusterfs          : YES
    libiscsi           : YES
    libkvm             : NO
    libnl              : YES
    libparted          : YES
    libpcap            : YES
    libssh             : YES
    libssh2            : NO
    libutil            : YES
    netcf              : YES
    NLS                : YES
    numactl            : YES
    openwsman          : NO
    parallels-sdk      : NO
    pciaccess          : YES
    polkit             : YES
    rbd                : YES
    readline           : YES
    sanlock            : YES
    sasl               : YES
    selinux            : YES
    udev               : YES
    xdr                : YES
    yajl               : YES

  Windows
    MinGW              : NO
    windres            : NO

  Test suite
    Expensive          : YES
    Coverage           : NO

  Miscellaneous
    Warning Flags      : -fasynchronous-unwind-tables -fexceptions -fipa-pure-const -fno-common -Waddress -Waggressive-loop-optimizations -Walloc-size-larger-than=9223372036854775807 -Walloca -Warray-bounds=2 -Wattributes -Wbool-compare -Wbool-operation
                         -Wbuiltin-declaration-mismatch -Wbuiltin-macro-redefined -Wcast-align -Wcast-align=strict -Wno-cast-function-type -Wchar-subscripts -Wclobbered -Wcomment -Wcomments -Wcoverage-mismatch -Wcpp -Wdangling-else -Wdate-time -Wdeclaration-after-statement
                         -Wdeprecated-declarations -Wdesignated-init -Wdiscarded-array-qualifiers -Wdiscarded-qualifiers -Wdiv-by-zero -Wduplicated-cond -Wduplicate-decl-specifier -Wempty-body -Wendif-labels -Wexpansion-to-defined -Wformat-contains-nul -Wformat-extra-args
                         -Wno-format-nonliteral -Wformat-overflow=2 -Wformat-security -Wno-format-truncation -Wformat-y2k -Wformat-zero-length -Wframe-address -Wframe-larger-than=4096 -Wfree-nonheap-object -Whsa -Wif-not-aligned -Wignored-attributes -Wignored-qualifiers
                         -Wimplicit -Wimplicit-fallthrough=5 -Wimplicit-function-declaration -Wimplicit-int -Wincompatible-pointer-types -Winit-self -Winline -Wint-conversion -Wint-in-bool-context -Wint-to-pointer-cast -Winvalid-memory-model -Winvalid-pch -Wjump-misses-init
                         -Wlogical-not-parentheses -Wlogical-op -Wmain -Wmaybe-uninitialized -Wmemset-elt-size -Wmemset-transposed-args -Wmisleading-indentation -Wmissing-attributes -Wmissing-braces -Wmissing-declarations -Wmissing-field-initializers -Wmissing-include-dirs
                         -Wmissing-parameter-type -Wmissing-prototypes -Wmultichar -Wmultistatement-macros -Wnarrowing -Wnested-externs -Wnonnull -Wnonnull-compare -Wnormalized=nfc -Wnull-dereference -Wodr -Wold-style-declaration -Wold-style-definition -Wopenmp-simd -Woverflow
                         -Woverride-init -Wpacked-bitfield-compat -Wpacked-not-aligned -Wparentheses -Wpointer-arith -Wpointer-compare -Wpointer-sign -Wpointer-to-int-cast -Wpragmas -Wpsabi -Wrestrict -Wreturn-local-addr -Wreturn-type -Wscalar-storage-order -Wsequence-point
                         -Wshadow -Wshift-count-negative -Wshift-count-overflow -Wshift-negative-value -Wshift-overflow=2 -Wno-sign-compare -Wsizeof-array-argument -Wsizeof-pointer-div -Wsizeof-pointer-memaccess -Wstrict-aliasing -Wstrict-prototypes -Wstringop-overflow=2
                         -Wstringop-truncation -Wsuggest-attribute=cold -Wno-suggest-attribute=const -Wsuggest-attribute=format -Wsuggest-attribute=noreturn -Wno-suggest-attribute=pure -Wsuggest-final-methods -Wsuggest-final-types -Wswitch -Wswitch-bool -Wswitch-enum
                         -Wswitch-unreachable -Wsync-nand -Wtautological-compare -Wtrampolines -Wtrigraphs -Wtype-limits -Wuninitialized -Wunknown-pragmas -Wunused -Wunused-but-set-parameter -Wunused-but-set-variable -Wunused-const-variable=2 -Wunused-function -Wunused-label
                         -Wunused-local-typedefs -Wunused-parameter -Wunused-result -Wunused-value -Wunused-variable -Wvarargs -Wvariadic-macros -Wvector-operation-performance -Wvla -Wvolatile-register-var -Wwrite-strings -fstack-protector-strong -Wdouble-promotion
    docs               : YES
    tests              : YES
    DTrace             : YES
    firewalld          : YES
    firewalld-zone     : YES
    nss                : YES
    numad              : YES
    Init script        : systemd
    Char device locks  : /var/lock
    Loader/NVRAM       : 
    pm_utils           : NO
    virt-login-shell   : NO
    virt-host-validate : YES
    TLS priority       : @LIBVIRT,SYSTEM

  Developer Tools
    wireshark_dissector: YES

  Privileges
    QEMU               : qemu:qemu

Option buildtype is: plain [default: debugoptimized]
Found ninja-1.8.2 at /usr/bin/ninja
+ /usr/bin/meson compile -C x86_64-redhat-linux-gnu -j 4 --verbose
ninja: Entering directory `x86_64-redhat-linux-gnu'
[1/1234] /usr/bin/env 'CC=ccache cc' /usr/bin/dtrace -o src/libvirt_probes.h -h -s ../src/libvirt_probes.d
[2/1234] /usr/bin/env 'CC=ccache cc' /usr/bin/dtrace -o src/libvirt_probes.o -G -s ../src/libvirt_probes.d
...
[1234/1234] /usr/bin/meson --internal exe --capture docs/manpages/virkeyname-win32.html -- /usr/bin/xsltproc --stringparam pagesrc docs/manpages/virkeyname-win32.rst --stringparam builddir /root/rpmbuild/BUILD/libvirt-8.1.0/x86_64-redhat-linux-gnu --stringparam timestamp 'Fri Aug 12 11:16:01 2022 UTC' --nonet ../docs/subsite.xsl docs/manpages/virkeyname-win32.html.in
+ exit 0
Executing(%install): /bin/sh -e /var/tmp/rpm-tmp.dPN7j4
+ umask 022
+ cd /root/rpmbuild/BUILD
+ '[' /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64 '!=' / ']'
+ rm -rf /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64
++ dirname /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64
+ mkdir -p /root/rpmbuild/BUILDROOT
+ mkdir /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64
+ cd libvirt-8.1.0
+ rm -fr /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64
++ stat --printf=%Y /root/rpmbuild/SPECS/libvirt.spec
+ export SOURCE_DATE_EPOCH=1660302961
+ SOURCE_DATE_EPOCH=1660302961
+ DESTDIR=/root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64
+ /usr/bin/meson install -C x86_64-redhat-linux-gnu --no-rebuild
Installing src/libvirt_probes.stp to /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/systemtap/tapset
Installing src/access/org.libvirt.api.policy to /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/polkit-1/actions
Installing src/qemu/libvirt_qemu_probes.stp to /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/systemtap/tapset
Installing src/libvirt.so.0.8001.0 to /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64
Installing src/libvirt-qemu.so.0.8001.0 to /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64
Installing src/libvirt-lxc.so.0.8001.0 to /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64
Installing src/libvirt-admin.so.0.8001.0 to /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64
Installing src/libvirt_driver_interface.so to /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/connection-driver
Installing src/lockd.so to /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/lock-driver
...
Installing /root/rpmbuild/BUILD/libvirt-8.1.0/docs/schemas/storagevol.rng to /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/libvirt/schemas
Installing /root/rpmbuild/BUILD/libvirt-8.1.0/x86_64-redhat-linux-gnu/libvirt.pc to /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/pkgconfig
Installing /root/rpmbuild/BUILD/libvirt-8.1.0/x86_64-redhat-linux-gnu/libvirt-qemu.pc to /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/pkgconfig
Installing /root/rpmbuild/BUILD/libvirt-8.1.0/x86_64-redhat-linux-gnu/libvirt-lxc.pc to /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/pkgconfig
Installing /root/rpmbuild/BUILD/libvirt-8.1.0/x86_64-redhat-linux-gnu/libvirt-admin.pc to /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/pkgconfig
Running custom install script '/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-python.sh /usr/bin/python3 /root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-install-symlink.py /etc/libvirt/qemu/networks/autostart ../default.xml default.xml'
Running custom install script '/root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-python.sh /usr/bin/python3 /root/rpmbuild/BUILD/libvirt-8.1.0/scripts/meson-install-dirs.py /etc/libvirt /var/log/libvirt /run/libvirt /run/libvirt/common /run/libvirt/interface /var/lib/libvirt/lockd /var/lib/libvirt/lockd/files /run/libvirt/lockd /var/lib/libvirt/sanlock /etc/libvirt/qemu/networks /etc/libvirt/qemu/networks/autostart /var/lib/libvirt/network /var/lib/libvirt/dnsmasq /run/libvirt/network /run/libvirt/nodedev /etc/libvirt/nwfilter /run/libvirt/nwfilter-binding /run/libvirt/nwfilter /etc/libvirt/secrets /run/libvirt/secrets /etc/libvirt/storage /etc/libvirt/storage/autostart /run/libvirt/storage /etc/libvirt/qemu /etc/libvirt/qemu/autostart /var/cache/libvirt/qemu /var/lib/libvirt/qemu /var/lib/libvirt/qemu/channel /var/lib/libvirt/qemu/channel/target /var/lib/libvirt/qemu/checkpoint /var/lib/libvirt/qemu/dump /var/lib/libvirt/qemu/nvram /var/lib/libvirt/qemu/ram /var/lib/libvirt/qemu/save /var/lib/libvirt/qemu/snapshot /var/lib/libvirt/swtpm /var/log/libvirt/qemu /var/log/swtpm/libvirt/qemu /run/libvirt/qemu /run/libvirt/qemu/dbus /run/libvirt/qemu/slirp /run/libvirt/qemu/swtpm /var/cache/libvirt /var/lib/libvirt/images /var/lib/libvirt/filesystems /var/lib/libvirt/boot'
Running custom install script '/usr/bin/meson --internal gettext install --subdir=po --localedir=share/locale --pkgname=libvirt'
+ install -d -m 0755 /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/libvirt/networks/
+ cp /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/qemu/networks/default.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/libvirt/networks/default.xml
+ chmod 0600 /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/qemu/networks/default.xml
+ install -d -m 0755 /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/libvirt/nwfilter/
+ cp -a /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-arp.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-dhcp-server.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-dhcp.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-dhcpv6-server.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-dhcpv6.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-incoming-ipv4.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-incoming-ipv6.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-ipv4.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-ipv6.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/clean-traffic-gateway.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/clean-traffic.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-arp-ip-spoofing.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-arp-mac-spoofing.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-arp-spoofing.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-ip-multicast.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-ip-spoofing.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-ipv6-multicast.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-ipv6-spoofing.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-mac-broadcast.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-mac-spoofing.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-other-l2-traffic.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-other-rarp-traffic.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/qemu-announce-self-rarp.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/qemu-announce-self.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/libvirt/nwfilter/
+ chmod 600 /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-arp.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-dhcp-server.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-dhcp.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-dhcpv6-server.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-dhcpv6.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-incoming-ipv4.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-incoming-ipv6.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-ipv4.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/allow-ipv6.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/clean-traffic-gateway.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/clean-traffic.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-arp-ip-spoofing.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-arp-mac-spoofing.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-arp-spoofing.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-ip-multicast.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-ip-spoofing.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-ipv6-multicast.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-ipv6-spoofing.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-mac-broadcast.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-mac-spoofing.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-other-l2-traffic.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/no-other-rarp-traffic.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/qemu-announce-self-rarp.xml /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/nwfilter/qemu-announce-self.xml
+ /usr/lib/rpm/find-lang.sh /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64 libvirt
+ rm -f /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/augeas/lenses/libvirtd_lxc.aug
+ rm -f /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/augeas/lenses/tests/test_libvirtd_lxc.aug
+ rm -rf /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/lxc.conf
+ rm -rf /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/logrotate.d/libvirtd.lxc
+ rm -rf /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/libvirt/libxl.conf
+ rm -rf /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/etc/logrotate.d/libvirtd.libxl
+ rm -f /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/augeas/lenses/libvirtd_libxl.aug
+ rm -f /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/augeas/lenses/tests/test_libvirtd_libxl.aug
+ mv /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/doc/libvirt libvirt-docs
+ mv /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/systemtap/tapset/libvirt_probes.stp /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/systemtap/tapset/libvirt_probes-64.stp
+ mv /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/systemtap/tapset/libvirt_qemu_probes.stp /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/systemtap/tapset/libvirt_qemu_probes-64.stp
+ /usr/lib/rpm/find-debuginfo.sh -j4 --strict-build-id -m -i --build-id-seed 8.1.0-1.el8 --unique-debug-suffix -8.1.0-1.el8.x86_64 --unique-debug-src-base libvirt-8.1.0-1.el8.x86_64 --run-dwz --dwz-low-mem-die-limit 10000000 --dwz-max-die-limit 110000000 -S debugsourcefiles.list /root/rpmbuild/BUILD/libvirt-8.1.0
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/bin/virsh
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/bin/virt-admin
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/bin/virt-pki-query-dn
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/bin/virt-host-validate
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/bin/virt-qemu-run
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/bin/virt-ssh-helper
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libnss_libvirt.so.2
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libnss_libvirt_guest.so.2
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt-admin.so.0.8001.0
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt-lxc.so.0.8001.0
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt-qemu.so.0.8001.0
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt.so.0.8001.0
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/connection-driver/libvirt_driver_network.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/connection-driver/libvirt_driver_nodedev.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/connection-driver/libvirt_driver_interface.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/connection-driver/libvirt_driver_nwfilter.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/connection-driver/libvirt_driver_qemu.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/connection-driver/libvirt_driver_secret.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/connection-driver/libvirt_driver_storage.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/lock-driver/lockd.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/lock-driver/sanlock.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/storage-backend/libvirt_storage_backend_disk.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/storage-backend/libvirt_storage_backend_fs.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/storage-backend/libvirt_storage_backend_gluster.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/storage-backend/libvirt_storage_backend_iscsi-direct.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/storage-backend/libvirt_storage_backend_iscsi.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/storage-backend/libvirt_storage_backend_logical.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/storage-backend/libvirt_storage_backend_mpath.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/storage-backend/libvirt_storage_backend_rbd.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/storage-backend/libvirt_storage_backend_scsi.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/storage-file/libvirt_storage_file_fs.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/libvirt/storage-file/libvirt_storage_file_gluster.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/lib64/wireshark/plugins/2.6/epan/libvirt.so
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/libexec/libvirt_iohelper
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/libexec/libvirt_leaseshelper
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/libexec/libvirt_parthelper
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/libexec/libvirt_sanlock_helper
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/sbin/libvirtd
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/sbin/virtinterfaced
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/sbin/virtlockd
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/sbin/virtlogd
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/sbin/virtnetworkd
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/sbin/virtnodedevd
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/sbin/virtnwfilterd
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/sbin/virtproxyd
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/sbin/virtqemud
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/sbin/virtsecretd
extracting debug info from /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/sbin/virtstoraged
/usr/lib/rpm/sepdebugcrcfix: Updated 48 CRC32s, 0 CRC32s did match.
cpio: x86_64-redhat-linux-gnu/.dtrace-temp.368fef4a.c: Cannot stat: No such file or directory
cpio: x86_64-redhat-linux-gnu/.dtrace-temp.f9ece864.c: Cannot stat: No such file or directory
42358 blocks
+ /usr/lib/rpm/check-buildroot
+ /usr/lib/rpm/redhat/brp-ldconfig
/sbin/ldconfig: Warning: ignoring configuration file that cannot be opened: /etc/ld.so.conf: No such file or directory
+ /usr/lib/rpm/brp-compress
+ /usr/lib/rpm/brp-strip-static-archive /usr/bin/strip
+ /usr/lib/rpm/brp-python-bytecompile '' 1
+ /usr/lib/rpm/brp-python-hardlink
+ PYTHON3=/usr/libexec/platform-python
+ /usr/lib/rpm/redhat/brp-mangle-shebangs
Executing(%check): /bin/sh -e /var/tmp/rpm-tmp.IplE8d
+ umask 022
+ cd /root/rpmbuild/BUILD
+ cd libvirt-8.1.0
+ VIR_TEST_DEBUG=1
+ /usr/bin/meson test -C x86_64-redhat-linux-gnu --num-processes 4 --print-errorlogs --no-suite syntax-check --timeout-multiplier 10
ninja: Entering directory `/root/rpmbuild/BUILD/libvirt-8.1.0/x86_64-redhat-linux-gnu'
ninja: no work to do.
  1/165 libvirt / check-aclperms                           OK               0.02s
  2/165 libvirt / check-admin-symfile                      OK               0.04s
  3/165 libvirt / check-symsorting                         OK               0.04s
  4/165 libvirt / check-admin-symsorting                   OK               0.03s
  5/165 libvirt / check-admin-drivername                   OK               0.04s
  6/165 libvirt / check-drivername                         OK               0.05s
  7/165 libvirt / check-augeas-libvirt_lockd               OK               0.02s
  8/165 libvirt / check-symfile                            OK               0.16s
  9/165 libvirt / check-augeas-libvirt_sanlock             OK               0.06s
 10/165 libvirt / check-augeas-virtlockd                   OK               0.02s
 11/165 libvirt / check-augeas-virtlogd                    OK               0.02s
 12/165 libvirt / check-augeas-libvirtd                    OK               0.08s
 13/165 libvirt / check-driverimpls                        OK               0.25s
 14/165 libvirt / check-aclrules                           OK               0.24s
 15/165 libvirt / check-augeas-virtproxyd                  OK               0.08s
 16/165 libvirt / check-augeas-virtinterfaced              OK               0.05s
 17/165 libvirt / check-augeas-libvirtd_qemu               OK               0.20s
 18/165 libvirt / check-augeas-virtnetworkd                OK               0.06s
 19/165 libvirt / check-augeas-virtnodedevd                OK               0.06s
 20/165 libvirt / check-augeas-virtnwfilterd               OK               0.06s
 21/165 libvirt / check-augeas-virtsecretd                 OK               0.05s
 22/165 libvirt / check-augeas-virtstoraged                OK               0.07s
 23/165 libvirt / check-virnetprotocol                     OK               0.06s
 24/165 libvirt / check-augeas-virtqemud                   OK               0.08s
 25/165 libvirt / check-virkeepaliveprotocol               OK               0.07s
 26/165 libvirt / check-qemu_protocol                      OK               0.05s
 27/165 libvirt / check-lxc_protocol                       OK               0.05s
 28/165 libvirt / check-admin_protocol                     OK               0.05s
 29/165 libvirt / check-remote_protocol                    OK               0.12s
 30/165 libvirt / check-lock_protocol                      OK               0.05s
 31/165 libvirt / domainconftest                           OK               0.02s
 32/165 libvirt / genericxml2xmltest                       OK               0.10s
 33/165 libvirt / interfacexml2xmltest                     OK               0.02s
 34/165 libvirt / metadatatest                             OK               0.02s
 35/165 libvirt / networkxml2xmlupdatetest                 OK               0.03s
 36/165 libvirt / nodedevxml2xmltest                       OK               0.03s
 37/165 libvirt / nwfilterxml2xmltest                      OK               0.04s
 38/165 libvirt / objecteventtest                          OK               0.03s
 39/165 libvirt / seclabeltest                             OK               0.02s
 40/165 libvirt / secretxml2xmltest                        OK               0.02s
 41/165 libvirt / shunloadtest                             OK               0.03s
 42/165 libvirt / sockettest                               OK               0.02s
 43/165 libvirt / storagevolxml2xmltest                    OK               0.03s
 44/165 libvirt / sysinfotest                              OK               0.02s
 45/165 libvirt / utiltest                                 OK               0.04s
 46/165 libvirt / viralloctest                             OK               0.02s
 47/165 libvirt / virauthconfigtest                        OK               0.02s
 48/165 libvirt / virbitmaptest                            OK               0.01s
 49/165 libvirt / domaincapstest                           OK               0.58s
 50/165 libvirt / virbuftest                               OK               0.02s
 51/165 libvirt / vircapstest                              OK               0.03s
 52/165 libvirt / virconftest                              OK               0.12s
 53/165 libvirt / vircryptotest                            OK               0.03s
 54/165 libvirt / virendiantest                            OK               0.02s
 55/165 libvirt / vircgrouptest                            OK               0.21s
 56/165 libvirt / virerrortest                             OK               0.09s
 57/165 libvirt / virfilecachetest                         OK               0.11s
 58/165 libvirt / virfirewalltest                          OK               0.04s
 59/165 libvirt / virfiletest                              OK               0.11s
 60/165 libvirt / virhostcputest                           OK               0.06s
 61/165 libvirt / viridentitytest                          OK               0.04s
 62/165 libvirt / viriscsitest                             OK               0.04s
 63/165 libvirt / virkeycodetest                           OK               0.02s
 64/165 libvirt / virkmodtest                              OK               0.02s
 65/165 libvirt / virlockspacetest                         OK               0.02s
 66/165 libvirt / virhostdevtest                           OK               0.18s
 67/165 libvirt / virlogtest                               OK               0.03s
 68/165 libvirt / virnetdevtest                            OK               0.03s
 69/165 libvirt / virnetworkportxml2xmltest                OK               0.02s
 70/165 libvirt / virnwfilterbindingxml2xmltest            OK               0.02s
 71/165 libvirt / virportallocatortest                     OK               0.03s
 72/165 libvirt / virpcitest                               OK               0.06s
 73/165 libvirt / virrotatingfiletest                      OK               0.02s
 74/165 libvirt / cputest                                  OK               1.49s
 75/165 libvirt / virstringtest                            OK               0.02s
 76/165 libvirt / virsystemdtest                           OK               0.32s
 77/165 libvirt / virtimetest                              OK               0.02s
 78/165 libvirt / virtypedparamtest                        OK               0.02s
 79/165 libvirt / viruritest                               OK               0.02s
 80/165 libvirt / virpcivpdtest                            OK               0.03s
 81/165 libvirt / vshtabletest                             OK               0.01s
 82/165 libvirt / virmigtest                               OK               0.02s
 83/165 libvirt / fchosttest                               OK               0.04s
 84/165 libvirt / scsihosttest                             OK               0.03s
 85/165 libvirt / vircaps2xmltest                          OK               0.08s
 86/165 libvirt / virnetdevbandwidthtest                   OK               0.04s
 87/165 libvirt / virprocessstattest                       OK               0.02s
 88/165 libvirt / virresctrltest                           OK               0.02s
 89/165 libvirt / virscsitest                              OK               0.02s
 90/165 libvirt / virusbtest                               OK               0.04s
 91/165 libvirt / virnetdevopenvswitchtest                 OK               0.04s
 92/165 libvirt / esxutilstest                             OK               0.03s
 93/165 libvirt / eventtest                                OK               0.44s
 94/165 libvirt / commandtest                              OK               2.80s
 95/165 libvirt / fdstreamtest                             OK               0.04s
 96/165 libvirt / virdriverconnvalidatetest                OK               0.02s
 97/165 libvirt / networkxml2conftest                      OK               0.04s
 98/165 libvirt / virdrivermoduletest                      OK               0.07s
 99/165 libvirt / networkxml2xmltest                       OK               0.02s
100/165 libvirt / networkxml2firewalltest                  OK               0.06s
101/165 libvirt / nodedevmdevctltest                       OK               0.02s
102/165 libvirt / nsstest                                  OK               0.04s
103/165 libvirt / nssguesttest                             OK               0.03s
104/165 libvirt / nwfilterebiptablestest                   OK               0.04s
105/165 libvirt / nwfilterxml2firewalltest                 OK               0.05s
106/165 libvirt / virshtest                                OK               1.72s
107/165 libvirt / virpolkittest                            OK               0.04s
108/165 libvirt / qemublocktest                            OK               0.12s
109/165 libvirt / virschematest                            OK               2.07s
110/165 libvirt / qemucaps2xmltest                         OK               0.10s
111/165 libvirt / qemucommandutiltest                      OK               0.02s
112/165 libvirt / qemudomaincheckpointxml2xmltest          OK               0.16s
113/165 libvirt / qemudomainsnapshotxml2xmltest            OK               0.02s
114/165 libvirt / qemufirmwaretest                         OK               0.02s
115/165 libvirt / qemuhotplugtest                          OK               0.34s
116/165 libvirt / qemumemlocktest                          OK               0.06s
117/165 libvirt / qemucapabilitiesnumbering                OK               0.99s
118/165 libvirt / qemumigparamstest                        OK               0.06s
119/165 libvirt / qemumigrationcookiexmltest               OK               0.05s
120/165 libvirt / qemumonitorjsontest                      OK               0.32s
121/165 libvirt / qemustatusxml2xmltest                    OK               0.04s
122/165 libvirt / qemuvhostusertest                        OK               0.02s
123/165 libvirt / qemucapabilitiestest                     OK               1.56s
124/165 libvirt / qemusecuritytest                         OK               0.61s
125/165 libvirt / virnetdaemontest                         OK               0.04s
126/165 libvirt / virnetmessagetest                        OK               0.02s
127/165 libvirt / virnetserverclienttest                   OK               0.03s
128/165 libvirt / virnetsockettest                         OK               0.13s
129/165 libvirt / qemuxml2xmltest                          OK               0.71s
130/165 libvirt / virnettlscontexttest                     OK               0.61s
131/165 libvirt / securityselinuxtest                      OK               0.02s
132/165 libvirt / securityselinuxlabeltest                 OK               0.03s
133/165 libvirt / storagepoolcapstest                      OK               0.02s
134/165 libvirt / virnettlssessiontest                     OK               0.41s
135/165 libvirt / storagepoolxml2argvtest                  OK               0.06s
136/165 libvirt / storagepoolxml2xmltest                   OK               0.07s
137/165 libvirt / storagevolxml2argvtest                   OK               0.02s
138/165 libvirt / virstorageutiltest                       OK               0.02s
139/165 libvirt / vmx2xmltest                              OK               0.04s
140/165 libvirt / xml2vmxtest                              OK               0.03s
141/165 libvirt / virjsontest                              OK               0.02s
142/165 libvirt / virstoragetest                           OK               0.10s
143/165 libvirt / virmacmaptest                            OK               0.02s
144/165 libvirt / libvirtd-fail                            OK               0.04s
145/165 libvirt / libvirtd-pool                            OK               0.04s
146/165 libvirt / virsh-auth                               OK               0.06s
147/165 libvirt / virsh-cpuset                             OK               0.06s
148/165 libvirt / virsh-define-dev-segfault                OK               0.05s
149/165 libvirt / virsh-int-overflow                       OK               0.04s
150/165 libvirt / virsh-checkpoint                         OK               0.29s
151/165 libvirt / qemuxml2argvtest                         OK               2.20s
152/165 libvirt / virsh-read-bufsiz                        OK               0.09s
153/165 libvirt / virsh-read-non-seekable                  OK               0.06s
154/165 libvirt / virsh-schedinfo                          OK               0.04s
155/165 libvirt / virsh-self-test                          OK               0.04s
156/165 libvirt / virsh-snapshot                           OK               0.16s
157/165 libvirt / virsh-start                              OK               0.04s
158/165 libvirt / virsh-undefine                           OK               0.09s
159/165 libvirt / virsh-uriprecedence                      OK               0.14s
160/165 libvirt / virsh-output                             OK               1.19s
161/165 libvirt / virt-admin-self-test                     OK               0.04s
162/165 libvirt / check-html                               OK               0.04s
163/165 libvirt / virsh-vcpupin                            OK               0.32s
164/165 libvirt / virsh-optparse                           OK               1.89s
165/165 libvirt / qemuagenttest                            OK               6.06s


Ok:                 165 
Expected Fail:      0   
Fail:               0   
Unexpected Pass:    0   
Skipped:            0   
Timeout:            0   

Full log written to /root/rpmbuild/BUILD/libvirt-8.1.0/x86_64-redhat-linux-gnu/meson-logs/testlog.txt
+ exit 0
Processing files: libvirt-8.1.0-1.el8.x86_64
Processing files: libvirt-docs-8.1.0-1.el8.x86_64
Executing(%doc): /bin/sh -e /var/tmp/rpm-tmp.1QPzXw
+ umask 022
+ cd /root/rpmbuild/BUILD
+ cd libvirt-8.1.0
+ DOCDIR=/root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/doc/libvirt-docs
+ export LC_ALL=C
+ LC_ALL=C
+ export DOCDIR
+ /usr/bin/mkdir -p /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/doc/libvirt-docs
+ cp -pr AUTHORS.rst /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/doc/libvirt-docs
+ cp -pr NEWS.rst /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/doc/libvirt-docs
+ cp -pr README.rst /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/doc/libvirt-docs
+ cp -pr libvirt-docs/examples libvirt-docs/html /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64/usr/share/doc/libvirt-docs
+ exit 0
...
Requires(rpmlib): rpmlib(CompressedFileNames) <= 3.0.4-1 rpmlib(FileDigests) <= 4.6.0-1 rpmlib(PayloadFilesHavePrefix) <= 4.0-1
Recommends: libvirt-debugsource(x86-64) = 8.1.0-1.el8
Processing files: libvirt-wireshark-debuginfo-8.1.0-1.el8.x86_64
Provides: debuginfo(build-id) = c6481c7636207d36ec1ee0630f974b770e69c27e libvirt-wireshark-debuginfo = 8.1.0-1.el8 libvirt-wireshark-debuginfo(x86-64) = 8.1.0-1.el8
Requires(rpmlib): rpmlib(CompressedFileNames) <= 3.0.4-1 rpmlib(FileDigests) <= 4.6.0-1 rpmlib(PayloadFilesHavePrefix) <= 4.0-1
Recommends: libvirt-debugsource(x86-64) = 8.1.0-1.el8
Processing files: libvirt-lock-sanlock-debuginfo-8.1.0-1.el8.x86_64
Provides: debuginfo(build-id) = 3c3e4e12e51db4bb6bcdbc6ff7e4c739faf4870d debuginfo(build-id) = bd0cd6110995053ab2f5eeb63d89eb2fe8fb89b2 libvirt-lock-sanlock-debuginfo = 8.1.0-1.el8 libvirt-lock-sanlock-debuginfo(x86-64) = 8.1.0-1.el8
Requires(rpmlib): rpmlib(CompressedFileNames) <= 3.0.4-1 rpmlib(FileDigests) <= 4.6.0-1 rpmlib(PayloadFilesHavePrefix) <= 4.0-1
Recommends: libvirt-debugsource(x86-64) = 8.1.0-1.el8
Processing files: libvirt-nss-debuginfo-8.1.0-1.el8.x86_64
Provides: debuginfo(build-id) = 15ff5bb2a8d5f9376c31c9a36e98690d80408246 debuginfo(build-id) = 6029248a25866adaf97d8d15c7d86e0db9e442d0 libvirt-nss-debuginfo = 8.1.0-1.el8 libvirt-nss-debuginfo(x86-64) = 8.1.0-1.el8
Requires(rpmlib): rpmlib(CompressedFileNames) <= 3.0.4-1 rpmlib(FileDigests) <= 4.6.0-1 rpmlib(PayloadFilesHavePrefix) <= 4.0-1
Recommends: libvirt-debugsource(x86-64) = 8.1.0-1.el8
Checking for unpackaged file(s): /usr/lib/rpm/check-files /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64
Wrote: /root/rpmbuild/SRPMS/libvirt-8.1.0-1.el8.src.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-docs-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-config-network-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-config-nwfilter-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-network-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-nwfilter-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-nodedev-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-interface-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-secret-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-core-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-logical-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-disk-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-scsi-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-iscsi-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-iscsi-direct-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-mpath-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-gluster-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-rbd-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-qemu-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-kvm-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-client-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-libs-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-wireshark-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-devel-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-lock-sanlock-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-nss-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-debugsource-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-network-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-nwfilter-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-nodedev-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-interface-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-secret-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-core-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-logical-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-disk-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-scsi-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-iscsi-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-iscsi-direct-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-mpath-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-gluster-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-rbd-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-qemu-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-client-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-libs-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-wireshark-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-lock-sanlock-debuginfo-8.1.0-1.el8.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/libvirt-nss-debuginfo-8.1.0-1.el8.x86_64.rpm
Executing(%clean): /bin/sh -e /var/tmp/rpm-tmp.Qo2aYM
+ umask 022
+ cd /root/rpmbuild/BUILD
+ cd libvirt-8.1.0
+ /usr/bin/rm -rf /root/rpmbuild/BUILDROOT/libvirt-8.1.0-1.el8.x86_64
+ exit 0
```

```bash
[root@c63843475281 libvirt-src]# createrepo -v  /root/rpmbuild/RPMS/x86_64
11:22:37: Version: 0.17.7 (Features: DeltaRPM LegacyWeakdeps )
11:22:37: Signal handler setup
11:22:37: Thread pool ready
Directory walk started
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-docs-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-config-network-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-config-nwfilter-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-network-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-nwfilter-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-nodedev-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-interface-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-secret-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-core-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-logical-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-disk-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-scsi-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-iscsi-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-iscsi-direct-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-mpath-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-gluster-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-rbd-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-qemu-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-kvm-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-client-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-libs-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-wireshark-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-devel-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-lock-sanlock-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-nss-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-debugsource-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-network-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-nwfilter-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-nodedev-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-interface-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-secret-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-core-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-logical-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-disk-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-scsi-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-iscsi-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-iscsi-direct-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-mpath-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-gluster-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-storage-rbd-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-daemon-driver-qemu-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-client-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-libs-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-wireshark-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-lock-sanlock-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Adding pkg: /root/rpmbuild/RPMS/x86_64/libvirt-nss-debuginfo-8.1.0-1.el8.x86_64.rpm
11:22:37: Dir to scan: /root/rpmbuild/RPMS/x86_64/.repodata
11:22:37: Package count: 51
Directory walk done - 51 packages
Temporary output repo path: /root/rpmbuild/RPMS/x86_64/.repodata/
11:22:37: Creating .xml.gz files
11:22:37: Setting number of packages
Preparing sqlite DBs
11:22:37: Creating databases
11:22:37: Thread pool user data ready
Pool started (with 5 workers)
Pool finished
11:22:37: Generating repomd.xml
11:22:37: Old repodata doesn't exists: Cannot rename /root/rpmbuild/RPMS/x86_64/repodata/ -> /root/rpmbuild/RPMS/x86_64/repodata.old.24731.20220812112237.740945: No such file or directory
11:22:37: Renamed /root/rpmbuild/RPMS/x86_64/.repodata/ -> /root/rpmbuild/RPMS/x86_64/repodata/
11:22:37: Memory cleanup
11:22:37: All done
[root@c63843475281 libvirt-src]# ls /root/rpmbuild/RPMS/x86_64
libvirt-8.1.0-1.el8.x86_64.rpm                                    libvirt-daemon-driver-nwfilter-8.1.0-1.el8.x86_64.rpm                   libvirt-daemon-driver-storage-iscsi-8.1.0-1.el8.x86_64.rpm                   libvirt-debuginfo-8.1.0-1.el8.x86_64.rpm
libvirt-client-8.1.0-1.el8.x86_64.rpm                             libvirt-daemon-driver-nwfilter-debuginfo-8.1.0-1.el8.x86_64.rpm         libvirt-daemon-driver-storage-iscsi-debuginfo-8.1.0-1.el8.x86_64.rpm         libvirt-debugsource-8.1.0-1.el8.x86_64.rpm
libvirt-client-debuginfo-8.1.0-1.el8.x86_64.rpm                   libvirt-daemon-driver-qemu-8.1.0-1.el8.x86_64.rpm                       libvirt-daemon-driver-storage-iscsi-direct-8.1.0-1.el8.x86_64.rpm            libvirt-devel-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-8.1.0-1.el8.x86_64.rpm                             libvirt-daemon-driver-qemu-debuginfo-8.1.0-1.el8.x86_64.rpm             libvirt-daemon-driver-storage-iscsi-direct-debuginfo-8.1.0-1.el8.x86_64.rpm  libvirt-docs-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-config-network-8.1.0-1.el8.x86_64.rpm              libvirt-daemon-driver-secret-8.1.0-1.el8.x86_64.rpm                     libvirt-daemon-driver-storage-logical-8.1.0-1.el8.x86_64.rpm                 libvirt-libs-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-config-nwfilter-8.1.0-1.el8.x86_64.rpm             libvirt-daemon-driver-secret-debuginfo-8.1.0-1.el8.x86_64.rpm           libvirt-daemon-driver-storage-logical-debuginfo-8.1.0-1.el8.x86_64.rpm       libvirt-libs-debuginfo-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-debuginfo-8.1.0-1.el8.x86_64.rpm                   libvirt-daemon-driver-storage-8.1.0-1.el8.x86_64.rpm                    libvirt-daemon-driver-storage-mpath-8.1.0-1.el8.x86_64.rpm                   libvirt-lock-sanlock-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-driver-interface-8.1.0-1.el8.x86_64.rpm            libvirt-daemon-driver-storage-core-8.1.0-1.el8.x86_64.rpm               libvirt-daemon-driver-storage-mpath-debuginfo-8.1.0-1.el8.x86_64.rpm         libvirt-lock-sanlock-debuginfo-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-driver-interface-debuginfo-8.1.0-1.el8.x86_64.rpm  libvirt-daemon-driver-storage-core-debuginfo-8.1.0-1.el8.x86_64.rpm     libvirt-daemon-driver-storage-rbd-8.1.0-1.el8.x86_64.rpm                     libvirt-nss-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-driver-network-8.1.0-1.el8.x86_64.rpm              libvirt-daemon-driver-storage-disk-8.1.0-1.el8.x86_64.rpm               libvirt-daemon-driver-storage-rbd-debuginfo-8.1.0-1.el8.x86_64.rpm           libvirt-nss-debuginfo-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-driver-network-debuginfo-8.1.0-1.el8.x86_64.rpm    libvirt-daemon-driver-storage-disk-debuginfo-8.1.0-1.el8.x86_64.rpm     libvirt-daemon-driver-storage-scsi-8.1.0-1.el8.x86_64.rpm                    libvirt-wireshark-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-driver-nodedev-8.1.0-1.el8.x86_64.rpm              libvirt-daemon-driver-storage-gluster-8.1.0-1.el8.x86_64.rpm            libvirt-daemon-driver-storage-scsi-debuginfo-8.1.0-1.el8.x86_64.rpm          libvirt-wireshark-debuginfo-8.1.0-1.el8.x86_64.rpm
libvirt-daemon-driver-nodedev-debuginfo-8.1.0-1.el8.x86_64.rpm    libvirt-daemon-driver-storage-gluster-debuginfo-8.1.0-1.el8.x86_64.rpm  libvirt-daemon-kvm-8.1.0-1.el8.x86_64.rpm                                    repodata
```


# 举例：KubeVirt替换libvirt的版本

创建rpm/custom-repo.yaml 文件，并执行make rpm-deps

```bash
[root@kubevirtci kubevirt]# cat rpm/custom-repo.yaml 
repositories:
- arch: x86_64
  baseurl: http://10.88.0.140:80/x86_64/ # The IP corrisponds to the rpms-http-server container
  name: custom-build
  gpgcheck: 0
  repo_gpgcheck: 0
  disabled: true
[root@kubevirtci kubevirt]# make CUSTOM_REPO=rpm/custom-repo.yaml LIBVIRT_VERSION=0:8.1.0-1.el8 SINGLE_ARCH="x86_64" rpm-deps
```

BUILD文件的libvirt相关的部分会被自动替换成所需的libvirt版本

```bash
        "@libvirt-client-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-qemu-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-libs-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-daemon-driver-qemu-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-libs-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-devel-0__8.1.0-1.el8.x86_64//rpm",
        "@libvirt-libs-0__8.1.0-1.el8.x86_64//rpm",
```

WORKSPACE文件libvirt相关的部分会被自动替换成所需的libvirt版本

```bash
rpm(
    name = "libvirt-client-0__8.1.0-1.el8.x86_64",
    sha256 = "28f9580e9869a57e5319e9eb686baf6ee0c8b78f060ca141b7b44fa63416810b",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-client-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-0__7.10.0-1.module_el8.6.0__plus__1046__plus__bd8eec5e.aarch64",
    sha256 = "28f67832b4a5192ebcc6c4dde1020629d7c29cb8e572f18f96520bcc6341cf9e",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/libvirt-daemon-7.10.0-1.module_el8.6.0+1046+bd8eec5e.aarch64.rpm"],
)

rpm(
    name = "libvirt-daemon-0__8.1.0-1.el8.x86_64",
    sha256 = "f3e045a9e5569028c17c6a3a337352e3dfdc6c6e458d1b59626f0e6d7c35a6bf",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-qemu-0__7.10.0-1.module_el8.6.0__plus__1046__plus__bd8eec5e.aarch64",
    sha256 = "68bf0a1e9cd263d0d71ac74a06d263ce3e961ad04df345ac58e87566e521c553",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/libvirt-daemon-driver-qemu-7.10.0-1.module_el8.6.0+1046+bd8eec5e.aarch64.rpm"],
)

rpm(
    name = "libvirt-daemon-driver-qemu-0__8.1.0-1.el8.x86_64",
    sha256 = "920f9b9cf2f5796557ccb9750edafb7b771b96507bce07ea643ec272f46245ec",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-daemon-driver-qemu-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-devel-0__7.10.0-1.module_el8.6.0__plus__1046__plus__bd8eec5e.aarch64",
    sha256 = "07f8a02c8de60700f95073f256ff7da55c3f041251140c14832ce5fe92df3fb1",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/libvirt-devel-7.10.0-1.module_el8.6.0+1046+bd8eec5e.aarch64.rpm"],
)

rpm(
    name = "libvirt-devel-0__8.1.0-1.el8.x86_64",
    sha256 = "6e6dc61acb4dabd93e7ef20103d4820447e7e8d055909ae8f4c625e91dcf56af",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-devel-8.1.0-1.el8.x86_64.rpm"],
)

rpm(
    name = "libvirt-libs-0__7.10.0-1.module_el8.6.0__plus__1046__plus__bd8eec5e.aarch64",
    sha256 = "ed9803fbaccc81266aa990aab0f1a4bf96b520700226991f6e1fe69e0724e14d",
    urls = ["http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/libvirt-libs-7.10.0-1.module_el8.6.0+1046+bd8eec5e.aarch64.rpm"],
)

rpm(
    name = "libvirt-libs-0__8.1.0-1.el8.x86_64",
    sha256 = "f60506097b2332ede702a948d3050c4c2b606daa7b0c2bcec088a4da11c62ac8",
    urls = ["http://10.88.0.140:80/x86_64/libvirt-libs-8.1.0-1.el8.x86_64.rpm"],
)
```

```bash

```


# bazeldnf

```bash
[root@kubevirtci bazeldnf]# git clone https://github.com/rmohr/bazeldnf
[root@kubevirtci bazeldnf]# cd bazeldnf
[root@kubevirtci bazeldnf]# cat rpm/repo.yaml 
repositories:
- arch: x86_64
  baseurl: http://10.88.0.140:80/x86_64/
  name: centos/custom-build
- arch: x86_64
  baseurl: http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/
  name: centos/stream8-baseos-x86_64
  gpgkey: https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
- arch: x86_64
  baseurl: http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/
  name: centos/stream8-appstream-x86_64
  gpgkey: https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
- arch: x86_64
  baseurl: http://mirror.centos.org/centos/8-stream/PowerTools/x86_64/os/
  name: centos/stream8-powertools-x86_64
  gpgkey: https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
[root@kubevirtci bazeldnf]# touch rpm/BUILD.bazel
```

```bash
[root@kubevirtci bazeldnf]# bazelisk run //:bazeldnf -- fetch --repofile rpm/repo.yaml
INFO: Analyzed target //:bazeldnf (4 packages loaded, 196 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 1.174s, Critical Path: 0.01s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO[0000] Resolving repomd.xml from http://10.88.0.140:80/x86_64/repodata/repomd.xml 
INFO[0000] Loading primary file from http://10.88.0.140:80/x86_64/repodata/b32ad07ab44719bcf39ae9c7ff03e295b8b420f7fc772da9977f9e03b416fe02-primary.xml.gz 
INFO[0000] Resolving repomd.xml from http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/repodata/repomd.xml 
INFO[0000] Loading primary file from http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/repodata/0e0c5fca0529c8d38204394fab49269af56edb6f335a9336d4840bc0dea33774-primary.xml.gz 
INFO[0004] Resolving repomd.xml from http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/repodata/repomd.xml 
INFO[0004] Loading primary file from http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/repodata/bf0a4a8aaa71b19d46f50628f302ed84cf9c8723fe6ea427ccfcbcc153333202-primary.xml.gz 
INFO[0006] Resolving repomd.xml from http://mirror.centos.org/centos/8-stream/PowerTools/x86_64/os/repodata/repomd.xml 
INFO[0006] Loading primary file from http://mirror.centos.org/centos/8-stream/PowerTools/x86_64/os/repodata/0520cf71ca0379e3a94ff114d5028292f17b8518ad1e0b49fece03eff1ce6d5d-primary.xml.gz 
```


```bash
[root@kubevirtci bazeldnf]# bazelisk run //:bazeldnf -- rpmtree --public --nobest --name testimage_x86_64 --basesystem centos-stream-release --repofile rpm/repo.yaml libvirt-0:8.1.0-1.el8
INFO: Analyzed target //:bazeldnf (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //:bazeldnf up-to-date:
  bazel-bin/bazeldnf.bash
INFO: Elapsed time: 0.123s, Critical Path: 0.00s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
INFO[0000] Loading packages.                            
INFO[0008] Initial reduction of involved packages.      
INFO[0009] Loading involved packages into the rpmtreer. 
INFO[0009] Loaded 5423 packages.                        
INFO[0009] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0009] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0009] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0009] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0009] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-12.el8 
INFO[0010] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0010] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0010] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0010] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0010] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-8.el8 
INFO[0010] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0010] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0010] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0010] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0010] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-13.el8 
INFO[0010] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8_4.1 
INFO[0010] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0010] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0010] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0010] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0010] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-10.el8 
INFO[0010] coreutils-single-0:8.30-12.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0010] coreutils-single-0:8.30-9.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0010] coreutils-single-0:8.30-13.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0010] coreutils-single-0:8.30-10.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0010] coreutils-single-0:8.30-8.el8 conflicts with coreutils-0:8.30-9.el8 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-18.el8 
INFO[0010] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-21.el8 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-25.el8 
INFO[0010] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8 
INFO[0010] libcurl-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-minimal-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-minimal-0:7.61.1-21.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-0:7.61.1-22.el8.3 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-minimal-0:7.61.1-22.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-minimal-0:7.61.1-18.el8_4.1 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] libcurl-0:7.61.1-25.el8 conflicts with libcurl-minimal-0:7.61.1-22.el8.3 
INFO[0010] Generated 25514 variables.                   
INFO[0010] Adding required packages to the rpmtreer.    
INFO[0010] Selecting libvirt: libvirt-0:8.1.0-1.el8     
INFO[0010] Selecting centos-stream-release: centos-stream-release-0:8.6-1.el8 
INFO[0010] Solving.                                     
INFO[0010] Loading the Partial weighted MAXSAT problem. 
INFO[0017] Solving the Partial weighted MAXSAT problem. 
INFO[0017] Solution with weight -198 found.             
INFO[0017] Picking selinux-policy-0:3.14.3-93.el8 instead of best candiate selinux-policy-0:3.14.3-105.el8 
INFO[0017] Picking selinux-policy-minimum-0:3.14.3-93.el8 instead of best candiate selinux-policy-minimum-0:3.14.3-105.el8 
INFO[0017] Writing bazel files.                         
Package                                         Version                                                         Size            Download Size
Installing:
 libvirt-daemon-driver-network                  0:8.1.0-1.el8                                                   680.65 K        181.42 K
 rpm                                            0:4.14.3-23.el8                                                 2.12 M          556.35 K
 ncurses-base                                   0:6.1-9.20180224.el8                                            314.23 K        83.08 K
 libidn2                                        0:2.2.0-1.el8                                                   293.60 K        96.02 K
 boost-system                                   0:1.66.0-13.el8                                                 22.68 K         18.68 K
 libarchive                                     0:3.3.3-4.el8                                                   840.36 K        368.60 K
 device-mapper-persistent-data                  0:0.9.0-7.el8                                                   3.37 M          949.31 K
 selinux-policy                                 0:3.14.3-93.el8                                                 26.06 K         659.85 K
 iptables                                       0:1.8.4-22.el8                                                  2.03 M          598.52 K
 libcollection                                  0:0.7.0-40.el8                                                  98.13 K         49.24 K
 cryptsetup-libs                                0:2.3.7-2.el8                                                   2.15 M          499.32 K
 mozjs60                                        0:60.9.0-4.el8                                                  23.73 M         6.93 M
 python3-pip-wheel                              0:9.0.3-22.el8                                                  930.56 K        916.30 K
 libvirt-daemon-driver-storage-disk             0:8.1.0-1.el8                                                   29.62 K         18.16 K
 systemd-udev                                   0:239-62.el8                                                    9.39 M          1.65 M
 libtpms                                        0:0.9.1-0.20211126git1ff6fe1f43.module_el8.6.0+1087+b42c8331    403.98 K        188.85 K
 lvm2-libs                                      8:2.03.14-5.el8                                                 2.80 M          1.24 M
 policycoreutils                                0:2.9-19.el8                                                    696.88 K        383.17 K
 nspr                                           0:4.34.0-3.el8                                                  323.61 K        146.38 K
 libbpf                                         0:0.5.0-1.el8                                                   308.74 K        139.97 K
 boost-date-time                                0:1.66.0-13.el8                                                 80.65 K         30.45 K
 iptables-libs                                  0:1.8.4-22.el8                                                  206.50 K        110.38 K
 libvirt-daemon-driver-storage-rbd              0:8.1.0-1.el8                                                   42.02 K         23.22 K
 dmidecode                                      1:3.3-4.el8                                                     230.33 K        94.38 K
 systemd-container                              0:239-62.el8                                                    1.72 M          780.39 K
 ca-certificates                                0:2021.2.50-82.el8                                              936.15 K        399.50 K
 python3-libselinux                             0:2.9-5.el8                                                     792.30 K        289.67 K
 libnghttp2                                     0:1.33.0-3.el8_2.1                                              169.26 K        79.21 K
 p11-kit                                        0:0.23.22-1.el8                                                 1.65 M          332.07 K
 libvirt-daemon-driver-qemu                     0:8.1.0-1.el8                                                   2.65 M          883.22 K
 policycoreutils-python-utils                   0:2.9-19.el8                                                    147.96 K        258.84 K
 pcre                                           0:8.42-6.el8                                                    512.34 K        215.63 K
 boost-atomic                                   0:1.66.0-13.el8                                                 9.94 K          14.47 K
 dbus-common                                    1:1.12.8-19.el8                                                 12.92 K         47.28 K
 crypto-policies-scripts                        0:20211116-1.gitae470d6.el8                                     204.40 K        85.20 K
 xz-libs                                        0:5.2.4-4.el8                                                   166.00 K        96.08 K
 libsigsegv                                     0:2.11-5.el8                                                    48.83 K         30.98 K
 pcre2                                          0:10.32-3.el8                                                   659.32 K        252.57 K
 quota                                          1:4.04-14.el8                                                   916.51 K        218.72 K
 systemd-pam                                    0:239-62.el8                                                    919.78 K        499.31 K
 gssproxy                                       0:0.8.0-21.el8                                                  272.12 K        122.28 K
 polkit                                         0:0.115-13.0.1.el8.2                                            417.58 K        157.70 K
 libvirt-daemon                                 0:8.1.0-1.el8                                                   1.62 M          369.44 K
 python3-setuptools-wheel                       0:39.2.0-6.el8                                                  348.48 K        295.73 K
 python3-setools                                0:4.3.0-3.el8                                                   2.75 M          639.22 K
 libuuid                                        0:2.32.1-35.el8                                                 36.42 K         99.23 K
 gettext                                        0:0.19.8.1-17.el8                                               5.45 M          1.12 M
 libsmartcols                                   0:2.32.1-35.el8                                                 249.71 K        182.16 K
 dbus-daemon                                    1:1.12.8-19.el8                                                 565.57 K        246.20 K
 gdbm                                           1:1.18-2.el8                                                    394.69 K        132.78 K
 libdb-utils                                    0:5.3.28-42.el8_4                                               379.20 K        153.24 K
 device-mapper-event-libs                       8:1.02.181-5.el8                                                55.88 K         276.56 K
 libvirt-daemon-config-nwfilter                 0:8.1.0-1.el8                                                   14.50 K         15.38 K
 platform-python-setuptools                     0:39.2.0-6.el8                                                  2.99 M          647.44 K
 nss-util                                       0:3.79.0-5.el8                                                  225.90 K        141.23 K
 diffutils                                      0:3.6-6.el8                                                     1.38 M          366.90 K
 swtpm-tools                                    0:0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331       275.40 K        121.56 K
 autogen-libopts                                0:5.18.12-8.el8                                                 151.05 K        76.80 K
 curl                                           0:7.61.1-25.el8                                                 703.48 K        360.54 K
 checkpolicy                                    0:2.9-1.el8                                                     1.77 M          356.58 K
 libmount                                       0:2.32.1-35.el8                                                 399.50 K        240.58 K
 polkit-pkla-compat                             0:0.1-12.el8                                                    100.51 K        46.97 K
 lua-libs                                       0:5.3.4-12.el8                                                  248.67 K        120.76 K
 elfutils-default-yama-scope                    0:0.187-4.el8                                                   2.09 K          52.83 K
 libcap-ng                                      0:0.7.11-1.el8                                                  52.67 K         34.19 K
 libpsl                                         0:0.20.2-6.el8                                                  71.92 K         62.86 K
 libnfnetlink                                   0:1.0.1-13.el8                                                  53.90 K         33.72 K
 boost-chrono                                   0:1.66.0-13.el8                                                 39.69 K         23.77 K
 libvirt-daemon-driver-nwfilter                 0:8.1.0-1.el8                                                   666.27 K        181.13 K
 python3-libsemanage                            0:2.9-8.el8                                                     455.32 K        131.26 K
 libtirpc                                       0:1.1.4-7.el8                                                   226.51 K        115.29 K
 kmod-libs                                      0:25-19.el8                                                     127.82 K        70.08 K
 glusterfs-cli                                  0:6.0-56.4.el8                                                  521.12 K        198.90 K
 libcom_err                                     0:1.45.6-5.el8                                                  62.58 K         50.52 K
 glusterfs                                      0:6.0-56.4.el8                                                  2.91 M          682.54 K
 boost-program-options                          0:1.66.0-13.el8                                                 537.02 K        144.13 K
 p11-kit-trust                                  0:0.23.22-1.el8                                                 473.54 K        140.29 K
 augeas-libs                                    0:1.12.0-7.el8                                                  1.43 M          447.30 K
 gzip                                           0:1.9-13.el8                                                    358.66 K        170.78 K
 pam                                            0:1.3.1-22.el8                                                  2.72 M          760.84 K
 expat                                          0:2.2.5-9.el8                                                   317.50 K        115.90 K
 libcap                                         0:2.48-4.el8                                                    169.93 K        75.80 K
 selinux-policy-minimum                         0:3.14.3-93.el8                                                 35.40 M         13.79 M
 basesystem                                     0:11-5.el8                                                      124             10.75 K
 libref_array                                   0:0.1.5-40.el8                                                  56.13 K         33.65 K
 libvirt-daemon-driver-interface                0:8.1.0-1.el8                                                   605.72 K        155.18 K
 gnutls-utils                                   0:3.6.16-4.el8                                                  1.52 M          356.62 K
 krb5-libs                                      0:1.18.2-21.el8                                                 2.25 M          860.54 K
 glusterfs-client-xlators                       0:6.0-56.4.el8                                                  4.32 M          904.10 K
 nettle                                         0:3.4.1-7.el8                                                   575.76 K        308.24 K
 cracklib-dicts                                 0:2.9.6-15.el8                                                  9.82 M          4.14 M
 lvm2                                           8:2.03.14-5.el8                                                 3.90 M          1.75 M
 libvirt-daemon-driver-storage-gluster          0:8.1.0-1.el8                                                   37.96 K         20.05 K
 libyaml                                        0:0.1.7-5.el8                                                   137.96 K        62.88 K
 libdb                                          0:5.3.28-42.el8_4                                               1.90 M          769.40 K
 setup                                          0:2.12.2-7.el8                                                  729.30 K        185.09 K
 coreutils-common                               0:8.30-13.el8                                                   9.93 M          2.09 M
 libnsl2                                        0:1.2.0-2.20180605git4a062cf.el8                                148.31 K        59.10 K
 cyrus-sasl                                     0:2.1.27-6.el8_5                                                156.32 K        98.72 K
 quota-nls                                      1:4.04-14.el8                                                   284.64 K        96.97 K
 libblkid                                       0:2.32.1-35.el8                                                 345.00 K        223.77 K
 libvirt-daemon-driver-storage-scsi             0:8.1.0-1.el8                                                   21.30 K         14.89 K
 nss-sysinit                                    0:3.79.0-5.el8                                                  15.46 K         75.57 K
 libseccomp                                     0:2.5.2-1.el8                                                   171.61 K        72.91 K
 dbus                                           1:1.12.8-19.el8                                                 124             42.43 K
 libiscsi                                       0:1.18.0-8.module_el8.6.0+983+a7505f3f                          232.50 K        91.55 K
 gdbm-libs                                      1:1.18-2.el8                                                    120.33 K        61.79 K
 keyutils                                       0:1.5.10-9.el8                                                  124.41 K        67.79 K
 centos-stream-release                          0:8.6-1.el8                                                     29.43 K         22.74 K
 python3-libs                                   0:3.6.8-47.el8                                                  32.78 M         8.23 M
 libsemanage                                    0:2.9-8.el8                                                     314.37 K        171.92 K
 ncurses                                        0:6.1-9.20180224.el8                                            596.08 K        396.27 K
 nss-softokn                                    0:3.79.0-5.el8                                                  3.87 M          1.26 M
 librdmacm                                      0:37.2-1.el8                                                    145.29 K        79.63 K
 libverto                                       0:0.3.2-2.el8                                                   28.70 K         24.60 K
 mpfr                                           0:3.1.6-1.el8                                                   614.92 K        226.70 K
 unbound-libs                                   0:1.16.0-2.el8                                                  1.55 M          580.36 K
 rpcbind                                        0:1.2.5-9.el8                                                   113.80 K        71.55 K
 libevent                                       0:2.1.8-5.el8                                                   925.20 K        259.53 K
 glusterfs-api                                  0:6.0-56.4.el8                                                  228.32 K        101.66 K
 libxslt                                        0:1.1.32-6.el8                                                  755.20 K        255.56 K
 device-mapper-event                            8:1.02.181-5.el8                                                49.62 K         277.71 K
 gmp                                            1:6.1.2-10.el8                                                  1.68 M          329.75 K
 python3-pyyaml                                 0:3.12-12.el8                                                   662.04 K        197.68 K
 device-mapper                                  8:1.02.181-5.el8                                                361.67 K        386.42 K
 numad                                          0:0.5-26.20150602git.el8                                        60.31 K         42.23 K
 dbus-libs                                      1:1.12.8-19.el8                                                 381.96 K        188.54 K
 boost-iostreams                                0:1.66.0-13.el8                                                 134.41 K        42.87 K
 python3-policycoreutils                        0:2.9-19.el8                                                    5.75 M          2.35 M
 python3-audit                                  0:3.0.7-4.el8                                                   337.20 K        88.90 K
 keyutils-libs                                  0:1.5.10-9.el8                                                  45.16 K         34.78 K
 gettext-libs                                   0:0.19.8.1-17.el8                                               1.62 M          321.58 K
 info                                           0:6.5-7.el8_5                                                   387.26 K        203.23 K
 libpwquality                                   0:1.4.4-3.el8                                                   409.00 K        109.43 K
 libverto-libev                                 0:0.3.2-2.el8                                                   13.04 K         16.53 K
 device-mapper-libs                             8:1.02.181-5.el8                                                416.88 K        419.54 K
 glibc-langpack-ur                              0:2.28-208.el8                                                  2.94 M          432.10 K
 libaio                                         0:0.3.112-1.el8                                                 98.80 K         33.41 K
 e2fsprogs-libs                                 0:1.45.6-5.el8                                                  522.62 K        238.70 K
 libacl                                         0:2.2.53-1.el8                                                  60.18 K         35.62 K
 util-linux                                     0:2.32.1-35.el8                                                 11.65 M         2.59 M
 cracklib                                       0:2.9.6-15.el8                                                  250.87 K        95.50 K
 parted                                         0:3.2-39.el8                                                    2.13 M          568.77 K
 dbus-tools                                     1:1.12.8-19.el8                                                 128.05 K        87.70 K
 libgomp                                        0:8.5.0-15.el8                                                  333.47 K        212.10 K
 lzo                                            0:2.08-14.el8                                                   200.48 K        70.85 K
 sed                                            0:4.5-5.el8                                                     773.39 K        305.33 K
 openssl-libs                                   1:1.1.1k-6.el8                                                  3.77 M          1.54 M
 audit-libs                                     0:3.0.7-4.el8                                                   310.77 K        125.88 K
 libicu                                         0:60.3-2.el8_1                                                  33.72 M         9.27 M
 libxml2                                        0:2.9.7-14.el8                                                  1.76 M          712.30 K
 libstdc++                                      0:8.5.0-15.el8                                                  1.86 M          464.94 K
 libnftnl                                       0:1.1.5-5.el8                                                   223.62 K        84.97 K
 libvirt-daemon-driver-nodedev                  0:8.1.0-1.el8                                                   636.30 K        166.16 K
 nfs-utils                                      1:2.3.3-56.el8                                                  1.66 M          526.79 K
 libcroco                                       0:0.6.12-4.el8_2.1                                              333.22 K        115.22 K
 libxcrypt                                      0:4.1.1-6.el8                                                   188.42 K        74.48 K
 iproute                                        0:5.18.0-1.el8                                                  2.51 M          827.78 K
 iproute-tc                                     0:5.18.0-1.el8                                                  910.20 K        477.10 K
 crypto-policies                                0:20211116-1.gitae470d6.el8                                     94.23 K         65.20 K
 glusterfs-libs                                 0:6.0-56.4.el8                                                  1.74 M          428.49 K
 gnutls                                         0:3.6.16-4.el8                                                  3.01 M          1.04 M
 iptables-ebtables                              0:1.8.4-22.el8                                                  15.23 K         73.78 K
 elfutils-libelf                                0:0.187-4.el8                                                   1.03 M          236.61 K
 isns-utils-libs                                0:0.99-1.el8                                                    631.88 K        107.48 K
 coreutils                                      0:8.30-13.el8                                                   6.15 M          1.27 M
 libvirt-daemon-driver-storage-iscsi-direct     0:8.1.0-1.el8                                                   25.50 K         17.08 K
 lz4-libs                                       0:1.8.3-3.el8_4                                                 122.25 K        67.35 K
 openldap                                       0:2.4.46-18.el8                                                 1.01 M          360.92 K
 libvirt                                        0:8.1.0-1.el8                                                   124             6.89 K
 bzip2                                          0:1.0.6-26.el8                                                  98.39 K         61.62 K
 nss                                            0:3.79.0-5.el8                                                  2.06 M          764.20 K
 swtpm                                          0:0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331       219.14 K        43.63 K
 qemu-img                                       15:6.2.0-12.module_el8.7.0+1140+ff0772f9                        8.57 M          2.25 M
 glibc                                          0:2.28-208.el8                                                  6.79 M          2.31 M
 sqlite-libs                                    0:3.26.0-15.el8                                                 1.17 M          594.68 K
 iscsi-initiator-utils-iscsiuio                 0:6.2.1.4-4.git095f59c.el8                                      190.95 K        102.82 K
 libsepol                                       0:2.9-3.el8                                                     762.65 K        348.04 K
 polkit-libs                                    0:0.115-13.0.1.el8.2                                            198.83 K        78.30 K
 libpciaccess                                   0:0.14-1.el8                                                    51.76 K         33.25 K
 libunistring                                   0:0.9.9-3.el8                                                   1.86 M          432.42 K
 publicsuffix-list-dafsa                        0:20180723-1.el8                                                65.24 K         57.47 K
 platform-python                                0:3.6.8-47.el8                                                  43.80 K         87.83 K
 mdevctl                                        0:1.1.0-2.el8                                                   2.05 M          772.85 K
 elfutils-libs                                  0:0.187-4.el8                                                   715.10 K        304.02 K
 libvirt-daemon-driver-secret                   0:8.1.0-1.el8                                                   569.48 K        143.64 K
 xz                                             0:5.2.4-4.el8                                                   431.14 K        156.84 K
 rpm-plugin-selinux                             0:4.14.3-23.el8                                                 12.75 K         79.46 K
 systemd-libs                                   0:239-62.el8                                                    4.59 M          1.16 M
 libvirt-daemon-driver-storage-mpath            0:8.1.0-1.el8                                                   12.85 K         12.51 K
 dnsmasq                                        0:2.79-23.el8                                                   670.11 K        328.25 K
 json-c                                         0:0.13.1-3.el8                                                  70.64 K         41.66 K
 libgcc                                         0:8.5.0-15.el8                                                  192.02 K        82.59 K
 yajl                                           0:2.1.0-11.el8                                                  85.42 K         41.67 K
 acl                                            0:2.2.53-1.el8                                                  209.64 K        82.99 K
 shadow-utils                                   2:4.6-17.el8                                                    4.13 M          1.29 M
 zlib                                           0:1.2.11-19.el8                                                 201.55 K        105.06 K
 centos-gpg-keys                                1:8-6.el8                                                       6.28 K          14.63 K
 libcurl                                        0:7.61.1-25.el8                                                 594.70 K        309.01 K
 iscsi-initiator-utils                          0:6.2.1.4-4.git095f59c.el8                                      1.81 M          386.82 K
 libgpg-error                                   0:1.31-1.el8                                                    908.91 K        247.52 K
 json-glib                                      0:1.4.4-1.el8                                                   541.04 K        147.74 K
 libfdisk                                       0:2.32.1-35.el8                                                 440.11 K        258.05 K
 rpm-libs                                       0:4.14.3-23.el8                                                 737.20 K        353.40 K
 libvirt-daemon-driver-storage                  0:8.1.0-1.el8                                                   124             6.77 K
 tzdata                                         0:2022a-2.el8                                                   2.18 M          485.40 K
 readline                                       0:7.0-10.el8                                                    468.61 K        204.02 K
 libattr                                        0:2.4.48-3.el8                                                  28.38 K         27.56 K
 cyrus-sasl-gssapi                              0:2.1.27-6.el8_5                                                42.86 K         51.06 K
 libgcrypt                                      0:1.8.5-7.el8                                                   1.27 M          473.84 K
 libvirt-client                                 0:8.1.0-1.el8                                                   1.02 M          365.76 K
 chkconfig                                      0:1.19.1-1.el8                                                  843.79 K        203.05 K
 libssh-config                                  0:0.9.6-3.el8                                                   816             19.75 K
 librbd1                                        1:12.2.7-9.el8                                                  4.64 M          1.14 M
 libutempter                                    0:1.1.6-14.el8                                                  54.63 K         32.46 K
 centos-stream-repos                            0:8-6.el8                                                       30.21 K         20.59 K
 libev                                          0:4.24-6.el8                                                    103.42 K        53.71 K
 libibverbs                                     0:37.2-1.el8                                                    1.02 M          393.71 K
 boost-random                                   0:1.66.0-13.el8                                                 39.07 K         22.85 K
 libvirt-daemon-config-network                  0:8.1.0-1.el8                                                   644             9.44 K
 boost-thread                                   0:1.66.0-13.el8                                                 183.57 K        60.11 K
 lzop                                           0:1.03-20.el8                                                   116.16 K        63.36 K
 hwdata                                         0:0.314-8.13.el8                                                8.87 M          1.82 M
 libffi                                         0:3.1-23.el8                                                    55.29 K         38.32 K
 nss-softokn-freebl                             0:3.79.0-5.el8                                                  813.46 K        406.99 K
 glib2                                          0:2.56.4-159.el8                                                12.30 M         2.61 M
 numactl-libs                                   0:2.0.12-13.el8                                                 52.09 K         36.99 K
 libvirt-libs                                   0:8.1.0-1.el8                                                   24.40 M         4.87 M
 libvirt-daemon-driver-storage-logical          0:8.1.0-1.el8                                                   29.59 K         18.98 K
 libpcap                                        14:1.9.1-5.el8                                                  387.00 K        172.74 K
 glibc-common                                   0:2.28-208.el8                                                  8.01 M          1.04 M
 libmnl                                         0:1.0.4-6.el8                                                   55.15 K         31.04 K
 boost-regex                                    0:1.66.0-13.el8                                                 1.18 M          287.33 K
 grep                                           0:3.1-6.el8                                                     845.03 K        280.36 K
 libselinux-utils                               0:2.9-5.el8                                                     328.67 K        248.57 K
 ncurses-libs                                   0:6.1-9.20180224.el8                                            958.61 K        341.76 K
 gnutls-dane                                    0:3.6.16-4.el8                                                  47.14 K         53.34 K
 cyrus-sasl-lib                                 0:2.1.27-6.el8_5                                                732.16 K        126.32 K
 librados2                                      1:12.2.7-9.el8                                                  12.86 M         3.04 M
 libnetfilter_conntrack                         0:1.0.6-5.el8                                                   166.47 K        66.28 K
 libvirt-daemon-driver-storage-iscsi            0:8.1.0-1.el8                                                   21.30 K         15.10 K
 popt                                           0:1.18-1.el8                                                    133.12 K        62.82 K
 brotli                                         0:1.0.6-3.el8                                                   1.53 M          330.87 K
 systemd                                        0:239-62.el8                                                    11.39 M         3.77 M
 bash                                           0:4.4.20-4.el8                                                  6.88 M          1.62 M
 libpath_utils                                  0:0.2.1-40.el8                                                  60.26 K         35.07 K
 libzstd                                        0:1.4.4-1.el8                                                   699.40 K        272.32 K
 psmisc                                         0:23.1-5.el8                                                    503.50 K        154.36 K
 libselinux                                     0:2.9-5.el8                                                     170.92 K        169.13 K
 gawk                                           0:4.2.1-4.el8                                                   2.72 M          1.19 M
 libini_config                                  0:1.3.1-40.el8                                                  156.25 K        72.16 K
 libtasn1                                       0:4.13-3.el8                                                    170.78 K        78.01 K
 bzip2-libs                                     0:1.0.6-26.el8                                                  78.42 K         49.10 K
 libnl3                                         0:3.7.0-1.el8                                                   1.06 M          345.42 K
 swtpm-libs                                     0:0.7.0-1.20211109gitb79fd91.module_el8.6.0+1087+b42c8331       99.70 K         49.81 K
 libssh                                         0:0.9.6-3.el8                                                   519.94 K        221.38 K
 libvirt-daemon-driver-storage-core             0:8.1.0-1.el8                                                   741.98 K        200.92 K
 filesystem                                     0:3.8-6.el8                                                     215.45 K        1.14 M
 libnfsidmap                                    1:2.3.3-56.el8                                                  199.18 K        124.68 K
 kmod                                           0:25-19.el8                                                     249.21 K        129.17 K
 netcf-libs                                     0:0.2.8-12.module_el8.6.0+983+a7505f3f                          213.40 K        78.40 K
 libbasicobjects                                0:0.1.1-40.el8                                                  55.98 K         32.18 K
Ignoring:

Transaction Summary:
Installing 262 Packages 
Total download size: 138.73 M
Total install size: 455.55 M
```