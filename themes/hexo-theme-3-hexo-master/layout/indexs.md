# 后端云网站专注领域

* 云原生基础设施生态：Kubernetes，KubeVirt，Istio。
* 云原生生态：Spin，Dapr，KEDA，Knative。
* DevOps(Bazel，ArgoCD，DroneCI，Tekton，Cloud Native Buildpacks，Shipwright)。
* Rust生态(侧重OS，VMM，虚拟机，容器底层)。
* Fuchsia生态。


# 后端云分享的免费内容包括但不限于
* [English version of the website https://www.backendcloud.cn/](https://backendcloud.github.io/)后端云网站英文版。
* [后端云网站](https://www.backendcloud.cn/)发布的文章以及“后端云”微信公众号（二维码见底部）。这两个平台是我亲自打理的，其他平台，比如腾讯云开发者社区“后端云”专栏是机器同步后社区管理员排版，比如知乎，简书，微博都是纯机器同步的，排版略差。体验感是：后端云网站 > 微信公众号 > 腾讯云开发者社区“后端云”专栏 > 知乎，简书，微博
* [后端云发布的视频] work in process 。。。
* 后端云发布的免费书籍
  * [《KubeVirt CI》](https://book.backendcloud.cn/kubevirt-ci-book/) work in process 。。。已完成24篇
  * [《Bazel在企业项目中的应用》](https://book.backendcloud.cn/bazel-book/) work in process 。。。已完成15篇
  * [《KubeVirt源码分析》](https://book.backendcloud.cn/kubevirt-book/) work in process 。。。已完成16篇
  * [《client-go源码分析》](https://book.backendcloud.cn/client-go-book/) 18篇
  * [《Moby(Docker)源码分析》] work in process 。。。
  * [《Kubernetes源码分析》] work in process 。。。
* 后端云发布的开源项目
  * 开源项目[backendcloud](https://github.com/backendcloud)（后端云网站[内容](https://github.com/backendcloud/backendcloud.github.io)和[源码](https://github.com/backendcloud/backendcloud-3-hexo)以及网站[CI](https://github.com/backendcloud/backendcloud-3-hexo/blob/master/.github/workflows/ci.yml)和[CD](https://github.com/backendcloud/backendcloud.github.io/blob/master/.github/workflows/cd.yml)的存放仓库，以及文章里的example代码的存放仓库）
  * 开源项目[KubeFusion](https://github.com/kubefusion)（该Github账号下的主项目KubeFusion是包含多种云原生技术的融合和集成定制以及KubeFusion自身特有功能（无侵入修改，后续可以随着上游项目升级而升级），其他项目是主项目的关联小项目。在筹备中，2023年上半年发布KubeFusion v0.1版）

> **背景：**
> * 互联网大潮期间，一种说法：应用开发者可能三成时间开发业务，七成时间折腾服务器；
> * 云计算大潮期间，服务器资源虚拟化后成为云服务商集中提供的服务，帮应用开发者解决了服务器的维护时间，不用去折腾服务器设备，网络设备，存储设备，折腾操作系统，开发者除了开发业务，只需要折腾应用的环境配置，这时候资源是动态按需的（横向纵向扩缩容），但是还不是高度动态的，还是需要按照云服务的资源（算力存储网络资源）配置进行收费，成本并没有显著降低，资源闲置还是普遍。因为成本问题云服务商不希望你一直动态变来变去，所以会把按量收费定的很高，大多数场景都是静态的配置，这样收费最低。只有少量的突发场景比如节日高峰场景才会去动态扩缩容；
> * 云原生，FaaS，BaaS大潮期间，开发者只需要关注开发业务，这时候的资源是高度动态，真正的按资源的使用量来付费，没在使用不会收取任何费用，没在使用不会消耗任何资源，这样使得成本和效率有质的飞跃，所以必然是大势所趋。
> 
> **KubeFusion参考的开源项目：**
> * 云原生基础设施生态：Kubernetes（网络插件：Multus，Flannel，Calico，userspace-cni，Cilium（Cilium基于高性能的eBPF（相对于iptables的netfilter），Cilium可以替换kube-proxy，Cilium和Istio结合））） + KubeVirt + service mesh（linkerd2 和 Istio（Istio含Envoy）二选一，linkerd2轻量，Istio功能更完备））
> * Assembly，Serverless，FaaS生态：（focus on business and everything else is a headache of a cloud provider）（下一代微服务框架spin）（Dapr+KEDA 和 Knative serving+event 二选一，Dapr+KEDA优于Knative serving+event）(Tekton，Cloud Native Buildpacks，Shipwright)






[//]: # (This may be the most platform independent comment)



# 后端云网站快捷键使用说明

快捷键为vim风格的。按键可能与vimium（chrome插件）的快捷键有冲突，插件设置屏蔽掉此站的快捷键即可。

## 全局

| Key | Descption                 |
| --- |---------------------------|
| s/S | 全屏/取消全屏                   |
| w/W | **`文章列表 和 具体一篇文章目录 间切换`** |
| i/I | 获取搜索框焦点                   |
| j/J | 向下滑动                      |
| k/K | 向上滑动                      |
| gg/GG | 到最顶端                      |
| shift+G/g | 到最下端                      |

* **`w/W | 文章列表 和 具体一篇文章目录 间切换`** 是PC端浏览多级标题文章时必不可少的功能


## 搜索框

| Key | Descption |
| --- | --- |
| ESC | 1.如果输入框有内容，清除内容 |
|     | 2.如果输入框无内容，失去焦点 |
| 下 | 向下选择文章 |
| 上 | 向上选择文章 |
| 回车 | 打开当前选中的文章，若没有，则默认打开第一个 |



# 联系方式
* 可在后端云公众号直接留言
* ✉ **[backendcloud@gmail.com](mailto:backendcloud@gmail.com)**


<hr>

> 风险须知：有些文章慎看，看了慎用，可以把一周的工作量缩短到三分钟，可能会导致您工作不饱满而被老板炒鱿鱼。
