title: Openstack Pike本地yum源搭建
date: 2017-12-28 22:20:40
categories:
- Openstack_op
tags:
- yum
---
在部署Openstack的时候，可能环境受限，不能连接外网，这时候需要通过本地yum源完成安装。

以Pike版，Centos平台为例，说明如何一步步搭建本地yum源。

# 先安装httpd

    yum install httpd

除了apache httpd外，也可以安装nginx

并开启httpd服务

# 配置远程yum源

国外源往往不稳定，速度不够快，国内阿里镜像比较稳定。第四行删除阿里内网地址
<!-- more -->

    rm -f /etc/yum.repos.d/*
    curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
    sed -i '/aliyuncs.com/d' /etc/yum.repos.d/*.repo

配置Openstack Pike源

vim /etc/yum.repos.d/Ali-pike.repo

    [Aliyun-pike]
    name=Aliyun-pike
    baseurl=https://mirrors.aliyun.com/centos/$releasever/cloud/$basearch/openstack-pike/
    gpgcheck=0
    enabled=1
    cost=88
    
    [Aliyun-qemu-ev]
    name=Aliyun-qemu-ev
    baseurl=https://mirrors.aliyun.com/centos/$releasever/virt/$basearch/kvm-common/
    https://mirrors.aliyun.com/centos
    gpgcheck=0
    enabled=1


# 同步rpm包仓库

    [root@localhost ~]# yum makecache
    [root@localhost ~]# mkdir /usr/local/nginx/html/pike
    [root@localhost pike]# cd /usr/local/nginx/html/pike
    [root@localhost pike]# yum repolist
    Loaded plugins: fastestmirror
    Loading mirror speeds from cached hostfile
    repo id                                                                                                                 repo name                                                                                                                                       status
    Aliyun-pike/7/x86_64                                                                                                    Aliyun-pike                                                                                                                                      2,195
    Aliyun-qemu-ev/7/x86_64                                                                                                 Aliyun-qemu-ev                                                                                                                                      39
    base/7/x86_64                                                                                                           CentOS-7 - Base - mirrors.aliyun.com                                                                                                             9,591
    epel/x86_64                                                                                                             Extra Packages for Enterprise Linux 7 - x86_64                                                                                                  12,184
    extras/7/x86_64                                                                                                         CentOS-7 - Extras - mirrors.aliyun.com                                                                                                             327
    updates/7/x86_64                                                                                                        CentOS-7 - Updates - mirrors.aliyun.com                                                                                                          1,573
    repolist: 25,909
    [root@localhost pike]# reposync --repoid=Aliyun-pike
    (1/2195): GitPython-1.0.1-5.el7.noarch.rpm                                                                                                                                                                                                             | 501 kB  00:00:00     
    (2/2195): PyQt4-devel-4.12-1.el7.x86_64.rpm                                                                                                                                                                                                            | 419 kB  00:00:00     
    (3/2195): PyQt4-4.12-1.el7.x86_64.rpm                                                                                                                                                                                                                  | 2.9 MB  00:00:00     
    (4/2195): PyQt4-qsci-api-4.12-1.el7.x86_64.rpm                                                                                                                                                                                                         | 156 kB  00:00:00     
    (5/2195): XStatic-Angular-common-1.5.8.0-1.el7.noarch.rpm                                                                                                                                                                                              | 455 kB  00:00:00     
    ...
    (2195/2195): zeromq-4.0.5-4.el7.x86_64.rpm                                                                                                                                                                                                             | 434 kB  00:00:00     
    [root@localhost pike]# reposync --repoid=Aliyun-qemu-ev
    (1/39): centos-release-qemu-ev-1.0-1.el7.noarch.rpm                                                                                                                                                                                                    |  10 kB  00:00:00     
    (2/39): gperftools-2.4-7.el7.x86_64.rpm                                                                                                                                                                                                                | 3.0 kB  00:00:00     
    (3/39): OVMF-20150414-2.gitc9e5618.el7.noarch.rpm                                                                                                                                                                                                      | 1.3 MB  00:00:00     
    ...
    (39/39): qemu-kvm-tools-ev-2.9.0-16.el7_4.8.1.x86_64.rpm                                                                                                                                                                                               | 320 kB  00:00:05     

# 创建清单

现在目录/usr/local/nginx/html/pike只有软件包，没有repodate清单，所以需要重新createrepo来创建清单

    [root@localhost pike]# pwd
    /usr/local/nginx/html/pike
    [root@localhost pike]# createrepo /usr/local/nginx/html/pike
    -bash: createrepo: command not found
    [root@localhost pike]# yum install createrepo
    Loaded plugins: fastestmirror
    Loading mirror speeds from cached hostfile
    Resolving Dependencies
    --> Running transaction check
    ---> Package createrepo.noarch 0:0.9.9-28.el7 will be installed
    --> Processing Dependency: python-deltarpm for package: createrepo-0.9.9-28.el7.noarch
    --> Processing Dependency: deltarpm for package: createrepo-0.9.9-28.el7.noarch
    --> Running transaction check
    ---> Package deltarpm.x86_64 0:3.6-3.el7 will be installed
    ---> Package python-deltarpm.x86_64 0:3.6-3.el7 will be installed
    --> Finished Dependency Resolution
    Dependencies Resolved
    ==============================================================================================================================================================================================================================================================================
     Package                                                                Arch                                                          Version                                                               Repository                                                   Size
    ==============================================================================================================================================================================================================================================================================
    Installing:
     createrepo                                                             noarch                                                        0.9.9-28.el7                                                          base                                                         94 k
    Installing for dependencies:
     deltarpm                                                               x86_64                                                        3.6-3.el7                                                             base                                                         82 k
     python-deltarpm                                                        x86_64                                                        3.6-3.el7                                                             base                                                         31 k
    Transaction Summary
    ==============================================================================================================================================================================================================================================================================
    Install  1 Package (+2 Dependent packages)
    Total download size: 207 k
    Installed size: 558 k
    Is this ok [y/d/N]: y
    Downloading packages:
    (1/3): deltarpm-3.6-3.el7.x86_64.rpm                                                                                                                                                                                                                   |  82 kB  00:00:00     
    (2/3): createrepo-0.9.9-28.el7.noarch.rpm                                                                                                                                                                                                              |  94 kB  00:00:00     
    (3/3): python-deltarpm-3.6-3.el7.x86_64.rpm                                                                                                                                                                                                            |  31 kB  00:00:00     
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Total                                                                                                                                                                                                                                         446 kB/s | 207 kB  00:00:00     
    Running transaction check
    Running transaction test
    Transaction test succeeded
    Running transaction
      Installing : deltarpm-3.6-3.el7.x86_64                                                                                                                                                                                                                                  1/3 
      Installing : python-deltarpm-3.6-3.el7.x86_64                                                                                                                                                                                                                           2/3 
      Installing : createrepo-0.9.9-28.el7.noarch                                                                                                                                                                                                                             3/3 
      Verifying  : createrepo-0.9.9-28.el7.noarch                                                                                                                                                                                                                             1/3 
      Verifying  : deltarpm-3.6-3.el7.x86_64                                                                                                                                                                                                                                  2/3 
      Verifying  : python-deltarpm-3.6-3.el7.x86_64                                                                                                                                                                                                                           3/3 
    Installed:
      createrepo.noarch 0:0.9.9-28.el7                                                                                                                                                                                                                                            
    Dependency Installed:
      deltarpm.x86_64 0:3.6-3.el7                                                                                                        python-deltarpm.x86_64 0:3.6-3.el7                                                                                                       
    Complete!
    [root@localhost pike]# createrepo /usr/local/nginx/html/pike
    Spawning worker 0 with 559 pkgs
    Spawning worker 1 with 559 pkgs
    Spawning worker 2 with 558 pkgs
    Spawning worker 3 with 558 pkgs
    Workers Finished
    Saving Primary metadata
    Saving file lists metadata
    Saving other metadata
    Generating sqlite DBs
    Sqlite DBs complete

# 配置本地yum源

例如控制节点yum源配置

vim /etc/yum.repos.d/openstack.repo

    [openstack]
    name=openstack
    baseurl=http://192.168.206.146/pike
    enabled=1
    gpgcheck=0

192.168.206.146是之前同步的本地yum源的ip地址

yum makecache

其他节点一样。
