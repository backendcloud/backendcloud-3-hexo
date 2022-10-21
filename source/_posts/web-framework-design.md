---
title: workinprocess-Web框架的设计方案和Go源码实现
readmore: true
date: 2022-10-21 19:28:18
categories: 云原生
tags:
- Golang
---

# 为何要用web框架

> 最有名的web框架莫过于Java的SpringBoot，Go的Gin。本篇以Go语言为例。其他语言或其他主流的web框架基于的设计方案基本都遵循这个。

其实不用web框架也可以进行web后端开发，比如下面的最简单的例子：

```go
package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
    // http.HandleFunc 实现了路由和Handler的映射
	http.HandleFunc("/", indexHandler)
	http.HandleFunc("/hello", helloHandler)
    // http.ListenAndServe 启动一个http服务，第一个参数是ip和端口号，第二个参数是http包里的Handler接口
	log.Fatal(http.ListenAndServe(":9999", nil))
}

// handler echoes r.URL.Path
func indexHandler(w http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(w, "URL.Path = %q\n", req.URL.Path)
}

// handler echoes r.URL.Header
func helloHandler(w http.ResponseWriter, req *http.Request) {
	for k, v := range req.Header {
		fmt.Fprintf(w, "Header[%q] = %q\n", k, v)
	}
}
```

测试得到下面的结果：
```bash
$ curl http://localhost:9999/
URL.Path = "/"
$ curl http://localhost:9999/hello
Header["Accept"] = ["*/*"]
Header["User-Agent"] = ["curl/7.54.0"]
```

那么为何要用web框架，或者说现在的主流web后端开发都要选定一个框架，然后再开发，就是为了提高效率，共通的业务以外的逻辑都由框架实现了，有了框架，开发只需要专注业务逻辑。

那么设计web框架的目的就很明确了，解决非业务的共通需求。那么有哪些此类的需求呢？就是框架要解决的问题。
1. 注册路由和路由发现
2. 快速路由算法（是框架理解上最复杂的地方，参考之前的两篇文章 {% post_link trie-route %} {% post_link radix-route %}，本篇略过。路由的性能非常重要，是框架间竞争的主要指标）
3. 上下文Context
4. 分组路由
5. 中间件（比如日志中间件，校验中间件）
6. 模板Template（现在开发都是前后端分离，模板很少实际开发中使用，所以这部分本篇略过）
7. 错误恢复

所以一个好的web框架的核心在于：决定性能的路由算法。社区活跃度。特色功能。易用度。等等。

掌握的这些问题的解决方案，就可以自己设计web框架，或者在现有框架的基础上定制框架。下面逐一介绍：


# 注册路由和路由发现

在拥有框架之前，是通过http.HandleFunc关联URL和处理函数handler，再调用http.ListenAndServe(":9999", nil)，http.ListenAndServe第二个参数留空。

第二个参数是一个Handler接口，需要实现方法 ServeHTTP，第二个参数也是基于net/http标准库实现Web框架的入口。

http.Handler接口的源码：

```go
package http

type Handler interface {
    ServeHTTP(w ResponseWriter, r *Request)
}

func ListenAndServe(address string, h Handler) error
```

除了调用http.HandleFunc，也可以通过下面的方式实现相同的目的。通过下面的Engine结构体来实现接口方法ServeHTTP，再将Engine传入http.ListenAndServe的第二个参数。

```go
// Engine is the uni handler for all requests
type Engine struct{}

func (engine *Engine) ServeHTTP(w http.ResponseWriter, req *http.Request) {
	switch req.URL.Path {
	case "/":
		fmt.Fprintf(w, "URL.Path = %q\n", req.URL.Path)
	case "/hello":
		for k, v := range req.Header {
			fmt.Fprintf(w, "Header[%q] = %q\n", k, v)
		}
	default:
		fmt.Fprintf(w, "404 NOT FOUND: %s\n", req.URL)
	}
}

func main() {
	engine := new(Engine)
	log.Fatal(http.ListenAndServe(":9999", engine))
}
```

进一步代码结构拆分，并在Engine结构体中创建一个map用于保存路由和Handler的映射。之后的调用就出现了我们用主流web框架的雏形调用样式。

```go
func main() {
	r := gee.New()
	r.GET("/", func(w http.ResponseWriter, req *http.Request) {
		fmt.Fprintf(w, "URL.Path = %q\n", req.URL.Path)
	})

	r.GET("/hello", func(w http.ResponseWriter, req *http.Request) {
		for k, v := range req.Header {
			fmt.Fprintf(w, "Header[%q] = %q\n", k, v)
		}
	})

	r.Run(":9999")
}
```

```go
package gee

import (
	"fmt"
	"net/http"
)

// HandlerFunc defines the request handler used by gee
type HandlerFunc func(http.ResponseWriter, *http.Request)

// Engine implement the interface of ServeHTTP
type Engine struct {
	router map[string]HandlerFunc
}

// New is the constructor of gee.Engine
func New() *Engine {
	return &Engine{router: make(map[string]HandlerFunc)}
}

func (engine *Engine) addRoute(method string, pattern string, handler HandlerFunc) {
	key := method + "-" + pattern
	engine.router[key] = handler
}

// GET defines the method to add GET request
func (engine *Engine) GET(pattern string, handler HandlerFunc) {
	engine.addRoute("GET", pattern, handler)
}

// POST defines the method to add POST request
func (engine *Engine) POST(pattern string, handler HandlerFunc) {
	engine.addRoute("POST", pattern, handler)
}

// Run defines the method to start a http server
func (engine *Engine) Run(addr string) (err error) {
	return http.ListenAndServe(addr, engine)
}

func (engine *Engine) ServeHTTP(w http.ResponseWriter, req *http.Request) {
	key := req.Method + "-" + req.URL.Path
	if handler, ok := engine.router[key]; ok {
		handler(w, req)
	} else {
		fmt.Fprintf(w, "404 NOT FOUND: %s\n", req.URL)
	}
}
```
