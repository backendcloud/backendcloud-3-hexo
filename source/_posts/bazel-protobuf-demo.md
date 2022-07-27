---
title: Bazel 构建 protobuf
readmore: true
date: 2022-07-27 13:28:37
categories: Devops
tags:
- Bazel
---

为了将proto文件转成编程语言代码，需要安装编译工具protoc。本篇验证使用 Bazel 构建 是否能和手动执行 protoc 和插件 的编译一样的结果。

> 本篇的代码放在： https://github.com/backendcloud/example/tree/master/bazel-sample/protobuf

三个proto源码：
```bash
 ⚡ root@localhost  ~/bazel-sample/protobuf   main ±  more proto/*.proto
::::::::::::::
proto/address.proto
::::::::::::::
syntax = "proto3";

option go_package = "github.com/jun06t/bazel-sample/protobuf/proto;user";

package user;

import "proto/zipcode.proto";

message Address {
  string  city     = 1;
  ZipCode zip_code = 2;
}
::::::::::::::
proto/user.proto
::::::::::::::
syntax = "proto3";

option go_package = "github.com/jun06t/bazel-sample/protobuf/proto;user";

package user;

import "proto/address.proto";
import "google/protobuf/any.proto";

message User {
  string              id      = 1;
  string              name    = 2;
  Address             address = 3;
  google.protobuf.Any tags    = 4;
}
::::::::::::::
proto/zipcode.proto
::::::::::::::
syntax = "proto3";

option go_package = "github.com/jun06t/bazel-sample/protobuf/proto;user";

package user;

message ZipCode {
  string code = 1;
}
```

# Bazel 构建

执行gazelle：

```bash
⚡ root@localhost  ~/bazel-sample/protobuf   main ±  bazelisk run //:gazelle
Starting local Bazel server and connecting to it...
INFO: SHA256 (https://golang.org/dl/?mode=json&include=all) = 5d539711d20290d769b21f137348eea164d5fd408cfc6483c9937d9e1a2a6d98
INFO: Analyzed target //:gazelle (63 packages loaded, 7894 targets configured).
INFO: Found 1 target...
Target //:gazelle up-to-date:
  bazel-bin/gazelle-runner.bash
  bazel-bin/gazelle
INFO: Elapsed time: 25.913s, Critical Path: 0.15s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
```

执行完 bazelisk run //:gazelle 命令后会自动生成下面的BUILD文件：

```bash
 ⚡ root@localhost  ~/bazel-sample/protobuf   main ±  cat proto/BUILD.bazel 
load("@rules_proto//proto:defs.bzl", "proto_library")
load("@io_bazel_rules_go//go:def.bzl", "go_library")
load("@io_bazel_rules_go//proto:def.bzl", "go_proto_library")

proto_library(
    name = "user_proto",
    srcs = [
        "address.proto",
        "user.proto",
        "zipcode.proto",
    ],
    visibility = ["//visibility:public"],
    deps = ["@com_google_protobuf//:any_proto"],
)

go_proto_library(
    name = "user_go_proto",
    importpath = "github.com/jun06t/bazel-sample/protobuf/proto",
    proto = ":user_proto",
    visibility = ["//visibility:public"],
)

go_library(
    name = "proto",
    embed = [":user_go_proto"],
    importpath = "github.com/jun06t/bazel-sample/protobuf/proto",
    visibility = ["//visibility:public"],
)
```

执行 bazelisk build //proto 命令：
```bash
 ⚡ root@localhost  ~/bazel-sample/protobuf   main ±  bazelisk build //proto                                                                                                    
Starting local Bazel server and connecting to it...
INFO: SHA256 (https://golang.org/dl/?mode=json&include=all) = 5d539711d20290d769b21f137348eea164d5fd408cfc6483c9937d9e1a2a6d98
INFO: Analyzed target //proto:proto (78 packages loaded, 8783 targets configured).
INFO: Found 1 target...
INFO: From Compiling src/google/protobuf/message_lite.cc:
In file included from /usr/include/string.h:519,
                 from external/com_google_protobuf/src/google/protobuf/stubs/port.h:39,
                 from external/com_google_protobuf/src/google/protobuf/stubs/macros.h:34,
                 from external/com_google_protobuf/src/google/protobuf/stubs/common.h:46,
                 from external/com_google_protobuf/src/google/protobuf/message_lite.h:45,
                 from external/com_google_protobuf/src/google/protobuf/message_lite.cc:36:
In function 'void* memcpy(void*, const void*, size_t)',
    inlined from 'google::protobuf::uint8* google::protobuf::io::EpsCopyOutputStream::WriteRaw(const void*, int, google::protobuf::uint8*)' at external/com_google_protobuf/src/google/protobuf/io/coded_stream.h:699:16,
    inlined from 'virtual google::protobuf::uint8* google::protobuf::internal::ImplicitWeakMessage::_InternalSerialize(google::protobuf::uint8*, google::protobuf::io::EpsCopyOutputStream*) const' at external/com_google_protobuf/src/google/protobuf/implicit_weak_message.h:85:28,
    inlined from 'bool google::protobuf::MessageLite::SerializePartialToZeroCopyStream(google::protobuf::io::ZeroCopyOutputStream*) const' at external/com_google_protobuf/src/google/protobuf/message_lite.cc:419:30:
/usr/include/bits/string_fortified.h:29:33: warning: 'void* __builtin___memcpy_chk(void*, const void*, long unsigned int, long unsigned int)' specified size between 18446744071562067968 and 18446744073709551615 exceeds maximum object size 9223372036854775807 [-Wstringop-overflow=]
   29 |   return __builtin___memcpy_chk (__dest, __src, __len,
      |          ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~
   30 |                                  __glibc_objsize0 (__dest));
      |                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~
Target //proto:proto up-to-date:
  bazel-bin/proto/proto.a
INFO: Elapsed time: 134.893s, Critical Path: 9.33s
INFO: 267 processes: 7 internal, 260 linux-sandbox.
INFO: Build completed successfully, 267 total actions
```

