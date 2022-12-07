---
title: 云原生时代的Spring Boot 3.0 - GraalVM原生镜像，启动速度提升近30倍
readmore: false
date: 2022-11-29 12:33:44
categories: 云原生
tags:
- Spring Boot 3
---


Spring Boot 3.0 五天前（2022年11月24日）发布了，变化很大，基于spring6.0，spring6.0是Spring下一个未来十年的新开端。


# JAVA 17

Spring Boot 3.0 版本最低支持 Java17，Springboot 2.7.3 最常用的jdk版本是Java 8，现在直接跳了9个版本直接从8跳到了17，且是强制要求，必须17或17以上的java版本。所以以后开发可以用上17或17以上的Java语言的新特性。


# Spring Native

Spring Native 也是升级的一个重大特性，支持使用 GraalVM 将 Spring 的应用程序编译成本地可执行的镜像文件，可以显著提升启动速度、峰值性能以及减少内存使用。

我们传统的应用都是编译成字节码，然后通过 JVM 解释并最终编译成机器码来运行，而 Spring Native 则是通过 AOT 提前编译为机器码，在运行时直接静态编译成可执行文件，不依赖 JVM。

![](/images/springboot3/1.jpg)

# Jakarta EE

JavaEE 改名之后就叫 JakartaEE，比如我们之前的javax.servlet包现在就叫jakarta.servlet。也因此，代码中所有使用到比如 HttpServletRequest 对象的 import 都需要修改。

```java
import javax.servlet.http.HttpServletRequest;
// 改为
import jakarta.servlet.http.HttpServletRequest;
```

# Spring Boot 3.0 初步使用（Windows）

创建Spring Boot 3.0 项目有两种方式，一种是Idea直接创建。

![](/images/springboot3/2022-11-29-09-17-59.png)

![](/images/springboot3/2022-11-29-09-18-17.png)

若IDE不是最新版本，不支持创建Spring Boot 3.0，还有第二种方式创建Spring Boot 3.0项目，登录官网 https://start.spring.io/ 生成 Spring Boot 3.0 初始项目。

![](/images/springboot3/2022-11-29-09-14-43.png)

下面是Spring Boot 3.0 的最小pom文件内容：

```XML
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>3.0.0</version>
		<relativePath/> <!-- lookup parent from repository -->
	</parent>
	<groupId>com.example</groupId>
	<artifactId>demo</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<name>demo</name>
	<description>Demo project for Spring Boot</description>
	<properties>
		<java.version>17</java.version>
	</properties>
	<dependencies>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter</artifactId>
		</dependency>

		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-test</artifactId>
			<scope>test</scope>
		</dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <version>3.0.0</version>
            <scope>compile</scope>
        </dependency>
    </dependencies>

	<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
			</plugin>
		</plugins>
	</build>

</project>
```

运行spring boot项目，需要安装开发环境，spring boot 3.0开始不用jdk了，取而代之的是graalvm，且最低版本要求是java17 graalvm版本。

https://github.com/graalvm/graalvm-ce-builds/releases 下载对应操作系统的java17 graalvm版本。

```bash
PS C:\Users\hanwei> java --version
openjdk 17.0.5 2022-10-18
OpenJDK Runtime Environment GraalVM CE 22.3.0 (build 17.0.5+8-jvmci-22.3-b08)
OpenJDK 64-Bit Server VM GraalVM CE 22.3.0 (build 17.0.5+8-jvmci-22.3-b08, mixed mode, sharing)
```

在最小 Spring Boot 项目源码的基础上了个简单的controller。

![](/images/springboot3/2022-11-28-16-35-09.png)

```java
package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class QuickStartController {
    @RequestMapping("/test")
    @ResponseBody
    public String test(){
        return "springboot 3.0 访问测试";
    }

    @RequestMapping("/hello")
    @ResponseBody
    public String home(){
        return "Hello World from springboot 3.0!";
    }
}
```

用java17 graalvm编译运行demo项目。

