---
title: 开源一个 node.js 防火墙小工具
readmore: false
categories: 编程
tags:
  - iptables
  - nodejs
  - vue
  - 后端云小项目
date: 2022-05-07 09:41:28
---

拿了一个网上的开源小项目改了改，原来的项目是 前端vue写的，后端nodejs写的。实现的功能是 防火墙的小工具，可通过前端web界面展示后台的防火墙策略，也可以通过界面插入一条防火墙策略。前后端用websocket通信。

原项目是一个拥有简单操作增删改查的iptables图形化管理器。具有下面的功能：
* 指定表指定链添加规则
* 指定表指定链指定位置插入规则
* 清空指定表指定链规则
* 单独查看被引用自定义链规则，更加一目了然 （CTRL键 + 鼠标左键）

我做了一点扩展，改了几行代码，实现的扩展功能包括：
* 原项目只能对nodejs部署的节点的防火墙做操作，现在扩展成可以对其他节点的防火墙操作
* 增加了获取其他节点的SSH安全日志
* 增加了获取其他节点的系统日志 SystemLog

所以前后端通信格式有了一点变化，增加了一个node字段，增加了两种类型，SystemLog 和 SSHLog

{node: "10.253.199.82", type: "SystemLog"}
{node: "10.253.199.82", type: "SSHLog"}

> 源码： https://github.com/backendcloud/iptables-UI