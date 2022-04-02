#!/bin/sh
# openstack pike 单机 一键安装
# 环境 centos 7.4.1708 x86_64
# 更多内容 http://dwz.cn/openstack
# Myde by Elven

[[ `uname -r` = *el7* ]] && { echo '开启安装openstack pike'; } || { echo '请在CentOS7.4 环境运行';exit; }
[[ $(whoami) == root ]] || { sudo su - root; }
[[ $? = 0 ]] || { echo 'Must run in root !';exit; }

##########################################
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

##########################################
#1、设置

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

##########################################
#2 安装

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

##########################################
#3、配置

# #------------------#####################
echo 'SQL数据库配置'
echo "#
[mysqld]
bind-address = 0.0.0.0
default-storage-engine = innodb
innodb_file_per_table
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
#">/etc/my.cnf.d/openstack.cnf
echo '启动数据库服务'
systemctl enable mariadb.service
systemctl start mariadb.service
sleep 5
netstat -antp|grep mysqld
#mysql_secure_installation #初始化设置密码,自动交互
[[ -f /usr/bin/expect ]] || { yum install expect -y; } #若没expect则安装
/usr/bin/expect << EOF
set timeout 30
spawn mysql_secure_installation
expect {
	"enter for none" { send "\r"; exp_continue}
	"Y/n" { send "Y\r" ; exp_continue}
	"password:" { send "$DBPass\r"; exp_continue}
	"new password:" { send "$DBPass\r"; exp_continue}
	"Y/n" { send "Y\r" ; exp_continue}
	eof { exit }
}
EOF
#测试
mysql -u root -p$DBPass -e "show databases;"
[ $? = 0 ] || { echo "mariadb初始化失败";exit; }

echo '创建数据库、用户授权'
mysql -u root -p$DBPass -e "
create database keystone;
grant all privileges on keystone.* to 'keystone'@'localhost' identified by 'keystone';
grant all privileges on keystone.* to 'keystone'@'%' identified by 'keystone';
create database glance;
grant all privileges on glance.* to 'glance'@'localhost' identified by 'glance';
grant all privileges on glance.* to 'glance'@'%' identified by 'glance';

create database nova;
grant all privileges on nova.* to 'nova'@'localhost' identified by 'nova';
grant all privileges on nova.* to 'nova'@'%' identified by 'nova';
create database nova_api;
grant all privileges on nova_api.* to 'nova'@'localhost' identified by 'nova';
grant all privileges on nova_api.* to 'nova'@'%' identified by 'nova';
create database nova_cell0;
grant all privileges on nova_cell0.* to 'nova'@'localhost' identified by 'nova';
grant all privileges on nova_cell0.* to 'nova'@'%' identified by 'nova';

create database neutron;
grant all privileges on neutron.* to 'neutron'@'localhost' identified by 'neutron';
grant all privileges on neutron.* to 'neutron'@'%' identified by 'neutron';

flush privileges;
select user,host from mysql.user;
show databases;
"
#
# #------------------#####################
echo 'RabbitMQ配置'
echo 'NODENAME=rabbit@controller'>/etc/rabbitmq/rabbitmq-env.conf
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
sleep 3
rabbitmq-plugins enable rabbitmq_management  #启动web插件端口15672
sleep 6
#添加用户及密码
rabbitmqctl  add_user admin admin
rabbitmqctl  set_user_tags admin administrator
rabbitmqctl add_user openstack openstack 
rabbitmqctl set_permissions openstack ".*" ".*" ".*" 
rabbitmqctl  set_user_tags openstack administrator
systemctl restart rabbitmq-server.service
sleep 3
netstat -antp|grep '5672'
[[ `rabbitmqctl list_users|grep openstack|wc -l` = 1 ]] || {
    echo 'rabbit创建用户失败'; 
    echo 'rabbit创建用户失败,请手动执行命令创建用户'>>./error.install.log; }

# #------------------#####################
#Keystone
#memcached启动
cp /etc/sysconfig/memcached{,.bak}
systemctl enable memcached.service
systemctl start memcached.service
netstat -antp|grep 11211

echo  'Keystone 配置'
cp /etc/keystone/keystone.conf{,.bak}  #备份默认配置
Keys=$(openssl rand -hex 10)  #生成随机密码
echo $Keys
echo "kestone  $Keys">/root/openstack.log
echo "
[DEFAULT]
admin_token = $Keys
verbose = true
[database]
connection = mysql+pymysql://keystone:keystone@controller/keystone
[token]
provider = fernet
driver = memcache
[memcache]
servers = controller:11211
">/etc/keystone/keystone.conf

#初始化身份认证服务的数据库
su -s /bin/sh -c "keystone-manage db_sync" keystone
#检查表是否创建成功
mysql -h controller -ukeystone -pkeystone -e "use keystone;show tables;"
#初始化密钥存储库
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
#设置admin用户（管理用户）和密码
keystone-manage bootstrap --bootstrap-password admin \
  --bootstrap-admin-url http://controller:35357/v3/ \
  --bootstrap-internal-url http://controller:5000/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne

#apache配置
cp /etc/httpd/conf/httpd.conf{,.bak}
echo "ServerName controller">>/etc/httpd/conf/httpd.conf
ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/

#Apache HTTP 启动并设置开机自启动
systemctl enable httpd.service
systemctl restart httpd.service
sleep 3
netstat -antp|egrep ':5000|:35357|:80'

#创建 OpenStack 客户端环境脚本
#admin环境脚本
echo "
export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default 
export OS_PROJECT_NAME=admin 
export OS_USERNAME=admin
export OS_PASSWORD=admin
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
">./admin-openstack.sh
#测试脚本是否生效
source ./admin-openstack.sh
openstack token issue

#创建service项目,创建glance,nova,neutron用户，并授权
openstack project create --domain default --description "Service Project" service
openstack user create --domain default --password=glance glance
openstack role add --project service --user glance admin
openstack user create --domain default --password=nova nova
openstack role add --project service --user nova admin
openstack user create --domain default --password=neutron neutron
openstack role add --project service --user neutron admin

#创建demo项目(普通用户密码及角色)
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password=demo demo
openstack role create user
openstack role add --project demo --user demo user
#demo环境脚本
echo "
export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=demo
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
">./demo-openstack.sh
#测试脚本是否生效
source ./demo-openstack.sh
openstack token issue

# #------------------#####################
echo 'Glance镜像服务'
# keystone上服务注册 ,创建glance服务实体,API端点（公有、私有、admin）
source ./admin-openstack.sh || { echo "加载前面设置的admin-openstack.sh环境变量脚本";exit; }
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292

cp /etc/glance/glance-api.conf{,.bak}
cp /etc/glance/glance-registry.conf{,.bak}
# images默认/var/lib/glance/images/
#Imgdir=/data/glance
mkdir -p $Imgdir
chown glance:nobody $Imgdir
echo "镜像目录： $Imgdir"
echo "#
[database]
connection = mysql+pymysql://glance:glance@controller/glance
[keystone_authtoken]
auth_uri = http://controller:5000/v3
auth_url = http://controller:35357/v3
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = glance
password = glance
[paste_deploy]
flavor = keystone
[glance_store]
stores = file,http
default_store = file
filesystem_store_datadir = $Imgdir
#">/etc/glance/glance-api.conf
#
echo "#
[database]
connection = mysql+pymysql://glance:glance@controller/glance
[keystone_authtoken]
auth_uri = http://controller:5000/v3
auth_url = http://controller:35357/v3
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = glance
password = glance
[paste_deploy]
flavor = keystone
#">/etc/glance/glance-registry.conf

#同步数据库,检查数据库
su -s /bin/sh -c "glance-manage db_sync" glance
mysql -h controller -u glance -pglance -e "use glance;show tables;"

#启动服务并设置开机自启动
systemctl enable openstack-glance-api openstack-glance-registry
systemctl start openstack-glance-api openstack-glance-registry
netstat -antp|egrep '9292|9191' #检测服务端口

# #------------------#####################
#创建Nova数据库、用户、认证，前面已设置
source ./admin-openstack.sh

