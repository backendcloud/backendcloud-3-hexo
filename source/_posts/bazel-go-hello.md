---
title: Bazel Golang hello-world
readmore: true
date: 2022-07-13 18:33:48
categories: Devops
tags:
- Bazel
- KubeVirt CI
---

# Golang hello-world

> 代码放在 https://github.com/backendcloud/example/tree/master/bazel-go-hello/hello

先用Go写个hello-world源文件。执行`go mod init`和`go mod tidy`

```bash
[root@localhost hello]# cat main/main.go 
package main
import "fmt"
func main() {
    fmt.Println("hello world")
}
[root@localhost hello]# ls
main
[root@localhost hello]# go mod init hello
go: creating new go.mod: module hello
go: to add module requirements and sums:
        go mod tidy
[root@localhost hello]# ls
go.mod  main
[root@localhost hello]# go mod tidy
```

编写bazel所需的WORKSPACE (WORKSPACE中加上rules_go)

```bash
[root@localhost hello]# cat WORKSPACE 
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "685052b498b6ddfe562ca7a97736741d87916fe536623afb7da2824c0211c369",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.33.0/rules_go-v0.33.0.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.33.0/rules_go-v0.33.0.zip",
    ],
)


load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains(version = "1.18.3")
```

```bash
[root@localhost hello]# bazel build //main:main
ERROR: Skipping '//main:main': no such package 'main': BUILD file not found in any of the following directories. Add a BUILD file to a directory to mark it as a package.
 - /root/hello/main
WARNING: Target pattern parsing failed.
ERROR: no such package 'main': BUILD file not found in any of the following directories. Add a BUILD file to a directory to mark it as a package.
 - /root/hello/main
INFO: Elapsed time: 0.137s
INFO: 0 processes.
FAILED: Build did NOT complete successfully (0 packages loaded)
[root@localhost hello]# bazel run //main:main
ERROR: Skipping '//main:main': no such package 'main': BUILD file not found in any of the following directories. Add a BUILD file to a directory to mark it as a package.
 - /root/hello/main
WARNING: Target pattern parsing failed.
ERROR: no such package 'main': BUILD file not found in any of the following directories. Add a BUILD file to a directory to mark it as a package.
 - /root/hello/main
INFO: Elapsed time: 0.127s
INFO: 0 processes.
FAILED: Build did NOT complete successfully (0 packages loaded)
FAILED: Build did NOT complete successfully (0 packages loaded)
```

这时执行bazel build和run，会报错，因为源码所在文件夹main文件夹里还没有BUILD.bazel文件和文件内容。该文件可以手动编写也可以用gazelle自动生成。下面分别介绍手动编写和自动生成BUILD.bazel文件。

```bash
[root@localhost hello]# vi main/BUILD.bazel
[root@localhost hello]# cat main/BUILD.bazel
load("@io_bazel_rules_go//go:def.bzl", "go_binary")

go_binary(
    name = "main",
    srcs = ["main.go"],
)
[root@localhost hello]# bazel build //main:main
INFO: Analyzed target //main:main (1 packages loaded, 2 targets configured).
INFO: Found 1 target...
Target //main:main up-to-date:
  bazel-bin/main/main_/main
INFO: Elapsed time: 0.318s, Critical Path: 0.13s
INFO: 3 processes: 1 internal, 2 linux-sandbox.
INFO: Build completed successfully, 3 total actions
[root@localhost hello]# bazel run //main:main
INFO: Analyzed target //main:main (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //main:main up-to-date:
  bazel-bin/main/main_/main
INFO: Elapsed time: 0.159s, Critical Path: 0.00s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
hello world
```

手动编辑源码所在文件夹main文件夹BUILD.bazel文件后，bazel build和run成功，下面介绍gazelle自动生成源码文件夹对应的BUILD.bazel文件。

先删除BUILD.bazel文件。

```bash
[root@localhost hello]# tree main
main
├── BUILD.bazel
└── main.go

0 directories, 2 files
[root@localhost hello]# rm -rf main/BUILD.bazel 
[root@localhost hello]# tree main
main
└── main.go

0 directories, 1 file
```

WORKSPACE文件增加gazelle相关内容。

```bash
[root@localhost hello]# vi WORKSPACE 
[root@localhost hello]# cat WORKSPACE 
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "685052b498b6ddfe562ca7a97736741d87916fe536623afb7da2824c0211c369",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.33.0/rules_go-v0.33.0.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.33.0/rules_go-v0.33.0.zip",
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "5982e5463f171da99e3bdaeff8c0f48283a7a5f396ec5282910b9e8a49c0dd7e",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.25.0/bazel-gazelle-v0.25.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.25.0/bazel-gazelle-v0.25.0.tar.gz",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

go_rules_dependencies()

go_register_toolchains(version = "1.18.3")
gazelle_dependencies()
```

