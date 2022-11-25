---
title: client-go 源码分析（3） - rest模块
readmore: true
date: 2022-11-25 18:40:38
categories: 云原生
tags:
- client-go
---

client-go的客户端对象有4个，作用各有不同：

* RESTClient： 是对HTTP Request进行了封装，实现了RESTful风格的API。其他客户端都是在RESTClient基础上的实现。可与用于k8s内置资源和CRD资源
* ClientSet:是对k8s内置资源对象的客户端的集合，默认情况下，不能操作CRD资源，但是通过client-gen代码生成的话，也是可以操作CRD资源的。
* DynamicClient:不仅能对K8S内置资源进行处理，还可以对CRD资源进行处理，不需要client-gen生成代码即可实现。
* DiscoveryClient：用于发现kube-apiserver所支持的资源组、资源版本、资源信息（即Group、Version、Resources）。

本篇的主题restclient，是其他3个的调用对象，关系如下：

![](/images/client-go-3/2022-11-25-14-27-58.png)

下面是一个调用restclient，查询default namespace下所有pod的例子：

```go
package main

import (
	"context"
	"fmt"

	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes/scheme"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
)

func main() {
	// 加载kubeconfig文件，生成config对象
	config, err := clientcmd.BuildConfigFromFlags("", "C:\\Users\\hanwei\\config")

	if err != nil {
		panic(err)
	}
	// 配置API路径和请求的资源组/资源版本信息
	config.APIPath = "api"
	config.GroupVersion = &corev1.SchemeGroupVersion
	config.NegotiatedSerializer = scheme.Codecs

	// 通过rest.RESTClientFor()生成RESTClient对象。 RESTClientFor通过令牌桶算法，有限制的说法。
	restClient, err := rest.RESTClientFor(config)
	if err != nil {
		panic(err)
	}

	// 通过RESTClient构建请求参数，查询default空间下所有pod资源
	result := &corev1.PodList{}
	err = restClient.Get().
		Namespace("default").
		Resource("pods").
		VersionedParams(&metav1.ListOptions{Limit: 500}, scheme.ParameterCodec).
		Do(context.TODO()).
		Into(result)

	if err != nil {
		panic(err)
	}

	for _, d := range result.Items {
		fmt.Printf("NAMESPACE:%v \t NAME: %v \t STATUS: %v\n", d.Namespace, d.Name, d.Status.Phase)
	}
}
```

```bash
GOROOT=C:\go\go1.19 #gosetup
GOPATH=C:\Users\hanwei\go #gosetup
C:\go\go1.19\bin\go.exe build -o C:\Users\hanwei\AppData\Local\Temp\GoLand\___1go_build_lab.exe lab #gosetup
C:\Users\hanwei\AppData\Local\Temp\GoLand\___1go_build_lab.exe
NAMESPACE:default        NAME: cdi-upload-windows-2003-001       STATUS: Running
NAMESPACE:default        NAME: tomcat-deployment-5b689c848f-2jprs        STATUS: Running
NAMESPACE:default        NAME: virt-launcher-bc-2003-0907-001-vkd8f      STATUS: Running
NAMESPACE:default        NAME: virt-launcher-test-sg-111-lc9kf   STATUS: Running
NAMESPACE:default        NAME: virt-launcher-test-sg-v98xt       STATUS: Running
NAMESPACE:default        NAME: virt-launcher-test-vpc-hdnxc      STATUS: Pending
NAMESPACE:default        NAME: virt-launcher-vm-centos-jphml     STATUS: Running

Process finished with the exit code 0
```

main方法分为以下几个步骤：
step 1 加载kubeconfig文件，生成config对象，并充实config对象属性内容。
step 2 用config对象，生成RESTClient对象。
step 3 RESTClient客户端去查询default namespace下所有pod。
step 4 并打印结果。

下面这条语句是上面的main方法最核心的语句，rest请求也是该语句发出的，下面将该条语句分4步（step 3-1，3-2，3-3，3-4）分解说明。

```go
	err = restClient.Get().
		Namespace("default").
		Resource("pods").
		VersionedParams(&metav1.ListOptions{Limit: 500}, scheme.ParameterCodec).
		Do(context.TODO()).
		Into(result)
```

step 3-1 restClient.Get(). 创建结构体Request，并组装结构体Request，比如将Get方法放在结构体Request的verb属性中。

```go
func (c *RESTClient) Get() *Request {
	return c.Verb("GET")
}
```

```go
func (c *RESTClient) Verb(verb string) *Request {
	return NewRequest(c).Verb(verb)
}
```

```go
func (r *Request) Verb(verb string) *Request {
	r.verb = verb
	return r
}
```

