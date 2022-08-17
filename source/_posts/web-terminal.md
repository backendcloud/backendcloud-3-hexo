---
title: Web Terminal 预备知识
readmore: true
date: 2022-08-17 18:53:50
categories: Tools
tags:
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

# TTY 和 PTY

## 回顾历史

几十年前，人们将 Teleprinter(电传打字机) 连接到早期的大型计算机上，作为输入和输出设备，将输入的数据发送到计算机，并打印出响应。

电传打字机有输入设备也有输出设备，分别对应的是电传打字机上的按键和纸带。

为了把不同型号的电传打字机接入计算机，需要在操作系统内核安装驱动，为上层应用屏蔽所有的低层细节。

电传打字机通过两根电缆连接：一根用于向计算机发送指令，一根用于接收计算机的输出。这两根电缆插入 UART （Universal Asynchronous Receiver and Transmitter，通用异步接收和发送器）的串行接口连接到计算机。

操作系统包含一个 UART 驱动程序，管理字节的物理传输，包括奇偶校验和流量控制。然后输入的字符序列被传递给 TTY 驱动，该驱动包含一个 line discipline。

line discipline 负责转换特殊字符（如退格、擦除字、清空行），并将收到的内容回传给电传打字机，以便用户可以看到输入的内容。line discipline 还负责对字符进行缓冲，当按下回车键时，缓冲的数据被传递给与 TTY 相关的前台用户进程。用户可以并行的执行几个进程，但每次只与一个进程交互，其他进程在后台工作。

![](/images/web-terminal/2022-08-17-16-00-12.png)

## 终端模拟器(terminal emulator)

今天电传打字机已经进了博物馆，但 Linux/Unix 仍然保留了当初 TTY 驱动和 line discipline 的设计和功能。终端不再是一个需要通过 UART 连接到计算机上物理设备。终端成为内核的一个模块，它可以直接向 TTY 驱动发送字符，并从 TTY 驱动读取响应然后打印到屏幕上。也就是说，用内核模块模拟物理终端设备，因此被称为终端模拟器(terminal emulator)。

![](/images/web-terminal/2022-08-17-16-03-09.png)

## 伪终端（pseudo terminal, PTY）

终端模拟器(terminal emulator) 是运行在内核的模块，我们也可以让终端模拟程序运行在用户区。运行在用户区的终端模拟程序，就被称为伪终端（pseudo terminal, PTY）。

PTY 运行在用户区，更加安全和灵活，同时仍然保留了 TTY 驱动和 line discipline 的功能。常用的伪终端有 xterm，gnome-terminal，以及远程终端 ssh。我们以 Ubuntu 桌面版提供的 gnome-terminal 为例，介绍伪终端如何与 TTY 驱动交互。

![](/images/web-terminal/2022-08-17-16-04-54.png)

PTY 是通过打开特殊的设备文件 /dev/ptmx 创建，由一对双向的字符设备构成，称为 PTY master 和 PTY slave。

gnome-terminal 持有 PTY master 的文件描述符 /dev/ptmx。gnome-terminal 负责监听键盘事件，通过PTY master接收或发送字符到 PTY slave，还会在屏幕上绘制来自PTY master的字符输出。

gnome-terminal 会 fork 一个 shell 子进程，并让 shell 持有 PTY slave 的设备文件 /dev/pts/[n]，shell 通过 PTY slave 接收字符，并输出处理结果。

PTY master 和 PTY slave 之间是 TTY 驱动，会在 master 和 slave 之间复制数据，并进行会话管理和提供 line discipline 功能。

在 gnome-terminal 中执行 tty 命令，可以看到代表PTY slave的设备文件：

```bash
[root@kubevirtci web-console]# tty
/dev/pts/0
```

执行 ps -l 命令，也可以确认 shell 关联的伪终端是 pts/0：

```bash
[root@kubevirtci web-console]# ps -l
F S   UID     PID    PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
4 S     0    1091    1090  0  80   0 -  1923 do_wai pts/0    00:00:00 bash
4 R     0   20771    1091  0  80   0 -  2523 -      pts/0    00:00:00 ps
```

> 注意到 TTY 这一列指出了当前进程的终端是 pts/0。

