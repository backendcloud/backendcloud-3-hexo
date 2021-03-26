title: 将快速疏散功能加入VM HA程序中
date: 2017-06-10 03:27:36
categories: Openstack_dev
tags:
- VM HA
- Nova
---

之前有篇文章介绍nova新增的快速疏散接口的说明
https://www.backendcloud.cn/2017/06/08/force-down/

现在在开发的VM HA程序中加入快速疏散功能

1. 修改配置文件，增加quick_evacuate_level选项
   level 1: (fastest) 不关机，只force down nova-compute-service
   level 2: (faster)(default) 先关机，关机介绍之后再force down nova-compute-service
   level 3: (disable quick_evacuate)
2. change python-novaclient>=6.0.0 to support force-service-down
3. 修改疏散流程处理逻辑，增加快速疏散



原来疏散的流程是发现故障计算节点后，先关机，然后等待故障节点因为心跳丢失而导致nova service state down，再进行疏散
现在改成：
level 1：(fastest) 不关机，只force down nova-compute-service
level 2：(faster)(default) 先关机，关机介绍之后再force down nova-compute-service
level 3: (disable quick_evacuate)什么也不做，和原来的流程一样


下面的代码`def _ipmi_handle`，变更前实现的将故障节点执行关机操作，变更后，在level 1的时候，先进行force down nova service state并跳过关机流程。
```python
    def _ipmi_handle(self, node):
        # cmd = 'ssh %s systemctl stop openstack-nova-compute' % node
        # return os.system(cmd)
        ret = 1
    ################  add  ################
        if CONF.quick_evacuate_level == 1:
            try:
                self.nova_client.services.force_down(host=node,
                                                     binary='nova-compute',
                                                     force_down=True,
                                                    )
                service = self.nova_client.services.list(
                    host=node,
                    binary='nova-compute')
                if service:
                    if service[0].state == 'down':
                        return ret
                raise
            except Exception as e:
                content = node + ' nova-compute service force down failed!'
                title = 'force down failed'
                self.db.add_or_update_guardian_log(**{'title': title,
                                                      'detail': content,
                                                      'level': 'ERROR'})
                LOG.error(content)
                LOG.error(e)
    ################  add  ################
        LOG.info('IPMI enabled,need to check power status of %s' % node)
        ipmi_info = self.db.get_ipmiInfo(node)
        if ipmi_info is None:
            LOG.warning(
                'can not find ipmi info for %s, will ignore evacuate...'
                % node)
            return 0
        LOG.debug('get ipmi info (ip %s user %s, password %s)' % (
            ipmi_info.ip, ipmi_info.username, ipmi_info.password))
        ipmi_util = IPMIUtil(ipmi_info.ip, ipmi_info.username,
                             ipmi_info.password)
        power_status = ipmi_util.get_power_status()
        LOG.info('power status of %s is %s' % (node, power_status))

        if 'off' != power_status:
            LOG.info('power status of %s is not off,power off it...' % node)
            ipmi_util.do_power_off()
            for i in range(1, CONF.ipmi_check_max_count + 1):
                power_status = ipmi_util.get_power_status()
                if 'off' != power_status:
                    LOG.info(
                        'power status of %s is not off,wait for %s seconds...'
                        % (node, CONF.ipmi_check_interval))
                    time.sleep(CONF.ipmi_check_interval)
                else:
                    break
            power_status = ipmi_util.get_power_status()
            if 'off' != power_status:
                LOG.info(
                    'after %s check,can not confirm power status of '
                    '%s is off,will ignore evacuate...'
                    % (node,
                       CONF.ipmi_check_max_count*CONF.ipmi_check_interval))
                ret = 0
        return ret
```



下面的代码在level 2时，不执行上面代码的跳过关机流程，在检查nova service state前force down实现快速疏散（不去检查心跳的流程）。level 3就是什么也不干，和原来一样。
```python
            ################  add  ################
            if CONF.quick_evacuate_level == 2:
                try:
                    self.nova_client.services.force_down(host=node,
                                                         binary='nova-compute',
                                                         force_down=True,
                                                        )
                    service = self.nova_client.services.list(
                        host=node,
                        binary='nova-compute')
                    if service:
                        if service[0].state != 'down':
                            raise
                except Exception as e:
                    content = node + ' nova-compute service force down failed!'
                    title = 'force down failed'
                    self.db.add_or_update_guardian_log(**{'title': title,
                                                          'detail': content,
                                                          'level': 'ERROR'})
                    LOG.error(content)
                    LOG.error(e)
            ################  add  ################

            if self._wait_for_service_to_down(node):
                for server in servers:
                    can_evacuate = self._evacuate_predict(server)
                    if can_evacuate:
                        try:
                            # just evacuate, let nova scheduler
                            # choose one host if not in drbd env
                            respone = server.evacuate(
                                host=evacuated_to,
                                on_shared_storage=CONF.on_share_storage)
                            LOG.info(
                                'evacuate vm info:[id:%s,name:%s,status:%s],'
                                'reponse is %s'
                                % (server.id, server.name, server.status,
                                    respone))
                            content = '虚拟机被疏散:虚拟机ID: %s' % server.id
                            self.send_snmp(content=content)
                        except Exception as e:
                            content = ('evacuate vm %s failed' % server.id)
                            title = ('疏散虚拟机%s失败' % server.id)
                            self.db.add_or_update_guardian_log(
                                **{'title': title,
                                   'detail': content,
                                   'level': 'ERROR'})
                            content = '虚拟机疏散调用API失败:虚拟机ID: %s' % server.id
                            self.send_snmp(content=content)
                            LOG.error(content)
                            LOG.error(e)

                        # add to db
                        try:
                            self.db.add_evacuate_history(
                                instance_id=server.id,
                                instance_name=server.name,
                                host=getattr(server, 'OS-EXT-SRV-ATTR:host'))

                            content = (
                                'add_evacuate_history '
                                '[instance_id:%s,instance_name:%s,host:%s]'
                                % (server.id, server.name,
                                   getattr(server, 'OS-EXT-SRV-ATTR:host')))
                            LOG.info(content)
                            title = ('增加疏散记录%s' % server.name)
                            self.db.add_or_update_guardian_log(
                                **{'title': title,
                                   'detail': content,
                                   'level': 'INFO'})
                        except Exception as e:
                            content = (
                                'add_evacuate_history for vm %s failed'
                                % server.id)
                            title = ('增加疏散记录%s失败' % server.id)
                            self.db.add_or_update_guardian_log(
                                **{'title': title,
                                   'detail': content,
                                   'level': 'ERROR'})
                            LOG.error(content)
                            LOG.error(e)
                    else:
                        content = '虚拟机没有被疏散:虚拟机ID: %s' % server.id
                        self.send_snmp(content=content)
                        LOG.info('server %s can not evacuate' % server.id)

                # disable this service
                try:
                    self.nova_client.services.disable(node, 'nova-compute')
                except Exception as e:
                    content = (
                        'failed to disable compute service on node %s' % node)
                    title = ('disable节点%s服务失败' % node)
                    self.db.add_or_update_guardian_log(
                        **{'title': title,
                           'detail': content,
                           'level': 'ERROR'})
                    LOG.error(content)
                    LOG.error(e)
                    raise

                heart_beat = self.db.get_heartbeat_by_name(node)
                heart_beat.has_evacuated = 1
                heart_beat.status = 'done'
                heart_beat.save(self.db.session)
                LOG.info('node %s update with [has_evacuated: 1]' % node)
```
