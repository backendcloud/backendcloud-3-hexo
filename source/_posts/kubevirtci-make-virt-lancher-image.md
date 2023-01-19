---
title: kubevirtci make virt-lancher image
readmore: true
date: 2022-08-03 19:34:27
categories: 云原生
tags:
- KubeVirt CI
---

打包libvirt镜像，参考以前的文章 {% post_link kubevirtci-libvirt-version-image-script %}


# make virt-lancher image no-bazel

使用 Dockerfile，基础镜像用上面做的libvirt，将编译好的virt-launcher复制到/usr/bin/virt-launcher，并作为ENTRYPOINT。

```bash
FROM kubevirt/libvirt:4.9.0

LABEL maintainer="The KubeVirt Project <kubevirt-dev@googlegroups.com>"

RUN dnf -y install \
  edk2-ovmf \
  socat \
  genisoimage \
  && dnf -y clean all && \
  test $(id -u qemu) = 107 # make sure that the qemu user really is 107

COPY virt-launcher /usr/bin/virt-launcher
COPY .version /.version

# Allow qemu to bind privileged ports
RUN setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/qemu-system-x86_64

RUN mkdir -p /usr/share/kubevirt/virt-launcher
COPY sock-connector /usr/share/kubevirt/virt-launcher/

ENTRYPOINT [ "/usr/bin/virt-launcher" ]
```

# make virt-lancher image with-bazel

使用Bazel BUILD文件。load rules_docker，`base = "@libvirt//image",`基础镜像采用上面制作的libvirt镜像，将编译好的virt-launcher复制到/usr/bin/virt-launcher，并作为ENTRYPOINT。

```bash
...
load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_image",
)

container_image(
    name = "version-container",
    base = "@libvirt//image",
    directory = "/",
    files = ["//:get-version"],
)

container_image(
    name = "virt-launcher-image",
    base = ":version-container",
    entrypoint = ["/usr/bin/virt-launcher"],
    tars = [
        ":sock-connector-tar",
        ":virt-launcher-tar",
    ],
    visibility = ["//visibility:public"],
)
```