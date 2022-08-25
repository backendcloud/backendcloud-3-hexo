---
title: k3s-knative-kourier Knative Serving hello-world
readmore: true
date: 2022-08-25 18:12:54
categories: 云原生
tags:
- k3s
- Knative Serving
- Kourier
---

# Since Knative has its own network layer, we need to disable k3s' Traefik during its installation
```bash
[root@centos9 tt]# export KUBECONFIG="/var/lib/rancher/k3s/server/cred/admin.kubeconfig"
[root@centos9 tt]# curl -sfL https://get.k3s.io | sh -s - --disable traefik
[INFO]  Finding release for channel stable
[INFO]  Using v1.24.3+k3s1 as release
[INFO]  Downloading hash https://github.com/k3s-io/k3s/releases/download/v1.24.3+k3s1/sha256sum-amd64.txt
[INFO]  Skipping binary downloaded, installed k3s matches hash
Rancher K3s Common (stable)                                                                                                                                                                                                                 4.1 kB/s | 2.9 kB     00:00    
Package k3s-selinux-1.2-2.el8.noarch is already installed.
Dependencies resolved.
Nothing to do.
Complete!
[INFO]  Skipping /usr/local/bin/kubectl symlink to k3s, command exists in PATH at /usr/bin/kubectl
[INFO]  Skipping /usr/local/bin/crictl symlink to k3s, already exists
[INFO]  Skipping /usr/local/bin/ctr symlink to k3s, already exists
[INFO]  Creating killall script /usr/local/bin/k3s-killall.sh
[INFO]  Creating uninstall script /usr/local/bin/k3s-uninstall.sh
[INFO]  env: Creating environment file /etc/systemd/system/k3s.service.env
[INFO]  systemd: Creating service file /etc/systemd/system/k3s.service
[INFO]  systemd: Enabling k3s unit
Created symlink /etc/systemd/system/multi-user.target.wants/k3s.service → /etc/systemd/system/k3s.service.
[INFO]  systemd: Starting k3s
```
# 正在删除traefik
```bash
[root@centos9 ~]# kubectl get pod -A
NAMESPACE     NAME                                      READY   STATUS              RESTARTS   AGE
kube-system   local-path-provisioner-7b7dc8d6f5-qxscd   1/1     Running             0          57m
kube-system   svclb-traefik-089ff14b-pf7b9              2/2     Running             0          56m
kube-system   coredns-b96499967-x277m                   1/1     Running             0          57m
kube-system   metrics-server-668d979685-k7wl7           1/1     Running             0          57m
kube-system   traefik-7cd4fcff68-ddr6q                  1/1     Running             0          56m
kube-system   helm-delete-traefik-98xsn                 0/1     ContainerCreating   0          0s
kube-system   helm-delete-traefik-crd-85kx9             0/1     ContainerCreating   0          0s
```

