---
title: client-go 源码分析（10） - 使用client-go实现一个简单controller的例子
readmore: true
date: 2022-12-16 12:38:33
categories: 云原生
tags:
- client-go
---

下面的example也是client-go官方的例子。通过这个简单的例子正好把之前的源码分析的一个个模块都串起来了。

main方法里构造indexer，queue，informer，从而构造自己的Controller。程序运行过程中 processNextItem方法一直在执行，从限速队列中取出item进行处理。处理方法是syncToStdout，syncToStdout 是控制器的业务逻辑。在此控制器中，业务逻辑只是将有关 pod 的信息打印到 stdout。如果发生错误，简单地返回错误。重试逻辑不应是业务逻辑的一部分。重试逻辑放在单独的方法handleErr中。

```go
/*
Copyright 2017 The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package main

import (
	"flag"
	"fmt"
	"time"

	"k8s.io/klog/v2"

	v1 "k8s.io/api/core/v1"
	meta_v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/fields"
	"k8s.io/apimachinery/pkg/util/runtime"
	"k8s.io/apimachinery/pkg/util/wait"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/cache"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/util/workqueue"
)

// Controller demonstrates how to implement a controller with client-go.
type Controller struct {
	indexer  cache.Indexer
	queue    workqueue.RateLimitingInterface
	informer cache.Controller
}

// NewController creates a new Controller.
func NewController(queue workqueue.RateLimitingInterface, indexer cache.Indexer, informer cache.Controller) *Controller {
	return &Controller{
		informer: informer,
		indexer:  indexer,
		queue:    queue,
	}
}

func (c *Controller) processNextItem() bool {
	// Wait until there is a new item in the working queue
	key, quit := c.queue.Get()
	if quit {
		return false
	}
	// Tell the queue that we are done with processing this key. This unblocks the key for other workers
	// This allows safe parallel processing because two pods with the same key are never processed in
	// parallel.
	defer c.queue.Done(key)

	// Invoke the method containing the business logic
	err := c.syncToStdout(key.(string))
	// Handle the error if something went wrong during the execution of the business logic
	c.handleErr(err, key)
	return true
}

// syncToStdout is the business logic of the controller. In this controller it simply prints
// information about the pod to stdout. In case an error happened, it has to simply return the error.
// The retry logic should not be part of the business logic.
func (c *Controller) syncToStdout(key string) error {
	obj, exists, err := c.indexer.GetByKey(key)
	if err != nil {
		klog.Errorf("Fetching object with key %s from store failed with %v", key, err)
		return err
	}

	if !exists {
		// Below we will warm up our cache with a Pod, so that we will see a delete for one pod
		fmt.Printf("Pod %s does not exist anymore\n", key)
	} else {
		// Note that you also have to check the uid if you have a local controlled resource, which
		// is dependent on the actual instance, to detect that a Pod was recreated with the same name
		fmt.Printf("Sync/Add/Update for Pod %s\n", obj.(*v1.Pod).GetName())
	}
	return nil
}

// handleErr checks if an error happened and makes sure we will retry later.
func (c *Controller) handleErr(err error, key interface{}) {
	if err == nil {
		// Forget about the #AddRateLimited history of the key on every successful synchronization.
		// This ensures that future processing of updates for this key is not delayed because of
		// an outdated error history.
		c.queue.Forget(key)
		return
	}

	// This controller retries 5 times if something goes wrong. After that, it stops trying.
	if c.queue.NumRequeues(key) < 5 {
		klog.Infof("Error syncing pod %v: %v", key, err)

		// Re-enqueue the key rate limited. Based on the rate limiter on the
		// queue and the re-enqueue history, the key will be processed later again.
		c.queue.AddRateLimited(key)
		return
	}

	c.queue.Forget(key)
	// Report to an external entity that, even after several retries, we could not successfully process this key
	runtime.HandleError(err)
	klog.Infof("Dropping pod %q out of the queue: %v", key, err)
}

// Run begins watching and syncing.
func (c *Controller) Run(workers int, stopCh chan struct{}) {
	defer runtime.HandleCrash()

	// Let the workers stop when we are done
	defer c.queue.ShutDown()
	klog.Info("Starting Pod controller")

	go c.informer.Run(stopCh)

	// Wait for all involved caches to be synced, before processing items from the queue is started
	if !cache.WaitForCacheSync(stopCh, c.informer.HasSynced) {
		runtime.HandleError(fmt.Errorf("Timed out waiting for caches to sync"))
		return
	}

	for i := 0; i < workers; i++ {
		go wait.Until(c.runWorker, time.Second, stopCh)
	}

	<-stopCh
	klog.Info("Stopping Pod controller")
}

func (c *Controller) runWorker() {
	for c.processNextItem() {
	}
}

func main() {
	var kubeconfig string = "C:\\Users\\hanwei\\config"
	var master string

	//flag.StringVar(&kubeconfig, "kubeconfig", "", "absolute path to the kubeconfig file")
	flag.StringVar(&master, "master", "", "master url")
	flag.Parse()

	// creates the connection
	config, err := clientcmd.BuildConfigFromFlags(master, kubeconfig)
	if err != nil {
		klog.Fatal(err)
	}

	// creates the clientset
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		klog.Fatal(err)
	}

	// create the pod watcher
	podListWatcher := cache.NewListWatchFromClient(clientset.CoreV1().RESTClient(), "pods", v1.NamespaceDefault, fields.Everything())

	// create the workqueue
	queue := workqueue.NewRateLimitingQueue(workqueue.DefaultControllerRateLimiter())

	// Bind the workqueue to a cache with the help of an informer. This way we make sure that
	// whenever the cache is updated, the pod key is added to the workqueue.
	// Note that when we finally process the item from the workqueue, we might see a newer version
	// of the Pod than the version which was responsible for triggering the update.
	indexer, informer := cache.NewIndexerInformer(podListWatcher, &v1.Pod{}, 0, cache.ResourceEventHandlerFuncs{
		AddFunc: func(obj interface{}) {
			key, err := cache.MetaNamespaceKeyFunc(obj)
			if err == nil {
				queue.Add(key)
			}
		},
		UpdateFunc: func(old interface{}, new interface{}) {
			key, err := cache.MetaNamespaceKeyFunc(new)
			if err == nil {
				queue.Add(key)
			}
		},
		DeleteFunc: func(obj interface{}) {
			// IndexerInformer uses a delta queue, therefore for deletes we have to use this
			// key function.
			key, err := cache.DeletionHandlingMetaNamespaceKeyFunc(obj)
			if err == nil {
				queue.Add(key)
			}
		},
	}, cache.Indexers{})

	controller := NewController(queue, indexer, informer)

	// We can now warm up the cache for initial synchronization.
	// Let's suppose that we knew about a pod "mypod" on our last run, therefore add it to the cache.
	// If this pod is not there anymore, the controller will be notified about the removal after the
	// cache has synchronized.
	indexer.Add(&v1.Pod{
		ObjectMeta: meta_v1.ObjectMeta{
			Name:      "mypod",
			Namespace: v1.NamespaceDefault,
		},
	})

	// Now let's start the controller
	stop := make(chan struct{})
	defer close(stop)
	go controller.Run(1, stop)

	// Wait forever
	select {}
}
```

