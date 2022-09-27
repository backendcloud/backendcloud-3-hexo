---
title: OVS-DPDK
readmore: true
date: 2022-09-22 18:34:24
categories: 云原生
tags:
- OVS-DPDK
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

> 要使用 ovs-dpdk，需要在node上构建 DPDK 并使用相应的 DPDK flag重新构建 ovs。 OVS-DPDK需要从源码编译，因为高度依赖内核等所在机器的环境，并需要配置很多参数以达到高性能。这意味着很难提供一个ovs-dpdk docker镜像来满足所有情况。
>
> OVS-DPDK需要大页内存作为资源。
>
> 由于 DPDK 会剥夺系统对 nic 的控制权，我们需要一个 ovs-dpdk 专用的 nic 来传输容器网络，另一个 nic 用于普通主机网络。
> 
> 普通Pod的ovs网络是在 pod 和 ovs 端口之间放置了一个 veth 对。 veth 的一端移动到容器网络命名空间。不能用 OVS-DPDK 做到这一点。当我们请求一个新的 DPDK 端口时，我们最终会在 /var/run/openvswitch/ 这样的目录中得到一个类似 vhost-user 套接字文件的东西。它不能在命名空间之间移动，它必须被挂载到 pod 中就像一个普通的文件(由 Userspace-CNI 提供的功能)。所以不能使用 OVS-DPDK 作为默认网络。Pod对K8S API不可达，K8S不能对pod进行健康检查。因此，需要依赖 Multus 来连接多个网络。Kernel-OVS 仍然是默认网络。此外，Multus 允许为Pod提供 OVS-DPDK 网络。这是同一个 OVS 实例，但是 DPDK port位于另一个支持 DPDK 的bridge上。
>
> ovs-dpdk创建br和port， ovs 集成网桥类型更改为 netdev ，端口类型更改为 dpdkvhostuser 并设置其他 ovs-dpdk 参数。

# 准备工作

```bash
[root@backendcloud-fedora27 ~]# dnf groupinstall "Development Tools"
[root@backendcloud-fedora27 ~]# dnf groupinstall "Virtualization"
[root@backendcloud-fedora27 ~]# dnf install qemu
[root@backendcloud-fedora27 ~]# dnf install automake tunctl kernel-tools pciutils hwloc numactl
[root@backendcloud-fedora27 ~]# dnf install libpcap-devel
[root@backendcloud-fedora27 ~]# dnf install numactl-devel
[root@backendcloud-fedora27 ~]# dnf install libtool
```

# 编译DPDK

```bash
[root@backendcloud-fedora27 ~]# tar xf dpdk-17.08.1.tar.xz 
[root@backendcloud-fedora27 ~]# ls
anaconda-ks.cfg  dpdk-17.08.1.tar.xz  dpdk-stable-17.08.1
[root@backendcloud-fedora27 ~]# cd dpdk-
-bash: cd: dpdk-: No such file or directory
[root@backendcloud-fedora27 ~]# cd dpdk-stable-17.08.1/
[root@backendcloud-fedora27 dpdk-stable-17.08.1]# export DPDK_DIR=`pwd`/build
[root@backendcloud-fedora27 dpdk-stable-17.08.1]# make config T=x86_64-native-linuxapp-gcc
Configuration done using x86_64-native-linuxapp-gcc
[root@backendcloud-fedora27 dpdk-stable-17.08.1]# sed -ri 's,(PMD_PCAP=).*,\1y,' build/.config
[root@backendcloud-fedora27 dpdk-stable-17.08.1]# make
```

make 报错：

```bash
/usr/src/kernels/4.18.19-100.fc27.x86_64/Makefile:945: *** "Cannot generate ORC metadata for CONFIG_UNWINDER_ORC=y, please install libelf-dev, libelf-devel or elfutils-libelf-devel".  Stop.
```

安装 elfutils-libelf-devel 解决：

```bash
[root@backendcloud-fedora27 dpdk-stable-17.08.1]# yum install -y elfutils-libelf-devel
```

> 编译DPDK可以参考 {% post_link dpdk-build %}

# 编译OvS-DPDK

