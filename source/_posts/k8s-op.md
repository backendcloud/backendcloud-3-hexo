title: k8s常用操作
date: 2020-05-27 17:32:08
categories:
- 容器
tags:
- k8s
---

# POD创建时指定工作节点主机host上一个dir分配给POD

    # cat cpu-ram-rc.yaml
    apiVersion: v1
    kind: ReplicationController
    metadata:
      name: cpu-ram-demo
    spec:
      replicas: 1
      selector:
        name: cpu-ram-demo
      template:
        metadata:
          labels:
            name: cpu-ram-demo
        spec:
          containers:
          - name: cpu-ram-demo-container
            image: registry.paas/library/nginx:1.15.9
            resources:
              requests:
                memory: "200Mi"
                cpu: "2"
              limits:
                memory: "200Mi"
                cpu: "2"
            volumeMounts:
              - mountPath: /etc/work
                name: host5490
          volumes:
          - hostPath:
                path: /docker_temp
            name: host5490
    # kubectl create -f cpu-ram-rc.yaml
    replicationcontroller/cpu-ram-demo created
    # kubectl get pod|grep cpu-ram-demo
    cpu-ram-demo-qmxf4                          1/1     Running            0          48s
    
    # kubectl exec -it cpu-ram-demo-qmxf4 bash
    root@cpu-ram-demo-qmxf4:/# cd /etc/work/
    root@cpu-ram-demo-qmxf4:/etc/work# ls
    root@cpu-ram-demo-qmxf4:/etc/work#
    
    # cd /docker_temp/
    # ls
    #
    
    在容器中对应的目录新建文件`from_docker`，在host上对应的目录可以查看到；在host对应的目录创建`from_host`，在容器对应的目录可以查看到。
    root@cpu-ram-demo-qmxf4:/etc/work# touch from_docker
    root@cpu-ram-demo-qmxf4:/etc/work# ls
    from_docker
    root@cpu-ram-demo-qmxf4:/etc/work#
    
    # ls
    from_docker
    # touch from_host
    # ls
    from_docker  from_host
    #
    
    root@cpu-ram-demo-qmxf4:/etc/work# ls
    from_docker  from_host
    root@cpu-ram-demo-qmxf4:/etc/work#

若出现故障，POD重生到其他的工作节点POD原挂载到目录里的内容会丢失。

