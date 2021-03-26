title: Openstack Masakari task流程源码分析
date: 2020-01-09 09:18:53
categories:
- Openstack_dev
tags:
- Openstack
- Masakari
- VM HA
- 源码分析

---

Masakari一词来源于日语板斧，该项目是Openstack社区的一个用来实现VM HA的开源项目。目前masakari支持下面3种故障恢复：
1. provisioning process down
2. VM process down
3. nova-compute host failure

本文将对以上三种故障处理流程的代码做详细分析。

**masakari架构图：**
![pic](/images/masakari-task-code/1.svg)

# 进程故障处理流程

所谓的进程就是计算节点的关键进程和服务，如`libvirt`, `nova-compute`, `masakari-instancemonitor`, `masakari-hostmonitor`, `sshd`, 一旦检测到进程异常，执行下面的流程。
该流程分为2步
第一步，disable计算节点的nova服务，让新创建的vm不会被调度到该节点。
第二步，监测第一步的disable动作是否被有效执行



`masakari\engine\drivers\taskflow\process_failure.py`
```python
class DisableComputeNodeTask(base.MasakariTask):
    def __init__(self, context, novaclient, **kwargs):
        kwargs['requires'] = ["process_name", "host_name"]
        super(DisableComputeNodeTask, self).__init__(context,
                                                     novaclient,
                                                     **kwargs)

    def execute(self, process_name, host_name):
        msg = "Disabling compute service on host: '%s'" % host_name
        self.update_details(msg)

        if not self.novaclient.is_service_down(self.context, host_name,
                                               process_name):
            # disable compute node on given host
            self.novaclient.enable_disable_service(self.context, host_name)
            msg = "Disabled compute service on host: '%s'" % host_name
            self.update_details(msg, 1.0)
        else:
            msg = ("Skipping recovery for process %(process_name)s as it is "
                   "already disabled") % {'process_name': process_name}
            LOG.info(msg)
            self.update_details(msg, 1.0)
```

给出`Disabling compute service on host <hostname>`消息后，判断host的计算服务是否down了，若没有执行`enable_disable_service`方法，执行完成该`diasble`动作后，给出`Disabled compute service on host <hostname>`消息；若已经down了，只给出`Skipping recovery for process %(process_name)s as it is already disabled`。

上面的DisableComputeNodeTask流程用了2个调用nova的方法`is_service_down`和`enable_disable_service`。

<!-- more -->


`masakari\compute\nova.py`
```python
    @translate_nova_exception
    def is_service_down(self, context, host_name, binary):
        """Check whether service is up or down on given host."""
        nova = novaclient(context)
        service = nova.services.list(host=host_name, binary=binary)[0]
        return service.status == 'disabled'
```
方法`is_service_down`调用novaclient模块的`services.list`查询该`host_name`的`service`信息，返回`service.status`是否为`disabled`。


`masakari\compute\nova.py`
```python
    def enable_disable_service(self, context, host_name, enable=False,
                               reason=None):
        """Enable or disable the service specified by nova service id."""
        nova = novaclient(context)
        service = nova.services.list(host=host_name, binary='nova-compute')[0]

        if not enable:
            LOG.info('Disable nova-compute on %s', host_name)
            if reason:
                nova.services.disable_log_reason(service.id, reason)
            else:
                nova.services.disable(service.id)
        else:
            LOG.info('Enable nova-compute on %s', host_name)
            nova.services.enable(service.id)
```
方法`enable_disable_service`调用novaclient模块的`services.list`查询该`host_name`的`service`信息，若`service.status`是`enable`则调用novaclient模块的`services.disable`disable服务（若有disable的原因，则加上reason参数）；若是`disable`则调用novaclient模块的`services.enable`enable服务。



