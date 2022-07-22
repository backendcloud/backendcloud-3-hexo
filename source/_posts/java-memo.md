---
title: Java项目开发中的点滴记录（1）
date: 2021-11-23 15:04:04
categories: 编程
tags:
- Java
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

记录下用Java开发项目中遇到的一些问题：

# @Pattern注解

对于http request body中的字段需要做正则校验，不需要条件判断的一般性正则校验，可以用@Pattern，而不必在方法中写正则校验，简化开发。

为了校验必须采用"sftp://"开头，写成了下面的形式
@Pattern(regexp = "^sftp://")

但是字段内容是`sftp://10.10.10.10:33022/ftp_test`时报错
查了下@Pattern注解自动会加上^和&。正确的写法是
`@Pattern(regexp = "^sftp://.*$")` 或者 `@Pattern(regexp = "sftp://.*")`

于是又完善了正则表达式写成下面的形式：

```java
    /**
     * ftpPath
     */
    @JsonProperty("ftpServer")
    @Pattern(regexp = "sftp://.+[:\\d+]?/.*", message = "ftpPath字段需要符合 \"sftp //\" 语法格式， \n" +
            "例如sftp://10.10.10.10:33022/ftp_test\n" +
            "10.10.10.10 是ip地址或者hostname，33022是sftp的端口，/ftp_test是sftp的目录（sftp的根目录是当前用户的home目录）")
    private String ftpPath;
    /**
     * ftpUser
     */
    @JsonProperty("ftpUser")
    private String ftpUser;
    /**
     * ftpPasswd
     */
    @JsonProperty("ftpPasswd")
    private String ftpPasswd;
```

# 要同时开启https和https服务

单独开启http服务，springboot的配置文件写

    #http端口号.
    server.port: 33021

单独开启https服务，用keytool做一个证书，springboot的配置文件这样写：

    #https端口号.
    server.port: 33021
    
    #https配置
    #证书的路径.
    server.ssl.key-store: classpath:keystore.p12
    #server.ssl.key-store: file:/Users/hanwei/xxx/yyy/api/src/main/resources/keystore.p12
    #证书密码，请修改为您自己证书的密码.
    server.ssl.key-store-password: 123456
    #秘钥库类型
    server.ssl.keyStoreType: PKCS12
    #证书别名
    server.ssl.keyAlias: tomcat


要同时开启http服务和https服务，springboot的配置文件这样写：

    #https端口号.
    server.port: 33021

    # http 端口
    http.port: 33011
    
    #https配置
    #证书的路径.
    server.ssl.key-store: classpath:keystore.p12
    #server.ssl.key-store: file:/Users/hanwei/xxx/yyy/api/src/main/resources/keystore.p12
    #证书密码，请修改为您自己证书的密码.
    server.ssl.key-store-password: 123456
    #秘钥库类型
    server.ssl.keyStoreType: PKCS12

并创建下面的java文件：

```java
import org.apache.catalina.connector.Connector;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.servlet.server.ServletWebServerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


@Configuration
public class SSLConfig {
    @Value("${http.port}")
    private Integer port;

    @Bean
    public ServletWebServerFactory servletContainer() {

        TomcatServletWebServerFactory tomcat = new TomcatServletWebServerFactory();
        Connector connector = new Connector("org.apache.coyote.http11.Http11NioProtocol");
        connector.setPort(port);
        tomcat.addAdditionalTomcatConnectors(connector);
        return tomcat;
    }

}
```

# 想让http response body json 的null字段显示成空字符串""

```java
//demo
    @RequestMapping("/map")
    public Map<String, Object> getMap() {
        Map<String, Object> map = new HashMap<>(3);
        User user = new User(1, "xxx", null);
        map.put("作者信息", user);
        map.put("博客地址", "http://www.yyy.com");
        map.put("CSDN地址", null);
        return map;
    }
```

调用接口显示：{"作者信息":{"id":1,"username":"xxx","password":null},"CSDN地址":null,"博客地址":"http://www.yyy.com"}

创建下面的java文件：

