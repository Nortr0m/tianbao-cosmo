-- ============================================================
-- 数据库初始化脚本 01：创建数据库
-- 数据库名称：tianbao_insurance
-- 字符集：utf8mb4
-- 排序规则：utf8mb4_unicode_ci
-- 引擎：InnoDB
-- 严格遵循PRD第8章数据模型设计和第9.2节数据库规范
-- ============================================================

-- 如果数据库已存在则删除（开发环境使用，生产环境请谨慎）
-- DROP DATABASE IF EXISTS `tianbao_insurance`;

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `tianbao_insurance`
    DEFAULT CHARACTER SET `utf8mb4`
    DEFAULT COLLATE `utf8mb4_unicode_ci`;

-- 使用数据库
USE `tianbao_insurance`;

-- 设置会话级字符集和时区
SET NAMES `utf8mb4`;
SET FOREIGN_KEY_CHECKS = 0;
SET SESSION SQL_MODE = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
