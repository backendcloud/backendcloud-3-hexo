---
title: client-go 源码分析（4） - ClientSet客户端
readmore: true
date: 2022-11-25 20:24:49
categories: 云原生
tags:
- client-go
---


本篇的主题是客户端ClientSet。ClientSet和DynamicClient的优缺点正好互换。ClientSet只能操作内置的资源对象，DynamicClient不仅可以操作内置的资源对象，也可以操作CRD；ClientSet有类型检查，DynamicClient没有。

下面是一个调用ClientSet，查询default namespace下所有pod的例子：

```go
package main

import (
	"context"
	"fmt"

	apiv1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
)

func main() {
	// 加载kubeconfig文件，生成config对象
	config, err := clientcmd.BuildConfigFromFlags("", "C:\\Users\\hanwei\\config")
	if err != nil {
		panic(err)
	}

	// kubernetes.NewForConfig通过config实例化ClientSet对象
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err)
	}

	//请求core核心资源组v1资源版本下的Pods资源对象
	podClient := clientset.CoreV1().Pods(apiv1.NamespaceDefault)
	// 设置选项
	list, err := podClient.List(context.TODO(), metav1.ListOptions{Limit: 500})
	if err != nil {
		panic(err)
	}

	for _, d := range list.Items {
		fmt.Printf("NAMESPACE: %v \t NAME:%v \t STATUS: %+v\n", d.Namespace, d.Name, d.Status.Phase)
	}
}
```

```bash
GOROOT=C:\go\go1.19 #gosetup
GOPATH=C:\Users\hanwei\go #gosetup
C:\go\go1.19\bin\go.exe build -o C:\Users\hanwei\AppData\Local\Temp\GoLand\___2go_build_lab.exe lab #gosetup
C:\Users\hanwei\AppData\Local\Temp\GoLand\___2go_build_lab.exe
NAMESPACE: default       NAME:cdi-upload-windows-2003-001        STATUS: Running
NAMESPACE: default       NAME:tomcat-deployment-5b689c848f-2jprs         STATUS: Running
NAMESPACE: default       NAME:virt-launcher-bc-2003-0907-001-vkd8f       STATUS: Running
NAMESPACE: default       NAME:virt-launcher-test-sg-111-lc9kf    STATUS: Running
NAMESPACE: default       NAME:virt-launcher-test-sg-v98xt        STATUS: Running
NAMESPACE: default       NAME:virt-launcher-test-vpc-hxkpx       STATUS: Running
NAMESPACE: default       NAME:virt-launcher-vm-centos-jphml      STATUS: Running

Process finished with the exit code 0
```

上面的main方法核心就是这两句：

```go
	//请求core核心资源组v1资源版本下的Pods资源对象
	podClient := clientset.CoreV1().Pods(apiv1.NamespaceDefault)
	// 设置选项
	list, err := podClient.List(context.TODO(), metav1.ListOptions{Limit: 500})
```

main方法中的 clientset.CoreV1() 调用了下面的方法：

```go
func (c *Clientset) CoreV1() corev1.CoreV1Interface {
	return c.coreV1
}
```

上面的代码返回的是corev1客户端，值类型是*corev1.CoreV1Client类型，是corev1.CoreV1Interface接口类型的具体类型。

```go
type PodsGetter interface {
	Pods(namespace string) PodInterface
}
```

```go
func (c *CoreV1Client) Pods(namespace string) PodInterface {
	return newPods(c, namespace)
}
```

上面的代码可以看出CoreV1Client实现了PodsGetter接口的全部方法，clientset.CoreV1().Pods(apiv1.NamespaceDefault)所以会配到PodsGetter接口的Pods方法，再匹配到具体的func (c *CoreV1Client) Pods方法，并传入namespace参数。

newPods 函数会构造pods结构体，并将函数的形参一个是 corev1 客户端 的 RESTClient()方法，就是上篇讲到的restclient客户端，一个是namespace，(c *CoreV1Client, namespace string)分别放进pods结构体的两个属性中。而pods结构体又实现了PodInterface接口的List方法。

main方法中的 clientset.CoreV1().Pods(apiv1.NamespaceDefault) 返回的是PodInterface接口。main方法中的下一句中 podClient.List 实际调用的就是 func (c *pods) List(ctx context.Context, opts metav1.ListOptions) (result *v1.PodList, err error) 方法。

```go
func newPods(c *CoreV1Client, namespace string) *pods {
	return &pods{
		client: c.RESTClient(),
		ns:     namespace,
	}
}
```

```go
type pods struct {
	client rest.Interface
	ns     string
}
```

```go
type PodInterface interface {
	Create(ctx context.Context, pod *v1.Pod, opts metav1.CreateOptions) (*v1.Pod, error)
	Update(ctx context.Context, pod *v1.Pod, opts metav1.UpdateOptions) (*v1.Pod, error)
	UpdateStatus(ctx context.Context, pod *v1.Pod, opts metav1.UpdateOptions) (*v1.Pod, error)
	Delete(ctx context.Context, name string, opts metav1.DeleteOptions) error
	DeleteCollection(ctx context.Context, opts metav1.DeleteOptions, listOpts metav1.ListOptions) error
	Get(ctx context.Context, name string, opts metav1.GetOptions) (*v1.Pod, error)
	List(ctx context.Context, opts metav1.ListOptions) (*v1.PodList, error)
	Watch(ctx context.Context, opts metav1.ListOptions) (watch.Interface, error)
	Patch(ctx context.Context, name string, pt types.PatchType, data []byte, opts metav1.PatchOptions, subresources ...string) (result *v1.Pod, err error)
	Apply(ctx context.Context, pod *corev1.PodApplyConfiguration, opts metav1.ApplyOptions) (result *v1.Pod, err error)
	ApplyStatus(ctx context.Context, pod *corev1.PodApplyConfiguration, opts metav1.ApplyOptions) (result *v1.Pod, err error)
	UpdateEphemeralContainers(ctx context.Context, podName string, pod *v1.Pod, opts metav1.UpdateOptions) (*v1.Pod, error)

	PodExpansion
}
```

```go
func (c *pods) List(ctx context.Context, opts metav1.ListOptions) (result *v1.PodList, err error) {
	var timeout time.Duration
	if opts.TimeoutSeconds != nil {
		timeout = time.Duration(*opts.TimeoutSeconds) * time.Second
	}
	result = &v1.PodList{}
	err = c.client.Get().
		Namespace(c.ns).
		Resource("pods").
		VersionedParams(&opts, scheme.ParameterCodec).
		Timeout(timeout).
		Do(ctx).
		Into(result)
	return
}
```

实际上 func (c *pods) List(ctx context.Context, opts metav1.ListOptions) (result *v1.PodList, err error) 方法就是调用上面讲到的 restclient 客户端。 参考 {% post_link client-go-3 %}