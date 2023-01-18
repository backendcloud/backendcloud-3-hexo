---
title: .git 目录的内部结构
readmore: true
date: 2023-01-18 18:37:35
categories: Tools
tags:
- Git
---

本篇不是讲git的使用，也不是讲git的源码，但阅读本篇有助于理解git的底层逻辑设计。本篇讲的是一个文件夹，具体就是git分布式仓库中的本地仓库的隐藏文件夹`.git`。

# .git目录的结构

```bash
[root@iZ23nrc95u7Z ~]# mkdir git-dir
[root@iZ23nrc95u7Z ~]# cd git-dir/
[root@iZ23nrc95u7Z git-dir]# git init
Initialized empty Git repository in /root/git-dir/.git/
[root@iZ23nrc95u7Z git-dir]# ls -a
.  ..  .git
```

*该隐藏文件夹有以下文件夹和文件：*

**hooks:是存储git钩子的目录，钩子是在特定事件发生时触发的脚本。比如：提交之前，提交之后。**

```bash
[root@iZ23nrc95u7Z git-dir]# cd .git/hooks/
[root@iZ23nrc95u7Z hooks]# ls
applypatch-msg.sample  commit-msg.sample  post-update.sample  pre-applypatch.sample  pre-commit.sample  prepare-commit-msg.sample  pre-push.sample  pre-rebase.sample  update.sample
```

**objects:是存储git各种对象及内容的对象库，包含正常的和压缩后的。**

文件名称是git管理的workspace文件内容的SHA-1 hash校验和，有40位，取前两位作为文件夹名称，后38位作为文件名。前2位作为文件夹是为了快速索引。

因为是根据文件内容做的校验和，所以.git目录不会重复保存，比如基于某个分支新创建一个分支，重复的文件不会重复保存，修改文件也是保存的增量信息。

目录objects里的文件保存的信息有几类，commit，tree（workspace的文件夹信息），blob（workspace的文件信息）。

**refs:是存储git各种引用的目录，包含分支、远程分支和标签。**

refs目录下面有几个目录：heads，remotes，tags

heads目录保存的是本地分支head信息，本地有几个分支就几个分支名称对应的文件，文件内容是该分支head对应的commit id。

remotes是远程仓库的分支和head信息

tags目录保存的是本地仓库的tag和head信息。一个tag对应一个和tag同名的文件，文件内容是该tag对应commit id。

**config:是代码库级别的配置文件。**

该文件的信息和 git config --local -l 命令显示的信息是完全一致的。

通过 git config --local 命令配置的信息，会添加到该文件中。比如 `git config --local user.name "Your Name Here"`。

通过修改该文件，可以实现同 git config --local 命令配置 一样的效果。

**HEAD:是代码库当前指向的分支。**

该文件记录当前所处的分支信息，比如 `ref: refs/heads/main`。

若用 git checkout 命令切换分支，该文件存储的信息会跟着变。

若修改该文件，一样可以达到和 git checkout 命令一样的切换分支的效果。

**description:这个文件用于GitWeb。**

GitWeb 是 CGI 脚本(Common Gateway Interface，通用网关接口，简单地讲就是运行在Web服务器上的程序, 但由浏览器的输入触发)，让用户在web页面查看git内容。如果我们要启动 GitWeb 可用如下命令：

git instaweb --start

服务并打开浏览器 http://127.0.0.1:1234，页面直接显示当前的 git 仓库名称以及描述，默认的描述如下：

Unnamed repository; edit this file 'description' to name the repository.

上面这段话就是默认的 description 文件的内容，编辑这个文件会让 GitWeb 描述更友好。

# 常用操作后.git目录的objects文件夹变化

**增加一个文件到暂存区，objects文件夹的变化**

```bash
[root@iZ23nrc95u7Z git-dir]# ls
[root@iZ23nrc95u7Z git-dir]# tree .git/objects/
.git/objects/
├── info
└── pack

2 directories, 0 files
[root@iZ23nrc95u7Z git-dir]# echo "this is file1" > file1.md
[root@iZ23nrc95u7Z git-dir]# ls
file1.md
[root@iZ23nrc95u7Z git-dir]# cat file1.md
this is file1
[root@iZ23nrc95u7Z git-dir]# git add file1.md
[root@iZ23nrc95u7Z git-dir]# tree .git/objects/
.git/objects/
├── 43
│   └── 3eb172726bc7b6d60e8d68efb0f0ef4e67a667
├── info
└── pack

3 directories, 1 file
[root@iZ23nrc95u7Z git-dir]# git ls-files --stage
100644 433eb172726bc7b6d60e8d68efb0f0ef4e67a667 0	file1.md
[root@iZ23nrc95u7Z git-dir]# git cat-file -t 433eb172726bc7b6d60e8d68efb0f0ef4e67a667
blob
[root@iZ23nrc95u7Z git-dir]# git cat-file -p 433eb172726bc7b6d60e8d68efb0f0ef4e67a667
this is file1
```

**增加一个文件夹和在该文件夹新建一个文件，并保存到暂存区，objects文件夹的变化**

