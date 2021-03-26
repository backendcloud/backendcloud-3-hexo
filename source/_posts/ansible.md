title: ansible简单使用
date: 2017-05-03 07:55:42
categories: 自动化
tags:
- ansible
---
# 安装

ansible的安装算简单的了，不要配置数据库，不用在远程操作的节点安装任何东西。只需要本机安装ansible即可。

但是还是依赖一些基本python库。

ansible
|--  jinja2
|--  PyYAML
|--  paramiko
|--  pycrypto>=2.6
|--  setuptools
|--  MarkupSafe
|--  cryptography>=1.1
|--  pyasn1>=0.1.7
|--  idna>=2.1
|--  asn1crypto>=0.21.0
|--  packaging
|--  six>=1.4.1
|--  enum34
|--  ipaddress
|--  cffi>=1.4.1
|--  pyparsing
|--  pycparser



# hello world

    # echo "127.0.0.1" > ~/ansible_hosts
    # export ANSIBLE_HOSTS=~/ansible_hosts
    # ansible all -m ping --ask-pass
    [root@promote ~]# cat ~/ansible_hosts
    127.0.0.1
    [root@promote ~]# export ANSIBLE_HOSTS=~/ansible_hosts
    [root@promote ~]# ansible all -m ping --ask-pass
    SSH password: 
    127.0.0.1 | SUCCESS => {
        "changed": false, 
        "ping": "pong"
    }
    


# 安装最新版

    # git clone git://github.com/ansible/ansible.git
    # cd ./ansible
    # make rpm
    # sudo rpm -Uvh ~/rpmbuild/ansible-*.noarch.rpm



# 模块

## ping模块

    [root@localhost ~]# ansible 127.0.0.1 -m ping
    127.0.0.1 | SUCCESS => {
        "changed": false, 
        "ping": "pong"
    }



## wait_for模块

检查端口是否占用

    [root@promote ~]# ansible 127.0.0.1 -m wait_for -a "port=22 delay=0 timeout=2"
    127.0.0.1 | SUCCESS => {
        "changed": false, 
        "elapsed": 0, 
        "path": null, 
        "port": 22, 
        "search_regex": null, 
        "state": "started"
    }
    [root@promote ~]# ansible 127.0.0.1 -m wait_for -a "port=81 delay=0 timeout=2"
    127.0.0.1 | FAILED! => {
        "changed": false, 
        "elapsed": 2, 
        "failed": true, 
        "msg": "Timeout when waiting for 127.0.0.1:81"
    }

检查文件是否存在，如配置文件，lock文件

    [root@promote ~]# ansible 127.0.0.1 -m wait_for -a "path=~/a delay=0 timeout=2"
    127.0.0.1 | SUCCESS => {
        "changed": false, 
        "elapsed": 0, 
        "gid": 1001, 
        "group": "1001", 
        "mode": "0600", 
        "owner": "1001", 
        "path": "/root/a", 
        "port": null, 
        "search_regex": null, 
        "secontext": "unconfined_u:object_r:admin_home_t:s0", 
        "size": 75, 
        "state": "file", 
        "uid": 1001
    }
    [root@promote ~]# ansible 127.0.0.1 -m wait_for -a "path=~/a1934 delay=0 timeout=2"
    127.0.0.1 | FAILED! => {
        "changed": false, 
        "elapsed": 2, 
        "failed": true, 
        "msg": "Timeout when waiting for file /root/a1934"
    }


## raw模块

    [root@localhost ~]# ansible 127.0.0.1 -m raw -a 'hostname|tee fgh'
    127.0.0.1 | SUCCESS | rc=0 >>
    localhost.localdomain
    Shared connection to 127.0.0.1 closed.
    
    
    [root@localhost ~]# cat fgh
    localhost.localdomain



## get_url模块

目的：将http://10.1.1.116/favicon.ico文件下载到指定节点10.1.1.113的/tmp目录下
命令：ansible 10.1.1.113 -m get_url -a 'url=http://10.1.1.116/favicon.ico dest=/tmp'


## synchronize模块

