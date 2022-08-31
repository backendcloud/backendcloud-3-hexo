---
title: KubeVirt CI 适配国内网络
readmore: true
date: 2022-08-31 12:58:50
categories: 云原生
tags:
- KubeVirt CI
---

不加修改，按照KubeVirt getting-started文档执行`make && make push && make manifests`是会报错的。

原因是国内的网络环境。

最好的方式是让网络环境成为科学的，若因网络限制，只能使用国内的网络环境，至少有两个地方需要修改：

# 添加 go package 国内代理
`hack/bootstrap.sh`的`set -e`下面加上两行

```bash
GO_PROXY="https://goproxy.cn,direct"
go env -w GOPROXY=${GO_PROXY}
```

# 项目根目录的`WORKSPACE`文件的gcr.io上的镜像换成国内可以访问的镜像。

> 因为有大量内容需要访问Github，国内针对github.com没有封掉，但让其有一定的概率访问不了，所以`make && make push && make manifests`流程即使按上面的修改后还是有一定的失败概率。