`masakari\engine\drivers\taskflow\process_failure.py`
```python
class ConfirmComputeNodeDisabledTask(base.MasakariTask):
    def __init__(self, context, novaclient, **kwargs):
        kwargs['requires'] = ["process_name", "host_name"]
        super(ConfirmComputeNodeDisabledTask, self).__init__(context,
                                                             novaclient,
                                                             **kwargs)

    def execute(self, process_name, host_name):
        def _wait_for_disable():
            service_disabled = self.novaclient.is_service_down(
                self.context, host_name, process_name)
            if service_disabled:
                raise loopingcall.LoopingCallDone()

        periodic_call = loopingcall.FixedIntervalLoopingCall(
            _wait_for_disable)
        try:
            msg = "Confirming compute service is disabled on host: '%s'" % (
                host_name)
            self.update_details(msg)

            # add a timeout to the periodic call.
            periodic_call.start(interval=CONF.verify_interval)
            etimeout.with_timeout(
                CONF.wait_period_after_service_update,
                periodic_call.wait)

            msg = "Confirmed compute service is disabled on host: '%s'" % (
                host_name)
            self.update_details(msg, 1.0)
        except etimeout.Timeout:
            msg = "Failed to disable service %(process_name)s" % {
                'process_name': process_name
            }
            self.update_details(msg, 1.0)
            raise exception.ProcessRecoveryFailureException(
                message=msg)
        finally:
            # stop the periodic call, in case of exceptions or Timeout.
            periodic_call.stop()
```
这段代码是一段监控动作的固定代码，做的事情就是调用Openstack的公共模块`oslo_service`，每隔一段时间去监测之前的`DisableComputeNodeTask`动作是否完成，是否超时。下面的几个其他流程的监控代码类似。



`masakari/setup.cfg`文件对task名称的定义：

    masakari.task_flow.tasks =
        disable_compute_service_task = masakari.engine.drivers.taskflow.host_failure:DisableComputeServiceTask
        confirm_compute_node_disabled_task = masakari.engine.drivers.taskflow.process_failure:ConfirmComputeNodeDisabledTask



配置文件对流程的定义：

        cfg.Opt('process_failure_recovery_tasks',
                type=types.Dict(
                    bounds=False,
                    value_type=types.List(bounds=True,
                                          item_type=types.String(quotes=True))),
                default={'pre': ['disable_compute_node_task'],
                         'main': ['confirm_compute_node_disabled_task'],
                         'post': []},
                help=("""
    This option allows operator to customize tasks to be executed for process
    failure recovery workflow.
    
    Provide list of strings reflecting to the task classes that should be included
    to the process failure recovery workflow. The full classname path of all task
    classes should be defined in the 'masakari.task_flow.tasks' of setup.cfg and
    these classes may be implemented by OpenStack Masaskari project team, deployer
    or third party.
    
    By default below two tasks will be part of this config option:-
    1. disable_compute_node_task
    2. confirm_compute_node_disabled_task
    
    The allowed values for this option is comma separated dictionary of object
    names in between ``{`` and ``}``."""))
    ]



# 虚拟机实例故障处理流程

`masakari\engine\drivers\taskflow\instance_failure.py`
```python
class StopInstanceTask(base.MasakariTask):
    def __init__(self, context, novaclient, **kwargs):
        kwargs['requires'] = ["instance_uuid"]
        super(StopInstanceTask, self).__init__(context,
                                               novaclient,
                                               **kwargs)

    def execute(self, instance_uuid):
        """Stop the instance for recovery."""
        instance = self.novaclient.get_server(self.context, instance_uuid)

        # If an instance is not HA_Enabled and "process_all_instances" config
        # option is also disabled, then there is no need to take any recovery
        # action.
        if not CONF.instance_failure.process_all_instances and not (
                strutils.bool_from_string(
                    instance.metadata.get('HA_Enabled', False))):
            msg = ("Skipping recovery for instance: %(instance_uuid)s as it is"
                   " not Ha_Enabled") % {'instance_uuid': instance_uuid}
            LOG.info(msg)
            self.update_details(msg, 1.0)
            raise exception.SkipInstanceRecoveryException()

        vm_state = getattr(instance, 'OS-EXT-STS:vm_state')
        if vm_state in ['paused', 'rescued']:
            msg = ("Recovery of instance '%(instance_uuid)s' is ignored as it "
                   "is in '%(vm_state)s' state.") % {
                'instance_uuid': instance_uuid, 'vm_state': vm_state
            }
            LOG.warning(msg)
            self.update_details(msg, 1.0)
            raise exception.IgnoreInstanceRecoveryException(msg)

        if vm_state != 'stopped':
            if vm_state == 'resized':
                self.novaclient.reset_instance_state(
                    self.context, instance.id, 'active')

            msg = "Stopping instance: %s" % instance_uuid
            self.update_details(msg)

            self.novaclient.stop_server(self.context, instance.id)

        def _wait_for_power_off():
            new_instance = self.novaclient.get_server(self.context,
                                                      instance_uuid)
            vm_state = getattr(new_instance, 'OS-EXT-STS:vm_state')
            if vm_state == 'stopped':
                raise loopingcall.LoopingCallDone()

        periodic_call = loopingcall.FixedIntervalLoopingCall(
            _wait_for_power_off)

        try:
            # add a timeout to the periodic call.
            periodic_call.start(interval=CONF.verify_interval)
            etimeout.with_timeout(CONF.wait_period_after_power_off,
                                  periodic_call.wait)
            msg = "Stopped instance: '%s'" % instance_uuid
            self.update_details(msg, 1.0)
        except etimeout.Timeout:
            msg = "Failed to stop instance %(instance)s" % {
                'instance': instance.id
            }
            self.update_details(msg, 1.0)
            raise exception.InstanceRecoveryFailureException(
                message=msg)
        finally:
            # stop the periodic call, in case of exceptions or Timeout.
            periodic_call.stop()
```

