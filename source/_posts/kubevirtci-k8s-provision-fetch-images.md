---
title: 一步步学KubeVirt CI （11） - k8s-provision - 获取镜像
readmore: true
date: 2022-07-19 19:06:52
categories: 云原生
tags:
- KubeVirt CI
---


# k8s-provision - 获取镜像

fetch-images.sh
```bash
#!/bin/bash

set -euo pipefail

function usage() {
    cat <<EOF
Usage: $0 <k8s-cluster-dir> [source-image-list]

    Fetches all images from the cluster provision source and manifests. Returns a list that is sorted and
    without double entries.

    If source-image-list is provided this is taken as an input and added to the result.

EOF
}

function check_args() {
    if [ "$#" -lt 1 ]; then
        usage
        exit 1
    fi
    if [ ! -d "$1" ]; then
        usage
        echo "Directory $1 does not exist"
        exit 1
    fi
}

function main() {
    check_args "$@"

    temp_file=$(mktemp)
    trap 'rm -f "${temp_file}"' EXIT SIGINT SIGTERM

    provision_dir="$1"
    image_regex='([a-z0-9\_\.]+[/-]?)+(@sha256)?:[a-z0-9\_\.\-]+'
    image_regex_w_double_quotes='"?'"${image_regex}"'"?'

    (
        # Avoid bailing out because of nothing found in scripts part
        set +e
        find "$provision_dir" -type f -name '*.sh' -print0 |
            xargs -0 grep -iE '(docker|podman)[ _]pull[^ ]+ '"${image_regex_w_double_quotes}"
        find "$provision_dir" -type f -name '*.yaml' -print0 |
            xargs -0 grep -iE '(image|value): '"${image_regex_w_double_quotes}"
        set -e
        # last `grep -v` is necessary to avoid trying to pre pull istio "images", as the regex also matches on values
        # from the generated istio deployment manifest
    ) | grep -ioE "${image_regex_w_double_quotes}"'$' | grep -v '.svc:' >>"${temp_file}"

    sed -E 's/"//g' "${temp_file}" | sort | uniq
}

main "$@"

```

main()调用了check_args()。然后把镜像信息都提取出来。

check_args()检查若参数个数小于1，打印help信息。检查第一个参数对应的文件夹不存在，报错以及打印help信息。

main()处理逻辑中用到了下面几个技巧：
* 用linux命令mktemp创建临时文件用来保存查询出来的中间数据。
* `trap 'rm -f "${temp_file}"' EXIT SIGINT SIGTERM` 在程序退出后清理临时文件。
* 用到了正则匹配image_regex是镜像名称格式，image_regex_w_double_quotes在image_regex基础加上了可以匹配双引号前后包裹的情况。主要是下面的三种镜像格式。
* find的`-print0`参数和`-print`的区别是前者去掉了后者的换行符。
* 用了2次find，分别查找sh脚本的镜像和manifest yaml配置文件里的镜像。
* find有可能查不到信息，而脚本的开头配置了`set -e`，就是find查不到信息的情况会退出当前脚本，显然不是想要的遇到错误退出当前脚本，在find前后配置`set +e`和恢复。
* grep用了`-e`参数，表示后面的字符串采用正则匹配，也可以用egrep代替。`-i`忽略大小写，正则表达式就不需要频繁加入A-Z，只需要a-z。`-o`只打印匹配的内容，可以去除镜像前的image，podman等信息。
* 最后对临时文件保存的中间数据去掉双引号，去重，排序

```bash
quay.io/openshift/origin-kube-rbac-proxy@sha256:baedb268ac66456018fb30af395bb3d69af5fff3252ff5d549f0231b1ebb6901
docker.io/calico/kube-controllers:v3.18.0
"quay.io/external_storage/local-volume-provisioner:v2.3.2"
```