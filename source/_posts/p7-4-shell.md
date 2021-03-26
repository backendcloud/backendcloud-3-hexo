title: 脚本安装Openstack Pike
date: 2017-12-28 20:43:27
categories:
- Openstack_op
tags:
- Openstack Pike
- 安装
---

[完整shell脚本](/files/p7.4_shell/pike.install.sh)

环境：
* centos 7.4.1708 x86_64
* all in one node
* 网络采用linux bridge，非ovs

<!-- more -->

检查linux版本；确认root用户
```bash
[[ `uname -r` = *el7* ]] && { echo '开启安装openstack pike'; } || { echo '请在CentOS7.4 环境运行';exit; }
[[ $(whoami) == root ]] || { sudo su - root; }
[[ $? = 0 ]] || { echo 'Must run in root !';exit; }
```

列出一些参数供后面的脚本使用，-F'[ /]+'用了正则，意思是以空格和/作为分隔
```bash
#参数

#获取第一块网卡名、ip地址
Net=`ip add|egrep global|awk '{ print $NF }'|head -n 1`
IP=`ip add|grep global|awk -F'[ /]+' '{ print $3 }'|head -n 1`
echo  "网卡名称:$Net"
echo  "IP地址:  $IP"

#参数
DBPass=elven2017    #SQL root密码
Node=controller     #节点名(controller不要改动)
Netname=$Net        #网卡名称
MyIP=$IP            #IP地址
VncProxy=$IP        #VNC代理外网IP地址
Imgdir=/data/glance #自定义glance镜像目录
VHD=/data/nova      #自定义Nova实例路径
Kvm=qemu            #QEMU或KVM ,KVM需要硬件支持
```

关闭selinux、防火墙；设置yum源；时间同步
```bash
echo  '关闭selinux、防火墙'
systemctl stop firewalld.service
systemctl disable firewalld.service
firewall-cmd --state
sed -i '/^SELINUX=.*/c SELINUX=disabled' /etc/selinux/config
sed -i 's/^SELINUXTYPE=.*/SELINUXTYPE=disabled/g' /etc/selinux/config
grep --color=auto '^SELINUX' /etc/selinux/config
setenforce 0

echo  '设置hostname'
hostnamectl set-hostname $Node
echo "$MyIP   $Node">>/etc/hosts

#使用阿里源
rm -f /etc/yum.repos.d/*
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
sed -i '/aliyuncs.com/d' /etc/yum.repos.d/*.repo #删除阿里内网地址#

echo  '自定义openstack源'
#yum install centos-release-openstack-pike -y #安装OpenStack源#
curl -o /etc/yum.repos.d/Ali-pike.repo http://elven.vip/ks/openstack/Ali-pike.repo
yum clean all && yum makecache #生成缓存

echo  '时间同步'
[[ -f /usr/sbin/ntpdate ]] || { echo "install ntp";yum install ntp ntpdate -y &> /dev/null; } #若没NTP则安装
/usr/sbin/ntpdate ntp6.aliyun.com 
echo "*/3 * * * * /usr/sbin/ntpdate ntp6.aliyun.com  &> /dev/null" > /tmp/crontab
crontab /tmp/crontab
```

完成所有rpm包的安装，执行2次，防止因为下载失败导致rpm没有安装的情况
```bash
function installrpm() 
{
yum install -y ntp wget vim net-tools openssh tree &> /dev/null
echo  'OpenStack tools 安装'
yum install -y python-openstackclient openstack-selinux \
  python2-PyMySQL openstack-utils 
echo  'MariaDB安装'
yum install mariadb mariadb-server mariadb-galera-server -y
yum install expect -y
echo  'RabbitMQ安装'
yum install rabbitmq-server erlang socat -y
echo  'Keystone安装'
yum install -y openstack-keystone httpd mod_wsgi memcached python-memcached
yum install apr apr-util -y
echo  '安装Glance'
yum install -y openstack-glance python-glance
echo  '安装nova'
yum install -y openstack-nova-api openstack-nova-conductor \
  openstack-nova-console openstack-nova-novncproxy \
  openstack-nova-scheduler openstack-nova-placement-api \
  openstack-nova-compute
echo  '安装neutron'
yum install -y openstack-neutron openstack-neutron-ml2 \
 openstack-neutron-linuxbridge python-neutronclient ebtables ipset
echo  '安装dashboard'
yum install openstack-dashboard -y
}

echo  '安装openstack'
installrpm
echo  '再次安装，防止下载失败'
installrpm &> /dev/null
```

接下来是配置各个组件和数据库，略去...

安装成功后测试启动一个vm实例
```bash
source ./admin-openstack.sh
echo ' 创建秘钥'
ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
nova keypair-add --pub-key ~/.ssh/id_dsa.pub mykey

echo ' 创建云主机类型'
openstack flavor create --id 1 --vcpus 1 --ram 512 --disk 5  m1.nano

echo '安全规则'
openstack security group rule create --proto icmp default
openstack security group rule create --proto tcp --dst-port 22 'default'

echo '创建网络'
openstack network create --share --external --provider-physical-network provider --provider-network-type flat public
#本机网段
IPS=`echo $IP|awk -F\. '{ print $1"."$2"."$3 }'` 
#创建子网
openstack subnet create --network public --allocation-pool start=$IPS.70,end=$IPS.100 \
 --dns-nameserver 119.29.29.29 --gateway $IPS.1 --subnet-range $IPS.0/24 public-lan

echo '下载测试镜像'
echo ''
wget http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img

echo '上传镜像到镜像服务'
openstack image create "cirros" --file cirros-0.3.5-x86_64-disk.img \
  --disk-format qcow2 --container-format bare --public

echo '创建虚拟机 kvm01'
NET=`openstack network list|grep 'public'|awk '{print $2}'`
nova boot --flavor m1.nano --image cirros \
  --nic net-id=$NET --security-group default --key-name mykey \
  kvm01
echo '查看虚机列表'
sleep 18
openstack server list
echo ''
echo '虚机 kvm01 控制台访问地址'
openstack console url show kvm01|awk ' /http/ { print $4 }'
```

