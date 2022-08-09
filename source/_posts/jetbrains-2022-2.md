---
title: Jetbrains全家桶2022.2 全平台破解
readmore: false
date: 2022-08-09 13:15:39
categories: Tools
tags:
- Jetbrains
- 破解
---

几天前Jetbrains发布了2022.2版本全家桶。本篇是关于2022.2的最新的破解方法：（已测试，全平台，全部IDE都适用）

> 因为版权侵权，著名的开源破解工具 ja-netfilter 被 Github 给被封了， https://github.com/ja-netfilter/ja-netfilter

因为Jetbrains 2022.2版本默认启用Java17，{% post_link jetbrains-mac-m1 %} 种介绍的 2022.1 的破解方法已经不适用了。

需要手动为 Java17 在 vmoptions 加上两行
```bash
--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED
```

并使用5月20日发布的ja-netfilter-v2022.2.0版本，2022.1 的破解方法可以继续使用。也可以为了省事也可以直接用下面的 2022.2 的破解方法：

Jetbrains 的 2022.2版本 全家桶破解方法 已更新至之前发布的一篇文章的最底部 {% post_link jetbrains-mac-m1 %}


使用说明：
- 将zip破解文件解压缩
- 将文件夹“jihuo-tool”整个文件夹放置到自己电脑的某个固定位置，位置任意，但是放好后就不要删除了
- 执行jihuo-tool\scripts里的安装脚本（若之前装过，装前先卸载），windows平台就执行vba，mac以及linux平台就执行sh
- 然后打开jetbrain软件，输入激活码。
- 完成破解，放心使用！