# Install Knative Serving
```bash
[root@centos9 tt]# export KNATIVE_VERSION="1.7.1"
[root@centos9 tt]# kubectl apply --filename "https://github.com/knative/serving/releases/download/v$KNATIVE_VERSION/serving-crds.yaml"
error: unable to read URL "https://github.com/knative/serving/releases/download/v1.7.1/serving-crds.yaml", server reported 404 Not Found, status code=404
[root@centos9 tt]# kubectl apply --filename "https://github.com/knative/serving/releases/download/knative-v$KNATIVE_VERSION/serving-crds.yaml"
customresourcedefinition.apiextensions.k8s.io/certificates.networking.internal.knative.dev created
customresourcedefinition.apiextensions.k8s.io/configurations.serving.knative.dev created
customresourcedefinition.apiextensions.k8s.io/clusterdomainclaims.networking.internal.knative.dev created
customresourcedefinition.apiextensions.k8s.io/domainmappings.serving.knative.dev created
customresourcedefinition.apiextensions.k8s.io/ingresses.networking.internal.knative.dev created
customresourcedefinition.apiextensions.k8s.io/metrics.autoscaling.internal.knative.dev created
customresourcedefinition.apiextensions.k8s.io/podautoscalers.autoscaling.internal.knative.dev created
customresourcedefinition.apiextensions.k8s.io/revisions.serving.knative.dev created
customresourcedefinition.apiextensions.k8s.io/routes.serving.knative.dev created
customresourcedefinition.apiextensions.k8s.io/serverlessservices.networking.internal.knative.dev created
customresourcedefinition.apiextensions.k8s.io/services.serving.knative.dev created
customresourcedefinition.apiextensions.k8s.io/images.caching.internal.knative.dev created
[root@centos9 tt]# kubectl apply --filename "https://github.com/knative/serving/releases/download/knative-v$KNATIVE_VERSION/serving-core.yaml"
namespace/knative-serving created
clusterrole.rbac.authorization.k8s.io/knative-serving-aggregated-addressable-resolver created
clusterrole.rbac.authorization.k8s.io/knative-serving-addressable-resolver created
clusterrole.rbac.authorization.k8s.io/knative-serving-namespaced-admin created
clusterrole.rbac.authorization.k8s.io/knative-serving-namespaced-edit created
clusterrole.rbac.authorization.k8s.io/knative-serving-namespaced-view created
clusterrole.rbac.authorization.k8s.io/knative-serving-core created
clusterrole.rbac.authorization.k8s.io/knative-serving-podspecable-binding created
serviceaccount/controller created
clusterrole.rbac.authorization.k8s.io/knative-serving-admin created
clusterrolebinding.rbac.authorization.k8s.io/knative-serving-controller-admin created
clusterrolebinding.rbac.authorization.k8s.io/knative-serving-controller-addressable-resolver created
customresourcedefinition.apiextensions.k8s.io/images.caching.internal.knative.dev unchanged
customresourcedefinition.apiextensions.k8s.io/certificates.networking.internal.knative.dev unchanged
customresourcedefinition.apiextensions.k8s.io/configurations.serving.knative.dev unchanged
customresourcedefinition.apiextensions.k8s.io/clusterdomainclaims.networking.internal.knative.dev unchanged
customresourcedefinition.apiextensions.k8s.io/domainmappings.serving.knative.dev unchanged
customresourcedefinition.apiextensions.k8s.io/ingresses.networking.internal.knative.dev unchanged
customresourcedefinition.apiextensions.k8s.io/metrics.autoscaling.internal.knative.dev unchanged
customresourcedefinition.apiextensions.k8s.io/podautoscalers.autoscaling.internal.knative.dev unchanged
customresourcedefinition.apiextensions.k8s.io/revisions.serving.knative.dev unchanged
customresourcedefinition.apiextensions.k8s.io/routes.serving.knative.dev unchanged
customresourcedefinition.apiextensions.k8s.io/serverlessservices.networking.internal.knative.dev unchanged
customresourcedefinition.apiextensions.k8s.io/services.serving.knative.dev unchanged
secret/serving-certs-ctrl-ca created
secret/knative-serving-certs created
image.caching.internal.knative.dev/queue-proxy created
configmap/config-autoscaler created
configmap/config-defaults created
configmap/config-deployment created
configmap/config-domain created
configmap/config-features created
configmap/config-gc created
configmap/config-leader-election created
configmap/config-logging created
configmap/config-network created
configmap/config-observability created
configmap/config-tracing created
Warning: autoscaling/v2beta2 HorizontalPodAutoscaler is deprecated in v1.23+, unavailable in v1.26+; use autoscaling/v2 HorizontalPodAutoscaler
horizontalpodautoscaler.autoscaling/activator created
poddisruptionbudget.policy/activator-pdb created
deployment.apps/activator created
service/activator-service created
deployment.apps/autoscaler created
service/autoscaler created
deployment.apps/controller created
service/controller created
deployment.apps/domain-mapping created
deployment.apps/domainmapping-webhook created
service/domainmapping-webhook created
horizontalpodautoscaler.autoscaling/webhook created
poddisruptionbudget.policy/webhook-pdb created
deployment.apps/webhook created
service/webhook created
validatingwebhookconfiguration.admissionregistration.k8s.io/config.webhook.serving.knative.dev created
mutatingwebhookconfiguration.admissionregistration.k8s.io/webhook.serving.knative.dev created
mutatingwebhookconfiguration.admissionregistration.k8s.io/webhook.domainmapping.serving.knative.dev created
secret/domainmapping-webhook-certs created
validatingwebhookconfiguration.admissionregistration.k8s.io/validation.webhook.domainmapping.serving.knative.dev created
validatingwebhookconfiguration.admissionregistration.k8s.io/validation.webhook.serving.knative.dev created
secret/webhook-certs created
[root@centos9 tt]# kubectl apply --filename "https://github.com/knative/serving/releases/download/knative-v$KNATIVE_VERSION/serving-default-domain.yaml"
job.batch/default-domain created
service/default-domain-service created
```

