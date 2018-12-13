# demo-springboot-cicd

这个示例用于演示一个 `sprintboot` 项目的 `cicd` 过程, 会完整的描述一个项目从开发到测试，以及最终部署到生成环境的一个完整流程。 流程图如下:

![](images/ci-cd-jenkins-helm-k8s.png)

一些特殊的情况，例如团队规模比较小，开发和测试是相同的人，可以暂时把流程图中的 `dev` 部分去掉，当以后团队规模扩大后，再补充上不迟。

下面的流程，不包含部署到 `dev` 环境的说明。

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
* kubenetes
* jenkins
* sonarqube
* helm
* harbor

## 开发

本地开发，需要安装的两个软件为 `docker` 和 `docker-compose`, 安装和使用方法不再累述，自己搜索一下就好

安装完成后，在终端执行如下命令:

```
https://github.com/danielyang990/demo-springboot-cicd.git
cd demo-springboot-cicd
make up
```

然后在浏览器中访问 `http://127.0.0.1:80`, 即可看到网站可以正常访问了。

默认使用的项目配置文件为 `application-docker.properties`, 你可以在 `docker-compose.yml` 文件中指定要使用的配置文件:

```
app:
    ...
    command: mvn clean spring-boot:run -Dspring-boot.run.profiles=docker
```

当修改了代码，希望重新编译，再次执行 `make up` 即可。

如果不能正常访问，执行 `make log` 查看相关的日志信息。

一切没有问题后，`commit` 你的代码！

## 部署

### 环境配置

为了隔离线下和线上环境，需要部署两套环境，一套是测试环境(`staging`)，一套是生产环境(`prod`)，只有在 `staging` 环境测试通过的应用，才被允许部署到 `prod` 环境。

两套环境都需要安装的软件为:

* [kubenetes](https://www.kubernetes.org.cn/4619.html): 子目录中为 `k8s` 中的一些第三方的组件，不带链接的，表示在这篇安装文档中有安装说明
    * Ingress Controlle: 负载均衡
    * Helm: 应用管理
    * [cert-manager](https://cloud.tencent.com/developer/article/1326543): 免费证书的签发
* [jenkins](https://github.com/gjmzj/kubeasz/blob/master/docs/guide/jenkins.md): 流水线管理，部署在上面部署好的 `k8s` 集群中
* [harbor](): 私有镜像仓库管理
* [sonarqube](): 代码检查

软件安装完成后，在 `jenkins` 中创建类型为 `多分支流水线` 的任务，关联相关仓库，触发方式选择代码触发，`Build Configuration` 选择 `by Jenkinsfile`, 然后点击保存即可。

开发完成后，当代码推送到远端仓库, `jenkins` 会监听到代码的变动，然后触发流水线，在流水线中进行编译、测试、代码检查等操作，`success` 后会将最新版本部署到正确的 `k8s` 集群中.

### 规范

为了让 `jenkins` 把不同的分支的代码部署到正确的环境，需要遵循如下规范：

* `develop` 分支用于开发，当有代码 `commit` 时，会自动触发测试环境的流水线，`success` 后把最新镜像更新到测试环境。
* `master` 分支用于上线，当 `develop` 分支合并到 `master` 后，会自动触发正式环境的流水线，`success` 后，会等待最后一步人工审核，当管理员点击了`通过` 后，最新版本才会更新到线上。
* 不能在 `master` 分支上直接 `commit`。
* 每次的 `commit` 信息要有明确的意义，例如 `git commit -m "feat: change the database configration"` 或者 `git commit "fix: database error"`


## 参考文档

不必都看哈，开发人员看下 `docker` 和 `docker-compose` 文档，知道怎么简单使用就好，半天就可以掌握。

运维人员要着重看下 `kubernetes` 文档，不必一下子重头看到尾。
要有一个简单的概念，出错知道是哪里出问题了，掌握简单的排查手段。 到时候再来查文档就好。

* [docker 中文文档](https://docs.docker-cn.com/)
* [docker-compose 中文文档](https://yeasy.gitbooks.io/docker_practice/compose/)
* [kubernetes 中文文档](https://k8smeetup.github.io/docs/home/)
* [helm 中文文档](https://whmzsu.github.io/helm-doc-zh-cn/)
* [Configuring CI/CD on Kubernetes with Jenkins](https://medium.com/containerum/configuring-ci-cd-on-kubernetes-with-jenkins-89eab7234270)

