title: cpu-pinning CPU绑定
date: 2017-07-20 18:30:18
categories: NFV
tags:
- cpu-pinning
---

既然我们的操作系统还有CPU特性都采用了NUMA架构，那么我们完全可以通过调整KVM对应的NUMA关系来达到KVM CPU这方面的优化。这里，我们一般是通过CPU绑定的方法来做相关操作的。

虚拟机vCPU核绑定亲和性：支持虚拟机vCPU与物理CPU内核的亲和性策略, VCPU与物理CPU一一绑定，不同VM运行在不同的物理CPU上，即VM间不共享物理CPU，避免超配带来的性能下降和不确定性；

比如我们要看这个Win7-ent虚拟机里vCPU对应物理CPU的情况，那么可以运行： # virsh vcpuinfo Win7-ent  可以查看

![cpu-pinning-1](/images/cpu-pinning/cpu-pinning-1.png)

这个虚拟机是2个vCPU 双核的，然后都是跑在了物理机的CPU8上，使用的时间是2964.6s。最后一个是CPU的亲和性，这个yyyyy 表示的是使用的物理CPU内部的逻辑核，一个y就代表其中一个CPU逻辑核。全部是y ，那么说明这台物理机的24个CPU核，这个CPU都能调度使用。

可以进入vrish ，然后运行emulatorpin Win7-ent， 通过这个命令我们可以更详细的得到这个虚拟机可以用哪几个核：

![cpu-pinning-1](/images/cpu-pinning/cpu-pinning-2.png)

我们可以看到目前这个虚拟机0-23的CPU它都能调度使用

那么以上就是查看虚拟机CPU NUMA调度的信息，如果我们要把虚拟机绑定到固定的CPU上，我们就要做以下操作： # virsh emulatorpin Win7-ent 18-23 –live   通过这个命令，我们把这个win7的虚拟机vCPU绑定在了18-23这6个CPU之间的核上。

我们用命令查看下 emulatorpin Win7-ent

![cpu-pinning-1](/images/cpu-pinning/cpu-pinning-3.png)

也可以用virsh dumpxml Win7-ent 查看确认：

![cpu-pinning-1](/images/cpu-pinning/cpu-pinning-4.png)

一个虚拟机我有两个vCPU, 比如这个win7 ，它就是双核的，我想让里面的vCPU1和vCPU2分别绑定在不同的物理CPU上可以吗？怎么操作呢？这也是可以的，我们通过下面的方法可以进行相关的vCPU分别绑定

    # virsh vcpupin Win7-ent 0 22
    
    # virsh vcpupin Win7-ent 1 23
    
    # virsh dumpxml Win7-ent

![cpu-pinning-1](/images/cpu-pinning/cpu-pinning-5.png)

    # virsh vcpuinfo Win7-ent

![cpu-pinning-1](/images/cpu-pinning/cpu-pinning-6.png)

这里要注意的是，你把虚拟机用reboot重启，这个绑定配置还是生效的，但是你shutdown的话，CPU绑定的效果会失效。我们要让VM关机然后起来也生效，就必须把参数写入到虚拟机的XML里，然后保存，这样关机了也不会失效。







