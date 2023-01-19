title: Openstack Placement
date: 2019-04-18 09:14:54
categories:
- Openstack_op

tags:
- placement

---

本文主要内容转自华为范桂飓的文章。
 
# 背景

私有云的用户，尤其是传统 IT 架构转型的私有云用户一般会拥有各式各样的存量资源系统，与这些系统对接会让 OpenStack 的资源体系变得复杂。

从用户的角度出发，或许会希望：

* 作为使用共享存储解决方案的用户，会希望 Nova 和 Horizon 能够正确报告共享存储磁盘资源的总量和使用量信息。
* 作为高级的 Neutron 用户，预期会使用外部的第三方路由网络功能，希望 Nova 能够掌握和使用特定的网络端口与特定的子网池相关联，确保虚拟机能够在该子网池上启动。
* 作为高级的 Cinder 用户，希望当我在 nova boot 命令中指定了 cinder volume-id 后 Nova 能够知道哪一些计算节点与 Request Volume 所在的 Cinder 存储池相关联。

所以，OpenStack 除了要处理计算节点 CPU，内存，PCI 设备、本地磁盘等内部资源外，还经常需要纳管有如 SDS、NFS 提供的存储服务，SDN 提供的网络服务等外部资源。

但在以往，Nova 只能处理由计算节点提供的资源。Nova Resource Tracker 假定所有资源均来自计算节点，因此在周期性上报资源状况时，Resource Tracker 只会单纯对计算节点清单进行资源总量和使用量的加和统计。显然，这无法满足上述复杂的生产需求，也违背了 OpenStack 一向赖以自豪的开放性原则。而且随着 OpenStack 的定义被社区进一步升级为「一个开源基础设施集成引擎」，意味 OpenStack 的资源系统将会由更多外部资源类型构成。

所以，当资源类型和提供者变得多样时，自然就需求一种高度抽象且简单统一的管理方法，让用户和代码能够便捷的使用、管理、监控整个 OpenStack 的系统资源，这就是 Placement（布局）。

# 项目简介

Placement 肩负着这样的历史使命，最早在 Newton 版本被引入到 openstack/nova repo，以 API 的形式进行孵化，所以也经常被称呼为 Placement API。它参与到 nova-scheduler 选择目标主机的调度流程中，负责跟踪记录 Resource Provider 的 Inventory 和 Usage，并使用不同的 Resource Classes 来划分资源类型，使用不同的 Resource Traits 来标记资源特征。

Ocata 版本的 Placement API 是一个可选项，建议用户启用并替代 CpuFilter、CoreFilter 和 DiskFilter。Pike 版本则强制要求启动 Placement API 服务，否则 nova-compute service 无法正常运行。

Placement API 开始了 openstack/nova repo 剥离流程，从 Placement API 蜕变为 OpenStack Placement，并在 Stein 版本中成为独立项目。

# 社区发展情况

从S版开始Placement发布了第一个正式版本1.0.0版本， Placement代码托管在自己的仓库中，并作为独立的OpenStack项目进行管理。

S版大多数变更都不是面向用户的，而是是内部数据从nova到placement的迁移。

S版一共338个commit，以下是公司参与情况。
https://www.stackalytics.com/?module=placement&release=stein&metric=commits

    Contribution Summary
    Commits: 338
    LOCs: 61838
    Do not merge (-2): 2
    Patch needs further work (-1): 154
    Looks good (+1): 313
    Looks good for core (+2): 649
    Approve: 305
    Abandon: 0
    Change Requests: 350 (30 of them abandoned)
    Patch Sets: 1320
    Draft Blueprints: 0
    Completed Blueprints: 0
    Filed Bugs: 0
    Resolved Bugs: 0
    Emails: 0
    Translations: 0

# 工作原理
nova-compute向placement报告资源信息。nova-scheduler在向placement询问满足一系列资源请求的节点的同时，仍然使用部分保留的filter和weight。（目前placement只替代了 nova-scheduler的CpuFilter、CoreFilter 和 DiskFilter常用的过滤器）

nova-scheduler 对 placement-api 的两次调用。第一次，nova-scheduler 向 placement-api 获取一组 Allocation Candidates（分配候选人），所谓 Allocation Candidates 就是能够满足资源需求的 Resource Provider。

