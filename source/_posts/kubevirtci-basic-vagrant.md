---
title: kubevirtci-basic-vagrant(workinprocess)
readmore: true
date: 2022-07-11 19:50:45
categories: 云原生
tags:
- KubeVirt CI
---


# vagrant install

    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    sudo yum -y install vagrant

# run vagrant

```bash
 ⚡ root@localhost  ~/tt  wget https://download.virtualbox.org/virtualbox/6.1.34/VirtualBox-6.1.34-150636-Linux_amd64.run
--2022-07-11 17:40:15--  https://download.virtualbox.org/virtualbox/6.1.34/VirtualBox-6.1.34-150636-Linux_amd64.run
Resolving download.virtualbox.org (download.virtualbox.org)... 23.194.210.104
Connecting to download.virtualbox.org (download.virtualbox.org)|23.194.210.104|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 112793047 (108M) [text/plain]
Saving to: ‘VirtualBox-6.1.34-150636-Linux_amd64.run’

VirtualBox-6.1.34-150636-Li 100%[==========================================>] 107.57M  11.1MB/s    in 10s     

2022-07-11 17:40:27 (10.6 MB/s) - ‘VirtualBox-6.1.34-150636-Linux_amd64.run’ saved [112793047/112793047]

 ⚡ root@localhost  ~/tt  ls
VirtualBox-6.1.34-150636-Linux_amd64.run
 ⚡ root@localhost  ~/tt  chmod 755 VirtualBox-6.1.34-150636-Linux_amd64.run 
 ⚡ root@localhost  ~/tt  ./VirtualBox-6.1.34-150636-Linux_amd64.run 
Verifying archive integrity... All good.
Uncompressing VirtualBox for Linux installation.............
VirtualBox Version 6.1.34 r150636 (2022-03-23T00:48:40Z) installer
Installing VirtualBox to /opt/VirtualBox
Python 2 (2.6 or 2.7) not available, skipping bindings installation.
This system is currently not set up to build kernel modules.
Please install the Linux kernel "header" files matching the current kernel
for adding new hardware support to the system.
The distribution packages containing the headers are probably:
    kernel-devel kernel-devel-5.14.0-115.el9.x86_64
This system is currently not set up to build kernel modules.
Please install the Linux kernel "header" files matching the current kernel
for adding new hardware support to the system.
The distribution packages containing the headers are probably:
    kernel-devel kernel-devel-5.14.0-115.el9.x86_64

There were problems setting up VirtualBox.  To re-start the set-up process, run
  /sbin/vboxconfig
as root.  If your system is using EFI Secure Boot you may need to sign the
kernel modules (vboxdrv, vboxnetflt, vboxnetadp, vboxpci) before you can load
them. Please see your Linux system's documentation for more information.

VirtualBox has been installed successfully.

You will find useful information about using VirtualBox in the user manual
  /opt/VirtualBox/UserManual.pdf
and in the user FAQ
  http://www.virtualbox.org/wiki/User_FAQ

We hope that you enjoy using VirtualBox.

The installation log file is at /var/log/vbox-install.log.
```

```bash
 ⚡ root@localhost  ~/tt  vagrant init hashicorp/bionic64
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
 ⚡ root@localhost  ~/tt  ls
Vagrantfile
 ⚡ root@localhost  ~/tt  vagrant up                     
No usable default provider could be found for your system.

Vagrant relies on interactions with 3rd party systems, known as
"providers", to provide Vagrant with resources to run development
environments. Examples are VirtualBox, VMware, Hyper-V.

The easiest solution to this message is to install VirtualBox, which
is available for free on all major platforms.

If you believe you already have a provider available, make sure it
is properly installed and configured. You can see more details about
why a particular provider isn't working by forcing usage with
`vagrant up --provider=PROVIDER`, which should give you a more specific
error message for that particular provider.
 ✘ ⚡ root@localhost  ~/tt  vagrant up --provider=virtualbox
The provider 'virtualbox' that was requested to back the machine
'default' is reporting that it isn't usable on this system. The
reason is shown below:

VirtualBox is complaining that the kernel module is not loaded. Please
run `VBoxManage --version` or open the VirtualBox GUI to see the error
message which should contain instructions on how to fix this error.
 ✘ ⚡ root@localhost  ~/tt  VBoxManage --version
WARNING: The vboxdrv kernel module is not loaded. Either there is no module
         available for the current kernel (5.14.0-115.el9.x86_64) or it failed to
         load. Please recompile the kernel module and install it by

           sudo /sbin/vboxconfig

         You will not be able to start VMs until this problem is fixed.
6.1.34r150636
 ⚡ root@localhost  ~/tt  
 ```