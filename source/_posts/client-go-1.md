---
title: client-go 源码分析（1） - discovery模块：discoveryclient获取所有的gv和gvr
readmore: false
date: 2022-11-24 12:21:32
categories: 云原生
tags:
- client-go
---

本篇是client-go源码分析的第一篇，client-go是从事Kubernetes开发必研究的项目，client-go之所以重要，主要在以下几个方面：
* 是调用Kubernetes API的唯一的golang官方库。比如常用到的命令行工具kubectl项目就是通过client-go和Kubernetes API打交道。
* 在Kubernetes源码中，如果Kubernetes的某个组件，需要List/Get Kubernetes中的Object，在绝大多 数情况下，会直接使用client-go中的Informer实例中的Lister()方法（该方法包含 了 Get 和 List 方法），而很少直接请求Kubernetes API。
* 用operator sdk开发自己的crd和custom controller开发，必须要用到的golang库，因为kubernetes易扩展的架构设计，只要是基于kubernetes二次开发的项目，基本都要开发自己定制的crd和controller。


本篇从相对简单的discovery包开始：

![](/images/client-go-1/2022-11-24-13-55-08.png)


discovery包的主要作用就是提供当前k8s集群支持哪些资源以及版本信息。

Kubernetes API Server暴露出/api和/apis接口。DiscoveryClient通过RESTClient分别请求/api和/apis接口，从而获取Kubernetes API Server所支持的资源组、资源版信息。这个是通过ServerGroups函数实现的，有了group, version信息后，但是还是不够，因为还没有具体到资源。ServerGroupsAndResources 就获得了所有的资源信息（所有的GVR资源信息），而在Resource资源的定义中，会定义好该资源支持哪些操作：list, delelte ,get等等。

所以kubectl中就使用discovery做了资源的校验。获取所有资源的版本信息，以及支持的操作。就可以判断客户端当前操作是否合理。

先上调用discovery包获取所有gv和gvr信息的代码：

```go
package main

import (
	"fmt"

	"k8s.io/apimachinery/pkg/runtime/schema"
	"k8s.io/client-go/discovery"
	"k8s.io/client-go/tools/clientcmd"
)

func main() {
	// 加载kubeconfig文件，生成config对象
	config, err := clientcmd.BuildConfigFromFlags("", "C:\\Users\\hanwei\\config")
	if err != nil {
		panic(err)
	}

	// discovery.NewDiscoveryClientForConfigg函数通过config实例化discoveryClient对象
	discoveryClient, err := discovery.NewDiscoveryClientForConfig(config)
	if err != nil {
		panic(err)
	}

	// discoveryClient.ServerGroupsAndResources 返回API Server所支持的资源组、资源版本、资源信息
	_, APIResourceList, err := discoveryClient.ServerGroupsAndResources()
	if err != nil {
		panic(err)
	}

	// 输出所有资源信息
	for _, list := range APIResourceList {
		gv, err := schema.ParseGroupVersion(list.GroupVersion)
		if err != nil {
			panic(err)
		}

		for _, resource := range list.APIResources {
			fmt.Printf("NAME: %v, GROUP: %v, VERSION: %v \n", resource.Name, gv.Group, gv.Version)
		}
	}
}
```