参数`process_all_instances`为`true`，则所有的vm实例都执行，若该参数为`false`，则是否执行实例要根据实例的`metadata key 'HA_Enabled=True' or not。`

    instance_failure_options = [
        cfg.BoolOpt('process_all_instances',
                    default=False,
                    help="""
    Operators can decide whether all instances or only those instances which
    contain metadata key 'HA_Enabled=True' should be taken into account to
    recover from instance failure events. When set to True, it will execute
    instance failure recovery actions for an instance irrespective of whether
    that particular instance contains metadata key 'HA_Enabled=True' or not.
    When set to False, it will only execute instance failure recovery actions
    for an instance which contain metadata key 'HA_Enabled=True'."""),
    ]

如果参数`process_all_instances`为`false`且vm实例的`metadata：HA_Enabled为false`，`not CONF.instance_failure.process_all_instances and not (strutils.bool_from_string(instance.metadata.get('HA_Enabled', False)))`，则跳过恢复该实例流程。

下面是vm几种状态的特殊处理，比如若是['paused', 'rescued']，若状态是!= 'stopped'且== 'resized'。

再下面就是调用`novaclient`模块的`novaclient.stop_server`去stop vm实例，再调用Openstack的公共模块`oslo_service`，每隔一段时间去监测之前的`_wait_for_power_off`动作是否完成，是否超时。



`masakari\engine\drivers\taskflow\instance_failure.py`
```python
class StartInstanceTask(base.MasakariTask):
    def __init__(self, context, novaclient, **kwargs):
        kwargs['requires'] = ["instance_uuid"]
        super(StartInstanceTask, self).__init__(context,
                                                novaclient,
                                                **kwargs)

    def execute(self, instance_uuid):
        """Start the instance."""
        msg = "Starting instance: '%s'" % instance_uuid
        self.update_details(msg)

        instance = self.novaclient.get_server(self.context, instance_uuid)
        vm_state = getattr(instance, 'OS-EXT-STS:vm_state')
        if vm_state == 'stopped':
            self.novaclient.start_server(self.context, instance.id)
            msg = "Instance started: '%s'" % instance_uuid
            self.update_details(msg, 1.0)
        else:
            msg = ("Invalid state for Instance %(instance)s. Expected state: "
                   "'STOPPED', Actual state: '%(actual_state)s'") % {
                'instance': instance_uuid,
                'actual_state': vm_state
            }
            self.update_details(msg, 1.0)
            raise exception.InstanceRecoveryFailureException(
                message=msg)
```
若vm实例状态时`stopped`，则调用novaclient模块的`novaclient.start_server`方法启动vm实例，否则抛出`exception.InstanceRecoveryFailureException`