目的：将主控方/root/a目录推送到指定节点的/tmp目录下
命令：ansible 10.1.1.113 -m synchronize -a 'src=/root/a dest=/tmp/ compress=yes'

    delete=yes   使两边的内容一样（即以推送方为主）
    compress=yes  开启压缩，默认为开启
    --exclude=.git  忽略同步.git结尾的文件

由于模块，默认都是推送push。因此，如果你在使用拉取pull功能的时候，可以参考如下来实现
    mode=pull   更改推送模式为拉取模式
目的：将10.1.1.113节点的/tmp/a目录拉取到主控节点的/root目录下
命令：ansible 10.1.1.113 -m synchronize -a 'mode=pull src=/tmp/a dest=/root/'
执行效果：
   由于模块默认启用了archive参数，该参数默认开启了recursive, links, perms, times, owner，group和-D参数。如果你将该参数设置为no，那么你将停止很多参数，比如会导致如下目的递归失败，导致无法拉取
    
其它相关的参数解释：

    dest_port=22    # 指定目的主机的ssh端口，ansible配置文件中的 ansible_ssh_port 变量优先级高于该 dest_port 变量
    rsync_path      # 指定 rsync 命令来在远程服务器上运行。这个参考rsync命令的--rsync-path参数，--rsync-path=PATH     # 指定远程服务器上的rsync命令所在路径信息
    rsync_timeout   # 指定 rsync 操作的 IP 超时时间，和rsync命令的 --timeout 参数效果一样



