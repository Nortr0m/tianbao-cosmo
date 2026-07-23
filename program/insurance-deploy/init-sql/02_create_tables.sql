-- ============================================================
-- 数据库初始化脚本 02：创建数据表
-- 严格遵循PRD第8章数据模型设计和第9.2节数据库规范
-- 所有表使用InnoDB引擎，utf8mb4字符集
-- 所有表包含通用字段（created_at/updated_at/created_by/updated_by/is_deleted）
-- ============================================================

USE `tianbao_insurance`;

-- ============================================================
-- 1. 保险公司表 (insurance_company)
-- ============================================================
DROP TABLE IF EXISTS `insurance_company`;
CREATE TABLE `insurance_company` (
    `company_id`            BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '保险公司ID，主键',
    `company_name`          VARCHAR(200)        NOT NULL                COMMENT '保险公司全称',
    `company_short_name`    VARCHAR(50)         NOT NULL                COMMENT '保险公司简称',
    `company_code`          VARCHAR(50)         NOT NULL                COMMENT '保险公司编码，唯一标识',
    `logo_url`              VARCHAR(500)                                COMMENT '公司Logo URL',
    `official_website`      VARCHAR(200)                                COMMENT '官方网站',
    `service_phone`         VARCHAR(20)                                 COMMENT '客服电话',
    `established_year`      INT                                         COMMENT '成立年份',
    `registered_capital`    DECIMAL(15, 2)                              COMMENT '注册资本（万元）',
    `headquarters`          VARCHAR(100)                                COMMENT '总部所在地',
    `company_type`          TINYINT             NOT NULL                COMMENT '公司类型：1=中资, 2=合资, 3=外资',
    `credit_rating`         VARCHAR(20)                                 COMMENT '信用评级',
    `solvency_ratio`        DECIMAL(5, 2)                               COMMENT '偿付能力充足率(%)',
    `introduction`          TEXT                                        COMMENT '公司简介',
    `feature_tags`          JSON                                        COMMENT '特色标签，JSON数组',
    `cooperation_status`    TINYINT             NOT NULL DEFAULT 1      COMMENT '合作状态：0=终止, 1=合作中',
    `cooperation_start_date` DATE                                       COMMENT '合作开始日期',
    `sort_order`            INT                 NOT NULL DEFAULT 0      COMMENT '排序序号',
    `is_hot`                TINYINT             NOT NULL DEFAULT 0      COMMENT '是否热门：0=否, 1=是',
    `remark`                VARCHAR(500)                                COMMENT '备注',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`company_id`),
    UNIQUE KEY `uk_company_code` (`company_code`),
    KEY `idx_cooperation_status` (`cooperation_status`),
    KEY `idx_is_hot` (`is_hot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='保险公司表';

-- ============================================================
-- 2. 评级历史表 (company_rating_history)
-- ============================================================
DROP TABLE IF EXISTS `company_rating_history`;
CREATE TABLE `company_rating_history` (
    `history_id`            BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '历史记录ID，主键',
    `company_id`            BIGINT UNSIGNED     NOT NULL                COMMENT '保险公司ID，外键',
    `rating_quarter`        VARCHAR(10)         NOT NULL                COMMENT '评级季度，格式：YYYY-QX',
    `credit_rating`         VARCHAR(20)         NOT NULL                COMMENT '信用评级',
    `solvency_ratio`        DECIMAL(8, 2)       NOT NULL                COMMENT '偿付能力充足率(%)',
    `core_solvency_ratio`   DECIMAL(8, 2)                               COMMENT '核心偿付能力充足率(%)',
    `net_profit`            DECIMAL(15, 2)                              COMMENT '净利润（万元）',
    `premium_income`        DECIMAL(15, 2)                              COMMENT '保费收入（万元）',
    `publish_date`          DATE                                        COMMENT '发布日期',
    `remark`                VARCHAR(500)                                COMMENT '备注',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`history_id`),
    UNIQUE KEY `uk_company_quarter` (`company_id`, `rating_quarter`),
    KEY `idx_company_id` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='保险公司评级历史表';

-- ============================================================
-- 3. 产品父类表 (product_base)
-- ============================================================
DROP TABLE IF EXISTS `product_base`;
CREATE TABLE `product_base` (
    `product_id`            BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '产品ID，主键',
    `product_name`          VARCHAR(200)        NOT NULL                COMMENT '产品名称',
    `product_code`          VARCHAR(50)         NOT NULL                COMMENT '产品编码，唯一标识',
    `company_id`            BIGINT UNSIGNED                             COMMENT '保险公司ID，外键',
    `product_type`          TINYINT             NOT NULL                COMMENT '产品大类：1=重疾险, 2=增额终身寿险, 3=年金险',
    `sub_type`              TINYINT                                     COMMENT '产品子类',
    `min_age`               INT                 NOT NULL                COMMENT '最小投保年龄',
    `max_age`               INT                 NOT NULL                COMMENT '最大投保年龄',
    `payment_years`         JSON                NOT NULL                COMMENT '可选缴费年限，JSON数组',
    `occupation_class`      TINYINT             NOT NULL                COMMENT '职业类别限制：1-6类',
    `payment_periods`       JSON                NOT NULL                COMMENT '可选保障期限，JSON数组',
    `monthly_ratio`         DECIMAL(6, 4)                               COMMENT '月缴比例',
    `quarterly_ratio`       DECIMAL(6, 4)                               COMMENT '季缴比例',
    `half_yearly_ratio`     DECIMAL(6, 4)                               COMMENT '半年缴比例',
    `sale_status`           TINYINT             NOT NULL DEFAULT 1      COMMENT '销售状态：0=停售, 1=在售',
    `system_status`         TINYINT             NOT NULL DEFAULT 0      COMMENT '系统状态：0=草稿, 1=已发布',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`product_id`),
    UNIQUE KEY `uk_product_code` (`product_code`),
    KEY `idx_company_id` (`company_id`),
    KEY `idx_product_type` (`product_type`),
    KEY `idx_sale_status` (`sale_status`),
    KEY `idx_system_status` (`system_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='保险产品父类表';

-- ============================================================
-- 4. 重疾险子类表 (critical_illness_product)
-- ============================================================
DROP TABLE IF EXISTS `critical_illness_product`;
CREATE TABLE `critical_illness_product` (
    `id`                    BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '自增ID，主键',
    `product_id`            BIGINT UNSIGNED     NOT NULL                COMMENT '产品ID，外键，关联product_base',
    `waiting_period`        INT                 NOT NULL                COMMENT '等待期（天）',
    `waiting_period_rule`   TINYINT             NOT NULL                COMMENT '等待期规则：1=疾病身故, 2=仅疾病',
    `critical_count`        INT                 NOT NULL                COMMENT '重疾种类数量',
    `critical_ratio`        INT                 NOT NULL                COMMENT '重疾赔付比例(%)',
    `medium_count`          INT                 NOT NULL                COMMENT '中症种类数量',
    `medium_ratio`          INT                 NOT NULL                COMMENT '中症赔付比例(%)',
    `light_count`           INT                 NOT NULL                COMMENT '轻症种类数量',
    `light_ratio`           INT                 NOT NULL                COMMENT '轻症赔付比例(%)',
    `critical_multi_interval` INT                                       COMMENT '重疾多次赔付间隔期（年）',
    `cancer_multi_interval` INT                                       COMMENT '癌症多次赔付间隔期（年）',
    `cvd_multi_interval`    INT                                         COMMENT '心脑血管多次赔付间隔期（年）',
    `disease_care_age`      INT                                         COMMENT '疾病关爱金保障年龄',
    `disease_care_critical_ratio` INT                                   COMMENT '疾病关爱金重疾额外赔付比例(%)',
    `disease_care_medium_ratio`   INT                                   COMMENT '疾病关爱金中症额外赔付比例(%)',
    `disease_care_light_ratio`    INT                                   COMMENT '疾病关爱金轻症额外赔付比例(%)',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_product_id` (`product_id`),
    KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='重疾险子类表';

-- ============================================================
-- 5. 增额终身寿险子类表 (whole_life_product)
-- ============================================================
DROP TABLE IF EXISTS `whole_life_product`;
CREATE TABLE `whole_life_product` (
    `id`                    BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '自增ID，主键',
    `product_id`            BIGINT UNSIGNED     NOT NULL                COMMENT '产品ID，外键，关联product_base',
    `reduction_rule_type`   TINYINT             NOT NULL                COMMENT '减保规则类型：1=基本保额20%, 2=已交保费20%, 3=现金价值20%, 4=无限制',
    `reduction_start_year`  INT                                         COMMENT '减保起始年份',
    `reduction_times_limit` INT                                         COMMENT '每年减保次数限制',
    `max_add_age`           INT                 NOT NULL                COMMENT '最大加保年龄',
    `add_premium_rule`      TINYINT             NOT NULL                COMMENT '加保规则：1=按投保时年龄, 2=按加保时年龄',
    `add_times_limit`       INT                                         COMMENT '加保次数限制',
    `add_ratio_limit`       INT                                         COMMENT '加保比例限制(%)',
    `loan_ratio`            DECIMAL(5, 2)       NOT NULL                COMMENT '保单贷款比例(%)',
    `loan_rate`             DECIMAL(5, 2)       NOT NULL                COMMENT '保单贷款利率(%)',
    `increase_rate`         DECIMAL(5, 2)       NOT NULL                COMMENT '保额递增比例(%)',
    `increase_end_age`      INT                                         COMMENT '保额递增截止年龄',
    `support_age_list`      JSON                NOT NULL                COMMENT '支持投保年龄列表，JSON数组',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_product_id` (`product_id`),
    KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='增额终身寿险子类表';

-- ============================================================
-- 6. 年金险子类表 (annuity_product)
-- ============================================================
DROP TABLE IF EXISTS `annuity_product`;
CREATE TABLE `annuity_product` (
    `id`                    BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '自增ID，主键',
    `product_id`            BIGINT UNSIGNED     NOT NULL                COMMENT '产品ID，外键，关联product_base',
    `start_age_female`      JSON                NOT NULL                COMMENT '女性起领年龄选项，JSON数组',
    `start_age_male`        JSON                NOT NULL                COMMENT '男性起领年龄选项，JSON数组',
    `support_monthly`       TINYINT             NOT NULL DEFAULT 1      COMMENT '是否支持月领：0=否, 1=是',
    `monthly_coefficient`   DECIMAL(5, 3)       NOT NULL                COMMENT '月领系数',
    `guarantee_options`     JSON                NOT NULL                COMMENT '保证领取选项，JSON数组',
    `support_increase`      TINYINT             NOT NULL DEFAULT 0      COMMENT '是否支持递增：0=否, 1=是',
    `increase_rate_options` JSON                                        COMMENT '递增比例选项，JSON数组',
    `increase_end_year`     INT                                         COMMENT '递增截止年限',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_product_id` (`product_id`),
    KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='年金险子类表';

-- ============================================================
-- 7. 一级分类表 (responsibility_category)
-- ============================================================
DROP TABLE IF EXISTS `responsibility_category`;
CREATE TABLE `responsibility_category` (
    `category_id`           BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '分类ID，主键',
    `category_code`         VARCHAR(50)         NOT NULL                COMMENT '分类编码，唯一标识',
    `category_name`         VARCHAR(100)        NOT NULL                COMMENT '分类名称',
    `sort_order`            INT                 NOT NULL DEFAULT 0      COMMENT '排序序号',
    `is_active`             TINYINT             NOT NULL DEFAULT 1      COMMENT '是否启用：0=禁用, 1=启用',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`category_id`),
    UNIQUE KEY `uk_category_code` (`category_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='责任一级分类表';

-- ============================================================
-- 8. 二级责任项表 (responsibility_item)
-- ============================================================
DROP TABLE IF EXISTS `responsibility_item`;
CREATE TABLE `responsibility_item` (
    `item_id`               BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '责任项ID，主键',
    `category_id`           BIGINT UNSIGNED                             COMMENT '所属分类ID，外键',
    `item_code`             VARCHAR(50)         NOT NULL                COMMENT '责任项编码，唯一标识',
    `item_name`             VARCHAR(100)        NOT NULL                COMMENT '责任项名称',
    `options`               JSON                NOT NULL                COMMENT '可选项配置，JSON对象',
    `sort_order`            INT                 NOT NULL DEFAULT 0      COMMENT '排序序号',
    `is_system`             TINYINT             NOT NULL DEFAULT 1      COMMENT '是否系统内置：0=自定义, 1=系统内置',
    `is_active`             TINYINT             NOT NULL DEFAULT 1      COMMENT '是否启用：0=禁用, 1=启用',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`item_id`),
    UNIQUE KEY `uk_item_code` (`item_code`),
    KEY `idx_category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='责任二级责任项表';

-- ============================================================
-- 9. 产品-责任关联表 (product_responsibility)
-- ============================================================
DROP TABLE IF EXISTS `product_responsibility`;
CREATE TABLE `product_responsibility` (
    `id`                    BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '自增ID，主键',
    `product_id`            BIGINT UNSIGNED     NOT NULL                COMMENT '产品ID，外键',
    `item_id`               BIGINT UNSIGNED     NOT NULL                COMMENT '责任项ID，外键',
    `is_supported`          TINYINT             NOT NULL DEFAULT 1      COMMENT '是否支持：0=不支持, 1=支持',
    `supported_options`     JSON                NOT NULL                COMMENT '支持的选项，JSON数组',
    `default_option`        VARCHAR(50)         NOT NULL                COMMENT '默认选项值',
    `premium_coefficient`   JSON                NOT NULL                COMMENT '保费系数配置，JSON对象',
    `sort_order`            INT                 NOT NULL DEFAULT 0      COMMENT '排序序号',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`id`),
    KEY `idx_product_id` (`product_id`),
    KEY `idx_item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产品-责任关联表';

-- ============================================================
-- 10. 产品编码映射表 (product_encoding_map)
-- ============================================================
DROP TABLE IF EXISTS `product_encoding_map`;
CREATE TABLE `product_encoding_map` (
    `map_id`                BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '映射ID，主键',
    `product_id`            BIGINT UNSIGNED     NOT NULL                COMMENT '产品ID，外键',
    `resp_category`         VARCHAR(20)         NOT NULL                COMMENT '责任大类编码',
    `resp_code`             VARCHAR(50)         NOT NULL                COMMENT '责任编码',
    `resp_name`             VARCHAR(100)        NOT NULL                COMMENT '责任名称',
    `bit_position`          INT                 NOT NULL                COMMENT '比特位位置（0-31）',
    `bit_mask`              INT                 NOT NULL                COMMENT '位掩码值（1<<bit_position）',
    `options`               JSON                NOT NULL                COMMENT '选项配置，JSON对象',
    `is_active`             TINYINT             NOT NULL DEFAULT 1      COMMENT '是否启用：0=禁用, 1=启用',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`map_id`),
    UNIQUE KEY `uk_product_resp_code` (`product_id`, `resp_code`),
    KEY `idx_product_id` (`product_id`),
    KEY `idx_resp_code` (`resp_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='产品编码映射表（用于位运算产品编码）';

-- ============================================================
-- 11. 重疾险费率主表 (premium_rate)
-- ============================================================
DROP TABLE IF EXISTS `premium_rate`;
CREATE TABLE `premium_rate` (
    `rate_id`               BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '费率ID，主键',
    `product_id`            BIGINT UNSIGNED     NOT NULL                COMMENT '产品ID，外键',
    `combo_code`            INT                 NOT NULL                COMMENT '责任组合编码',
    `gender`                TINYINT             NOT NULL                COMMENT '性别：1=男, 2=女',
    `age`                   INT                 NOT NULL                COMMENT '投保年龄',
    `payment_year`          INT                 NOT NULL                COMMENT '缴费年限',
    `premium_per_k`         DECIMAL(10, 2)      NOT NULL                COMMENT '每千元保额保费',
    `health_status`         TINYINT             NOT NULL DEFAULT 1      COMMENT '健康状态：1=标准体, 2=优选体, 3=超优体',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`rate_id`),
    UNIQUE KEY `uk_rate_unique` (`product_id`, `combo_code`, `gender`, `age`, `payment_year`, `health_status`),
    KEY `idx_product_id` (`product_id`),
    KEY `idx_combo_code` (`combo_code`),
    KEY `idx_gender` (`gender`),
    KEY `idx_age` (`age`),
    KEY `idx_payment_year` (`payment_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='重疾险费率主表';

-- ============================================================
-- 12. 增额终身寿险费率表 (whole_life_rate)
-- ============================================================
DROP TABLE IF EXISTS `whole_life_rate`;
CREATE TABLE `whole_life_rate` (
    `rate_id`               BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '费率ID，主键',
    `product_id`            BIGINT UNSIGNED     NOT NULL                COMMENT '产品ID，外键',
    `gender`                TINYINT             NOT NULL                COMMENT '性别：1=男, 2=女',
    `age`                   INT                 NOT NULL                COMMENT '投保年龄',
    `payment_year`          INT                 NOT NULL                COMMENT '缴费年限',
    `policy_year`           INT                 NOT NULL                COMMENT '保单年度',
    `cash_value`            DECIMAL(15, 2)      NOT NULL                COMMENT '现金价值',
    `death_benefit`         DECIMAL(15, 2)                              COMMENT '身故保险金',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`rate_id`),
    UNIQUE KEY `uk_rate_unique` (`product_id`, `gender`, `age`, `payment_year`, `policy_year`),
    KEY `idx_product_id` (`product_id`),
    KEY `idx_gender` (`gender`),
    KEY `idx_age` (`age`),
    KEY `idx_payment_year` (`payment_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='增额终身寿险费率表';

-- ============================================================
-- 13. 年金险费率表 (annuity_rate)
-- ============================================================
DROP TABLE IF EXISTS `annuity_rate`;
CREATE TABLE `annuity_rate` (
    `rate_id`               BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '费率ID，主键',
    `product_id`            BIGINT UNSIGNED     NOT NULL                COMMENT '产品ID，外键',
    `gender`                TINYINT             NOT NULL                COMMENT '性别：1=男, 2=女',
    `age`                   INT                 NOT NULL                COMMENT '投保年龄',
    `payment_year`          INT                 NOT NULL                COMMENT '缴费年限',
    `policy_year`           INT                 NOT NULL                COMMENT '保单年度',
    `annual_payout`         DECIMAL(15, 2)                              COMMENT '年领取金额',
    `cash_value`            DECIMAL(15, 2)                              COMMENT '现金价值',
    `death_benefit`         DECIMAL(15, 2)                              COMMENT '身故保险金',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`rate_id`),
    UNIQUE KEY `uk_rate_unique` (`product_id`, `gender`, `age`, `payment_year`, `policy_year`),
    KEY `idx_product_id` (`product_id`),
    KEY `idx_gender` (`gender`),
    KEY `idx_age` (`age`),
    KEY `idx_payment_year` (`payment_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='年金险费率表';

-- ============================================================
-- 14. 祝寿金配置表 (annuity_birthday_bonus)
-- ============================================================
DROP TABLE IF EXISTS `annuity_birthday_bonus`;
CREATE TABLE `annuity_birthday_bonus` (
    `bonus_id`              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '祝寿金ID，主键',
    `product_id`            BIGINT UNSIGNED     NOT NULL                COMMENT '产品ID，外键',
    `bonus_age`             INT                 NOT NULL                COMMENT '祝寿金领取年龄',
    `bonus_type`            TINYINT             NOT NULL                COMMENT '祝寿金类型：1=固定金额, 2=倍数, 3=比例',
    `bonus_value`           DECIMAL(10, 2)      NOT NULL                COMMENT '祝寿金数值',
    `bonus_desc`            VARCHAR(200)                                COMMENT '祝寿金描述',
    `is_active`             TINYINT             NOT NULL DEFAULT 1      COMMENT '是否启用：0=禁用, 1=启用',
    `sort_order`            INT                 NOT NULL DEFAULT 0      COMMENT '排序序号',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`bonus_id`),
    UNIQUE KEY `uk_product_bonus_age` (`product_id`, `bonus_age`),
    KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='年金险祝寿金配置表';

-- ============================================================
-- 15. 卡片模板表 (card_template)
-- ============================================================
DROP TABLE IF EXISTS `card_template`;
CREATE TABLE `card_template` (
    `template_id`           BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '模板ID，主键',
    `template_name`         VARCHAR(100)        NOT NULL                COMMENT '模板名称',
    `category_code`         VARCHAR(50)         NOT NULL                COMMENT '分类编码',
    `tags`                  JSON                                        COMMENT '标签，JSON数组',
    `ai_prompt`             TEXT                                        COMMENT 'AI生成提示词',
    `search_keywords`       VARCHAR(500)                                COMMENT '搜索关键词',
    `background_url`        VARCHAR(500)        NOT NULL                COMMENT '背景图URL',
    `default_title`         VARCHAR(200)                                COMMENT '默认标题',
    `default_subtitle`      VARCHAR(200)                                COMMENT '默认副标题',
    `is_system`             TINYINT             NOT NULL DEFAULT 1      COMMENT '是否系统模板：0=自定义, 1=系统',
    `is_recommended`        TINYINT             NOT NULL DEFAULT 0      COMMENT '是否推荐：0=否, 1=是',
    `use_count_7d`          INT                 NOT NULL DEFAULT 0      COMMENT '近7天使用次数',
    `use_count_30d`         INT                 NOT NULL DEFAULT 0      COMMENT '近30天使用次数',
    `use_count_total`       INT                 NOT NULL DEFAULT 0      COMMENT '累计使用次数',
    `last_used_time`        DATETIME                                    COMMENT '最后使用时间',
    `sort_order`            INT                 NOT NULL DEFAULT 0      COMMENT '排序序号',
    `is_active`             TINYINT             NOT NULL DEFAULT 1      COMMENT '是否启用：0=禁用, 1=启用',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`template_id`),
    KEY `idx_category_code` (`category_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='卡片模板表';

-- ============================================================
-- 16. 用户信息表 (user_info)
-- ============================================================
DROP TABLE IF EXISTS `user_info`;
CREATE TABLE `user_info` (
    `user_id`               BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '用户ID，主键',
    `username`              VARCHAR(50)         NOT NULL                COMMENT '用户名，唯一',
    `password`              VARCHAR(100)        NOT NULL                COMMENT '密码（BCrypt加密）',
    `nickname`              VARCHAR(50)                                 COMMENT '昵称',
    `avatar_url`            VARCHAR(500)                                COMMENT '头像URL',
    `phone`                 VARCHAR(20)                                 COMMENT '手机号',
    `email`                 VARCHAR(100)                                COMMENT '邮箱',
    `gender`                TINYINT                                     COMMENT '性别：1=男, 2=女, 0=未知',
    `birthday`              DATE                                        COMMENT '生日',
    `wechat_openid`         VARCHAR(50)                                 COMMENT '微信OpenID，唯一',
    `wechat_unionid`        VARCHAR(50)                                 COMMENT '微信UnionID',
    `member_level`          TINYINT             NOT NULL DEFAULT 0      COMMENT '会员等级：0=普通, 1=VIP, 2=SVIP',
    `member_expire_time`    DATETIME                                    COMMENT '会员过期时间',
    `status`                TINYINT             NOT NULL DEFAULT 1      COMMENT '状态：0=禁用, 1=正常',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`user_id`),
    UNIQUE KEY `uk_username` (`username`),
    UNIQUE KEY `uk_wechat_openid` (`wechat_openid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户信息表';

-- ============================================================
-- 17. VIP会员记录表 (user_vip_record)
-- ============================================================
DROP TABLE IF EXISTS `user_vip_record`;
CREATE TABLE `user_vip_record` (
    `record_id`             BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '记录ID，主键',
    `user_id`               BIGINT UNSIGNED     NOT NULL                COMMENT '用户ID，外键',
    `member_level`          TINYINT             NOT NULL                COMMENT '会员等级：1=VIP, 2=SVIP',
    `purchase_amount`       DECIMAL(10, 2)      NOT NULL                COMMENT '购买金额',
    `expire_time`           DATETIME            NOT NULL                COMMENT '过期时间',
    `purchase_time`         DATETIME            NOT NULL                COMMENT '购买时间',
    `order_no`              VARCHAR(50)         NOT NULL                COMMENT '订单号，唯一',
    `pay_type`              TINYINT                                     COMMENT '支付方式：1=微信, 2=支付宝',
    `status`                TINYINT             NOT NULL DEFAULT 1      COMMENT '状态：0=无效, 1=有效, 2=已退款',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`record_id`),
    UNIQUE KEY `uk_order_no` (`order_no`),
    KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='VIP会员购买记录表';

-- ============================================================
-- 18. 管理员表 (admin_user)
-- ============================================================
DROP TABLE IF EXISTS `admin_user`;
CREATE TABLE `admin_user` (
    `admin_id`              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '管理员ID，主键',
    `username`              VARCHAR(50)         NOT NULL                COMMENT '用户名，唯一',
    `password`              VARCHAR(100)        NOT NULL                COMMENT '密码（BCrypt加密）',
    `real_name`             VARCHAR(50)                                 COMMENT '真实姓名',
    `phone`                 VARCHAR(20)                                 COMMENT '手机号',
    `email`                 VARCHAR(100)                                COMMENT '邮箱',
    `avatar_url`            VARCHAR(500)                                COMMENT '头像URL',
    `role_id`               BIGINT UNSIGNED                             COMMENT '角色ID，外键',
    `status`                TINYINT             NOT NULL DEFAULT 1      COMMENT '状态：0=禁用, 1=正常',
    `last_login_time`       DATETIME                                    COMMENT '最后登录时间',
    `last_login_ip`         VARCHAR(50)                                 COMMENT '最后登录IP',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`admin_id`),
    UNIQUE KEY `uk_username` (`username`),
    KEY `idx_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员表';

-- ============================================================
-- 19. 角色表 (admin_role)
-- ============================================================
DROP TABLE IF EXISTS `admin_role`;
CREATE TABLE `admin_role` (
    `role_id`               BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '角色ID，主键',
    `role_code`             VARCHAR(50)         NOT NULL                COMMENT '角色编码，唯一标识',
    `role_name`             VARCHAR(50)         NOT NULL                COMMENT '角色名称',
    `description`           VARCHAR(200)                                COMMENT '角色描述',
    `status`                TINYINT             NOT NULL DEFAULT 1      COMMENT '状态：0=禁用, 1=启用',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`role_id`),
    UNIQUE KEY `uk_role_code` (`role_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员角色表';

-- ============================================================
-- 20. 权限表 (admin_permission)
-- ============================================================
DROP TABLE IF EXISTS `admin_permission`;
CREATE TABLE `admin_permission` (
    `permission_id`         BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '权限ID，主键',
    `permission_code`       VARCHAR(50)         NOT NULL                COMMENT '权限编码，唯一标识',
    `permission_name`       VARCHAR(50)         NOT NULL                COMMENT '权限名称',
    `parent_id`             BIGINT UNSIGNED     NOT NULL DEFAULT 0      COMMENT '父权限ID，0=顶级',
    `permission_type`       TINYINT             NOT NULL                COMMENT '权限类型：1=菜单, 2=按钮, 3=接口',
    `path`                  VARCHAR(200)                                COMMENT '路由路径/接口路径',
    `sort_order`            INT                 NOT NULL DEFAULT 0      COMMENT '排序序号',
    `status`                TINYINT             NOT NULL DEFAULT 1      COMMENT '状态：0=禁用, 1=启用',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`permission_id`),
    UNIQUE KEY `uk_permission_code` (`permission_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员权限表';

-- ============================================================
-- 21. 角色权限关联表 (admin_role_permission)
-- ============================================================
DROP TABLE IF EXISTS `admin_role_permission`;
CREATE TABLE `admin_role_permission` (
    `id`                    BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '自增ID，主键',
    `role_id`               BIGINT UNSIGNED     NOT NULL                COMMENT '角色ID，外键',
    `permission_id`         BIGINT UNSIGNED     NOT NULL                COMMENT '权限ID，外键',
    `created_at`            DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `created_by`            BIGINT UNSIGNED                             COMMENT '创建人ID',
    `updated_by`            BIGINT UNSIGNED                             COMMENT '更新人ID',
    `is_deleted`            TINYINT             NOT NULL DEFAULT 0      COMMENT '是否删除：0=否, 1=是',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_role_permission` (`role_id`, `permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色权限关联表';

-- ============================================================
-- 添加外键约束（可选，根据实际业务需求启用）
-- ============================================================
-- ALTER TABLE `product_base` ADD CONSTRAINT `fk_product_company`
--     FOREIGN KEY (`company_id`) REFERENCES `insurance_company` (`company_id`);
-- ALTER TABLE `critical_illness_product` ADD CONSTRAINT `fk_ci_product`
--     FOREIGN KEY (`product_id`) REFERENCES `product_base` (`product_id`);
-- ALTER TABLE `whole_life_product` ADD CONSTRAINT `fk_wl_product`
--     FOREIGN KEY (`product_id`) REFERENCES `product_base` (`product_id`);
-- ALTER TABLE `annuity_product` ADD CONSTRAINT `fk_annuity_product`
--     FOREIGN KEY (`product_id`) REFERENCES `product_base` (`product_id`);
-- ALTER TABLE `company_rating_history` ADD CONSTRAINT `fk_rating_company`
--     FOREIGN KEY (`company_id`) REFERENCES `insurance_company` (`company_id`);
-- ALTER TABLE `responsibility_item` ADD CONSTRAINT `fk_item_category`
--     FOREIGN KEY (`category_id`) REFERENCES `responsibility_category` (`category_id`);
-- ALTER TABLE `product_responsibility` ADD CONSTRAINT `fk_pr_product`
--     FOREIGN KEY (`product_id`) REFERENCES `product_base` (`product_id`);
-- ALTER TABLE `product_responsibility` ADD CONSTRAINT `fk_pr_item`
--     FOREIGN KEY (`item_id`) REFERENCES `responsibility_item` (`item_id`);
-- ALTER TABLE `product_encoding_map` ADD CONSTRAINT `fk_pem_product`
--     FOREIGN KEY (`product_id`) REFERENCES `product_base` (`product_id`);
-- ALTER TABLE `premium_rate` ADD CONSTRAINT `fk_rate_product`
--     FOREIGN KEY (`product_id`) REFERENCES `product_base` (`product_id`);
-- ALTER TABLE `whole_life_rate` ADD CONSTRAINT `fk_wlr_product`
--     FOREIGN KEY (`product_id`) REFERENCES `product_base` (`product_id`);
-- ALTER TABLE `annuity_rate` ADD CONSTRAINT `fk_ar_product`
--     FOREIGN KEY (`product_id`) REFERENCES `product_base` (`product_id`);
-- ALTER TABLE `annuity_birthday_bonus` ADD CONSTRAINT `fk_abb_product`
--     FOREIGN KEY (`product_id`) REFERENCES `product_base` (`product_id`);
-- ALTER TABLE `user_vip_record` ADD CONSTRAINT `fk_vip_user`
--     FOREIGN KEY (`user_id`) REFERENCES `user_info` (`user_id`);
-- ALTER TABLE `admin_user` ADD CONSTRAINT `fk_admin_role`
--     FOREIGN KEY (`role_id`) REFERENCES `admin_role` (`role_id`);
-- ALTER TABLE `admin_role_permission` ADD CONSTRAINT `fk_rp_role`
--     FOREIGN KEY (`role_id`) REFERENCES `admin_role` (`role_id`);
-- ALTER TABLE `admin_role_permission` ADD CONSTRAINT `fk_rp_permission`
--     FOREIGN KEY (`permission_id`) REFERENCES `admin_permission` (`permission_id`);

-- 恢复外键检查
SET FOREIGN_KEY_CHECKS = 1;
