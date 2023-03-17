---
title: Prometheus+Grafana quick-start
readmore: true
date: 2023-03-17 18:32:49
categories: 云原生
tags:
---

Prometheus+Grafana 是监控Kubernetes集群各项监控指标的主流开源工具。

本篇是关于Prometheus+Grafana的快速入门。最简单的监控demo：对服务器节点的监控。把从服务器（即被监控机器）采集到的信息发到prometheus，经prometheus数据处理后在grafana进行直观的展示。

# 安装和配置node_exporter

https://prometheus.io/download/ 下载最新的稳定版的node_exporter：

```bash
[root@centos9 ~]# wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
--2023-03-17 16:28:12--  https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
Resolving github.com (github.com)... 20.205.243.166
Connecting to github.com (github.com)|20.205.243.166|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://objects.githubusercontent.com/github-production-release-asset-2e65be/9524057/fc1630e0-8913-427f-94ba-4131d3ed96c7?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20230317%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230317T082813Z&X-Amz-Expires=300&X-Amz-Signature=b44ba826d32ba4a48e6ae44a8beff21a2e2814f868757c795270de9ebe31a352&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=9524057&response-content-disposition=attachment%3B%20filename%3Dnode_exporter-1.5.0.linux-amd64.tar.gz&response-content-type=application%2Foctet-stream [following]
--2023-03-17 16:28:13--  https://objects.githubusercontent.com/github-production-release-asset-2e65be/9524057/fc1630e0-8913-427f-94ba-4131d3ed96c7?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20230317%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230317T082813Z&X-Amz-Expires=300&X-Amz-Signature=b44ba826d32ba4a48e6ae44a8beff21a2e2814f868757c795270de9ebe31a352&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=9524057&response-content-disposition=attachment%3B%20filename%3Dnode_exporter-1.5.0.linux-amd64.tar.gz&response-content-type=application%2Foctet-stream
Resolving objects.githubusercontent.com (objects.githubusercontent.com)... 185.199.109.133
Connecting to objects.githubusercontent.com (objects.githubusercontent.com)|185.199.109.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 10181045 (9.7M) [application/octet-stream]
Saving to: ‘node_exporter-1.5.0.linux-amd64.tar.gz’

node_exporter-1.5.0.linux-amd64.tar.gz                       100%[===========================================================================================================================================>]   9.71M  8.54MB/s    in 1.1s

2023-03-17 16:28:15 (8.54 MB/s) - ‘node_exporter-1.5.0.linux-amd64.tar.gz’ saved [10181045/10181045]
```

解压并启动node_exporter：

```bash
[root@centos9 ~]# tar xzvf node_exporter-1.5.0.linux-amd64.tar.gz
node_exporter-1.5.0.linux-amd64/
node_exporter-1.5.0.linux-amd64/LICENSE
node_exporter-1.5.0.linux-amd64/NOTICE
node_exporter-1.5.0.linux-amd64/node_exporter
[root@centos9 ~]# node_exporter-1.5.0.linux-amd64/node_exporter
ts=2023-03-17T08:29:01.780Z caller=node_exporter.go:180 level=info msg="Starting node_exporter" version="(version=1.5.0, branch=HEAD, revision=1b48970ffcf5630534fb00bb0687d73c66d1c959)"
ts=2023-03-17T08:29:01.780Z caller=node_exporter.go:181 level=info msg="Build context" build_context="(go=go1.19.3, user=root@6e7732a7b81b, date=20221129-18:59:09)"
ts=2023-03-17T08:29:01.780Z caller=node_exporter.go:183 level=warn msg="Node Exporter is running as root user. This exporter is designed to run as unprivileged user, root is not required."
ts=2023-03-17T08:29:01.781Z caller=filesystem_common.go:111 level=info collector=filesystem msg="Parsed flag --collector.filesystem.mount-points-exclude" flag=^/(dev|proc|run/credentials/.+|sys|var/lib/docker/.+|var/lib/containers/storage/.+)($|/)
ts=2023-03-17T08:29:01.781Z caller=filesystem_common.go:113 level=info collector=filesystem msg="Parsed flag --collector.filesystem.fs-types-exclude" flag=^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$
ts=2023-03-17T08:29:01.781Z caller=diskstats_common.go:111 level=info collector=diskstats msg="Parsed flag --collector.diskstats.device-exclude" flag=^(ram|loop|fd|(h|s|v|xv)d[a-z]|nvme\d+n\d+p)\d+$
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:110 level=info msg="Enabled collectors"
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=arp
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=bcache
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=bonding
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=btrfs
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=conntrack
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=cpu
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=cpufreq
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=diskstats
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=dmi
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=edac
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=entropy
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=fibrechannel
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=filefd
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=filesystem
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=hwmon
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=infiniband
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=ipvs
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=loadavg
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=mdadm
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=meminfo
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=netclass
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=netdev
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=netstat
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=nfs
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=nfsd
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=nvme
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=os
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=powersupplyclass
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=pressure
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=rapl
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=schedstat
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=selinux
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=sockstat
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=softnet
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=stat
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=tapestats
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=textfile
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=thermal_zone
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=time
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=timex
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=udp_queues
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=uname
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=vmstat
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=xfs
ts=2023-03-17T08:29:01.783Z caller=node_exporter.go:117 level=info collector=zfs
ts=2023-03-17T08:29:01.784Z caller=tls_config.go:232 level=info msg="Listening on" address=[::]:9100
ts=2023-03-17T08:29:01.784Z caller=tls_config.go:235 level=info msg="TLS is disabled." http2=false address=[::]:9100
```

