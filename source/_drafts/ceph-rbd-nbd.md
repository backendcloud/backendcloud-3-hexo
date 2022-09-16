---
title: Ceph cephadm 部署 以及 Ceph rbd-nbd 简单使用
readmore: true
date: 2022-09-15 18:33:08
categories: 云原生
tags:
- Ceph
- rbd-nbd
---

Ceph只有两种部署方式cephadm和Rook。本文采用cephadm部署。Rook部署参考文章：{% post_link rook-deploy %}

# 安装cephadm

centos7内核中没有drbd模块，可通过升级内核版本解决，升级完后需要重启。升级内核的步骤参考：{% post_link cilium-install %} 最后一个章节。

```bash
[root@centos7-ceph ~]# curl --silent --remote-name --location https://github.com/ceph/ceph/raw/quincy/src/cephadm/cephadm
[root@centos7-ceph ~]# chmod +x cephadm 
[root@centos7-ceph ~]# ./cephadm add-repo --release quincy
-bash: ./cephadm: /usr/bin/python3: bad interpreter: No such file or directory
[root@centos7-ceph ~]# ls
anaconda-ks.cfg  cephadm
[root@centos7-ceph ~]# ./cephadm add-repo --release quincy
-bash: ./cephadm: /usr/bin/python3: bad interpreter: No such file or directory
# cephadm 需要python3
[root@centos7-ceph ~]# yum install epel-replease
[root@centos7-ceph ~]# yum install python3
[root@centos7-ceph ~]# ./cephadm add-repo --release quincy
ERROR: Ceph does not support pacific or later for this version of this linux distro and therefore cannot add a repo for it
[root@centos7-ceph ~]# ./cephadm add-repo --release pacific
ERROR: Ceph does not support pacific or later for this version of this linux distro and therefore cannot add a repo for it
[root@centos7-ceph ~]# ./cephadm add-repo --release octopus
Writing repo to /etc/yum.repos.d/ceph.repo...
Enabling EPEL...
Completed adding repo.
[root@centos7-ceph ~]# ./cephadm install
Installing packages ['cephadm']...
Non-zero exit code 1 from yum install -y cephadm
yum: stdout Loaded plugins: fastestmirror
yum: stdout Loading mirror speeds from cached hostfile
yum: stdout  * base: mirror-hk.koddos.net
yum: stdout  * elrepo: mirror-hk.koddos.net
yum: stdout  * epel: mirror.lzu.edu.cn
yum: stdout  * extras: mirror-hk.koddos.net
yum: stdout  * updates: mirror-hk.koddos.net
yum: stdout Resolving Dependencies
yum: stdout --> Running transaction check
yum: stdout ---> Package cephadm.noarch 2:15.2.17-0.el7 will be installed
yum: stdout --> Finished Dependency Resolution
yum: stdout 
yum: stdout Dependencies Resolved
yum: stdout 
yum: stdout ================================================================================
yum: stdout  Package        Arch          Version                  Repository          Size
yum: stdout ================================================================================
yum: stdout Installing:
yum: stdout  cephadm        noarch        2:15.2.17-0.el7          Ceph-noarch         55 k
yum: stdout 
yum: stdout Transaction Summary
yum: stdout ================================================================================
yum: stdout Install  1 Package
yum: stdout 
yum: stdout Total download size: 55 k
yum: stdout Installed size: 223 k
yum: stdout Downloading packages:
yum: stdout Public key for cephadm-15.2.17-0.el7.noarch.rpm is not installed
yum: stdout Retrieving key from https://download.ceph.com/keys/release.gpg
yum: stderr warning: /var/cache/yum/x86_64/7/Ceph-noarch/packages/cephadm-15.2.17-0.el7.noarch.rpm: Header V4 RSA/SHA256 Signature, key ID 460f3994: NOKEY
yum: stderr 
yum: stderr 
yum: stderr Invalid GPG Key from https://download.ceph.com/keys/release.gpg: No key found in given key data
Traceback (most recent call last):
  File "./cephadm", line 9471, in <module>
    main()
  File "./cephadm", line 9459, in main
    r = ctx.func(ctx)
  File "./cephadm", line 7962, in command_install
    pkg.install(ctx.packages)
  File "./cephadm", line 7808, in install
    call_throws(self.ctx, [self.tool, 'install', '-y'] + ls)
  File "./cephadm", line 1788, in call_throws
    raise RuntimeError('Failed command: %s' % ' '.join(command))
RuntimeError: Failed command: yum install -y cephadm
# 报错是找不到gpg-key，去yum配置文件，将gpgcheck都disable掉。
[root@centos7-ceph ~]# vi /etc/yum.repos.d/ceph.repo 
[root@centos7-ceph ~]# ./cephadm install
Installing packages ['cephadm']...
[root@centos7-ceph ~]# which cephadm
/usr/sbin/cephadm
```