# Install and configure Kourier
```bash
[root@centos9 tt]# kubectl apply --filename https://raw.githubusercontent.com/knative/serving/knative-v$KNATIVE_VERSION/third_party/kourier-latest/kourier.yaml
namespace/kourier-system created
configmap/kourier-bootstrap created
configmap/config-kourier created
serviceaccount/net-kourier created
clusterrole.rbac.authorization.k8s.io/net-kourier created
clusterrolebinding.rbac.authorization.k8s.io/net-kourier created
deployment.apps/net-kourier-controller created
service/net-kourier-controller created
deployment.apps/3scale-kourier-gateway created
service/kourier created
service/kourier-internal created
[root@centos9 tt]# kubectl patch configmap/config-network --namespace knative-serving --type merge --patch '{"data":{"ingress.class":"kourier.ingress.networking.knative.dev"}}'
configmap/config-network patched
```

# 检查k3s+knative+kourier pod运行状态
```bash
[root@centos9 tt]# kubectl get pod -A
NAMESPACE         NAME                                      READY   STATUS    RESTARTS   AGE
kube-system       local-path-provisioner-7b7dc8d6f5-qxscd   1/1     Running   0          67m
kube-system       coredns-b96499967-x277m                   1/1     Running   0          67m
kube-system       metrics-server-668d979685-k7wl7           1/1     Running   0          67m
knative-serving   domain-mapping-6cdd967788-t7nb7           1/1     Running   0          3m52s
knative-serving   autoscaler-69c94fb9c7-lhsx9               1/1     Running   0          3m52s
knative-serving   webhook-69db94fb79-w966n                  1/1     Running   0          3m52s
knative-serving   controller-59bb6bbfc-xstvl                1/1     Running   0          3m52s
knative-serving   domainmapping-webhook-986ddd5c7-b7q4g     1/1     Running   0          3m52s
knative-serving   activator-77df89764b-gnqbw                1/1     Running   0          3m52s
knative-serving   default-domain-dpp5x                      1/1     Running   0          3m9s
kube-system       svclb-kourier-1a1ccd02-lkf4t              2/2     Running   0          2m36s
knative-serving   net-kourier-controller-79f5b774c5-zsw4q   1/1     Running   0          2m36s
kourier-system    3scale-kourier-gateway-54f8c78c75-d74g6   1/1     Running   0          2m36s
[root@centos9 tt]# kubectl get svc kourier -n kourier-system
NAME      TYPE           CLUSTER-IP      EXTERNAL-IP       PORT(S)                      AGE
kourier   LoadBalancer   10.43.136.237   192.168.190.130   80:32512/TCP,443:31765/TCP   2m42s
```

# 制作knative serving helloworld-go 镜像，部署和测试