```bash
C:\sdk\graalvm-ce-java17-22.3.0\bin\java.exe -XX:TieredStopAtLevel=1 -Dspring.output.ansi.enabled=always -Dcom.sun.management.jmxremote -Dspring.jmx.enabled=true -Dspring.liveBeansView.mbeanDomain -Dspring.application.admin.enabled=true "-javaagent:C:\Program Files\JetBrains\IntelliJ IDEA 2022.2\lib\idea_rt.jar=9872:C:\Program Files\JetBrains\IntelliJ IDEA 2022.2\bin" -Dfile.encoding=UTF-8 -classpath C:\Users\hanwei\Documents\JavaProject\demo-maven\target\classes;C:\Users\hanwei\.m2\repository\org\springframework\boot\spring-boot-starter\3.0.0\spring-boot-starter-3.0.0.jar;C:\Users\hanwei\.m2\repository\org\springframework\boot\spring-boot\3.0.0\spring-boot-3.0.0.jar;C:\Users\hanwei\.m2\repository\org\springframework\spring-context\6.0.2\spring-context-6.0.2.jar;C:\Users\hanwei\.m2\repository\org\springframework\boot\spring-boot-autoconfigure\3.0.0\spring-boot-autoconfigure-3.0.0.jar;C:\Users\hanwei\.m2\repository\org\springframework\boot\spring-boot-starter-logging\3.0.0\spring-boot-starter-logging-3.0.0.jar;C:\Users\hanwei\.m2\repository\ch\qos\logback\logback-classic\1.4.5\logback-classic-1.4.5.jar;C:\Users\hanwei\.m2\repository\ch\qos\logback\logback-core\1.4.5\logback-core-1.4.5.jar;C:\Users\hanwei\.m2\repository\org\apache\logging\log4j\log4j-to-slf4j\2.19.0\log4j-to-slf4j-2.19.0.jar;C:\Users\hanwei\.m2\repository\org\apache\logging\log4j\log4j-api\2.19.0\log4j-api-2.19.0.jar;C:\Users\hanwei\.m2\repository\org\slf4j\jul-to-slf4j\2.0.4\jul-to-slf4j-2.0.4.jar;C:\Users\hanwei\.m2\repository\jakarta\annotation\jakarta.annotation-api\2.1.1\jakarta.annotation-api-2.1.1.jar;C:\Users\hanwei\.m2\repository\org\springframework\spring-core\6.0.2\spring-core-6.0.2.jar;C:\Users\hanwei\.m2\repository\org\springframework\spring-jcl\6.0.2\spring-jcl-6.0.2.jar;C:\Users\hanwei\.m2\repository\org\yaml\snakeyaml\1.33\snakeyaml-1.33.jar;C:\Users\hanwei\.m2\repository\org\slf4j\slf4j-api\2.0.4\slf4j-api-2.0.4.jar;C:\Users\hanwei\.m2\repository\org\springframework\boot\spring-boot-starter-web\3.0.0\spring-boot-starter-web-3.0.0.jar;C:\Users\hanwei\.m2\repository\org\springframework\boot\spring-boot-starter-json\3.0.0\spring-boot-starter-json-3.0.0.jar;C:\Users\hanwei\.m2\repository\com\fasterxml\jackson\core\jackson-databind\2.14.1\jackson-databind-2.14.1.jar;C:\Users\hanwei\.m2\repository\com\fasterxml\jackson\core\jackson-annotations\2.14.1\jackson-annotations-2.14.1.jar;C:\Users\hanwei\.m2\repository\com\fasterxml\jackson\core\jackson-core\2.14.1\jackson-core-2.14.1.jar;C:\Users\hanwei\.m2\repository\com\fasterxml\jackson\datatype\jackson-datatype-jdk8\2.14.1\jackson-datatype-jdk8-2.14.1.jar;C:\Users\hanwei\.m2\repository\com\fasterxml\jackson\datatype\jackson-datatype-jsr310\2.14.1\jackson-datatype-jsr310-2.14.1.jar;C:\Users\hanwei\.m2\repository\com\fasterxml\jackson\module\jackson-module-parameter-names\2.14.1\jackson-module-parameter-names-2.14.1.jar;C:\Users\hanwei\.m2\repository\org\springframework\boot\spring-boot-starter-tomcat\3.0.0\spring-boot-starter-tomcat-3.0.0.jar;C:\Users\hanwei\.m2\repository\org\apache\tomcat\embed\tomcat-embed-core\10.1.1\tomcat-embed-core-10.1.1.jar;C:\Users\hanwei\.m2\repository\org\apache\tomcat\embed\tomcat-embed-el\10.1.1\tomcat-embed-el-10.1.1.jar;C:\Users\hanwei\.m2\repository\org\apache\tomcat\embed\tomcat-embed-websocket\10.1.1\tomcat-embed-websocket-10.1.1.jar;C:\Users\hanwei\.m2\repository\org\springframework\spring-web\6.0.2\spring-web-6.0.2.jar;C:\Users\hanwei\.m2\repository\org\springframework\spring-beans\6.0.2\spring-beans-6.0.2.jar;C:\Users\hanwei\.m2\repository\io\micrometer\micrometer-observation\1.10.2\micrometer-observation-1.10.2.jar;C:\Users\hanwei\.m2\repository\io\micrometer\micrometer-commons\1.10.2\micrometer-commons-1.10.2.jar;C:\Users\hanwei\.m2\repository\org\springframework\spring-webmvc\6.0.2\spring-webmvc-6.0.2.jar;C:\Users\hanwei\.m2\repository\org\springframework\spring-aop\6.0.2\spring-aop-6.0.2.jar;C:\Users\hanwei\.m2\repository\org\springframework\spring-expression\6.0.2\spring-expression-6.0.2.jar com.example.demo.DemoApplication

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.0.0)

2022-11-29T10:19:58.816+08:00  INFO 20116 --- [           main] com.example.demo.DemoApplication         : Starting DemoApplication using Java 17.0.5 with PID 20116 (C:\Users\hanwei\Documents\JavaProject\demo-maven\target\classes started by hanwei in C:\Users\hanwei\Documents\JavaProject\demo-maven)
2022-11-29T10:19:58.818+08:00  INFO 20116 --- [           main] com.example.demo.DemoApplication         : No active profile set, falling back to 1 default profile: "default"
2022-11-29T10:19:59.501+08:00  INFO 20116 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2022-11-29T10:19:59.510+08:00  INFO 20116 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2022-11-29T10:19:59.510+08:00  INFO 20116 --- [           main] o.apache.catalina.core.StandardEngine    : Starting Servlet engine: [Apache Tomcat/10.1.1]
2022-11-29T10:19:59.594+08:00  INFO 20116 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2022-11-29T10:19:59.594+08:00  INFO 20116 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 737 ms
2022-11-29T10:19:59.866+08:00  INFO 20116 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2022-11-29T10:19:59.872+08:00  INFO 20116 --- [           main] com.example.demo.DemoApplication         : Started DemoApplication in 1.386 seconds (process running for 2.036)
```





rest api测试ok。

![](/images/springboot3/2022-11-28-17-18-57.png)

```bash
http://localhost:8080/hello

HTTP/1.1 200 
Content-Type: text/plain;charset=UTF-8
Content-Length: 32
Date: Mon, 28 Nov 2022 08:31:59 GMT
Keep-Alive: timeout=60
Connection: keep-alive

Hello World from springboot 3.0!

Response code: 200; Time: 175ms (175 ms); Content length: 32 bytes (32 B)
```

