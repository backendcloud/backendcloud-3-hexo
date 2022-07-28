---
title: Github Releases 和 Github Badges
readmore: false
date: 2022-05-09 18:29:30
categories: Devops
tags:
- goreleaser
- Github
- Metrics
- Profile
- Badges
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

# goreleaser - 一键多平台打包工具

https://github.com/goreleaser/goreleaser/releases 下载`goreleaser`

创建一个go hello项目，仅包含一个main文件
```go
package main

import "fmt"

func main() {
    fmt.Println("hello world")
}
```

初始化配置
```bash
PS C:\Users\hanwei\Documents\GitHub\example\goreleaser> C:\Users\hanwei\Downloads\goreleaser_Windows_x86_64\goreleaser.exe init
   • Generating .goreleaser.yaml file
   • config created; please edit accordingly to your needs file=.goreleaser.yaml
```


执行上面的命令会生成 `.goreleaser.yaml`，可以稍微编辑下goos：目标系统，goarch：目标CPU架构。goos和goarch是乘积关系。
```yaml
# This is an example .goreleaser.yml file with some sensible defaults.
# Make sure to check the documentation at https://goreleaser.com
before:
  hooks:
    # You may remove this if you don't use go modules.
    - go mod tidy
    # you may remove this if you don't need go generate
    - go generate ./...
builds:
  - env:
      - CGO_ENABLED=0
    goos:
      - linux
      - windows
      - darwin
    goarch:
      - amd64
      - arm
archives:
  - replacements:
      darwin: Darwin
      linux: Linux
      windows: Windows
      386: i386
      amd64: x86_64
checksum:
  name_template: 'checksums.txt'
snapshot:
  name_template: "{{ incpatch .Version }}-next"
changelog:
  sort: asc
  filters:
    exclude:
      - '^docs:'
      - '^test:'
```

执行命令 goreleaser --snapshot --skip-publish --rm-dist 生成各种版本的发布
```shell
PS C:\Users\hanwei\Documents\GitHub\example\goreleaser> C:\Users\hanwei\Downloads\goreleaser_Windows_x86_64\goreleaser.exe --snapshot --skip-publish --rm-dist
   • releasing...     
   • loading config file       file=.goreleaser.yaml
   • loading environment variables
   • getting and validating git state
      • ignoring errors because this is a snapshot error=git doesn't contain any tags. Either add a tag or use --snapshot
      • building...               commit=eb8d1cf69c8f6027c96918500d79e0913488a17d latest tag=v0.0.0
      • pipe skipped              error=disabled during snapshot mode
   • parsing tag
   • running before hooks
      • running                   hook=go mod tidy
      • running                   hook=go generate ./...
   • setting defaults 
   • snapshotting     
      • building snapshot...      version=0.0.1-next
   • checking distribution directory
   • loading go mod information
   • build prerequisites
   • writing effective config file
      • writing                   config=dist\config.yaml
   • building binaries
      • building                  binary=dist\example_darwin_amd64_v1\example
   • calculating checksums
   • storing release metadata
      • writing                   file=dist\artifacts.json
      • writing                   file=dist\metadata.json
   • release succeeded after 7.80s
PS C:\Users\hanwei\Documents\GitHub\example\goreleaser>
```

```shell
C:\Users\hanwei\Documents\GitHub\example\goreleaser>tree /F
.
│  .gitignore
│  .goreleaser.yaml
│  demo1.go
│  go.mod
│
└─dist
    │  artifacts.json
    │  checksums.txt
    │  config.yaml
    │  example_0.0.1-next_Darwin_x86_64.tar.gz
    │  example_0.0.1-next_Linux_armv6.tar.gz
    │  example_0.0.1-next_Linux_x86_64.tar.gz
    │  example_0.0.1-next_Windows_armv6.tar.gz
    │  example_0.0.1-next_Windows_x86_64.tar.gz
    │  metadata.json
    │
    ├─example_darwin_amd64_v1
    │      example
    │
    ├─example_linux_amd64_v1
    │      example
    │
    ├─example_linux_arm_6
    │      example
    │
    ├─example_windows_amd64_v1
    │      example.exe
    │
    └─example_windows_arm_6
            example.exe
```

