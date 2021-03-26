title: 云环境中GPU配置
date: 2017-04-29 18:49:59
categories:
- 智能云
tags:
- GPU
- 配置
---
Ocata周期的科学技术重点之一是进一步扩展OpenStack中GPU支持的状态。这里的第一个问题是我们在讨论GPU支持时正在讨论的问题，因为使用现有的OpenStack功能（例如，Nova的PCI直通支持）已经有几种可能性和组合，允许部署者利用GPU拼凑云。这里的想法是让我们了解尽可能多的可能性，同时深入了解社区经验支持它的细节。

GPU计算节点就像常规计算节点，除了它们包含一个或多个GPU卡。这些卡是以某种方式配置的他们可以传递给实例。然后，该实例可以将GPU卡用于计算或加速图形工作。

# step 1: ENABLE MEMORY MANAGEMENT

To ensure the devices perform in a virtualised / passthrough environment we need to enable IOMMU within the GPU server. IOMMU (I/O Memory Management Unit) is a feature supported by motherboard chipsets that provides enhanced virtual-to-physical memory mapping capabilities, including the ability to map large portions of non-contiguous memory. IOMMU can be enabled in the motherboard's BIOS, please refer to your server provider for instructions on how to ensure this is set. Once this is applied you can pass a boot parameter (intel_iommu=on) to the kernel at boot time to ensure its enabled and turned on within the OS.
 
Ensure Grub is configured

    [root@gpu ~]# grep intel_iommu=on /boot/grub2/grub.cfg | head -n 1
    linux16 /vmlinuz-3.10.0-327.18.2.el7.x86_64 root=UUID=33011dab-c75a-45d0-b7a2-ae23545c850f ro quiet rdblacklist=nouveau intel_iommu=on
 
Then verify IOMMU is enabled when the system is booted up in dmesg
 
    [root@gpu ~]# dmesg | grep -iE "dmar|iommu" | grep -i enabled 
    [ 0.000000] Intel-IOMMU: enabled 

# step 2: GET THE GPU IDS FOR THE NOVA CONFIGURATION

The first thing we will need to capture is the vendor ID and device ID from the host system of the GPUs we want to pass through. In the example below we are using 1x NVIDIA Tesla K80 and 1x NVIDIA GRID K2
 
check for the nvidia GPUs 

    [root@gpu ~]# lspci | grep NVIDIA 
    04:00.0 3D controller: NVIDIA Corporation GK210GL [Tesla K80] (rev a1) 
    05:00.0 3D controller: NVIDIA Corporation GK210GL [Tesla K80] (rev a1) 
    83:00.0 VGA compatible controller: NVIDIA Corporation GK104GL [GRID K2] (rev a1) 
    84:00.0 VGA compatible controller: NVIDIA Corporation GK104GL [GRID K2] (rev a1) 

get their IDs with the -n flag 

    [root@gpu ~]# lspci -nn | grep NVIDIA 
    04:00.0 3D controller [0302]: NVIDIA Corporation GK210GL [Tesla K80] [10de:102d] (rev a1) 05:00.0 3D controller [0302]: NVIDIA Corporation GK210GL [Tesla K80] [10de:102d] (rev a1) 83:00.0 VGA compatible controller [0300]: NVIDIA Corporation GK104GL [GRID K2] [10de:11bf] (rev a1) 
    84:00.0 VGA compatible controller [0300]: NVIDIA Corporation GK104GL [GRID K2] [10de:11bf] (rev a1) 
 
Based on the above we now have:
1) The vendor id is: 10de (Which corresponds to NVIDIA)
2) And the product id is: 102d and 11bf (Where 102d is the K80 and 11bf is the GRID K2)

# step 3: CONFIGURE THE GPU NOVA SERVICE

## step 3.1: CONFIGURE THE COMPUTER(S) TO BE GPU AWARE

The next step is to configure the GPU server Nova Service with the appropriate passthrough flags:
 
file: /etc/nova/nova.conf / On the GPU server 

    [DEFAULT] 
    ... 
    pci_passthrough_whitelist={"vendor_id":"10de","product_id":"102d"}
     
    Restart the nova service
     
    [root@gpu ~]# systemctl restart openstack-nova-compute 
    [root@gpu ~]#
 
## step 3.2: CONFIGURE THE CONTROLLER(S) TO BE GPU AWARE

We then need to add the PCI configuration and resource scheduling parameters to the nova.conf on the controller(s)
 
