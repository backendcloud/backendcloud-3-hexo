---
title: JDK bug - Encrypt Private Key failed  unrecognized algorithm name  PBEWithSHA1AndDESede
date: 2021-11-23 14:22:24
categories: java
tags:
- JDK
- bug
---

相同的代码从git仓库拉下来，有的机器运行报错，有的机器运行完全正常。查了下报错的地方在，为了开启https服务制作的私有证书的错误：


```java
Error starting ApplicationContext. To display the conditions report re-run your application with 'debug' enabled.
2021-11-10 09:55:47.873 [ERROR] [restartedMain] org.springframework.boot.SpringApplication - Application run failed
org.springframework.context.ApplicationContextException: Failed to start bean 'webServerStartStop'; nested exception is org.springframework.boot.web.server.WebServerException: Unable to start embedded Tomcat server
    at org.springframework.context.support.DefaultLifecycleProcessor.doStart(DefaultLifecycleProcessor.java:181)
    at org.springframework.context.support.DefaultLifecycleProcessor.access$200(DefaultLifecycleProcessor.java:54)
    at org.springframework.context.support.DefaultLifecycleProcessor$LifecycleGroup.start(DefaultLifecycleProcessor.java:356)
    at java.lang.Iterable.forEach(Iterable.java:75)
    at org.springframework.context.support.DefaultLifecycleProcessor.startBeans(DefaultLifecycleProcessor.java:155)
    at org.springframework.context.support.DefaultLifecycleProcessor.onRefresh(DefaultLifecycleProcessor.java:123)
    at org.springframework.context.support.AbstractApplicationContext.finishRefresh(AbstractApplicationContext.java:935)
    at org.springframework.context.support.AbstractApplicationContext.refresh(AbstractApplicationContext.java:586)
    at org.springframework.boot.web.servlet.context.ServletWebServerApplicationContext.refresh(ServletWebServerApplicationContext.java:145)
    at org.springframework.boot.SpringApplication.refresh(SpringApplication.java:758)
    at org.springframework.boot.SpringApplication.refreshContext(SpringApplication.java:438)
    at org.springframework.boot.SpringApplication.run(SpringApplication.java:337)
    at org.springframework.boot.SpringApplication.run(SpringApplication.java:1336)
    at org.springframework.boot.SpringApplication.run(SpringApplication.java:1325)
    at com.chinamobile.edge.cmp.api.WebApplication.main(WebApplication.java:15)
    at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
    at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
    at java.lang.reflect.Method.invoke(Method.java:498)
    at org.springframework.boot.devtools.restart.RestartLauncher.run(RestartLauncher.java:49)
Caused by: org.springframework.boot.web.server.WebServerException: Unable to start embedded Tomcat server
    at org.springframework.boot.web.embedded.tomcat.TomcatWebServer.start(TomcatWebServer.java:229)
    at org.springframework.boot.web.servlet.context.WebServerStartStopLifecycle.start(WebServerStartStopLifecycle.java:43)
    at org.springframework.context.support.DefaultLifecycleProcessor.doStart(DefaultLifecycleProcessor.java:178)
    ... 19 common frames omitted
Caused by: java.lang.IllegalArgumentException: standardService.connector.startFailed
    at org.apache.catalina.core.StandardService.addConnector(StandardService.java:243)
    at org.springframework.boot.web.embedded.tomcat.TomcatWebServer.addPreviouslyRemovedConnectors(TomcatWebServer.java:282)
    at org.springframework.boot.web.embedded.tomcat.TomcatWebServer.start(TomcatWebServer.java:213)
    ... 21 common frames omitted
Caused by: org.apache.catalina.LifecycleException: Protocol handler start failed
    at org.apache.catalina.connector.Connector.startInternal(Connector.java:1075)
    at org.apache.catalina.util.LifecycleBase.start(LifecycleBase.java:183)
    at org.apache.catalina.core.StandardService.addConnector(StandardService.java:239)
    ... 23 common frames omitted
Caused by: java.lang.IllegalArgumentException: Key protection  algorithm not found: java.security.UnrecoverableKeyException: Encrypt Private Key failed: unrecognized algorithm name: PBEWithSHA1AndDESede
    at org.apache.tomcat.util.net.AbstractJsseEndpoint.createSSLContext(AbstractJsseEndpoint.java:99)
    at org.apache.tomcat.util.net.AbstractJsseEndpoint.initialiseSsl(AbstractJsseEndpoint.java:71)
    at org.apache.tomcat.util.net.NioEndpoint.bind(NioEndpoint.java:258)
    at org.apache.tomcat.util.net.AbstractEndpoint.bindWithCleanup(AbstractEndpoint.java:1204)
    at org.apache.tomcat.util.net.AbstractEndpoint.start(AbstractEndpoint.java:1290)
    at org.apache.coyote.AbstractProtocol.start(AbstractProtocol.java:614)
    at org.apache.catalina.connector.Connector.startInternal(Connector.java:1072)
    ... 25 common frames omitted
Caused by: java.security.KeyStoreException: Key protection  algorithm not found: java.security.UnrecoverableKeyException: Encrypt Private Key failed: unrecognized algorithm name: PBEWithSHA1AndDESede
    at sun.security.pkcs12.PKCS12KeyStore.setKeyEntry(PKCS12KeyStore.java:694)
    at sun.security.pkcs12.PKCS12KeyStore.engineSetKeyEntry(PKCS12KeyStore.java:594)
    at java.security.KeyStore.setKeyEntry(KeyStore.java:1140)
    at org.apache.tomcat.util.net.SSLUtilBase.getKeyManagers(SSLUtilBase.java:365)
    at org.apache.tomcat.util.net.SSLUtilBase.createSSLContext(SSLUtilBase.java:246)
    at org.apache.tomcat.util.net.AbstractJsseEndpoint.createSSLContext(AbstractJsseEndpoint.java:97)
    ... 31 common frames omitted
Caused by: java.security.UnrecoverableKeyException: Encrypt Private Key failed: unrecognized algorithm name: PBEWithSHA1AndDESede
    at sun.security.pkcs12.PKCS12KeyStore.encryptPrivateKey(PKCS12KeyStore.java:938)
    at sun.security.pkcs12.PKCS12KeyStore.setKeyEntry(PKCS12KeyStore.java:631)
    ... 36 common frames omitted
Caused by: java.security.NoSuchAlgorithmException: unrecognized algorithm name: PBEWithSHA1AndDESede
    at sun.security.x509.AlgorithmId.get(AlgorithmId.java:448)
    at sun.security.pkcs12.PKCS12KeyStore.mapPBEAlgorithmToOID(PKCS12KeyStore.java:955)
    at sun.security.pkcs12.PKCS12KeyStore.encryptPrivateKey(PKCS12KeyStore.java:912)
    ... 37 common frames omitted
```

查了下，是jdk 292版本的一个bug。回退到老版本或者升级到新版本即可。
    Oracle JDK 8u291: Passed. 
    Open JDK 8u282: Passed. 
    Open JDK 8u292: Failed, KeyStoreException thrown.
    OpenJDK 8u302-b04 Passed.
> https://bugs.openjdk.java.net/browse/JDK-8266261
> https://bugs.openjdk.java.net/browse/JDK-8242565




升级了JDK的版本，版本从292升级到312后，一切正常。

```bash
hanwei@hanweideMacBook-Air tt]$ java -version
openjdk version "1.8.0_292"
OpenJDK Runtime Environment (Zulu 8.54.0.21-CA-macos-aarch64) (build 1.8.0_292-b10)
OpenJDK 64-Bit Server VM (Zulu 8.54.0.21-CA-macos-aarch64) (build 25.292-b10, mixed mode)
hanwei@hanweideMacBook-Air tt]$ java -version
openjdk version "1.8.0_312"
OpenJDK Runtime Environment (Zulu 8.58.0.13-CA-macos-aarch64) (build 1.8.0_312-b07)
OpenJDK 64-Bit Server VM (Zulu 8.58.0.13-CA-macos-aarch64) (build 25.312-b07, mixed mode)
```