`masakari\engine\drivers\taskflow\instance_failure.py`
```python
class ConfirmInstanceActiveTask(base.MasakariTask):
    def __init__(self, context, novaclient, **kwargs):
        kwargs['requires'] = ["instance_uuid"]
        super(ConfirmInstanceActiveTask, self).__init__(context,
                                                        novaclient,
                                                        **kwargs)

    def execute(self, instance_uuid):
        def _wait_for_active():
            new_instance = self.novaclient.get_server(self.context,
                                                      instance_uuid)
            vm_state = getattr(new_instance, 'OS-EXT-STS:vm_state')
            if vm_state == 'active':
                raise loopingcall.LoopingCallDone()

        periodic_call = loopingcall.FixedIntervalLoopingCall(
            _wait_for_active)
        try:
            msg = "Confirming instance '%s' vm_state is ACTIVE" % instance_uuid
            self.update_details(msg)

            # add a timeout to the periodic call.
            periodic_call.start(interval=CONF.verify_interval)
            etimeout.with_timeout(CONF.wait_period_after_power_on,
                                  periodic_call.wait)

            msg = "Confirmed instance '%s' vm_state is ACTIVE" % instance_uuid
            self.update_details(msg, 1.0)
        except etimeout.Timeout:
            msg = "Failed to start instance %(instance)s" % {
                'instance': instance_uuid
            }
            self.update_details(msg, 1.0)
            raise exception.InstanceRecoveryFailureException(
                message=msg)
        finally:
            # stop the periodic call, in case of exceptions or Timeout.
            periodic_call.stop()
```
调用Openstack的公共模块`oslo_service`，每隔一段时间去监测之前的`_wait_for_active`动作是否完成，是否超时。


`masakari/setup.cfg`文件对task名称的定义：

        stop_instance_task = masakari.engine.drivers.taskflow.instance_failure:StopInstanceTask
        start_instance_task = masakari.engine.drivers.taskflow.instance_failure:StartInstanceTask
        confirm_instance_active_task = masakari.engine.drivers.taskflow.instance_failure:ConfirmInstanceActiveTask

        

配置文件对流程的定义：

        cfg.Opt('instance_failure_recovery_tasks',
                type=types.Dict(
                    bounds=False,
                    value_type=types.List(bounds=True,
                                          item_type=types.String(quotes=True))),
                default={'pre': ['stop_instance_task'],
                         'main': ['start_instance_task'],
                         'post': ['confirm_instance_active_task']},
                help=("""
    This option allows operator to customize tasks to be executed for instance
    failure recovery workflow.
    
    Provide list of strings reflecting to the task classes that should be included
    to the instance failure recovery workflow. The full classname path of all task
    classes should be defined in the 'masakari.task_flow.tasks' of setup.cfg and
    these classes may be implemented by OpenStack Masaskari project team, deployer
    or third party.
    
    By default below three tasks will be part of this config option:-
    1. stop_instance_task
    2. start_instance_task
    3. confirm_instance_active_task
    
    The allowed values for this option is comma separated dictionary of object
    names in between ``{`` and ``}``.""")),
    ]



# 节点故障处理流程

`masakari\engine\drivers\taskflow\host_failure.py`
```python
class DisableComputeServiceTask(base.MasakariTask):
    def __init__(self, context, novaclient, **kwargs):
        kwargs['requires'] = ["host_name"]
        super(DisableComputeServiceTask, self).__init__(context, novaclient,
                                                        **kwargs)

    def execute(self, host_name):
        msg = "Disabling compute service on host: '%s'" % host_name
        self.update_details(msg)
        self.novaclient.enable_disable_service(self.context, host_name)
        # Sleep until nova-compute service is marked as disabled.
        log_msg = ("Sleeping %(wait)s sec before starting recovery "
               "thread until nova recognizes the node down.")
        LOG.info(log_msg, {'wait': CONF.wait_period_after_service_update})
        eventlet.sleep(CONF.wait_period_after_service_update)
        msg = "Disabled compute service on host: '%s'" % host_name
        self.update_details(msg, 1.0)
```
`DisableComputeServiceTask`实现`disable`计算节点的计算服务



