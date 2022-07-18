---
title: 一步步学KubeVirt CI （10） - packer（workinprocess）
readmore: true
date: 2022-07-18 20:23:32
categories: 云原生
tags:
- KubeVirt CI
---

# packer 是什么
Packer是一个从单一的模板文件来创建多平台一致性镜像的轻量级开源工具，它能够运行在常用的主流操作系统如Windows、Linux和Mac os上，能够高效的并行创建多平台例如AWS、Azure和Alicloud的镜像，它的目的并不是取代Puppet/Chef等配置管理工具，实际上，当制作镜像的时候，Packer可以使用Chef或者Puppet等工具来安装镜像所需要的软件。通过Packer自动化的创建各种平台的镜像是非常容易的。

# install
```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install packer
```

# run

## 编写 Packer 模板并构建 Packer 镜像
```bash
 ⚡ root@localhost  ~  packer -v
1.8.2
 ⚡ root@localhost  ~  mkdir packer_tutorial
 ⚡ root@localhost  ~  cd packer_tutorial 
 ⚡ root@localhost  ~/packer_tutorial  vi docker-ubuntu.pkr.hcl
  ⚡ root@localhost  ~/packer_tutorial  cat docker-ubuntu.pkr.hcl
packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:xenial"
  commit = true
}

build {
  name    = "learn-packer"
  sources = [
    "source.docker.ubuntu"
  ]
}
 ⚡ root@localhost  ~/packer_tutorial  packer init .
Installed plugin github.com/hashicorp/docker v1.0.6 in "/root/.config/packer/plugins/github.com/hashicorp/docker/packer-plugin-docker_v1.0.6_x5.0_linux_amd64"
 ⚡ root@localhost  ~/packer_tutorial  packer fmt .
docker-ubuntu.pkr.hcl
 ⚡ root@localhost  ~/packer_tutorial  packer validate .
The configuration is valid.
 ⚡ root@localhost  ~/packer_tutorial  packer build docker-ubuntu.pkr.hcl
learn-packer.docker.ubuntu: output will be in this color.

==> learn-packer.docker.ubuntu: Creating a temporary directory for sharing data...
==> learn-packer.docker.ubuntu: Pulling Docker image: ubuntu:xenial
    learn-packer.docker.ubuntu: Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
    learn-packer.docker.ubuntu: Resolved "ubuntu" as an alias (/etc/containers/registries.conf.d/000-shortnames.conf)
    learn-packer.docker.ubuntu: Trying to pull docker.io/library/ubuntu:xenial...
    learn-packer.docker.ubuntu: Getting image source signatures
    learn-packer.docker.ubuntu: Copying blob sha256:58690f9b18fca6469a14da4e212c96849469f9b1be6661d2342a4bf01774aa50
    learn-packer.docker.ubuntu: Copying blob sha256:fb15d46c38dcd1ea0b1990006c3366ecd10c79d374f341687eb2cb23a2c8672e
    learn-packer.docker.ubuntu: Copying blob sha256:fb15d46c38dcd1ea0b1990006c3366ecd10c79d374f341687eb2cb23a2c8672e
    learn-packer.docker.ubuntu: Copying blob sha256:58690f9b18fca6469a14da4e212c96849469f9b1be6661d2342a4bf01774aa50
    learn-packer.docker.ubuntu: Copying blob sha256:b51569e7c50720acf6860327847fe342a1afbe148d24c529fb81df105e3eed01
    learn-packer.docker.ubuntu: Copying blob sha256:b51569e7c50720acf6860327847fe342a1afbe148d24c529fb81df105e3eed01
    learn-packer.docker.ubuntu: Copying blob sha256:da8ef40b9ecabc2679fe2419957220c0272a965c5cf7e0269fa1aeeb8c56f2e1
    learn-packer.docker.ubuntu: Copying blob sha256:da8ef40b9ecabc2679fe2419957220c0272a965c5cf7e0269fa1aeeb8c56f2e1
    learn-packer.docker.ubuntu: Copying config sha256:b6f50765242581c887ff1acc2511fa2d885c52d8fb3ac8c4bba131fd86567f2e
    learn-packer.docker.ubuntu: Writing manifest to image destination
    learn-packer.docker.ubuntu: Storing signatures
    learn-packer.docker.ubuntu: b6f50765242581c887ff1acc2511fa2d885c52d8fb3ac8c4bba131fd86567f2e
==> learn-packer.docker.ubuntu: Starting docker container...
    learn-packer.docker.ubuntu: Run command: docker run -v /root/.config/packer/tmp2360805626:/packer-files -d -i -t --entrypoint=/bin/sh -- ubuntu:xenial
    learn-packer.docker.ubuntu: Container ID: 0b71e6aa7a989c2d1c7437b7ee8f45c430d01caf98694692daff491e6ff736d3
==> learn-packer.docker.ubuntu: Using docker communicator to connect: 10.88.0.3
==> learn-packer.docker.ubuntu: Committing the container
    learn-packer.docker.ubuntu: Image ID: 67805af31a79afadb2efbfb28c0727e7d1f4b363d271a573882a29538332ea4a
==> learn-packer.docker.ubuntu: Killing the container: 0b71e6aa7a989c2d1c7437b7ee8f45c430d01caf98694692daff491e6ff736d3
Build 'learn-packer.docker.ubuntu' finished after 17 seconds 110 milliseconds.

==> Wait completed after 17 seconds 110 milliseconds

==> Builds finished. The artifacts of successful builds are:
--> learn-packer.docker.ubuntu: Imported Docker image: 67805af31a79afadb2efbfb28c0727e7d1f4b363d271a573882a29538332ea4a
 ⚡ root@localhost  ~/packer_tutorial  docker images                                                                   
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
REPOSITORY                   TAG                 IMAGE ID      CREATED         SIZE
<none>                       <none>              67805af31a79  31 seconds ago  139 MB
```

