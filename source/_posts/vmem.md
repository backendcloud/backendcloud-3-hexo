title: 内存虚拟化
date: 2017-07-19 05:17:46
categories: NFV
tags:
- KSM
- Huge Page
---

# 内存虚拟化

除了 CPU 虚拟化，另一个关键是内存虚拟化，通过内存虚拟化共享物理系统内存，动态分配给虚拟机。虚拟机的内存虚拟化很象现在的操作系统支持的虚拟内存方式，应用程序看到邻近的内存地址空间，这个地址空间无需和下面的物理机器内存直接对应，操作系统保持着虚拟页到物理页的映射。

![vmem](/images/vmem/mem-1.jpg)

可见，KVM 为了在一台机器上运行多个虚拟机，需要增加一个新的内存虚拟化层，也就是说，必须虚拟 MMU 来支持客户操作系统，来实现 VA -> PA -> MA 的翻译。客户操作系统继续控制虚拟地址到客户内存物理地址的映射 （VA -> PA），但是客户操作系统不能直接访问实际机器内存，因此VMM 需要负责映射客户物理内存到实际机器内存 （PA -> MA）。

VMM 内存虚拟化的实现方式：
* 软件方式：通过软件实现内存地址的翻译，比如 Shadow page table （影子页表）技术
* 硬件实现：基于 CPU 的辅助虚拟化功能，比如 AMD 的 NPT 和 Intel 的 EPT 技术 

EPT的好处是，它的两阶段记忆体转换，特点就是将 Guest Physical Address → System Physical Address，VMM不用再保留一份 SPT (Shadow Page Table)，以及以往还得经过 SPT 这个转换过程。除了降低各部虚拟机器在切换时所造成的效能损耗外，硬体指令集也比虚拟化软体处理来得可靠与稳定。



# KSM （Kernel SamePage Merging 或者 Kernel Shared Memory）

其原理是，KSM 作为内核中的守护进程（称为 ksmd）存在，它定期执行页面扫描，识别副本页面并合并副本，释放这些页面以供它用。因此，在多个进程中，Linux将内核相似的内存页合并成一个内存页。这个特性，被KVM用来减少多个相似的虚拟机的内存占用，提高内存的使用效率。由于内存是共享的，所以多个虚拟机使用的内存减少了。这个特性，对于虚拟机使用相同镜像和操作系统时，效果更加明显。但是，事情总是有代价的，使用这个特性，都要增加内核开销，用时间换空间。所以为了提高效率，可以将这个特性关闭。

其好处是，在运行类似的客户机操作系统时，通过 KSM，可以节约大量的内存，从而可以实现更多的内存超分，运行更多的虚机。



# KVM Huge Page Backed Memory （大页内存）

这是KVM虚拟机的又一个优化技术.。Intel 的 x86 CPU 通常使用4Kb内存页，当是经过配置，也能够使用巨页(huge page): (4MB on x86_32, 2MB on x86_64 and x86_32 PAE)

使用巨页，KVM的虚拟机的页表将使用更少的内存，并且将提高CPU的效率。最高情况下，可以提高20%的效率！

使用方法，需要3步：

    mkdir /dev/hugepages
    mount -t hugetlbfs hugetlbfs /dev/hugepages

保留一些内存给巨页

    sysctl vm.nr_hugepages=2048 （使用 x86_64 系统时，这相当于从物理内存中保留了2048 x 2M = 4GB 的空间来给虚拟机使用）

给 kvm 传递参数 hugepages

    qemu-kvm - qemu-kvm -mem-path /dev/hugepages

也可以在配置文件里加入：

    <memoryBacking>
    <hugepages/>
    </memoryBacking>

验证方式，当虚拟机正常启动以后，在物理机里查看：

    cat /proc/meminfo |grep -i hugepages

电信业务网元尤其是转发面网元，在业务处理过程中，对表项的操作（增删改）非常密集，建议支持巨页内存，以减少内存访问带来的性能损耗。

