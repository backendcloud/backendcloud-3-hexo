---
title: kubevirtci-make-manifests
readmore: true
date: 2022-08-03 19:33:44
categories: 云原生
tags:
- KubeVirt CI
---


# make manifests or manifests-no-bazel

前者用bazel生成manifest，后者不用bazel。

主要区别就下面的生成`${templator}`的不同，后者进入仓库的tools/manifest-templator/目录后执行go build生成可执行文件然后复制到`${templator}`路径。

```bash
(cd ${KUBEVIRT_DIR}/tools/manifest-templator/ && go_build && cp manifest-templator ${templator})
```

前者是通过bazel生成`${templator}`。

```bash
bazel run \
        --config=${HOST_ARCHITECTURE} \
        //:build-manifest-templator -- ${templator}
```



# 下面进入 //:build-manifest-templator -- ${templator}

用了内置的genrule，input是tools/manifest-templator/目录下的templator标签，该标签对应于tools/manifest-templator/ package中的BUILD.bazel文件中的name：templator（用于go build “tools/manifest-templator/”工具），output是"manifest-templator-copier"，命令是`"echo '#!/bin/sh\n\ncp -f $(SRCS) $$1' > \"$@\""`。

这段genrule做的事情是往output文件中打印一段shell脚本，该脚本就执行了个复制操作。讲input源（就是go编译的tools/manifest-templator/工具）复制到`$1`（即`${templator}`）。

```bash
genrule(
    name = "build-manifest-templator",
    srcs = [
        "//tools/manifest-templator:templator",
    ],
    outs = ["manifest-templator-copier"],
    cmd = "echo '#!/bin/sh\n\ncp -f $(SRCS) $$1' > \"$@\"",
    executable = 1,
)
```


> 接下来都是用编译后的工具`${templator}`对manifests模板里的变量进行替换，得到manifests。