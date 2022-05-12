---
title: gvk-gvr
readmore: true
date: 2022-05-12 10:14:24
categories:
tags:
---


# Group
资源组，Kubenetes API Server 也称为 APIGroup，其有如下特点：

* 资源组的划分依据是资源的功能；
* 支持不同资源组中拥有不同资源版本，从而方便组内资源迭代升级；
* 支持不同 Group 内有同名 Kind 的 Resource；
* 支持通过 CRD 扩展自定义资源；
* 使用 kubectl 命令进行资源交互时，可以不指定 Group；
* 有组名 Group 及无组名 Group

包含拥有组名的 Group 和没有组名的 Core Groups（如 v1/pods），其 HTTP 请求方式也有差别：

* 有组名 Group 资源: .../apis/<GROUP>/<VERSION>/<RESOURCE>
* 无组名 Group 资源: .../api/<VERSION>/<RESOURCE>

# Version
Kubernetes 的资源版本 Version 采用的是语义化的版本号，版本号以 v 开头，版本号后面跟着版本的测试阶段(Alpha -> Beta -> Stable)，例如：v1alpha1、v1beta1、v2stable1

版本的各个测试阶段情况如下：

* Alpha 阶段：内部测试版本，存在很多的缺陷和漏洞，版本极其不稳定，官方随时可能会放弃支持该版本，仅仅用于开发者的测试使用，Alpha 版本中的功能默认情况下会被禁用。常见命名方式如 v1alpha1；
* Beta 阶段：相对稳定版本，经过了官方和社区的测试，版本迭代时会有些许改变，但不会像 Alpha 版本一样不稳定，Beta 阶段下的功能默认是开启的。常见命名方式如 v2beta1；
* Stable 阶段：正式发布版本，功能稳定版本，基本形成了产品，默认情况下所有功能全部开启，命名方式一般不加 stable，直接是 v1、v2 这种；

 
# Resource
Resource 是 Kubernetes 中的核心概念，Kubernetes 的本质就是管理、调度及维护其下各种 Resources。

* Resource 实例化后称为一个 Resource Object；
* Kubernetes 中所有的 Resource Object 都称为 Entity；
* 可以通过 Kubenetes API Server 去操作 Resource Object；

Kubernetes 目前将 Entity 分为两大类：

* Persistent Entity：即 Resource Object 创建后会持久存在，绝大部分都是 PE，如 Deployment / Service；
* Ephemeral Entity: 短暂实体，Resource Object 创建后不稳定，出现故障/调度失败后不再重建，如 Pod；


# 资源操作方法
虽然在 Etcd 层面而言，对于资源的操作最终也只转换为增删改查这些基本操作，但是抽象到资源层面，Kubernetes 赋予了资源比较多的操作方法，之前提到过，称之为「Verbs」，分别是 create / delete / deletecollection / patch / update / get / list / watch，我们仍然可以把它们归到增删改查四大类:

增：
* create：Resource Object 创建
删：
* delete：单个 Resource Object 删除
* deletecollection：多个 Resource Objects 删除
改：
* patch：Resource Object 局部字段更新
* update：Resource Object 整体更新
查：
* get：单个 Resource Object 获取
* list：多个 Resource Objects 获取
* watch：Resource Objects 监控



# Resource 与 Namespace

Kubernetes 同样支持 Namespace（命名空间）的概念，可以解决 Resource Object 过多时带来的管理复杂性问题。Namespace 有如下几个特点；
* 每个 Namespace 可以视作「虚拟集群」，即不同的 Namespace 间可以实现隔离；
* 不同的 Namespace 间可以实现跨 Namespace 的通信；
* 可以对不同的用户配置对不同 Namespace 的访问权限；
因此我们知道，Namespace 即可实现资源的隔离，同时有能满足跨 Namespace 的通信，是一个非常灵活的概念，在很多场景下，比如多租户的实现、生产/测试/开发环境的隔离等场景中都会起到重要作用。

# Resource Manifest File 资源对象描述文件
无论是 Kubernetes 的内置资源还是通过 CRD 定义的 Custom Resource，都是通过资源对象描述文件进行 Resource Object 的创建。

Kubernetes 中 Manifest File 可以通过两种格式来定义：YAML 和 JSON，无论格式如何，Manifest File 各个字段都是固定的意义：

* apiVersion：注意这里的 APIVersion 其实指的是 APIGroup/APIVersion，如 Deployment 可以写为 apps/v1，而对于 Pod，因为它属于 Core Group，即无名 Group，因此省略 Group，写为 v1 即可；
* kind：Resource Object 的种类；
* metadata：Resource Object 的元数据信息，常用的包括 name / namespace / labels；
* spec：Resource Object 的期望状态（Desired Status）
* status：Resource Object 的实际状态（Actual Status）