下面以实际的例子，看看在 terminal 执行一个命令的全过程。
* 我们在桌面启动终端程序 gnome-terminal，它向操作系统请求一个PTY master，并把 GUI 绘制在显示器上
* gnome-terminal 启动子进程 bash
* bash 的标准输入、标准输出和标准错误都设置为 PTY slave
* gnome-terminal 监听键盘事件，并将输入的字符发送到PTY master
* line discipline 收到字符，进行缓冲。只有当你按下回车键时，它才会把缓冲的字符复制到PTY slave。
* line discipline 在接收到字符的同时，也会把字符写回给PTY master。gnome-terminal 只会在屏幕上显示来自 PTY master 的东西。因此，line discipline 需要回传字符，以便让你看到你刚刚输入的内容。
* 当你按下回车键时，TTY 驱动负责将缓冲的数据复制到PTY slave
* bash 从标准输入读取输入的字符（例如 ls -l ）。注意，bash 在启动时已经将标准输入被设置为了PTY slave
* bash 解释从输入读取的字符，发现需要运行 ls
* bash fork 出 ls 进程。bash fork 出的进程拥有和 bash 相同的标准输入、标准输出和标准错误，也就是PTY slave
* ls 运行，结果打印到标准输出，也就是PTY slave
* TTY 驱动将字符复制到PTY master
* gnome-terminal 循环从 PTY master 读取字节，绘制到用户界面上。

## 远程终端

我们经常通过 ssh 连接到一个远程主机，这时候远程主机上的 ssh server 就是一个伪终端 PTY，它同样持有 PTY master，但 ssh server 不再监听键盘事件，以及在屏幕上绘制输出结果，而是通过 TCP 连接，向 ssh client 发送或接收字符。

![](/images/web-terminal/2022-08-17-16-11-52.png)

我们简单梳理一下远程终端是如何执行命令的。

1. 用户在客户端的 terminal 中输入 ssh 命令，经过 PTY master、TTY 驱动，到达 PTY slave。bash 的标准输入已经设置为了 PTY slave，它从标准输入读取字符序列并解释执行，发现需要启动 ssh 客户端，并请求和远程服务器建 TCP 连接。
2. 服务器端接收客户端的 TCP 连接请求，向内核申请创建 PTY，获得一对设备文件描述符。让 ssh server 持有 PTY master，ssh server fork 出的子进程 bash 持有 PTY slave。bash 的标准输入、标准输出和标准错误都设置为了PTY slave。
3. 当用户在客户端的 terminal 中输入命令 ls -l 和回车键，这些字符经过 PTY master 到达 TTY 驱动。我们需要禁用客户端 line discipline 的所有规则，也就是说客户端的 line discipline 不会对特殊字符回车键做处理，而是让命令 ls -l 和回车键一起到达 PTY slave。ssh client 从 PTY slave 读取字符序列，通过网络，发送给 ssh server。
4. ssh server 将从 TCP 连接上接收到的字节写入PTY master。TTY 驱动对字节进行缓冲，直到收到特殊字符回车键。
5. 由于服务器端的 line discipline 没有禁用 echo 规则，所以 TTY 驱动还会将收到的字符写回PTY master，ssh server 从 PTY master 读取字符，将这些字符通过 TCP 连接发回客户端。注意，这是发回的字符不是 ls -l 命令的执行结果，而是 ls -l 本身的回显，让客户端能看到自己的输入。
6. 在服务器端 TTY 驱动将字符序列传送给 PTY slave，bash 从 PTY slave读取字符，解释并执行命令 ls -l。bash fork 出 ls 子进程，该子进程的标准输入、标准输出和标准错误同样设置为了 PTY slave。ls -l 命令的执行结果写入标准输出 PTY slave，然后执行结果通过 TTY 驱动到达 PTY master，再由 ssh server 通过 TCP 连接发送给 ssh client。

> 注意在客户端，我们在屏幕上看到的所有字符都来自于远程服务器。包括我们输入的内容，也是远程服务器上的 line discipline 应用 echo 规则的结果，将这些字符回显了回来。

> 想进一步探究，可以阅读 TTY驱动的源码(https://github.com/torvalds/linux/blob/master/drivers/tty/tty_io.c) 和 line discipline的源码(https://github.com/torvalds/linux/blob/master/drivers/tty/n_tty.c)

# Web Terminal

> 首先明确一下，这里说的 Web Terminal 是指再网页中实现的，类似于终端客户端软件的东西。

实现 Web Terminal 现在比较主流的实现方案是：前端使用 xterm.js 作 HTML5 中的终端组件，服务端使用 node-pty 做 PTY 的操作工具。而通讯方面，SSH 用的是 TCP，Web 上能用的也就是 WebSocket 了。

> * https://github.com/xtermjs/xterm.js
> * https://github.com/microsoft/node-pty
> * https://github.com/socketio/socket.io
> * https://github.com/ysk2014/webshell