# POD创建时配置存储卷类型为emptyDir

    # cat cpu-ram-rc-emptydir.yaml
    apiVersion: v1
    kind: ReplicationController
    metadata:
      name: cpu-ram-demo
    spec:
      replicas: 1
      selector:
        name: cpu-ram-demo
      template:
        metadata:
          labels:
            name: cpu-ram-demo
        spec:
          containers:
          - name: cpu-ram-demo-container
            image: registry.paas/library/nginx:1.15.9
            resources:
              requests:
                memory: "200Mi"
                cpu: "2"
              limits:
                memory: "200Mi"
                cpu: "2"
            volumeMounts:
              - mountPath: /etc/work
                name: host5490
          volumes:
          - name: host5490
            emptyDir: {}
    # kubectl create -f cpu-ram-rc-emptydir.yaml
    replicationcontroller/cpu-ram-demo created
    # kubectl get pod|grep cpu-ram
    cpu-ram-demo-h8cwf                          1/1     Running            0          32s
    # kubectl describe pod cpu-ram-demo-h8cwf
    Name:               cpu-ram-demo-h8cwf
    Namespace:          default
    Priority:           0
    PriorityClassName:  <none>
    Node:               paasn4/39.135.102.125
    Start Time:         Wed, 27 May 2020 21:08:57 +0800
    Labels:             name=cpu-ram-demo
    Annotations:        <none>
    Status:             Running
    IP:                 10.222.90.218
    Controlled By:      ReplicationController/cpu-ram-demo
    Containers:
      cpu-ram-demo-container:
        Container ID:   docker://0ffc339f7961b71c5db778cbbe7f738c78fdd5b57013e2b43a3ab2d488f463f7
        Image:          registry.paas/library/nginx:1.15.9
        Image ID:       docker-pullable://registry.paas/library/nginx@sha256:082b7224e857035c61eb4a802bfccf8392736953f78a99096acc7e3296739889
        Port:           <none>
        Host Port:      <none>
        State:          Running
          Started:      Wed, 27 May 2020 21:08:59 +0800
        Ready:          True
        Restart Count:  0
        Limits:
          cpu:     2
          memory:  200Mi
        Requests:
          cpu:        2
          memory:     200Mi
        Environment:  <none>
        Mounts:
          /etc/work from host5490 (rw)
          /var/run/secrets/kubernetes.io/serviceaccount from default-token-vc2bx (ro)
    Conditions:
      Type              Status
      Initialized       True
      Ready             True
      ContainersReady   True
      PodScheduled      True
    Volumes:
      host5490:
        Type:    EmptyDir (a temporary directory that shares a pod's lifetime)
        Medium:
      default-token-vc2bx:
        Type:        Secret (a volume populated by a Secret)
        SecretName:  default-token-vc2bx
        Optional:    false
    QoS Class:       Guaranteed
    Node-Selectors:  <none>
    Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                     node.kubernetes.io/unreachable:NoExecute for 300s
    Events:
      Type    Reason     Age        From               Message
      ----    ------     ----       ----               -------
      Normal  Scheduled  68s        default-scheduler  Successfully assigned default/cpu-ram-demo-h8cwf to paasn4
      Normal  Pulled     <invalid>  kubelet, paasn4    Container image "registry.paas/library/nginx:1.15.9" already present on machine
      Normal  Created    <invalid>  kubelet, paasn4    Created container
      Normal  Started    <invalid>  kubelet, paasn4    Started container

若出现故障，POD重生到其他的工作节点POD原挂载到目录里的内容会丢失。



# POD创建时配置sercret

    # echo -n "1f2d1e2e67df" > ./password.txt
    # kubectl create secret generic db-user-pass --from-file=./password.txt
    secret/db-user-pass created
    # cat cpu-ram-rc-secret.yaml
    apiVersion: v1
    kind: ReplicationController
    metadata:
      name: cpu-ram-demo
    spec:
      replicas: 1
      selector:
        name: cpu-ram-demo
      template:
        metadata:
          labels:
            name: cpu-ram-demo
        spec:
          containers:
          - name: cpu-ram-demo-container
            image: registry.paas/library/nginx:1.15.9
            resources:
              requests:
                memory: "200Mi"
                cpu: "2"
              limits:
                memory: "200Mi"
                cpu: "2"
            volumeMounts:
            - name: foo
              mountPath: /etc/foo
              readOnly: true
          volumes:
          - name: foo
            secret:
              secretName: db-user-pass
    # kubectl create -f cpu-ram-rc-secret.yaml
    replicationcontroller/cpu-ram-demo created
    # kubectl get pod|grep cpu-ram
    cpu-ram-demo-bdnpz                          1/1     Running            0          27s
    # kubectl exec -it cpu-ram-demo-bdnpz bash
    root@cpu-ram-demo-bdnpz:/# cd /etc/foo/
    root@cpu-ram-demo-bdnpz:/etc/foo# ls
    password.txt
    root@cpu-ram-demo-bdnpz:/etc/foo# cat password.txt
    1f2d1e2e67dfroot@cpu-ram-demo-bdnpz:/etc/foo#

若出现故障，POD重生到其他的工作节点POD目录里的`password.txt`内容不会丢失。



# POD创建时配置configmap

    # kubectl create configmap special-config --from-literal=special.how=very
    configmap/special-config created
    # cat cpu-ram-rc-configmap.yaml
    apiVersion: v1
    kind: ReplicationController
    metadata:
      name: cpu-ram-demo
    spec:
      replicas: 1
      selector:
        name: cpu-ram-demo
      template:
        metadata:
          labels:
            name: cpu-ram-demo
        spec:
          containers:
          - name: cpu-ram-demo-container
            image: registry.paas/library/nginx:1.15.9
            env:
              - name: SPECIAL_LEVEL_KEY
                valueFrom:
                  configMapKeyRef:
                    name: special-config
                    key: special.how
            resources:
              requests:
                memory: "200Mi"
                cpu: "2"
              limits:
                memory: "200Mi"
                cpu: "2"
    # kubectl create -f cpu-ram-rc-configmap.yaml
    replicationcontroller/cpu-ram-demo created
    # kubectl get pod|grep cpu-ram
    cpu-ram-demo-lhwlc                          1/1     Running            0          36s
    # kubectl exec -it cpu-ram-demo-lhwlc bash
    root@cpu-ram-demo-lhwlc:/# env|grep very
    SPECIAL_LEVEL_KEY=very
    root@cpu-ram-demo-lhwlc:/#

若出现故障，POD重生到其他的工作节点POD环境变量`env`的`SPECIAL_LEVEL_KEY=very`不会丢失。



# pod自动扩缩容

    创建deployment nginx-test和service nginx-test，service暴露端口80
    # kubectl run nginx-test --image=registry.paas/library/nginx:1.15.9 --requests=cpu=20m --expose --port=80
    kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
    service/nginx-test created
    deployment.apps/nginx-test created
    创建hpa（horizontalpodautoscaler），pod数量从1~10，一旦cpu占有率超过5%。就自动进行扩容，若cpu低于5%，就自动进行缩容
    [root@paasm1 ~]# kubectl autoscale deployment nginx-test --cpu-percent=5 --min=1 --max=10
    horizontalpodautoscaler.autoscaling/nginx-test autoscaled
    [root@paasm1 ~]# kubectl get service
    NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
    kubernetes   ClusterIP   10.233.0.1     <none>        443/TCP   26d
    nginx-test   ClusterIP   10.233.28.40   <none>        80/TCP    23s
    加压前
    # kubectl get hpa
    NAME         REFERENCE               TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
    nginx-test   Deployment/nginx-test   0%/5%     1         10        1          104s
    登陆到集群任意一节点对nginx-service进行加压操作
    # while true;do curl 10.233.28.40 >/dev/null 2>&1;done
    加压一段时候后，pod数量从1变成10
    # kubectl get hpa
    NAME         REFERENCE               TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
    nginx-test   Deployment/nginx-test   14%/5%    1         10        10         5m28s
    # kubectl get pod
    NAME                          READY   STATUS    RESTARTS   AGE
    nginx-test-7745fc4958-94msx   1/1     Running   0          3m59s
    nginx-test-7745fc4958-9fvzj   1/1     Running   0          3m43s
    nginx-test-7745fc4958-bfzqt   1/1     Running   0          3m59s
    nginx-test-7745fc4958-bp2hf   1/1     Running   0          4m14s
    nginx-test-7745fc4958-ff7sm   1/1     Running   0          3m59s
    nginx-test-7745fc4958-fsdq5   1/1     Running   0          3m59s
    nginx-test-7745fc4958-mtwkb   1/1     Running   0          3m43s
    nginx-test-7745fc4958-n9kgc   1/1     Running   0          6m13s
    nginx-test-7745fc4958-pzwlg   1/1     Running   0          4m14s
    nginx-test-7745fc4958-x5sw9   1/1     Running   0          4m14s
    停止加压操作，pod数量从10变成1
    # kubectl get hpa
    NAME         REFERENCE               TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
    nginx-test   Deployment/nginx-test   0%/5%     1         10        1          12m
    # kubectl get pod
    NAME                          READY   STATUS    RESTARTS   AGE
    nginx-test-7745fc4958-n9kgc   1/1     Running   0          22m



# 升级和回滚

    # cat pod-30.yaml
    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      name: nginx-test
    #  annotations:
    #    io.kubernetes.cri.untrusted-workload: "true"
    spec:
      replicas: 30
      template:
          metadata:
              labels:
                  app: nginx
          spec:
              containers:
                - name: nginx
                  image: registry.paas/library/nginx:1.13
    创建deployments/nginx-test，有30个pod，nginx的版本是1.13
    # kubectl create -f pod-30.yaml
    deployment.extensions/nginx-test created
    # kubectl get deployment nginx-test
    NAME         READY   UP-TO-DATE   AVAILABLE   AGE
    nginx-test   0/30    30           0           5s
    创建中......
    # kubectl get deployment nginx-test
    NAME         READY   UP-TO-DATE   AVAILABLE   AGE
    nginx-test   7/30    30           7           9s
    创建完成
    # kubectl get deployment nginx-test
    NAME         READY   UP-TO-DATE   AVAILABLE   AGE
    nginx-test   30/30   30           30          19s
    # kubectl get pod|grep nginx-test
    nginx-test-c6fcf8b85-2mhk8                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-4c62c                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-6kx9p                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-78nc6                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-79vfr                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-8l7dc                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-9n7dh                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-bcpj9                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-c9p4h                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-dp8rg                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-dsll8                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-fqcpb                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-fsh8h                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-h6v5l                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-jmtjr                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-krpj9                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-lhdf7                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-lqzgj                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-m6kfp                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-n8ccf                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-r4wrb                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-r72qk                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-rrd7l                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-shvmg                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-tdhz7                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-tlqcv                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-vkrf5                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-vwdtc                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-wdwcc                  1/1     Running            0          43s
    nginx-test-c6fcf8b85-zf4nv                  1/1     Running            0          43s
    # kubectl describe deployment nginx-test
    Name:                   nginx-test
    Namespace:              default
    CreationTimestamp:      Tue, 09 Jun 2020 17:35:32 +0800
    Labels:                 app=nginx
    Annotations:            deployment.kubernetes.io/revision: 1
    Selector:               app=nginx
    Replicas:               30 desired | 30 updated | 30 total | 30 available | 0 unavailable
    StrategyType:           RollingUpdate
    MinReadySeconds:        0
    RollingUpdateStrategy:  1 max unavailable, 1 max surge
    Pod Template:
      Labels:  app=nginx
      Containers:
       nginx:
        Image:        registry.paas/library/nginx:1.13
        Port:         <none>
        Host Port:    <none>
        Environment:  <none>
        Mounts:       <none>
      Volumes:        <none>
    Conditions:
      Type           Status  Reason
      ----           ------  ------
      Available      True    MinimumReplicasAvailable
    OldReplicaSets:  <none>
    NewReplicaSet:   nginx-test-c6fcf8b85 (30/30 replicas created)
    Events:
      Type    Reason             Age   From                   Message
      ----    ------             ----  ----                   -------
      Normal  ScalingReplicaSet  61s   deployment-controller  Scaled up replica set nginx-test-c6fcf8b85 to 30
    执行升级命令
    # kubectl set image deployments nginx-test nginx=registry.paas/library/nginx:1.15.9
    deployment.extensions/nginx-test image updated
    升级中......
    # kubectl get deployments/nginx-test
    NAME         READY   UP-TO-DATE   AVAILABLE   AGE
    nginx-test   29/30   24           29          2m4s
    升级完成，30个pod的nginx版本都升级到1.15.9
    # kubectl get deployments/nginx-test
    NAME         READY   UP-TO-DATE   AVAILABLE   AGE
    nginx-test   30/30   30           30          2m25s
    # kubectl describe deployment nginx-test
    Name:                   nginx-test
    Namespace:              default
    CreationTimestamp:      Tue, 09 Jun 2020 17:35:32 +0800
    Labels:                 app=nginx
    Annotations:            deployment.kubernetes.io/revision: 2
    Selector:               app=nginx
    Replicas:               30 desired | 30 updated | 30 total | 30 available | 0 unavailable
    StrategyType:           RollingUpdate
    MinReadySeconds:        0
    RollingUpdateStrategy:  1 max unavailable, 1 max surge
    Pod Template:
      Labels:  app=nginx
      Containers:
       nginx:
        Image:        registry.paas/library/nginx:1.15.9
        Port:         <none>
        Host Port:    <none>
        Environment:  <none>
        Mounts:       <none>
      Volumes:        <none>
    Conditions:
      Type           Status  Reason
      ----           ------  ------
      Available      True    MinimumReplicasAvailable
    OldReplicaSets:  <none>
    NewReplicaSet:   nginx-test-6db76bdf4d (30/30 replicas created)
    Events:
      Type    Reason             Age                 From                   Message
      ----    ------             ----                ----                   -------
      Normal  ScalingReplicaSet  2m20s               deployment-controller  Scaled up replica set nginx-test-c6fcf8b85 to 30
      Normal  ScalingReplicaSet  48s                 deployment-controller  Scaled up replica set nginx-test-6db76bdf4d to 1
      Normal  ScalingReplicaSet  48s                 deployment-controller  Scaled down replica set nginx-test-c6fcf8b85 to 29
      Normal  ScalingReplicaSet  48s                 deployment-controller  Scaled up replica set nginx-test-6db76bdf4d to 2
      Normal  ScalingReplicaSet  47s                 deployment-controller  Scaled down replica set nginx-test-c6fcf8b85 to 28
      Normal  ScalingReplicaSet  47s                 deployment-controller  Scaled up replica set nginx-test-6db76bdf4d to 3
      Normal  ScalingReplicaSet  46s                 deployment-controller  Scaled down replica set nginx-test-c6fcf8b85 to 27
      Normal  ScalingReplicaSet  46s                 deployment-controller  Scaled up replica set nginx-test-6db76bdf4d to 4
      Normal  ScalingReplicaSet  44s                 deployment-controller  Scaled down replica set nginx-test-c6fcf8b85 to 26
      Normal  ScalingReplicaSet  35s (x16 over 44s)  deployment-controller  (combined from similar events): Scaled down replica set nginx-test-c6fcf8b85 to 18
    执行回滚操作
    # kubectl rollout undo deployments nginx-test
    deployment.extensions/nginx-test rolled back
    回滚中......
    # kubectl get deployments/nginx-test
    NAME         READY   UP-TO-DATE   AVAILABLE   AGE
    nginx-test   29/30   14           29          3m53s
    # kubectl describe deployment nginx-test
    Name:                   nginx-test
    Namespace:              default
    CreationTimestamp:      Tue, 09 Jun 2020 17:35:32 +0800
    Labels:                 app=nginx
    Annotations:            deployment.kubernetes.io/revision: 3
    Selector:               app=nginx
    Replicas:               30 desired | 15 updated | 31 total | 29 available | 2 unavailable
    StrategyType:           RollingUpdate
    MinReadySeconds:        0
    RollingUpdateStrategy:  1 max unavailable, 1 max surge
    Pod Template:
      Labels:  app=nginx
      Containers:
       nginx:
        Image:        registry.paas/library/nginx:1.13
        Port:         <none>
        Host Port:    <none>
        Environment:  <none>
        Mounts:       <none>
      Volumes:        <none>
    Conditions:
      Type           Status  Reason
      ----           ------  ------
      Available      True    MinimumReplicasAvailable
    OldReplicaSets:  nginx-test-6db76bdf4d (15/15 replicas created)
    NewReplicaSet:   nginx-test-c6fcf8b85 (16/16 replicas created)
    Events:
      Type    Reason             Age                     From                   Message
      ----    ------             ----                    ----                   -------
      Normal  ScalingReplicaSet  3m56s                   deployment-controller  Scaled up replica set nginx-test-c6fcf8b85 to 30
      Normal  ScalingReplicaSet  2m24s                   deployment-controller  Scaled up replica set nginx-test-6db76bdf4d to 1
      Normal  ScalingReplicaSet  2m24s                   deployment-controller  Scaled down replica set nginx-test-c6fcf8b85 to 29
      Normal  ScalingReplicaSet  2m24s                   deployment-controller  Scaled up replica set nginx-test-6db76bdf4d to 2
      Normal  ScalingReplicaSet  2m23s                   deployment-controller  Scaled down replica set nginx-test-c6fcf8b85 to 28
      Normal  ScalingReplicaSet  2m23s                   deployment-controller  Scaled up replica set nginx-test-6db76bdf4d to 3
      Normal  ScalingReplicaSet  2m22s                   deployment-controller  Scaled down replica set nginx-test-c6fcf8b85 to 27
      Normal  ScalingReplicaSet  2m22s                   deployment-controller  Scaled up replica set nginx-test-6db76bdf4d to 4
      Normal  ScalingReplicaSet  2m20s                   deployment-controller  Scaled down replica set nginx-test-c6fcf8b85 to 26
      Normal  ScalingReplicaSet  2m11s (x16 over 2m20s)  deployment-controller  (combined from similar events): Scaled down replica set nginx-test-c6fcf8b85 to 18
    回滚完成，30个pod的nginx版本都回滚到1.13
    # kubectl get deployments/nginx-test
    NAME         READY   UP-TO-DATE   AVAILABLE   AGE
    nginx-test   30/30   30           30          4m35s
    # kubectl describe deployment nginx-test
    Name:                   nginx-test
    Namespace:              default
    CreationTimestamp:      Tue, 09 Jun 2020 17:35:32 +0800
    Labels:                 app=nginx
    Annotations:            deployment.kubernetes.io/revision: 3
    Selector:               app=nginx
    Replicas:               30 desired | 30 updated | 30 total | 30 available | 0 unavailable
    StrategyType:           RollingUpdate
    MinReadySeconds:        0
    RollingUpdateStrategy:  1 max unavailable, 1 max surge
    Pod Template:
      Labels:  app=nginx
      Containers:
       nginx:
        Image:        registry.paas/library/nginx:1.13
        Port:         <none>
        Host Port:    <none>
        Environment:  <none>
        Mounts:       <none>
      Volumes:        <none>
    Conditions:
      Type           Status  Reason
      ----           ------  ------
      Available      True    MinimumReplicasAvailable
    OldReplicaSets:  <none>
    NewReplicaSet:   nginx-test-c6fcf8b85 (30/30 replicas created)
    Events:
      Type    Reason             Age                    From                   Message
      ----    ------             ----                   ----                   -------
      Normal  ScalingReplicaSet  4m37s                  deployment-controller  Scaled up replica set nginx-test-c6fcf8b85 to 30
      Normal  ScalingReplicaSet  3m5s                   deployment-controller  Scaled up replica set nginx-test-6db76bdf4d to 1
      Normal  ScalingReplicaSet  3m5s                   deployment-controller  Scaled down replica set nginx-test-c6fcf8b85 to 29
      Normal  ScalingReplicaSet  3m5s                   deployment-controller  Scaled up replica set nginx-test-6db76bdf4d to 2
      Normal  ScalingReplicaSet  3m4s                   deployment-controller  Scaled down replica set nginx-test-c6fcf8b85 to 28
      Normal  ScalingReplicaSet  3m4s                   deployment-controller  Scaled up replica set nginx-test-6db76bdf4d to 3
      Normal  ScalingReplicaSet  3m3s                   deployment-controller  Scaled down replica set nginx-test-c6fcf8b85 to 27
      Normal  ScalingReplicaSet  3m3s                   deployment-controller  Scaled up replica set nginx-test-6db76bdf4d to 4
      Normal  ScalingReplicaSet  3m1s                   deployment-controller  Scaled down replica set nginx-test-c6fcf8b85 to 26
      Normal  ScalingReplicaSet  2m52s (x16 over 3m1s)  deployment-controller  (combined from similar events): Scaled down replica set nginx-test-c6fcf8b85 to 18

