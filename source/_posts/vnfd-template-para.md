title: VNFD模板参数化
date: 2016-07-05 22:57:33
categories: NFV
tags:
  - VNFD
  - template
  - parameter

---

# 概要

VNFD参数化可以实现通过单个VNFD文件和不同的VDU的参数以及值进行多次部署。
相反，若使用非参数化的VNFD，因为是参数的值都是不可变的，静态的，这样会限制通过单个VNFD同时部署VNF的数量。例如，部署一个非参数化的含有固定IP地址的实例，再次通过该VNFD部署的时候，若不删除第一次生产的VNF实例将会导致一个错误。



# 非参数化的VNFD模板

下面是一个非参数化的VNFD例子。下一节将举例如何下面的非参数化的VNFD模板可以被参数化以及在部署多VNFs时重用。
```
    template_name: cirros_user_data
    description: Cirros image
    service_properties:
        Id: cirros
        vendor: ACME
        version: 1
        type:
            - router
            - firewall
    vdus:
        vdu1:
            id: vdu1
            vm_image: cirros-0.3.4-x86_64-uec
            instance_type: m1.tiny
            service_type: firewall
            mgmt_driver: noop
            user_data: |
                #!/bin/sh
                echo “my hostname is `hostname`” > /tmp/hostname
                df -h > /home/cirros/diskinfo
            user_data_format: RAW
            network_interfaces:
                management:
                    network: net_mgmt
                    management: True
                    addresses:
                        - 192.168.120.11
                pkt_in:
                    network: net0
                pkt_out:
                    network: net1
            placement_policy:
                availability_zone: nova
            auto-scaling: noop
            monitoring_policy: noop
            failure_policy: noop
            config:
                param0: key0
                param1: key1
```


# 参数化的VNFD模板

该小节将对上节的模板做参数化以达到重用和对同一模板进行多次部署VNFs。作为演示，假设终端用户要在每一次部署VNF时对下面的参数赋不同的值： instance_type, user_data, user_data_format and management interface IP addresses

下一步在部署的时候替代下面的参数值{ get_input: <param_name>}。例如，实例类型m1.tiny替代instance_type: {get_input: flavor}。get_input是模板中的关键字，表示在部署VNF的时候有值提供给参数instance_type。

当参数化 instance_type, user_data, user_data_format and management interface IP addresses时，上一节的模板将如下：
```
    template_name: cirros_user_data
    description: Cirros image
    service_properties:
        Id: cirros
        vendor: ACME
        version: 1
        type:
            - router
            - firewall
    vdus:
        vdu1:
            id: vdu1
            vm_image: cirros-0.3.4-x86_64-uec
            instance_type: {get_input: flavor }
            service_type: firewall
            mgmt_driver: noop
            user_data: {get_input: user_data_value}
            user_data_format: {get_input: user_data_format_value}
            network_interfaces:
                management:
                    network: net_mgmt
                    management: True
                    addresses: { get_input: mgmt_ip}
                pkt_in:
                    network: net0
                pkt_out:
                    network: net1
            placement_policy:
                availability_zone: nova
            auto-scaling: noop
            monitoring_policy: noop
            failure_policy: noop
            config:
                param0: key0
                param1: key1
```



# 在VNF部署时候需要提供的包含参数和值文件

下面的例子是部署时候需要提供的包含参数和值文件，用于在部署VNF时替代上面的模板中的参数化部分。
在关键字‘param’下面包含变量和其值，用于替换VNFD模板中的参数化内容。没有关键字‘param’将导致VNF部署失败。

```
    vdus:
        vdu1:
            param:
                flavor: m1.tiny
                mgmt_ip:
                    - 192.168.120.11
                user_data_format_value: RAW
                user_data_value: |
                    #!/bin/sh echo “my hostname is hostname” > /tmp/hostname df -h > /home/cirros/diskinfo
```



# 要点总结：
- 若你想在部署多VNF时重用VNFD那么就参数化你的模板
- 使用参数化的VNFD，在部署时需要提供VNFD模板中参数的值，形式为 {get_input: <param_value_name>}，‘param_value_name’ 为部署时候需要提供的包含参数和值文件中的变量。
- 部署时候需要提供的包含参数和值文件格式为yaml，参数的值在每一次部署均为不同。
- 注意IP地址要为下面的格式（部署时候需要提供的包含参数和值文件中）
```
    param_name_value:
        - xxx.xxx.xxx.xxx
```
- 通过python-tackerclient的vnf-create命令指定参数化VNFD模板以及包含参数和值文件的例子：“vnf-create –vnfd-name <vnfd_name> –param-file <param_yaml_file> –name <vnf_name>”
- 也可通过 Horizon UI 在生成VNF时指定参数的值
