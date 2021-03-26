title: pci-api support
date: 2017-05-02 10:11:54
categories:
- 智能云
tags:
- PCI
- API
---

1 Use case
1.1 List and show PCI devices on VMs
1.2 List and show PCI stats on hypervisors
1.3 List PCI devices on the nodes
1.4 Get PCI device detailed information

2 What the REST PCI API will look like

The PCI API should incloude 3 interfaces:

We should extend server API to add PCI assignment information. When you use the server API, the result contains the PCI device information. For example:
Use case: List an show PCI devices on VMs Request:

    GET v2/{tenant_id}/servers/{server_id}

Nova-client command :

    nova list
    nova show VM name 

The response JSON will contain the variable "os-pci:pci_devices":

    { "server": {"os-pci:pci_devices": [{"id": 1}], "tenant_id": "openstack", "user_id": "fake"}}

you can see which PCI device was used by the server of interest to you. The value of "os-pci-devices" means this VM used one PCI device(id=1).

We also should extend hypervisor API to add PCI stats information. We use the hypervisor api can also get the PCI stats in the results. For example:
Use case : List an show PCI stats on hypervisors  Request:

    GET v2/{tenant_id}/os-hypervisors/{hypervisor_hostname}

Nova-client command :

    nova hypervisor-list
    nova hypervisor-show id 

The response JOSN contains the variable "pci_stats":

    {"hypervisor": {"pci_stats": [{"count": 5, "vendor_id": "8086", "product_id": "1520", "extra_info": {"phys_function": "abc", "key1": "value1"}}}]}

We also need to add PCI APIs like to get PCI device information.
Use case : List PCI devices on the nodes  Request:

    GET v2/{tenant_id}/os-pci

Nova-client command :

  nova pci-list

 The response JSON may like below :

    {"pci_devices": [{ "address": "0000:04:10.0",  "compute_node_id": 1, "id": 1, "product_id": "1520",  "status": "available",  "vendor_id": "8086" } ]}
Request:

    GET v2/{tenant_id}/os-pci/detail

The response JSON may like below :

    { "pci_devices": [ { "address": "0000:04:10.0", "compute_node_id": 1, "created_at": null, "deleted": false,  "deleted_at": null, "dev_id": "pci_0000_04_10_0",  "dev_type": "type-VF", "extra_info": { "key1": "value1", "key2": "value2", "phys_function": "0x004" }, "id": 1, "instance_uuid": "246ca", "label": "label_8086_1520", "product_id": "1520", "status": "available",  "updated_at": null, "vendor_id": "8086"}]}

Use case : Show PCI device infomation Request:

   GET v2/{tenant_id}/os-pci/{pci_device_id}
Nova-client command :

  nova pci-show id 
The response JSON may like below :

    {"pci_device": { "address": "0000:04:10.0","compute_node_id": 1, "created_at": null, "deleted": false, "deleted_at": null, "dev_id": "pci_0000_04_10_0", "dev_type": "type-VF", "extra_info": {"key1": "value1", "key2": "value2", "phys_function": "0x004"}, "id": 1, "instance_uuid": "246ca", "label": "label_8086_1520", "product_id": "1520",  "status": "available",  "updated_at": null, "vendor_id": "8086"}}

We intend to add the PCI APIs into V2 and V3. The patch may be big, so I want to split the patch into 3 parts in V2 and V3.

* extend the sever API.
* extend hypervisor API.
* add PCI API.