EXAMPLE：

    GET /allocation_candidates?resources=VCPU:1,MEMORY_MB:2048,DISK_GB:100

NOTE：获取 Allocation Candidates 的实现是一系列复杂的数据库级联查询与过滤操作，以 query params 作为过滤条件。该例子传递了 Launch Instance 所需的 vCPU、RAM 和 Disk 资源，除此之外，还可以提供 required 和 member_of 参数，分别用于指定 Resource Traits 和 Resource Provider Aggregate 特性，使 Allocation Candidates 的获取方式更加灵活。更多详情请浏览 Allocation candidates。

```bash
[root@control01 ~]# openstack allocation candidate list --resource VCPU=1,MEMORY_MB=2048,DISK_GB=10 --required HW_CPU_X86_SSE2
+---+----------------------------------+--------------------------------------+----------------------------------------------+--------------------------------------------------------------+
| # | allocation                       | resource provider                    | inventory used/capacity                      | traits                                                       |
+---+----------------------------------+--------------------------------------+----------------------------------------------+--------------------------------------------------------------+
| 1 | VCPU=1,MEMORY_MB=2048,DISK_GB=10 | 5c5a578f-51b0-481c-b38c-7aaa3394e585 | VCPU=5/512,MEMORY_MB=3648/60670,DISK_GB=7/49 | HW_CPU_X86_SSE2,HW_CPU_X86_SSE,HW_CPU_X86_MMX,HW_CPU_X86_SVM |
+---+----------------------------------+--------------------------------------+----------------------------------------------+--------------------------------------------------------------+
```

<!-- more -->

placement-api 返回给 nova-scheduler 的 JSON object with a list of allocation requests and a JSON object of provider summary objects 数据结构如下，关键在于 allocation_requests 和 provider_summaries 两个字段，它们在后续的 Scheduler Filters 逻辑中也发挥着重要的作用。

```bash
{
  "allocation_requests": [
    <ALLOCATION_REQUEST_1>,
    ...
    <ALLOCATION_REQUEST_N>
  ],
  "provider_summaries": {
    <COMPUTE_NODE_UUID_1>: <PROVIDER_SUMMARY_1>,
    ...
    <COMPUTE_NODE_UUID_N>: <PROVIDER_SUMMARY_N>,
  }
}
```

allocation_requests：包含了所有能够满足需求的 resource provider 及其预期分配的资源清单。

```bash
"allocation_requests": [
        {
            "allocations": {
                "a99bad54-a275-4c4f-a8a3-ac00d57e5c64": {
                    "resources": {
                        "DISK_GB": 100
                    }
                },
                "35791f28-fb45-4717-9ea9-435b3ef7c3b3": {
                    "resources": {
                        "VCPU": 1,
                        "MEMORY_MB": 1024
                    }
                }
            }
        },
        {
            "allocations": {
                "a99bad54-a275-4c4f-a8a3-ac00d57e5c64": {
                    "resources": {
                        "DISK_GB": 100
                    }
                },
                "915ef8ed-9b91-4e38-8802-2e4224ad54cd": {
                    "resources": {
                        "VCPU": 1,
                        "MEMORY_MB": 1024
                    }
                }
            }
        }
    ],
```

provider_summaries：包含了所有满足需求的 resource providers 的各项资源总量和使用量信息。

