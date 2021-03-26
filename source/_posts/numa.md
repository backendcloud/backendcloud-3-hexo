title: NUMA 非一致性内存访问
date: 2017-07-20 17:47:16
categories: NFV
tags:
- NUMA
---

# SMP（Symmetric Multi-Processing ）

SMP技术就是对称多处理结构，这种结构的最大特点就是CPU共享所有资源，比如总线，内存，IO系统等等

![SMP](/images/numa/numa-1.png)



# NUMA 非一致性内存访问

NUMA架构设计图：

![SMP](/images/numa/numa-2.png)

在NUMA中还有三个节点的概念：

* 本地节点： 对于某个节点中的所有CPU，此节点称为本地节点。
* 邻居节点：与本地节点相邻的节点称为邻居节点。
* 远端节点：非本地节点或邻居节点的节点，称为远端节点。

CPU访问不同类型节点内存的速度是不相同的，访问本地节点的速度最快，访问远端节点的速度最慢，即访问速度与节点的距离有关，距离越远访问速度越慢，此距离称作Node Distance。正是因为有这个特点，所以我们的应用程序要尽量的减少不通CPU模块之间的交互，也就是说，如果你的应用程序能有方法固定在一个CPU模块里，那么你的应用的性能将会有很大的提升。

因此KVM也是一样，我们在CPU优化这块就是要让KVM绑定在指定的CPU上，这样减少跨CPU的交互使用，让KVM的性能提升。现在我们的服务器还有linux操作系统都是默认走NUMA模式。所以numa和cpu-pinning（cpu绑定）是密不可分的。

NFV对底层NFVI需支持将虚拟机的CPU和内存部署在同一个NUMA(Non Uniform Memory Access，非一致性内存访问)内，从而降低内存访问的时延 。

虚拟机NUMA亲和性：支持虚拟机numa亲和性策略,保证虚拟机vCPU、内存、直通网卡在同一NUMA节点，避免CPU访问远端内存导致业务时延大等问题

    # numactl --hardware
    available: 2 nodes (0-1)
    node 0 cpus: 0 1 2 3
    node 0 size: 8191 MB
    node 0 free: 6435 MB
    node 1 cpus: 4 5 6 7
    node 1 size: 8192 MB
    node 1 free: 6634 MB
    node distances:
    node   0   1
      0:  10  20
      1:  20  10
    
    # virsh capabilities
    ...
       <topology>
              <cells num='2'>
                <cell id='0'>
                  <memory unit='KiB'>4193872</memory>
                  <pages unit='KiB' size='4'>1048468</pages>
                  <pages unit='KiB' size='2048'>0</pages>
                  <distances>
                    <sibling id='0' value='10'/>
                    <sibling id='1' value='20'/>
                  </distances>
                  <cpus num='4'>
                    <cpu id='0' socket_id='0' core_id='0' siblings='0'/>
                    <cpu id='1' socket_id='0' core_id='1' siblings='1'/>
                    <cpu id='2' socket_id='0' core_id='2' siblings='2'/>
                    <cpu id='3' socket_id='0' core_id='3' siblings='3'/>
                  </cpus>
                </cell>
                <cell id='1'>
                  <memory unit='KiB'>4194304</memory>
                  <pages unit='KiB' size='4'>1048576</pages>
                  <pages unit='KiB' size='2048'>0</pages>
                  <distances>
                    <sibling id='0' value='20'/>
                    <sibling id='1' value='10'/>
                  </distances>
                  <cpus num='4'>
                    <cpu id='4' socket_id='1' core_id='0' siblings='4'/>
                    <cpu id='5' socket_id='1' core_id='1' siblings='5'/>
                    <cpu id='6' socket_id='1' core_id='2' siblings='6'/>
                    <cpu id='7' socket_id='1' core_id='3' siblings='7'/>
                  </cpus>
                </cell>
              </cells>
            </topology>
    ...


TOSCA NFVD (VNF Descriptor):

    ....
    VDU1:
      capabilities:
        nfv_compute:
          properties:
            mem_size: 4096 MB
            num_cpus: 4
            numa_nodes:
              node0:
                id: 0
                vcpus: [0,1]
                mem_size: 1024 MB
              node1:
                id: 1
                vcpus: [2,3]
                mem_size: 3072 MB
    ...

