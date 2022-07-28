---
title: Github Action 补充介绍
date: 2022-04-12 13:04:03
categories: Devops
tags:
- Github Action
- CICD
- Docker
- Openstack
---

`目录：`（可以按`w`快捷键切换大纲视图）
[TOC]

# 其他补充
继续上篇文章 {% post_link blog-cicd %} 

上篇的介绍对于hexo部署已经足够了，也可以干其他很多事情，不过github action还有些强大的特性没涉及，补充罗列下其他常用的地方，不得不说设计太精妙了。Github被微软收购后，竟然变更强了。Intel推出的12代酷睿，性能远超mac的m1了，这次没挤牙膏。Wintel的时代没有过去，老当益壮，还可再战。

## Github Action 的使用限制
2000分钟/月 的总使用时长限制，每个 Workflow 中的 job 最多可以执行 6 个小时 每个 Workflow 最多可以执行 72 小时 每个 Workflow 中的 job 最多可以排队 24 小时 在一个存储库的所有 Action 中，一个小时最多可以执行 1000 个 API 请求 并发工作数：Linux：20，Mac：5。

> 这些限制对于个人开发足够了。当然也限制了使用Github的资源当服务器，Github有那Github当服务器的action，使用了该action，可以ssh到Github服务器上使用服务器的算力，Github的服务器性能还是非常强劲的。

## 什么是Workflow
Workflow 是由一个或多个 job 组成的可配置的自动化过程。可以自定义名称，Github Action页面就会显示自定义的名称，否则用默认的命名方式。

on 可以定义 触发 Workflow 执行的 event 名称。下面是最常用的两种。

    // 单个事件
    on: push
    
    // 多个事件
    on: [push,pull_request]

## Workflow 的 job 是什么？ 以及不同的job之间如何共享数据

一个 Workflow 由一个或多个 jobs 构成，含义是一次持续集成的运行，可以完成多个任务，Github任务叫step，一个step可以有多个action。

因为一个job对应一次持续集成。不同的job是不能共享数据的。上面的hexo两次ci.yaml定义的workflow都是单job的。Github默认多job是并行执行的。

job必须定义id，且id就是key，这个和step不同，step的id和name是用key value对定义的，且不同的step是以数组的形式，按书写顺序，顺序执行。job的name 会显示在 Github Action页面上。

    jobs:
        my_first_job:
            name: My first job
        my_second_job:
            name: My second job

needs 可以标识 job 是否依赖于别的 job——如果 job 失败，则会跳过所有需要该 job 的 job

    jobs:
        job1:
        job2:
            needs: job1
        job3:
            needs: [job1, job2]

不同的job之间如何共享数据 可以通过  和need打配合共享字符串变量 或者  artifact 在 workflow job 之间共享数据
### 和need打配合共享字符串变量
```yaml
jobs:
  job1:
    runs-on: ubuntu-latest
    # Map a step output to a job output
    outputs:
      output1: ${{ steps.step1.outputs.test }}
      output2: ${{ steps.step2.outputs.test }}
    steps:
    - id: step1
      run: echo "::set-output name=test::hello"
    - id: step2
      run: echo "::set-output name=test::world"
  job2:
    runs-on: ubuntu-latest
    needs: job1
    steps:
    - run: echo ${{needs.job1.outputs.output1}} ${{needs.job1.outputs.output2}}
```
### artifact 在 workflow job 之间共享数据
Github actions Artifact 可以用来存储action生产出来的产物，比如npm build生成的静态文件。当上传成功后，后续的流程就可以下载这些文件来使用。

其中一个job要上传文件到Github actions Artifact，use使用 actions/upload-artifact@v2

```yaml
- uses: actions/upload-artifact@v2
  with:
  name: agileconfig-ui   # name：上传的artifact的名称，下载的时候需要使用。
  path: xxx/yyy/   # path：需要上传的文件夹的path
```

另一个job需要needs上传文件的job，use使用 actions/download-artifact@v2

