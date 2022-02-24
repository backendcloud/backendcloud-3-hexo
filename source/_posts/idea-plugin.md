---
title: Idea 插件推荐
date: 2021-12-16 17:48:09
categories: Tools
tags:
- Idea
- 插件
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]


# Idea http client

最推荐的，完全可以取代postman。菜单tools -> http client。
如果使用 Postman 工具来测试接口，不仅要在电脑上安装 Postman ，还需要在不同工具之间切换，比较麻烦。幸运的是 IDEA 自带了一款简洁轻量级的接口调用插件，

![](/images/idea-plugin/1.png)
![](/images/idea-plugin/2.gif)

## 写入请求内容

```http
请求路径
GET http://localhost:8080/user
请求头
Content-Type: application/json
{
  请求体
}
三个井号分割开两个请求
```

## 响应处理脚本（Response handler script）

* 我们很多时候不会一个 会话 只发送一个 请求 ，而是在一个会话中发送多个请求。
* 并且，会根据不同响应，发送不同的请求或者请求体。
  这就需要响应脚本进行处理。

刚好 idea 的 http client 提供了 响应处理脚本 的功能，例如：

```http
### 认证
POST https://36.121.8.231:33021/api/v1/cxxx/authentication/token
Content-Type: application/json;charset=UTF-8

{
  "username": "abc",
  "password": "abc123"
}

> {%
client.log("this is a client log");
client.log(response.headers);
client.log(response.headers.valueOf("X-Auth-Token"));
client.log(response.body);
client.log(response.body.issueAt);
client.log(response.status);
client.global.set("token", response.headers.valueOf("X-Auth-Token"));
client.global.set("url", "https://36.121.8.231:33021")
client.global.set("poolId", "2cc8c281-a909-449e-bf78-2babda17fc6a");
client.global.set("tenantId", "d1fa53e1-01dc-4b51-8051-ed949d943b8a");
client.test("Request executed successfully", function() {
  client.assert(response.status === 201, "Response status is not 201");
});
%}
```

上面是发送一个认证接口的POST请求。对response做了如下的操作：
client.log是输出日志信息，如：打印一段文字；打印response的头，打印response的头的"X-Auth-Token"，打印返回体json数据，打印返回体json数据的某一字段issueAt，打印返回的状态码，赋值token url poolId tenantId全局变量，支持断言可以迭代自动化测试。

之后就可以使用全局变量`{{token}}` `{{url}}` `{{poolId}}` `{{tenantId}}`。

## 日志功能

操作界面的右上角有增加环境变量文件和打开日志等按钮。
日志文件按照从新到旧的顺序记录每次的http request以及respone信息，有点遗憾的是没有response的header信息。

## IntelliJ IDEA HTTP Client 的优点有：

* 在同一窗口实现开发和测试。
* 测试脚本可以实现串联的接口调用，提高测试效率。
* 结合git可上传的测试脚本，在多人协同合作的环境下，共享接口请求代码变得非常简单。

# Idea GsonFomatPlus & Idea Lombok

Lombok的`@data`注解最为常用，用于简化代码的，结合Idea GsonFomatPlus & Idea Lombok，可以自动生成对象类的代码。

例如有如下的requst或reponse：

```json
{ 
    "name": "王五", 
    "gender": "man", 
    "age": 15, 
    "height": "140cm", 
    "addr": { 
        "province": "fujian", 
        "city": "quanzhou", 
        "code": "300000" 
    }, 
    "hobby": [ 
        { 
            "name": "billiards", 
            "code": "1" 
        }, 
        { 
            "name": "computerGame", 
            "code": "2" 
        } 
    ] 
} 
```

在实体类代码中mac快捷键`option+s`调出界面
![](/images/idea-plugin/3.png)
![](/images/idea-plugin/4.png)



#  Idea git & Idea JIRA & Idea Gerrit

Idea git用起来效率是低于命令行的git，但是考虑到git操作频率不高，且Idea git不用切换软件界面，另外界面更加友好，也是一个选择。另外借助Idea的插件`git commit template`，拥有强大的commit模版管理功能。

Idea JIRA用是能用，但是功能太有限，几乎不能满足日常JIRA的需求，最多只能看下提给自己的JIRA issue以及改下JIRA issue的状态。因为JIRA的操作点太多了。

Idea Gerrit拥有Gerrit web的常用功能，如review +1+2，submit，查看提交的信息和提交的code diff，使用区别就是一个是Idea界面，一个是web界面。

下面3个截图都是Idea的界面，和Gerrit web界面完全一致。

![](/images/idea-plugin/image-20211216173125226.png)

![](/images/idea-plugin/image-20211216173246369.png)

![](/images/idea-plugin/image-20211216173520251.png)





# Idea xftp/ssh/teminal/database/MyBatisX

Idea sftp用于临时传个jar包很方面，不用切换软件。
Idea ssh/teminal 临时执行一个命令也算方便。
Idea database对数据库的常用操作都有了，不用切换软件，缺点就是速度上感觉比navicat要慢一点。
Idea MyBatisX对切换java代码和xml代码间提供了便利，如下图：

![](/images/idea-plugin/image-20211216173831604.png)





# Idea mind map

可以在写代码的同时写思维导图。file -> new 思维导图。

![](/images/idea-plugin/image-20211216174203869.png)

![](/images/idea-plugin/image-20211216174358736.png)





# Idea Paste Image into Markdown

在Markdown文件中方便插入截屏图片（直接粘贴即可）。类似Typora软件的截屏图片的插入。



# Idea IDE Eva Reset

用于reset评估版的时间，可以有无限时间的评估时间，相当于在免费使用正版的Idea。

