# 阶段1：构建阶段
FROM maven:3.9-eclipse-temurin-21-alpine AS build

# 设置工作目录
WORKDIR /app

# 先复制pom.xml和依赖管理文件，利用Docker缓存层
COPY pom.xml .
COPY src ./src

# 编译打包，跳过测试以加速构建
RUN mvn clean package -DskipTests -Dmaven.test.skip=true

# 阶段2：运行阶段
FROM eclipse-temurin:21-jre-alpine AS runtime

# 安装必要的工具（用于健康检查等）
RUN apk add --no-cache curl

# 创建非root用户
RUN addgroup -g 1001 appgroup && \
    adduser -u 1001 -G appgroup -s /bin/sh -D appuser

# 设置工作目录
WORKDIR /app

# 从构建阶段复制jar包
COPY --from=build /app/target/*.jar app.jar

# 更改文件所有者为非root用户
RUN chown -R appuser:appgroup /app

# 切换到非root用户
USER appuser

# 暴露服务端口
EXPOSE 8081

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8081/actuator/health || exit 1

# 启动应用
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar"]