```yaml
- uses: actions/download-artifact@v2
  with:
    name: agileconfig-ui   # name：需要下载的artifact的名称
    path: aaa/bbb   # path：下载后存储数据的path
```

> Github actions Artifact除了可以不同job共享文件，也可以手动到Github Action下载文件，比如编译打包后的文件。

## 定义环境变量
### job定义环境变量

    jobs:
        job1:
            env:
                FIRST_NAME: Mona

### step定义环境变量

```yaml
    steps:
    # 定义 step 的名称
    - name: Print a greeting
      # 定义 step 的环境变量
      env:
        MY_VAR: Hi there! My name is
        FIRST_NAME: Mona
        MIDDLE_NAME: The
        LAST_NAME: Octocat
      # 运行指令：输出环境变量
      run: |
        echo $MY_VAR $FIRST_NAME $MIDDLE_NAME $LAST_NAME
```

## 什么是矩阵？
就是有时候，我们的代码可能编译环境有多个。我们需要在 macos 上编译 dmg 压缩包，在 windows 上编译 exe 可执行文件。这种时候，我们使用矩阵就可以啦~

比如下面的代码，我们使用了矩阵指定了：2 个操作系统，3 个 node 版本。

这时候下面这段代码就会执行 6 次—— 2 x 3 = 6！！！

```yaml
runs-on: ${{ matrix.os }}
strategy:
  matrix:
    os: [ubuntu-16.04, ubuntu-18.04]
    node: [6, 8, 10]
steps:
  - uses: actions/setup-node@v1
    with:
      node-version: ${{ matrix.node }}
```

## 跳过Github Actions 或者 选择性的执行CICD流程
在 commit 信息中只要包含了下面几个关键词就会跳过 CI，不会触发 CI Build

    [skip ci]
    [ci skip]
    [no ci]
    [skip actions]
    [actions skip]

需求：不想每次提交都触发Github Actions构建，只有git commit message不包含指定的内容才触发

Github Actions 支持 jobs.<job_id>.if (opens new window)语法 Github Actions运行中我们可以拿到一些当前的环境信息，比如git的提交内容信息，通过这些内容来控制actions的执行

比如，当git message不包含wip才触发构建

    jobs:
        format:
            runs-on: ubuntu-latest
            if: "! contains(github.event.head_commit.message, 'wip')"

同理，下面的workflow表示，只有git message中包含[build]才触发构建，否则跳过

    jobs:
        format:
            runs-on: ubuntu-latest
            if: "contains(github.event.head_commit.message, '[build]')"

## 如何手动触发构建
默认情况只有push和pull request动作才会触发构建

    on:
        push:
            branches: [ main ]
        pull_request:
            branches: [ main ]

最简单的做法，添加workflow_dispatch动作

    on:
        workflow_dispatch:
        push:
            branches: [ main ]
        pull_request:
            branches: [ main ]

这样在actions页面可以看到执行构建的按钮，选择分支后可以执行手动构建。
![](/images/blog-cicd/img.png)

```yaml
on:
  workflow_dispatch:
    inputs:
      name:
        description: 'Person to greet'
        required: true
        default: 'Mona the Octocat'
      home:
        description: 'location'
        required: false

jobs:
  say_hello:
    runs-on: ubuntu-latest
    steps:
    - run: |
        echo "Hello ${{ github.event.inputs.name }}!"
        echo "- in ${{ github.event.inputs.home }}!"
```
关于手动触发还支持自定义输入文本，也就是输入文本当成传入的参数，用在后续的构建命令中
![](/images/blog-cicd/img_1.png)

## 代码检查 以bash脚本检查为例

