---
title: Bazel 构建 grpc server&client
readmore: true
date: 2022-07-27 19:01:25
categories: Devops
tags:
- Bazel
---

> clone grpc-go 官方仓库， 找到 https://github.com/grpc/grpc-go/tree/master/examples/helloworld

添加bazel所需文件

> 修改后的源码放在： https://github.com/backendcloud/example/tree/master/bazel-sample/bazel-grpc-go

运行gazelle生成BUILD文件：

```bash
 ⚡ root@localhost  ~/grpc-go/examples   master  tree helloworld 
helloworld
├── greeter_client
│   └── main.go
├── greeter_server
│   └── main.go
└── helloworld
    ├── helloworld_grpc.pb.go
    ├── helloworld.pb.go
    └── helloworld.proto
 ⚡ root@localhost  ~/grpc-go/examples   master ±  bazelisk run //:gazelle
DEBUG: /root/.cache/bazel/_bazel_root/f5202d34dc52917de631ee5215d8583b/external/bazel_gazelle/internal/go_repository.bzl:209:18: org_golang_x_tools: gazelle: /root/.cache/bazel/_bazel_root/f5202d34dc52917de631ee5215d8583b/external/org_golang_x_tools/cmd/fiximports/testdata/src/old.com/bad/bad.go: error reading go file: /root/.cache/bazel/_bazel_root/f5202d34dc52917de631ee5215d8583b/external/org_golang_x_tools/cmd/fiximports/testdata/src/old.com/bad/bad.go:2:43: expected 'package', found 'EOF'
gazelle: found packages complexnums (complexnums.go) and conversions (conversions.go) in /root/.cache/bazel/_bazel_root/f5202d34dc52917de631ee5215d8583b/external/org_golang_x_tools/go/internal/gccgoimporter/testdata
gazelle: found packages p (issue15920.go) and issue25301 (issue25301.go) in /root/.cache/bazel/_bazel_root/f5202d34dc52917de631ee5215d8583b/external/org_golang_x_tools/go/internal/gcimporter/testdata
gazelle: /root/.cache/bazel/_bazel_root/f5202d34dc52917de631ee5215d8583b/external/org_golang_x_tools/go/loader/testdata/badpkgdecl.go: error reading go file: /root/.cache/bazel/_bazel_root/f5202d34dc52917de631ee5215d8583b/external/org_golang_x_tools/go/loader/testdata/badpkgdecl.go:1:34: expected 'package', found 'EOF'
gazelle: finding module path for import domain.name/importdecl: go get: unrecognized import path "domain.name/importdecl": https fetch: Get "https://domain.name/importdecl?go-get=1": dial tcp: lookup domain.name on 192.168.190.2:53: no such host
gazelle: finding module path for import old.com/one: go get: unrecognized import path "old.com/one": https fetch: Get "http://www.old.com/one?go-get=1": redirected from secure URL https://old.com/one?go-get=1 to insecure URL http://www.old.com/one?go-get=1
gazelle: finding module path for import titanic.biz/bar: go get: unrecognized import path "titanic.biz/bar": reading https://titanic.biz/bar?go-get=1: 403 Forbidden
gazelle: finding module path for import titanic.biz/foo: go get: unrecognized import path "titanic.biz/foo": reading https://titanic.biz/foo?go-get=1: 403 Forbidden
gazelle: finding module path for import fruit.io/pear: go get: unrecognized import path "fruit.io/pear": https fetch: Get "https://fruit.io/pear?go-get=1": dial tcp: lookup fruit.io on 192.168.190.2:53: server misbehaving
gazelle: finding module path for import fruit.io/banana: go get: unrecognized import path "fruit.io/banana": https fetch: Get "https://fruit.io/banana?go-get=1": dial tcp: lookup fruit.io on 192.168.190.2:53: server misbehaving
gazelle: finding module path for import lib: go get: malformed module path "lib": missing dot in first path element
gazelle: finding module path for import nosuchpkg: go get: malformed module path "nosuchpkg": missing dot in first path element
gazelle: finding module path for import lib: go get: malformed module path "lib": missing dot in first path element
gazelle: finding module path for import nosuchpkg: go get: malformed module path "nosuchpkg": missing dot in first path element
gazelle: finding module path for import lib: go get: malformed module path "lib": missing dot in first path element
gazelle: finding module path for import lib: go get: malformed module path "lib": missing dot in first path element
gazelle: finding module path for import lib: go get: malformed module path "lib": missing dot in first path element
gazelle: finding module path for import lib: go get: malformed module path "lib": missing dot in first path element
gazelle: finding module path for import lib: go get: malformed module path "lib": missing dot in first path element
gazelle: finding module path for import lib: go get: malformed module path "lib": missing dot in first path element
gazelle: finding module path for import lib: go get: malformed module path "lib": missing dot in first path element
gazelle: finding module path for import referrers: go get: malformed module path "referrers": missing dot in first path element
gazelle: finding module path for import lib: go get: malformed module path "lib": missing dot in first path element
gazelle: finding module path for import lib: go get: malformed module path "lib": missing dot in first path element
gazelle: finding module path for import lib: go get: malformed module path "lib": missing dot in first path element
gazelle: finding module path for import a: go get: malformed module path "a": missing dot in first path element
gazelle: finding module path for import b: go get: malformed module path "b": missing dot in first path element
gazelle: finding module path for import b: go get: malformed module path "b": missing dot in first path element
gazelle: finding module path for import a: go get: malformed module path "a": missing dot in first path element
gazelle: finding module path for import a: go get: malformed module path "a": missing dot in first path element
gazelle: finding module path for import a: go get: malformed module path "a": missing dot in first path element
gazelle: finding module path for import b: go get: malformed module path "b": missing dot in first path element
INFO: Analyzed target //:gazelle (14 packages loaded, 76 targets configured).
INFO: Found 1 target...
Target //:gazelle up-to-date:
  bazel-bin/gazelle-runner.bash
  bazel-bin/gazelle
INFO: Elapsed time: 84.942s, Critical Path: 1.27s
INFO: 7 processes: 1 internal, 6 linux-sandbox.
INFO: Build completed successfully, 7 total actions
INFO: Build completed successfully, 7 total actions
 ⚡ root@localhost  ~/grpc-go/examples   master ±  tree helloworld
helloworld
├── greeter_client
│   ├── BUILD.bazel
│   └── main.go
├── greeter_server
│   ├── BUILD.bazel
│   └── main.go
└── helloworld
    ├── BUILD.bazel
    ├── helloworld_grpc.pb.go
    ├── helloworld.pb.go
    └── helloworld.proto
```