```bash
[root@backendcloud-fedora27 ~]# wget http://openvswitch.org/releases/openvswitch-2.8.1.tar.gz
[root@backendcloud-fedora27 ~]# tar -xzvf openvswitch-2.8.1.tar.gz
[root@backendcloud-fedora27 ~]# cd openvswitch-2.8.1/
[root@backendcloud-fedora27 openvswitch-2.8.1]# export OVS_DIR=`pwd`
[root@backendcloud-fedora27 openvswitch-2.8.1]# sudo ./boot.sh
[root@backendcloud-fedora27 openvswitch-2.8.1]# sudo ./configure --with-dpdk="$DPDK_DIR/" CFLAGS="-g -Ofast"
[root@backendcloud-fedora27 openvswitch-2.8.1]# sudo make 'CFLAGS=-g -Ofast -march=native' -j10
```

# Create OvS DB and Start OvS DB-Server

```bash
[root@backendcloud-fedora27 openvswitch-2.8.1]# pkill -9 ovs
[root@backendcloud-fedora27 openvswitch-2.8.1]# rm -rf /usr/local/var/run/openvswitch
[root@backendcloud-fedora27 openvswitch-2.8.1]# rm -rf /usr/local/etc/openvswitch/
[root@backendcloud-fedora27 openvswitch-2.8.1]# rm -f /usr/local/etc/openvswitch/conf.db
[root@backendcloud-fedora27 openvswitch-2.8.1]# mkdir -p /usr/local/etc/openvswitch
[root@backendcloud-fedora27 openvswitch-2.8.1]# mkdir -p /usr/local/var/run/openvswitch
[root@backendcloud-fedora27 openvswitch-2.8.1]# cd $OVS_DIR
[root@backendcloud-fedora27 openvswitch-2.8.1]# ./ovsdb/ovsdb-tool create /usr/local/etc/openvswitch/conf.db ./vswitchd/vswitch.ovsschema
[root@backendcloud-fedora27 openvswitch-2.8.1]# ./ovsdb/ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock --remote=db:Open_vSwitch,Open_vSwitch,manager_options --pidfile --detach
[root@backendcloud-fedora27 openvswitch-2.8.1]# ./utilities/ovs-vsctl --no-wait init
```

# Configure Fedora27 for OvS-DPDK

```bash
[root@backendcloud-fedora27 openvswitch-2.8.1]# vim /etc/default/grub
...
GRUB_CMDLINE_LINUX_DEFAULT="default_hugepagesz=1G hugepagesz=1G hugepages=4 hugepagesz=2M hugepages=512 iommu=pt intel_iommu=on"
[root@backendcloud-fedora27 openvswitch-2.8.1]# grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-4.18.19-100.fc27.x86_64
Found initrd image: /boot/initramfs-4.18.19-100.fc27.x86_64.img
Found linux image: /boot/vmlinuz-0-rescue-98bddbf29a4f40009b8390e2c27a80ac
Found initrd image: /boot/initramfs-0-rescue-98bddbf29a4f40009b8390e2c27a80ac.img
done
[root@backendcloud-fedora27 openvswitch-2.8.1]# reboot
```

> 可以设置cpu隔离：
>
> GRUB_CMDLINE_LINUX_DEFAULT="default_hugepagesz=1G hugepagesz=1G hugepages=16 hugepagesz=2M hugepages=2048 iommu=pt intel_iommu=on isolcpus=1-27,29-55"

```bash
[root@backendcloud-fedora27 ~]# mkdir -p /mnt/huge
[root@backendcloud-fedora27 ~]# mkdir -p /mnt/huge_2mb
[root@backendcloud-fedora27 ~]# mount -t hugetlbfs hugetlbfs /mnt/huge
[root@backendcloud-fedora27 ~]# mount -t hugetlbfs none /mnt/huge_2mb -o pagesize=2MB
[root@backendcloud-fedora27 ~]# cat /proc/meminfo 
MemTotal:       17650724 kB
MemFree:        11744728 kB
MemAvailable:   11867184 kB
...
HugePages_Total:       4
HugePages_Free:        4
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:    1048576 kB
Hugetlb:         5242880 kB
DirectMap4k:      124736 kB
DirectMap2M:     5273600 kB
DirectMap1G:    13631488 kB
[root@backendcloud-fedora27 ~]# cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-4.18.19-100.fc27.x86_64 root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/root rhgb quiet default_hugepagesz=1G hugepagesz=1G hugepages=4 hugepagesz=2M hugepages=512 iommu=pt intel_iommu=on
```

