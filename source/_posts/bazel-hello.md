---
title: BUILD.bazel hello-world
readmore: true
date: 2022-06-15 19:25:03
categories: Tools
tags:
- bazel
---

# 简介
Bazel是一个类似于类似于 Make、Maven 和 Gradle的构建和测试工具。使用 Java、C++、Go、Android、iOS 以及许多其他语言和平台进行构建和测试。Bazel 可在 Windows、macOS 和 Linux 上运行。

Bazel近来很火，因为Bazel更容易与 Docker 和 Kubernetes 集成，其与项目的CI/CD挂钩，帮助提生产力。当然Bazel还有很多其他的优势：
* 开源
* 100%在沙箱环境构建
* 支持任何语言，因为除了直接支持的语言，还有支持语言扩展，比如官方维护的go语言扩展rules_go。支持编写任何其他语言的扩展，甚至自创了一套配置语言Starlark。
* 支持超大项目
* 快速构建，快速测试

# install bazel 的两种方式
## bazel release 页面下载二进制文件
> https://github.com/bazelbuild/bazel/releases

## 自行编译成二进制文件
```bash
[developer@localhost ~]$ git clone https://github.com/sub-mod/bazel-builds
Cloning into 'bazel-builds'...
remote: Enumerating objects: 8, done.
remote: Total 8 (delta 0), reused 0 (delta 0), pack-reused 8
Unpacking objects: 100% (8/8), done.
[developer@localhost ~]$ cd bazel-builds/
[developer@localhost bazel-builds]$ ls
compile_bazel.sh  Dockerfile  README.md
[developer@localhost bazel-builds]$ docker build -t submod/bazel-build -f Dockerfile .
Sending build context to Docker daemon  60.42kB
Step 1/11 : FROM quay.io/sub_mod/manylinux2010-s2i
latest: Pulling from sub_mod/manylinux2010-s2i
5f017a04f42a: Pull complete 
c26811943bc4: Pull complete 
3109f06a2dea: Pull complete 
14d95ec965d1: Pull complete 
063fe0284015: Pull complete 
91fbfeacdb14: Pull complete 
1ccf9e79b962: Pull complete 
ae85d0fb9037: Pull complete 
10b95c4b0739: Pull complete 
18f67aa9e4e0: Pull complete 
0563d785bb24: Pull complete 
8a22ddd469d0: Pull complete 
62e98946bedc: Pull complete 
4e6e8bfd7920: Pull complete 
061b91ccb09b: Pull complete 
5568def49d7f: Pull complete 
0e1f23ce1023: Pull complete 
796c07df8e3e: Pull complete 
ef48c6f62ed1: Pull complete 
e01104580113: Pull complete 
dad2a4db0ba8: Pull complete 
9fc522177a50: Pull complete 
46f431dbc47d: Pull complete 
5aaae20e40d9: Pull complete 
a4eb32cc6d9b: Pull complete 
c7b0da64f50d: Pull complete 
4a0defbf23a4: Pull complete 
a3e63cb9f51d: Pull complete 
Digest: sha256:e7888ae2ecfe912ce192c16ab07fbcb3239a18ddcbd01a649ce9cd99e5fc4395
Status: Downloaded newer image for quay.io/sub_mod/manylinux2010-s2i:latest
 ---> 0eab18ac8125
Step 2/11 : LABEL Author "Subin Modeel <smodeel@redhat.com>"
 ---> Running in d797e7696ab3
Removing intermediate container d797e7696ab3
 ---> 9b8f32447843
Step 3/11 : USER root
 ---> Running in bb99bcbe78ca
Removing intermediate container bb99bcbe78ca
 ---> e7159b9da620
Step 4/11 : ENV JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-1.8.0*"     PLATFORM="el6"
 ---> Running in 0a74e4c38fe3
Removing intermediate container 0a74e4c38fe3
 ---> d81996e6bf1b
Step 5/11 : RUN yum install -y centos-release-scl unzip tree mlocate vim wget ccache sudo     && yum install -y devtoolset-7 rh-python36     && yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel
 ---> Running in f03e3153b123
Loaded plugins: ovl
Setting up Install Process
Package 10:centos-release-scl-7-4.el6.centos.noarch already installed and latest version
Package unzip-6.0-5.el6.x86_64 already installed and latest version
Resolving Dependencies
...
Removing intermediate container f03e3153b123
 ---> 9ea84735d107
Step 6/11 : RUN source scl_source enable devtoolset-7 rh-python36     && gcc --version     && python -V     && pip install --upgrade pip
 ---> Running in 01a8eb8d7e57
gcc (GCC) 7.3.1 20180303 (Red Hat 7.3.1-5)
Copyright (C) 2017 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Python 3.6.12
The directory '/opt/app-root/src/.cache/pip/http' or its parent directory is not owned by the current user and the cache has been disabled. Please check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
The directory '/opt/app-root/src/.cache/pip' or its parent directory is not owned by the current user and caching wheels has been disabled. check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
Collecting pip
  Downloading https://files.pythonhosted.org/packages/a4/6d/6463d49a933f547439d6b5b98b46af8742cc03ae83543e4d7688c2420f8b/pip-21.3.1-py3-none-any.whl (1.7MB)
Installing collected packages: pip
  Found existing installation: pip 9.0.1
    Uninstalling pip-9.0.1:
      Successfully uninstalled pip-9.0.1
Successfully installed pip-21.3.1
You are using pip version 21.3.1, however version 22.1.2 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
Removing intermediate container 01a8eb8d7e57
 ---> 9b1a14b90024
Step 7/11 : RUN echo "echo 'using user scl_enable script'" >> ${APP_ROOT}/etc/scl_enable     && echo "source scl_source enable rh-python36 devtoolset-7" >> ${APP_ROOT}/etc/scl_enable     && echo "JAVA_HOME='/usr/lib/jvm/java-1.8.0-openjdk-1.8.0*'" >> ${APP_ROOT}/etc/scl_enable     && echo "FULL_JAVA_HOME=$(readlink -f $JAVA_HOME)" >> ${APP_ROOT}/etc/scl_enable     && echo "export JAVA_HOME=\$FULL_JAVA_HOME" >> ${APP_ROOT}/etc/scl_enable     && echo "export CC=/opt/rh/devtoolset-7/root/usr/bin/gcc" >> ${APP_ROOT}/etc/scl_enable     && echo "export CXX=/opt/rh/devtoolset-7/root/usr/bin/g++" >> ${APP_ROOT}/etc/scl_enable     && echo "export EXTRA_BAZEL_ARGS='--verbose_failures'" >> ${APP_ROOT}/etc/scl_enable     && echo "export BAZEL_LINKLIBS='-l%:libstdc++.a'" >> ${APP_ROOT}/etc/scl_enable
 ---> Running in add23de16705
Removing intermediate container add23de16705
 ---> 258d833cd89a
Step 8/11 : WORKDIR ${HOME}
 ---> Running in 0ebed8de2a0a
Removing intermediate container 0ebed8de2a0a
 ---> c7c161bac6cd
Step 9/11 : ENTRYPOINT ["container-entrypoint"]
 ---> Running in 947f99d29e51
Removing intermediate container 947f99d29e51
 ---> e342d64de7c0
Step 10/11 : CMD ["base-usage"]
 ---> Running in 162578924dc5
Removing intermediate container 162578924dc5
 ---> 9b7fc5ad724a
Step 11/11 : USER 1001
 ---> Running in cab42ec2b9f7
Removing intermediate container cab42ec2b9f7
 ---> 4d9f971b6549
Successfully built 4d9f971b6549
Successfully tagged submod/bazel-build:latest
[developer@localhost bazel-builds]$ docker run -it -v $(pwd):/opt/app-root/src -u 0 submod/bazel-build:latest /bin/bash
using user scl_enable script
bash-4.1# docker ps
bash: docker: command not found
bash-4.1# ls
compile_bazel.sh  Dockerfile  README.md
bash-4.1# ./compile_bazel.sh
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/opt/rh/devtoolset-7/root/usr/libexec/gcc/x86_64-redhat-linux/7/lto-wrapper
Target: x86_64-redhat-linux
Configured with: ../configure --enable-bootstrap --enable-languages=c,c++,fortran,lto --prefix=/opt/rh/devtoolset-7/root/usr --mandir=/opt/rh/devtoolset-7/root/usr/share/man --infodir=/opt/rh/devtoolset-7/root/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-shared --enable-threads=posix --enable-checking=release --enable-multilib --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-gcc-major-version-only --enable-plugin --with-linker-hash-style=gnu --enable-initfini-array --with-default-libstdcxx-abi=gcc4-compatible --with-isl=/builddir/build/BUILD/gcc-7.3.1-20180303/obj-x86_64-redhat-linux/isl-install --enable-libmpx --with-mpc=/builddir/build/BUILD/gcc-7.3.1-20180303/obj-x86_64-redhat-linux/mpc-install --with-tune=generic --with-arch_32=i686 --build=x86_64-redhat-linux
Thread model: posix
gcc version 7.3.1 20180303 (Red Hat 7.3.1-5) (GCC) 
Python 3.6.12
/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.275.b01-0.el6_10.x86_64
3.4.1
--2022-06-15 14:24:21--  https://github.com/bazelbuild/bazel/releases/download/3.4.1/bazel-3.4.1-dist.zip
Resolving github.com... 20.205.243.166
Connecting to github.com|20.205.243.166|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://objects.githubusercontent.com/github-production-release-asset-2e65be/20773773/65bba880-c5ae-11ea-89bf-92c3e5e5dcbc?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20220615%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220615T062424Z&X-Amz-Expires=300&X-Amz-Signature=eac18304d5aede347e976f3674829e56bbec5482bf062f1b161c4dd6d9cb32f0&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=20773773&response-content-disposition=attachment%3B%20filename%3Dbazel-3.4.1-dist.zip&response-content-type=application%2Foctet-stream [following]
--2022-06-15 14:24:21--  https://objects.githubusercontent.com/github-production-release-asset-2e65be/20773773/65bba880-c5ae-11ea-89bf-92c3e5e5dcbc?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20220615%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220615T062424Z&X-Amz-Expires=300&X-Amz-Signature=eac18304d5aede347e976f3674829e56bbec5482bf062f1b161c4dd6d9cb32f0&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=20773773&response-content-disposition=attachment%3B%20filename%3Dbazel-3.4.1-dist.zip&response-content-type=application%2Foctet-stream
Resolving objects.githubusercontent.com... 185.199.108.133, 185.199.109.133, 185.199.111.133
Connecting to objects.githubusercontent.com|185.199.108.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 303411732 (289M) [application/octet-stream]
Saving to: “bazel-3.4.1-dist.zip”

100%[==================================================================================================================================================================================================================================>] 303,411,732 6.87M/s   in 55s     

2022-06-15 14:25:17 (5.28 MB/s) - “bazel-3.4.1-dist.zip” saved [303411732/303411732]

Archive:  bazel-3.4.1-dist.zip
  inflating: bazel-3.4.1/AUTHORS     
  inflating: bazel-3.4.1/BUILD       
  inflating: bazel-3.4.1/CHANGELOG.md  
  inflating: bazel-3.4.1/CODEOWNERS  
  inflating: bazel-3.4.1/CONTRIBUTING.md  
  inflating: bazel-3.4.1/CONTRIBUTORS  
  inflating: bazel-3.4.1/ISSUE_TEMPLATE.md  
  ...
  inflating: bazel-3.4.1/third_party/bazel_bootstrap/libserialization-constant-annotation.jar  
  inflating: bazel-3.4.1/third_party/bazel_bootstrap/libserialization-constant-processor.jar  
  inflating: bazel-3.4.1/third_party/bazel_bootstrap/libserialization-processor-util.jar  
  inflating: bazel-3.4.1/third_party/bazel_bootstrap/libserialization.jar  
  inflating: bazel-3.4.1/third_party/bazel_bootstrap/libunsafe-provider.jar  
🍃  Building Bazel from scratch......
🍃  Building Bazel with Bazel.
DEBUG: /tmp/bazel_Kl2DhjY4/out/external/bazel_toolchains/rules/rbe_repo/version_check.bzl:59:14: 
Current running Bazel is not a release version and one was not defined explicitly in rbe_autoconfig target. Falling back to '3.1.0'
DEBUG: /tmp/bazel_Kl2DhjY4/out/external/bazel_toolchains/rules/rbe_repo/checked_in.bzl:103:14: rbe_ubuntu1804_java11 not using checked in configs as detect_java_home was set to True 
DEBUG: /tmp/bazel_Kl2DhjY4/out/external/bazel_toolchains/rules/rbe_repo/version_check.bzl:59:14: 
Current running Bazel is not a release version and one was not defined explicitly in rbe_autoconfig target. Falling back to '3.1.0'
DEBUG: /tmp/bazel_Kl2DhjY4/out/external/bazel_toolchains/rules/rbe_repo/checked_in.bzl:103:14: rbe_ubuntu1604_java8 not using checked in configs as detect_java_home was set to True 
DEBUG: /tmp/bazel_Kl2DhjY4/out/external/build_bazel_rules_nodejs/internal/common/check_bazel_version.bzl:47:14: 
Current Bazel is not a release version, cannot check for compatibility.
DEBUG: /tmp/bazel_Kl2DhjY4/out/external/build_bazel_rules_nodejs/internal/common/check_bazel_version.bzl:49:14: Make sure that you are running at least Bazel 0.21.0.
DEBUG: /tmp/bazel_Kl2DhjY4/out/external/build_bazel_rules_nodejs/internal/common/check_bazel_version.bzl:47:14: 
Current Bazel is not a release version, cannot check for compatibility.
DEBUG: /tmp/bazel_Kl2DhjY4/out/external/build_bazel_rules_nodejs/internal/common/check_bazel_version.bzl:49:14: Make sure that you are running at least Bazel 0.21.0.
INFO: Analyzed target //src:bazel_nojdk (301 packages loaded, 8986 targets configured).
INFO: Found 1 target...
INFO: From Compiling src/main/cpp/blaze_util_posix.cc:
src/main/cpp/blaze_util_posix.cc: In function 'uint64_t blaze::AcquireLock(const blaze_util::Path&, bool, bool, blaze::BlazeLock*)':
src/main/cpp/blaze_util_posix.cc:704:3: warning: ignoring return value of 'int ftruncate(int, __off_t)', declared with attribute warn_unused_result [-Wunused-result]
   (void) ftruncate(lockfd, 0);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
INFO: From Compiling third_party/grpc/src/core/lib/gpr/string.cc:
In file included from /usr/include/string.h:642:0,
                 from third_party/grpc/src/core/lib/gpr/string.cc:28:
In function 'void* memset(void*, int, size_t)',
    inlined from 'char* gpr_leftpad(const char*, char, size_t)' at third_party/grpc/src/core/lib/gpr/string.cc:221:9:
/usr/include/bits/string3.h:82:30: warning: call to '__warn_memset_zero_len' declared with attribute warning: memset used with constant zero length parameter; this could be due to transposed parameters
       __warn_memset_zero_len ();
       ~~~~~~~~~~~~~~~~~~~~~~~^~
INFO: From Compiling src/main/cpp/blaze.cc:
src/main/cpp/blaze.cc: In function 'void blaze::WriteFileToStderrOrDie(const blaze_util::Path&)':
src/main/cpp/blaze.cc:752:11: warning: ignoring return value of 'size_t fwrite(const void*, size_t, size_t, FILE*)', declared with attribute warn_unused_result [-Wunused-result]
     fwrite(buffer, 1, num_read, stderr);
     ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
INFO: From Linking src/main/cpp/client:
bazel-out/k8-opt/bin/third_party/grpc/_objs/gpr_base/string.o:string.cc:function gpr_leftpad(char const*, char, unsigned long): warning: memset used with constant zero length parameter; this could be due to transposed parameters
INFO: From Compiling external/bazel_tools/third_party/ijar/zip_main.cc [for host]:
In file included from /usr/include/string.h:642:0,
                 from external/bazel_tools/third_party/ijar/zip_main.cc:28:
In function 'void* memcpy(void*, const void*, size_t)',
    inlined from 'char** devtools_ijar::read_filelist(char*)' at external/bazel_tools/third_party/ijar/zip_main.cc:258:9:
/usr/include/bits/string3.h:52:71: warning: 'void* __builtin_memcpy(void*, const void*, long unsigned int)': specified size between 18446744071562067968 and 18446744073709551615 exceeds maximum object size 9223372036854775807 [-Wstringop-overflow=]
   return __builtin___memcpy_chk (__dest, __src, __len, __bos0 (__dest));
                                                                       ^
INFO: From Compiling third_party/ijar/zip_main.cc:
In file included from /usr/include/string.h:642:0,
                 from third_party/ijar/zip_main.cc:28:
In function 'void* memcpy(void*, const void*, size_t)',
    inlined from 'char** devtools_ijar::read_filelist(char*)' at third_party/ijar/zip_main.cc:258:9:
/usr/include/bits/string3.h:52:71: warning: 'void* __builtin_memcpy(void*, const void*, long unsigned int)': specified size between 18446744071562067968 and 18446744073709551615 exceeds maximum object size 9223372036854775807 [-Wstringop-overflow=]
   return __builtin___memcpy_chk (__dest, __src, __len, __bos0 (__dest));
                                                                       ^
INFO: From Compiling src/main/java/com/google/devtools/build/lib/syntax/cpu_profiler_posix.cc:
src/main/java/com/google/devtools/build/lib/syntax/cpu_profiler_posix.cc: In function 'void cpu_profiler::onsigprof(int)':
src/main/java/com/google/devtools/build/lib/syntax/cpu_profiler_posix.cc:55:10: warning: ignoring return value of 'ssize_t write(int, const void*, size_t)', declared with attribute warn_unused_result [-Wunused-result]
     write(2, msg, strlen(msg));
     ~~~~~^~~~~~~~~~~~~~~~~~~~~
src/main/java/com/google/devtools/build/lib/syntax/cpu_profiler_posix.cc:77:12: warning: ignoring return value of 'ssize_t write(int, const void*, size_t)', declared with attribute warn_unused_result [-Wunused-result]
       write(2, msg, strlen(msg));
       ~~~~~^~~~~~~~~~~~~~~~~~~~~
src/main/java/com/google/devtools/build/lib/syntax/cpu_profiler_posix.cc:86:12: warning: ignoring return value of 'ssize_t write(int, const void*, size_t)', declared with attribute warn_unused_result [-Wunused-result]
       write(2, buf, strlen(buf));
       ~~~~~^~~~~~~~~~~~~~~~~~~~~
INFO: From Compiling src/main/tools/daemonize.c:
src/main/tools/daemonize.c: In function 'WritePidFile':
src/main/tools/daemonize.c:95:3: warning: ignoring return value of 'write', declared with attribute warn_unused_result [-Wunused-result]
   write(pid_done_fd, &dummy, sizeof(dummy));
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
INFO: From Generating Java (Immutable) proto_library @googleapis//:google_devtools_build_v1_build_events_proto:
google/devtools/build/v1/build_events.proto:20:1: warning: Import google/api/annotations.proto is unused.
INFO: From Action external/googleapis/google_bytestream_bytestream_java_grpc_srcs.jar:
google/bytestream/bytestream.proto:19:1: warning: Import google/api/annotations.proto is unused.
INFO: From Generating Java (Immutable) proto_library //src/main/protobuf:execution_statistics_proto:
[libprotobuf WARNING external/com_google_protobuf/src/google/protobuf/compiler/java/java_file.cc:242] The optimize_for = LITE_RUNTIME option is no longer supported by protobuf Java code generator and is ignored--protoc will always generate full runtime code for Java. To use Java Lite runtime, users should use the Java Lite plugin instead. See:
  https://github.com/protocolbuffers/protobuf/blob/master/java/lite.md
INFO: From Generating Java (Immutable) proto_library @googleapis//:google_api_auth_proto:
google/api/auth.proto:19:1: warning: Import google/api/annotations.proto is unused.
INFO: From Generating Java (Immutable) proto_library @googleapis//:google_bytestream_bytestream_proto:
google/bytestream/bytestream.proto:19:1: warning: Import google/api/annotations.proto is unused.
INFO: From Generating Java (Immutable) proto_library @googleapis//:google_devtools_build_v1_build_status_proto:
google/devtools/build/v1/build_status.proto:20:1: warning: Import google/api/annotations.proto is unused.
INFO: From JavacBootstrap src/main/java/com/google/devtools/build/lib/shell/libshell-skylark.jar [for host]:
warning: Implicitly compiled files were not subject to annotation processing.
  Use -proc:none to disable annotation processing or -implicit to specify a policy for implicit compilation.
1 warning
INFO: From JavacBootstrap src/java_tools/singlejar/java/com/google/devtools/build/singlejar/libbootstrap.jar [for host]:
warning: Implicitly compiled files were not subject to annotation processing.
  Use -proc:none to disable annotation processing or -implicit to specify a policy for implicit compilation.
1 warning
INFO: From JavacBootstrap src/java_tools/buildjar/java/com/google/devtools/build/buildjar/libskylark-deps.jar [for host]:
warning: Implicitly compiled files were not subject to annotation processing.
  Use -proc:none to disable annotation processing or -implicit to specify a policy for implicit compilation.
Note: Some input files use or override a deprecated API.
Note: Recompile with -Xlint:deprecation for details.
1 warning
INFO: From JavacBootstrap src/java_tools/buildjar/java/com/google/devtools/build/buildjar/libbootstrap_VanillaJavaBuilder.jar [for host]:
warning: Implicitly compiled files were not subject to annotation processing.
  Use -proc:none to disable annotation processing or -implicit to specify a policy for implicit compilation.
Note: src/java_tools/buildjar/java/com/google/devtools/build/buildjar/VanillaJavaBuilder.java uses or overrides a deprecated API.
Note: Recompile with -Xlint:deprecation for details.
1 warning
Target //src:bazel_nojdk up-to-date:
  bazel-bin/src/bazel_nojdk
INFO: Elapsed time: 409.662s, Critical Path: 75.25s
INFO: 2279 processes: 1572 local, 707 worker.
INFO: Build completed successfully, 2328 total actions
DEBUG: /tmp/bazel_Kl2DhjY4/out/external/bazel_toolchains/rules/rbe_repo/version_check.bzl:59:14: 
Current running Bazel is not a release version and one was not defined explicitly in rbe_autoconfig target. Falling back to '3.1.0'
DEBUG: /tmp/bazel_Kl2DhjY4/out/external/bazel_toolchains/rules/rbe_repo/checked_in.bzl:103:14: rbe_ubuntu1804_java11 not using checked in configs as detect_java_home was set to True 
DEBUG: /tmp/bazel_Kl2DhjY4/out/external/bazel_toolchains/rules/rbe_repo/version_check.bzl:59:14: 
Current running Bazel is not a release version and one was not defined explicitly in rbe_autoconfig target. Falling back to '3.1.0'
DEBUG: /tmp/bazel_Kl2DhjY4/out/external/bazel_toolchains/rules/rbe_repo/checked_in.bzl:103:14: rbe_ubuntu1604_java8 not using checked in configs as detect_java_home was set to True 
DEBUG: /tmp/bazel_Kl2DhjY4/out/external/build_bazel_rules_nodejs/internal/common/check_bazel_version.bzl:47:14: 
Current Bazel is not a release version, cannot check for compatibility.
DEBUG: /tmp/bazel_Kl2DhjY4/out/external/build_bazel_rules_nodejs/internal/common/check_bazel_version.bzl:49:14: Make sure that you are running at least Bazel 0.21.0.
DEBUG: /tmp/bazel_Kl2DhjY4/out/external/build_bazel_rules_nodejs/internal/common/check_bazel_version.bzl:47:14: 
Current Bazel is not a release version, cannot check for compatibility.
DEBUG: /tmp/bazel_Kl2DhjY4/out/external/build_bazel_rules_nodejs/internal/common/check_bazel_version.bzl:49:14: Make sure that you are running at least Bazel 0.21.0.

Build successful! Binary is here: /opt/app-root/src/bazel-3.4.1/output/bazel
bash-4.1# ls -l /opt/app-root/src/bazel-3.4.1/output/bazel
-rwxr-xr-x. 1 root root 27045648 Jun 15 14:33 /opt/app-root/src/bazel-3.4.1/output/bazel
bash-4.1# 
[root@localhost ~]# docker cp 1f18f39977a4:/opt/app-root/src/bazel-3.4.1/output/bazel /usr/bin
[root@localhost ~]# which bazel
/usr/bin/bazel
[root@localhost ~]# ll /usr/bin/bazel
-rwxr-xr-x. 1 root root 27045648 Jun 15 22:33 /usr/bin/bazel
```

