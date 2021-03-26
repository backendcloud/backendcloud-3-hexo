title: 部署实时OpenStack实例
date: 2018-01-23 16:28:28
categories:
- NFV
tags:
- RT
---



最近的OpenStack nova版本增加了对实时实例的支持，即提供实时应用所需的确定性和性能保证的实例。这项工作在OpenStack Ocata发行版中最终标记为完成。

# HOST BIOS配置

最重要的步骤是：

* 禁用电源管理，包括CPU睡眠状态
* 禁用超线程或与逻辑处理器相关的任何选项

这些是benchmarking中使用的标准步骤，否则都可能导致非确定性行为。



# HOST配置

## 安装 CentOS 7
## 添加 RT repo

<!-- more -->

    $ echo << EOF > /etc/yum.repos.d/CentOS-RT.repo
    # CentOS-RT.repo
    #
    # The Real Time (RT) repository.
    #
    
    [rt]
    name=CentOS-$releasever - rt
    baseurl=http://mirror.centos.org/centos/$releasever/rt/$basearch/
    gpgcheck=1
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
    enabled=1
    EOF
    
    $ sudo yum update -y
    $ wget http://linuxsoft.cern.ch/cern/centos/7/rt/CentOS-RT.repo /etc/yum.repos.d/CentOS-RT.repo
    $ wget http://linuxsoft.cern.ch/cern/centos/7/os/x86_64/RPM-GPG-KEY-cern /etc/pki/rpm-gpg/RPM-GPG-KEY-cern
    $ sudo yum groupinstall RT


## 安装dependencies

    $ yum remove tuned
    $ yum install -y tuned-2.7.1-5.el7
    $ yum install -y centos-release-qemu-ev
    $ yum install -y tuned-profiles-realtime tuned-profiles-nfv
    $ yum install -y kernel-rt.x86_64 kernel-rt-kvm.x86_64

## 配置realtime profile

    $ lscpu | grep ^NUMA
    NUMA node(s):          2
    NUMA node0 CPU(s):     0,2,4,6,8,10
    NUMA node1 CPU(s):     1,3,5,7,9,11
    $ echo "isolated_cores=4-11" >> /etc/tuned/realtime-virtual-host-variables.conf

## load realtime profile

    $ systemctl enable tuned
    $ systemctl start tuned
    $ tuned-adm profile realtime-virtual-host
    $ grep tuned_params= /boot/grub2/grub.cfg
    set tuned_params="isolcpus=4-11 nohz=on nohz_full=4-11 intel_pstate=disable nosoftlockup"

## 配置大页内存

