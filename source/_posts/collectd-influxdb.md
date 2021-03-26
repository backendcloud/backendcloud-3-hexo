title: Collectd 和 InfluxDB 的部署和使用
date: 2017-06-15 06:47:53
categories:
- Collectd
tags:
- Collectd
- InfluxDB
---

操作系统 ubuntu16.04



# 更新软件包

$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo reboot


# 安装influxdb

    hanwei@ubuntu-lab:~$ wget https://dl.influxdata.com/influxdb/releases/influxdb_1.2.4_amd64.deb
    --2017-06-14 16:37:09--  https://dl.influxdata.com/influxdb/releases/influxdb_1.2.4_amd64.deb
    Resolving dl.influxdata.com (dl.influxdata.com)... 52.84.167.167, 52.84.167.39, 52.84.167.178, ...
    Connecting to dl.influxdata.com (dl.influxdata.com)|52.84.167.167|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 17305080 (17M) [application/x-debian-package]
    Saving to: ‘influxdb_1.2.4_amd64.deb’
    
    influxdb_1.2.4_amd64.deb         100%[========================================================>]  16.50M   875KB/s    in 19s     
    
    2017-06-14 16:37:29 (874 KB/s) - ‘influxdb_1.2.4_amd64.deb’ saved [17305080/17305080]
    
    hanwei@ubuntu-lab:~$ sudo dpkg -i influxdb_1.2.4_amd64.deb
    [sudo] password for hanwei: 
    Selecting previously unselected package influxdb.
    (Reading database ... 63342 files and directories currently installed.)
    Preparing to unpack influxdb_1.2.4_amd64.deb ...
    Unpacking influxdb (1.2.4-1) ...
    Setting up influxdb (1.2.4-1) ...
    Created symlink from /etc/systemd/system/influxd.service to /lib/systemd/system/influxdb.service.
    Created symlink from /etc/systemd/system/multi-user.target.wants/influxdb.service to /lib/systemd/system/influxdb.service.
    Processing triggers for man-db (2.7.5-1) ...
    hanwei@ubuntu-lab:~$ service influxdb start
    ==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
    Authentication is required to start 'influxdb.service'.
    Authenticating as: hanwei,,, (hanwei)
    Password: 
    ==== AUTHENTICATION COMPLETE ===
    hanwei@ubuntu-lab:~$ service influxdb status
    ● influxdb.service - InfluxDB is an open-source, distributed, time series database
       Loaded: loaded (/lib/systemd/system/influxdb.service; enabled; vendor preset: enabled)
       Active: active (running) since Wed 2017-06-14 16:50:05 CST; 4s ago
         Docs: https://docs.influxdata.com/influxdb/
     Main PID: 2156 (influxd)
        Tasks: 7
       Memory: 4.9M
          CPU: 49ms
       CGroup: /system.slice/influxdb.service
               └─2156 /usr/bin/influxd -config /etc/influxdb/influxdb.conf 







# 修改influxdb配置文件

    hanwei@ubuntu-lab:~$ vim /etc/influxdb/influxdb.conf
    [admin]
      # Determines whether the admin service is enabled.
      # enabled = false
    
      # The default bind address used by the admin service.
      # bind-address = ":8083"
    
      # Whether the admin service should use HTTPS.
      # https-enabled = false
    
    修改成
    enabled = true
    bind-address = ":8083"



# 在infuxdb创建数据库Collectd

两种方式CLI或者web ui

http://192.168.206.144:8086/query?q=CREATE+DATABASE+%22collectd%22&db=collectd

或者用web ui
![influxdb](/images/collectd-influxdb/influxdb.jpg)



# 安装 Collectd

    $ sudo apt-get install collectd



# 配置 Collectd 为客户端，收集到数据后直接发给 InfluxDB

    $ sudo vi /etc/collectd/collectd.conf
    ...
    LoadPlugin network
    ...
    <Plugin network>
            Server "192.168.2.183" "25826"
    </Plugin>
    ...

重启 Collectd：

    $ sudo /etc/init.d/collectd restart



# 配置 InfluxDB 自带的 Collectd 插件

InfluxDB 自带的 Collectd 插件默认是关闭的，需要手动配置打开 enabled = true，并填上 database = “collectd” 这一行，这里的 “collectd” 就是我们上面创建的那个数据库，更改配置后记得重启 InfluxDB

    $ sudo vim /etc/influxdb/shared/influxdb.conf
    ...
      # Configure the collectd api
      [input_plugins.collectd]
      enabled = true
      # address = "0.0.0.0" # If not set, is actually set to bind-address.
      # port = 25826
      database = "collectd"
      # types.db can be found in a collectd installation or on github:
      # https://github.com/collectd/collectd/blob/master/src/types.db
      # typesdb = "/usr/share/collectd/types.db" # The path to the collectd types.db file
    ...
    hanwei@ubuntu-lab:~$ sudo service influxdb restart