# 配置OVS-DPDK

```bash
[root@backendcloud-fedora27 ~]# modprobe vfio-pci
[root@backendcloud-fedora27 ~]# modprobe openvswitch
[root@backendcloud-fedora27 ~]# cd openvswitch-2.8.1
[root@backendcloud-fedora27 openvswitch-2.8.1]# ./ovsdb/ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock --remote=db:Open_vSwitch,Open_vSwitch,manager_options --pidfile --detach
[root@backendcloud-fedora27 openvswitch-2.8.1]# ./vswitchd/ovs-vswitchd unix:/usr/local/var/run/openvswitch/db.sock --pidfile --detach
2022-09-22T06:09:08Z|00001|ovs_numa|INFO|Discovered 4 CPU cores on NUMA node 0
2022-09-22T06:09:08Z|00002|ovs_numa|INFO|Discovered 1 NUMA nodes and 4 CPU cores
2022-09-22T06:09:08Z|00003|reconnect|INFO|unix:/usr/local/var/run/openvswitch/db.sock: connecting...
2022-09-22T06:09:08Z|00004|reconnect|INFO|unix:/usr/local/var/run/openvswitch/db.sock: connected
2022-09-22T06:09:08Z|00005|dpdk|INFO|DPDK Disabled - Use other_config:dpdk-init to enable
[root@backendcloud-fedora27 openvswitch-2.8.1]# ./utilities/ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true
```

配置隔离cpu，memory提高DPDK性能，非必须。

```bash
[root@backendcloud-fedora27 openvswitch-2.8.1]# ./utilities/ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=0x10000001
[root@backendcloud-fedora27 openvswitch-2.8.1]# ./utilities/ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-lcore-mask=0xffffffeffffffe
[root@backendcloud-fedora27 openvswitch-2.8.1]# ./utilities/ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-socket-mem="1024,1024"
```

# Creating an OvS-DPDK Bridge and Ports

```bash
[root@backendcloud-fedora27 openvswitch-2.8.1]# ./utilities/ovs-vsctl show
52de1671-20cc-438c-be6a-d41e7923100b
[root@backendcloud-fedora27 openvswitch-2.8.1]# ./utilities/ovs-vsctl add-br br0 -- set bridge br0 datapath_type=netdev
[root@backendcloud-fedora27 openvswitch-2.8.1]# ./utilities/ovs-vsctl add-port br0 vhost-user1 -- set Interface vhost-user1 type=dpdkvhostuser
[root@backendcloud-fedora27 openvswitch-2.8.1]# ./utilities/ovs-vsctl add-port br0 vhost-user2 -- set Interface vhost-user2 type=dpdkvhostuser
[root@backendcloud-fedora27 openvswitch-2.8.1]# ./utilities/ovs-vsctl show
52de1671-20cc-438c-be6a-d41e7923100b
    Bridge "br0"
        Port "vhost-user1"
            Interface "vhost-user1"
                type: dpdkvhostuser
        Port "br0"
            Interface "br0"
                type: internal
        Port "vhost-user2"
            Interface "vhost-user2"
                type: dpdkvhostuser
```

# Binding Nic Device to DPDK

