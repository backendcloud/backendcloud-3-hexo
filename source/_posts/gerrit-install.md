title: gerrit install
date: 2017-06-28 15:51:07
categories:
- 敏捷
tags:
- gerrit
---

![gerrit-ci](/images/gerrit-install/gerrit-ci.png)
gerrit是现在主流的代码评审工具，在code push和code merge直接加了层代码评审验证的环节，也是持续集成工具链上的重要的一个环节和工具。

gerrit部署过程如下：

安装jdk1.8
安装httpd

下载gerrit，如：gerrit-2.12.4.war

    Gerrit 2.12.4 https://www.gerritcodereview.com/download/gerrit-2.12.4.war

gerrit管理帐号

    sudo adduser gerrit
    sudo passwd gerrit

并将gerrit加入sudo权限

    sudo visudo
    gerrit  ALL=(ALL:ALL) ALL

安装gerrit

    java -jar gerrit-2.11.3.war init

启动gerrit服务

    [gerrit@promote review2]$ /etc/init.d/gerrit.sh start
    ** ERROR: GERRIT_SITE not set
    [gerrit@promote review2]$ pwd
    /home/gerrit/review2
    [gerrit@promote review2]$ /etc/init.d/gerrit.sh start
    ** ERROR: GERRIT_SITE not set
    [gerrit@promote review2]$ export GERRIT_SITE=/home/gerrit/review2
    [gerrit@promote review2]$ /etc/init.d/gerrit.sh status
    Checking arguments to Gerrit Code Review:
      GERRIT_SITE     =  /home/gerrit/review2
      GERRIT_CONFIG   =  /home/gerrit/review2/etc/gerrit.config
      GERRIT_PID      =  /home/gerrit/review2/logs/gerrit.pid
      GERRIT_TMP      =  /home/gerrit/review2/tmp
      GERRIT_WAR      =  /home/gerrit/review2/bin/gerrit.war
      GERRIT_FDS      =  1024
      GERRIT_USER     =  gerrit
      JAVA            =  /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.141-2.6.10.1.el7_3.x86_64/jre/bin/java
      JAVA_OPTIONS    =  
      RUN_EXEC        =  /usr/bin/perl -e '$x=$ENV{JAVA};exec $x @ARGV;die $!' -- GerritCodeReview
      RUN_ARGS        =  -jar /home/gerrit/review2/bin/gerrit.war daemon -d /home/gerrit/review2
    
    [gerrit@promote review2]$ /etc/init.d/gerrit.sh start
    Starting Gerrit Code Review: OK
    [root@promote etc]# cd /etc/httpd/
    [root@promote httpd]# ls
    conf  conf.d  conf.modules.d  logs  modules  run
    [root@promote httpd]# cd conf.d/
    [root@promote conf.d]# ls
    autoindex.conf  gerrit.conf  README  userdir.conf  welcome.conf

根据需要修改配置文件

    [root@promote conf.d]# vim gerrit.conf 
 
配置gerrit账户密码

    [root@promote ~]# htpasswd -m /etc/gerrit.passwd hanwei
    htpasswd: cannot modify file /etc/gerrit.passwd; use '-c' to create it
    [root@promote ~]# touch /etc/gerrit.passwd
    [root@promote ~]# htpasswd -m /etc/gerrit.passwd hanwei
    New password: 
    Re-type new password: 
    Adding password for user hanwei

打开浏览器，打开gerrit主界面，用刚刚创建的账号登录gerrit
