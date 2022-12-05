---
title: client-go 源码分析（4） - ClientSet客户端 和 DynamicClient客户端
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

上面是clientset查询pod list的，下面的删除，创建，都是调用的restclient客户端实现的：

```go
func (c *pods) Delete(ctx context.Context, name string, opts metav1.DeleteOptions) error {
	return c.client.Delete().
		Namespace(c.ns).
		Resource("pods").
		Name(name).
		Body(&opts).
		Do(ctx).
		Error()
}
```

```go
func (c *pods) Create(ctx context.Context, pod *v1.Pod, opts metav1.CreateOptions) (result *v1.Pod, err error) {
	result = &v1.Pod{}
	err = c.client.Post().
		Namespace(c.ns).
		Resource("pods").
		VersionedParams(&opts, scheme.ParameterCodec).
		Body(pod).
		Do(ctx).
		Into(result)
	return
}
```

```go
type Pod struct {
	metav1.TypeMeta `json:",inline"`
	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metav1.ObjectMeta `json:"metadata,omitempty" protobuf:"bytes,1,opt,name=metadata"`

	// Specification of the desired behavior of the pod.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	Spec PodSpec `json:"spec,omitempty" protobuf:"bytes,2,opt,name=spec"`

	// Most recently observed status of the pod.
	// This data may not be up to date.
	// Populated by the system.
	// Read-only.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	Status PodStatus `json:"status,omitempty" protobuf:"bytes,3,opt,name=status"`
}
```

DynamicClient是一种动态客户端，它可以对任意Kubernetes资源进行RESTful操作，包括CRD自定义资源。DynamicClient与ClientSet操作类似，同样封装了RESTClient，同样提供了Create、Update、Delete、Get、List、Watch、Patch等方法。DynamicClient与ClientSet最大的不同之处是，ClientSet仅能访问Kubernetes自带的资源（即客户端集合内的资源），不能直接访问CRD自定义资源。ClientSet需要预先实现每种Resource和Version的操作，其内部的数据都是结构化数据（即已知数据结构）。而DynamicClient内部实现了Unstructured，用于处理非结构化数据结构（即无法提前预知数据结构），这也是DynamicClient能够处理CRD自定义资源的关键。

注意：
* DynamicClient获得的数据都是一个object类型。存的时候是 unstructured
* DynamicClient不是类型安全的，因此在访问CRD自定义资源时需要特别注意。例如，在操作指针不当的情况下可能会导致程序崩溃。

```go
package main

import (
	"context"
	"fmt"

	apiv1 "k8s.io/api/core/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/runtime/schema"
	"k8s.io/client-go/dynamic"
	"k8s.io/client-go/tools/clientcmd"
)

func main() {
	// 加载kubeconfig文件，生成config对象
	config, err := clientcmd.BuildConfigFromFlags("", "C:\\Users\\hanwei\\config")
	if err != nil {
		panic(err)
	}

	// dynamic.NewForConfig函数通过config实例化dynamicClient对象
	dynamicClient, err := dynamic.NewForConfig(config)
	if err != nil {
		panic(err)
	}

	// 通过schema.GroupVersionResource设置请求的资源版本和资源组，设置命名空间和请求参数,得到unstructured.UnstructuredList指针类型的PodList
	gvr := schema.GroupVersionResource{Version: "v1", Resource: "pods"}
	unstructObj, err := dynamicClient.Resource(gvr).Namespace(apiv1.NamespaceDefault).List(context.TODO(), metav1.ListOptions{Limit: 500})
	if err != nil {
		panic(err)
	}

	// 通过runtime.DefaultUnstructuredConverter函数将unstructured.UnstructuredList转为PodList类型
	podList := &corev1.PodList{}
	err = runtime.DefaultUnstructuredConverter.FromUnstructured(unstructObj.UnstructuredContent(), podList)
	if err != nil {
		panic(err)
	}

	for _, d := range podList.Items {
		fmt.Printf("NAMESPACE: %v NAME:%v \t STATUS: %+v\n", d.Namespace, d.Name, d.Status.Phase)
	}
}
```

```bash
GOROOT=C:\go\go1.19 #gosetup
GOPATH=C:\Users\hanwei\go #gosetup
C:\go\go1.19\bin\go.exe build -o C:\Users\hanwei\AppData\Local\Temp\GoLand\___4go_build_lab.exe lab #gosetup
C:\Users\hanwei\AppData\Local\Temp\GoLand\___4go_build_lab.exe
NAMESPACE: default NAME:cdi-upload-windows-2003-001      STATUS: Running
NAMESPACE: default NAME:hp-volume-7lvp4          STATUS: Running
NAMESPACE: default NAME:tomcat-deployment-5b689c848f-2jprs       STATUS: Running
NAMESPACE: default NAME:virt-launcher-bc-2003-0907-001-vkd8f     STATUS: Running
NAMESPACE: default NAME:virt-launcher-test-sg-111-lc9kf          STATUS: Running
NAMESPACE: default NAME:virt-launcher-test-sg-v98xt      STATUS: Running
NAMESPACE: default NAME:virt-launcher-test-snapshot-v-z52fv      STATUS: Running
NAMESPACE: default NAME:virt-launcher-test-vpc-q8rwz     STATUS: Running
NAMESPACE: default NAME:virt-launcher-vm-centos-q5zq5    STATUS: Running

Process finished with the exit code 0
```

和ClientSet客户端一样，调用的ResetClient客户端。不同的是将response body的数据转成非结构化的数据体返回。

```go
func (c *dynamicResourceClient) List(ctx context.Context, opts metav1.ListOptions) (*unstructured.UnstructuredList, error) {
	result := c.client.client.Get().AbsPath(c.makeURLSegments("")...).SpecificallyVersionedParams(&opts, dynamicParameterCodec, versionV1).Do(ctx)
	if err := result.Error(); err != nil {
		return nil, err
	}
	retBytes, err := result.Raw()
	if err != nil {
		return nil, err
	}
	uncastObj, err := runtime.Decode(unstructured.UnstructuredJSONScheme, retBytes)
	if err != nil {
		return nil, err
	}
	if list, ok := uncastObj.(*unstructured.UnstructuredList); ok {
		return list, nil
	}

	list, err := uncastObj.(*unstructured.Unstructured).ToList()
	if err != nil {
		return nil, err
	}
	return list, nil
}
```

在调用 runtime.DefaultUnstructuredConverter.FromUnstructured 将上面的非结构化数据转换成Kubernetes资源对象数据类型（使用encoding/json/Unmarshaler进行转换，若无法通过上述方式转换，用反射机制进行转换）。
