---
title: WebAssembly hello-world
readmore: false
date: 2022-07-21 12:38:55
categories: Fuchsia
tags:

---

> 在说 WebAssembly hello-world 前顺带提下Flutter

这 两个有个共同的特点：在js/ts统治的前端世界里的潜力股。js占领着前端的统治地位，又来了ts弥补缺陷加持统治地位，ts还有ms在强推，github被ms收购了后更加联合github一起强推。

# Flutter hello-world

```dart
// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
```
![](/images/wasm-hello/2022-07-21-12-05-52.png)
![](/images/wasm-hello/2022-07-21-12-07-50.png)

> 代码和run流程没啥好说的，写了一个标题，写了一个Hello World文本内容。相对于WebAssembly hello-world比较简单。

为何要重视Flutter。主要是：
* 全端框架，一次开发，web，安卓，ios全有了
* 原生运行
* google在推
* 一个框架带起来了一个编程语言dart，这个比较少见
* Flutter 是未来 Fuchsia 的UI开发框架
* Flutter项目的star数是我印象中见过最多的，这说明活力高



# WebAssembly hello-world

WebAssembly的出现不是完全取代js，只是为了取代js的一个应用领域：浏览器进行计算密集型应用。

WebAssembly实现的目标之一是：编译一次，到处运行。这句话在java虚拟机，容器中似曾相识。

WebAssembly借助云计算，区块链的东风发展起来。

## 克隆项目模板

```bash
PS C:\Users\hanwei> cd tt
PS C:\Users\hanwei\tt> cargo generate --git https://github.com/rustwasm/wasm-pack-template
🤷   Project Name : wasm-game-of-life
🔧   Basedir: C:\Users\hanwei\tt ...
🔧   Generating template ...
[ 1/12]   Done: .appveyor.yml
[ 2/12]   Done: .gitignore
[ 3/12]   Done: .travis.yml
[ 4/12]   Done: Cargo.toml
[ 5/12]   Done: LICENSE_APACHE
[ 6/12]   Done: LICENSE_MIT
[ 7/12]   Done: README.md
[ 8/12]   Done: src\lib.rs
[ 9/12]   Done: src\utils.rs
[10/12]   Done: src
[11/12]   Done: tests\web.rs
[12/12]   Done: tests
🔧   Moving generated files into: `C:\Users\hanwei\tt\wasm-game-of-life`...
💡   Initializing a fresh Git repository
✨   Done! New project created C:\Users\hanwei\tt\wasm-game-of-life
```

> 会提示输入新项目的名称。这里用的是wasm-game-of-life。

## 构建项目
```bash
PS C:\Users\hanwei\tt> cd .\wasm-game-of-life\
PS C:\Users\hanwei\tt\wasm-game-of-life> wasm-pack build
[INFO]: Checking for the Wasm target...
info: downloading component 'rust-std' for 'wasm32-unknown-unknown'
info: installing component 'rust-std' for 'wasm32-unknown-unknown'
[INFO]: Compiling to Wasm...
   Compiling proc-macro2 v1.0.40
   Compiling unicode-ident v1.0.2
   Compiling quote v1.0.20
   Compiling syn v1.0.98
   Compiling wasm-bindgen-shared v0.2.81
   Compiling log v0.4.17
   Compiling cfg-if v1.0.0
   Compiling bumpalo v3.10.0
   Compiling lazy_static v1.4.0
   Compiling wasm-bindgen v0.2.81
   Compiling wasm-bindgen-backend v0.2.81
   Compiling wasm-bindgen-macro-support v0.2.81
   Compiling wasm-bindgen-macro v0.2.81
   Compiling console_error_panic_hook v0.1.7
   Compiling wasm-game-of-life v0.1.0 (C:\Users\hanwei\tt\wasm-game-of-life)
warning: function is never used: `set_panic_hook`
 --> src\utils.rs:1:8
  |
1 | pub fn set_panic_hook() {
  |        ^^^^^^^^^^^^^^
  |
  = note: `#[warn(dead_code)]` on by default

warning: `wasm-game-of-life` (lib) generated 1 warning
    Finished release [optimized] target(s) in 4.81s
