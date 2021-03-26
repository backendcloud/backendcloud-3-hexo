title: sriov计算节点转ovs计算节点脚本
date: 2019-04-19 16:50:16
categories:
- Openstack_op
tags:
- sriov
- ovs
- 脚本

---

因为有时候需要更改计算节点的功能，批量将sriov计算节点转成ovs计算节点。

就把手动修改的命令一条条排列组成脚本，然后用ansible工具批量运行下面的将sriov计算节点，转ovs计算节点的脚本。

```bash
# cat sriov2ovs.bash

# 关闭物理网卡sriov vf的配置
echo '0' > /sys/class/net/ens1f0/device/sriov_numvfs
sed -i '/sriov_numvfs/d' /etc/rc.d/rc.local

# stop neutron-sriov-nic-agent服务，并disable掉，因为要启用neutron ovs服务
systemctl disable neutron-sriov-nic-agent
systemctl stop neutron-sriov-nic-agent

# 删除nova.conf sriov直通白名单配置
sed -i '/passthrough_whitelist/d' /etc/nova/nova.conf
systemctl restart openstack-nova-compute

# 物理网卡配置
# configure bond
(cat <<HERE
TYPE=Ethernet
BOOTPROTO=none
NAME=ens1f0
DEVICE=ens1f0
ONBOOT=yes
MASTER=bond1
SLAVE=yes

HERE
)> /etc/sysconfig/network-scripts/ifcfg-ens1f0

(cat <<HERE
TYPE=Ethernet
BOOTPROTO=none
NAME=ens1f1
DEVICE=ens1f1
ONBOOT=yes
MASTER=bond1
SLAVE=yes

HERE
)> /etc/sysconfig/network-scripts/ifcfg-ens1f1

(cat <<HERE
BOOTPROTO=none
DEVICE=bond1
ONBOOT=yes
## MTU=1500
TYPE=Bond
BONDING_OPTS="mode=active-backup miimon=100"

HERE
)> /etc/sysconfig/network-scripts/ifcfg-bond1

# 修改对数据包源地址的校验配置
sed -i '/net\.ipv4\.conf\.all\.rp_filter/d' /etc/rc.d/rc.local
sed -i '/net\.ipv4\.conf\.default\.rp_filter/d' /etc/rc.d/rc.local
sed -i '$a\net.ipv4.conf.all.rp_filter=0' /etc/sysctl.conf
sed -i '$a\net.ipv4.conf.default.rp_filter=0' /etc/sysctl.conf
sysctl -p

# 安装neutron-openvswitch等服务
yum install -y openstack-neutron openstack-neutron-ml2 openstack-neutron-openvswitch openvswitch

# 配置openvswitch_agent.ini文件，配置物理网卡到网桥的映射，并重启网络相关服务
# neutron.conf
# /etc/neutron/plugins/ml2/openvswitch_agent.ini
(cat <<HERE
[DEFAULT]

[agent]
extensions = qos

[ovs]
integration_bridge = br-int
bridge_mappings = physnet1:br-prv

[securitygroup]
enable_ipset = true
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver

HERE
)> /etc/neutron/plugins/ml2/openvswitch_agent.ini

systemctl enable  openvswitch.service
systemctl restart  openvswitch.service
systemctl status  openvswitch.service

# 增加之前配置物理网卡到网桥的映射的网桥和网卡连接
ovs-vsctl add-br br-prv
ovs-vsctl add-port br-prv bond1

systemctl enable neutron-openvswitch-agent.service
systemctl restart neutron-openvswitch-agent.service
```

