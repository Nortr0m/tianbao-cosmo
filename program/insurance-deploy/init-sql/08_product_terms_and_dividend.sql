-- =====================================================
-- 产品条款信息表 + 分红相关表 + 子类表扩展字段
-- 创建时间: 2026-07-05
-- 说明: 用于存储产品条款文本信息和分红演示数据
-- =====================================================

-- 1. 产品条款信息表（存储犹豫期/等待期/责任摘要/免责条款等文本信息）
CREATE TABLE IF NOT EXISTS `product_terms` (
    `terms_id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `product_id`        BIGINT UNSIGNED NOT NULL COMMENT '产品ID',
    `insurance_period`  VARCHAR(200) COMMENT '保险期间',
    `hesitation_period` VARCHAR(50) COMMENT '犹豫期',
    `waiting_period`    VARCHAR(50) COMMENT '等待期',
    `liability_summary` TEXT COMMENT '保险责任摘要',
    `exclusion_summary` TEXT COMMENT '责任免除条款概要',
    `other_rights`      TEXT COMMENT '其他权益',
    `sale_region`       VARCHAR(500) COMMENT '销售区域',
    `product_terms_raw` JSON COMMENT '原始条款完整JSON',
    `created_at`        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `is_deleted`        TINYINT NOT NULL DEFAULT 0,
    PRIMARY KEY (`terms_id`),
    UNIQUE KEY `uk_product_id` (`product_id`),
    KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='产品条款信息表';

-- 2. 产品分红配置表（三档演示利率配置）
CREATE TABLE IF NOT EXISTS `product_dividend_config` (
    `config_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `product_id` BIGINT UNSIGNED NOT NULL COMMENT '产品ID',
    `scheduled_rate` DECIMAL(6,4) COMMENT '预定利率',
    `guaranteed_rate` DECIMAL(6,4) COMMENT '保证利率',
    `min_guaranteed_rate` DECIMAL(6,4) COMMENT '最低保证利率',
    `increase_rate` DECIMAL(6,4) COMMENT '增额比例',
    `dividend_low_rate` DECIMAL(6,4) COMMENT '低档演示利率',
    `dividend_mid_rate` DECIMAL(6,4) COMMENT '中档演示利率',
    `dividend_high_rate` DECIMAL(6,4) COMMENT '高档演示利率',
    `dividend_assumed_rate` DECIMAL(6,4) COMMENT '假定分红利率',
    `universal_settle_rate` DECIMAL(6,4) COMMENT '万能结算利率',
    `min_settle_rate` DECIMAL(6,4) COMMENT '最低结算利率',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `is_deleted` TINYINT NOT NULL DEFAULT 0,
    PRIMARY KEY (`config_id`),
    UNIQUE KEY `uk_product_id` (`product_id`),
    KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='产品分红配置表';

-- 3. 增额终身寿险分红演示利率表（按性别/年龄/缴费年限/保单年度的保证/中/高档数据）
CREATE TABLE IF NOT EXISTS `whole_life_dividend_rate` (
    `rate_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `product_id` BIGINT UNSIGNED NOT NULL COMMENT '产品ID',
    `gender` TINYINT NOT NULL COMMENT '性别(1男/0女)',
    `age` INT NOT NULL COMMENT '投保年龄',
    `payment_year` INT NOT NULL COMMENT '缴费年限',
    `policy_year` INT NOT NULL COMMENT '保单年度',
    `cash_value_guaranteed` DECIMAL(15,2) COMMENT '保证现金价值',
    `cash_value_mid_dividend` DECIMAL(15,2) COMMENT '中档分红现金价值',
    `cash_value_high_dividend` DECIMAL(15,2) COMMENT '高档分红现金价值',
    `death_benefit_guaranteed` DECIMAL(15,2) COMMENT '保证身故保险金',
    `death_benefit_mid_dividend` DECIMAL(15,2) COMMENT '中档分红身故保险金',
    `death_benefit_high_dividend` DECIMAL(15,2) COMMENT '高档分红身故保险金',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`rate_id`),
    UNIQUE KEY `uk_rate` (`product_id`, `gender`, `age`, `payment_year`, `policy_year`),
    KEY `idx_product_gender` (`product_id`, `gender`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='增额终身寿险分红演示利率表';

-- 4. 年金险现金价值表（含年领取金额）
CREATE TABLE IF NOT EXISTS `annuity_cash_value` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `product_id` BIGINT UNSIGNED NOT NULL COMMENT '产品ID',
    `gender` TINYINT NOT NULL COMMENT '性别(1男/0女)',
    `age` INT NOT NULL COMMENT '投保年龄',
    `payment_year` INT NOT NULL COMMENT '缴费年限',
    `policy_year` INT NOT NULL COMMENT '保单年度',
    `cash_value` DECIMAL(15,2) COMMENT '现金价值',
    `death_benefit` DECIMAL(15,2) COMMENT '身故保险金',
    `annual_payout` DECIMAL(15,2) COMMENT '年领取金额',
    `total_received` DECIMAL(15,2) COMMENT '累计领取金额',
    `cash_value_guaranteed` DECIMAL(15,2) COMMENT '保证现金价值(分红型)',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_annuity_cv` (`product_id`, `gender`, `age`, `payment_year`, `policy_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='年金险现金价值表';

-- 5. 扩展 whole_life_product 表（增额寿专属条款字段）
ALTER TABLE `whole_life_product`
    ADD COLUMN IF NOT EXISTS `reduction_rule_text` TEXT COMMENT '减保限制规则文字版' AFTER `support_age_list`,
    ADD COLUMN IF NOT EXISTS `add_rule_text` TEXT COMMENT '加保规则文字说明' AFTER `reduction_rule_text`,
    ADD COLUMN IF NOT EXISTS `second_applicant_rule` VARCHAR(200) COMMENT '第二投保人规则' AFTER `add_rule_text`,
    ADD COLUMN IF NOT EXISTS `cross_generation` TINYINT DEFAULT 0 COMMENT '是否支持隔代投保' AFTER `second_applicant_rule`,
    ADD COLUMN IF NOT EXISTS `trust_linkage` TINYINT DEFAULT 0 COMMENT '是否支持信托对接' AFTER `cross_generation`,
    ADD COLUMN IF NOT EXISTS `min_premium` DECIMAL(15,2) COMMENT '最低保费要求' AFTER `trust_linkage`,
    ADD COLUMN IF NOT EXISTS `min_sum_assured` DECIMAL(15,2) COMMENT '最低保额要求' AFTER `min_premium`,
    ADD COLUMN IF NOT EXISTS `health_class` VARCHAR(100) COMMENT '健康分级规则' AFTER `min_sum_assured`,
    ADD COLUMN IF NOT EXISTS `typical_rate_example` TEXT COMMENT '典型费率示例' AFTER `health_class`,
    ADD COLUMN IF NOT EXISTS `death_payout_rule` VARCHAR(500) COMMENT '身故赔付规则(K值说明)' AFTER `typical_rate_example`;

-- 6. 扩展 annuity_product 表（年金险专属条款字段）
ALTER TABLE `annuity_product`
    ADD COLUMN IF NOT EXISTS `annuity_type` VARCHAR(100) COMMENT '年金类型(养老年金/教育年金/普通年金)' AFTER `increase_end_year`,
    ADD COLUMN IF NOT EXISTS `payout_rule_text` TEXT COMMENT '领取方式文字版' AFTER `annuity_type`,
    ADD COLUMN IF NOT EXISTS `is_lifelong` TINYINT DEFAULT 0 COMMENT '是否终身领取' AFTER `payout_rule_text`,
    ADD COLUMN IF NOT EXISTS `min_premium` DECIMAL(15,2) COMMENT '起投金额' AFTER `is_lifelong`,
    ADD COLUMN IF NOT EXISTS `death_benefit_rule` TEXT COMMENT '身故保险金规则' AFTER `min_premium`,
    ADD COLUMN IF NOT EXISTS `universal_account_linked` TINYINT DEFAULT 0 COMMENT '是否关联万能账户' AFTER `death_benefit_rule`,
    ADD COLUMN IF NOT EXISTS `universal_account_name` VARCHAR(200) COMMENT '万能账户名称' AFTER `universal_account_linked`,
    ADD COLUMN IF NOT EXISTS `universal_guaranteed_rate` DECIMAL(5,3) COMMENT '万能账户保底利率' AFTER `universal_account_name`,
    ADD COLUMN IF NOT EXISTS `community_linkage` TINYINT DEFAULT 0 COMMENT '是否对接养老社区' AFTER `universal_guaranteed_rate`,
    ADD COLUMN IF NOT EXISTS `community_name` VARCHAR(200) COMMENT '养老社区名称' AFTER `community_linkage`,
    ADD COLUMN IF NOT EXISTS `first_return_time` VARCHAR(200) COMMENT '首次返还时间/规则' AFTER `community_name`,
    ADD COLUMN IF NOT EXISTS `return_frequency` VARCHAR(100) COMMENT '返还频率' AFTER `first_return_time`,
    ADD COLUMN IF NOT EXISTS `return_amount_rule` TEXT COMMENT '每期返还金额规则' AFTER `return_frequency`,
    ADD COLUMN IF NOT EXISTS `typical_rate_example` TEXT COMMENT '典型费率示例' AFTER `return_amount_rule`;

-- 7. 扩展 product_base 表（收益类型）
ALTER TABLE `product_base`
    ADD COLUMN IF NOT EXISTS `yield_type` VARCHAR(100) COMMENT '收益类型(固收型/分红型/万能型)' AFTER `half_yearly_ratio`;
