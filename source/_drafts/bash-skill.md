---
title: bash-skill
readmore: true
date: 2022-05-23 10:13:58
categories:
tags:
---

# 字符串分割 - docker manifest 脚本中 字符串分割 os 和 arch 信息

```bash
PLATFORMS=${PLATFORMS:-"linux_amd64 linux_arm64"}
for platform in ${PLATFORMS}; do
  os=${platform%_*}
  arch=${platform#*_}
  echo $os
  echo $arch
done
```

> %_* 删掉第一个下划线及其右边的字符串
> #*_ 删除第一个下划线及其左边的字符串

# 字符串匹配和替换

```bash
以下两种语法可以检查字符串内部，是否匹配给定的模式。如果匹配成功，就删除匹配的部分，换成其他的字符串返回。原始变量不会发生变化。

# 如果 pattern 匹配变量 variable 的一部分，
# 最长匹配（贪婪匹配）的那部分被 string 替换，但仅替换第一个匹配
${variable/pattern/string}

# 如果 pattern 匹配变量 variable 的一部分，
# 最长匹配（贪婪匹配）的那部分被 string 替换，所有匹配都替换
${variable//pattern/string}
上面两种语法都是最长匹配（贪婪匹配）下的替换，区别是前一个语法仅仅替换第一个匹配，后一个语法替换所有匹配。

#上面例子中，前一个命令只替换了第一个foo，后一个命令将两个foo都替换了。
#下面的例子将分隔符从:换成换行符。

$ echo -e ${PATH//:/'\n'}
/usr/local/bin
/usr/bin
/bin
...
#上面例子中，echo命令的-e参数，表示将替换后的字符串的\n字符，解释为换行符。
```


