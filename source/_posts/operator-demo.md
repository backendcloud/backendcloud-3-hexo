---
title: workinnprocess - operator-demo
readmore: true
date: 2022-06-14 21:08:01
categories:
tags:
---

这时候有下面几个文件，执行代码生成器根据这几个文件自动生成其他代码
```bash
├── pkg
│   ├── apis
│   │   └── samplecontroller
│   │       ├── register.go
│   │       └── v1alpha1
│   │           ├── doc.go
│   │           ├── register.go
│   │           └── types.go
[developer@localhost sample-controller]$ ./hack/update-codegen.sh 
Generating deepcopy funcs
Generating clientset for samplecontroller:v1alpha1 at k8s.io/sample-controller/pkg/generated/clientset
Generating listers for samplecontroller:v1alpha1 at k8s.io/sample-controller/pkg/generated/listers
Generating informers for samplecontroller:v1alpha1 at k8s.io/sample-controller/pkg/generated/informers
```
执行完上面的脚本会生成generated文件夹和zz_generated.deepcopy.go
```bash
├── pkg
│   ├── apis
│   │   └── samplecontroller
│   │       ├── register.go
│   │       └── v1alpha1
│   │           ├── doc.go
│   │           ├── register.go
│   │           ├── types.go
│   │           └── zz_generated.deepcopy.go
│   ├── generated
│   │   ├── clientset
│   │   │   └── versioned
│   │   │       ├── clientset.go
│   │   │       ├── doc.go
│   │   │       ├── fake
│   │   │       │   ├── clientset_generated.go
│   │   │       │   ├── doc.go
│   │   │       │   └── register.go
│   │   │       ├── scheme
│   │   │       │   ├── doc.go
│   │   │       │   └── register.go
│   │   │       └── typed
│   │   │           └── samplecontroller
│   │   │               └── v1alpha1
│   │   │                   ├── doc.go
│   │   │                   ├── fake
│   │   │                   │   ├── doc.go
│   │   │                   │   ├── fake_foo.go
│   │   │                   │   └── fake_samplecontroller_client.go
│   │   │                   ├── foo.go
│   │   │                   ├── generated_expansion.go
│   │   │                   └── samplecontroller_client.go
│   │   ├── informers
│   │   │   └── externalversions
│   │   │       ├── factory.go
│   │   │       ├── generic.go
│   │   │       ├── internalinterfaces
│   │   │       │   └── factory_interfaces.go
│   │   │       └── samplecontroller
│   │   │           ├── interface.go
│   │   │           └── v1alpha1
│   │   │               ├── foo.go
│   │   │               └── interface.go
│   │   └── listers
│   │       └── samplecontroller
│   │           └── v1alpha1
│   │               ├── expansion_generated.go
│   │               └── foo.go
[developer@localhost sample-controller]$ kubectl create -f artifacts/examples/crd-status-subresource.yaml
customresourcedefinition.apiextensions.k8s.io/foos.samplecontroller.k8s.io created
[developer@localhost sample-controller]$ kubectl create -f artifacts/examples/example-foo.yaml
foo.samplecontroller.k8s.io/example-foo created
[developer@localhost sample-controller]$ kubectl get deployment
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
example-foo   1/1     1            1           13s
[developer@localhost sample-controller]$ kubectl delete -f artifacts/examples/example-foo.yaml
foo.samplecontroller.k8s.io "example-foo" deleted
[developer@localhost sample-controller]$ kubectl delete -f artifacts/examples/crd-status-subresource.yaml
[developer@localhost sample-controller]$ ./sample-controller -kubeconfig=$HOME/.kube/config
I0615 16:44:44.032385   22954 controller.go:115] Setting up event handlers
I0615 16:44:44.032436   22954 controller.go:156] Starting Foo controller
I0615 16:44:44.032439   22954 controller.go:159] Waiting for informer caches to sync
W0615 16:44:44.039201   22954 reflector.go:324] pkg/mod/k8s.io/client-go@v0.0.0-20220613195210-2a9f95519059/tools/cache/reflector.go:167: failed to list *v1alpha1.Foo: the server could not find the requested resource (get foos.samplecontroller.k8s.io)
E0615 16:44:44.039228   22954 reflector.go:138] pkg/mod/k8s.io/client-go@v0.0.0-20220613195210-2a9f95519059/tools/cache/reflector.go:167: Failed to watch *v1alpha1.Foo: failed to list *v1alpha1.Foo: the server could not find the requested resource (get foos.samplecontroller.k8s.io)
W0615 16:44:45.325515   22954 reflector.go:324] pkg/mod/k8s.io/client-go@v0.0.0-20220613195210-2a9f95519059/tools/cache/reflector.go:167: failed to list *v1alpha1.Foo: the server could not find the requested resource (get foos.samplecontroller.k8s.io)
E0615 16:44:45.325540   22954 reflector.go:138] pkg/mod/k8s.io/client-go@v0.0.0-20220613195210-2a9f95519059/tools/cache/reflector.go:167: Failed to watch *v1alpha1.Foo: failed to list *v1alpha1.Foo: the server could not find the requested resource (get foos.samplecontroller.k8s.io)
W0615 16:44:47.991377   22954 reflector.go:324] pkg/mod/k8s.io/client-go@v0.0.0-20220613195210-2a9f95519059/tools/cache/reflector.go:167: failed to list *v1alpha1.Foo: the server could not find the requested resource (get foos.samplecontroller.k8s.io)
E0615 16:44:47.991398   22954 reflector.go:138] pkg/mod/k8s.io/client-go@v0.0.0-20220613195210-2a9f95519059/tools/cache/reflector.go:167: Failed to watch *v1alpha1.Foo: failed to list *v1alpha1.Foo: the server could not find the requested resource (get foos.samplecontroller.k8s.io)
I0615 16:44:52.634670   22954 controller.go:164] Starting workers
I0615 16:44:52.634690   22954 controller.go:170] Started workers
I0615 16:44:55.461059   22954 controller.go:228] Successfully synced 'default/example-foo'
I0615 16:44:55.461486   22954 event.go:294] "Event occurred" object="default/example-foo" fieldPath="" kind="Foo" apiVersion="samplecontroller.k8s.io/v1alpha1" type="Normal" reason="Synced" message="Foo synced successfully"
E0615 16:44:55.477252   22954 controller.go:233] error syncing 'default/example-foo': Operation cannot be fulfilled on foos.samplecontroller.k8s.io "example-foo": the object has been modified; please apply your changes to the latest version and try again, requeuing
I0615 16:44:55.523293   22954 controller.go:228] Successfully synced 'default/example-foo'
I0615 16:44:55.523590   22954 event.go:294] "Event occurred" object="default/example-foo" fieldPath="" kind="Foo" apiVersion="samplecontroller.k8s.io/v1alpha1" type="Normal" reason="Synced" message="Foo synced successfully"
I0615 16:44:55.548737   22954 controller.go:228] Successfully synced 'default/example-foo'
I0615 16:44:55.548870   22954 event.go:294] "Event occurred" object="default/example-foo" fieldPath="" kind="Foo" apiVersion="samplecontroller.k8s.io/v1alpha1" type="Normal" reason="Synced" message="Foo synced successfully"
I0615 16:44:55.556281   22954 controller.go:228] Successfully synced 'default/example-foo'
I0615 16:44:55.556524   22954 event.go:294] "Event occurred" object="default/example-foo" fieldPath="" kind="Foo" apiVersion="samplecontroller.k8s.io/v1alpha1" type="Normal" reason="Synced" message="Foo synced successfully"
I0615 16:45:01.555773   22954 controller.go:228] Successfully synced 'default/example-foo'
I0615 16:45:01.556016   22954 event.go:294] "Event occurred" object="default/example-foo" fieldPath="" kind="Foo" apiVersion="samplecontroller.k8s.io/v1alpha1" type="Normal" reason="Synced" message="Foo synced successfully"
I0615 16:45:01.560986   22954 controller.go:228] Successfully synced 'default/example-foo'
I0615 16:45:01.561069   22954 event.go:294] "Event occurred" object="default/example-foo" fieldPath="" kind="Foo" apiVersion="samplecontroller.k8s.io/v1alpha1" type="Normal" reason="Synced" message="Foo synced successfully"
E0615 16:46:03.596199   22954 reflector.go:138] pkg/mod/k8s.io/client-go@v0.0.0-20220613195210-2a9f95519059/tools/cache/reflector.go:167: Failed to watch *v1alpha1.Foo: the server could not find the requested resource (get foos.samplecontroller.k8s.io)
W0615 16:46:10.417654   22954 reflector.go:324] pkg/mod/k8s.io/client-go@v0.0.0-20220613195210-2a9f95519059/tools/cache/reflector.go:167: failed to list *v1alpha1.Foo: the server could not find the requested resource (get foos.samplecontroller.k8s.io)
E0615 16:46:10.417678   22954 reflector.go:138] pkg/mod/k8s.io/client-go@v0.0.0-20220613195210-2a9f95519059/tools/cache/reflector.go:167: Failed to watch *v1alpha1.Foo: failed to list *v1alpha1.Foo: the server could not find the requested resource (get foos.samplecontroller.k8s.io)
W0615 16:46:25.223027   22954 reflector.go:324] pkg/mod/k8s.io/client-go@v0.0.0-20220613195210-2a9f95519059/tools/cache/reflector.go:167: failed to list *v1alpha1.Foo: the server could not find the requested resource (get foos.samplecontroller.k8s.io)
E0615 16:46:25.223049   22954 reflector.go:138] pkg/mod/k8s.io/client-go@v0.0.0-20220613195210-2a9f95519059/tools/cache/reflector.go:167: Failed to watch *v1alpha1.Foo: failed to list *v1alpha1.Foo: the server could not find the requested resource (get foos.samplecontroller.k8s.io)
```