## service模块

    [root@promote ~]# ansible 127.0.0.1 -m service -a "name=firewalld state=stop" --ask-pass
    SSH password: 
    127.0.0.1 | FAILED! => {
        "changed": false, 
        "failed": true, 
        "msg": "value of state must be one of: started,stopped,restarted,reloaded, got: stop"
    }
    [root@promote ~]# ansible 127.0.0.1 -m service -a "name=firewalld state=stopped" --ask-pass
    SSH password: 
    127.0.0.1 | SUCCESS => {
        "changed": true, 
        "name": "firewalld", 
        "state": "stopped", 
        "status": {
            "ActiveEnterTimestamp": "Tue 2017-05-02 18:24:48 CST", 
            "ActiveEnterTimestampMonotonic": "271551053930", 
            "ActiveExitTimestamp": "Tue 2017-05-02 18:24:45 CST", 
            "ActiveExitTimestampMonotonic": "271547664754", 
            "ActiveState": "active", 
            "After": "system.slice polkit.service dbus.service basic.target", 
            "AllowIsolate": "no", 
            "AssertResult": "yes", 
            "AssertTimestamp": "Tue 2017-05-02 18:24:46 CST", 
            "AssertTimestampMonotonic": "271549335937", 
            "Before": "libvirtd.service shutdown.target network.target NetworkManager.service", 
            "BlockIOAccounting": "no", 
            "BlockIOWeight": "18446744073709551615", 
            "BusName": "org.fedoraproject.FirewallD1", 
            "CPUAccounting": "no", 
            "CPUQuotaPerSecUSec": "infinity", 
            "CPUSchedulingPolicy": "0", 
            "CPUSchedulingPriority": "0", 
            "CPUSchedulingResetOnFork": "no", 
            "CPUShares": "18446744073709551615", 
            "CanIsolate": "no", 
            "CanReload": "yes", 
            "CanStart": "yes", 
            "CanStop": "yes", 
            "CapabilityBoundingSet": "18446744073709551615", 
            "ConditionResult": "yes", 
            "ConditionTimestamp": "Tue 2017-05-02 18:24:46 CST", 
            "ConditionTimestampMonotonic": "271549335937", 
            "Conflicts": "ip6tables.service shutdown.target ipset.service ebtables.service iptables.service", 
            "ControlGroup": "/system.slice/firewalld.service", 
            "ControlPID": "0", 
            "DefaultDependencies": "yes", 
            "Delegate": "no", 
            "Description": "firewalld - dynamic firewall daemon", 
            "DevicePolicy": "auto", 
            "Documentation": "man:firewalld(1)", 
            "EnvironmentFile": "/etc/sysconfig/firewalld (ignore_errors=yes)", 
            "ExecMainCode": "0", 
            "ExecMainExitTimestampMonotonic": "0", 
            "ExecMainPID": "28770", 
            "ExecMainStartTimestamp": "Tue 2017-05-02 18:24:46 CST", 
            "ExecMainStartTimestampMonotonic": "271549353698", 
            "ExecMainStatus": "0", 
            "ExecReload": "{ path=/bin/kill ; argv[]=/bin/kill -HUP $MAINPID ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", 
            "ExecStart": "{ path=/usr/sbin/firewalld ; argv[]=/usr/sbin/firewalld --nofork --nopid $FIREWALLD_ARGS ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", 
            "FailureAction": "none", 
            "FileDescriptorStoreMax": "0", 
            "FragmentPath": "/usr/lib/systemd/system/firewalld.service", 
            "GuessMainPID": "yes", 
            "IOScheduling": "0", 
            "Id": "firewalld.service", 
            "IgnoreOnIsolate": "no", 
            "IgnoreOnSnapshot": "no", 
            "IgnoreSIGPIPE": "yes", 
            "InactiveEnterTimestamp": "Tue 2017-05-02 18:24:46 CST", 
            "InactiveEnterTimestampMonotonic": "271549332916", 
            "InactiveExitTimestamp": "Tue 2017-05-02 18:24:46 CST", 
            "InactiveExitTimestampMonotonic": "271549353774", 
            "JobTimeoutAction": "none", 
            "JobTimeoutUSec": "0", 
            "KillMode": "control-group", 
            "KillSignal": "15", 
            "LimitAS": "18446744073709551615", 
            "LimitCORE": "18446744073709551615", 
            "LimitCPU": "18446744073709551615", 
            "LimitDATA": "18446744073709551615", 
            "LimitFSIZE": "18446744073709551615", 
            "LimitLOCKS": "18446744073709551615", 
            "LimitMEMLOCK": "65536", 
            "LimitMSGQUEUE": "819200", 
            "LimitNICE": "0", 
            "LimitNOFILE": "4096", 
            "LimitNPROC": "7027", 
            "LimitRSS": "18446744073709551615", 
            "LimitRTPRIO": "0", 
            "LimitRTTIME": "18446744073709551615", 
            "LimitSIGPENDING": "7027", 
            "LimitSTACK": "18446744073709551615", 
            "LoadState": "loaded", 
            "MainPID": "28770", 
            "MemoryAccounting": "no", 
            "MemoryCurrent": "18446744073709551615", 
            "MemoryLimit": "18446744073709551615", 
            "MountFlags": "0", 
            "Names": "firewalld.service", 
            "NeedDaemonReload": "no", 
            "Nice": "0", 
            "NoNewPrivileges": "no", 
            "NonBlocking": "no", 
            "NotifyAccess": "none", 
            "OOMScoreAdjust": "0", 
            "OnFailureJobMode": "replace", 
            "PermissionsStartOnly": "no", 
            "PrivateDevices": "no", 
            "PrivateNetwork": "no", 
            "PrivateTmp": "no", 
            "ProtectHome": "no", 
            "ProtectSystem": "no", 
            "RefuseManualStart": "no", 
            "RefuseManualStop": "no", 
            "RemainAfterExit": "no", 
            "Requires": "basic.target", 
            "Restart": "no", 
            "RestartUSec": "100ms", 
            "Result": "success", 
            "RootDirectoryStartOnly": "no", 
            "RuntimeDirectoryMode": "0755", 
            "SameProcessGroup": "no", 
            "SecureBits": "0", 
            "SendSIGHUP": "no", 
            "SendSIGKILL": "yes", 
            "Slice": "system.slice", 
            "StandardError": "null", 
            "StandardInput": "null", 
            "StandardOutput": "null", 
            "StartLimitAction": "none", 
            "StartLimitBurst": "5", 
            "StartLimitInterval": "10000000", 
            "StartupBlockIOWeight": "18446744073709551615", 
            "StartupCPUShares": "18446744073709551615", 
            "StatusErrno": "0", 
            "StopWhenUnneeded": "no", 
            "SubState": "running", 
            "SyslogLevelPrefix": "yes", 
            "SyslogPriority": "30", 
            "SystemCallErrorNumber": "0", 
            "TTYReset": "no", 
            "TTYVHangup": "no", 
            "TTYVTDisallocate": "no", 
            "TimeoutStartUSec": "1min 30s", 
            "TimeoutStopUSec": "1min 30s", 
            "TimerSlackNSec": "50000", 
            "Transient": "no", 
            "Type": "dbus", 
            "UMask": "0022", 
            "UnitFilePreset": "enabled", 
            "UnitFileState": "enabled", 
            "WantedBy": "basic.target", 
            "Wants": "system.slice", 
            "WatchdogTimestamp": "Tue 2017-05-02 18:24:48 CST", 
            "WatchdogTimestampMonotonic": "271551053862", 
            "WatchdogUSec": "0"
        }
    }

