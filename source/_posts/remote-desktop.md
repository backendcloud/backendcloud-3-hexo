---
title: 远程登录windows桌面
readmore: false
date: 2022-06-20 19:27:47
categories: Tools
tags:
---

> 本篇是关于服务端的配置。客户端不用多说，windows自带客户端mstsc，苹果应用商店下载Microsoft Remote Desktop。

> 局域网不用多说，直接mstsc ip登录远程桌面，本篇是非局域网的远程登录。虽然有Teamviewer和向日葵可以实现，一来Teamviewer免费版不能用于商用，向日葵稳定性差，多次频繁遇到服务不可用，二来windows自带的远程桌面体验更好。本篇是关于windows自带的远程桌面服务配置方案。

> 前提打开要登陆的电脑的远程桌面的开关，默认是关闭的。设置 - 系统 - 远程桌面 中打开。

对比几种方案：
1. 路由器端口映射，我之前打10000说家用监控需要一个公网ip，电信最早从事网络运营公网ip多，应该都会给的，移动据说要不到。这种方案缺点是稳定性差，应该运营商限制家用电脑提供服务端口，没限制死就让你用起来不爽。
2. ssh隧道到自己的云主机然后通过访问自己的云主机的公网ip的端口实现远程桌面的登录，前提是要有台云主机，且网络流量会产生收费。
3. 用免费的内网穿透工具cpolar，目前使用下来没啥问题。

| 方案            | 优点 | 缺点                                                                       |
|---------------|---|--------------------------------------------------------------------------|
| 方案1：公网直连      | 登录ip端口固定，客户端服务端配置简单 | 需要有服务桌面电脑所在局域网的网络管理权限，需要运营商支持                                            |
| 方案2：自己搭建ssh隧道 | 稳定 | 需要后台建立ssh隧道，需要云服务和流量使用费                                                  |
| 方案3：cpolar    | 稳定，免费 | 只是目前免费稳定，将来cpolar如何开展业务不是自己能控制的。免费的账号url的地址每次链接都不一样，需要登录dashboard查看url地址 |

下面介绍下综合最优的方案3。

step1. 官网 https://www.cpolar.com 注册和下载安装cpolar
step2. authtoken添加到的cpolar.yml文件中 $ cpolar authtoken xxxyyyzzz
step3. 开启远程桌面隧道 cpolar start remoteDesktop

step3的输出会显示url地址，或者 https://dashboard.cpolar.com/status 也可以查看到url地址，mstsc 输入 url地址即可

至此，已经可以在任何地方访问自己的远程电脑了，下面介绍下如何开机启动 cpolar start remoteDesktop 这条命令。若是linux，mac系统比较容易，添加到bashrc或/etc/profile或rc.local，windows处理起来略有点繁琐

1. 将 cpolar start remoteDesktop 这一行写入一个ps1后缀的文件中。 
2. 用 https://github.com/MScholtes/PS2EXE 工具将ps1转exe
3. 将生成的exe文件放到目录 %USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup

