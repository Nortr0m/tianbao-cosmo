-- ============================================================
-- 数据库初始化脚本 03：初始化基础数据
-- 严格遵循PRD第8章数据模型设计和第9.2节数据库规范
-- ============================================================

USE `tianbao_insurance`;

-- ============================================================
-- 1. 初始化责任一级分类 (responsibility_category)
-- ============================================================
INSERT INTO `responsibility_category` (`category_code`, `category_name`, `sort_order`, `is_active`, `created_by`) VALUES
('BASE',        '基础保障',     1, 1, 1),
('DEATH',       '身故责任',     2, 1, 1),
('WAIVER',      '豁免责任',     3, 1, 1),
('MULTI_PAY',   '多次赔付',     4, 1, 1),
('BONUS',       '额外赔付',     5, 1, 1),
('ALLOWANCE',   '津贴责任',     6, 1, 1),
('SPECIAL',     '特色责任',     7, 1, 1);

-- ============================================================
-- 2. 初始化管理员角色 (admin_role)
-- ============================================================
INSERT INTO `admin_role` (`role_code`, `role_name`, `description`, `status`, `created_by`) VALUES
('super_admin',     '超级管理员',   '拥有系统全部权限，可进行所有操作',          1, 1),
('product_admin',   '产品管理员',   '负责保险产品信息维护、上下架管理',          1, 1),
('data_admin',      '数据管理员',   '负责费率数据导入、数据校验与维护',          1, 1),
('operation_admin', '运营管理员',   '负责卡片模板管理、内容运营、用户管理',      1, 1);

