循序渐进理解Kubernetes网络系列
* 基础知识：linux网桥，linux路由
* docker网络，pod网络
* flannel
* calico
* flannel结合calico
* multus cni
* kube-ovn
* cni设计结构
* sr-iov（硬件透传给pod）
* dpdk

循序渐进理解Kubernetes运行时系列
cri
image
除非临时测试下，否则不要用latest，用latest的具体版本号，因为latest是会变的，有新版本发布latest指向的版本会发生变化。
即使latest版本一直固定，但是Kubernetes的pod.container.imagePullPolicy默认值，对于latest会每次生成pod都会去镜像仓库下载，有版本号的默认值是本地没有才会去镜像仓库下载。

循序渐进理解Kubernetes存储系列
csi
cinder-csi-plugin