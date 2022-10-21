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

只要对上面的代码做一些代码结构拆分，并在Engine结构体中创建一个map用于保存路由和Handler的映射。之后的调用就出现了我们用主流web框架的雏形调用样式。

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

# 上下文Context

为何要有上下文：
1. 对Web服务来说，无非是根据请求*http.Request，构造响应http.ResponseWriter。要构造一个完整的响应，需要考虑消息头(Header)和消息体(Body)，而 Header 包含了状态码(StatusCode)，消息类型(ContentType)等几乎每次请求都需要设置的信息。因此，如果不进行有效的封装，那么框架的用户将需要写大量重复，繁杂的代码，而且容易出错。针对常用场景，能够高效地构造出 HTTP 响应是一个好的框架必须考虑的点。现在前后端分离的web开发，返回的结构体往往是json数据类型，所以要对返回体作json数据格式的封装。
2. 提供和当前请求强相关的信息的存放位置。比如：解析动态路由/hello/:name，参数:name的值。中间件。Context 就像一次会话的百宝箱，可以找到任何东西。

代码实现上：

将router map[string]HandlerFunc的HandlerFunc，从`type HandlerFunc func(http.ResponseWriter, *http.Request)`切换成`type HandlerFunc func(*Context)`  

对框架的调用也从`r.GET("/hello", func(w http.ResponseWriter, req *http.Request)`变成`r.GET("/hello", func(c *gee.Context)`。

创建Context结构体，保存上下文(Context目前只包含了http.ResponseWriter和*http.Request，另外提供了对 Method 和 Path 这两个常用属性的直接访问。)：

```go
type Context struct {
	// origin objects
	Writer http.ResponseWriter
	Req    *http.Request
	// request info
	Path   string
	Method string
	// response info
	StatusCode int
}
```

提供了访问Query和PostForm参数的方法:
```go
func (c *Context) PostForm(key string) string {
	return c.Req.FormValue(key)
}

func (c *Context) Query(key string) string {
	return c.Req.URL.Query().Get(key)
}
```

提供修改返回的状态码和头的方法：
```go
func (c *Context) Status(code int) {
	c.StatusCode = code
	c.Writer.WriteHeader(code)
}

func (c *Context) SetHeader(key string, value string) {
	c.Writer.Header().Set(key, value)
}
```

提供了快速构造String/Data/JSON/HTML响应的方法：
```go
func (c *Context) String(code int, format string, values ...interface{}) {
	c.SetHeader("Content-Type", "text/plain")
	c.Status(code)
	c.Writer.Write([]byte(fmt.Sprintf(format, values...)))
}

func (c *Context) JSON(code int, obj interface{}) {
	c.SetHeader("Content-Type", "application/json")
	c.Status(code)
	encoder := json.NewEncoder(c.Writer)
	if err := encoder.Encode(obj); err != nil {
		http.Error(c.Writer, err.Error(), 500)
	}
}

func (c *Context) Data(code int, data []byte) {
	c.Status(code)
	c.Writer.Write(data)
}

func (c *Context) HTML(code int, html string) {
	c.SetHeader("Content-Type", "text/html")
	c.Status(code)
	c.Writer.Write([]byte(html))
}
```

# 分组路由

web框架一般都提供分组路由和多层分组嵌套功能。分组路由的好处有：
* 提取共通的部分作为分组，可以减少框架使用者URL的输入长度。
* 真实的业务场景中，往往某一组路由需要相似的处理。可以按分组配置中间件。

分组路由和嵌套分组的代码实现：
```go
// Engine implement the interface of ServeHTTP
type (
	RouterGroup struct {
		prefix      string
		middlewares []HandlerFunc // support middleware
		parent      *RouterGroup  // support nesting
		engine      *Engine       // all groups share a Engine instance
	}

	Engine struct {
		*RouterGroup
		router *router
		groups []*RouterGroup // store all groups
	}
)

// New is the constructor of gee.Engine
func New() *Engine {
	engine := &Engine{router: newRouter()}
	engine.RouterGroup = &RouterGroup{engine: engine}
	engine.groups = []*RouterGroup{engine.RouterGroup}
	return engine
}

// Group is defined to create a new RouterGroup
// remember all groups share the same Engine instance
func (group *RouterGroup) Group(prefix string) *RouterGroup {
	engine := group.engine
	newGroup := &RouterGroup{
		prefix: group.prefix + prefix,
		parent: group,
		engine: engine,
	}
	engine.groups = append(engine.groups, newGroup)
	return newGroup
}
```

> 再addRoute, GET, POST原来放在Engine结构体的方法，现在放到RouterGroup结构体上

框架调用方式现在变为：
```go
func main() {
	r := gee.New()
	r.GET("/index", func(c *gee.Context) {
		c.HTML(http.StatusOK, "<h1>Index Page</h1>")
	})
	v1 := r.Group("/v1")
	{
		v1.GET("/", func(c *gee.Context) {
			c.HTML(http.StatusOK, "<h1>Hello Gee</h1>")
		})

		v1.GET("/hello", func(c *gee.Context) {
			// expect /hello?name=geektutu
			c.String(http.StatusOK, "hello %s, you're at %s\n", c.Query("name"), c.Path)
		})
	}
	v2 := r.Group("/v2")
	{
		v2.GET("/hello/:name", func(c *gee.Context) {
			// expect /hello/geektutu
			c.String(http.StatusOK, "hello %s, you're at %s\n", c.Param("name"), c.Path)
		})
	}
	r.Run(":9999")
}
```

# 中间件

中间件(middlewares)，简单说，就是非业务的技术类组件。一般中间件加在某一个路由分组上或者总的分组上，即应用在代码的RouterGroup上，中间件可以给框架提供无限的扩展能力。例如/admin的分组，可以应用鉴权中间件；/分组应用日志中间件。

中间件的设计思路：

没有中间件的框架设计是这样的，当接收到请求后，匹配路由，该请求的所有信息都保存在Context中。中间件也不例外，接收到请求后，应查找所有应作用于该路由的中间件，保存在Context中，依次进行调用。为什么依次调用后，还需要在Context中保存呢？因为在设计中，中间件不仅作用在处理流程前，也可以作用在处理流程后，即在用户业务的 Handler 处理完毕后，还可以执行剩下的操作。

比如：
```go
//中间件A
func A(c *Context) {
    part1
    c.Next()
    part2
}
//中间件B
func B(c *Context) {
    part3
    c.Next()
    part4
}
```

执行的顺序是：part1 -> part3 -> Handler -> part 4 -> part2

具体的中间件框架的代码设计如下：