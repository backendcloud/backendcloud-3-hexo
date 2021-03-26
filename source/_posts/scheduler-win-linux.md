title: 支持windows虚拟机和linux虚拟机分区调度
date: 2018-01-23 14:40:11
categories:
- Openstack_op
tags:
- nova-scheduler
---

有一个新装的环境测试报windows，linux分区调度不支持

测试前提条件：
* Openstack Pike
* image文件配置了metadata。openstack image set --property os_type=windows image_id
* 主机组也配置了metadata。nova aggregate-set-metadata aggregate_id os_type=windows

用该image生成的vm，没有被nova-scheduler调度到windows主机组。

<!-- more -->

分析原因，首先想到的是nova的配置文件filter选项有没有配置对应的filter。

    # vim /etc/nova/nova.conf

scheduler_default_filters果然没有配置AggregateImagePropertiesIsolation

AggregateImagePropertiesIsolation的作用：Checks a host in an aggregate that metadata key/value match with image properties.

将AggregateImagePropertiesIsolation加上，重启openstack-nova-scheduler.service但生成的vm仍旧不能被调度到windows主机组。

查看日志文件/var/log/nova/nova-scheduler.log：发现有这句话：Filter AggregateImagePropertiesIsolation returned 5 host(s) get_filtered_objects /usr/lib/python2.7/site-packages/nova/filters.py:104

说明filter：AggregateImagePropertiesIsolation生效了，但是却不能识别出windows主机组，返回了5 host(s)，该环境一共就5个计算节点。

查看代码逻辑：

    # vim /lib/python2.7/site-packages/nova/scheduler/filters/aggregate_image_properties_isolation.py

```python
class AggregateImagePropertiesIsolation(filters.BaseHostFilter):
    """AggregateImagePropertiesIsolation works with image properties."""

    # Aggregate data and instance type does not change within a request
    run_filter_once_per_request = True

    def host_passes(self, host_state, spec_obj):
        """Checks a host in an aggregate that metadata key/value match
        with image properties.
        """
        cfg_namespace = (CONF.filter_scheduler.
            aggregate_image_properties_isolation_namespace)
        cfg_separator = (CONF.filter_scheduler.
            aggregate_image_properties_isolation_separator)

        image_props = spec_obj.image.properties if spec_obj.image else {}
        LOG.debug("##### image_props: %s #####" % image_props)
        metadata = utils.aggregate_metadata_get_by_host(host_state)

        for key, options in metadata.items():
            if (cfg_namespace and
                    not key.startswith(cfg_namespace + cfg_separator)):
                continue
            prop = None
            try:
                prop = image_props.get(key)
            except AttributeError:
                LOG.warning(_LW("Host '%(host)s' has a metadata key '%(key)s' "
                                "that is not present in the image metadata."),
                            {"host": host_state.host, "key": key})
                continue

            # NOTE(sbauza): Aggregate metadata is only strings, we need to
            # stringify the property to match with the option
            # TODO(sbauza): Fix that very ugly pattern matching
            if prop and str(prop) not in options:
                LOG.debug("%(host_state)s fails image aggregate properties "
                            "requirements. Property %(prop)s does not "
                            "match %(options)s.",
                          {'host_state': host_state,
                           'prop': prop,
                           'options': options})
                return False
        return True

```

通过代码得知，只有一种情况下才会返回False，其他情况都是返回True。False就是计算节点被过滤掉，True是没被过滤掉。现在的实际情况是没有被过滤，全部计算节点返回的是True。期望的是只有metadata被设置为windows的主机返回True，其他应该都是False。现在来分析原因。

看代码，返回False只有一种情况：主机的某一个metadata和image的metadata不匹配。返回True，除了主机的所有metadata和image的metadata都匹配会返回；还有一种情况在代码的continue语句中，即在except中，该异常是AttributeError。就是说主机的所有metadata只要是或者和image的metadata都匹配或者不存在于image的metadata中，就会执行完所有的while循环，返回True。

检查不期望被filter通过的主机的metadata，nova aggregate-show aggregate_id 发现其他主机组没有配置os_type。用命令nova aggregate-set-metadata aggregate_id给其他主机组添加属性：os_type=linux

再用该image生成vm，可以被正确调度到windows主机组。