运行main方法：

```bash
GOROOT=C:\go\go1.19 #gosetup
GOPATH=C:\Users\hanwei\go #gosetup
C:\go\go1.19\bin\go.exe build -o C:\Users\hanwei\AppData\Local\Temp\GoLand\___go_build_k8s_io_client_go_examples_workqueue.exe k8s.io/client-go/examples/workqueue #gosetup
C:\Users\hanwei\AppData\Local\Temp\GoLand\___go_build_k8s_io_client_go_examples_workqueue.exe
I1206 13:33:12.745784   21064 main.go:124] Starting Pod controller
Sync/Add/Update for Pod virt-launcher-bc-2003-0907-001-7cxdn
Sync/Add/Update for Pod virt-launcher-zal-vm-centos-zng7m
Sync/Add/Update for Pod virt-launcher-test-vpc-p2v2v
Sync/Add/Update for Pod virt-launcher-test-sg-vh6gq
Sync/Add/Update for Pod virt-launcher-test-sg-111-g5kc6
Sync/Add/Update for Pod virt-launcher-vm-centos-hc5rc
Sync/Add/Update for Pod virt-launcher-test-vloume-bak-xklt9
Sync/Add/Update for Pod tomcat-deployment-5b689c848f-2jprs
Sync/Add/Update for Pod hp-volume-g8b69
Sync/Add/Update for Pod virt-launcher-test-snapshot-v-lqg7x
Sync/Add/Update for Pod cdi-upload-windows-2003-001
Pod default/mypod does not exist anymore
Sync/Add/Update for Pod virt-launcher-test-vloume-bak-xklt9
Sync/Add/Update for Pod virt-launcher-test-vloume-bak-xklt9
Pod default/virt-launcher-test-vloume-bak-xklt9 does not exist anymore
Sync/Add/Update for Pod virt-launcher-testvm-gd649
Sync/Add/Update for Pod virt-launcher-testvm-gd649
Sync/Add/Update for Pod virt-launcher-testvm-gd649
Sync/Add/Update for Pod virt-launcher-testvm-gd649
Sync/Add/Update for Pod virt-launcher-testvm-gd649
Sync/Add/Update for Pod virt-launcher-testvm-gd649
Sync/Add/Update for Pod virt-launcher-testvm-gd649
Sync/Add/Update for Pod virt-launcher-testvm-gd649
Sync/Add/Update for Pod virt-launcher-testvm-gd649
Sync/Add/Update for Pod virt-launcher-test-vpc-p2v2v
Sync/Add/Update for Pod virt-launcher-test-vpc-p2v2v
Pod default/virt-launcher-test-vpc-p2v2v does not exist anymore
```

