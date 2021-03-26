title: Openstack中的虚拟机的cpu绑定
date: 2018-07-13 20:09:41
categories:
- Openstack_dev
tags:
- cpu绑定
---

# vcpu绑定配置

    # vim /etc/nova/nova.conf

    [DEFAULT]
    vcpu_pin_set = 4-12,^8,15     

重启nova服务，所有实例只能跑在CPUs 4,5,6,7,9,10,11,12,15上。

# 设置cpu绑定策略

flavor extra specs：

hw:cpu_policy=shared|dedicated
hw:cpu_threads_policy=avoid|separate|isolate|prefer

属性配置说明参见：http://specs.openstack.org/openstack/nova-specs/specs/kilo/implemented/virt-driver-cpu-pinning.html

也就是说这个所谓的绑定，并不是让用户显式的将一个vcpu绑定到某一物理cpu上，openstack不会暴露给用户物理cpu的layout信息；它的使用只是由用户指定绑定选项dedicated，并制定绑定策略，由nova来通过一系列调度具体选择绑定某个vcpu到某一pcpu上。使用方法一般是建两个host-aggregate，一个叫cpu_pinning，一个叫normal，两个aggregate加入不同物理机，有绑定需求的虚机使用cpu_pinning这个aggregate中的物理机建虚机。不会将有绑定需求和没有绑定需求的cpu放在同一个物理机上

也可以通过修改虚拟机XML配置文件指定vcpu绑定到某一个具体的pcpu

<!-- more -->

# 手动修改cpu绑定

修改虚拟机XML配置文件：

      <vcpu placement='static' cpuset='0'>1</vcpu>
    ...
        <topology sockets='1' cores='1' threads='1'/>
    
    # virsh vcpupin instance-00008205
    VCPU: CPU Affinity
    ----------------------------------
       0: 0
    
    # virsh vcpuinfo instance-00008205
    VCPU:           0
    CPU:            0
    State:          running
    CPU time:       7.7s
    CPU Affinity:   y---------------
    
      <vcpu placement='static' cpuset='0,2,4,10,12'>5</vcpu>
      <cputune>
        <vcpupin vcpu='0' cpuset='0'/>
        <vcpupin vcpu='1' cpuset='2'/>
        <vcpupin vcpu='2' cpuset='12'/>
        <vcpupin vcpu='3' cpuset='10'/>
        <vcpupin vcpu='4' cpuset='4'/>
      </cputune>
    
        <topology sockets='1' cores='5' threads='1'/>
    
    # virsh vcpupin instance-00008205
    VCPU: CPU Affinity
    ----------------------------------
       0: 0
       1: 2
       2: 12
       3: 10
       4: 4
    
    # virsh vcpuinfo instance-00008205
    VCPU:           0
    CPU:            0
    State:          running
    CPU time:       35.4s
    CPU Affinity:   y---------------
    
    VCPU:           1
    CPU:            2
    State:          running
    CPU Affinity:   --y-------------
    
    VCPU:           2
    CPU:            12
    State:          running
    CPU Affinity:   ------------y---
    
    VCPU:           3
    CPU:            10
    State:          running
    CPU Affinity:   ----------y-----
    
    VCPU:           4
    CPU:            4
    State:          running
    CPU Affinity:   ----y-----------

# 自动修改cpu绑定

![cpu绑定](/images/cpupin/cpupin.jpg)

```python
            # 通过修改虚拟机xml配置文件，制定vcpu和pcpu的绑定关系
            ssh_client = SSHClient(ip, user, password)
            cputune_subxml = ""
            cpuset = []
            for cpu_pin in cpu_pin_info:
                cpu_pin_xml = ("<vcpupin vcpu='%s' cpuset='%s'/>"
                               % (cpu_pin[0], cpu_pin[1]))
                cputune_subxml += cpu_pin_xml
                cpuset.append(str(cpu_pin[1]))
            sed_command = ("s|<vcpu placement=.*$|"
                           "<vcpu placement='static' cpuset='%s'>%s</vcpu>|g;"
                           "s|<topology sockets=.*$|"
                           "<topology sockets='1' cores='%s' threads='1'/>|g;"
                           % (",".join(cpuset), len(cpu_pin_info),
                              len(cpu_pin_info)))
            if cputune_subxml:
                sed_command += ("/<cputune>/,/<\\/cputune>/d;")
                sed_command += ("/<vcpu placement/a\\<cputune>%s<\\/cputune>"
                                % cputune_subxml)
            command = ("EDITOR=\"sed -i \\\"%s\\\"\" virsh edit %s"
                       % (sed_command, instance_name))
            LOG.debug("Set cpu pinnig. command=%s" % command)
            ssh_client.exec_command(command)
```



