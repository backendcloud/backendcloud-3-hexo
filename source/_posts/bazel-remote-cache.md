---
title: Bazel remote cache
readmore: true
date: 2022-08-01 13:14:49
categories: Devops
tags:
- Bazel
---

本篇的源码放在： https://github.com/backendcloud/example/tree/master/bazel-remote


使用以前发过的文章{% post_link bazel-go-hello %}里的 bazel-hello-go 项目。


配置使用bazel remote cache。可以bazel命令行增加`--remote_cache=`参数，但是需要每条命令都加。为了简便可以将其配置到配置文件中。

```bash
 ⚡ root@backendcloud  ~/bazel-remote  cat .bazelrc 
build --remote_cache=http://localhost:9090
build --remote_timeout=150
```

先测试下配置了remote cache但是bazel remote server没有开启的情况。

根据remote cache 配置，优先使用远程的 bazel server 的缓存，若这个时候 bazel server 服务还没有开启，没有找到，则给出warning，然后本地构建，缓存到本地。

```bash
 ⚡ root@backendcloud  ~/bazel-remote  bazel clean            
INFO: Invocation ID: d52888ef-fa20-4265-8029-df762db9795b
INFO: Starting clean (this may take a while). Consider using --async if the clean takes more than several minutes.
 ⚡ root@backendcloud  ~/bazel-remote  bazel build //main:main
INFO: Invocation ID: 59559957-eb61-4eb7-b4d4-8f8709753dc8
INFO: Analyzed target //main:main (51 packages loaded, 8558 targets configured).
INFO: Found 1 target...
WARNING: Remote Cache: Connection refused: localhost/127.0.0.1:9090
WARNING: Remote Cache: 3 errors during bulk transfer:
io.netty.channel.AbstractChannel$AnnotatedConnectException: Connection refused: localhost/127.0.0.1:9090
io.netty.channel.AbstractChannel$AnnotatedConnectException: Connection refused: localhost/127.0.0.1:9090
io.netty.channel.AbstractChannel$AnnotatedConnectException: Connection refused: localhost/127.0.0.1:9090
WARNING: Remote Cache: 4 errors during bulk transfer:
io.netty.channel.AbstractChannel$AnnotatedConnectException: Connection refused: localhost/127.0.0.1:9090
io.netty.channel.AbstractChannel$AnnotatedConnectException: Connection refused: localhost/127.0.0.1:9090
io.netty.channel.AbstractChannel$AnnotatedConnectException: Connection refused: localhost/127.0.0.1:9090
io.netty.channel.AbstractChannel$AnnotatedConnectException: Connection refused: localhost/127.0.0.1:9090
Target //main:main up-to-date:
  bazel-bin/main/main_/main
INFO: Elapsed time: 1.462s, Critical Path: 0.75s
INFO: 8 processes: 4 internal, 4 linux-sandbox.
INFO: Build completed successfully, 8 total actions
```

现在开启 bazel server。

```bash
 ⚡ root@backendcloud  ~  docker pull buchgr/bazel-remote-cache
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
✔ docker.io/buchgr/bazel-remote-cache:latest
Trying to pull docker.io/buchgr/bazel-remote-cache:latest...
Getting image source signatures
Copying blob 51747f63bf0a done  
Copying blob e8614d09b7be done  
Copying blob c6f4d1a13b69 done  
Copying blob 97bfab678aab done  
Copying config b2b137a75a done  
Writing manifest to image destination
Storing signatures
b2b137a75a4fe036a5641c2ac174058bdcb4b53c9567881b21d6cea6d177c89c
 ⚡ root@backendcloud  ~/bazel-remote  docker run -u 1000:1000 -v /root/bazel-remote/dummy-remote-cache:/data -p 9090:8080 -p 9092:9092 buchgr/bazel-remote-cache
```

正常构建，没有之前构建找不到remote server的warning。

```bash
 ⚡ root@backendcloud  ~/bazel-remote  bazel clean                                                                                                               
INFO: Invocation ID: 8b5f8fdb-5726-4a6e-bb78-397a13e0fb3a
INFO: Starting clean (this may take a while). Consider using --async if the clean takes more than several minutes.
 ⚡ root@backendcloud  ~/bazel-remote  bazel build //main:main                                                                                                   
INFO: Invocation ID: 26ecf58b-f38b-4704-88f8-e4b363d76dd6
INFO: Analyzed target //main:main (51 packages loaded, 8558 targets configured).
INFO: Found 1 target...
Target //main:main up-to-date:
  bazel-bin/main/main_/main
INFO: Elapsed time: 0.776s, Critical Path: 0.13s
INFO: 8 processes: 4 remote cache hit, 4 internal.
INFO: Build completed successfully, 8 total actions
```

检查bazel remote server cache的日志：

