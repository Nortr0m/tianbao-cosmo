-- 产品表新增维护状态字段
ALTER TABLE product_base
    ADD COLUMN maintenance_status INT DEFAULT 2 COMMENT '维护状态（0-解析中，1-待人工确认，2-已确认，3-下线）' AFTER system_status;

-- 现有数据默认设置为已确认状态
UPDATE product_base SET maintenance_status = 2 WHERE maintenance_status IS NULL;

-- 产品资料完整度表
CREATE TABLE IF NOT EXISTS product_document_status (
    product_id BIGINT PRIMARY KEY COMMENT '产品ID',
    has_terms BOOLEAN DEFAULT FALSE COMMENT '是否有保险条款',
    has_brochure BOOLEAN DEFAULT FALSE COMMENT '是否有产品说明书',
    has_rules BOOLEAN DEFAULT FALSE COMMENT '是否有投保规则',
    has_rate_table BOOLEAN DEFAULT FALSE COMMENT '是否有费率表',
    has_cash_value BOOLEAN DEFAULT FALSE COMMENT '是否有现金价值表',
    folder_path VARCHAR(500) DEFAULT NULL COMMENT '产品资料文件夹路径',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    CONSTRAINT fk_pds_product_id FOREIGN KEY (product_id) REFERENCES product_base(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='产品资料完整度表';

-- 创建索引
CREATE INDEX idx_product_maintenance_status ON product_base(maintenance_status);
CREATE INDEX idx_product_sale_status ON product_base(sale_status);
CREATE INDEX idx_product_system_status ON product_base(system_status);