```bash
[root@backendcloud-fedora27 openvswitch-2.8.1]# modprobe vfio-pci
[root@backendcloud-fedora27 openvswitch-2.8.1]# cp ~/dpdk-stable-17.08.1/usertools/dpdk-devbind.py /usr/bin/
[root@backendcloud-fedora27 openvswitch-2.8.1]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:7a:c2:a0 brd ff:ff:ff:ff:ff:ff
    inet 192.168.126.143/24 brd 192.168.126.255 scope global dynamic ens33
       valid_lft 1442sec preferred_lft 1442sec
    inet6 fe80::7e7a:3d91:e5b0:4a63/64 scope link 
       valid_lft forever preferred_lft forever
3: ens34: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:7a:c2:aa brd ff:ff:ff:ff:ff:ff
    inet 192.168.126.144/24 brd 192.168.126.255 scope global dynamic ens34
       valid_lft 1398sec preferred_lft 1398sec
    inet6 fe80::49fe:5d8c:8b86:95d8/64 scope link 
       valid_lft forever preferred_lft forever
4: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 52:54:00:30:d1:c3 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
       valid_lft forever preferred_lft forever
5: virbr0-nic: <BROADCAST,MULTICAST> mtu 1500 qdisc fq_codel master virbr0 state DOWN group default qlen 1000
    link/ether 52:54:00:30:d1:c3 brd ff:ff:ff:ff:ff:ff
6: ovs-netdev: <BROADCAST,PROMISC> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 22:0e:6b:c1:4c:91 brd ff:ff:ff:ff:ff:ff
7: br0: <BROADCAST,PROMISC> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 0e:3b:21:02:03:47 brd ff:ff:ff:ff:ff:ff
[root@backendcloud-fedora27 openvswitch-2.8.1]# dpdk-devbind.py --status

Network devices using DPDK-compatible driver
============================================
<none>

Network devices using kernel driver
===================================
0000:02:01.0 '82545EM Gigabit Ethernet Controller (Copper) 100f' if=ens33 drv=e1000 unused=vfio-pci *Active*
0000:02:02.0 '82545EM Gigabit Ethernet Controller (Copper) 100f' if=ens34 drv=e1000 unused=vfio-pci *Active*
...
[root@backendcloud-fedora27 openvswitch-2.8.1]# dpdk-devbind.py --bind=vfio-pci ens34
Routing table indicates that interface 0000:02:02.0 is active. Not modifying
[root@backendcloud-fedora27 openvswitch-2.8.1]# yum install -y net-tools
[root@backendcloud-fedora27 openvswitch-2.8.1]# ifconfig ens34 down
[root@backendcloud-fedora27 openvswitch-2.8.1]# dpdk-devbind.py --bind=vfio-pci ens34
[root@backendcloud-fedora27 openvswitch-2.8.1]# dpdk-devbind.py --status

Network devices using DPDK-compatible driver
============================================
0000:02:02.0 '82545EM Gigabit Ethernet Controller (Copper) 100f' drv=vfio-pci unused=

Network devices using kernel driver
===================================
0000:02:01.0 '82545EM Gigabit Ethernet Controller (Copper) 100f' if=ens33 drv=e1000 unused=vfio-pci *Active*
...
```

# Using DPDK vhost-user Ports with VMs

去官网下载镜像并修改root密码：

```bash
[root@backendcloud-fedora27 ~]# virt-customize -a centos7vm1.qcow2 --root-password password:666666
-bash: virt-customize: command not found
[root@backendcloud-fedora27 ~]# dnf install -y libguestfs-tools
[root@backendcloud-centos9 ~]# virt-customize -a centos7vm1.qcow2 --root-password password:666666
[   0.0] Examining the guest ...
[   6.8] Setting a random seed
[   6.8] Setting passwords
[   8.3] SELinux relabelling
[  12.9] Finishing off
[root@backendcloud-centos9 ~]# virt-customize -a centos7vm2.qcow2 --root-password password:666666
```

启动两个dpdk vm：

```bash
qemu-system-x86_64 -m 1024 -smp 4 -cpu host,pmu=off -hda /root/centos7vm1.qcow2 -boot c -enable-kvm -no-reboot -net none -nographic \
-chardev socket,id=char1,path=/usr/local/var/run/openvswitch/vhost-user1 \
-netdev type=vhost-user,id=mynet1,chardev=char1,vhostforce \
-device virtio-net-pci,mac=00:00:00:00:00:01,netdev=mynet1 \
-object memory-backend-file,id=mem,size=1G,mem-path=/dev/hugepages,share=on \
-numa node,memdev=mem -mem-prealloc

qemu-system-x86_64 -m 1024 -smp 4 -cpu host,pmu=off -hda /root/centos7vm2.qcow2 -boot c -enable-kvm -no-reboot -net none -nographic \
-chardev socket,id=char2,path=/usr/local/var/run/openvswitch/vhost-user2 \
-netdev type=vhost-user,id=mynet2,chardev=char2,vhostforce \
-device virtio-net-pci,mac=00:00:00:00:00:02,netdev=mynet2 \
-object memory-backend-file,id=mem,size=1G,mem-path=/dev/hugepages,share=on \
-numa node,memdev=mem -mem-prealloc
```

