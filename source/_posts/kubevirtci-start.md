---
title: 一步步学KubeVirt CI （1） - 开篇
readmore: fasle
date: 2022-07-07 19:45:32
categories: 云原生
tags:
- KubeVirt CI
---


# 开篇

刚接触KubeVirt CI的时候，直接被带晕。太复杂了。涉及的方方面面太多了。把自己学习KubeVirt CI的过程记录下来，就有了这本电子书《一步步学KubeVirt CI》。

本书的所有内容基于下面两个代码仓库：
> https://github.com/kubevirt/kubevirtci
> https://github.com/kubevirt/project-infra

若有Kubenetes CI的技术储备会更好，没有也没关系。
> https://github.com/kubernetes/test-infra

本书面向读者的前提是有以下知识点的基本了解，否则理解起来可能会有些吃力。
* Linux os & tools
* Docker/Podman 
* Kubenetes
* KubeVirt
* shell脚本 和 Golang

有了上面的基本了解和技术储备后，就可以开始了。第一章是基础篇，会针对KubeVirt CI需要的技术，做强化说明和查漏补缺。