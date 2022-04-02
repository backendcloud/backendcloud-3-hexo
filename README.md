# backendcloud-3-hexo

https://github.com/backendcloud/backendcloud-3-hexo 是 https://www.backendcloud.cn/ 的hexo项目仓库。该仓库下的./public/文件不一定更新，只有用到下面的Github Action CICD流程的情况下会自动更新。

`https://github.com/backendcloud/backendcloud-3-hexo/blob/master/.github/workflows/ci.yml`
```yaml
name: Deploy site files

on:
  push:
    branches:
      - master # 只在master上push触发部署
    paths-ignore: # 下列文件的变更不触发部署，可以自行添加
      - README.md
      - LICENSE

jobs:
  deploy:
    runs-on: ubuntu-latest # 使用ubuntu系统镜像运行自动化脚本

    steps: # 自动化步骤
      - uses: actions/checkout@v2 # 第一步，下载代码仓库

      - name: Deploy to Server # 第二步，rsync推文件
        uses: AEnterprise/rsync-deploy@v1.0 # 使用别人包装好的步骤镜像
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }} # 引用配置，SSH私钥
          ARGS: -avz --delete --exclude='*.pyc' # rsync参数，排除.pyc文件
          SERVER_PORT: "22" # SSH端口
          FOLDER: ./public/ # 要推送的文件夹，路径相对于代码仓库的根目录
          SERVER_IP: ${{ secrets.SSH_HOST }} # 引用配置，服务器的host名（IP或者域名domain.com）
          USERNAME: root # 引用配置，服务器登录名
          SERVER_DESTINATION: /usr/share/nginx/html/backendcloud/www/ # 部署到目标文件夹
#      - name: Restart server # 第三步，重启服务
#        uses: appleboy/ssh-action@master
#        with:
#          host: ${{ secrets.SSH_HOST }} # 下面三个配置与上一步类似
#          username: ${{ secrets.SSH_USERNAME }}
#          key: ${{ secrets.DEPLOY_KEY }}
#          # 重启的脚本，根据自身情况做相应改动，一般要做的是migrate数据库以及重启服务器
#          script: |
#            cd /home/fming/mysite/
#            python manage.py migrate
#            supervisorctl restart web
```


# backendcloud.github.io
https://github.com/backendcloud/backendcloud.github.io 是对应的静态html仓库。该仓库是Github Action CICD流程自动更新的。
