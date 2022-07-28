---
title: Starlark语言
readmore: true
date: 2022-07-01 18:53:07
categories: Devops
tags:
- Bazel
- Starlark
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

# Starlark

Tensorflow， Envoy， Kubernetes， KubeVirt 等等大型项目都是用 Bazel 构建的，要参与开发这些项目或者基于这些项目做开发，不能避开Bazel，且Bazel是当前开源Build System里最先进也最代表着未来方向的产品，非常有必要掌握。

Starlark是一门配置语言，设计之初是为了作为 Bazel 的配置语言，Starlark语法类似 Python，但不是Python，保持语言类似于 Python 可以减少学习曲线，使语义对用户更加明显。与 Python 显著不同的地方在于，独立的 Starlark 线程是并行执行的，因此 Starlark 工作负载在并行机器上可以很好地伸缩。

> https://github.com/bazelbuild/starlark

Starlark 语言的主要用途是描述构建: 如何编译 C++ 或 Scala 库，如何构建项目及其依赖项，如何运行测试。描述构建可能非常复杂，特别是当代码库混合了多种语言并针对多种平台时。

# Starlark & Go

在了解Starlark和Go的结合前，要先对go代码中嵌入其他语言，以及用Go实现的其他脚本语言的解释器做下了解。

## otto：A JavaScript interpreter in Go

```go
import (
	"fmt"
	"github.com/robertkrimen/otto"
)

func main() {

	vm := otto.New()

	// Run something in the VM
	vm.Run(`
    	abc = 2 + 2;
    	console.log("The value of abc is " + abc); // 4
	`)

	// Get a value out of the VM
	if value, err := vm.Get("abcdef"); err == nil {
		if value_int, err := value.ToInteger(); err == nil {
			fmt.Printf("%v, %v\n", value_int, err)
		}
	}

	// Set a number
	vm.Set("def", 11)
	vm.Run(`
    	console.log("The value of def is " + def);
    	// The value of def is 11
	`)

	// Set a string
	vm.Set("xyzzy", "Nothing happens.")
	vm.Run(`
    	console.log(xyzzy.length); // 16
	`)

	// Get the value of an expression
	value, _ := vm.Run("xyzzy.length")
	{
		// value is an int64 with a value of 16
		valueInt, _ := value.ToInteger()
		fmt.Printf("var valueInt is %v\n", valueInt)
	}

	// An error happens
	_, err := vm.Run("abcdefghijlmnopqrstuvwxyz.length")
	if err != nil {
		// err = ReferenceError: abcdefghijlmnopqrstuvwxyz is not defined
		// If there is an error, then value.IsUndefined() is true
		fmt.Println("Err happened!")
	}
}
```

> go代码中引用了otto，otto是javascript解释器的go的实现，翻译成大白话就是go编写的js的解释器。

上面的go代码嵌入了javascript代码，分别做了
1. 运行js
2. js获取变量
3. js赋值数字和字符串变量
4. 获取js表达式的返回值
5. js脚本发生错误，go捕获错误

运行结果如下：
```bash
The value of abc is 4
0, <nil>
The value of def is 11
16
var valueInt is 16
Err happened!
```

除了引用otto包在go中嵌入javascript代码，也可以直接用otto运行javascript代码
```bash
$ go get -v github.com/robertkrimen/otto/otto
$ otto example.js
```

除了在go代码中嵌入JavaScript，还可以嵌入以下的语言：
* anko - 用Go语言编写的可编写脚本的解释器。
* binder - 转到基于gopher-lua的 Lua绑定库。
* cel-go - 具有渐进式输入功能的快速，便携式，非图灵完整表达评估。
* expr - 可以评估表达式的引擎。
* gentee - 可嵌入的脚本编程语言。
* gisp - Go中的简单LISP。
* go-duktape - Go的Duktape JavaScript引擎绑定。
* go-lua - Lua 5.2 VM到纯Go的端口。
* go-php - Go的PHP绑定。
* go-python - 与CPython C-API的go绑定。
* golua - Lua C API的绑定。
* gopher-lua - 用Go编写的Lua 5.1 VM和编译器。
* gval - 用Go编写的高度可定制的表达语言。
* ngaro - 可嵌入的Ngaro VM实现，支持在Retro中编写脚本。
* otto - 用Go编写的JavaScript解释器。
* purl - Go中嵌入的Perl 5.18.2。
* tengo - 用于Go的字节码编译脚本语言。

## run starlark

> 有了上面的知识，可以开始了解Go写的Starlark语言的解释器了。  https://github.com/google/starlark-go

### 进入starlark交互界面
```bash
[root@localhost ~]# go get -u go.starlark.net/cmd/starlark
[root@localhost ~]# starlark
Welcome to Starlark (go.starlark.net)
>>>  
```

### 直接运行starlark脚本
```bash
[root@localhost ~]# cat a.star
coins = {
  'dime': 10,
  'nickel': 5,
  'penny': 1,
  'quarter': 25,
}
print('By name:\t' + ', '.join(sorted(coins.keys())))
print('By value:\t' + ', '.join(sorted(coins.keys(), key=coins.get)))

[root@localhost ~]# starlark a.star 
By name:        dime, nickel, penny, quarter
By value:       penny, nickel, dime, quarter
```

### 将starlark脚本嵌入Go代码
下面的内容是在Go代码中嵌入了starlark脚本，可以看到Go的main方法不仅执行了starlark脚本，还获取了starlark的函数并在Go中调用starlark函数和给starlark函数传参。
```bash
[root@localhost tt]# cat fibonacci.star 
def fibonacci(n):
    res = list(range(n))
    for i in res[2:]:
        res[i] = res[i-2] + res[i-1]
    return res
print(fibonacci(8))
[root@localhost tt]# starlark fibonacci.star 
[0, 1, 1, 2, 3, 5, 8, 13]
[root@localhost tt]# cat main.go 
package main

import (
        "fmt"
        "go.starlark.net/starlark"
)

func main() {
        // Execute Starlark program in a file.
        thread := &starlark.Thread{Name: "my thread"}
        globals, err := starlark.ExecFile(thread, "fibonacci.star", nil, nil)
        if err != nil {
                fmt.Println("Err happened!")
        }

        // Retrieve a module global.
        fibonacci := globals["fibonacci"]

        // Call Starlark function from Go.
        v, err := starlark.Call(thread, fibonacci, starlark.Tuple{starlark.MakeInt(10)}, nil)
        if err != nil {
                fmt.Println("Err happened!")
        }
        fmt.Printf("fibonacci(10) = %v\n", v) // fibonacci(10) = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
}
[root@localhost tt]# go run main.go 
[0, 1, 1, 2, 3, 5, 8, 13]
fibonacci(10) = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
[root@localhost tt]# 
```


# Starlark & Go & Bazel

上面的章节都是单单Starlark语言，比较容易入门，有了一点点python语法就可以很快上手Starlark语言和运行Starlark语言。一旦和Bazel结合起来，涉及的东西太多太多了，已远不是本篇篇幅能够覆盖的。

以云原生项目举例：
* Bazel 给 go_rules，用于Go项目的 Bazel构建。 https://github.com/bazelbuild/rules_go
* rules_docker, rules_k8s
* 为自己项目写的bazel rule和bazel库
* 等等

> 除了Go语言的rules_go，官方还提供了rules_rust rules_nodejs rules_python rules_scala rules_swift rules_kotlin rules_java rules_dotnet rules_cc等等