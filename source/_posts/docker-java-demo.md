---
title: docker hello-world 项目
date: 2022-05-02 10:13:44
categories:
tags:
---




docker hello-world 项目是一个最基础的 docker hello-world，包括：（以安卓开发做对比）
* 制作镜像一个简单的利用redis中间件的java项目 - 如同开发一个安卓应用并打包
* 上传自己的镜像到 docker hub（公共镜像仓库） - 上传到安卓市场
* 任何人任何机器都可以拉取公共镜像仓库之前上传的镜像，并正常运行之前的java项目 - 任何手机都可以去安卓市场下载该手机应用

# centos7 下安装docker

```bash
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io
systemctl start docker && systemctl enable docker && systemctl status docker

```

# docker 镜像加速
```bash
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
"registry-mirrors": ["https://82m9ar63.mirror.aliyuncs.com"],
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {
"max-size": "100m"
},
"storage-driver": "overlay2"
}
EOF
systemctl daemon-reload
systemctl restart docker

```

# 下载和部署 redis 镜像
```bash
docker pull redis:latest
mkdir -p /data/redis/
tee /data/redis/redis.conf <<-'EOF'
appendonly yes
requirepass 666666
EOF
docker run -v /data/redis/redis.conf:/etc/redis/redis.conf \
-v /data/redis/data:/data \
-d --name myredis \
-p 6379:6379 \
redis:latest  redis-server /etc/redis/redis.conf

```

# java docker-hello 项目

## pom.xml
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

## application.properties
```
spring.redis.host=192.168.159.132
spring.redis.password=666666
```

## CounterController.java
```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CounterController {

//    private int i = 0; //mysql，redis

    @Autowired
    StringRedisTemplate redisTemplate;

    @GetMapping("/hello")
    public String count(){

        Long increment = redisTemplate.opsForValue().increment("count-people");
        return "有 【"+ increment +"】 人访问了这个页面";
    }
}
```
![](.docker-java-demo_images/c4ecf7e9.png)

# 给 docker-hello 项目制作镜像
```bash
[root@localhost tt]# cat Dockerfile 
FROM openjdk:8-jdk-slim
LABEL maintainer=leifengyang

COPY target/*.jar   /app.jar

ENTRYPOINT ["java","-jar","/app.jar"]

[root@localhost tt]# docker build -t docker-java-demo:v1.0 .
Sending build context to Docker daemon  27.58MB
Step 1/4 : FROM openjdk:8-jdk-slim
8-jdk-slim: Pulling from library/openjdk
1fe172e4850f: Already exists 
44d3aa8d0766: Pull complete 
81bea02f1eea: Pull complete 
ccd3c592d09e: Pull complete 
Digest: sha256:ace86b512a287ed6c65c4b0daffd895c1ad3d8489aa2ba5fedd9585a29ebb3de
Status: Downloaded newer image for openjdk:8-jdk-slim
 ---> a07d7f1dd64b
Step 2/4 : LABEL maintainer=leifengyang
 ---> Running in 0c95e08a46c1
Removing intermediate container 0c95e08a46c1
 ---> 451513a02e4a
Step 3/4 : COPY target/*.jar   /app.jar
 ---> bb79a201820b
Step 4/4 : ENTRYPOINT ["java","-jar","/app.jar"]
 ---> Running in 7d08772be1eb
Removing intermediate container 7d08772be1eb
 ---> 903bba8f3d19
Successfully built 903bba8f3d19
Successfully tagged docker-java-demo:v1.0
[root@localhost tt]# 
```

