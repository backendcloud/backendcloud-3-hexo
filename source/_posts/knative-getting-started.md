---
title: Knative getting-started
readmore: true
date: 2022-08-25 22:21:18
categories: 云原生
tags:
- Knative
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

# 部署Kubernetes+Knative
```bash
 ⚡ root@centos9  ~  kn quickstart kind
Running Knative Quickstart using Kind
✅ Checking dependencies...
    Kind version is: 0.14.0

☸ Creating Kind cluster...
enabling experimental podman provider
Creating cluster "knative" ...
 ✓ Ensuring node image (kindest/node:v1.24.3) 🖼 
 ✓ Preparing nodes 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️ 
 ✓ Installing CNI 🔌 
 ✓ Installing StorageClass 💾 
 ✓ Waiting ≤ 2m0s for control-plane = Ready ⏳ 
 • Ready after 17s 💚
Set kubectl context to "kind-knative"
You can now use your cluster with:

kubectl cluster-info --context kind-knative

Have a nice day! 👋

🍿 Installing Knative Serving v1.6.0 ...
    CRDs installed...
    Core installed...
    Finished installing Knative Serving
🕸️ Installing Kourier networking layer v1.6.0 ...
    Kourier installed...
    Ingress patched...
    Finished installing Kourier Networking layer
🕸 Configuring Kourier for Kind...
    Kourier service installed...
    Domain DNS set up...
    Finished configuring Kourier
🔥 Installing Knative Eventing v1.6.0 ... 
    CRDs installed...
    Core installed...
    In-memory channel installed...
    Mt-channel broker installed...
    Example broker installed...
    Finished installing Knative Eventing
🚀 Knative install took: 11m31s 
🎉 Now have some fun with Serverless and Event Driven Apps!
 ⚡ root@centos9  ~  kubectl get pod -A
NAMESPACE            NAME                                            READY   STATUS    RESTARTS   AGE
knative-eventing     eventing-controller-5c8967885c-99f8z            1/1     Running   0          5m4s
knative-eventing     eventing-webhook-7f9b5f7d9-w6bfx                1/1     Running   0          5m4s
knative-eventing     imc-controller-7d9b5756cb-5cz2c                 1/1     Running   0          73s
knative-eventing     imc-dispatcher-76665c67df-f6mtx                 1/1     Running   0          73s
knative-eventing     mt-broker-controller-b74d7487c-jvv2d            1/1     Running   0          56s
knative-eventing     mt-broker-filter-545d9f864f-48vzb               1/1     Running   0          56s
knative-eventing     mt-broker-ingress-7655d545f5-5lw4f              1/1     Running   0          56s
knative-serving      activator-c7d578d94-55hqj                       1/1     Running   0          10m
knative-serving      autoscaler-6488988457-jt6xf                     1/1     Running   0          10m
knative-serving      controller-6cff4c9d57-nscsl                     1/1     Running   0          10m
knative-serving      domain-mapping-7598c5f659-gnsl4                 1/1     Running   0          10m
knative-serving      domainmapping-webhook-8c4c9fdc4-697sk           1/1     Running   0          10m
knative-serving      net-kourier-controller-7997b54d46-7vfgq         1/1     Running   0          9m37s
knative-serving      webhook-df8844f6-69nzj                          1/1     Running   0          10m
kourier-system       3scale-kourier-gateway-54f8c78c75-9rn5n         1/1     Running   0          9m37s
kube-system          coredns-6d4b75cb6d-6pcp4                        1/1     Running   0          10m
kube-system          coredns-6d4b75cb6d-b2f2g                        1/1     Running   0          10m
kube-system          etcd-knative-control-plane                      1/1     Running   0          10m
kube-system          kindnet-c4b89                                   1/1     Running   0          10m
kube-system          kube-apiserver-knative-control-plane            1/1     Running   0          10m
kube-system          kube-controller-manager-knative-control-plane   1/1     Running   0          10m
kube-system          kube-proxy-gj8s6                                1/1     Running   0          10m
kube-system          kube-scheduler-knative-control-plane            1/1     Running   0          10m
local-path-storage   local-path-provisioner-6b84c5c67f-fd7k7         1/1     Running   0          10m

```
# Using Knative Serving
## Deploying a Knative Service
```bash
 ⚡ root@centos9  ~/tt  cat hello.yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: hello
spec:
  template:
    spec:
      containers:
        - image: gcr.io/knative-samples/helloworld-go
          ports:
            - containerPort: 8080
          env:
            - name: TARGET
              value: "World"
 ⚡ root@centos9  ~/tt  kubectl apply -f hello.yaml
service.serving.knative.dev/hello created
 ⚡ root@centos9  ~/tt  kubectl get ksvc
NAME    URL                                       LATESTCREATED   LATESTREADY   READY   REASON
hello   http://hello.default.127.0.0.1.sslip.io   hello-00001     hello-00001   True    
```
## Autoscaling
```bash
 ⚡ root@centos9  ~/tt  echo "Accessing URL $(kn service describe hello -o url)"
Accessing URL http://hello.default.127.0.0.1.sslip.io
 ⚡ root@centos9  ~/tt  curl "$(kn service describe hello -o url)"
Hello World!
 ⚡ root@centos9  ~/tt  kubectl get pod -l serving.knative.dev/service=hello -w
NAME                                    READY   STATUS    RESTARTS   AGE
hello-00001-deployment-8cfd5879-zjkm2   2/2     Running   0          75s
hello-00001-deployment-8cfd5879-zjkm2   2/2     Terminating   0          2m3s
hello-00001-deployment-8cfd5879-zjkm2   1/2     Terminating   0          2m30s
hello-00001-deployment-8cfd5879-zjkm2   0/2     Terminating   0          2m34s
hello-00001-deployment-8cfd5879-zjkm2   0/2     Terminating   0          2m34s
hello-00001-deployment-8cfd5879-zjkm2   0/2     Terminating   0          2m34s
```