## helloworld-go golang代码
```bash
[root@centos9 tt]# git clone https://github.com/knative/docs.git knative-docs
Cloning into 'knative-docs'...
remote: Enumerating objects: 39528, done.
remote: Counting objects: 100% (30/30), done.
remote: Compressing objects: 100% (29/29), done.
remote: Total 39528 (delta 6), reused 2 (delta 1), pack-reused 39498
Receiving objects: 100% (39528/39528), 65.81 MiB | 10.04 MiB/s, done.
Resolving deltas: 100% (25518/25518), done.
[root@centos9 tt]# cd knative-docs/code-samples/serving/hello-world/helloworld-go
[root@centos9 helloworld-go]# cat helloworld.go 
package main

import (
        "fmt"
        "log"
        "net/http"
        "os"
)

func handler(w http.ResponseWriter, r *http.Request) {
        log.Print("helloworld: received a request")
        target := os.Getenv("TARGET")
        if target == "" {
                target = "World"
        }
        fmt.Fprintf(w, "Hello %s!\n", target)
}

func main() {
        log.Print("helloworld: starting server...")

        http.HandleFunc("/", handler)

        port := os.Getenv("PORT")
        if port == "" {
                port = "8080"
        }

        log.Printf("helloworld: listening on port %s", port)
        log.Fatal(http.ListenAndServe(fmt.Sprintf(":%s", port), nil))
}
```