`masakari\engine\drivers\taskflow\host_failure.py`
```python
class PrepareHAEnabledInstancesTask(base.MasakariTask):
    """Get all HA_Enabled instances."""
    default_provides = set(["instance_list"])

    def __init__(self, context, novaclient, **kwargs):
        kwargs['requires'] = ["host_name"]
        super(PrepareHAEnabledInstancesTask, self).__init__(context,
                                                            novaclient,
                                                            **kwargs)

    def execute(self, host_name):
        def _filter_instances(instance_list):
            ha_enabled_instances = []
            non_ha_enabled_instances = []

            for instance in instance_list:
                is_instance_ha_enabled = strutils.bool_from_string(
                    instance.metadata.get('HA_Enabled', False))
                if CONF.host_failure.ignore_instances_in_error_state and (
                        getattr(instance, "OS-EXT-STS:vm_state") == "error"):
                    if is_instance_ha_enabled:
                        msg = ("Ignoring recovery of HA_Enabled instance "
                               "'%(instance_id)s' as it is in 'error' state."
                               ) % {'instance_id': instance.id}
                        LOG.info(msg)
                        self.update_details(msg, 0.4)
                    continue

                if is_instance_ha_enabled:
                    ha_enabled_instances.append(instance)
                else:
                    non_ha_enabled_instances.append(instance)

            msg = "Total HA Enabled instances count: '%d'" % len(
                ha_enabled_instances)
            self.update_details(msg, 0.6)

            if CONF.host_failure.evacuate_all_instances:
                msg = ("Total Non-HA Enabled instances count: '%d'" % len(
                    non_ha_enabled_instances))
                self.update_details(msg, 0.7)

                ha_enabled_instances.extend(non_ha_enabled_instances)

                msg = ("All instances (HA Enabled/Non-HA Enabled) should be "
                       "considered for evacuation. Total count is: '%d'") % (
                    len(ha_enabled_instances))
                self.update_details(msg, 0.8)

            return ha_enabled_instances

        msg = "Preparing instances for evacuation"
        self.update_details(msg)

        instance_list = self.novaclient.get_servers(self.context, host_name)

        msg = ("Total instances running on failed host '%(host_name)s' is "
               "%(instance_list)d") % {'host_name': host_name,
                                       'instance_list': len(instance_list)}
        self.update_details(msg, 0.3)

        instance_list = _filter_instances(instance_list)

        if not instance_list:
            msg = ("Skipped host '%s' recovery as no instances needs to be "
                   "evacuated" % host_name)
            self.update_details(msg, 1.0)
            LOG.info(msg)
            raise exception.SkipHostRecoveryException(message=msg)

        # List of instance UUID
        instance_list = [instance.id for instance in instance_list]

        msg = "Instances to be evacuated are: '%s'" % ','.join(instance_list)
        self.update_details(msg, 1.0)

        return {
            "instance_list": instance_list,
        }
```
`PrepareHAEnabledInstancesTask`是疏散前的准备，准备哪些实例是需要疏散的。

具体实现：调用`novaclient`的`novaclient.get_servers`方法获得故障节点`hostname`上的所有的vm实例，存放在`instance_list`列表，调用过滤方法`_filter_instances`过滤后的vm实例，存放在`instance_list`列表，获取`instance_list`列表中的所有的`instance`的`id`再存放于`instance_list`列表。

`_filter_instances`方法对host上所有的实例做了过滤，返回需要疏散的实例。
具体实现：
（1）先将所有实例分为三类，一类 `CONF.host_failure.ignore_instances_in_error_state`设定为`true`且为`error`状态的实例，这一类直接跳过；第二类metadata包含`HA_Enabled`的实例，保存在数组`ha_enabled_instances`中；第三类是metadata不包含HA_Enabled的实例，保存在数组`non_ha_enabled_instances`中。
（2）若`CONF.host_failure.evacuate_all_instances`设定为`true`，则返回保存在数组`ha_enabled_instances`和`non_ha_enabled_instances`合并后的数组，若`CONF.host_failure.evacuate_all_instances`设定为`false`，则只返回`ha_enabled_instances`数组。



