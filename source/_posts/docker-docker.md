---
title: Docker-Docker
readmore: true
date: 2022-07-29 19:08:43
categories: Devops
tags:
---

在 云原生项目的 CI 中, 需要创建一个沙盒环境去创建和销毁CI环境用来 测试虚拟机环境或容器环境。几年前还是用 vagrant + libvirt + kvm，现在随着容器技术的发展，vagrant 虚拟机化的CI环境 已经基本不用了。取而代之的是容器化的CI环境。

# Docker in Docker

Docker in Docker 可以在 Container 中直接运行一个 Docker Daemon ，然后使用 Container 中的 Docker CLI 工具操作容器。

```bash
 ⚡ root@backendcloud  ~  docker run --privileged -e DOCKER_TLS_CERTDIR="" -d --name dockerd  docker:dind
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Resolved "docker" as an alias (/etc/containers/registries.conf.d/000-shortnames.conf)
Trying to pull docker.io/library/docker:dind...
Getting image source signatures
Copying blob 33702c1843d1 skipped: already exists  
Copying blob db8946a7c6c2 done  
Copying blob d1c203384d5b skipped: already exists  
Copying blob cee6b871713b done  
Copying blob 530afca65e2e skipped: already exists  
Copying blob 146feb07c331 done  
Copying blob e7b044ff4e6b done  
Copying blob 649b2db28c49 done  
Copying blob dbd7811a8fce done  
Copying blob 7b9a2b83f06a done  
Copying blob 4052cf0d7af0 done  
Copying blob 668035bf1efe done  
Copying blob afd9bc40a60c done  
Copying config e9bf5bfbaf done  
Writing manifest to image destination
Storing signatures
01ae48251258f3082787e836c258213f3287f8a2afbb2cdd02b67f099311ab38
 ⚡ root@backendcloud  ~  docker ps
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
CONTAINER ID  IMAGE                          COMMAND     CREATED         STATUS             PORTS       NAMES
01ae48251258  docker.io/library/docker:dind              43 seconds ago  Up 43 seconds ago              dockerd
 ⚡ root@backendcloud  ~  docker exec -it 01ae48251258 bash
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Error: crun: executable file `bash` not found in $PATH: No such file or directory: OCI runtime attempted to invoke a command that was not found
 ✘ ⚡ root@backendcloud  ~  docker exec -it 01ae48251258 sh  
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
/ # docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
/ # docker images
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
/ # docker pull backendcloud/bazel-sample-cmd:v1.0.0
v1.0.0: Pulling from backendcloud/bazel-sample-cmd
f5797b5ad6f5: Pull complete 
2d98a33c337e: Pull complete 
ffc0beffb346: Pull complete 
Digest: sha256:0e150b40fa598393d5cb9f4448ef721109111051d5630fbcb3c68541503211cf
Status: Downloaded newer image for backendcloud/bazel-sample-cmd:v1.0.0
docker.io/backendcloud/bazel-sample-cmd:v1.0.0
/ # docker images
REPOSITORY                      TAG       IMAGE ID       CREATED        SIZE
backendcloud/bazel-sample-cmd   v1.0.0    9a30bb12bb57   52 years ago   26.5MB
/ # 
 ⚡ root@backendcloud  ~  docker images
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
REPOSITORY                   TAG                 IMAGE ID      CREATED       SIZE
docker.io/library/docker     dind                e9bf5bfbaf86  8 days ago    312 MB
docker.io/library/registry   latest              d1fe2eaf6101  10 days ago   24.6 MB
<none>                       <none>              f9ecc8696ab1  10 days ago   139 MB
quay.io/kubevirtci/k8s-1.21  2207120734-32ed068  75c519e42ddf  2 weeks ago   14.9 GB
<none>                       <none>              6a7046328a54  2 weeks ago   3.55 GB
quay.io/fedora/fedora        <none>              3a66698e6040  2 months ago  169 MB
quay.io/libpod/registry      2.7                 2d4f4b5309b1  2 years ago   26.8 MB
localhost:5000/registry      2.7                 2d4f4b5309b1  2 years ago   26.8 MB
l.gcr.io/google/bazel        latest              5cac8433a9d7  52 years ago  1.64 GB
```