> 访问过服务过了一小段时间，pod开始缩容。（若在缩容前ping service，reset time。）缩容后，再次ping service，新的pod又起起来了。

```bash
 ⚡ root@centos9  ~  curl "$(kn service describe hello -o url)"

Hello World!
 ⚡ root@centos9  ~/tt  kubectl get pod -l serving.knative.dev/service=hello -w
NAME                                    READY   STATUS    RESTARTS   AGE
hello-00001-deployment-8cfd5879-zjkm2   2/2     Running   0          75s
hello-00001-deployment-8cfd5879-zjkm2   2/2     Terminating   0          2m3s
hello-00001-deployment-8cfd5879-zjkm2   1/2     Terminating   0          2m30s
hello-00001-deployment-8cfd5879-zjkm2   0/2     Terminating   0          2m34s
hello-00001-deployment-8cfd5879-zjkm2   0/2     Terminating   0          2m34s
hello-00001-deployment-8cfd5879-zjkm2   0/2     Terminating   0          2m34s
hello-00001-deployment-8cfd5879-bttrq   0/2     Pending       0          0s
hello-00001-deployment-8cfd5879-bttrq   0/2     Pending       0          0s
hello-00001-deployment-8cfd5879-bttrq   0/2     ContainerCreating   0          0s
hello-00001-deployment-8cfd5879-bttrq   1/2     Running             0          0s
hello-00001-deployment-8cfd5879-bttrq   2/2     Running             0          1s
```

## Traffic splitting

只有1个版本的时候，流量100%进入该版本。update一个新的版本，这时候有两个版本，默认latest版本流量100%，可以通过配置设定不同版本的流量百分比。