```bash
 ⚡ root@backendcloud  ~/bazel-remote  docker run -u 1000:1000 -v /root/bazel-remote/dummy-remote-cache:/data -p 9090:8080 -p 9092:9092 buchgr/bazel-remote-cache
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
2022/08/01 05:50:13 bazel-remote built with go1.18.4 from git commit 951cb59c415abc46a67412a6e9206fc6c00da40d.
2022/08/01 05:50:13 Initial RLIMIT_NOFILE cur: 1048576 max: 1048576
2022/08/01 05:50:13 Setting RLIMIT_NOFILE cur: 1048576 max: 1048576
2022/08/01 05:50:13 Storage mode: zstd
2022/08/01 05:50:13 Zstandard implementation: go
2022/08/01 05:50:13 Limiting concurrent file removals to 5000
2022/08/01 05:50:13 Loading existing files in /data.
2022/08/01 05:50:13 Sorting cache files by atime.
2022/08/01 05:50:13 Building LRU index.
2022/08/01 05:50:13 Finished loading disk cache files.
2022/08/01 05:50:13 Loaded 17 existing disk cache items.
2022/08/01 05:50:13 Authentication: disabled
2022/08/01 05:50:13 Mangling non-empty instance names with AC keys: disabled
2022/08/01 05:50:13 gRPC AC dependency checks: enabled
2022/08/01 05:50:13 experimental gRPC remote asset API: disabled
2022/08/01 05:50:13 Starting gRPC server on address :9092
2022/08/01 05:50:13 Starting HTTP server for profiling on address :6060
2022/08/01 05:50:13 Starting HTTP server on address :8080
2022/08/01 05:50:13 HTTP AC validation: enabled
2022/08/01 05:50:33 GRPC CAS HEAD c93640c39c0d364a4370b6fc6a8393197333f1b9f53485f452ab376afc51ffbd OK
2022/08/01 05:50:33 GRPC CAS HEAD e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 OK
2022/08/01 05:50:33 GRPC CAS HEAD e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 OK
2022/08/01 05:50:33  GET 200       10.88.0.1 /ac/d1a6a5be479277f96215c18989d1575fa7864210f85fca08b738bd4737dec72c
2022/08/01 05:50:33  GET 200       10.88.0.1 /cas/c93640c39c0d364a4370b6fc6a8393197333f1b9f53485f452ab376afc51ffbd
2022/08/01 05:50:33 GRPC CAS HEAD 1c5a4bdcd4182a020257f7afd9e0ca489a1903b7fbea72770bc765177d05afa4 OK
2022/08/01 05:50:33 GRPC CAS HEAD e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 OK
2022/08/01 05:50:33 GRPC CAS HEAD e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 OK
2022/08/01 05:50:33  GET 200       10.88.0.1 /ac/d3ff58cd0b019b4cc13bab29d292d7751904ca55af0a7a287eaee8eea40886b9
2022/08/01 05:50:33  GET 200       10.88.0.1 /cas/1c5a4bdcd4182a020257f7afd9e0ca489a1903b7fbea72770bc765177d05afa4
2022/08/01 05:50:33 GRPC CAS HEAD 3d6be95289cdfc1f5d7e72139ba15f1e61961bf8a754d94bc428213b916e84a4 OK
2022/08/01 05:50:33 GRPC CAS HEAD ecd3c8e667cb081f2aef650b61d3ef1876f5e708e78d662fb373e75e4d9151c2 OK
2022/08/01 05:50:33 GRPC CAS HEAD e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 OK
2022/08/01 05:50:33 GRPC CAS HEAD e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 OK
2022/08/01 05:50:33  GET 200       10.88.0.1 /ac/f6332f30f716c0c2af97cc4cc4d3ee60aa81a40eaf5d7fe6ccbb272d490d7819
2022/08/01 05:50:33  GET 200       10.88.0.1 /cas/ecd3c8e667cb081f2aef650b61d3ef1876f5e708e78d662fb373e75e4d9151c2
2022/08/01 05:50:33  GET 200       10.88.0.1 /cas/3d6be95289cdfc1f5d7e72139ba15f1e61961bf8a754d94bc428213b916e84a4
2022/08/01 05:50:33 GRPC CAS HEAD baa521657fa89d7f1296cb101daaa4d50fd033b78f135661549cb407bfdc0f4a OK
2022/08/01 05:50:33 GRPC CAS HEAD e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 OK
2022/08/01 05:50:33 GRPC CAS HEAD e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 OK
2022/08/01 05:50:33  GET 200       10.88.0.1 /ac/0f0e6da4d2d29061111a54de7c565611faacafa73e117daada0512ea3032370f
2022/08/01 05:50:33  GET 200       10.88.0.1 /cas/baa521657fa89d7f1296cb101daaa4d50fd033b78f135661549cb407bfdc0f4a
```

检查remote server的缓存（多了下面的缓存文件）：