```bash
OROOT=C:\go\go1.19 #gosetup
GOPATH=C:\Users\hanwei\go #gosetup
C:\go\go1.19\bin\go.exe build -o C:\Users\hanwei\AppData\Local\Temp\GoLand\___go_build_main_go.exe C:\Users\hanwei\Documents\GoProject\lab\lab01\main.go #gosetup
C:\Users\hanwei\AppData\Local\Temp\GoLand\___go_build_main_go.exe
... // 省略
NAME: pods, GROUP: , VERSION: v1
NAME: pods/attach, GROUP: , VERSION: v1
NAME: pods/binding, GROUP: , VERSION: v1
NAME: pods/eviction, GROUP: , VERSION: v1
NAME: pods/exec, GROUP: , VERSION: v1
NAME: pods/log, GROUP: , VERSION: v1
NAME: pods/portforward, GROUP: , VERSION: v1
NAME: pods/proxy, GROUP: , VERSION: v1
NAME: pods/status, GROUP: , VERSION: v1
NAME: challenges/status, GROUP: acme.cert-manager.io, VERSION: v1
NAME: cephbucketnotifications, GROUP: ceph.rook.io, VERSION: v1
NAME: cephbucketnotifications/status, GROUP: ceph.rook.io, VERSION: v1
NAME: cephnfses, GROUP: ceph.rook.io, VERSION: v1
NAME: cephnfses/status, GROUP: ceph.rook.io, VERSION: v1
NAME: cephfilesystemsubvolumegroups, GROUP: ceph.rook.io, VERSION: v1
NAME: cephfilesystemsubvolumegroups/status, GROUP: ceph.rook.io, VERSION: v1
NAME: cephfilesystemmirrors, GROUP: ceph.rook.io, VERSION: v1
NAME: cephfilesystemmirrors/status, GROUP: ceph.rook.io, VERSION: v1
NAME: cephblockpools, GROUP: ceph.rook.io, VERSION: v1
NAME: cephblockpools/status, GROUP: ceph.rook.io, VERSION: v1
NAME: cephobjectstores, GROUP: ceph.rook.io, VERSION: v1
NAME: cephobjectstores/status, GROUP: ceph.rook.io, VERSION: v1
NAME: cephclusters, GROUP: ceph.rook.io, VERSION: v1
NAME: cephclusters/status, GROUP: ceph.rook.io, VERSION: v1
NAME: cephobjectzones, GROUP: ceph.rook.io, VERSION: v1
NAME: cephobjectzones/status, GROUP: ceph.rook.io, VERSION: v1
NAME: cephrbdmirrors, GROUP: ceph.rook.io, VERSION: v1
NAME: cephrbdmirrors/status, GROUP: ceph.rook.io, VERSION: v1
NAME: cephblockpoolradosnamespaces, GROUP: ceph.rook.io, VERSION: v1
NAME: cephblockpoolradosnamespaces/status, GROUP: ceph.rook.io, VERSION: v1
NAME: cephobjectrealms, GROUP: ceph.rook.io, VERSION: v1
NAME: cephobjectrealms/status, GROUP: ceph.rook.io, VERSION: v1
NAME: cephclients, GROUP: ceph.rook.io, VERSION: v1
NAME: cephclients/status, GROUP: ceph.rook.io, VERSION: v1
NAME: cephobjectstoreusers, GROUP: ceph.rook.io, VERSION: v1
NAME: cephobjectstoreusers/status, GROUP: ceph.rook.io, VERSION: v1
NAME: cephfilesystems, GROUP: ceph.rook.io, VERSION: v1
NAME: cephfilesystems/status, GROUP: ceph.rook.io, VERSION: v1
NAME: cephobjectzonegroups, GROUP: ceph.rook.io, VERSION: v1
NAME: cephobjectzonegroups/status, GROUP: ceph.rook.io, VERSION: v1
NAME: cephbuckettopics, GROUP: ceph.rook.io, VERSION: v1
NAME: cephbuckettopics/status, GROUP: ceph.rook.io, VERSION: v1
NAME: virtualmachineinstancereplicasets, GROUP: kubevirt.io, VERSION: v1
NAME: virtualmachineinstancereplicasets/status, GROUP: kubevirt.io, VERSION: v1
NAME: virtualmachineinstancereplicasets/scale, GROUP: kubevirt.io, VERSION: v1
NAME: virtualmachineinstancepresets, GROUP: kubevirt.io, VERSION: v1
NAME: virtualmachineinstancemigrations, GROUP: kubevirt.io, VERSION: v1
NAME: virtualmachineinstancemigrations/status, GROUP: kubevirt.io, VERSION: v1
NAME: kubevirts, GROUP: kubevirt.io, VERSION: v1
NAME: kubevirts/status, GROUP: kubevirt.io, VERSION: v1
NAME: virtualmachineinstances, GROUP: kubevirt.io, VERSION: v1
NAME: virtualmachines, GROUP: kubevirt.io, VERSION: v1
NAME: virtualmachines/status, GROUP: kubevirt.io, VERSION: v1
NAME: virtualmachineinstancereplicasets, GROUP: kubevirt.io, VERSION: v1alpha3
NAME: virtualmachineinstancereplicasets/status, GROUP: kubevirt.io, VERSION: v1alpha3
NAME: virtualmachineinstancereplicasets/scale, GROUP: kubevirt.io, VERSION: v1alpha3
NAME: virtualmachineinstancepresets, GROUP: kubevirt.io, VERSION: v1alpha3
NAME: virtualmachineinstancemigrations, GROUP: kubevirt.io, VERSION: v1alpha3
NAME: virtualmachineinstancemigrations/status, GROUP: kubevirt.io, VERSION: v1alpha3
NAME: kubevirts, GROUP: kubevirt.io, VERSION: v1alpha3
NAME: kubevirts/status, GROUP: kubevirt.io, VERSION: v1alpha3
NAME: virtualmachineinstances, GROUP: kubevirt.io, VERSION: v1alpha3
NAME: virtualmachines, GROUP: kubevirt.io, VERSION: v1alpha3
NAME: virtualmachines/status, GROUP: kubevirt.io, VERSION: v1alpha3
... // 省略

Process finished with the exit code 0
```