# 上传 docer-hello 项目到公共镜像仓库
```bash
[root@localhost tt]# docker images
REPOSITORY         TAG          IMAGE ID       CREATED         SIZE
docker-java-demo   v1.0         903bba8f3d19   2 minutes ago   323MB
redis              latest       a10f849e1540   4 days ago      117MB
openjdk            8-jdk-slim   a07d7f1dd64b   4 days ago      296MB
[root@localhost tt]# docker tag docker-java-demo:v1.0 backendcloud/docker-java-demo:v1.0
[root@localhost tt]# docker push backendcloud/docker-java-demo:v1.0
The push refers to repository [docker.io/backendcloud/docker-java-demo]
f30a1988cea2: Preparing 
e2118ceaebd1: Preparing 
8373e87e0617: Preparing 
13a34b6fff78: Preparing 
9c1b6dd6c1e6: Preparing 
denied: requested access to the resource is denied
[root@localhost tt]# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: backendcloud
Password: 
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
[root@localhost tt]# docker push backendcloud/docker-java-demo:v1.0
The push refers to repository [docker.io/backendcloud/docker-java-demo]
f30a1988cea2: Pushed 
e2118ceaebd1: Mounted from library/openjdk 
8373e87e0617: Mounted from library/openjdk 
13a34b6fff78: Mounted from library/openjdk 
9c1b6dd6c1e6: Mounted from library/openjdk 
v1.0: digest: sha256:826e2d6fb61c9a93e06e4816a511051aa18504eb2f6b098c8fa4b3fc0c8ed44c size: 1372
[root@localhost tt]# docker images
REPOSITORY                      TAG          IMAGE ID       CREATED          SIZE
backendcloud/docker-java-demo   v1.0         903bba8f3d19   13 minutes ago   323MB
docker-java-demo                v1.0         903bba8f3d19   13 minutes ago   323MB
redis                           latest       a10f849e1540   4 days ago       117MB
openjdk                         8-jdk-slim   a07d7f1dd64b   4 days ago       296MB
[root@localhost tt]# docker run -d -p 8080:8080 backendcloud/docker-java-demo:v1.0 
311a62f586934059e4a18ed19460047efbe167979b316a0a9c17476e457e1c26
[root@localhost tt]# docker ps
CONTAINER ID   IMAGE                                COMMAND                  CREATED          STATUS          PORTS                                       NAMES
311a62f58693   backendcloud/docker-java-demo:v1.0   "java -jar /app.jar"     38 seconds ago   Up 37 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   brave_einstein
2883786f38ae   redis:latest                         "docker-entrypoint.s…"   42 minutes ago   Up 42 minutes   0.0.0.0:6379->6379/tcp, :::6379->6379/tcp   myredis
[root@localhost tt]# docker exec -it 311a62f586934059e4a18ed19460047efbe167979b316a0a9c17476e457e1c26 /bin/bash
root@311a62f58693:/# 
```

![](.docker-java-demo_images/4003a8cb.png)
![](.docker-java-demo_images/11d94787.png)
```bash
[root@localhost tt]# docker logs 311a62f58693

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v2.6.7)

2022-05-02 09:27:58.936  INFO 1 --- [           main] c.e.d.DockerJavaDemoApplication          : Starting DockerJavaDemoApplication v0.0.1-SNAPSHOT using Java 1.8.0_332 on 311a62f58693 with PID 1 (/app.jar started by root in /)
2022-05-02 09:27:58.942  INFO 1 --- [           main] c.e.d.DockerJavaDemoApplication          : No active profile set, falling back to 1 default profile: "default"
2022-05-02 09:27:59.925  INFO 1 --- [           main] .s.d.r.c.RepositoryConfigurationDelegate : Multiple Spring Data modules found, entering strict repository configuration mode!
2022-05-02 09:27:59.931  INFO 1 --- [           main] .s.d.r.c.RepositoryConfigurationDelegate : Bootstrapping Spring Data Redis repositories in DEFAULT mode.
2022-05-02 09:27:59.958  INFO 1 --- [           main] .s.d.r.c.RepositoryConfigurationDelegate : Finished Spring Data repository scanning in 3 ms. Found 0 Redis repository interfaces.
2022-05-02 09:28:00.506  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2022-05-02 09:28:00.520  INFO 1 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2022-05-02 09:28:00.520  INFO 1 --- [           main] org.apache.catalina.core.StandardEngine  : Starting Servlet engine: [Apache Tomcat/9.0.62]
2022-05-02 09:28:00.596  INFO 1 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2022-05-02 09:28:00.596  INFO 1 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 1522 ms
2022-05-02 09:28:01.598  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2022-05-02 09:28:01.613  INFO 1 --- [           main] c.e.d.DockerJavaDemoApplication          : Started DockerJavaDemoApplication in 3.26 seconds (JVM running for 3.753)
2022-05-02 09:28:54.065  INFO 1 --- [nio-8080-exec-1] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring DispatcherServlet 'dispatcherServlet'
2022-05-02 09:28:54.065  INFO 1 --- [nio-8080-exec-1] o.s.web.servlet.DispatcherServlet        : Initializing Servlet 'dispatcherServlet'
2022-05-02 09:28:54.066  INFO 1 --- [nio-8080-exec-1] o.s.web.servlet.DispatcherServlet        : Completed initialization in 1 ms
[root@localhost tt]# 
```

> docker-java-demo 项目源码放在 https://github.com/backendcloud/example/tree/master/docker-java-demo