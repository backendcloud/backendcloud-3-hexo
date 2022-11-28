---
title: WIProcess-Spring Boot 3.0 初步使用
readmore: false
date: 2022-11-28 18:33:44
categories: 云原生
tags:
---


Spring Boot 3.0 四天前（2022年11月24日）发布了，变化很大，基于spring6.0，spring6.0说是Spring下一个十年的新开端。


# JAVA 17

Spring Boot 3.0 版本最低支持 Java17，Springboot 2.7.3 最常用的jdk版本是Java 8，现在直接从8跳到了17，且强制要求，17以下的版本不再支持。这样可以使用17或17以上的Java语言的新特性。


# Spring Native

Spring Native 也是升级的一个重大特性，支持使用 GraalVM 将 Spring 的应用程序编译成本地可执行的镜像文件，可以显著提升启动速度、峰值性能以及减少内存使用。

我们传统的应用都是编译成字节码，然后通过 JVM 解释并最终编译成机器码来运行，而 Spring Native 则是通过 AOT 提前编译为机器码，在运行时直接静态编译成可执行文件，不依赖 JVM。


# Jakarta EE

JavaEE 改名之后就叫 JakartaEE，比如我们之前的javax.servlet包现在就叫jakarta.servlet。也因此，代码中所有使用到比如 HttpServletRequest 对象的 import 都需要修改。

https://start.spring.io/

```java
import javax.servlet.http.HttpServletRequest;
// 改为
import jakarta.servlet.http.HttpServletRequest;
```

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

```bash
PS C:\Users\hanwei> java --version
openjdk 17.0.5 2022-10-18
OpenJDK Runtime Environment GraalVM CE 22.3.0 (build 17.0.5+8-jvmci-22.3-b08)
OpenJDK 64-Bit Server VM GraalVM CE 22.3.0 (build 17.0.5+8-jvmci-22.3-b08, mixed mode, sharing)
```

