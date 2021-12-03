---
title: Mac版Typora 标题自动编号
date: 2021-09-15 17:36:23
categories: Tools
tags:
- Typora
- Tools
---

Mac版的Typora在"使用偏好 - 外观 - 打开主题文件夹"，打开的文件夹放一个base.user.css文件，文件内容如下
```css
hanwei@hanweideMacBook-Air themes]$ pwd
/Users/hanwei/Library/Application Support/abnerworks.Typora/themes
hanwei@hanweideMacBook-Air themes]$ cat base.user.css
/** initialize css counter */
#write {
counter-reset: h1
}
h1 {
counter-reset: h2
}
h2 {
counter-reset: h3
}
h3 {
counter-reset: h4
}
h4 {
counter-reset: h5
}
h5 {
counter-reset: h6
}
/** put counter result into headings */
#write h1:before {
counter-increment: h1;
content: counter(h1) " "
}#write h2:before {
counter-increment: h2;
content: counter(h1) "." counter(h2) " "
}
#write h3:before,
h3.md-focus.md-heading:before /** override the default style for focused headings */ {
counter-increment: h3;
content: counter(h1) "." counter(h2) "." counter(h3) " "
}
#write h4:before,
h4.md-focus.md-heading:before {
counter-increment: h4;
content: counter(h1) "." counter(h2) "." counter(h3) "." counter(h4) " "
}
#write h5:before,
h5.md-focus.md-heading:before {
counter-increment: h5;
content: counter(h1) "." counter(h2) "." counter(h3) "." counter(h4) "." counter(h5) " "
}
#write h6:before,
h6.md-focus.md-heading:before {
counter-increment: h6;
content: counter(h1) "." counter(h2) "." counter(h3) "." counter(h4) "." counter(h5) "." counter(h6) " "
}
/** override the default style for focused headings */
#write>h3.md-focus:before,
#write>h4.md-focus:before,
#write>h5.md-focus:before,
#write>h6.md-focus:before,
h3.md-focus:before,
h4.md-focus:before,
h5.md-focus:before,
h6.md-focus:before {
color: inherit;
border: inherit;
border-radius: inherit;
position: inherit;
left:initial;
float: none;
top:initial;
font-size: inherit;
padding-left: inherit;
padding-right: inherit;
vertical-align: inherit;
font-weight: inherit;
line-height: inherit;
}
hanwei@hanweideMacBook-Air themes]$ 
```

Windows版一样的文件名和内容，只是目录位置变一下。记得以上流程做完要重启Typora，重启才能生效。该css只让正文部分的标题自动编号，`大纲`和`TOC`部分还是老样子。
