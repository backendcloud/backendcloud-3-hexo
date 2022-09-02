---
title: Rook Deploy
readmore: true
date: 2022-09-02 18:59:35
categories: 云原生
tags:
- Rook
- Ceph
---

云原生存储现在比较火的是Rook和Longhorn，本篇是关于 运行在Kubernetes之上的rook ceph云原生存储的部署。

过去ceph的部署都是用官方的ceph-deploy工具部署，最近的新版ceph，ceph-deploy工具已经不不再支持，取而代之的是两种部署方式：
1. Cephadm 传统方式部署
2. Rook 云原生方式部署

# 启动Kubernetes集群
```bash
 ⚡ root@centos9  ~/tt  cat kind-example-config.yaml 
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
 ⚡ root@centos9  ~/tt  kind create cluster --config kind-example-config.yaml
enabling experimental podman provider
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.24.0) 🖼 
 ✓ Preparing nodes 📦 📦 📦 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️️ 
 ✓ Installing CNI 🔌 
 ✓ Installing StorageClass 💾 
 ✓ Joining worker nodes 🚜 
Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-kind

Thanks for using kind! 😊
 ⚡ root@centos9  ~/tt  kubectl get po -A
NAMESPACE            NAME                                         READY   STATUS    RESTARTS   AGE
kube-system          coredns-6d4b75cb6d-2tmfm                     1/1     Running   0          71s
kube-system          coredns-6d4b75cb6d-4s27g                     1/1     Running   0          71s
kube-system          etcd-kind-control-plane                      1/1     Running   0          86s
kube-system          kindnet-2522d                                1/1     Running   0          71s
kube-system          kindnet-h95c6                                1/1     Running   0          66s
kube-system          kindnet-q2t4q                                1/1     Running   0          66s
kube-system          kindnet-sn57p                                1/1     Running   0          65s
kube-system          kube-apiserver-kind-control-plane            1/1     Running   0          86s
kube-system          kube-controller-manager-kind-control-plane   1/1     Running   0          86s
kube-system          kube-proxy-gj7qp                             1/1     Running   0          66s
kube-system          kube-proxy-nnvd6                             1/1     Running   0          65s
kube-system          kube-proxy-vf6qk                             1/1     Running   0          71s
kube-system          kube-proxy-xbc6f                             1/1     Running   0          66s
kube-system          kube-scheduler-kind-control-plane            1/1     Running   0          86s
local-path-storage   local-path-provisioner-9cd9bd544-v27p7       1/1     Running   0          71s
 ⚡ root@centos9  ~/tt  kubectl get node -o wide
NAME                 STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION          CONTAINER-RUNTIME
kind-control-plane   Ready    control-plane   94s   v1.24.0   10.89.0.3     <none>        Ubuntu 21.10   5.14.0-115.el9.x86_64   containerd://1.6.4
kind-worker          Ready    <none>          70s   v1.24.0   10.89.0.2     <none>        Ubuntu 21.10   5.14.0-115.el9.x86_64   containerd://1.6.4
kind-worker2         Ready    <none>          71s   v1.24.0   10.89.0.4     <none>        Ubuntu 21.10   5.14.0-115.el9.x86_64   containerd://1.6.4
kind-worker3         Ready    <none>          71s   v1.24.0   10.89.0.5     <none>        Ubuntu 21.10   5.14.0-115.el9.x86_64   containerd://1.6.4
```

