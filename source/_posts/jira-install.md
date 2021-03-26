title: JIRA安装
date: 2017-06-27 01:53:54
categories:
- 敏捷
tags:
- JIRA
---

※仅用于个人研究和学习，不可用于商业用途

## 必要的环境
Linux下安装tomcat环境和jdk环境

## 建立两个目录
mkdir –p /home/jira
mkdir –p /home/jira_home
不能用相同目录，必须两个目录

## 复制文件
百度云网盘地址http://pan.baidu.com/s/1eQgTYKE下载atlassian-jira-6.3.6.tar.gz
http://download.csdn.net/detail/mchdba/7950429下载atlassian-extras-2.2.2.jar

将atlassian-jira-6.3.6.tar.gz复制到/home/jira 安装目录并解压
atlassian-extras-2.2.2.jar复制到安装目录的\atlassian-jira\WEB-INF\lib

## jira端口设置
jira默认使用8080，检查端口是否被占用

[root@name01 conf]# lsof -i:8080

若要修改端口，修改配置文件
    # vim /home/jira/atlassian-jira-6.3.6-standalone/conf/server.xml
大约第49行

## 配置jira_home 
    # vim /home/jira/atlassian-jira-6.3.6-standalone/atlassian-jira/WEB-INF/classes/jira-application.properties
编辑
    jira.home = /home/jira_home

## 启动jira
    # /home/jira/atlassian-jira-6.3.6-standalone/bin/start-jira.sh

## 安装
浏览器打开网址（注意端口号），一步步安装
选择jira，下面两个：jira agile，jira service desk不要选择

## 输入licence key

```
Description=JIRA: Commercial,
CreationDate=2014-09-20,
jira.LicenseEdition=ENTERPRISE,
Evaluation=false,
jira.LicenseTypeName=COMMERCIAL,
jira.active=true,
licenseVersion=2,
MaintenanceExpiryDate=2099-12-31,
Organisation=pl,
SEN=SEN-L4572887,
ServerID=BPT3-4QRK-FCRR-HEP3,
jira.NumberOfUsers=-1,
LicenseID=AAABBw0ODAoPeNptkFtLxDAQhd/zKwI+R9Kwy66FPKxthGhvtF0p4kuso0a6sUwvuP/edissyj4MD
HPOfHOYqzu0tICWeoJy4a+FzzkNwpIK7q1ICF2Ntu3tl5P3Ot89+1SNphnMPCEBwqkJTQ9y9jN+w
zxBPi2a68jW4DpQr/a0rZJS5VmuC0XOBNnjAH/s5bGFxBxABmkcqzzQu2jRTd3bEZaFZvE+AnYzR
JDYWNeDM64G9d1aPJ4TeXxOlOK7cbZbjrbNgkyGwwtg+rbvJpBkHikAR0Adytt0XzFV7R5Y+qQzV
kWZIoVK5FQsWq03YrvdkN/Ekz3S4SXlcpRswPrDdPD/aT+P1nzDMC0CFQCM9+0LlHVNnZQnSTwuR
O3eK+2gVgIUCteTs4Q3khIgrnsY64hxYB/d8bM=X02dh,
LicenseExpiryDate=2099-12-31,
PurchaseDate=2014-09-20
```

## 安装完成，确认licence
在 管理-》通用设置 -》授权信息
若时间不是2099-12-30就再把上面的信息再填一遍