![](/images/prometheus-grafana-quick-start/2023-03-17-16-44-37.png)

点击Metrics，看到下面的监控数据的页面

![](/images/prometheus-grafana-quick-start/2023-03-17-16-45-09.png)

> 若提示不可用，需要去服务器的防火墙开放9100的端口。下面的Prometheus，Grafana同理。

# 安装和配置Prometheus

https://prometheus.io/download/ 下载最新的稳定版的prometheus：

```bash
[root@centos9 ~]# wget https://github.com/prometheus/prometheus/releases/download/v2.42.0/prometheus-2.42.0.linux-amd64.tar.gz
--2023-03-17 16:25:02--  https://github.com/prometheus/prometheus/releases/download/v2.42.0/prometheus-2.42.0.linux-amd64.tar.gz
Resolving github.com (github.com)... 20.205.243.166
Connecting to github.com (github.com)|20.205.243.166|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://objects.githubusercontent.com/github-production-release-asset-2e65be/6838921/67c76e0b-84d6-4839-9b5a-0bffc648fab9?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20230317%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230317T082503Z&X-Amz-Expires=300&X-Amz-Signature=b5b88ec649010b7853e8e6694e7ba9a971002a860e2764718609b7dead0c0e5a&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=6838921&response-content-disposition=attachment%3B%20filename%3Dprometheus-2.42.0.linux-amd64.tar.gz&response-content-type=application%2Foctet-stream [following]
--2023-03-17 16:25:03--  https://objects.githubusercontent.com/github-production-release-asset-2e65be/6838921/67c76e0b-84d6-4839-9b5a-0bffc648fab9?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20230317%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230317T082503Z&X-Amz-Expires=300&X-Amz-Signature=b5b88ec649010b7853e8e6694e7ba9a971002a860e2764718609b7dead0c0e5a&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=6838921&response-content-disposition=attachment%3B%20filename%3Dprometheus-2.42.0.linux-amd64.tar.gz&response-content-type=application%2Foctet-stream
Resolving objects.githubusercontent.com (objects.githubusercontent.com)... 185.199.109.133
Connecting to objects.githubusercontent.com (objects.githubusercontent.com)|185.199.109.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 90588428 (86M) [application/octet-stream]
Saving to: ‘prometheus-2.42.0.linux-amd64.tar.gz’

prometheus-2.42.0.linux-amd64.tar.gz                         100%[===========================================================================================================================================>]  86.39M  10.8MB/s    in 8.2s

2023-03-17 16:25:12 (10.5 MB/s) - ‘prometheus-2.42.0.linux-amd64.tar.gz’ saved [90588428/90588428]

[root@centos9 ~]# tar xzvf prometheus-2.42.0.linux-amd64.tar.gz
prometheus-2.42.0.linux-amd64/
prometheus-2.42.0.linux-amd64/NOTICE
prometheus-2.42.0.linux-amd64/consoles/
prometheus-2.42.0.linux-amd64/consoles/index.html.example
prometheus-2.42.0.linux-amd64/consoles/node.html
prometheus-2.42.0.linux-amd64/consoles/prometheus-overview.html
prometheus-2.42.0.linux-amd64/consoles/node-disk.html
prometheus-2.42.0.linux-amd64/consoles/prometheus.html
prometheus-2.42.0.linux-amd64/consoles/node-overview.html
prometheus-2.42.0.linux-amd64/consoles/node-cpu.html
prometheus-2.42.0.linux-amd64/console_libraries/
prometheus-2.42.0.linux-amd64/console_libraries/menu.lib
prometheus-2.42.0.linux-amd64/console_libraries/prom.lib
prometheus-2.42.0.linux-amd64/prometheus.yml
prometheus-2.42.0.linux-amd64/LICENSE
prometheus-2.42.0.linux-amd64/promtool
prometheus-2.42.0.linux-amd64/prometheus
```

