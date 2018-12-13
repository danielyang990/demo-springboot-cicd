# 启动所有服务(-d 表示以后台启动, --build 表示每次启动都会进行镜像构建操作)
up:
	docker-compose -p demo up -d --build

# 停止所有服务
down:
	docker-compose -p demo down

# 查看 app 服务的日志
log:
	docker-compose -p demo logs -f app

# 查看 docker-compose 启动的服务
ps:
	docker-compose -p demo ps

# 构建镜像
build:
	docker-compose -p demo build

# others:
# 	mvn spring-boot:run
# 	mvn package
# 	java -jar target/myproject-0.0.1-SNAPSHOT.jar
