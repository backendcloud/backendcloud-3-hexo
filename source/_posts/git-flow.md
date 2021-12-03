---
title: 开始尝试使用git flow工作流
date: 2021-09-26 15:32:59
categories:
- Tools
tags:
- git flow
- git
---

之前开发项目都是git+gerrit，仅使用一个develop分支，自己电脑上的develop分支代码有变动，git add; git commit (--amend); git review; gerrit通过评审验证后submit，merge到远端代码仓库的develop分支。

现在尝试git flow工作流。

# git flow工作流的分支模式

![](/images/git-flow/1.png)

# git flow工具和git flow工作流

git flow工作流是一套工作方式，工作流程。完全可以不安装git-flow工具，用git去实现git flow工作流。

git-flow工具 并不是要替代 Git工具，它仅仅是非常聪明有效地把标准的 Git 命令用脚本组合了起来，更方便的实现git flow工作流。

# git flow工具的安装

	brew install git-flow

# git flow工具常用的功能

## 在项目中设置 git-flow

当你想把你的项目 “切换” 到 git-flow 上后，Git 还是可以像往常一样工作的。这完全是取决于你在仓库上使用特殊的 git-flow 命令或是普通的 Git 命令。换句话说，git-flow 它不会以任何一种戏剧性的方式来改变你的仓库。

```bash
hanwei@hanweideMacBook-Air xxx-project]$ git flow init

Which branch should be used for bringing forth production releases?
   - develop
   - master
Branch name for production releases: [master] 

Which branch should be used for integration of the "next release"?
   - develop
Branch name for "next release" development: [develop] 

How to name your supporting branch prefixes?
Feature branches? [feature/] 
Release branches? [release/] 
Hotfix branches? [hotfix/] 
Support branches? [support/] 
Version tag prefix? [] 
```

当在项目的根目录执行 “git flow init” 命令时（它是否已经包括了一个 Git 仓库并不重要），一个交互式安装助手将引导您完成这个初始化操作。听起来是不是有点炫，但实际上它只是在你的分支上配置了一些命名规则。

尽管如此，这个安装助手还是允许你使用自己喜欢的名字。我强烈建议你使用默认的命名机制，并且一步一步地确定下去。

## 功能开发

```bash
hanwei@hanweideMacBook-Air xxx-project]$ git flow feature start test-gitflow
Switched to a new branch 'feature/test-gitflow'

Summary of actions:
- A new branch 'feature/test-gitflow' was created, based on 'develop'
- You are now on branch 'feature/test-gitflow'

Now, start committing on your feature. When done, use:

     git flow feature finish test-gitflow

```

`编写新功能对应的代码；git add .；git commit (--amend)`

```bash
hanwei@hanweideMacBook-Air xxx-project]$ git flow feature finish test-gitflow
fatal: Index contains uncommited changes. Aborting.
hanwei@hanweideMacBook-Air xxx-project]$ git commit
[feature/test-gitflow 546c759] [xxx-project] [无视本次提交]test git flow工作流
 2 files changed, 30 insertions(+)
 create mode 100644 xxx-project/.README_images/ea3d10c7.png
hanwei@hanweideMacBook-Air xxx-project]$ git flow feature finish test-gitflow
Switched to branch 'develop'
Your branch is up to date with 'origin/develop'.
Updating f90bcb3..546c759
Fast-forward
 xxx-project/.README_images/ea3d10c7.png | Bin 0 -> 115727 bytes
 xxx-project/README.md                   |  30 ++++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)
 create mode 100644 xxx-project/.README_images/ea3d10c7.png
Deleted branch feature/test-gitflow (was 546c759).

Summary of actions:
- The feature branch 'feature/test-gitflow' was merged into 'develop'
- Feature branch 'feature/test-gitflow' has been removed
- You are now on branch 'develop'
```

## 管理 releases

	$ git flow release start 1.1.5
	Switched to a new branch 'release/1.1.5'

`do something`

	git flow release finish 1.1.5

这个命令会完成如下一系列的操作：

首先，git-flow 会拉取远程仓库，以确保目前是最新的版本。
然后，release 的内容会被合并到 “master” 和 “develop” 两个分支中去，这样不仅产品代码为最新的版本，而且新的功能分支也将基于最新代码。
为便于识别和做历史参考，release 提交会被标记上这个 release 的名字（在我们的例子里是 “1.1.5”）。
清理操作，版本分支会被删除，并且回到 “develop”。

## hotfix

	$ git flow hotfix start missing-link

`do something`

	$ git flow hotfix finish missing-link

这个过程非常类似于发布一个 release 版本：

完成的改动会被合并到 “master” 中，同样也会合并到 “develop” 分支中，这样就可以确保这个错误不会再次出现在下一个 release 中。
这个 hotfix 程序将被标记起来以便于参考。
这个 hotfix 分支将被删除，然后切换到 “develop” 分支上去。
还是和产生 release 的流程一样，现在需要编译和部署你的产品（如果这些操作不是自动被触发的话）。

# 定制属于自己的工作流程

使用 git-flow 并不是必须的。当积攒了一定的使用经验后，很多团队会不再需要它了。当你能正确地理解工作流程的基本组成部分和目标的之后，你完全可以定义一个属于你自己的工作流程。
