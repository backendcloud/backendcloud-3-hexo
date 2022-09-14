---
title: jenkinsfile
readmore: true
date: 2022-09-09 14:13:57
categories:
tags:
---


Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock

[root@kubesphere ~]# usermod -a -G docker jenkins

2022-09-09-14-42-29.png


# 配置环境变量

```groovy
pipeline {
    agent any

    environment {
        DISABLE_AUTH = 'true'
        DB_ENGINE    = 'sqlite'
    }

    stages {
        stage('Build') {
            steps {
                sh 'printenv'
            }
        }
    }
}
```

# Jenkins 清理和通知

```groovy
pipeline {
    agent any
    stages {
        stage('No-op') {
            steps {
                sh 'ls'
            }
        }
    }
    post {
        always {
            echo 'One way or another, I have finished'
            deleteDir() /* clean up our workspace */
        }
        success {
            echo 'I succeeeded!'
        }
        unstable {
            echo 'I am unstable :/'
        }
        failure {
            echo 'I failed :('
        }
        changed {
            echo 'Things were different before...'
        }
    }
}
```