title: Load Balance(LVS实现方式)					
date: 2016-07-05 23:10:25
categories: Openstack_op
tags:
  - Load Balance
  - LVS
---

# 网络拓扑图

![网络拓扑图](/images/lb/stucture.jpg)



# 配置vm网络

1 生成上图所示的虚拟机
2 设定各个VM的 网卡的配置文件
3 建两个网桥，如上图所示，并在网桥上绑定对应的网卡

网卡①

    [root@localhost network-scripts]# cat ifcfg-eth0
    DEVICE=eth0
    TYPE=Ethernet
    ONBOOT=yes
    BOOTPROTO=static
    IPADDR=192.168.124.180
    NETMASK=255.255.255.0


网卡②

    [root@localhost network-scripts]# cat ifcfg-ens0
    HWADDR="52:54:00:64:59:6D"
    TYPE="Ethernet"
    BOOTPROTO="static"
    NAME="ens0"
    UUID="bace60bc-e8d3-4269-9136-7fc507e8bbfb"
    ONBOOT="yes"
    IPADDR="192.168.124.185"
    NETMASK="255.255.255.0"


网卡③

    [root@localhost network-scripts]# cat ifcfg-ens1
    HWADDR="52:54:00:4B:D1:62"
    TYPE="Ethernet"
    BOOTPROTO="static"
    NAME="ens1"
    UUID="ce9ffcff-aa00-42b4-a4b7-194d158afa5f"
    ONBOOT="yes"
    IPADDR="192.168.125.2"
    NETMASK="255.255.255.0"


网卡④

    [root@localhost network-scripts]# cat ifcfg-ens0
    TYPE="Ethernet"
    BOOTPROTO="static"
    ONBOOT="yes"
    IPADDR="192.168.125.3"
    NETMASK="255.255.255.0"
    GATEWAY="192.168.125.2"


网卡⑤

    [root@localhost network-scripts]# cat ifcfg-ens0
    TYPE="Ethernet"
    BOOTPROTO="static"
    ONBOOT="yes"
    IPADDR="192.168.125.4"
    NETMASK="255.255.255.0"
    GATEWAY="192.168.125.2"


网卡⑥

    [root@localhost network-scripts]# cat ifcfg-ens0
    TYPE="Ethernet"
    BOOTPROTO="static"
    ONBOOT="yes"
    IPADDR="192.168.125.5"
    NETMASK="255.255.255.0"
    GATEWAY="192.168.125.2"



# 安装LVS

    [root@localhost ~]# yum install ipvsadm
    Loaded plugins: fastestmirror
    Loading mirror speeds from cached hostfile
    Resolving Dependencies
    --> Running transaction check
    ---> Package ipvsadm.x86_64 0:1.27-4.el7 will be installed
    --> Finished Dependency Resolution
    
    Dependencies Resolved
    
    ================================================================================
     Package          Arch            Version               Repository         Size
    ================================================================================
    Installing:
     ipvsadm          x86_64          1.27-4.el7            c6-media           44 k
    
    Transaction Summary
    ================================================================================
    Install  1 Package
    
    Total download size: 44 k
    Installed size: 75 k
    Is this ok [y/d/N]: y
    Downloading packages:
    Running transaction check
    Running transaction test
    Transaction test succeeded
    Running transaction
      Installing : ipvsadm-1.27-4.el7.x86_64                                    1/1 
      Verifying  : ipvsadm-1.27-4.el7.x86_64                                    1/1 
    
    Installed:
      ipvsadm.x86_64 0:1.27-4.el7                                                   
    
    Complete!



# 设定

SSH VM:director

    [root@localhost network-scripts]# ipvsadm -A -t 192.168.124.185:80 -s rr
    [root@localhost network-scripts]# ipvsadm -a -t 192.168.124.185:80 -r 192.168.125.3:80 -m
    [root@localhost network-scripts]# ipvsadm -a -t 192.168.124.185:80 -r 192.168.125.4:80 -m
    [root@localhost network-scripts]# echo 1 > /proc/sys/net/ipv4/ip_forward
    [root@localhost network-scripts]# systemctl stop firewalld.service
    [root@localhost network-scripts]# setenforce 0


SSH VM:node3(4,5,…)

    [root@localhost ~]# systemctl stop firewalld.service
    [root@localhost ~]# setenforce 0
    [root@localhost ~]# systemctl start httpd.service
    [root@localhost ~]# echo node3(3,5,…)_html > /var/www/html/index.html
    [root@localhost ~]# curl localhost
    node3(4,5,…)_html



# 负载均衡结果确认

最后SSH VM:client发现负载被均匀的分发到各个node上

    [root@localhost ~]# curl 192.168.124.185
    node3_html
    [root@localhost ~]# curl 192.168.124.185
    node4_html
    [root@localhost ~]# curl 192.168.124.185
    node3_html
    [root@localhost ~]# curl 192.168.124.185
    node4_html



# 抓包截图

![抓包截图](/images/lb/zhuabao.jpg)
