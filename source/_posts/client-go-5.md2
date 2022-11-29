---
title: WIProcess-client-go-5
readmore: true
date: 2022-11-28 18:06:20
categories: 云原生
tags:
- client-go
---


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
C:\go\go1.19\bin\go.exe build -o C:\Users\hanwei\AppData\Local\Temp\GoLand\___2go_build_lab.exe lab #gosetup
C:\Users\hanwei\AppData\Local\Temp\GoLand\___2go_build_lab.exe
NAMESPACE: default NAME:cdi-upload-windows-2003-001      STATUS: Running
NAMESPACE: default NAME:tomcat-deployment-5b689c848f-2jprs       STATUS: Running
NAMESPACE: default NAME:virt-launcher-bc-2003-0907-001-vkd8f     STATUS: Running
NAMESPACE: default NAME:virt-launcher-test-sg-111-lc9kf          STATUS: Running
NAMESPACE: default NAME:virt-launcher-test-sg-v98xt      STATUS: Running
NAMESPACE: default NAME:virt-launcher-vm-centos-jphml    STATUS: Running

Process finished with the exit code 0
```

```go

```