若上面的操作是在vmware上操作，需要加上上面额外的参数pmu=off，为了规避vmware的bug。若不加会报下面的错误：

```bash
[root@backendcloud-fedora27 ~]# qemu-system-x86_64 -m 1024 -smp 4 -cpu host -hda /root/centos7vm1.qcow2 -boot c -enable-kvm -no-reboot -net none -nographic \
> -chardev socket,id=char1,path=/usr/local/var/run/openvswitch/vhost-user1 \
> -netdev type=vhost-user,id=mynet1,chardev=char1,vhostforce \
> -device virtio-net-pci,mac=00:00:00:00:00:01,netdev=mynet1 \
> -object memory-backend-file,id=mem,size=1G,mem-path=/dev/hugepages,share=on \
> -numa node,memdev=mem -mem-prealloc
qemu-system-x86_64: error: failed to set MSR 0x38d to 0x0
qemu-system-x86_64: /builddir/build/BUILD/qemu-2.10.2/target/i386/kvm.c:1806: kvm_put_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
Aborted (core dumped)
```

# 安装iperf3，并测试使用OVS-DPDK虚拟机

```bash
[root@localhost ~]# iperf3 -s
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
Accepted connection from 192.168.0.2, port 48462
[  5] local 192.168.0.1 port 5201 connected to 192.168.0.2 port 48464
[ ID] Interval           Transfer     Bandwidth
[  5]   0.00-1.00   sec   828 MBytes  6.95 Gbits/sec                  
[  5]   1.00-2.00   sec   775 MBytes  6.51 Gbits/sec                  
[  5]   2.00-3.00   sec   852 MBytes  7.15 Gbits/sec                  
[  5]   3.00-4.00   sec  1.03 GBytes  8.85 Gbits/sec                  
[  5]   4.00-5.00   sec   928 MBytes  7.79 Gbits/sec                  
[  5]   5.00-6.00   sec   905 MBytes  7.59 Gbits/sec                  
[  5]   6.00-7.00   sec   824 MBytes  6.91 Gbits/sec                  
[  5]   7.00-8.00   sec   962 MBytes  8.07 Gbits/sec                  
[  5]   8.00-9.00   sec   987 MBytes  8.28 Gbits/sec                  
[  5]   9.00-10.00  sec   856 MBytes  7.19 Gbits/sec                  
[  5]  10.00-10.04  sec  35.2 MBytes  7.97 Gbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth
[  5]   0.00-10.04  sec  0.00 Bytes  0.00 bits/sec                  sender
[  5]   0.00-10.04  sec  8.80 GBytes  7.53 Gbits/sec                  receiver
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
```

```bash
[root@localhost ~]# iperf3 -c 192.168.0.1
Connecting to host 192.168.0.1, port 5201
[  4] local 192.168.0.2 port 48464 connected to 192.168.0.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec   861 MBytes  7.22 Gbits/sec  1087    177 KBytes       
[  4]   1.00-2.00   sec   745 MBytes  6.26 Gbits/sec  566    182 KBytes       
[  4]   2.00-3.00   sec   908 MBytes  7.61 Gbits/sec  755    184 KBytes       
[  4]   3.00-4.00   sec  1.01 GBytes  8.66 Gbits/sec  824    212 KBytes       
[  4]   4.00-5.00   sec   935 MBytes  7.85 Gbits/sec  589    165 KBytes       
[  4]   5.00-6.00   sec   875 MBytes  7.34 Gbits/sec  514    194 KBytes       
[  4]   6.00-7.00   sec   850 MBytes  7.13 Gbits/sec  718    188 KBytes       
[  4]   7.00-8.00   sec   983 MBytes  8.25 Gbits/sec  949    158 KBytes       
[  4]   8.00-9.00   sec   930 MBytes  7.80 Gbits/sec  649    180 KBytes       
[  4]   9.00-10.00  sec   892 MBytes  7.48 Gbits/sec  668    147 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-10.00  sec  8.80 GBytes  7.56 Gbits/sec  7319             sender
[  4]   0.00-10.00  sec  8.80 GBytes  7.56 Gbits/sec                  receiver

iperf Done.
```