```bash
http://localhost:8080/test

HTTP/1.1 200 
Content-Type: text/plain;charset=UTF-8
Content-Length: 27
Date: Mon, 28 Nov 2022 08:32:05 GMT
Keep-Alive: timeout=60
Connection: keep-alive

springboot 3.0 访问测试

Response code: 200; Time: 17ms (17 ms); Content length: 19 bytes (19 B)
```

打包二进制可执行文件需要安装 native-image ， 执行 gu install native-image 命令。

打包二进制可执行文件，执行出错：

![](/images/springboot3/2022-11-29-09-11-08.png)

上面报错，因为需要安装windows docker。


官网下载安装windows dockerdesktop完成后。启动windows dockerdesktop报错（可能是因为 Windows 11 的默认网络配置被改了，正常不会报错，毕竟是很常用的工具）：

```bash
stderr: 
   在 Docker.ApiServices.WSL2.WslShortLivedCommandResult.LogAndThrowIfUnexpectedExitCode(String prefix, ILogger log, Int32 expectedExitCode) 位置 C:\workspaces\PR-19568\src\github.com\docker\pinata\win\src\Docker.ApiServices\WSL2\WslCommand.cs:行号 160
   在 Docker.Engines.WSL2.WSL2Provisioning.<ProvisionAsync>d__8.MoveNext() 位置 C:\workspaces\PR-19568\src\github.com\docker\pinata\win\src\Docker.Engines\WSL2\WSL2Provisioning.cs:行号 81
--- 引发异常的上一位置中堆栈跟踪的末尾 ---
   在 System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   在 System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   在 Docker.Engines.WSL2.LinuxWSL2Engine.<DoStartAsync>d__26.MoveNext() 位置 C:\workspaces\PR-19568\src\github.com\docker\pinata\win\src\Docker.Engines\WSL2\LinuxWSL2Engine.cs:行号 170
--- 引发异常的上一位置中堆栈跟踪的末尾 ---
   在 System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   在 System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   在 Docker.ApiServices.StateMachines.TaskExtensions.<WrapAsyncInCancellationException>d__0.MoveNext() 位置 C:\workspaces\PR-19568\src\github.com\docker\pinata\win\src\Docker.ApiServices\StateMachines\TaskExtensions.cs:行号 29
--- 引发异常的上一位置中堆栈跟踪的末尾 ---
   在 System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   在 System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   在 Docker.ApiServices.StateMachines.StartTransition.<DoRunAsync>d__5.MoveNext() 位置 C:\workspaces\PR-19568\src\github.com\docker\pinata\win\src\Docker.ApiServices\StateMachines\StartTransition.cs:行号 67
--- 引发异常的上一位置中堆栈跟踪的末尾 ---
   在 System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   在 Docker.ApiServices.StateMachines.StartTransition.<DoRunAsync>d__5.MoveNext() 位置 C:\workspaces\PR-19568\src\github.com\docker\pinata\win\src\Docker.ApiServices\StateMachines\StartTransition.cs:行号 92
--- 引发异常的上一位置中堆栈跟踪的末尾 ---
   在 System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   在 System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   在 Docker.ApiServices.StateMachines.EngineStateMachine.<StartAsync>d__14.MoveNext() 位置 C:\workspaces\PR-19568\src\github.com\docker\pinata\win\src\Docker.ApiServices\StateMachines\EngineStateMachine.cs:行号 69
--- 引发异常的上一位置中堆栈跟踪的末尾 ---
   在 System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   在 System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   在 Docker.Engines.Engines.<StartAsync>d__22.MoveNext() 位置 C:\workspaces\PR-19568\src\github.com\docker\pinata\win\src\Docker.Engines\Engines.cs:行号 106
```

在PowerShell（管理员模式）或者cmd（管理员模式）中执行 

```bash
netsh winsock reset
```

> 执行该命令后记得重启！

重启后，Windows 11下的dockerdesktop可以正常启动。

对于没有vmware需求，没有虚拟机vpn网络需求，仅仅开发springboot3.0，上面的方式已经可以实现目标。

不过若有VMware需求，以及有VMware虚拟机共享宿主机vpn网络的需求，上面的重置命令慎用，会导致VMware里运行的虚拟机使用宿主机vpn网络出现问题，网络不通。

并且由于windows下的dockerdesktop需要打开hyper-v或者WSL 2，一旦打开会影响VMware 嵌套虚拟化功能，导致VMware下虚拟机的嵌套虚拟化功能不可用。

不过也不用担心，只需要3步可以恢复：
1. 卸载windows dockerdesktop
2. 设置 - 应用 - 可选功能 - 更多windows功能，取消 WSL 2 和 hyper-v 的勾，重启电脑
3. 卸载wmware，重新安装wmware。

这种情况还是在沙盒环境里编译打包原生可执行文件，比如下面的用Linux环境。

# Spring Boot 3.0 初步使用（Linux）

上面windows跑通的项目源码直接放到Linux下，执行，报错：

```bash
[ERROR] Internal error: java.lang.RuntimeException: GraalVM native-image is missing from your system.
[ERROR]  Make sure that GRAALVM_HOME environment variable is present.
```

按报错信息，配置 GRAALVM_HOME 和 安装 GraalVM native-image。

```bash
export GRAALVM_HOME 到/etc/bashrc
```

```bash
[hanwei@backendcloud-centos9 ~]$ gu install native-image
Downloading: Component catalog from www.graalvm.org
Processing Component: Native Image
Downloading: Component native-image: Native Image from github.com
Installing new component: Native Image (org.graalvm.native-image, version 22.3.0)
```

再执行报错：

```bash
Test configuration file wasn't found.
```

