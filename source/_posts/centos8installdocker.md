title: "CentOS 8.0 安装docker 报错：Problem: package docker-ce-3:19.03.8-3.el7.x86_64 requires containerd.io >= 1.2.2-3"
date: 2020-03-16 16:04:21
categories:
- 容器
tags:
- docker
- centos8

---

CentOS 8.0 安装docker 报错：Problem: package docker-ce-3:19.03.8-3.el7.x86_64 requires containerd.io >= 1.2.2-3

安装步骤参考官方文档：
https://docs.docker.com/install/linux/docker-ce/centos/

卸载旧版本

    [root@localhost ~]# remove docker \
                      docker-client \
                      docker-client-latest \
                      docker-common \
                      docker-latest \
                      docker-latest-logrotate \
                      docker-logrotate \
                      docker-engine

安装社区版Docker Engine

    [root@localhost ~]# yum install -y yum-utils \
      device-mapper-persistent-data \
      lvm2
    [root@localhost ~]# sudo yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
    [root@localhost ~]# yum-config-manager --enable docker-ce-nightly
    [root@localhost ~]# yum-config-manager --enable docker-ce-test
    [root@localhost ~]# yum-config-manager --enable docker-ce-test
    [root@localhost ~]# yum-config-manager --disable docker-ce-nightly
    [root@localhost ~]# yum install docker-ce docker-ce-cli containerd.io
    # 安装这一步报错

<!--more-->
报错内容

    [root@localhost yum.repos.d]# yum install docker-ce docker-ce-cli containerd.io
    Last metadata expiration check: 0:04:46 ago on Mon 16 Mar 2020 03:40:11 PM CST.
    Package containerd.io-1.2.0-3.el7.x86_64 is already installed.
    Error:
     Problem: package docker-ce-3:19.03.8-3.el7.x86_64 requires containerd.io >= 1.2.2-3, but none of the providers can be installed
      - cannot install the best candidate for the job
      - package containerd.io-1.2.10-3.2.el7.x86_64 is excluded
      - package containerd.io-1.2.13-3.1.el7.x86_64 is excluded
      - package containerd.io-1.2.2-3.3.el7.x86_64 is excluded
      - package containerd.io-1.2.2-3.el7.x86_64 is excluded
      - package containerd.io-1.2.4-3.1.el7.x86_64 is excluded
      - package containerd.io-1.2.5-3.1.el7.x86_64 is excluded
      - package containerd.io-1.2.6-3.3.el7.x86_64 is excluded
      - package containerd.io-1.2.11-3.2.el7.x86_64 is excluded
      - package containerd.io-1.2.12-3.1.el7.x86_64 is excluded
      - package containerd.io-1.2.6-3.2.el7.x86_64 is excluded
    (try to add '--skip-broken' to skip uninstallable packages or '--nobest' to use not only best candidate packages)

分析原因
看上面的内容，说的是containerd.io >= 1.2.2-3 ，意思就是 containerd.io 的版本必须大于等于 1.2.2-3

解决
1、要么就降低docker 的版本
2、如果不想降低docker 版本，那么就更新 containerd.io 的版本

    [root@localhost ~]# yum install -y wget
    [root@localhost ~]# wget https://download.docker.com/linux/centos/7/x86_64/edge/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
    [root@localhost ~]# yum install -y  containerd.io-1.2.6-3.3.el7.x86_64.rpm
    [root@localhost ~]# yum install docker-ce docker-ce-cli

启动 docker

    [root@localhost ~]# systemctl start docker

**检查是否安装成功**

1、检查版本号

    [root@localhost ~]# docker -v
    Docker version 19.03.8, build afacb8b

2、运行hello-world容器

    [root@localhost ~]# docker run hello-world
    Unable to find image 'hello-world:latest' locally
    latest: Pulling from library/hello-world
    1b930d010525: Pull complete
    Digest: sha256:f9dfddf63636d84ef479d645ab5885156ae030f611a56f3a7ac7f2fdd86d7e4e
    Status: Downloaded newer image for hello-world:latest
    
    Hello from Docker!
    This message shows that your installation appears to be working correctly.
    
    To generate this message, Docker took the following steps:
     1. The Docker client contacted the Docker daemon.
     2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
        (amd64)
     3. The Docker daemon created a new container from that image which runs the
        executable that produces the output you are currently reading.
     4. The Docker daemon streamed that output to the Docker client, which sent it
        to your terminal.
    
    To try something more ambitious, you can run an Ubuntu container with:
     $ docker run -it ubuntu bash
    
    Share images, automate workflows, and more with a free Docker ID:
     https://hub.docker.com/
    
    For more examples and ideas, visit:
     https://docs.docker.com/get-started/