## shell模块

    [root@promote ~]# ansible targets -m shell -a 'df -h'
    127.0.0.1 | SUCCESS | rc=0 >>
    Filesystem               Size  Used Avail Use% Mounted on
    /dev/mapper/centos-root   50G  6.1G   44G  13% /
    devtmpfs                 879M     0  879M   0% /dev
    tmpfs                    889M  144K  889M   1% /dev/shm
    tmpfs                    889M   20M  869M   3% /run
    tmpfs                    889M     0  889M   0% /sys/fs/cgroup
    /dev/mapper/centos-home   46G  569M   45G   2% /home
    /dev/sda1                497M  155M  343M  32% /boot
    tmpfs                    178M     0  178M   0% /run/user/0
    
    120.16.220.26 | SUCCESS | rc=0 >>
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/xvda1       40G  5.9G   32G  16% /
    devtmpfs        489M     0  489M   0% /dev
    tmpfs           497M     0  497M   0% /dev/shm
    tmpfs           497M   50M  447M  11% /run
    tmpfs           497M     0  497M   0% /sys/fs/cgroup

## copy模块

    [root@promote ~]# ansible 120.16.220.26 -m copy  -a "src=/root/a dest=/root/a"
    120.26.200.226 | SUCCESS => {
        "changed": true, 
        "checksum": "43e57bee936f6e0f6e8d7b32bdbc0270a02734de", 
        "dest": "/root/a", 
        "gid": 0, 
        "group": "root", 
        "md5sum": "d931cf1b23ae3441357fdf7a937b8acb", 
        "mode": "0644", 
        "owner": "root", 
        "size": 15306, 
        "src": "/root/.ansible/tmp/ansible-tmp-1493741518.08-148843208427673/source", 
        "state": "file", 
        "uid": 0
    }

## file模块

    [root@promote ~]# ll a
    -rw-r--r--. 1 root root 15306 May  2 23:08 a
    [root@promote ~]# ansible 127.0.0.1 -m file -a "dest=/root/a mode=600"
    127.0.0.1 | SUCCESS => {
        "changed": true, 
        "gid": 0, 
        "group": "root", 
        "mode": "0600", 
        "owner": "root", 
        "path": "/root/a", 
        "secontext": "unconfined_u:object_r:admin_home_t:s0", 
        "size": 15306, 
        "state": "file", 
        "uid": 0
    }
    [root@promote ~]# ls a
    a
    [root@promote ~]# ll a
    -rw-------. 1 root root 15306 May  2 23:08 a
    
    [root@promote ~]# ll a
    -rw-------. 1 root root 15306 May  2 23:08 a
    [root@promote ~]# ansible 127.0.0.1 -m file -a "dest=/root/a mode=600 owner=docker group=docker"
    127.0.0.1 | SUCCESS => {
        "changed": true, 
        "gid": 1001, 
        "group": "docker", 
        "mode": "0600", 
        "owner": "docker", 
        "path": "/root/a", 
        "secontext": "unconfined_u:object_r:admin_home_t:s0", 
        "size": 15306, 
        "state": "file", 
        "uid": 1001
    }
    [root@promote ~]# ll a
    -rw-------. 1 docker docker 15306 May  2 23:08 a


使用 file 模块也可以创建目录,与执行 mkdir -p 效果类似:

    $ ansible webservers -m file -a "dest=/path/to/c mode=755 owner=mdehaan group=mdehaan state=directory"

