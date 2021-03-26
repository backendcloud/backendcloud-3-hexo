title: python，NFV项目开发--vim
date: 2016-09-02 19:35:02
categories: Tools
tags:
- vim
---

vim是python开发最常用的编辑工具之一，本文不是介绍vim的，而是结合python进行实际项目开发，说一说vim在python开发中的心得。

# vim之所以流行，之所以被称为上古神器
1) 写bash脚本写perl的，在linux下修改些配置，对vim再熟悉不过。
vim的高效因为纯键盘，要远远快过鼠标键盘结合。就如在vim下用hjkl要远快过在vim下用上下左右箭头的，因为手指的移动的距离越长，效率越低。

2) vim说烂了的基本功能，编辑和命令模式，G,gg,dd,(yy,p),(yn,p),(dn,p),/查找,n(下一个).N(上一个),%s替换，vim -d(diff),ctrl+v块操作,:(行号) 等等

3) 强大的配置文件，可配置tab转4个空格，自动缩进4格，智能缩进，语法高亮，显示行号，等等。配置文件不仅提供强大的工具，还个性化定制，符合个人的编程习惯。

4) 常用集成开发环境如eclipse的代码补全，实时检查语法，文件目录树，标签等等几乎有的一切功能vim和vim插件都可实现，但是vim有的很多功能和特性其他开发工具未必有，实际上很多功能，如代码补全，根据个人习惯，有些人是不开的或不用的。再比如目录树和标签，这些都是windows的文件系统和操作特点决定需要的。而python开发不会在windows下进行。

5) 作为文本编辑的纯粹，减少一切于此无关的干扰，专注于编辑。

vim的强大不仅仅在于好用，编辑速度快，还在于可扩展，甚至是无限扩展，也就是无限可能。

下面聊一聊vim在python开发中的必备配置和插件以及心得。

# 两个常用的插件：
pyflakes http://www.vim.org/scripts/script.php?script_id=2441
pep8 http://www.vim.org/scripts/script.php?script_id=2914

这两个vim插件下载好了，解压缩后直接复制到~/.vim/ftplugin/python

python开发，pyflakes必装，实时提示语法错误。

pep8 vim插件需要机器上有pep8工具，没有的话先pip install pep8后再下载pep8 vim插件。输出窗口提示PEP8错误。pep8 vim插件个人认为不一定要装。因为不好用，不如开2个VIM，就是说开左右两个窗口对照，一个程序，一个pep8错误。


# pyflakes vim插件实际效果
![pyflakes效果](/images/vim_python/vim_python_error.png)

拼写错误，导致引用未定义的变量


# PEP8不超过79个字符实时提示设置
在~/.vimrc中加入下面两行
```
    highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    match OverLength /\%80v.\+/
```
任意一行字符>=80的时候，80以及80以外的字符都用红色背景标记出来


# PEP8不超过79个字符实时提示效果
![超过79个字符](/images/vim_python/vim_more_79.png)
![不超过79个字符](/images/vim_python/vim_less_80.png)


# PEP8格式化输出
    autopep8 -i --aggressive file(s)
可以将自己编写的python文件格式化输出成符合PEP8的python文件

不推荐，理由有2个，一个是格式化输出个人使用下来虽然能消除很多不符合PEP8的错误，但不能保证100%符合PEP8，二个是遵循PEP8写代码，是个良好的编程习惯，不仅仅为了他人的阅读，应该让自己写代码的时候就遵循这个规则来写。通过检查报错不断完善自己的编码习惯。多次迭代，PEP8检查的耗时越来越少，且养成了良好的python编程习惯。


# VIM显示tab键和不需要的多余空格

文件中有 TAB 键的时候，你是看不见的。要把它显示出来。
同样对于行尾多余的空白字符显示成 "-"。尾行有多余的空格PEP8检查会报错。
在~/.vimrc中加入下面两行
```
    set listchars=tab:>-,trail:-
    set list
```
现在，TAB会被显示成 ">-" 而行尾多余的应该被删除的空白字符显示成 "-"。
