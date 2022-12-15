---
title: Golang标准库time（2） - timer和ticker
readmore: true
date: 2022-12-15 18:44:01
categories: 云原生
tags:
- Golang
---

timer也叫定时器，ticker是反复触发的定时器。实际上 timer和ticker 的代码已经都不在time标准库里了，都在golang的runtime包里。



timer 的触发 设计golang的GMP，golang的调度，待以后再分析。