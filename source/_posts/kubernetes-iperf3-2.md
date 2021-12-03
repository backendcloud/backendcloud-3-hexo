---
title: iperf3测试Kubernetes Service的四层性能（下）
date: 2021-08-10 07:06:01
categories: 云原生
tags:
- iperf3
- Kubernetes
- Service
---

继续上篇文章 {% post_link kubernetes-iperf3 iperf3测试Kubernetes Service的四层性能（上） %}

起16个iperf3客户端，模拟2000并发（单个iperf3客户端最多只能128并发）

```yaml
#  cat iperf3.yaml 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: iperf3-server-deployment
  labels:
    app: iperf3-server
spec:
  replicas: 1
  selector:
    matchLabels:
      app: iperf3-server
  template:
    metadata:
      labels:
        app: iperf3-server
    spec:
      affinity:
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 1
            preference:
              matchExpressions:
              - key: kubernetes.io/role
                operator: In
                values:
                - master
      #tolerations:
      #  - key: node-role.kubernetes.io/master
      #    operator: Exists
      #    effect: NoSchedule
      containers:
      - name: iperf3-server
        image: registry.paas/cmss/iperf3
        command: ["/bin/sh","-c"]
        args:
          - |
            iperf3 -s -p 5201&
            iperf3 -s -p 5202&
            iperf3 -s -p 5203&
            iperf3 -s -p 5204&
            iperf3 -s -p 5205&
            iperf3 -s -p 5206&
            iperf3 -s -p 5207&
            iperf3 -s -p 5208&
            iperf3 -s -p 5209&
            iperf3 -s -p 5210&
            iperf3 -s -p 5211&
            iperf3 -s -p 5212&
            iperf3 -s -p 5213&
            iperf3 -s -p 5214&
            iperf3 -s -p 5215&
            iperf3 -s -p 5216&
            sleep infinity
        ports:
        - containerPort: 5201
        - containerPort: 5202
        - containerPort: 5203
        - containerPort: 5204
        - containerPort: 5205
        - containerPort: 5206
        - containerPort: 5207
        - containerPort: 5208
        - containerPort: 5209
        - containerPort: 5210
        - containerPort: 5211
        - containerPort: 5212
        - containerPort: 5213
        - containerPort: 5214
        - containerPort: 5215
        - containerPort: 5216
      terminationGracePeriodSeconds: 0


---


apiVersion: v1
kind: Service
metadata:
  name: iperf3-server
spec:
  selector:
    app: iperf3-server
  ports:
  - port: 5201
    targetPort: 5201
    name: server5201
  - port: 5202
    targetPort: 5202
    name: server5202
  - port: 5203
    targetPort: 5203
    name: server5203
  - port: 5204
    targetPort: 5204
    name: server5204
  - port: 5205
    targetPort: 5205
    name: server5205
  - port: 5206
    targetPort: 5206
    name: server5206
  - port: 5207
    targetPort: 5207
    name: server5207
  - port: 5208
    targetPort: 5208
    name: server5208
  - port: 5209
    targetPort: 5209
    name: server5209
  - port: 5210
    targetPort: 5210
    name: server5210
  - port: 5211
    targetPort: 5211
    name: server5211
  - port: 5212
    targetPort: 5212
    name: server5212
  - port: 5213
    targetPort: 5213
    name: server5213
  - port: 5214
    targetPort: 5214
    name: server5214
  - port: 5215
    targetPort: 5215
    name: server5215
  - port: 5216
    targetPort: 5216
    name: server5216
    
---
    
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: iperf3-clients
  labels:
    app: iperf3-client
spec:
  selector:
    matchLabels:
      app: iperf3-client
  template:
    metadata:
      labels:
        app: iperf3-client
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/hostname
                operator: NotIn
                values:
                - vcdn-bm6
                - vcdn-bm7
      #tolerations:
      #  - key: node-role.kubernetes.io/master
      #    operator: Exists
      #    effect: NoSchedule
      containers:
      - name: iperf3-client
        image: registry.paas/cmss/iperf3
        command: ['/bin/sh', '-c', 'sleep infinity']
        # To benchmark manually: kubectl exec iperf3-clients-jlfxq -- /bin/sh -c 'iperf3 -c iperf3-server'
      terminationGracePeriodSeconds: 0
```

