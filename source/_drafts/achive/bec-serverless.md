---
title: 后端云站从虚拟机迁移到serverless
date: 2021-01-21 16:13:50
categories: 动态
tags:
- serverless
---

博客经历了几个阶段：放在github+CNAME，遇到不稳定，速度慢；后放到阿里云的云主机，很流畅稳定，唯一的缺点就是收费；现在腾讯云，阿里云都推出了无服务器服务serverless，这种博客的访问量完全在免费范围内，测试了下，完全没问题，放了一个拷贝放到了腾讯云上。 链接：http://my-bucket-hexo-1257857641.cos-website.ap-guangzhou.myqcloud.com

可以考虑以后退掉云主机，改用serverless了。

```bash
hanwei@hanweideMacBook-Air backendcloud-3-hexo % sls --debug
  DEBUG ─ Resolving the template's static variables.
  DEBUG ─ Collecting components from the template.
  DEBUG ─ Downloading any NPM components found in the template.
  DEBUG ─ Analyzing the template's components dependencies.
  DEBUG ─ Creating the template's components graph.
  DEBUG ─ Syncing template state.
  DEBUG ─ Executing the template's components graph.
  DEBUG ─ Preparing website Tencent COS bucket my-bucket-hexo-1257857641.
  DEBUG ─ Bucket "my-bucket-hexo-1257857641" in the "ap-guangzhou" region already exist.
  DEBUG ─ Setting ACL for "my-bucket-hexo-1257857641" bucket in the "ap-guangzhou" region.
  DEBUG ─ Ensuring no CORS are set for "my-bucket-hexo-1257857641" bucket in the "ap-guangzhou" region.
  DEBUG ─ Ensuring no Tags are set for "my-bucket-hexo-1257857641" bucket in the "ap-guangzhou" region.
  DEBUG ─ Configuring bucket my-bucket-hexo-1257857641 for website hosting.
  DEBUG ─ Uploading website files from /Users/hanwei/mywork/5.my_blog/backendcloud-3-hexo/public to bucket my-bucket-hexo-1257857641.
  DEBUG ─ Starting upload to bucket my-bucket-hexo-1257857641 in region ap-guangzhou
  DEBUG ─ Uploading directory /Users/hanwei/mywork/5.my_blog/backendcloud-3-hexo/public to bucket my-bucket-hexo-1257857641
  DEBUG ─ Website deployed successfully to URL: http://my-bucket-hexo-1257857641.cos-website.ap-guangzhou.myqcloud.com.
  myWebsite:
    url: http://my-bucket-hexo-1257857641.cos-website.ap-guangzhou.myqcloud.com
    env:
  32s › myWebsite › done
```

>参考：
>https://cloud.tencent.com/developer/article/1600265
>https://github.com/tinafangkunding/serverless-hexo