[INFO]: Installing wasm-bindgen...
[INFO]: Optimizing wasm binaries with `wasm-opt`...
[INFO]: Optional fields missing from Cargo.toml: 'description', 'repository', and 'license'. These are not necessary, but recommended
[INFO]: :-) Done in 15.41s
[INFO]: :-) Your wasm pkg is ready to publish at C:\Users\hanwei\tt\wasm-game-of-life\pkg.
```

build后多出了pkg和target两个目录

```bash
PS C:\Users\hanwei\tt\wasm-game-of-life> ls


    目录: C:\Users\hanwei\tt\wasm-game-of-life


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         2022/7/21     10:23                pkg
d-----         2022/7/21     10:17                src
d-----         2022/7/21     10:23                target
d-----         2022/7/21     10:17                tests
-a----         2022/7/21     10:17            351 .appveyor.yml
-a----         2022/7/21     10:17             60 .gitignore
-a----         2022/7/21     10:17           3043 .travis.yml
-a----         2022/7/21     10:23           6663 Cargo.lock
-a----         2022/7/21     10:17           1046 Cargo.toml
-a----         2022/7/21     10:17          11051 LICENSE_APACHE
-a----         2022/7/21     10:17           1098 LICENSE_MIT
-a----         2022/7/21     10:17           2861 README.md


PS C:\Users\hanwei\tt\wasm-game-of-life> cd .\target\
PS C:\Users\hanwei\tt\wasm-game-of-life\target> ls


    目录: C:\Users\hanwei\tt\wasm-game-of-life\target


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         2022/7/21     10:23                release
d-----         2022/7/21     10:23                wasm32-unknown-unknown
-a----         2022/7/21     10:23           2071 .rustc_info.json
-a----         2022/7/21     10:23            177 CACHEDIR.TAG


PS C:\Users\hanwei\tt\wasm-game-of-life\target> cd ..\pkg
PS C:\Users\hanwei\tt\wasm-game-of-life\pkg> ls


    目录: C:\Users\hanwei\tt\wasm-game-of-life\pkg


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         2022/7/21     10:23              1 .gitignore
-a----         2022/7/21     10:23            353 package.json
-a----         2022/7/21     10:17           2861 README.md
-a----         2022/7/21     10:23             80 wasm_game_of_life.d.ts
-a----         2022/7/21     10:23             95 wasm_game_of_life.js
-a----         2022/7/21     10:23            829 wasm_game_of_life_bg.js
-a----         2022/7/21     10:23            284 wasm_game_of_life_bg.wasm
-a----         2022/7/21     10:23            114 wasm_game_of_life_bg.wasm.d.ts
```

## 将其嵌入网页

```bash
PS C:\Users\hanwei\tt\wasm-game-of-life\pkg> cd ..
PS C:\Users\hanwei\tt\wasm-game-of-life> npm init wasm-app www
Need to install the following packages:
  create-wasm-app@0.1.0
