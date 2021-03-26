title: k8s支持Capability机制
date: 2020-05-22 15:18:59
categories: 容器
tags:
- k8s
- Kubernetes
- Capability
- SYS_TIME

---

Docker Container Capabilities

在docker run命令中，我们可以通过`--cap-add`和`--cap-drop`来给容器添加`linux Capabilities`。下面表格中的列出的Capabilities是docker默认给容器添加的，用户可以通过`--cap-drop`去除其中一个或者多个。

| Docker’s capabilities |	Linux capabilities |	Capability Description |
| ---- | ---- | --------------------------------------------------------------------------------------------------------------------------------- |
| SETPCAP |	CAP_SETPCAP |	Modify process capabilities. |
| MKNOD |	CAP_MKNOD |	Create special files using mknod(2). |
| AUDIT_WRITE |	CAP_AUDIT_WRITE |	Write records to kernel auditing log. |
| CHOWN |	CAP_CHOWN |	Make arbitrary changes to file UIDs and GIDs (see chown(2)). |
| NET_RAW |	CAP_NET_RAW |	Use RAW and PACKET sockets. |
| DAC_OVERRIDE |	CAP_DAC_OVERRIDE |	Bypass file read, write, and execute permission checks. |
| FOWNER |	CAP_FOWNER |	Bypass permission checks on operations that normally require the file system UID of the process to match the UID of the file. |
| FSETID |	CAP_FSETID |	Don’t clear set-user-ID and set-group-ID permission bits when a file is modified. |
| KILL |	CAP_KILL |	Bypass permission checks for sending signals. |
| SETGID |	CAP_SETGID |	Make arbitrary manipulations of process GIDs and supplementary GID list. |
| SETUID |	CAP_SETUID |	Make arbitrary manipulations of process UIDs. |
| NET_BIND_SERVICE |	CAP_NET_BIND_SERVICE | Bind a socket to internet domain privileged ports (port numbers less than 1024). |
| SYS_CHROOT |	CAP_SYS_CHROOT |	Use chroot(2), change root directory. |
| SETFCAP |	CAP_SETFCAP |	Set file capabilities. |

下面表格中列出的`Capabilities`是`docker`默认删除的`Capabilities`，用户可以通过`--cap-add`添加其中一个或者多个。

| Docker’s capabilities |	Linux capabilities |	Capability Description |
| ---- | ---- | --------------------------------------------------------------------------------------------------------------------------------- |
| SYS_MODULE |	CAP_SYS_MODULE |	Load and unload kernel modules. |
| SYS_RAWIO |	CAP_SYS_RAWIO |	Perform I/O port operations (iopl(2) and ioperm(2)). |
| SYS_PACCT |	CAP_SYS_PACCT |	Use acct(2), switch process accounting on or off. |
| SYS_ADMIN |	CAP_SYS_ADMIN |	Perform a range of system administration operations. |
| SYS_NICE |	CAP_SYS_NICE |	Raise process nice value (nice(2), setpriority(2)) and change the nice value for arbitrary processes. |
| SYS_RESOURCE |	CAP_SYS_RESOURCE |	Override resource Limits. |
| SYS_TIME |	CAP_SYS_TIME |	Set system clock (settimeofday(2), stime(2), adjtimex(2)); set real-time (hardware) clock. |
| SYS_TTY_CONFIG |	CAP_SYS_TTY_CONFIG |	Use vhangup(2); employ various privileged ioctl(2) operations on virtual terminals. |
| AUDIT_CONTROL |	CAP_AUDIT_CONTROL |	Enable and disable kernel auditing; change auditing filter rules; retrieve auditing status and filtering rules. |
| MAC_OVERRIDE |	CAP_MAC_OVERRIDE |	Allow MAC configuration or state changes. Implemented for the Smack LSM. |
| MAC_ADMIN |	CAP_MAC_ADMIN |	Override Mandatory Access Control (MAC). Implemented for the Smack Linux Security Module (LSM). |
| NET_ADMIN |	CAP_NET_ADMIN |	Perform various network-related operations. |
| SYSLOG |	CAP_SYSLOG |	Perform privileged syslog(2) operations. |
| DAC_READ_SEARCH |	CAP_DAC_READ_SEARCH |	Bypass file read permission checks and directory read and execute permission checks. |
| LINUX_IMMUTABLE |	CAP_LINUX_IMMUTABLE |	Set the FS_APPEND_FL and FS_IMMUTABLE_FL i-node flags. |
| NET_BROADCAST |	CAP_NET_BROADCAST |	Make socket broadcasts, and listen to multicasts. |
| IPC_LOCK |	CAP_IPC_LOCK |	Lock memory (mlock(2), mlockall(2), mmap(2), shmctl(2)). |
| IPC_OWNER |	CAP_IPC_OWNER |	Bypass permission checks for operations on System V IPC objects. |
| SYS_PTRACE |	CAP_SYS_PTRACE |	Trace arbitrary processes using ptrace(2). |
| SYS_BOOT |	CAP_SYS_BOOT |	Use reboot(2) and kexec_load(2), reboot and load a new kernel for later execution. |
| LEASE |	CAP_LEASE |	Establish leases on arbitrary files (see fcntl(2)). |
| WAKE_ALARM |	CAP_WAKE_ALARM |	Trigger something that will wake up the system. |
| BLOCK_SUSPEND |	CAP_BLOCK_SUSPEND |	Employ features that can block system suspend. |