检查一下服务器上打开的端口就会发现 influxdb 插件启动了一个 25826 端口，如果发现 InfluxDB 数据库里没有（收集到）数据，务必检查这个 25826 端口是否正常启动了

    hanwei@ubuntu-lab:~$ sudo netstat -tupln
    Active Internet connections (only servers)
    Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
    tcp        0      0 192.168.122.1:53        0.0.0.0:*               LISTEN      1649/dnsmasq    
    tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1308/sshd       
    tcp        0      0 127.0.0.1:5432          0.0.0.0:*               LISTEN      1437/postgres   
    tcp        0      0 127.0.0.1:6010          0.0.0.0:*               LISTEN      1740/0          
    tcp        0      0 127.0.0.1:6011          0.0.0.0:*               LISTEN      10471/1         
    tcp6       0      0 :::8083                 :::*                    LISTEN      10490/influxd   
    tcp6       0      0 :::8086                 :::*                    LISTEN      10490/influxd   
    tcp6       0      0 :::22                   :::*                    LISTEN      1308/sshd       
    tcp6       0      0 :::8088                 :::*                    LISTEN      10490/influxd   
    tcp6       0      0 ::1:5432                :::*                    LISTEN      1437/postgres   
    tcp6       0      0 ::1:6010                :::*                    LISTEN      1740/0          
    tcp6       0      0 ::1:6011                :::*                    LISTEN      10471/1         
    udp        0      0 0.0.0.0:53466           0.0.0.0:*                           10239/collectd  
    udp        0      0 192.168.122.1:53        0.0.0.0:*                           1649/dnsmasq    
    udp        0      0 0.0.0.0:67              0.0.0.0:*                           1649/dnsmasq    
    udp        0      0 0.0.0.0:68              0.0.0.0:*                           1250/dhclient   
    udp6       0      0 :::25826                :::*                                10490/influxd




# 检查InfluxDB是否有Collectd 传来的数据

InfluxDB 已经准备好接受和处理 Collectd 传来的数据了。用命令行或者 Web 管理界面验证一下数据库里是否有数据

    hanwei@ubuntu-lab:~$ influx
    Connected to http://localhost:8086 version 1.2.4
    InfluxDB shell version: 1.2.4
    > show databases;
    name: databases
    name
    ----
    _internal
    mydb
    > use collectd
    Using database collectd
    > show measurements
    name: measurements
    name
    ----
    cpu_value
    df_value
    disk_io_time
    disk_read
    disk_value
    disk_weighted_io_time
    disk_write
    entropy_value
    interface_rx
    interface_tx
    irq_value
    load_longterm
    load_midterm
    load_shortterm
    memory_value
    processes_value
    swap_value
    users_value
    > SELECT * from cpu_value
    ...
    7435180464451600 ubuntu-lab.localdomain 0        cpu  nice          722
    1497435180464452775 ubuntu-lab.localdomain 0        cpu  interrupt     0
    1497435180464454083 ubuntu-lab.localdomain 0        cpu  softirq       339
    1497435180464454592 ubuntu-lab.localdomain 0        cpu  steal         0
    1497435180464455103 ubuntu-lab.localdomain 0        cpu  idle          592750
    1497435190462593838 ubuntu-lab.localdomain 0        cpu  user          4281
    1497435190462598610 ubuntu-lab.localdomain 0        cpu  system        5599
    1497435190462600580 ubuntu-lab.localdomain 0        cpu  wait          7799
    1497435190462602296 ubuntu-lab.localdomain 0        cpu  nice          722
    1497435190462603649 ubuntu-lab.localdomain 0        cpu  interrupt     0
    1497435190462604905 ubuntu-lab.localdomain 0        cpu  softirq       339
    1497435190462605510 ubuntu-lab.localdomain 0        cpu  steal         0
    1497435190462606004 ubuntu-lab.localdomain 0        cpu  idle          593745
    1497435200463552177 ubuntu-lab.localdomain 0        cpu  user          4285
    1497435200463557277 ubuntu-lab.localdomain 0        cpu  system        5608
    1497435200463558626 ubuntu-lab.localdomain 0        cpu  wait          7799
    1497435200463560045 ubuntu-lab.localdomain 0        cpu  nice          722
    1497435200463561496 ubuntu-lab.localdomain 0        cpu  interrupt     0
    1497435200463562866 ubuntu-lab.localdomain 0        cpu  softirq       339
    ...

或者web ui
![influxdb-load](/images/collectd-influxdb/influxdb-load.jpg)