# keystone上服务注册 ,创建nova用户、服务、API
# nova用户前面已建
openstack service create --name nova --description "OpenStack Compute" compute
openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1
#创建placement用户、服务、API
openstack user create --domain default --password=placement placement
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region RegionOne placement public http://controller:8778
openstack endpoint create --region RegionOne placement internal http://controller:8778
openstack endpoint create --region RegionOne placement admin http://controller:8778

mkdir -p $VHD
chown -R nova:nova $VHD
echo 'nova配置'
echo '#
[DEFAULT]
instances_path='$VHD'
enabled_apis = osapi_compute,metadata
transport_url = rabbit://openstack:openstack@controller
my_ip = '$MyIP'
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver
osapi_compute_listen_port=8774

[api_database]
connection = mysql+pymysql://nova:nova@controller/nova_api
[database]
connection = mysql+pymysql://nova:nova@controller/nova

[api]
auth_strategy = keystone
[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = nova

[vnc]
enabled = true
vncserver_listen = $my_ip
vncserver_proxyclient_address = $my_ip
novncproxy_base_url = http://'$VncProxy':6080/vnc_auto.html

[glance]
api_servers = http://controller:9292
[oslo_concurrency]
lock_path = /var/lib/nova/tmp

[placement]
os_region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://controller:35357/v3
username = placement
password = placement

[scheduler]
discover_hosts_in_cells_interval = 300

[libvirt]
virt_type = '$Kvm'
#'>/etc/nova/nova.conf

echo "

#Placement API
<Directory /usr/bin>
   <IfVersion >= 2.4>
      Require all granted
   </IfVersion>
   <IfVersion < 2.4>
      Order allow,deny
      Allow from all
   </IfVersion>
</Directory>
">>/etc/httpd/conf.d/00-nova-placement-api.conf
systemctl restart httpd
sleep 5

#同步数据库
su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
su -s /bin/sh -c "nova-manage db sync" nova

#检测数据
nova-manage cell_v2 list_cells
mysql -h controller -u nova -pnova -e "use nova_api;show tables;"
mysql -h controller -u nova -pnova -e "use nova;show tables;" 
mysql -h controller -u nova -pnova -e "use nova_cell0;show tables;"
# #------------------#####################

echo 'Neutron服务'
source ./admin-openstack.sh 
# 创建Neutron服务实体,API端点
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696

#Neutron 备份配置
cp /etc/neutron/neutron.conf{,.bak2}
cp /etc/neutron/plugins/ml2/ml2_conf.ini{,.bak}
ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
cp /etc/neutron/plugins/ml2/linuxbridge_agent.ini{,.bak}
cp /etc/neutron/dhcp_agent.ini{,.bak}
cp /etc/neutron/metadata_agent.ini{,.bak}
cp /etc/neutron/l3_agent.ini{,.bak}

#配置
echo '
#
[neutron]
url = http://controller:9696
auth_url = http://controller:35357
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = neutron
password = neutron
service_metadata_proxy = true
metadata_proxy_shared_secret = metadata
#'>>/etc/nova/nova.conf
#
echo '
[DEFAULT]
nova_metadata_ip = controller
metadata_proxy_shared_secret = metadata
#'>/etc/neutron/metadata_agent.ini
#
echo '#
[ml2]
tenant_network_types = 
type_drivers = vlan,flat
mechanism_drivers = linuxbridge
extension_drivers = port_security
[ml2_type_flat]
flat_networks = provider
[securitygroup]
enable_ipset = True
#'>/etc/neutron/plugins/ml2/ml2_conf.ini
echo '#
[linux_bridge]
physical_interface_mappings = provider:'$Netname'
[vxlan]
enable_vxlan = false

[agent]
prevent_arp_spoofing = True
[securitygroup]
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
enable_security_group = True
#'>/etc/neutron/plugins/ml2/linuxbridge_agent.ini
#
echo '#
[DEFAULT]
interface_driver = linuxbridge
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = true
#'>/etc/neutron/dhcp_agent.ini
#
echo '
[DEFAULT]
core_plugin = ml2
service_plugins = router
allow_overlapping_ips = true
transport_url = rabbit://openstack:openstack@controller
auth_strategy = keystone
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = neutron

[nova]
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
region_name = RegionOne
project_name = service
username = nova
password = nova

[database]
connection = mysql://neutron:neutron@controller:3306/neutron

[oslo_concurrency]
lock_path = /var/lib/neutron/tmp 
#'>/etc/neutron/neutron.conf
#
echo '
[DEFAULT]
interface_driver = linuxbridge
#'>/etc/neutron/l3_agent.ini
#
#同步数据库
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
#检测数据
mysql -h controller -u neutron -pneutron -e "use neutron;show tables;" 

# #------------------#####################
#dashboard

echo '配置openstack Web'
cp /etc/openstack-dashboard/local_settings{,.bak}
Setfiles=/etc/openstack-dashboard/local_settings
sed -i 's#_member_#user#g' $Setfiles
sed -i 's#OPENSTACK_HOST = "127.0.0.1"#OPENSTACK_HOST = "controller"#' $Setfiles
##允许所有主机访问#
sed -i "/ALLOWED_HOSTS/cALLOWED_HOSTS = ['*', ]" $Setfiles
#登录界面域#
sed -i '/MULTIDOMAIN_SUPPORT/cOPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = False' $Setfiles
#去掉memcached注释#
sed -in '153,158s/#//' $Setfiles 
sed -in '160,164s/.*/#&/' $Setfiles
sed -i 's#UTC#Asia/Shanghai#g' $Setfiles
sed -i 's#%s:5000/v2.0#%s:5000/v3#' $Setfiles
sed -i '/ULTIDOMAIN_SUPPORT/cOPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True' $Setfiles
sed -i "s@^#OPENSTACK_KEYSTONE_DEFAULT@OPENSTACK_KEYSTONE_DEFAULT@" $Setfiles
echo '
#set
OPENSTACK_API_VERSIONS = {
    "identity": 3,
    "image": 2,
    "volume": 2,
}
#'>>$Setfiles
systemctl restart httpd
sleep 5

##########################################

echo '启动服务'
#Apache 
systemctl enable httpd.service
#systemctl restart httpd haproxy
#netstat -antp|egrep 'httpd'

#glance服务
systemctl enable openstack-glance-api openstack-glance-registry
systemctl restart openstack-glance-api openstack-glance-registry

#nova服务
 systemctl enable openstack-nova-api.service \
  openstack-nova-consoleauth.service openstack-nova-scheduler.service \
  openstack-nova-conductor.service openstack-nova-novncproxy.service \
  libvirtd.service openstack-nova-compute.service
#启动
systemctl start libvirtd.service
systemctl start openstack-nova-api.service \
  openstack-nova-consoleauth.service openstack-nova-scheduler.service \
  openstack-nova-conductor.service openstack-nova-novncproxy.service \
  openstack-nova-compute.service

#neutron服务
systemctl enable neutron-server.service \
  neutron-linuxbridge-agent.service neutron-dhcp-agent.service \
  neutron-metadata-agent.service neutron-l3-agent.service
systemctl start neutron-server.service \
  neutron-linuxbridge-agent.service neutron-dhcp-agent.service \
  neutron-metadata-agent.service neutron-l3-agent.service

##########################################
#cheack
#登录界面域#
sed -i '/MULTIDOMAIN_SUPPORT/cOPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = False' $Setfiles

echo "查看节点"
source ./admin-openstack.sh 
openstack compute service list
#openstack network agent list

##########################################
##########################################
#可选,创建虚机#

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

##########################################
##########################################
#end

echo '
安装完毕！
数据库root密码 '$DBPass'
shell加载admin权限 source '$(pwd)'/admin-openstack.sh

登录Web管理 http://'$MyIP'/dashboard
用户 admin
密码 admin
推荐 火狐浏览器
'
#域   default
##########################################
# #使用
# curl http://elven.vip/ks/openstack/pike.install.sh>pike.install.sh && sh pike.install.sh
# yum install -y wget && wget -O pike.install.sh http://elven.vip/ks/openstack/pike.install.sh && sh pike.install.sh

