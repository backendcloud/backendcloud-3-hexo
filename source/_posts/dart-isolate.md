---
title: Dart 多线程
date: 2022-07-20 13:17:28
categories: Fuchsia
tags:

---

# Dart 的线程概念

在Dart中，它的线程概念被称为 Isolate 。 它与我们之前理解的Thread 概念有所不同，各个isolate 之间是无法共享内存空间，isolate 之间有自己的event loop。Dart中多线程之间只能通过发送消息通信，所以它的资源开销低于线程，Dart的这种特别的线程也有被称为微线程这种说法。

Dart中的线程是以隔离（Isolate）的方式存在的，每个Isolate都有自己独立的，私有内存块（多个线程不共享内存），没有共享内存，就不需要竞争资源，就不需要锁（不必担心死锁问题）。

所有的Dart代码，都运行在Isolate中。Isolate提供了Dart | Flutter的运行环境，微任务队列，事件队列，事件轮询（EventLoop）都在Isolate中进行。


# Isolate.spawn() - Creates and spawns an isolate that shares the same code as the current isolate.

## 多线程创建

```dart
import 'dart:isolate';

void main(List<String> args) {
  multiThread();
}

void multiThread() {
  print('multiThread start');
  print('当前线程：' + Isolate.current.debugName!);
  Isolate.spawn(newThread, 'hello');
  print('multiThread end');
}

void newThread(String message) {
  print('当前线程：' + Isolate.current.debugName!);
  print(message);
}
```

> Dart的 Null Safety 和 线程安全 有些类似Rust。

代码执行结果：
```bash
multiThread start
当前线程：main
multiThread end
当前线程：newThread
hello
```

## 多线程之间通信机制

Isolate多线程之间，通信的唯一方式是port

ReveivePort类：初始化接收端口，创建发送端口，接收消息，监听消息，关闭端口

SendPort类：将消息发送给ReceivePort

通信方式：单向通信、双向通信

```dart
import 'dart:isolate';

void main(List<String> args) {
  multiThread();
}

void multiThread() async {
  print('multiThread start');
  print('当前线程：' + Isolate.current.debugName!);
  // 接收端口
  ReceivePort r1 = ReceivePort();
  // 发送端口
  SendPort p1 = r1.sendPort;
  // 创建新线程
  Isolate.spawn(newThread, p1);

  // 接收新线程发送过来的消息
  // var msg = await r1.first;
  // print('来自新线程的消息：' + msg.toString());

  r1.listen((message) {
    print('来自新线程的消息：' + message.toString());
    // 如果不关闭的话主线程会被阻塞
    r1.close();
  });
  print('multiThread end');
}

void newThread(SendPort p1) {
  print('当前线程：' + Isolate.current.debugName!);
  // 发送消息给 main 线程
  p1.send('abc');
}
```

代码执行结果：
```bash
multiThread start
当前线程：main
当前线程：newThread
multiThread end
来自新线程的消息：abc
```

Isolate之间通讯，总结就是，通过SendPort作为中介传递给要通讯的线程，然后通过ReveivePort接收或者监听消息，双向通讯其实就是在单向通讯的基础上，当单向通讯已经建立了，就可以传送自己线程的SendPort，然后用ReveivePort监听SendPort发送的消息。

```dart
import 'dart:isolate';

void main(List<String> args) {
  multiThread();
}

void multiThread() async {
  print('multiThread start');
  print('当前线程：' + Isolate.current.debugName!);
  // 接收端口
  ReceivePort r1 = ReceivePort();
  // 发送端口
  SendPort p1 = r1.sendPort;
  Isolate.spawn(newThread, p1);

  // 接收新线程发送过来的消息
  // r1.listen((message) {
  // print('来自新线程的消息：' + message.toString());
  // // 如果不关闭的话主线程会被阻塞
  // r1.close();
  // });

  SendPort p2 = await r1.first;
  p2.send('来自主线程的消息');
  print('multiThread end');
}

void newThread(SendPort p1) {
  print('当前线程：' + Isolate.current.debugName!);
  ReceivePort r2 = ReceivePort();
  SendPort p2 = r2.sendPort;
  // 发送消息给 main 线程
  p1.send(p2);
  r2.listen((message) {
    print(message);
  });
}
```


代码执行结果：
```bash
multiThread start
当前线程：main
当前线程：newThread
multiThread end
来自主线程的消息
```


# Isolate.spawnUri() - Creates and spawns an isolate that runs the code from the library with the specified URI.




主线程文件：
```dart
import 'dart:isolate';

void main(List<String> args) {
  start();
  // 执行耗时的任务
  newIsolate();
  init();
}

void start() {
  print('应用启动:' + DateTime.now().microsecondsSinceEpoch.toString());
}

void newIsolate() async {
  print('新线程创建');
  ReceivePort r = ReceivePort();
  SendPort p = r.sendPort;

  // 创建新线程
  Isolate childIsolate = await Isolate.spawnUri(
    Uri(path: 'childIsolate.dart'),
    ['data1', 'data2', 'data3'],
    p,
  );

  // 监听消息
  r.listen((message) {
    print('主线程接收到数据：${message[0]}');
    if (message[1] == 1) {
      // 异步任务正在处理
    } else if (message[1] == 2) {
      // 取消监听
      r.close();
      // 杀死新线程，释放资源
      childIsolate.kill();
      print('子线程已经释放');
    }
  });
}

init() {print('这是在init方法中');}
```


子线程文件：
```dart
import 'dart:io';
import 'dart:isolate';

void main(List<String> args, SendPort mainSendPort) {
  print('新线程接受到的参数：$args');
  mainSendPort.send(['开始执行异步', 0]);
  sleep(Duration(seconds: 1));
  mainSendPort.send(['加载中', 1]);
  sleep(Duration(seconds: 1));
  mainSendPort.send(['异步任务完成', 2]);
}
```

执行结果：
```bash
应用启动:1658285199756744
新线程创建
这是在init方法中
新线程接受到的参数：[data1, data2, data3]
主线程接收到数据：开始执行异步
主线程接收到数据：加载中
主线程接收到数据：异步任务完成
子线程已经释放
```