```yaml
name: shellcheck
'on':
  push:
  pull_request:
  schedule:
    - cron: '0 1 * * *'

jobs:

  shellcheck:
    name: shellcheck
    runs-on: ubuntu-latest

    steps:
      - name: Check out the codebase.
        uses: actions/checkout@v2

      - name: Install shellcheck from GitHub releases
        run: |
          sudo curl -L https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.$(uname -s).$(uname -m).tar.xz -o shellcheck.tar.xz
          sudo tar -xvf shellcheck.tar.xz
          sudo mv shellcheck-v${SHELLCHECK_VERSION}/shellcheck /usr/local/bin/shellcheck
          sudo chmod 755 /usr/local/bin/shellcheck
          shellcheck --version
        env:
          SHELLCHECK_VERSION: 0.7.2

      - name: Shellcheck!
        run: |
          shellcheck 代码仓库里要检查的脚本的路径
          shellcheck 代码仓库里要检查的脚本的路径
```

## GitHub Actions 编译安卓
```yaml
name: android_build

on:
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout the code
        # 拉取 android_builder 的源代码
        uses: actions/checkout@v2
      - name: Set up JDK
        # 设置 Java 运行环境
        uses: actions/setup-java@v1
        with:
          java-version: 1.8
          # 用 1.8 版本覆盖环境中自带的 Java 11 版本
      - id: get-project
        # 读取项目地址
        name: Get project name
        run: echo "::set-output name=PROJECT::$(cat project-to-build)"
      - name: Clone project
        # 拉取项目源码到虚拟环境
        run: git clone --depth=1 ${{ steps.get-project.outputs.PROJECT }} project
      - name: Build the app
        # 构建调试版 APK
        working-directory: ./project
        run: |
          if [ ! -f "gradlew" ]; then gradle wrapper; fi
          chmod +x gradlew
          ./gradlew assembleDebug --stacktrace
      - name: Upload APK
        # 打包上传生成的 APK 到的网页端
        uses: actions/upload-artifact@v2
        with:
          name: my-build-apk
          path: ./**/*.apk
```


## Docker构建镜像和推送到Docker Hub
进到 https://hub.docker.com/settings/security 生成access token，注意好记好。 然后打开Github到Settings > Secrets > New secret添加两条记录：

* 键名：DOCKER_HUB_USERNAME，值是Docker hub的用户名
* 键名：DOCKER_HUB_ACCESS_TOKEN，值是刚才复制的access token，值类似c292155d-1bd7-xxxx-xxxx-4da75bedb178

```yaml
name: CI to Docker Hub 

on:
  push:
        branches: [ master ]
   # tags:
   #   - "v*.*.*"

jobs:

  build:
    runs-on: ubuntu-latest
    steps:
      -
        name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1
      -
        name: Login to DockerHub
        uses: docker/login-action@v1 
        with:
          username: ${{ secrets.DOCKER_HUB_USERNAME }}
          password: ${{ secrets.DOCKER_HUB_ACCESS_TOKEN }}
      -
        name: Build and push
        id: docker_build
        uses: docker/build-push-action@v2
        with:
          push: true
          tags: finleyma/simplewhale:latest
          build-args: |
            arg1=value1
            arg2=value2
      -
        name: Image digest
        run: echo ${{ steps.docker_build.outputs.digest }}
```

## Github Action 部署 Openstack 环境
下面两个例子分别是 在最新的几个Openstack版本 T-X版 `部署nova等基本服务` 和 `部署Ironic等服务` 的例子

```yaml
jobs:
  functional-compute:
    strategy:
      fail-fast: false
      matrix:
        name: ["master"]
        openstack_version: ["master"]
        ubuntu_version: ["20.04"]
        include:
          - name: "xena"
            openstack_version: "stable/xena"
            ubuntu_version: "20.04"
          - name: "wallaby"
            openstack_version: "stable/wallaby"
            ubuntu_version: "20.04"
          - name: "victoria"
            openstack_version: "stable/victoria"
            ubuntu_version: "20.04"
          - name: "ussuri"
            openstack_version: "stable/ussuri"
            ubuntu_version: "18.04"
          - name: "train"
            openstack_version: "stable/train"
            ubuntu_version: "18.04"
    runs-on: ubuntu-${{ matrix.ubuntu_version }}
    name: Deploy OpenStack ${{ matrix.name }} with Nova and run compute acceptance tests
    steps:
      - name: Deploy devstack
        uses: EmilienM/devstack-action@v0.6
        with:
          branch: ${{ matrix.openstack_version }}
          conf_overrides: |
            CINDER_ISCSI_HELPER=tgtadm
```

