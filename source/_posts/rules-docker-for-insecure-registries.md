---
title: 发布一个开源小项目 rules_docker_for_insecure_registries
readmore: false
date: 2022-08-04 18:34:06
categories: Tools
tags:
- 后端云小项目
---

# 需求背景

Bazel构建的过程中向http服务的镜像仓库推送镜像会报错。

原因还是以前常见的镜像服务错误：http: server gave HTTP response to HTTPS client

传统的对策是：

**对于Podman**

编辑 /etc/containers/registries.conf 增加：

```bash
[[registry]]
location = "localhost:5000"
insecure = true
```

**对于Docker**

`vi /usr/lib/systemd/system/docker.service` 找到 `ExecStart`，在其末尾添加如下内容（IP 则为 registry 主机的 IP）： `--insecure-registry 192.168.60.128:5000`

然而Bazel构建下上述传统的方式不管用，因为Bazel的构建环境和在命令行执行的环境不太一样。Bazel构建官方维护的仓库目前还不支持不安全的镜像仓库，要修复上面的错误，要么改bazel rule_docker代码，要么做个安全的镜像仓库 https://docs.docker.com/registry/deploying/#run-an-externally-accessible-registry

后者网上有很多教程，这里不说了。这里说下用前一种方式：修改bazel rule_docker代码。

# 使用方法


```bash
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "95d39fd84ff4474babaf190450ee034d958202043e366b9fc38f438c9e6c3334",
    strip_prefix = "rules_docker-0.16.0",
    urls = [
        "https://github.com/bazelbuild/rules_docker/releases/download/v0.16.0/rules_docker-v0.16.0.tar.gz",
        "https://storage.googleapis.com/builddeps/95d39fd84ff4474babaf190450ee034d958202043e366b9fc38f438c9e6c3334",
    ],
)
```

在项目根目录的WORKSPACE中将上面的内容替换成下面的内容：

```bash
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "4985f2084b414a281c5abf36e3dbe4be274ec93f28eca82bbf0dd42c0dfef449",
    urls = ["https://github.com/backendcloud/rules_docker_for_insecure_registries/releases/download/rules_docker_for_insecure_registries/rules_docker-v0.25.2.tar.gz"],
)
```


# 使用前后对比

```bash
 ⚡ root@backendcloud  ~/example/bazel-sample/docker   master ±  make docker-push
bazel run --define=IMAGE_TAG=v1.0.0 //cmd:image-push
INFO: Analyzed target //cmd:image-push (1 packages loaded, 5 targets configured).
INFO: Found 1 target...
Target //cmd:image-push up-to-date:
  bazel-bin/cmd/image-push.digest
  bazel-bin/cmd/image-push
INFO: Elapsed time: 0.264s, Critical Path: 0.01s
INFO: 2 processes: 2 internal.
INFO: Build completed successfully, 2 total actions
INFO: Build completed successfully, 2 total actions
2022/08/04 17:58:31 Error pushing image to 120.26.200.226:5000/backendcloud/bazel-sample-cmd:v1.0.0: unable to push image to 120.26.200.226:5000/backendcloud/bazel-sample-cmd:v1.0.0: Get "https://120.26.200.226:50t
make: *** [Makefile:2: docker-push] Error 1
 ✘ ⚡ root@backendcloud  ~/example/bazel-sample/docker   master ±  vi cmd/BUILD.bazel
 ⚡ root@backendcloud  ~/example/bazel-sample/docker   master ±  make docker-push  
bazel run --define=IMAGE_TAG=v1.0.0 //cmd:image-push
INFO: Analyzed target //cmd:image-push (1 packages loaded, 5 targets configured).
INFO: Found 1 target...
Target //cmd:image-push up-to-date:
  bazel-bin/cmd/image-push.digest
  bazel-bin/cmd/image-push
INFO: Elapsed time: 0.222s, Critical Path: 0.01s
INFO: 2 processes: 2 internal.
INFO: Build completed successfully, 2 total actions
INFO: Build completed successfully, 2 total actions
2022/08/04 17:58:45 Successfully pushed Docker image to 120.26.200.226:5000/backendcloud/bazel-sample-cmd:v1.0.0 - 120.26.200.226@sha256:322b44c93453aaaa21bb1584caa16cb56f178230f5bb47a93d7ab4b4279dd2fe
```

将旧的rules_docker替换成新的，发现可以推送镜像到http的镜像仓库了。