In the file: /etc/nova/nova.conf on the controller

    [DEFAULT]
    ... 
    pci_alias={"name":"K80_Tesla","vendor_id":"10de","product_id":"102d"} 
    scheduler_available_filters=nova.scheduler.filters.all_filters 
    scheduler_available_filters=nova.scheduler.filters.pci_passthrough_filter.PciPassthroughFilter 
    scheduler_default_filters=RetryFilter,AvailabilityZoneFilter,RamFilter,ComputeFilter,ComputeCapabilitiesFilter,ImagePropertiesFilter,ServerGroupAntiAffinityFilter,ServerGroupAffinityFilter,PciPassthroughFilter 
    scheduler_driver=nova.scheduler.filter_scheduler.FilterScheduler scheduler_max_attempts=5 

设定使用pci filter，是为了防止节点所有pci设备被分配完毕之后，该节点再次接收到创建pci设备的vm的请求，导致vm创建错误的问题

Restart all the nova services on the controller(s) to enable the configuration.

# step 4: SETUP THE GPU FLAVOR IN OPENSTACK

Replace with whatever CPU/RAM requirements are appropriate for your environment

    openstack flavor create --public --ram 2048 --disk 20 --vcpus 2 m1.large.2xK80 

Add a passthrough property for the flavor 

    openstack flavor set m1.large.2xK80 --property pci_passthrough:alias='K80_Tesla:2' 

Then once created you should see something like this: 

    openstack flavor show m1.large.1xK80   

    Field   Value
    OS-FLV-DISABLED:disabled    False
    OS-FLV-EXT-DATA:ephemeral   0
    disk    20
    id  481b0dd4-1148-4714-8f0b-fceb8aed884f
    name    m1.large.2xK80
    os-flavor-access:is_public  True
    properties  pci_passthrough:alias='K80_Tesla:2'
    ram 2048
    rxtx_factor 1.0
    swap     
    vcpus   2



# step 5: SPIN UP AN INSTANCE WITH YOUR NEW GPU FLAVOR

Spin up an instance with CLI/GUI and ssh in, you'll hopefully see
 
    # yum install pciutils if a barebone centos 7 
    [root@gpupass1 ~]# lspci 
    00:00.0 Host bridge: Intel Corporation 440FX - 82441FX PMC [Natoma] (rev 02) 
    00:01.0 ISA bridge: Intel Corporation 82371SB PIIX3 ISA [Natoma/Triton II] 
    00:01.1 IDE interface: Intel Corporation 82371SB PIIX3 IDE [Natoma/Triton II] 
    00:01.2 USB controller: Intel Corporation 82371SB PIIX3 USB [Natoma/Triton II] (rev 01) 
    00:01.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 03) 
    00:02.0 VGA compatible controller: Cirrus Logic GD 5446 
    00:03.0 Ethernet controller: Red Hat, Inc Virtio network device 
    00:04.0 SCSI storage controller: Red Hat, Inc Virtio block device 
    00:05.0 3D controller: NVIDIA Corporation GK210GL [Tesla K80] (rev a1) # <----- BOOM! 
    00:06.0 Unclassified device [00ff]: Red Hat, Inc Virtio memory balloon 



## 可能会出现的问题说明

对于GPU透传的虚拟机进行迁移可能会出现问题，若迁移的目标主机不支持GPU透传则迁移会失败。



# NEXT STEPS

* Performance Analysis (Performance evaluation of the GPUs within a virtualised environment in comparison to a bare metal environment.)
* GPU to GPU performance within a VM
* GPU to GPU performance across nodes (SR-IOV on Mellanox Fabric)
* P100 cards to be added to lab environment shortly.



# The GPU exclusive hypervisor instance scheduling problem

Regarding scheduling, the problem is that if you allow both GPU and non-GPU flavor instances to use a GPU enabled compute node, i.e., you don't explicitly setup aggregates that stop this, then you can end up
with your nice expensive GPU node/s being packed full of regular instances and no way to get any workload onto the 15-30k worth of GPU! You can always use aggregates to stop that from occurring, but then you end up with the reverse problem - you might have 4-8 GPUs you can assign/passthrough to VMs per compute node, and likelihood is that you have different CPU+Memory configs for these flavors, so you'll end up with all GPUs assigned but a reasonable amount of free CPU and Memory resource that could be used for other non-GPU instances.

所以这是我希望找到一个解决方法，为什么我以前讨论过调度程序“耗材”的概念，也就是说，计算主机上一个任意的方式来解释*事物*。我可以想象一个主机配置或聚合元设置，如consumerable_ <key>：<integer / float>，具有匹配的风格设置和维护每个主机的耗材的工作值的调度程序过滤器。例如，对于GPU节点使用情况，可以简单地将主机设置为consumable_regularflavor = 4，并且所有具有metadata regularflavor = 1的非GPU风格，那么调度程序将允许每个GPU节点多达4个非GPU实例，但是更多。这是一个粗略而比较幼稚的例子，忽略了边缘的情况，

