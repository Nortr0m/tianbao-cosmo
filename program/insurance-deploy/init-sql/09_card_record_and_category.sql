-- ============================================================
-- 数据库初始化脚本 09：卡片生成记录表与卡片分类表
-- 所有表使用InnoDB引擎，utf8mb4字符集
-- 所有表包含通用字段（created_at/updated_at/created_by/updated_by/is_deleted）
-- ============================================================

USE `tianbao_insurance`;

-- ============================================================
-- 1. 卡片生成记录表 (card_record)
-- ============================================================
DROP TABLE IF EXISTS `card_record`;
CREATE TABLE `card_record` (
    `record_id`             BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '记录ID，主键',
    `user_id`               BIGINT UNSIGNED     NOT NULL                COMMENT '用户ID',
    `template_id`           BIGINT UNSIGNED                             COMMENT '模板ID',
    `product_id`            BIGINT UNSIGNED                             COMMENT '产品ID',
    `card_title`            VARCHAR(200)                                COMMENT '卡片标题',
    `card_subtitle`         VARCHAR(200)                                COMMENT '卡片副标题',
    `background_url`        VARCHAR(500)                                COMMENT '背景图URL',
    `generated_image_url`   VARCHAR(500)                                COMMENT '生成的图片URL',
    `age`                   INT                                         COMMENT '年龄',
    `gender`                TINYINT                                     COMMENT '性别：1=男，2=女',
    `payment_period`        VARCHAR(50)                                 COMMENT '缴费期限',
    `coverage`              DECIMAL(15, 2)                              COMMENT '保额',
    `premium`               DECIMAL(10, 2)                              COMMENT '年缴保费',
    `watermark`             VARCHAR(100)                                COMMENT '水印文字',
    `custom_params`         JSON                                        COMMENT '自定义参数，JSON对象',
    `generate_time`         DATETIME                                    COMMENT '生成时间',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否，1=是',
    PRIMARY KEY (`record_id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_template_id` (`template_id`),
    KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='卡片生成记录表';

-- ============================================================
-- 2. 卡片分类表 (card_category)
-- ============================================================
DROP TABLE IF EXISTS `card_category`;
CREATE TABLE `card_category` (
    `category_id`           BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '分类ID，主键',
    `category_code`         VARCHAR(50)         NOT NULL                COMMENT '分类编码，唯一标识',
    `category_name`         VARCHAR(100)        NOT NULL                COMMENT '分类名称',
    `category_icon`         VARCHAR(200)                                COMMENT '分类图标',
    `sort_order`            INT                 NOT NULL DEFAULT 0      COMMENT '排序序号',
    `is_active`             TINYINT             NOT NULL DEFAULT 1      COMMENT '是否启用：0=禁用，1=启用',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否，1=是',
    PRIMARY KEY (`category_id`),
    UNIQUE KEY `uk_category_code` (`category_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='卡片分类表';

-- ============================================================
-- 3. 初始分类数据
-- ============================================================
INSERT INTO `card_category` (`category_code`, `category_name`, `category_icon`, `sort_order`, `is_active`) VALUES
('MINIMALIST', '极简', NULL, 1, 1),
('FAMILY', '家庭', NULL, 2, 1),
('RETIREMENT', '养老', NULL, 3, 1),
('EDUCATION', '教育', NULL, 4, 1),
('LEGACY', '传承', NULL, 5, 1),
('CRITICAL_ILLNESS', '重疾', NULL, 6, 1),
('CHILDREN_SPECIAL', '少儿特疾', NULL, 7, 1),
('BUSINESS', '职业', NULL, 8, 1),
('FESTIVAL', '节日', NULL, 9, 1),
('KAI_MEN_HONG', '开门红', NULL, 10, 1);