**配置Prometheus的数据源：scrape target**

```bash
[root@centos9 ~]# cd prometheus-2.42.0.linux-amd64/
[root@centos9 prometheus-2.42.0.linux-amd64]# cat prometheus.yml
# my global config
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["localhost:9090"]
```

参考 job_name: "prometheus" 新写一个job，用于获取node_exporter的地址的监控数据，如下：

```yaml
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["localhost:9090"]
  - job_name: "demo"
    static_configs:
      - targets: ["localhost:9100"]
```

启动Prometheus：

```bash
[root@centos9 prometheus-2.42.0.linux-amd64]# ./prometheus --config.file=prometheus.yml
ts=2023-03-17T08:54:20.390Z caller=main.go:512 level=info msg="No time or size retention was set so using the default time retention" duration=15d
ts=2023-03-17T08:54:20.390Z caller=main.go:556 level=info msg="Starting Prometheus Server" mode=server version="(version=2.42.0, branch=HEAD, revision=225c61122d88b01d1f0eaaee0e05b6f3e0567ac0)"
ts=2023-03-17T08:54:20.390Z caller=main.go:561 level=info build_context="(go=go1.19.5, platform=linux/amd64, user=root@c67d48967507, date=20230201-07:53:32)"
ts=2023-03-17T08:54:20.390Z caller=main.go:562 level=info host_details="(Linux 5.14.0-142.el9.x86_64 #1 SMP PREEMPT_DYNAMIC Thu Aug 4 18:15:17 UTC 2022 x86_64 centos9 (none))"
ts=2023-03-17T08:54:20.390Z caller=main.go:563 level=info fd_limits="(soft=524288, hard=524288)"
ts=2023-03-17T08:54:20.390Z caller=main.go:564 level=info vm_limits="(soft=unlimited, hard=unlimited)"
ts=2023-03-17T08:54:20.392Z caller=web.go:561 level=info component=web msg="Start listening for connections" address=0.0.0.0:9090
ts=2023-03-17T08:54:20.393Z caller=main.go:993 level=info msg="Starting TSDB ..."
ts=2023-03-17T08:54:20.394Z caller=tls_config.go:232 level=info component=web msg="Listening on" address=[::]:9090
ts=2023-03-17T08:54:20.394Z caller=tls_config.go:235 level=info component=web msg="TLS is disabled." http2=false address=[::]:9090
ts=2023-03-17T08:54:20.396Z caller=head.go:564 level=info component=tsdb msg="Replaying on-disk memory mappable chunks if any"
ts=2023-03-17T08:54:20.396Z caller=head.go:608 level=info component=tsdb msg="On-disk memory mappable chunks replay completed" duration=2.128µs
ts=2023-03-17T08:54:20.396Z caller=head.go:614 level=info component=tsdb msg="Replaying WAL, this may take a while"
ts=2023-03-17T08:54:20.396Z caller=head.go:685 level=info component=tsdb msg="WAL segment loaded" segment=0 maxSegment=0
ts=2023-03-17T08:54:20.396Z caller=head.go:722 level=info component=tsdb msg="WAL replay completed" checkpoint_replay_duration=22.831µs wal_replay_duration=172.681µs wbl_replay_duration=121ns total_replay_duration=214.751µs
ts=2023-03-17T08:54:20.397Z caller=main.go:1014 level=info fs_type=XFS_SUPER_MAGIC
ts=2023-03-17T08:54:20.397Z caller=main.go:1017 level=info msg="TSDB started"
ts=2023-03-17T08:54:20.397Z caller=main.go:1197 level=info msg="Loading configuration file" filename=prometheus.yml
ts=2023-03-17T08:54:20.406Z caller=main.go:1234 level=info msg="Completed loading of configuration file" filename=prometheus.yml totalDuration=9.414666ms db_storage=686ns remote_storage=1.021µs web_handler=331ns query_engine=750ns scrape=9.076288ms scrape_sd=49.95µs notify=25.901µs notify_sd=11.908µs rules=1.185µs tracing=4.397µs
ts=2023-03-17T08:54:20.406Z caller=main.go:978 level=info msg="Server is ready to receive web requests."
ts=2023-03-17T08:54:20.407Z caller=manager.go:974 level=info component="rule manager" msg="Starting rule manager..."
```