```yaml
jobs:
  functional-baremetal:
    strategy:
      fail-fast: false
      matrix:
        name: ["master"]
        openstack_version: ["master"]
        ubuntu_version: ["20.04"]
        include:
          - name: "xena"
            openstack_version: "stable/xena"
            ubuntu_version: "20.04"
          - name: "wallaby"
            openstack_version: "stable/wallaby"
            ubuntu_version: "20.04"
          - name: "victoria"
            openstack_version: "stable/victoria"
            ubuntu_version: "20.04"
          - name: "ussuri"
            openstack_version: "stable/ussuri"
            ubuntu_version: "18.04"
          - name: "train"
            openstack_version: "stable/train"
            ubuntu_version: "18.04"
    runs-on: ubuntu-${{ matrix.ubuntu_version }}
    name: Deploy OpenStack ${{ matrix.name }} with Ironic and run baremetal acceptance tests
    steps:
      - name: Deploy devstack
        uses: EmilienM/devstack-action@v0.6
        with:
          branch: ${{ matrix.openstack_version }}
          conf_overrides: |
            enable_plugin ironic https://opendev.org/openstack/ironic ${{ matrix.openstack_version }}
            LIBS_FROM_GIT=pyghmi,virtualbmc
            FORCE_CONFIG_DRIVE=True
            Q_AGENT=openvswitch
            Q_ML2_TENANT_NETWORK_TYPE=vxlan
            Q_ML2_PLUGIN_MECHANISM_DRIVERS=openvswitch
            DEFAULT_INSTANCE_TYPE=baremetal
            OVERRIDE_PUBLIC_BRIDGE_MTU=1400
            VIRT_DRIVER=ironic
            BUILD_TIMEOUT=1800
            SERVICE_TIMEOUT=90
            GLANCE_LIMIT_IMAGE_SIZE_TOTAL=5000
            Q_USE_SECGROUP=False
            API_WORKERS=1
            IRONIC_BAREMETAL_BASIC_OPS=True
            IRONIC_BUILD_DEPLOY_RAMDISK=False
            IRONIC_AUTOMATED_CLEAN_ENABLED=False
            IRONIC_CALLBACK_TIMEOUT=600
            IRONIC_DEPLOY_DRIVER=ipmi
            IRONIC_INSPECTOR_BUILD_RAMDISK=False
            IRONIC_RAMDISK_TYPE=tinyipa
            IRONIC_TEMPEST_BUILD_TIMEOUT=720
            IRONIC_TEMPEST_WHOLE_DISK_IMAGE=False
            IRONIC_VM_COUNT=1
            IRONIC_VM_EPHEMERAL_DISK=1
            IRONIC_VM_LOG_DIR=/opt/stack/new/ironic-bm-logs
            IRONIC_VM_SPECS_RAM=1024
            IRONIC_DEFAULT_DEPLOY_INTERFACE=direct
            IRONIC_ENABLED_DEPLOY_INTERFACES=direct
            SWIFT_ENABLE_TEMPURLS=True
            SWIFT_TEMPURL_KEY=secretkey
          enabled_services: 'ir-api,ir-cond,s-account,s-container,s-object,s-proxy,q-svc,q-agt,q-dhcp,q-l3,q-meta,-cinder,-c-sch,-c-api,-c-vol,-c-bak,-ovn,-ovn-controller,-ovn-northd,-q-ovn-metadata-agent'
```
![](/images/blog-cicd/img3.png)
![](/images/blog-cicd/img4.png)
这样仅一顿饭的功夫，自动完成了5，6个最新版本的openstack环境的并行准备。