bazel构建完成后生成下面的3个 .pb.go 文件：
```bash
 ⚡ root@localhost  ~/bazel-sample/protobuf   main ±  tree bazel-bin/proto 
bazel-bin/proto
├── proto.a
├── proto.x
├── user_go_proto_
│   └── github.com
│       └── jun06t
│           └── bazel-sample
│               └── protobuf
│                   └── proto
│                       ├── address.pb.go
│                       ├── user.pb.go
│                       └── zipcode.pb.go
└── user_proto-descriptor-set.proto.bin

6 directories, 6 files
```




# 手动执行 protoc 编译

```bash
 ⚡ root@localhost  ~/bazel-sample/protobuf   main  protoc --go_out=. --go_opt=paths=source_relative     --go-grpc_out=. --go-grpc_opt=paths=source_relative     proto/*.proto 
google/protobuf/any.proto: File not found.
proto/user.proto:8:1: Import "google/protobuf/any.proto" was not found or had errors.
proto/user.proto:14:3: "google.protobuf.Any" is not defined.
```

报错，因为安装protoc只装了可执行文件protoc，少装了文件：

```bash
wget https://github.com/protocolbuffers/protobuf/releases/download/vxx.xx.xx/protoc-xx.xx.xx-linux-x86_64.zip
unzip protoc-xx.xx.xx-linux-x86_64.zip
cp bin/protoc /usr/bin/
cp -r include/google /usr/include/
注：最后一行是为了将proto的一些库复制到系统，例如google/protobuf/any.proto，如果不复制，编译如果用了里面的库例如Any，会提示：protobuf google.protobuf.Any not found 。
```

补复制了下 include/ 文件夹，编译后，生成了下面的3个 .pb.go 文件：

```bash
 ⚡ root@localhost  ~/bazel-sample/protobuf   main ±  ls proto/*      
proto/address.proto  proto/BUILD.bazel  proto/user.proto  proto/zipcode.proto
 ⚡ root@localhost  ~/bazel-sample/protobuf   main ±  protoc --go_out=. --go_opt=paths=source_relative     --go-grpc_out=. --go-grpc_opt=paths=source_relative     proto/*.proto
 ⚡ root@localhost  ~/bazel-sample/protobuf   main ±  ls proto/*                                                          
proto/address.pb.go  proto/address.proto  proto/BUILD.bazel  proto/user.pb.go  proto/user.proto  proto/zipcode.pb.go  proto/zipcode.proto
```

# 对比生成的3个 .pb.go 文件

```bash
 ⚡ root@localhost  ~/bazel-sample/protobuf   main ±  diff bazel-bin/proto/user_go_proto_/github.com/jun06t/bazel-sample/protobuf/proto/address.pb.go proto/address.pb.go 
3,4c3,4
< //    protoc-gen-go v1.27.1
< //    protoc        v3.14.0
---
> //    protoc-gen-go v1.28.0
> //    protoc        v3.21.4
 ✘ ⚡ root@localhost  ~/bazel-sample/protobuf   main ±  diff bazel-bin/proto/user_go_proto_/github.com/jun06t/bazel-sample/protobuf/proto/zipcode.pb.go proto/zipcode.pb.go 
3,4c3,4
< //    protoc-gen-go v1.27.1
< //    protoc        v3.14.0
---
> //    protoc-gen-go v1.28.0
> //    protoc        v3.21.4
 ✘ ⚡ root@localhost  ~/bazel-sample/protobuf   main ±  diff bazel-bin/proto/user_go_proto_/github.com/jun06t/bazel-sample/protobuf/proto/user.pb.go proto/user.pb.go      
3,4c3,4
< //    protoc-gen-go v1.27.1
< //    protoc        v3.14.0
---
> //    protoc-gen-go v1.28.0
> //    protoc        v3.21.4
```

发现两种方式编译结果除了Bazel构建选用的两个工具的版本和手动编译的不一致，其他内容完全一致。手动的版本较新是因为是去Github手动下载的最新发布的版本。