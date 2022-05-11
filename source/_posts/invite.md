---
title: 协作邀请
date: 2022-05-10 21:17:47
readmore: false
categories: 网站里程碑
tags: 
- pr
- issue
---

后端云网站是一份可以在线修改的文档。

若你发现有什么可以或改进或重写或新写的，欢迎提供帮助！意见和讨论发 **[这里](https://github.com/backendcloud/backendcloud-3-hexo/issues)**

编辑后端云网站方法如下：
* step1 **`fork`** [后端云文档仓库 https://github.com/backendcloud/backendcloud-3-hexo](https://github.com/backendcloud/backendcloud-3-hexo)，新建一个分支
* step2 修改文章修改 **`source/_posts`** 路径下对应url的markdown文件。有原创文章要发表若本地装了hexo，不用多说。若没有hexo也不想装，新建一个markdown文件，参考其他markdown文件的开头复制修改下，修改和新增文章内容
* step3 提交 **`pr`** ，pr merge后会自动触发 **[CI](https://github.com/backendcloud/backendcloud-3-hexo/blob/master/.github/workflows/ci.yml)** 和 **[CD](https://github.com/backendcloud/backendcloud.github.io/blob/master/.github/workflows/cd.yml)** 流程， **[CI](https://github.com/backendcloud/backendcloud-3-hexo/blob/master/.github/workflows/ci.yml)** 和 **[CD](https://github.com/backendcloud/backendcloud.github.io/blob/master/.github/workflows/cd.yml)** 跑完，网站就会更新。


