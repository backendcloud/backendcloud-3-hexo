---
title: Starlark语言
readmore: true
date: 2022-07-01 10:53:07
categories: Devops
tags:
- Bazel
- Starlark
---


Tensorflow， Envoy， Kubernetes， KubeVirt 等等大型项目都是用 Bazel 构建的，要参与开发这些项目或者基于这些项目做开发，不能避开Bazel，且Bazel是当前开源Build System里最先进也最代表着未来方向的产品，非常有必要掌握。

Starlark是一门配置语言，语法类似 Python。与 Python 不同，独立的 Starlark 线程是并行执行的，因此 Starlark 工作负载在并行机器上可以很好地伸缩。

在了解Starlark前，要先对go代码中嵌入其他语言，以及用go写的其他脚本语言的解释器做下了解。

# otto：A JavaScript interpreter in Go (golang)