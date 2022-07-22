---
title: Vagrant基本使用
readmore: true
date: 2022-07-12 19:50:45
categories: 云原生
tags:
- KubeVirt CI
---

# vagrant install

```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install vagrant
```

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

CentOS Stream 9已经装了vagrant和virtualBox，提示不支持当前的linux内核，竟然不支持当前内核。virtualBox官网看了，只有最高到Centos Stream 8的版本，算了，virtualBox + vagrant就改在windows下跑吧。

```powershell
PS C:\Users\hanwei\tt> vagrant init hashicorp/bionic64
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
PS C:\Users\hanwei\tt> ls


    目录: C:\Users\hanwei\tt


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         2022/7/12      9:02           3094 Vagrantfile


PS C:\Users\hanwei\tt> vagrant up
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
PS C:\Users\hanwei\tt> vagrant up --provider=VMware
The provider 'VMware' could not be found, but was requested to
back the machine 'default'. Please use a provider that exists.

Vagrant knows about the following providers: docker, hyperv, virtualbox
PS C:\Users\hanwei\tt> vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'hashicorp/bionic64' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Loading metadata for box 'hashicorp/bionic64'
    default: URL: https://vagrantcloud.com/hashicorp/bionic64
==> default: Adding box 'hashicorp/bionic64' (v1.0.282) for provider: virtualbox
    default: Downloading: https://vagrantcloud.com/hashicorp/boxes/bionic64/versions/1.0.282/providers/virtualbox.box
    default:
==> default: Successfully added box 'hashicorp/bionic64' (v1.0.282) for 'virtualbox'!
==> default: Importing base box 'hashicorp/bionic64'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'hashicorp/bionic64' version '1.0.282' is up to date...
==> default: Setting the name of the VM: tt_default_1657588035744_45442
Vagrant is currently configured to create VirtualBox synced folders with
the `SharedFoldersEnableSymlinksCreate` option enabled. If the Vagrant
guest is not trusted, you may want to disable this option. For more
information on this option, please refer to the VirtualBox manual:

  https://www.virtualbox.org/manual/ch04.html#sharedfolders

This option can be disabled globally with an environment variable:

  VAGRANT_DISABLE_VBOXSYMLINKCREATE=1

or on a per folder basis within the Vagrantfile:

  config.vm.synced_folder '/host/path', '/guest/path', SharedFoldersEnableSymlinksCreate: false
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: Warning: Connection aborted. Retrying...
    default: Warning: Connection reset. Retrying...
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
    default: The guest additions on this VM do not match the installed version of
    default: VirtualBox! In most cases this is fine, but in rare cases it can
    default: prevent things such as shared folders from working properly. If you see
    default: shared folder errors, please make sure the guest additions within the
    default: virtual machine match the version of VirtualBox you have installed on
    default: your host and reload your VM.
    default:
    default: Guest Additions Version: 6.0.10
    default: VirtualBox Version: 6.1
==> default: Mounting shared folders...
    default: /vagrant => C:/Users/hanwei/tt
PS C:\Users\hanwei\tt>
```

 ![](/images/kubevirtci-basic-vagrant/2022-07-12-09-14-26.png)