step 3-2 Namespace("default").Resource("pods").VersionedParams(&metav1.ListOptions{Limit: 500}, scheme.ParameterCodec). 是链式调用（方法的返回值是该方法的方法接收器本身），用于继续组装结构体Request。

```go
func (r *Request) Namespace(namespace string) *Request {
	if r.err != nil {
		return r
	}
	if r.namespaceSet {
		r.err = fmt.Errorf("namespace already set to %q, cannot change to %q", r.namespace, namespace)
		return r
	}
	if msgs := IsValidPathSegmentName(namespace); len(msgs) != 0 {
		r.err = fmt.Errorf("invalid namespace %q: %v", namespace, msgs)
		return r
	}
	r.namespaceSet = true
	r.namespace = namespace
	return r
}
```

```go
func (r *Request) Resource(resource string) *Request {
	if r.err != nil {
		return r
	}
	if len(r.resource) != 0 {
		r.err = fmt.Errorf("resource already set to %q, cannot change to %q", r.resource, resource)
		return r
	}
	if msgs := IsValidPathSegmentName(resource); len(msgs) != 0 {
		r.err = fmt.Errorf("invalid resource %q: %v", resource, msgs)
		return r
	}
	r.resource = resource
	return r
}
```
 
```go
func (r *Request) VersionedParams(obj runtime.Object, codec runtime.ParameterCodec) *Request {
	return r.SpecificallyVersionedParams(obj, codec, r.c.content.GroupVersion)
}
```

step 3-3 Do(context.TODO()). 执行request rest请求（对Request结构体的属性做了一些验证，并处理了重试动作），并在response收到后执行回调函数 result = r.transformResponse(resp, req) 获得结构体Result。



```go
func (r *Request) Do(ctx context.Context) Result {
	var result Result
	err := r.request(ctx, func(req *http.Request, resp *http.Response) {
		result = r.transformResponse(resp, req)
	})
	if err != nil {
		return Result{err: err}
	}
	if result.err == nil || len(result.body) > 0 {
		metrics.ResponseSize.Observe(ctx, r.verb, r.URL().Host, float64(len(result.body)))
	}
	return result
}
```

```go
func (r *Request) request(ctx context.Context, fn func(*http.Request, *http.Response)) error {
	// Metrics for total request latency
	start := time.Now()
	defer func() {
		metrics.RequestLatency.Observe(ctx, r.verb, r.finalURLTemplate(), time.Since(start))
	}()

	if r.err != nil {
		klog.V(4).Infof("Error in request: %v", r.err)
		return r.err
	}

	if err := r.requestPreflightCheck(); err != nil {
		return err
	}

	client := r.c.Client
	if client == nil {
		client = http.DefaultClient
	}

	// Throttle the first try before setting up the timeout configured on the
	// client. We don't want a throttled client to return timeouts to callers
	// before it makes a single request.
	if err := r.tryThrottle(ctx); err != nil {
		return err
	}

	if r.timeout > 0 {
		var cancel context.CancelFunc
		ctx, cancel = context.WithTimeout(ctx, r.timeout)
		defer cancel()
	}

	isErrRetryableFunc := func(req *http.Request, err error) bool {
		// "Connection reset by peer" or "apiserver is shutting down" are usually a transient errors.
		// Thus in case of "GET" operations, we simply retry it.
		// We are not automatically retrying "write" operations, as they are not idempotent.
		if req.Method != "GET" {
			return false
		}
		// For connection errors and apiserver shutdown errors retry.
		if net.IsConnectionReset(err) || net.IsProbableEOF(err) {
			return true
		}
		return false
	}

	// Right now we make about ten retry attempts if we get a Retry-After response.
	retry := r.retryFn(r.maxRetries)
	for {
		if err := retry.Before(ctx, r); err != nil {
			return retry.WrapPreviousError(err)
		}
		req, err := r.newHTTPRequest(ctx)
		if err != nil {
			return err
		}
		resp, err := client.Do(req)
		updateURLMetrics(ctx, r, resp, err)
		// The value -1 or a value of 0 with a non-nil Body indicates that the length is unknown.
		// https://pkg.go.dev/net/http#Request
		if req.ContentLength >= 0 && !(req.Body != nil && req.ContentLength == 0) {
			metrics.RequestSize.Observe(ctx, r.verb, r.URL().Host, float64(req.ContentLength))
		}
		retry.After(ctx, r, resp, err)

		done := func() bool {
			defer readAndCloseResponseBody(resp)

			// if the server returns an error in err, the response will be nil.
			f := func(req *http.Request, resp *http.Response) {
				if resp == nil {
					return
				}
				fn(req, resp)
			}

			if retry.IsNextRetry(ctx, r, req, resp, err, isErrRetryableFunc) {
				return false
			}

			f(req, resp)
			return true
		}()
		if done {
			return retry.WrapPreviousError(err)
		}
	}
}
```

