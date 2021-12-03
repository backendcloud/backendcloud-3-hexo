---
title: Fluentd 实现 Kubernetes Pod 日志收集
date: 2021-11-30 16:36:50
categories: 云原生
tags:
- Kubernetes
- Pod
- Fluentd

---

> 阅读本文章前先阅读 https://kubernetes.io/zh/docs/concepts/cluster-administration/logging/

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]


![](/images/pod-log-collect/81a85a94.png)
>https://docs.fluentd.org/

# Fluentd 日志架构
![](/images/pod-log-collect/dd6ad8f3.png)
Fluentd 典型的部署架构需要包含两种不同角色：转发器（forwarder），聚合器（aggregator）。

![](/images/pod-log-collect/c8152f68.png)
每个Kubernetes工作节点部署一个Fluentd用于将节点的容器日志转发到边缘云配置公网的工作节点，配置公网的工作节点再将日志转发到软件部署节点。

# Fluent 配置文件
每个Kubernetes工作节点Fluentd的配置如下：

	<source>
	  @type tail
	  path /var/log/containers/*.log
	  pos_file /var/log/fluentd-containers.log.pos
	  format json
	  tag kubernetes.*
	  time_format %Y-%m-%dT%H:%M:%S.%NZ
	</source>
	
	<match kubernetes.**>
	  @type forward
	  send_timeout 60s
	  recover_wait 10s
	  hard_timeout 60s
	  <server>
	    name myserver1
	    host 192.168.200.100
	    port 24224
	    weight 60
	  </server>
	</match>

汇聚日志节点也就是上图中配置了公网的工作节点Fluentd的配置如下：

	<source>
	  @type forward
	  port 24224
	  bind 0.0.0.0
	</source>
	
	<match **>
	  @type forward
	  send_timeout 60s
	  recover_wait 10s
	  hard_timeout 60s
	  <server>
	    name myserver2
	    host 36.134.56.149
	    port 24224
	    weight 60
	  </server>
	</match>

软件部署节点Fluentd的配置如下：

	<source>
	  @type forward
	  port 24224
	  bind 0.0.0.0
	</source>
	
	<match **>
	  @type stdout                                              # Uses file plugin to write logs to
	</match>

# 用Fluentd收集Pod日志过程中遇到的几个问题记录下

## 对比裸机和容器部署，采取容器部署方案

裸机也可以部署，但是需要ruby环境，还有Fluent的依赖，其中还有版本依赖关系，部署有些麻烦，且不利于自动化。若采用容器部署，以上缺点都不存在，可以利用Kubernetes的kind: DaemonSet很方便在每一个Kubernetes节点上起Fluentd服务。

容器镜像用的是 docker pull fluent/fluentd:latest
也可以使用fluent/fluentd-kubernetes-daemonset，应该会更好，有些配置都应该配置好了，我是自己研究，用了原始的镜像。
也可以直接使用 Kubernetes 官方提供的 addon 插件的资源清单，地址：https://github.com/kubernetes/kubernetes/blob/master/cluster/addons/fluentd-elasticsearch/  直接安装即可。

以下命令启动容器

	docker run -it -d   -p 24224:24224   -v /path/to/conf:/fluentd/etc   -v /var:/var fluent/fluentd:latest

初次启动失败，因为没有配置文件（宿主机的/path/to/conf目录覆盖了容器中fluentd配置文件目录），加上Fluentd配置文件，重启容器成功。

为了测试Fluent日志服务，做了两个小实验。

### input: tail

Fluent配置文件写成如下的形式后重启Fluentd容器。

	# Directive determines the input sources
	# Watches source and triggers an event with a tag attached to it
	<source>
	  @type tail                                               # Uses tail plugin to read logs from
	  format json                                              # Assumes that the log file is in "json" format
	  read_from_head true                                      # Start to read the logs from the head of file, not bottom
	  tag api.user.registration                                # Tag triggered event with "api.user.registration"
	  path /home/ubuntu/logs/application/registration.log*     # Paths to the files which will be tailed
	  pos_file /home/ubuntu/logs/fluentd/registration.log.pos  # Path to the "position" database file
	</source>
	 
	# Directive determines the output destinations
	# Catches an event with a specific tag attached to it
	<match api.user.registration>
	  @type file                                               # Uses file plugin to write logs to
	  path /home/ubuntu/logs/fluentd/registration.log          # Path to the log file which logs will be written to
	</match>

测试成功。
```bash
ubuntu@linux:~$ echo '{"user":"1"}' >> logs/application/registration.log.1 
ubuntu@linux:~$ echo '{"user":"2"}' >> logs/application/registration.log.1 
ubuntu@linux:~$ echo '{"user":"3"}' >> logs/application/registration.log.1 

ubuntu@linux:~$ ls -l logs/fluentd/
 
-rw-r--r-- 1 td-agent td-agent 61 Apr  6 21:02 registration.log.20180406.b56933893cd87b6b8
-rw-r--r-- 1 td-agent td-agent 83 Apr  6 21:02 registration.log.pos

ubuntu@linux:~$ cat logs/fluentd/registration.log.20180406.b56933893cd87b6b8
 
2018-04-06T21:02:30+01:00	api.user.registration	{"user":"1"}
2018-04-06T21:02:49+01:00	api.user.registration	{"user":"2"}
2018-04-06T21:02:55+01:00	api.user.registration	{"user":"3"}

ubuntu@linux:~$ touch logs/application/registration.log.2
 
ubuntu@linux:~$ echo '{"admin":"1"}' >> logs/application/registration.log.2
ubuntu@linux:~$ echo '{"admin":"2"}' >> logs/application/registration.log.2
ubuntu@linux:~$ echo '{"admin":"3"}' >> logs/application/registration.log.2

ubuntu@linux:~$ cat logs/fluentd/registration.log.20180406.b56933893cd87b6b8
 
2018-04-06T21:02:30+01:00	api.user.registration	{"user":"1"}
2018-04-06T21:02:49+01:00	api.user.registration	{"user":"2"}
2018-04-06T21:02:55+01:00	api.user.registration	{"user":"3"}
2018-04-06T21:07:37+01:00	api.user.registration	{"admin":"1"}
2018-04-06T21:07:37+01:00	api.user.registration	{"admin":"2"}
2018-04-06T21:07:38+01:00	api.user.registration	{"admin":"3"}
```

### input: forward
Fluent配置文件写成如下的形式后重启Fluentd容器。

	<source>
	  @type   forward
	</source>
	
	<match *>
	
	  @type              file
	
	  path               /fluentd/log/${tag}/${tag}
	  append             true
	  <format>
	    @type            single_value
	    message_key      log
	  </format>
	  <buffer tag,time>
	    @type             file
	    timekey           1d
	    timekey_wait      10m
	    flush_mode        interval
	    flush_interval    30s
	  </buffer>
	</match>

启动一个新的容器，指定容器的logging driver

	docker run -d \
	  ...
	  --log-driver=fluentd \
	  --log-opt fluentd-address=<fluentdhost>:24224 \
	  --log-opt mode=non-blocking \
	  --log-opt tag={{.Name}} \
	  <image>

观察日志，到/home/ubuntu/container-logs目录下能够看到类似这样的目录结构：

	.
	└── <container-name>
	    └── <container-name>.20190123.log


## Fluentd容器中可以cat pod的日志文件，但是Fluentd服务的日志报不可读取Pod的日志文件

	/var/log/containers/samplelog-79bd66868b-t7xn9_logging1_fluentd-70e85c5d6328e7d.log unreadable. It is excluded and would be examined next time.

登录Fluentd容器可以cat日志文件，有看了日志文件的读写属性，root用户可以读，其他用户不能读。ps了下Fluentd进程，发现都是以fluent用户运行的。

```bash
/ # ps -ef
PID   USER     TIME  COMMAND
    1 root      0:00 {entrypoint.sh} /usr/bin/dumb-init /bin/sh /bin/entrypoint.sh /bin/sh -c exec fluentd -c /fluentd/etc/${FLUENTD_CONF} -p /fluentd/plugins $FLUENTD_
    6 fluent    0:02 {fluentd} /usr/bin/ruby /usr/bin/fluentd -c /fluentd/etc/fluent.conf -p /fluentd/plugins
   17 fluent    0:28 /usr/bin/ruby -Eascii-8bit:ascii-8bit /usr/bin/fluentd -c /fluentd/etc/fluent.conf -p /fluentd/plugins --under-supervisor
   21 root      0:00 sh
   26 root      0:00 ps -ef
/ # 
```


因为fluentd镜像在构建的时候用的是fluent用户权限运行，所以会发生权限不足的情况。

解决方法就是可以去拉取fluent代码自行构建并在Dockfile中指定用户；或使用最简单的方法，在env中指定fluent用户的UID为0，具体操作方法我在stackoverflow上有该问题的回答。

https://stackoverflow.com/questions/51671212/fluentd-log-unreadable-it-is-excluded-and-would-be-examined-next-time/70165516#70165516

The most direct way is to change mode:

	chmod 777 /var/log/containers/*.log

but the best way is: change fluent user to root (set FLUENT_UID environment variable to 0 in your docker/kubernetes configuration);

add --env FLUENT_UID=0 to docker command, for example:

	docker run -it -d -p 24224:24224 -v /path/to/conf:/fluentd/etc -v /var:/var --env FLUENT_UID=0 fluent/fluentd:latest

or add to Kubernetes yaml file:

	apiVersion: extensions/v1beta1
	kind: DaemonSet
	metadata:
	  name: fluentd
	  namespace: kube-system
	  # namespace: default
	  labels:
	    k8s-app: fluentd-logging
	    version: v1
	    kubernetes.io/cluster-service: "true"
	spec:
	  template:
	    metadata:
	      labels:
	        k8s-app: fluentd-logging
	        version: v1
	        kubernetes.io/cluster-service: "true"
	    spec:
	      serviceAccount: fluentd
	      serviceAccountName: fluentd
	      tolerations:
	      - key: node-role.kubernetes.io/master
	        effect: NoSchedule
	      containers:
	      - name: fluentd
	        image: fluent/fluentd-kubernetes-daemonset:v1.4-debian-elasticsearch
	        env:
	          - name: FLUENT_UID  # change this place
	            value: "0"

按我在stackoverflow上的回答修改后，一切正常。

```bash
/ # ps -ef
PID   USER     TIME  COMMAND
    1 root      0:00 {entrypoint.sh} /usr/bin/dumb-init /bin/sh /bin/entrypoint.sh /bin/sh -c exec fluentd -c /fluentd/etc/${FLUENTD_CONF} -p /fluentd/plugins $FLUENTD_
    7 root      0:05 {fluentd} /usr/bin/ruby /usr/bin/fluentd -c /fluentd/etc/fluent.conf -p /fluentd/plugins
   16 root      1:58 /usr/bin/ruby -Eascii-8bit:ascii-8bit /usr/bin/fluentd -c /fluentd/etc/fluent.conf -p /fluentd/plugins --under-supervisor
   22 root      0:00 sh
   28 root      0:00 ps -ef
/ # 
```