添加
default_hugepagesz=1G
到
/etc/default/grub

    $ grub2-mkconfig -o /boot/grub2/grub.cfg
    Generating grub configuration file ...
    Found linux image: /boot/vmlinuz-3.10.0-327.13.1.el7.x86_64
    done
    $ echo 4 > /sys/devices/system/node/node0/hugepages/hugepages-1048576kB/nr_hugepages
    $ echo 4 > /sys/devices/system/node/node1/hugepages/hugepages-1048576kB/nr_hugepages
    $ cat << EOF > /usr/lib/systemd/system/hugetlb-gigantic-pages.service
    [Unit]
    Description=HugeTLB Gigantic Pages Reservation
    DefaultDependencies=no
    Before=dev-hugepages.mount
    ConditionPathExists=/sys/devices/system/node
    ConditionKernelCommandLine=hugepagesz=1G
    
    [Service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=/usr/lib/systemd/hugetlb-reserve-pages
    
    [Install]
    WantedBy=sysinit.target
    EOF
    
    $ cat << EOF > /usr/lib/systemd/hugetlb-reserve-pages
    #!/bin/bash
    
    nodes_path=/sys/devices/system/node/
    if [ ! -d $nodes_path ]; then
      echo "ERROR: $nodes_path does not exist"
      exit 1
    fi
    
    reserve_pages()
    {
      echo $1 > $nodes_path/$2/hugepages/hugepages-1048576kB/nr_hugepages
    }
    
    reserve_pages 4 node0
    reserve_pages 4 node1
    EOF
    
    $ chmod +x /usr/lib/systemd/hugetlb-reserve-pages
    $ systemctl enable hugetlb-gigantic-pages

## reboot host

## Verify

    $ tuned-adm active
    Current active profile: realtime-virtual-host
    
    $ cat /proc/cmdline
    BOOT_IMAGE=/vmlinuz-3.10.0-327.18.2.rt56.223.el7_2.x86_64 root=/dev/mapper/rhel_virtlab502-root ro crashkernel=auto rd.lvm.lv=rhel_virtlab502/root rd.lvm.lv=rhel_virtlab502/swap console=ttyS1,115200 default_hugepagesz=1G isolcpus=3,5,7 nohz=on nohz_full=3,5,7 intel_pstate=disable nosoftlockup
    
    $ cat /sys/module/kvm/parameters/lapic_timer_advance_ns
    1000  # this should be a non-0 value
    
    $ cat /sys/devices/system/node/node0/hugepages/hugepages-1048576kB/nr_hugepages
    4
    $ cat /sys/devices/system/node/node1/hugepages/hugepages-1048576kB/nr_hugepages
    4
    
    $ yum install -y rt-tests
    
    $ hwlatdetect
          hwlatdetect:  test duration 120 seconds
       parameters:
            Latency threshold: 10us
            Sample window:     1000000us
            Sample width:      500000us
         Non-sampling period:  500000us
            Output File:       None
    
    Starting test
    test finished
    Max Latency: 0us
    Samples recorded: 0
    Samples exceeding threshold: 0
    
    $ yum install rteval
    
    $ rteval --onlyload --duration=4h --verbose


# Guest配置

## eneble rt repo

    $ echo << EOF > /etc/yum.repos.d/CentOS-RT.repo
    # CentOS-RT.repo
    #
    # The Real Time (RT) repository.
    #
    
    [rt]
    name=CentOS-$releasever - rt
    baseurl=http://mirror.centos.org/centos/$releasever/rt/$basearch/
    gpgcheck=1
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
    enabled=1
    EOF
    
    $ sudo yum update -y

## 安装dependencies

    $ yum remove tuned
    $ yum install -y tuned-2.7.1-5.el7
    $ yum install -y centos-release-qemu-ev
    $ yum install -y tuned-profiles-realtime tuned-profiles-nfv
    $ yum install -y kernel-rt.x86_64

## Configure the realtime profile

    $ echo "isolated_cores=2,3" >> /etc/tuned/realtime-virtual-guest-variables.conf

## Load the realtime profile

    $ systemctl enable tuned
    $ systemctl start tuned
    $ tuned-adm profile realtime-virtual-guest
    $ grep tuned_params= /boot/grub2/grub.cfg set 
    tuned_params="isolcpus=2,3 nohz=on nohz_full=2,3 rcu_nocbs=2,3 intel_pstate=disable nosoftlockup"

## 配置大页内存

添加
default_hugepagesz=1G
到
/etc/default/grub

    $ grub2-mkconfig -o /boot/grub2/grub.cfg
    Generating grub configuration file ...
    Found linux image: /boot/vmlinuz-3.10.0-327.13.1.el7.x86_64
    done

## 安装testing dependencies

    $ yum install -y epel-release
    $ yum install -y rt-tests stress

## Reboot the guest to apply changes

## Verify the changes have been applied

    $ tuned-adm active
    Current active profile: realtime-virtual-guest
    
    $ uname -a
    Linux guest.localdomain 3.10.0-693.2.2.rt56.623.el7.x86_64 #1 SMP PREEMPT RT Sun Jan 01 00:00:00 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
    
    $ cat /proc/cmdline
    BOOT_IMAGE=/vmlinuz-3.10.0-693.2.2.rt56.623.el7.x86_64 root=/dev/mapper/centos-root ro rd.lvm.lv=centos/root rd.lvm.lv=centos/swap console=ttyS0,115200n8 default_hugepagesz=1G isolcpus=2,3 nohz=on nohz_full=2,3 rcu_nocbs=2,3 intel_pstate=disable nosoftlockup

## Install OpenStack-specific dependencies

    $ yum install -y acpid
    $ systemctl enable acpid
    $ yum install -y cloud-init cloud-utils-growpart
    $ echo "NOZEROCONF=yes" >> /etc/sysconfig/network
    $ poweroff

## Clean up the image

    centos7: vm name
    $ sudo virt-sysprep -d centos7
    $ sudo virsh undefine centos7
    $ sudo qemu-img convert -O qcow2 -c centos7.qcow2 centos7-small.qcow2

# Nova 配置
首先安装openstack

## Configure flavor

    $ openstack flavor create --vcpus 4 --ram 4096 --disk 20 rt1.small
    $ openstack flavor set rt1.small \
        --property 'hw:cpu_policy=dedicated' \
        --property 'hw:cpu_realtime=yes' \
        --property 'hw:cpu_realtime_mask=^0-1' \
        --property 'hw:mem_page_size=1GB'
    By way of an explanation, these various properties correspond to the following.
    
    hw:cpu_policy=dedicated
    This indicates that instances must have exclusive pCPUs assigned to them.
    
    hw:cpu_realtime=yes
    This indicates that instances will have a real-time policy.
    
    hw:cpu_realtime_mask="^0-1"
    This indicates that all instance vCPUs except vCPUs 0 and 1 will have a real-time policy.
    
    hw:mem_page_size=1GB
    This indicates that instances will have a sole 1 GB huge page assigned to them.

## Configure image

    $ openstack image create --disk-format qcow2 --container-format bare \
        --public --file ./centos-small.qcow2 centos-rt

## Configure security groups and keypairs

    $ echo OS_PROJECT_NAME
    demo
    $ openstack project list | grep -w demo
    | f5a2496e6edf4ef4b5ffe62b01a8bf4b | demo               |
    $ openstack security group list | grep -w f5a2496e6edf4ef4b5ffe62b01a8bf4b
    | 466ffc5e-114d-43a4-8854-db490c6b4571 | default | Default security group | f5a2496e6edf4ef4b5ffe62b01a8bf4b |
    
    $ openstack security group rule create --proto icmp \
        466ffc5e-114d-43a4-8854-db490c6b4571
    $ openstack security group rule create --proto tcp --dst-port 22 \
        466ffc5e-114d-43a4-8854-db490c6b4571
    In addition, we want to create a keypair so we can ssh into the instance.
    
    $ openstack keypair create --public-key .ssh/id_rsa.pub default-key

# 测试

    $ openstack server create --flavor rt1.small --image centos-rt \
        --key-name default-key rt-server

若报以下错误：Could not access KVM kernel module: Permission denied failed to initialize KVM: Permission denied

    $ sudo rmmod kvm_intel
    $ sudo rmmod kvm
    $ sudo modprobe kvm
    $ sudo modprobe kvm_intel

ssh to guest

    $ openstack server ssh rt-server --login centos

Run cyclictest to confirm expected latencies

    $ taskset -c 2 stress --cpu 4
    $ taskset -c 2 cyclictest -m -n -q -p95 -D 24h -h100 -i 200 > cyclictest.out

