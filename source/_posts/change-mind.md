---
title: 换个思路
readmore: true
date: 2022-07-05 8:15:40
categories: 生活
tags:
---

# 去看看比国内还无聊的抖音

如今无聊成了一切流量的来源，流量就是钱，掌握了无聊的密码就为拿下了或大或小的矿山。

为了看看比抖音还要无聊tiktok，安卓虚拟机里装各种破解版本的tiktok，换了个思路在x86电脑里装安卓虚拟机后在安卓系统里装虚拟安卓系统，因为只有嵌套的安卓os才可以设定sim卡的国家和运营商（正规的安卓虚拟机无此功能）。

后来发现其实啥也不用做，浏览器直接打开 https://www.tiktok.com 就可以看，随意切换国家。傻了，瞎折腾。

自己的iphone手机，设置把地区换一下，tiktok也可以看了，傻了，之前搞了半天，瞎折腾个啥。

> 上面所有思路前提是设备是科学的


# x11转发

Golang项目需要用shell和linux环境，为了开发方便有的项目要从windows Goland切成linux Goland。但是有个小问题：
xmanager 自己家里用没人管，但在商业环境下用可能被骚扰，公司的电脑只能github下个开源的tabby，再下个面的 X server（2选1），终端配置里enable x11转发，就可以打开终端打开Goland

    SSH      * VcXsrv: https://sourceforge.net/projects/vcxsrv/
    SSH      * Xming: https://sourceforge.net/projects/xming/


# 幻灯片

用marp写ppt太香了，专注于内容，而不用去花时间排版做形式，不是非常注重包装的ppt，需要用office powerpoint，marp感觉够用了。可惜只有vscode可以用，intellij用不了。

> demo： http://slide.backendcloud.cn/html/marp_recipes.html

> source： https://github.com/backendcloud/backendcloud-slide/tree/main/src/marp-recipes