# 对比未用OVS-DPDK的虚拟机

```bash
[root@backendcloud-fedora27 ~]# yum -y install wget openssl-devel gcc make python-devel openssl-devel kernel-devel graphviz kernel-debug-devel autoconf automake rpm-build redhat-rpm-config libtool python-twisted-core python-zope-interface PyQt4 desktop-file-utils libcap-ng-devel groff checkpolicy selinux-policy-devel
[root@backendcloud-fedora27 ~]# adduser ovs
[root@backendcloud-fedora27 ~]# su - ovs
[ovs@backendcloud-fedora27 ~]$ mkdir -p ~/rpmbuild/SOURCES
[ovs@backendcloud-fedora27 ~]$ cd ~/rpmbuild/SOURCES
[ovs@backendcloud-fedora27 ~]$ wget http://openvswitch.org/releases/openvswitch-2.5.10.tar.gz
[ovs@backendcloud-fedora27 ~]$ tar -zxvf openvswitch-2.5.10.tar.gz
[ovs@backendcloud-fedora27 ~]$ rpmbuild -bb --nocheck openvswitch-2.5.10/rhel/openvswitch-fedora.spec
[ovs@backendcloud-fedora27 ~]$ exit
[root@backendcloud-fedora27 ~]# yum localinstall yum localinstall /home/ovs/rpmbuild/RPMS/x86_64/openvswitch-2.5.10-1.fc27.x86_64.rpm -y
[root@backendcloud-fedora27 ~]# ovs-vsctl --version
ovs-vsctl (Open vSwitch) 2.5.10
Compiled Sep 22 2022 16:43:31
DB Schema 7.12.1
[root@backendcloud-fedora27 ~]# systemctl start openvswitch.service
[root@backendcloud-fedora27 tmp]# ovs-vsctl show
0425b4a1-cfb0-4cbb-94a8-68bd581ce48e
[root@backendcloud-fedora27 ~]# ovs-vsctl add-br br1
[root@backendcloud-fedora27 tmp]# ovs-vsctl show
0425b4a1-cfb0-4cbb-94a8-68bd581ce48e
    Bridge "br1"
        Port "br1"
            Interface "br1"
                type: internal
    ovs_version: "2.5.10"
[root@backendcloud-fedora27 tmp]# cat test.xml 
<network>
  <name>test</name>
  <forward mode="bridge"/>
  <bridge name="br1"/>
  <virtualport type="openvswitch"/>
</network>
[root@backendcloud-fedora27 tmp]# virsh net-list --all
 Name                 State      Autostart     Persistent
----------------------------------------------------------
 default              active     yes           yes

[root@backendcloud-fedora27 tmp]# virsh net-define test.xml
Network test defined from test.xml

[root@backendcloud-fedora27 tmp]# virsh net-list --all
 Name                 State      Autostart     Persistent
----------------------------------------------------------
 default              active     yes           yes
 test                 inactive   no            yes

[root@backendcloud-fedora27 tmp]# virsh net-start test
Network test started

[root@backendcloud-fedora27 tmp]# virsh net-list --all
 Name                 State      Autostart     Persistent
----------------------------------------------------------
 default              active     yes           yes
 test                 active     no            yes

[root@backendcloud-fedora27 tmp]# ovs-vsctl show
0425b4a1-cfb0-4cbb-94a8-68bd581ce48e
    Bridge "br1"
        Port "br1"
            Interface "br1"
                type: internal
    ovs_version: "2.5.10"
[root@backendcloud-fedora27 tmp]# virt-install --virt-type kvm --name test-vm1 --ram 1024 --boot hd  --disk path=c1.qcow2 --network network=test,mac=52:54:00:aa:69:dd --noautoconsole --keymap=en-us
WARNING  No operating system detected, VM performance may suffer. Specify an OS with --os-variant for optimal results.

Starting install...
Domain creation completed.
[root@backendcloud-fedora27 tmp]# virt-install --virt-type kvm --name test-vm2 --ram 1024 --boot hd  --disk path=c2.qcow2 --network network=test,mac=52:54:00:aa:69:de --noautoconsole --keymap=en-us
WARNING  No operating system detected, VM performance may suffer. Specify an OS with --os-variant for optimal results.

Starting install...
Domain creation completed.
# 不加 "--keymap=en-us" kvm虚拟机会出现键盘乱码
[root@backendcloud-fedora27 tmp]# ovs-vsctl show
0425b4a1-cfb0-4cbb-94a8-68bd581ce48e
    Bridge "br1"
        Port "vnet0"
            Interface "vnet0"
        Port "br1"
            Interface "br1"
                type: internal
        Port "vnet1"
            Interface "vnet1"
    ovs_version: "2.5.10"
```