```go
func (r *Request) transformResponse(resp *http.Response, req *http.Request) Result {
	var body []byte
	if resp.Body != nil {
		data, err := ioutil.ReadAll(resp.Body)
		switch err.(type) {
		case nil:
			body = data
		case http2.StreamError:
			// This is trying to catch the scenario that the server may close the connection when sending the
			// response body. This can be caused by server timeout due to a slow network connection.
			// TODO: Add test for this. Steps may be:
			// 1. client-go (or kubectl) sends a GET request.
			// 2. Apiserver sends back the headers and then part of the body
			// 3. Apiserver closes connection.
			// 4. client-go should catch this and return an error.
			klog.V(2).Infof("Stream error %#v when reading response body, may be caused by closed connection.", err)
			streamErr := fmt.Errorf("stream error when reading response body, may be caused by closed connection. Please retry. Original error: %w", err)
			return Result{
				err: streamErr,
			}
		default:
			klog.Errorf("Unexpected error when reading response body: %v", err)
			unexpectedErr := fmt.Errorf("unexpected error when reading response body. Please retry. Original error: %w", err)
			return Result{
				err: unexpectedErr,
			}
		}
	}

	glogBody("Response Body", body)

	// verify the content type is accurate
	var decoder runtime.Decoder
	contentType := resp.Header.Get("Content-Type")
	if len(contentType) == 0 {
		contentType = r.c.content.ContentType
	}
	if len(contentType) > 0 {
		var err error
		mediaType, params, err := mime.ParseMediaType(contentType)
		if err != nil {
			return Result{err: errors.NewInternalError(err)}
		}
		decoder, err = r.c.content.Negotiator.Decoder(mediaType, params)
		if err != nil {
			// if we fail to negotiate a decoder, treat this as an unstructured error
			switch {
			case resp.StatusCode == http.StatusSwitchingProtocols:
				// no-op, we've been upgraded
			case resp.StatusCode < http.StatusOK || resp.StatusCode > http.StatusPartialContent:
				return Result{err: r.transformUnstructuredResponseError(resp, req, body)}
			}
			return Result{
				body:        body,
				contentType: contentType,
				statusCode:  resp.StatusCode,
				warnings:    handleWarnings(resp.Header, r.warningHandler),
			}
		}
	}

	switch {
	case resp.StatusCode == http.StatusSwitchingProtocols:
		// no-op, we've been upgraded
	case resp.StatusCode < http.StatusOK || resp.StatusCode > http.StatusPartialContent:
		// calculate an unstructured error from the response which the Result object may use if the caller
		// did not return a structured error.
		retryAfter, _ := retryAfterSeconds(resp)
		err := r.newUnstructuredResponseError(body, isTextResponse(resp), resp.StatusCode, req.Method, retryAfter)
		return Result{
			body:        body,
			contentType: contentType,
			statusCode:  resp.StatusCode,
			decoder:     decoder,
			err:         err,
			warnings:    handleWarnings(resp.Header, r.warningHandler),
		}
	}

	return Result{
		body:        body,
		contentType: contentType,
		statusCode:  resp.StatusCode,
		decoder:     decoder,
		warnings:    handleWarnings(resp.Header, r.warningHandler),
	}
}
```

```go
type Result struct {
	body        []byte
	warnings    []net.WarningHeader
	contentType string
	err         error
	statusCode  int

	decoder runtime.Decoder
}
```

step 3-4 Into(result) 将Result结构体解码成类型为&corev1.PodList{}的变量result中去。

```go
func (r Result) Into(obj runtime.Object) error {
	if r.err != nil {
		// Check whether the result has a Status object in the body and prefer that.
		return r.Error()
	}
	if r.decoder == nil {
		return fmt.Errorf("serializer for %s doesn't exist", r.contentType)
	}
	if len(r.body) == 0 {
		return fmt.Errorf("0-length response with status code: %d and content type: %s",
			r.statusCode, r.contentType)
	}

	out, _, err := r.decoder.Decode(r.body, nil, obj)
	if err != nil || out == obj {
		return err
	}
	// if a different object is returned, see if it is Status and avoid double decoding
	// the object.
	switch t := out.(type) {
	case *metav1.Status:
		// any status besides StatusSuccess is considered an error.
		if t.Status != metav1.StatusSuccess {
			return errors.FromObject(t)
		}
	}
	return nil
}
```