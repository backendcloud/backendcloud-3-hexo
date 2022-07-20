---
title: 效率工具
readmore: false
date: 2022-07-05 8:15:40
categories: Tools
tags:
---

# x11

Golang项目需要用shell和linux环境，为了开发方便有的项目要从windows Goland切成linux Goland。但是有个小问题：
xmanager 自己家里用没人管，但在商业环境下用可能被骚扰，公司的电脑只能github下个开源的tabby，再下个面的 X server（2选1），终端配置里enable x11转发，就可以打开终端打开Goland

    SSH      * VcXsrv: https://sourceforge.net/projects/vcxsrv/
    SSH      * Xming: https://sourceforge.net/projects/xming/



# Marp

用marp写ppt太香了，专注于内容，而不用去花时间排版做形式，除非非常注重宣传和包装的ppt，要用office powerpoint。程序员写的ppt用marp感觉够用了。可惜只有vscode可以用，Jetbrains用不了。

> demo： http://slide.backendcloud.cn/html/marp_recipes.html

> source： https://github.com/backendcloud/backendcloud-slide/tree/main/src/marp-recipes



# Dendron

Dendron是vscode的markdown笔记插件，提升markdown写笔记的效率。

> Dendron is an open-source, local-first, markdown-based, note-taking tool. It's a personal knowledge management solution (PKM).


# mdbook & mdbook-pdf & mdBook-pagetoc

mdbook是Rust写的markdown写电子书的工具，build可以生成html。mdbook-pdf是生成pdf的插件。

> https://github.com/rust-lang/mdBook
>
> https://github.com/HollowMan6/mdbook-pdf
>
> https://github.com/JorelAli/mdBook-pagetoc
>
> https://github.com/zjp-CN/mdbook-theme
>
> https://github.com/JorelAli/mdBook-pagetoc

# zsh & ohmyzsh

默认shell从bash换到zsh，并安装ohmyzsh，感觉好用多了。

>zsh比bash好用些，对bash兼容性比较好，bash对sh兼容性比较好。

> ohmyzsh号称有300+插件

    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
    sh install.sh

换下默认主题，从`ZSH_THEME="robbyrussell"`换成`ZSH_THEME="agnoster"`


# gh (github cli)
github的命令行操作，git的补充。