这种方式下，容器中的 Docker Daemon 完全独立于外部，具有良好的隔离特性。看起来，Container 类似一个 VM 。

> Docker in Docker 不推荐使用，主要原因还是安全问题。 Docker in Docker 需要以特权模式启动，这种嵌套会带来潜在的安全风险。



# Docker outside of Docker

将 Container 的外部 Docker Daemon 服务挂载到 Container 。让 Container 误以为本地运行了 Docker Daemon，使用 Docker CLI 命令操作时，外部的 Docker Daemon 会响应请求。

```bash
 ⚡ root@backendcloud  ~  curl --silent -XGET --unix-socket /run/docker.sock http://localhost/version     
{"Platform":{"Name":"linux/amd64/\"centos\"-9"},"Components":[{"Name":"Podman Engine","Version":"4.1.1","Details":{"APIVersion":"4.1.1","Arch":"amd64","BuildTime":"2022-06-16T00:59:06+08:00","Experimental":"false","GitCommit":"","GoVersion":"go1.17.5","KernelVersion":"5.14.0-115.el9.x86_64","MinAPIVersion":"4.0.0","Os":"linux"}},{"Name":"Conmon","Version":"conmon version 2.1.2, commit: 8b8ad6d5fea210d1d098d27339324d33c7a43179","Details":{"Package":"conmon-2.1.2-2.el9.x86_64"}},{"Name":"OCI Runtime (crun)","Version":"crun version 1.4.5\ncommit: c381048530aa750495cf502ddb7181f2ded5b400\nspec: 1.0.0\n+SYSTEMD +SELINUX +APPARMOR +CAP +SECCOMP +EBPF +CRIU +YAJL","Details":{"Package":"crun-1.4.5-2.el9.x86_64"}}],"Version":"4.1.1","ApiVersion":"1.40","MinAPIVersion":"1.24","GitCommit":"","GoVersion":"go1.17.5","Os":"linux","Arch":"amd64","KernelVersion":"5.14.0-115.el9.x86_64","BuildTime":"2022-06-16T00:59:06+08:00"}
 ⚡ root@backendcloud  ~  docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock alpine sh      
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
/ # docker ps
sh: docker: not found
/ # apk add curl
fetch https://dl-cdn.alpinelinux.org/alpine/v3.16/main/x86_64/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.16/community/x86_64/APKINDEX.tar.gz
(1/5) Installing ca-certificates (20211220-r0)
(2/5) Installing brotli-libs (1.0.9-r6)
(3/5) Installing nghttp2-libs (1.47.0-r0)
(4/5) Installing libcurl (7.83.1-r2)
(5/5) Installing curl (7.83.1-r2)
Executing busybox-1.35.0-r15.trigger
Executing ca-certificates-20211220-r0.trigger
OK: 8 MiB in 19 packages
/ # curl --silent -XGET --unix-socket /run/docker.sock http://localhost/version
{"Platform":{"Name":"linux/amd64/\"centos\"-9"},"Components":[{"Name":"Podman Engine","Version":"4.1.1","Details":{"APIVersion":"4.1.1","Arch":"amd64","BuildTime":"2022-06-16T00:59:06+08:00","Experimental":"false","GitCommit":"","GoVersion":"go1.17.5","KernelVersion":"5.14.0-115.el9.x86_64","MinAPIVersion":"4.0.0","Os":"linux"}},{"Name":"Conmon","Version":"conmon version 2.1.2, commit: 8b8ad6d5fea210d1d098d27339324d33c7a43179","Details":{"Package":"conmon-2.1.2-2.el9.x86_64"}},{"Name":"OCI Runtime (crun)","Version":"crun version 1.4.5\ncommit: c381048530aa750495cf502ddb7181f2ded5b400\nspec: 1.0.0\n+SYSTEMD +SELINUX +APPARMOR +CAP +SECCOMP +EBPF +CRIU +YAJL","Details":{"Package":"crun-1.4.5-2.el9.x86_64"}}],"Version":"4.1.1","ApiVersion":"1.40","MinAPIVersion":"1.24","GitCommit":"","GoVersion":"go1.17.5","Os":"linux","Arch":"amd64","KernelVersion":"5.14.0-115.el9.x86_64","BuildTime":"2022-06-16T00:59:06+08:00"}
/ # curl --silent -XGET --unix-socket /run/docker.sock -H 'Content-Type: application/json' http://localhost/containers/json
[{"Id":"f540765175df91ea55e9079a3eddecef54241fc9279a055d77bf1cbf8f1193bf","Names":["/busy_black"],"Image":"docker.io/library/alpine:latest","ImageID":"sha256:d7d3d98c851ff3a95dbcb70ce09d186c9aaf7e25d48d55c0f99aae360aecfd53","Command":"sh","Created":1659076951,"Ports":[],"Labels":{},"State":"running","Status":"Up 3 minutes","NetworkSettings":{"Networks":{"podman":{"IPAMConfig":null,"Links":null,"Aliases":["f540765175df"],"NetworkID":"podman","EndpointID":"","Gateway":"10.88.0.1","IPAddress":"10.88.0.6","IPPrefixLen":16,"IPv6Gateway":"","GlobalIPv6Address":"","GlobalIPv6PrefixLen":0,"MacAddress":"46:df:ec:3e:1d:cd","DriverOpts":null}}},"Mounts":[{"Type":"bind","Source":"/var/run/docker.sock","Destination":"/var/run/docker.sock","Mode":"","RW":true,"Propagation":"rprivate"}],"Name":"","Config":null,"NetworkingConfig":null,"Platform":null,"AdjustCPUShares":false}]
/ # curl --silent -XGET --unix-socket /run/docker.sock -H 'Content-Type: application/json' http://localhost/images/json
[{"Id":"sha256:3a66698e604003f7822a0c73e9da50e090fda9a99fe1f2e1e2e7fe796cc803d5","ParentId":"","RepoTags":["quay.io/fedora/fedora@sha256:38813cf0913241b7f13c7057e122f7c3cfa2e7c427dca3194f933d94612e280b"],"RepoDigests":["quay.io/fedora/fedora@sha256:2fda47c322448f24874f051e9f1f20ff5fb8c54c97391a68091e3941e1cc18dd","quay.io/fedora/fedora@sha256:38813cf0913241b7f13c7057e122f7c3cfa2e7c427dca3194f933d94612e280b"],"Created":1651831918,"Size":168993849,"SharedSize":0,"VirtualSize":168993849,"Labels":{"license":"MIT","name":"fedora","vendor":"Fedora Project","version":"36"},"Containers":1,"Names":["quay.io/fedora/fedora@sha256:38813cf0913241b7f13c7057e122f7c3cfa2e7c427dca3194f933d94612e280b"],"Digest":"sha256:38813cf0913241b7f13c7057e122f7c3cfa2e7c427dca3194f933d94612e280b","History":["quay.io/fedora/fedora@sha256:38813cf0913241b7f13c7057e122f7c3cfa2e7c427dca3194f933d94612e280b"]},{"Id":"sha256:6a7046328a54690f7e72a922d756d9010a12b659e869af9ae4bbfe547c645558","ParentId":"4d559bfbd15a774534a56c573bd96d84e115955452ee8977694d71284bfadcb5","RepoTags":null,"RepoDigests":[],"Created":1657527756,"Size":3553300887,"SharedSize":0,"VirtualSize":3553300887,"Labels":{"io.buildah.version":"1.26.1","license":"MIT","name":"fedora","vendor":"Fedora Project","version":"36"},"Containers":1,"Dangling":true,"Digest":"sha256:12a6e59f89076e673b46a1eb8b6a920193f1af9b9dec6f203620ce354e0eb413","History":["docker.io/library/b32c24a99cdab01636b74054bb72a97d5bfa5dd95a82e7304f5be2855f9b687b-tmp:latest"]},{"Id":"sha256:75c519e42ddf7a89f6eb329790862865d58454b0329f0e49e19b541c892ebd3c","ParentId":"","RepoTags":["quay.io/kubevirtci/k8s-1.21:2207120734-32ed068"],"RepoDigests":["quay.io/kubevirtci/k8s-1.21@sha256:38e3cc0b3abe1e571dc81f559ba32a1a26d5d9baf4f49c8d0bc315f7b09a0b30"],"Created":1657612234,"Size":14883352836,"SharedSize":0,"VirtualSize":14883352836,"Labels":{"license":"MIT","name":"fedora","vendor":"Fedora Project","version":"36"},"Containers":2,"Names":["quay.io/kubevirtci/k8s-1.21:2207120734-32ed068"],"Digest":"sha256:38e3cc0b3abe1e571dc81f559ba32a1a26d5d9baf4f49c8d0bc315f7b09a0b30","History":["quay.io/kubevirtci/k8s-1.21:2207120734-32ed068"]},{"Id":"sha256:2d4f4b5309b1e41b4f83ae59b44df6d673ef44433c734b14c1c103ebca82c116","ParentId":"","RepoTags":["quay.io/libpod/registry:2.7","localhost:5000/registry:2.7"],"RepoDigests":["localhost:5000/registry@sha256:eb072440e6939e2982739a7b64c16f6b37f2caf52cd39db6bd504d8f7505cbda","quay.io/libpod/registry@sha256:eb072440e6939e2982739a7b64c16f6b37f2caf52cd39db6bd504d8f7505cbda"],"Created":1592504405,"Size":26788530,"SharedSize":0,"VirtualSize":26788530,"Labels":null,"Containers":1,"Names":["quay.io/libpod/registry:2.7","localhost:5000/registry:2.7"],"Digest":"sha256:eb072440e6939e2982739a7b64c16f6b37f2caf52cd39db6bd504d8f7505cbda","History":["localhost:5000/registry:2.7","quay.io/libpod/registry:2.7"]},{"Id":"sha256:f9ecc8696ab12ad121214450f43f74d64280e08b17d2a7ed2367a754bab20c6d","ParentId":"","RepoTags":null,"RepoDigests":[],"Created":1658136937,"Size":138900601,"SharedSize":0,"VirtualSize":138900601,"Labels":null,"Containers":1,"Dangling":true,"Digest":"sha256:0ca33ba401ff409274fdcd7705403fa1f85513b61774d4fc54a20e1d2a5c0f13","History":["docker.io/library/4468ab974bf638eda36568b2cbb64d7eb7133de5826eae476a7dff512051bd20-tmp:latest"]},{"Id":"sha256:5cac8433a9d73b7814bbad1aa45d0fc22eb0c2dddba8657b65db796570710746","ParentId":"","RepoTags":["l.gcr.io/google/bazel:latest"],"RepoDigests":["l.gcr.io/google/bazel@sha256:ace9881e6e9c5d48b5fd637321361aeffe54000265894a65f7d818dc1065bd80"],"Created":0,"Size":1637554883,"SharedSize":0,"VirtualSize":1637554883,"Labels":null,"Containers":5,"Names":["l.gcr.io/google/bazel:latest"],"Digest":"sha256:ace9881e6e9c5d48b5fd637321361aeffe54000265894a65f7d818dc1065bd80","History":["l.gcr.io/google/bazel:latest"]},{"Id":"sha256:d1fe2eaf610136771d6883bae3001aea0b5c90ab56fb190e052227cbfe73364d","ParentId":"","RepoTags":["docker.io/library/registry:latest"],"RepoDigests":["docker.io/library/registry@sha256:6f86956ed3802764cf98f5f20ed549a649ffd1f24fb273aef48748da5531b576","docker.io/library/registry@sha256:c631a581c6152f5a4a141a974b74cf308ab2ee660287a3c749d88e0b536c0c20"],"Created":1658188548,"Size":24647771,"SharedSize":0,"VirtualSize":24647771,"Labels":null,"Containers":1,"Names":["docker.io/library/registry:latest"],"Digest":"sha256:c631a581c6152f5a4a141a974b74cf308ab2ee660287a3c749d88e0b536c0c20","History":["docker.io/library/registry:latest"]},{"Id":"sha256:e9bf5bfbaf86d5b1829f700f8f887518595c3d7df33e560457896187489985d7","ParentId":"","RepoTags":["docker.io/library/docker:dind"],"RepoDigests":["docker.io/library/docker@sha256:c10de736621bc2d4a3a44297346640b62309db58f46822b87679d9419a6b321c","docker.io/library/docker@sha256:c5ecf5207228cf4181544eea56c3655265a8c17a7a905558be47050fbafc5a94"],"Created":1658359676,"Size":312441646,"SharedSize":0,"VirtualSize":312441646,"Labels":null,"Containers":0,"Names":["docker.io/library/docker:dind"],"Digest":"sha256:c10de736621bc2d4a3a44297346640b62309db58f46822b87679d9419a6b321c","History":["docker.io/library/docker:dind"]},{"Id":"sha256:d7d3d98c851ff3a95dbcb70ce09d186c9aaf7e25d48d55c0f99aae360aecfd53","ParentId":"","RepoTags":["docker.io/library/alpine:latest"],"RepoDigests":["docker.io/library/alpine@sha256:7580ece7963bfa863801466c0a488f11c86f85d9988051a9f9c68cb27f6b7872","docker.io/library/alpine@sha256:9b2a28eb47540823042a2ba401386845089bb7b62a9637d55816132c4c3c36eb"],"Created":1658178015,"Size":5815366,"SharedSize":0,"VirtualSize":5815366,"Labels":null,"Containers":1,"Names":["docker.io/library/alpine:latest"],"Digest":"sha256:7580ece7963bfa863801466c0a488f11c86f85d9988051a9f9c68cb27f6b7872","History":["docker.io/library/alpine:latest"]}]
/ # 
 ⚡ root@backendcloud  ~  curl --silent -XGET --unix-socket /run/docker.sock -H 'Content-Type: application/json' http://localhost/containers/json
[]
 ⚡ root@backendcloud  ~  curl --silent -XGET --unix-socket /run/docker.sock -H 'Content-Type: application/json' http://localhost/images/json
[{"Id":"sha256:3a66698e604003f7822a0c73e9da50e090fda9a99fe1f2e1e2e7fe796cc803d5","ParentId":"","RepoTags":["quay.io/fedora/fedora@sha256:38813cf0913241b7f13c7057e122f7c3cfa2e7c427dca3194f933d94612e280b"],"RepoDigests":["quay.io/fedora/fedora@sha256:2fda47c322448f24874f051e9f1f20ff5fb8c54c97391a68091e3941e1cc18dd","quay.io/fedora/fedora@sha256:38813cf0913241b7f13c7057e122f7c3cfa2e7c427dca3194f933d94612e280b"],"Created":1651831918,"Size":168993849,"SharedSize":0,"VirtualSize":168993849,"Labels":{"license":"MIT","name":"fedora","vendor":"Fedora Project","version":"36"},"Containers":1,"Names":["quay.io/fedora/fedora@sha256:38813cf0913241b7f13c7057e122f7c3cfa2e7c427dca3194f933d94612e280b"],"Digest":"sha256:38813cf0913241b7f13c7057e122f7c3cfa2e7c427dca3194f933d94612e280b","History":["quay.io/fedora/fedora@sha256:38813cf0913241b7f13c7057e122f7c3cfa2e7c427dca3194f933d94612e280b"]},{"Id":"sha256:6a7046328a54690f7e72a922d756d9010a12b659e869af9ae4bbfe547c645558","ParentId":"4d559bfbd15a774534a56c573bd96d84e115955452ee8977694d71284bfadcb5","RepoTags":null,"RepoDigests":[],"Created":1657527756,"Size":3553300887,"SharedSize":0,"VirtualSize":3553300887,"Labels":{"io.buildah.version":"1.26.1","license":"MIT","name":"fedora","vendor":"Fedora Project","version":"36"},"Containers":1,"Dangling":true,"Digest":"sha256:12a6e59f89076e673b46a1eb8b6a920193f1af9b9dec6f203620ce354e0eb413","History":["docker.io/library/b32c24a99cdab01636b74054bb72a97d5bfa5dd95a82e7304f5be2855f9b687b-tmp:latest"]},{"Id":"sha256:75c519e42ddf7a89f6eb329790862865d58454b0329f0e49e19b541c892ebd3c","ParentId":"","RepoTags":["quay.io/kubevirtci/k8s-1.21:2207120734-32ed068"],"RepoDigests":["quay.io/kubevirtci/k8s-1.21@sha256:38e3cc0b3abe1e571dc81f559ba32a1a26d5d9baf4f49c8d0bc315f7b09a0b30"],"Created":1657612234,"Size":14883352836,"SharedSize":0,"VirtualSize":14883352836,"Labels":{"license":"MIT","name":"fedora","vendor":"Fedora Project","version":"36"},"Containers":2,"Names":["quay.io/kubevirtci/k8s-1.21:2207120734-32ed068"],"Digest":"sha256:38e3cc0b3abe1e571dc81f559ba32a1a26d5d9baf4f49c8d0bc315f7b09a0b30","History":["quay.io/kubevirtci/k8s-1.21:2207120734-32ed068"]},{"Id":"sha256:2d4f4b5309b1e41b4f83ae59b44df6d673ef44433c734b14c1c103ebca82c116","ParentId":"","RepoTags":["quay.io/libpod/registry:2.7","localhost:5000/registry:2.7"],"RepoDigests":["localhost:5000/registry@sha256:eb072440e6939e2982739a7b64c16f6b37f2caf52cd39db6bd504d8f7505cbda","quay.io/libpod/registry@sha256:eb072440e6939e2982739a7b64c16f6b37f2caf52cd39db6bd504d8f7505cbda"],"Created":1592504405,"Size":26788530,"SharedSize":0,"VirtualSize":26788530,"Labels":null,"Containers":1,"Names":["quay.io/libpod/registry:2.7","localhost:5000/registry:2.7"],"Digest":"sha256:eb072440e6939e2982739a7b64c16f6b37f2caf52cd39db6bd504d8f7505cbda","History":["localhost:5000/registry:2.7","quay.io/libpod/registry:2.7"]},{"Id":"sha256:f9ecc8696ab12ad121214450f43f74d64280e08b17d2a7ed2367a754bab20c6d","ParentId":"","RepoTags":null,"RepoDigests":[],"Created":1658136937,"Size":138900601,"SharedSize":0,"VirtualSize":138900601,"Labels":null,"Containers":1,"Dangling":true,"Digest":"sha256:0ca33ba401ff409274fdcd7705403fa1f85513b61774d4fc54a20e1d2a5c0f13","History":["docker.io/library/4468ab974bf638eda36568b2cbb64d7eb7133de5826eae476a7dff512051bd20-tmp:latest"]},{"Id":"sha256:5cac8433a9d73b7814bbad1aa45d0fc22eb0c2dddba8657b65db796570710746","ParentId":"","RepoTags":["l.gcr.io/google/bazel:latest"],"RepoDigests":["l.gcr.io/google/bazel@sha256:ace9881e6e9c5d48b5fd637321361aeffe54000265894a65f7d818dc1065bd80"],"Created":0,"Size":1637554883,"SharedSize":0,"VirtualSize":1637554883,"Labels":null,"Containers":5,"Names":["l.gcr.io/google/bazel:latest"],"Digest":"sha256:ace9881e6e9c5d48b5fd637321361aeffe54000265894a65f7d818dc1065bd80","History":["l.gcr.io/google/bazel:latest"]},{"Id":"sha256:d1fe2eaf610136771d6883bae3001aea0b5c90ab56fb190e052227cbfe73364d","ParentId":"","RepoTags":["docker.io/library/registry:latest"],"RepoDigests":["docker.io/library/registry@sha256:6f86956ed3802764cf98f5f20ed549a649ffd1f24fb273aef48748da5531b576","docker.io/library/registry@sha256:c631a581c6152f5a4a141a974b74cf308ab2ee660287a3c749d88e0b536c0c20"],"Created":1658188548,"Size":24647771,"SharedSize":0,"VirtualSize":24647771,"Labels":null,"Containers":1,"Names":["docker.io/library/registry:latest"],"Digest":"sha256:c631a581c6152f5a4a141a974b74cf308ab2ee660287a3c749d88e0b536c0c20","History":["docker.io/library/registry:latest"]},{"Id":"sha256:e9bf5bfbaf86d5b1829f700f8f887518595c3d7df33e560457896187489985d7","ParentId":"","RepoTags":["docker.io/library/docker:dind"],"RepoDigests":["docker.io/library/docker@sha256:c10de736621bc2d4a3a44297346640b62309db58f46822b87679d9419a6b321c","docker.io/library/docker@sha256:c5ecf5207228cf4181544eea56c3655265a8c17a7a905558be47050fbafc5a94"],"Created":1658359676,"Size":312441646,"SharedSize":0,"VirtualSize":312441646,"Labels":null,"Containers":0,"Names":["docker.io/library/docker:dind"],"Digest":"sha256:c10de736621bc2d4a3a44297346640b62309db58f46822b87679d9419a6b321c","History":["docker.io/library/docker:dind"]},{"Id":"sha256:d7d3d98c851ff3a95dbcb70ce09d186c9aaf7e25d48d55c0f99aae360aecfd53","ParentId":"","RepoTags":["docker.io/library/alpine:latest"],"RepoDigests":["docker.io/library/alpine@sha256:7580ece7963bfa863801466c0a488f11c86f85d9988051a9f9c68cb27f6b7872","docker.io/library/alpine@sha256:9b2a28eb47540823042a2ba401386845089bb7b62a9637d55816132c4c3c36eb"],"Created":1658178015,"Size":5815366,"SharedSize":0,"VirtualSize":5815366,"Labels":null,"Containers":0,"Names":["docker.io/library/alpine:latest"],"Digest":"sha256:7580ece7963bfa863801466c0a488f11c86f85d9988051a9f9c68cb27f6b7872","History":["docker.io/library/alpine:latest"]}]
```

符合预期。Docker outside of Docker 方式直接使用的外部 Docker Daemon。

> Docker out of Docker 并没有实现完全的隔离，互相之间可以看见。


# sysbox

![](/images/docker-docker/2022-07-29-15-24-01.png)

https://github.com/nestybox/sysbox#installation  安装后，创建带Sysbox的容器命令： `docker run --runtime=sysbox-runc -it any_image`

sysbox容器内部创建的容器在外面是看不到的，所以sysbox更像 安全版的 Docker in Docker。准确说sysbox是安全版的docker。若sysbox容器里装了docker那就是安全版的 Docker in Docker。若sysbox容器里装了Kubernetes，就是安全版的 Kubernetes in Docker。Kind是将Kubernetes的节点容器化，kind容器用sysbox容器代替，创建Kubernetes集群，那就是安全版的 Kind in Docker（如下图）。

![](/images/docker-docker/2022-07-29-15-25-47.png)

## Comparison to Related Technologies

![](/images/docker-docker/2022-07-29-15-24-30.png)