---
title: 一步步学KubeVirt CI （2） - 镜像构建
readmore: true
date: 2022-07-07 19:52:25
categories: 云原生
tags:
- KubeVirt CI
---


# 空镜像scratch

scratch是一个空镜像，直接docker hub下载是下不了的，只能在Dockerfile中用FROM

```bash
# 不用容器，先用go build & run 执行下看下结果
[root@localhost hello]# cat app.go 
package main

import "fmt"

func main(){
    fmt.Printf("Hello World!");
}
[root@localhost hello]# go build app.go 
[root@localhost hello]# ls
app  app.go
[root@localhost hello]# ./app 
Hello World![root@localhost hello]#

# Dockerfile （使用了空镜像scratch）
[root@localhost hello]# cat Dockerfile
FROM scratch
ADD app /
CMD ["/app"]

# 构建镜像
[root@localhost hello]# docker build -t hello .
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
STEP 1/3: FROM scratch
STEP 2/3: ADD app /
--> f40b810d4f1
STEP 3/3: CMD ["/app"]
COMMIT hello
--> 3b05b3e8edb
Successfully tagged localhost/hello:latest
3b05b3e8edb740b20ed133aa65539217efe8cf2e97816b2912992fb8edb73f6b

[root@localhost hello]# docker images
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
REPOSITORY                                   TAG                   IMAGE ID      CREATED        SIZE
localhost/hello                              latest                3b05b3e8edb7  3 seconds ago  1.78 MB
# 用容器跑的结果 和 不用容器，用go build & run 一致
[root@localhost hello]# docker container run -it hello
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Hello World![root@localhost hello]# 
```


# 虚悬镜像

```bash
[root@localhost hello]# docker system df
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
TYPE           TOTAL       ACTIVE      SIZE        RECLAIMABLE
Images         21          5           19.44GB     4.2GB (22%)
Containers     10          4           823B        60B (7%)
Local Volumes  8           7           23.07GB     22.47GB (97%)
[root@localhost hello]# docker images
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
REPOSITORY                                   TAG                   IMAGE ID      CREATED         SIZE
localhost/hello                              2                     a37976309a63  16 seconds ago  7.59 MB
<none>                                       <none>                19be39c07a76  27 seconds ago  340 MB
localhost/hello                              latest                3b05b3e8edb7  19 minutes ago  1.78 MB
<none>                                       <none>                573a101bae9d  24 minutes ago  29.4 kB
quay.io/kubevirtci/k8s-1.21                  2207060141-111fd50    6fa0fcc42f47  31 hours ago    15.2 GB
quay.io/kubevirtci/gocli                     2207060141-111fd50    07874ec90d6e  31 hours ago    14.5 MB
quay.io/kubevirt/builder                     2206141426-2d31aa580  7ae2a103287f  3 weeks ago     1.98 GB
docker.io/library/golang                     alpine                155ead2e66ca  5 weeks ago     338 MB
docker.io/library/alpine                     latest                e66264b98777  6 weeks ago     5.82 MB
docker.io/kubevirtci/gocli                   latest                094672b6ef8e  21 months ago   12.6 MB
quay.io/libpod/registry                      2.7                   2d4f4b5309b1  2 years ago     26.8 MB
docker.io/backendcloud/example-hook-sidecar  mybuild5              0581e298f5bb  52 years ago    211 MB
docker.io/backendcloud/winrmcli              mybuild4              91ca4390f858  52 years ago    199 MB
docker.io/backendcloud/winrmcli              mybuild5              91ca4390f858  52 years ago    199 MB
docker.io/backendcloud/example-hook-sidecar  mybuild6              0581e298f5bb  52 years ago    211 MB
```

上面的镜像列表中，还可以看到一个特殊的镜像，这个镜像既没有仓库名，也没有标签，均为 `<none>`。