对比 bazel run 和 go run 效果完全一样。

```bash
 ⚡ root@localhost  ~/grpc-go/examples   master ±  bazelisk run //helloworld/greeter_server
INFO: Analyzed target //helloworld/greeter_server:greeter_server (1 packages loaded, 3 targets configured).
INFO: Found 1 target...
Target //helloworld/greeter_server:greeter_server up-to-date:
  bazel-bin/helloworld/greeter_server/greeter_server_/greeter_server
INFO: Elapsed time: 0.701s, Critical Path: 0.46s
INFO: 5 processes: 3 internal, 2 linux-sandbox.
INFO: Build completed successfully, 5 total actions
INFO: Build completed successfully, 5 total actions
2022/07/27 17:48:34 server listening at [::]:50051
2022/07/27 17:48:41 Received: world
```

```bash
 ⚡ root@localhost  ~/grpc-go/examples   master ±  bazelisk run //helloworld/greeter_client
INFO: Analyzed target //helloworld/greeter_client:greeter_client (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //helloworld/greeter_client:greeter_client up-to-date:
  bazel-bin/helloworld/greeter_client/greeter_client_/greeter_client
INFO: Elapsed time: 0.190s, Critical Path: 0.00s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
2022/07/27 17:48:41 Greeting: Hello world
```

```bash
 ⚡ root@localhost  ~/grpc-go/examples   master ±  go run helloworld/greeter_server/main.go 
2022/07/27 17:50:39 server listening at [::]:50051
2022/07/27 17:50:52 Received: world
```

```bash
 ⚡ root@localhost  ~/grpc-go/examples   master ±  go run helloworld/greeter_client/main.go 
2022/07/27 17:50:52 Greeting: Hello world
```