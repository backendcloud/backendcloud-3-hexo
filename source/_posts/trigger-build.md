title: gerrit触发jenkins执行脚本自动构建rpm包
date: 2017-06-28 18:17:13
categories:
- 敏捷
tags:
- gerrit
- jenkins
- 持续集成
---

持续集成包括很多，自动编译，自动打包，自动部署，自动测试。本文只涉及一部分，本文讲的是利用gerrit工具和jenkins工具在开发代码被review通过后merge到主干的时候触发rpm自动构建脚本，自动生成rpm包的过程。

搭建jenkins环境，gerrit环境

安装jenkins的gerrit trigger插件并配置gerrit信息
![1](/images/trigger-build/trigger-build-1.png)

测试连接gerrit正常
![2](/images/trigger-build/trigger-build-2.png)

配置jenkins任务
配置构建触发器，选择gerrit event
![3](/images/trigger-build/trigger-build-3.png)

配置gerrit trriger（配置git项目库，分支，merger触发）
![4](/images/trigger-build/trigger-build-4.png)

编写模块的rpm build脚本，并将脚本内容填入构建执行脚本文本框中

如guardian模块的打包脚本

    [root@promote ttt]# cat guardian_build_script.sh 
    rm -rf ./guardian
    git clone ssh://hanwei@gerrit.cmss.com:29418/EC_Openstack/guardian
    cd guardian
    git checkout kilo_dev
    python setup.py sdist
    rm -rf /root/build/*
    mkdir -p /root/build/SOURCES
    cp dist/guardian*.tar.gz guardian.conf guardian.logrotate guardian.service snmp_msg /root/build/SOURCES
    rpmbuild --bb  guardian.spec
    ls -lh /root/build/RPMS/noarch/*.rpm

修改代码，git提交commit，提交至gerrit review

gerrit review +2 后merge后，触发jenkins进行任务构建（执行该模块的rpm build脚本）

可以看到第5次构建是由gerrit triger触发进行的。
![5](/images/trigger-build/trigger-build-5.png)

并完成打包rpm，jenkins的console output输出脚本执行打印的信息。
![6](/images/trigger-build/trigger-build-6.png)
![7](/images/trigger-build/trigger-build-7.png)

jenkins在执行打包脚本可能需要root权限，默认是jenkins用户执行的。通过以下操作给jenkins用户增加root权限执行脚本。


    1.将jenkins账号分别加入到root组中
    
    gpasswd -a root jenkins
    
    2.修改/etc/sysconfig/jenkins文件中，
    
    # user id to be invoked as (otherwise will run as root; not wise!)
    JENKINS_USER=root
    JENKINS_GROUP=root
    
    可以修改为root权限运行
    
    3.重启Jenkins
    service Jenkins restart


