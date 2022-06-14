---
title: wintel&mac的不同感受
readmore: false
date: 2022-06-13 21:14:07
categories: Tools
tags:
- win
- intel
- mac
---
# 该篇总结下这些年同时使用windows+intel（本文简称wintel）和mac电脑的明显的不同感受

先说个人结论：
* 若是用于IntelliJ全家桶从事软件开发，remote ssh服务器，mac是最好选择。
* 若是从事图文视频创作mac是最好选择。
* 若是仅仅用于看看视频，上上网，手机pad的替代，mac是最好的选择。
* 若是要全能电脑，wintel是最好选择。毕竟在软件覆盖面，人工智能和游戏需要的GPU算力方面，需要大内存的工作等领域mac还是较弱。

| mac       | wintel                                                                           |
|-----------|----------------------------------------------------------------------------------|
| cpu性能     | 从12代酷睿开始wintel的cpu性能全面超越 m1/m1 pro/m2                                            |
| 性价比       | mac笔记本2万元以下相对同配置的wintel略贵，2万以上的型号性价比差很多；mac studio 2万以下的和PC台式机性价比不相上下，2万以上性价比差很多 |
| 流畅度       | mac完胜                                                                            |
| 操心度，体验舒心度 | mac太省心，感官上上mac完胜，体验一致性上mac完胜                                                     |
| 应用领域      | mac适合手机pad的替代，图文视频创作，软件开发。wintel全能，覆盖mac的全部领域还包括需要GPU算力的游戏人工智能，大内存等工作领域          |
| 虚拟化软硬件支持  | mac不成熟。wintel非常成熟                                                                |
| 便携性和集成度   | mac笔记本完胜，演讲，demo，移动需要首选mac                                                       |
| Linux原生工具 | mac支持要好于windows，因为mac操作系统就是BSD的内核（开源版的unix）                                      |

> 我自己从事云计算开发，若仅仅软件开发上，喜欢用mac的，但是现在越来越要用到需要大内存，高性能cpu，虚拟化的本地开发环境，所以目前都是用wintel电脑开发。

# 附录： 软件开发中常用的git，git-review，ssh，cgo，gcc等等不如mac好用
主要这些工具都是linux原生的，所以移植到wintel平台不太方便也不好用。
* cgo，gcc需要装mingw。
* ssh windows下无法直接使用，或者用终端工具或者用软件ssh包或者用linux虚拟机使用ssh。
* git使用有个巨坑的地方：git仓库的超链接文件clone下来，本应该是链接文件的，缺变成了链接对象的复制文件。
解决方法是：

安装git的时候，要选中下面的选项，默认是不选的。
![](/images/win-mac_images/10d76a0c.png)
git clone时候要加个参数`-c core.symlinks=true`

    git clone -c core.symlinks=true <URL>






