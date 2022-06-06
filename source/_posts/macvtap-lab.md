---
title: KubeVirt macvtap虚拟机创建过程 手动实验
readmore: true
date: 2022-06-06 18:10:42
categories: 云原生
tags:
- KubeVirt
- macvtap
- 网络
---

MACVTAP 的实现基于传统的 MACVLAN。我们会起两个libvirt容器，一个作为客户端去测试连接虚拟机，也就是左边这个。 右边会在容器中起虚拟机，容器的eth0做一个macvtap给虚拟机用，macvtap0会把收到的包都发给虚拟机的eth0
![](/images/macvtap-lab/1.png)

整个手动实验的流程大致为：
1. 创建有虚拟化工具的容器
2. 在容器中下载Openstack的常用云镜像
3. 用上一步下载的镜像在容器中启动带macvtap网口的虚拟机
4. vnc登录虚拟机检查macvtap网口的mac地址是否一致，添加容器的ip和路由信息给虚拟机
5. 登录容器，删除容器的ip和路由信息
6. 验证可以ssh登录虚拟机，虚拟机可以连接公网

```bash
# 可以自己制作镜像，下面的Dockerfile的内容：
FROM centos:7.6.1810
RUN yum install -y wget && wget https://download.qemu.org/qemu-4.0.0.tar.xz && \
    tar xvJf qemu-4.0.0.tar.xz  \
    && yum install -y automake gcc-c++ gcc make autoconf libtool gtk2-devel \
    && cd qemu-4.0.0 \
    && ./configure \
    && make -j 72 && make install \
    && yum install -y bridge-utils && yum install -y net-tools tunctl iproute && yum -y install openssh-clients \
    cd .. && rm qemu-4.0.0.tar.xz && rm -rf qemu-4.0.0
RUN yum install -y libvirt virt-manager gustfish openssh-clients    
# 可以下载现成的镜像
[root@localhost ~]# docker run -d --privileged -v /dev:/dev -v \
>     /home/fanux:/root --name qemu-vm \
>     fanux/libvirt:latest init
Unable to find image 'fanux/libvirt:latest' locally
latest: Pulling from fanux/libvirt
ac9208207ada: Pull complete 
d644e3e2db9c: Pull complete 
c331c930c5cd: Pull complete 
ff8f6f2781cf: Pull complete 
Digest: sha256:c9115f0583dfbd2efdb2864d3027f01972f3e829dcf5dfc482da8dd22bfa03b7
Status: Downloaded newer image for fanux/libvirt:latest
28462b7b8b768e1b1585bbc52ac5a9844a53d6228ce85ed8709a9e7db7259276
[root@localhost ~]# docker ps
CONTAINER ID   IMAGE                  COMMAND   CREATED          STATUS          PORTS     NAMES
28462b7b8b76   fanux/libvirt:latest   "init"    17 seconds ago   Up 16 seconds             qemu-vm
[root@localhost ~]# docker exec -it qemu-vm bash
bash-4.2# ls
anaconda-post.log  bin  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
bash-4.2# cd
bash-4.2# pwd
/root
bash-4.2# wget http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1905.qcow2
--2022-06-06 07:08:19--  http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1905.qcow2
Resolving cloud.centos.org (cloud.centos.org)... 3.137.219.52
Connecting to cloud.centos.org (cloud.centos.org)|3.137.219.52|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 941359104 (898M) [application/octet-stream]
Saving to: 'CentOS-7-x86_64-GenericCloud-1905.qcow2'

32% [========================================================================>                                                                                                                                                          ] 304,270,277 1.61MB/s  eta 5m 43s 
# 等待下载完成
```