```bash
[root@iZ23nrc95u7Z git-dir]# ls
file1.md
[root@iZ23nrc95u7Z git-dir]# mkdir dir2
[root@iZ23nrc95u7Z git-dir]# echo "this is file2" > dir2/file2.md
[root@iZ23nrc95u7Z git-dir]# tree
.
├── dir2
│   └── file2.md
└── file1.md

1 directory, 2 files
[root@iZ23nrc95u7Z git-dir]# git add dir2
[root@iZ23nrc95u7Z git-dir]# tree .git/objects/
.git/objects/
├── 43
│   └── 3eb172726bc7b6d60e8d68efb0f0ef4e67a667
├── f1
│   └── 38820097c8ef62a012205db0b1701df516f6d5
├── info
└── pack

4 directories, 2 files
[root@iZ23nrc95u7Z git-dir]# git ls-files --stage
100644 f138820097c8ef62a012205db0b1701df516f6d5 0	dir2/file2.md
100644 433eb172726bc7b6d60e8d68efb0f0ef4e67a667 0	file1.md
[root@iZ23nrc95u7Z git-dir]# git cat-file -t 433eb172726bc7b6d60e8d68efb0f0ef4e67a667
blob
[root@iZ23nrc95u7Z git-dir]# git cat-file -p 433eb172726bc7b6d60e8d68efb0f0ef4e67a667
this is file1
[root@iZ23nrc95u7Z git-dir]# git cat-file -t f138820097c8ef62a012205db0b1701df516f6d5
blob
[root@iZ23nrc95u7Z git-dir]# git cat-file -p f138820097c8ef62a012205db0b1701df516f6d5
this is file2
```

**提交内容：**

git commit 将暂存区的内容提交到本地仓库。

```bash
[root@iZ23nrc95u7Z git-dir]# git commit -m 'add file1.md and dir2/file2.md'
[master (root-commit) b2d176a] add file1.md and dir2/file2.md
 2 files changed, 2 insertions(+)
 create mode 100644 dir2/file2.md
 create mode 100644 file1.md
[root@iZ23nrc95u7Z git-dir]# tree .git/objects/
.git/objects/
├── 01
│   └── 54de200dfc71f16a7847f293d79b42b43995e6
├── 20
│   └── d1d441485e8a194976cba515754890bffb32ad
├── 43
│   └── 3eb172726bc7b6d60e8d68efb0f0ef4e67a667
├── b2
│   └── d176a8c3f1d4f608b722cc3b79bdeeaebbdf06
├── f1
│   └── 38820097c8ef62a012205db0b1701df516f6d5
├── info
└── pack

7 directories, 5 files
```

发现经过了 git commit 命令，除了原来的两个文件blob对象，又多出了三个对象，分别是commit对象，该commit作为整体的tree对象，file2.md所在的文件夹dir2的tree对象。

```bash
[root@iZ23nrc95u7Z git-dir]# git cat-file -t 0154de200dfc71f16a7847f293d79b42b43995e6
tree
[root@iZ23nrc95u7Z git-dir]# git cat-file -p 0154de200dfc71f16a7847f293d79b42b43995e6
040000 tree 20d1d441485e8a194976cba515754890bffb32ad	dir2
100644 blob 433eb172726bc7b6d60e8d68efb0f0ef4e67a667	file1.md
[root@iZ23nrc95u7Z git-dir]# git cat-file -t 20d1d441485e8a194976cba515754890bffb32ad
tree
[root@iZ23nrc95u7Z git-dir]# git cat-file -p 20d1d441485e8a194976cba515754890bffb32ad
100644 blob f138820097c8ef62a012205db0b1701df516f6d5	file2.md
[root@iZ23nrc95u7Z git-dir]# git cat-file -t b2d176a8c3f1d4f608b722cc3b79bdeeaebbdf06
commit
[root@iZ23nrc95u7Z git-dir]# git cat-file -p b2d176a8c3f1d4f608b722cc3b79bdeeaebbdf06
tree 0154de200dfc71f16a7847f293d79b42b43995e6
author gitusername <gitusermail> 1674019979 +0800
committer gitusername <gitusermail> 1674019979 +0800

add file1.md and dir2/file2.md
[root@iZ23nrc95u7Z git-dir]# git log
commit b2d176a8c3f1d4f608b722cc3b79bdeeaebbdf06
Author: gitusername <gitusermail>
Date:   Wed Jan 18 13:32:59 2023 +0800

    add file1.md and dir2/file2.md
[root@iZ23nrc95u7Z git-dir]# cat .git/COMMIT_EDITMSG
add file1.md and dir2/file2.md
```

commit后，继续修改文件内容，或新增文件，文件夹。不管是内容修改还是新建，校验和变了，就会在.git/objects目录下多出对应的对象，再次commit，会多出commit对象和该commit的整个tree的对象。

所以即使有多个版本git不会保存多份相同文件内容，只会保存原始文件和增量内容，每一个commit版本都有清晰的结构快照，可以恢复到任意一次commit。新建分支，在其他分支的commit。通过分支信息文件，分支的HEAD信息文件，可以计算出不同分支的commit历史。