# 部署Rook
```bash
 ⚡ root@centos9  ~/tt  cd ..
 ⚡ root@centos9  ~/tt  git clone --single-branch --branch master https://github.com/rook/rook.git
 ⚡ root@centos9  ~  cd rook/deploy/examples
 ⚡ root@centos9  ~/rook/deploy/examples   master  kubectl create -f crds.yaml -f common.yaml -f operator.yaml
customresourcedefinition.apiextensions.k8s.io/cephblockpoolradosnamespaces.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephblockpools.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephbucketnotifications.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephbuckettopics.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephclients.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephclusters.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephfilesystemmirrors.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephfilesystems.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephfilesystemsubvolumegroups.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephnfses.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephobjectrealms.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephobjectstores.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephobjectstoreusers.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephobjectzonegroups.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephobjectzones.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephrbdmirrors.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/objectbucketclaims.objectbucket.io created
customresourcedefinition.apiextensions.k8s.io/objectbuckets.objectbucket.io created
namespace/rook-ceph created
clusterrole.rbac.authorization.k8s.io/cephfs-csi-nodeplugin created
clusterrole.rbac.authorization.k8s.io/cephfs-external-provisioner-runner created
clusterrole.rbac.authorization.k8s.io/rbd-csi-nodeplugin created
clusterrole.rbac.authorization.k8s.io/rbd-external-provisioner-runner created
clusterrole.rbac.authorization.k8s.io/rook-ceph-cluster-mgmt created
clusterrole.rbac.authorization.k8s.io/rook-ceph-global created
clusterrole.rbac.authorization.k8s.io/rook-ceph-mgr-cluster created
clusterrole.rbac.authorization.k8s.io/rook-ceph-mgr-system created
clusterrole.rbac.authorization.k8s.io/rook-ceph-object-bucket created
clusterrole.rbac.authorization.k8s.io/rook-ceph-osd created
clusterrole.rbac.authorization.k8s.io/rook-ceph-system created
clusterrolebinding.rbac.authorization.k8s.io/cephfs-csi-provisioner-role created
clusterrolebinding.rbac.authorization.k8s.io/rbd-csi-nodeplugin created
clusterrolebinding.rbac.authorization.k8s.io/rbd-csi-provisioner-role created
clusterrolebinding.rbac.authorization.k8s.io/rook-ceph-global created
clusterrolebinding.rbac.authorization.k8s.io/rook-ceph-mgr-cluster created
clusterrolebinding.rbac.authorization.k8s.io/rook-ceph-object-bucket created
clusterrolebinding.rbac.authorization.k8s.io/rook-ceph-osd created
clusterrolebinding.rbac.authorization.k8s.io/rook-ceph-system created
role.rbac.authorization.k8s.io/cephfs-external-provisioner-cfg created
role.rbac.authorization.k8s.io/rbd-csi-nodeplugin created
role.rbac.authorization.k8s.io/rbd-external-provisioner-cfg created
role.rbac.authorization.k8s.io/rook-ceph-cmd-reporter created
role.rbac.authorization.k8s.io/rook-ceph-mgr created
role.rbac.authorization.k8s.io/rook-ceph-osd created
role.rbac.authorization.k8s.io/rook-ceph-purge-osd created
role.rbac.authorization.k8s.io/rook-ceph-rgw created
role.rbac.authorization.k8s.io/rook-ceph-system created
rolebinding.rbac.authorization.k8s.io/cephfs-csi-provisioner-role-cfg created
rolebinding.rbac.authorization.k8s.io/rbd-csi-nodeplugin-role-cfg created
rolebinding.rbac.authorization.k8s.io/rbd-csi-provisioner-role-cfg created
rolebinding.rbac.authorization.k8s.io/rook-ceph-cluster-mgmt created
rolebinding.rbac.authorization.k8s.io/rook-ceph-cmd-reporter created
rolebinding.rbac.authorization.k8s.io/rook-ceph-mgr created
rolebinding.rbac.authorization.k8s.io/rook-ceph-mgr-system created
rolebinding.rbac.authorization.k8s.io/rook-ceph-osd created
rolebinding.rbac.authorization.k8s.io/rook-ceph-purge-osd created
rolebinding.rbac.authorization.k8s.io/rook-ceph-rgw created
rolebinding.rbac.authorization.k8s.io/rook-ceph-system created
serviceaccount/rook-ceph-cmd-reporter created
serviceaccount/rook-ceph-mgr created
serviceaccount/rook-ceph-osd created
serviceaccount/rook-ceph-purge-osd created
serviceaccount/rook-ceph-rgw created
serviceaccount/rook-ceph-system created
serviceaccount/rook-csi-cephfs-plugin-sa created
serviceaccount/rook-csi-cephfs-provisioner-sa created
serviceaccount/rook-csi-rbd-plugin-sa created
serviceaccount/rook-csi-rbd-provisioner-sa created
configmap/rook-ceph-operator-config created
deployment.apps/rook-ceph-operator created
 ⚡ root@centos9  ~/rook/deploy/examples   master  kubectl create -f cluster.yaml
cephcluster.ceph.rook.io/rook-ceph created
# 检查Rook pod 状态
 ⚡ root@centos9  ~/rook   master  kubectl get pod -A
NAMESPACE            NAME                                         READY   STATUS     RESTARTS   AGE
kube-system          coredns-6d4b75cb6d-2tmfm                     1/1     Running    0          4m55s
kube-system          coredns-6d4b75cb6d-4s27g                     1/1     Running    0          4m55s
kube-system          etcd-kind-control-plane                      1/1     Running    0          5m10s
kube-system          kindnet-2522d                                1/1     Running    0          4m55s
kube-system          kindnet-h95c6                                1/1     Running    0          4m50s
kube-system          kindnet-q2t4q                                1/1     Running    0          4m50s
kube-system          kindnet-sn57p                                1/1     Running    0          4m49s
kube-system          kube-apiserver-kind-control-plane            1/1     Running    0          5m10s
kube-system          kube-controller-manager-kind-control-plane   1/1     Running    0          5m10s
kube-system          kube-proxy-gj7qp                             1/1     Running    0          4m50s
kube-system          kube-proxy-nnvd6                             1/1     Running    0          4m49s
kube-system          kube-proxy-vf6qk                             1/1     Running    0          4m55s
kube-system          kube-proxy-xbc6f                             1/1     Running    0          4m50s
kube-system          kube-scheduler-kind-control-plane            1/1     Running    0          5m10s
local-path-storage   local-path-provisioner-9cd9bd544-v27p7       1/1     Running    0          4m55s
rook-ceph            rook-ceph-csi-detect-version-6djth           0/1     Init:0/1   0          71s
rook-ceph            rook-ceph-detect-version-f5dr5               0/1     Init:0/1   0          71s
rook-ceph            rook-ceph-operator-b5c96c99b-nsz4q           1/1     Running    0          2m39s
 ⚡ root@centos9  ~/rook   master  kubectl get pod -A
NAMESPACE            NAME                                                     READY   STATUS      RESTARTS   AGE
kube-system          coredns-6d4b75cb6d-2tmfm                                 1/1     Running     0          12m
kube-system          coredns-6d4b75cb6d-4s27g                                 1/1     Running     0          12m
kube-system          etcd-kind-control-plane                                  1/1     Running     0          12m
kube-system          kindnet-2522d                                            1/1     Running     0          12m
kube-system          kindnet-h95c6                                            1/1     Running     0          11m
kube-system          kindnet-q2t4q                                            1/1     Running     0          11m
kube-system          kindnet-sn57p                                            1/1     Running     0          11m
kube-system          kube-apiserver-kind-control-plane                        1/1     Running     0          12m
kube-system          kube-controller-manager-kind-control-plane               1/1     Running     0          12m
kube-system          kube-proxy-gj7qp                                         1/1     Running     0          11m
kube-system          kube-proxy-nnvd6                                         1/1     Running     0          11m
kube-system          kube-proxy-vf6qk                                         1/1     Running     0          12m
kube-system          kube-proxy-xbc6f                                         1/1     Running     0          11m
kube-system          kube-scheduler-kind-control-plane                        1/1     Running     0          12m
local-path-storage   local-path-provisioner-9cd9bd544-v27p7                   1/1     Running     0          12m
rook-ceph            csi-cephfsplugin-gczrh                                   2/2     Running     0          5m53s
rook-ceph            csi-cephfsplugin-provisioner-5c788447dd-rdv5r            5/5     Running     0          5m53s
rook-ceph            csi-cephfsplugin-provisioner-5c788447dd-s5754            5/5     Running     0          5m53s
rook-ceph            csi-cephfsplugin-rgscz                                   2/2     Running     0          5m53s
rook-ceph            csi-cephfsplugin-s5pfz                                   2/2     Running     0          5m53s
rook-ceph            csi-rbdplugin-lrp48                                      2/2     Running     0          5m54s
rook-ceph            csi-rbdplugin-provisioner-75885879dc-dswsl               5/5     Running     0          5m54s
rook-ceph            csi-rbdplugin-provisioner-75885879dc-vpc9p               5/5     Running     0          5m53s
rook-ceph            csi-rbdplugin-vbbgn                                      2/2     Running     0          5m54s
rook-ceph            csi-rbdplugin-vgvwf                                      2/2     Running     0          5m54s
rook-ceph            rook-ceph-crashcollector-kind-worker-86774b8649-lgsg9    1/1     Running     0          98s
rook-ceph            rook-ceph-crashcollector-kind-worker2-6c785f9c65-jbkqs   1/1     Running     0          75s
rook-ceph            rook-ceph-crashcollector-kind-worker3-d47b86944-mqntp    1/1     Running     0          68s
rook-ceph            rook-ceph-mgr-a-6b5f955c46-k9hz9                         2/2     Running     0          98s
rook-ceph            rook-ceph-mgr-b-8468f5bf98-ggsls                         2/2     Running     0          98s
rook-ceph            rook-ceph-mon-a-7d8c47b49-xchqn                          1/1     Running     0          6m11s
rook-ceph            rook-ceph-mon-b-547b8b66c8-7hfn8                         1/1     Running     0          5m17s
rook-ceph            rook-ceph-mon-c-66fffd4685-gwvcz                         1/1     Running     0          2m4s
rook-ceph            rook-ceph-operator-b5c96c99b-nsz4q                       1/1     Running     0          9m48s
rook-ceph            rook-ceph-osd-1-77646bc88-lzqhc                          1/1     Running     0          68s
rook-ceph            rook-ceph-osd-prepare-kind-worker-9sktq                  0/1     Completed   0          19s
rook-ceph            rook-ceph-osd-prepare-kind-worker2-phzzk                 0/1     Completed   0          16s
rook-ceph            rook-ceph-osd-prepare-kind-worker3-qrf6z                 0/1     Completed   0          13s
```