# 部署Ceph
```bash
[root@centos7-ceph ~]# cephadm bootstrap --mon-ip 192.168.190.137
Unable to locate any of ['podman', 'docker']
[root@centos7-ceph ~]# yum install -y docker
[root@centos7-ceph ~]# systemctl start docker
[root@centos7-ceph ~]# systemctl enable docker
Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
[root@centos7-ceph ~]# cephadm bootstrap --mon-ip 192.168.190.137
Creating directory /etc/ceph for ceph.conf
Verifying podman|docker is present...
Verifying lvm2 is present...
Verifying time synchronization is in place...
No time sync service is running; checked for ['chrony.service', 'chronyd.service', 'systemd-timesyncd.service', 'ntpd.service', 'ntp.service', 'ntpsec.service']
Installing packages ['chrony']...
Enabling unit chronyd.service
No time sync service is running; checked for ['chrony.service', 'chronyd.service', 'systemd-timesyncd.service', 'ntpd.service', 'ntp.service', 'ntpsec.service']
Repeating the final host check...
podman|docker (/usr/bin/docker) is present
systemctl is present
lvcreate is present
Unit chronyd.service is enabled and running
Host looks OK
Cluster fsid: 0f83d2c4-34d0-11ed-bc24-000c29395653
Verifying IP 192.168.190.137 port 3300 ...
Verifying IP 192.168.190.137 port 6789 ...
Mon IP 192.168.190.137 is in CIDR network 192.168.190.0/24
Pulling container image quay.io/ceph/ceph:v15...
Extracting ceph user uid/gid from container image...
Creating initial keys...
Creating initial monmap...
Creating mon...
firewalld ready
Enabling firewalld service ceph-mon in current zone...
Waiting for mon to start...
Waiting for mon...
mon is available
Assimilating anything we can from ceph.conf...
Generating new minimal ceph.conf...
Restarting the monitor...
Setting mon public_network...
Creating mgr...
Verifying port 9283 ...
firewalld ready
Enabling firewalld service ceph in current zone...
firewalld ready
Enabling firewalld port 9283/tcp in current zone...
Wrote keyring to /etc/ceph/ceph.client.admin.keyring
Wrote config to /etc/ceph/ceph.conf
Waiting for mgr to start...
Waiting for mgr...
mgr not available, waiting (1/10)...
mgr not available, waiting (2/10)...
mgr is available
Enabling cephadm module...
Waiting for the mgr to restart...
Waiting for Mgr epoch 4...
Mgr epoch 4 is available
Setting orchestrator backend to cephadm...
Generating ssh key...
Wrote public SSH key to to /etc/ceph/ceph.pub
Adding key to root@localhost's authorized_keys...
Adding host centos7-ceph...
Deploying mon service with default placement...
Deploying mgr service with default placement...
Deploying crash service with default placement...
Enabling mgr prometheus module...
Deploying prometheus service with default placement...
Deploying grafana service with default placement...
Deploying node-exporter service with default placement...
Deploying alertmanager service with default placement...
Enabling the dashboard module...
Waiting for the mgr to restart...
Waiting for Mgr epoch 12...
Mgr epoch 12 is available
Generating a dashboard self-signed certificate...
Creating initial admin user...
Fetching dashboard port number...
firewalld ready
Enabling firewalld port 8443/tcp in current zone...
Ceph Dashboard is now available at:

             URL: https://centos7-ceph:8443/
            User: admin
        Password: btfafhwcwl

You can access the Ceph CLI with:

        sudo /usr/sbin/cephadm shell --fsid 0f83d2c4-34d0-11ed-bc24-000c29395653 -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.admin.keyring

Please consider enabling telemetry to help improve Ceph:

        ceph telemetry on

For more information see:

        https://docs.ceph.com/docs/master/mgr/telemetry/

Bootstrap complete.
```