浏览器打开 `http://<deploy-ip>:9090`

![](/images/prometheus-grafana-quick-start/2023-03-17-17-01-15.png)

![](/images/prometheus-grafana-quick-start/2023-03-17-17-03-10.png)

![](/images/prometheus-grafana-quick-start/2023-03-17-17-03-35.png)

> demo http://localhost:9100/metrics 就是刚刚后加的。

# 安装和配置Grafana
## 安装Grafana

https://grafana.com/grafana/download 下载最新的稳定版的Grafana：

```bash
[root@centos9 ~]# wget https://dl.grafana.com/enterprise/release/grafana-enterprise-9.4.3-1.x86_64.rpm
--2023-03-17 17:08:49--  https://dl.grafana.com/enterprise/release/grafana-enterprise-9.4.3-1.x86_64.rpm
Resolving dl.grafana.com (dl.grafana.com)... 199.232.194.217
Connecting to dl.grafana.com (dl.grafana.com)|199.232.194.217|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 87999308 (84M) [application/octet-stream]
Saving to: ‘grafana-enterprise-9.4.3-1.x86_64.rpm’

grafana-enterprise-9.4.3-1.x86_64.rpm                        100%[===========================================================================================================================================>]  83.92M  90.9KB/s    in 10m 3s

2023-03-17 17:18:54 (143 KB/s) - ‘grafana-enterprise-9.4.3-1.x86_64.rpm’ saved [87999308/87999308]

[root@centos9 ~]# yum install grafana-enterprise-9.4.3-1.x86_64.rpm
Last metadata expiration check: 0:34:49 ago on Fri 17 Mar 2023 04:45:01 PM CST.
Dependencies resolved.
=================================================================================================================================================================================================================================================
 Package                                                          Architecture                                         Version                                                  Repository                                                  Size
=================================================================================================================================================================================================================================================
Installing:
 grafana-enterprise                                               x86_64                                               9.4.3-1                                                  @commandline                                                84 M
Installing dependencies:
 chkconfig                                                        x86_64                                               1.20-2.el9                                               baseos                                                     180 k

Transaction Summary
=================================================================================================================================================================================================================================================
Install  2 Packages

Total size: 84 M
Total download size: 180 k
Installed size: 309 M
Is this ok [y/N]: y
Downloading Packages:
chkconfig-1.20-2.el9.x86_64.rpm                                                                                                                                                                                   57 kB/s | 180 kB     00:03
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                                                                             42 kB/s | 180 kB     00:04
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                                                         1/1
  Installing       : chkconfig-1.20-2.el9.x86_64                                                                                                                                                                                             1/2
  Installing       : grafana-enterprise-9.4.3-1.x86_64                                                                                                                                                                                       2/2
  Running scriptlet: grafana-enterprise-9.4.3-1.x86_64                                                                                                                                                                                       2/2
### NOT starting on installation, please execute the following statements to configure grafana to start automatically using systemd
 sudo /bin/systemctl daemon-reload
 sudo /bin/systemctl enable grafana-server.service
### You can start grafana-server by executing
 sudo /bin/systemctl start grafana-server.service

POSTTRANS: Running script

  Verifying        : chkconfig-1.20-2.el9.x86_64                                                                                                                                                                                             1/2
  Verifying        : grafana-enterprise-9.4.3-1.x86_64                                                                                                                                                                                       2/2

Installed:
  chkconfig-1.20-2.el9.x86_64                                                                                          grafana-enterprise-9.4.3-1.x86_64

Complete!
[root@centos9 ~]# systemctl daemon-reload
[root@centos9 ~]# systemctl start grafana-server
[root@centos9 ~]# systemctl status grafana-server
● grafana-server.service - Grafana instance
     Loaded: loaded (/usr/lib/systemd/system/grafana-server.service; disabled; vendor preset: disabled)
     Active: active (running) since Fri 2023-03-17 17:26:01 CST; 4s ago
       Docs: http://docs.grafana.org
   Main PID: 36556 (grafana)
      Tasks: 9 (limit: 101761)
     Memory: 64.3M
        CPU: 1.714s
     CGroup: /system.slice/grafana-server.service
             └─36556 /usr/share/grafana/bin/grafana server --config=/etc/grafana/grafana.ini --pidfile=/var/run/grafana/grafana-server.pid --packaging=rpm cfg:default.paths.logs=/var/log/grafana cfg:default.paths.data=/var/lib/grafana cfg:d>

Mar 17 17:26:01 centos9 grafana[36556]: logger=provisioning.alerting t=2023-03-17T17:26:01.760020976+08:00 level=info msg="starting to provision alerting"
Mar 17 17:26:01 centos9 grafana[36556]: logger=provisioning.alerting t=2023-03-17T17:26:01.760063238+08:00 level=info msg="finished to provision alerting"
Mar 17 17:26:01 centos9 systemd[1]: Started Grafana instance.
Mar 17 17:26:01 centos9 grafana[36556]: logger=grafanaStorageLogger t=2023-03-17T17:26:01.760820463+08:00 level=info msg="storage starting"
Mar 17 17:26:01 centos9 grafana[36556]: logger=report t=2023-03-17T17:26:01.761097523+08:00 level=warn msg="Scheduling and sending of reports disabled, SMTP is not configured and enabled. Configure SMTP to enable."
Mar 17 17:26:01 centos9 grafana[36556]: logger=http.server t=2023-03-17T17:26:01.765396285+08:00 level=info msg="HTTP Server Listen" address=[::]:3000 protocol=http subUrl= socket=
Mar 17 17:26:01 centos9 grafana[36556]: logger=ngalert.state.manager t=2023-03-17T17:26:01.765507582+08:00 level=info msg="Warming state cache for startup"
Mar 17 17:26:01 centos9 grafana[36556]: logger=ngalert.state.manager t=2023-03-17T17:26:01.776842351+08:00 level=info msg="State cache has been initialized" states=0 duration=11.333187ms
Mar 17 17:26:01 centos9 grafana[36556]: logger=ticker t=2023-03-17T17:26:01.776927354+08:00 level=info msg=starting first_tick=2023-03-17T17:26:10+08:00
Mar 17 17:26:01 centos9 grafana[36556]: logger=ngalert.multiorg.alertmanager t=2023-03-17T17:26:01.776956052+08:00 level=info msg="starting MultiOrg Alertmanager"
[root@centos9 ~]# systemctl enable grafana-server
Synchronizing state of grafana-server.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install enable grafana-server
Created symlink /etc/systemd/system/multi-user.target.wants/grafana-server.service → /usr/lib/systemd/system/grafana-server.service.
```