![](/images/ovs-dpdk/2022-09-22-17-33-28.png)

> 可以看出使用OVS-DPDK的虚拟机的未使用OVS-DPDK的虚拟机网络性能有明显的差距。以上都是VMWare模拟的DPDK，并非实际环境，性能数据仅供参考，但性能以外的流程逻辑是一样的。

# 参考：OVS-DPDK bond组网

> 本小节内容源自华为产品用户手册

![](2022-09-27-13-54-20.png)

```bash
ovs-vsctl add-br br-dpdk -- set bridge br-dpdk datapath_type=netdev 
ovs-vsctl add-bond br-dpdk dpdk-bond p0 p1 -- set Interface p0 type=dpdk options:dpdk-devargs=0000:05:00.0 -- set Interface p1 type=dpdk options:dpdk-devargs=0000:06:00.0 
ovs-vsctl set port dpdk-bond bond_mode=balance-tcp 
ovs-vsctl set port dpdk-bond lacp=active ifconfig br-dpdk 192.168.2.1/24 up
```

ifconfig br-dpdk 192.168.2.1/24 up这个是配置br-dpdk网桥的IP地址，用来配置VXLAN隧道。Host2上执行ifconfig br-dpdk 192.168.2.2/24 up来配对，隧道的网段和虚拟机的网段区别开来。

```bash
ovs-vsctl add-br br-int -- set bridge br-int datapath_type=netdev
ovs-vsctl add-port br-int vxlan0 -- set Interface vxlan0 type=vxlan options:local_ip=192.168.2.1 options:remote_ip=192.168.2.2
```

> 该组网下br-int上有一个VXLAN端口，出主机的流量都会加上VXLAN头。而VXLAN口的local_ip填的是本主机br-dpdk的IP地址，remote_ip是对端br-dpdk的IP地址。

```bash
ovs-vsctl add-br br-ply1 -- set bridge br-ply1 datapath_type=netdev
ovs-vsctl add-port br-ply1 tap1 -- set Interface tap1 type=dpdkvhostuserclient options:vhost-server-path=/var/run/openvswitch/tap1
ovs-vsctl add-port br-ply1 p-tap1-int -- set Interface p-tap1-int type=patch options:peer=p-tap1
ovs-vsctl add-port br-int p-tap1 -- set Interface p-tap1 type=patch options:peer=p-tap1-int
```

> 该组网每增加一个虚拟机，就增加一个br-ply网桥，该网桥上有一个dpdkvhostuser给虚拟机，patch口连到br-int网桥上。

```bash
ovs-vsctl show
```

![](2022-09-27-13-58-13.png)

验证是否和对端的br-dpdk网桥联通 ping 192.168.2.2

![](2022-09-27-13-58-34.png)

创建虚拟机。虚拟机配置需要注意内存大页、网口配置，虚拟机配置文件可以参考如下：