toggle 'Skip Tests' mode，就是在Linux Idea的Maven窗口，点击跳过测试按钮。

再执行ok。

```bash
/home/hanwei/sdk/graalvm-ce-java17-22.3.0/bin/java -XX:TieredStopAtLevel=1 -Dspring.output.ansi.enabled=always -Dcom.sun.management.jmxremote -Dspring.jmx.enabled=true -Dspring.liveBeansView.mbeanDomain -Dspring.application.admin.enabled=true -javaagent:/home/hanwei/.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0/222.4459.24/lib/idea_rt.jar=41343:/home/hanwei/.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0/222.4459.24/bin -Dfile.encoding=UTF-8 -classpath /home/hanwei/demo/target/classes:/home/hanwei/.m2/repository/org/springframework/boot/spring-boot-starter/3.0.0/spring-boot-starter-3.0.0.jar:/home/hanwei/.m2/repository/org/springframework/boot/spring-boot/3.0.0/spring-boot-3.0.0.jar:/home/hanwei/.m2/repository/org/springframework/spring-context/6.0.2/spring-context-6.0.2.jar:/home/hanwei/.m2/repository/org/springframework/boot/spring-boot-autoconfigure/3.0.0/spring-boot-autoconfigure-3.0.0.jar:/home/hanwei/.m2/repository/org/springframework/boot/spring-boot-starter-logging/3.0.0/spring-boot-starter-logging-3.0.0.jar:/home/hanwei/.m2/repository/ch/qos/logback/logback-classic/1.4.5/logback-classic-1.4.5.jar:/home/hanwei/.m2/repository/ch/qos/logback/logback-core/1.4.5/logback-core-1.4.5.jar:/home/hanwei/.m2/repository/org/apache/logging/log4j/log4j-to-slf4j/2.19.0/log4j-to-slf4j-2.19.0.jar:/home/hanwei/.m2/repository/org/apache/logging/log4j/log4j-api/2.19.0/log4j-api-2.19.0.jar:/home/hanwei/.m2/repository/org/slf4j/jul-to-slf4j/2.0.4/jul-to-slf4j-2.0.4.jar:/home/hanwei/.m2/repository/jakarta/annotation/jakarta.annotation-api/2.1.1/jakarta.annotation-api-2.1.1.jar:/home/hanwei/.m2/repository/org/springframework/spring-core/6.0.2/spring-core-6.0.2.jar:/home/hanwei/.m2/repository/org/springframework/spring-jcl/6.0.2/spring-jcl-6.0.2.jar:/home/hanwei/.m2/repository/org/yaml/snakeyaml/1.33/snakeyaml-1.33.jar:/home/hanwei/.m2/repository/org/slf4j/slf4j-api/2.0.4/slf4j-api-2.0.4.jar:/home/hanwei/.m2/repository/org/springframework/boot/spring-boot-starter-web/3.0.0/spring-boot-starter-web-3.0.0.jar:/home/hanwei/.m2/repository/org/springframework/boot/spring-boot-starter-json/3.0.0/spring-boot-starter-json-3.0.0.jar:/home/hanwei/.m2/repository/com/fasterxml/jackson/core/jackson-databind/2.14.1/jackson-databind-2.14.1.jar:/home/hanwei/.m2/repository/com/fasterxml/jackson/core/jackson-annotations/2.14.1/jackson-annotations-2.14.1.jar:/home/hanwei/.m2/repository/com/fasterxml/jackson/core/jackson-core/2.14.1/jackson-core-2.14.1.jar:/home/hanwei/.m2/repository/com/fasterxml/jackson/datatype/jackson-datatype-jdk8/2.14.1/jackson-datatype-jdk8-2.14.1.jar:/home/hanwei/.m2/repository/com/fasterxml/jackson/datatype/jackson-datatype-jsr310/2.14.1/jackson-datatype-jsr310-2.14.1.jar:/home/hanwei/.m2/repository/com/fasterxml/jackson/module/jackson-module-parameter-names/2.14.1/jackson-module-parameter-names-2.14.1.jar:/home/hanwei/.m2/repository/org/springframework/boot/spring-boot-starter-tomcat/3.0.0/spring-boot-starter-tomcat-3.0.0.jar:/home/hanwei/.m2/repository/org/apache/tomcat/embed/tomcat-embed-core/10.1.1/tomcat-embed-core-10.1.1.jar:/home/hanwei/.m2/repository/org/apache/tomcat/embed/tomcat-embed-el/10.1.1/tomcat-embed-el-10.1.1.jar:/home/hanwei/.m2/repository/org/apache/tomcat/embed/tomcat-embed-websocket/10.1.1/tomcat-embed-websocket-10.1.1.jar:/home/hanwei/.m2/repository/org/springframework/spring-web/6.0.2/spring-web-6.0.2.jar:/home/hanwei/.m2/repository/org/springframework/spring-beans/6.0.2/spring-beans-6.0.2.jar:/home/hanwei/.m2/repository/io/micrometer/micrometer-observation/1.10.2/micrometer-observation-1.10.2.jar:/home/hanwei/.m2/repository/io/micrometer/micrometer-commons/1.10.2/micrometer-commons-1.10.2.jar:/home/hanwei/.m2/repository/org/springframework/spring-webmvc/6.0.2/spring-webmvc-6.0.2.jar:/home/hanwei/.m2/repository/org/springframework/spring-aop/6.0.2/spring-aop-6.0.2.jar:/home/hanwei/.m2/repository/org/springframework/spring-expression/6.0.2/spring-expression-6.0.2.jar com.example.demo.DemoApplication

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.0.0)

2022-11-29T00:02:01.348+08:00  INFO 11794 --- [           main] com.example.demo.DemoApplication         : Starting DemoApplication using Java 17.0.5 with PID 11794 (/home/hanwei/demo/target/classes started by hanwei in /home/hanwei/demo)
2022-11-29T00:02:01.352+08:00  INFO 11794 --- [           main] com.example.demo.DemoApplication         : No active profile set, falling back to 1 default profile: "default"
2022-11-29T00:02:02.011+08:00  INFO 11794 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2022-11-29T00:02:02.018+08:00  INFO 11794 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2022-11-29T00:02:02.018+08:00  INFO 11794 --- [           main] o.apache.catalina.core.StandardEngine    : Starting Servlet engine: [Apache Tomcat/10.1.1]
2022-11-29T00:02:02.089+08:00  INFO 11794 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2022-11-29T00:02:02.090+08:00  INFO 11794 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 687 ms
2022-11-29T00:02:02.347+08:00  INFO 11794 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2022-11-29T00:02:02.350+08:00  INFO 11794 --- [           main] com.example.demo.DemoApplication         : Started DemoApplication in 1.335 seconds (process running for 16.893)
```

