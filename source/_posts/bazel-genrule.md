---
title: bazel genrule
readmore: true
date: 2022-08-02 20:32:59
categories: Devops
tags:
- Bazel
---


# 创建一个简单的 c hello 项目

```bash
 ⚡ root@backendcloud  ~/bazel-genrule  touch WORKSPACE
 ⚡ root@backendcloud  ~/bazel-genrule  more dir/*
::::::::::::::
dir/BUILD.bazel
::::::::::::::
# dir/BUILD

cc_binary(
  name = "hello_bazel",
  srcs = ["main.c"],
)
::::::::::::::
dir/main.c
::::::::::::::
// dir/main.c

#include <stdio.h>

int main(int argc, char **argv) {
  printf("Hello Bazel.\n");
  return 0;
}
```

```bash
 ⚡ root@backendcloud  ~/bazel-genrule  bazel run //dir:hello_bazel
INFO: Analyzed target //dir:hello_bazel (36 packages loaded, 161 targets configured).
INFO: Found 1 target...
Target //dir:hello_bazel up-to-date:
  bazel-bin/dir/hello_bazel
INFO: Elapsed time: 2.158s, Critical Path: 0.08s
INFO: 6 processes: 4 internal, 2 linux-sandbox.
INFO: Build completed successfully, 6 total actions
INFO: Build completed successfully, 6 total actions
Hello Bazel.
 ⚡ root@backendcloud  ~/bazel-genrule  bazel build //dir:hello_bazel
INFO: Analyzed target //dir:hello_bazel (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //dir:hello_bazel up-to-date:
  bazel-bin/dir/hello_bazel
INFO: Elapsed time: 0.128s, Critical Path: 0.00s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
 ⚡ root@backendcloud  ~/bazel-genrule  tree bazel-bin
bazel-bin
└── dir
    ├── hello_bazel
    ├── hello_bazel-2.params
    ├── hello_bazel.runfiles
    │   ├── __main__
    │   │   └── dir
    │   │       └── hello_bazel -> /root/.cache/bazel/_bazel_root/ad9cc06f8fa63e04295f7fabfff7160e/execroot/__main__/bazel-out/k8-fastbuild/bin/dir/hello_bazel
    │   └── MANIFEST
    ├── hello_bazel.runfiles_manifest
    └── _objs
        └── hello_bazel
            ├── main.pic.d
            └── main.pic.o

6 directories, 7 files
 ⚡ root@backendcloud  ~/bazel-genrule  cp bazel-bin/dir/hello_bazel.runfiles/__main__/dir/hello_bazel .
 ⚡ root@backendcloud  ~/bazel-genrule  ./hello_bazel
Hello Bazel.
```

# 使用 genrule 执行一条命令

genrule 的 参数 分为： sources，a tool（例如一个内置命令，一个shell脚本），一条命令，outputs

```bash
genrule :: (name, sources, tool, command) -> output
```

下面的例子是cp一个点c文件，再运行一个写有sed功能的脚本。

```bash
 ⚡ root@backendcloud  ~/bazel-genrule  more dir2/*
::::::::::::::
dir2/BUILD.bazel
::::::::::::::
genrule(
  name = "copy_of_main",
  srcs = ["main.c"],
  outs = ["copy_of_main.c"],
  cmd = "cp $< $@",
)
::::::::::::::
dir2/main.c
::::::::::::::
#include <stdio.h>

int main(int argc, char **argv) {
  printf("Hello Blaze.\n");
  return 0;
}
```

`$<` 表示 input sources `main.c`， `$@` 表示 outputs `copy_of_main.c`。

```bash
 ⚡ root@backendcloud  ~/bazel-genrule  bazel build //dir2:copy_of_main
INFO: Analyzed target //dir2:copy_of_main (2 packages loaded, 3 targets configured).
INFO: Found 1 target...
Target //dir2:copy_of_main up-to-date:
  bazel-bin/dir2/copy_of_main.c
INFO: Elapsed time: 0.261s, Critical Path: 0.01s
INFO: 2 processes: 1 internal, 1 linux-sandbox.
INFO: Build completed successfully, 2 total actions
 ⚡ root@backendcloud  ~/bazel-genrule  tree bazel-bin
bazel-bin
├── dir
│   ├── hello_bazel
│   ├── hello_bazel-2.params
│   ├── hello_bazel.runfiles
│   │   ├── __main__
│   │   │   └── dir
│   │   │       └── hello_bazel -> /root/.cache/bazel/_bazel_root/ad9cc06f8fa63e04295f7fabfff7160e/execroot/__main__/bazel-out/k8-fastbuild/bin/dir/hello_bazel
│   │   └── MANIFEST
│   ├── hello_bazel.runfiles_manifest
│   └── _objs
│       └── hello_bazel
│           ├── main.pic.d
│           └── main.pic.o
└── dir2
    └── copy_of_main.c

7 directories, 8 files
 ⚡ root@backendcloud  ~/bazel-genrule  cat bazel-bin/dir2/copy_of_main.c
#include <stdio.h>

int main(int argc, char **argv) {
  printf("Hello Blaze.\n");
  return 0;
}
```

> 文件成功复制。