```bash
[root@k8s-11 ~]# kubectl get po
NAME                                   READY   STATUS    RESTARTS   AGE
cdi-upload-windows-2003-001            1/1     Running   1          14d
hp-volume-g8b69                        1/1     Running   0          16h
tomcat-deployment-5b689c848f-2jprs     0/1     Error     0          13d
virt-launcher-bc-2003-0907-001-7cxdn   1/1     Running   0          19h
virt-launcher-test-sg-111-g5kc6        1/1     Running   0          19h
virt-launcher-test-sg-vh6gq            1/1     Running   0          19h
virt-launcher-test-snapshot-v-lqg7x    1/1     Running   0          19h
virt-launcher-test-vpc-p2v2v           1/1     Running   0          4m7s
virt-launcher-vm-centos-hc5rc          1/1     Running   0          19h
virt-launcher-zal-vm-centos-zng7m      1/1     Running   0          3h7m
```

增加了一个pod： virt-launcher-testvm-gd649   

```bash
[root@k8s-11 ~]# kubectl get po
NAME                                   READY   STATUS     RESTARTS   AGE
cdi-upload-windows-2003-001            1/1     Running    1          14d
hp-volume-g8b69                        1/1     Running    0          16h
tomcat-deployment-5b689c848f-2jprs     0/1     Error      0          13d
virt-launcher-bc-2003-0907-001-7cxdn   1/1     Running    0          19h
virt-launcher-test-sg-111-g5kc6        1/1     Running    0          19h
virt-launcher-test-sg-vh6gq            1/1     Running    0          19h
virt-launcher-test-snapshot-v-lqg7x    1/1     Running    0          19h
virt-launcher-test-vpc-p2v2v           1/1     Running    0          4m27s
virt-launcher-testvm-gd649             0/2     Init:0/2   0          2s
virt-launcher-vm-centos-hc5rc          1/1     Running    0          19h
virt-launcher-zal-vm-centos-zng7m      1/1     Running    0          3h7m
```

控制台更新以下输出：

```bash
Sync/Add/Update for Pod virt-launcher-testvm-gd649
Sync/Add/Update for Pod virt-launcher-testvm-gd649
```

main方法种创建了podListwatcher，podListWatcher 实际是一个http短连接和一个http长连接：

```go
	// create the pod watcher
	podListWatcher := cache.NewListWatchFromClient(clientset.CoreV1().RESTClient(), "pods", v1.NamespaceDefault, fields.Everything())
```

```go
// NewListWatchFromClient creates a new ListWatch from the specified client, resource, namespace and field selector.
func NewListWatchFromClient(c Getter, resource string, namespace string, fieldSelector fields.Selector) *ListWatch {
	optionsModifier := func(options *metav1.ListOptions) {
		options.FieldSelector = fieldSelector.String()
	}
	return NewFilteredListWatchFromClient(c, resource, namespace, optionsModifier)
}
```

```go
// NewFilteredListWatchFromClient creates a new ListWatch from the specified client, resource, namespace, and option modifier.
// Option modifier is a function takes a ListOptions and modifies the consumed ListOptions. Provide customized modifier function
// to apply modification to ListOptions with a field selector, a label selector, or any other desired options.
func NewFilteredListWatchFromClient(c Getter, resource string, namespace string, optionsModifier func(options *metav1.ListOptions)) *ListWatch {
	listFunc := func(options metav1.ListOptions) (runtime.Object, error) {
		optionsModifier(&options)
		return c.Get().
			Namespace(namespace).
			Resource(resource).
			VersionedParams(&options, metav1.ParameterCodec).
			Do(context.TODO()).
			Get()
	}
	watchFunc := func(options metav1.ListOptions) (watch.Interface, error) {
		options.Watch = true
		optionsModifier(&options)
		return c.Get().
			Namespace(namespace).
			Resource(resource).
			VersionedParams(&options, metav1.ParameterCodec).
			Watch(context.TODO())
	}
	return &ListWatch{ListFunc: listFunc, WatchFunc: watchFunc}
}
```