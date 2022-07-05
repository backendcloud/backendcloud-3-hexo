---
title: 一步步学写Bazel lib&rules （2） - 写一个简单的 go rules
readmore: true
date: 2022-07-04 18:52:19
categories: Devops
tags:
- Bazel
---


> https://github.com/jayconrod/rules_go_simple/tree/v1  这是一个为一个新语言写 Bazel rules 的 最小样例。

```bash
.
├── BUILD.bazel
├── def.bzl
├── deps.bzl
├── internal
│   ├── actions.bzl
│   ├── BUILD.bazel
│   └── rules.bzl
├── LICENSE.txt
├── README.md
├── tests
│   ├── BUILD.bazel
│   ├── hello.go
│   ├── hello_test.sh
│   └── message.go
└── WORKSPACE
```

WORKSPACE
```python
workspace(name = "rules_go_simple")

load("//:deps.bzl", "go_rules_dependencies")

go_rules_dependencies()
```

上面的WORKSPACE调用下面的deps.bzl，在deps.bzl用内置的方法http_archive引入bazel基础库Skylib依赖

deps.bzl
```python
"""Macro for declaring repository dependencies."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def go_rules_dependencies():
    """Declares external repositories that rules_go_simple depends on.
    This function should be loaded and called from WORKSPACE of any project
    that uses rules_go_simple.
    """

    # bazel_skylib is a set of libraries that are useful for writing
    # Bazel rules. We use it to handle quoting arguments in shell commands.
    _maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
        ],
        sha256 = "97e70364e9249702246c0e9444bccdc4b847bed1eb03c5a3ece4f83dfe6abc44",
    )

def _maybe(rule, name, **kwargs):
    """Declares an external repository if it hasn't been declared already."""
    if name not in native.existing_rules():
        rule(name = name, **kwargs)
```

tests/BUILD.bazel
```python
load("//:def.bzl", "go_binary")

sh_test(
    name = "hello_test",
    srcs = ["hello_test.sh"],
    args = ["$(location :hello)"],
    data = [":hello"],
)

go_binary(
    name = "hello",
    srcs = [
        "hello.go",
        "message.go",
    ],
)
```

BUILD.bazel调用了项目根目录下的def.bzl，def.bzl又调用了internal目录的rules.bzl的go_binary方法。

def.bzl
```python
load("//internal:rules.bzl", _go_binary = "go_binary")

go_binary = _go_binary
```

internal/rules.bzl
```python
load(":actions.bzl", "go_compile", "go_link")

def _go_binary_impl(ctx):
    # Declare an output file for the main package and compile it from srcs. All
    # our output files will start with a prefix to avoid conflicting with
    # other rules.
    prefix = ctx.label.name + "%/"
    main_archive = ctx.actions.declare_file(prefix + "main.a")
    go_compile(
        ctx,
        srcs = ctx.files.srcs,
        out = main_archive,
    )

    # Declare an output file for the executable and link it. Note that output
    # files may not have the same name as the rule, so we still need to use the
    # prefix here.
    executable = ctx.actions.declare_file(prefix + ctx.label.name)
    go_link(
        ctx,
        main = main_archive,
        out = executable,
    )

    # Return the DefaultInfo provider. This tells Bazel what files should be
    # built when someone asks to build a go_binary rules. It also says which
    # one is executable (in this case, there's only one).
    return [DefaultInfo(
        files = depset([executable]),
        executable = executable,
    )]

# Declare the go_binary rule. This statement is evaluated during the loading
# phase when this file is loaded. The function body above is evaluated only
# during the analysis phase.
go_binary = rule(
    _go_binary_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".go"],
            doc = "Source files to compile for the main package of this binary",
        ),
    },
    doc = "Builds an executable program from Go source code",
    executable = True,
)
```

上面的代码构造ctx上下文内容，调用了internal/actions.bzl的go_compile（go tool compile）和go_link（go tool link）方法

internal/actions.bzl
```python
load("@bazel_skylib//lib:shell.bzl", "shell")

def go_compile(ctx, srcs, out):
    """Compiles a single Go package from sources.
    Args:
        ctx: analysis context.
        srcs: list of source Files to be compiled.
        out: output .a file. Should have the importpath as a suffix,
            for example, library "example.com/foo" should have the path
            "somedir/example.com/foo.a".
    """
    cmd = "go tool compile -o {out} -- {srcs}".format(
        out = shell.quote(out.path),
        srcs = " ".join([shell.quote(src.path) for src in srcs]),
    )
    ctx.actions.run_shell(
        outputs = [out],
        inputs = srcs,
        command = cmd,
        mnemonic = "GoCompile",
        use_default_shell_env = True,
    )

def go_link(ctx, out, main):
    """Links a Go executable.
    Args:
        ctx: analysis context.
        out: output executable file.
        main: archive file for the main package.
    """
    cmd = "go tool link -o {out} -- {main}".format(
        out = shell.quote(out.path),
        main = shell.quote(main.path),
    )
    ctx.actions.run_shell(
        outputs = [out],
        inputs = [main],
        command = cmd,
        mnemonic = "GoLink",
        use_default_shell_env = True,
    )
```

运行 bazel build/run/test
```bash
[root@localhost rules_go_simple]# bazel build //tests:hello
INFO: Analyzed target //tests:hello (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //tests:hello up-to-date:
  bazel-bin/tests/hello%/hello
INFO: Elapsed time: 0.121s, Critical Path: 0.00s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
[root@localhost rules_go_simple]# bazel run //tests:hello
INFO: Analyzed target //tests:hello (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //tests:hello up-to-date:
  bazel-bin/tests/hello%/hello
INFO: Elapsed time: 0.118s, Critical Path: 0.00s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
Hello, world!
[root@localhost rules_go_simple]# bazel test //tests:hello_test
INFO: Analyzed target //tests:hello_test (0 packages loaded, 0 targets configured).
INFO: Found 1 test target...
Target //tests:hello_test up-to-date:
  bazel-bin/tests/hello_test
INFO: Elapsed time: 0.179s, Critical Path: 0.05s
INFO: 2 processes: 2 linux-sandbox.
INFO: Build completed successfully, 2 total actions
//tests:hello_test                                                       PASSED in 0.0s

Executed 1 out of 1 test: 1 test passes.
INFO: Build completed successfully, 2 total actions
```