---
title: Openstack和Kubernetes融合部署（1） - 使用minikube快速部署单机版Kubernetes
date: 2022-04-14 10:02:53
categories: 云原生
tags:
- minikube
- Kubernetes
---
```bash
(kolla_env) [root@localhost kolla]# tox -egenconfig
genconfig create: /root/kolla/.tox/genconfig
genconfig installdeps: -chttps://releases.openstack.org/constraints/upper/yoga, -r/root/kolla/requirements.txt, -r/root/kolla/test-requirements.txt

genconfig develop-inst: /root/kolla
genconfig installed: attrs==21.4.0,autopage==0.5.0,bandit==1.7.1,bashate==2.1.0,certifi==2021.10.8,charset-normalizer==2.0.12,cliff==3.10.1,cmd2==2.4.0,coverage==6.2,ddt==1.4.4,debtcollector==2.5.0,docker==5.0.3,entrypoints==0.3,extras==1.0.0,fixtures==3.0.0,flake8==3.7.9,future==0.18.2,gitdb==4.0.9,GitPython==3.1.18,hacking==3.0.1,idna==3.3,importlib-metadata==4.8.3,importlib-resources==5.4.0,Jinja2==3.0.3,-e git+https://github.com/openstack/kolla@65a706ff84c18a20d8d8c5147e66e4276382c132#egg=kolla,MarkupSafe==2.0.1,mccabe==0.6.1,netaddr==0.8.0,oslo.config==8.8.0,oslo.i18n==5.1.0,oslotest==4.5.0,pbr==5.8.1,prettytable==2.5.0,pycodestyle==2.5.0,pyflakes==2.1.1,pyparsing==3.0.7,pyperclip==1.8.2,python-subunit==1.4.0,PyYAML==6.0,requests==2.27.1,rfc3986==1.5.0,six==1.16.0,smmap==5.0.0,stestr==3.2.1,stevedore==3.5.0,testtools==2.5.0,typing_extensions==4.1.1,urllib3==1.26.8,voluptuous==0.12.2,wcwidth==0.2.5,websocket-client==1.2.3,wrapt==1.13.3,zipp==3.6.0
genconfig run-test-pre: PYTHONHASHSEED='3372895096'
genconfig run-test: commands[0] | oslo-config-generator --config-file etc/oslo-config-generator/kolla-build.conf
/root/kolla/.tox/genconfig/lib/python3.6/site-packages/oslo_config/types.py:57: UserWarning: converting '[]' to a string
warnings.warn('converting \'%s\' to a string' % str_val)
_________________________________________________________________________ summary __________________________________________________________________________
genconfig: commands succeeded
congratulations :)
(kolla_env) [root@localhost kolla]#
(kolla_env) [root@localhost kolla]# mkdir /etc/kolla/
(kolla_env) [root@localhost kolla]# cp etc/kolla/kolla-build.conf /etc/kolla/
(kolla_env) [root@localhost kolla]# vim /etc/kolla/kolla-build.conf
```
```bash
vim /etc/kolla/kolla-build.conf

[DEFAULT]
base = centos
install_type = source
namespace = kolla
push = false
# The Docker Images tag (string value)
tag = 14.0.0
```

* base：使用 CentOS 做为 Base 镜像
* install_type：使用源码方式部署
* tag：指定构建镜像的 Tag 为 14.0.0（Kolla Yoga 的版本号）

