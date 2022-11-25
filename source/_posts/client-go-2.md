---
title: WIProcess-client-go 源码分析（2） - discovery模块：discovery cache
readmore: true
date: 2022-11-25 10:06:45
categories: 云原生
tags:
- client-go

---

DiscoveryClient可以将资源相关信息存储于本地，默认存储位置为～/.kube/cache和～/.kube/http-cache。缓存可以减轻client-go对KubernetesAPI Server的访问压力。默认每10分钟与Kubernetes API Server同步一次，同步周期较长，因为资源组、源版本、资源信息一般很少变动。本地缓存的DiscoveryClient如图5-4所示。DiscoveryClient第一次获取资源组、资源版本、资源信息时，首先会查询本地缓存，如果数据不存在（没有命中）则请求Kubernetes API Server接口（回源），Cache将Kubernetes API Server响应的数据存储在本地一份并返回给DiscoveryClient。当下一次DiscoveryClient再次获取资源信息时，会将数据直接从本地缓存返回（命中）给DiscoveryClient。本地缓存的默认存储周期为10分钟（对应CachedDiscoveryClient 结构体的ttl属性，超时时间）。代码示例如下：

```go
type CachedDiscoveryClient struct {
	delegate discovery.DiscoveryInterface

	// cacheDirectory is the directory where discovery docs are held.  It must be unique per host:port combination to work well.
	cacheDirectory string

	// ttl is how long the cache should be considered valid
	ttl time.Duration

	// mutex protects the variables below
	mutex sync.Mutex

	// ourFiles are all filenames of cache files created by this process
	ourFiles map[string]struct{}
	// invalidated is true if all cache files should be ignored that are not ours (e.g. after Invalidate() was called)
	invalidated bool
	// fresh is true if all used cache files were ours
	fresh bool

	// caching openapi v3 client which wraps the delegate's client
	openapiClient openapi.Client
}

var _ discovery.CachedDiscoveryInterface = &CachedDiscoveryClient{}

// ServerResourcesForGroupVersion returns the supported resources for a group and version.
func (d *CachedDiscoveryClient) ServerResourcesForGroupVersion(groupVersion string) (*metav1.APIResourceList, error) {
	filename := filepath.Join(d.cacheDirectory, groupVersion, "serverresources.json")
	cachedBytes, err := d.getCachedFile(filename)
	// don't fail on errors, we either don't have a file or won't be able to run the cached check. Either way we can fallback.
	if err == nil {
		cachedResources := &metav1.APIResourceList{}
		if err := runtime.DecodeInto(scheme.Codecs.UniversalDecoder(), cachedBytes, cachedResources); err == nil {
			klog.V(10).Infof("returning cached discovery info from %v", filename)
			return cachedResources, nil
		}
	}

	liveResources, err := d.delegate.ServerResourcesForGroupVersion(groupVersion)
	if err != nil {
		klog.V(3).Infof("skipped caching discovery info due to %v", err)
		return liveResources, err
	}
	if liveResources == nil || len(liveResources.APIResources) == 0 {
		klog.V(3).Infof("skipped caching discovery info, no resources found")
		return liveResources, err
	}

	if err := d.writeCachedFile(filename, liveResources); err != nil {
		klog.V(1).Infof("failed to write cache to %v due to %v", filename, err)
	}

	return liveResources, nil
}
```

结构体CachedDiscoveryClient的方法ServerResourcesForGroupVersion，首先读取放在 filepath.Join(d.cacheDirectory, groupVersion, "serverresources.json") 路径下的缓存。

![](/images/client-go-2/2022-11-25-10-12-23.png)

尝试调用k8s.io/apimachinery/pkg/runtime/DecodeInto 对文件读取的内容解码到结构体metav1.APIResourceList中。若解码成功，返回结构体metav1.APIResourceList内容；若解码不成功，继续下面的语句，即d.delegate.ServerResourcesForGroupVersion(groupVersion)，这里用了delegate结构体数据，中文意思是委托，因为使用接口DiscoveryInterface的CachedDiscoveryClient中的ServerResourcesForGroupVersion去读取缓存失败了，需要去kubernetes API实时去取数据了，这件事就委托这个接口DiscoveryInterface去实现多态中的DiscoveryClient中的ServerResourcesForGroupVersion方法取实现。该方法的代码分析参考 {% post_link client-go-1 %}

```go

```

```go

```