```bash
 "provider_summaries": {
        "a99bad54-a275-4c4f-a8a3-ac00d57e5c64": {
            "resources": {
                "DISK_GB": {
                    "used": 0,
                    "capacity": 1900
                }
            },
            "traits": ["MISC_SHARES_VIA_AGGREGATE"],
            "parent_provider_uuid": null,
            "root_provider_uuid": "a99bad54-a275-4c4f-a8a3-ac00d57e5c64"
        },
        "35791f28-fb45-4717-9ea9-435b3ef7c3b3": {
            "resources": {
                "VCPU": {
                    "used": 0,
                    "capacity": 384
                },
                "MEMORY_MB": {
                    "used": 0,
                    "capacity": 196608
                }
            },
            "traits": ["HW_CPU_X86_SSE2", "HW_CPU_X86_AVX2"],
            "parent_provider_uuid": null,
            "root_provider_uuid": "35791f28-fb45-4717-9ea9-435b3ef7c3b3"
        },
        "915ef8ed-9b91-4e38-8802-2e4224ad54cd": {
            "resources": {
                "VCPU": {
                    "used": 0,
                    "capacity": 384
                },
                "MEMORY_MB": {
                    "used": 0,
                    "capacity": 196608
                }
            },
            "traits": ["HW_NIC_SRIOV"],
            "parent_provider_uuid": null,
            "root_provider_uuid": "915ef8ed-9b91-4e38-8802-2e4224ad54cd"
        },
        "f5120cad-67d9-4f20-9210-3092a79a28cf": {
            "resources": {
                "SRIOV_NET_VF": {
                    "used": 0,
                    "capacity": 8
                }
            },
            "traits": [],
            "parent_provider_uuid": "915ef8ed-9b91-4e38-8802-2e4224ad54cd",
            "root_provider_uuid": "915ef8ed-9b91-4e38-8802-2e4224ad54cd"
        }
    }
NOTE：可以看出 SRIOV_NET_VF 亦被当做为一种资源类型，由专门的 resource provider 提供。
```

nova-scheduler 在获得了 Allocation Candidates 之后再进一步通过 Filtered 和 Weighed 机制来最终确定目标主机。然后再根据 allocation requests 和 provider summaries 的数据来扣除（claim_resources）目标主机对应的 resource provider 的资源使用量，这就是 nova-scheduler 第二次调用 placement-api 所做的事情。回顾一下 allocations tables 的内容：

```bash
MariaDB [nova_api]> select * from allocations;
+---------------------+------------+----+----------------------+--------------------------------------+-------------------+------+
| created_at          | updated_at | id | resource_provider_id | consumer_id                          | resource_class_id | used |
+---------------------+------------+----+----------------------+--------------------------------------+-------------------+------+
| 2018-08-01 10:52:15 | NULL       |  7 |                    1 | f8d55035-389c-47b8-beea-02f00f25f5d9 |                 0 |    1 |
| 2018-08-01 10:52:15 | NULL       |  8 |                    1 | f8d55035-389c-47b8-beea-02f00f25f5d9 |                 1 |  512 |
| 2018-08-01 10:52:15 | NULL       |  9 |                    1 | f8d55035-389c-47b8-beea-02f00f25f5d9 |                 2 |    1 |
+---------------------+------------+----+----------------------+--------------------------------------+-------------------+------+

# consumer_id 消费者
# resource_class_id 资源类型
# resource_provider_id 资源提供者
# used 分配的数量
# 上述记录表示为虚拟机分配了 vCPU 1颗，RAM 512MB，Disk 1GB
显然，其中的 Consumer 消费者就是要创建的虚拟机了。
```

# 软件安装

1 创建数据库

要创建数据库，请完成以下步骤：
o   使用数据库访问客户端以root用户身份连接到数据库服务器：

```bash
    $ mysql -u root -p
```

o   创建placement数据库：

```bash
    MariaDB [(none)]> CREATE DATABASE placement;
```

o   授予对数据库的适当访问权限：

```bash
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'localhost' \
      IDENTIFIED BY 'PLACEMENT_DBPASS';
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'%' \
      IDENTIFIED BY 'PLACEMENT_DBPASS';
    替换PLACEMENT_DBPASS为合适的密码。
```

o   退出数据库访问客户端。

2 配置用户和端点
1)  来源admin凭据来访问仅管理员CLI命令：

```bash
    $ . admin-openrc
```

2)  使用您选择的创建Placement服务用户PLACEMENT_PASS：

```bash
$ openstack user create --domain default --password-prompt placement

User Password:
Repeat User Password:
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| domain_id           | default                          |
| enabled             | True                             |
| id                  | fa742015a6494a949f67629884fc7ec8 |
| name                | placement                        |
| options             | {}                               |
| password_expires_at | None                             |
+---------------------+----------------------------------+
```
3)  使用admin角色将Placement用户添加到服务项目：

    $ openstack role add --project service --user placement admin

4)  在服务目录中创建Placement API条目：

```bash
$ openstack service create --name placement \
  --description "Placement API" placement

+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | Placement API                    |
| enabled     | True                             |
| id          | 2d1a27022e6e4185b86adac4444c495f |
| name        | placement                        |
| type        | placement                        |
+-------------+----------------------------------+
```

