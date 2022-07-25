---
title: 扩展 Bazel 的构建(workinprocess)
readmore: true
date: 2022-07-25 18:23:16
categories: Devops
tags:
- Bazel
---

# 扩展 Bazel 的构建

本篇介绍何使用宏和规则扩展 Bazel 的构建。

# Starlark 语言

> 参考 <a href="https://www.backendcloud.cn/2022/07/01/bazel-starlark/" target="_blank">https://www.backendcloud.cn/2022/07/01/bazel-starlark/</a>

# 宏和规则（Macros and rules）

宏是实例化规则的函数。当 BUILD 文件过于重复或过于复杂时，它就非常有用，因为它允许您重复使用某些代码。

规则比宏更强大。它可以访问 Bazel 内部信息，并完全掌控将要处理的内容。例如，它可以将信息传递给其他规则。

如果您想重复使用简单的逻辑，请从宏开始。如果宏变得复杂，通常最好使其成为规则。对新语言的支持通常通过规则来实现，例如 rules_go( https://github.com/bazelbuild/rules_go )。规则适用于高级用户，大多数用户永远都不需要编写规则；它们只会加载和调用现有规则。

# 共享变量

着代码库和 BUILD 文件越大，可能会注意到一些重复项，例如：
```bash
cc_library(
  name = "foo",
  copts = ["-DVERSION=5"],
  srcs = ["foo.cc"],
)

cc_library(
  name = "bar",
  copts = ["-DVERSION=5"],
  srcs = ["bar.cc"],
  deps = [":foo"],
)
```

## 同一个BUILD文件使用共享变量
```bash
COPTS = ["-DVERSION=5"]

cc_library(
  name = "foo",
  copts = COPTS,
  srcs = ["foo.cc"],
)

cc_library(
  name = "bar",
  copts = COPTS,
  srcs = ["bar.cc"],
  deps = [":foo"],
)
```

## 不同BUILD文件使用共享变量

在 path/to/variables.bzl 中，写入：

```bash
COPTS = ["-DVERSION=5"]
```

然后，可以在 BUILD 文件以访问变量：

```bash
load("//path/to:variables.bzl", "COPTS")

cc_library(
  name = "foo",
  copts = COPTS,
  srcs = ["foo.cc"],
)

cc_library(
  name = "bar",
  copts = COPTS,
  srcs = ["bar.cc"],
  deps = [":foo"],
)
```