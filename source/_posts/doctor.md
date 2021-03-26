title: Doctor framework
date: 2017-06-14 11:51:04
categories:
- NFV
tags:
- Doctor
---

Openstack社区一直没有专门的VM HA的组件来支持VM HA，所以各个厂商有这个需要都自己开发。

社区给的解释是，VM HA是应用层考虑的事情，而不是Iaas层考虑的事情。

OPNFV Doctor项目本身没有代码，而是集成测试上游项目Openstack的几个项目，将其整合成一套支持VM HA的框架。写这篇文章就是来介绍该框架的。



# Collecting Statistic and Events with collectd

![Collecting Statistic and Events with collectd](/images/doctor/collectd.png)
Collectd有Ceilometer的插件，也有SNMP的插件。可以和ceilometer连接，也可以通过发送snmp消息和其他组件传递消息。



# Doctor: mapping to the OpenStack ecosystem
![Doctor: mapping to the OpenStack ecosystem](/images/doctor/doctor-openStack-ecosystem.png)



# Policy example

host_down(host) :-
            doctor:events(hostname=host, type="compute.host.down", status="down")
execute[nova:services.force_down(host, "nova-compute", "True")] :-
            host_down(host)



# Congress Doctor Driver
![Congress Doctor Driver](/images/doctor/Congress-Doctor-Driver.png)

