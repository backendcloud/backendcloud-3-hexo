---
title: workinprocess-http基数树路由算法和Go源码分析
readmore: false
date: 2022-10-20 18:36:54
categories: 云原生
tags:
- Radix树
---


# Radix树简介

Radix Tree名为压缩前缀树，又名为基数树。听名字，就知道该算法是之前介绍的前缀树的压缩版，也就是具有共同前缀的节点拥有相同的父节点。和前缀树Trie Tree极为相似，一个最大的区别点在于它不是按照每个字符长度做节点拆分，而是可以以1个或多个字符叠加作为一个分支。这就避免了长字符key会分出深度很深的节点。Radix Tree的结构构造如下图所示：

> Trie Tree 参考{% post_link trie-route %}

![](/images/radix-route/2022-10-20-13-39-09.png)

针对Radix Tree的构造规则，它的节点插入和删除行为相比较于Trie Tree来说，略有不同：
* 对于节点插入而言，当有新的key进来，需要拆分原有公共前缀分支。
* 对于节点删除而言，当删除一个现有key后，发现其父节点只有另外一个子节点key，则此子节点可以和父节点合并为一个新的节点，以此减少树的比较深度。

![](/images/radix-route/2022-10-20-13-40-06.png)


# web框架中的快速路由 基数树

```bash
Priority   Path             Handle
9          \                *<1>
3          ├s               nil
2          |├earch\         *<2>
1          |└upport\        *<3>
2          ├blog\           *<4>
1          |    └:post      nil
1          |         └\     *<5>
2          ├about-us\       *<6>
1          |        └team\  *<7>
1          └contact\        *<8>

// 这个图相当于注册了下面这几个路由
GET("/search/", func1)
GET("/support/", func2)
GET("/blog/:post/", func3)
GET("/about-us/", func4)
GET("/about-us/team/", func5)
GET("/contact/", func6)
```

通过上面的示例可以看出：
* *<数字> 代表一个 handler 函数的内存地址（指针）
* search 和 support 拥有共同的父节点 s ，并且 s 是没有对应的 handle 的， 只有叶子节点（就是最后一个节点，下面没有子节点的节点）才会注册 handler 。
* 从根开始，一直到叶子节点，才是路由的实际路径。
* 路由搜索的顺序是从上向下，从左到右的顺序，为了快速找到尽可能多的路由，包含子节点越多的节点，优先级越高。


# golang实现

> 本次分析的源码放在 https://github.com/julienschmidt/httprouter


route,node结构体：

```go
type Router struct {
    trees map[string]*node
    ...
}
```

因为github.com/julienschmidt/httprouter是生产可用的路由模块，加入了很多细节的考虑，比如：
* 是否处理当访问路径最后带的 /
* 是否自动修正路径， 如果路由没有找到时，Router 会自动尝试修复
* 自定义 OPTIONS 路由
* 自定义http NotFound handler函数
* 自定义错误恢复handler函数
* 定义静态文件目录
* 等等

本篇主要分析路由基数树算法相关的代码，非相关的其他代码略过。

路由算法主要包括路由注册和路由发现两个部分：

## 路由注册

路由注册的过程包括两部分：
1. 检查路由根节点（以request method GET/POST/DELETE/PUT 区分几个路由根结点）是否存在，不存在则新建。并注册根节点信息。
2. 递归注册根节点的所有子节点信息。


## 路由发现

路由注册的过程包括两部分：
1. 一层层查找到最底层匹配的节点
2. 获取动态路由（冒号，星号）匹配的参数