kubectl api-resources 和 kubectl api-versions 这两条命令也是调用的该discover包。

```bash
[root@k8s-11 .kube]# kubectl |grep api
  api-resources Print the supported API resources on the server
  api-versions  Print the supported API versions on the server, in the form of "group/version"
```

上面的main方法，分为4步：

step1：clientcmd.BuildConfigFromFlags 函数返回 config对象，这里用了kubeconfig的本地路径。

step2：discovery.NewDiscoveryClientForConfig 函数返回 DiscoveryClient对象。

```go
func BuildConfigFromFlags(masterUrl, kubeconfigPath string) (*restclient.Config, error) {
	if kubeconfigPath == "" && masterUrl == "" {
		klog.Warning("Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.  This might not work.")
		kubeconfig, err := restclient.InClusterConfig()
		if err == nil {
			return kubeconfig, nil
		}
		klog.Warning("error creating inClusterConfig, falling back to default config: ", err)
	}
	return NewNonInteractiveDeferredLoadingClientConfig(
		&ClientConfigLoadingRules{ExplicitPath: kubeconfigPath},
		&ConfigOverrides{ClusterInfo: clientcmdapi.Cluster{Server: masterUrl}}).ClientConfig()
}
```

```go
func NewDiscoveryClientForConfig(c *restclient.Config) (*DiscoveryClient, error) {
	config := *c
	if err := setDiscoveryDefaults(&config); err != nil {
		return nil, err
	}
	httpClient, err := restclient.HTTPClientFor(&config)
	if err != nil {
		return nil, err
	}
	return NewDiscoveryClientForConfigAndClient(&config, httpClient)
}
```

step3：discoveryClient.ServerGroupsAndResources 函数相对绕一点。

```go
func (d *DiscoveryClient) ServerGroupsAndResources() ([]*metav1.APIGroup, []*metav1.APIResourceList, error) {
	return withRetries(defaultRetries, func() ([]*metav1.APIGroup, []*metav1.APIResourceList, error) {
		return ServerGroupsAndResources(d)
	})
}
```

withRetries 函数 多次尝试执行 函数 ServerGroupsAndResources(d DiscoveryInterface) ([]*metav1.APIGroup, []*metav1.APIResourceList, error) ，该函数的形式参数是interface，用到了golang中的多态。因为实参是结构体DiscoveryClient，所以多态会调用DiscoveryClient下对应的具体方法。

```go
func ServerGroupsAndResources(d DiscoveryInterface) ([]*metav1.APIGroup, []*metav1.APIResourceList, error) {
	sgs, err := d.ServerGroups()
	if sgs == nil {
		return nil, nil, err
	}
	resultGroups := []*metav1.APIGroup{}
	for i := range sgs.Groups {
		resultGroups = append(resultGroups, &sgs.Groups[i])
	}

	groupVersionResources, failedGroups := fetchGroupVersionResources(d, sgs)

	// order results by group/version discovery order
	result := []*metav1.APIResourceList{}
	for _, apiGroup := range sgs.Groups {
		for _, version := range apiGroup.Versions {
			gv := schema.GroupVersion{Group: apiGroup.Name, Version: version.Version}
			if resources, ok := groupVersionResources[gv]; ok {
				result = append(result, resources)
			}
		}
	}

	if len(failedGroups) == 0 {
		return resultGroups, result, nil
	}

	return resultGroups, result, &ErrGroupDiscoveryFailed{Groups: failedGroups}
}
```

ServerGroupsAndResources(d DiscoveryInterface) ([]*metav1.APIGroup, []*metav1.APIResourceList, error) 主要就是 调用了 d.ServerGroups() 以及 fetchGroupVersionResources(d, sgs) 两个方法，分别获取group信息和resource信息。

