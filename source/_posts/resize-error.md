title: resize失败原因调查
date: 2017-07-04 10:20:06
categories: Openstack_op
tags:
- Nova
---

# 对云主机进行resize操作没有成功

对一个vm做resize，即从一个小的flavor换一个大的flavor，没有成功

# 检查云主机所在节点的nova-compute.log

    2017-07-03 17:50:08.573 24296 TRACE oslo_messaging.rpc.dispatcher   File "/usr/lib/python2.7/site-packages/nova/compute/manager.py", line 6959, in _error_out_instance_on_exception
    2017-07-03 17:50:08.573 24296 TRACE oslo_messaging.rpc.dispatcher     raise error.inner_exception
    2017-07-03 17:50:08.573 24296 TRACE oslo_messaging.rpc.dispatcher ResizeError: Resize error: not able to execute ssh command: Unexpected error while running command.
    2017-07-03 17:50:08.573 24296 TRACE oslo_messaging.rpc.dispatcher Command: ssh 172.16.231.26 -p 22 mkdir -p /var/lib/nova/instances/54091e90-55f5-4f4d-8f66-31fbc787584f
    2017-07-03 17:50:08.573 24296 TRACE oslo_messaging.rpc.dispatcher Exit code: 255
    2017-07-03 17:50:08.573 24296 TRACE oslo_messaging.rpc.dispatcher Stdout: u''
    2017-07-03 17:50:08.573 24296 TRACE oslo_messaging.rpc.dispatcher Stderr: u'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\r\n@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @\r\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\r\nIT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!\r\nSomeone could be eavesdropping on you right now (man-in-the-middle attack)!\r\nIt is also possible that a host key has just been changed.\r\nThe fingerprint for the ECDSA key sent by the remote host is\nc8:0b:98:9d:8d:d8:14:89:e6:fe:97:66:22:4e:57:13.\r\nPlease contact your system administrator.\r\nAdd correct host key in /var/lib/nova/.ssh/known_hosts to get rid of this message.\r\nOffending ECDSA key in /var/lib/nova/.ssh/known_hosts:34\r\nPassword authentication is disabled to avoid man-in-the-middle attacks.\r\nKeyboard-interactive authentication is disabled to avoid man-in-the-middle attacks.\r\nPermission denied (publickey,gssapi-keyex,gssapi-with-mic,password).\r\n'



# 分析原因

可能是计算节点的nova用户的host key改变了

# 对策

对所有计算节点 删除/var/lib/nova/.ssh/known_hosts 有关计算节点的行，重新用nova用户ssh互相登陆，新增host key并确保nova用户计算节点之间ssh都是互信的

# 测试ok

    [root@NFJD-TESTVM-CORE-API-1 ~]# nova show e1b51267-2fad-48da-a749-bb36b729bf0c
    +--------------------------------------+-------------------------------------------------------------------+
    | Property                             | Value                                                             |
    +--------------------------------------+-------------------------------------------------------------------+
    | OS-DCF:diskConfig                    | MANUAL                                                            |
    | OS-EXT-AZ:availability_zone          | nova                                                              |
    | OS-EXT-SRV-ATTR:host                 | NFJD-TESTN-COMPUTE-2                                              |
    | OS-EXT-SRV-ATTR:hypervisor_hostname  | NFJD-TESTN-COMPUTE-2                                              |
    | OS-EXT-SRV-ATTR:instance_name        | instance-0000685c                                                 |
    | OS-EXT-STS:power_state               | 1                                                                 |
    | OS-EXT-STS:task_state                | -                                                                 |
    | OS-EXT-STS:vm_state                  | active                                                            |
    | OS-SRV-USG:launched_at               | 2017-07-04T01:13:23.000000                                        |
    | OS-SRV-USG:terminated_at             | -                                                                 |
    | accessIPv4                           |                                                                   |
    | accessIPv6                           |                                                                   |
    | config_drive                         | True                                                              |
    | created                              | 2017-07-04T01:12:23Z                                              |
    | flavor                               | m1.medium (3)                                                     |
    | hostId                               | d4b42eac18963a6b9c295b06afa49642ce9e51d12d9aef2d1a16e930          |
    | id                                   | e1b51267-2fad-48da-a749-bb36b729bf0c                              |
    | image                                | CentOS-7.1-x86_64-20161018 (8aaf1759-9fb4-4ba9-8cff-1743eb824c5f) |
    | key_name                             | -                                                                 |
    | metadata                             | {}                                                                |
    | name                                 | test                                                              |
    | net001 network                       | 192.168.2.127                                                     |
    | os-extended-volumes:volumes_attached | []                                                                |
    | progress                             | 0                                                                 |
    | security_groups                      | default                                                           |
    | status                               | ACTIVE                                                            |
    | tenant_id                            | 6c149dcd3cf64171b8dd972dd03bbac0                                  |
    | updated                              | 2017-07-04T01:12:19Z                                              |
    | user_id                              | 62f52135115f4898bd0d82c1f0cd632b                                  |
    +--------------------------------------+-------------------------------------------------------------------+
    [root@NFJD-TESTVM-CORE-API-1 ~]# nova resize e1b51267-2fad-48da-a749-bb36b729bf0c 4
    [root@NFJD-TESTVM-CORE-API-1 ~]# nova show e1b51267-2fad-48da-a749-bb36b729bf0c
    +--------------------------------------+-------------------------------------------------------------------+
    | Property                             | Value                                                             |
    +--------------------------------------+-------------------------------------------------------------------+
    | OS-DCF:diskConfig                    | MANUAL                                                            |
    | OS-EXT-AZ:availability_zone          | nova                                                              |
    | OS-EXT-SRV-ATTR:host                 | NFJD-TESTN-COMPUTE-2                                              |
    | OS-EXT-SRV-ATTR:hypervisor_hostname  | NFJD-TESTN-COMPUTE-2                                              |
    | OS-EXT-SRV-ATTR:instance_name        | instance-0000685c                                                 |
    | OS-EXT-STS:power_state               | 1                                                                 |
    | OS-EXT-STS:task_state                | -                                                                 |
    | OS-EXT-STS:vm_state                  | active                                                            |
    | OS-SRV-USG:launched_at               | 2017-07-04T02:35:50.000000                                        |
    | OS-SRV-USG:terminated_at             | -                                                                 |
    | accessIPv4                           |                                                                   |
    | accessIPv6                           |                                                                   |
    | config_drive                         | True                                                              |
    | created                              | 2017-07-04T02:34:42Z                                              |
    | flavor                               | m1.large (4)                                                     |
    | hostId                               | d4b42eac18963a6b9c295b06afa49642ce9e51d12d9aef2d1a16e930          |
    | id                                   | e1b51267-2fad-48da-a749-bb36b729bf0c                              |
    | image                                | CentOS-7.1-x86_64-20161018 (8aaf1759-9fb4-4ba9-8cff-1743eb824c5f) |
    | key_name                             | -                                                                 |
    | metadata                             | {}                                                                |
    | name                                 | test                                                              |
    | net001 network                       | 192.168.2.127                                                     |
    | os-extended-volumes:volumes_attached | []                                                                |
    | progress                             | 0                                                                 |
    | security_groups                      | default                                                           |
    | status                               | ACTIVE                                                            |
    | tenant_id                            | 6c149dcd3cf64171b8dd972dd03bbac0                                  |
    | updated                              | 2017-07-04T02:34:19Z                                              |
    | user_id                              | 62f52135115f4898bd0d82c1f0cd632b                                  |
    +--------------------------------------+-------------------------------------------------------------------+