# bazel shell hello-world
```bash
[root@localhost ~]# git clone https://github.com/sendoamr/bazel-hello-world
[root@localhost ~]# cd bazel-hello-world
[root@localhost bazel-hello-world]# bazel build //shell:helloWorld
INFO: Analyzed target //shell:helloWorld (17 packages loaded, 51 targets configured).
INFO: Found 1 target...
Target //shell:helloWorld up-to-date:
  bazel-bin/shell/helloWorld
INFO: Elapsed time: 2.458s, Critical Path: 0.02s
INFO: 0 processes.
INFO: Build completed successfully, 4 total actions
# 若报错，可以删除WORKSPACE文件再touch一个空的WORKSPACE文件
[root@localhost bazel-hello-world]# bazel run //shell:helloWorld
INFO: Analyzed target //shell:helloWorld (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //shell:helloWorld up-to-date:
  bazel-bin/shell/helloWorld
INFO: Elapsed time: 0.178s, Critical Path: 0.00s
INFO: 0 processes.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
Sell: Hello world!
{
"message": "Hello world!"
}
```

# bazel go hello-world
```bash
[root@localhost bazel-hello-world]# bazel build //go:helloWorld
ERROR: Skipping '//go:helloWorld': error loading package 'go': Unable to find package for @io_bazel_rules_go//go:def.bzl: The repository '@io_bazel_rules_go' could not be resolved.
WARNING: Target pattern parsing failed.
ERROR: Unable to find package for @io_bazel_rules_go//go:def.bzl: The repository '@io_bazel_rules_go' could not be resolved.
INFO: Elapsed time: 0.064s
INFO: 0 processes.
FAILED: Build did NOT complete successfully (1 packages loaded)
```
> 报错是因为缺少bazel_rules_go，将 https://github.com/bazelbuild/rules_go#setup 的一段内容加到WORKSPACE文件中
```bash
[root@localhost bazel-hello-world]# ~/bazel build //go:helloWorld
Starting local Bazel server and connecting to it...
INFO: Analyzed target //go:helloWorld (52 packages loaded, 8563 targets configured).
INFO: Found 1 target...
Target //go:helloWorld up-to-date:
  bazel-bin/go/helloWorld_/helloWorld
INFO: Elapsed time: 27.619s, Critical Path: 0.83s
INFO: 8 processes: 4 internal, 4 processwrapper-sandbox.
INFO: Build completed successfully, 8 total actions
[root@localhost bazel-hello-world]# ~/bazel run //go:helloWorld
Starting local Bazel server and connecting to it...
INFO: Analyzed target //go:helloWorld (52 packages loaded, 8563 targets configured).
INFO: Found 1 target...
Target //go:helloWorld up-to-date:
  bazel-bin/go/helloWorld_/helloWorld
INFO: Elapsed time: 6.787s, Critical Path: 0.06s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
Go: Hello world!
{
"message": "Hello world!"
}
```

