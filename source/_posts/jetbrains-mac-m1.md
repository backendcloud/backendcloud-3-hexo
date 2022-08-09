---
title: jetbrains macbook m1版全家桶破解
date: 2021-03-11 17:01:57
categories: Tools
tags:
- Jetbrains
- 破解

---
> 写该文章的时候2020.3是最新版，于 2022.04.20 在文章末尾 更新最新版 `2022.1` 正式版 破解方法 适用于Jetbrains全家桶，适用于全平台 mac m1/x86；windows；linux（centos/ubuntu）等

> 于 2022.08.09 在文章末尾 更新最新版 `2022.2` 正式版 破解方法 适用于Jetbrains全家桶，适用于全平台 mac m1/x86；windows；linux（centos/ubuntu）等

苹果macbook要放弃intel芯片，转而采用自家芯片，m1芯片是从intel到全系采用自家芯片的过渡期到一个芯片型号，arm架构。随着m1芯片发布以来时间的推移，越来越多越多的软件从需要rosetta转译到原生支持。jetbrains从2020年下半年开始也发布了原生支持m1的版本。

**破解方式:**
1 官网下载软件 http://www.jetbrains.com/
2 下载[破解zip包](/files/jetbrains-mac-m1/Jetbrains2020.3及以上版本激活补丁_520xiazai.zip)，解压缩得到激活码和破解文件
3 先安装主程序.安装完后打开,会提示激活,此时选择[Evaluate for free]=>[Evaluate] (如果是已经过了试用期.可用reset_script目录里面脚本进行重置.)
4 解压文件,新建个项目并打开,再将JetbrainsPatch*.zip拖到软件右侧界面,然后关闭软件,再打开(即重启软件,补丁不会自动重启软件).
5 找到授权管理菜单(help=>Register=>Add new License),选择Activation Code,然后将ActivationCode.txt里面的内容复制过去粘贴
6 重新打开主程序，发现破解成功，有效期至2099年

**以上方法亲测对以下3款有效（实际应该对全家桶2020.3全部有效）：**
* goland 2020.3
* IntelliJ ideaIU 2020.3
* PyCharm 2020.3

也可使用下面的方法和上面的方法组合使用，双保险，防止一方突然失效。

Jetbrains 家的产品有一个很良心的地方，他会允许你试用 30 天（这个数字写死在代码里了）以评估是否你真的需要为它而付费。有一款插件你或许可以用它来重置一下试用时间。但切记不要无休止的一直试用，这并不是这个插件的初衷！

插件市场安装：
在 Settings/Preferences... -> Plugins 内手动添加第三方插件仓库地址：https://plugins.zhile.io 搜索：IDE Eval Reset 插件进行安装。
![](/images/jetbrains-mac-m1/1.jpg)
![](/images/jetbrains-mac-m1/2.jpg)
![](/images/jetbrains-mac-m1/3.jpg)
![](/images/jetbrains-mac-m1/4.jpg)



> [于 2022.04.20 更新 Jetbrains 2022.1 正式版 破解方法 适用于全系列系统 mac m1/x86；windows；linux（centos/ubuntu）等](https://puffy-secure-2a8.notion.site/jetbrains-2022-1-windows-64-mac-m1-6dda5f1f079d41609eac7a467d7c19d4)

> [于 2022.08.09 更新 Jetbrains 2022.2 正式版 破解方法 适用于Jetbrains全家桶，适用于全平台 mac m1/x86；windows；linux（centos/ubuntu）等](https://puffy-secure-2a8.notion.site/jetbrains-2022-2-windows-64-mac-m1-mac-x86-linux-4320ae14f4474cf48ca291d5aa03a1be)