```bash
 ⚡ root@backendcloud  ~/bazel-remote  ls dummy-remote-cache/*
dummy-remote-cache/ac.v2:
00  04  08  0c  10  14  18  1c  20  24  28  2c  30  34  38  3c  40  44  48  4c  50  54  58  5c  60  64  68  6c  70  74  78  7c  80  84  88  8c  90  94  98  9c  a0  a4  a8  ac  b0  b4  b8  bc  c0  c4  c8  cc  d0  d4  d8  dc  e0  e4  e8  ec  f0  f4  f8  fc
01  05  09  0d  11  15  19  1d  21  25  29  2d  31  35  39  3d  41  45  49  4d  51  55  59  5d  61  65  69  6d  71  75  79  7d  81  85  89  8d  91  95  99  9d  a1  a5  a9  ad  b1  b5  b9  bd  c1  c5  c9  cd  d1  d5  d9  dd  e1  e5  e9  ed  f1  f5  f9  fd
02  06  0a  0e  12  16  1a  1e  22  26  2a  2e  32  36  3a  3e  42  46  4a  4e  52  56  5a  5e  62  66  6a  6e  72  76  7a  7e  82  86  8a  8e  92  96  9a  9e  a2  a6  aa  ae  b2  b6  ba  be  c2  c6  ca  ce  d2  d6  da  de  e2  e6  ea  ee  f2  f6  fa  fe
03  07  0b  0f  13  17  1b  1f  23  27  2b  2f  33  37  3b  3f  43  47  4b  4f  53  57  5b  5f  63  67  6b  6f  73  77  7b  7f  83  87  8b  8f  93  97  9b  9f  a3  a7  ab  af  b3  b7  bb  bf  c3  c7  cb  cf  d3  d7  db  df  e3  e7  eb  ef  f3  f7  fb  ff

dummy-remote-cache/cas.v2:
00  04  08  0c  10  14  18  1c  20  24  28  2c  30  34  38  3c  40  44  48  4c  50  54  58  5c  60  64  68  6c  70  74  78  7c  80  84  88  8c  90  94  98  9c  a0  a4  a8  ac  b0  b4  b8  bc  c0  c4  c8  cc  d0  d4  d8  dc  e0  e4  e8  ec  f0  f4  f8  fc
01  05  09  0d  11  15  19  1d  21  25  29  2d  31  35  39  3d  41  45  49  4d  51  55  59  5d  61  65  69  6d  71  75  79  7d  81  85  89  8d  91  95  99  9d  a1  a5  a9  ad  b1  b5  b9  bd  c1  c5  c9  cd  d1  d5  d9  dd  e1  e5  e9  ed  f1  f5  f9  fd
02  06  0a  0e  12  16  1a  1e  22  26  2a  2e  32  36  3a  3e  42  46  4a  4e  52  56  5a  5e  62  66  6a  6e  72  76  7a  7e  82  86  8a  8e  92  96  9a  9e  a2  a6  aa  ae  b2  b6  ba  be  c2  c6  ca  ce  d2  d6  da  de  e2  e6  ea  ee  f2  f6  fa  fe
03  07  0b  0f  13  17  1b  1f  23  27  2b  2f  33  37  3b  3f  43  47  4b  4f  53  57  5b  5f  63  67  6b  6f  73  77  7b  7f  83  87  8b  8f  93  97  9b  9f  a3  a7  ab  af  b3  b7  bb  bf  c3  c7  cb  cf  d3  d7  db  df  e3  e7  eb  ef  f3  f7  fb  ff

dummy-remote-cache/raw.v2:
00  04  08  0c  10  14  18  1c  20  24  28  2c  30  34  38  3c  40  44  48  4c  50  54  58  5c  60  64  68  6c  70  74  78  7c  80  84  88  8c  90  94  98  9c  a0  a4  a8  ac  b0  b4  b8  bc  c0  c4  c8  cc  d0  d4  d8  dc  e0  e4  e8  ec  f0  f4  f8  fc
01  05  09  0d  11  15  19  1d  21  25  29  2d  31  35  39  3d  41  45  49  4d  51  55  59  5d  61  65  69  6d  71  75  79  7d  81  85  89  8d  91  95  99  9d  a1  a5  a9  ad  b1  b5  b9  bd  c1  c5  c9  cd  d1  d5  d9  dd  e1  e5  e9  ed  f1  f5  f9  fd
02  06  0a  0e  12  16  1a  1e  22  26  2a  2e  32  36  3a  3e  42  46  4a  4e  52  56  5a  5e  62  66  6a  6e  72  76  7a  7e  82  86  8a  8e  92  96  9a  9e  a2  a6  aa  ae  b2  b6  ba  be  c2  c6  ca  ce  d2  d6  da  de  e2  e6  ea  ee  f2  f6  fa  fe
03  07  0b  0f  13  17  1b  1f  23  27  2b  2f  33  37  3b  3f  43  47  4b  4f  53  57  5b  5f  63  67  6b  6f  73  77  7b  7f  83  87  8b  8f  93  97  9b  9f  a3  a7  ab  af  b3  b7  bb  bf  c3  c7  cb  cf  d3  d7  db  df  e3  e7  eb  ef  f3  f7  fb  ff
```