title: 新增OpenStack NOVA API用于强制计算节点nova-compute服务down
date: 2017-06-08 20:11:17
readmore: false
categories: Openstack_dev
tags:
- Nova
- evacuate
---
# 相关blueprints：
https://blueprints.launchpad.net/nova/+spec/mark-host-down
https://blueprints.launchpad.net/python-novaclient/+spec/support-force-down-service



# 为何要新增该API

有了该API，可以让外部故障监控获得nova-compute服务down的速度更快，这将直接提高VM HA的故障恢复时间（从故障节点疏散VM到正常节点的时间）。
external fault monitoring system a possibility of telling OpenStack Nova fast that compute host is down. This will immediately enable calling of evacuation of any VM on host and further enabling faster HA actions.



# REST API for forced down

request: PUT /v2.1/{tenant_id}/os-services/force-down { “binary”: “nova-compute”, “host”: “compute1”, “forced_down”: true }

response: 200 OK { “service”: { “host”: “compute1”, “binary”: “nova-compute”, “forced_down”: true } }

Example: curl -g -i -X PUT http://{service_host_ip}:8774/v2.1/{tenant_id}/os-services /force-down -H “Content-Type: application/json” -H “Accept: application/json ” -H “X-OpenStack-Nova-API-Version: 2.11” -H “X-Auth-Token: {token}” -d ‘{“b inary”: “nova-compute”, “host”: “compute1”, “forced_down”: true}’



# CLI for forced down

nova service-force-down <hostname> nova-compute

Example: nova service-force-down compute1 nova-compute



# REST API for disabling forced down

request: PUT /v2.1/{tenant_id}/os-services/force-down { “binary”: “nova-compute”, “host”: “compute1”, “forced_down”: false }

response: 200 OK { “service”: { “host”: “compute1”, “binary”: “nova-compute”, “forced_down”: false } }

Example: curl -g -i -X PUT http://{service_host_ip}:8774/v2.1/{tenant_id}/os-services /force-down -H “Content-Type: application/json” -H “Accept: application/json ” -H “X-OpenStack-Nova-API-Version: 2.11” -H “X-Auth-Token: {token}” -d ‘{“b inary”: “nova-compute”, “host”: “compute1”, “forced_down”: false}’



# CLI for disabling forced down

nova service-force-down –unset <hostname> nova-compute

Example: nova service-force-down –unset compute1 nova-compute