```java
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.*;
import com.fasterxml.jackson.databind.Module;
import com.fasterxml.jackson.databind.module.SimpleModule;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;

import java.io.IOException;

@Configuration
public class JacksonConfig {
    @Bean
    @Primary
    @ConditionalOnMissingBean(ObjectMapper.class)
    public ObjectMapper jacksonObjectMapper(Jackson2ObjectMapperBuilder builder) {
        ObjectMapper objectMapper = builder.createXmlMapper(false).build();
        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, true);
        objectMapper.configure(MapperFeature.ALLOW_COERCION_OF_SCALARS, false);
        objectMapper.getSerializerProvider().setNullValueSerializer(new JsonSerializer<Object>() {
            @Override
            public void serialize(Object o, JsonGenerator jsonGenerator, SerializerProvider serializerProvider) throws IOException {
                jsonGenerator.writeString("");
            }
        });
        return objectMapper;
    }

    @Bean
    public Module customStringDeserializer() {
        SimpleModule module = new SimpleModule();
        module.addDeserializer(String.class, CustomStringDeserializer.instance);
        return module;
    }
}
```

调用接口显示：{"作者信息":{"id":1,"username":"xxx","password":""},"CSDN地址":"","博客地址":"http://www.yyy.com"}



# 想让http response body json 的null字段不显示出来

可以利用`@JsonInclude(JsonInclude.Include.NON_NULL)`注解，例如：

```java
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@NoArgsConstructor
@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ListPoolTenantsResponse {

    /**
     * tenantId
     */
    @JsonProperty("tenantId")
    private String tenantId;
    /**
     * poolTenants
     */
    @JsonProperty("poolTenants")
    private List<PoolTenantsDTO> poolTenants;

    /**
     * PoolTenantsDTO
     */
    @NoArgsConstructor
    @Data
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class PoolTenantsDTO {
        /**
         * id
         */
        @JsonProperty("id")
        private String id;
        /**
         * name
         */
        @JsonProperty("name")
        private String name;
        /**
         * poolId
         */
        @JsonProperty("poolId")
        private String poolId;
        /**
         * poolName
         */
        @JsonProperty("poolName")
        private String poolName;
        /**
         * poolType
         */
        @JsonProperty("poolType")
        private Integer poolType;
        /**
         * description
         */
        @JsonProperty("description")
        private String description;
        /**
         * status
         */
        @JsonProperty("status")
        private String status;
        /**
         * quotaSpec
         */
        @JsonProperty("quotaSpec")
        private QuotaSpecDTO quotaSpec;

        /**
         * QuotaSpecDTO
         */
        @NoArgsConstructor
        @Data
        @JsonInclude(JsonInclude.Include.NON_NULL)
        public static class QuotaSpecDTO {
            /**
             * cpu
             */
            @JsonProperty("cpu")
            private Integer cpu;
            /**
             * memory
             */
            @JsonProperty("memory")
            private Integer memory;
        }
    }
}
```

# Mybatis-Plus作为ORM时，想将数据库中的某个字段更新为null

默认情况下，是不能将字段更新为null的，即使更新为null，查询数据库发现字段还是原来的字段并没有更新，是因为mybatis-plus FieldStrategy 有三种策略：

IGNORED：0 忽略
NOT_NULL：1 非 NULL，默认策略
NOT_EMPTY：2 非空
而默认更新策略是NOT_NULL：非 NULL；即通过接口更新数据时数据为NULL值时将不更新进数据库。

Mybatis-Plus这种默认的策略，对更新操作提供极大的便利，例如http request更新请求时只更新json body中的字段，而body中没有的字段不会更新，这也符合一般的需求。若将body中没有的字段也更新为null，有点奇怪。一般的需求都是为null的字段保持原样。

若某个字段有更新为null的需求，可以通过注解`@TableField(updateStrategy = FieldStrategy.IGNORED)`实现。

例如：

```java
import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.annotation.FieldStrategy;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import com.fasterxml.jackson.databind.node.ObjectNode;
import lombok.Data;

@Data
@TableName(value = "image", autoResultMap = true)
public class Image {
//    private String id;
    @TableId("name")
    private String name;
    private String description;
    private boolean publicView; //和Harbor一致
    private String type;
    private String registry; //镜像仓库地址，支持多镜像仓库
    private String repository; //"project/repository"的形式，和Harbor一致
    @TableField(typeHandler = JacksonTypeHandler.class, updateStrategy = FieldStrategy.IGNORED)
    private JSONObject lables; //"lables": {"gpu": "yes"}
}
```