删除目录(递归的删除)和删除文件:

    $ ansible webservers -m file -a "dest=/path/to/c state=absent"



## yum模块

    [root@localhost ~]# ansible 127.0.0.1 -m yum -a "name=vim state=present"
    127.0.0.1 | SUCCESS => {
        "changed": true, 
        "msg": "", 
        "rc": 0, 
        "results": [
            "Loaded plugins: fastestmirror\nLoading mirror speeds from cached hostfile\n * epel: mirrors.tuna.tsinghua.edu.cn\nResolving Dependencies\n--> Running transaction check\n---> Package vim-enhanced.x86_64 2:7.4.160-1.el7_3.1 will be installed\n--> Finished Dependency Resolution\n\nDependencies Resolved\n\n================================================================================\n Package            Arch         Version                    Repository     Size\n================================================================================\nInstalling:\n vim-enhanced       x86_64       2:7.4.160-1.el7_3.1        updates       1.0 M\n\nTransaction Summary\n================================================================================\nInstall  1 Package\n\nTotal download size: 1.0 M\nInstalled size: 2.2 M\nDownloading packages:\nRunning transaction check\nRunning transaction test\nTransaction test succeeded\nRunning transaction\n  Installing : 2:vim-enhanced-7.4.160-1.el7_3.1.x86_64                      1/1 \n  Verifying  : 2:vim-enhanced-7.4.160-1.el7_3.1.x86_64                      1/1 \n\nInstalled:\n  vim-enhanced.x86_64 2:7.4.160-1.el7_3.1                                       \n\nComplete!\n"
        ]
    }
    [root@localhost ~]# ansible 127.0.0.1 -m yum -a "name=vim state=present"
    127.0.0.1 | SUCCESS => {
        "changed": false, 
        "msg": "", 
        "rc": 0, 
        "results": [
            "vim-enhanced-2:7.4.160-1.el7_3.1.x86_64 providing vim is already installed"
        ]
    }

    

## user模块

    [root@localhost ~]# ansible 127.0.0.1 -m user  -a "name=docker state=absent"
    127.0.0.1 | SUCCESS => {
        "changed": false, 
        "name": "docker", 
        "state": "absent"
    }
    [root@localhost ~]# useradd docker
    useradd: warning: the home directory already exists.
    Not copying any file from skel directory into it.
    Creating mailbox file: File exists
    [root@localhost ~]# ansible 127.0.0.1 -m user  -a "name=docker state=absent"
    127.0.0.1 | SUCCESS => {
        "changed": true, 
        "force": false, 
        "name": "docker", 
        "remove": false, 
        "state": "absent"
    }



## group模块

目的：在所有节点上创建一个组名为nolinux，gid为2014的组
命令：ansible all -m group -a 'gid=2014 name=nolinux'



## script模块

    [root@localhost ~]# cat a.sh
    echo hello from a.sh
    [root@localhost ~]# ansible 127.0.0.1 -m script -a '/root/a.sh'
    127.0.0.1 | SUCCESS => {
        "changed": true, 
        "rc": 0, 
        "stderr": "Shared connection to 127.0.0.1 closed.\r\n", 
        "stdout": "hello from a.sh\r\n", 
        "stdout_lines": [
            "hello from a.sh"
        ]
    }



## cron模块

    [root@localhost ~]# ansible 127.0.0.1 -m cron -a 'name="custom job" minute=*/3 hour=* day=* month=* weekday=* job="/usr/sbin/ntpdate 172.16.254.139"'
    127.0.0.1 | SUCCESS => {
        "changed": true, 
        "envs": [], 
        "jobs": [
            "custom job"
        ]
    }

    # crontab -e
    #Ansible: custom job
    */3 * * * * /usr/sbin/ntpdate 172.16.254.139



## 后台执行

    # ansible all -B 3600 -P 0 -a "/usr/bin/long_running_operation --do-stuff"
    # ansible all -B 1800 -P 60 -a "/usr/bin/long_running_operation --do-stuff"
    其中 -B 1800 表示最多运行30分钟, -P 60 表示每隔60秒获取一次状态信息.
