---
title: Hello, Deno
readmore: true
date: 2022-07-25 13:17:15
categories: Fuchsia
tags:
---

# Deno 是什么
现代JS/TS的运行时。

Deno的创始人和Node的创始人是同一个人。把Node的前两个字母和后两个字母调换了下，destroy node，要用Rust重写js/ts的运行时，来解决设计Node.js之初的缺陷，并要在Deno中解决这些问题。

# Deno 和 Node 的对比

|对比|Node|Deno|
|---|---|---|
|开发语言|C++|Rust|
|工具链|npm，webpack，babel，typescript、eslint、prettier。。。|部分工具集成在Deno中|
|运行时|是JS的运行时|JS，TS，WebAssembly的运行时|
|安全控制|无|有安全控制，需要某个权限要显式打开权限才可以|
|异步|Callback，被称为回調地獄。很多Node原生API都是使用 CallBack Function 而不是 Promise|原生使用Promise|
|异步运行时|libuv |Tokio|
|JS模块化规范|使用CommonJS，与 ES 模块不兼容|只支持 ES 模块，跟浏览器的模块加载规则一致，不支持 CommonJS 模块|
|模块系统|中心化模块系统npm|去中心化模块系统，可以从任何地方加载模块。这点类似Golang|

# install

Deno是Rust的模块，可以用cargo安装。也可以用脚本安装。

```bash
# 三种安装方式：
Rust包安装：cargo install deno --locked
win: iwr https://deno.land/install.ps1 -useb | iex
linux/Mac: curl -fsSL https://deno.land/install.sh | sh
```

# run

## hello world

```bash
PS C:\Users\hanwei> deno run https://deno.land/std/examples/welcome.ts
Download https://deno.land/std/examples/welcome.ts
Warning Implicitly using latest version (0.149.0) for https://deno.land/std/examples/welcome.ts
Download https://deno.land/std@0.149.0/examples/welcome.ts
Welcome to Deno! deno run https://deno.land/std/examples/welcome.ts
Download https://deno.land/std/examples/welcome.ts
Warning Implicitly using latest version (0.149.0) for https://deno.land/std/examples/welcome.ts
Download https://deno.land/std@0.149.0/examples/welcome.ts
Welcome to Deno!
```

## 发送 HTTP 请求
```bash
PS C:\Users\hanwei> deno run --allow-net=example.com https://deno.land/std/examples/curl.ts https://example.com
<!doctype html>
<html>
<head>
    <title>Example Domain</title>
    ...
```

## 读取文件
```bash
PS C:\Users\hanwei> deno run --allow-read https://deno.land/std@/examples/cat.ts "C:\Windows\System32\Drivers\etc\hosts"

Download https://deno.land/std@/examples/cat.ts
error: Module not found "https://deno.land/std@/examples/cat.ts".
PS C:\Users\hanwei> deno run --allow-read https://deno.land/std/examples/cat.ts "C:\Windows\System32\Drivers\etc\hosts"
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.


# localhost name resolution is handled within DNS itself.
#       127.0.0.1       localhost
#       ::1             localhost
```

## TCP服务器
这是一个服务器的例子，它接受端口 8080 上的连接，并向客户机返回它发送的任何内容。linux用nc测试，windows可用telnet测试。 nc localhost 8080 或者 telnet localhost 8080

```bash
PS C:\Users\hanwei> deno run --allow-net https://deno.land/std/examples/echo_server.ts
Listening on http://localhost:8080

```

