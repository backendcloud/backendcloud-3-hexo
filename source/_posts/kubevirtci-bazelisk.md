---
title: 一步步学KubeVirt CI （8） - bazelisk
readmore: true
date: 2022-07-14 18:40:06
categories: 云原生
tags:
- KubeVirt CI
---


# bazelisk

## bazelisk 是什么

> bazelisk和bazel可以当成一个东西

Bazelisk Python版本已经废弃，最新的是用 Go 编写的，bazelisk 在 Bazel 外面又包装了一层。它会根据项目当前的工作目录自动选择一个配置的 Bazel 版本，从官方服务器下载它（如果需要），然后将所有命令行参数透传给真正的 Bazel 二进制文件。这样就可以像调用 Bazel 一样调用它。

## run

```bash
 ⚡ root@localhost  ~  wget https://github.com/bazelbuild/bazelisk/releases/download/v1.12.0/bazelisk-linux-amd64
--2022-07-14 10:42:40--  https://github.com/bazelbuild/bazelisk/releases/download/v1.12.0/bazelisk-linux-amd64
Resolving github.com (github.com)... 20.205.243.166
Connecting to github.com (github.com)|20.205.243.166|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://objects.githubusercontent.com/github-production-release-asset-2e65be/149661467/5e1ba444-d66e-4cea-8a79-891dd699d05a?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20220714%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220714T024243Z&X-Amz-Expires=300&X-Amz-Signature=0c172847d0c479fd1a2175af6f3c67d8053ae424696f33b519b282836b57e22f&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=149661467&response-content-disposition=attachment%3B%20filename%3Dbazelisk-linux-amd64&response-content-type=application%2Foctet-stream [following]
--2022-07-14 10:42:43--  https://objects.githubusercontent.com/github-production-release-asset-2e65be/149661467/5e1ba444-d66e-4cea-8a79-891dd699d05a?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20220714%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220714T024243Z&X-Amz-Expires=300&X-Amz-Signature=0c172847d0c479fd1a2175af6f3c67d8053ae424696f33b519b282836b57e22f&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=149661467&response-content-disposition=attachment%3B%20filename%3Dbazelisk-linux-amd64&response-content-type=application%2Foctet-stream
Resolving objects.githubusercontent.com (objects.githubusercontent.com)... 185.199.111.133, 185.199.108.133, 185.199.109.133, ...
Connecting to objects.githubusercontent.com (objects.githubusercontent.com)|185.199.111.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 5165056 (4.9M) [application/octet-stream]
Saving to: ‘bazelisk-linux-amd64’

bazelisk-linux-amd64             100%[=========================================================>]   4.93M  2.69MB/s    in 1.8s    

2022-07-14 10:42:46 (2.69 MB/s) - ‘bazelisk-linux-amd64’ saved [5165056/5165056]

 ⚡ root@localhost  ~  mv bazelisk-linux-amd64 bazelisk            
 ⚡ root@localhost  ~  chmod +x bazelisk 
 ⚡ root@localhost  ~  ./bazelisk 
2022/07/14 10:43:11 Downloading https://releases.bazel.build/5.2.0/release/bazel-5.2.0-linux-x86_64...
WARNING: Invoking Bazel in batch mode since it is not invoked from within a workspace (below a directory having a WORKSPACE file).
                                                           [bazel release 5.2.0]
Usage: bazel <command> <options> ...

Available commands:
  analyze-profile     Analyzes build profile data.
  aquery              Analyzes the given targets and queries the action graph.
  build               Builds the specified targets.
  canonicalize-flags  Canonicalizes a list of bazel options.
  clean               Removes output files and optionally stops the server.
  coverage            Generates code coverage report for specified test targets.
  cquery              Loads, analyzes, and queries the specified targets w/ configurations.
  dump                Dumps the internal state of the bazel server process.
  fetch               Fetches external repositories that are prerequisites to the targets.
  help                Prints help for commands, or the index.
  info                Displays runtime info about the bazel server.
  license             Prints the license of this software.
  mobile-install      Installs targets to mobile devices.
  print_action        Prints the command line args for compiling a file.
  query               Executes a dependency graph query.
  run                 Runs the specified target.
  shutdown            Stops the bazel server.
  sync                Syncs all repositories specified in the workspace file
  test                Builds and runs the specified test targets.
  version             Prints version information for bazel.

Getting more help:
  bazel help <command>
                   Prints help and options for <command>.
  bazel help startup_options
                   Options for the JVM hosting bazel.
  bazel help target-syntax
                   Explains the syntax for specifying targets.
  bazel help info-keys
                   Displays a list of keys used by the info command.
 ⚡ root@localhost  ~  ./bazelisk
WARNING: Invoking Bazel in batch mode since it is not invoked from within a workspace (below a directory having a WORKSPACE file).
                                                           [bazel release 5.2.0]
Usage: bazel <command> <options> ...

Available commands:
  analyze-profile     Analyzes build profile data.
  aquery              Analyzes the given targets and queries the action graph.
  build               Builds the specified targets.
  canonicalize-flags  Canonicalizes a list of bazel options.
  clean               Removes output files and optionally stops the server.
  coverage            Generates code coverage report for specified test targets.
  cquery              Loads, analyzes, and queries the specified targets w/ configurations.
  dump                Dumps the internal state of the bazel server process.
  fetch               Fetches external repositories that are prerequisites to the targets.
  help                Prints help for commands, or the index.
  info                Displays runtime info about the bazel server.
  license             Prints the license of this software.
  mobile-install      Installs targets to mobile devices.
  print_action        Prints the command line args for compiling a file.
  query               Executes a dependency graph query.
  run                 Runs the specified target.
  shutdown            Stops the bazel server.
  sync                Syncs all repositories specified in the workspace file
  test                Builds and runs the specified test targets.
  version             Prints version information for bazel.

Getting more help:
  bazel help <command>
                   Prints help and options for <command>.
  bazel help startup_options
                   Options for the JVM hosting bazel.
  bazel help target-syntax
                   Explains the syntax for specifying targets.
  bazel help info-keys
                   Displays a list of keys used by the info command.
 ⚡ root@localhost  ~  
```

> 第一次执行`bazelisk`会下载配置文件中对应版本的bazel，没有就是最新版本。之后再执行`bazelisk`效果和速度等同于`bazel`。