# 部署 rook-ceph-tools 检查 ceph 状态
```bash
 ⚡ root@centos9  ~/rook/deploy/examples   master  cd ../..
 ⚡ root@centos9  ~/rook   master  kubectl create -f deploy/examples/toolbox.yaml
deployment.apps/rook-ceph-tools created
 ⚡ root@centos9  ~/rook   master  kubectl get po -A
NAMESPACE            NAME                                                     READY   STATUS      RESTARTS   AGE
kube-system          coredns-6d4b75cb6d-2tmfm                                 1/1     Running     0          21m
kube-system          coredns-6d4b75cb6d-4s27g                                 1/1     Running     0          21m
kube-system          etcd-kind-control-plane                                  1/1     Running     0          21m
kube-system          kindnet-2522d                                            1/1     Running     0          21m
kube-system          kindnet-h95c6                                            1/1     Running     0          21m
kube-system          kindnet-q2t4q                                            1/1     Running     0          21m
kube-system          kindnet-sn57p                                            1/1     Running     0          21m
kube-system          kube-apiserver-kind-control-plane                        1/1     Running     0          21m
kube-system          kube-controller-manager-kind-control-plane               1/1     Running     0          21m
kube-system          kube-proxy-gj7qp                                         1/1     Running     0          21m
kube-system          kube-proxy-nnvd6                                         1/1     Running     0          21m
kube-system          kube-proxy-vf6qk                                         1/1     Running     0          21m
kube-system          kube-proxy-xbc6f                                         1/1     Running     0          21m
kube-system          kube-scheduler-kind-control-plane                        1/1     Running     0          21m
local-path-storage   local-path-provisioner-9cd9bd544-v27p7                   1/1     Running     0          21m
rook-ceph            csi-cephfsplugin-gczrh                                   2/2     Running     0          15m
rook-ceph            csi-cephfsplugin-provisioner-5c788447dd-rdv5r            5/5     Running     0          15m
rook-ceph            csi-cephfsplugin-provisioner-5c788447dd-s5754            5/5     Running     0          15m
rook-ceph            csi-cephfsplugin-rgscz                                   2/2     Running     0          15m
rook-ceph            csi-cephfsplugin-s5pfz                                   2/2     Running     0          15m
rook-ceph            csi-rbdplugin-lrp48                                      2/2     Running     0          15m
rook-ceph            csi-rbdplugin-provisioner-75885879dc-dswsl               5/5     Running     0          15m
rook-ceph            csi-rbdplugin-provisioner-75885879dc-vpc9p               5/5     Running     0          15m
rook-ceph            csi-rbdplugin-vbbgn                                      2/2     Running     0          15m
rook-ceph            csi-rbdplugin-vgvwf                                      2/2     Running     0          15m
rook-ceph            rook-ceph-crashcollector-kind-worker-86774b8649-lgsg9    1/1     Running     0          10m
rook-ceph            rook-ceph-crashcollector-kind-worker2-6c785f9c65-jbkqs   1/1     Running     0          10m
rook-ceph            rook-ceph-crashcollector-kind-worker3-d47b86944-mqntp    1/1     Running     0          10m
rook-ceph            rook-ceph-mgr-a-6b5f955c46-k9hz9                         2/2     Running     0          10m
rook-ceph            rook-ceph-mgr-b-8468f5bf98-ggsls                         2/2     Running     0          10m
rook-ceph            rook-ceph-mon-a-7d8c47b49-xchqn                          1/1     Running     0          15m
rook-ceph            rook-ceph-mon-b-547b8b66c8-7hfn8                         1/1     Running     0          14m
rook-ceph            rook-ceph-mon-c-66fffd4685-gwvcz                         1/1     Running     0          11m
rook-ceph            rook-ceph-operator-b5c96c99b-nsz4q                       1/1     Running     0          19m
rook-ceph            rook-ceph-osd-1-77646bc88-lzqhc                          1/1     Running     0          10m
rook-ceph            rook-ceph-osd-prepare-kind-worker-l6n65                  0/1     Completed   0          4m45s
rook-ceph            rook-ceph-osd-prepare-kind-worker2-d88n9                 0/1     Completed   0          4m42s
rook-ceph            rook-ceph-osd-prepare-kind-worker3-pkj4s                 0/1     Completed   0          4m39s
rook-ceph            rook-ceph-tools-79bc54b8d8-mjqzz                         1/1     Running     0          3m1s
 ⚡ root@centos9  ~/rook   master  kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash
bash-4.4$ ceph status
  cluster:
    id:     fcfdeb56-b495-486e-85ef-f22def3bf799
    health: HEALTH_WARN
            OSD count 1 < osd_pool_default_size 3
 
  services:
    mon: 3 daemons, quorum a,b,c (age 12m)
    mgr: a(active, since 11m), standbys: b
    osd: 1 osds: 1 up (since 11m), 1 in (since 11m)
 
  data:
    pools:   0 pools, 0 pgs
    objects: 0 objects, 0 B
    usage:   19 MiB used, 200 GiB / 200 GiB avail
    pgs:     
 
bash-4.4$ ceph osd status
ID  HOST           USED  AVAIL  WR OPS  WR DATA  RD OPS  RD DATA  STATE      
 1  kind-worker3  19.2M   199G      0        0       0        0   exists,up  
bash-4.4$ ceph df
--- RAW STORAGE ---
CLASS     SIZE    AVAIL    USED  RAW USED  %RAW USED
hdd    200 GiB  200 GiB  19 MiB    19 MiB          0
TOTAL  200 GiB  200 GiB  19 MiB    19 MiB          0
 
--- POOLS ---
POOL  ID  PGS  STORED  OBJECTS  USED  %USED  MAX AVAIL
bash-4.4$ rados df
POOL_NAME  USED  OBJECTS  CLONES  COPIES  MISSING_ON_PRIMARY  UNFOUND  DEGRADED  RD_OPS  RD  WR_OPS  WR  USED COMPR  UNDER COMPR

total_objects    0
total_used       19 MiB
total_avail      200 GiB
total_space      200 GiB
bash-4.4$ exit
 ⚡ root@centos9  ~/rook   master  kubectl create -f deploy/examples/toolbox-job.yaml
job.batch/rook-ceph-toolbox-job created
 ⚡ root@centos9  ~/rook   master  kubectl -n rook-ceph logs -l job-name=rook-ceph-toolbox-job
Defaulted container "script" out of: script, config-init (init)
    mon: 3 daemons, quorum a,b,c (age 13m)
    mgr: a(active, since 12m), standbys: b
    osd: 1 osds: 1 up (since 12m), 1 in (since 12m)
 
  data:
    pools:   0 pools, 0 pgs
    objects: 0 objects, 0 B
    usage:   19 MiB used, 200 GiB / 200 GiB avail
    pgs:     
```