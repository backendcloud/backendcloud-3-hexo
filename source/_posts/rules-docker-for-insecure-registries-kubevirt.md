---
title: rules_docker_for_insecure_registries
readmore: true
date: 2022-08-10 18:56:44
categories: Tools
tags:
- 后端云小项目
---

# 报错

之前发布过一篇文章 {% post_link rules_docker_for_insecure %}

用修改后的rule去跑kubevirt的时候，报错

![](2022-08-10-15-58-39.png)

# 原因

原因是kubevirt用到的rules_docker是0.16.0版本的，我是那最新版（2022.07.22发布）的0.25.0版基础上改的。kubevirt的代码还没适配最新版的，只兼容0.16.0版本。

具体发生错误的地方如下：line 785 ： attr.architecture 未配置

![](2022-08-10-15-56-50.png)

# 对策

对策：就是基于kubevirt用到的rules_docker是0.16.0版本再改一版。

* [Releases - rules_docker_for_insecure_registries](https://github.com/backendcloud/rules_docker_for_insecure_registries/releases/tag/rules_docker_for_insecure_registries)

* [Releases - kubevirt_rules_docker_for_insecure_registries](https://github.com/backendcloud/rules_docker_for_insecure_registries/releases/tag/kubevirt_rules_docker_for_insecure_registries)