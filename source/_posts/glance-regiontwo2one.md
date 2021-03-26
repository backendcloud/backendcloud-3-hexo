title: openstack两个region分别用各自glance服务->共用glance服务
date: 2017-02-08 16:51:34
categories: Openstack_op
tags:
- Region
----
# 删除原RegionTwo的glance的endpoint，新增RegionOne的glance的endpoint到RegionTwo
```
[root@stone-controller-1 ~]# keystone endpoint-list|grep 9292
/usr/lib/python2.7/site-packages/keystoneclient/shell.py:65: DeprecationWarning: The keystone CLI is deprecated in favor of python-openstackclient. For a Python library, continue using python-keystoneclient.
  'python-keystoneclient.', DeprecationWarning)
| a7bde0b6d0124002acde9a1a7a6f5d8e | RegionIronic |          http://10.254.3.245:9292          |          http://10.254.3.245:9292          |          http://10.254.3.245:9292          | dc9c789e03a348949980402f85e93a80 |
| d6b013981fdb48cf8f1e2108ebd12977 |  RegionOne   |         http://10.254.10.249:9292          |         http://10.254.10.249:9292          |         http://10.254.10.249:9292          | dc9c789e03a348949980402f85e93a80 |
| ebfe433d5eb741be9b63e33a25530aa0 |  RegionTwo   |          http://10.254.9.14:9292           |          http://10.254.9.14:9292           |          http://10.254.9.14:9292           | dc9c789e03a348949980402f85e93a80 |
[root@stone-controller-1 ~]# keystone endpoint-create --region RegionTwo --service glance --publicurl 'http://10.254.10.249:9292' --internalurl 'http://10.254.10.249:9292' --adminurl 'http://10.254.10.249:9292'
/usr/lib/python2.7/site-packages/keystoneclient/shell.py:65: DeprecationWarning: The keystone CLI is deprecated in favor of python-openstackclient. For a Python library, continue using python-keystoneclient.
  'python-keystoneclient.', DeprecationWarning)
+-------------+----------------------------------+
|   Property  |              Value               |
+-------------+----------------------------------+
|   adminurl  |    http://10.254.10.249:9292     |
|      id     | 3da0dfbdee5d4f9d95025cb3a5d7acee |
| internalurl |    http://10.254.10.249:9292     |
|  publicurl  |    http://10.254.10.249:9292     |
|    region   |            RegionTwo             |
|  service_id | dc9c789e03a348949980402f85e93a80 |
+-------------+----------------------------------+
[root@stone-controller-1 ~]# keystone endpoint-delete ebfe433d5eb741be9b63e33a25530aa0
/usr/lib/python2.7/site-packages/keystoneclient/shell.py:65: DeprecationWarning: The keystone CLI is deprecated in favor of python-openstackclient. For a Python library, continue using python-keystoneclient.
  'python-keystoneclient.', DeprecationWarning)
Endpoint has been deleted.
[root@stone-controller-1 ~]# keystone endpoint-list|grep 9292
/usr/lib/python2.7/site-packages/keystoneclient/shell.py:65: DeprecationWarning: The keystone CLI is deprecated in favor of python-openstackclient. For a Python library, continue using python-keystoneclient.
  'python-keystoneclient.', DeprecationWarning)
| 3da0dfbdee5d4f9d95025cb3a5d7acee |  RegionTwo   |         http://10.254.10.249:9292          |         http://10.254.10.249:9292          |         http://10.254.10.249:9292          | dc9c789e03a348949980402f85e93a80 |
| a7bde0b6d0124002acde9a1a7a6f5d8e | RegionIronic |          http://10.254.3.245:9292          |          http://10.254.3.245:9292          |          http://10.254.3.245:9292          | dc9c789e03a348949980402f85e93a80 |
| d6b013981fdb48cf8f1e2108ebd12977 |  RegionOne   |         http://10.254.10.249:9292          |         http://10.254.10.249:9292          |         http://10.254.10.249:9292          | dc9c789e03a348949980402f85e93a80 |
```


# 修改调用原RegionTwo的glance的配置

    [root@controller1_region2 ~]# vim /etc/nova/nova.conf 
    将api_servers=10.254.9.14:9292改成api_servers=10.254.10.249:9292



# 关停原RegionTwo的glance服务