可见执行传统jar包的启动速度是 1.335 seconds ，下面编译原生二进制文件。点击Linux Idea的Maven窗口的 build image 按钮。会在项目的target目录下（和生成的jar包在同一级目录）生成二进制可执行文件。

```bash
/home/hanwei/sdk/graalvm-ce-java17-22.3.0/bin/java -Dmaven.multiModuleProjectDirectory=/home/hanwei/demo -Dmaven.home=/home/hanwei/.m2/wrapper/dists/apache-maven-3.8.6-bin/1ks0nkde5v1pk9vtc31i9d0lcd/apache-maven-3.8.6 -Dclassworlds.conf=/home/hanwei/.m2/wrapper/dists/apache-maven-3.8.6-bin/1ks0nkde5v1pk9vtc31i9d0lcd/apache-maven-3.8.6/bin/m2.conf -Dmaven.ext.class.path=/home/hanwei/.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0/222.4459.24/plugins/maven/lib/maven-event-listener.jar -javaagent:/home/hanwei/.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0/222.4459.24/lib/idea_rt.jar=44943:/home/hanwei/.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0/222.4459.24/bin -Dfile.encoding=UTF-8 -classpath /home/hanwei/.m2/wrapper/dists/apache-maven-3.8.6-bin/1ks0nkde5v1pk9vtc31i9d0lcd/apache-maven-3.8.6/boot/plexus-classworlds.license:/home/hanwei/.m2/wrapper/dists/apache-maven-3.8.6-bin/1ks0nkde5v1pk9vtc31i9d0lcd/apache-maven-3.8.6/boot/plexus-classworlds-2.6.0.jar org.codehaus.classworlds.Launcher -Didea.version=2022.2.4 -DskipTests=true org.graalvm.buildtools:native-maven-plugin:0.9.16:build -P native
[INFO] Scanning for projects...
[INFO] 
[INFO] --------------------------< com.example:demo >--------------------------
[INFO] Building demo 0.0.1-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- native-maven-plugin:0.9.16:build (default-cli) @ demo ---
[WARNING] 'native:build' goal is deprecated. Use 'native:compile-no-fork' instead.
[INFO] Found GraalVM installation from GRAALVM_HOME variable.
[INFO] [graalvm reachability metadata repository for ch.qos.logback:logback-classic:1.4.5]: Configuration directory not found. Trying latest version.
[INFO] [graalvm reachability metadata repository for ch.qos.logback:logback-classic:1.4.5]: Configuration directory is ch.qos.logback/logback-classic/1.4.1
[INFO] [graalvm reachability metadata repository for org.apache.tomcat.embed:tomcat-embed-core:10.1.1]: Configuration directory not found. Trying latest version.
[INFO] [graalvm reachability metadata repository for org.apache.tomcat.embed:tomcat-embed-core:10.1.1]: Configuration directory is org.apache.tomcat.embed/tomcat-embed-core/10.0.20
[INFO] Executing: /home/hanwei/sdk/graalvm-ce-java17-22.3.0/bin/native-image -cp /home/hanwei/demo/target/classes:/home/hanwei/.m2/repository/org/slf4j/jul-to-slf4j/2.0.4/jul-to-slf4j-2.0.4.jar:/home/hanwei/.m2/repository/org/springframework/spring-web/6.0.2/spring-web-6.0.2.jar:/home/hanwei/.m2/repository/ch/qos/logback/logback-core/1.4.5/logback-core-1.4.5.jar:/home/hanwei/.m2/repository/jakarta/annotation/jakarta.annotation-api/2.1.1/jakarta.annotation-api-2.1.1.jar:/home/hanwei/.m2/repository/com/fasterxml/jackson/core/jackson-annotations/2.14.1/jackson-annotations-2.14.1.jar:/home/hanwei/.m2/repository/org/springframework/boot/spring-boot-starter-json/3.0.0/spring-boot-starter-json-3.0.0.jar:/home/hanwei/.m2/repository/org/springframework/spring-core/6.0.2/spring-core-6.0.2.jar:/home/hanwei/.m2/repository/com/fasterxml/jackson/module/jackson-module-parameter-names/2.14.1/jackson-module-parameter-names-2.14.1.jar:/home/hanwei/.m2/repository/org/apache/tomcat/embed/tomcat-embed-websocket/10.1.1/tomcat-embed-websocket-10.1.1.jar:/home/hanwei/.m2/repository/ch/qos/logback/logback-classic/1.4.5/logback-classic-1.4.5.jar:/home/hanwei/.m2/repository/org/springframework/spring-jcl/6.0.2/spring-jcl-6.0.2.jar:/home/hanwei/.m2/repository/org/springframework/boot/spring-boot-starter-web/3.0.0/spring-boot-starter-web-3.0.0.jar:/home/hanwei/.m2/repository/org/springframework/boot/spring-boot-autoconfigure/3.0.0/spring-boot-autoconfigure-3.0.0.jar:/home/hanwei/.m2/repository/org/springframework/spring-beans/6.0.2/spring-beans-6.0.2.jar:/home/hanwei/.m2/repository/org/springframework/boot/spring-boot-starter-tomcat/3.0.0/spring-boot-starter-tomcat-3.0.0.jar:/home/hanwei/.m2/repository/com/fasterxml/jackson/datatype/jackson-datatype-jsr310/2.14.1/jackson-datatype-jsr310-2.14.1.jar:/home/hanwei/.m2/repository/org/apache/tomcat/embed/tomcat-embed-el/10.1.1/tomcat-embed-el-10.1.1.jar:/home/hanwei/.m2/repository/com/fasterxml/jackson/core/jackson-core/2.14.1/jackson-core-2.14.1.jar:/home/hanwei/.m2/repository/org/apache/logging/log4j/log4j-api/2.19.0/log4j-api-2.19.0.jar:/home/hanwei/.m2/repository/org/springframework/spring-expression/6.0.2/spring-expression-6.0.2.jar:/home/hanwei/.m2/repository/org/springframework/spring-webmvc/6.0.2/spring-webmvc-6.0.2.jar:/home/hanwei/.m2/repository/org/springframework/boot/spring-boot/3.0.0/spring-boot-3.0.0.jar:/home/hanwei/.m2/repository/org/apache/tomcat/embed/tomcat-embed-core/10.1.1/tomcat-embed-core-10.1.1.jar:/home/hanwei/.m2/repository/org/springframework/spring-aop/6.0.2/spring-aop-6.0.2.jar:/home/hanwei/.m2/repository/org/apache/logging/log4j/log4j-to-slf4j/2.19.0/log4j-to-slf4j-2.19.0.jar:/home/hanwei/.m2/repository/org/springframework/boot/spring-boot-starter/3.0.0/spring-boot-starter-3.0.0.jar:/home/hanwei/.m2/repository/org/springframework/boot/spring-boot-starter-logging/3.0.0/spring-boot-starter-logging-3.0.0.jar:/home/hanwei/.m2/repository/org/slf4j/slf4j-api/2.0.4/slf4j-api-2.0.4.jar:/home/hanwei/.m2/repository/org/springframework/spring-context/6.0.2/spring-context-6.0.2.jar:/home/hanwei/.m2/repository/io/micrometer/micrometer-observation/1.10.2/micrometer-observation-1.10.2.jar:/home/hanwei/.m2/repository/org/yaml/snakeyaml/1.33/snakeyaml-1.33.jar:/home/hanwei/.m2/repository/com/fasterxml/jackson/core/jackson-databind/2.14.1/jackson-databind-2.14.1.jar:/home/hanwei/.m2/repository/com/fasterxml/jackson/datatype/jackson-datatype-jdk8/2.14.1/jackson-datatype-jdk8-2.14.1.jar:/home/hanwei/.m2/repository/io/micrometer/micrometer-commons/1.10.2/micrometer-commons-1.10.2.jar --no-fallback -H:Path=/home/hanwei/demo/target -H:Name=demo -H:ConfigurationFileDirectories=/home/hanwei/demo/target/graalvm-reachability-metadata/39f9c4cd5765941e97b499c39e24353f8a36ebd3/org.apache.tomcat.embed/tomcat-embed-core/10.0.20,/home/hanwei/demo/target/graalvm-reachability-metadata/39f9c4cd5765941e97b499c39e24353f8a36ebd3/ch.qos.logback/logback-classic/1.4.1
========================================================================================================================
GraalVM Native Image: Generating 'demo' (executable)...
========================================================================================================================
[1/7] Initializing...                                                                                    (6.4s @ 0.18GB)
 Version info: 'GraalVM 22.3.0 Java 17 CE'
 Java version info: '17.0.5+8-jvmci-22.3-b08'
 C compiler: gcc (redhat, x86_64, 11.3.1)
 Garbage collector: Serial GC
 1 user-specific feature(s)
 - org.springframework.aot.nativex.feature.PreComputeFieldFeature
The bundle named: org.apache.el.Messages, has not been found. If the bundle is part of a module, verify the bundle name is a fully qualified class name. Otherwise verify the bundle path is accessible in the classpath.
Field org.springframework.core.NativeDetector#imageCode set to true at build time
Field org.apache.commons.logging.LogAdapter#log4jSpiPresent set to true at build time
Field org.apache.commons.logging.LogAdapter#log4jSlf4jProviderPresent set to true at build time
Field org.apache.commons.logging.LogAdapter#slf4jSpiPresent set to true at build time
Field org.apache.commons.logging.LogAdapter#slf4jApiPresent set to true at build time
Field org.springframework.format.support.DefaultFormattingConversionService#jsr354Present set to false at build time
Field org.springframework.core.KotlinDetector#kotlinPresent set to false at build time
Field org.springframework.core.KotlinDetector#kotlinReflectPresent set to false at build time
Field org.springframework.cglib.core.AbstractClassGenerator#imageCode set to true at build time
Field org.springframework.boot.logging.java.JavaLoggingSystem$Factory#PRESENT set to true at build time
Field org.springframework.boot.logging.log4j2.Log4J2LoggingSystem$Factory#PRESENT set to false at build time
Field org.springframework.boot.logging.logback.LogbackLoggingSystem$Factory#PRESENT set to true at build time
Field org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport#romePresent set to false at build time
Field org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport#jaxb2Present set to false at build time
Field org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport#jackson2Present set to true at build time
Field org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport#jackson2XmlPresent set to false at build time
Field org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport#jackson2SmilePresent set to false at build time
Field org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport#jackson2CborPresent set to false at build time
Field org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport#gsonPresent set to false at build time
Field org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport#jsonbPresent set to false at build time
Field org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport#kotlinSerializationCborPresent set to false at build time
Field org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport#kotlinSerializationJsonPresent set to false at build time
Field org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport#kotlinSerializationProtobufPresent set to false at build time
Field org.springframework.web.servlet.view.InternalResourceViewResolver#jstlPresent set to false at build time
Field org.springframework.web.context.support.StandardServletEnvironment#jndiPresent set to true at build time
Field org.springframework.web.context.support.WebApplicationContextUtils#jsfPresent set to false at build time
Field org.springframework.web.context.request.RequestContextHolder#jsfPresent set to false at build time
Field org.springframework.context.event.ApplicationListenerMethodAdapter#reactiveStreamsPresent set to false at build time
Field org.springframework.boot.logging.logback.LogbackLoggingSystemProperties#JBOSS_LOGGING_PRESENT set to false at build time
Field org.springframework.http.converter.support.AllEncompassingFormHttpMessageConverter#jaxb2Present set to false at build time
Field org.springframework.http.converter.support.AllEncompassingFormHttpMessageConverter#jackson2Present set to true at build time
Field org.springframework.http.converter.support.AllEncompassingFormHttpMessageConverter#jackson2XmlPresent set to false at build time
Field org.springframework.http.converter.support.AllEncompassingFormHttpMessageConverter#jackson2SmilePresent set to false at build time
Field org.springframework.http.converter.support.AllEncompassingFormHttpMessageConverter#gsonPresent set to false at build time
Field org.springframework.http.converter.support.AllEncompassingFormHttpMessageConverter#jsonbPresent set to false at build time
Field org.springframework.http.converter.support.AllEncompassingFormHttpMessageConverter#kotlinSerializationCborPresent set to false at build time
Field org.springframework.http.converter.support.AllEncompassingFormHttpMessageConverter#kotlinSerializationJsonPresent set to false at build time
Field org.springframework.http.converter.support.AllEncompassingFormHttpMessageConverter#kotlinSerializationProtobufPresent set to false at build time
Field org.springframework.boot.autoconfigure.web.format.WebConversionService#JSR_354_PRESENT set to false at build time
Field org.springframework.web.client.RestTemplate#romePresent set to false at build time
Field org.springframework.web.client.RestTemplate#jaxb2Present set to false at build time
Field org.springframework.web.client.RestTemplate#jackson2Present set to true at build time
Field org.springframework.web.client.RestTemplate#jackson2XmlPresent set to false at build time
Field org.springframework.web.client.RestTemplate#jackson2SmilePresent set to false at build time
Field org.springframework.web.client.RestTemplate#jackson2CborPresent set to false at build time
Field org.springframework.web.client.RestTemplate#gsonPresent set to false at build time
Field org.springframework.web.client.RestTemplate#jsonbPresent set to false at build time
Field org.springframework.web.client.RestTemplate#kotlinSerializationCborPresent set to false at build time
Field org.springframework.web.client.RestTemplate#kotlinSerializationJsonPresent set to false at build time
Field org.springframework.web.client.RestTemplate#kotlinSerializationProtobufPresent set to false at build time
Field org.springframework.core.ReactiveAdapterRegistry#reactorPresent set to false at build time
Field org.springframework.core.ReactiveAdapterRegistry#rxjava3Present set to false at build time
Field org.springframework.core.ReactiveAdapterRegistry#kotlinCoroutinesPresent set to false at build time
Field org.springframework.core.ReactiveAdapterRegistry#mutinyPresent set to false at build time
SLF4J: No SLF4J providers were found.
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See https://www.slf4j.org/codes.html#noProviders for further details.
Field org.springframework.web.servlet.mvc.method.annotation.ReactiveTypeHandler#isContextPropagationPresent set to false at build time
Field org.springframework.web.servlet.support.RequestContext#jstlPresent set to false at build time
[2/7] Performing analysis...  [*********]                                                               (54.5s @ 1.28GB)
  15,278 (92.35%) of 16,544 classes reachable
  24,932 (67.63%) of 36,867 fields reachable
  73,534 (62.25%) of 118,132 methods reachable
     780 classes,   163 fields, and 3,506 methods registered for reflection
      64 classes,    70 fields, and    55 methods registered for JNI access
       4 native libraries: dl, pthread, rt, z
[3/7] Building universe...                                                                               (5.2s @ 4.12GB)
[4/7] Parsing methods...      [**]                                                                       (4.2s @ 4.35GB)
[5/7] Inlining methods...     [***]                                                                      (1.9s @ 2.82GB)
[6/7] Compiling methods...    [*****]                                                                   (27.8s @ 3.46GB)
[7/7] Creating image...                                                                                  (6.1s @ 1.15GB)
  32.83MB (49.82%) for code area:    48,151 compilation units
  32.75MB (49.70%) for image heap:  354,531 objects and 320 resources
 324.99KB ( 0.48%) for other data
  65.90MB in total
------------------------------------------------------------------------------------------------------------------------
Top 10 packages in code area:                               Top 10 object types in image heap:
   1.63MB sun.security.ssl                                     7.21MB byte[] for code metadata
   1.04MB java.util                                            3.88MB byte[] for embedded resources
 832.55KB java.lang.invoke                                     3.63MB java.lang.Class
 718.00KB com.sun.crypto.provider                              3.39MB java.lang.String
 541.00KB org.apache.catalina.core                             2.80MB byte[] for java.lang.String
 499.59KB org.apache.tomcat.util.net                           2.79MB byte[] for general heap data
 490.49KB org.apache.coyote.http2                              1.28MB com.oracle.svm.core.hub.DynamicHubCompanion
 472.53KB java.lang                                          815.22KB byte[] for reflection metadata
 461.63KB sun.security.x509                                  659.44KB java.lang.String[]
 459.52KB java.util.concurrent                               648.80KB java.util.HashMap$Node
  25.43MB for 637 more packages                                5.47MB for 3070 more object types
------------------------------------------------------------------------------------------------------------------------
                        9.1s (7.9% of total time) in 37 GCs | Peak RSS: 6.43GB | CPU load: 4.46
------------------------------------------------------------------------------------------------------------------------
Produced artifacts:
 /home/hanwei/demo/target/demo (executable)
 /home/hanwei/demo/target/demo.build_artifacts.txt (txt)
========================================================================================================================
Finished generating 'demo' in 1m 53s.
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  01:55 min
[INFO] Finished at: 2022-11-28T23:55:32+08:00
[INFO] ------------------------------------------------------------------------

Process finished with exit code 0
```

