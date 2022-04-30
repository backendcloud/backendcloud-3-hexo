---
title: 部署 cinder-csi-plugin 遇到的几个问题
categories: 云原生
tags:
  - cinder-csi-plugin
  - minikube
  - cinder
  - Openstack
  - Kubernetes
date: 2022-04-24 11:00:11
---

# 连不上keystone: 为部分 Pod 添加自定义域名解析
keystone url用了域名，需要在/etc/hosts添加域名解析
![](/images/fusion-dev-env1/00f23ba4.png)

如果有部分 Pod 对特定的域名解析有依赖，在不希望配置 dns 解析的情况下，可以使用 K8S 提供的 hostAliases 来为部分工作负载添加 hosts:

    spec:
      hostAliases:
      - hostnames: [ "harbor.example.com" ]
        ip: "10.10.10.10"

添加后在容器内可以看到 hosts 被添加到了 /etc/hosts 中:

    $ cat /etc/hosts
    ...
    # Entries added by HostAliases.
    10.10.10.10	harboar.example.com

```bash
[developer@localhost ~]$ kubectl logs csi-cinder-nodeplugin-t8hcx -nkube-system -c cinder-csi-plugin
I0424 11:10:56.531843       1 driver.go:73] Driver: cinder.csi.openstack.org
I0424 11:10:56.531889       1 driver.go:74] Driver version: 1.3.2@latest
I0424 11:10:56.531892       1 driver.go:75] CSI Spec version: 1.3.0
I0424 11:10:56.531898       1 driver.go:104] Enabling controller service capability: LIST_VOLUMES
I0424 11:10:56.531900       1 driver.go:104] Enabling controller service capability: CREATE_DELETE_VOLUME
I0424 11:10:56.531907       1 driver.go:104] Enabling controller service capability: PUBLISH_UNPUBLISH_VOLUME
I0424 11:10:56.531909       1 driver.go:104] Enabling controller service capability: CREATE_DELETE_SNAPSHOT
I0424 11:10:56.531911       1 driver.go:104] Enabling controller service capability: LIST_SNAPSHOTS
I0424 11:10:56.531913       1 driver.go:104] Enabling controller service capability: EXPAND_VOLUME
I0424 11:10:56.531915       1 driver.go:104] Enabling controller service capability: CLONE_VOLUME
I0424 11:10:56.531917       1 driver.go:104] Enabling controller service capability: LIST_VOLUMES_PUBLISHED_NODES
I0424 11:10:56.531919       1 driver.go:116] Enabling volume access mode: SINGLE_NODE_WRITER
I0424 11:10:56.531920       1 driver.go:126] Enabling node service capability: STAGE_UNSTAGE_VOLUME
I0424 11:10:56.531923       1 driver.go:126] Enabling node service capability: EXPAND_VOLUME
I0424 11:10:56.531928       1 driver.go:126] Enabling node service capability: GET_VOLUME_STATS
I0424 11:10:56.532069       1 openstack.go:90] Block storage opts: {0 false false}
I0424 11:10:57.181982       1 server.go:108] Listening for connections on address: &net.UnixAddr{Name:"/csi/csi.sock", Net:"unix"}
E0424 11:10:58.771149       1 utils.go:85] GRPC error: rpc error: code = Internal desc = [NodeGetInfo] unable to retrieve instance id of node error fetching http://169.254.169.254/openstack/latest/meta_data.json: Get "http://169.254.169.254/openstack/latest/meta_data.json": dial tcp 169.254.169.254:80: connect: connection refused
E0424 11:11:00.768432       1 utils.go:85] GRPC error: rpc error: code = Internal desc = [NodeGetInfo] unable to retrieve instance id of node error fetching http://169.254.169.254/openstack/latest/meta_data.json: Get "http://169.254.169.254/openstack/latest/meta_data.json": dial tcp 169.254.169.254:80: connect: connection refused
E0424 11:11:13.787632       1 utils.go:85] GRPC error: rpc error: code = Internal desc = [NodeGetInfo] unable to retrieve instance id of node error fetching http://169.254.169.254/openstack/latest/meta_data.json: Get "http://169.254.169.254/openstack/latest/meta_data.json": dial tcp 169.254.169.254:80: connect: connection refused
```
metadata服务没起来
> https://github.com/kubernetes/cloud-provider-openstack/issues/1127

# devstack重启后，cinder创建卷报错

> https://www.codetd.com/en/article/13087314

# cinder-csi-plugin node服务没起来
```bash
  Normal   Provisioning          3m32s (x9 over 7m47s)  cinder.csi.openstack.org_csi-cinder-controllerplugin-667d467bf6-qfsnn_90ee191a-788a-4cda-82f2-eb61f37b20f5  External provisioner is provisioning volume for claim "default/csi-pvc-cinderplugin"
  Warning  ProvisioningFailed    3m32s (x9 over 7m47s)  cinder.csi.openstack.org_csi-cinder-controllerplugin-667d467bf6-qfsnn_90ee191a-788a-4cda-82f2-eb61f37b20f5  failed to provision volume with StorageClass "csi-sc-cinderplugin": error generating accessibility requirements: no available topology found
  Normal   ExternalProvisioning  97s (x26 over 7m47s)   persistentvolume-controller        waiting for a volume to be created, either by external provisioner "cinder.csi.openstack.org" or manually created by system administrator
```
> https://github.com/kubernetes-sigs/aws-ebs-csi-driver/issues/848
> https://github.com/hetznercloud/csi-driver/issues/92

# minikube - http: server gave HTTP response to HTTPS client
> https://minikube.sigs.k8s.io/docs/handbook/registry/