```bash
bash-4.2# virt-customize -a CentOS-7-x86_64-GenericCloud-1905.qcow2 \
>      --root-password password:coolpass
bash: virt-customize: command not found
bash-4.2# ls
CentOS-7-x86_64-GenericCloud-1905.qcow2
bash-4.2# yum install libguestfs-tools -y
# 等待完成安装 libguestfs-tools
bash-4.2# virt-customize -a CentOS-7-x86_64-GenericCloud-1905.qcow2     --root-password password:coolpass
[   0.0] Examining the guest ...
virt-customize: error: libguestfs error: could not create appliance through 
libvirt.

Try running qemu directly without libvirt using this environment variable:
export LIBGUESTFS_BACKEND=direct

Original error from libvirt: Unable to read from 
'/sys/fs/cgroup/cpuset/docker/28462b7b8b768e1b1585bbc52ac5a9844a53d6228ce85ed8709a9e7db7259276/cpuset.cpus': 
No such file or directory [code=38 int1=2]

If reporting bugs, run virt-customize with debugging enabled and include 
the complete output:

  virt-customize -v -x [...]
bash-4.2# export LIBGUESTFS_BACKEND=direct
bash-4.2# virt-customize -a CentOS-7-x86_64-GenericCloud-1905.qcow2     --root-password password:coolpass
[   0.0] Examining the guest ...
[   5.9] Setting a random seed
[   5.9] Setting passwords
[   6.9] Finishing off
bash-4.2# ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 52:54:00:f3:91:b4 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
       valid_lft forever preferred_lft forever
3: virbr0-nic: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast master virbr0 state DOWN group default qlen 1000
    link/ether 52:54:00:f3:91:b4 brd ff:ff:ff:ff:ff:ff
4: eth0@if5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
# 配置正确镜像地址，interface的地方是macvtap相关的配置       
bash-4.2# cat vm3.xml 
<domain type='kvm'>
  <name>vm3</name>
  <memory unit='MiB'>2048</memory>
  <currentMemory unit='MiB'>2048</currentMemory>
  <os>
    <type arch='x86_64'>hvm</type>
    <boot dev='hd'/>
  </os>
  <clock offset='utc'/>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <devices>
    <emulator>/usr/libexec/qemu-kvm</emulator>
  <disk type='file' device='disk'>
       <driver name='qemu' type='qcow2'/>
       <source file='/root/CentOS-7-x86_64-GenericCloud-1905.qcow2'/>
       <target dev='vda' bus='virtio'/>
  </disk>
  <interface type='direct'> 
    <source dev='eth0' mode='bridge' /> 
    <model type='virtio' />    
    <driver name='vhost' /> 
  </interface>
  <serial type='pty'>
    <target port='0'/>
  </serial>
  <console type='pty'>
    <target type='serial' port='0'/>
  </console>
  </devices>
</domain>       
bash-4.2# virsh define vm3.xml
Domain vm3 defined from vm3.xml

bash-4.2# virsh start vm3
Domain vm3 started

bash-4.2# virsh list
 Id    Name                           State
----------------------------------------------------
 4     vm3                            running

bash-4.2# virsh console vm3
Connected to domain vm3
Escape character is ^]
[**    ] A start job is running for LSB: Bri... networking (1min 22s / 5min 6s)
```
等待超时，因为没有用libvirt的默认网络virbr0 192.168.122.1/24
```bash
bash-4.2# virsh console vm3
Connected to domain vm3
Escape character is ^]
[FAILED] Failed to start LSB: Bring up/down networking.
See 'systemctl status network.service' for details.
         Starting Initial cloud-init job (metadata service crawler)...
[  OK  ] Reached target Network.
         Starting Postfix Mail Transport Agent...
         Starting Dynamic System Tuning Daemon...
[  OK  ] Started Dynamic System Tuning Daemon.
[  311.768815] cloud-init[2214]: Cloud-init v. 18.2 running 'init' at Mon, 06 Jun 2022 08:00:13 +0000. Up 311.74 seconds.
[  311.844614] cloud-init[2214]: ci-info: +++++++++++++++++++++++++++Net device info+++++++++++++++++++++++++++
[  311.849250] cloud-init[2214]: ci-info: +--------+------+-----------+-----------+-------+-------------------+
[  311.853612] cloud-init[2214]: ci-info: | Device |  Up  |  Address  |    Mask   | Scope |     Hw-Address    |
[  311.873730] cloud-init[2214]: ci-info: +--------+------+-----------+-----------+-------+-------------------+
[  311.878685] cloud-init[2214]: ci-info: | eth0:  | True |     .     |     .     |   .   | 52:54:00:59:b9:59 |
[  311.895503] cloud-init[2214]: ci-info: | eth0:  | True |     .     |     .     |   d   | 52:54:00:59:b9:59 |
[  311.900503] cloud-init[2214]: ci-info: |  lo:   | True | 127.0.0.1 | 255.0.0.0 |   .   |         .         |
[  311.907714] cloud-init[2214]: ci-info: |  lo:   | True |     .     |     .     |   d   |         .         |
[  311.913055] cloud-init[2214]: ci-info: +--------+------+-----------+-----------+-------+-------------------+
[  OK  ] Started Postfix Mail Transport Agent.
[  312.369095] cloud-init[2214]: 2022-06-06 08:00:13,972 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [0/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  313.383786] cloud-init[2214]: 2022-06-06 08:00:14,987 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [1/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  314.386331] cloud-init[2214]: 2022-06-06 08:00:15,989 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [2/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  315.389370] cloud-init[2214]: 2022-06-06 08:00:16,992 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [3/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  316.392063] cloud-init[2214]: 2022-06-06 08:00:17,995 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [4/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  317.395670] cloud-init[2214]: 2022-06-06 08:00:18,999 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [5/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  319.397314] cloud-init[2214]: 2022-06-06 08:00:21,000 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [7/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  321.400043] cloud-init[2214]: 2022-06-06 08:00:23,003 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [9/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  323.404276] cloud-init[2214]: 2022-06-06 08:00:25,007 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [11/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  325.408253] cloud-init[2214]: 2022-06-06 08:00:27,011 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [13/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  327.420410] cloud-init[2214]: 2022-06-06 08:00:29,022 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [15/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  330.435034] cloud-init[2214]: 2022-06-06 08:00:32,038 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [18/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  333.444836] cloud-init[2214]: 2022-06-06 08:00:35,048 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [21/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  336.449530] cloud-init[2214]: 2022-06-06 08:00:38,053 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [24/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  339.455327] cloud-init[2214]: 2022-06-06 08:00:41,058 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [27/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  342.466047] cloud-init[2214]: 2022-06-06 08:00:44,069 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [30/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  346.473460] cloud-init[2214]: 2022-06-06 08:00:48,077 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [34/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  350.481009] cloud-init[2214]: 2022-06-06 08:00:52,084 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [38/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  354.486899] cloud-init[2214]: 2022-06-06 08:00:56,090 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [42/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  358.504546] cloud-init[2214]: 2022-06-06 08:01:00,107 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [46/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  362.510852] cloud-init[2214]: 2022-06-06 08:01:04,114 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [50/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  367.526887] cloud-init[2214]: 2022-06-06 08:01:09,129 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [55/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  372.534647] cloud-init[2214]: 2022-06-06 08:01:14,138 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [60/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  377.551978] cloud-init[2214]: 2022-06-06 08:01:19,155 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [65/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  382.572711] cloud-init[2214]: 2022-06-06 08:01:24,175 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [70/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  387.576323] cloud-init[2214]: 2022-06-06 08:01:29,179 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [75/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  393.584551] cloud-init[2214]: 2022-06-06 08:01:35,188 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [81/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  399.600092] cloud-init[2214]: 2022-06-06 08:01:41,203 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [87/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  405.617891] cloud-init[2214]: 2022-06-06 08:01:47,219 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [93/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  411.635755] cloud-init[2214]: 2022-06-06 08:01:53,239 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [99/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  417.653314] cloud-init[2214]: 2022-06-06 08:01:59,255 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [105/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  424.662619] cloud-init[2214]: 2022-06-06 08:02:06,266 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [112/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  431.675033] cloud-init[2214]: 2022-06-06 08:02:13,277 - url_helper.py[WARNING]: Calling 'http://169.254.169.254/2009-04-04/meta-data/instance-id' failed [119/120s]: request error [('Connection aborted.', error(101, 'Network is unreachable'))]
[  438.693254] cloud-init[2214]: 2022-06-06 08:02:20,286 - DataSourceEc2.py[CRITICAL]: Giving up on md from ['http://169.254.169.254/2009-04-04/meta-data/instance-id'] after 126 seconds
[  438.700606] cloud-init[2214]: 2022-06-06 08:02:20,303 - util.py[WARNING]: Getting data from <class 'cloudinit.sources.DataSourceCloudStack.DataSourceCloudStack'> failed
         Starting Hostname Service...
[  OK  ] Started Hostname Service.
[  OK  ] Started Initial cloud-init job (metadata service crawler).
[  OK  ] Reached target Network is Online.
         Starting Crash recovery kernel arming...
         Starting System Logging Service...
         Starting Notify NFS peers of a restart...
         Starting Permit User Sessions...
         Starting OpenSSH Server Key Generation...
[  OK  ] Reached target Cloud-config availability.
         Starting Apply the settings specified in cloud-config...
[  OK  ] Started Notify NFS peers of a restart.
[  OK  ] Started Permit User Sessions.
[  OK  ] Started Getty on tty1.
[  OK  ] Started Command Scheduler.
[  OK  ] Started Serial Getty on ttyS0.
[  OK  ] Reached target Login Prompts.
[  OK  ] Started System Logging Service.
[  439.959107] cloud-init[2417]: Cloud-init v. 18.2 running 'modules:config' at Mon, 06 Jun 2022 08:02:21 +0000. Up 439.84 seconds.
[  OK  ] Started OpenSSH Server Key Generation.
         Starting OpenSSH server daemon...
[  OK  ] Started OpenSSH server daemon.
         Stopping OpenSSH server daemon...
[  OK  ] Stopped OpenSSH server daemon.
[  OK  ] Stopped OpenSSH Server Key Generation.
         Stopping OpenSSH Server Key Generation...
         Starting OpenSSH server daemon...
[  OK  ] Started OpenSSH server daemon.
[  OK  ] Started Apply the settings specified in cloud-config.
         Starting Execute cloud user/final scripts...
[  440.418210] cloud-init[2520]: Cloud-init v. 18.2 running 'modules:final' at Mon, 06 Jun 2022 08:02:21 +0000. Up 440.37 seconds.
ci-info: no authorized ssh keys fingerprints found for user centos.
[  440.461634] cloud-init[2520]: ci-info: no authorized ssh keys fingerprints found for user centos.
ec2: 
ec2: #############################################################
ec2: -----BEGIN SSH HOST KEY FINGERPRINTS-----
ec2: 256 SHA256:+/5XwLw4GlltaTay0VpF47EwPhaOO6uzUTPPhHJI2oQ no comment (ECDSA)
ec2: 256 SHA256:chny9bN6XCMj8F5Fxq7/lgMn46T+bz110LLZg73L0x0 no comment (ED25519)
ec2: 2048 SHA256:xTd9jW+o2PXSSbgFDohzJtP9nqgQ6qYZqiordoM/s7Q no comment (RSA)
ec2: -----END SSH HOST KEY FINGERPRINTS-----
ec2: #############################################################
-----BEGIN SSH HOST KEY KEYS-----
ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNKP5FypaAJKYT+tcg7zZsNKBRpfD4bf1myBnTTbh9Tpuz+iuk35Rf3XNW5I/xmAbMSIKfFv756YVqRPXTm4LlU= 
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICUjnAmAkrGukuWLmhk3Dz62yn5tcp86VuDcQ89feupm 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEPmPaE4RbU/7pQUbnr3eCMuQhbIbqywp0xAQvX8cWb/uYJuifi3sv95AxbQ8nr6IowhYZmtOzPVLZSGOcAPFploGtKrj2Slv/DtVfnzlEASY3HrXTvswcXGjRTu1deLWC3VndqH4v359TA6L5wRzxFgd3SoM27+uZCHXdmnLM6pLhGo3JRSU4z/Lls35dgljlQHjBc6HaXJYwhkK+yAwjQPPRQxaWKs18f+jFQJ96NwPmVkwYUQs1Aviz20/GQGB9ntDH5/wbrqjfs+v8s7ab73VLwgzJbl0EG2vPvjEjw/PY8cogs0IFoMmkSbXqwd4xDCfYtmQqcsX5MuiFZFf1 
-----END SSH HOST KEY KEYS-----
[  440.556429] cloud-init[2520]: Cloud-init v. 18.2 finished at Mon, 06 Jun 2022 08:02:22 +0000. Datasource DataSourceNone.  Up 440.54 seconds
[  440.561900] cloud-init[2520]: 2022-06-06 08:02:22,157 - cc_final_message.py[WARNING]: Used fallback datasource
[  OK  ] Started Execute cloud user/final scripts.
[  OK  ] Reached target Multi-User System.
         Starting Update UTMP about System Runlevel Changes...
[  OK  ] Started Update UTMP about System Runlevel Changes.

CentOS Linux 7 (Core)
Kernel 3.10.0-957.12.2.el7.x86_64 on an x86_64

localhost login: 
```
用上面设置的镜像root密码：coolpass  登录虚拟机
```bash
[root@localhost ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:59:b9:59 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::5054:ff:fe59:b959/64 scope link 
       valid_lft forever preferred_lft forever
[root@localhost ~]# 
```
发现虚拟机的网口eth0，和容器的网口macvtap0@eth0的mac地址相同，都是52:54:00:59:b9:59，这是由macvtap机制决定的。
```bash
[root@localhost ~]# docker exec -it qemu-vm bash
bash-4.2# ip r
default via 172.17.0.1 dev eth0 
172.17.0.0/16 dev eth0 proto kernel scope link src 172.17.0.2 
192.168.122.0/24 dev virbr0 proto kernel scope link src 192.168.122.1 
bash-4.2# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 52:54:00:f3:91:b4 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
       valid_lft forever preferred_lft forever
3: virbr0-nic: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast master virbr0 state DOWN group default qlen 1000
    link/ether 52:54:00:f3:91:b4 brd ff:ff:ff:ff:ff:ff
4: eth0@if5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
6: macvtap0@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 500
    link/ether 52:54:00:59:b9:59 brd ff:ff:ff:ff:ff:ff
```
继续登录宿主机的容器中的虚拟机操作
```bash
# 刚启动完虚拟机是没有IP地址的，需要我们进行配置，配置和容器一样的ip地址
[root@localhost ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:59:b9:59 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::5054:ff:fe59:b959/64 scope link 
       valid_lft forever preferred_lft forever
[root@localhost ~]# ip r
[root@localhost ~]# ip addr add 172.17.0.2/16 dev eth0
[root@localhost ~]# ip route add default via 172.17.0.1 dev eth0
[root@localhost ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:59:b9:59 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.2/16 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe59:b959/64 scope link 
       valid_lft forever preferred_lft forever
[root@localhost ~]# ip r
default via 172.17.0.1 dev eth0 
172.17.0.0/16 dev eth0 proto kernel scope link src 172.17.0.2 
[root@localhost ~]# ping 172.17.0.1
PING 172.17.0.1 (172.17.0.1) 56(84) bytes of data.
64 bytes from 172.17.0.1: icmp_seq=1 ttl=64 time=1.18 ms
64 bytes from 172.17.0.1: icmp_seq=2 ttl=64 time=0.888 ms
64 bytes from 172.17.0.1: icmp_seq=3 ttl=64 time=0.222 ms

--- 172.17.0.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2005ms
rtt min/avg/max/mdev = 0.222/0.764/1.184/0.403 ms
[root@localhost ~]# vi /etc/resolv.conf
[root@localhost ~]# cat /etc/resolv.conf
; Created by cloud-init on instance boot automatically, do not edit.
;
# Generated by NetworkManager
nameserver 114.114.114.114
[root@localhost ~]# vi /etc/ssh/sshd_config
# 修改/etc/ssh/sshd-config文件，将其中的PermitRootLogin no修改为yes，PubkeyAuthentication yes修改为no，AuthorizedKeysFile .ssh/authorized_keys前面加上#屏蔽掉，PasswordAuthentication no修改为yes就可以了
# 启动ssh客户端容器
[root@localhost ~]# docker run --rm -it fanux/libvirt bash
[root@eafdef6e7d92 /]# ssh root@172.17.0.2
ssh: connect to host 172.17.0.2 port 22: Connection refused
[root@eafdef6e7d92 /]# 
# 会发现不通, 这是因为容器里的eth0和虚拟机里的eth0都配置了相同的地址导致，只需要把容器里的eth0地址删掉即可
[root@localhost ~]# docker exec -it qemu-vm bash
bash-4.2# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 52:54:00:f3:91:b4 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
       valid_lft forever preferred_lft forever
3: virbr0-nic: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast master virbr0 state DOWN group default qlen 1000
    link/ether 52:54:00:f3:91:b4 brd ff:ff:ff:ff:ff:ff
4: eth0@if5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
6: macvtap0@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 500
    link/ether 52:54:00:59:b9:59 brd ff:ff:ff:ff:ff:ff
bash-4.2# ip addr del 172.17.0.2/16 dev eth0
bash-4.2# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 52:54:00:f3:91:b4 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
       valid_lft forever preferred_lft forever
3: virbr0-nic: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast master virbr0 state DOWN group default qlen 1000
    link/ether 52:54:00:f3:91:b4 brd ff:ff:ff:ff:ff:ff
4: eth0@if5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
6: macvtap0@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 500
    link/ether 52:54:00:59:b9:59 brd ff:ff:ff:ff:ff:ff
bash-4.2# 
# 再次ssh即可进入虚拟机：
[root@eafdef6e7d92 /]# ssh root@172.17.0.2
The authenticity of host '172.17.0.2 (172.17.0.2)' can't be established.
ECDSA key fingerprint is SHA256:+/5XwLw4GlltaTay0VpF47EwPhaOO6uzUTPPhHJI2oQ.
ECDSA key fingerprint is MD5:d0:b9:38:1d:9b:78:97:59:42:47:8e:e8:66:1b:53:0b.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '172.17.0.2' (ECDSA) to the list of known hosts.
Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
[root@eafdef6e7d92 /]# ssh root@172.17.0.2
Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
[root@eafdef6e7d92 /]# 
# PasswordAuthentication这个字段为"no"的缘故。之前明明改过了，应该是忘记重启sshd了，进入虚拟机，执行service sshd restart，成功登录虚拟机
[root@eafdef6e7d92 /]# ssh root@172.17.0.2
root@172.17.0.2's password: 
Last login: Mon Jun  6 08:06:25 2022
[root@localhost ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:59:b9:59 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.2/16 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe59:b959/64 scope link 
       valid_lft forever preferred_lft forever
# 修改虚拟机mac地址
[root@localhost ~]# ip link set eth0 address 52:54:00:56:e4:23    
# 会发现就连不上虚拟机了
# 改回：
[root@localhost ~]# ip link set eth0 address 52:54:00:59:b9:59
```
又可正常连接了，为啥？