比如，我们可以通过给给容器add NET_ADMIN Capability，使得我们可以对network interface进行modify，对应的docker run命令如下：

    $ docker run -it --rm --cap-add=NET_ADMIN ubuntu:14.04 ip link add dummy0 type dummy




在Kubernetes对Pod的定义中，用户可以`add/drop Capabilities`在`Pod.spec.containers.sercurityContext.capabilities`中添加要add的Capabilities list和drop的Capabilities list。

    [root@paasm1 ~]# cat pause.yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: pause
    spec:
      containers:
        - name:  pause
          image: registry.paas/cmss/busybox
          command: [ "sh", "-c", "sleep 1h" ]
    
    [root@paasm1 ~]# kubectl create -f pause.yaml
    pod/pause created
    [root@paasm1 ~]# kubectl get pod
    NAME                                        READY   STATUS             RESTARTS   AGE
    docker-paasn1                               0/1     Pending            0          19d
    independent-jaguar-nginx-647f7998cd-gstrj   0/1     ImagePullBackOff   0          45h
    pause                                       1/1     Running            0          27s
    r00tf0rm3                                   0/1     ErrImagePull       0          19d
    [root@paasm1 ~]# kubectl exec pause -it sh
    / # vi
    / # date
    Fri May 22 06:44:13 UTC 2020
    / # date -s 09:09
    date: can't set date: Operation not permitted
    Fri May 22 09:09:00 UTC 2020
    / # [root@paasm1 ~]#

Pod pause不能修改系统时间

    [root@paasm1 ~]# cat pause1.yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: pause1
    spec:
      containers:
        - name:  pause1
          image: registry.paas/cmss/busybox
          command: [ "sh", "-c", "sleep 1h" ]
          securityContext:
            capabilities:
              add: ["NET_ADMIN","SYS_TIME"]
    
    [root@paasm1 ~]# kubectl create -f pause1.yaml
    pod/pause1 created
    [root@paasm1 ~]# kubectl get pod
    NAME                                        READY   STATUS             RESTARTS   AGE
    docker-paasn1                               0/1     Pending            0          19d
    independent-jaguar-nginx-647f7998cd-gstrj   0/1     ImagePullBackOff   0          45h
    pause                                       1/1     Running            0          7m42s
    pause1                                      1/1     Running            0          30s
    r00tf0rm3                                   0/1     ErrImagePull       0          19d
    [root@paasm1 ~]# kubectl exec pause1 -it sh
    / # date
    Fri May 22 01:13:12 UTC 2020
    / # date -s 20:20
    Fri May 22 20:20:00 UTC 2020
    / # date
    Fri May 22 20:20:01 UTC 2020
    / # [root@paasm1 ~]#

Pod pause1可以修改系统时间