5)  创建Placement API服务端点：

```bash
$ openstack endpoint create --region RegionOne \
  placement public http://controller:8778

+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 2b1b2637908b4137a9c2e0470487cbc0 |
| interface    | public                           |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 2d1a27022e6e4185b86adac4444c495f |
| service_name | placement                        |
| service_type | placement                        |
| url          | http://controller:8778           |
+--------------+----------------------------------+

$ openstack endpoint create --region RegionOne \
  placement internal http://controller:8778

+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 02bcda9a150a4bd7993ff4879df971ab |
| interface    | internal                         |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 2d1a27022e6e4185b86adac4444c495f |
| service_name | placement                        |
| service_type | placement                        |
| url          | http://controller:8778           |
+--------------+----------------------------------+

$ openstack endpoint create --region RegionOne \
  placement admin http://controller:8778

+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 3d71177b9e0f406f98cbff198d74b182 |
| interface    | admin                            |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 2d1a27022e6e4185b86adac4444c495f |
| service_name | placement                        |
| service_type | placement                        |
| url          | http://controller:8778           |
+--------------+----------------------------------+
```

3 安装和配置组件
1)  安装包：

```bash
    # yum install openstack-placement-api
```

2)  编辑/etc/placement/placement.conf文件并完成以下操作：
o   在该[placement_database]部分中，配置数据库访问：

```bash
    [placement_database]
    # ...
    connection = mysql+pymysql://placement:PLACEMENT_DBPASS@controller/placement
    替换PLACEMENT_DBPASS为您为放置数据库选择的密码。
```

o   在[api]和[keystone_authtoken]部分中，配置身份服务访问：

```bash
[api]
# ...
auth_strategy = keystone

[keystone_authtoken]
# ...
auth_url = http://controller:5000/v3
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = placement
password = PLACEMENT_PASS
替换PLACEMENT_PASS为您placement在Identity服务中为用户选择的密码 。
```

3)  填充placement数据库：

```bash
    # su -s /bin/sh -c "placement-manage db sync" placement
```

4 完成安装
•  重启httpd服务：

```bash
    # systemctl restart httpd
```

# 使用方法

1 Resource provider aggregates 功能

Resource provider aggregates 是一个类似于 Host Aggregate 的功能，获取 Allocation Candidates 时，支持通过 member_of request query parameter 从特定的 Aggregate 中获取。Resource provider aggregates 非常适用于拥有不同主机聚合（ e.g. 高性能主机聚合，大存储容量主机聚合）类型的生产场景中。

```bash
Create resource provider aggregates
[root@control01 ~]# openstack aggregate create --zone nova host_aggregate_1
+-------------------+----------------------------+
| Field             | Value                      |
+-------------------+----------------------------+
| availability_zone | nova                       |
| created_at        | 2018-12-08T05:49:55.051678 |
| deleted           | False                      |
| deleted_at        | None                       |
| id                | 1                          |
| name              | host_aggregate_1           |
| updated_at        | None                       |
+-------------------+----------------------------+

[root@control01 ~]# openstack aggregate add host host_aggregate_1 control01
+-------------------+---------------------------------+
| Field             | Value                           |
+-------------------+---------------------------------+
| availability_zone | nova                            |
| created_at        | 2018-12-08T05:49:55.000000      |
| deleted           | False                           |
| deleted_at        | None                            |
| hosts             | [u'control01']                  |
| id                | 1                               |
| metadata          | {u'availability_zone': u'nova'} |
| name              | host_aggregate_1                |
| updated_at        | None                            |
+-------------------+---------------------------------+

[root@control01 ~]# openstack aggregate show host_aggregate_1
+-------------------+----------------------------+
| Field             | Value                      |
+-------------------+----------------------------+
| availability_zone | nova                       |
| created_at        | 2018-12-08T05:49:55.000000 |
| deleted           | False                      |
| deleted_at        | None                       |
| hosts             | [u'control01']             |
| id                | 1                          |
| name              | host_aggregate_1           |
| properties        |                            |
| updated_at        | None                       |
+-------------------+----------------------------+

[root@control01 ~]# openstack resource provider list
+--------------------------------------+-----------+------------+--------------------------------------+----------------------+
| uuid                                 | name      | generation | root_provider_uuid                   | parent_provider_uuid |
+--------------------------------------+-----------+------------+--------------------------------------+----------------------+
| 5c5a578f-51b0-481c-b38c-7aaa3394e585 | control01 |         26 | 5c5a578f-51b0-481c-b38c-7aaa3394e585 | None                 |
+--------------------------------------+-----------+------------+--------------------------------------+----------------------+

[root@control01 ~]# openstack resource provider aggregate list 5c5a578f-51b0-481c-b38c-7aaa3394e585
+--------------------------------------+
| uuid                                 |
+--------------------------------------+
| 5eea7084-0207-44f0-bbeb-c759e8c766a1 |
+--------------------------------------+
```