```bash
[root@localhost hello]# bazel run //:gazelle
ERROR: Skipping '//:gazelle': no such package '': BUILD file not found in any of the following directories. Add a BUILD file to a directory to mark it as a package.
 - /root/hello
WARNING: Target pattern parsing failed.
ERROR: no such package '': BUILD file not found in any of the following directories. Add a BUILD file to a directory to mark it as a package.
 - /root/hello
INFO: Elapsed time: 0.157s
INFO: 0 processes.
FAILED: Build did NOT complete successfully (0 packages loaded)
FAILED: Build did NOT complete successfully (0 packages loaded)
```

忘记项目根目录写BUILD.bazel文件的gazelle内容了。补上。

```bash
[root@localhost hello]# cat BUILD.bazel 
load("@bazel_gazelle//:def.bzl", "gazelle")

# gazelle:prefix github.com/example/project
gazelle(name = "gazelle")
```


```bash
[root@localhost hello]# bazel run //:gazelle
INFO: Analyzed target //:gazelle (34 packages loaded, 407 targets configured).
INFO: Found 1 target...
ERROR: /root/.cache/bazel/_bazel_root/8516ecc87a690cd3acb37f3088b16cd1/external/org_golang_x_mod/module/BUILD.bazel:3:11: GoCompilePkg external/org_golang_x_mod/module/module.a [for host] failed: (Exit 1): builder failed: error executing command bazel-out/host/bin/external/go_sdk/builder compilepkg -sdk external/go_sdk -installsuffix linux_amd64 -src external/org_golang_x_mod/module/module.go -src external/org_golang_x_mod/module/pseudo.go ... (remaining 24 arguments skipped)

Use --sandbox_debug to see verbose messages from the sandbox and retain the sandbox build root for debugging
compilepkg: missing strict dependencies:
        /root/.cache/bazel/_bazel_root/8516ecc87a690cd3acb37f3088b16cd1/sandbox/linux-sandbox/16/execroot/__main__/external/org_golang_x_mod/module/module.go: import of "golang.org/x/xerrors"
No dependencies were provided.
Check that imports in Go sources match importpath attributes in deps.
Target //:gazelle failed to build
Use --verbose_failures to see the command lines of failed build steps.
INFO: Elapsed time: 47.864s, Critical Path: 1.31s
INFO: 25 processes: 15 internal, 10 linux-sandbox.
FAILED: Build did NOT complete successfully
FAILED: Build did NOT complete successfully
```

执行gazelle报错：`org_golang_x_mod/module/module.go: import of "golang.org/x/xerrors" No dependencies were provided.`

这个错误可能是gazelle v0.24 和 v0.25 的bug，将版本降至v0.23错误消失。

```bash
#http_archive(
#    name = "bazel_gazelle",
#    sha256 = "5982e5463f171da99e3bdaeff8c0f48283a7a5f396ec5282910b9e8a49c0dd7e",
#    urls = [
#        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.25.0/bazel-gazelle-v0.25.0.tar.gz",
#        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.25.0/bazel-gazelle-v0.25.0.tar.gz",
#    ],
#)

http_archive(
    name = "bazel_gazelle",
    sha256 = "62ca106be173579c0a167deb23358fdfe71ffa1e4cfdddf5582af26520f1c66f",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.23.0/bazel-gazelle-v0.23.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.23.0/bazel-gazelle-v0.23.0.tar.gz",
    ],
)
```

```bash
[root@localhost hello]# tree main
main
└── main.go

0 directories, 1 file
[root@localhost hello]# bazel run //:gazelle
INFO: Analyzed target //:gazelle (84 packages loaded, 8715 targets configured).
INFO: Found 1 target...
Target //:gazelle up-to-date:
  bazel-bin/gazelle-runner.bash
  bazel-bin/gazelle
INFO: Elapsed time: 59.258s, Critical Path: 25.89s
INFO: 26 processes: 4 internal, 22 linux-sandbox.
INFO: Build completed successfully, 26 total actions
INFO: Build completed successfully, 26 total actions
[root@localhost hello]# tree main
main
├── BUILD.bazel
└── main.go

0 directories, 2 files
[root@localhost hello]# cat main/BUILD.bazel 
load("@io_bazel_rules_go//go:def.bzl", "go_binary", "go_library")

go_library(
    name = "main_lib",
    srcs = ["main.go"],
    importpath = "github.com/example/project/main",
    visibility = ["//visibility:private"],
)

go_binary(
    name = "main",
    embed = [":main_lib"],
    visibility = ["//visibility:public"],
)
```

查看源文件对应的目录，自动生成了BUILD.bazel文件

bazel build 和 run 都正常

```bash
[root@localhost hello]# bazel build //main:main
INFO: Analyzed target //main:main (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //main:main up-to-date:
  bazel-bin/main/main_/main
INFO: Elapsed time: 0.178s, Critical Path: 0.00s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
[root@localhost hello]# bazel run //main:main
INFO: Analyzed target //main:main (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //main:main up-to-date:
  bazel-bin/main/main_/main
INFO: Elapsed time: 0.159s, Critical Path: 0.00s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
hello world
```

