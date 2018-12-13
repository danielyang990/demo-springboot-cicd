# demo-springboot-cicd

这个示例用于演示一个 `sprintboot` 项目的 `cicd` 过程, 会完整的描述一个项目从开发到测试，以及最终部署到生成环境的一个完整流程。

涉及到相关过程如下:

* 如何通过 `docker-compose` 在本地开发调试
* 如何通过 `jenkins` 流水线部署到 `staging` 环境
* 如何通过 `jenkins` 流水线部署到 `prod` 环境
* 如果在流水线中执行单元测试
* 如何在流水线中调用 `sonarqube` 进行代码检查
* 如何在流水线中更新 `k8s` 环境中的应用
* 如何在流水线执行成功或失败时，调用 `telegram` 的 `api` 发通知到某个群
* 如何通过 `helm` 来打包应用，以及管理应用的版本

演示过程中用到的相关软件有：

* docker
* docker-compose
* jenkins
* kubenetes
* sonarqube
* helm
* harbor

## 开发

本地开发，需要安装的两个软件为 `docker` 和 `docker-compose`, 安装和使用方法不再累述，自己搜索一下就好

安装完成后，执行如下命令:

```

make up
curl 127.0.0.1:80
```

## 部署

开发完成后，应用会通过 `jenkins` 部署到 `k8s` 集群中，
部署环境有两个，一个是测试环境(staging)，一个是生产环境(staging)，



