---
title: Starlark语言（workinprocess）
readmore: true
date: 2022-07-01 10:53:07
categories: Devops
tags:
- Bazel
- Starlark
---


Tensorflow， Envoy， Kubernetes， KubeVirt 等等大型项目都是用 Bazel 构建的，要参与开发这些项目或者基于这些项目做开发，不能避开Bazel，且Bazel是当前开源Build System里最先进也最代表着未来方向的产品，非常有必要掌握。

Starlark是一门配置语言，语法类似 Python。与 Python 不同，独立的 Starlark 线程是并行执行的，因此 Starlark 工作负载在并行机器上可以很好地伸缩。

在了解Starlark前，要先对go代码中嵌入其他语言，以及用go写的其他脚本语言的解释器做下了解。

# otto：A JavaScript interpreter in Go (golang)

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
* 运行js
* js获取变量
* js赋值数字和字符串变量
* 获取js表达式的返回值
* js脚本发生错误，go捕获错误

运行结果如下：
```bash
The value of abc is 4
0, <nil>
The value of def is 11
16
var valueInt is 16
Err happened!
```