3、运行tomcat容器，并映射端口号

    [root@localhost etc]# docker pull tomcat
    Using default tag: latest
    latest: Pulling from library/tomcat
    50e431f79093: Pull complete
    dd8c6d374ea5: Pull complete
    c85513200d84: Pull complete
    55769680e827: Pull complete
    e27ce2095ec2: Pull complete
    5943eea6cb7c: Pull complete
    3ed8ceae72a6: Pull complete
    91d1e510d72b: Pull complete
    98ce65c663bc: Pull complete
    27d4ac9d012a: Pull complete
    Digest: sha256:2c90303e910d7d5323935b6dc4f8ba59cc1ec99cf1b71fd6ca5158835cffdc9c
    Status: Downloaded newer image for tomcat:latest
    docker.io/library/tomcat:latest
    [root@localhost etc]# docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    tomcat              latest              4e7840b49fad        2 weeks ago         529MB
    hello-world         latest              fce289e99eb9        14 months ago       1.84kB
    [root@localhost etc]# docker run -it -p 8888:8080 tomcat
    Using CATALINA_BASE:   /usr/local/tomcat
    Using CATALINA_HOME:   /usr/local/tomcat
    Using CATALINA_TMPDIR: /usr/local/tomcat/temp
    Using JRE_HOME:        /usr/local/openjdk-8
    Using CLASSPATH:       /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar
    16-Mar-2020 09:22:23.444 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version name:   Apache Tomcat/8.5.51
    16-Mar-2020 09:22:23.445 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server built:          Feb 5 2020 22:26:25 UTC
    16-Mar-2020 09:22:23.445 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version number: 8.5.51.0
    16-Mar-2020 09:22:23.445 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Name:               Linux
    16-Mar-2020 09:22:23.445 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Version:            4.18.0-80.el8.x86_64
    16-Mar-2020 09:22:23.445 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Architecture:          amd64
    16-Mar-2020 09:22:23.445 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Java Home:             /usr/local/openjdk-8/jre
    16-Mar-2020 09:22:23.445 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Version:           1.8.0_242-b08
    16-Mar-2020 09:22:23.445 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Vendor:            Oracle Corporation
    16-Mar-2020 09:22:23.446 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_BASE:         /usr/local/tomcat
    16-Mar-2020 09:22:23.446 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_HOME:         /usr/local/tomcat
    16-Mar-2020 09:22:23.446 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties
    16-Mar-2020 09:22:23.446 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager
    16-Mar-2020 09:22:23.446 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djdk.tls.ephemeralDHKeySize=2048
    16-Mar-2020 09:22:23.446 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.protocol.handler.pkgs=org.apache.catalina.webresources
    16-Mar-2020 09:22:23.446 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dorg.apache.catalina.security.SecurityListener.UMASK=0027
    16-Mar-2020 09:22:23.446 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dignore.endorsed.dirs=
    16-Mar-2020 09:22:23.446 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.base=/usr/local/tomcat
    16-Mar-2020 09:22:23.446 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.home=/usr/local/tomcat
    16-Mar-2020 09:22:23.446 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.io.tmpdir=/usr/local/tomcat/temp
    16-Mar-2020 09:22:23.446 INFO [main] org.apache.catalina.core.AprLifecycleListener.lifecycleEvent Loaded APR based Apache Tomcat Native library [1.2.23] using APR version [1.6.5].
    16-Mar-2020 09:22:23.446 INFO [main] org.apache.catalina.core.AprLifecycleListener.lifecycleEvent APR capabilities: IPv6 [true], sendfile [true], accept filters [false], random [true].
    16-Mar-2020 09:22:23.446 INFO [main] org.apache.catalina.core.AprLifecycleListener.lifecycleEvent APR/OpenSSL configuration: useAprConnector [false], useOpenSSL [true]
    16-Mar-2020 09:22:23.454 INFO [main] org.apache.catalina.core.AprLifecycleListener.initializeSSL OpenSSL successfully initialized [OpenSSL 1.1.1d  10 Sep 2019]
    16-Mar-2020 09:22:23.520 INFO [main] org.apache.coyote.AbstractProtocol.init Initializing ProtocolHandler ["http-nio-8080"]
    16-Mar-2020 09:22:23.533 INFO [main] org.apache.tomcat.util.net.NioSelectorPool.getSharedSelector Using a shared selector for servlet write/read
    16-Mar-2020 09:22:23.552 INFO [main] org.apache.catalina.startup.Catalina.load Initialization processed in 367 ms
    16-Mar-2020 09:22:23.584 INFO [main] org.apache.catalina.core.StandardService.startInternal Starting service [Catalina]
    16-Mar-2020 09:22:23.584 INFO [main] org.apache.catalina.core.StandardEngine.startInternal Starting Servlet Engine: Apache Tomcat/8.5.51
    16-Mar-2020 09:22:23.595 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["http-nio-8080"]
    16-Mar-2020 09:22:23.611 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in 58 ms

![pic_1](/images/centos8installdocker/1.png)