可以看到flavor从 m1.medium -> m1.large



# 通过日志对resize的流程进行分析

## 源节点

    2017-07-04 10:35:40.999 9791 DEBUG oslo_concurrency.processutils [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Running cmd (subprocess): env LC_ALL=C LANG=C qemu-img info /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/disk execute /usr/lib/python2.7/site-packages/oslo_concurrency/processutils.py:223

读取云主机disk信息
    
    2017-07-04 10:35:41.430 9791 DEBUG oslo_concurrency.processutils [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Running cmd (subprocess): ssh 172.16.231.26 -p 22 mkdir -p /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca execute /usr/lib/python2.7/site-packages/oslo_concurrency/processutils.py:223

从源节点ssh到目标节点创建实例id的文件夹
    
    2017-07-04 10:35:41.524 9791 DEBUG nova.virt.libvirt.driver [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Shutting down instance from state 1 _clean_shutdown /usr/lib/python2.7/site-packages/nova/virt/libvirt/driver.py:2517
    2017-07-04 10:35:43.572 9791 INFO nova.virt.libvirt.driver [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Instance shutdown successfully after 2 seconds.
    2017-07-04 10:35:43.578 9791 INFO nova.virt.libvirt.driver [-] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Instance destroyed successfully.

关闭vm

    2017-07-04 10:35:43.578 9791 DEBUG oslo_concurrency.processutils [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Running cmd (subprocess): mv /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca_resize execute /usr/lib/python2.7/site-packages/oslo_concurrency/processutils.py:223

vm的disk文件夹从d63958dc-3510-4291-b219-93183c49d2ca移动到d63958dc-3510-4291-b219-93183c49d2ca_resize

    2017-07-04 10:35:49.547 9791 DEBUG oslo_concurrency.processutils [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] CMD "qemu-img convert -f qcow2 -O qcow2 /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca_resize/disk /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca_resize/disk_rbase" returned: 0 in 5.957s execute /usr/lib/python2.7/site-packages/oslo_concurrency/processutils.py:254

将disk文件生成qcow2格式的新文件disk_rbase
    
    2017-07-04 10:35:49.682 9791 DEBUG oslo_concurrency.processutils [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] CMD "rsync --sparse --compress --dry-run /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca_resize/disk_rbase 172.16.231.26:/var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/disk" returned: 0 in 0.133s execute /usr/lib/python2.7/site-packages/oslo_concurrency/processutils.py:254

将disk文件通过rsync拷贝到新节点

    2017-07-04 10:35:58.295 9791 DEBUG nova.virt.driver [-] Emitting event <LifecycleEvent: 1499135743.29, d63958dc-3510-4291-b219-93183c49d2ca => Stopped> emit_event /usr/lib/python2.7/site-packages/nova/virt/driver.py:1309
    2017-07-04 10:35:58.297 9791 INFO nova.compute.manager [-] [instance: d63958dc-3510-4291-b219-93183c49d2ca] VM Stopped (Lifecycle Event)
    2017-07-04 10:35:58.367 9791 DEBUG nova.compute.manager [req-bb3cd615-5752-4574-86a5-efea318d4cd3 - - - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Synchronizing instance power state after lifecycle event "Stopped"; current vm_state: active, current task_state: resize_migrating, current DB power_state: 1, VM power_state: 4 handle_lifecycle_event /usr/lib/python2.7/site-packages/nova/compute/manager.py:1274

vm的生命周期更新为STOP关机

    2017-07-04 10:38:27.357 9791 DEBUG oslo_concurrency.processutils [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] CMD "rsync --sparse --compress /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca_resize/disk_rbase 172.16.231.26:/var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/disk" returned: 0 in 157.673s execute /usr/lib/python2.7/site-packages/oslo_concurrency/processutils.py:254

之前的“将disk文件通过rsync拷贝到新节点”命令结束，命令返回状态码正常，返回0。可以看出这个拷贝非常耗时间，从命令发出到结束，耗时近三分钟

    2017-07-04 10:38:27.360 9791 DEBUG oslo_concurrency.processutils [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Running cmd (subprocess): rm -f /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca_resize/disk_rbase execute /usr/lib/python2.7/site-packages/oslo_concurrency/processutils.py:223

删除disk_rbase文件

    2017-07-04 10:38:27.887 9791 DEBUG oslo_concurrency.processutils [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Running cmd (subprocess): rsync --sparse --compress --dry-run /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca_resize/disk.config 172.16.231.26:/var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/disk.config execute /usr/lib/python2.7/site-packages/oslo_concurrency/processutils.py:223

将disk.conf文件通过rsync拷贝到新节点  

## 新的节点
    
    2017-07-04 10:36:41.924 7940 DEBUG nova.compute.manager [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Stashing vm_state: active _prep_resize /usr/lib/python2.7/site-packages/nova/compute/manager.py:4197
    2017-07-04 10:36:42.083 7940 DEBUG oslo_concurrency.lockutils [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Lock "compute_resources" acquired by "resize_claim" :: waited 0.000s inner /usr/lib/python2.7/site-packages/oslo_concurrency/lockutils.py:444
    2017-07-04 10:36:42.084 7940 DEBUG nova.compute.resource_tracker [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Memory overhead for 8192 MB instance; 0 MB resize_claim /usr/lib/python2.7/site-packages/nova/compute/resource_tracker.py:181
    2017-07-04 10:36:42.087 7940 INFO nova.compute.claims [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Attempting claim: memory 8192 MB, disk 80 GB
    2017-07-04 10:36:42.087 7940 INFO nova.compute.claims [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Total memory: 257763 MB, used: 334848.00 MB
    2017-07-04 10:36:42.088 7940 INFO nova.compute.claims [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] memory limit: 386644.50 MB, free: 51796.50 MB
    2017-07-04 10:36:42.088 7940 INFO nova.compute.claims [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Total disk: 199 GB, used: 1960.00 GB
    2017-07-04 10:36:42.089 7940 INFO nova.compute.claims [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] disk limit: 3184.00 GB, free: 1224.00 GB
    2017-07-04 10:36:42.135 7940 DEBUG nova.compute.resources.vcpu [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Total CPUs: 32 VCPUs, used: 172.00 VCPUs test /usr/lib/python2.7/site-packages/nova/compute/resources/vcpu.py:52
    2017-07-04 10:36:42.136 7940 DEBUG nova.compute.resources.vcpu [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] CPUs limit: 512.00 VCPUs, free: 340.00 VCPUs test /usr/lib/python2.7/site-packages/nova/compute/resources/vcpu.py:63
    2017-07-04 10:36:42.136 7940 INFO nova.compute.claims [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Claim successful

为即将要resize的vm申请cpu，mem，disk资源

    2017-07-04 10:39:31.543 7940 DEBUG keystoneclient.session [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] REQ: curl -g -i -X GET http://172.16.231.21:9696/v2.0/ports.json?tenant_id=6c149dcd3cf64171b8dd972dd03bbac0&device_id=d63958dc-3510-4291-b219-93183c49d2ca -H "User-Agent: python-neutronclient" -H "Accept: application/json" -H "X-Auth-Token: {SHA1}a4553ab155061f8207794e3a5fad6865cd9af651" _http_log_request /usr/lib/python2.7/site-packages/keystoneclient/session.py:195
    2017-07-04 10:39:31.833 7940 DEBUG keystoneclient.session [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] RESP: [200] date: Tue, 04 Jul 2017 02:37:04 GMT connection: keep-alive content-type: application/json; charset=UTF-8 content-length: 701 x-openstack-request-id: req-a75dc999-a4b4-4d94-b544-7dfea42becf0
    RESP BODY: {"ports": [{"status": "ACTIVE", "binding:host_id": "NFJD-TESTN-COMPUTE-3", "allowed_address_pairs": [], "extra_dhcp_opts": [], "device_owner": "compute:nova", "fixed_ips": [{"subnet_id": "8d375886-7bb3-4d9f-a049-ecf2eb25f62a", "ip_address": "192.168.2.128"}], "id": "327e38f0-d108-4240-a053-5c4c4878f88c", "security_groups": ["68a68b74-d424-4a15-8830-c7d2b89ebd56"], "device_id": "d63958dc-3510-4291-b219-93183c49d2ca", "name": "", "admin_state_up": true, "network_id": "ee98ec6a-e1ed-43eb-9d0a-26080d277484", "tenant_id": "6c149dcd3cf64171b8dd972dd03bbac0", "binding:vif_details": {"port_filter": false}, "binding:vnic_type": "normal", "binding:vif_type": "ovs", "mac_address": "fa:16:3e:40:33:dd"}]}
     _http_log_response /usr/lib/python2.7/site-packages/keystoneclient/session.py:224

获取vm的port信息

    2017-07-04 10:39:31.834 7940 DEBUG keystoneclient.session [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] REQ: curl -g -i -X PUT http://172.16.231.21:9696/v2.0/ports/327e38f0-d108-4240-a053-5c4c4878f88c.json -H "User-Agent: python-neutronclient" -H "Content-Type: application/json" -H "Accept: application/json" -H "X-Auth-Token: {SHA1}a4553ab155061f8207794e3a5fad6865cd9af651" -d '{"port": {"binding:host_id": "NFJD-TESTN-COMPUTE-2"}}' _http_log_request /usr/lib/python2.7/site-packages/keystoneclient/session.py:195
    2017-07-04 10:39:31.928 7940 DEBUG keystoneclient.session [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] RESP: [200] date: Tue, 04 Jul 2017 02:37:04 GMT connection: keep-alive content-type: application/json; charset=UTF-8 content-length: 698 x-openstack-request-id: req-4c2d569d-b589-4b33-b17a-2fe9ecec50c8
    RESP BODY: {"port": {"status": "ACTIVE", "binding:host_id": "NFJD-TESTN-COMPUTE-2", "allowed_address_pairs": [], "extra_dhcp_opts": [], "device_owner": "compute:nova", "fixed_ips": [{"subnet_id": "8d375886-7bb3-4d9f-a049-ecf2eb25f62a", "ip_address": "192.168.2.128"}], "id": "327e38f0-d108-4240-a053-5c4c4878f88c", "security_groups": ["68a68b74-d424-4a15-8830-c7d2b89ebd56"], "device_id": "d63958dc-3510-4291-b219-93183c49d2ca", "name": "", "admin_state_up": true, "network_id": "ee98ec6a-e1ed-43eb-9d0a-26080d277484", "tenant_id": "6c149dcd3cf64171b8dd972dd03bbac0", "binding:vif_details": {"port_filter": false}, "binding:vnic_type": "normal", "binding:vif_type": "ovs", "mac_address": "fa:16:3e:40:33:dd"}}
     _http_log_response /usr/lib/python2.7/site-packages/keystoneclient/session.py:224

修改vm的port信息，将binding host信息从  NFJD-TESTN-COMPUTE-2修改成 NFJD-TESTN-COMPUTE-3
REQ的body信息-d '{"port": {"binding:host_id": "NFJD-TESTN-COMPUTE-2"}}'
RESP的body从"binding:host_id": "NFJD-TESTN-COMPUTE-3", 变更成了"binding:host_id": "NFJD-TESTN-COMPUTE-2", 

    2017-07-04 10:39:32.654 7940 DEBUG nova.virt.libvirt.driver [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Starting finish_migration finish_migration /usr/lib/python2.7/site-packages/nova/virt/libvirt/driver.py:6989
    
开始 finish_migration 方法

    2017-07-04 10:39:32.655 7940 DEBUG nova.virt.disk.api [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Checking if we can resize image /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/disk. size=85899345920 can_resize_image /usr/lib/python2.7/site-packages/nova/virt/disk/api.py:213
    2017-07-04 10:39:32.655 7940 DEBUG oslo_concurrency.processutils [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Running cmd (subprocess): env LC_ALL=C LANG=C qemu-img info /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/disk execute /usr/lib/python2.7/site-packages/oslo_concurrency/processutils.py:223

通过命令“qemu-img info”检查disk文件是否可以resize

    2017-07-04 10:39:32.722 7940 DEBUG nova.virt.disk.api [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Checking if we can extend filesystem inside /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/disk. CoW=True is_image_extendable /usr/lib/python2.7/site-packages/nova/virt/disk/api.py:227
    2017-07-04 10:39:32.723 7940 DEBUG nova.virt.disk.vfs.api [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Instance for image imgfile=/var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/disk imgfmt=qcow2 partition=None instance_for_image /usr/lib/python2.7/site-packages/nova/virt/disk/vfs/api.py:46
    2017-07-04 10:39:32.723 7940 DEBUG nova.virt.disk.vfs.api [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Using primary VFSGuestFS instance_for_image /usr/lib/python2.7/site-packages/nova/virt/disk/vfs/api.py:50
    2017-07-04 10:39:32.724 7940 DEBUG nova.virt.disk.vfs.guestfs [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Setting up appliance for /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/disk qcow2 setup /usr/lib/python2.7/site-packages/nova/virt/disk/vfs/guestfs.py:169

检查是否可以extend filesystem

    2017-07-04 10:39:34.190 7940 DEBUG nova.network.neutronv2.api [req-5539f967-c22d-42c0-8f82-afa2017bb990 95c6c2eaccd8432481933be931a54690 98c26c5e5374423bb2c2e61a96fe6470 - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] _get_instance_nw_info() _get_instance_nw_info /usr/lib/python2.7/site-packages/nova/network/neutronv2/api.py:773
    2017-07-04 10:39:34.213 7940 DEBUG keystoneclient.auth.identity.v2 [req-5539f967-c22d-42c0-8f82-afa2017bb990 95c6c2eaccd8432481933be931a54690 98c26c5e5374423bb2c2e61a96fe6470 - - -] Making authentication request to http://172.16.231.115:35357/v2.0/tokens get_auth_ref /usr/lib/python2.7/site-packages/keystoneclient/auth/identity/v2.py:76
    2017-07-04 10:39:34.376 7940 DEBUG keystoneclient.session [req-5539f967-c22d-42c0-8f82-afa2017bb990 95c6c2eaccd8432481933be931a54690 98c26c5e5374423bb2c2e61a96fe6470 - - -] REQ: curl -g -i -X GET http://172.16.231.21:9696/v2.0/ports.json?tenant_id=6c149dcd3cf64171b8dd972dd03bbac0&device_id=d63958dc-3510-4291-b219-93183c49d2ca -H "User-Agent: python-neutronclient" -H "Accept: application/json" -H "X-Auth-Token: {SHA1}0b2a12732f6bd659a206dfb020858f050cdc5fd6" _http_log_request /usr/lib/python2.7/site-packages/keystoneclient/session.py:195
    2017-07-04 10:39:34.638 7940 DEBUG keystoneclient.session [req-5539f967-c22d-42c0-8f82-afa2017bb990 95c6c2eaccd8432481933be931a54690 98c26c5e5374423bb2c2e61a96fe6470 - - -] RESP: [200] date: Tue, 04 Jul 2017 02:37:07 GMT connection: keep-alive content-type: application/json; charset=UTF-8 content-length: 701 x-openstack-request-id: req-a8f53ba8-9851-40c3-8ac2-0fc8a852d833
    RESP BODY: {"ports": [{"status": "ACTIVE", "binding:host_id": "NFJD-TESTN-COMPUTE-2", "allowed_address_pairs": [], "extra_dhcp_opts": [], "device_owner": "compute:nova", "fixed_ips": [{"subnet_id": "8d375886-7bb3-4d9f-a049-ecf2eb25f62a", "ip_address": "192.168.2.128"}], "id": "327e38f0-d108-4240-a053-5c4c4878f88c", "security_groups": ["68a68b74-d424-4a15-8830-c7d2b89ebd56"], "device_id": "d63958dc-3510-4291-b219-93183c49d2ca", "name": "", "admin_state_up": true, "network_id": "ee98ec6a-e1ed-43eb-9d0a-26080d277484", "tenant_id": "6c149dcd3cf64171b8dd972dd03bbac0", "binding:vif_details": {"port_filter": false}, "binding:vnic_type": "normal", "binding:vif_type": "ovs", "mac_address": "fa:16:3e:40:33:dd"}]}
     _http_log_response /usr/lib/python2.7/site-packages/keystoneclient/session.py:224
    2017-07-04 10:39:34.640 7940 DEBUG keystoneclient.session [req-5539f967-c22d-42c0-8f82-afa2017bb990 95c6c2eaccd8432481933be931a54690 98c26c5e5374423bb2c2e61a96fe6470 - - -] REQ: curl -g -i -X GET http://172.16.231.21:9696/v2.0/networks.json?id=ee98ec6a-e1ed-43eb-9d0a-26080d277484 -H "User-Agent: python-neutronclient" -H "Accept: application/json" -H "X-Auth-Token: {SHA1}aafe088a1f0bdaf55a3374d2e8437a7fac0d3a6e" _http_log_request /usr/lib/python2.7/site-packages/keystoneclient/session.py:195
    2017-07-04 10:39:34.891 7940 DEBUG keystoneclient.session [req-5539f967-c22d-42c0-8f82-afa2017bb990 95c6c2eaccd8432481933be931a54690 98c26c5e5374423bb2c2e61a96fe6470 - - -] RESP: [200] date: Tue, 04 Jul 2017 02:37:07 GMT connection: keep-alive content-type: application/json; charset=UTF-8 content-length: 269 x-openstack-request-id: req-0d9ef411-e617-443b-821d-730c66cd9507
    RESP BODY: {"networks": [{"status": "ACTIVE", "subnets": ["8d375886-7bb3-4d9f-a049-ecf2eb25f62a"], "name": "net001", "admin_state_up": true, "router:external": false, "tenant_id": "23f23d0bed4f4f408ff7d21492254e1d", "shared": false, "id": "ee98ec6a-e1ed-43eb-9d0a-26080d277484"}]}
     _http_log_response /usr/lib/python2.7/site-packages/keystoneclient/session.py:224
    2017-07-04 10:39:34.893 7940 DEBUG keystoneclient.session [req-5539f967-c22d-42c0-8f82-afa2017bb990 95c6c2eaccd8432481933be931a54690 98c26c5e5374423bb2c2e61a96fe6470 - - -] REQ: curl -g -i -X GET http://172.16.231.21:9696/v2.0/floatingips.json?fixed_ip_address=192.168.2.128&port_id=327e38f0-d108-4240-a053-5c4c4878f88c -H "User-Agent: python-neutronclient" -H "Accept: application/json" -H "X-Auth-Token: {SHA1}0b2a12732f6bd659a206dfb020858f050cdc5fd6" _http_log_request /usr/lib/python2.7/site-packages/keystoneclient/session.py:195
    2017-07-04 10:39:34.901 7940 DEBUG keystoneclient.session [req-5539f967-c22d-42c0-8f82-afa2017bb990 95c6c2eaccd8432481933be931a54690 98c26c5e5374423bb2c2e61a96fe6470 - - -] RESP: [200] date: Tue, 04 Jul 2017 02:37:07 GMT connection: keep-alive content-type: application/json; charset=UTF-8 content-length: 19 x-openstack-request-id: req-d8f3d38b-b1a7-4ae6-8dd7-0deae746add4
    RESP BODY: {"floatingips": []}
     _http_log_response /usr/lib/python2.7/site-packages/keystoneclient/session.py:224
    2017-07-04 10:39:34.902 7940 DEBUG keystoneclient.session [req-5539f967-c22d-42c0-8f82-afa2017bb990 95c6c2eaccd8432481933be931a54690 98c26c5e5374423bb2c2e61a96fe6470 - - -] REQ: curl -g -i -X GET http://172.16.231.21:9696/v2.0/subnets.json?id=8d375886-7bb3-4d9f-a049-ecf2eb25f62a -H "User-Agent: python-neutronclient" -H "Accept: application/json" -H "X-Auth-Token: {SHA1}aafe088a1f0bdaf55a3374d2e8437a7fac0d3a6e" _http_log_request /usr/lib/python2.7/site-packages/keystoneclient/session.py:195
    2017-07-04 10:39:34.917 7940 DEBUG keystoneclient.session [req-5539f967-c22d-42c0-8f82-afa2017bb990 95c6c2eaccd8432481933be931a54690 98c26c5e5374423bb2c2e61a96fe6470 - - -] RESP: [200] date: Tue, 04 Jul 2017 02:37:07 GMT connection: keep-alive content-type: application/json; charset=UTF-8 content-length: 492 x-openstack-request-id: req-fc2f8f43-b004-4cb1-b2c6-d35ecdf43e14
    RESP BODY: {"subnets": [{"vsd_managed": false, "name": "net001", "enable_dhcp": true, "network_id": "ee98ec6a-e1ed-43eb-9d0a-26080d277484", "tenant_id": "23f23d0bed4f4f408ff7d21492254e1d", "dns_nameservers": ["8.8.8.8"], "gateway_ip": "192.168.2.1", "ipv6_ra_mode": null, "allocation_pools": [{"start": "192.168.2.2", "end": "192.168.2.248"}], "host_routes": [], "ip_version": 4, "ipv6_address_mode": null, "cidr": "192.168.2.0/24", "id": "8d375886-7bb3-4d9f-a049-ecf2eb25f62a", "subnetpool_id": null}]}
     _http_log_response /usr/lib/python2.7/site-packages/keystoneclient/session.py:224
    2017-07-04 10:39:34.918 7940 DEBUG keystoneclient.session [req-5539f967-c22d-42c0-8f82-afa2017bb990 95c6c2eaccd8432481933be931a54690 98c26c5e5374423bb2c2e61a96fe6470 - - -] REQ: curl -g -i -X GET http://172.16.231.21:9696/v2.0/ports.json?network_id=ee98ec6a-e1ed-43eb-9d0a-26080d277484&device_owner=network%3Adhcp -H "User-Agent: python-neutronclient" -H "Accept: application/json" -H "X-Auth-Token: {SHA1}aafe088a1f0bdaf55a3374d2e8437a7fac0d3a6e" _http_log_request /usr/lib/python2.7/site-packages/keystoneclient/session.py:195
    2017-07-04 10:39:34.931 7940 DEBUG keystoneclient.session [req-5539f967-c22d-42c0-8f82-afa2017bb990 95c6c2eaccd8432481933be931a54690 98c26c5e5374423bb2c2e61a96fe6470 - - -] RESP: [200] date: Tue, 04 Jul 2017 02:37:07 GMT connection: keep-alive content-type: application/json; charset=UTF-8 content-length: 13 x-openstack-request-id: req-e39c8301-a788-4ca4-9bed-53c549acd0b1
    RESP BODY: {"ports": []}
     _http_log_response /usr/lib/python2.7/site-packages/keystoneclient/session.py:224
    2017-07-04 10:39:34.932 7940 DEBUG nova.network.base_api [req-5539f967-c22d-42c0-8f82-afa2017bb990 95c6c2eaccd8432481933be931a54690 98c26c5e5374423bb2c2e61a96fe6470 - - -] Updating cache with info: [VIF({'profile': None, 'ovs_interfaceid': u'327e38f0-d108-4240-a053-5c4c4878f88c', 'preserve_on_delete': False, 'network': Network({'bridge': 'alubr0', 'subnets': [Subnet({'ips': [FixedIP({'meta': {}, 'version': 4, 'type': 'fixed', 'floating_ips': [], 'address': u'192.168.2.128'})], 'version': 4, 'meta': {}, 'dns': [IP({'meta': {}, 'version': 4, 'type': 'dns', 'address': u'8.8.8.8'})], 'routes': [], 'cidr': u'192.168.2.0/24', 'gateway': IP({'meta': {}, 'version': 4, 'type': 'gateway', 'address': u'192.168.2.1'})})], 'meta': {'injected': False, 'tenant_id': u'23f23d0bed4f4f408ff7d21492254e1d'}, 'id': u'ee98ec6a-e1ed-43eb-9d0a-26080d277484', 'label': u'net001'}), 'devname': u'tap327e38f0-d1', 'vnic_type': u'normal', 'qbh_params': None, 'meta': {}, 'details': {u'port_filter': False}, 'address': u'fa:16:3e:40:33:dd', 'active': True, 'type': u'ovs', 'id': u'327e38f0-d108-4240-a053-5c4c4878f88c', 'qbg_params': None})] update_instance_cache_with_nw_info /usr/lib/python2.7/site-packages/nova/network/base_api.py:42

调用neutron API获取vm的网络信息并更新cache

    2017-07-04 10:39:35.163 7940 DEBUG nova.virt.disk.api [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Checking if we can resize image /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/disk. size=85899345920 can_resize_image /usr/lib/python2.7/site-packages/nova/virt/disk/api.py:213
    2017-07-04 10:39:35.165 7940 DEBUG oslo_concurrency.processutils [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Running cmd (subprocess): env LC_ALL=C LANG=C qemu-img info /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/disk execute /usr/lib/python2.7/site-packages/oslo_concurrency/processutils.py:223

获取image 文件 的信息判断 是否可以resize

    2017-07-04 10:39:35.230 7940 DEBUG oslo_concurrency.processutils [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Running cmd (subprocess): qemu-img resize /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/disk 85899345920 execute /usr/lib/python2.7/site-packages/oslo_concurrency/processutils.py:223

通过“qemu-img resize”命令resize image文件

    2017-07-04 10:39:35.297 7940 DEBUG nova.virt.disk.api [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Checking if we can extend filesystem inside /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/disk. CoW=True is_image_extendable /usr/lib/python2.7/site-packages/nova/virt/disk/api.py:227

检查image文件是否extend filesystem。检查结果：CoW=True is_image_extendable

    2017-07-04 10:39:37.728 7940 INFO nova.virt.libvirt.driver [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Creating image
    2017-07-04 10:39:37.729 7940 DEBUG oslo_concurrency.processutils [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Running cmd (subprocess): sudo nova-rootwrap /etc/nova/rootwrap.conf chown 162 /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/disk.config execute /usr/lib/python2.7/site-packages/oslo_concurrency/processutils.py:223
    2017-07-04 10:39:37.804 7940 INFO nova.virt.libvirt.driver [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Using config drive
    2017-07-04 10:39:37.901 7940 INFO nova.virt.libvirt.driver [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Creating config drive at /var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/disk.config

生成image文件，使用nova-rootwrap，使用root权限修改disk.config文件权限，disk.config配置使用config drive
    
    2017-07-04 10:39:37.924 7940 DEBUG nova.virt.libvirt.driver [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Start _get_guest_xml network_info=[VIF({'profile': None, 'ovs_interfaceid': u'327e38f0-d108-4240-a053-5c4c4878f88c', 'preserve_on_delete': False, 'network': Network({'bridge': 'alubr0', 'subnets': [Subnet({'ips': [FixedIP({'version': 4, 'vif_mac': u'fa:16:3e:40:33:dd', 'floating_ips': [], 'label': u'net001', 'meta': {}, 'address': u'192.168.2.128', 'type': 'fixed'})], 'version': 4, 'meta': {}, 'dns': [IP({'meta': {}, 'version': 4, 'type': 'dns', 'address': u'8.8.8.8'})], 'routes': [], 'cidr': u'192.168.2.0/24', 'gateway': IP({'meta': {}, 'version': 4, 'type': 'gateway', 'address': u'192.168.2.1'})})], 'meta': {'injected': False, 'tenant_id': u'23f23d0bed4f4f408ff7d21492254e1d'}, 'id': u'ee98ec6a-e1ed-43eb-9d0a-26080d277484', 'label': u'net001'}), 'devname': u'tap327e38f0-d1', 'vnic_type': u'normal', 'qbh_params': None, 'meta': {}, 'details': {u'port_filter': False}, 'address': u'fa:16:3e:40:33:dd', 'active': True, 'type': u'ovs', 'id': u'327e38f0-d108-4240-a053-5c4c4878f88c', 'qbg_params': None})] disk_info={'disk_bus': 'virtio', 'cdrom_bus': 'ide', 'mapping': {'disk.config': {'bus': 'ide', 'type': 'cdrom', 'dev': 'hdd'}, 'disk': {'bus': 'virtio', 'boot_index': '1', 'type': 'disk', 'dev': u'vda'}, 'root': {'bus': 'virtio', 'boot_index': '1', 'type': 'disk', 'dev': u'vda'}}} image_meta={u'min_disk': 40, u'container_format': u'bare', u'min_ram': 0, u'disk_format': u'qcow2', u'properties': {u'image.os_type': u'linux', u'hw_qemu_guest_agent': u'yes', u'base_image_ref': u'8aaf1759-9fb4-4ba9-8cff-1743eb824c5f', u'os_distro': u'centos', u'hw_ovirt_guest_agent': u'yes'}} rescue=None block_device_info={'block_device_mapping': [], 'swap': None, 'ephemerals': [], 'root_device_name': u'/dev/vda'} _get_guest_xml /usr/lib/python2.7/site-packages/nova/virt/libvirt/driver.py:4547
    2017-07-04 10:39:38.140 7940 DEBUG nova.virt.libvirt.vif [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] vif_type=ovs instance=Instance(access_ip_v4=None,access_ip_v6=None,architecture=None,auto_disk_config=False,availability_zone='nova',cell_name=None,cleaned=False,config_drive='True',created_at=2017-07-04T02:34:42Z,default_ephemeral_device=None,default_swap_device=None,deleted=False,deleted_at=None,disable_terminate=False,display_description='test',display_name='test',ephemeral_gb=0,ephemeral_key_uuid=None,fault=<?>,flavor=Flavor(9),host='NFJD-TESTN-COMPUTE-2',hostname='test',id=26717,image_ref='8aaf1759-9fb4-4ba9-8cff-1743eb824c5f',info_cache=InstanceInfoCache,instance_type_id=9,kernel_id='',key_data=None,key_name=None,launch_index=0,launched_at=2017-07-04T02:35:15Z,launched_on='NFJD-TESTN-COMPUTE-3',locked=False,locked_by=None,memory_mb=8192,metadata={},new_flavor=Flavor(9),node='NFJD-TESTN-COMPUTE-2',numa_topology=None,old_flavor=Flavor(3),os_type=None,pci_devices=PciDeviceList,pci_requests=<?>,power_state=1,progress=0,project_id='6c149dcd3cf64171b8dd972dd03bbac0',ramdisk_id='',reservation_id='r-7uedfsof',root_device_name='/dev/vda',root_gb=80,scheduled_at=None,security_groups=SecurityGroupList,shutdown_terminate=False,system_metadata={image_base_image_ref='8aaf1759-9fb4-4ba9-8cff-1743eb824c5f',image_container_format='bare',image_disk_format='qcow2',image_hw_ovirt_guest_agent='yes',image_hw_qemu_guest_agent='yes',image_image.os_type='linux',image_min_disk='40',image_min_ram='0',image_os_distro='centos',old_vm_state='active'},tags=<?>,task_state='resize_finish',terminated_at=None,updated_at=2017-07-04T02:38:01Z,user_data=None,user_id='62f52135115f4898bd0d82c1f0cd632b',uuid=d63958dc-3510-4291-b219-93183c49d2ca,vcpu_model=VirtCPUModel,vcpus=4,vm_mode=None,vm_state='active') vif=VIF({'profile': None, 'ovs_interfaceid': u'327e38f0-d108-4240-a053-5c4c4878f88c', 'preserve_on_delete': False, 'network': Network({'bridge': 'alubr0', 'subnets': [Subnet({'ips': [FixedIP({'version': 4, 'vif_mac': u'fa:16:3e:40:33:dd', 'floating_ips': [], 'label': u'net001', 'meta': {}, 'address': u'192.168.2.128', 'type': 'fixed'})], 'version': 4, 'meta': {}, 'dns': [IP({'meta': {}, 'version': 4, 'type': 'dns', 'address': u'8.8.8.8'})], 'routes': [], 'cidr': u'192.168.2.0/24', 'gateway': IP({'meta': {}, 'version': 4, 'type': 'gateway', 'address': u'192.168.2.1'})})], 'meta': {'injected': False, 'tenant_id': u'23f23d0bed4f4f408ff7d21492254e1d'}, 'id': u'ee98ec6a-e1ed-43eb-9d0a-26080d277484', 'label': u'net001'}), 'devname': u'tap327e38f0-d1', 'vnic_type': u'normal', 'qbh_params': None, 'meta': {}, 'details': {u'port_filter': False}, 'address': u'fa:16:3e:40:33:dd', 'active': True, 'type': u'ovs', 'id': u'327e38f0-d108-4240-a053-5c4c4878f88c', 'qbg_params': None}) virt_typekvm get_config /usr/lib/python2.7/site-packages/nova/virt/libvirt/vif.py:364
    2017-07-04 10:39:38.144 7940 DEBUG nova.virt.libvirt.driver [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Qemu guest agent is enabled through image metadata _set_qemu_guest_agent /usr/lib/python2.7/site-packages/nova/virt/libvirt/driver.py:4145
    2017-07-04 10:39:38.144 7940 DEBUG nova.virt.libvirt.driver [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Ovirt guest agent is enabled through image metadata _set_ovirt_guest_agent /usr/lib/python2.7/site-packages/nova/virt/libvirt/driver.py:4161
    2017-07-04 10:39:38.147 7940 DEBUG nova.virt.libvirt.config [req-ced45485-770b-4751-a339-58f070c6342b 62f52135115f4898bd0d82c1f0cd632b 6c149dcd3cf64171b8dd972dd03bbac0 - - -] Generated XML ('<domain type="kvm">\n  <uuid>d63958dc-3510-4291-b219-93183c49d2ca</uuid>\n  <name>instance-0000685d</name>\n  <memory>8388608</memory>\n  <vcpu>4</vcpu>\n  <metadata>\n    <nova:instance xmlns:nova="http://openstack.org/xmlns/libvirt/nova/1.0">\n      <nova:package version="2015.1.5-1.el7.centos"/>\n      <nova:name>test</nova:name>\n      <nova:creationTime>2017-07-04 02:39:38</nova:creationTime>\n      <nova:flavor name="m1.large">\n        <nova:memory>8192</nova:memory>\n        <nova:disk>80</nova:disk>\n        <nova:swap>0</nova:swap>\n        <nova:ephemeral>0</nova:ephemeral>\n        <nova:vcpus>4</nova:vcpus>\n      </nova:flavor>\n      <nova:owner>\n        <nova:user uuid="62f52135115f4898bd0d82c1f0cd632b">admin</nova:user>\n        <nova:project uuid="6c149dcd3cf64171b8dd972dd03bbac0">admin</nova:project>\n      </nova:owner>\n      <nova:root type="image" uuid="8aaf1759-9fb4-4ba9-8cff-1743eb824c5f"/>\n    </nova:instance>\n  </metadata>\n  <sysinfo type="smbios">\n    <system>\n      <entry name="manufacturer">Fedora Project</entry>\n      <entry name="product">OpenStack Nova</entry>\n      <entry name="version">2015.1.5-1.el7.centos</entry>\n      <entry name="serial">604c99de-78ac-4609-b0b9-f6fb62e705c2</entry>\n      <entry name="uuid">d63958dc-3510-4291-b219-93183c49d2ca</entry>\n    </system>\n  </sysinfo>\n  <os>\n    <type>hvm</type>\n    <boot dev="hd"/>\n    <smbios mode="sysinfo"/>\n  </os>\n  <features>\n    <acpi/>\n    <apic/>\n  </features>\n  <cputune>\n    <shares>4096</shares>\n  </cputune>\n  <clock offset="utc">\n    <timer name="pit" tickpolicy="delay"/>\n    <timer name="rtc" tickpolicy="catchup"/>\n    <timer name="hpet" present="no"/>\n  </clock>\n  <cpu mode="host-model" match="exact">\n    <topology sockets="4" cores="1" threads="1"/>\n  </cpu>\n  <devices>\n    <disk type="file" device="disk">\n      <driver name="qemu" type="qcow2" cache="directsync"/>\n      <source file="/var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/disk"/>\n      <target bus="virtio" dev="vda"/>\n    </disk>\n    <disk type="file" device="cdrom">\n      <driver name="qemu" type="raw" cache="directsync"/>\n      <source file="/var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/disk.config"/>\n      <target bus="ide" dev="hdd"/>\n    </disk>\n    <interface type="bridge">\n      <mac address="fa:16:3e:40:33:dd"/>\n      <model type="virtio"/>\n      <source bridge="alubr0"/>\n      <target dev="tap327e38f0-d1"/>\n      <virtualport type="openvswitch">\n        <parameters interfaceid="327e38f0-d108-4240-a053-5c4c4878f88c"/>\n      </virtualport>\n    </interface>\n    <serial type="file">\n      <source path="/var/lib/nova/instances/d63958dc-3510-4291-b219-93183c49d2ca/console.log"/>\n    </serial>\n    <serial type="pty"/>\n    <input type="tablet" bus="usb"/>\n    <graphics type="vnc" autoport="yes" keymap="en-us" listen="0.0.0.0"/>\n    <video>\n      <model type="cirrus"/>\n    </video>\n    <channel type="unix">\n      <source mode="bind" path="/var/lib/libvirt/qemu/org.qemu.guest_agent.0.instance-0000685d.sock"/>\n      <target type="virtio" name="org.qemu.guest_agent.0"/>\n    </channel>\n    <channel type="unix">\n      <source mode="bind" path="/var/lib/libvirt/qemu/com.redhat.rhevm.vdsm.instance-0000685d.sock"/>\n      <target type="virtio" name="com.redhat.rhevm.vdsm"/>\n    </channel>\n    <channel type="unix">\n      <source mode="bind" path="/var/lib/libvirt/qemu/com.redhat.rhevm.vdsm.0.instance-0000685d.sock"/>\n      <target type="virtio" name="com.redhat.rhevm.vdsm.0"/>\n    </channel>\n    <memballoon model="virtio">\n      <stats period="10"/>\n    </memballoon>\n  </devices>\n</domain>\n',)  to_xml /usr/lib/python2.7/site-packages/nova/virt/libvirt/config.py:82

生成vm boot所需要的xml文件

    2017-07-04 10:39:39.224 7940 DEBUG nova.virt.driver [req-13fbc44e-ff27-43a1-bedc-6c40889619ce - - - - -] Emitting event <LifecycleEvent: 1499135979.22, d63958dc-3510-4291-b219-93183c49d2ca => Resumed> emit_event /usr/lib/python2.7/site-packages/nova/virt/driver.py:1309
    2017-07-04 10:39:39.226 7940 INFO nova.compute.manager [req-13fbc44e-ff27-43a1-bedc-6c40889619ce - - - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] VM Resumed (Lifecycle Event)
    2017-07-04 10:39:39.230 7940 INFO nova.virt.libvirt.driver [-] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Instance running successfully.
    2017-07-04 10:39:39.297 7940 DEBUG nova.compute.manager [req-13fbc44e-ff27-43a1-bedc-6c40889619ce - - - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Synchronizing instance power state after lifecycle event "Resumed"; current vm_state: active, current task_state: resize_finish, current DB power_state: 1, VM power_state: 1 handle_lifecycle_event /usr/lib/python2.7/site-packages/nova/compute/manager.py:1274
    2017-07-04 10:39:39.361 7940 INFO nova.compute.manager [req-13fbc44e-ff27-43a1-bedc-6c40889619ce - - - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] During sync_power_state the instance has a pending task (resize_finish). Skip.
    2017-07-04 10:39:39.362 7940 DEBUG nova.virt.driver [req-13fbc44e-ff27-43a1-bedc-6c40889619ce - - - - -] Emitting event <LifecycleEvent: 1499135979.23, d63958dc-3510-4291-b219-93183c49d2ca => Started> emit_event /usr/lib/python2.7/site-packages/nova/virt/driver.py:1309
    2017-07-04 10:39:39.363 7940 INFO nova.compute.manager [req-13fbc44e-ff27-43a1-bedc-6c40889619ce - - - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] VM Started (Lifecycle Event)
    2017-07-04 10:39:39.425 7940 DEBUG nova.compute.manager [req-13fbc44e-ff27-43a1-bedc-6c40889619ce - - - - -] [instance: d63958dc-3510-4291-b219-93183c49d2ca] Synchronizing instance power state after lifecycle event "Started"; current vm_state: resized, current task_state: None, current DB power_state: 1, VM power_state: 1 handle_lifecycle_event /usr/lib/python2.7/site-packages/nova/compute/manager.py:1274
    
启动vm，更新vm所处的生命周期

    

# 若resize前的vm为关机状态，resize操作不会在resize之后自动开机

nova/compute/manager.py
```python
    ...
            # NOTE(mriedem): If the original vm_state was STOPPED, we don't
            # automatically power on the instance after it's migrated
            power_on = old_vm_state != vm_states.STOPPED
    
            try: 
                self.driver.finish_migration(context, migration, instance,
                                             disk_info,
                                             network_info,
                                             image_meta, resize_instance,
                                             block_device_info, power_on)
    ...
```