```bash
 ⚡ root@centos9  ~/tt  kn revisions list
NAME          SERVICE   TRAFFIC   TAGS   GENERATION   AGE     CONDITIONS   READY   REASON
hello-00001   hello     100%             1            7m39s   3 OK / 4     True    
 ⚡ root@centos9  ~/tt  cat hello.yaml 
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: hello
spec:
  template:
    spec:
      containers:
        - image: gcr.io/knative-samples/helloworld-go
          ports:
            - containerPort: 8080
          env:
            - name: TARGET
              value: "Knative"
 ⚡ root@centos9  ~/tt  kubectl apply -f hello.yaml
service.serving.knative.dev/hello configured
 ⚡ root@centos9  ~/tt  curl "$(kn service describe hello -o url)"
Hello Knative!
 ⚡ root@centos9  ~/tt  kubectl get revisions
NAME          CONFIG NAME   K8S SERVICE NAME   GENERATION   READY   REASON   ACTUAL REPLICAS   DESIRED REPLICAS
hello-00001   hello                            1            True             0                 0
hello-00002   hello                            2            True             1                 1
 ⚡ root@centos9  ~/tt  kn revisions list
NAME          SERVICE   TRAFFIC   TAGS   GENERATION   AGE     CONDITIONS   READY   REASON
hello-00002   hello     100%             2            49s     4 OK / 4     True    
hello-00001   hello                      1            8m45s   3 OK / 4     True    
 ⚡ root@centos9  ~/tt  kkn service update hello \
--traffic hello-00001=50 \
--traffic @latest=50
Updating Service 'hello' in namespace 'default':

  0.017s The Route is still working to reflect the latest desired specification.
  0.035s Waiting for load balancer to be ready
  0.252s Ready to serve.

Service 'hello' with latest revision 'hello-00002' (unchanged) is available at URL:
http://hello.default.127.0.0.1.sslip.io
 ⚡ root@centos9  ~/tt  kn revisions list
NAME          SERVICE   TRAFFIC   TAGS   GENERATION   AGE    CONDITIONS   READY   REASON
hello-00002   hello     50%              2            2m5s   3 OK / 4     True    
hello-00001   hello     50%              1            10m    3 OK / 4     True    
 ⚡ root@centos9  ~/tt  curl "$(kn service describe hello -o url)"
Hello Knative!
 ⚡ root@centos9  ~/tt  curl "$(kn service describe hello -o url)"
Hello World!
 ⚡ root@centos9  ~/tt  curl "$(kn service describe hello -o url)"
Hello World!
 ⚡ root@centos9  ~/tt  curl "$(kn service describe hello -o url)"
Hello World!
 ⚡ root@centos9  ~/tt  curl "$(kn service describe hello -o url)"
Hello Knative!
 ⚡ root@centos9  ~/tt  curl "$(kn service describe hello -o url)"
Hello Knative!
```

> 上面可以看出当两个版本的流量各配置50%后，访问服务被导向的两个版本的概率分别是50%。

# Using Knative Eventing

![](/images/knative-getting-started/20220825223005.png)

| Component|	Basic Definition|
|---|---|
|Source|	A Kubernetes Custom Resource which emits events to the Broker.|
| Broker|	A "hub" for events in your infrastructure; a central location to send events for delivery.|
| Trigger|	Acts as a filter for events entering the broker, can be configured with desired event attributes.|
| Sink|	A destination for events.|

## Using a Knative Service as a source
```bash
 ⚡ root@centos9  ~/tt  cat cloudevents-player.yaml 
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: cloudevents-player
spec:
  template:
    metadata:
      annotations:
        autoscaling.knative.dev/min-scale: "1"
    spec:
      containers:
        - image: ruromero/cloudevents-player:latest
          env:
            - name: BROKER_URL
              value: http://broker-ingress.knative-eventing.svc.cluster.local/default/example-broker
 ⚡ root@centos9  ~/tt  kubectl apply -f cloudevents-player.yaml
service.serving.knative.dev/cloudevents-player created
 ⚡ root@centos9  ~/tt  kubectl get ksvc
NAME                 URL                                                    LATESTCREATED              LATESTREADY                READY   REASON
cloudevents-player   http://cloudevents-player.default.127.0.0.1.sslip.io   cloudevents-player-00001   cloudevents-player-00001   True    
hello                http://hello.default.127.0.0.1.sslip.io                hello-00002                hello-00002                True    
```

浏览器打开cloudevents-player url：

![](/images/knative-getting-started/20220825221108.png)

![](/images/knative-getting-started/20220825221209.png)

## Using Triggers and sinks
```bash
 ⚡ root@centos9  ~/tt  kn trigger create cloudevents-trigger --sink cloudevents-player  --broker example-broker
Trigger 'cloudevents-trigger' successfully created in namespace 'default'.
```

> 创建一个触发器，该触发器从事件源侦听(source) CloudEvents，并将它们放入接收器(sink)(也是 CloudEvents Player 应用程序)中。

![](/images/knative-getting-started/20220825221711.png)