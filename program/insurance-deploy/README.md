# 天保星君保险平台 - Docker 部署指南

## 目录结构

```
insurance-deploy/
├── docker-compose.yml          # 开发环境 Docker Compose 配置
├── docker-compose.prod.yml     # 生产环境 Docker Compose 配置
├── nginx.conf                  # 开发环境 Nginx 配置
├── nginx.prod.conf             # 生产环境 Nginx 配置
├── .env.example                # 生产环境环境变量示例
├── init-sql/                   # MySQL 初始化脚本
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   └── 03_init_data.sql
├── mysql-data/                 # MySQL 数据持久化目录（自动创建）
├── redis-data/                 # Redis 数据持久化目录（自动创建）
└── ssl/                        # SSL 证书目录（生产环境需手动创建）
```

## 前置要求

- Docker Engine >= 20.10
- Docker Compose >= 2.0
- 确保以下端口未被占用：80, 443, 3306, 6379, 8080, 8081

## 开发环境部署

### 1. 构建前端项目

在部署之前，需要先构建前端静态资源：

```bash
# 构建 PC Web 前端
cd ../insurance-web
npm install
npm run build

# 构建管理后台前端
cd ../insurance-admin-web
npm install
npm run build
```

### 2. 启动开发环境

```bash
cd insurance-deploy

# 启动所有服务（后台运行）
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 查看指定服务日志
docker-compose logs -f api
```

### 3. 访问服务

| 服务 | 地址 |
|------|------|
| PC Web 前端 | http://localhost |
| 管理后台 | http://localhost/admin |
| API 服务 | http://localhost/api |
| Admin API | http://localhost/admin-api |
| MySQL | localhost:3306 |
| Redis | localhost:6379 |

### 4. 停止开发环境

```bash
# 停止所有服务（保留数据卷）
docker-compose down

# 停止所有服务并删除数据卷（谨慎使用）
docker-compose down -v
```

## 生产环境部署

### 1. 准备环境变量

```bash
cd insurance-deploy

# 复制环境变量示例文件
cp .env.example .env

# 编辑 .env 文件，设置强密码和密钥
vim .env
```

### 2. 准备 SSL 证书

将 SSL 证书文件放置到 `ssl/` 目录：

```bash
mkdir -p ssl
cp /path/to/your/cert.pem ssl/cert.pem
cp /path/to/your/key.pem ssl/key.pem
```

### 3. 构建前端项目

与开发环境相同，确保 `../insurance-web/dist` 和 `../insurance-admin-web/dist` 目录存在。

### 4. 启动生产环境

```bash
# 启动所有服务（后台运行）
docker-compose -f docker-compose.prod.yml up -d

# 查看服务状态
docker-compose -f docker-compose.prod.yml ps

# 查看日志
docker-compose -f docker-compose.prod.yml logs -f
```

### 5. 生产环境特性

- 所有服务配置 `restart: always`
- MySQL 和 Redis 启用密码认证
- 后端服务启用 G1GC JVM 优化
- Nginx 启用 HTTPS 和 HTTP/2
- 安全响应头配置
- 更严格的静态资源缓存策略
- 资源限制配置

## 常用命令

### 服务管理

```bash
# 启动服务
docker-compose up -d

# 停止服务
docker-compose down

# 重启单个服务
docker-compose restart api

# 重新构建并启动服务
docker-compose up -d --build api

# 查看服务状态
docker-compose ps

# 查看资源使用情况
docker stats
```

### 日志管理

```bash
# 查看所有服务日志
docker-compose logs

# 实时跟踪日志
docker-compose logs -f

# 查看最近100行日志
docker-compose logs --tail=100 api

# 查看指定时间之后的日志
docker-compose logs --since="2024-01-01T00:00:00" api
```

### 数据库操作

```bash
# 进入 MySQL 容器
docker-compose exec mysql mysql -u root -p

# 进入 Redis 容器
docker-compose exec redis redis-cli

# 备份数据库
docker-compose exec mysql mysqldump -u root -p tianbao_insurance > backup.sql

# 恢复数据库
docker-compose exec -T mysql mysql -u root -p tianbao_insurance < backup.sql
```

### 容器维护

```bash
# 进入容器内部
docker-compose exec api sh

# 查看容器详情
docker-compose exec api cat /etc/os-release

# 清理未使用的 Docker 资源
docker system prune -f

# 清理构建缓存
docker builder prune -f
```

## 故障排查

### 服务无法启动

1. 检查端口是否被占用：`netstat -tlnp | grep -E '80|443|3306|6379|8080|8081'`
2. 检查日志：`docker-compose logs <service-name>`
3. 检查环境变量：`.env` 文件是否正确配置

### 数据库连接失败

1. 确认 MySQL 服务健康状态：`docker-compose ps`
2. 检查数据库凭据是否正确
3. 确认网络连通性：`docker-compose exec api ping mysql`

### 前端资源404

1. 确认前端项目已构建：`ls ../insurance-web/dist`
2. 检查 Nginx 配置挂载是否正确
3. 检查 Nginx 错误日志：`docker-compose logs nginx`

## 安全建议

1. **修改默认密码**：生产环境务必修改所有默认密码
2. **定期更新镜像**：`docker-compose pull && docker-compose up -d`
3. **限制端口暴露**：生产环境建议仅暴露 80/443 端口
4. **启用防火墙**：配置服务器防火墙规则
5. **定期备份**：设置数据库自动备份策略
6. **监控告警**：配置容器资源监控和告警

## 更新部署

```bash
# 拉取最新代码后重新构建
git pull

# 重新构建并启动
docker-compose -f docker-compose.prod.yml up -d --build

# 清理旧镜像
docker image prune -f
```

## 注意事项

- 开发环境使用 `docker-compose.yml`，生产环境使用 `docker-compose.prod.yml`
- 生产环境务必配置 `.env` 文件，不要提交到版本控制
- SSL 证书文件权限应设置为 `600`
- 数据卷目录（`mysql-data`、`redis-data`）需要定期备份