Ok to proceed? (y) y
🦀 Rust + 🕸 Wasm = ❤
PS C:\Users\hanwei\tt\wasm-game-of-life> cd www
PS C:\Users\hanwei\tt\wasm-game-of-life\www> ls


    目录: C:\Users\hanwei\tt\wasm-game-of-life\www


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         2022/7/21     10:29                .bin
-a----         2022/7/21     10:29             20 .gitignore
-a----         2022/7/21     10:29             78 .travis.yml
-a----         2022/7/21     10:29            284 bootstrap.js
-a----         2022/7/21     10:29            308 index.html
-a----         2022/7/21     10:29             59 index.js
-a----         2022/7/21     10:29          11051 LICENSE-APACHE
-a----         2022/7/21     10:29           1077 LICENSE-MIT
-a----         2022/7/21     10:29         215279 package-lock.json
-a----         2022/7/21     10:29            973 package.json
-a----         2022/7/21     10:29           2662 README.md
-a----         2022/7/21     10:29            325 webpack.config.js
```

## 安装依赖

```bash
PS C:\Users\hanwei\tt\wasm-game-of-life\www> npm install
npm WARN old lockfile
npm WARN old lockfile The package-lock.json file was created with an old version of npm,
npm WARN old lockfile so supplemental metadata must be fetched from the registry.
npm WARN old lockfile
npm WARN old lockfile This is a one-time fix-up, please be patient...
npm WARN old lockfile
npm WARN deprecated urix@0.1.0: Please see https://github.com/lydell/urix#deprecated
npm WARN deprecated uuid@3.3.2: Please upgrade  to version 7 or higher.  Older versions may use Math.random() in certain circumstances, which is known to be problematic.  See https://v8.dev/blog/math-random for details.
npm WARN deprecated source-map-url@0.4.0: See https://github.com/lydell/source-map-url#deprecated
npm WARN deprecated source-map-resolve@0.5.2: See https://github.com/lydell/source-map-resolve#deprecated
npm WARN deprecated resolve-url@0.2.1: https://github.com/lydell/resolve-url#deprecated
npm WARN deprecated querystring@0.2.0: The querystring API is considered Legacy. new code should use the URLSearchParams API instead.
npm WARN deprecated mkdirp@0.5.1: Legacy versions of mkdirp are no longer supported. Please update to mkdirp 1.x. (Note that the API surface has changed to use Promises in 1.x.)
npm WARN deprecated ini@1.3.5: Please update to ini >=1.3.6 to avoid a prototype pollution issue
npm WARN deprecated debug@4.1.1: Debug versions >=3.2.0 <3.2.7 || >=4 <4.3.1 have a low-severity ReDos regression when used in a Node.js environment. It is recommended you upgrade to 3.2.7 or 4.3.1. (https://github.com/visionmedia/debug/issues/797)
npm WARN deprecated chokidar@2.1.8: Chokidar 2 does not receive security updates since 2019. Upgrade to chokidar 3 with 15x fewer dependencies
npm WARN deprecated debug@3.2.6: Debug versions >=3.2.0 <3.2.7 || >=4 <4.3.1 have a low-severity ReDos regression when used in a Node.js environment. It is recommended you upgrade to 3.2.7 or 4.3.1. (https://github.com/visionmedia/debug/issues/797)
npm WARN deprecated uuid@3.4.0: Please upgrade  to version 7 or higher.  Older versions may use Math.random() in certain circumstances, which is known to be problematic.  See https://v8.dev/blog/math-random for details.
npm WARN deprecated debug@3.2.6: Debug versions >=3.2.0 <3.2.7 || >=4 <4.3.1 have a low-severity ReDos regression when used in a Node.js environment. It is recommended you upgrade to 3.2.7 or 4.3.1. (https://github.com/visionmedia/debug/issues/797)
npm WARN deprecated debug@3.2.6: Debug versions >=3.2.0 <3.2.7 || >=4 <4.3.1 have a low-severity ReDos regression when used in a Node.js environment. It is recommended you upgrade to 3.2.7 or 4.3.1. (https://github.com/visionmedia/debug/issues/797)

added 587 packages, and audited 588 packages in 8s

18 packages are looking for funding
  run `npm fund` for details

29 vulnerabilities (7 moderate, 19 high, 3 critical)

To address all issues, run:
  npm audit fix

Run `npm audit` for details.
```

## 使用本地wasm-game-of-life包

```bash
PS C:\Users\hanwei\tt\wasm-game-of-life\www> cd ../pkg
PS C:\Users\hanwei\tt\wasm-game-of-life\pkg> npm link

added 1 package, and audited 3 packages in 649ms

found 0 vulnerabilities
PS C:\Users\hanwei\tt\wasm-game-of-life\pkg> cd ../www
PS C:\Users\hanwei\tt\wasm-game-of-life\www> npm link wasm-game-of-life

added 1 package, and audited 590 packages in 1s

18 packages are looking for funding
  run `npm fund` for details

28 vulnerabilities (7 moderate, 18 high, 3 critical)

To address all issues, run:
  npm audit fix

Run `npm audit` for details.
PS C:\Users\hanwei\tt\wasm-game-of-life\www> notepad index.js
```

## opensslErrorStack: [ 'error:03000086:digital envelope routines::initialization error' ]
```bash
PS C:\Users\hanwei\tt\wasm-game-of-life\www> npm run start

> create-wasm-app@0.1.0 start
> webpack-dev-server

(node:83776) [DEP0111] DeprecationWarning: Access to process.binding('http_parser') is deprecated.
(Use `node --trace-deprecation ...` to show where the warning was created)
i ｢wds｣: Project is running at http://localhost:8080/
i ｢wds｣: webpack output is served from /
i ｢wds｣: Content not from webpack is served from C:\Users\hanwei\tt\wasm-game-of-life\www
node:internal/crypto/hash:71
  this[kHandle] = new _Hash(algorithm, xofLen);
                  ^

Error: error:0308010C:digital envelope routines::unsupported
    at new Hash (node:internal/crypto/hash:71:19)
    at Object.createHash (node:crypto:133:10)
    at module.exports (C:\Users\hanwei\tt\wasm-game-of-life\www\node_modules\webpack\lib\util\createHash.js:135:53)
    at NormalModule._initBuildHash (C:\Users\hanwei\tt\wasm-game-of-life\www\node_modules\webpack\lib\NormalModule.js:417:16)
    at handleParseError (C:\Users\hanwei\tt\wasm-game-of-life\www\node_modules\webpack\lib\NormalModule.js:471:10)
    at C:\Users\hanwei\tt\wasm-game-of-life\www\node_modules\webpack\lib\NormalModule.js:503:5
    at C:\Users\hanwei\tt\wasm-game-of-life\www\node_modules\webpack\lib\NormalModule.js:358:12
    at C:\Users\hanwei\tt\wasm-game-of-life\www\node_modules\loader-runner\lib\LoaderRunner.js:373:3
    at iterateNormalLoaders (C:\Users\hanwei\tt\wasm-game-of-life\www\node_modules\loader-runner\lib\LoaderRunner.js:214:10)
    at Array.<anonymous> (C:\Users\hanwei\tt\wasm-game-of-life\www\node_modules\loader-runner\lib\LoaderRunner.js:205:4)    at Storage.finished (C:\Users\hanwei\tt\wasm-game-of-life\www\node_modules\enhanced-resolve\lib\CachedInputFileSystem.js:43:16)
    at C:\Users\hanwei\tt\wasm-game-of-life\www\node_modules\enhanced-resolve\lib\CachedInputFileSystem.js:79:9
    at C:\Users\hanwei\tt\wasm-game-of-life\www\node_modules\graceful-fs\graceful-fs.js:78:16
    at FSReqCallback.readFileAfterClose [as oncomplete] (node:internal/fs/read_file_context:68:3) {
  opensslErrorStack: [ 'error:03000086:digital envelope routines::initialization error' ],
  library: 'digital envelope routines',
  reason: 'unsupported',
  code: 'ERR_OSSL_EVP_UNSUPPORTED'
}

Node.js v18.6.0
```

> node版本太高了，降级node版本即可。

## run
```bash
PS C:\Users\hanwei\tt\wasm-game-of-life\www> node -v
v16.16.0
PS C:\Users\hanwei\tt\wasm-game-of-life\www> npm run start
npm WARN config global `--global`, `--local` are deprecated. Use `--location=global` instead.

> create-wasm-app@0.1.0 start
> webpack-dev-server

(node:100900) [DEP0111] DeprecationWarning: Access to process.binding('http_parser') is deprecated.
(Use `node --trace-deprecation ...` to show where the warning was created)
i ｢wds｣: Project is running at http://localhost:8080/
i ｢wds｣: webpack output is served from /
i ｢wds｣: Content not from webpack is served from C:\Users\hanwei\tt\wasm-game-of-life\www
i ｢wdm｣: Hash: 675aa614c674d1267776
Version: webpack 4.43.0
Time: 218ms
Built at: 2022/07/21 11:00:21
                           Asset       Size  Chunks                         Chunk Names
                  0.bootstrap.js   5.63 KiB       0  [emitted]
2e5f49bf085dfeb02627.module.wasm  310 bytes       0  [emitted] [immutable]
                    bootstrap.js    369 KiB    main  [emitted]              main
                      index.html  308 bytes          [emitted]
Entrypoint main = bootstrap.js
[0] multi (webpack)-dev-server/client?http://localhost:8080 ./bootstrap.js 40 bytes {main} [built]
[../pkg/wasm_game_of_life.js] 95 bytes {0} [built]
[./bootstrap.js] 284 bytes {main} [built]
[./index.js] 59 bytes {0} [built]
[./node_modules/ansi-html/index.js] 4.16 KiB {main} [built]
[./node_modules/ansi-regex/index.js] 135 bytes {main} [built]
[./node_modules/strip-ansi/index.js] 161 bytes {main} [built]
[./node_modules/webpack-dev-server/client/index.js?http://localhost:8080] (webpack)-dev-server/client?http://localhost:8080 4.29 KiB {main} [built]
[./node_modules/webpack-dev-server/client/overlay.js] (webpack)-dev-server/client/overlay.js 3.51 KiB {main} [built]
[./node_modules/webpack-dev-server/client/socket.js] (webpack)-dev-server/client/socket.js 1.53 KiB {main} [built]
[./node_modules/webpack-dev-server/client/utils/createSocketUrl.js] (webpack)-dev-server/client/utils/createSocketUrl.js 2.91 KiB {main} [built]
[./node_modules/webpack-dev-server/client/utils/log.js] (webpack)-dev-server/client/utils/log.js 964 bytes {main} [built]
[./node_modules/webpack-dev-server/client/utils/reloadApp.js] (webpack)-dev-server/client/utils/reloadApp.js 1.59 KiB {main} [built]
[./node_modules/webpack-dev-server/client/utils/sendMessage.js] (webpack)-dev-server/client/utils/sendMessage.js 402 bytes {main} [built]
[./node_modules/webpack/hot sync ^\.\/log$] (webpack)/hot sync nonrecursive ^\.\/log$ 170 bytes {main} [built]
    + 23 hidden modules
i ｢wdm｣: Compiled successfully.
```

## 浏览器打开效果：
![](/images/wasm-hello/2022-07-21-11-01-33.png)