执行二进制可执行文件，启动速度只有 0.052 seconds 。

```bash
[hanwei@backendcloud-centos9 ~]$ cd demo/target/
[hanwei@backendcloud-centos9 target]$ ls
classes  demo  demo-0.0.1-SNAPSHOT.jar  demo-0.0.1-SNAPSHOT.jar.original  demo.build_artifacts.txt  generated-sources  generated-test-sources  graalvm-reachability-metadata  maven-archiver  maven-status  spring-aot  surefire-reports  test-classes
[hanwei@backendcloud-centos9 target]$ ./demo 

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.0.0)

2022-11-29T00:03:59.026+08:00  INFO 12061 --- [           main] com.example.demo.DemoApplication         : Starting AOT-processed DemoApplication using Java 17.0.5 with PID 12061 (/home/hanwei/demo/target/demo started by hanwei in /home/hanwei/demo/target)
2022-11-29T00:03:59.026+08:00  INFO 12061 --- [           main] com.example.demo.DemoApplication         : No active profile set, falling back to 1 default profile: "default"
2022-11-29T00:03:59.040+08:00  INFO 12061 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2022-11-29T00:03:59.040+08:00  INFO 12061 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2022-11-29T00:03:59.040+08:00  INFO 12061 --- [           main] o.apache.catalina.core.StandardEngine    : Starting Servlet engine: [Apache Tomcat/10.1.1]
2022-11-29T00:03:59.044+08:00  INFO 12061 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2022-11-29T00:03:59.044+08:00  INFO 12061 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 18 ms
2022-11-29T00:03:59.068+08:00  INFO 12061 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2022-11-29T00:03:59.068+08:00  INFO 12061 --- [           main] com.example.demo.DemoApplication         : Started DemoApplication in 0.052 seconds (process running for 0.056)
```