这个镜像原本是有镜像名和标签的，随着官方镜像维护，发布了新版本后，重新 docker pull 时，这个镜像名被转移到了新下载的镜像身上，而旧的镜像上的这个名称则被取消，从而成为了 `<none>`。除了 docker pull 可能导致这种情况，docker build 也同样可以导致这种现象。由于新旧镜像同名，旧镜像名称被取消，从而出现仓库名、标签均为 `<none>` 的镜像。这类无标签镜像也被称为 虚悬镜像(dangling image) ，可以用下面的命令专门显示这类镜像：

```bash
[root@localhost hello]# docker images ls -f dangling=true
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Error: cannot specify an image and a filter(s)

#注意：不是images，是image，和docker images命令不同
[root@localhost hello]# docker image ls -f dangling=true
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
REPOSITORY  TAG         IMAGE ID      CREATED       SIZE
<none>      <none>      19be39c07a76  16 hours ago  340 MB
<none>      <none>      573a101bae9d  16 hours ago  29.4 kB
```

一般来说，虚悬镜像已经失去了存在的价值，是可以随意删除的，可以用下面的命令删除。

```bash
[root@localhost hello]# docker image prune
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
WARNING! This command removes all dangling images.
Are you sure you want to continue? [y/N] y
19be39c07a766503753c91261bfd2dd786f536db69402ccbc12bdaea054e3047
6220efe05008da6279e95d7a377993b035e59833dfd75f66184a24fcf2c8a85d
906f367739194e499b1baf1459fa7c0eca2cf8249fc466e671315c1f2a13b369
[root@localhost hello]# docker image ls -f dangling=true
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
REPOSITORY  TAG         IMAGE ID      CREATED       SIZE
<none>      <none>      573a101bae9d  16 hours ago  29.4 kB
[root@localhost hello]# docker image ls -f dangling=true
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
REPOSITORY  TAG         IMAGE ID      CREATED       SIZE
<none>      <none>      573a101bae9d  16 hours ago  29.4 kB
[root@localhost hello]# docker images
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
REPOSITORY                                   TAG                   IMAGE ID      CREATED        SIZE
localhost/hello                              2                     a37976309a63  16 hours ago   7.59 MB
localhost/hello                              latest                3b05b3e8edb7  16 hours ago   1.78 MB
<none>                                       <none>                573a101bae9d  16 hours ago   29.4 kB
quay.io/kubevirtci/k8s-1.21                  2207060141-111fd50    6fa0fcc42f47  47 hours ago   15.2 GB
quay.io/kubevirtci/gocli                     2207060141-111fd50    07874ec90d6e  2 days ago     14.5 MB
quay.io/kubevirt/builder                     2206141426-2d31aa580  7ae2a103287f  3 weeks ago    1.98 GB
docker.io/library/golang                     alpine                155ead2e66ca  5 weeks ago    338 MB
docker.io/library/alpine                     latest                e66264b98777  6 weeks ago    5.82 MB
docker.io/kubevirtci/gocli                   latest                094672b6ef8e  21 months ago  12.6 MB
quay.io/libpod/registry                      2.7                   2d4f4b5309b1  2 years ago    26.8 MB
docker.io/backendcloud/winrmcli              mybuild4              91ca4390f858  52 years ago   199 MB
docker.io/backendcloud/winrmcli              mybuild5              91ca4390f858  52 years ago   199 MB
docker.io/backendcloud/example-hook-sidecar  mybuild6              0581e298f5bb  52 years ago   211 MB
docker.io/backendcloud/example-hook-sidecar  mybuild5              0581e298f5bb  52 years ago   211 MB

# 发现还有一个虚悬镜像，再删了一遍，还是没删掉，用docker rmi删除，提示有容器在使用该镜像。docker image prune这里做得不友好，一点warning信息没有。
[root@localhost hello]# docker image prune
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
WARNING! This command removes all dangling images.
Are you sure you want to continue? [y/N] y
[root@localhost hello]# docker images
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
REPOSITORY                                   TAG                   IMAGE ID      CREATED        SIZE
localhost/hello                              2                     a37976309a63  16 hours ago   7.59 MB
localhost/hello                              latest                3b05b3e8edb7  16 hours ago   1.78 MB
<none>                                       <none>                573a101bae9d  16 hours ago   29.4 kB
quay.io/kubevirtci/k8s-1.21                  2207060141-111fd50    6fa0fcc42f47  47 hours ago   15.2 GB
quay.io/kubevirtci/gocli                     2207060141-111fd50    07874ec90d6e  2 days ago     14.5 MB
quay.io/kubevirt/builder                     2206141426-2d31aa580  7ae2a103287f  3 weeks ago    1.98 GB
docker.io/library/golang                     alpine                155ead2e66ca  5 weeks ago    338 MB
docker.io/library/alpine                     latest                e66264b98777  6 weeks ago    5.82 MB
docker.io/kubevirtci/gocli                   latest                094672b6ef8e  21 months ago  12.6 MB
quay.io/libpod/registry                      2.7                   2d4f4b5309b1  2 years ago    26.8 MB
docker.io/backendcloud/winrmcli              mybuild4              91ca4390f858  52 years ago   199 MB
docker.io/backendcloud/winrmcli              mybuild5              91ca4390f858  52 years ago   199 MB
docker.io/backendcloud/example-hook-sidecar  mybuild6              0581e298f5bb  52 years ago   211 MB
docker.io/backendcloud/example-hook-sidecar  mybuild5              0581e298f5bb  52 years ago   211 MB
[root@localhost hello]# docker rmi 573a101bae9d
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Error: Image used by 095dff22c8f728ba34ead410db4c8a61b94f4e1119d7b9ec8c0d53140998e158: image is in use by a container
```