![](/images/prometheus-grafana-quick-start/2023-03-17-17-27-31.png)

用户名和密码初始默认的是admin admin

![](/images/prometheus-grafana-quick-start/2023-03-17-17-30-48.png)

![](/images/prometheus-grafana-quick-start/2023-03-17-17-32-27.png)

## 配置Grafana的数据源

点击 配置 - Data Sources，选Prometheus。

![](/images/prometheus-grafana-quick-start/2023-03-17-17-33-12.png)

url就是上面的浏览器打开Prometheus的URL：

![](/images/prometheus-grafana-quick-start/2023-03-17-17-33-55.png)

## 配置Grafana的Dashboard

https://grafana.com/grafana/dashboards/

找评分好一点，下载多的，点进去

比如这个 https://grafana.com/grafana/dashboards/11074-node-exporter-for-prometheus-dashboard-en-v20201010/

![](/images/prometheus-grafana-quick-start/2023-03-17-17-38-30.png)

可以有三种方式load dashboard：从url或id或json文件

load dashboard后，界面如下：

![](/images/prometheus-grafana-quick-start/2023-03-17-17-44-10.png)

等待一段事件后，发现有了监控的看板有了实时的数据：

![](/images/prometheus-grafana-quick-start/2023-03-17-17-53-05.png)