title: 后端云网站全部url http -> https
date: 2017-05-06 11:03:57
readmore: false
categories: 网站里程碑
tags:
- https
---

记录下：
2017.05.06 “后端云”网站弃用http，开始全部采用更加安全的https链接。

除了上面的 url http -> https，还改了几个小细节：

# 浏览器http的访问请求会被自动替换成https的

# `http(s)://backendcloud.cn/*` 的url会被自动替换成 `https://www.backendcloud.cn/*`

# 