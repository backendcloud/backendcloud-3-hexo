---
title: 实现反向隧道的几个脚本（workinprocess）
readmore: true
date: 2022-08-02 19:24:02
categories: Tools
tags:
---

为解决边缘计算中的云边互联问题，需要使用反向隧道技术。

边缘端不同于云端网络，边缘端，边缘节点往往没有公网IP，或者边缘端，边缘节点处于wifi中，处于NAT内网中，这时只能从边访问云，云访问不了边，这个时候需要云边建立通信隧道，实现云也可以访问边。

本篇介绍下两个实现脚本。一个shell实现，一个Golang实现。

# 创建ssh反向隧道的shell脚本

首先下载autossh

```bash
wget https://www.harding.motd.ca/autossh/autossh-1.4g.tgz
tar xzvf autossh-1.4g.tgz
cd autossh-1.4g
./configure
make
make install
 ```

shell脚本：
```bash
#!/bin/bash

# The remote host that we connect to via SSH, and establish the listening remote port(s)
REMOTE_HOST=remotehost.example.net
REMOTE_HOST_SSH_PORT=22
REMOTE_HOST_SSH_USER=myusername

# Define reverse port forwards
# Format: 'REMOTE_PORT:LOCAL_HOST:LOCAL_PORT' (where LOCAL_HOST can be actual localhost or any host acessible by localhost)
PORTS=(
     "8880:localhost:80"    # 8880 -> 80
     "8443:localhost:443"   # 8443 -> 443
     "8822:localhost:22"    # 8822 -> 22
    )

for PORT in ${PORTS[@]}
do   
  PORT_STR="$PORT_STR -R 0.0.0.0:$PORT"
done

# Ignore early failed connections at boot
export AUTOSSH_GATETIME=0

autossh -4 -M 0 -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes $PORT_STR -p$REMOTE_HOST_SSH_PORT $REMOTE_HOST_SSH_USER@$REMOTE_HOST
```

修改上面的脚本中的remote server的ip，port，username。脚本在本地执行。成功ssh登录远程后，remote server会起几个端口的服务，例如在remote server执行命令