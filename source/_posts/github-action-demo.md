---
title: 试用Github Action CI/CD流程（创建一个React项目，并打包部署）
date: 2022-02-25 11:54:20
categories: Tools
tags:
- CI/CD
- Github Action
- React

---

创建一个React项目`github-action-demo`

将（将backendcloud替换成你到github账户名）

	"homepage": "https://backendcloud.github.io/github-actions-demo",

添加到package.json

push到github仓库。

增加github aciton CI配置文件：流程大体是一旦监控到master分支有push，则在虚拟环境checkout项目,build React项目，部署静态文件到代码仓库的`gh-pages`分支。

```bash
hanwei@hanweideMacBook-Air github-actions-demo]$ cat .github/workflows/ci.yml 
name: GitHub Actions Build and Deploy Demo
on:
  push:
    branches:
      - master
jobs:
  build-and-deploy:
    concurrency: ci-${{ github.ref }} # Recommended if you intend to make multiple deployments in quick succession.
    runs-on: ubuntu-latest
    steps:
      - name: Checkout 🛎️
        uses: actions/checkout@v2

      - name: Install and Build 🔧 # This example project is built using npm and outputs the result to the 'build' folder. Replace with the commands required to build your project, or remove this step entirely if your site is pre-built.
        run: |
          npm ci
          npm run build

      - name: Deploy 🚀
        uses: JamesIves/github-pages-deploy-action@v4.2.5
        with:
          branch: gh-pages # The branch the action should deploy to.
          folder: build # The folder the action should deploy.
hanwei@hanweideMacBook-Air github-actions-demo]$ 
```

再次push代码到github代码仓库，触发github action流程，查看github action的日志（github网站保存30天）：
```bash
deploy
succeeded 17 minutes ago in 4s
Search logs
1s
Current runner version: '2.287.1'
Operating System
Virtual Environment
Virtual Environment Provisioner
GITHUB_TOKEN Permissions
Secret source: Actions
Prepare workflow directory
Prepare all required actions
Getting action download info
Download action repository 'actions/deploy-pages@v1' (SHA:479e82243a95585ebee8ab037c4bfd8e6356a47b)
0s
Run actions/deploy-pages@v1
Sending telemetry for run id 1896726019
3s
Run actions/deploy-pages@v1
Actor: github-pages[bot]
Action ID: 1896726019
Artifact URL: https://pipelines.actions.githubusercontent.com/7IW4xoAefje3iJJjmBQg228AYglZEwNoROQmK16mg2iViZ9muv/_apis/pipelines/workflows/1896726019/artifacts?api-version=6.0-preview
{"count":1,"value":[{"containerId":3420907,"size":614400,"signedContent":null,"fileContainerResourceUrl":"https://pipelines.actions.githubusercontent.com/7IW4xoAefje3iJJjmBQg228AYglZEwNoROQmK16mg2iViZ9muv/_apis/resources/Containers/3420907","type":"actions_storage","name":"github-pages","url":"https://pipelines.actions.githubusercontent.com/7IW4xoAefje3iJJjmBQg228AYglZEwNoROQmK16mg2iViZ9muv/_apis/pipelines/1/runs/2/artifacts?artifactName=github-pages","expiresOn":"2022-05-26T03:47:37.6013822Z","items":null}]}
Creating deployment with payload:
{
	"artifact_url": "https://pipelines.actions.githubusercontent.com/7IW4xoAefje3iJJjmBQg228AYglZEwNoROQmK16mg2iViZ9muv/_apis/pipelines/1/runs/2/artifacts?artifactName=github-pages&%24expand=SignedContent",
	"pages_build_version": "f018db912dfb491e86183fbc140fe14e3a256905",
	"oidc_token": "***"
}
Created deployment for f018db912dfb491e86183fbc140fe14e3a256905
{"page_url":"https://backendcloud.github.io/github-actions-demo/","status_url":"https://api.github.com/repos/backendcloud/github-actions-demo/pages/deployment/status/f018db912dfb491e86183fbc140fe14e3a256905"}

Current status: updating_pages
Reported success!

Sending telemetry for run id 1896726019
0s
Evaluate and set environment url
Evaluated environment url: https://backendcloud.github.io/github-actions-demo/
Cleaning up orphan processes
```

CI/CD流程完成后用浏览器打开`https://backendcloud.github.io/github-actions-demo/`，发现React项目部署成功，显示如下：

![](/images/github-action-demo/1.png)

github近期有两个变动：

1是用于github.io不再是默认用`gh-pages`分支，静态网页到内容选用哪个分支需要提前配置。若不配置，打开`https://backendcloud.github.io/github-actions-demo/`会报`404
`错误。

![](/images/github-action-demo/2.png)

2是`Github`提供给开发者调用的`Github API`已经取消了用户名密码认证，只能用更加安全的token认证。

![](/images/github-action-demo/3.png)

