---
title: Dart 多线程
date: 2022-07-20 13:17:28
categories: Fuchsia
tags:

---

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
```powershell
C:/sdk/dart2.17.6/bin/dart.exe --enable-asserts C:\Users\hanwei\AndroidStudioProjects\untitled\bin\untitled.dart
应用启动:1658285199756744
新线程创建
这是在init方法中
新线程接受到的参数：[data1, data2, data3]
主线程接收到数据：开始执行异步
主线程接收到数据：加载中
主线程接收到数据：异步任务完成
子线程已经释放

Process finished with exit code 0
```