这是因为虚拟机的eth0的mac地址是必须与macvtap0@eth0的mac地址保持一样，原理很简单
1. ARP时问IP地址是172.17.0.2的机器mac地址是什么
2. 虚拟机回了一个52:54:00:59:b9:59
3. macvtap0@eth0是可以理解成挂在网桥端口上的，这样就把包发给macvtap0@eth0了（因为mac地址一样,不一样就不会发给macvtap0@eth0了）
4. macvtap0@eth0就把包丢给qemu应用进程（最终到虚拟机eth0）

支持完成macvtap实验，容器可以登录虚拟机，宿主机可以登录虚拟机

    [root@localhost ~]# ssh root@172.17.0.2
    root@172.17.0.2's password:
    Last login: Mon Jun  6 08:35:36 2022 from gateway
    [root@localhost ~]#

虚拟机可以访问公网

    [root@localhost ~]# curl www.backendcloud.cn
    <html>
    <head><title>301 Moved Permanently</title></head>
    <body bgcolor="white">
    <center><h1>301 Moved Permanently</h1></center>
    <hr><center>nginx/1.6.3</center>
    </body>
    </html>
    [root@localhost ~]# 

> 该容器就是KubeVirt中的virt-lancher容器，该实验将KubeVirt的网站的虚拟机创建流程手动走了一遍。

裸用qemu

以上是通过libvirt进行使用的，这样屏蔽了很多底层的细节，如果是直接使用qemu命令需要如下操作：

创建macvtap设备：

    ip link add link eth0 name macvtap0 type macvtap mode bridge
    ip link set macvtap0 address 1a:46:0b:ca:bc:7b up
    bash-4.2# cat /sys/class/net/macvtap0/ifindex  # 对应下面命令的/dev/tap2
    2
    bash-4.2# cat /sys/class/net/macvtap0/address # 与qemu mac地址配置一致
    1a:46:0b:ca:bc:7b

启动qemu,然后虚拟机里面的地址配置同libvirt，可以通过vnc客户端（vnc viewer）进入虚拟机配置，不在赘述:

    bash-4.2# qemu-system-x86_64 -enable-kvm /root/CentOS-7-x86_64-GenericCloud.qcow2\
    -netdev tap,fd=30,id=hostnet0,vhost=on,vhostfd=4 30<>/dev/tap2 4<>/dev/vhost-net \
    -device virtio-net-pci,netdev=hostnet0,id=net0,mac=1a:46:0b:ca:bc:7b   \
    -monitor telnet:127.0.0.1:5801,server,nowait
    VNC server running on ::1:5900