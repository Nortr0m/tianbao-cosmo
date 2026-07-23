-- ============================================================
-- 产品数据导入
-- 生成时间: 2026-06-18 08:03:00
-- 产品总数: 215
-- ============================================================

USE `tianbao_insurance`;

-- 清空现有产品数据
DELETE FROM `product_base`;
DELETE FROM `whole_life_product`;
DELETE FROM `critical_illness_product`;
DELETE FROM `annuity_product`;

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中华玺（悦享版）终身寿险（分红型）', 'PROD_0001', 37, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 运营规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    1, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中华玺（福庆版）终身寿险（分红型）', 'PROD_0002', 37, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 运营规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    2, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中华盈（A款）终身寿险', 'PROD_0003', 37, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 运营规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    3, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中意一生中意（甄享版）终身寿险（分红型）', 'PROD_0004', 39, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档4份: 投保规则, 销售规则, 条款, 产品说明书', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    4, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中意一生中意（福享版）终身寿险（分红型）', 'PROD_0005', 39, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档4份: 条款, 产品说明书, 投保规则, 销售规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    5, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中意一生中意（鑫享版）终身寿险（分红型）', 'PROD_0006', 39, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档4份: 条款, 产品说明书, 投保规则, 销售规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    6, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中意臻享一生（金玺版）终身寿险（分红型）', 'PROD_0007', 39, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档4份: 产品说明书, 条款, 投保规则, 销售规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    7, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中汇人寿传家保（传富版）终身寿险（分红型）', 'PROD_0008', 28, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档4份: 条款, 产品说明书, 其他, 其他', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    8, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中英人寿爱永恒美式终身寿险（分红型）', 'PROD_0009', 40, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档5份: 产品说明书, 条款, 体检财务规则, 运营规则, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    9, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中英人寿福满佳C款（悦享版）终身寿险（分红型）', 'PROD_0010', 40, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 条款, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    10, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中英人寿福满盈终身寿险C款（分红型）', 'PROD_0011', 40, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 条款, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    11, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中英人寿鑫盈家终身寿险C款（互联网）', 'PROD_0012', 40, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 条款, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    12, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中荷互联网金享事成（优享版）终身寿险', 'PROD_0013', 36, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 条款, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    13, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中荷互联网金享事成（典藏版）终身寿险', 'PROD_0014', 36, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    14, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中邮悦享盈佳（尊享版）终身寿险（分红型）', 'PROD_0015', 144, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 运营规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    15, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中邮悦享盈佳（福享版）终身寿险（分红型）', 'PROD_0016', 144, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 运营规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    16, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中邮臻禧一生（传家版）终身寿险（分红型）', 'PROD_0017', 144, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 运营规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    17, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '信泰如意传承（启航版）终身寿险（互联网专属）', 'PROD_0018', 30, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    18, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '信泰如意尊（泰来2.0）终身寿险（互联网专属）', 'PROD_0019', 30, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    19, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '信泰如意尊（泰来2026）终身寿险（互联网专属）', 'PROD_0020', 30, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 条款, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    20, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '光大永明光明至尊（乐享版）终身寿险（分红型）', 'PROD_0021', 10, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    21, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '光大永明光明至尊（超越版）终身寿险（分红型）', 'PROD_0022', 10, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    22, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '利安鑫利来（青泉版A款）终身寿险（分红型）', 'PROD_0023', 44, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 条款, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    23, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '利安鑫利来（青泉版B款）终身寿险（分红型）', 'PROD_0024', 44, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    24, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '华泰人寿华瑞金生（2025）终身寿险（分红型）', 'PROD_0025', 110, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    25, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '华泰人寿华瑞金生（鑫享版）终身寿险（分红型）', 'PROD_0026', 110, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    26, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '同方全球「传世乐享」（臻宝版）终身寿险（分红型）', 'PROD_0027', 29, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 条款, 运营规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    27, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '同方全球「新传世恒久」（智臻版）终身寿险（分红型）', 'PROD_0028', 29, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 条款, 运营规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    28, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '同方全球「新传世恒久」（臻享版）终身寿险（分红型）', 'PROD_0029', 29, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 条款, 运营规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    29, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '同方全球「新传世荣耀」（稳盈2.0）终身寿险', 'PROD_0030', 29, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 条款, 运营规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    30, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '同方全球「臻世宝2026」互联网终身寿险', 'PROD_0031', 29, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 条款, 运营规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    31, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '国华步步瑞盈终身寿险B款', 'PROD_0032', 12, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    32, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '国宝人寿福樽享C款终身寿险', 'PROD_0033', 11, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 投保规则, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    33, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '国宝人寿福臻享A款终身寿险（分红型）', 'PROD_0034', 11, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 投保规则, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    34, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '国宝人寿福臻享B款终身寿险（分红型）', 'PROD_0035', 11, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 投保规则, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    35, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '国宝人寿福鑫享B款终身寿险', 'PROD_0036', 11, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 投保规则, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    36, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '复星保德信星盈家（玄武版）终身寿险', 'PROD_0037', 6, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 投保规则, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    37, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '复星保德信星福家天马版终身寿险（分红型）', 'PROD_0038', 6, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    38, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '复星保德信星福家朱雀版终身寿险（分红型）', 'PROD_0039', 6, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 投保规则, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    39, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '安联安享汇盈C（III）终身寿险（分红型）', 'PROD_0040', 35, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 投保规则, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    40, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '安联安顺汇福C（5.0）终身寿险（分红型）', 'PROD_0041', 35, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 投保规则, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    41, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '富德生命鑫享5号终身寿险（分红型）', 'PROD_0042', 8, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 条款, 运营规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    42, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '工银安盛人寿鑫享世承终身寿险（2.0版）', 'PROD_0043', 9, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    43, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '工银安盛人寿鑫享如意2025终身寿险（分红型）', 'PROD_0044', 9, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    44, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '幸福乐享2025终身寿险', 'PROD_0045', 117, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 投保规则, 条款, 产品说明书', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    45, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '幸福乐享财富2025终身寿险', 'PROD_0046', 117, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 投保规则, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    46, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '幸福如意2025终身寿险（分红型）', 'PROD_0047', 117, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 投保规则, 条款, 产品说明书', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    47, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '幸福如意步步高终身寿险（分红型）', 'PROD_0048', 117, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 投保规则, 条款, 产品说明书', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    48, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '恒安标准传世瑞盈B款终身寿险（分红型）', 'PROD_0049', 14, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 投保规则, 产品说明书, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    49, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '恒安标准幸福金生活力版2.0终身寿险（分红型）（产品组合）', 'PROD_0050', 14, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 投保规则, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    50, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '恒安标准幸福金生活力版2.0终身寿险（分红型）（单主险）', 'PROD_0051', 14, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 投保规则, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    51, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '恒安标准恒鑫世家2.0终身寿险（分红型）', 'PROD_0052', 14, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 投保规则, 条款, 产品说明书', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    52, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '恒安标准恒鑫世家2.0终身寿险（分红型）（高客）', 'PROD_0053', 14, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 投保规则, 条款, 产品说明书', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    53, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '招商信诺信享传世尊享版终身寿险（分红型）', 'PROD_0054', 42, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档2份: 其他, 产品说明书', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    54, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '招商信诺信享传耀尊贵版终身寿险（分红型）', 'PROD_0055', 42, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 投保规则, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    55, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '招商信诺瑞享鑫生臻享版终身寿险（分红型）', 'PROD_0056', 42, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 其他, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    56, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '新华人寿E增福优享版终身寿险（互联网）', 'PROD_0057', 116, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 投保规则, 产品说明书', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    57, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '泰康乐享世家2026终身寿险', 'PROD_0058', 27, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档4份: 产品说明书, 投保规则, 条款, 销售规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    58, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '泰康乐增寿庆典版终身寿险（分红型）', 'PROD_0059', 27, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档4份: 产品说明书, 投保规则, 条款, 销售规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    59, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '泰康乐增福（尊享版）终身寿险（分红型）', 'PROD_0060', 27, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档4份: 产品说明书, 投保规则, 条款, 销售规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    60, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '瑞众大富翁终身寿险（分红型，长盈版）', 'PROD_0061', 18, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 销售规则, 产品说明书, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    61, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '瑞众大富翁（国盛一号）终身寿险（分红型）', 'PROD_0062', 18, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 条款, 销售规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    62, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '瑞众大富翁（稳赢版）终身寿险', 'PROD_0063', 18, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 运营规则, 产品说明书', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    63, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '瑞众大富翁（鑫瑞版）终身寿险（分红型）', 'PROD_0064', 18, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 条款, 销售规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    64, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '瑞众大富翁（鑫耀版）终身寿险', 'PROD_0065', 18, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 运营规则, 产品说明书', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    65, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '长城山海关永乐典藏版终身寿险（分红型）（单人版）', 'PROD_0066', 32, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档4份: 产品说明书, 投保规则, 条款, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    66, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '长城山海关永乐典藏版终身寿险（分红型）（双人版）', 'PROD_0067', 32, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档4份: 产品说明书, 投保规则, 条款, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    67, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '长城山海关锦绣版终身寿险（分红型）', 'PROD_0068', 32, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档4份: 产品说明书, 投保规则, 条款, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    68, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '长生福家兴终身寿险（分红型）', 'PROD_0069', 33, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 条款, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    69, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '阳光人寿互联网i保鑫多多B款终身寿险', 'PROD_0070', 31, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    70, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '阳光人寿国金壹号2026终身寿险', 'PROD_0071', 31, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 条款, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    71, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '阳光人寿鑫壹号终身寿险（分红型）', 'PROD_0072', 31, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 投保规则, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    72, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '阳光人寿鑫悦相伴终身寿险（分红型）', 'PROD_0073', 31, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 投保规则, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    73, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '阳光人寿阳光升2025终身寿险', 'PROD_0074', 31, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 产品说明书, 投保规则, 条款', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    74, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '陆家嘴国泰泰赢家2.0终身寿险（分红型）', 'PROD_0075', 20, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 产品说明书, 投保规则', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    75, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '陆家嘴国泰鸿利鑫享3.0终身寿险（分红型）', 'PROD_0076', 20, 2,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 增额寿 | 文档3份: 条款, 投保规则, 产品说明书', 1
);
INSERT INTO `whole_life_product` (
    `product_id`, `reduction_rule_type`, `max_add_age`, `add_premium_rule`,
    `loan_ratio`, `loan_rate`, `increase_rate`, `support_age_list`, `created_by`
) VALUES (
    76, 1, 70, 1, 80.00, 5.00, 3.00,
    '[18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70]', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中华鸿A款年金保险', 'PROD_0077', 37, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中意一生中意年金保险（分红型）', 'PROD_0078', 39, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档4份: 条款, 产品说明书, 投保规则, 销售规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中意利满满年金保险（分红型）', 'PROD_0079', 39, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档5份: 产品说明书, 条款, 运营规则, 投保规则, 销售规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中意意值有年金保险（分红型）', 'PROD_0080', 39, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档4份: 条款, 产品说明书, 投保规则, 销售规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中汇人寿启航星（汇赢版）年金保险（分红型）', 'PROD_0081', 28, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 其他', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中汇人寿汇精彩年金保险', 'PROD_0082', 28, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档4份: 条款, 产品说明书, 其他, 其他', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中英人寿悦活人生年金保险B款（分红型）', 'PROD_0083', 40, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中英人寿悦活人生年金保险C款（互联网）', 'PROD_0084', 40, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中英人寿悦活人生年金保险D款', 'PROD_0085', 40, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档4份: 产品说明书, 条款, 运营规则, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中英人寿福相伴养老年金保险', 'PROD_0086', 40, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档4份: 产品说明书, 条款, 运营规则, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中英人寿鑫盈家养老年金保险', 'PROD_0087', 40, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中荷互联网金享年年年金保险', 'PROD_0088', 36, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中荷互联网金生岁享3.0养老年金保险', 'PROD_0089', 36, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档4份: 条款, 产品说明书, 运营规则, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中邮乐享鑫年养老年金保险（分红型）', 'PROD_0090', 144, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 运营规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中邮扬帆985年金保险（分红型）', 'PROD_0091', 144, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 运营规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中邮邮爱一生（鸿禧版）年金保险', 'PROD_0092', 144, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 运营规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '人保寿险民享盈年金保险（A款）（互联网专属）', 'PROD_0093', NULL, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '人保寿险民享盈年金保险（B款）（互联网专属）', 'PROD_0094', NULL, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '信泰如意福享（2026）养老年金保险（互联网专属）', 'PROD_0095', 30, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '光大永明光明慧选（颐享版）养老年金保险（分红型）', 'PROD_0096', 10, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '光大永明光明慧选（颐养版）养老年金保险（分红型）', 'PROD_0097', 10, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '利安安享颐生（青岚版）养老年金保险', 'PROD_0098', 44, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '利安安享颐生（青岚版）养老年金保险（个养版）', 'PROD_0099', 44, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '利安安享颐生（青峰版）养老年金保险（分红型）', 'PROD_0100', 44, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '利安安享颐生（青峰版）养老年金保险（分红型）（个养版）', 'PROD_0101', 44, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '利安鑫享颐生（臻享版）年金保险（分红型）', 'PROD_0102', 44, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '利安鑫享颐生（臻享版）年金保险（分红型）(个养版）', 'PROD_0103', 44, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '华泰人寿泰享金生养老年金保险（分红型）', 'PROD_0104', 110, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '同方全球「同悦人生」年金保险（分红型）', 'PROD_0105', 29, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 运营规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '同方全球「臻享年年2026」互联网养老年金', 'PROD_0106', 29, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 运营规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '同方全球「臻宝贝2026」互联网年金保险', 'PROD_0107', 29, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 运营规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '国华乐享天伦养老年金保险B款', 'PROD_0108', 12, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '国华步步高升年金保险B款', 'PROD_0109', 12, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '国宝人寿宝悦人生年金保险（分红型）', 'PROD_0110', 11, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '国宝人寿宝逸人生年金保险', 'PROD_0111', 11, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '国民慧选2号（乐享版）养老年金保险（互联网）', 'PROD_0112', 152, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 运营规则, 产品说明书, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '国民慧选2号（节税版）A款养老年金保险（互联网）', 'PROD_0113', 152, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '国民慧选2号（节税版）养老年金保险（互联网）', 'PROD_0114', 152, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 运营规则, 产品说明书, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '复星保德信星海赢家火凤版养老年金保险（分红型）', 'PROD_0115', 6, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '复星保德信星海赢家玄武版养老年金保险（分红型）', 'PROD_0116', 6, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '复星保德信星海赢家青鸾版养老年金保险 (分红型)', 'PROD_0117', 6, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '复星保德信星海赢家（朱雀版）养老年金保险', 'PROD_0118', 6, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '复星保德信星颐3.0年金保险', 'PROD_0119', 6, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '复星保德信星颐朱雀版年金保险（分红型）', 'PROD_0120', 6, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '大家养老大富之家（恒享版）养老年金保险（分红型）', 'PROD_0121', 140, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 投保规则, 产品说明书, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '大家养老大富之家（鼎鑫版）养老年金保险（分红型）', 'PROD_0122', 140, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 投保规则, 产品说明书, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '大家养老大成之家（未来版）年金保险（分红型）', 'PROD_0123', 140, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '大家养老大盈之家（恒裕版）养老年金保险', 'PROD_0124', 140, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '大家养老大盈之家（臻选版）养老年金保险（分红型）', 'PROD_0125', 140, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '大家养老大盈之家（鑫享版）养老年金保险（分红型）', 'PROD_0126', 140, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '大家养老大盈之家（鑫御版）养老年金保险', 'PROD_0127', 140, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '大家养老大福之家（快享版）年金保险（分红型）', 'PROD_0128', 140, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 投保规则, 产品说明书, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '大家养老大锦之家（稳盈版）养老年金保险（分红型）', 'PROD_0129', 140, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '大家养老鑫享久久A款养老年金保险', 'PROD_0130', 140, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 投保规则, 产品说明书, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '大家养老鑫享年年A款养老年金保险', 'PROD_0131', 140, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 投保规则, 产品说明书, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '大家金彩一生养老年金保险', 'PROD_0132', 1, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '大家金悦年年年金保险（分红型）', 'PROD_0133', 1, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '大家金禧一生年金保险', 'PROD_0134', 1, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '太平e满多年金保险（互联网专属）', 'PROD_0135', 121, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 运营规则, 产品说明书', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '安联安享丰赢C养老年金保险（分红型）', 'PROD_0136', 35, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '安联安享鑫生C（II）终身年金保险（分红型）', 'PROD_0137', 35, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '安联安享颐年养老年金保险（分红型）', 'PROD_0138', 35, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '安联安赢丰年年金保险（分红型）', 'PROD_0139', 35, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '富德生命大富翁6.0养老年金保险', 'PROD_0140', 8, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 运营规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '富德生命鑫如意2.0养老年金保险', 'PROD_0141', 8, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 运营规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '富德生命鑫富宝年金保险C款', 'PROD_0142', 8, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 运营规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '富德生命鑫富盈年金保险A款（分红型）', 'PROD_0143', 8, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 运营规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '富德生命鑫富盈年金保险B款（分红型）', 'PROD_0144', 8, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 运营规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '工银安盛人寿盛享丰年养老年金保险（2.0版）', 'PROD_0145', 9, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '工银安盛人寿盛享丰年养老年金保险（2.0版）（个养版）', 'PROD_0146', 9, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '工银安盛人寿盛享嘉年养老年金保险（分红型）', 'PROD_0147', 9, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '幸福相伴年年养老年金保险', 'PROD_0148', 117, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 投保规则, 条款, 产品说明书', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '恒安标准幸福到老长寿2.0养老年金保险（分红型）', 'PROD_0149', 14, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 投保规则, 产品说明书, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '恒安标准恒爱尊享3.0终身年金保险（分红型）', 'PROD_0150', 14, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 投保规则, 产品说明书', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '恒安标准筑梦未来3.0教育金年金保险（分红型）', 'PROD_0151', 14, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '招商信诺信享盈家养老年金保险（分红型）', 'PROD_0152', 42, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '招商信诺信享盈家悦享版养老年金保险（分红型）', 'PROD_0153', 42, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '泰康乐享百岁庆典版养老年金保险（分红型）', 'PROD_0154', 27, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档4份: 产品说明书, 投保规则, 条款, 销售规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '泰康乐享百岁庆典版养老年金保险（分红型）(个养版)', 'PROD_0155', 27, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档4份: 产品说明书, 投保规则, 条款, 销售规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '泰康乐盈年年年金保险（分红型）', 'PROD_0156', 27, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档4份: 产品说明书, 投保规则, 条款, 销售规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '海港e生养老年金保险（分红型）', 'PROD_0157', 15, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '海港守护e生年金保险（分红型）', 'PROD_0158', 15, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '海港星耀人生年金保险（互联网）', 'PROD_0159', 15, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '海港星耀金生年金保险（互联网）', 'PROD_0160', 15, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '瑞众东方红（岁盈版）年金保险', 'PROD_0161', 18, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 运营规则, 产品说明书', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '瑞众东方红（锦骏版）年金保险（分红型）', 'PROD_0162', 18, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 销售规则, 产品说明书, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '瑞众东方红（鲲鹏版）年金保险（分红型）', 'PROD_0163', 18, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 销售规则, 产品说明书, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '瑞众瑞年年（乐养版）养老年金保险', 'PROD_0164', 18, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 销售规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '长城八达岭南山旗舰A款年金保险（分红型）（单人版）', 'PROD_0165', 32, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档4份: 产品说明书, 投保规则, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '长城八达岭南山旗舰A款年金保险（分红型）（双人版）', 'PROD_0166', 32, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档4份: 产品说明书, 投保规则, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '长城八达岭绝影版年金保险（分红型）', 'PROD_0167', 32, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '长城八达岭赤兔版A款年金保险（分红型）', 'PROD_0168', 32, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '长城明爱金彩D款养老年金保险（分红型）', 'PROD_0169', 32, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档5份: 产品说明书, 其他, 投保规则, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '长城明爱金彩养老年金保险（互联网）', 'PROD_0170', 32, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档4份: 投保规则, 投保规则, 产品说明书, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '长生福来运年金保险（分红型）', 'PROD_0171', 33, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '长生福运连连年金保险（2.0版）', 'PROD_0172', 33, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '阳光人寿互联网i保福享多D款年金保险（个养版）', 'PROD_0173', 31, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '阳光人寿互联网好享盈年金保险', 'PROD_0174', 31, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '阳光人寿互联网未来星年金保险', 'PROD_0175', 31, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '阳光人寿鑫悦人生养老年金保险（分红型）（个养版）', 'PROD_0176', 31, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '阳光人寿鑫悦人生养老年金保险（分红型）（普通版）', 'PROD_0177', 31, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '阳光人寿鑫悦双享年金保险（分红型）', 'PROD_0178', 31, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '阳光人寿鑫悦双享年金保险（分红型）（个养版）', 'PROD_0179', 31, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '阳光人寿颐享金升2025养老年金保险（分红型）', 'PROD_0180', 31, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '陆家嘴国泰泰享年年养老年金保险（分红型）', 'PROD_0181', 20, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 投保规则, 产品说明书', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '陆家嘴国泰泰有鑫意养老年金保险', 'PROD_0182', 20, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档4份: 条款, 投保规则, 运营规则, 产品说明书', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '陆家嘴国泰泰给利2.0年金保险（分红型）', 'PROD_0183', 20, 3,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 年金险 | 文档3份: 条款, 投保规则, 产品说明书', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中华星（2025版）少儿重大疾病保险', 'PROD_0184', 37, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档4份: 条款, 产品说明书, 投保规则, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '中英人寿爱守护C款重大疾病保险', 'PROD_0185', 40, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '人保寿险无敌宝宝2.0少儿重大疾病保险（互联网专属）', 'PROD_0186', NULL, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '众安众民保·重疾险（简易健告）', 'PROD_0187', 102, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档2份: 其他, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '众安尊享e生·重疾险', 'PROD_0188', 102, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 其他, 其他, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '众民保·重疾险', 'PROD_0189', 102, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档6份: 其他, 其他, 其他, 其他, 其他, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '信泰及时雨（2026）重大疾病保险（互联网专属）', 'PROD_0190', 30, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '信美相互达尔文宝贝计划15号重大疾病保险', 'PROD_0191', NULL, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档7份: 产品说明书, 条款, 产品说明书, 条款, 产品说明书, 条款, 其他', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '全民星·百万重疾津贴险（中端特需版）', 'PROD_0192', 102, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档4份: 其他, 其他, 其他, 其他', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '北京人寿小福娃2号（守护版）少儿重疾保险计划（互联网专属）', 'PROD_0193', 4, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档6份: 产品说明书, 条款, 产品说明书, 条款, 投保规则, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '华贵麦兜兜2026少儿重大疾病保险（互联网专属）', 'PROD_0194', 19, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '同方全球「新康健」（守护版）重大疾病保险', 'PROD_0195', 29, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 产品说明书, 条款, 运营规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '君龙小青龙8号D款少儿重大疾病保险（互联网）', 'PROD_0196', 143, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '君龙明爱智选重大疾病保险（互联网）', 'PROD_0197', 143, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档6份: 条款, 条款, 投保规则, 投保规则, 其他, 其他', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '国富人寿海绵保宝少儿重大疾病保险（互联网）', 'PROD_0198', 13, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 投保规则, 产品说明书, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '复星保德信明爱守护重大疾病保险（互联网专属）', 'PROD_0199', 6, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 投保规则, 产品说明书, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '复星联合妈咪保贝爱常在少儿重大疾病保险（B款）（互联网）', 'PROD_0200', 7, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 运营规则, 产品说明书, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '复星联合康乐一生（2026版）重大疾病保险（互联网）', 'PROD_0201', 7, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 运营规则, 产品说明书, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '复星联合达尔文12号重大疾病保险（互联网）', 'PROD_0202', 7, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 条款, 投保规则, 产品说明书', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '安联安康常伴C少儿重大疾病保险', 'PROD_0203', 35, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '安联安康恒佑C（II）重大疾病保险', 'PROD_0204', 35, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '富德生命臻健康2.0重大疾病保险', 'PROD_0205', 8, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 产品说明书, 条款, 运营规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '工银安盛人寿御享欣生重大疾病保险（2.0版）', 'PROD_0206', 9, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 条款, 产品说明书, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '德华安顾人寿大爱无疆·易核重疾险（互联网）', 'PROD_0207', NULL, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 运营规则, 条款, 产品说明书', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '德华安顾安享保重大疾病保险（2025版）（互联网）', 'PROD_0208', NULL, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 运营规则, 条款, 产品说明书', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '招商仁和青云卫6号少儿重大疾病保险（互联网）', 'PROD_0209', NULL, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档6份: 条款, 条款, 产品说明书, 产品说明书, 运营规则, 运营规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '海港安心保（续航版）重大疾病保险', 'PROD_0210', 15, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '紫金康康保个人重大疾病保险（互联网专属2025版）', 'PROD_0211', NULL, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档2份: 其他, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '长生恒生宝重大疾病保险（2.0版）', 'PROD_0212', 33, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 产品说明书, 条款, 投保规则', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '阳光人寿互联网新随e保（2025升级版）重疾险', 'PROD_0213', 31, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 产品说明书, 投保规则, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '阳光人寿倍享阳光关爱多2.0重大疾病保险', 'PROD_0214', 31, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 投保规则, 产品说明书, 条款', 1
);

INSERT INTO `product_base` (
    `product_name`, `product_code`, `company_id`, `product_type`,
    `min_age`, `max_age`, `payment_years`, `occupation_class`,
    `payment_periods`, `sale_status`, `system_status`, `remark`, `created_by`
) VALUES (
    '陆家嘴国泰泰保贝B款少儿重大疾病保险', 'PROD_0215', 20, 1,
    0, 70, '[1, 3, 5, 10, 15, 20]', 6,
    '["终身"]', 1, 1, '分类: 重疾险 | 文档3份: 条款, 投保规则, 产品说明书', 1
);