# 多阶段构建
构建镜像和运行镜像分开，有两个好处
1. 镜像很小
2. 源代码分离，安全

```bash
# 多阶段构建Dockerfile
[root@localhost hello]# cat Dockerfile 
FROM golang:alpine as builder
WORKDIR /go/src/
COPY app.go .
RUN go build -o app app.go
FROM alpine:latest as prod
WORKDIR /root/
COPY --from=0 /go/src/app .
CMD ["./app"]

# 生成镜像（第一个跑完会被自动销毁，只保留第二个镜像）
[root@localhost hello]# docker build -t hello:2 .
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
[1/2] STEP 1/4: FROM golang:alpine AS builder
[1/2] STEP 2/4: WORKDIR /go/src/
--> Using cache 906f367739194e499b1baf1459fa7c0eca2cf8249fc466e671315c1f2a13b369
--> 906f3677391
[1/2] STEP 3/4: COPY app.go .
--> Using cache 6220efe05008da6279e95d7a377993b035e59833dfd75f66184a24fcf2c8a85d
--> 6220efe0500
[1/2] STEP 4/4: RUN go build -o app app.go
--> 19be39c07a7
[2/2] STEP 1/4: FROM alpine:latest AS prod
Resolved "alpine" as an alias (/etc/containers/registries.conf.d/000-shortnames.conf)
Trying to pull docker.io/library/alpine:latest...
Getting image source signatures
Copying blob 2408cc74d12b skipped: already exists  
Copying config e66264b987 done  
Writing manifest to image destination
Storing signatures
[2/2] STEP 2/4: WORKDIR /root/
--> 9f975764a6d
[2/2] STEP 3/4: COPY --from=0 /go/src/app .
--> 22fd24c9b9d
[2/2] STEP 4/4: CMD ["./app"]
[2/2] COMMIT hello:2
--> a37976309a6
Successfully tagged localhost/hello:2
a37976309a6375e3107bf0c89cc373d6c0b953b6596238006aabf0ac3bcfa762

[root@localhost hello]# docker images
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
REPOSITORY                                   TAG                   IMAGE ID      CREATED         SIZE
localhost/hello                              2                     a37976309a63  16 seconds ago  7.59 MB

[root@localhost hello]# docker container run -it hello:2
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Hello World![root@localhost hello]# 
# 镜像运行符合预期（将镜像从alpine换成上一小节的scratch空镜像也可以）
```