# json数据类型如何在Java实体字段和数据库字段的映射

json数据类型和Java实体类的映射是很常见，json嵌套json也可以通过在Java实体类再写个嵌套的内部类。内部的json数据类型对应实体内部类，但是现在的需求是要同数据库的某个json类型字段要关联起来。可以通过下面的方式。

例如：

```sql
CREATE TABLE image
(
    #id     int AUTO_INCREMENT comment 'id',
--     id   varchar(80),
    name varchar(80),
    description varchar(500),
    public_view tinyint(1) comment '0:非公开；1:公开',
    type varchar(80),
    registry varchar(80),
    repository varchar(80),
    lables JSON,
    primary key (name)
);
```

```java
import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.annotation.FieldStrategy;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import com.fasterxml.jackson.databind.node.ObjectNode;
import lombok.Data;

@Data
@TableName(value = "image", autoResultMap = true)
public class Image {
//    private String id;
    @TableId("name")
    private String name;
    private String description;
    private boolean publicView; //和Harbor一致
    private String type;
    private String registry; //记录仓库地址，支持多镜像仓库
    private String repository; //"project/repository"的形式，和Harbor一致
    @TableField(typeHandler = JacksonTypeHandler.class, updateStrategy = FieldStrategy.IGNORED)
    private JSONObject lables; //"lables": {"gpu": "yes"}
}
```
typeHandler: 字段类型处理器，用于 JavaType 与 JdbcType 之间的转换。

若不按上面处理会报下面的错误：

	com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Cannot create a JSON value from a string with CHARACTER SET 'binary'."


# http response body字段按需显示时间格式

response body字段前加上注解：

@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone="GMT+8") 显示东八区的时间
@JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") 显示UTC的时间，精确到毫秒，例如：2017-06-01T00:00:00.000Z

# 同步服务器间的数据