```go
type ServerGroupsInterface interface {
	// ServerGroups returns the supported groups, with information like supported versions and the
	// preferred version.
	ServerGroups() (*metav1.APIGroupList, error)
}
```

```go
func (d *DiscoveryClient) ServerGroups() (apiGroupList *metav1.APIGroupList, err error) {
	// Get the groupVersions exposed at /api
	v := &metav1.APIVersions{}
	err = d.restClient.Get().AbsPath(d.LegacyPrefix).Do(context.TODO()).Into(v)
	apiGroup := metav1.APIGroup{}
	if err == nil && len(v.Versions) != 0 {
		apiGroup = apiVersionsToAPIGroup(v)
	}
	if err != nil && !errors.IsNotFound(err) && !errors.IsForbidden(err) {
		return nil, err
	}

	// Get the groupVersions exposed at /apis
	apiGroupList = &metav1.APIGroupList{}
	err = d.restClient.Get().AbsPath("/apis").Do(context.TODO()).Into(apiGroupList)
	if err != nil && !errors.IsNotFound(err) && !errors.IsForbidden(err) {
		return nil, err
	}
	// to be compatible with a v1.0 server, if it's a 403 or 404, ignore and return whatever we got from /api
	if err != nil && (errors.IsNotFound(err) || errors.IsForbidden(err)) {
		apiGroupList = &metav1.APIGroupList{}
	}

	// prepend the group retrieved from /api to the list if not empty
	if len(v.Versions) != 0 {
		apiGroupList.Groups = append([]metav1.APIGroup{apiGroup}, apiGroupList.Groups...)
	}
	return apiGroupList, nil
}
```

func (d *DiscoveryClient) ServerGroups() (apiGroupList *metav1.APIGroupList, err error) 调用restClient Get方法访问Kubernetes API，获取apiGroup信息，调用了两次，分别是历史遗留的/api接口，对应corev1，还有就是有gv具体名称的/apis接口。

```go
func fetchGroupVersionResources(d DiscoveryInterface, apiGroups *metav1.APIGroupList) (map[schema.GroupVersion]*metav1.APIResourceList, map[schema.GroupVersion]error) {
	groupVersionResources := make(map[schema.GroupVersion]*metav1.APIResourceList)
	failedGroups := make(map[schema.GroupVersion]error)

	wg := &sync.WaitGroup{}
	resultLock := &sync.Mutex{}
	for _, apiGroup := range apiGroups.Groups {
		for _, version := range apiGroup.Versions {
			groupVersion := schema.GroupVersion{Group: apiGroup.Name, Version: version.Version}
			wg.Add(1)
			go func() {
				defer wg.Done()
				defer utilruntime.HandleCrash()

				apiResourceList, err := d.ServerResourcesForGroupVersion(groupVersion.String())

				// lock to record results
				resultLock.Lock()
				defer resultLock.Unlock()

				if err != nil {
					// TODO: maybe restrict this to NotFound errors
					failedGroups[groupVersion] = err
				}
				if apiResourceList != nil {
					// even in case of error, some fallback might have been returned
					groupVersionResources[groupVersion] = apiResourceList
				}
			}()
		}
	}
	wg.Wait()

	return groupVersionResources, failedGroups
}
```

```go
func (d *DiscoveryClient) ServerResourcesForGroupVersion(groupVersion string) (resources *metav1.APIResourceList, err error) {
	url := url.URL{}
	if len(groupVersion) == 0 {
		return nil, fmt.Errorf("groupVersion shouldn't be empty")
	}
	if len(d.LegacyPrefix) > 0 && groupVersion == "v1" {
		url.Path = d.LegacyPrefix + "/" + groupVersion
	} else {
		url.Path = "/apis/" + groupVersion
	}
	resources = &metav1.APIResourceList{
		GroupVersion: groupVersion,
	}
	err = d.restClient.Get().AbsPath(url.String()).Do(context.TODO()).Into(resources)
	if err != nil {
		// ignore 403 or 404 error to be compatible with an v1.0 server.
		if groupVersion == "v1" && (errors.IsNotFound(err) || errors.IsForbidden(err)) {
			return resources, nil
		}
		return nil, err
	}
	return resources, nil
}
```

因为获取gv对应的resouce信息需要每一个gv都需要发送一个rest请求，大量rest请求比较耗时，为了加快速度，fetchGroupVersionResources 方法采取go协程同时并发的方式发送rest api请求。

step4：最后将查到的变量APIResourceList通过两层for循环输出所有的resouce信息。