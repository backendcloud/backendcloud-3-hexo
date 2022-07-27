---
title: Bazel rules_docker 使用
readmore: true
date: 2022-07-27 13:22:53
categories: Devops
tags:
- Bazel
---


> 本篇的代码放在： https://github.com/backendcloud/example/tree/master/bazel-sample/docker-go-image


WORKSPACE文件内容：
* 加载rules_go
* 加载rules_docker
* 加载gazelle
* 准备基础镜像alpine_linux_amd64和distroless_linux_amd64 （类似Dockerfile的FROM）


```bash
 ⚡ root@localhost  ~/bazel-sample/docker   main ±  cat WORKSPACE 
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "2b1641428dff9018f9e85c0384f03ec6c10660d935b750e3fa1492a281a53b0f",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.29.0/rules_go-v0.29.0.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.29.0/rules_go-v0.29.0.zip",
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "de69a09dc70417580aabf20a28619bb3ef60d038470c7cf8442fafcf627c21cb",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.24.0/bazel-gazelle-v0.24.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.24.0/bazel-gazelle-v0.24.0.tar.gz",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")

go_rules_dependencies()

go_register_toolchains(version = "1.17.2")

gazelle_dependencies()

# Docker
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "59536e6ae64359b716ba9c46c39183403b01eabfbd57578e84398b4829ca499a",
    strip_prefix = "rules_docker-0.22.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.22.0/rules_docker-v0.22.0.tar.gz"],
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

container_repositories()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()

load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
)

container_pull(
    name = "alpine_linux_amd64",
    registry = "index.docker.io",
    repository = "library/alpine",
    tag = "3.15",
)

container_pull(
    name = "distroless_linux_amd64",
    registry = "gcr.io",
    repository = "distroless/base",
    tag = "latest",
)
```


BUILD文件：
```bash
 ⚡ root@localhost  ~/bazel-sample/docker   main ±  cat cmd/BUILD.bazel
load("@io_bazel_rules_go//go:def.bzl", "go_binary", "go_library")
load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_push")

go_library(
    name = "cmd_lib",
    srcs = ["main.go"],
    importpath = "github.com/jun06t/bazel-sample/docker/cmd",
    visibility = ["//visibility:private"],
)

go_binary(
    name = "cmd",
    embed = [":cmd_lib"],
    visibility = ["//visibility:public"],
)

container_image(
    name = "image",
#    base = "@alpine_linux_amd64//image",
    base = "@distroless_linux_amd64//image",
    entrypoint = ["/cmd"],
    files = [":cmd"],
    repository = "backendcloud/bazel-sample-cmd",
)

container_push(
    name = "image-push",
    format = "Docker",
    image = ":image",
    registry = "localhost:5000",
    repository = "backendcloud/bazel-sample-cmd",
    tag = "$(IMAGE_TAG)",
)
```


部署个镜像仓库：
```bash
docker run -d -p 5000:5000 --restart=always --name registry registrydocker run -d -p 5000:5000 --restart=always --name registry registry
curl http://192.168.190.130:5000/v2/
```
返回`{}`表示仓库状态正常。


准备Makefile：
```bash
 ⚡ root@localhost  ~/bazel-sample/docker   main ±  cat Makefile 
docker-push:
        bazelisk run --define=IMAGE_TAG=v1.0.0 //cmd:image-push
```

Run（镜像制作和push到镜像仓库）：
```bash
 ⚡ root@localhost  ~/bazel-sample/docker   main ±  make docker-push  
bazelisk run --define=IMAGE_TAG=v1.0.0 //cmd:image-push
INFO: Analyzed target //cmd:image-push (1 packages loaded, 5 targets configured).
INFO: Found 1 target...
Target //cmd:image-push up-to-date:
  bazel-bin/cmd/image-push.digest
  bazel-bin/cmd/image-push
INFO: Elapsed time: 0.332s, Critical Path: 0.01s
INFO: 2 processes: 2 internal.
INFO: Build completed successfully, 2 total actions
INFO: Build completed successfully, 2 total actions
2022/07/27 09:02:56 Successfully pushed Docker image to localhost:5000/backendcloud/bazel-sample-cmd:v1.0.0
```