List allocation cadidates filter by aggregates

```bash
# REQ
curl -i "http://172.18.22.222/placement/allocation_candidates?resources=VCPU:1,MEMORY_MB:512,DISK_GB:5&member_of=5eea7084-0207-44f0-bbeb-c759e8c766a1" \
-X GET \
-H 'Content-type: application/json' \
-H 'Accept: application/json' \
-H 'X-Auth-Project-Id: admin' \
-H 'OpenStack-API-Version: placement 1.21' \
-H 'X-Auth-Token:gAAAAABcC12qN3GdLvjYXSSUODi7Dg9jTHUfcnF7I_ljmcffZjs3ignipGLj6iqDvDJ1gXkzGIDW6rRRNcXary-wPfgsb3nCWRIEiAS8LrReI4SYL1KfQiGW7j92b6zTz7RoSEBXACQ9z7UUVfeJ06n8WqVMBaSob4BeFIuHiVKpYCJNv7LR6cI'

# RESP
{
    "provider_summaries": {
        "5c5a578f-51b0-481c-b38c-7aaa3394e585": {
            "traits": ["HW_CPU_X86_SSE2", "HW_CPU_X86_SSE", "HW_CPU_X86_MMX", "HW_CPU_X86_SVM"],
            "resources": {
                "VCPU": {
                    "used": 5,
                    "capacity": 512
                },
                "MEMORY_MB": {
                    "used": 3648,
                    "capacity": 60670
                },
                "DISK_GB": {
                    "used": 7,
                    "capacity": 49
                }
            }
        }
    },
    "allocation_requests": [{
        "allocations": {
            "5c5a578f-51b0-481c-b38c-7aaa3394e585": {
                "resources": {
                    "VCPU": 1,
                    "MEMORY_MB": 512,
                    "DISK_GB": 5
                }
            }
        }
    }]
}
```

2 Resource traits 功能

Resource traits 特征标签功能，用于标识 Resource Provider 的特征性质，每个 Resource Provider 有着其各自的缺省 traits，也支持为指定的 Resource Provider 自定义 traits。

Resource traits 是非常灵活的一种设计，类似于 “标签” 的作用，用户可以建立起 “标签云” 并决定为某一个 Resource Provider 贴上 “标签”，是一种资源归纳分类需求的辅助工具。

