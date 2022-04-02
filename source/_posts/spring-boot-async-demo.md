---
title: spring-boot异步的example
date: 2022-03-25 11:24:27
categories: Java
tags:
- spring-boot
- async
---

# 工程简介
2种异步example
* void没有返回值
* 有返回值

# 延伸阅读

spring boot 自带 @Async 注解，只要加到想要异步的方法上即可。有个小坑，就是只这样还是同步的service，还需要在main方法上加上 @EnableAsync 注解。
```java
@SpringBootApplication
@EnableAsync
public class DemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}
```
## 没有返回值的异步
### service
```java
@Service
public class AsyncNoReturnImpl implements AsyncNoReturn {

    @Async
    @Override
    public void execAsync1(){
        try{
            Thread.sleep(2000);
            System.out.println("甲睡了2000ms");
        }catch (Exception e){
            e.printStackTrace();
        }
    }
    @Async
    @Override
    public void execAsync2(){
        try{
            Thread.sleep(4000);
            System.out.println("乙睡了4000ms");
        }catch (Exception e){
            e.printStackTrace();
        }
    }
    @Async
    @Override
    public void execAsync3(){
        try{
            Thread.sleep(3000);
            System.out.println("丙睡了3000ms");
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
```
### controller
```java
@GetMapping("/async-no-return")
    public ResponseEntity<String> getAsyncNoReturn() {
        long s = System.currentTimeMillis();
        asyncNoReturn.execAsync1();
        asyncNoReturn.execAsync2();
        asyncNoReturn.execAsync3();
        System.out.println("我执行结束了");
        long costTime = System.currentTimeMillis() - s;
        System.out.println("service async-no-return cost time: " + costTime);
        return ResponseEntity.status(200).body("good");
    }
```
### test
    ## async-no-return
    GET http://localhost:8080/async-no-return
    
    我执行结束了
    service async-no-return cost time: 3
    甲睡了2000ms
    丙睡了3000ms
    乙睡了4000ms

因为3个service都异步了，所以接口直接返回了，几乎没有花时间，3ms。3个service并行执行，4秒后全部执行完毕。
## 有返回值的异步
### service
```java
@Service
public class AsyncHasReturnImpl implements AsyncHasReturn {

    @Async
    public Future<String> execAsync1(){
        try{
            Thread.sleep(2000);
            System.out.println("甲睡了2000ms");
            return new AsyncResult<String>("甲执行成功了");
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }
    @Async
    public Future<String> execAsync2(){
        try{
            Thread.sleep(4000);
            System.out.println("乙睡了4000ms");
            return new AsyncResult<String>("乙执行成功了");
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }
    @Async
    public Future<String> execAsync3(){
        try{
            Thread.sleep(3000);
            System.out.println("丙睡了3000ms");
            return new  AsyncResult<String>("丙执行结束了");
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

}
```
### controller
```java
@GetMapping("/async-has-return")
    public ResponseEntity<String> getAsyncHasReturn() throws ExecutionException, InterruptedException {
        long s = System.currentTimeMillis();
        Future<String> stringFuture1 = asyncHasReturn.execAsync1();
        Future<String> stringFuture2 = asyncHasReturn.execAsync2();
        Future<String> stringFuture3 = asyncHasReturn.execAsync3();
        long costTime = System.currentTimeMillis() - s;
        System.out.println("执行到代码中间了，cost time: " + costTime);
        System.out.println("我执行结束了" + stringFuture1.get() + stringFuture2.get() + stringFuture3.get());
        costTime = System.currentTimeMillis() - s;
        System.out.println("service async-has-return cost time: " + costTime);
        return ResponseEntity.status(200).body("good");
    }
```
### test
    ## async-has-return
    GET http://localhost:8080/async-has-return
    
    执行到代码中间了，cost time: 1
    甲睡了2000ms
    丙睡了3000ms
    乙睡了4000ms
    我执行结束了甲执行成功了乙执行成功了丙执行结束了
    service async-has-return cost time: 4006

可见将异步service赋值给Future是不花时间的，不需要等待当前异步线程执行完毕。只有get()方法需要等待当前的异步线程执行完毕，几个异步线程是并行执行的。类似get()方法的还有isDone()，因为get()已经包括了isDone()，所以不需要使用isDone()做判断了。

> 全部代码在： https://github.com/backendcloud/example/tree/master/spring-boot/async/demo/