```
[root@controller1_region2 ~]# systemctl status openstack-glance-api.service  openstack-glance-registry.service
  openstack-glance-api.service - OpenStack Image Service (code-named Glance) API server
   Loaded: loaded (/usr/lib/systemd/system/openstack-glance-api.service; enabled; vendor preset: disabled)
   Active: active (running) since Tue 2016-11-01 19:23:23 CST; 1 months 4 days ago
 Main PID: 9992 (glance-api)
   CGroup: /system.slice/openstack-glance-api.service
           |- 9992 /usr/bin/python2 /usr/bin/glance-api
           |- 9999 /usr/bin/python2 /usr/bin/glance-api
           |-10000 /usr/bin/python2 /usr/bin/glance-api
           |-10001 /usr/bin/python2 /usr/bin/glance-api
           |-10002 /usr/bin/python2 /usr/bin/glance-api
           |-10003 /usr/bin/python2 /usr/bin/glance-api
           |-10004 /usr/bin/python2 /usr/bin/glance-api
           |-10005 /usr/bin/python2 /usr/bin/glance-api
           |-10006 /usr/bin/python2 /usr/bin/glance-api
           |-10007 /usr/bin/python2 /usr/bin/glance-api
           |-10008 /usr/bin/python2 /usr/bin/glance-api
           |-10009 /usr/bin/python2 /usr/bin/glance-api
           |-10010 /usr/bin/python2 /usr/bin/glance-api
           |-10011 /usr/bin/python2 /usr/bin/glance-api
           |-10012 /usr/bin/python2 /usr/bin/glance-api
           |-10013 /usr/bin/python2 /usr/bin/glance-api
           |-10014 /usr/bin/python2 /usr/bin/glance-api
           |-10015 /usr/bin/python2 /usr/bin/glance-api
           |-10016 /usr/bin/python2 /usr/bin/glance-api
           |-10017 /usr/bin/python2 /usr/bin/glance-api
           |-10018 /usr/bin/python2 /usr/bin/glance-api
           |-10019 /usr/bin/python2 /usr/bin/glance-api
           |-10020 /usr/bin/python2 /usr/bin/glance-api
           |-10021 /usr/bin/python2 /usr/bin/glance-api
           |-10022 /usr/bin/python2 /usr/bin/glance-api
           |-10023 /usr/bin/python2 /usr/bin/glance-api
           |-10024 /usr/bin/python2 /usr/bin/glance-api
           |-10025 /usr/bin/python2 /usr/bin/glance-api
           |-10026 /usr/bin/python2 /usr/bin/glance-api
           |-10027 /usr/bin/python2 /usr/bin/glance-api
           |-10028 /usr/bin/python2 /usr/bin/glance-api
           |-10029 /usr/bin/python2 /usr/bin/glance-api
           `-10030 /usr/bin/python2 /usr/bin/glance-api

Nov 01 19:23:22 controller1_region2 systemd[1]: Starting OpenStack Image Service (code-named Glance) API server...
Nov 01 19:23:23 controller1_region2 systemd[1]: Started OpenStack Image Service (code-named Glance) API server.

  openstack-glance-registry.service - OpenStack Image Service (code-named Glance) Registry server
   Loaded: loaded (/usr/lib/systemd/system/openstack-glance-registry.service; enabled; vendor preset: disabled)
   Active: active (running) since Tue 2016-11-01 19:23:29 CST; 1 months 4 days ago
 Main PID: 10053 (glance-registry)
   CGroup: /system.slice/openstack-glance-registry.service
           |-10053 /usr/bin/python2 /usr/bin/glance-registry
           |-10061 /usr/bin/python2 /usr/bin/glance-registry
           |-10062 /usr/bin/python2 /usr/bin/glance-registry
           |-10063 /usr/bin/python2 /usr/bin/glance-registry
           |-10064 /usr/bin/python2 /usr/bin/glance-registry
           |-10065 /usr/bin/python2 /usr/bin/glance-registry
           |-10066 /usr/bin/python2 /usr/bin/glance-registry
           |-10067 /usr/bin/python2 /usr/bin/glance-registry
           |-10068 /usr/bin/python2 /usr/bin/glance-registry
           |-10069 /usr/bin/python2 /usr/bin/glance-registry
           |-10070 /usr/bin/python2 /usr/bin/glance-registry
           |-10071 /usr/bin/python2 /usr/bin/glance-registry
           |-10072 /usr/bin/python2 /usr/bin/glance-registry
           |-10073 /usr/bin/python2 /usr/bin/glance-registry
           |-10074 /usr/bin/python2 /usr/bin/glance-registry
           |-10075 /usr/bin/python2 /usr/bin/glance-registry
           |-10076 /usr/bin/python2 /usr/bin/glance-registry
           |-10077 /usr/bin/python2 /usr/bin/glance-registry
           |-10078 /usr/bin/python2 /usr/bin/glance-registry
           |-10079 /usr/bin/python2 /usr/bin/glance-registry
           |-10080 /usr/bin/python2 /usr/bin/glance-registry
           |-10081 /usr/bin/python2 /usr/bin/glance-registry
           |-10082 /usr/bin/python2 /usr/bin/glance-registry
           |-10083 /usr/bin/python2 /usr/bin/glance-registry
           |-10084 /usr/bin/python2 /usr/bin/glance-registry
           |-10085 /usr/bin/python2 /usr/bin/glance-registry
           |-10086 /usr/bin/python2 /usr/bin/glance-registry
           |-10087 /usr/bin/python2 /usr/bin/glance-registry
           |-10088 /usr/bin/python2 /usr/bin/glance-registry
           |-10089 /usr/bin/python2 /usr/bin/glance-registry
           |-10090 /usr/bin/python2 /usr/bin/glance-registry
           |-10091 /usr/bin/python2 /usr/bin/glance-registry
           `-10092 /usr/bin/python2 /usr/bin/glance-registry

Nov 01 19:23:29 controller1_region2 systemd[1]: Starting OpenStack Image Service (code-named Glance) Registry server...
Nov 01 19:23:29 controller1_region2 systemd[1]: Started OpenStack Image Service (code-named Glance) Registry server.
Nov 01 19:26:27 controller1_region2 glance-registry[10053]: /usr/lib64/python2.7/site-packages/sqlalchemy/sql/default_comparator.py:35: SAWarning: The IN-predicate on "image_locations.id" ...
Nov 01 19:26:27 controller1_region2 glance-registry[10053]: return o[0](self, self.expr, op, *(other + o[1:]), **kwargs)
Nov 02 09:17:50 controller1_region2 glance-registry[10053]: /usr/lib64/python2.7/site-packages/sqlalchemy/sql/default_comparator.py:35: SAWarning: The IN-predicate on "image_locations.id" ...
Nov 02 09:17:50 controller1_region2 glance-registry[10053]: return o[0](self, self.expr, op, *(other + o[1:]), **kwargs)
Hint: Some lines were ellipsized, use -l to show in full.
```

