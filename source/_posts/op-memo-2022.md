---
title: Openstack运维常见问题记录(5)
readmore: false
date: 2022-09-26 18:24:36
categories: Openstack_op
tags:
---


# windows2012镜像使用virtio-SCSI磁盘驱动蓝屏问题

蓝屏是因为当时的镜像打的驱动是virtio的驱动，而磁盘设备所需的是scsi驱动，所以当时的镜像都会蓝屏，后来重制的镜像，磁盘驱动打的是scsi驱动，镜像上传时再加2个参数：hw_disk_bus=scsi，hw_scsi_model=virtio-scsi，后测试没有再蓝屏

制作镜像加载scsi驱动时注意选择磁盘驱动类型，要选择scsi模式，不要选择virtio模式


# nova总是调度到固定的一些计算节点中，而并非均分到所有计算节点中

检查nova filter和weight


# 虚拟机高可用发生虚拟机疏散，正常的节点也会疏散

**现象：**

XXXX-HOST-YYYY34 节点故障，高可用组件应该疏散 XXXX-HOST-YYYY34 节点，实际不仅 XXXX-HOST-YYYY34 节点被疏散，XXXX-HOST-YYYY340 341 342~349等节点都被疏散，340~349都是正常的节点，并非故障节点。

**原因分析：**

应该是字符匹配，只要匹配到含有XXXX-HOST-YYYY34的节点都会被疏散。

**分析代码：**

高可用组件，监控到节点故障后，会调用nova api去执行nova的疏散命令。

相关代码：

python-novaclient\novaclient\shell.py

```python
...
@utils.arg(
    '--strict',
    dest='strict',
    action='store_true',
    default=False,
    help=_('Evacuate host with exact hypervisor hostname match'))
def do_host_evacuate(cs, args):
    """Evacuate all instances from failed host."""
    response = []
    for server in _hyper_servers(cs, args.host, args.strict):
        response.append(_server_evacuate(cs, server, args))
    utils.print_list(response, [
        "Server UUID",
        "Evacuate Accepted",
        "Error Message",
    ])
```

> 从上面的代码看出 strict 参数默认是false

```python
def _hyper_servers(cs, host, strict):
    hypervisors = cs.hypervisors.search(host, servers=True)
    for hyper in hypervisors:
        if strict and hyper.hypervisor_hostname != host:
            continue
        if hasattr(hyper, 'servers'):
            for server in hyper.servers:
                yield server
        if strict:
            break
    else:
        if strict:
            msg = (_("No hypervisor matching '%s' could be found.") %
                   host)
            raise exceptions.NotFound(404, msg)
```

> 从上面的代码看出，strict 参数为true时候是完全匹配，否者是是否包含的匹配。

```python
    def search(self, hypervisor_match, servers=False, detailed=False):
        """
        Get a list of matching hypervisors.

        :param hypervisor_match: The hypervisor host name or a portion of it.
            The hypervisor hosts are selected with the host name matching
            this pattern.
        :param servers: If True, server information is also retrieved.
        :param detailed: If True, detailed hypervisor information is returned.
            This requires API version 2.53 or greater.
        """
        # Starting with microversion 2.53, the /servers and /search routes are
        # deprecated and we get the same results using GET /os-hypervisors
        # using query parameters for the hostname pattern and servers.
        if self.api_version >= api_versions.APIVersion('2.53'):
            url = ('/os-hypervisors%s?hypervisor_hostname_pattern=%s' %
                   ('/detail' if detailed else '',
                    parse.quote(hypervisor_match, safe='')))
            if servers:
                url += '&with_servers=True'
        else:
            if detailed:
                raise exceptions.UnsupportedVersion(
                    _('Parameter "detailed" requires API version 2.53 or '
                      'greater.'))
            target = 'servers' if servers else 'search'
            url = ('/os-hypervisors/%s/%s' %
                   (parse.quote(hypervisor_match, safe=''), target))
        return self._list(url, 'hypervisors')
```

novaclient要调用 nova rest api 查询匹配到的hypervisor。

```bash
 GET
/os-hypervisors/detail
List Hypervisors Details

 GET
/os-hypervisors/statistics
Show Hypervisor Statistics (DEPRECATED)

 GET
/os-hypervisors/{hypervisor_id}
Show Hypervisor Details

 GET
/os-hypervisors/{hypervisor_id}/uptime
Show Hypervisor Uptime (DEPRECATED)

 GET
/os-hypervisors/{hypervisor_hostname_pattern}/search
Search Hypervisor (DEPRECATED)

 GET
/os-hypervisors/{hypervisor_hostname_pattern}/servers
List Hypervisor Servers (DEPRECATED)
```

虚拟机高可用组件调用的novaclient，没有加strict参数，导致只要主机名包含有XXXX-HOST-YYYY34的节点都会被疏散。

**对策：**

1. 规范命名规则，一千台计算节点以内用 XXXX-HOST-YYYY034，数字编号统一为3位。
2. 修改高可用组件代码，调用novaclient代码时候加上strict参数。



