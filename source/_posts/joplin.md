---
title: Joplin试用
readmore: false
date: 2022-06-20 19:04:51
categories: Tools
tags:
---

Joplin最近很火，试用了下。和最火的老牌云笔记印象笔记，最火的新一代云笔记all-in-one的Notion做了点对比。

> https://github.com/laurent22/joplin

Joplin是开源产品商业化很低，简单用了下，BUG很多，IOS的换行操作都有bug。Joplin相比印象笔记和Notion厉害的地方在于开源和同步方式多样。

除了支持传统的文件多端同步，还支持在自己的服务器部署服务端，或用Joplin官方自己的云服务，或用亚马逊S3存储，家用NAS存储同步。

> 印象笔记和Notion的不同可参考之前的文章 <a href="https://www.backendcloud.cn/2022/01/06/notion/" target="_blank">https://www.backendcloud.cn/2022/01/06/notion/</a>

> 用下来感觉比较好的Joplin部署方案：
> 轻度：存储服务使用 微软Onedrive或坚果云的WebDev服务，免费。微软5G的大小，坚果云一个月1G的流量，轻度用户足够了。网上说连接数并行量大的时候坚果云不稳定，我没遇到过，因为就是试用了下而已，试用没任何问题。唯一遇到的小坑就是坚果云不支持根目录提供webdev服务，要在根目录新建一个目录提供webdev服务。
> 重度：基于国内网络的问题，亚马逊S3服务只能选用国内兼容S3的腾讯或阿里的对象存储。

> 腾讯和阿里的对象存储服务的价格，1G1元，好像和印象笔记收费差不多，比notion贵很多。另外看了下webdev服务端保存的格式，是加密的，也就是对我是完全不透明的，要是哪一个地方操作不小心出错了，整个云笔记都打不开了。印象和Notion专业性够强，我更信任他们些。 Joplin又不便宜，又数据安全不让我放心，暂时不考虑，虽然已经做的很棒了。

