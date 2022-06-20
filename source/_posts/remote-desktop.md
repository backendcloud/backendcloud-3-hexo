---
title: 远程登录windows桌面
readmore: false
date: 2022-06-20 19:27:47
categories: Tools
tags:
---

> 客户端不用多说，windows自带客户端mstsc。苹果应用商店下载Microsoft Remote Desktop。本篇是关于服务端的配置。局域网不用多说，直接ip登录，本篇是非局域网。虽然有teamviewer和向日葵可以实现，一来teamviewer不能用于商业，向日葵稳定性差些有较低概率服务不可用，二来windows自带的远程桌面体验更好。本篇是关于windows自带的远程桌面服务。前提打开设置 - 系统 - 远程桌面 的开关。

对比几种方案：
1. 路由器端口映射，打10086要个公网ip即可，电信的ip多，随便要，移动据说要不到。缺点是感觉稳定性差，应该运营商限制自己的电脑提供云服务。
2. ssh隧道到自己的云主机然后通过访问自己的云主机的公网ip的端口实现远程桌面的登录，前提是要有台云主机，且网络流量会产生收费。
3. 试用免费的内网穿透工具cpolar，目前使用没啥问题。

下面介绍下第三种方案。

1. 官网 https://www.cpolar.com 注册和下载安装cpolar
2. authtoken添加到的cpolar.yml文件中 $ ./cpolar authtoken xxxyyyzzz
3. 开启远程桌面隧道 ./cpolar start remoteDesktop

第三步的输出会显示url地址，或者 https://dashboard.cpolar.com/status 也可以查看到url地址，mstsc 输入 url地址即可

下面介绍下如何任何开机启动 ./cpolar start remoteDesktop 这条命令。若是linux，mac系统太简单了，windows处理起来略有点繁琐

1. 将 cpolar start remoteDesktop 这一行写入一个ps1后缀的文件中。 
2. 用 https://github.com/MScholtes/PS2EXE 工具将ps1转exe
3. 将生成的exe文件放到目录 %USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup

