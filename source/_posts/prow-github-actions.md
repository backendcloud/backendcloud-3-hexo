---
title: prow-github-actions
readmore: true
date: 2022-07-14 18:52:47
categories: Devops
tags:
- Prow
- Github Action

---


# prow-github-actions

prow-github-actions和Kubernetes Prow不是一个东西，prow-github-actions是受Kubernetes Prow启发而写的，是个Github Action。可以理解成是个适用于个人的轻量版的prow。

# 和Kubernetes Prow对比

| 对比 | prow-github-actions | Kubernetes Prow |
| --- | --- | --- |
| 代码仓库 | https://github.com/jpmcb/prow-github-actions | https://github.com/kubernetes/test-infra/tree/master/prow |
| 二次开发，定制 | 不太方便，功能固定 | 方便，功能可扩展 |
| 应用场景 | 个人项目仓库 | 组织项目仓库 |
| 所需资源 | 啥都不需要 | 需要创建一个github机器人账号，需要k8s集群以及硬件资源，网络资源，创建钩子，部署，二次开发 |
| 缺点 | 受2000分钟/月 的Github Action限制，处理需要一定的时间响应时间略长 | 除了没有前者轻量，没啥缺点 |


# 代码仓库配置prow-github-actions

只要加上这两个Github Action文件。

```yaml
name: "Prow github actions"
on:
  issue_comment:
    types: [created]

jobs:
  execute:
    runs-on: ubuntu-latest
    steps:
      - uses: jpmcb/prow-github-actions@v1.0.0
        with:
          prow-commands: '/assign 
            /unassign 
            /approve 
            /retitle 
            /area 
            /kind 
            /priority 
            /remove 
            /lgtm 
            /close 
            /reopen 
            /lock 
            /milestone 
            /hold 
            /cc 
            /uncc'
          github-token: "${{ secrets.GITHUB_TOKEN }}"
```

```yaml
name: "Merge on lgtm label"
on:
  schedule:
  - cron: "0 * * * *"

jobs:
  execute:
    runs-on: ubuntu-latest
    steps:
      - uses: jpmcb/prow-github-actions@v1.0.0
        with:
          jobs: 'lgtm'
          github-token: "${{ secrets.GITHUB_TOKEN }}"

          # this is optional and defaults to 'merge'
          merge-method: 'squash'
```



# demo
## 代码仓库收到其他fork的代码仓库的pr
![](/images/prow-github-actions/image1.png)

## /assign
![](/images/prow-github-actions/2022-07-14-17-13-56.png)


## /lgtm
![](/images/prow-github-actions/2022-07-14-17-12-42.png)

## /approve
![](/images/prow-github-actions/2022-07-14-17-16-14.png)

## /close
![](/images/prow-github-actions/2022-07-14-17-26-55.png)

## /reopen
![](/images/prow-github-actions/2022-07-14-17-28-11.png)