检查生成的vm实例的状态

    [root@controller ~]# nova list
    +--------------------------------------+-------+--------+------------+-------------+-----------------------+
    | ID                                   | Name  | Status | Task State | Power State | Networks              |
    +--------------------------------------+-------+--------+------------+-------------+-----------------------+
    | c549f904-4ef7-4d40-9101-c53796665996 | kvm01 | ACTIVE | -          | Running     | public=192.168.206.77 |
    +--------------------------------------+-------+--------+------------+-------------+-----------------------+
    [root@controller ~]# nova show kvm01
    +--------------------------------------+----------------------------------------------------------+
    | Property                             | Value                                                    |
    +--------------------------------------+----------------------------------------------------------+
    | OS-DCF:diskConfig                    | MANUAL                                                   |
    | OS-EXT-AZ:availability_zone          | nova                                                     |
    | OS-EXT-SRV-ATTR:host                 | controller                                               |
    | OS-EXT-SRV-ATTR:hostname             | kvm01                                                    |
    | OS-EXT-SRV-ATTR:hypervisor_hostname  | controller                                               |
    | OS-EXT-SRV-ATTR:instance_name        | instance-00000002                                        |
    | OS-EXT-SRV-ATTR:kernel_id            |                                                          |
    | OS-EXT-SRV-ATTR:launch_index         | 0                                                        |
    | OS-EXT-SRV-ATTR:ramdisk_id           |                                                          |
    | OS-EXT-SRV-ATTR:reservation_id       | r-u854qjqn                                               |
    | OS-EXT-SRV-ATTR:root_device_name     | /dev/vda                                                 |
    | OS-EXT-SRV-ATTR:user_data            | -                                                        |
    | OS-EXT-STS:power_state               | 1                                                        |
    | OS-EXT-STS:task_state                | -                                                        |
    | OS-EXT-STS:vm_state                  | active                                                   |
    | OS-SRV-USG:launched_at               | 2017-12-28T09:43:43.000000                               |
    | OS-SRV-USG:terminated_at             | -                                                        |
    | accessIPv4                           |                                                          |
    | accessIPv6                           |                                                          |
    | config_drive                         |                                                          |
    | created                              | 2017-12-28T09:43:04Z                                     |
    | description                          | -                                                        |
    | flavor:disk                          | 5                                                        |
    | flavor:ephemeral                     | 0                                                        |
    | flavor:extra_specs                   | {}                                                       |
    | flavor:original_name                 | m1.nano                                                  |
    | flavor:ram                           | 512                                                      |
    | flavor:swap                          | 0                                                        |
    | flavor:vcpus                         | 1                                                        |
    | hostId                               | 9a199918e4eaa7609f034f7ea5673901064c5648122da48055fd4be9 |
    | host_status                          | UP                                                       |
    | id                                   | c549f904-4ef7-4d40-9101-c53796665996                     |
    | image                                | cirros (2ff90b8a-f268-4b13-826e-1480555cee72)            |
    | key_name                             | mykey                                                    |
    | locked                               | False                                                    |
    | metadata                             | {}                                                       |
    | name                                 | kvm01                                                    |
    | os-extended-volumes:volumes_attached | []                                                       |
    | progress                             | 0                                                        |
    | public network                       | 192.168.206.77                                           |
    | security_groups                      | default                                                  |
    | status                               | ACTIVE                                                   |
    | tags                                 | []                                                       |
    | tenant_id                            | 2b66b2184bce441dac04b7f6cad860b7                         |
    | updated                              | 2017-12-28T09:43:43Z                                     |
    | user_id                              | dde8a45affd8461c8bf21e1012f02a33                         |
    +--------------------------------------+----------------------------------------------------------+

ssh ip方式登录

    [root@controller ~]# ssh cirros@192.168.206.77
    $ cd /etc
    $ ls
    TZ             blkid.tab      cirros         default        fstab          hostname       init.d         inputrc        ld.so.conf     mke2fs.conf    mtab           os-release     profile        random-seed    resolv.conf    securetty      shadow         sudoers
    acpi           blkid.tab.old  cirros-init    dropbear       group          hosts          inittab        issue          ld.so.conf.d   modules        network        passwd         protocols      rc3.d          screenrc       services       ssl            sudoers.d
    $ cat cirros/version 
    0.3.5

用openstack命令登陆

    [root@controller ~]# openstack server ssh --login cirros kvm01
    $ cd /etc
    $ ls
    TZ             blkid.tab      cirros         default        fstab          hostname       init.d         inputrc        ld.so.conf     mke2fs.conf    mtab           os-release     profile        random-seed    resolv.conf    securetty      shadow         sudoers
    acpi           blkid.tab.old  cirros-init    dropbear       group          hosts          inittab        issue          ld.so.conf.d   modules        network        passwd         protocols      rc3.d          screenrc       services       ssl            sudoers.d
    $ cat cirros/version
    0.3.5

novnc登陆界面
![novnc](/images/p7.4_shell/1.jpg)