> 看了下gazalle代码仓库，17天前（本篇发布于2022-07-13）刚发了一个最新版本v0.26，试了下最新版BUG已经改掉，可将下面的内容替换掉WORKSPACE的相关内容

```bash
http_archive(
    name = "bazel_gazelle",
    sha256 = "501deb3d5695ab658e82f6f6f549ba681ea3ca2a5fb7911154b5aa45596183fa",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.26.0/bazel-gazelle-v0.26.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.26.0/bazel-gazelle-v0.26.0.tar.gz",
    ],
)

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")
```


# 另一个完整的Golang项目

上面的例子是个仅有一个go文件main.go的打印一句话的最小Golang项目，下面是一个具备 内部包引用 和 go.mod第三方包引用 的 简单的生成uuid 的 完整Golang项目。

> 代码放在 https://github.com/backendcloud/example/tree/master/bazel-sample/basic

```bash
 ⚡ root@localhost  ~/bazel-sample/basic   main  ls
BUILD.bazel  cmd  deps.bzl  go.mod  go.sum  uuid  WORKSPACE
 ⚡ root@localhost  ~/bazel-sample/basic   main  more cmd/*
::::::::::::::
cmd/BUILD.bazel
::::::::::::::
load("@io_bazel_rules_go//go:def.bzl", "go_binary", "go_library")

go_library(
    name = "cmd_lib",
    srcs = ["main.go"],
    importpath = "github.com/jun06t/bazel-sample/basic/cmd",
    visibility = ["//visibility:private"],
    deps = ["//uuid"],
)

go_binary(
    name = "cmd",
    embed = [":cmd_lib"],
    pure = "on",
    visibility = ["//visibility:public"],
)
::::::::::::::
cmd/main.go
::::::::::::::
package main

import (
        "log"

        "github.com/jun06t/bazel-sample/basic/uuid"
)

func main() {
        id, err := uuid.Generate()
        if err != nil {
                log.Fatal(err)
        }
        log.Println(id)
}
 ⚡ root@localhost  ~/bazel-sample/basic   main  more uuid/*
::::::::::::::
uuid/BUILD.bazel
::::::::::::::
load("@io_bazel_rules_go//go:def.bzl", "go_library")

go_library(
    name = "uuid",
    srcs = ["uuid.go"],
    importpath = "github.com/jun06t/bazel-sample/basic/uuid",
    visibility = ["//visibility:public"],
    deps = ["@com_github_google_uuid//:uuid"],
)
::::::::::::::
uuid/uuid.go
::::::::::::::
package uuid

import (
        "github.com/google/uuid"
)

func Generate() (string, error) {
        u, err := uuid.NewUUID()
        if err != nil {
                return "", err
        }
        return u.String(), nil
}
 ⚡ root@localhost  ~/bazel-sample/basic   main  more  deps.bzl 
load("@bazel_gazelle//:deps.bzl", "go_repository")

def go_dependencies():
    go_repository(
        name = "com_github_google_uuid",
        importpath = "github.com/google/uuid",
        sum = "h1:t6JiXgmwXMjEs8VusXIJk2BXHsn+wx8BZdTaoZ5fu7I=",
        version = "v1.3.0",
    )
```

```bash
 ⚡ root@localhost  ~/bazel-sample/basic   main  bazelisk build //...
INFO: SHA256 (https://golang.org/dl/?mode=json&include=all) = 5d539711d20290d769b21f137348eea164d5fd408cfc6483c9937d9e1a2a6d98
INFO: Analyzed 3 targets (31 packages loaded, 7999 targets configured).
INFO: Found 3 targets...
INFO: Elapsed time: 66.214s, Critical Path: 18.44s
INFO: 14 processes: 4 internal, 10 linux-sandbox.
INFO: Build completed successfully, 14 total actions
 ⚡ root@localhost  ~/bazel-sample/basic   main  tree bazel-bin
bazel-bin
├── cmd
│   ├── cmd_lib.a
│   └── cmd_lib.x
├── external
│   └── com_github_google_uuid
│       ├── uuid.a
│       └── uuid.x
└── uuid
    ├── uuid.a
    └── uuid.x

4 directories, 6 files
 ⚡ root@localhost  ~/bazel-sample/basic   main  bazelisk run //cmd:cmd
INFO: Analyzed target //cmd:cmd (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //cmd:cmd up-to-date:
  bazel-out/k8-fastbuild-ST-4c64f0b3d5c7/bin/cmd/cmd_/cmd
INFO: Elapsed time: 0.239s, Critical Path: 0.00s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
2022/07/26 15:40:57 4940e599-0cb6-11ed-b31b-000c297cbcd1
```

> cmd/BUILD.bazel 和 uuid/BUILD.bazel 两个文件是用 bazelisk run //:gazelle 自动生成的

> 可以在 deps.bzl 和 WORKSPACE 中手动指定go包依赖，也可以不用指定，由rules_go/gazelle自动指定。