```bash
[root@centos7-ceph ~]# docker images
REPOSITORY                         TAG                 IMAGE ID            CREATED             SIZE
quay.io/ceph/ceph                  v15                 93146564743f        5 weeks ago         1.2 GB
quay.io/ceph/ceph-grafana          6.7.4               557c83e11646        13 months ago       486 MB
quay.io/prometheus/prometheus      v2.18.1             de242295e225        2 years ago         140 MB
quay.io/prometheus/alertmanager    v0.20.0             0881eb8f169f        2 years ago         52.1 MB
quay.io/prometheus/node-exporter   v0.18.1             e5a616e4b9cf        3 years ago         22.9 MB
[root@centos7-ceph ~]# docker ps
CONTAINER ID        IMAGE                                      COMMAND                  CREATED             STATUS              PORTS               NAMES
d15a9da77739        quay.io/ceph/ceph-grafana:6.7.4            "/bin/sh -c 'grafa..."   5 minutes ago       Up 5 minutes                            ceph-0f83d2c4-34d0-11ed-bc24-000c29395653-grafana.centos7-ceph
6c5964cf2ec1        quay.io/prometheus/alertmanager:v0.20.0    "/bin/alertmanager..."   5 minutes ago       Up 5 minutes                            ceph-0f83d2c4-34d0-11ed-bc24-000c29395653-alertmanager.centos7-ceph
caed7e3a45df        quay.io/prometheus/prometheus:v2.18.1      "/bin/prometheus -..."   6 minutes ago       Up 6 minutes                            ceph-0f83d2c4-34d0-11ed-bc24-000c29395653-prometheus.centos7-ceph
68b6d54b9bba        quay.io/prometheus/node-exporter:v0.18.1   "/bin/node_exporte..."   7 minutes ago       Up 7 minutes                            ceph-0f83d2c4-34d0-11ed-bc24-000c29395653-node-exporter.centos7-ceph
45e0fa29235c        quay.io/ceph/ceph:v15                      "/usr/bin/ceph-cra..."   10 minutes ago      Up 9 minutes                            ceph-0f83d2c4-34d0-11ed-bc24-000c29395653-crash.centos7-ceph
5e7dc2c50525        quay.io/ceph/ceph:v15                      "/usr/bin/ceph-mgr..."   11 minutes ago      Up 11 minutes                           ceph-0f83d2c4-34d0-11ed-bc24-000c29395653-mgr.centos7-ceph.dkxras
5e0c3934584c        quay.io/ceph/ceph:v15                      "/usr/bin/ceph-mon..."   11 minutes ago      Up 11 minutes                           ceph-0f83d2c4-34d0-11ed-bc24-000c29395653-mon.centos7-ceph
[root@centos7-ceph ~]# cephadm install ceph-common
Installing packages ['ceph-common']...
[root@centos7-ceph ~]# ceph -v
ceph version 15.2.17 (8a82819d84cf884bd39c17e3236e0632ac146dc4) octopus (stable)
[root@centos7-ceph ~]# ceph status
  cluster:
    id:     0f83d2c4-34d0-11ed-bc24-000c29395653
    health: HEALTH_WARN
            OSD count 0 < osd_pool_default_size 3
 
  services:
    mon: 1 daemons, quorum centos7-ceph (age 15m)
    mgr: centos7-ceph.dkxras(active, since 14m)
    osd: 0 osds: 0 up, 0 in
 
  data:
    pools:   0 pools, 0 pgs
    objects: 0 objects, 0 B
    usage:   0 B used, 0 B / 0 B avail
    pgs:     
 
```

```bash

```