可以利用com.jcraft.jsch.ChannelSftp的put方法，再写个定时更新任务

    /**
     * 定时更新任务
     */
    @Async("taskScheduler")
    @Scheduled(cron = "0/15 * * * * ?")
    public void update() {

也可以利用org.apache.camel同步

```java
import org.apache.camel.builder.RouteBuilder;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class FtpRouteBuilder extends RouteBuilder {

    @Override
    public void configure() throws Exception {
        from("file:/tmp/ftp_test?recursive=true&noop=true").to("sftp://10.10.10.10:33022/ftp_test?username=root&password=123456@&binary=true");
    }
}
```

# 修改日志的打包周期

## 同时修改按单位时间内和按大小打包(以修改SystemLog为例)

```xml
<appender name="FILE-SFTP-SystemLog" class="ch.qos.logback.core.rolling.RollingFileAppender">
    <!--日志文件输出的文件名 -->
    <File>${FILE_PATH_SFTP_SystemLog}</File>
    <!--滚动日志 基于时间和文件大小-->
    <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
        <!-- 滚动日志文件保存格式 -->
        <FileNamePattern>${FILE_PATH_SFTP_SystemLog}_%d{"yyyy-MM-dd_HH", UTC}_0.zip</FileNamePattern>
        <MaxFileSize>100MB</MaxFileSize>
        <totalSizeCap>1GB</totalSizeCap>
        <MaxHistory>2</MaxHistory>
    </rollingPolicy>

    <!-- 按临界值过滤日志：低于INFO以下级别被抛弃 -->
    <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
        <level>INFO</level>
    </filter>
    <encoder>
        <!--格式化输出：%d表示日期，%thread表示线程名，%-5level：级别从左显示5个字符宽度%msg：日志消息，%n是换行符 -->
        <pattern>
            {
            "time": "%d{yyyy-MM-dd HH:mm:ss.SSS}",
            "level": "%level",
            "thread": "%thread",
            "class": "%logger{40}",
            "message": "%message"
            }%n
        </pattern>
        <charset>UTF-8</charset>
    </encoder>
</appender>
```

`<rollingPolicy ... /rollingPolicy>` 几个参数用于配置日志文件分割方式：
* `<FileNamePattern>` 中的 `yyyy-MM-dd_HH-mm` 表示以小时为周期分割文件，`yyyy-MM-dd_HH` 表示以小时为周期分割文件，`yyyy-MM-dd` 表示以天为单位分割文件，`yyyy-MM` 表示按月，`yyyy` 表示按年。
* `<MaxFileSize>` 表示打包的单个文件大小不超过这个值。
* `<totalSizeCap>` 限制日志打包的容量大小。
* `<MaxHistory>` 限制历史打包文件的数量。

## 修改Logback在小时单位内按分钟打包(以修改SystemLog为例)（支持以下时间间隔：1，2，5，10，15，20，30分钟）

```xml
<appender name="FILE-SFTP-SystemLog" class="ch.qos.logback.core.rolling.RollingFileAppender">
    <!--日志文件输出的文件名 -->
    <File>${FILE_PATH_SFTP_SystemLog}</File>
    <!--滚动日志 基于时间和文件大小-->
    <!--        <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">-->
    <rollingPolicy
            class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
        <!-- 滚动日志文件保存格式 -->
        <!--            <FileNamePattern>${FILE_PATH_SFTP_OperationLog}_%d{yyyy-MM-dd-HH-mm}_%i.zip</FileNamePattern>-->
        <FileNamePattern>${FILE_PATH_SFTP_SystemLog}_%d{"yyyy-MM-dd_HH-mm", UTC}_0.zip</FileNamePattern>
        <timeBasedFileNamingAndTriggeringPolicy
                class="xxx.yyy.api.config.MyTimeBasedFileNamingAndTriggeringPolicy">
            <multiple>5</multiple>
        </timeBasedFileNamingAndTriggeringPolicy>
        <!--            <MaxFileSize>100MB</MaxFileSize>-->
        <!--            <totalSizeCap>1GB</totalSizeCap>-->
        <MaxHistory>90</MaxHistory>
    </rollingPolicy>
    <!-- 按临界值过滤日志：低于INFO以下级别被抛弃 -->
    <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
        <level>INFO</level>
    </filter>
    <encoder>
        <!--格式化输出：%d表示日期，%thread表示线程名，%-5level：级别从左显示5个字符宽度%msg：日志消息，%n是换行符 -->
        <pattern>
            {
            "time": "%d{yyyy-MM-dd HH:mm:ss.SSS}",
            "level": "%level",
            "thread": "%thread",
            "class": "%logger{40}",
            "message": "%message"
            }%n
        </pattern>
        <charset>UTF-8</charset>
    </encoder>
</appender>
```

`<rollingPolicy ... /rollingPolicy>` 几个参数用于配置日志文件分割方式：
* `<FileNamePattern>` 中的时间格式部分只可固定为 `yyyy-MM-dd_HH-mm`。
* `<multiple>` 表示打包间隔分钟数。支持以下时间间隔：1，2，5，10，12，15，20，30 分钟。
* `<MaxHistory>` 限制历史打包文件的时间。就是说历史打包文件的数量为 `<MaxHistory>` 除以 `<multiple>`。

MyTimeBasedFileNamingAndTriggeringPolicy.java文件如下：

```java
package xxx.yyy.api.config;

import ch.qos.logback.core.joran.spi.NoAutoStart;
import ch.qos.logback.core.rolling.DefaultTimeBasedFileNamingAndTriggeringPolicy;

@NoAutoStart
public class MyTimeBasedFileNamingAndTriggeringPolicy<E> extends DefaultTimeBasedFileNamingAndTriggeringPolicy<E> {
    //这个用来指定时间间隔
    private Integer multiple = 1;

    @Override
    protected void computeNextCheck() {
        nextCheck = rc.getEndOfNextNthPeriod(dateInCurrentPeriod, multiple).getTime();
    }

    public Integer getMultiple() {
        return multiple;
    }

    public void setMultiple(Integer multiple) {
        if (multiple > 1) {
            this.multiple = multiple;
        }
    }
}
```