## 使用配置器将软件安装和配置到镜像中
使用配置器可以完成自动化对镜像的修改。可以使用 shell 脚本、文件上传以及 工具如Chef 或 Puppet的集成。

```bash
 ⚡ root@localhost  ~/packer_tutorial  vi docker-ubuntu.pkr.hcl 
 ⚡ root@localhost  ~/packer_tutorial  cat docker-ubuntu.pkr.hcl 
packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:xenial"
  commit = true
}

build {
  name    = "learn-packer"
  sources = [
    "source.docker.ubuntu"
  ]
  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Adding file to Docker Container",
      "echo \"FOO is $FOO\" > example.txt",
    ]
  }
}
 ⚡ root@localhost  ~/packer_tutorial  packer build docker-ubuntu.pkr.hcl
learn-packer.docker.ubuntu: output will be in this color.

==> learn-packer.docker.ubuntu: Creating a temporary directory for sharing data...
==> learn-packer.docker.ubuntu: Pulling Docker image: ubuntu:xenial
    learn-packer.docker.ubuntu: Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
    learn-packer.docker.ubuntu: Trying to pull docker.io/library/ubuntu:xenial...
    learn-packer.docker.ubuntu: Getting image source signatures
    learn-packer.docker.ubuntu: Copying blob sha256:fb15d46c38dcd1ea0b1990006c3366ecd10c79d374f341687eb2cb23a2c8672e
    learn-packer.docker.ubuntu: Copying blob sha256:58690f9b18fca6469a14da4e212c96849469f9b1be6661d2342a4bf01774aa50
    learn-packer.docker.ubuntu: Copying blob sha256:b51569e7c50720acf6860327847fe342a1afbe148d24c529fb81df105e3eed01
    learn-packer.docker.ubuntu: Copying blob sha256:da8ef40b9ecabc2679fe2419957220c0272a965c5cf7e0269fa1aeeb8c56f2e1
    learn-packer.docker.ubuntu: Copying config sha256:b6f50765242581c887ff1acc2511fa2d885c52d8fb3ac8c4bba131fd86567f2e
    learn-packer.docker.ubuntu: Writing manifest to image destination
    learn-packer.docker.ubuntu: Storing signatures
    learn-packer.docker.ubuntu: b6f50765242581c887ff1acc2511fa2d885c52d8fb3ac8c4bba131fd86567f2e
==> learn-packer.docker.ubuntu: Starting docker container...
    learn-packer.docker.ubuntu: Run command: docker run -v /root/.config/packer/tmp1662891009:/packer-files -d -i -t --entrypoint=/bin/sh -- ubuntu:xenial
    learn-packer.docker.ubuntu: Container ID: d87bd6538f024785583193c89c3163893f6102f24a8802890598b776e9635be5
==> learn-packer.docker.ubuntu: Using docker communicator to connect: 10.88.0.4
==> learn-packer.docker.ubuntu: Provisioning with shell script: /tmp/packer-shell3215798209
==> learn-packer.docker.ubuntu: Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
    learn-packer.docker.ubuntu: Adding file to Docker Container
==> learn-packer.docker.ubuntu: Committing the container
    learn-packer.docker.ubuntu: Image ID: f9ecc8696ab12ad121214450f43f74d64280e08b17d2a7ed2367a754bab20c6d
==> learn-packer.docker.ubuntu: Killing the container: d87bd6538f024785583193c89c3163893f6102f24a8802890598b776e9635be5
Build 'learn-packer.docker.ubuntu' finished after 9 seconds 559 milliseconds.

==> Wait completed after 9 seconds 559 milliseconds

==> Builds finished. The artifacts of successful builds are:
--> learn-packer.docker.ubuntu: Imported Docker image: f9ecc8696ab12ad121214450f43f74d64280e08b17d2a7ed2367a754bab20c6d
 ⚡ root@localhost  ~/packer_tutorial  docker images
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
REPOSITORY                   TAG                 IMAGE ID      CREATED         SIZE
<none>                       <none>              f9ecc8696ab1  14 seconds ago  139 MB
<none>                       <none>              67805af31a79  14 minutes ago  139 MB
quay.io/kubevirtci/k8s-1.21  2207120734-32ed068  75c519e42ddf  6 days ago      14.9 GB
quay.io/kubevirtci/gocli     2207120734-32ed068  2b7ac78aac01  6 days ago      14.5 MB
<none>                       <none>              6a7046328a54  7 days ago      3.55 GB
docker.io/kindest/node       <none>              f5aa68ba122a  8 weeks ago     915 MB
quay.io/fedora/fedora        <none>              3a66698e6040  2 months ago    169 MB
docker.io/library/golang     1.17.8              5bd8c5733e7c  3 months ago    963 MB
docker.io/library/ubuntu     xenial              b6f507652425  10 months ago   139 MB
docker.io/kindest/node       v1.18.15            f4403d4d6580  18 months ago   1.29 GB
quay.io/libpod/registry      2.7                 2d4f4b5309b1  2 years ago     26.8 MB
 ⚡ root@localhost  ~/packer_tutorial  docker run -it f9ecc8696ab1       
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
# ls
bin  boot  dev  etc  example.txt  home  lib  lib64  media  mnt  opt  packer-files  proc  root  run  sbin  srv  sys  tmp  usr  var
# cat example.txt
FOO is hello world
# 
```

## 通过 Packer 变量来参数化 Packer 构建，使其更加健壮

```bash
 ⚡ root@localhost  ~/packer_tutorial  cat docker-ubuntu.pkr.hcl 
packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}
#定义变量块
variable "docker_image" {
  type    = string
  default = "ubuntu:xenial"
}

source "docker" "ubuntu" {
  image  = var.docker_image
  commit = true
}

build {
  name = "learn-packer"
  sources = [
    "source.docker.ubuntu"
  ]

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Adding file to Docker Container",
      "echo \"FOO is $FOO\" > example.txt",
    ]
  }

  provisioner "shell" {
    inline = [
      "echo Running ${var.docker_image} Docker image.",
    "echo \"${var.docker_image} is run\" > example.txt", ]
  }
}
```


## 变量文件构建映像
```bash
 ⚡ root@localhost  ~/packer_tutorial  vi example.pkrvars.hcl
 ⚡ root@localhost  ~/packer_tutorial  cat example.pkrvars.hcl 
docker_image = "ubuntu:bionic"
 ⚡ root@localhost  ~/packer_tutorial  packer build --var-file=example.pkrvars.hcl docker-ubuntu.pkr.hcl
```

> 升序优先顺序是：变量默认值、环境变量、变量文件、命令行标志