```xml
<domain type='kvm'> 
   <name>VM1</name> 
 <uuid>fb8eb9ff-21a7-42ad-b233-2a6e0470e0b5</uuid> 
   <memory unit='KiB'>2097152</memory> 
   <currentMemory unit='KiB'>2097152</currentMemory> 
   <memoryBacking> 
     <hugepages> 
       <page size='524288' unit='KiB' nodeset='0'/> 
     </hugepages> 
     <locked/> 
   </memoryBacking> 
   <vcpu placement='static'>4</vcpu> 
   <cputune> 
     <vcpupin vcpu='0' cpuset='6'/> 
     <vcpupin vcpu='1' cpuset='7'/> 
     <vcpupin vcpu='2' cpuset='8'/> 
     <vcpupin vcpu='3' cpuset='9'/> 
     <emulatorpin cpuset='0-3'/> 
   </cputune> 
   <numatune> 
     <memory mode='strict' nodeset='0'/> 
   </numatune> 
   <os> 
     <type arch='aarch64' machine='virt-rhel7.6.0'>hvm</type> 
     <loader readonly='yes' type='pflash'>/usr/share/AAVMF/AAVMF_CODE.fd</loader> 
     <nvram>/var/lib/libvirt/qemu/nvram/VM1_VARS.fd</nvram> 
     <boot dev='hd'/> 
   </os> 
   <features> 
     <acpi/> 
     <gic version='3'/> 
   </features> 
   <cpu mode='host-passthrough' check='none'> 
     <topology sockets='1' cores='4' threads='1'/> 
     <numa> 
       <cell id='0' cpus='0-3' memory='2097152' unit='KiB' memAccess='shared'/> 
     </numa> 
   </cpu> 
   <clock offset='utc'/> 
 <on_poweroff>destroy</on_poweroff> 
 <on_reboot>restart</on_reboot> 
   <on_crash>destroy</on_crash> 
   <devices> 
     <emulator>/usr/libexec/qemu-kvm</emulator> 
     <disk type='file' device='disk'> 
       <driver name='qemu' type='qcow2'/> 
       <source file='/home/kvm/images/1.img'/> 
       <target dev='vda' bus='virtio'/> 
       <address type='pci' domain='0x0000' bus='0x04' slot='0x00' function='0x0'/> 
     </disk> 
     <disk type='file' device='cdrom'> 
      <driver name='qemu' type='raw'/> 
       <target dev='sda' bus='scsi'/> 
       <readonly/> 
       <address type='drive' controller='0' bus='0' target='0' unit='0'/> 
     </disk> 
     <controller type='usb' index='0' model='qemu-xhci' ports='8'> 
       <address type='pci' domain='0x0000' bus='0x02' slot='0x00' function='0x0'/> 
     </controller> 
     <controller type='scsi' index='0' model='virtio-scsi'> 
       <address type='pci' domain='0x0000' bus='0x03' slot='0x00' function='0x0'/> 
     </controller> 
     <controller type='pci' index='0' model='pcie-root'/> 
     <controller type='pci' index='1' model='pcie-root-port'> 
       <model name='pcie-root-port'/> 
       <target chassis='1' port='0x8'/> 
       <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x0' multifunction='on'/> 
     </controller> 
     <controller type='pci' index='2' model='pcie-root-port'> 
       <model name='pcie-root-port'/> 
       <target chassis='2' port='0x9'/> 
       <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x1'/> 
     </controller> 
     <controller type='pci' index='3' model='pcie-root-port'> 
       <model name='pcie-root-port'/> 
       <target chassis='3' port='0xa'/> 
       <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x2'/> 
     </controller> 
     <controller type='pci' index='4' model='pcie-root-port'> 
       <model name='pcie-root-port'/> 
       <target chassis='4' port='0xb'/> 
       <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x3'/> 
     </controller> 
     <controller type='pci' index='5' model='pcie-root-port'> 
       <model name='pcie-root-port'/> 
       <target chassis='5' port='0xc'/> 
       <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x4'/> 
     </controller> 
     <interface type='vhostuser'> 
       <source type='unix' path='/var/run/openvswitch/tap1' mode='server'/> 
       <target dev='tap1'/> 
       <model type='virtio'/> 
       <driver name='vhost' queues='4' rx_queue_size='1024' tx_queue_size='1024'/> 
     </interface> 
     <serial type='pty'> 
       <target type='system-serial' port='0'> 
         <model name='pl011'/> 
       </target> 
     </serial> 
     <console type='pty'> 
       <target type='serial' port='0'/> 
     </console> 
   </devices> 
 </domain> 
 ```

 跨主机虚拟机连通性验证。Host1主机的虚拟机内验证是否和Host2主机内的虚拟机联通。ping 192.168.1.21

 ![](2022-09-27-13-59-25.png)
 