上面的命令会在本机生成各种平台的版本发布。也可以执行`goreleaser.exe --rm-dist`发布到github release页面，执行发布到github release页面前，需要先打tag和设置GITHUB_TOKEN
```bash
PS C:\Users\hanwei\Documents\GitHub\example\goreleaser> git tag -a v0.3.0 -m "release v0.3.0"
PS C:\Users\hanwei\Documents\GitHub\example\goreleaser> git push origin v0.3.0

#下面是windows平台设置环境变量方法，mac和linux平台用export
PS C:\Users\hanwei\Documents\GitHub\example\goreleaser> $env:GITHUB_TOKEN='xxx'
PS C:\Users\hanwei\Documents\GitHub\example\goreleaser>  C:\go\bin\goreleaser.exe --rm-dist                         
   • releasing...     
   • loading config file       file=.goreleaser.yaml
   • loading environment variables
   • getting and validating git state
      • building...               commit=bf2d26ef3ada8efdbc38e6635d6f42a5e2f9bd2d latest tag=v0.3.0
   • parsing tag      
   • setting defaults
   • checking distribution directory
      • --rm-dist is set, cleaning it up
   • loading go mod information
   • build prerequisites
   • writing effective config file
      • writing                   config=dist\config.yaml
   • generating changelog
      • writing                   changelog=dist\CHANGELOG.md
   • building binaries
      • building                  binary=dist\example_linux_amd64_v1\example
      • building                  binary=dist\example_linux_arm_6\example
      • building                  binary=dist\example_darwin_amd64_v1\example
      • building                  binary=dist\example_windows_arm_6\example.exe
      • building                  binary=dist\example_windows_amd64_v1\example.exe
   • archives         
      • creating                  archive=dist\example_0.3.0_Darwin_x86_64.tar.gz
      • creating                  archive=dist\example_0.3.0_Windows_armv6.tar.gz
      • creating                  archive=dist\example_0.3.0_Linux_armv6.tar.gz
      • creating                  archive=dist\example_0.3.0_Linux_x86_64.tar.gz
      • creating                  archive=dist\example_0.3.0_Windows_x86_64.tar.gz
   • calculating checksums
   • storing release metadata
      • writing                   file=dist\artifacts.json
      • writing                   file=dist\metadata.json
   • publishing
      • scm releases
         • creating or updating release repo=backendcloud/example tag=v0.3.0
         • uploading to release      file=dist\checksums.txt name=checksums.txt
         • uploading to release      file=dist\example_0.3.0_Windows_armv6.tar.gz name=example_0.3.0_Windows_armv6.tar.gz
         • uploading to release      file=dist\example_0.3.0_Linux_x86_64.tar.gz name=example_0.3.0_Linux_x86_64.tar.gz
         • uploading to release      file=dist\example_0.3.0_Windows_x86_64.tar.gz name=example_0.3.0_Windows_x86_64.tar.gz
         • uploading to release      file=dist\example_0.3.0_Darwin_x86_64.tar.gz name=example_0.3.0_Darwin_x86_64.tar.gz
         • uploading to release      file=dist\example_0.3.0_Linux_armv6.tar.gz name=example_0.3.0_Linux_armv6.tar.gz
   • announcing       
   • release succeeded after 7.47s
PS C:\Users\hanwei\Documents\GitHub\example\goreleaser>
```
![](/images/github-profile/3121d5cc.png)
![](/images/github-profile/a0cf8876.png)

> goreleaser demo项目源码放在： https://github.com/backendcloud/example/tree/master/goreleaser

# 添加代码仓库的跟踪统计
![](/images/github-profile/679dbcf1.png)
一般的开源项目都有类似上面的统计标签，实现起来有很多种方式，比如travis网站可以生成ci的状态，coveralls网站可以生成覆盖率情况，下面的网站可以生成大量类型的标签，复制对应的markdown，复制到自己代码仓库的README.md文件中：

> 参考： https://shields.io/

例如：
https://github.com/backendcloud/example 下的README.md文件添加：

```markdown
![GitHub language count](https://img.shields.io/github/languages/count/backendcloud/example) ![Lines of code](https://img.shields.io/tokei/lines/github/backendcloud/example)
```

# 手动添加github的profile

> 和Github用户名同名的仓库的README.md可以同时作为自己的Github的profile。换成大白话就是，同名仓库 是一个特殊的仓库，你可以通过添加一个 README.md 显示在你的Github个人主页。

>  参考： https://github.com/anuraghazra/github-readme-stats

统计自己github的基本情况，比如提交，start数等；统计自己github代码的语言种类的比重。（将username换成自己github的用户名）
```markdown
<img align="middle" src="https://github-readme-stats.vercel.app/api?username=backendcloud&show_icons=true&icon_color=CE1D2D&text_color=718096&bg_color=ffffff&hide_title=true" />

[![Top Langs](https://github-readme-stats.vercel.app/api/top-langs/?username=backendcloud&langs_count=10&layout=compact)](https://github.com/anuraghazra/github-readme-stats)
```


# Github Action自动添加github的profile

在和Github用户名同名的仓库添加Github Actions。在push自己的profile的时候更新，或者每天更新一次，比如设置夜里03:30更新下自己的Github Metrics。
```yaml
name: Example
uses: lowlighter/metrics@latest
with:
  filename: metrics.classic.svg
  token: ${{ secrets.METRICS_TOKEN }}
  base: header, repositories
  plugin_lines: yes
```
![](/images/github-profile/ce1f0572.png)

```yaml
name: Metrics
on:
  # Schedule updates (each hour)
  schedule: [{cron: "30 3 * * *"}]
  # Lines below let you run workflow manually and on each commit (optional)
  workflow_dispatch:
  push: {branches: ["master", "main"]}
jobs:
  github-metrics:
    runs-on: ubuntu-latest
    steps:
      # See action.yml for all options
      - uses: lowlighter/metrics@latest
        with:
          # Your GitHub token
          token: ${{ secrets.METRICS_TOKEN }}
          plugin_habits: yes
          plugin_languages: yes
          plugin_lines: yes
          plugin_notable: yes
          plugin_achievements: yes
          plugin_achievements_only: polyglot, contributor, inspirer, maintainer, developer, influencer, deployer
```
![](/images/github-profile/fef239d6.png)