-- ============================================================
-- 3. 初始化管理员账号 (admin_user)
-- 密码：123456，使用BCrypt加密
-- 加密结果：$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO
-- 注意：以下为BCrypt哈希示例值，实际使用前请重新生成
-- ============================================================
INSERT INTO `admin_user` (`username`, `password`, `real_name`, `phone`, `email`, `role_id`, `status`, `created_by`) VALUES
('superadmin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '超级管理员', '13800138000', 'admin@tianbao.com', 1, 1, 1),
('productadmin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '产品管理员', '13800138003', 'product@tianbao.com', 2, 1, 1),
('dataadmin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '数据管理员', '13800138004', 'data@tianbao.com', 3, 1, 1),
('opadmin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '运营管理员', '13800138005', 'op@tianbao.com', 4, 1, 1);

-- ============================================================
-- 4. 初始化卡片模板分类 (card_template)
-- ============================================================
INSERT INTO `card_template` (`template_name`, `category_code`, `tags`, `ai_prompt`, `search_keywords`, `background_url`, `default_title`, `default_subtitle`, `is_system`, `is_recommended`, `sort_order`, `is_active`, `created_by`) VALUES
('少儿教育金模板',    'EDUCATION',    '["教育金", "少儿", "规划"]',        '为0-12岁儿童设计的教育金保险规划卡片，突出长期储蓄和阶段性领取特点', '教育金,少儿保险,学费规划,教育储备', 'https://cdn.tianbao.com/templates/education_bg.jpg', '给孩子最好的未来', '从幼儿园到大学，全程守护成长', 1, 1, 1, 1, 1),
('养老规划模板',      'PENSION',      '["养老", "退休", "年金"]',        '为30-55岁人群设计的养老金规划卡片，强调长期稳定收益和终身领取', '养老金,退休规划,养老保险,晚年保障', 'https://cdn.tianbao.com/templates/pension_bg.jpg', '优雅养老，从容人生', '现在开始规划，未来安心养老', 1, 1, 2, 1, 1),
('财富传承模板',      'WEALTH',       '["传承", "财富", "终身寿险"]',    '为高净值人群设计的财富传承规划卡片，突出资产保全和定向传承功能', '财富传承,资产保全,终身寿险,家族信托', 'https://cdn.tianbao.com/templates/wealth_bg.jpg', '财富永续，家族长青', '科学规划，让财富代代相传', 1, 1, 3, 1, 1),
('重疾保障模板',      'HEALTH',       '["重疾", "健康", "保障"]',        '为18-50岁人群设计的重大疾病保障卡片，强调高额赔付和多次保障', '重疾险,健康保障,疾病保险,医疗保障', 'https://cdn.tianbao.com/templates/health_bg.jpg', '守护健康，安心生活', '全面重疾保障，让生命更有尊严', 1, 1, 4, 1, 1),
('少儿专属模板',      'CHILDREN',     '["少儿", "儿童", "专属"]',        '专为0-17岁儿童设计的保险规划卡片，突出少儿特疾和保费豁免', '少儿保险,儿童重疾,保费豁免,成长守护', 'https://cdn.tianbao.com/templates/children_bg.jpg', '宝贝计划，全面守护', '专为孩子设计，守护健康成长', 1, 0, 5, 1, 1),
('家庭守护模板',      'FAMILY',       '["家庭", "综合", "全家"]',        '为家庭设计的综合保障规划卡片，涵盖重疾、意外、医疗等多维度', '家庭保险,全家保障,综合保障,家庭计划', 'https://cdn.tianbao.com/templates/family_bg.jpg', '一家之主，守护全家', '一张保单，守护全家幸福', 1, 1, 6, 1, 1),
('企业主专属模板',    'BUSINESS',     '["企业主", "高端", "定制"]',      '为企业主和高管设计的专属保险规划卡片，强调资产隔离和高端医疗', '企业主保险,高端医疗,资产隔离,高管保障', 'https://cdn.tianbao.com/templates/business_bg.jpg', '事业有为，保障无忧', '专为企业精英量身定制', 1, 0, 7, 1, 1),
('节日营销模板',      'FESTIVAL',     '["节日", "营销", "活动"]',        '节日主题营销卡片模板，适用于各类节日保险推广活动', '节日营销,保险活动,推广卡片,节日特惠', 'https://cdn.tianbao.com/templates/festival_bg.jpg', '节日特惠，保障加倍', '限时优惠，为家人添一份保障', 1, 0, 8, 1, 1),
('开门红专属模板',    'KAI_MEN_HONG', '["开门红", "新年", "促销"]',     '开门红活动期间专属卡片模板，突出限时优惠和专属产品', '开门红,新年保险,限时优惠,专属产品', 'https://cdn.tianbao.com/templates/kaimenhong_bg.jpg', '新年开门红，保障新启程', '限时专属，开启新年保障计划', 1, 1, 9, 1, 1),
('极简通用模板',      'MINIMALIST',   '["极简", "通用", "简约"]',        '极简风格通用卡片模板，适用于各类保险产品的快速展示', '极简,通用模板,简约风格,快速展示', 'https://cdn.tianbao.com/templates/minimalist_bg.jpg', '简单保障，安心生活', '化繁为简，保障一目了然', 1, 0, 10, 1, 1);

-- ============================================================
-- 5. 初始化示例保险公司 (insurance_company)
-- ============================================================
INSERT INTO `insurance_company` (`company_name`, `company_short_name`, `company_code`, `logo_url`, `official_website`, `service_phone`, `established_year`, `registered_capital`, `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`, `introduction`, `feature_tags`, `cooperation_status`, `cooperation_start_date`, `sort_order`, `is_hot`, `created_by`) VALUES
('中国平安人寿保险股份有限公司', '平安人寿', 'PINGAN_LIFE', 'https://cdn.tianbao.com/logos/pingan.png', 'https://life.pingan.com', '95511', 1988, 3380000.00, '深圳', 1, 'AAA', 230.50, '中国平安人寿保险股份有限公司成立于1988年，是中国第一家股份制保险企业，现已发展成为融保险、银行、投资等金融业务为一体的综合金融服务集团。', '["综合金融", "科技赋能", "服务网络广"]', 1, '2024-01-01', 1, 1, 1),
('中国人寿保险股份有限公司', '中国人寿', 'CHINA_LIFE', 'https://cdn.tianbao.com/logos/chinalife.png', 'https://www.e-chinalife.com', '95519', 1949, 2826500.00, '北京', 1, 'AAA', 210.30, '中国人寿保险股份有限公司是国内最大的寿险公司，总部位于北京，注册资本282.65亿元人民币，提供个人人寿保险、团体人寿保险、意外险和健康险等产品与服务。', '["国有背景", "网点众多", "品牌信赖"]', 1, '2024-01-01', 2, 1, 1),
('太平洋人寿保险股份有限公司', '太平洋人寿', 'CPIC_LIFE', 'https://cdn.tianbao.com/logos/cpic.png', 'https://www.cpic.com.cn', '95500', 1991, 842000.00, '上海', 1, 'AA+', 205.80, '中国太平洋人寿保险股份有限公司成立于1991年，总部设在上海，是国内领先的综合性保险集团，业务涵盖人寿保险、健康保险、意外伤害保险等。', '["稳健经营", "产品丰富", "理赔快速"]', 1, '2024-01-01', 3, 1, 1),
('新华人寿保险股份有限公司', '新华保险', 'NEW_CHINA_LIFE', 'https://cdn.tianbao.com/logos/newchinalife.png', 'https://www.newchinalife.com', '95567', 1996, 3119500.00, '北京', 1, 'AA+', 198.60, '新华人寿保险股份有限公司成立于1996年，是一家全国性大型寿险企业，主要股东为中央汇金投资有限责任公司，提供各类人寿保险、健康保险和人身意外伤害保险。', '["国有控股", "投资稳健", "养老特色"]', 1, '2024-01-01', 4, 0, 1),
('泰康人寿保险有限责任公司', '泰康人寿', 'TAIKANG_LIFE', 'https://cdn.tianbao.com/logos/taikang.png', 'https://www.taikanglife.com', '95522', 1996, 300000.00, '北京', 1, 'AA', 185.20, '泰康人寿保险有限责任公司成立于1996年，是一家涵盖保险、资管、医养三大核心业务的大型保险金融服务集团，创新推出"保险+医养"模式。', '["医养结合", "养老社区", "健康管理"]', 1, '2024-01-01', 5, 1, 1);

-- ============================================================
-- 6. 初始化示例产品父类 (product_base)
-- ============================================================
INSERT INTO `product_base` (`product_name`, `product_code`, `company_id`, `product_type`, `sub_type`, `min_age`, `max_age`, `payment_years`, `occupation_class`, `payment_periods`, `monthly_ratio`, `quarterly_ratio`, `half_yearly_ratio`, `sale_status`, `system_status`, `created_by`) VALUES
('平安福2024重大疾病保险', 'PINGANFU_2024', 1, 1, 1, 18, 55, '[5, 10, 15, 20, 30]', 4, '["终身"]', 0.0900, 0.2700, 0.5200, 1, 1, 1),
('国寿福终身重大疾病保险', 'GUOSHOUFU_2024', 2, 1, 1, 28, 60, '[5, 10, 15, 20, 30]', 4, '["终身"]', 0.0880, 0.2650, 0.5100, 1, 1, 1),
('太保鑫相伴增额终身寿险', 'XINXIANGBAN_2024', 3, 2, 1, 18, 70, '[3, 5, 10, 20]', 6, '["终身"]', 0.0850, 0.2550, 0.5000, 1, 1, 1),
('泰康瑞享一生年金保险', 'RUIXIANG_2024', 5, 3, 1, 18, 65, '[3, 5, 10, 15, 20]', 6, '["至80岁", "至90岁", "终身"]', 0.0850, 0.2550, 0.5000, 1, 1, 1),
('新华多倍保重大疾病保险', 'DUOBEIBAO_2024', 4, 1, 2, 18, 55, '[5, 10, 15, 20]', 4, '["终身", "至70岁"]', 0.0890, 0.2680, 0.5150, 1, 1, 1);

-- ============================================================
-- 7. 初始化重疾险子类 (critical_illness_product)
-- ============================================================
INSERT INTO `critical_illness_product` (`product_id`, `waiting_period`, `waiting_period_rule`, `critical_count`, `critical_ratio`, `medium_count`, `medium_ratio`, `light_count`, `light_ratio`, `critical_multi_interval`, `cancer_multi_interval`, `cvd_multi_interval`, `disease_care_age`, `disease_care_critical_ratio`, `disease_care_medium_ratio`, `disease_care_light_ratio`, `created_by`) VALUES
(1, 90, 1, 120, 100, 20, 50, 40, 30, 1, 3, 1, 60, 80, 30, 15),
(2, 180, 1, 100, 100, 15, 50, 30, 30, 1, 3, 1, 70, 50, 25, 10),
(5, 90, 1, 110, 100, 25, 60, 50, 30, 1, 3, 1, 60, 100, 40, 20);

-- ============================================================
-- 8. 初始化增额终身寿险子类 (whole_life_product)
-- ============================================================
INSERT INTO `whole_life_product` (`product_id`, `reduction_rule_type`, `reduction_start_year`, `reduction_times_limit`, `max_add_age`, `add_premium_rule`, `add_times_limit`, `add_ratio_limit`, `loan_ratio`, `loan_rate`, `increase_rate`, `increase_end_age`, `support_age_list`, `created_by`) VALUES
(3, 1, 5, 1, 70, 1, 5, 20, 80.00, 5.50, 3.50, 105, '[18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70]', 1);

-- ============================================================
-- 9. 初始化年金险子类 (annuity_product)
-- ============================================================
INSERT INTO `annuity_product` (`product_id`, `start_age_female`, `start_age_male`, `support_monthly`, `monthly_coefficient`, `guarantee_options`, `support_increase`, `increase_rate_options`, `increase_end_year`, `created_by`) VALUES
(4, '[55, 60, 65]', '[60, 65, 70]', 1, 0.085, '["保证领取20年", "保证领取25年", "保证领取至80岁"]', 1, '[3.0, 3.5, 4.0]', 20, 1);

-- ============================================================
-- 10. 初始化示例责任二级项 (responsibility_item)
-- ============================================================
INSERT INTO `responsibility_item` (`category_id`, `item_code`, `item_name`, `options`, `sort_order`, `is_system`, `is_active`, `created_by`) VALUES
(1, 'CRITICAL_ILLNESS', '重大疾病保险金', '{"values": ["50万", "100万", "150万", "200万"], "unit": "元", "type": "select"}', 1, 1, 1, 1),
(1, 'MEDIUM_ILLNESS', '中症疾病保险金', '{"values": ["25万", "50万", "75万"], "unit": "元", "type": "select"}', 2, 1, 1, 1),
(1, 'LIGHT_ILLNESS', '轻症疾病保险金', '{"values": ["15万", "30万", "45万"], "unit": "元", "type": "select"}', 3, 1, 1, 1),
(2, 'DEATH_BENEFIT', '身故保险金', '{"values": ["已交保费", "基本保额", "已交保费与现金价值较大者"], "unit": "", "type": "select"}', 1, 1, 1, 1),
(2, 'TOTAL_DISABILITY', '全残保险金', '{"values": ["已交保费", "基本保额", "已交保费与现金价值较大者"], "unit": "", "type": "select"}', 2, 1, 1, 1),
(3, 'POLICYHOLDER_WAIVER', '投保人豁免', '{"values": ["轻症", "中症", "重疾", "身故", "全残"], "unit": "", "type": "multi_select"}', 1, 1, 1, 1),
(3, 'INSURED_WAIVER', '被保险人豁免', '{"values": ["轻症", "中症", "重疾"], "unit": "", "type": "multi_select"}', 2, 1, 1, 1),
(4, 'CRITICAL_MULTI', '重疾多次赔付', '{"values": ["2次", "3次", "4次", "5次", "6次"], "unit": "次", "type": "select"}', 1, 1, 1, 1),
(4, 'CANCER_MULTI', '癌症多次赔付', '{"values": ["1次", "2次", "3次"], "unit": "次", "type": "select"}', 2, 1, 1, 1),
(4, 'CVD_MULTI', '心脑血管多次赔付', '{"values": ["1次", "2次", "3次"], "unit": "次", "type": "select"}', 3, 1, 1, 1),
(5, 'DISEASE_CARE', '疾病关爱金', '{"values": ["60岁前", "70岁前", "保单前15年"], "unit": "", "type": "select"}', 1, 1, 1, 1),
(5, 'CHILDREN_SPECIFIC', '少儿特定疾病', '{"values": ["10种", "15种", "20种", "25种"], "unit": "种", "type": "select"}', 2, 1, 1, 1),
(6, 'HOSPITAL_ALLOWANCE', '住院津贴', '{"values": ["100元/天", "200元/天", "300元/天"], "unit": "元/天", "type": "select"}', 1, 1, 1, 1),
(6, 'ICU_ALLOWANCE', 'ICU津贴', '{"values": ["500元/天", "1000元/天", "1500元/天"], "unit": "元/天", "type": "select"}', 2, 1, 1, 1),
(7, 'GREEN_CHANNEL', '就医绿通', '{"values": ["专家门诊", "住院安排", "手术安排", "海外就医"], "unit": "", "type": "multi_select"}', 1, 1, 1, 1),
(7, 'SECOND_OPINION', '二次诊疗', '{"values": ["国内", "海外"], "unit": "", "type": "multi_select"}', 2, 1, 1, 1);

-- ============================================================
-- 11. 初始化示例产品-责任关联 (product_responsibility)
-- ============================================================
INSERT INTO `product_responsibility` (`product_id`, `item_id`, `is_supported`, `supported_options`, `default_option`, `premium_coefficient`, `sort_order`, `created_by`) VALUES
(1, 1, 1, '["50万", "100万", "150万", "200万"]', '100万', '{"50万": 1.0, "100万": 1.8, "150万": 2.5, "200万": 3.2}', 1, 1),
(1, 2, 1, '["25万", "50万", "75万"]', '50万', '{"25万": 1.0, "50万": 1.5, "75万": 2.0}', 2, 1),
(1, 3, 1, '["15万", "30万", "45万"]', '30万', '{"15万": 1.0, "30万": 1.4, "45万": 1.8}', 3, 1),
(1, 4, 1, '["已交保费", "基本保额", "已交保费与现金价值较大者"]', '基本保额', '{"已交保费": 1.0, "基本保额": 1.1, "已交保费与现金价值较大者": 1.2}', 4, 1),
(1, 7, 1, '["轻症", "中症", "重疾"]', '轻症,中症,重疾', '{"轻症": 1.05, "中症": 1.08, "重疾": 1.15}', 5, 1),
(1, 8, 1, '["2次", "3次", "4次", "5次", "6次"]', '3次', '{"2次": 1.1, "3次": 1.2, "4次": 1.3, "5次": 1.4, "6次": 1.5}', 6, 1),
(1, 10, 1, '["1次", "2次", "3次"]', '2次', '{"1次": 1.15, "2次": 1.25, "3次": 1.35}', 7, 1),
(1, 11, 1, '["60岁前", "70岁前", "保单前15年"]', '60岁前', '{"60岁前": 1.2, "70岁前": 1.3, "保单前15年": 1.15}', 8, 1);

-- ============================================================
-- 12. 初始化示例产品编码映射 (product_encoding_map)
-- ============================================================
INSERT INTO `product_encoding_map` (`product_id`, `resp_category`, `resp_code`, `resp_name`, `bit_position`, `bit_mask`, `options`, `created_by`) VALUES
(1, 'BASE', 'CRITICAL_ILLNESS', '重大疾病保险金', 0, 1, '{"values": ["50万", "100万", "150万", "200万"], "default": "100万"}', 1),
(1, 'BASE', 'MEDIUM_ILLNESS', '中症疾病保险金', 1, 2, '{"values": ["25万", "50万", "75万"], "default": "50万"}', 1),
(1, 'BASE', 'LIGHT_ILLNESS', '轻症疾病保险金', 2, 4, '{"values": ["15万", "30万", "45万"], "default": "30万"}', 1),
(1, 'DEATH', 'DEATH_BENEFIT', '身故保险金', 3, 8, '{"values": ["已交保费", "基本保额", "已交保费与现金价值较大者"], "default": "基本保额"}', 1),
(1, 'WAIVER', 'INSURED_WAIVER', '被保险人豁免', 4, 16, '{"values": ["轻症", "中症", "重疾"], "default": "轻症,中症,重疾"}', 1),
(1, 'MULTI_PAY', 'CRITICAL_MULTI', '重疾多次赔付', 5, 32, '{"values": ["2次", "3次", "4次", "5次", "6次"], "default": "3次"}', 1),
(1, 'MULTI_PAY', 'CANCER_MULTI', '癌症多次赔付', 6, 64, '{"values": ["1次", "2次", "3次"], "default": "2次"}', 1),
(1, 'BONUS', 'DISEASE_CARE', '疾病关爱金', 7, 128, '{"values": ["60岁前", "70岁前", "保单前15年"], "default": "60岁前"}', 1);

-- ============================================================
-- 13. 初始化示例重疾险费率 (premium_rate)
-- ============================================================
INSERT INTO `premium_rate` (`product_id`, `combo_code`, `gender`, `age`, `payment_year`, `premium_per_k`, `health_status`, `created_by`) VALUES
(1, 0, 1, 30, 20, 28.50, 1, 1),
(1, 0, 2, 30, 20, 26.80, 1, 1),
(1, 0, 1, 30, 30, 19.20, 1, 1),
(1, 0, 2, 30, 30, 18.50, 1, 1),
(1, 1, 1, 30, 20, 32.10, 1, 1),
(1, 1, 2, 30, 20, 30.50, 1, 1),
(1, 0, 1, 40, 20, 45.60, 1, 1),
(1, 0, 2, 40, 20, 42.30, 1, 1),
(2, 0, 1, 30, 20, 30.20, 1, 1),
(2, 0, 2, 30, 20, 28.50, 1, 1),
(2, 0, 1, 35, 20, 35.80, 1, 1),
(2, 0, 2, 35, 20, 33.60, 1, 1);

-- ============================================================
-- 14. 初始化示例增额终身寿险费率 (whole_life_rate)
-- ============================================================
INSERT INTO `whole_life_rate` (`product_id`, `gender`, `age`, `payment_year`, `policy_year`, `cash_value`, `death_benefit`, `created_by`) VALUES
(3, 1, 30, 5, 1, 8500.00, 100000.00, 1),
(3, 1, 30, 5, 5, 48000.00, 100000.00, 1),
(3, 1, 30, 5, 10, 62000.00, 118000.00, 1),
(3, 1, 30, 5, 20, 88000.00, 166000.00, 1),
(3, 1, 30, 5, 30, 124000.00, 234000.00, 1),
(3, 2, 30, 5, 1, 8600.00, 100000.00, 1),
(3, 2, 30, 5, 10, 63500.00, 120000.00, 1),
(3, 2, 30, 5, 20, 91000.00, 172000.00, 1);

-- ============================================================
-- 15. 初始化示例年金险费率 (annuity_rate)
-- ============================================================
INSERT INTO `annuity_rate` (`product_id`, `gender`, `age`, `payment_year`, `policy_year`, `annual_payout`, `cash_value`, `death_benefit`, `created_by`) VALUES
(4, 2, 30, 10, 1, NULL, 8500.00, 100000.00, 1),
(4, 2, 30, 10, 10, NULL, 95000.00, 100000.00, 1),
(4, 2, 30, 10, 25, 8500.00, 145000.00, 100000.00, 1),
(4, 2, 30, 10, 30, 9200.00, 168000.00, 100000.00, 1),
(4, 2, 30, 10, 40, 11200.00, 205000.00, 100000.00, 1),
(4, 1, 30, 10, 25, 7800.00, 138000.00, 100000.00, 1),
(4, 1, 30, 10, 30, 8500.00, 158000.00, 100000.00, 1);

-- ============================================================
-- 16. 初始化示例祝寿金配置 (annuity_birthday_bonus)
-- ============================================================
INSERT INTO `annuity_birthday_bonus` (`product_id`, `bonus_age`, `bonus_type`, `bonus_value`, `bonus_desc`, `sort_order`, `created_by`) VALUES
(4, 80, 2, 10.00, '80岁祝寿金：给付10倍基本保额', 1, 1),
(4, 90, 2, 20.00, '90岁祝寿金：给付20倍基本保额', 2, 1);

-- ============================================================
-- 17. 初始化示例用户信息 (user_info)
-- ============================================================
INSERT INTO `user_info` (`username`, `password`, `nickname`, `phone`, `email`, `gender`, `birthday`, `member_level`, `status`, `created_by`) VALUES
('demo_user', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '演示用户', '13800138001', 'demo@example.com', 1, '1990-05-20', 0, 1, 1),
('vip_user', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', 'VIP用户', '13800138002', 'vip@example.com', 2, '1985-08-15', 1, 1, 1);

-- ============================================================
-- 18. 初始化示例VIP记录 (user_vip_record)
-- ============================================================
INSERT INTO `user_vip_record` (`user_id`, `member_level`, `purchase_amount`, `expire_time`, `purchase_time`, `order_no`, `pay_type`, `status`, `created_by`) VALUES
(2, 1, 299.00, '2025-12-31 23:59:59', '2024-01-01 10:00:00', 'VIP202401010001', 1, 1, 1);

-- ============================================================
-- 19. 初始化示例管理员 (admin_user) - 已在第3节统一初始化
-- ============================================================

-- ============================================================
-- 20. 初始化示例权限 (admin_permission)
-- ============================================================
INSERT INTO `admin_permission` (`permission_code`, `permission_name`, `parent_id`, `permission_type`, `path`, `sort_order`, `status`, `created_by`) VALUES
('dashboard', '数据看板', 0, 1, '/dashboard', 1, 1, 1),
('product_manage', '产品管理', 0, 1, '/product', 2, 1, 1),
('product_list', '产品列表', 2, 1, '/product/list', 1, 1, 1),
('product_create', '新增产品', 2, 2, '/product/create', 2, 1, 1),
('product_edit', '编辑产品', 2, 2, '/product/edit', 3, 1, 1),
('product_delete', '删除产品', 2, 2, '/product/delete', 4, 1, 1),
('company_manage', '保险公司', 0, 1, '/company', 3, 1, 1),
('company_list', '公司列表', 7, 1, '/company/list', 1, 1, 1),
('rate_manage', '费率管理', 0, 1, '/rate', 4, 1, 1),
('rate_import', '费率导入', 9, 2, '/rate/import', 1, 1, 1),
('template_manage', '模板管理', 0, 1, '/template', 5, 1, 1),
('template_list', '模板列表', 11, 1, '/template/list', 1, 1, 1),
('user_manage', '用户管理', 0, 1, '/user', 6, 1, 1),
('user_list', '用户列表', 13, 1, '/user/list', 1, 1, 1),
('system_manage', '系统管理', 0, 1, '/system', 7, 1, 1),
('admin_list', '管理员列表', 15, 1, '/system/admin', 1, 1, 1),
('role_list', '角色列表', 15, 1, '/system/role', 2, 1, 1),
('permission_list', '权限列表', 15, 1, '/system/permission', 3, 1, 1);

-- ============================================================
-- 21. 初始化超级管理员角色权限关联 (admin_role_permission)
-- ============================================================
INSERT INTO `admin_role_permission` (`role_id`, `permission_id`, `created_by`) VALUES
(1, 1, 1), (1, 2, 1), (1, 3, 1), (1, 4, 1), (1, 5, 1), (1, 6, 1),
(1, 7, 1), (1, 8, 1), (1, 9, 1), (1, 10, 1), (1, 11, 1), (1, 12, 1),
(1, 13, 1), (1, 14, 1), (1, 15, 1), (1, 16, 1), (1, 17, 1), (1, 18, 1);

-- ============================================================
-- 22. 初始化产品管理员角色权限关联
-- ============================================================
INSERT INTO `admin_role_permission` (`role_id`, `permission_id`, `created_by`) VALUES
(2, 2, 1), (2, 3, 1), (2, 4, 1), (2, 5, 1), (2, 6, 1),
(2, 7, 1), (2, 8, 1), (2, 9, 1), (2, 10, 1), (2, 11, 1), (2, 12, 1);

-- ============================================================
-- 23. 初始化数据管理员角色权限关联
-- ============================================================
INSERT INTO `admin_role_permission` (`role_id`, `permission_id`, `created_by`) VALUES
(3, 9, 1), (3, 10, 1), (3, 2, 1), (3, 3, 1), (3, 7, 1), (3, 8, 1);

-- ============================================================
-- 24. 初始化运营管理员角色权限关联
-- ============================================================
INSERT INTO `admin_role_permission` (`role_id`, `permission_id`, `created_by`) VALUES
(4, 11, 1), (4, 12, 1), (4, 13, 1), (4, 14, 1), (4, 1, 1);

-- ============================================================
-- 数据初始化完成
-- ============================================================