```bash
iperf3 -c iperf3-server -t 10 -p 5201 -M 2000 -P 125 -b 0 >tt1.log&
iperf3 -c iperf3-server -t 10 -p 5202 -M 2000 -P 125 -b 0 >tt2.log&
iperf3 -c iperf3-server -t 10 -p 5203 -M 2000 -P 125 -b 0 >tt3.log&
iperf3 -c iperf3-server -t 10 -p 5204 -M 2000 -P 125 -b 0 >tt4.log&
iperf3 -c iperf3-server -t 10 -p 5205 -M 2000 -P 125 -b 0 >tt5.log&
iperf3 -c iperf3-server -t 10 -p 5206 -M 2000 -P 125 -b 0 >tt6.log&
iperf3 -c iperf3-server -t 10 -p 5207 -M 2000 -P 125 -b 0 >tt7.log&
iperf3 -c iperf3-server -t 10 -p 5208 -M 2000 -P 125 -b 0 >tt8.log&
iperf3 -c iperf3-server -t 10 -p 5209 -M 2000 -P 125 -b 0 >tt9.log&
iperf3 -c iperf3-server -t 10 -p 5210 -M 2000 -P 125 -b 0 >tt10.log&
iperf3 -c iperf3-server -t 10 -p 5211 -M 2000 -P 125 -b 0 >tt11.log&
iperf3 -c iperf3-server -t 10 -p 5212 -M 2000 -P 125 -b 0 >tt12.log&
iperf3 -c iperf3-server -t 10 -p 5213 -M 2000 -P 125 -b 0 >tt13.log&
iperf3 -c iperf3-server -t 10 -p 5214 -M 2000 -P 125 -b 0 >tt14.log&
iperf3 -c iperf3-server -t 10 -p 5215 -M 2000 -P 125 -b 0 >tt15.log&
iperf3 -c iperf3-server -t 10 -p 5216 -M 2000 -P 125 -b 0 >tt16.log&
```

