---
title: v6bindv4 和 golang
readmore: true
date: 2022-11-16 12:57:10
categories: 云原生
tags:
---


And it means that it is an IPv6 socket that is used for IPv4 communication. Application and socket-wise, it is IPv6 but network and packet-wise it is IPv4. This is allowed as a transition mechanism if net.ipv6.bindv6only=0 and the application didn't set the socket option IPV6_V6ONLY. It seems that some recent OSes disable this option by default so that IPv6 sockets can handle only real IPv6 communications. 

这意味着它是一个用于 IPv4通信的 IPv6套接字。应用程序和套接字方面，它是 IPv6，但网络和数据包方面，它是 IPv4。如果 net.IPV6.bindv6only = 0并且应用程序没有设置套接字选项 IPV6 _ V6ONLY，则允许使用这种转换机制。似乎最近的一些操作系统在默认情况下禁用了这个选项，因此 IPv6套接字只能处理真正的 IPv6通信。

IPv6 applications compatibility with IPv4 applications

Socket applications written with AF_INET6 address family allow Internet Protocol version 6 (IPv6) applications to work with Internet Protocol version 4 (IPv4) applications (those applications that use AF_INET address family). This feature allows socket programmers to use an IPv4-mapped IPv6 address format. This address format represents the IPv4 address of an IPv4 node to be represented as an IPv6 address. The IPv4 address is encoded into the low-order 32 bits of the IPv6 address, and the high-order 96 bits hold the fixed prefix 0:0:0:0:0:FFFF. For example, an IPv4-mapped address can look like this:

::FFFF:192.1.1.1

These addresses can be generated automatically by the getaddrinfo() API, when the specified host has only IPv4 addresses.

这些地址包含一个嵌入式全局 IPv4地址。它们用于将 IPv4节点的地址表示为 IPv6地址，用于支持 IPv6并使用 AF _ INET6套接字的应用程序。这允许支持 IPv6的应用程序始终以 IPv6格式处理 IP 地址，而不管 TCP/IP 通信是通过 IPv4还是 IPv6网络进行的。双模式 TCP/IP 栈执行 IPv4映射的地址与本机 IPv4格式之间的转换。IPv4映射的地址具有以下格式:

前80位全0，中间16位全1，后面32位是ipv4地址，例如 `::FFFF:129.144.52.38`