`masakari\engine\drivers\taskflow\host_failure.py`
```python
class EvacuateInstancesTask(base.MasakariTask):

    def __init__(self, context, novaclient, **kwargs):
        kwargs['requires'] = ["host_name", "instance_list"]
        self.update_host_method = kwargs['update_host_method']
        super(EvacuateInstancesTask, self).__init__(context, novaclient,
                                                    **kwargs)

    def _get_state_and_host_of_instance(self, context, instance):
        new_instance = self.novaclient.get_server(context, instance.id)
        instance_host = getattr(new_instance,
                                "OS-EXT-SRV-ATTR:hypervisor_hostname")
        old_vm_state = getattr(instance, "OS-EXT-STS:vm_state")
        new_vm_state = getattr(new_instance, "OS-EXT-STS:vm_state")

        return (old_vm_state, new_vm_state, instance_host)

    def _stop_after_evacuation(self, context, instance):
        def _wait_for_stop_confirmation():
            old_vm_state, new_vm_state, instance_host = (
                self._get_state_and_host_of_instance(context, instance))

            if new_vm_state == 'stopped':
                raise loopingcall.LoopingCallDone()

        periodic_call_stopped = loopingcall.FixedIntervalLoopingCall(
            _wait_for_stop_confirmation)

        try:
            self.novaclient.stop_server(context, instance.id)
            # confirm instance is stopped after recovery
            periodic_call_stopped.start(interval=CONF.verify_interval)
            etimeout.with_timeout(
                CONF.wait_period_after_power_off,
                periodic_call_stopped.wait)
        except etimeout.Timeout:
            with excutils.save_and_reraise_exception():
                periodic_call_stopped.stop()
                msg = ("Instance '%(uuid)s' is successfully evacuated but "
                       "failed to stop.") % {'uuid': instance.id}
                LOG.warning(msg)
        else:
            periodic_call_stopped.stop()

    def _evacuate_and_confirm(self, context, instance, host_name,
                              failed_evacuation_instances,
                              reserved_host=None):
        # Before locking the instance check whether it is already locked
        # by user, if yes don't lock the instance
        instance_already_locked = self.novaclient.get_server(
            context, instance.id).locked

        if not instance_already_locked:
            # lock the instance so that until evacuation and confirmation
            # is not complete, user won't be able to perform any actions
            # on the instance.
            self.novaclient.lock_server(context, instance.id)

        def _wait_for_evacuation_confirmation():
            old_vm_state, new_vm_state, instance_host = (
                self._get_state_and_host_of_instance(context, instance))
            if instance_host != host_name:
                if ((old_vm_state == 'error' and
                    new_vm_state == 'active') or
                        old_vm_state == new_vm_state):
                    raise loopingcall.LoopingCallDone()

        def _wait_for_evacuation():
            periodic_call = loopingcall.FixedIntervalLoopingCall(
                _wait_for_evacuation_confirmation)

            try:
                # add a timeout to the periodic call.
                periodic_call.start(interval=CONF.verify_interval)
                etimeout.with_timeout(
                    CONF.wait_period_after_evacuation,
                    periodic_call.wait)
            except etimeout.Timeout:
                # Instance is not evacuated in the expected time_limit.
                failed_evacuation_instances.append(instance.id)
            else:
                # stop the periodic call, in case of exceptions or
                # Timeout.
                periodic_call.stop()

        try:
            vm_state = getattr(instance, "OS-EXT-STS:vm_state")
            task_state = getattr(instance, "OS-EXT-STS:task_state")

            # Nova evacuates an instance only when vm_state is in active,
            # stopped or error state. If an instance is in other than active,
            # error and stopped vm_state, masakari resets the instance state
            # to *error* so that the instance can be evacuated.
            stop_instance = True
            if vm_state not in ['active', 'error', 'stopped']:
                self.novaclient.reset_instance_state(context, instance.id)
                instance = self.novaclient.get_server(context, instance.id)
                power_state = getattr(instance, "OS-EXT-STS:power_state")
                if vm_state == 'resized' and power_state != SHUTDOWN:
                    stop_instance = False

            elif task_state is not None:
                # Nova fails evacuation when the instance's task_state is not
                # none. In this case, masakari resets the instance's vm_state
                # to 'error' and task_state to none.
                self.novaclient.reset_instance_state(context, instance.id)
                instance = self.novaclient.get_server(context, instance.id)
                if vm_state == 'active':
                    stop_instance = False

            # evacuate the instance
            self.novaclient.evacuate_instance(context, instance.id,
                                              target=reserved_host)

            _wait_for_evacuation()

            if vm_state != 'active':
                if stop_instance:
                    self._stop_after_evacuation(self.context, instance)
                    # If the instance was in 'error' state before failure
                    # it should be set to 'error' after recovery.
                    if vm_state == 'error':
                        self.novaclient.reset_instance_state(
                            context, instance.id)
        except etimeout.Timeout:
            # Instance is not stop in the expected time_limit.
            failed_evacuation_instances.append(instance.id)
        except Exception:
            # Exception is raised while resetting instance state or
            # evacuating the instance itself.
            failed_evacuation_instances.append(instance.id)
        finally:
            if not instance_already_locked:
                # Unlock the server after evacuation and confirmation
                self.novaclient.unlock_server(context, instance.id)

    def execute(self, host_name, instance_list, reserved_host=None):
        msg = ("Start evacuation of instances from failed host '%(host_name)s'"
               ", instance uuids are: '%(instance_list)s'") % {
            'host_name': host_name, 'instance_list': ','.join(instance_list)}
        self.update_details(msg)

        def _do_evacuate(context, host_name, instance_list,
                         reserved_host=None):
            failed_evacuation_instances = []

            if reserved_host:
                msg = "Enabling reserved host: '%s'" % reserved_host
                self.update_details(msg, 0.1)
                if CONF.host_failure.add_reserved_host_to_aggregate:
                    # Assign reserved_host to an aggregate to which the failed
                    # compute host belongs to.
                    aggregates = self.novaclient.get_aggregate_list(context)
                    for aggregate in aggregates:
                        if host_name in aggregate.hosts:
                            try:
                                msg = ("Add host %(reserved_host)s to "
                                       "aggregate %(aggregate)s") % {
                                    'reserved_host': reserved_host,
                                    'aggregate': aggregate.name}
                                self.update_details(msg, 0.2)

                                self.novaclient.add_host_to_aggregate(
                                    context, reserved_host, aggregate)
                                msg = ("Added host %(reserved_host)s to "
                                       "aggregate %(aggregate)s") % {
                                    'reserved_host': reserved_host,
                                    'aggregate': aggregate.name}
                                self.update_details(msg, 0.3)
                            except exception.Conflict:
                                msg = ("Host '%(reserved_host)s' already has "
                                       "been added to aggregate "
                                       "'%(aggregate)s'.") % {
                                    'reserved_host': reserved_host,
                                    'aggregate': aggregate.name}
                                self.update_details(msg, 1.0)
                                LOG.info(msg)

                            # A failed compute host can be associated with
                            # multiple aggregates but operators will not
                            # associate it with multiple aggregates in real
                            # deployment so adding reserved_host to the very
                            # first aggregate from the list.
                            break

                self.novaclient.enable_disable_service(
                    context, reserved_host, enable=True)

                # Set reserved property of reserved_host to False
                self.update_host_method(self.context, reserved_host)

            thread_pool = greenpool.GreenPool(
                CONF.host_failure_recovery_threads)

            for instance_id in instance_list:
                msg = "Evacuation of instance started: '%s'" % instance_id
                self.update_details(msg, 0.5)
                instance = self.novaclient.get_server(self.context,
                                                      instance_id)
                thread_pool.spawn_n(self._evacuate_and_confirm, context,
                                    instance, host_name,
                                    failed_evacuation_instances,
                                    reserved_host)

            thread_pool.waitall()

            evacuated_instances = list(set(instance_list).difference(set(
                failed_evacuation_instances)))

            if evacuated_instances:
                evacuated_instances.sort()
                msg = ("Successfully evacuate instances '%(instance_list)s' "
                       "from host '%(host_name)s'") % {
                    'instance_list': ','.join(evacuated_instances),
                    'host_name': host_name}
                self.update_details(msg, 0.7)

            if failed_evacuation_instances:
                msg = ("Failed to evacuate instances "
                       "'%(failed_evacuation_instances)s' from host "
                       "'%(host_name)s'") % {
                    'failed_evacuation_instances':
                        ','.join(failed_evacuation_instances),
                    'host_name': host_name}
                self.update_details(msg, 0.7)
                raise exception.HostRecoveryFailureException(
                    message=msg)

            msg = "Evacuation process completed!"
            self.update_details(msg, 1.0)

        lock_name = reserved_host if reserved_host else None

        @utils.synchronized(lock_name)
        def do_evacuate_with_reserved_host(context, host_name, instance_list,
                                           reserved_host):
            _do_evacuate(self.context, host_name, instance_list,
                         reserved_host=reserved_host)

        if lock_name:
            do_evacuate_with_reserved_host(self.context, host_name,
                                           instance_list, reserved_host)
        else:
            # No need to acquire lock on reserved_host when recovery_method is
            # 'auto' as the selection of compute host will be decided by nova.
            _do_evacuate(self.context, host_name, instance_list)
```
`EvacuateInstancesTask`实现对故障节点上的需要疏散的实例做疏散操作。其中分2种情况，是否指定`reserved_host`，若指定则疏散到该`reserved_host`，若无，由`nova-scheduler`选择疏散的目的节点。
具体实现：
（1）若`CONF.host_failure.add_reserved_host_to_aggregate`为true，则将`reserved_host`添加到故障节点所属的主机组。
（2）调用`novaclient`模块的`novaclient.enable_disable_service(context, reserved_host, enable=True)`方法将`reserved_host`的计算服务从disable状态修改为enable状态
（3）调用`update_host_method`方法将`reserved_host`的reserved属性设定为false
（4）根据配置文件`CONF.host_failure_recovery_threads`设定的线程数启动对应的线程数，来疏散`instance_list`数组里的实例
（5）等待所有疏散线程结束
（6）给出所有疏散的实例和所有未疏散的实例

