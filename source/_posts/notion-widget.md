---
title: Notion的页面插入小控件Widget
date: 2022-01-06 11:06:12
readmore: false
categories: Tools
tags:
- Notion
- widget

---

# 什么是Widget

Widget 不是一个小型的 App，它是一种新的桌面内容展现形式，主要是用于弥补主应用程序无法及时展示用户所关心的数据。

一个优秀的 Widget 需要有三个特点：简单明了（Glanceable）、恰当展示（Relevant）、个性化定制（Personalized）。

# Notion的页面插入Widget

Notion的页面可以轻松插入如同IOS系统，鸿蒙系统里的小控件。如下图：

![](/images/notion-widget/image-20220106104837528.png)

各种控件很多，可以在文章中的链接里自己试用，下面拿上图的4个小控件：未来7天天气，当前日历，生命剩余电量，当前时间来举例。



## 未来7天天气组件

[WeatherWidget.io](https://weatherwidget.io/)

![](/images/notion-widget/image-20220106105912575.png)

点击获取代码`get code`按钮

```javascript
<a class="weatherwidget-io" href="https://forecast7.com/en/40d71n74d01/new-york/" data-label_1="NEW YORK" data-label_2="WEATHER" data-theme="original" >NEW YORK WEATHER</a>
<script>
!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src='https://weatherwidget.io/js/widget.min.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','weatherwidget-io-js');
</script>
```

复制代码后不能直接粘贴Notion，只能是一大段代码，去

[Apption - Notion friendly Embeddable Widget Apps](https://apption.co/)

生成url，url放到notion的embed block

![](/images/notion-widget/image-20220106110026133.png)

## 当前日历组件

[WidgetBox - Notion Widgets](https://widgetbox.app/)

![](/images/notion-widget/image-20220106110108124.png)

配置好外观后，复制url，url放到notion的embed block

![](/images/notion-widget/image-20220106110151345.png)

## 生命的剩余电量🔋组件

[Indify - Notion Widgets](https://indify.co/)

![](/images/notion-widget/image-20220106110505666.png)

配置好外观后，复制url，url放到notion的embed block

![](/images/notion-widget/image-20220106110542945.png)

## 当前时间组件

[WidgetBox - Notion Widgets](https://widgetbox.app/)

![](/images/notion-widget/image-20220106110429664.png)

配置好外观后，复制url，url放到notion的embed block

![](/images/notion-widget/image-20220106110331915.png)

