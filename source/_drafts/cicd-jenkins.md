---
title: CICD之Docker安装Jenkins
date: 2021-12-03 16:29:07
categories:
tags:
---


# Docker安装Jenkins

	# docker pull jenkins/jenkins:lts
	# mkdir /data/jenkins_home
	# chown -R 1000:1000 /data/jenkins_home
	# docker run -d --name jenkins -p 33044:8080 -v /data/jenkins_home:/var/jenkins_home jenkins/jenkins:lts
	# cat /data/jenkins_home/secrets/initialAdminPassword 
	8fd5f6a62kwa4993a2fc76b120becbd7



![](/images/cicd-jenkins/image-20211203160457116.png)

使用上条命令的 `8fd5f6a62kwa4993a2fc76b120becbd7` 登录，安装常用插件或自定义插件

![](/images/cicd-jenkins/image-20211203160709642.png)

等待Jenkins插件更新完成。

![](/images/cicd-jenkins/image-20211203160732723.png)

![](/images/cicd-jenkins/image-20211203160950616.png)

创建第一个用户管理员用户，同时，密码 `8fd5f6a62kwa4993a2fc76b120becbd7` 失效。

![](/images/cicd-jenkins/image-20211203161245849.png)

![](/images/cicd-jenkins/image-20211203161356068.png)

Jenkins部署完成。

![](/images/cicd-jenkins/image-20211203161413551.png)

有了Jenkins，接下来就是代码的自动部署过程了。