```bash
 ⚡ root@backendcloud  ~/bazel-genrule  more dir2/*
::::::::::::::
dir2/BUILD.bazel
::::::::::::::
genrule(
  name = "copy_of_main",
  srcs = ["main.c"],
  outs = ["copy_of_main.c"],
  cmd = "cp $< $@",
)

genrule(
  name = "renamed_main",
  srcs = ["copy_of_main.c"],
  outs = ["renamed_main.c"],
  tools = ["substitute.sh"],
  cmd = "$(location substitute.sh) 'Blaze' 'Bazel' $< $@",
)
::::::::::::::
dir2/main.c
::::::::::::::
#include <stdio.h>

int main(int argc, char **argv) {
  printf("Hello Blaze.\n");
  return 0;
}
::::::::::::::
dir2/substitute.sh
::::::::::::::
#!/bin/bash

sed "s/$1/$2/" $3 > $4
 ⚡ root@backendcloud  ~/bazel-genrule  bazel build //dir2:renamed_main
INFO: Analyzed target //dir2:renamed_main (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
ERROR: /root/bazel-genrule/dir2/BUILD.bazel:8:8: Executing genrule //dir2:renamed_main failed: (Exit 126): bash failed: error executing command /bin/bash -c 'source external/bazel_tools/tools/genrule/genrule-setup.sh; dir2/substitute.sh '\''Blaze'\'' '\''Bazel'\'' bazel-out/k8-fastbuild/bin/dir2/copy_of_main.c bazel-out/k8-fastbuild/bin/dir2/renamed_main.c'

Use --sandbox_debug to see verbose messages from the sandbox and retain the sandbox build root for debugging
/bin/bash: line 1: dir2/substitute.sh: Permission denied
Target //dir2:renamed_main failed to build
Use --verbose_failures to see the command lines of failed build steps.
INFO: Elapsed time: 0.104s, Critical Path: 0.01s
INFO: 2 processes: 2 internal.
FAILED: Build did NOT complete successfully
```

上面报错是因为没有权限，赋予权限。`chmod u+x substitute.sh`

```bash
 ✘ ⚡ root@backendcloud  ~/bazel-genrule  chmod 777 dir2/substitute.sh 
 ⚡ root@backendcloud  ~/bazel-genrule  bazel build //dir2:renamed_main
INFO: Analyzed target //dir2:renamed_main (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //dir2:renamed_main up-to-date:
  bazel-bin/dir2/renamed_main.c
INFO: Elapsed time: 0.103s, Critical Path: 0.01s
INFO: 2 processes: 1 internal, 1 linux-sandbox.
INFO: Build completed successfully, 2 total actions
 ⚡ root@backendcloud  ~/bazel-genrule  tree bazel-bin
bazel-bin
├── dir
│   ├── hello_bazel
│   ├── hello_bazel-2.params
│   ├── hello_bazel.runfiles
│   │   ├── __main__
│   │   │   └── dir
│   │   │       └── hello_bazel -> /root/.cache/bazel/_bazel_root/ad9cc06f8fa63e04295f7fabfff7160e/execroot/__main__/bazel-out/k8-fastbuild/bin/dir/hello_bazel
│   │   └── MANIFEST
│   ├── hello_bazel.runfiles_manifest
│   └── _objs
│       └── hello_bazel
│           ├── main.pic.d
│           └── main.pic.o
└── dir2
    ├── copy_of_main.c
    └── renamed_main.c

7 directories, 9 files
 ⚡ root@backendcloud  ~/bazel-genrule  cat bazel-bin/dir2/renamed_main.c
#include <stdio.h>

int main(int argc, char **argv) {
  printf("Hello Bazel.\n");
  return 0;
}
```

加上cc_binary，执行完成的BUILD流程：

```bash
 ⚡ root@backendcloud  ~/bazel-genrule  more dir2/*
::::::::::::::
dir2/BUILD.bazel
::::::::::::::
genrule(
  name = "copy_of_main",
  srcs = ["main.c"],
  outs = ["copy_of_main.c"],
  cmd = "cp $< $@",
)

genrule(
  name = "renamed_main",
  srcs = ["copy_of_main.c"],
  outs = ["renamed_main.c"],
  tools = ["substitute.sh"],
  cmd = "$(location substitute.sh) 'Blaze' 'Bazel' $< $@",
)

cc_binary(
  name = "hello_bazel",
  srcs = [":renamed_main"],
)
::::::::::::::
dir2/main.c
::::::::::::::
#include <stdio.h>

int main(int argc, char **argv) {
  printf("Hello Blaze.\n");
  return 0;
}
::::::::::::::
dir2/substitute.sh
::::::::::::::
#!/bin/bash

sed "s/$1/$2/" $3 > $4
 ⚡ root@backendcloud  ~/bazel-genrule  bazel run //dir2:hello_bazel
INFO: Analyzed target //dir2:hello_bazel (34 packages loaded, 160 targets configured).
INFO: Found 1 target...
Target //dir2:hello_bazel up-to-date:
  bazel-bin/dir2/hello_bazel
INFO: Elapsed time: 0.366s, Critical Path: 0.06s
INFO: 6 processes: 4 internal, 2 linux-sandbox.
INFO: Build completed successfully, 6 total actions
INFO: Build completed successfully, 6 total actions
Hello Bazel.
```