## 制作镜像并上传docker hub
```bash
[root@centos9 helloworld-go]# cat Dockerfile 
# Use the official Golang image to create a build artifact.
# This is based on Debian and sets the GOPATH to /go.
FROM golang:1.13 as builder

# Create and change to the app directory.
WORKDIR /app

# Retrieve application dependencies using go modules.
# Allows container builds to reuse downloaded dependencies.
COPY go.* ./
RUN go mod download

# Copy local code to the container image.
COPY . ./

# Build the binary.
# -mod=readonly ensures immutable go.mod and go.sum in container builds.
RUN CGO_ENABLED=0 GOOS=linux go build -mod=readonly -v -o server

# Use the official Alpine image for a lean production container.
# https://hub.docker.com/_/alpine
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM alpine:3
RUN apk add --no-cache ca-certificates

# Copy the binary to the production image from the builder stage.
COPY --from=builder /app/server /server

# Run the web service on container startup.
CMD ["/server"]
[root@centos9 helloworld-go]# docker build -t docker.io/backendcloud/helloworld-go .
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
[1/2] STEP 1/6: FROM golang:1.13 AS builder

Error: error creating build container: ^C
[root@centos9 helloworld-go]# docker build -t backendcloud/helloworld-go .
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
[1/2] STEP 1/6: FROM golang:1.13 AS builder
✔ docker.io/library/golang:1.13
Trying to pull docker.io/library/golang:1.13...
Getting image source signatures
Copying blob 799f41bb59c9 done  
Copying blob c958d65b3090 done  
Copying blob 80931cf68816 done  
Copying blob edaf0a6b092f done  
Copying blob 813643441356 done  
Copying blob d6ff36c9ec48 done  
Copying blob 16b5038bccc8 done  
Copying config d6f3656320 done  
Writing manifest to image destination
Storing signatures
[1/2] STEP 2/6: WORKDIR /app
--> 828a2d7681c
[1/2] STEP 3/6: COPY go.* ./
--> 8d8c9e35cb3
[1/2] STEP 4/6: RUN go mod download
--> cd50b410496
[1/2] STEP 5/6: COPY . ./
--> 3d4eedb7c9e
[1/2] STEP 6/6: RUN CGO_ENABLED=0 GOOS=linux go build -mod=readonly -v -o server
net
vendor/golang.org/x/net/http/httpproxy
crypto/x509
net/textproto
vendor/golang.org/x/net/http/httpguts
crypto/tls
net/http/httptrace
net/http
github.com/knative/docs/code-samples/serving/hello-world/helloworld-go
--> afeac0749bd
[2/2] STEP 1/4: FROM alpine:3
Resolved "alpine" as an alias (/etc/containers/registries.conf.d/000-shortnames.conf)
Trying to pull docker.io/library/alpine:3...
Getting image source signatures
Copying blob 213ec9aee27d skipped: already exists  
Copying config 9c6f072447 done  
Writing manifest to image destination
Storing signatures
[2/2] STEP 2/4: RUN apk add --no-cache ca-certificates
fetch https://dl-cdn.alpinelinux.org/alpine/v3.16/main/x86_64/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.16/community/x86_64/APKINDEX.tar.gz
(1/1) Installing ca-certificates (20220614-r0)
Executing busybox-1.35.0-r17.trigger
Executing ca-certificates-20220614-r0.trigger
OK: 6 MiB in 15 packages
--> adb2f939cdc
[2/2] STEP 3/4: COPY --from=builder /app/server /server
--> 4aa9c1e09b8
[2/2] STEP 4/4: CMD ["/server"]
[2/2] COMMIT backendcloud/helloworld-go
--> e00e007c551
Successfully tagged localhost/backendcloud/helloworld-go:latest
e00e007c551b1090b8f316b6b0f3a45d74c73e9a3d90de59ec15780519e60ae9
[root@centos9 helloworld-go]# docker push backendcloud/helloworld-go
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Getting image source signatures
Error: trying to reuse blob sha256:994393dc58e7931862558d06e46aa2bb17487044f670f310dffe1d24e4d1eec7 at destination: checking whether a blob sha256:994393dc58e7931862558d06e46aa2bb17487044f670f310dffe1d24e4d1eec7 exists in docker.io/backendcloud/helloworld-go: errors:
denied: requested access to the resource is denied
error parsing HTTP 401 response body: unexpected end of JSON input: ""

[root@centos9 helloworld-go]# docker push backendcloud/helloworld-go
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
Getting image source signatures
Copying blob 91c5703324e6 done  
Copying blob 3ace8d3a0355 done  
Copying blob 213ec9aee27d skipped: already exists  
Copying config e00e007c55 done  
WARN[0047] Failed, retrying in 1s ... (1/3). Error: writing blob: Patch "https://registry-1.docker.io/v2/backendcloud/helloworld-go/blobs/uploads/37839a47-df43-4484-b274-9a94ec038784?_state=30VxOFN44VyS0C4KuomnYUMIsohRppkAUPAxy-7VSWB7Ik5hbWUiOiJiYWNrZW5kY2xvdWQvaGVsbG93b3JsZC1nbyIsIlVVSUQiOiIzNzgzOWE0Ny1kZjQzLTQ0ODQtYjI3NC05YTk0ZWMwMzg3ODQiLCJPZmZzZXQiOjAsIlN0YXJ0ZWRBdCI6IjIwMjItMDgtMjVUMDg6MzA6MzguMTQ1NDcxNzgzWiJ9": EOF 
Getting image source signatures
Copying blob 779b7f9a0d7e skipped: already exists  
Copying blob 105575cd9027 skipped: already exists  
Copying blob 213ec9aee27d skipped: already exists  
Copying config e00e007c55 done  
Writing manifest to image destination
Storing signatures
```

## 部署 helloworld-go 微服务 并 测试
```bash
[root@centos9 helloworld-go]# cat service.yaml 
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: helloworld-go
  namespace: default
spec:
  template:
    spec:
      containers:
        - image: docker.io/backendcloud/helloworld-go
          env:
            - name: TARGET
              value: "Go Sample v1"
[root@centos9 helloworld-go]# kubectl apply -f service.yaml 
service.serving.knative.dev/helloworld-go created
[root@centos9 helloworld-go]# kubectl get ksvc helloworld-go
NAME            URL                                                     LATESTCREATED         LATESTREADY           READY   REASON
helloworld-go   http://helloworld-go.default.192.168.190.130.sslip.io   helloworld-go-00001   helloworld-go-00001   True    
[root@centos9 helloworld-go]# kubectl get ksvc helloworld-go  --output=custom-columns=NAME:.metadata.name,URL:.status.url
NAME            URL
helloworld-go   http://helloworld-go.default.192.168.190.130.sslip.io
[root@centos9 helloworld-go]# curl http://helloworld-go.default.192.168.190.130.sslip.io
Hello Go Sample v1!
```

