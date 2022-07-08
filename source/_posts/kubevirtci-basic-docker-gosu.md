---
title: 一步步学KubeVirt CI （3） - gosu在容器中的使用
readmore: true
date: 2022-07-08 18:40:08
categories: 云原生
tags:
- KubeVirt CI
---

# gosu在容器中的使用
容器中使用gosu的起源来自安全问题，容器中运行的进程，如果以root身份运行的会有安全隐患，该进程拥有容器内的全部权限，更可怕的是如果有数据卷映射到宿主机，那么通过该容器就能操作宿主机的文件夹了，一旦该容器的进程有漏洞被外部利用后果是很严重的。因此，容器内使用非root账号运行进程才是安全的方式。gosu类似linux中的su和sudo命令。但是既然有了su和sudo为何还要做出一个gosu来。因为：

1. gosu启动命令时只有一个进程，所以docker容器启动时使用gosu，那么该进程可以做到PID等于1；
2. sudo启动命令时先创建sudo进程，然后该进程作为父进程去创建子进程，1号PID被sudo进程占据；

# su & gosu
```bash
$ docker run -it --rm ubuntu:trusty su -c 'exec ps aux'
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0  46636  2688 ?        Ss+  02:22   0:00 su -c exec ps a
root         6  0.0  0.0  15576  2220 ?        Rs   02:22   0:00 ps aux
$ docker run -it --rm ubuntu:trusty sudo ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  3.0  0.0  46020  3144 ?        Ss+  02:22   0:00 sudo ps aux
root         7  0.0  0.0  15576  2172 ?        R+   02:22   0:00 ps aux
$ docker run -it --rm -v $PWD/gosu-amd64:/usr/local/bin/gosu:ro ubuntu:trusty gosu root ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0   7140   768 ?        Rs+  02:22   0:00 ps aux
```

# sudo: Why does sudo call fork() and exec() rather than just exec()?

If sudo merely called exec, then sudo couldn't do things like run any cleanup tasks when the exec'd code completed. Take `pam_open_session` and `pam_close_session` for example.

> https://linux.die.net/man/3/pam_open_session
> https://linux.die.net/man/3/pam_close_session

# 拿经典的redis镜像举例

## 首先得了解RUN CMD ENTRYPOINT区别
三者的共同点是：都是执行命令；都有两种格式Shell格式和Exec格式。

不同点是：RUN命令执行命令并创建新的镜像层，通常用于安装软件包。CMD ENTRYPOINT是设置容器启动后默认执行的命令其参数且他们的组合官网有个说明。

| | No ENTRYPOINT|ENTRYPOINT exec_entry p1_entry|ENTRYPOINT [“exec_entry”, “p1_entry”]|
| --- | --- | --- | --- |
|No CMD|	error, not allowed	|/bin/sh -c exec_entry p1_entry	|exec_entry p1_entry|
|CMD [“exec_cmd”, “p1_cmd”]|	exec_cmd p1_cmd	|/bin/sh -c exec_entry p1_entry	|exec_entry p1_entry exec_cmd p1_cmd|
|CMD [“p1_cmd”, “p2_cmd”]|	p1_cmd p2_cmd	|/bin/sh -c exec_entry p1_entry	|exec_entry p1_entry p1_cmd p2_cmd|
|CMD exec_cmd p1_cmd	|/bin/sh -c exec_cmd p1_cmd	|/bin/sh -c exec_entry p1_entry	|exec_entry p1_entry /bin/sh -c exec_cmd p1_cmd|

## Dockfile
```yaml
FROM alpine:3.4
...
RUN addgroup -S redis && adduser -S -G redis redis
...
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 6379
CMD [ "redis-server" ]
```

```yaml
...
RUN addgroup -S redis && adduser -S -G redis redis
...
```
上面的需要root处理的步骤放这一段，后面启动redis-server用了非root用户启动。原因是下面的`docker-entrypoint.sh`脚本：

##
```bash
#!/bin/sh
...
# allow the container to be started with `--user`
if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
	find . \! -user redis -exec chown redis '{}' +
	exec gosu redis "$0" "$@"
fi

exec "$@"
```

> 上面的代码有一层递归。

检测到root用户启动redis命令redis-server，就会做两件事：
1. 找到当前目录的所有非redis用户文件并将找出的全部文件改成redis所有，`find . \! -user redis`是找出当前目录的所有非redis用户文件，`-exec chown redis '{}' +`是将找出的文件修改成redis用户所有。
2. `exec gosu redis "$0" "$@"`改用redis用户执行当前脚本，发生一次递归，就是改用redis用户重新执行CMD+ENTRYPOINT，且不fock()新的进程PID，销毁旧进程，使用旧进程PID。

第二次执行CMD+ENTRYPOINT，因为是redis用户执行的，所以不进入if语句，直接`exec "$@"`，因为没有了`$0`所以不会再递归执行CMD+ENTRYPOINT了。

该脚本的内容就是根据 CMD 的内容来判断，如果是 redis-server 的话，则切换到 redis 用户身份启动服务器，否则依旧使用 root 身份执行。比如：

```bash
$ docker run -it redis id
uid=0(root) gid=0(root) groups=0(root)
```