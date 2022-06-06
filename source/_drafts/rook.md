---
title: rook
readmore: true
date: 2022-06-06 09:27:26
categories:
tags:
---

```bash
controlplane $ kubectl get pod -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   coredns-66bff467f8-bp4jm                   1/1     Running   0          50s
kube-system   coredns-66bff467f8-slhzx                   1/1     Running   0          50s
kube-system   etcd-controlplane                          1/1     Running   0          58s
kube-system   katacoda-cloud-provider-5fddb5c748-bzvzs   1/1     Running   0          50s
kube-system   kube-apiserver-controlplane                1/1     Running   0          58s
kube-system   kube-controller-manager-controlplane       1/1     Running   0          58s
kube-system   kube-flannel-ds-amd64-dzt25                1/1     Running   0          50s
kube-system   kube-flannel-ds-amd64-pjlzz                1/1     Running   0          42s
kube-system   kube-keepalived-vip-h84b5                  1/1     Running   0          22s
kube-system   kube-proxy-7lgml                           1/1     Running   0          42s
kube-system   kube-proxy-84qqb                           1/1     Running   0          50s
kube-system   kube-scheduler-controlplane                1/1     Running   0          58s
controlplane $ cat lvm.yaml 
apiVersion: apps/v1
kind: DaemonSet
metadata:
 name: lvm
 namespace: kube-system
spec:
 revisionHistoryLimit: 10
 selector:
   matchLabels:
     name: lvm
 template:
   metadata:
     labels:
       name: lvm
   spec:
     containers:
     - args:
       - apt -y update; apt -y install lvm2
       command:
       - /bin/sh
       - -c
       image: debian:10
       imagePullPolicy: IfNotPresent
       name: lvm
       securityContext:
         privileged: true
       volumeMounts:
       - mountPath: /etc
         name: etc
       - mountPath: /sbin
         name: sbin
       - mountPath: /usr
         name: usr
       - mountPath: /lib
         name: lib
     dnsPolicy: ClusterFirst
     restartPolicy: Always
     schedulerName: default-scheduler
     securityContext:
     volumes:
     - hostPath:
         path: /etc
         type: Directory
       name: etc
     - hostPath:
         path: /sbin
         type: Directory
       name: sbin
     - hostPath:
         path: /usr
         type: Directory
       name: usr
     - hostPath:
         path: /lib
         type: Directory
       name: lib
controlplane $ kubectl apply -f lvm.yaml
daemonset.apps/lvm created
controlplane $ git clone --single-branch --branch release-1.3 https://github.com/rook/rook.git
Cloning into 'rook'...
remote: Enumerating objects: 46539, done.
remote: Counting objects: 100% (22/22), done.
remote: Compressing objects: 100% (22/22), done.
remote: Total 46539 (delta 0), reused 21 (delta 0), pack-reused 46517
Receiving objects: 100% (46539/46539), 32.33 MiB | 10.78 MiB/s, done.
Resolving deltas: 100% (32035/32035), done.
controlplane $ cd rook/cluster/examples/kubernetes/ceph
controlplane $ kubectl create -f common.yaml
namespace/rook-ceph created
customresourcedefinition.apiextensions.k8s.io/cephclusters.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephclients.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephfilesystems.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephnfses.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephobjectstores.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephobjectstoreusers.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/cephblockpools.ceph.rook.io created
customresourcedefinition.apiextensions.k8s.io/volumes.rook.io created
customresourcedefinition.apiextensions.k8s.io/objectbuckets.objectbucket.io created
customresourcedefinition.apiextensions.k8s.io/objectbucketclaims.objectbucket.io created
clusterrolebinding.rbac.authorization.k8s.io/rook-ceph-object-bucket created
clusterrole.rbac.authorization.k8s.io/rook-ceph-cluster-mgmt created
clusterrole.rbac.authorization.k8s.io/rook-ceph-cluster-mgmt-rules created
role.rbac.authorization.k8s.io/rook-ceph-system created
clusterrole.rbac.authorization.k8s.io/rook-ceph-global created
clusterrole.rbac.authorization.k8s.io/rook-ceph-global-rules created
clusterrole.rbac.authorization.k8s.io/rook-ceph-mgr-cluster created
clusterrole.rbac.authorization.k8s.io/rook-ceph-mgr-cluster-rules created
clusterrole.rbac.authorization.k8s.io/rook-ceph-object-bucket created
serviceaccount/rook-ceph-system created
rolebinding.rbac.authorization.k8s.io/rook-ceph-system created
clusterrolebinding.rbac.authorization.k8s.io/rook-ceph-global created
serviceaccount/rook-ceph-osd created
serviceaccount/rook-ceph-mgr created
serviceaccount/rook-ceph-cmd-reporter created
role.rbac.authorization.k8s.io/rook-ceph-osd created
clusterrole.rbac.authorization.k8s.io/rook-ceph-osd created
clusterrole.rbac.authorization.k8s.io/rook-ceph-mgr-system created
clusterrole.rbac.authorization.k8s.io/rook-ceph-mgr-system-rules created
role.rbac.authorization.k8s.io/rook-ceph-mgr created
role.rbac.authorization.k8s.io/rook-ceph-cmd-reporter created
rolebinding.rbac.authorization.k8s.io/rook-ceph-cluster-mgmt created
rolebinding.rbac.authorization.k8s.io/rook-ceph-osd created
rolebinding.rbac.authorization.k8s.io/rook-ceph-mgr created
rolebinding.rbac.authorization.k8s.io/rook-ceph-mgr-system created
clusterrolebinding.rbac.authorization.k8s.io/rook-ceph-mgr-cluster created
clusterrolebinding.rbac.authorization.k8s.io/rook-ceph-osd created
rolebinding.rbac.authorization.k8s.io/rook-ceph-cmd-reporter created
podsecuritypolicy.policy/00-rook-privileged created
clusterrole.rbac.authorization.k8s.io/psp:rook created
clusterrolebinding.rbac.authorization.k8s.io/rook-ceph-system-psp created
rolebinding.rbac.authorization.k8s.io/rook-ceph-default-psp created
rolebinding.rbac.authorization.k8s.io/rook-ceph-osd-psp created
rolebinding.rbac.authorization.k8s.io/rook-ceph-mgr-psp created
rolebinding.rbac.authorization.k8s.io/rook-ceph-cmd-reporter-psp created
serviceaccount/rook-csi-cephfs-plugin-sa created
serviceaccount/rook-csi-cephfs-provisioner-sa created
role.rbac.authorization.k8s.io/cephfs-external-provisioner-cfg created
rolebinding.rbac.authorization.k8s.io/cephfs-csi-provisioner-role-cfg created
clusterrole.rbac.authorization.k8s.io/cephfs-csi-nodeplugin created
clusterrole.rbac.authorization.k8s.io/cephfs-csi-nodeplugin-rules created
clusterrole.rbac.authorization.k8s.io/cephfs-external-provisioner-runner created
clusterrole.rbac.authorization.k8s.io/cephfs-external-provisioner-runner-rules created
clusterrolebinding.rbac.authorization.k8s.io/rook-csi-cephfs-plugin-sa-psp created
clusterrolebinding.rbac.authorization.k8s.io/rook-csi-cephfs-provisioner-sa-psp created
clusterrolebinding.rbac.authorization.k8s.io/cephfs-csi-nodeplugin created
clusterrolebinding.rbac.authorization.k8s.io/cephfs-csi-provisioner-role created
serviceaccount/rook-csi-rbd-plugin-sa created
serviceaccount/rook-csi-rbd-provisioner-sa created
role.rbac.authorization.k8s.io/rbd-external-provisioner-cfg created
rolebinding.rbac.authorization.k8s.io/rbd-csi-provisioner-role-cfg created
clusterrole.rbac.authorization.k8s.io/rbd-csi-nodeplugin created
clusterrole.rbac.authorization.k8s.io/rbd-csi-nodeplugin-rules created
clusterrole.rbac.authorization.k8s.io/rbd-external-provisioner-runner created
clusterrole.rbac.authorization.k8s.io/rbd-external-provisioner-runner-rules created
clusterrolebinding.rbac.authorization.k8s.io/rook-csi-rbd-plugin-sa-psp created
clusterrolebinding.rbac.authorization.k8s.io/rook-csi-rbd-provisioner-sa-psp created
clusterrolebinding.rbac.authorization.k8s.io/rbd-csi-nodeplugin created
clusterrolebinding.rbac.authorization.k8s.io/rbd-csi-provisioner-role created
controlplane $ vi operator.yaml
# Then search for the CSI_RBD_GRPC_METRICS_PORT variable, uncomment it by removing the #, and change the value from port 9090 to 9093
controlplane $ kubectl create -f operator.yaml
configmap/rook-ceph-operator-config created
deployment.apps/rook-ceph-operator created
controlplane $ kubectl get pod -n rook-ceph
NAME                                  READY   STATUS              RESTARTS   AGE
rook-ceph-operator-5dc456cdb6-8pjfb   0/1     ContainerCreating   0          14s
controlplane $ kubectl get pod -n rook-ceph
NAME                                  READY   STATUS    RESTARTS   AGE
rook-ceph-operator-5dc456cdb6-8pjfb   1/1     Running   0          39s
rook-discover-p7jw9                   1/1     Running   0          7s
controlplane $ 
```