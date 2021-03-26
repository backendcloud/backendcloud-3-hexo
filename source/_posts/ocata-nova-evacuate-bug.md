title: Ocata nova evacuate bug
date: 2017-06-28 18:24:18
categories: Openstack_dev
tags:
- Ocata
- Nova
- Bug

---

# 现象

执行nova evacuate操作，但是在rebuild的时候有问题，到了某个步骤之后报错"rebuild的虚机被删除了"。

# 原因

当实例从一个节点疏散到另一个节点的时候，在rebuild过程中check_instance_exists方法执行的过程中InstanceNotFound异常是被期待发生的。

check_instance_exists方法是用来确保实例在新的节点上不存在，若存在要引发异常的。

实际代码中的check_instance_exists在不该报InstanceNotFound异常的时候，报了此异常，在方法的except未加入捕获InstanceNotFound异常。

# 社区修复

nova/virt/libvirt/driver.py

```python
    def instance_exists(self, instance):
        """Efficient override of base instance_exists method."""
        try:
            self._host.get_guest(instance)
            return True
        except exception.InternalError:
            return False
```

修改成：

```python
    def instance_exists(self, instance):
        """Efficient override of base instance_exists method."""
        try:
            self._host.get_guest(instance)
            return True
        except (exception.InternalError, exception.InstanceNotFound):
            return False
```

# 增加测试

```python
    @mock.patch.object(host.Host, 'get_guest')
    def test_instance_exists(self, mock_get_guest):
        drvr = libvirt_driver.LibvirtDriver(fake.FakeVirtAPI(), False)
        self.assertTrue(drvr.instance_exists(None))

        mock_get_guest.side_effect = exception.InstanceNotFound
        self.assertFalse(drvr.instance_exists(None))

        mock_get_guest.side_effect = exception.InternalError
        self.assertFalse(drvr.instance_exists(None))
```