```bash
root@iperf3-clients-4cqqc:/# grep SUM *.log
tt1.log:[SUM]   0.00-1.00   sec  81.5 MBytes   683 Mbits/sec  1078             
tt1.log:[SUM]   1.00-2.00   sec  70.8 MBytes   594 Mbits/sec  1036             
tt1.log:[SUM]   2.00-3.00   sec  69.1 MBytes   580 Mbits/sec  923             
tt1.log:[SUM]   3.00-4.00   sec  68.0 MBytes   570 Mbits/sec  978             
tt1.log:[SUM]   4.00-5.00   sec  68.3 MBytes   572 Mbits/sec  1120             
tt1.log:[SUM]   5.00-6.00   sec  69.1 MBytes   581 Mbits/sec  1368             
tt1.log:[SUM]   6.00-7.00   sec  68.1 MBytes   571 Mbits/sec  891             
tt1.log:[SUM]   7.00-8.00   sec  69.7 MBytes   585 Mbits/sec  1170             
tt1.log:[SUM]   8.00-9.00   sec  67.3 MBytes   564 Mbits/sec  1068             
tt1.log:[SUM]   9.00-10.00  sec  67.9 MBytes   570 Mbits/sec  866             
tt1.log:[SUM]   0.00-10.00  sec   700 MBytes   587 Mbits/sec  10498             sender
tt1.log:[SUM]   0.00-10.09  sec   685 MBytes   570 Mbits/sec                  receiver
tt10.log:[SUM]   0.00-1.00   sec  74.2 MBytes   623 Mbits/sec  902             
tt10.log:[SUM]   1.00-2.00   sec  67.0 MBytes   562 Mbits/sec  900             
tt10.log:[SUM]   2.00-3.00   sec  66.4 MBytes   557 Mbits/sec  760             
tt10.log:[SUM]   3.00-4.00   sec  64.9 MBytes   545 Mbits/sec  864             
tt10.log:[SUM]   4.00-5.00   sec  65.2 MBytes   547 Mbits/sec  1181             
tt10.log:[SUM]   5.00-6.00   sec  64.6 MBytes   542 Mbits/sec  1348             
tt10.log:[SUM]   6.00-7.00   sec  64.3 MBytes   539 Mbits/sec  1256             
tt10.log:[SUM]   7.00-8.00   sec  63.7 MBytes   535 Mbits/sec  1342             
tt10.log:[SUM]   8.00-9.00   sec  61.7 MBytes   518 Mbits/sec  1147             
tt10.log:[SUM]   9.00-10.00  sec  63.3 MBytes   531 Mbits/sec  1031             
tt10.log:[SUM]   0.00-10.00  sec   656 MBytes   550 Mbits/sec  10731             sender
tt10.log:[SUM]   0.00-10.11  sec   643 MBytes   533 Mbits/sec                  receiver
tt11.log:[SUM]   0.00-1.00   sec  75.6 MBytes   634 Mbits/sec  1034             
tt11.log:[SUM]   1.00-2.00   sec  69.9 MBytes   586 Mbits/sec  984             
tt11.log:[SUM]   2.00-3.00   sec  69.2 MBytes   581 Mbits/sec  808             
tt11.log:[SUM]   3.00-4.00   sec  69.5 MBytes   582 Mbits/sec  723             
tt11.log:[SUM]   4.00-5.00   sec  67.5 MBytes   567 Mbits/sec  1133             
tt11.log:[SUM]   5.00-6.00   sec  68.7 MBytes   576 Mbits/sec  1241             
tt11.log:[SUM]   6.00-7.00   sec  68.8 MBytes   577 Mbits/sec  902             
tt11.log:[SUM]   7.00-8.00   sec  67.3 MBytes   565 Mbits/sec  1115             
tt11.log:[SUM]   8.00-9.00   sec  67.1 MBytes   563 Mbits/sec  1177             
tt11.log:[SUM]   9.00-10.00  sec  67.5 MBytes   566 Mbits/sec  725             
tt11.log:[SUM]   0.00-10.00  sec   691 MBytes   580 Mbits/sec  9842             sender
tt11.log:[SUM]   0.00-10.12  sec   678 MBytes   562 Mbits/sec                  receiver
tt12.log:[SUM]   0.00-1.00   sec  79.6 MBytes   668 Mbits/sec  1037             
tt12.log:[SUM]   1.00-2.00   sec  73.6 MBytes   617 Mbits/sec  806             
tt12.log:[SUM]   2.00-3.00   sec  70.1 MBytes   588 Mbits/sec  915             
tt12.log:[SUM]   3.00-4.00   sec  69.1 MBytes   579 Mbits/sec  853             
tt12.log:[SUM]   4.00-5.00   sec  71.4 MBytes   599 Mbits/sec  969             
tt12.log:[SUM]   5.00-6.00   sec  71.9 MBytes   603 Mbits/sec  963             
tt12.log:[SUM]   6.00-7.00   sec  70.7 MBytes   593 Mbits/sec  973             
tt12.log:[SUM]   7.00-8.00   sec  68.3 MBytes   573 Mbits/sec  1223             
tt12.log:[SUM]   8.00-9.00   sec  67.3 MBytes   564 Mbits/sec  1078             
tt12.log:[SUM]   9.00-10.00  sec  69.0 MBytes   579 Mbits/sec  628             
tt12.log:[SUM]   0.00-10.00  sec   711 MBytes   596 Mbits/sec  9445             sender
tt12.log:[SUM]   0.00-10.09  sec   694 MBytes   577 Mbits/sec                  receiver
tt13.log:[SUM]   0.00-1.00   sec  77.7 MBytes   651 Mbits/sec  935             
tt13.log:[SUM]   1.00-2.00   sec  70.6 MBytes   593 Mbits/sec  1005             
tt13.log:[SUM]   2.00-3.00   sec  69.4 MBytes   582 Mbits/sec  902             
tt13.log:[SUM]   3.00-4.00   sec  68.7 MBytes   576 Mbits/sec  998             
tt13.log:[SUM]   4.00-5.00   sec  68.2 MBytes   572 Mbits/sec  1079             
tt13.log:[SUM]   5.00-6.00   sec  68.4 MBytes   574 Mbits/sec  1293             
tt13.log:[SUM]   6.00-7.00   sec  66.7 MBytes   560 Mbits/sec  933             
tt13.log:[SUM]   7.00-8.00   sec  66.7 MBytes   559 Mbits/sec  1036             
tt13.log:[SUM]   8.00-9.00   sec  66.6 MBytes   559 Mbits/sec  1088             
tt13.log:[SUM]   9.00-10.00  sec  67.5 MBytes   566 Mbits/sec  1010             
tt13.log:[SUM]   0.00-10.00  sec   691 MBytes   579 Mbits/sec  10279             sender
tt13.log:[SUM]   0.00-10.00  sec   670 MBytes   562 Mbits/sec                  receiver
tt14.log:[SUM]   0.00-1.00   sec  76.5 MBytes   642 Mbits/sec  1015             
tt14.log:[SUM]   1.00-2.00   sec  67.0 MBytes   562 Mbits/sec  921             
tt14.log:[SUM]   2.00-3.00   sec  65.7 MBytes   551 Mbits/sec  982             
tt14.log:[SUM]   3.00-4.00   sec  66.1 MBytes   555 Mbits/sec  923             
tt14.log:[SUM]   4.00-5.00   sec  62.6 MBytes   525 Mbits/sec  1208             
tt14.log:[SUM]   5.00-6.00   sec  63.4 MBytes   532 Mbits/sec  1095             
tt14.log:[SUM]   6.00-7.00   sec  64.1 MBytes   538 Mbits/sec  1191             
tt14.log:[SUM]   7.00-8.00   sec  64.0 MBytes   537 Mbits/sec  893             
tt14.log:[SUM]   8.00-9.00   sec  65.1 MBytes   546 Mbits/sec  1084             
tt14.log:[SUM]   9.00-10.00  sec  66.1 MBytes   555 Mbits/sec  846             
tt14.log:[SUM]   0.00-10.00  sec   661 MBytes   554 Mbits/sec  10158             sender
tt14.log:[SUM]   0.00-10.00  sec   640 MBytes   537 Mbits/sec                  receiver
tt15.log:[SUM]   0.00-1.00   sec  77.4 MBytes   649 Mbits/sec  877             
tt15.log:[SUM]   1.00-2.00   sec  73.3 MBytes   615 Mbits/sec  902             
tt15.log:[SUM]   2.00-3.00   sec  70.8 MBytes   594 Mbits/sec  823             
tt15.log:[SUM]   3.00-4.00   sec  70.7 MBytes   593 Mbits/sec  894             
tt15.log:[SUM]   4.00-5.00   sec  70.4 MBytes   590 Mbits/sec  902             
tt15.log:[SUM]   5.00-6.00   sec  70.9 MBytes   594 Mbits/sec  1035             
tt15.log:[SUM]   6.00-7.00   sec  69.6 MBytes   584 Mbits/sec  1201             
tt15.log:[SUM]   7.00-8.00   sec  72.6 MBytes   609 Mbits/sec  949             
tt15.log:[SUM]   8.00-9.00   sec  70.2 MBytes   589 Mbits/sec  1055             
tt15.log:[SUM]   9.00-10.00  sec  68.4 MBytes   574 Mbits/sec  1056             
tt15.log:[SUM]   0.00-10.00  sec   714 MBytes   599 Mbits/sec  9694             sender
tt15.log:[SUM]   0.00-10.01  sec   692 MBytes   580 Mbits/sec                  receiver
tt16.log:[SUM]   0.00-1.00   sec  80.4 MBytes   675 Mbits/sec  1039             
tt16.log:[SUM]   1.00-2.00   sec  71.9 MBytes   603 Mbits/sec  1155             
tt16.log:[SUM]   2.00-3.00   sec  69.3 MBytes   581 Mbits/sec  968             
tt16.log:[SUM]   3.00-4.00   sec  68.6 MBytes   575 Mbits/sec  1073             
tt16.log:[SUM]   4.00-5.00   sec  67.3 MBytes   564 Mbits/sec  1047             
tt16.log:[SUM]   5.00-6.00   sec  66.6 MBytes   558 Mbits/sec  1087             
tt16.log:[SUM]   6.00-7.00   sec  69.1 MBytes   580 Mbits/sec  1026             
tt16.log:[SUM]   7.00-8.00   sec  69.1 MBytes   580 Mbits/sec  1031             
tt16.log:[SUM]   8.00-9.00   sec  66.9 MBytes   561 Mbits/sec  902             
tt16.log:[SUM]   9.00-10.00  sec  65.4 MBytes   549 Mbits/sec  1093             
tt16.log:[SUM]   0.00-10.00  sec   695 MBytes   583 Mbits/sec  10421             sender
tt16.log:[SUM]   0.00-10.00  sec   674 MBytes   565 Mbits/sec                  receiver
tt2.log:[SUM]   0.00-1.00   sec  89.6 MBytes   752 Mbits/sec  1067             
tt2.log:[SUM]   1.00-2.00   sec  67.2 MBytes   564 Mbits/sec  974             
tt2.log:[SUM]   2.00-3.00   sec  66.5 MBytes   558 Mbits/sec  854             
tt2.log:[SUM]   3.00-4.00   sec  66.4 MBytes   557 Mbits/sec  946             
tt2.log:[SUM]   4.00-5.00   sec  64.8 MBytes   543 Mbits/sec  1220             
tt2.log:[SUM]   5.00-6.00   sec  65.4 MBytes   548 Mbits/sec  1158             
tt2.log:[SUM]   6.00-7.00   sec  63.6 MBytes   534 Mbits/sec  962             
tt2.log:[SUM]   7.00-8.00   sec  65.2 MBytes   547 Mbits/sec  1120             
tt2.log:[SUM]   8.00-9.00   sec  66.0 MBytes   554 Mbits/sec  866             
tt2.log:[SUM]   9.00-10.00  sec  62.9 MBytes   527 Mbits/sec  934             
tt2.log:[SUM]   0.00-10.00  sec   678 MBytes   568 Mbits/sec  10101             sender
tt2.log:[SUM]   0.00-10.06  sec   659 MBytes   550 Mbits/sec                  receiver
tt3.log:[SUM]   0.00-1.00   sec  82.2 MBytes   689 Mbits/sec  1026             
tt3.log:[SUM]   1.00-2.00   sec  69.7 MBytes   584 Mbits/sec  1025             
tt3.log:[SUM]   2.00-3.00   sec  70.0 MBytes   587 Mbits/sec  935             
tt3.log:[SUM]   3.00-4.00   sec  70.7 MBytes   593 Mbits/sec  980             
tt3.log:[SUM]   4.00-5.00   sec  69.4 MBytes   583 Mbits/sec  1261             
tt3.log:[SUM]   5.00-6.00   sec  70.8 MBytes   594 Mbits/sec  1112             
tt3.log:[SUM]   6.00-7.00   sec  71.5 MBytes   600 Mbits/sec  858             
tt3.log:[SUM]   7.00-8.00   sec  73.0 MBytes   613 Mbits/sec  1290             
tt3.log:[SUM]   8.00-9.00   sec  73.8 MBytes   619 Mbits/sec  931             
tt3.log:[SUM]   9.00-10.00  sec  74.7 MBytes   626 Mbits/sec  975             
tt3.log:[SUM]   0.00-10.00  sec   726 MBytes   609 Mbits/sec  10393             sender
tt3.log:[SUM]   0.00-10.10  sec   711 MBytes   591 Mbits/sec                  receiver
tt4.log:[SUM]   0.00-1.00   sec  79.6 MBytes   668 Mbits/sec  959             
tt4.log:[SUM]   1.00-2.00   sec  69.9 MBytes   587 Mbits/sec  962             
tt4.log:[SUM]   2.00-3.00   sec  69.0 MBytes   579 Mbits/sec  926             
tt4.log:[SUM]   3.00-4.00   sec  67.7 MBytes   568 Mbits/sec  876             
tt4.log:[SUM]   4.00-5.00   sec  69.4 MBytes   583 Mbits/sec  1233             
tt4.log:[SUM]   5.00-6.00   sec  68.6 MBytes   576 Mbits/sec  1292             
tt4.log:[SUM]   6.00-7.00   sec  67.7 MBytes   568 Mbits/sec  910             
tt4.log:[SUM]   7.00-8.00   sec  69.9 MBytes   586 Mbits/sec  1306             
tt4.log:[SUM]   8.00-9.00   sec  69.7 MBytes   585 Mbits/sec  1027             
tt4.log:[SUM]   9.00-10.00  sec  69.0 MBytes   579 Mbits/sec  1086             
tt4.log:[SUM]   0.00-10.00  sec   701 MBytes   588 Mbits/sec  10577             sender
tt4.log:[SUM]   0.00-10.00  sec   679 MBytes   570 Mbits/sec                  receiver
tt5.log:[SUM]   0.00-1.00   sec  79.0 MBytes   662 Mbits/sec  951             
tt5.log:[SUM]   1.00-2.00   sec  71.0 MBytes   596 Mbits/sec  1000             
tt5.log:[SUM]   2.00-3.00   sec  68.6 MBytes   575 Mbits/sec  871             
tt5.log:[SUM]   3.00-4.00   sec  66.7 MBytes   559 Mbits/sec  1038             
tt5.log:[SUM]   4.00-5.00   sec  66.5 MBytes   558 Mbits/sec  1093             
tt5.log:[SUM]   5.00-6.00   sec  67.6 MBytes   567 Mbits/sec  1336             
tt5.log:[SUM]   6.00-7.00   sec  66.7 MBytes   559 Mbits/sec  1135             
tt5.log:[SUM]   7.00-8.00   sec  66.1 MBytes   555 Mbits/sec  1214             
tt5.log:[SUM]   8.00-9.00   sec  66.2 MBytes   555 Mbits/sec  915             
tt5.log:[SUM]   9.00-10.00  sec  68.4 MBytes   574 Mbits/sec  733             
tt5.log:[SUM]   0.00-10.00  sec   687 MBytes   576 Mbits/sec  10286             sender
tt5.log:[SUM]   0.00-10.10  sec   672 MBytes   558 Mbits/sec                  receiver
tt6.log:[SUM]   0.00-1.00   sec  77.9 MBytes   653 Mbits/sec  1030             
tt6.log:[SUM]   1.00-2.00   sec  72.5 MBytes   608 Mbits/sec  908             
tt6.log:[SUM]   2.00-3.00   sec  70.1 MBytes   588 Mbits/sec  861             
tt6.log:[SUM]   3.00-4.00   sec  68.6 MBytes   576 Mbits/sec  919             
tt6.log:[SUM]   4.00-5.00   sec  69.9 MBytes   586 Mbits/sec  1124             
tt6.log:[SUM]   5.00-6.00   sec  69.2 MBytes   581 Mbits/sec  1144             
tt6.log:[SUM]   6.00-7.00   sec  68.8 MBytes   577 Mbits/sec  1156             
tt6.log:[SUM]   7.00-8.00   sec  69.6 MBytes   584 Mbits/sec  1046             
tt6.log:[SUM]   8.00-9.00   sec  69.7 MBytes   585 Mbits/sec  914             
tt6.log:[SUM]   9.00-10.00  sec  68.7 MBytes   577 Mbits/sec  659             
tt6.log:[SUM]   0.00-10.00  sec   705 MBytes   591 Mbits/sec  9761             sender
tt6.log:[SUM]   0.00-10.12  sec   692 MBytes   574 Mbits/sec                  receiver
tt7.log:[SUM]   0.00-1.00   sec  74.5 MBytes   625 Mbits/sec  933             
tt7.log:[SUM]   1.00-2.00   sec  76.2 MBytes   639 Mbits/sec  916             
tt7.log:[SUM]   2.00-3.00   sec  74.6 MBytes   626 Mbits/sec  880             
tt7.log:[SUM]   3.00-4.00   sec  72.7 MBytes   610 Mbits/sec  920             
tt7.log:[SUM]   4.00-5.00   sec  71.1 MBytes   596 Mbits/sec  1160             
tt7.log:[SUM]   5.00-6.00   sec  73.3 MBytes   614 Mbits/sec  1200             
tt7.log:[SUM]   6.00-7.00   sec  73.1 MBytes   614 Mbits/sec  1065             
tt7.log:[SUM]   7.00-8.00   sec  72.0 MBytes   604 Mbits/sec  1219             
tt7.log:[SUM]   8.00-9.00   sec  72.1 MBytes   605 Mbits/sec  999             
tt7.log:[SUM]   9.00-10.00  sec  73.2 MBytes   614 Mbits/sec  1071             
tt7.log:[SUM]   0.00-10.00  sec   733 MBytes   615 Mbits/sec  10363             sender
tt7.log:[SUM]   0.00-10.12  sec   719 MBytes   596 Mbits/sec                  receiver
tt8.log:[SUM]   0.00-1.00   sec  79.4 MBytes   666 Mbits/sec  876             
tt8.log:[SUM]   1.00-2.00   sec  70.1 MBytes   588 Mbits/sec  1051             
tt8.log:[SUM]   2.00-3.00   sec  70.3 MBytes   590 Mbits/sec  800             
tt8.log:[SUM]   3.00-4.00   sec  69.4 MBytes   582 Mbits/sec  1062             
tt8.log:[SUM]   4.00-5.00   sec  70.1 MBytes   588 Mbits/sec  985             
tt8.log:[SUM]   5.00-6.00   sec  68.7 MBytes   576 Mbits/sec  1317             
tt8.log:[SUM]   6.00-7.00   sec  69.5 MBytes   583 Mbits/sec  1107             
tt8.log:[SUM]   7.00-8.00   sec  69.5 MBytes   583 Mbits/sec  967             
tt8.log:[SUM]   8.00-9.00   sec  68.8 MBytes   577 Mbits/sec  1041             
tt8.log:[SUM]   9.00-10.00  sec  68.2 MBytes   572 Mbits/sec  838             
tt8.log:[SUM]   0.00-10.00  sec   704 MBytes   591 Mbits/sec  10044             sender
tt8.log:[SUM]   0.00-10.10  sec   689 MBytes   573 Mbits/sec                  receiver
tt9.log:[SUM]   0.00-1.00   sec  80.2 MBytes   673 Mbits/sec  1032             
tt9.log:[SUM]   1.00-2.00   sec  73.9 MBytes   620 Mbits/sec  1006             
tt9.log:[SUM]   2.00-3.00   sec  71.7 MBytes   601 Mbits/sec  936             
tt9.log:[SUM]   3.00-4.00   sec  72.6 MBytes   609 Mbits/sec  939             
tt9.log:[SUM]   4.00-5.00   sec  72.5 MBytes   608 Mbits/sec  1059             
tt9.log:[SUM]   5.00-6.00   sec  73.2 MBytes   614 Mbits/sec  1457             
tt9.log:[SUM]   6.00-7.00   sec  73.1 MBytes   613 Mbits/sec  869             
tt9.log:[SUM]   7.00-8.00   sec  74.2 MBytes   623 Mbits/sec  1090             
tt9.log:[SUM]   8.00-9.00   sec  74.7 MBytes   627 Mbits/sec  819             
tt9.log:[SUM]   9.00-10.00  sec  74.9 MBytes   628 Mbits/sec  940             
tt9.log:[SUM]   0.00-10.00  sec   741 MBytes   622 Mbits/sec  10147             sender
tt9.log:[SUM]   0.00-10.05  sec   722 MBytes   602 Mbits/sec                  receiver
root@iperf3-clients-4cqqc:/# 
```

测下来：
1）iperf3工具并发数1～2000对结果没啥影响，都接近单个10G网卡的带宽极限
