title: openstack token管理
categories: Openstack_dev
date: 2016-06-11 15:23:00
tags:
  - openstack token管理

---

# openstack token获得

对于openstack的api操作来说，大量的命令都依赖相关用户的token来完成，尤其对自动化测试来说，可以说拿到了用户的token就相当于取得了进入openstack这个大工厂大门的钥匙，有了这个钥匙，才能进入这个工厂大显身手。

要想拿到token, 必须知道用户的相关信息，其中用户名和密码是必须的。

    [root@localhost ~(keystone_admin)]# curl -i http://192.168.246.11:5000/v2.0/tokens -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "User-Agent: python-neutronclient" -d '{"auth": {"tenantName": "admin", "passwordCredentials": {"username": "admin", "password": "root"}}}'


    HTTP/1.1 200 OK
    Vary: X-Auth-Token
    Content-Type: application/json
    Content-Length: 4804
    Date: Wed, 08 Jun 2016 07:40:57 GMT
    
    {"access": {"token": {"issued_at": "2016-06-08T07:40:57.818783", "expires": "2016-06-08T08:40:57Z", "id": "b7eab8ebd4804299a488e64b726b010e", "tenant": {"description": "admin tenant", "enabled": true, "id": "0c5d59c1d4044a24ad1bbd3e3b35747c", "name": "admin"}}, "serviceCatalog": [{"endpoints": [{"adminURL": "http://192.168.246.11:8774/v2/0c5d59c1d4044a24ad1bbd3e3b35747c", "region": "RegionOne", "internalURL": "http://192.168.246.11:8774/v2/0c5d59c1d4044a24ad1bbd3e3b35747c", "id": "23c0cadd16fc45caaab80a5815e0c3f6", "publicURL": "http://192.168.246.11:8774/v2/0c5d59c1d4044a24ad1bbd3e3b35747c"}], "endpoints_links": [], "type": "compute", "name": "nova"}, {"endpoints": [{"adminURL": "http://192.168.246.11:9696/", "region": "RegionOne", "internalURL": "http://192.168.246.11:9696/", "id": "54ad0239c74e4dcd952817cd981ed73b", "publicURL": "http://192.168.246.11:9696/"}], "endpoints_links": [], "type": "network", "name": "neutron"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8776/v2/0c5d59c1d4044a24ad1bbd3e3b35747c", "region": "RegionOne", "internalURL": "http://192.168.246.11:8776/v2/0c5d59c1d4044a24ad1bbd3e3b35747c", "id": "2678892f75974502a73755a61993c491", "publicURL": "http://192.168.246.11:8776/v2/0c5d59c1d4044a24ad1bbd3e3b35747c"}], "endpoints_links": [], "type": "volumev2", "name": "cinderv2"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8774/v3", "region": "RegionOne", "internalURL": "http://192.168.246.11:8774/v3", "id": "58f7edd271b64706a11ad16ce3add588", "publicURL": "http://192.168.246.11:8774/v3"}], "endpoints_links": [], "type": "computev3", "name": "novav3"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8080", "region": "RegionOne", "internalURL": "http://192.168.246.11:8080", "id": "217a06dc22f44bf7a313aa8d7970593f", "publicURL": "http://192.168.246.11:8080"}], "endpoints_links": [], "type": "s3", "name": "swift_s3"}, {"endpoints": [{"adminURL": "http://192.168.246.11:9292", "region": "RegionOne", "internalURL": "http://192.168.246.11:9292", "id": "75da03c5ec854d7d9725bfd0773997e9", "publicURL": "http://192.168.246.11:9292"}], "endpoints_links": [], "type": "image", "name": "glance"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8777", "region": "RegionOne", "internalURL": "http://192.168.246.11:8777", "id": "378d0e81679e461db1d91f9d69b4e649", "publicURL": "http://192.168.246.11:8777"}], "endpoints_links": [], "type": "metering", "name": "ceilometer"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8000/v1/", "region": "RegionOne", "internalURL": "http://192.168.246.11:8000/v1/", "id": "c544bb131cab4e5da9d06567c4a6f1b2", "publicURL": "http://192.168.246.11:8000/v1/"}], "endpoints_links": [], "type": "cloudformation", "name": "heat-cfn"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8776/v1/0c5d59c1d4044a24ad1bbd3e3b35747c", "region": "RegionOne", "internalURL": "http://192.168.246.11:8776/v1/0c5d59c1d4044a24ad1bbd3e3b35747c", "id": "2538162ef1d74fb9a06776ff882d211e", "publicURL": "http://192.168.246.11:8776/v1/0c5d59c1d4044a24ad1bbd3e3b35747c"}], "endpoints_links": [], "type": "volume", "name": "cinder"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8773/services/Admin", "region": "RegionOne", "internalURL": "http://192.168.246.11:8773/services/Cloud", "id": "3e7685ca54c54376bf117cb3fdda81da", "publicURL": "http://192.168.246.11:8773/services/Cloud"}], "endpoints_links": [], "type": "ec2", "name": "nova_ec2"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8004/v1/0c5d59c1d4044a24ad1bbd3e3b35747c", "region": "RegionOne", "internalURL": "http://192.168.246.11:8004/v1/0c5d59c1d4044a24ad1bbd3e3b35747c", "id": "404fc17696fa4e9e824efbb159613fe8", "publicURL": "http://192.168.246.11:8004/v1/0c5d59c1d4044a24ad1bbd3e3b35747c"}], "endpoints_links": [], "type": "orchestration", "name": "heat"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8080/", "region": "RegionOne", "internalURL": "http://192.168.246.11:8080/v1/AUTH_0c5d59c1d4044a24ad1bbd3e3b35747c", "id": "0391f065d3bf4a29bb855ca6f900586b", "publicURL": "http://192.168.246.11:8080/v1/AUTH_0c5d59c1d4044a24ad1bbd3e3b35747c"}], "endpoints_links": [], "type": "object-store", "name": "swift"}, {"endpoints": [{"adminURL": "http://192.168.246.11:35357/v2.0", "region": "RegionOne", "internalURL": "http://192.168.246.11:5000/v2.0", "id": "1d1a8b082e8042a197f85cd287b768c2", "publicURL": "http://192.168.246.11:5000/v2.0"}], "endpoints_links": [], "type": "identity", "name": "keystone"}], "user": {"username": "admin", "roles_links": [], "id": "df2a12db5e984a0ab476b31cedfea441", "roles": [{"name": "_member_"}, {"name": "heat_stack_owner"}, {"name": "admin"}], "name": "admin"}, "metadata": {"is_admin": 0, "roles": ["9fe2ff9ee4384b1894a90878d3e92bab", "4dde4b01171747eeb58d46b9fcf9355f", "d96615f068c948a78bfa8297da7f64fa"]}}}


其中['token']['id']就是我们得到的用户token。




# 编程实现openstack token获得

编程实现取得用户token也极为简单，代码如下：

```
[root@localhost ~(keystone_admin)]# cat a.py 
import httplib2
import json
http_obj =httplib2.Http()
headers = {}
body = {
    "auth": {
            "passwordCredentials":{
                "username":'admin',
                "password":'root',
            },
            "tenantName":'admin',
        },
    }
req_url ="http://localhost:5000/v2.0/tokens"
method ="POST"
headers['Content-Type']= 'application/json'
headers['Accept']= 'application/json'
resp, token =http_obj.request(req_url, method, headers=headers,body=json.dumps(body))
print resp
print token
```


    [root@localhost ~(keystone_admin)]# python a.py 
    {'date': 'Wed, 08 Jun 2016 07:41:49 GMT', 'vary': 'X-Auth-Token', 'content-length': '4804', 'status': '200', 'content-type': 'application/json'}
    {"access": {"token": {"issued_at": "2016-06-08T07:41:49.197591", "expires": "2016-06-08T08:41:49Z", "id": "0ec6a859daba4b6bb4b106130bdccc91", "tenant": {"description": "admin tenant", "enabled": true, "id": "0c5d59c1d4044a24ad1bbd3e3b35747c", "name": "admin"}}, "serviceCatalog": [{"endpoints": [{"adminURL": "http://192.168.246.11:8774/v2/0c5d59c1d4044a24ad1bbd3e3b35747c", "region": "RegionOne", "internalURL": "http://192.168.246.11:8774/v2/0c5d59c1d4044a24ad1bbd3e3b35747c", "id": "23c0cadd16fc45caaab80a5815e0c3f6", "publicURL": "http://192.168.246.11:8774/v2/0c5d59c1d4044a24ad1bbd3e3b35747c"}], "endpoints_links": [], "type": "compute", "name": "nova"}, {"endpoints": [{"adminURL": "http://192.168.246.11:9696/", "region": "RegionOne", "internalURL": "http://192.168.246.11:9696/", "id": "54ad0239c74e4dcd952817cd981ed73b", "publicURL": "http://192.168.246.11:9696/"}], "endpoints_links": [], "type": "network", "name": "neutron"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8776/v2/0c5d59c1d4044a24ad1bbd3e3b35747c", "region": "RegionOne", "internalURL": "http://192.168.246.11:8776/v2/0c5d59c1d4044a24ad1bbd3e3b35747c", "id": "2678892f75974502a73755a61993c491", "publicURL": "http://192.168.246.11:8776/v2/0c5d59c1d4044a24ad1bbd3e3b35747c"}], "endpoints_links": [], "type": "volumev2", "name": "cinderv2"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8774/v3", "region": "RegionOne", "internalURL": "http://192.168.246.11:8774/v3", "id": "58f7edd271b64706a11ad16ce3add588", "publicURL": "http://192.168.246.11:8774/v3"}], "endpoints_links": [], "type": "computev3", "name": "novav3"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8080", "region": "RegionOne", "internalURL": "http://192.168.246.11:8080", "id": "217a06dc22f44bf7a313aa8d7970593f", "publicURL": "http://192.168.246.11:8080"}], "endpoints_links": [], "type": "s3", "name": "swift_s3"}, {"endpoints": [{"adminURL": "http://192.168.246.11:9292", "region": "RegionOne", "internalURL": "http://192.168.246.11:9292", "id": "75da03c5ec854d7d9725bfd0773997e9", "publicURL": "http://192.168.246.11:9292"}], "endpoints_links": [], "type": "image", "name": "glance"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8777", "region": "RegionOne", "internalURL": "http://192.168.246.11:8777", "id": "378d0e81679e461db1d91f9d69b4e649", "publicURL": "http://192.168.246.11:8777"}], "endpoints_links": [], "type": "metering", "name": "ceilometer"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8000/v1/", "region": "RegionOne", "internalURL": "http://192.168.246.11:8000/v1/", "id": "c544bb131cab4e5da9d06567c4a6f1b2", "publicURL": "http://192.168.246.11:8000/v1/"}], "endpoints_links": [], "type": "cloudformation", "name": "heat-cfn"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8776/v1/0c5d59c1d4044a24ad1bbd3e3b35747c", "region": "RegionOne", "internalURL": "http://192.168.246.11:8776/v1/0c5d59c1d4044a24ad1bbd3e3b35747c", "id": "2538162ef1d74fb9a06776ff882d211e", "publicURL": "http://192.168.246.11:8776/v1/0c5d59c1d4044a24ad1bbd3e3b35747c"}], "endpoints_links": [], "type": "volume", "name": "cinder"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8773/services/Admin", "region": "RegionOne", "internalURL": "http://192.168.246.11:8773/services/Cloud", "id": "3e7685ca54c54376bf117cb3fdda81da", "publicURL": "http://192.168.246.11:8773/services/Cloud"}], "endpoints_links": [], "type": "ec2", "name": "nova_ec2"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8004/v1/0c5d59c1d4044a24ad1bbd3e3b35747c", "region": "RegionOne", "internalURL": "http://192.168.246.11:8004/v1/0c5d59c1d4044a24ad1bbd3e3b35747c", "id": "404fc17696fa4e9e824efbb159613fe8", "publicURL": "http://192.168.246.11:8004/v1/0c5d59c1d4044a24ad1bbd3e3b35747c"}], "endpoints_links": [], "type": "orchestration", "name": "heat"}, {"endpoints": [{"adminURL": "http://192.168.246.11:8080/", "region": "RegionOne", "internalURL": "http://192.168.246.11:8080/v1/AUTH_0c5d59c1d4044a24ad1bbd3e3b35747c", "id": "0391f065d3bf4a29bb855ca6f900586b", "publicURL": "http://192.168.246.11:8080/v1/AUTH_0c5d59c1d4044a24ad1bbd3e3b35747c"}], "endpoints_links": [], "type": "object-store", "name": "swift"}, {"endpoints": [{"adminURL": "http://192.168.246.11:35357/v2.0", "region": "RegionOne", "internalURL": "http://192.168.246.11:5000/v2.0", "id": "1d1a8b082e8042a197f85cd287b768c2", "publicURL": "http://192.168.246.11:5000/v2.0"}], "endpoints_links": [], "type": "identity", "name": "keystone"}], "user": {"username": "admin", "roles_links": [], "id": "df2a12db5e984a0ab476b31cedfea441", "roles": [{"name": "_member_"}, {"name": "heat_stack_owner"}, {"name": "admin"}], "name": "admin"}, "metadata": {"is_admin": 0, "roles": ["9fe2ff9ee4384b1894a90878d3e92bab", "4dde4b01171747eeb58d46b9fcf9355f", "d96615f068c948a78bfa8297da7f64fa"]}}}





# 問題：

因为每个处理都会向VIM发送获取token的请求，VIM收到请求后都会创建一个新的token，所以会造成token数太多。




# 现状：

token的生成和使用：

                +-------+
                | start |
                +---+---+
                    |
                    |
           +--------v------------+          #VNFM根据tenant/user/password，向VIM发送获取token_id的请求。
           | get token from VIM  |          #VIM收到请求后，会创建一个新的token，返回给VNFM。
           +--------+------------+
                    |
                    |
    +---------------v-------------------+
    | send request to VIM using token   |
    +---------------+-------------------+
                    |
                    |
               +----v---+
               |  end   |
               +--------+




# 改进方案

## 二次开发的项目中数据库中添加表(token)：								

| 列名  | type                    | comment                                    |
|-------|:------------------------|--------------------------------------------|
|tenant |varchar(64) NOT NULL     |和user字段一起使用来查询token               |
|user   |varchar(255) NOT NULL    |和token字段一起使用来查询token              |
|passwd |varchar(128) DEFAULT NULL|和tenant,user字段一起使用，生成一个新的token|
|token  |varchar(64) NOT NULL     |token ID                                    |
|expires|date                     |token的失效时间（UTC时间）                  |


## 二次开发的项目token管理流程

                       +--------+
                       | start  |
                       +---+----+
                           |
                           |
          +----------------v------------------+
          | change current time to UTC time   |
          +----------------+------------------+
                           |
                           |
          +----------------v----------------------+
          |                                       |
          | delete expires < current time's date  |
          |                                       |
          +----------------+----------------------+
                           |
                           |
         +-----------------v---------------------------+
         |                                             |
         |  get  expires < current time + 600s's date  |
         |                                             |
         +-----------------+---------------------------+
                           |
                           |
                           <-------------------------------------+
                           |                                     |
                           |                                     |
              +------------v---------+                           |
              |   deal with a data   |                           |
              +------------+---------+                           |
                           |                                     |
                           |                                     |
    +----------------------v-------------------+                 |
    |  get a new token and insert to database  |                 |
    +----------------------+-------------------+                 |
                           |                                     |
                           |                                     |
          +----------------v------------------+          N       |
          |  deal with the data process end?  +------------------+
          +-----------------------------------+
                           |
                           |Y
                           |
                    +------v------+
                    |  sleep 60s  |
                    +-------------+




## 二次开发的项目token使用流程

使用上述方案后，不会每一个请求都需要生成一个新的token，VIM上keystone默认配置的token有效时间是一小时，在N小时之内，二次开发的项目处理相同tenant和user的请求，VIM只需要创建N+1个token，从而大大降低了token数。

                               +----------+
                               |  start   |
                               +----+-----+
                                    |
                                    |
             +----------------------v-----------------------------+
             | look for token according tenant/user from database |      # may be more than a data, get expires value max data
             +----------------------+-----------------------------+
                                    |
                                    |
                                +---v-----+
                                | exist?  +-------------------------------+
                                +---+-----+                               |
                                    |                                     |
                                    |Y                                    |
                                    |                                     |
                      +-------------v------------------+                  |
                      |  check the token is available  |                  |
                      +-------------+------------------+                 N|
                                    |                                     |
                                    |                                     |
          Y                  +------v------+                              |
    +------------------------+  available  |                              |
    |                        +------+------+                              |
    |                               |                                     |
    |                               <-------------------------------------+
    |                               |
    |                              N|
    |                               |
    |           +-------------------v---------------------+
    |           | get a new token and insert to database  |
    |           +-------------------+---------------------+
    |                               |
    |                               |
    +------------------------------->
                                    |
                                    |
                             +------v------------+
                             |  use the token    |
                             +------+------------+
                                    |
                                    |
                                +---v----+
                                |  end   |
                                +--------+