```bash
[hanwei@backendcloud-centos9 target]$ ll -h
total 84M
drwxr-xr-x. 5 hanwei hanwei   74 Nov 28 23:15 classes
-rwxr-xr-x. 1 hanwei hanwei  66M Nov 28 23:55 demo
-rw-r--r--. 1 hanwei hanwei  18M Nov 28 23:49 demo-0.0.1-SNAPSHOT.jar
-rw-r--r--. 1 hanwei hanwei 119K Nov 28 23:49 demo-0.0.1-SNAPSHOT.jar.original
-rw-r--r--. 1 hanwei hanwei   19 Nov 28 23:55 demo.build_artifacts.txt
drwxr-xr-x. 3 hanwei hanwei   25 Nov 28 22:59 generated-sources
drwxr-xr-x. 3 hanwei hanwei   30 Nov 28 22:59 generated-test-sources
drwxr-xr-x. 4 hanwei hanwei  101 Nov 28 23:42 graalvm-reachability-metadata
drwxr-xr-x. 2 hanwei hanwei   28 Nov 28 22:59 maven-archiver
drwxr-xr-x. 3 hanwei hanwei   35 Nov 28 22:59 maven-status
drwxr-xr-x. 3 hanwei hanwei   18 Nov 28 22:59 spring-aot
drwxr-xr-x. 2 hanwei hanwei  153 Nov 28 23:03 surefire-reports
drwxr-xr-x. 3 hanwei hanwei   17 Nov 28 22:59 test-classes
```

