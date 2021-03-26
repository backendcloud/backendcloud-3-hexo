title: 去QQ广告
date: 2017-02-17 03:41:34
categories:
- Tools
tags:
- QQ
- 广告
---
下网上的插件，非官方的qq风险太大
google搜索了下，找到了解决办法
qq广告主要集中在聊天框右上角的图片广告，左下角的文字广告。
图片广告，对于win10只需要将C:\Users\用户\AppData\Roaming\Tencent\QQ\Misc\com.tencent.advertisement的当前用户的写权限关闭即可。
用修改hosts文件的方法，对于任何系统，且左下，右上的广告同时去掉，推荐这种方法。将以下内容添加到C:\Windows\System32\drivers\etc\hosts文件中

    0.0.0.0 c.gdt.qq.com
    0.0.0.0 adshmct.qq.com
    0.0.0.0 adshmmsg.qq.com
    0.0.0.0 adshmct.qq.com
    0.0.0.0 q.i.gdt.qq.com
    0.0.0.0 v.gdt.qq.com
    0.0.0.0 adshmct.qq.com
    0.0.0.0 hm.l.qq.com
    0.0.0.0 adshmmsg.qq.com

就是不走公网的域名解析，本地解析，和linux  /etc/hosts 一样，0.0.0.0 的原因是:
如果，我们在Hosts中，写入以下内容：
127.0.0.1 # 要屏蔽的网站 A
0.0.0.0 # 要屏蔽的网站 B
这样，计算机解析域名A和 B时，就解析到本机IP或错误的IP，达到了屏蔽网站A 和B的目的。

推荐后者