其中第（4）步，多线程疏散方法`_evacuate_and_confirm`具体实现：
（a）调用`novaclient`模块获取vm实例是否为locked状态`novaclient.get_server(context, instance.id).locked`
（b）若不是`locked`状态则调用`novaclient.lock_server(context, instance.id)`方法将vm实例锁定，目的是确保对实例疏散过程中，用户不能对该实例有任何操作。
（c）因为疏散支持对`error`，`active`，`stopped`三种状态的vm做疏散，若不是这三种状态将实例reset成这三种状态。
（d）执行对vm实例的疏散
（e）等待实例疏散的完成



`masakari/setup.cfg`文件对task名称的定义：

    masakari.task_flow.tasks =
        disable_compute_service_task = masakari.engine.drivers.taskflow.host_failure:DisableComputeServiceTask
        prepare_HA_enabled_instances_task = masakari.engine.drivers.taskflow.host_failure:PrepareHAEnabledInstancesTask
        evacuate_instances_task = masakari.engine.drivers.taskflow.host_failure:EvacuateInstancesTask

配置文件对流程的定义：

        cfg.Opt('host_auto_failure_recovery_tasks',
                type=types.Dict(
                    bounds=False,
                    value_type=types.List(bounds=True,
                                          item_type=types.String(quotes=True))),
                default={'pre': ['disable_compute_service_task'],
                         'main': ['prepare_HA_enabled_instances_task'],
                         'post': ['evacuate_instances_task']},
                help=("""
    This option allows operator to customize tasks to be executed for host failure
    auto recovery workflow.
    
    Provide list of strings reflecting to the task classes that should be included
    to the host failure recovery workflow. The full classname path of all task
    classes should be defined in the 'masakari.task_flow.tasks' of setup.cfg and
    these classes may be implemented by OpenStack Masaskari project team, deployer
    or third party.
    
    By default below three tasks will be part of this config option:-
    1. disable_compute_service_task
    2. prepare_HA_enabled_instances_task
    3. evacuate_instances_task
    
    The allowed values for this option is comma separated dictionary of object
    names in between ``{`` and ``}``.""")),
    ]