```bash
C:\sdk\graalvm-ce-java17-22.3.0\bin\java.exe -XX:TieredStopAtLevel=1 -Dspring.output.ansi.enabled=always -Dcom.sun.management.jmxremote -Dspring.jmx.enabled=true -Dspring.liveBeansView.mbeanDomain -Dspring.application.admin.enabled=true "-javaagent:C:\Program Files\JetBrains\IntelliJ IDEA 2022.2\lib\idea_rt.jar=4655:C:\Program Files\JetBrains\IntelliJ IDEA 2022.2\bin" -Dfile.encoding=UTF-8 -classpath C:\Users\hanwei\Documents\JavaProject\demo-maven\target\classes;C:\Users\hanwei\.m2\repository\org\springframework\boot\spring-boot-starter\3.0.0\spring-boot-starter-3.0.0.jar;C:\Users\hanwei\.m2\repository\org\springframework\boot\spring-boot\3.0.0\spring-boot-3.0.0.jar;C:\Users\hanwei\.m2\repository\org\springframework\spring-context\6.0.2\spring-context-6.0.2.jar;C:\Users\hanwei\.m2\repository\org\springframework\boot\spring-boot-autoconfigure\3.0.0\spring-boot-autoconfigure-3.0.0.jar;C:\Users\hanwei\.m2\repository\org\springframework\boot\spring-boot-starter-logging\3.0.0\spring-boot-starter-logging-3.0.0.jar;C:\Users\hanwei\.m2\repository\ch\qos\logback\logback-classic\1.4.5\logback-classic-1.4.5.jar;C:\Users\hanwei\.m2\repository\ch\qos\logback\logback-core\1.4.5\logback-core-1.4.5.jar;C:\Users\hanwei\.m2\repository\org\apache\logging\log4j\log4j-to-slf4j\2.19.0\log4j-to-slf4j-2.19.0.jar;C:\Users\hanwei\.m2\repository\org\apache\logging\log4j\log4j-api\2.19.0\log4j-api-2.19.0.jar;C:\Users\hanwei\.m2\repository\org\slf4j\jul-to-slf4j\2.0.4\jul-to-slf4j-2.0.4.jar;C:\Users\hanwei\.m2\repository\jakarta\annotation\jakarta.annotation-api\2.1.1\jakarta.annotation-api-2.1.1.jar;C:\Users\hanwei\.m2\repository\org\springframework\spring-core\6.0.2\spring-core-6.0.2.jar;C:\Users\hanwei\.m2\repository\org\springframework\spring-jcl\6.0.2\spring-jcl-6.0.2.jar;C:\Users\hanwei\.m2\repository\org\yaml\snakeyaml\1.33\snakeyaml-1.33.jar;C:\Users\hanwei\.m2\repository\org\slf4j\slf4j-api\2.0.4\slf4j-api-2.0.4.jar;C:\Users\hanwei\.m2\repository\org\springframework\boot\spring-boot-starter-web\3.0.0\spring-boot-starter-web-3.0.0.jar;C:\Users\hanwei\.m2\repository\org\springframework\boot\spring-boot-starter-json\3.0.0\spring-boot-starter-json-3.0.0.jar;C:\Users\hanwei\.m2\repository\com\fasterxml\jackson\core\jackson-databind\2.14.1\jackson-databind-2.14.1.jar;C:\Users\hanwei\.m2\repository\com\fasterxml\jackson\core\jackson-annotations\2.14.1\jackson-annotations-2.14.1.jar;C:\Users\hanwei\.m2\repository\com\fasterxml\jackson\core\jackson-core\2.14.1\jackson-core-2.14.1.jar;C:\Users\hanwei\.m2\repository\com\fasterxml\jackson\datatype\jackson-datatype-jdk8\2.14.1\jackson-datatype-jdk8-2.14.1.jar;C:\Users\hanwei\.m2\repository\com\fasterxml\jackson\datatype\jackson-datatype-jsr310\2.14.1\jackson-datatype-jsr310-2.14.1.jar;C:\Users\hanwei\.m2\repository\com\fasterxml\jackson\module\jackson-module-parameter-names\2.14.1\jackson-module-parameter-names-2.14.1.jar;C:\Users\hanwei\.m2\repository\org\springframework\boot\spring-boot-starter-tomcat\3.0.0\spring-boot-starter-tomcat-3.0.0.jar;C:\Users\hanwei\.m2\repository\org\apache\tomcat\embed\tomcat-embed-core\10.1.1\tomcat-embed-core-10.1.1.jar;C:\Users\hanwei\.m2\repository\org\apache\tomcat\embed\tomcat-embed-el\10.1.1\tomcat-embed-el-10.1.1.jar;C:\Users\hanwei\.m2\repository\org\apache\tomcat\embed\tomcat-embed-websocket\10.1.1\tomcat-embed-websocket-10.1.1.jar;C:\Users\hanwei\.m2\repository\org\springframework\spring-web\6.0.2\spring-web-6.0.2.jar;C:\Users\hanwei\.m2\repository\org\springframework\spring-beans\6.0.2\spring-beans-6.0.2.jar;C:\Users\hanwei\.m2\repository\io\micrometer\micrometer-observation\1.10.2\micrometer-observation-1.10.2.jar;C:\Users\hanwei\.m2\repository\io\micrometer\micrometer-commons\1.10.2\micrometer-commons-1.10.2.jar;C:\Users\hanwei\.m2\repository\org\springframework\spring-webmvc\6.0.2\spring-webmvc-6.0.2.jar;C:\Users\hanwei\.m2\repository\org\springframework\spring-aop\6.0.2\spring-aop-6.0.2.jar;C:\Users\hanwei\.m2\repository\org\springframework\spring-expression\6.0.2\spring-expression-6.0.2.jar com.example.demo.DemoApplication

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.0.0)

2022-11-28T16:31:48.488+08:00  INFO 14684 --- [           main] com.example.demo.DemoApplication         : Starting DemoApplication using Java 17.0.5 with PID 14684 (C:\Users\hanwei\Documents\JavaProject\demo-maven\target\classes started by hanwei in C:\Users\hanwei\Documents\JavaProject\demo-maven)
2022-11-28T16:31:48.491+08:00  INFO 14684 --- [           main] com.example.demo.DemoApplication         : No active profile set, falling back to 1 default profile: "default"
2022-11-28T16:31:49.254+08:00  INFO 14684 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2022-11-28T16:31:49.263+08:00  INFO 14684 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2022-11-28T16:31:49.263+08:00  INFO 14684 --- [           main] o.apache.catalina.core.StandardEngine    : Starting Servlet engine: [Apache Tomcat/10.1.1]
2022-11-28T16:31:49.352+08:00  INFO 14684 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2022-11-28T16:31:49.352+08:00  INFO 14684 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 821 ms
2022-11-28T16:31:49.656+08:00  INFO 14684 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2022-11-28T16:31:49.665+08:00  INFO 14684 --- [           main] com.example.demo.DemoApplication         : Started DemoApplication in 1.547 seconds (process running for 2.261)
2022-11-28T16:31:59.271+08:00  INFO 14684 --- [nio-8080-exec-1] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring DispatcherServlet 'dispatcherServlet'
2022-11-28T16:31:59.271+08:00  INFO 14684 --- [nio-8080-exec-1] o.s.web.servlet.DispatcherServlet        : Initializing Servlet 'dispatcherServlet'
2022-11-28T16:31:59.271+08:00  INFO 14684 --- [nio-8080-exec-1] o.s.web.servlet.DispatcherServlet        : Completed initialization in 0 ms
```

![](/images/springboot3/2022-11-28-16-35-09.png)

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

需要开启docker服务，而windows下的dockerdesktop需要打开hyper-v或者WSL 2，一旦打开会影响VMware 嵌套虚拟化功能，导致该功能不可用。

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

执行该命令后记得重启！

重启后，windows 11下的dockerdesktop可以正常启动。

对于没有vmware需求，没有虚拟机vpn网络需求，仅仅开发springboot3.0，上面的方式已经可以实现目标。

不过若有VMware需求，以及有VMware虚拟机共享宿主机vpn网络的需求，上面的重置命令慎用，用了会导致不仅VMware不可使用嵌套虚拟化，也会导致VMware里运行的虚拟机使用宿主机vpn网络出现问题，网络不通。

不过也不用担心，只需要3步可以恢复：
1. 卸载windows dockerdesktop
2. 设置 - 应用 - 可选功能 - 更多windows功能，取消 WSL 2 和 hyper-v 的勾，重启电脑
3. 卸载wmware，重新安装wmware。