[root@localhost network-scripts]# docker images
REPOSITORY                                          TAG       IMAGE ID       CREATED          SIZE
kolla/centos-source-nova-compute                    14.0.0    b2b76357d6b6   2 minutes ago    2.52GB
kolla/centos-source-nova-novncproxy                 14.0.0    a03deaaa8d6a   4 minutes ago    1.9GB
kolla/centos-source-nova-compute-ironic             14.0.0    f4c334a45051   4 minutes ago    1.85GB
kolla/centos-source-nova-ssh                        14.0.0    a0f8d91f0826   4 minutes ago    1.85GB
kolla/centos-source-neutron-mlnx-agent              14.0.0    85b80afc1dc3   5 minutes ago    1.85GB
kolla/centos-source-neutron-linuxbridge-agent       14.0.0    fbe2f1428df0   6 minutes ago    1.8GB
kolla/centos-source-neutron-l3-agent                14.0.0    ff7d7e202c8a   6 minutes ago    1.82GB
kolla/centos-source-neutron-infoblox-ipam-agent     14.0.0    cf84a2272161   7 minutes ago    1.77GB
kolla/centos-source-neutron-server                  14.0.0    c527c00541f6   7 minutes ago    1.77GB
kolla/centos-source-keystone-fernet                 14.0.0    84ba9be60e0a   7 minutes ago    1.7GB
kolla/centos-source-nova-serialproxy                14.0.0    06a803d23db3   7 minutes ago    1.81GB
kolla/centos-source-nova-scheduler                  14.0.0    f16428738835   7 minutes ago    1.81GB
kolla/centos-source-nova-conductor                  14.0.0    dfe81464d758   7 minutes ago    1.81GB
kolla/centos-source-glance-api                      14.0.0    d5645973f0d1   7 minutes ago    1.67GB
kolla/centos-source-keystone                        14.0.0    eca59a5df383   7 minutes ago    1.7GB
kolla/centos-source-nova-api                        14.0.0    a46870cdfcac   7 minutes ago    1.81GB
kolla/centos-source-keystone-ssh                    14.0.0    fa81dc289599   7 minutes ago    1.7GB
kolla/centos-source-neutron-sriov-agent             14.0.0    1a3988cc8957   7 minutes ago    1.76GB
kolla/centos-source-horizon                         14.0.0    fd43c318a46b   7 minutes ago    1.72GB
kolla/centos-source-neutron-openvswitch-agent       14.0.0    2f2b2371a429   7 minutes ago    1.76GB
kolla/centos-source-neutron-metadata-agent          14.0.0    4cd2cbe2f22e   8 minutes ago    1.76GB
kolla/centos-source-neutron-metering-agent          14.0.0    609679cd8056   8 minutes ago    1.76GB
kolla/centos-source-proxysql                        14.0.0    aa14e2cd8d14   8 minutes ago    1.05GB
kolla/centos-source-nova-base                       14.0.0    4871d6ff0381   8 minutes ago    1.81GB
kolla/centos-source-neutron-bgp-dragent             14.0.0    48865abced08   9 minutes ago    1.76GB
kolla/centos-source-neutron-dhcp-agent              14.0.0    92fea3ed0107   9 minutes ago    1.76GB
kolla/centos-source-ironic-neutron-agent            14.0.0    0b41094ea817   9 minutes ago    1.76GB
kolla/centos-source-neutron-base                    14.0.0    4d4df4c9b461   9 minutes ago    1.76GB
kolla/centos-source-keystone-base                   14.0.0    5931873069d3   11 minutes ago   1.66GB
kolla/centos-source-glance-base                     14.0.0    121441e81aeb   11 minutes ago   1.63GB
kolla/centos-source-barbican-keystone-listener      14.0.0    b71e340db42f   11 minutes ago   1.52GB
kolla/centos-source-barbican-base                   14.0.0    d7caa7968fdb   11 minutes ago   1.52GB
kolla/centos-source-heat-api                        14.0.0    17b001c68756   13 minutes ago   1.54GB
kolla/centos-source-placement-api                   14.0.0    e809b2a5e192   13 minutes ago   1.47GB
kolla/centos-source-heat-engine                     14.0.0    ca652a9c2858   13 minutes ago   1.54GB
kolla/centos-source-heat-api-cfn                    14.0.0    1327338fb4ad   13 minutes ago   1.54GB
kolla/centos-source-placement-base                  14.0.0    9e697ad9afd5   13 minutes ago   1.47GB
kolla/centos-source-heat-base                       14.0.0    8a9286113d25   14 minutes ago   1.54GB
kolla/centos-source-openstack-base                  14.0.0    f78817dd1b5d   14 minutes ago   1.46GB
kolla/centos-source-kolla-toolbox                   14.0.0    808ad82b7e1a   16 minutes ago   1.45GB
kolla/centos-source-mariadb-server                  14.0.0    e635bc60f9ac   16 minutes ago   1.41GB
kolla/centos-source-openvswitch-netcontrold         14.0.0    fba8e761ac04   16 minutes ago   1.07GB
kolla/centos-source-prometheus-memcached-exporter   14.0.0    e7aed56c61df   16 minutes ago   912MB
kolla/centos-source-nova-libvirt                    14.0.0    58e2a8ad3a7e   17 minutes ago   2.32GB
kolla/centos-source-openvswitch-vswitchd            14.0.0    9a198059fab5   17 minutes ago   1.05GB
kolla/centos-source-openvswitch-db-server           14.0.0    11dc66c05f40   17 minutes ago   1.05GB
kolla/centos-source-openvswitch-base                14.0.0    deea32ef2542   17 minutes ago   1.05GB
kolla/centos-source-rabbitmq                        14.0.0    3d6540d9b584   17 minutes ago   984MB
kolla/centos-source-prometheus-haproxy-exporter     14.0.0    f4997b5f47cf   17 minutes ago   911MB
kolla/centos-source-mariadb-clustercheck            14.0.0    668db62d75bc   17 minutes ago   1.07GB
kolla/centos-source-fluentd                         14.0.0    efa58dff6985   19 minutes ago   1.18GB
kolla/centos-source-haproxy                         14.0.0    9b1292170c70   20 minutes ago   956MB
kolla/centos-source-memcached                       14.0.0    edbd24451824   20 minutes ago   960MB
kolla/centos-source-prometheus-base                 14.0.0    615824fe59c0   20 minutes ago   898MB
kolla/centos-source-keepalived                      14.0.0    94a077283061   20 minutes ago   965MB
kolla/centos-source-mariadb-base                    14.0.0    5e55a2b18772   20 minutes ago   1.04GB
kolla/centos-source-cron                            14.0.0    47dccd04efa9   21 minutes ago   925MB
kolla/centos-source-base                            14.0.0    9c7a52e8bba3   23 minutes ago   898MB
quay.io/centos/centos                               stream8   c5c90f59f34b   4 weeks ago      380MB
[root@localhost network-scripts]# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
[root@localhost network-scripts]#