对比两种打包方式：jar包和原生可执行文件，jar包18兆，原生可执行文件因为可以不依赖java运行环境而直接运行，所以体积大些，66兆。


上面是通过Linux Idea的Maven窗口执行的。也可以通过命令行执行mvn命令生成原生二进制文件。

```bash
[hanwei@backendcloud-centos9 target]$ which mvn
~/.local/bin/mvn
[hanwei@backendcloud-centos9 target]$ ll ~/.local/bin/mvn
lrwxrwxrwx. 1 hanwei hanwei 107 Nov 28 22:57 /home/hanwei/.local/bin/mvn -> /home/hanwei/.m2/wrapper/dists/apache-maven-3.8.6-bin/1ks0nkde5v1pk9vtc31i9d0lcd/apache-maven-3.8.6/bin/mvn
# 到feature-native目录下
[hanwei@backendcloud-centos9 demo]$ cd ..
[hanwei@backendcloud-centos9 demo]$ mvn clean
# 打包
[hanwei@backendcloud-centos9 demo]$ mvn package -Pnative
# 可执行文件
[hanwei@backendcloud-centos9 demo]$ mvn native:compile-no-fork 
# 到target目录下启动可执行文件
```

从上面的执行效果对比看出，云原生时代的Spring Boot 3.0: GraalVM编译的二进制可执行文件，启动速度相对于传统jar包提升近30倍（1.335 seconds -> 0.052 seconds）。