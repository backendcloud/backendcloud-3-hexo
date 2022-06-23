---
title: Centos Stream 9 入坑之 error in libcrypto
readmore: true
date: 2022-06-23 18:18:14
categories: Linux
tags:
- Centos Stream 9
---

# ssh_dispatch_run_fatal: Connection to xxx port 29418: error in libcrypto
mac，windows，centos7 os下git clone项目的代码仓库都是ok的，唯独Centos Stream 9 os下git clone不了代码仓库。

报错如下：

    ssh_dispatch_run_fatal: Connection to xxx port 29418: error in libcrypto

原因有两个：
1. 有些老古董的项目流程，比如我遇到的老古董gerrit工具还跑在老系统上
2. 从 RHEL 8 / Centos Stream 8 开始，加密算法采用强加密为默认值，弱加密算法弃用。

> 参考：https://access.redhat.com/articles/3642912

解决办法也是和上面2个原因相对应的：
1. 升级老系统
2. 老系统不方便升级，只能牺牲点安全，在 Centos Stream 9 上执行下面的命令

   update-crypto-policies --set DEFAULT:SHA1

```bash
[root@centos9 .ssh]# git clone "ssh://xxx@gerrit.xxx.com:29418/xxx/xxx"
Cloning into 'xxx'...
ssh_dispatch_run_fatal: Connection to xxx port 29418: error in libcrypto
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
[root@centos9 .ssh]# update-crypto-policies --show
DEFAULT
[root@centos9 .ssh]# update-crypto-policies --set DEFAULT:SHA1
Setting system policy to DEFAULT:SHA1
Note: System-wide crypto policies are applied on application start-up.
It is recommended to restart the system for the change of policies
to fully take place.
[root@centos9 .ssh]# git clone "ssh://xxx@gerrit.xxx.com:29418/xxx/xxx"
Cloning into 'xxx'...
remote: Counting objects: 172185, done
remote: Finding sources: 100% (172185/172185)
remote: Total 172185 (delta 114844), reused 172183 (delta 114844)
Receiving objects: 100% (172185/172185), 232.20 MiB | 8.48 MiB/s, done.
Resolving deltas: 100% (114844/114844), done.
```

> 参考： https://access.redhat.com/articles/3666211

# 关于 CentOS Stream 9

> 以下仅个人看法

之前centos7 宣布支持到2024年，网上砸锅了，各种言论漫天飞，基本充斥2种：愤怒和Centos不支持我来支持。

愤怒不可理解，不是有centos stream吗

我来支持，有一定技术储备的公司说说也就罢了，阿猫阿狗也来凑热闹，那些以前只是把CentOS的标志换成自己公司标志的也说CentOS不支持了我来支持。这不搞笑吗！网络社会蹭热度如此无底线。

过去centos的做法简而言之，Red Hat将Fedora用于测试它想在RHEL中实现的功能。这些功能进入到RHEL，然后使用最新的RHEL版本创建CentOS，作为一种免费且自我支持的RHEL的替代方案。这就相当于：

Fedora是最上游，RHEL是中游，CentOS是下游

> 因为CentOS是RHEL的下游，通过CentOS项目向RHEL提交源码就像你想让江水逆流而上一样不现实。

一个centos7 2014年就出来了，快10多年了还是centos7，过去那种发版速度显然不适应现代产品迭代速度，现在的产品是按天迭代的，现在的做法是按天为单位发布CentOS Stream，让 CentOS Stream 成为一个持续交付的发行版，上下游关系变为：

一个centos7支持到2024年，也支持了10年，过去的ubuntu LTS版本，windows版本支持10年后不支持很正常吧。

Fedora是最上游，CentOS Stream是中游，RHEL是下游

> CentOS Stream将以RHEL上游的身份来解决合作伙伴、社区用户和其他开发者在之前无法参与RHEL的开发过程的问题。旨在提高 RHEL 开发过程的透明度和协作性，它出现的目的是为了完善红帽RHEL的生态和加速创新。所以给CentOS换个身份，问题就完美解决了。

CentOS Stream的版本稳定性上：发布在 Stream 上的更新与发布在 RHEL 未发布的次要版本上的更新是相同的。目的是为了让 CentOS Stream 与 RHEL 本身一样具有基本的稳定性。

win11，office，ios上的app都是这种迭代速度，用的人数以亿记，为何centos不可以。现在软件流程，CICD技术可以让这种迭代速度在稳定性和功能性的找到最佳的平衡。