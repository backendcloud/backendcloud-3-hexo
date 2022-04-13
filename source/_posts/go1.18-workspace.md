---
title: Go 1.18 新特性 - 工作区
date: 2022-04-13 20:17:47
categories: Tools
tags:
- Go
- workspace
---

> 多模块管理的时候，有的模块还在开发中，还没发布到github上，过去通过replace来做的，go1.18 新增了工作区特性，给多模块管理提供了方便。

# 过去的replace模式

```bash
hanwei@hanweideMacBook-Air golang]$ go version
go version go1.18 darwin/arm64
hanwei@hanweideMacBook-Air golang]$ mkdir go1.18-workspace/
hanwei@hanweideMacBook-Air golang]$ cd go1.18-workspace/
hanwei@hanweideMacBook-Air go1.18-workspace]$ mkdir mypkg example
hanwei@hanweideMacBook-Air go1.18-workspace]$ tree
.
├── example
└── mypkg

2 directories, 0 files
hanwei@hanweideMacBook-Air go1.18-workspace]$ go mod init github.com/go1.18-workspace/mypkg
go: creating new go.mod: module github.com/go1.18-workspace/mypkg
go: to add module requirements and sums:
        go mod tidy
hanwei@hanweideMacBook-Air go1.18-workspace]$ cd mypkg/
hanwei@hanweideMacBook-Air mypkg]$ touch bar.go
hanwei@hanweideMacBook-Air mypkg]$ vi bar.go 
hanwei@hanweideMacBook-Air mypkg]$ cat bar.go 
package mypkg

func Bar() {
        println("This is package mypkg")
}
hanwei@hanweideMacBook-Air mypkg]$ cd ../example/
hanwei@hanweideMacBook-Air example]$ go mod init github.com/go1.18-workspace/example
go: creating new go.mod: module github.com/go1.18-workspace/example
go: to add module requirements and sums:
        go mod tidy
hanwei@hanweideMacBook-Air example]$ touch main.go
hanwei@hanweideMacBook-Air example]$ vi main.go 
hanwei@hanweideMacBook-Air example]$ cat main.go 
package main

import (
    "github.com/go1.18-workspace/mypkg"
)

func main() {
    mypkg.Bar()
}
```
这时候，如果我们运行 go mod tidy，肯定会报错，因为我们的 mypkg 包根本没有提交到 github 上，肯定找不到。
```bash
hanwei@hanweideMacBook-Air example]$ go mod tidy
go: finding module for package github.com/go1.18-workspace/mypkg
github.com/go1.18-workspace/example imports
        github.com/go1.18-workspace/mypkg: cannot find module providing package github.com/go1.18-workspace/mypkg: module github.com/go1.18-workspace/mypkg: git ls-remote -q origin in /Users/hanwei/GoProjects/pkg/mod/cache/vcs/2c423cac5ebc1b2d018ef93a87560d369abd7dec6c155b46cddb11299415bc09: exit status 128:
        remote: Repository not found.
        fatal: repository 'https://github.com/go1.18-workspace/mypkg/' not found
hanwei@hanweideMacBook-Air example]$ go run main.go
main.go:4:5: no required module provides package github.com/go1.18-workspace/mypkg; to add it:
        go get github.com/go1.18-workspace/mypkg
```
go run main.go 也就不成功。

我们当然可以提交 mypkg 到 github，但我们每修改一次 mypkg，就需要提交，否则 example 中就没法使用上最新的。

针对这种情况，目前是建议通过 replace 来解决，即在 example 中的 go.mod 增加如下 replace：
```bash
hanwei@hanweideMacBook-Air example]$ go mod edit -replace=github.com/go1.18-workspace/mypkg=../mypkg
hanwei@hanweideMacBook-Air example]$ cat go.mod 
module github.com/go1.18-workspace/example

go 1.18

replace github.com/go1.18-workspace/mypkg => ../mypkg
```
（v1.0.0 根据具体情况修改，还未提交，可以使用 v1.0.0）
```bash
hanwei@hanweideMacBook-Air example]$ cat go.mod 
module github.com/go1.18-workspace/example

go 1.18

require github.com/go1.18-workspace/mypkg v1.0.0
replace github.com/go1.18-workspace/mypkg => ../mypkg
hanwei@hanweideMacBook-Air example]$ tree ..
..
├── example
│   ├── go.mod
│   └── main.go
└── mypkg
    ├── bar.go
    └── go.mod

2 directories, 4 files
```
再次运行 go run main.go，输出如下：
```bash
hanwei@hanweideMacBook-Air example]$ go run main.go 
This is package mypkg
```

# 工作区模式

将上面的replace注释，再执行go run main.go，报错
```bash
hanwei@hanweideMacBook-Air example]$ cat go.mod 
module github.com/go1.18-workspace/example

go 1.18

//require github.com/go1.18-workspace/mypkg v1.0.0
//replace github.com/go1.18-workspace/mypkg => ../mypkg
hanwei@hanweideMacBook-Air example]$ go run main.go 
main.go:4:5: missing go.sum entry for module providing package github.com/go1.18-workspace/mypkg; to add:
        go mod download github.com/go1.18-workspace/mypkg
```
初始化 workspace
```bash
hanwei@hanweideMacBook-Air go1.18-workspace]$ go version
go version go1.18 darwin/arm64
hanwei@hanweideMacBook-Air go1.18-workspace]$ go work init example mypkg
hanwei@hanweideMacBook-Air go1.18-workspace]$ tree
.
├── example
│   ├── go.mod
│   └── main.go
├── go.work
└── mypkg
    ├── bar.go
    └── go.mod

2 directories, 5 files
hanwei@hanweideMacBook-Air go1.18-workspace]$ cat go.work 
go 1.18

use (
        ./example
        ./mypkg
)
hanwei@hanweideMacBook-Air example]$ go run main.go 
This is package mypkg
```
可见用工作区比replace方便太多了。

> go.work 文件的语法和 go.mod 类似，因此也支持 replace。

> 注意，go.work 不需要提交到 Git 中，因为它只是你本地开发使用的。

> 在 GOPATH 年代，多 GOPATH 是一个头疼的问题。当时没有很好的解决，Module 就出现了，多 GOPATH 问题因此消失。但多 Module 问题随之出现。Workspace 方案较好的解决了这个问题。