```bash
List traits
curl -i "http://172.18.22.222/placement/traits" \
-X GET \
-H 'Content-type: application/json' \
-H 'Accept: application/json' \
-H 'X-Auth-Project-Id: admin' \
-H 'OpenStack-API-Version: placement 1.21' \
-H 'X-Auth-Token:gAAAAABcC12qN3GdLvjYXSSUODi7Dg9jTHUfcnF7I_ljmcffZjs3ignipGLj6iqDvDJ1gXkzGIDW6rRRNcXary-wPfgsb3nCWRIEiAS8LrReI4SYL1KfQiGW7j92b6zTz7RoSEBXACQ9z7UUVfeJ06n8WqVMBaSob4BeFIuHiVKpYCJNv7LR6cI'

Create custom traits
curl -i "http://172.18.22.222/placement/traits/CUSTOM_FANGUIJU_HOST" \
-X PUT \
-H 'Content-type: application/json' \
-H 'Accept: application/json' \
-H 'X-Auth-Project-Id: admin' \
-H 'OpenStack-API-Version: placement 1.21' \
-H 'X-Auth-Token:gAAAAABcC12qN3GdLvjYXSSUODi7Dg9jTHUfcnF7I_ljmcffZjs3ignipGLj6iqDvDJ1gXkzGIDW6rRRNcXary-wPfgsb3nCWRIEiAS8LrReI4SYL1KfQiGW7j92b6zTz7RoSEBXACQ9z7UUVfeJ06n8WqVMBaSob4BeFIuHiVKpYCJNv7LR6cI'
NOTE：自定义 traits 建议以 CUSTOM_ 开头。

Update all traits for a specific resource provider
curl -i "http://172.18.22.222/placement/resource_providers/5c5a578f-51b0-481c-b38c-7aaa3394e585/traits" \
-X PUT \
-H 'Content-type: application/json' \
-H 'Accept: application/json' \
-H 'X-Auth-Project-Id: admin' \
-H 'OpenStack-API-Version: placement 1.21' \
-H 'X-Auth-Token:gAAAAABcC12qN3GdLvjYXSSUODi7Dg9jTHUfcnF7I_ljmcffZjs3ignipGLj6iqDvDJ1gXkzGIDW6rRRNcXary-wPfgsb3nCWRIEiAS8LrReI4SYL1KfQiGW7j92b6zTz7RoSEBXACQ9z7UUVfeJ06n8WqVMBaSob4BeFIuHiVKpYCJNv7LR6cI' \
-d '{"resource_provider_generation": 28, "traits": ["HW_CPU_X86_SSE2", "HW_CPU_X86_SSE", "HW_CPU_X86_MMX", "HW_CPU_X86_SVM", "CUSTOM_FANGUIJU_HOST"]}'

Return all traits associated with a specific resource provider
[root@control01 ~]# openstack resource provider trait list 5c5a578f-51b0-481c-b38c-7aaa3394e585
+----------------------+
| name                 |
+----------------------+
| HW_CPU_X86_SSE2      |
| HW_CPU_X86_SSE       |
| HW_CPU_X86_MMX       |
| HW_CPU_X86_SVM       |
| CUSTOM_FANGUIJU_HOST |
+----------------------+
```

List allocation cadidates filter by traits

```bash
# REQ
curl -i "http://172.18.22.222/placement/allocation_candidates?resources=VCPU:1,MEMORY_MB:512,DISK_GB:5&member_of=5eea7084-0207-44f0-bbeb-c759e8c766a1&required=CUSTOM_FANGUIJU_HOST" \
-X GET \
-H 'Content-type: application/json' \
-H 'Accept: application/json' \
-H 'X-Auth-Project-Id: admin' \
-H 'OpenStack-API-Version: placement 1.21' \
-H 'X-Auth-Token:gAAAAABcC12qN3GdLvjYXSSUODi7Dg9jTHUfcnF7I_ljmcffZjs3ignipGLj6iqDvDJ1gXkzGIDW6rRRNcXary-wPfgsb3nCWRIEiAS8LrReI4SYL1KfQiGW7j92b6zTz7RoSEBXACQ9z7UUVfeJ06n8WqVMBaSob4BeFIuHiVKpYCJNv7LR6cI'

# RESP
{
    "provider_summaries": {
        "5c5a578f-51b0-481c-b38c-7aaa3394e585": {
            "traits": ["HW_CPU_X86_SSE2", "HW_CPU_X86_SSE", "HW_CPU_X86_MMX", "HW_CPU_X86_SVM", "CUSTOM_FANGUIJU_HOST"],
            "resources": {
                "VCPU": {
                    "used": 5,
                    "capacity": 512
                },
                "MEMORY_MB": {
                    "used": 3648,
                    "capacity": 60670
                },
                "DISK_GB": {
                    "used": 7,
                    "capacity": 49
                }
            }
        }
    },
    "allocation_requests": [{
        "allocations": {
            "5c5a578f-51b0-481c-b38c-7aaa3394e585": {
                "resources": {
                    "VCPU": 1,
                    "MEMORY_MB": 512,
                    "DISK_GB": 5
                }
            }
        }
    }]
}
```

# 总结

该项目还比较年轻, 很多功能并未完全实现， Stein 版本第一次成为独立项目，目前虽然placement只替代了 nova-scheduler的CpuFilter、CoreFilter 和 DiskFilter几个常用的过滤器，期望未来最终能替代 nova-scheduler service并且能够便捷的使用、管理、监控整个 OpenStack 的系统资源。




