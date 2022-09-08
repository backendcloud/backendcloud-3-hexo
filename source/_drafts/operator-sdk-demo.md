---
title: Operator SDK
readmore: true
date: 2022-09-05 18:23:07
categories: 云原生
tags:
- Operator SDK
---

# Operator SDK 和 Kubebuilder 对比

这两个项目有一定的重合，重合部分已经合并。参考：

```bash
import java.text.SimpleDateFormat
    dateformat = new SimpleDateFormat("yyyyMMddHHmmss")
    def time = dateformat.format(new Date())
    def label = "jenkins-slave-${UUID.randomUUID().toString()}"
    def images = []
    def namespace = "49099d38-6b42-4f98-b872-cc91c87b16f4"
    def scmproject = "ceph-csi"
    def buildNum = BUILD_NUMBER
    def pipelineName = "ceph-csi"
    podTemplate(label: label, cloud:"kubernetes", nodeSelector:"jenkins-slave=true",containers: [
    containerTemplate(
    name: 'jnlp',
    image: 'registry.paas/cmss/jnlp-slave:3.10-1-alpine',
    args: '${computer.jnlpmac} ${computer.name}'),
      containerTemplate(
   name: 'golang-1-17',
   image: 'registry.paas/cmss/glong:ceph-csi',
   command: 'cat',
   ttyEnabled: true),
   containerTemplate(
   name: 'harbor',
   image: 'registry.paas/cmss/harbor:v0.3',
   command: 'cat',
   ttyEnabled: true),
   containerTemplate(
   name: 'gotest',
   image: 'registry.paas/cmss/go-test:v0.1',
   command: 'cat',
   ttyEnabled: true),
   containerTemplate(
    name: 'sonar',
    image: 'registry.paas/cmss/sonar:v0.5',
    command: 'cat',
    ttyEnabled: true),
    
 ],
volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
  hostPathVolume(mountPath: '/root/.m2/', hostPath: '/dcos/maven/.m2/'),
  hostPathVolume(mountPath: '/etc/hosts', hostPath: '/etc/hosts'),
  hostPathVolume(mountPath: '/root/.gradle', hostPath: '/dcos/gradle/.gradle')
]) {
    node(label) {
                stage("CodePull"){
                           git branch: '${BRANCH}',credentialsId: 'gerrit-code-clone', url: 'http://gerrit.cmss.com/a/EKI/ceph_csi'
                           env.shortCommit = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
                           env.gitUrl = sh(returnStdout: true, script: 'git config remote.origin.url').trim()
                           env.branch = sh(returnStdout: true, script: "git rev-parse --abbrev-ref HEAD").trim()
                           env.commitMessage = sh(returnStdout: true, script: "git log --oneline --format=%B -n 1 HEAD").trim()
                           sh """
                           mkdir ${namespace}-${scmproject}
                           mv `ls -1 | grep -v ${namespace}-${scmproject}` ${namespace}-${scmproject}
                           mv ${namespace}-${scmproject} ${scmproject}
                           ls -l
                           pwd
                           """
                       }
                
      stage("CodeBuild"){
                              container('golang-1-17'){
                                 sh """
                                    pwd
                                    cd ${scmproject}
                                    mkdir -p /go/src/github.com/ceph/
                                    mv ceph-csi /go/src/github.com/ceph/
                                    cd /go/src/github.com/ceph/ceph-csi
                                    ls -l
                                    chmod +x build.env
                                    chmod +x ./scripts/check-env.sh
                                    export GOPROXY=https://goproxy.cn
                                    make cephcsi
                                    cd /
                                    mv go /home/jenkins/agent/workspace/eki-ceph-csi/${scmproject}/
                                  """
                              }

                          }
    stage("ArtifactPush"){
                              container('harbor') {
                              images.add('10.160.22.6:8005/eki-ceph-csi:${VERSION}')
                              if(!scmproject){
                                  scmproject = sh(returnStdout: true, script: "ls -1").trim()
                              }
                              withCredentials([usernamePassword(credentialsId: 'docker-login-creds', usernameVariable: 'username',passwordVariable: 'password')]){
                              if(env.shortCommit){
                              sh """
                                  cd ${scmproject}
                                  pwd
                                  ls -l
                                  
                                  mv go /go
                                  
                                  cd /go/src/github.com/ceph/ceph-csi/
                                  
                                  ls -l
                                  
                                  
                                  docker login -u $username -p $password 10.160.22.6:8005
                                  
                                  sleep 3
                                  
                                  chmod +x build.env

                                 make eki
                                 
                                 docker tag  quay.io/cephcsi/cephcsi:v3.6-canary 10.160.22.6:8005/eki-ceph-csi:${BUILD_SEQ}
                                      
                                 docker push 10.160.22.6:8005/eki-ceph-csi:${BUILD_SEQ}
                                       
                                 docker logout 10.160.22.6:8005
                              """
                          }
                      }
                         }
                  }
     

}}
```