```
[root@controller1_region2 ~]# systemctl disable openstack-glance-api.service openstack-glance-registry.service
Removed symlink /etc/systemd/system/multi-user.target.wants/openstack-glance-registry.service.
Removed symlink /etc/systemd/system/multi-user.target.wants/openstack-glance-api.service.
[root@controller1_region2 ~]# systemctl stop openstack-glance-api.service openstack-glance-registry.service
[root@controller1_region2 ~]# systemctl status openstack-glance-api.service  openstack-glance-registry.service
  openstack-glance-api.service - OpenStack Image Service (code-named Glance) API server
   Loaded: loaded (/usr/lib/systemd/system/openstack-glance-api.service; disabled; vendor preset: disabled)
   Active: inactive (dead) since Wed 2016-12-07 02:11:55 CST; 5s ago
 Main PID: 9992 (code=exited, status=0/SUCCESS)

Nov 01 19:23:22 controller1_region2 systemd[1]: Starting OpenStack Image Service (code-named Glance) API server...
Nov 01 19:23:23 controller1_region2 systemd[1]: Started OpenStack Image Service (code-named Glance) API server.
Dec 07 02:11:55 controller1_region2 systemd[1]: Stopping OpenStack Image Service (code-named Glance) API server...
Dec 07 02:11:55 controller1_region2 systemd[1]: Stopped OpenStack Image Service (code-named Glance) API server.

  openstack-glance-registry.service - OpenStack Image Service (code-named Glance) Registry server
   Loaded: loaded (/usr/lib/systemd/system/openstack-glance-registry.service; disabled; vendor preset: disabled)
   Active: inactive (dead) since Wed 2016-12-07 02:11:55 CST; 5s ago
 Main PID: 10053 (code=exited, status=0/SUCCESS)

Nov 01 19:23:29 controller1_region2 systemd[1]: Starting OpenStack Image Service (code-named Glance) Registry server...
Nov 01 19:23:29 controller1_region2 systemd[1]: Started OpenStack Image Service (code-named Glance) Registry server.
Nov 01 19:26:27 controller1_region2 glance-registry[10053]: /usr/lib64/python2.7/site-packages/sqlalchemy/sql/default_comparator.py:35: SAWarning: The IN-predicate on "image_locations.id" ...
Nov 01 19:26:27 controller1_region2 glance-registry[10053]: return o[0](self, self.expr, op, *(other + o[1:]), **kwargs)
Nov 02 09:17:50 controller1_region2 glance-registry[10053]: /usr/lib64/python2.7/site-packages/sqlalchemy/sql/default_comparator.py:35: SAWarning: The IN-predicate on "image_locations.id" ...
Nov 02 09:17:50 controller1_region2 glance-registry[10053]: return o[0](self, self.expr, op, *(other + o[1:]), **kwargs)
Dec 07 02:11:55 controller1_region2 systemd[1]: Stopping OpenStack Image Service (code-named Glance) Registry server...
Dec 07 02:11:55 controller1_region2 systemd[1]: Stopped OpenStack Image Service (code-named Glance) Registry server.
Hint: Some lines were ellipsized, use -l to show in full.
```



# 重启openstack服务

    # openstack-service restart



# 验证

登陆dashboard，切换RegionOne和RegionTwo的镜像一览，由原来各自的镜像列表变成了一样的镜像列表

