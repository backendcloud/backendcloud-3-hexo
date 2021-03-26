title: k8s OOMkilled超出内存限制的容器
date: 2020-05-22 13:52:15
categories: 容器
tags:
- k8s
- Kubernetes
- OOMkilled
- privileged

---

运行增大服务器内存压力测试脚本

    #!/bin/bash
    mkdir /tmp/skyfans/memory -p
    mount -t tmpfs -o size=10240M tmpfs /tmp/skyfans/memory
    dd if=/dev/zero of=/tmp/skyfans/memory/block
    sleep 60
    rm /tmp/skyfans/memory/block
    umount /tmp/skyfans/memory
    rmdir /tmp/skyfans/memory

在vm上，服务器上都可以，但是在容器中执行mount时报错：mount: permission denied
需要开启 privileged。
大约在0.6版，privileged被引入docker。
使用该参数，container内的root拥有真正的root权限。
否则，container内的root只是外部的一个普通用户权限。
privileged启动的容器，可以看到很多host上的设备，并且可以执行mount。
甚至允许在docker容器中启动docker容器。
docker解决方法：在docker run启动容器时加上--privileged  如：docker run -v /home/liurizhou/temp:/home/liurizhou/temp --privileged my_images:latest /bin.bash
k8s解决方法：在containers:加上    securityContext:    privileged: true     runAsUser: 0

    apiVersion: v1
    kind: Pod
    metadata:
      name: mem-nginx
    spec:
      containers:
      - name: mem-nginx-container
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
        securityContext:
          privileged: true
          runAsUser: 0
      volumes:
      - hostPath:
            path: /docker_temp
        name: host5490
      nodeSelector:
        disktype: abc

再执行内存加压脚本，mount可以执行。
只要节点有足够的内存资源，那容器就可以使用超过其申请的内存，但是不允许容器使用超过其限制的 资源。如果容器分配了超过限制的内存，这个容器将会被优先结束。如果容器持续使用超过限制的内存， 这个容器就会被终结。如果一个结束的容器允许重启，kubelet就会重启容器。
比如上面的yaml文件中上限是200M，内存加压超过200M后，pod会触发OOMKilled被中止，重新创建一个新的pod。

    [root@paasm1 ~]# kubectl describe pod mem-nginx
    Name:               mem-nginx
    Namespace:          default
    Priority:           0
    PriorityClassName:  <none>
    Node:               paasn3/39.135.102.123
    Start Time:         Thu, 21 May 2020 18:08:50 +0800
    Labels:             <none>
    Annotations:        <none>
    Status:             Running
    IP:                 10.222.72.25
    Containers:
      mem-nginx-container:
        Container ID:   docker://e103444b362d34076290839d0c1ab593e2a79f17d8b373c787f1cb5ab2960942
        Image:          registry.paas/library/nginx:1.15.9
        Image ID:       docker-pullable://registry.paas/library/nginx@sha256:082b7224e857035c61eb4a802bfccf8392736953f78a99096acc7e3296739889
        Port:           <none>
        Host Port:      <none>
        State:          Running
          Started:      Fri, 22 May 2020 11:20:13 +0800
        Last State:     Terminated
          Reason:       OOMKilled
          Exit Code:    0
          Started:      Fri, 22 May 2020 11:12:10 +0800
          Finished:     Fri, 22 May 2020 11:20:11 +0800
        Ready:          True
        Restart Count:  2
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
        Type:          HostPath (bare host directory volume)
        Path:          /docker_temp
        HostPathType:
      default-token-vc2bx:
        Type:        Secret (a volume populated by a Secret)
        SecretName:  default-token-vc2bx
        Optional:    false
    QoS Class:       Guaranteed
    Node-Selectors:  disktype=abc
    Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                     node.kubernetes.io/unreachable:NoExecute for 300s
    Events:
      Type    Reason          Age                 From             Message
      ----    ------          ----                ----             -------
      Normal  SandboxChanged  2m3s (x2 over 10m)  kubelet, paasn3  Pod sandbox changed, it will be killed and re-created.
      Normal  Killing         2m2s (x2 over 10m)  kubelet, paasn3  Killing container with id docker://mem-nginx-container:Need to kill Pod
      Normal  Pulled          2m (x3 over 17h)    kubelet, paasn3  Container image "registry.paas/library/nginx:1.15.9" already present on machine
      Normal  Created         2m (x3 over 17h)    kubelet, paasn3  Created container
      Normal  Started         2m (x3 over 17h)    kubelet, paasn3  Started container

docker ps查看容器，发现`k8s_mem-nginx-container_mem-nginx_default_116a11b8-9b4b-11ea-a000-04bd7053eff0_1`变成了 `k8s_mem-nginx-container_mem-nginx_default_116a11b8-9b4b-11ea-a000-04bd7053eff0_2`


