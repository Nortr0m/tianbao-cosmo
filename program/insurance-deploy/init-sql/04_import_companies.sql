-- ============================================================
-- 保险公司数据导入
-- 生成时间: 2026-06-18 08:03:00
-- 公司总数: 202
-- ============================================================

USE `tianbao_insurance`;

-- 清空现有公司数据（保留表结构）
DELETE FROM `insurance_company`;

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '大家人寿保险股份有限公司', '大家人寿', 'IC000-ABRS', '/logos/大家人寿保险股份有限公司.png',
    'https://life.djbx.com/', '95569', 2010, 3079000.00,
    '北京市', 1, 'B（2017年）', NULL,
    '大家人寿保险股份有限公司（以下简称“大家人寿”或“公司”） 成立于2010年6月，总部设在北京。公司主要经营人寿保险、健康保险、意外伤害保险等各类人身保险业务、上述业务的再保险业务以及经保险监督管理机构批准的其他业务。大家人寿是大家保险集团旗下专业寿险子公司，通过集团综合化经营平台，为个人及团体提供涵盖生存、养老、疾病、医疗、身故、残疾等保障范围的多种产品，全面满足客户在人身保险领域的保险保障需求。', '["国有背景", "品牌重塑"]', 1, 1, 0,
    '股权结构: \'国有控股\', 实际控制人: \'财政部\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '爱心人寿保险股份有限公司', '爱心人寿', 'IC001-AXRS', '/logos/爱心人寿保险股份有限公司.png',
    'http://www.aixin-ins.com/', '10109520', 2017, 232000.00,
    '北京市', 2, 'BB（2025年3季度）', 152.01,
    '爱心人寿保险股份有限公司成立于2017年6月19日，是经原中国保监会批准成立的全国性、综合性人寿保险公司，总部位于北京。\n爱心人寿拥有优良的治理结构，出色的管理团队，充分尊重行业规律，坚持创新发展战略和科学发展路径，致力于守护客户及其家庭的终生幸福。\n爱心人寿以保险为公司发展的核心主业，已形成京津冀、长三角、大湾区为战略支点的机构布局，助力国家多层次社会保障体系建设。同时下设爱心家园养老有限公司、爱心保险经纪有限公司，同时自建社区型优质医疗机构北京佳景爱小心门诊部，并经政府审批发起设立北京爱心守护慈善基金会。\n公司以客户为中心，以场景化需求为导向，为客户及其家庭提供涉及“保险保障、医养健康、财富管理、安全防范和慈善帮助”五大关爱，实现家庭更安全、更健康和更幸福，致力于成为一家让监管放心、股东信任、员工归属，有鲜明特征、有价值的、受社会尊敬的保险企业。\n公司已构建了以互联网大数据、人工智能区块链及云平台技术为底层支持体系的“保险+医疗+养老”的重要生态布局；以“专业化、轻资产、科技型”经营理念为指引，构筑公司核心竞争能力；以“专注服务于家庭”为核心定位，实现“让每一个家庭因为爱心而更加安全、健康和美好”；以爱心慈善公益为社会责任，特别是聚焦“一老一小”，为更多有需要的群体提供慈善援助。\n北京新里程健康产业集团有限公司作为爱心人寿唯一战略类第一大股东，将携手爱心人寿共同推动“医疗+保险”、“康养+保险”的深度协同和业务驱动，打造“医康养保”连续服务产业链。', '["民营"]', 1, 2, 0,
    '股权结构: \'民营控股\', 实际控制人: \'北京新里程健康产业集团\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '百年人寿保险股份有限公司', '百年人寿', 'IC002-BNRS', '/logos/百年人寿保险股份有限公司.png',
    'http://www.aeonlife.com.cn/', '95542', 2009, 790480.00,
    '辽宁省大连市', 2, 'C（2022年4季度）', 102.59,
    '百年人寿总部位于大连，是东北地区首家中资寿险法人机构。近年来，百年人寿深入推进“以客户为中心”的发展战略，坚持求真务实、诚信担当、利他共赢、创新进取，打造了涵盖个险、银保、团险、经代等多个渠道的业务构架，培养了一支成熟的经营管理团队，已建立起较为完备的产品和服务体系，覆盖传统险、疾病险、医疗险、意外险等多个领域，通过市场细分、客户画像、高客中心建设、产品迭代升级、细胞库服务、华为战略合作等多个项目，为客户提供覆盖全生命周期的保险服务保障。公司坚守合规、稳健的经营理念，不断强化投资能力建设，行业地位和品牌知名度不断提升。', '["民营"]', 1, 3, 0,
    '股权结构: \'民营控股\', 实际控制人: \'大连万达集团\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '北京人寿保险股份有限公司', '北京人寿', 'IC003-BJRS', '/logos/北京人寿保险股份有限公司.png',
    'https://www.beijinglife.com.cn/', '400-81-96677', 2018, 286000.00,
    '北京市', 1, 'BB（2025年3季度）', 159.50,
    '北京人寿保险股份有限公司（简称“北京人寿”）是经（原）中国保险监督管理委员会批准，由国有企业、集体企业和社会企业共同发起组建的全国性人寿保险公司。北京人寿本着走稳、走好、走远的发展理念，立足首都，面向全国，放眼世界，充分发挥北京的政策优势、服务优势、科技创新优势，以服务新型城镇化的社会保障体系建设为基础，按照“价值成长 创新发展”的战略和“北京人寿 身边亲人”的服务宗旨，坚持科技领先、专业支撑、资源整合、品牌服务，实现商业性业务与政策性业务均衡发展，企业价值与社会价值持续提升，建成一家科技引领、创新驱动的新型保险公司，努力打造优质、强大、持久的保险品牌。公司业务范围：普通型保险（包括人寿保险和年金保险）、健康保险、意外伤害保险、分红型保险、万能型保险；上述业务的再保险业务；国家法律、法规允许的保险资金运用业务；（原）中国保险监督管理委员会批准的其他业务。', '[]', 1, 4, 0,
    '股权结构: \'地方国有控股\', 实际控制人: \'北京市国资委\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '渤海人寿保险股份有限公司', '渤海人寿', 'IC004-BHRS', '/logos/渤海人寿保险股份有限公司.png',
    'http://www.bohailife.net/', '4008-667-668', 2014, 1300000.00,
    '天津市', 2, 'C（2023年3季度）', 102.35,
    '渤海人寿是首家总部落户天津自贸区的专业寿险公司。渤海人寿主要股东由渤海租赁股份有限公司、天津天保控股有限公司等现代企业构成，主要经营:普通型保险，包括人寿保险和年金保险；健康保险；意外伤害保险；分红型保险；万能型保险等人身险业务。', '["民营"]', 1, 5, 0,
    '股权结构: \'混合所有制\', 实际控制人: \'渤海租赁\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '复星保德信人寿保险有限公司', '复星保德信人寿', 'IC005-FXBDXRS', '/logos/复星保德信人寿保险有限公司.png',
    'https://www.pflife.com.cn/', '400-821-6808', 2012, 336210.00,
    '中国（上海）自由贸易试验区张杨路2389弄1-2号置汇旭辉广场A座17-18层01、02、03、05、06、07室市', 4, 'BB（2025年3季度）', 152.56,
    '复星保德信人寿保险有限公司是由复星与美国保德信金融集团联合发起组建的合资寿险公司，经原中国保险监督管理委员会批准，于2012年9月正式成立，总部位于上海。公司注册资本金为33.621亿元，股东双方各持有合资公司50%的股份。', '["中外合资"]', 1, 6, 0,
    '股权结构: \'中外合资（各50%）\', 实际控制人: \'复星国际/保德信金融集团\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '复星联合健康保险股份有限公司', '复星联合健康', 'IC006-FXLHJK', '/logos/复星联合健康保险股份有限公司.png',
    'http://www.fosun-uhi.com/', '4006-11-7777', 2017, 101080.00,
    '广东省广州市', 2, 'BB（2025年3季度）', 153.94,
    '复星联合健康保险股份有限公司（简称“复星联合健康保险”）成立于2017年1月，主要股东是上海复星产业投资有限公司、上海复星医药（集团）股份有限公司、国际金融公司（IFC）、亚洲开发银行（ADB）、广东宜华房地产开发有限公司、广州南沙科金控股集团有限公司、宁波西子资产管理有限公司、重庆东银控股集团有限公司、上海丰实资产管理有限公司和迪安诊断技术集团股份有限公司。公司注册地广东省广州市，以健康发展、特色经营、创新驱动、体验至上为宗旨，专业提供健康保障及健康管理服务。复星联合健康保险立足广大消费者需求，开展各类医疗保险、疾病保险、失能收入损失保险、护理保险、意外保险业务，全力为客户提供优质的全生命周期产品，建立贴心的全流程服务体系。', '["民营"]', 1, 7, 0,
    '股权结构: \'民营控股\', 实际控制人: \'复星集团\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '富德生命人寿保险股份有限公司', '富德生命人寿', 'IC007-FDSMRS', '/logos/富德生命人寿保险股份有限公司.png',
    'http://www.sino-life.com/', '95535/ 4008-200-035', 2002, 1175200.00,
    '深圳市', 2, 'B（2018年）', 103.00,
    '富德生命人寿保险股份有限公司是一家全国性的专业寿险公司，总部现位于深圳。股东由深圳市富德金融投资控股有限公司、深圳市国民投资发展有限公司等资金雄厚的企业构成。总资产近4500亿元，是国内资本实力较强的寿险公司之一。', '["民营", "品牌重塑"]', 1, 8, 0,
    '股权结构: \'民营控股\', 实际控制人: \'张峻\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '工银安盛人寿保险有限公司', '工银安盛人寿', 'IC008-GYASRS', '/logos/工银安盛人寿保险有限公司.png',
    'https://www.icbc-axa.com/', '95359', 2012, 1250500.00,
    '中国（上海）自由贸易试验区银城路16号30层3001单元、31层、32层、33层、34层、36层市', 4, 'BBB（2025年3季度）', 187.00,
    '工银安盛人寿保险有限公司由中国工商银行、法国安盛集团和中国五矿集团三家实力雄厚的中外股东合资组建。公司专营人寿保险、健康保险和意外伤害保险等保险业务，服务客户超过110万人。工银安盛人寿在经营发展中以习近平新时代中国特色社会主义思想为指引，深入学习贯彻党的二十大和中央金融工作会议精神，牢牢把握金融工作的政治性和人民性，坚持保险姓保、回归本源专业性，通过实施“党建引领、集团融入、资负统筹、数字转型、风控固基、人才强司、文化凝聚”七大工程，坚定走好中国特色保险发展之路，努力把工银安盛锻造成为银行系和合资保险公司中客户数量最多、业务规模最大、经营结构最优、资产质量最好、盈利能力最强、服务口碑最佳和品牌价值最高的人身保险公司，为工银集团综合化经营、上海国际金融中心和金融强国建设贡献更大力量。', '["中外合资", "品牌重塑"]', 1, 9, 0,
    '股权结构: \'银行系合资\', 实际控制人: \'中国工商银行\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '光大永明人寿保险有限公司', '光大永明人寿', 'IC009-GDYMRS', '/logos/光大永明人寿保险有限公司.png',
    'http://www.sunlife-everbright.com/', '95348', 2002, 540000.00,
    '天津市', 4, 'AA（2025年3季度）', 121.98,
    '光大永明人寿保险有限公司由中国光大集团和加拿大永明金融集团联合组建，为了实现更快的发展，业务范围覆盖了全国80%的人口区域;秉持“以客为尊”的经营理念,通过多种销售渠道,以优质的产品和服务,满足客户养老、意外、医疗、教育、资产管理等多方面的保险保障和财富管理需求。', '["中外合资"]', 1, 10, 0,
    '股权结构: \'中外合资\', 实际控制人: \'中国光大集团\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '国宝人寿保险股份有限公司', '国宝人寿', 'IC010-GBRS', '/logos/国宝人寿保险股份有限公司.png',
    'https://www.panda-assets.com/', '028-96555', 2018, 198000.00,
    '四川省成都市', 1, 'BB（2025年3季度）', 156.23,
    '国宝人寿保险股份有限公司是由四川省政府主导组建，首家总部落户在成都市的全国性股份制人寿保险公司。\n作为四川省管金融企业，国宝人寿切实把自身发展融入增进民生福祉和服务国家战略大局。深入践行人民保险的政治性、人民性，重点围绕乡村振兴、新市民、中低收入人群、易受灾人群等特殊保险需求，在基本保障、健康管理、养老保障等重点领域积极探索，加大产品创新开发推广力度。', '[]', 1, 11, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '国华人寿保险股份有限公司', '国华人寿', 'IC011-GHRS', '/logos/国华人寿保险股份有限公司.png',
    'http://www.95549.cn/', '95549', 2007, 484625.00,
    '上海市', 2, 'BBB（2018年）', 122.80,
    '国华人寿保险股份有限公司是由原中国保险监督管理委员会批准设立的全国性、股份制专业寿险公司。\n自成立以来，国华人寿科学把握寿险经营规律，合规经营、稳健发展，探索符合自身特色的健康发展之路。公司以银行保险、互联网为业务主渠道，并大力发展个人保险业务。', '["民营"]', 1, 12, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '国富人寿保险股份有限公司', '国富人寿', 'IC012-GFRS', '/logos/国富人寿保险股份有限公司.png',
    'http://www.e-guofu.com/', '0771-5723168/4006946688', 2018, 192600.00,
    '广西壮族自治区南宁市', 1, 'B（2025年3季度）', 139.76,
    '国富人寿保险股份有限公司由广西投资集团有限公司、广州唯品会信息科技有限公司、吉安新年广告传媒有限公司、北京信中利投资股份有限公司、湖北三峡华翔集团有限公司、广西日报传媒集团有限公司、上海恒大建材市场管理股份有限公司、广西名都生态科技发展有限公司等8家公司共同发起创立。公司注册地在我国面向东盟开放合作的前沿城市——南宁。', '[]', 1, 13, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '恒安标准人寿保险有限公司', '恒安标准人寿', 'IC013-HABZRS', '/logos/恒安标准人寿保险有限公司.png',
    'http://www.hengansl.com/index.html', '956069', 2003, 404600.00,
    '天津市', 4, 'AAA（2025年3季度）', 182.58,
    '恒安标准作为一家合资寿险公司，一直秉承以客户为中心立足市场，建立涵盖客户全生命周期的保险产品体系，满足客户在风险保障和养老等多方面的需求，是公司致力追求的服务宗旨。公司在天津市行政辖区及已设立分公司的省、自治区、直辖市内经营下列业务（法定保险业务除外）：（一）人寿保险、健康保险和意外伤害保险等保险业务；（二）上款业务的再保险业务；代理销售机动车辆保险、企业财产保险、家庭财产保险、货物运输保险、船舶保险、工程保险、特殊风险保险、农业保险、责任保险、信用保险、保证保险、健康保险、意外伤害保险。（依法须经批准的项目，经相关部门批准后方可开展经营活动）', '["中外合资"]', 1, 14, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '海港人寿保险股份有限公司', '海港人寿', 'IC014-HDRS', '/logos/海港人寿保险股份有限公司.png',
    'https://www.harbourlife.com.cn/', '956010', 2023, 1500000.00,
    '深圳市', 1, 'A（2018年）', NULL,
    '海港人寿保险股份有限公司（以下简称“海港人寿”）是经国家金融监督管理总局批准成立的一家全国性的国有保险公司，公司由深圳市鹏联投资有限公司、中国保险保障基金有限责任公司、太平人寿保险有限公司、广东粤财投资控股有限公司、重庆市渝新投资有限公司联合发起成立，公司的经营范围为：人寿保险、健康保险和意外伤害保险等保险业务；上述业务的再保险业务；国家法律、法规允许的保险资金运用业务；经国务院保险监督管理机构批准的其他业务。', '["国有背景", "品牌重塑"]', 1, 15, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '横琴人寿保险有限公司', '横琴人寿', 'IC015-HQRS', '/logos/横琴人寿保险有限公司.png',
    'https://www.hqins.cn/', '400-6912345', 2016, 313700.00,
    '广东省珠海市', 2, 'B（2025年3季度）', 125.69,
    '横琴人寿保险有限公司是珠海第一家全国性法人保险公司。横琴人寿坚持“保险姓保”的价值导向，遵循行业发展规律，秉承“简约、开放、专注”的经营理念，搭建智慧共享的平台，为客户提供简约贴心的产品，营造亲和温暖的客户体验。实施“科技驱动+家庭保险账户”的双特色发展模式,业务涵盖寿险,意外险,年金险,健康险等。', '["民营"]', 1, 16, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '弘康人寿保险股份有限公司', '弘康人寿', 'IC016-HKRS', '/logos/弘康人寿保险股份有限公司.png',
    'https://www.hongkang-life.com/hongkang/index.html', '956097', 2012, 100000.00,
    '北京市', 2, '无披露', 127.75,
    '弘康人寿保险股份有限公司（下称“弘康人寿”）是经原中国保险监督管理委员会批准设立的全国性寿险公司，弘康人寿总部位于北京，弘康人寿致力于开发符合客户需求的高性价比产品，保障类产品涵盖寿险、重疾险、意外险等险种，客户人均保额超过行业平均水平；财富类产品以稳健为特色，覆盖投连、分红、终身寿等险种。', '["民营"]', 1, 17, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '瑞众人寿保险有限责任公司', '瑞众人寿', 'IC017-HXRS', '/logos/瑞众人寿保险有限责任公司.png',
    'http://www.ruiinsurance.com/', '95300', 2023, 5650000.00,
    '北京市', 1, 'BBB（2018年）', NULL,
    '瑞众人寿保险有限责任公司总部设在北京，经营范围包括人寿保险、健康保险和意外伤害保险等各类人身保险业务；上述业务的再保险业务；国家法律、法规允许的保险资金运用业务；经国务院保险监督管理机构批准的其他业务。', '["国有背景", "品牌重塑"]', 1, 18, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '华贵人寿保险股份有限公司', '华贵人寿', 'IC018-HGRS', '/logos/华贵人寿保险股份有限公司.png',
    'https://www.huaguilife.cn/', '400-684-1888', 2017, 200000.00,
    '贵州省贵阳市', 1, 'B（2025年3季度）', 135.03,
    '华贵人寿保险股份有限公司是经原中国保险监督管理委员会批准，总部注册地位于国家级新区贵州省贵安新区。华贵保险经营范围包括：普通型保险（包括人寿保险和年金保险）、健康保险、意外伤害保险、分红型保险；上述业务的再保险业务；国家法律、法规允许的保险资金运用业务；保险监督管理机构批准的其他业务。\n作为贵州省第一家本土保险法人机构，华贵保险以“致力成为‘专而优’的产品和服务领先的保险公司”为发展愿景；秉承“诚信、顺势、务实、创造、分享”的价值观，围绕“一个中心、二个基础、六大能力”发展思路，立足贵州、服务全国，以民生保障类产品创新为突破口，切实保护消费者利益，为客户提供全方位的人身保险保障，努力建设成为客户满意、员工幸福、社会价值与商业价值兼备的新型寿险公司。', '[]', 1, 19, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '陆家嘴国泰人寿保险有限责任公司', '陆家嘴国泰人寿', 'IC019-LJZGTRS', '/logos/陆家嘴国泰人寿保险有限责任公司.png',
    'http://www.cathaylife.cn/', '4008869899', 2004, 300000.00,
    '中国（上海）自由贸易试验区海阳西路555号/东育路588号前滩中心38层市', 4, 'AA（2025年3季度）', 136.02,
    '陆家嘴国泰人寿保险有限责任公司是海峡两岸第一家合资寿险公司，总部设在上海。\n到目前为止，陆家嘴国泰人寿已开发和销售包括寿险、健康险、意外险、年金险在内的百余种商品，其长期看护类产品填补了业内在此方向的空白，荣获多种奖项。同时，不断扩展的营销渠道及服务平台也为保户快速了解产品及享受服务提供了便利。', '["中外合资", "品牌重塑"]', 1, 20, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '富泽人寿保险股份有限公司', '富泽人寿', 'IC020-JKRS', '/logos/富泽人寿保险股份有限公司.png',
    'https://www.fzlife.com/', '956016', 2025, 1700000.00,
    '山东省济南市', 1, 'C（2020年2季度）', 102.47,
    '富泽人寿保险股份有限公司是一家全国性的国有股份制人寿保险公司，注册地为山东省济南市。公司的经营范围为：人寿保险、健康保险和意外伤害保险等保险业务；上述业务的再保险业务；国家法律、法规允许的保险资金运用业务；经国务院保险监督管理机构批准的其他业务。\n富泽人寿积极服务国家重大战略，切实履行社会责任，充分发挥经济减震器和社会稳定器作用。公司在北京、上海、江苏、浙江、黑龙江等地区设立了多家分公司，稳步推进在注册地山东及其他多区域的机构筹建，全面提升市场竞争优势和发展潜力。\n富泽人寿实施多元化渠道发展策略，夯实发展负债端基础，形成涵盖线上+线下+外部合作的多元化渠道组合和全方位客户服务网络。公司紧密围绕经济社会发展和人民群众保险需求变化，持续优化产品结构，丰富产品供给，逐步构建覆盖养老、健康、财富管理及风险保障等多层次、多样化的产品体系。', '["国有背景", "品牌重塑"]', 1, 21, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '昆仑健康保险股份有限公司', '昆仑健康', 'IC021-KLJK', '/logos/昆仑健康保险股份有限公司.png',
    'https://www.kunlunhealth.com.cn/', '400-811-8899', 2006, 234182.00,
    '北京市', 2, 'B（2021年3季度）', 123.96,
    '昆仑健康保险股份有限公司（以下简称“昆仑健康保险”、“公司”）是经原中国保险监督管理委员会正式批准，作为国内首批专业健康保险公司之一，历经十余年发展，现已成长为一家中型健康险公司。\n\n公司坚持“以人为本、以客户的健康为中心”的经营理念，积极布局“金融科技+健康管理+医疗服务”生态圈战略。一方面，秉承“治未病”理念，让重大疾病风险因素管理创新服务模式落地，为客户提供全周期健康管理服务；另一方面，以互联网为着力点，实施金融科技战略，全力打造健康服务平台和管理平台，多维一体地为客户提供全方位大健康服务。', '["民营"]', 1, 22, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中国人民健康保险股份有限公司', '人保健康', 'IC022-RBJK', '/logos/中国人民健康保险股份有限公司.png',
    'http://www.picchealth.com/', '95518', 2005, 856800.00,
    '北京市', 1, 'A（2025年3季度）', 262.43,
    '中国人民健康保险股份有限公司（简称‘中国人保健康’）是经国务院同意、中国银保监会（原中国保监会）批准设立的国内第一家专业健康保险公司。\n公司战略：服务健康中国，践行集团卓越战略，深度融入国家医疗保障体系建设，为广大人民群众提供高质量的健康保障和健康管理服务。公司使命：人民保险 服务人民。经营理念：服务大局、创新变革、科技引领、客户至上、价值为先、专业为本。经营模式：构建“保险+健康服务+科技”的商业模式，为客户提供商质优高效便捷的服务。经营策略：实施创新驱动，推进数字化转型，完善公司治理，强化激励约束，深化体制机制变革，不断增强发展动力和经营活力。业务格局：聚焦主责主业和专业经营，构建“6+1”业务发展新格局，丰富产品服务供给，加快业务模式创新，推进管理机制变革，实现高质量发展。', '[]', 1, 23, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中国人民人寿保险股份有限公司', '人民人寿', 'IC023-RMRS', '/logos/中国人民人寿保险股份有限公司.png',
    'http://www.picclife.com/', '4008895518', 2005, 2576100.00,
    '中国北京市', 1, 'A（2025年3季度）', 185.00,
    '中国人民人寿保险股份有限公司总部设在北京。中国人保寿险是中国人民保险集团旗下的重要成员，主要经营人寿保险、年金保险、健康保险、意外伤害保险等保险业务及上述业务的再保险业务。公司坚持以高质量发展为导向，不断提升服务国家大局的能力，聚焦服务乡村振兴、服务绿色发展、服务增进民生福祉、服务区域发展等重点领域，着力做好科技金融、绿色金融、普惠金融、养老金融、数字金融“五篇大文章”，积极为中国式现代化贡献保险力量。', '[]', 1, 24, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '瑞泰人寿保险有限公司', '瑞泰人寿', 'IC024-RTRS', '/logos/瑞泰人寿保险有限公司.png',
    'http://www.oldmutual-chnenergy.com', '4008109339', 2004, 187100.00,
    '北京市', 4, 'BB（2025年3季度）', 158.63,
    '瑞泰人寿保险有限公司是第一家总部设在北京的合资寿险公司。投资方为中国国电集团国电资本控股有限公司和南非耆卫集团耆卫人寿保险（南非）有限公司。瑞泰人寿依托中外方股东的雄厚实力，融合世界500强企业的国际化管理经验，以“打造精致的、特色的、持续盈利的瑞泰人寿”为企业愿景，坚持“高端、专业”的市场定位和品牌形象，不断推出为客户量身订做的保险一体化解决方案，着力打造全国性、一流的寿险公司。', '["中外合资"]', 1, 25, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '上海人寿保险股份有限公司', '上海人寿', 'IC025-SHRS', '/logos/上海人寿保险股份有限公司.png',
    'http://www.shanghailife.com.cn', '400-911-8118', 2015, 600000.00,
    '上海市', 2, 'C（2021年3季度）', 124.89,
    '上海人寿保险股份有限公司是注册在中国（上海）自由贸易试验区内的首家全国性人身保险公司。上海人寿将紧紧依托中国（上海）自贸区先行先试的政策环境，创新实践，努力探索走一条传统保险与资产管理相结合、人寿保险与健康保险相结合、保险服务与医疗服务相结合、保险功能与生命产业相结合、国际经验与国人需求相结合的人寿保险公司发展新路。上海人寿将以国际化的平台，个性化的产品，以人为本的服务理念，为广大客户提供全新的保险服务体验。', '["民营"]', 1, 26, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '泰康人寿保险有限责任公司', '泰康人寿', 'IC026-TKRS', '/logos/泰康人寿保险有限责任公司.png',
    'http://www.taikanglife.com/', '95522', 2016, 300000.00,
    '北京市', 1, 'A（2025年3季度）', 235.61,
    '泰康人寿保险有限责任公司（简称泰康人寿）是泰康保险集团股份有限公司（简称泰康保险集团）的子公司。\n泰康人寿坚定推进“长寿时代、泰康方案”。“支付+服务+投资”三端协同，形成新寿险。致力于打造最佳最优筹资模式，构建全生命周期的医养康宁服务体系。持续建设“长寿、健康、财富”三大客户解决方案和健康财富规划师（HWP）职业解决方案。\n泰康人寿深耕寿险，厚积薄发。通过覆盖全国的经营网络以及完善的个人保险、银行保险、电话销售、网络销售及经纪代理全渠道，为个人及家庭提供全方位的人身保障和财富管理产品与服务。', '["国有背景"]', 1, 27, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中汇人寿保险股份有限公司', '中汇人寿', 'IC027-TARS', '/logos/中汇人寿保险股份有限公司.png',
    'https://www.zhonghuilife.com/', '010-84053600', 2023, 3320000.00,
    '北京市', 1, 'BBB（2018年）', NULL,
    '中汇人寿坚持以高质量党建引领高质量发展，坚持“稳中求进、创新转型、价值提升、依法合规”16字经营方针，坚持深耕寿险主业，打造健康服务、养老服务、财富管理三大平台，服务国家发展大局和客户保险保障需求，推动公司发展战略稳步落地。\n中汇人寿将秉持国有金融企业的使命担当，踊跃开展各类公益活动，全面履行社会责任，主动融入社会民生保障和国家经济社会发展大局，为新时代中国特色社会主义现代化建设贡献力量。', '["国有背景", "品牌重塑"]', 1, 28, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '同方全球人寿保险有限公司', '同方全球人寿', 'IC028-TFQQRS', '/logos/同方全球人寿保险有限公司.png',
    'http://www.aegonthtf.com/', '956095', 2003, 263000.00,
    '深圳市', 4, 'AA（2025年3季度）', 161.00,
    '同方全球人寿保险有限公司由荷兰全球人寿保险集团（Aegon）与同方股份有限公司（THTF）各出资50%组建而成，公司于2003年正式获得营业执照，在中国开展寿险业务。', '["中外合资", "品牌重塑"]', 1, 29, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '信泰人寿保险股份有限公司', '信泰人寿', 'IC029-XTRS', '/logos/信泰人寿保险股份有限公司.png',
    'http://www.xintai.com/', '95365', 2007, 1020400.00,
    '浙江省杭州市', 1, 'B（2025年2季度）', 127.84,
    '信泰人寿保险股份有限公司创立于2007年5月18日，总部设在浙江杭州。信泰保险秉承“诚信为基、专业为本、进取为纲、共赢为要”的价值观，坚持“客户优先、价值导向、精益管理、稳健成长”的经营理念，稳步提升持续发展能力和盈利能力，致力于为广大客户提供更为便捷的保险保障服务。', '[]', 1, 30, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '阳光人寿保险股份有限公司', '阳光人寿', 'IC030-YGRS', '/logos/阳光人寿保险股份有限公司.png',
    'http://life.sinosig.com/', '95510', 2007, 2104520.00,
    '北京市', 2, 'AA（2025年3季度）', 165.26,
    '阳光人寿保险股份有限公司成立于2007年12月17日，是阳光保险集团股份有限公司旗下的全国性专业寿险公司，主要经营人寿保险、健康保险和意外伤害保险等一切人身险业务。阳光人寿自成立以来发展势头良好，价值不断提升，以专业服务为客户提供人寿、养老、医疗、健康、意外等保险保障。', '["民营"]', 1, 31, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '长城人寿保险股份有限公司', '长城人寿', 'IC031-ZCRS', '/logos/长城人寿保险股份有限公司.png',
    'http://www.greatlife.cn/', '95576', 2005, 683900.00,
    '北京市', 1, 'BBB（2025年3季度）', 131.34,
    '长城人寿保险股份有限公司，是经原中国保监会批准成立的全国性人寿保险公司，于2005年9月20日正式成立，公司总部设于北京。长城人寿成立以来，始终秉持稳健发展原则，强调“保费规模、价值贡献、利润增长”三者平衡发展。坚持价值导向，持续优化业务结构，重点发展高价值类业务，加强业务品质管理；资金运用方面，持续优化资产配置，拓展投资渠道，提升投资团队专业化水平；管理工作方面，不断提升科学、精细化管理水平，强化风险管控，全面推动公司高质量发展。', '[]', 1, 32, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '长生人寿保险有限公司', '长生人寿', 'IC032-ZSRS', '/logos/长生人寿保险有限公司.png',
    'http://www.gwcslife.com/', '400-820-8599', 2003, 216700.00,
    '上海市', 4, 'B（2025年2季度）', 55.50,
    '长生人寿保险有限公司成立于2003年9月，总部位于上海市。长生人寿一直坚持以客户为中心的经营主旨，切实履行公司消费者权益保护工作的主体责任，完善服务功能，提高服务质效；不断创新客户服务内涵和服务形式，构建起兼具人性关怀和公司特色的客户服务体系。', '["中外合资", "品牌重塑"]', 1, 33, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '招商局仁和人寿保险股份有限公司', '招商仁和人寿', 'IC033-ZSRHRS', '/logos/招商局仁和人寿保险股份有限公司.png',
    'https://www.cmrh.com/', '400-86-95666', 2017, 659900.00,
    '深圳市', 1, 'BB（2025年3季度）', 182.99,
    '2016年12月1日，经原中国保监会批准，招商仁和人寿正式开始筹建，并于2017年6月30日获得开业批复。作为一家央企控股的保险公司，招商仁和人寿将遵循金融保险业的发展规律和“保险姓保”的原则，走市场化、专业化、差异化的创新驱动型发展道路，推动“一个商业模式”转型，聚焦经营机制和经营能力两方面优化提升，大力实施“九大工程”。', '["国有背景"]', 1, 34, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '安联人寿保险有限公司', '安联人寿', 'IC034-ZDALRS', '/logos/安联人寿保险有限公司.png',
    'https://www.allianz.com.cn/', '95342', 1998, 200000.00,
    '上海市', 3, 'AA（2025年3季度）', 314.61,
    '凭借德国安联集团超过130年的保险和风险管理经验，以及全球领先的品牌影响力，安联人寿深耕中国中高端寿险市场多年，通过营销员团队、合作银行、多元和数字化渠道等全方位的营销网络，为中国消费者提供专业全面的人寿保险解决方案，涵盖生存、养老、疾病、医疗、身故、残疾、教育金等多种保障范围，让每一位客户拥有无忧人生。', '["品牌重塑"]', 1, 35, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中荷人寿保险有限公司', '中荷人寿', 'IC035-ZHRS', '/logos/中荷人寿保险有限公司.png',
    'http://www.bob-cardif.com/', '4008161688', 2002, 357000.00,
    '辽宁省大连市', 4, 'AA（2025年3季度）', 161.20,
    '作为中国加入世界贸易组织后首批获准成立的中外合资寿险公司，中荷人寿由北京银行与法国巴黎保险集团合资经营，业务覆盖环渤海经济圈、中原经济区、长三角经济圈，公司践行“诚信、担当、创新、共赢”的核心价值观，秉承“客户至上、轻松尊重”的保险服务理念，坚持以客户为中心，持续研发满足客户需求的保险产品，着力构建科技赋能、风控护航、全员合规、团结协作、和济进取的新发展格局，努力担负起“创造价值、值得信赖、成就未来”的企业使命，致力成为保险行业最值得信赖与尊重的典范。', '["中外合资", "品牌重塑"]', 1, 36, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中华联合人寿保险股份有限公司', '中华联合人寿', 'IC036-ZHLHRS', '/logos/中华联合人寿保险股份有限公司.png',
    'http://life.cic.cn', '95585', 2015, 260000.00,
    '北京市', 1, 'BB（2025年3季度）', 122.85,
    '中华联合人寿保险股份有限公司是中华联合保险集团股份有限公司旗下子公司，成立于2015年，是一家全国性国有控股股份制人寿保险公司，总部设在北京。公司始终坚持以客户为中心，从客户的实际需要出发，不断创新与丰富保险服务内容，完善保险服务手段，竭力为有保险需求的个人和家庭提供全方位、高品质、高效率的保险保障和财富管理服务。', '[]', 1, 37, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中信保诚人寿保险有限公司', '中信保诚人寿', 'IC037-ZXBCRS', '/logos/中信保诚人寿保险有限公司.png',
    'http://www.citic-prudential.com.cn/index.aspx', '4008-838-838', 2000, 236000.00,
    '北京市', 4, 'BB（2025年3季度）', 204.00,
    '中信保诚人寿保险有限公司成立于2000年，由中信集团和保诚集团联合发起创建。中信保诚人寿总部设在北京。秉承“聆听所至，信诚所在”的经营理念，中信保诚人寿在产品开发、业务发展、机构拓展、渠道建设、风险管理等方面开展了一系列卓有成效的工作，并以完善的内控和公司治理机制、优异的市场表现、杰出的专业化运作活跃在中国寿险市场。', '["中外合资", "品牌重塑"]', 1, 38, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中意人寿保险有限公司', '中意人寿', 'IC038-ZYRS', '/logos/中意人寿保险有限公司.png',
    'http://www.generalichina.com/', '956156/400-888-7555', 2002, 370000.00,
    '北京市', 4, 'AAA（2025年3季度）', 176.01,
    '中意人寿保险有限公司由意大利忠利保险有限公司（ASSICURAZIONI GENERALI）和中国石油天然气集团有限公司（CNPC）合资组建，是中国加入世界贸易组织后首家获准成立的中外合资保险公司。中意人寿引进国际先进的保险知识和经验，立足中国市场，为客户量身定做个性化、多样化、满足不同保障需求的保险产品，主要包括人寿保险、意外保险、健康保险、投资型保险以及团体雇员福利计划。这些产品保障面广、费率灵活、保障利益全面、可组合搭配，形成具有鲜明特色和创新优势的中意人寿产品系列。中意人寿秉承“以客为尊”的服务理念，竭诚为客户提供全方位、专业化、高品质的服务，理赔服务的时效与品质长期稳居行业前列。同时倡导差异化服务，不断创新服务内涵。全球紧急救援、直接付费医疗等，独具中意人寿的特色服务，让客户尽享一流保险公司服务的优越与尊荣。依托忠利集团的保险经营经验和两大股东的雄厚实力，中意人寿致力于打造国内一流的保险公司，按照“诚信为本、客户为尊、专业为基、创新为魂”的经营理念，坚持“自律、进取、学习”六字行为准则，努力为客户、股东、营销员、员工和社会创造价值。', '["中外合资"]', 1, 39, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中英人寿保险有限公司', '中英人寿', 'IC039-ZYRS', '/logos/中英人寿保险有限公司.png',
    'http://www.aviva-cofco.com.cn', '95545', 2003, 294500.00,
    '北京市', 4, 'AAA（2025年3季度）', 250.77,
    '中英人寿保险有限公司由中国中粮资本投资有限公司与英国英杰华集团合资组建，公司规模与利润均稳居合资第一梯队。中英人寿以Care in Every Home（关爱万家）为企业愿景，以I_C.A.R.E.（关爱）为企业文化的核心价值观，从正直与诚信（Integrity）出发演绎出团队情 (Collaboration)、行动力 (Action)、务实性 (Result-oriented)、同理心 (Empathy)的中英文化，成为企业持续、高速发展的坚实基础和源动力。强强联手打造的中英人寿秉承英杰华集团300多年的专业保险经验，依托中粮集团的强大实力，立足于中国市场，致力于成为领先的多渠道及数字化保险公司，打造定制化产品与服务，为广大客户提供优质的寿险服务及全面的财务保障！', '["中外合资"]', 1, 40, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '珠江人寿保险股份有限公司', '珠江人寿', 'IC040-ZJRS', '/logos/珠江人寿保险股份有限公司.png',
    'https://www.prlife.com.cn/', '4006-833-866', 2012, 670000.00,
    '广州市', 1, 'C（2021年3季度）', 104.04,
    '珠江人寿保险股份有限公司是由广东珠江投资控股集团有限公司、广州金融控股集团有限公司、广东韩建投资有限公司、广东新南方集团有限公司、衡阳合创房地产开发有限公司、广东珠光集团有限公司和广东粤财信托有限公司等7家股东共同投资的综合性寿险公司。\n珠江人寿为客户提供贴心周到的服务、科学合理的保障计划，并通过多元化的销售渠道，为个人及企业客户提供全方位的人寿保险、健康保险、意外伤害保险等各类人身保险保障。\n珠江人寿将围绕"成为最具竞争力和价值的金融保险集团"这一总体发展愿景，依托公司股东的强大实力，本着"守法经营、诚信服务、稳健发展、追求实效"的经营理念，竭诚为社会的繁荣稳定作出自己的贡献。', '[]', 1, 41, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '招商信诺人寿保险有限公司', '招商信诺人寿', 'IC041-ZSXNRS', '/logos/招商信诺人寿保险有限公司.png',
    'https://www.cignacmb.com/', '95362', 2003, 280000.00,
    '广东省深圳市', 4, 'AA（2025年3季度）', 193.36,
    '招商信诺人寿保险有限公司，简称招商信诺，公司经营范围包括人寿保险、健康保险和意外伤害保险等保险业务及其再保险业务。提供全面的保险服务。', '["中外合资"]', 1, 42, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '平安健康保险股份有限公司', '平安健康', 'IC042-PAJK', '/logos/平安健康保险股份有限公司.png',
    'https://health.pingan.com/', '95511转7', 2005, 461700.00,
    '上海市', 1, 'AAA（2025年3季度）', 313.96,
    '平安健康保险股份有限公司（以下简称“平安健康保险”）是我国首批设立的专业健康保险公司，是“世界500强”企业中国平安保险（集团）股份有限公司（中国平安，601318.SH，2318.HK）的重要成员公司。\n在“健康中国2030”战略的指引下，平安健康保险以“中国领先的医疗健康服务驱动型专业健康保险公司”为愿景，聚焦个人、企业、政府创新探索健康保险+医疗健康服务的新模式，致力于为客户提供“省心、省时、又省钱”的一站式健康解决方案。\n截至目前，平安健康保险已推出百余款对老中青全年龄段、全面覆盖健康体、慢病体和带病体的医疗保险、重疾保险、高端医疗保险和带病人群特色保险产品。早在2016年5月推出的百万医疗险产品“平安e生保”，引领了我国百万医疗险的创新之先。', '["国有背景"]', 1, 43, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '利安人寿保险股份有限公司', '利安人寿', 'IC043-LARS', '/logos/利安人寿保险股份有限公司.png',
    'http://www.lianlife.cc/', '956009', 2011, 457900.00,
    '江苏省南京市', 1, 'BB（2025年3季度）', 197.40,
    '利安人寿保险股份有限公司（简称“利安人寿”）是经中国银行保险监督管理委员会批准设立的一家全国性人身保险公司。利安人寿股东由江苏省国际信托有限责任公司、江苏交通控股有限公司、南京紫金投资集团有限责任公司、江苏汇鸿国际集团股份有限公司、江苏省信用再担保集团有限公司等5家国有大型企业和深圳市柏霖资产管理有限公司、雨润控股集团有限公司、月星集团有限公司、红豆集团有限公司、远东控股集团有限公司等5家知名民营企业组成。\n利安人寿以“利国安民”为使命，秉承“客户至上、稳健经营、创新发展、价值导向”的经营理念，坚持“诚信做人、勤勉做事、持续创新、追求卓越”的核心价值观，着力构建专业、透明、便捷的保险服务平台，积极为社会大众提供全面周到的保险保障和财富管理服务。利安人寿在帮助客户实现终身价值最大化的同时，努力为员工的职业生涯发展提供良好平台，努力为健全社会保障体系、保障民众生活安定做出积极的贡献，致力于打造“广受尊重的保险金融集团”！', '[]', 1, 44, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中美联泰大都会人寿保险有限公司', '中美联泰大都会人寿', 'IC044-ZMLTDDHRS', '/logos/中美联泰大都会人寿保险有限公司.png',
    'https://www.metlife.com.cn/', '400-818-8168', 2005, 272000.00,
    '中国（上海）自由贸易试验区世纪大道1196号31、32层整层 市', 4, 'BBB（2025年3季度）', 327.58,
    '中美联泰大都会人寿保险有限公司是由美国大都会集团下属公司和上海联和投资有限公司合资组建而成。凭借美国大都会集团在保险业的丰富经验以上海联和投资有限公司对中国场的深刻认识，大都会人寿致力于为中国消费者提供值得信赖和专业的保险方案。大都会人寿通过顾问行销、银行保险、直效行销数字营销等多元渠道，为全国各地超过二十个城的消费者提供人寿、健康、意外伤害年金保险产品等保险服务。', '["中外合资", "品牌重塑"]', 1, 45, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '合众人寿保险股份有限公司', '合众人寿', 'IC045-HZRS', '/logos/合众人寿保险股份有限公司.png',
    'http://www.unionlife.com.cn/unionlife/index/index.html', '95515', 2005, 428200.00,
    '湖北省武汉市', 2, 'BB（2018）', NULL,
    '合众人寿保险股份有限公司，简称“合众人寿”，合众人寿旗下投资有合众财险、合众资产、合众优年、盛世合众等公司，共同为客户提供涵盖保险、资产管理、养老等多领域的综合服务,并最终实现“成为专注于科技、保险、养老服务的综合金融保险集团”的愿景目标。合众人寿的掌舵人，董事长戴浩因一场意外改变了他的人生。穿越死亡线的他重新思考生命的意义、财富的价值。康复后，回忆住院期间很多病友因没钱放弃治疗，他决定创办一家体现爱与责任，能帮助每个家庭抵御风险的企业。源于爱，传递爱，合众人寿为爱而生。合众人寿致力于为社会大众提供人文关怀的寿险产品和服务。公司开发了一整套完备的产品体系，覆盖传统的长期寿险、分红保险、重大疾病保险和短期险产品等种类。合众人寿建立了“以客户为中心”的客户服务体系，提出“合众保险 理赔不难”的服务承诺，并推出相应的“两项承诺，创新四赔，八大服务”的合心意理赔服务体系，力求以友善、便捷、专业的服务，为客户提供全方位的金融服务。', '["民营"]', 1, 46, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '瑞华健康保险股份有限公司', '瑞华健康', 'IC046-RHJK', '/logos/瑞华健康保险股份有限公司.png',
    'https://www.rhassurance.com/rhOffic/home', '400-609-6868', 2018, 50000.00,
    '上海市', 2, 'BB（2024年4季度）', 101.51,
    '瑞华健康保险股份有限公司（以下简称“瑞华保险”）作为一家科技创新型专业健康保险公司，瑞华保险深入贯彻落实新发展理念与党的二十大精神，坚持以“健康中国”战略为引领，以健康促进为己任，以专业化的健康风险保障为核心，以数字化的健康管理为驱动，以生态化的医疗服务网络体系为支撑，紧紧围绕人民群众日益增长的医疗、健康、养老、护理等全生命周期、全场景的需求，构建了由专病健康业务（Special Care) 、急速健康业务（Urgent Care) 、长期护理业务（Long Term Care) 、普惠健康业务（Total Care) 等四大板块构成的“4C”业务体系，全方位推进商业健康保险与健康管理服务深度融合发展，积极服务民生保障和“健康中国”建设。', '["民营"]', 1, 47, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '太平养老保险股份有限公司', '太平养老', 'IC047-TPYL', '/logos/太平养老保险股份有限公司.png',
    'http://tppension.cntaiping.com/', '95589', 2004, 300000.00,
    '上海市', 1, 'AA（2025年3季度）', 209.89,
    '太平养老保险股份有限公司是中管金融机构中国太平保险集团有限责任公司旗下专业经营养老金业务和员工福利保障业务的重要子公司，也是我国首家国有专业养老保险公司，服务网络覆盖全国。\n太平养老拥有企业年金基金法人受托、投资、账户管理人资格，同时也具备养老保险资产管理资格，在国家养老健康保障制度建立和商业化运作试点中，积极参与了企业年金、职业年金、个人税优健康保险、个税递延养老保险等相关政策的制定研究，树立了行业领先优势。太平养老为客户提供全方位的健康保障，在团体终身重疾、中高端医疗、长期护理保险产品、全球医疗保障服务等方面具有独特的国际合作优势，受到各界广泛认同。', '["国有背景"]', 1, 48, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '和谐健康保险股份有限公司', '和谐健康', 'IC048-HXJK', '/logos/和谐健康保险股份有限公司.png',
    'http://www.hexiehealth.com/', '956076', 2006, 1390000.00,
    '中国（四川）自由贸易试验区成都高新区天府大道北段966号10号楼2层市', 2, '', NULL,
    '和谐健康保险股份有限公司是经中国保险监督管理委员会最早批准开业的全国性、专业性健康保险公司之一。和谐健康坚持“保险姓保”的发展方向，以“科学、开放、共享、协调、创新”为发展理念；以“合规经营，诚信发展，防控风险，严谨廉洁”为经营宗旨，大力发展保障型业务、期交业务，全面增强核心竞争力。', '["民营"]', 1, 49, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '信美人寿相互保险社', '信美相互', 'IC049-XMXH', '/logos/信美人寿相互保险社.png',
    'https://www.trustlife.com/index.html#/home', '400-139-9990', 2017, 150100.00,
    '北京市', 2, 'BBB（2025年3季度）', 123.13,
    '信美人寿相互保险社是国内首家成立的相互人寿保险组织。信美相互经保监会许可的业务范围为普通型保险，包括人寿保险和年金保险；健康保险；意外伤害保险；上述业务的再保险业务；国家法律、法规允许的保险资金运用业务；经中国保监会批准的其他业务。', '["民营"]', 1, 50, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '众惠财产相互保险社', '众惠相互', 'IC050-ZHXH', '/logos/众惠财产相互保险社.png',
    'https://www.pubmi.org/', '400-919-0505', 2017, 100000.00,
    '北京市', 2, 'BBB（2025年3季度）', 186.12,
    '众惠财产相互保险社成立于2017年2月14日，是中国首家经保监会批准设立的全国性相互保险组织。位于金融创新窗口深圳前海，主营业务包括信用保险、保证保险、短期健康和意外伤害保险等。\n', '["民营"]', 1, 51, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '海保人寿保险股份有限公司', '海保人寿', 'IC051-HBRS', '/logos/海保人寿保险股份有限公司.png',
    'https://www.haibao-life.com/index.shtml', '400-898-0899', 2018, 150000.00,
    '海南省海口市', 2, 'BB（2025年3季度）', 157.12,
    '海保人寿保险股份有限公司由海马投资集团有限公司、海思科医药集团股份有限公司、易联众信息技术股份有限公司、深圳市智信利达投资有限公司、舜元建设（集团）有限公司、深圳市仲山裕华投资发展有限公司、海南新建桥经济发展有限公司、本源建投（北京）资产管理有限公司共同出资发起设立，注册地海口市，于2018年5月23日正式获得中国银行保险监督管理委员会的开业批复，是第一家在海南筹建开业的全国性保险法人机构。', '["民营"]', 1, 52, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中国太平洋人寿保险股份有限公司', '太平洋人寿', 'IC052-TPYRS', '/logos/中国太平洋人寿保险股份有限公司.png',
    'http://www.cpic.com.cn/', '95500', 2001, 862800.00,
    '上海市', 2, 'AA（2025年3季度）', 214.00,
    '中国太平洋人寿保险股份有限公司成立于2001年11月，是中国太平洋保险（集团）股份有限公司（以下简称“中国太平洋保险”）旗下专业寿险子公司，总部设在上海。中国太平洋保险是在1991年5月13日成立的中国太平洋保险公司的基础上组建而成的保险集团公司，是国内领先的“A+H”股上市综合性保险集团。', '["民营"]', 1, 53, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    'BUPA', 'BUPA（保柏）中国', 'IC053-BUPA（BB）ZG', '/logos/BUPA.png',
    'http://www.bupa.com.cn/EN/index.htm', '4008-5008-33', NULL, NULL,
    'NULL', 1, '', NULL,
    '保柏中国隶属于国际知名的保柏集团。保柏在英国健康和护理市场处于领先地位，业务服务遍布全球。 保柏集团成立于1947年，目前为115个国籍超过1,000万会员服务，这些会员分别位于全球190个国家和地区。', '[]', 1, 54, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    'MSH INTERNATIONAL', 'MSH', 'IC054-MSH', '/logos/MSH INTERNATIONAL.png',
    'http://www.mshchina.com/Default.aspx', '400 613 0330', NULL, NULL,
    '中国上海浦东峨山路91弄陆家嘴软件园9号楼北塔5层市', 1, '', NULL,
    'MSH INTERNATIONAL成立于1974年，是国际健康险设计和管理方面的全球领军者。设有法国巴黎、加拿大多伦多、中东迪拜和中国上海4个区域总部，为客户提供24小时不间断的服务。MSH INTERNATIONAL 来自各个国家的员工具备40种语言能力，为遍布全球200个国家的企业和被保险人提供服务，致力于为个人客户提供高质量的保险方案，为企业客户提供量身定做的保险产品。', '[]', 1, 55, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '美国安泰保险金融集团', 'Aetna', 'IC055-AETNA', '/logos/美国安泰保险金融集团.png',
    'https://es.aetna.com/', '', NULL, NULL,
    'NULL', 1, '', NULL,
    '美国安泰保险金融集团是世界上历史最悠久的健康保险公司之一。1850年开设了Annuity部门，开始了人寿保险业务，1853年Annuity部门独立出来成立安泰人寿保险公司。在美国，该公司在医疗、牙科、药物以及人寿和团体残疾保险利益行业位居前列。', '[]', 1, 56, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    'Global Benefits Group', 'GBG', 'IC056-GBG', '/logos/Global Benefits Group.png',
    'https://www.gbg.com/#/Home', '', NULL, NULL,
    'NULL', 1, '', NULL,
    'Global Benefits Group（GBG）已經專注於國際保險市場超過35年。在那個時候，隨著世界經濟全球化的加速，GBG開發了這個特定市場利基所需的專業承保結構。\nGBG是醫療，生活，殘疾和旅行保險解決方案的主要承保商，開發商和分銷商，旨在滿足那些生活和工作超越地理界限的人們的需求。\n在我們的TieCare International品牌下，我們是全球國際學校員工福利的領先提供商。', '[]', 1, 57, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '亚太财产保险有限公司', '亚太财险', 'IC057-YTCX', '/logos/亚太财产保险有限公司.png',
    'https://www.apiins.com/maechannel/home.do', '95506', 2005, 400000.00,
    '深圳市', 2, 'C（2025年3季度）', 121.90,
    '亚太财产保险有限公司（简称“亚太财险”）是经原中国保监会批准成立的全国性综合财产保险公司。亚太财险由“民安财产保险有限公司”更名而来，是一家历史悠久的财产保险公司。自1943年创立至今，已有80余年的发展历史。公司经营范围包括：财产损失保险、责任保险、信用保险和保证保险、短期健康保险和意外伤害保险等业务。公司拥有专业的人才队伍和丰富的风险管理经验，具备强大的再保支持和海外救援能力，能够为海内外客户提供诚信、专业、周全、快捷、细致的风险保障及风险管理增值服务。\n', '["民营", "品牌重塑"]', 1, 58, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '爱和谊日生同和财产保险(中国)有限公司', '爱和谊日生同和财险', 'IC058-AHYRSTHCX', '/logos/爱和谊日生同和财产保险(中国)有限公司.png',
    '', '', NULL, NULL,
    'NULL', 3, 'BBB（2024年2季度）', 450.00,
    '', '[]', 1, 59, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '安诚财产保险股份有限公司', '安诚财险', 'IC060-ACCX', '/logos/安诚财产保险股份有限公司.png',
    'http://www.e-acic.com/AcicWebManager/template/main', '95544', 2006, 407600.00,
    '重庆市', 1, 'B（2025年3季度）', 354.74,
    '安诚财产保险股份有限公司成立于2006年12月，是第一家总部设在重庆的全国性财产保险公司。公司注册资本金40.76亿元人民币，总体资产规模近80亿元人民币。现有省级分公司19家，分支机构259家，员工6000余人，主要分布在长三角、珠三角、西三角及华北地区等重要经济带。公司设有全国性独资子公司安诚保险销售有限公司、安澜保险经纪有限公司。', '[]', 1, 60, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '安达保险有限公司', '安达保险', 'IC061-ADBX', '/logos/安达保险有限公司.png',
    'https://www.chubb.com.cn/', '400-889-2120', 2016, 75510.00,
    '上海市', 3, 'B（2022年4季度）', 213.36,
    '', '["品牌重塑"]', 1, 61, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '安盛天平财产保险有限公司', '安盛天平财险', 'IC062-ASTPCX', '/logos/安盛天平财产保险有限公司.png',
    'https://www.axa.cn/', '95550', 2004, 84600.00,
    '中国（上海）自由贸易试验区银城路1幢117号瑞明大厦11层市', 3, 'AA（2025年3季度）', 217.24,
    '安盛集团（AXA）总部位于法国巴黎，是当今世界领先的保险及资产管理集团之一，于2020年位列《财富》世界五百强榜单第34位，业务覆盖全球57个国家和地区，为全球1.08亿客户提供量身定制的服务和解决方案。安盛天平为安盛集团在华全资财险公司，秉承“从赔付者到陪伴者”的企业愿景，始终以全方位、定制化的优质产品和服务，在健康险、商业险以及财产和意外伤害险领域，满足客户不断变化的需求。', '["品牌重塑"]', 1, 62, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '安信农业保险股份有限公司', '安信农险', 'IC063-AXNX', '/logos/安信农业保险股份有限公司.png',
    'https://www.aaic.com.cn/', '400-806-0606', 2004, 70000.00,
    '上海共和新路3651号农保大厦市', 1, '', NULL,
    '2004年9月，作为中国农业保险的先驱者和探索者，我国第一家专业性农业保险公司--安信农业保险股份有限公司在上海破冰启航，翻开了新时期探索我国农业保险发展的历史新篇。翌年，上海市政府为加大对农业保险的扶持力度，建立了“上海市推进农业保险委员会”这一长效化的工作机制，在全国乃属第一。农业保险在各级政府的关心和扶持下得到了持续稳定健康的发展，在服务上海农村社会经济发展、参与社会管理等方面发挥了积极有效的作用。', '["国有背景"]', 1, 63, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '北部湾财产保险股份有限公司', '北部湾财险', 'IC064-BBWCX', '/logos/北部湾财产保险股份有限公司.png',
    'http://www.bgic.com/', '400-990-9999', 2013, 150000.00,
    '广西南宁市', 1, 'BB（2026年1季度）', 232.75,
    '北部湾财产保险股份有限公司是在广西壮族自治区党委、自治区人民政府的大力推动、支持下，由广西金融投资集团有限公司作为主发起人，联合区内外共13家大型企业共同发起，于2013年1月18日成立，是首家总部设于广西的全国性法人保险机构。', '[]', 1, 64, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '东京海上日动火灾保险（中国）有限公司', '东京海上日动（中国）', 'IC065-DJHSRD（ZG）', '/logos/东京海上日动火灾保险（中国）有限公司.png',
    'https://www.tokiomarine.com.cn/cn/', '400-885-8008', 1994, 40000.00,
    '中国（上海）自由贸易试验区陆家嘴环路1000号恒生银行大厦38楼市', 3, 'AAA（2025年3季度）', 376.51,
    '东京海上日动火灾保险（中国）有限公司，前身为成立于1994年的日本东京海上火灾保险株式会社上海分公司，是首家进入中国保险市场的日资保险公司。在长年的经营历史中，我公司始终坚持稳健经营、客户为本的经营方针，经营业绩与规模在外资财险公司均名列前茅。', '[]', 1, 65, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '都邦财产保险股份有限公司', '都邦财险', 'IC066-DBCX', '/logos/都邦财产保险股份有限公司.png',
    'https://www.dbic.com.cn/', '95586', 2005, 290000.00,
    '吉林省吉林市', 1, 'B（2025年3季度）', 154.20,
    '都邦保险成立于2005年10月19日，注册地吉林市。都邦保险已拥有33家分公司，形成了覆盖全国的机构服务网络，并连续多年实现盈利，步入健康快速发展的轨道；都邦保险坚持把服务作为公司发展的生命线，以完善服务硬件设施配置、建设高素质的客户服务队伍、建立全国通赔网络系统和推广亲情特色化客户服务举措为重点，着力打造一流服务品牌，赢得了广大客户的广泛赞誉。', '[]', 1, 66, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '丰泰保险（亚洲）有限公司', '丰泰保险', 'IC067-FTBX', '/logos/丰泰保险（亚洲）有限公司.png',
    '', '', NULL, NULL,
    'NULL', 3, '', NULL,
    '', '[]', 1, 67, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '富邦财产保险有限公司', '富邦财险', 'IC068-FBCX', '/logos/富邦财产保险有限公司.png',
    'https://www.fubon.com.cn/', '4008-817-518', 2010, 112000.00,
    '厦门市', 4, 'A（2025年3季度）', 209.66,
    '1961年台湾第一家民营产物保险公司—富邦产物保险（原名国泰产物保险）正式成立，开启富邦集团发展的扉页，迄今已将届53年。1992年集团总裁蔡万才先生取「富国安邦」之寓意，正式将「富邦」的全新企业识别系统，整合至所属的各关系企业。半世纪以来，富邦集团深耕台湾，逐步发展成为台湾产品线最完整的金融集团，经营触角也由金融领域延伸至不动产服务及电信媒体服务。此外，并长期透过集团旗下五大基金会投入社会公益活动，善尽企业社会责任，实践富邦集团永续经营的理念。', '["中外合资"]', 1, 68, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '国任财产保险股份有限公司', '国任财险', 'IC069-GRCX', '/logos/国任财产保险股份有限公司.png',
    'https://www.guorenpcic.com/', '956030', 2009, 400700.00,
    '深圳市', 1, 'B（2025年3季度）', 250.98,
    '国任财产保险股份有限公司（简称“国任保险”）前身是信达财产保险股份有限公司（简称“信达财险”），是经保险监督管理部门批准，于2009年8月在北京成立的一家全国性保险公司，现注册资本40.07亿元人民币。2018年1月，公司更名为“国任保险”。2019年3月底，公司注册地迁至深圳，现为深圳金融总部企业。\n', '["品牌重塑"]', 1, 69, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '国泰财产保险有限责任公司', '国泰财险', 'IC070-GTCX', '/logos/国泰财产保险有限责任公司.png',
    'https://www.cathay-ins.com.cn/', '400-926-2860', 2008, 263000.00,
    '上海市', 4, 'A（2025年3季度）', 388.59,
    '国泰财产保险有限责任公司（以下简称“国泰产险”）于2008年8月在上海成立。由国泰人寿保险股份有限公司和国泰世纪产物保险股份有限公司共同出资建成，经营范围覆盖东南沿海和中西部地区。2016年7月，国泰产险引入蚂蚁科技集团股份有限公司（简称“蚂蚁集团”）战略投资，以“保险+科技+数据”深度共创，拓展科技保险蓝图，服务阿里巴巴经济体、小微商家及个人客户。“以科技赋能保险，为用户创造价值”，国泰产险以“自动化、智能化、定制化”保险产品赋能业务生态，聚焦于创新和差异化的保险产品和智能服务，践行“让每个人更简单地享受保险”的公司使命。', '["中外合资"]', 1, 70, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '海峡金桥财产保险股份有限公司', '海峡金桥财险', 'IC071-HXJQCX', '/logos/海峡金桥财产保险股份有限公司.png',
    'https://www.chgic.com/', '0591-96331', 2016, 150000.00,
    '福建省福州市', 1, 'B（2025年3季度）', 151.24,
    '海峡金桥财产保险股份有限公司（以下简称：海峡保险）是福建首家国有法人的全国性保险公司，总部设在中国(福建)自由贸易试验区福州片区。        \n         设立海峡保险是福建省委、省政府加快发展现代保险服务业，贯彻“一带一路”国家战略，建设海上丝绸之路核心区,建设生态文明先行示范区，做强做大福建金融业，构建两岸区域性金融服务中心的一项重要举措。', '[]', 1, 71, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '华安财产保险股份有限公司', '华安财险', 'IC072-HACX', '/logos/华安财产保险股份有限公司.png',
    'https://www.sinosafe.com.cn/', '95556', 1996, 210000.00,
    '深圳市', 2, 'B（2025年3季度）', 159.45,
    '华安——华夏安康，作为民族企业的一分子，华安立足华夏大地，立志为炎黄子孙的安康幸福保驾护航。       为应对中国保险业面临的巨大挑战及机遇，华安保险厚积薄发，数万名华安人围绕“以华安人为中心”的变革思想，为着共同的理想，孜孜以求、勤勉不懈。在坚持重视客户需求和利益的基础上，华安保险不断借鉴国内外同业先进技术及管理经验，以新产品、新手段、新服务满足客户的不同需要，为数千亿元财产提供了充分的保险保障，获得了广大客户的支持与信赖。', '["民营"]', 1, 72, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '华农财产保险股份有限公司', '华农财险', 'IC073-HNCX', '/logos/华农财产保险股份有限公司.png',
    'https://www.chinahuanong.com.cn/', '400-010-0000', 2006, 100000.00,
    '广东省佛山市', 2, 'B（2025年3季度）', 180.89,
    '华农保险数智持续赋能获客、风控、客服三大核心优势能力建设，聚焦车险、意健险、农险、财产险四大业务方向，深耕细分市场和客群，通过产品服务创新，赢得市场。车险依托自研“天擎”车险智慧决策系统，实现算账智慧经营、有效益高质量发展；意健险/数智保险实现从0到1、再到规模屡创新高的快速突破，跃升公司第二大业务板块；三农保险围绕“乡村振兴”国家战略，以“创新”为特色，全国首创“河蟹目标收入保险”“纸浆价格保险”等多款创新产品；财产险聚焦工程险、责任险等板块业务，逐步形成核心优势，积累可持续发展能力。\n\n', '["民营"]', 1, 73, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '华泰财产保险有限公司', '华泰财险', 'IC074-HTCX', '/logos/华泰财产保险有限公司.png',
    'http://www.ehuatai.com/business.html', '40060-95509', 2011, 300000.00,
    '中国（上海）自由贸易试验区博成路1101号华泰金融大厦3层306A、307单元市', 3, 'BBB（2025年3季度）', 207.69,
    '华泰保险集团股份有限公司（以下简称“华泰保险集团”）是一家集财险、寿险、资产管理、基金管理于一体的综合性金融保险集团，前身是1996年成立的华泰财产保险股份有限公司', '[]', 1, 74, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '建信财产保险有限公司', '建信财险', 'IC075-JXCX', '/logos/建信财产保险有限公司.png',
    'https://www.ccbpi.com.cn/', '400-900-6996', 2016, 100000.00,
    '北京市', 1, 'BBB（2025年3季度）', 208.40,
    '建信财产保险有限公司(简称“建信财险”)于2016年10月成立，是经监管机构批准设立的全国性财产保险公司。隶属于中国建设银行集团，经营总部设立在北京。', '["国有背景"]', 1, 75, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '锦泰财产保险股份有限公司', '锦泰财险', 'IC076-JTCX', '/logos/锦泰财产保险股份有限公司.png',
    'http://www.ejintai.com/', '4008666555', 2011, 237900.00,
    '成都市', 1, 'BBB（2025年3季度）', 599.00,
    '锦泰财产保险股份有限公司(以下简称“锦泰保险”)成立于2011年1月，是注册及经营总部均在四川成都的全国性股份制保险机构，股东由中央、省、市三级具有雄厚实力的国资企业构成。2016年12月，锦泰保险在全国中小企业股份转让系统挂牌，是中西部首家在“新三板”挂牌的保险公司', '[]', 1, 76, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '京东安联财产保险有限公司', '京东安联财险', 'IC077-JDALCX', '/logos/京东安联财产保险有限公司.png',
    'https://www.allianz.cn/zh/home_page/', '950610', 2003, 161000.00,
    '广东省广州市', 4, 'BB（2025年3季度）', 183.10,
    '京东安联是京东集团与德国安联集团在2018年合力打造，定位为一家以客户为中心、数据为基础、技术为驱动的科技型保险公司。秉承“智·惠”保险价值主张，致力于成为最值得信赖的数字化科技保险公司。', '["中外合资", "品牌重塑"]', 1, 77, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '利宝保险有限公司', '利宝保险', 'IC078-LBBX', '/logos/利宝保险有限公司.png',
    'http://www.libertymutual.com.cn/', '400-888-2008', 2007, 193633.30,
    '重庆市', 3, 'BB（2025年3季度）', 223.69,
    '利宝保险有限公司是利宝互助保险集团在中国的全资子公司。1996年，利宝互助保险开始进入中国设立办事处。2003年，在中国重庆设立了分公司，把发展中国市场列为关键战略，成为第1家进入中国西部的外资保险公司。2007年，利宝互助保险重庆分公司经保监会批准，升级为利宝在中国的全资子公司，并正式更名为利宝保险有限公司，成为首家将中国总部设在重庆的世界500强企业。', '[]', 1, 78, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '美亚财产保险有限公司', '美亚财险', 'IC079-MYCX', '/logos/美亚财产保险有限公司.png',
    'https://www.aig.com.cn/', '（86-21）3857 8000', 1992, 91100.00,
    '中国（上海）自由贸易试验区陆家嘴环路1000号恒生银行大厦31楼021室及33楼042室市', 3, 'AA（2025年3季度）', 240.63,
    '美亚财产保险公司是一家外资保险企业，1992年成立于上海。经营范围则包括财产损失保险、责任保险、信用保险、保证保险等财产保险业务及再保险业务。', '[]', 1, 79, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '瑞再企商保险有限公司', '瑞再企商保险', 'IC080-RZQSBX', '/logos/瑞再企商保险有限公司.png',
    'https://www.swissrecorporatesolutions.com.cn/', '', NULL, NULL,
    'NULL', 1, 'BBB（2024年1季度）', 344.00,
    '', '[]', 1, 80, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '三星财产保险（中国）有限公司', '三星财险', 'IC081-SXCX', '/logos/三星财产保险（中国）有限公司.png',
    'https://www.samsunganycar.com/', '4009-333-000', 2010, 87500.00,
    '上海市', 4, 'BB（2025年3季度）', 635.09,
    '三星财产保险（中国）有限公司，原名三星火灾海上保险（中国）有限公司，并于2010年5月11日正式更名为"三星财产保险（中国）有限公司"，简称"三星产险" ', '["中外合资"]', 1, 81, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '史带财产保险股份有限公司', '史带财险', 'IC082-SDCX', '/logos/史带财产保险股份有限公司.png',
    'http://www.starrchina.cn/', '400-999-5507', 1995, 143250.00,
    '中国（上海）自由贸易试验区福山路500号25层01-04单元及06单元市', 3, 'BB（2025年3季度）', 201.04,
    '史带财产保险股份有限公司（简称“史带财险”，原大众保险）注册资本为人民 币 14.325 亿元，是一家股份制商业保险公司。是史带集团在中国的成员公司， 获国际知名评级机构贝氏（A.M.Best）评定财务实力 A（优秀）', '[]', 1, 82, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '苏黎世财产保险（中国）有限公司', '苏黎世财险', 'IC083-SLSCX', '/logos/苏黎世财产保险（中国）有限公司.png',
    'https://www.zurich.com.cn/', '4006155156', 2013, 92200.00,
    '中国（上海）自由贸易试验区世纪大道100号环球金融中心16楼T20市', 3, 'A（2025年3季度）', 219.46,
    '苏黎世保险集团是一家全球领先的多险种保险公司，为全球及本地市场的客户提供服务。苏黎世拥有约55,000名员工，为超过215个国家和地区的客户提供多种财产保险以及人寿保险的产品和服务。', '[]', 1, 83, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '太平财产保险有限公司', '太平财险', 'IC084-TPCX', '/logos/太平财产保险有限公司.png',
    'http://caixian.cntaiping.com/', '95589', 2001, 767000.00,
    '深圳市', 1, 'BBB（2025年3季度）', 244.09,
    '太平财产保险有限公司，简称“太平财险”，公司总部在深圳，注册资本金61.7亿元，隶属于中管金融企业中国太平保险集团有限责任公司，是服务评价AA级公司，是经营评价、风险综合评级A级公司，是标准普尔评级国际A级公司，经营历史悠久，管理先进规范，服务专业诚信，品牌形象良好，曾荣获“年度卓越财险公司”、“年度最佳财产险公司”、“年度最佳保险品牌”等多项荣誉称号。', '[]', 1, 84, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '申能财产保险股份有限公司', '申能财险', 'IC085-TACX', '/logos/申能财产保险股份有限公司.png',
    'https://www.95505.com.cn/', '400-123-4567', 2024, 1000000.00,
    '中国（上海）自由贸易试验区临港新片区海港大道1539号1001室市', 1, 'BBB（2025年3季度）', 252.30,
    '申能财产保险股份有限公司【以下简称“申能财险”】获得国家金融监督管理总局批复开业（金复【2024】20号），于2024年1月16日正式成立。\n申能财险将发挥股东的专业优势，立足长三角、服务全国，加强与新能源、新技术和新业态企业的合作，为客户提供一揽子风险保障方案。公司还将围绕客户及绿色产业链的保障与风险管理需求，创新更多绿色保险和风险减量服务，建立可持续的合作关系。同时，公司将坚持合规经营，坚持稳中求进，以改革创新为动力，以提高精细化运营与资源配置水平为抓手，以渠道、产品、区域、客户结构优化为主线，推动和实现企业的高质量发展。\n', '["国有背景", "品牌重塑"]', 1, 85, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '阳光财产保险股份有限公司', '阳光财险', 'IC086-YGCX', '/logos/阳光财产保险股份有限公司.png',
    'http://www.4000-000-000.com/index', '95510', 2005, 645690.00,
    '北京市', 2, 'AA（2025年3季度）', 252.18,
    '阳光财产保险成立于2005年7月，是主要经营财产保险业务的全国性保险公司，注册资本金31.8亿元人民币。\n        阳光产险成立以来，连续多年刷新国内新设保险公司年度保费规模的历史纪录，实现了又好又快的发展，服务网络实现全国覆盖。', '["民营"]', 1, 86, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '英大泰和财产保险股份有限公司', '英大泰和财险', 'IC087-YDTHCX', '/logos/英大泰和财产保险股份有限公司.png',
    'http://www.ydpic.com.cn/', '4000188688', 2008, 660000.00,
    '北京市', 1, 'AAA（2025年3季度）', 276.46,
    '英大泰和财产保险股份有限公司始终为客户提供好的产品和技术支持、健全的售后服务，我公司业务范围：财产损失保险；责任保险；信用保险和保证保险；短期健康保险和意外伤害保险；上述业务的再保险业务；国家法律、法规允许的保险资金运用业务；经中国保监会批准的其他业务。', '["国有背景"]', 1, 87, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '英国RSA保险集团', '太阳联合财险', 'IC088-TYLHCX', '/logos/英国RSA保险集团.png',
    '', '', NULL, NULL,
    'NULL', 3, '', NULL,
    '', '[]', 1, 88, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '永安财产保险股份有限公司', '永安财险', 'IC089-YACX', '/logos/永安财产保险股份有限公司.png',
    'http://www.yaic.com.cn/', '95502', 1996, 300941.60,
    '陕西省西安市', 1, 'BBB（2025年3季度）', 279.55,
    '1996年9月28日，在中国经济改革开放的大潮中，永安保险公司在西安成立。公司目前为国有资本控股企业，主要股东为延长石油集团、上海复星集团、陕西有色集团等，公司注册资本金30.09416亿元。截至2019年年底，拥有分公司27家，航运保险运营中心1家，中心支公司185家，支公司365家，营销服务部411家，营业部1家，各类分支机构990家，拥有一万三千余名员工，公司总资产147.26亿元，净资产49.19亿元。', '[]', 1, 89, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '永诚财产保险股份有限公司', '永诚财险', 'IC090-YCCX', '/logos/永诚财产保险股份有限公司.png',
    'http://www.alltrust.com.cn/', '95552', 2004, 217800.00,
    '上海市', 4, 'BB（2025年3季度）', 163.20,
    '永诚财产保险股份有限公司（以下简称永诚保险）成立于2004年，是由国内外实力雄厚的大型电力企业集团和产业投资集团共同发起组建的全国性股份制财产保险公司.', '["中外合资"]', 1, 90, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '长安责任保险股份有限公司', '长安责任', 'IC091-ZAZR', '/logos/长安责任保险股份有限公司.png',
    'https://www.capli.com.cn/', '', 2007, 325154.00,
    'NULL', 2, '', NULL,
    '长安保险是以责任保险为特色的综合性财产保险公司，经营业务范围涵盖责任险、车险、财产损失险、信用与保证保险、短期健康险和意外险及上述业务的再保险等业务。努力贴近经济社会发展和人民生产生活中的保险新需求，尤其在食品安全、校园安全、建筑工程、环境保护、安全生产等领域，具备较强的研发能力、完整的产品体系和独特的竞争优势，获得了良好的市场口碑和社会赞誉。', '["民营"]', 1, 91, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中国大地财产保险股份有限公司', '大地财险', 'IC092-DDCX', '/logos/中国大地财产保险股份有限公司.png',
    'http://www.ccic-net.com.cn/', '95590', 2003, 1510000.00,
    '中国（上海）自由贸易试验区民生路1199弄1号楼6、7、8、9、10层市', 1, 'AA（2025年3季度）', 277.00,
    '中国大地保险的业务经营范围涵盖非寿险业务的各个领域。2014年，公司获准短期出口信用保险经营资格，成为全国拥有该项资质的五家财产险公司之一。公司创立十四年来实现了跨越式发展。', '[]', 1, 92, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中国平安财产保险股份有限公司', '平安财险', 'IC093-PACX', '/logos/中国平安财产保险股份有限公司.png',
    'https://property.pingan.com/', '95511', 2002, 2100000.00,
    '深圳市', 2, 'A（2025年3季度）', 217.90,
    '中国平安财产保险股份有限公司（以下简称“平安产险”）于1988年诞生于深圳蛇口，是中国平安保险（集团）股份有限公司（以下简称“平安集团”）实现多元化发展的起点；以保费收入衡量，平安产险是中国第二大财产保险公司。成立32年来，平安产险坚持稳定、健康的发展方略。', '["民营"]', 1, 93, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中国人民财产保险股份有限公司', '人保财险', 'IC094-RBCX', '/logos/中国人民财产保险股份有限公司.png',
    'http://www.epicc.com.cn/', '95518', 2003, 2220000.00,
    '北京市', 1, 'A（2025年3季度）', 237.97,
    '中国人民财产保险股份有限公司的前身是1949年10月20日成立的中国人民保险公司，是中国人民保险集团股份有限公司的核心成员和标志性主业，是国内历史悠久、业务规模大、综合实力强的大型国有财产保险公司，保费规模居全球财险市场前列。公司于2003年11月6日在香港联交所主板上市。', '[]', 1, 94, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中国人寿财产保险股份有限公司', '中国人寿财险', 'IC095-ZGRSCX', '/logos/中国人寿财产保险股份有限公司.png',
    'https://www.chinalife-p.com.cn/#/', '95519', 2006, 2780000.00,
    ' 北京市', 1, 'AAA（2025年3季度）', 212.83,
    '中国人寿财产保险股份有限公司成立于2006年12月30日，系中国人寿保险（集团）公司旗下核心成员，注册资本为188亿元，经营范围包括财产损失保险、责任保险、信用保险和保证保险、短期健康保险和意外伤害保险，上述业务的再保险业务，国家法律、法规允许的保险资金运用业务，经中国银保监会批准的其他业务。', '[]', 1, 95, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中国太平洋财产保险股份有限公司', '太平洋财险', 'IC096-TPYCX', '/logos/中国太平洋财产保险股份有限公司.png',
    'http://www.cpic.com.cn/', '95500', 2001, 1994800.00,
    '中国（上海）自由贸易试验区银城中路190号交银金融大厦南楼市', 1, 'AA（2025年3季度）', 237.50,
    '中国太平洋财产保险股份有限公司（简称“太平洋产险”）是中国太平洋保险（集团）股份有限公司旗下的专业子公司，为客户提供全面的财产保险产品和服务。\n太平洋产险承保机动车辆保险、财产保险、责任保险、农业保险、意外伤害保险、短期健康保险等中国银保监会批准的各类保险业务，服务范围覆盖航空航天、电力能源、石油化工、船舶航运、纺织烟草、机械设备、电子通讯、金融贸易、科技创新、基础建设、农林牧渔等各行业和领域。', '["国有背景"]', 1, 96, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中航安盟财产保险有限公司', '中航安盟财险', 'IC097-ZHAMCX', '/logos/中航安盟财产保险有限公司.png',
    'https://www.groupama-sdig.com/', '956001', 2024, 140000.00,
    '四川省成都市', 4, '', NULL,
    '经营范围：一、农业保险；二、涉农财产保险；三、企业财产保险；四、个人财产保险；五、机动车辆保险；六、责任保险；七、信用保险；八、保证保险；九、航空保险；十、运输保险；十一、意外伤害保险；十二、短期健康保险；十三、所有其他类型的财产保险；十四、上文所列保险业务的再保险；十五、法律、法规允许或中国银保监会批准的资金运用业务；十六、法律法规规定和中国银保监会及国家有关部门批准的其他业务。（涉及国家规定实施准入特别管理措施的除外）（依法须经批准的项目，经相关部门批准后方可开展经营活动）。', '["中外合资"]', 1, 97, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中华联合财产保险股份有限公司', '中华联合财险', 'IC098-ZHLHCX', '/logos/中华联合财产保险股份有限公司.png',
    'http://e.cic.cn/', '95585', 2006, 1464000.00,
    '北京市', 1, 'A（2025年3季度）', 215.90,
    '中华财险，全称为中华联合财产保险股份有限公司。公司始创于1986年7月15日，2002年，经国务院批复同意，冠名“中华”，成为全国唯一一家以“中华”冠名的国有控股保险公司。', '[]', 1, 98, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中意财产保险有限公司', '中意财险', 'IC099-ZYCX', '/logos/中意财产保险有限公司.png',
    'http://www.generali-china.cn/', '400-600-2700', 2007, 130000.00,
    '北京市', 3, 'BB（2025年4季度）', 218.61,
    '中意财产保险有限公司是2007年4月经中国保险监督管理委员会批准在京成立，由中国石油集团资本有限责任公司和意大利忠利保险有限公司合资组建的全国性合资财产保险公司，注册资本金13亿元人民币。\n中意财险将借助股东优势，以高度职业化的员工队伍，研究和开发各种财产保险产品，为企业和个人客户提供优质的保险产品和服务。公司的业务发展战略是股东业务和市场业务并重，目标是将公司建设成为中国一流的保险公司。', '[]', 1, 99, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中银保险有限公司', '中银保险', 'IC100-ZYBX', '/logos/中银保险有限公司.png',
    'https://www.bankofchina.com/bocins/', '95566', 2005, 450000.00,
    '北京市', 1, 'AAA（2025年3季度）', 410.61,
    '中银保险有限公司是经中国保监会批准设立的全国性财产保险公司，公司成立于2005年1月5日，总部设在北京。公司主要经营财产损失保险；责任保险；信用保险和保证保险；短期健康保险和意外伤害保险；上述业务的再保险业务；', '["国有背景"]', 1, 100, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '众安在线财产保险股份有限公司', '众安在线', 'IC101-ZAZX', '/logos/众安在线财产保险股份有限公司.png',
    'https://www.zhongan.com/', '952299、10109955', 2013, 146981.29,
    '上海市', 2, 'BBB（2025年3季度）', 241.21,
    '众安在线财产保险股份有限公司（以下简称“众安”）是中国首家互联网保险公司，于2013年11月6日揭牌开业，众安总部位于上海，不设任何分支机构，完全通过互联网展业。由“保险+科技”双引擎驱动，众安专注于应用新技术重塑保险价值链，围绕健康、消费金融、汽车、生活消费、航旅五大生态，以科技服务新生代，为其提供个性化、定制化、智能化的新保险。', '["民营"]', 1, 101, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '珠峰财产保险股份有限公司', '珠峰财险', 'IC102-ZFCX', '/logos/珠峰财产保险股份有限公司.png',
    'https://www.zhufengic.com/', '10108848', 2016, 108000.00,
    '北京市', 1, 'B（2025年3季度）', 161.33,
    '经营范围：机动车保险，包括机动车交通事故责任强制保险和机动车商业保险；企业/家庭财产保险及工程保险（特殊风险除外）；责任保险；船舶/货运保险；短期健康/意外伤害保险；上述业务的再保险业务；国家法律、法规允许的保险资金运用业务；经监管机构批准的其他业务。', '[]', 1, 102, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '紫金财产保险股份有限公司', '紫金财险', 'IC103-ZJCX', '/logos/紫金财产保险股份有限公司.png',
    'https://www.zking.com/', '95312', 2009, 600000.00,
    '江苏省南京市', 1, 'AA（2025年4季度）', 323.79,
    '紫金财产保险股份有限公司成立于2009年5月，总部位于南京市，是江苏省首家全国性财产保险公司。作为省财政厅主管的国有大型金融企业，紫金保险在江苏金融四梁八柱体系中占据重要位置。公司以“管理风险，创造价值”为使命，秉承“责任、专业、创新”的理念，倡导“以客户为中心”的经营文化、“绩效优先”的执行文化和“人才优先”的用人文化，实现了高起点组建、远战略规划、全国性布局。', '[]', 1, 103, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '北大方正人寿保险有限公司', '北大方正人寿', 'IC104-BDFZRS', '/logos/北大方正人寿保险有限公司.png',
    'https://www.pkufi.com/', '4008205882', 2002, 458000.00,
    '上海市', 4, 'B（2025年3季度）', 101.12,
    '北大方正人寿保险有限公司是由新方正控股发展有限责任公司、明治安田生命保险相互会社和海尔集团旗下的海尔集团（青岛）金盈控股有限公司联合组建的一家中外合资保险机构，经原中国保险监督管理委员会批准，于2002年11月28日正式成立，总部设立在上海，专为社会大众提供各类人寿、健康和人身意外伤害保险等产品。', '["中外合资"]', 1, 104, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '渤海财产保险股份有限公司', '渤海财险', 'IC105-BHCX', '/logos/渤海财产保险股份有限公司.png',
    'http://www.bpic.com.cn/', '956017', 2005, 197300.00,
    '天津市', 4, 'B（2025年3季度）', 170.51,
    '渤海财产保险股份有限公司由天津的国有骨干企业发起设立，2005年10月18日开业，是首家总部设在天津的全国性财产保险公司。目前，公司拥有24家省级机构，300余家地市级和县级机构，销售服务网络遍及全国，产品涉及机动车辆保险、企业财产保险、工程保险、货物运输保险、责任保险、保证保险、意外伤害保险、短期健康保险等保险产品，能够为客户提供专业、全面的风险保障。', '["中外合资"]', 1, 105, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '鼎和财产保险股份有限公司', '鼎和财险', 'IC106-DHCX', '/logos/鼎和财产保险股份有限公司.png',
    'https://www.edhic.com/', '95393', 2008, 464300.00,
    '深圳市', 1, 'AA（2025年3季度）', 512.41,
    '和财产保险股份有限公司（以下简称“鼎和保险公司”）成立于2008年5月，总部设在深圳。自成立以来，鼎和保险公司持续保持健康发展的良好势头，公司资产、保费规模快速增长，经营效益不断改善，行业影响力逐年提高，连续多年实现保费收入和经营利润双增长，秉持“为更加清洁的美好生活提供专业的风险管理”的使命，充分发挥公司在能源行业、电力保险业务方面的专长，全力提升“一站式”综合服务能力，努力向新时代央企产业金融转型升级，以高质量发展服务中国式现代化建设。', '["国有背景"]', 1, 106, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '东吴人寿保险股份有限公司', '东吴人寿', 'IC107-DWRS', '/logos/东吴人寿保险股份有限公司.png',
    'http://www.soochowlife.net/', '95354', 2012, 600000.00,
    '苏州市', 1, 'BBB（2025年3季度）', 169.17,
    '东吴人寿保险股份有限公司成立于2012年5月，总部位于江苏苏州，是国内第一家在地级城市设立的寿险法人机构。公司坚持综合发展，深耕市场需求，全面拓展个险、银保、团险、互联网等销售渠道。立足地方、服务区域。以客户为中心，不断深化“传播健康理念，守护美好生活”的战略使命，树立了“一份承诺、一生呵护”的良好品牌形象。', '[]', 1, 107, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '华海财产保险股份有限公司', '华海财险', 'IC108-HHCX', '/logos/华海财产保险股份有限公司.png',
    'https://www.cnoic.com/', '4000611111', 2014, 120000.00,
    '山东省烟台市', 2, 'B（2025年4季度）', 211.15,
    '华海财产保险股份有限公司于2014年3月21日获原中国保监会批准筹建，2014年12月9日正式开业。华海保险主要股东是沿海地区和海洋领域实力雄厚的实体企业，是一家全国性、综合性财产保险公司。华海保险秉承传统、开拓创新，致力于成为一流的现代保险企业。', '["民营"]', 1, 108, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '华泰人寿保险股份有限公司', '华泰人寿', 'IC109-HTRS', '/logos/华泰人寿保险股份有限公司.png',
    'https://life.ehuatai.com/index.html', '95509', 2005, 431250.00,
    '北京市', 3, 'A（2025年3季度）', 167.43,
    '华泰人寿保险股份有限公司是一家由国内外实力雄厚的金融保险集团和知名企业发起设立的全国性寿险公司，公司于2005年正式开业，总部设在北京。作为华泰保险集团的重要成员，华泰人寿持续聚焦客户、品质、规模和利润四大要素，坚持价值成长之路，依托华泰保险集团其他子公司的市场资源以及业内领先的资产管理能力，利用美国安达集团的全面技术支持，实现了健康、平稳和较快的发展。', '[]', 1, 109, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '平安养老保险股份有限公司', '平安养老', 'IC110-PAYL', '/logos/平安养老保险股份有限公司.png',
    'https://yl.pingan.com/', '95511', 2004, 1160300.00,
    '中国（上海）自由贸易试验区陆家嘴环路1333号12楼、20楼、21楼、24楼，邮编200120市', 2, 'BB（2025年3季度）', 396.97,
    '平安养老保险股份有限公司是平安集团子公司，2004年12月在上海成立,是国内首家专业养老险公司。平安养老险聚焦养老主业，以"专业的养老资产管理机构"为目标，推动养老与健康管理结合，助力国家积极应对老龄化战略。', '["民营"]', 1, 110, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '前海人寿保险股份有限公司', '前海人寿', 'IC111-QHRS', '/logos/前海人寿保险股份有限公司.png',
    'https://www.foresealife.com/index.html', '956099', 2012, 850000.00,
    '深圳市', 2, '', NULL,
    '前海人寿保险股份有限公司成立于2012年2月，是首家总部位于前海蛇口自贸片区的全国性金融保险机构，致力于成为服务领先、值得信赖的保险企业。公司服务客户超550万人，贡献百亿元税收，多年入选“中国企业500强”“中国服务业企业500强”，荣获优秀消费者权益保护保险机构、保险科技创新大奖、卓越养老保险公司、卓越社会责任表现金融机构等多项荣誉。', '["民营"]', 1, 111, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '太平洋健康保险股份有限公司', '太平洋健康', 'IC112-TBALJK', '/logos/太平洋健康保险股份有限公司.png',
    'http://health.cpic.com.cn/', '95500-5', 2014, 360000.00,
    '上海市', 1, 'BBB（2025年3季度）', 215.00,
    '太平洋健康保险股份有限公司成立于2014年12月，是中国太平洋保险（集团）股份有限公司（以下简称“太平洋保险”）旗下专业健康险公司。太平洋保险是国内领先的综合性保险集团，并是首家A+H+G（上海、香港、伦敦）三地上市的保险公司。太平洋健康险以“建设一家科技型医疗健康保险公司”为愿景，以客户为中心，提供数字化的全方位保险支付解决方案及全周期医疗服务，让人们生活更健康。', '["国有背景", "品牌重塑"]', 1, 112, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '泰康养老保险股份有限公司', '泰康养老', 'IC113-TKYL', '/logos/泰康养老保险股份有限公司.png',
    'https://tkyl.taikang.com/', '4006695522', 2007, 900000.00,
    '北京市', 2, 'A（2025年3季度）', 206.99,
    '泰康养老成立于2007年8月，致力于为广大企事业单位及职工群体提供企业/职业年金、团体及个人养老保险、团体及个人健康保险、团体寿险、意外险等服务。作为泰康保险集团旗下的专业养老保险公司，泰康养老长期深度参与我国养老保障体系建设，积累了丰富的养老金管理和养老保险服务经验，打造了市场领先的年金大受托服务模式，并首创职域服务模式，为职工提供一揽子福利医养保障解决方案。', '["民营"]', 1, 113, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '泰山财产保险股份有限公司', '泰山保险', 'IC114-TSBX', '/logos/泰山财产保险股份有限公司.png',
    'https://www.taishanpic.com', '956123', 2011, 270300.00,
    '中国（山东）自由贸易试验区济南片区舜华路1173号市', 1, 'B（2025年4季度）', 346.34,
    '泰山财产保险股份有限公司是首家注册地在山东的全国性保险法人机构，是山东省国资委履行出资人职责直接管理的省管企业，股东为山东高速集团等10家省管国有企业，股东为山东高速集团等10家省管国有企业及德国安顾集团旗下保险子公司安顾财险股份公司。', '[]', 1, 114, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '新华人寿保险股份有限公司', '新华人寿', 'IC115-XHRS', '/logos/新华人寿保险股份有限公司.png',
    'https://www.newchinalife.com/', '95567', 1996, 312000.00,
    '北京市', 1, 'BB（2025年3季度）', 204.41,
    '	\n新华人寿保险股份有限公司成立于1996年9月，总部位于北京市，是一家全国性的大型寿险企业。公司坚持贯彻以人民为中心的价值取向，服务国家战略大局，保障社会民生，服务实体经济，积极践行“以客户为中心”的经营理念，紧抓行业新机遇新变化，全方位加速客户驱动的战略转型，围绕客户全生命周期需求打造多层次产品和服务体系，持续推进各领域专业化、市场化改革，系统化提升公司核心竞争力，推动公司全面高质量发展。\n', '["国有背景"]', 1, 115, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '幸福人寿保险股份有限公司', '幸福人寿', 'IC116-XFRS', '/logos/幸福人寿保险股份有限公司.png',
    'https://www.happyinsurance.com.cn/', '95560', 2007, 1013000.00,
    '北京市', 1, 'B（2025年3季度）', 106.33,
    '幸福人寿保险股份有限公司成立于2007年，是经中国保监会批准的一家全国性寿险公司。幸福人寿属于国有控股企业，股东背景深厚，成立十七年来，公司始终以“为人民创造有保障的幸福生活”为使命，积极履行社会责任，坚持依法合规经营，为客户提供专业、诚信、高效、超值的保险保障服务。', '["国有背景"]', 1, 116, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '英大泰和人寿保险股份有限公司', '英大泰和人寿', 'IC117-YDTHRS', '/logos/英大泰和人寿保险股份有限公司.png',
    'http://www.ydthlife.com/index.shtml', '4000188688', 2007, 400000.00,
    '北京市', 1, 'A（2025年3季度）', 203.25,
    '英大泰和人寿保险股份有限公司，由国家电网有限公司及其所属公司发起，于2007年6月26日在北京注册成立。英大人寿坚持“保险姓保”、回归本源、服务实体、服务电网主业，以完备的保险产品体系，加快构建“保险+服务”模式；全力落实“健康中国”战略，差异特色经营企业补充医疗保险业务，促进商业健康保险深度参与国家电网公司多层次医疗保障制度改革，缓解国网职工“看病贵、就医难、结算繁”等痛点难点；努力打造具有鲜明特色和较高知名度的人寿保险公司，为国家电网公司建设具有中国特色国际领先的能源互联网企业提供坚强保险保障。', '["国有背景"]', 1, 117, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '友邦人寿保险有限公司', '友邦人寿', 'IC118-YBRS', '/logos/友邦人寿保险有限公司.png',
    'https://www.aia.com.cn/zh-cn/index', '400 820 3588', 2020, 377700.00,
    '上海市', 3, 'AAA（2025年3季度）', 307.22,
    '友邦人寿保险有限公司（友邦人寿）获得原中国银保监会批复，将友邦保险有限公司上海分公司改建为独资人身保险公司，于2020年7月9日正式成立。公司经营范围包括人寿保险、健康保险、意外伤害保险等各类人身保险业务，上述业务的再保险业务，国家法律、法规允许的保险资金运用业务，以及经保险监督管理机构批准的其他业务。', '[]', 1, 118, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中国平安人寿保险股份有限公司', '平安人寿', 'IC119-PARS', '/logos/中国平安人寿保险股份有限公司.png',
    'https://life.pingan.com/index.html', '95511', 2002, 3380000.00,
    '深圳市', 2, 'AA（2025年3季度）', 183.27,
    '中国平安人寿保险股份有限公司成立于2002年，是中国平安保险（集团）股份有限公司旗下的重要成员。公司服务网络遍布全国，向客户提供全周期人身保险产品和服务。以人民为中心，坚定践行高质量发展。公司深入贯彻落实“渠道+产品”改革战略，推动以队伍质量、产品质量、服务质量为核心的各项改革，坚定不移地发展更为均衡的专业化销售渠道，并为客户提供更为适配的产品及服务，打造“省时、省心又省钱”的消费体验，守护消费者美好幸福生活。', '["民营"]', 1, 119, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '太平人寿保险有限公司', '太平人寿', 'IC120-TPRS', '/logos/太平人寿保险有限公司.png',
    'http://life.cntaiping.com/', '95589', 2001, 1003000.00,
    '中国（上海）自由贸易试验区银城中路488号太平金融大厦2801、2803A、2804室，29-33层市', 1, 'A（2025年3季度）', 224.27,
    '中国太平保险集团有限责任公司，简称“中国太平”，于1929年在上海创立，是我国历史上持续经营最为悠久的民族保险品牌，也是我国唯一一家管理总部在境外的中管金融企业。\n中国太平源自太平保险、中国保险、民安保险三大民族品牌，1956年根据国家统一部署，中国保险、太平保险停办国内业务，专营港澳和海外保险业务。1999年所有境外国有保险机构划归中国保险股份有限公司管理。2000年在港交所上市，是我国首家在境外上市的保险企业。2001年以太平品牌在境内复业。2009年统一“中保”“太平”“民安”三大品牌，更名为中国太平保险集团公司。2012年列入中央管理，升格为副部级金融央企。2013年完成重组改制和整体上市，正式更名为中国太平保险集团有限责任公司', '[]', 1, 120, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中宏人寿保险有限公司', '中宏人寿', 'IC121-ZHRS', '/logos/中宏人寿保险有限公司.png',
    'http://www.manulife-sinochem.com', '95383', 1996, 160000.00,
    '上海市', 4, 'AA（2025年3季度）', 213.16,
    '中宏人寿保险有限公司是国内首家中外合资人寿保险公司，由加拿大宏利旗下的宏利人寿保险（国际）有限公司和中国中化集团公司核心成员——中化集团财务有限责任公司合资组建。目前，中宏保险在上海、北京、广东、浙江、江苏、四川、山东、福建、重庆、辽宁、天津、湖北、河北和湖南等地的50多个城市稳步发展，不断迈向全国。中宏保险在中国保险市场深耕经营二十余年，致力于为公众提供稳健可靠、深受信赖和具有远见的保险产品和服务。', '["中外合资"]', 1, 121, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '安心财产保险有限责任公司', '安心财险', 'IC122-AXCX', '/logos/安心财产保险有限责任公司.png',
    'https://www.95303.com/', '95303', 2015, 128500.00,
    '北京市', 2, '', NULL,
    '安心财产保险有限责任公司，全国首批创新型互联网保险公司，于2015年6月26日获得原保监会筹建批文，2016年1月18日正式开业，总部设在北京。坚持“简单的保险”理念，将保险产品条款通俗化、投保自助化、理赔简单化，确保用户看得明白、买得方便、赔得快捷，为客户提供优质的保险产品和极致的服务体验。', '["民营"]', 1, 122, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '鼎诚人寿保险有限责任公司', '鼎诚人寿', 'IC123-DCRS', '/logos/鼎诚人寿保险有限责任公司.png',
    'https://www.dingchenglife.com.cn', '4008-008-008', 2009, 125000.00,
    '北京市', 4, 'BB（2025年1季度）', 117.95,
    '鼎诚人寿保险有限责任公司是一家全国性合资寿险公司，成立于2009年3月，前身为新光海航人寿保险有限责任公司。2018年9月经中国银行保险监督管理委员会批准，鼎诚人寿完成了股权变更及增资，资本实力更加雄厚。鼎诚人寿以“为百姓提供买得起、有保障的寿险产品和服务”为使命，遵从“专业立身、客户为先，奋斗为本”的企业价值观，专注寿险经营，聚焦保险保障。', '["中外合资", "品牌重塑"]', 1, 123, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '东方嘉富人寿保险有限公司', '东方嘉富', 'IC124-ZHRS', '/logos/东方嘉富人寿保险有限公司.png',
    'https://www.sinokorealife.com.cn', '4009-800-800', 2012, 300100.00,
    '浙江省杭州市', 1, 'BB（2025年3季度）', 222.00,
    '', '["品牌重塑"]', 1, 124, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '泰康在线财产保险股份有限公司', '泰康在线', 'IC125-TKZX', '/logos/泰康在线财产保险股份有限公司.png',
    'http://www.tk.cn/', '40000-95522', 2015, 550000.00,
    '北京市', 2, 'BB（2025年3季度）', 187.76,
    '世界500强泰康保险集团的全资子公司，成立于2015年，以“保险+科技“、保险+服务“为主要商业模式，专注于互联网保险业务的创新开拓。秉持让保险更安心、更便捷的理念，致力于开发与医疗健康生态深度融合，与互联网生态完全贴合的保险产品。', '["民营"]', 1, 125, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中国人寿保险股份有限公司', '中国人寿', 'IC126-ZGRS', '/logos/中国人寿保险股份有限公司.png',
    'https://www.e-chinalife.com/', '95519', 2003, 2826500.00,
    '中国北京市', 1, 'AAA（2025年3季度）', 202.31,
    '中国人寿保险股份有限公司是国内寿险行业的龙头企业，总部位于北京, 注册资本282.65亿元人民币。作为《财富》世界500强和世界品牌500强企业——中国人寿保险（集团）公司的核心成员，公司以悠久的历史、雄厚的实力、专业领先的竞争优势及世界知名的品牌赢得了社会广泛客户的信赖，始终占据国内寿险市场领导者的地位，被誉为中国保险业的“中流砥柱”。', '[]', 1, 126, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '易安财产保险股份有限公司', '易安财险', 'IC127-YACX', '/logos/易安财产保险股份有限公司.png',
    'https://www.1an.com/', '4000-121212', 2016, 100000.00,
    '深圳市', 2, '', NULL,
    '易安财产保险股份有限公司是应国家“互联网+”战略浪潮，经保监会批准设立的国内四家专业互联网保险公司之一，2016年2月16日获批开业，注册资本金10亿元，注册地为深圳市。易安保险以用户为中心，秉承 “创新、融合、共享、使命”的核心价值观，致力于运用互联网思维，开发全新场景化保险产品，发展创新型保险业务形态，提供个性化、差异化风险保障方案，打造一家定制安全感的保险公司。', '["民营"]', 1, 127, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '三峡人寿保险股份有限公司', '三峡人寿', 'IC128-SXRS', '/logos/三峡人寿保险股份有限公司.png',
    'http://www.tg-life.com.cn/', '023-96999', 2017, 153700.00,
    '重庆市', 1, 'B（2025年3季度）', 273.46,
    '三峡人寿保险股份有限公司是重庆市委、市政府支持，国务院保险监督管理机构批准设立的全国性保险金融机构，同时也是第一家总部位于重庆的中资寿险公司。公司注册资本金10亿元人民币，股东包括重庆渝富资本运营集团有限公司、重庆高科集团有限公司、新华联控股有限公司、江苏华西同诚投资控股集团有限公司、重庆迪马工业有限责任公司、重庆中科建设（集团）有限公司六家大型企业。业务范围包括普通型保险（包括人寿保险和年金保险）、健康保险、意外伤害保险、分红型保险；上述业务的再保险业务；国家法律、法规允许的保险资金运用业务；国务院保险监督管理机构批准的其他业务。', '["国有背景"]', 1, 128, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '民生人寿保险股份有限公司', '民生保险', 'IC129-MSRS', '/logos/民生人寿保险股份有限公司.png',
    'https://www.minshenglife.com/', '95596', 2002, 600000.00,
    '北京市', 2, 'BBB（2025年3季度）', 146.27,
    '民生人寿保险股份有限公司2003年6月18日正式开业，注册资本金60亿元，建立了覆盖全国重点省市区域的机构服务网络，拥有26家分公司、近700个服务网点、近2万名高素质专业人员，累计服务用户超850万。', '["民营"]', 1, 129, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '农银人寿保险股份有限公司', '农银人寿', 'IC130-NYRS', '/logos/农银人寿保险股份有限公司.png',
    'http://www.abchinalife.cn/', '400-77-95581', 2005, 295000.00,
    '北京市', 1, 'A（2025年3季度）', 174.41,
    '农银人寿保险股份有限公司（简称农银人寿）是由中国农业银行股份有限公司、北京中关村科学城建设股份有限公司等公司强强合作打造，并在国家工商行政管理总局注册的全国性人寿保险公司', '["国有背景", "品牌重塑"]', 1, 130, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '交银人寿保险有限公司', '交银人寿', 'IC131-JYKLRS', '/logos/交银人寿保险有限公司.png',
    'https://www.bocommlife.com/', '4008-211-211', 2000, 510000.00,
    '中国（上海）自由贸易试验区陆家嘴环路333号22-23楼市', 4, 'AA（2025年3季度）', 193.84,
    '交银人寿保险有限公司是经国务院同意、监管部门批准成立的国内首家银行控股寿险公司，是交通银行控股的中外合资保险机构，交银人寿追求价值持续增长，效益优先、兼顾规模，确定了“成为一家在保障型保险服务领域成长性和盈利性居领先地位的公司”的战略目标，拼搏进取、责任立业、创新超越。', '["中外合资", "品牌重塑"]', 1, 131, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '建信人寿保险股份有限公司', '建信人寿', 'IC132-JXRS', '/logos/建信人寿保险股份有限公司.png',
    'https://www.ccb-life.com.cn/', '95331', 1998, 712000.00,
    '上海市', 4, 'BB（2025年3季度）', 125.00,
    '建信人寿保险股份有限公司（“建信人寿”）是中国建设银行股份有限公司控股的人寿保险公司，总部位于上海，是国务院批准的首批银行控股的保险公司之一。', '["中外合资"]', 1, 132, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '大家财产保险有限责任公司', '大家财险', 'IC133-DJCX', '/logos/大家财产保险有限责任公司.png',
    'https://property.djbx.com/', '95569', 2019, 400000.00,
    '深圳市', 1, 'BB（2025年3季度）', 199.77,
    '大家财产保险有限责任公司（以下简称“大家财险”）经中国银行保险监督管理委员会（银保监复〔2019〕785号）于2019年8月21日批复开业，总部设在深圳，注册资本40亿元，大家财险拥有36家分公司，服务网点遍布全国。公司经营各类财产损失保险；责任保险；信用保险和保证保险；短期健康保险和意外伤害保险；上述业务的再保险业务；国家法律、法规允许的保险资金运用业务；经中国银保监会批准的其他业务。', '["国有背景", "品牌重塑"]', 1, 133, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中煤财产保险股份有限公司', '中煤财险', 'IC134-ZMCX', '/logos/中煤财产保险股份有限公司.png',
    'https://www.chinacoal-ins.com/', '400-6536-888', 2008, 122000.00,
    '山西示范区南中环街529号清控创新基地A座22、23层市', 1, 'A（2025年3季度）', 276.31,
    '中煤保险是山西省首家也是唯一一家总部设在太原的全国性财产保险法人机构，成立于2008 年 10 月，经营范围涵盖财产损失险、责任险、农业险等。经过多年发展，已成长为一家优势突出，服务全面的综合性保险公司。', '[]', 1, 134, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '浙商财产保险股份有限公司', '浙商保险', 'IC135-ZSBX', '/logos/浙商财产保险股份有限公司.png',
    'https://www.zsins.com/', '4008-666-777', 2009, 500000.00,
    '杭州市', 1, 'B（2025年3季度）', 225.10,
    '浙商保险是中国企业500强浙江省交通投资集团有限公司的核心成员，由浙江省商业集团有限公司、浙江省能源集团有限公司、雅戈尔集团股份有限公司、正泰集团股份有限公司等规模较大、实力雄厚的综合性集团，与浙江国大集团有限责任公司、浙江勤业建工集团有限公司、苏泊尔集团有限公等市场知度名较高的企业共同组建。', '[]', 1, 135, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '国联人寿保险股份有限公司', '国联人寿', 'IC136-GLRS', '/logos/国联人寿保险股份有限公司.png',
    'https://www.guolian-life.com/index.html', '95570', 2014, 210000.00,
    '无锡市', 1, 'BB（2025年3季度）', 160.68,
    '国联人寿保险股份有限公司成立于2014年12月26日，是经原中国保险监督管理委员会批准成立的全国性寿险公司。公司总部位于江苏无锡。公司开发的产品覆盖人寿保险、年金保险、健康保险、意外伤害保险等多个领域，同时以“便捷、专业、亲和、互动”的服务理念，高效透明的运营体系、完善的销售服务网络为客户提供专业、优质的服务，有效发挥了保险的经济补偿、资金融通和社会管理功能，树立了良好的企业形象。', '[]', 1, 136, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '和泰人寿保险股份有限公司', '和泰人寿', 'IC136-HTRS', '/logos/和泰人寿保险股份有限公司.png',
    'https://www.htlic.com/', '4006665858', 2017, 150000.00,
    '山东省济南市', 2, 'B（2025年3季度）', 121.07,
    '和泰人寿保险股份有限公司）成立于2017年1月24日，由中信国安有限公司、北京居然之家投资控股集团有限公司、深圳市金世纪工程实业有限公司、北京英克必成科技有限公司（腾讯全资子公司）、栾川县金兴矿业有限责任公司、秦皇岛煜明房地产集团有限公司、深圳市合丰泰科技集团有限公司、深圳明香控股集团有限公司8家企业发起设立，和泰人寿致力于打造“互联网优势明显，价值创造能力突出的创新型寿险公司”，坚持互联网渠道和传统渠道双轮驱动，努力为客户提供优质的保险产品和服务。', '["民营"]', 1, 137, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '黄河财产保险股份有限公司', '黄河财险', 'IC137-HHCX', '/logos/黄河财产保险股份有限公司.png',
    'http://www.ypic.cn/', '10100018', 2018, 250000.00,
    '甘肃省兰州市', 1, 'BB（2025年3季度）', 526.97,
    '  黄河财产保险股份有限公司（以下简称黄河财险或公司）经甘肃省委、省政府同意，中国保监会2017年12月29日批准开业，是甘肃省首家全国性法人保险机构。公司注册资本金25亿元，注册地为兰州市，在兰州和北京设立双总部。公司前两年经营区域为甘肃省和北京市，经营范围包括机动车车辆保险、企业/家庭财产保险及工程保险（特殊风险除外）；责任保险；船舶/货运保险；农业保险；信用保证保险；短期健康意外伤害保险；上述业务的再保险业务；国家法律法规允许的保险资金运用业务；经银保监会批准的其他业务。\n　　', '[]', 1, 138, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '大家养老保险股份有限公司', '大家养老', 'IC138-DJYL', '/logos/大家养老保险股份有限公司.png',
    'http://annuity.djbx.com/', '95569-6', 2013, 330000.00,
    '北京市', 1, 'BBB（2025年3季度）', 281.22,
    '大家养老保险股份有限公司是经监管批准设立的全国性养老保险公司，总部设立在北京。公司聚焦第三支柱商业养老保险领域，提供覆盖全生命周期，分阶段、多层次的养老保险+服务整体解决方案，致力于成为有温度的养老保险保障服务商，助力客户实现老有所养、老有所安、老有所乐的品质生活。', '["国有背景"]', 1, 139, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '日本财产保险（中国）有限公司', '日本财险（中国）', 'IC139-RBCX（ZG）', '/logos/日本财产保险（中国）有限公司.png',
    'https://www.sompo-cn.com/cn/', '0411-39663188', 2005, 60000.00,
    '辽宁省大连市', 3, 'BBB（2025年3季度）', 235.60,
    '日本财产保险公司于2005年5月31日，作为日资财险公司率先在中国大陆成立了现地法人公司——日本财产保险(中国)有限公司(由2003年设立的日本财产保险公司大连分公司升格为现地法人公司)。以辽宁省为中心展开业务的同时，公司规模也在逐步顺利扩大。 ', '[]', 1, 140, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '东海航运保险股份有限公司', '东海保险', 'IC140-DHBX', '/logos/东海航运保险股份有限公司.png',
    'https://www.dic-china.com/', '4000009797', 2015, 100000.00,
    '浙江省宁波市', 1, 'BB（2025年3季度）', 208.22,
    '东海航运保险股份有限公司（以下简称“东海保险”）成立于2015年12月，总部设在浙江省宁波市，由中国人民财产保险股份有限公司、宁波舟山港集团有限公司、上海国际港务（集团）股份有限公司、宁波开发投资集团有限公司等共同发起组建，属国内首家航运保险法人机构，是一家全国性、股份制、专业化的国有保险公司。', '[]', 1, 141, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '君龙人寿保险有限公司', '君龙人寿', 'IC141-JLRS', '/logos/君龙人寿保险有限公司.png',
    'http://www.kdlins.com.cn/', '400-666-0123', 2008, 260000.00,
    '厦门市', 1, 'BBB（2025年3季度）', 162.69,
    '君龙人寿于2008年12月17日在厦门正式开业，由《财富》世界500强企业厦门建发集团有限公司和拥有70余年寿险管理经验的台湾人寿保险股份有限公司强强联手合资设立。厦门建发集团有限公司系厦门市属国有独资企业，创立于1980年。现主要业务涵盖供应链运营、城市建设与运营、医疗健康、旅游会展以及新兴产业投资等领域，2021年营业收入超7000亿元人民币，资产总额超6500亿元人民币，已连续多年登榜“《财富》世界500强”', '[]', 1, 142, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中邮人寿保险股份有限公司', '中邮人寿', 'IC142-ZYRS', '/logos/中邮人寿保险股份有限公司.png',
    'https://www.chinapost-life.com/export/index.html', '400-890-9999', 2009, 2866300.00,
    '北京市', 1, 'BB（2025年3季度）', 129.70,
    ' 中邮人寿保险股份有限公司是中国邮政控股的寿险公司，公司总部位于北京，2009年8月4日由中国保险监督管理委员会批准成立，中邮人寿保险股份有限公司充分依托邮政网络和资源，以“服务基层、服务三农”为己任，坚持专业化与特色化并举的原则，以小额保险为切入点，以促进城乡保险业均衡发展为着力点，全力打造一个体系现代化、服务大众化、管理规范化，政府满意、监管放心、百姓欢迎的新型高效商业保险公司。', '[]', 1, 143, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '德华安顾人寿保险有限公司', '德华安顾', 'IC143-DHAG', '/logos/德华安顾人寿保险有限公司.png',
    'https://www.ergo-life.cn/', '400-888-0011', 2013, 224000.00,
    '山东省济南市', 4, 'B（2025年4季度）', 219.25,
    '德华安顾人寿保险ERGO是由山东省国有资产投资控股有限公司与德国安顾集团股份公司、德国安顾人寿保险股份公司共同出资组建的全国性互联网寿险公司。推荐优秀保险理财顾问，并提供健康险、医疗险、人寿险、意外险等险、万能型保险、投资连接型保险等，管理投资领域涉及广泛。', '["中外合资"]', 1, 144, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '三井住友海上火灾保险（中国）有限公司', '三井住友海上', 'IC144-SJZYHS', '/logos/三井住友海上火灾保险（中国）有限公司.png',
    'http://www.ms-ins.com.cn/', '4008-832-836', 2007, 50000.00,
    '中国（上海）自由贸易试验区世纪大道100号上海环球金融中心34-T70市', 3, 'AAA（2025年3季度）', 353.88,
    '三井住友海上火灾保险(中国)有限公司(以下简称“三井住友海上”)是由日本MS&AD保险集团旗下核心企业之一的日本三井住友海上火灾保险株式会社全额出资设立，并于2007年由原三井住友海上上海分公司改制而成的独立法人企业。注册地为中国（上海）自由贸易试验区，公司秉承“通过全球化的保险与金融服务事业，提供安心与安全，为创造富有活力的社会以及地球的健全未来贡献心力”的集团经营理念，目标2030年助力实现“有韧性和可持续发展社会”，并以可持续发展目标（SDGs）为指引，在经营活动中持续创造社会共同价值', '[]', 1, 145, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '新疆前海联合财产保险股份有限公司', '前海财险', 'IC145-QHCX', '/logos/新疆前海联合财产保险股份有限公司.png',
    'https://www.qhins.com/', '4008-110-110', 2016, 100000.00,
    '广东省深圳市', 2, 'C（2025年3季度）', 112.95,
    '新疆前海联合财产保险股份有限公司是经原中国保险监督管理委员会批准设立的全国性财产保险公司，于2016年5月19日开业，公司住所位于新疆乌鲁木齐，营业场所位于深圳。公司股东实力雄厚，管理规范，经营范围涉及金融投资、建筑地产、仓储物流、文化商贸等多产业，经营区域覆盖全国。前海财险始终坚持创新驱动发展，聚集大量管理人才、业务人才、技术人才共谋发展，持续进行产品创新、渠道创新、管理创新，促进公司业务规模、专业能力、市场地位不断提升，努力建设市场化、新型化的一流财产保险公司。', '["民营"]', 1, 146, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '合众财产保险股份有限公司', '合众财险', 'IC146-HZCX', '/logos/合众财产保险股份有限公司.png',
    'http://www.union-ins.cn/', '4000195515', 2015, 100000.00,
    '北京市', 2, 'B（2025年3季度）', 381.28,
    '经营范围：机动车保险，包括机动车交通事故责任强制保险和机动车商业保险；企业/家庭财产保险及工程保险（特殊风险保险除外）；上述业务的再保险业务；国家法律、法规允许的保险资金运用业务；经中国保监会批准的其他业务。', '["民营"]', 1, 147, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '小康人寿保险有限责任公司', '小康人寿', 'IC147-XKRS', '/logos/小康人寿保险有限责任公司.png',
    'https://www.livit-life.com/', '400-815-6688', 2005, 300000.00,
    '上海市', 2, 'BB（2025年3季度）', 265.87,
    '公司于2005年12月在北京成立，2020年12月完成股东变更及增资，经中国银保监会审核批准后正式更名为小康人寿保险有限责任公司，简称“小康人寿”，公司愿景是成为一家受人尊敬的百年险企，公司使命是美满生活的幸福管家，核心价值观为“爱（Love)”、“创新（Innovation)”、“价值（Value)”、“坚持（Insistence)”、“诚实（Truth)”。经营理念为“客户至上、价值共赢、小轻快活、稳健合规”，人才理念为“正直、团结、担当、好奇、思辨”。', '["民营", "品牌重塑"]', 1, 148, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '诚泰财产保险股份有限公司', '诚泰保险', 'IC148-CTBX', '/logos/诚泰财产保险股份有限公司.png',
    'https://www.champion-ic.com/', '4006222888', 2011, 597000.00,
    '云南省昆明市', 1, 'BB（2025年3季度）', 352.00,
    '诚泰财产保险股份有限公司是经原中国保险监督管理委员会批准，于2011年12月31日成立的唯一一家总部设在云南的全国性保险公司，公司主营财产损失保险；责任保险；信用保险和保证保险；短期健康保险和意外伤害保险；上述业务的再保险业务；国家法律法规允许的保险资金运用业务；经批准的其他业务。\n', '[]', 1, 149, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中原农业保险股份有限公司', '中原农险', 'IC149-ZYNX', '/logos/中原农业保险股份有限公司.png',
    'https://www.zyic.com/', '956061/400-66-56789', 2015, 400000.00,
    '河南省郑州市', 1, 'AA（2025年3季度）', 320.12,
    '公司经营范围包括农业保险、财产损失保险、 责任保险、短期健康保险和意外伤害保险、信用保险和保证保险;上述业务的再保险业务;国家法律法规允许的资金运用业务;经中国银保监会批准的其他业务。\n中原农险牢记"尚德聚智、惠农利民"的初心使命，立足于新发展阶段，确立了做中国最懂"三农"保险公司的战略定位，开启了第二个五年规划建设新征程，秉承"专而精、精而强"的发展理念，专心研究"三农"、专业服务"三农"、专注深耕"三农"，打造一流的农业风险管理者、一流的涉农金融服务者、一流的保险科技运用者、一流的管理提升实践者，建设客户信赖、社会尊重、政府满意、员工幸福的保险企业。', '[]', 1, 150, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '国民养老保险股份有限公司', '国民养老', 'IC150-GMYL', '/logos/国民养老保险股份有限公司.png',
    'https://www.guominpension.com', '4001010011', 2022, 1137700.00,
    '北京市', 1, 'AAA（2025年3季度）', 465.19,
    '作为专业性的养老保险经营机构，国民养老保险始终坚持“专业专注、普惠为民”，以个人养老金和商业养老金作为业务发展重点，持续推动保险产品转型升级和服务体系优化完善，提升服务民生保障水平，彰显责任担当，助力第三支柱养老保险发展。', '["国有背景"]', 1, 151, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中国出口信用保险公司', '中国信保', 'IC151-ZGXB', '/logos/中国出口信用保险公司.png',
    '', '', NULL, NULL,
    'NULL', 1, '', NULL,
    '', '["国有背景"]', 1, 152, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '财信吉祥人寿保险股份有限公司', '财信人寿', 'IC152-JXRS', '/logos/财信吉祥人寿保险股份有限公司.png',
    'http://life.hnchasing.com/', '4008003003', 2012, 500000.00,
    '湖南省长沙市', 1, 'BB（2025年3季度）', 166.71,
    '财信吉祥人寿保险股份有限公司（以下简称“公司”）成立于2012年9月，总部位于长沙，是湖南省首家本土保险法人企业。目前，公司已连续四年实现盈利，步入持续盈利与稳健发展通道，正逐步成长为中部地区重要的保险金融主体。公司切实践行“服务大局、服务客户”的使命，不断创新金融保险服务模式，持续提升客户体验，形成了以保障型产品为主，覆盖客户全生命周期的寿险产品体系。', '[]', 1, 153, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '融盛财产保险股份有限公司', '融盛保险', 'IC153-RSBX', '/logos/融盛财产保险股份有限公司.png',
    'http://www.erongsheng.com/', '400-955-6789', 2018, 119500.00,
    '沈阳市', 2, 'BB（2025年3季度）', 464.41,
    '融盛财产保险股份有限公司由东软集团股份有限公司、沈阳新松机器人自动化股份有限公司、辽宁省交通规划设计院有限责任公司、上海弘焜房产经纪有限公司、北方联合出版传媒（集团）股份有限公司和大连汇能投资控股集团有限公司等六家知名企业联合发起设立，于2018年06月29日获得中国银保监会批准开业，注册地为辽宁省沈阳市。是辽宁省唯一一家财产保险法人机构。', '["民营"]', 1, 154, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '长江财产保险股份有限公司', '长江财险', 'IC154-ZJCX', '/logos/长江财产保险股份有限公司.png',
    'https://www.cjbx.com.cn', '400-866-8666', 2011, 279700.00,
    '湖北省武汉市', 1, 'BB（2025年3季度）', 462.70,
    '长江财产保险股份有限公司（简称长江财险）成立于2011年11月18日，总部设在武汉，是湖北省首家全国性法人财产保险公司，由湖北省委、省政府直接管理，长江财险始终坚守“保险姓保”和经济补偿核心职能，防范化解各种风险。', '[]', 1, 155, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '安华农业保险股份有限公司', '安华农业保险', 'IC155-AHNYBX', '/logos/安华农业保险股份有限公司.png',
    'http://www.ahic.com.cn', '95540', 2004, 105750.00,
    '吉林省长春市', 2, 'C（2024年1季度）', 187.00,
    '安华农业保险成立十余年来，始终秉持“根植农村、安身农业、贴近农民、服务三农”的企业宗旨，致力于探索新形势下农业保险的发展道路，在大力开办农业保险的同时，业务涵盖商业性财产保险及团体人身意外保险，形成城乡互补、农商并举的业务格局，年保费规模超过55亿。\n    安华保险拥有强大的服务团队，超过3000名正式员工，全国各级分支机构300多家，为个人客户和企业客户提供各类财险、农险、人身意外伤害保险等服务。', '["民营"]', 1, 156, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '安盛保险(百慕达)有限公司', '安盛保险', 'IC156-ASBX', '/logos/安盛保险(百慕达)有限公司.png',
    'https://www.axa.com.hk/zh/home-insurance-protection/', '852 2802 2812', 1984, NULL,
    '香港铜锣湾勿地臣街1号时代广场2座20楼2001室市', 1, '', NULL,
    '', '[]', 1, 157, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '保诚保险有限公司', '保诚保险', 'IC157-BCBX', '/logos/保诚保险有限公司.png',
    'https://www.prudential.com.hk/tc/', '852 2281 1333', 1964, NULL,
    'NULL', 1, '', NULL,
    '', '[]', 1, 158, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '周大福人寿保险有限公司', '周大福人寿', 'IC158-FTBX', '/logos/周大福人寿保险有限公司.png',
    'https://www.ctflife.com.hk', '4001 347 440', 1985, NULL,
    'NULL', 1, '', NULL,
    '周大福人寿保险有限公司（「周大福人寿」）扎根香港近40年，为周大福创建有限公司的全资附属公司，也是香港最具规模的寿险公司之一。作为周大福企业成员，周大福人寿紧扣郑氏家族（「周大福集团」或「集团」）多元业务体系的雄厚资源，致力为客户及其挚爱家人于「生活、成长、健康、传承」的人生旅程中，提供个人化的匠心规划、终身保障及优质体验。凭借集团财务实力及环球投资布局，周大福人寿矢志成为亚太区领先的保险公司，持续开创保险新价值。', '["品牌重塑"]', 1, 159, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '富卫人寿保险（百慕达）有限公司', '富卫香港', 'IC159-FWXG', '/logos/富卫人寿保险（百慕达）有限公司.png',
    'https://www.fwd.com.hk/zh/', '852 3123 3123', 2013, NULL,
    '香港中环德辅道中308号富卫金融中心28楼市', 1, '', NULL,
    '', '[]', 1, 160, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '友邦保险(国际)有限公司', '友邦国际', 'IC160-YBXG', '/logos/友邦保险(国际)有限公司.png',
    'https://www.aia.com.hk/', '852 2232 8888', 1919, NULL,
    '香港北角电气道183号友邦广场12楼友邦财骏中心市', 1, '', NULL,
    '', '[]', 1, 161, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '宏利人寿保险（国际）有限公司', '宏利香港', 'IC161-HLXG', '/logos/宏利人寿保险（国际）有限公司.png',
    'https://www.manulife.com.hk/zh-hk/individual.html', '852 2510 3941', 1897, NULL,
    '香港九龙观塘伟业街223-231号宏利金融中心A座21楼市', 1, '', NULL,
    '', '[]', 1, 162, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '汇丰人寿保险有限公司', '汇丰人寿', 'IC162-HFRS', '/logos/汇丰人寿保险有限公司.png',
    'https://www.hsbcinsurance.com.cn/', '400-820-8363 ', 2009, 231400.00,
    '中国（上海）自由贸易试验区世纪大道8号汇丰银行大楼20楼2002单元，21楼2101单元市', 1, '', NULL,
    '汇丰人寿保险有限公司(以下简称“本公司”)是在中华人民共和国上海市设立的港澳台法人独资公司，汇丰保险(亚洲)有限公司持有本公司 100%的股权。截至 2022 年 12 月 31 日止，本公司已在北京市、广东省、天津市、深圳市、浙江省分别设立了分公司。', '[]', 1, 163, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中融人寿保险股份有限公司', '中融人寿', 'IC163-ZRRS', '/logos/中融人寿保险股份有限公司.png',
    'http://www.zhongronglife.com/', '400-818-6636', 2010, NULL,
    '北京市', 1, '', NULL,
    '中融人寿保险股份有限公司（以下简称"中融人寿"）是2010年3月18日经中国保险监督管理委员会批准成立的一家全国性人寿保险公司，总部位于北京。股东贵阳金融控股有限公司、中润合创投资有限公司、联合铜箔（惠州）有限公司、深圳市力元资产管理有限公司等多家股东均资金实力雄厚，经营稳健，可为中融人寿的快速持续发展提供有力的保障。 \n\n公司秉持"应变、融和、创新、超越"的经营理念，严格按照现代企业制度规范经营，专注于人寿保险市场的全面拓展，不断探索业务创新和管理创新，通过自身的持续努力，为逐步富裕起来的中国民众提供周全的保险保障服务和专业的理财增值服务；同时，公司也将回馈社会，全力承担社会责任，为创造和谐社会做出应有贡献。 \n', '[]', 1, 164, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '汇丰人寿保险（国际）有限公司', '汇丰人寿（国际）', 'IC164-HFRS（GJ）', '/logos/汇丰人寿保险（国际）有限公司.png',
    '', ' (852) 2233 3000', NULL, NULL,
    'NULL', 1, '', NULL,
    '', '[]', 1, 165, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '富德财产保险股份有限公司', '富德产险', 'IC165-FDCX', '/logos/富德财产保险股份有限公司.png',
    'https://www.fundins.com', '4006695535', 2012, 350000.00,
    '广东省深圳市', 2, 'BB（2025年3季度）', 357.91,
    '富德财产保险股份有限公司（简称“富德产险”）是一家全国性财产保险公司，是富德保险控股股份有限公司旗下成员公司。公司于2012年5月7日开业，总部设在深圳，公司以“成为在财产险细分市场上具有特色竞争力的专业产险公司”为企业愿景，以“为客户提供优质服务，为股东创造卓越价值，为员工创造美好生活，为社会做出应有贡献”为企业使命，追求商业价值、社会价值最大化，积极履行社会责任，持续为中国保险业发展贡献力量。\n', '["民营"]', 1, 166, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中银三星人寿保险有限公司', '中银三星人寿', 'IC166-ZYSXRS', '/logos/中银三星人寿保险有限公司.png',
    'https://www.boc-samsunglife.cn', '4000095566、95566', 2005, 246666.67,
    '北京市', 1, '', NULL,
    '    中银三星人寿保险有限公司（以下简称“公司”）成立于2015年8月，是中国银行旗下的全国性寿险公司，前身是成立于2005年的中航三星人寿保险有限公司。公司总部位于北京，截至2021年末，注册资本人民币24.67亿元，在全国设有14家省级分支机构，主要从事人寿保险、年金保险、健康保险和意外伤害保险等人身保险业务，为客户提供全生命周期的风险保障和财富管理服务。\n\n      公司实力雄厚，由三家信誉卓著的全球知名企业共同出资设立，投资方分别为中银投资资产管理有限公司（中国银行全资子公司）、三星集团成员公司和中国航空集团有限公司。', '[]', 1, 167, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '安达人寿保险有限公司（百慕达注册）', '安达人寿', 'IC167-ADRS', '/logos/安达人寿保险有限公司（百慕达注册）.png',
    '', '+852 2894 9833', NULL, NULL,
    '香港铜锣湾告士打道311号皇室大厦安达人寿大楼35楼市', 1, '', NULL,
    '', '[]', 1, 168, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '现代财产保险（中国）有限公司', '现代财险', 'IC168-XDCX', '/logos/现代财产保险（中国）有限公司.png',
    '', '', NULL, NULL,
    'NULL', 1, '', NULL,
    '', '[]', 1, 169, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '香港大都会人寿保险有限公司', '香港大都会人寿', 'IC169-XGDDHRS', '/logos/香港大都会人寿保险有限公司.png',
    '', '(852) 2199 1000', NULL, NULL,
    'NULL', 1, '', NULL,
    '', '[]', 1, 170, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '忠意人寿（香港）有限公司', '忠意人寿', 'IC170-ZYRS', '/logos/忠意人寿（香港）有限公司.png',
    'https://www.generali.com.hk/ZH_HK/contact_us', '852 2521 0707', NULL, NULL,
    '香港太古城英皇道1111號21樓市', 1, '', NULL,
    '', '[]', 1, 171, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中国人寿保险（海外）股份有限公司', '中国人寿（海外）', 'IC171-ZGRS（HW）', '/logos/中国人寿保险（海外）股份有限公司.png',
    '', '(852) 3999 5519', NULL, NULL,
    '香港湾仔轩尼诗道313号中国人寿大厦地下G2 - G3铺市', 1, '', NULL,
    '', '[]', 1, 172, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '香港永明金融有限公司', '永明金融', 'IC172-YMJR', '/logos/香港永明金融有限公司.png',
    'https://www.sunlife.com.hk/zh-hans/', '(852) 2103 8928', NULL, NULL,
    '香港九龙红磡红鸾道18号祥祺中心A座16楼市', 1, '', NULL,
    '', '[]', 1, 173, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '苏黎世人寿保险（香港）有限公司', '苏黎世保险（香港）', 'IC173-SLSBX（XG）', '/logos/苏黎世人寿保险（香港）有限公司.png',
    'https://www.zurich.com.hk/zh-hk', '+852 2968 2288', NULL, NULL,
    '香港港岛东华兰路18号 港岛东中心25-26楼市', 1, '', NULL,
    '', '[]', 1, 174, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '恒生保险有限公司', '恒生保险', 'IC174-HSBX', '/logos/恒生保险有限公司.png',
    '', '(852) 2288 6699', NULL, NULL,
    '香港九龙深旺道1号汇丰中心1座18楼市', 1, '', NULL,
    '', '[]', 1, 175, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '台新人寿保险股份有限公司', '台新人寿', 'IC175-TXRS', '/logos/台新人寿保险股份有限公司.png',
    'https://www.taishinlife.com.tw/zh-TW', '02-2767-8866', NULL, NULL,
    'NULL', 1, '', NULL,
    '本公司持续关注社会趋势与客户需求，藉由灵活、创新、高价值的商品解决方案及服务，从保障个人与家庭出发，满足人生多元需求，并以穏健经营强化营运绩效，确保保户与员工的最大利益，持续深化永续经营各面向之作为，运用核心职能善尽企业社会责任，展现永续经营的决心与努力。\n展望未来，本公司将秉持「诚信、承诺、创新、合作」的企业核心价值，开发符合客户不同人生阶段需求的保险商品，提供完善多元的金融服务，使客户享受到一站购足的便利优势，期许成为客户心中的智慧好伙伴、最值得信赖与托付的人寿保险公司。', '[]', 1, 176, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中银集团人寿保险有限公司', '中银人寿（香港）', 'IC176-ZYRS（XG）', '/logos/中银集团人寿保险有限公司.png',
    'https://www.boclife.com.hk/tc/', '852 2860 0688', NULL, NULL,
    '香港太古城英皇道1111号13楼市', 1, '', NULL,
    '', '[]', 1, 177, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '新华养老保险股份有限公司', '新华养老', 'IC177-XHYL', '/logos/新华养老保险股份有限公司.png',
    'https://www.newchinapension.com/', '4008155599', 2016, 500000.00,
    '深圳市', 1, '', NULL,
    '', '[]', 1, 178, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '立桥人寿保险有限公司', '立桥人寿', 'IC178-LQRS', '/logos/立桥人寿保险有限公司.png',
    'https://www.wli.com.hk', '852 2830 7500', NULL, NULL,
    '香港上环干诺道中168-200号信德中心招商局大厦11楼1116-1118室市', 1, '', NULL,
    '', '[]', 1, 179, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中国太平保险（香港）有限公司', '中国太平（香港）', 'IC179-ZGTP（XG）', '/logos/中国太平保险（香港）有限公司.png',
    'https://www.hk.cntaiping.com/ttc/', '（+852）3716 1616', NULL, NULL,
    '香港北角京华道18号中国太平金融中心15楼市', 1, '', NULL,
    '', '[]', 1, 180, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '万通保险国际有限公司', '万通保险', 'IC180-WTBX', '/logos/万通保险国际有限公司.png',
    'https://www.yflife.com/', '400 842 3983', NULL, NULL,
    'NULL', 1, '', NULL,
    '', '[]', 1, 181, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '恒安标准人寿(亚洲)有限公司', '恒安标准人寿亚洲', 'IC181-HABZRSYZ', '/logos/恒安标准人寿(亚洲)有限公司.png',
    'https://www.hengansl.com.hk/sc', '852 2169 0300', NULL, NULL,
    '香港鲗鱼涌英皇道979号太古坊林肯大厦十二楼市', 1, '', NULL,
    '', '[]', 1, 182, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '华汇人寿保险股份有限公司', '华汇人寿', 'IC182-HHRS', '/logos/华汇人寿保险股份有限公司.png',
    'https://www.sciclife.com/', '4008-788-788', NULL, 150000.00,
    '沈阳市', 1, '', NULL,
    '', '[]', 1, 183, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '国泰人寿保险股份有限公司', '国泰人寿', 'IC183-GTRS', '/logos/国泰人寿保险股份有限公司.png',
    'https://www.cathaylife.com.tw/cathaylife/', '886-2-55595110', NULL, NULL,
    'NULL', 1, '', NULL,
    '', '[]', 1, 184, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '保泰人寿保险有限公司', '保泰人寿', 'IC184-BTRS', '/logos/保泰人寿保险有限公司.png',
    'https://www.bowtie.com.hk/', '3008 8123', NULL, NULL,
    '香港湾仔皇后大道东 58-64 号帝后商业中心 1 楼市', 1, '', NULL,
    '', '[]', 1, 185, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中国融通财产保险有限公司', '融通财险', 'IC185-RTCX', '/logos/中国融通财产保险有限公司.png',
    'https://www.crtic.com/', '', NULL, 300000.00,
    '上海市', 1, '', NULL,
    '中国融通财产保险有限公司于2022年1月经中国银保监会批准开业，总部设在上海，注册资本30亿元。融通财险坚持 “以客户为中心” 理念，致力于建设成为特色鲜明、优势突出、服务优质的科技赋能型保险公司，服务经济社会高质量发展，提升社会治理和风险管理水平，成为中国融通集团风险管理的主要平台和有效工具，成为集团构建未来金控架构的先行者和孵化器。\n\n', '[]', 1, 186, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '众诚汽车保险股份有限公司', '众诚保险', 'IC186-ZCBX', '/logos/众诚汽车保险股份有限公司.png',
    'https://www.urtrust.com.cn/', '4008-600-600', 2011, NULL,
    '广州市', 1, '', NULL,
    '', '[]', 1, 187, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '国元农业保险股份有限公司', '国元保险', 'IC187-GYBX', '/logos/国元农业保险股份有限公司.png',
    '', '', NULL, NULL,
    'NULL', 1, '', 230.00,
    '', '[]', 1, 188, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '汇友财产相互保险社', '汇友相互', 'IC188-HYXHBX', '/logos/汇友财产相互保险社.png',
    'https://www.heromutual.com/', '400-818-9666', 2017, 60000.00,
    '北京市', 1, 'BBB（2025年3季度）', 671.49,
    '汇友财产相互保险社2017年成立，总部位于北京。汇友相互作为一家相互制保险企业，突出投保人既是消费者也是会员的特点。目前有2万5千多家建工企业投保成为汇友相互的会员，遍布全国近300个地市。相互保险这种组织形式在国际上有数百年历史，会员所有、会员自治的治理结构是其独有的发展优势。', '[]', 1, 189, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '凯基人寿保险股份有限公司', '凯基人寿', 'IC189-KJRS', '/logos/凯基人寿保险股份有限公司.png',
    '', '0800-098-889', NULL, NULL,
    '台北市', 1, '', NULL,
    '', '[]', 1, 190, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中国太平洋保险(香港)有限公司', '太平洋保险(香港)', 'IC190-TPXG', '/logos/中国太平洋保险(香港)有限公司.png',
    'https://hkgi.cpic.com.cn/', ' (852)2541 4338', 1994, NULL,
    ' 香港湾仔港湾道18号中环广场43楼01室市', 1, '', NULL,
    '中国太平洋保险(香港)有限公司 (曾用名：萬利保險有限公司 MANDARIN INSURANCE COMPANY LIMITED) ，成立于1976年，位于香港特别行政区，是一家以从事保险代理公司、保险经纪公司和保险服务公司为主的企业。\n', '[]', 1, 191, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '泰禾人寿保险有限公司', '泰禾人寿', 'IC191-THRS', '/logos/泰禾人寿保险有限公司.png',
    'https://www.tahoelife.com.hk/tl/tc', '(852) 3767 8777', NULL, NULL,
    'NULL', 3, '', NULL,
    '', '["品牌重塑"]', 1, 192, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '阳光农业相互保险公司', '阳光农险', 'IC192-YGNX', '/logos/阳光农业相互保险公司.png',
    'https://www.samic.com.cn/', '400-735-5555', NULL, NULL,
    'NULL', 1, '', NULL,
    '', '[]', 1, 193, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中国人民养老保险有限责任公司', '人民养老', 'IC193-RMYL', '/logos/中国人民养老保险有限责任公司.png',
    'https://www.picc.com/', '010-69000200', 2017, NULL,
    '北京市', 1, '', NULL,
    '', '[]', 1, 194, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '香港人寿保险有限公司', '香港人寿', 'IC194-XGRS', '/logos/香港人寿保险有限公司.png',
    'https://www.hklife.com.hk/sc/about-us/corporate-information/index.html', '2290 2882', NULL, NULL,
    '香港皇后大道中183号中远大厦15楼市', 1, '', NULL,
    '香港人寿保险有限公司（「香港人寿」）于2001年成立，由五间本地金融机构联合组成，包括 亚洲保险有限公司、创兴银行有限公司、招商永隆银行有限公司、华侨银行 (香港) 有限公司及上海商业银行有限公司；各股东均建基于香港，平均服务香港逾50年，根基稳固，实力雄厚。我们主要透过创兴银行、招商永隆银行、华侨银行 (香港) 及上海商业银行的庞大分销网络，约130个分销点，为客户提供快捷方便的一站式保险及理财服务。', '[]', 1, 195, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '深圳比亚迪财产保险有限公司', '比亚迪保险', 'IC195-BYDBX', '/logos/深圳比亚迪财产保险有限公司.png',
    'https://www.bydpcic.com', '4000121212', 2016, 400000.00,
    '深圳市', 1, '', NULL,
    '', '[]', 1, 196, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '全球人寿保险股份有限公司', '全球人寿', 'IC196-QQRS', '/logos/全球人寿保险股份有限公司.png',
    'https://www.transglobe.com.tw/about-concept.html', '', NULL, NULL,
    'NULL', 1, '', NULL,
    '全球人寿自1994年正式在台湾营运，藉由丰富的寿险经验，为台湾保户提供专业的保险规划与服务，陆续于1998年至2001年间，并购美国家庭人寿、全美人寿台湾分公司、安盛国卫在台所有保户及相关业务，2009年中玮一股份有限公司（现中玮德惠股份有限公司）成为全球人寿单一股东，矢志深耕台湾，并于2013年3月概括承受国华人寿全体保户及业务，展现对经营人寿保险事业强烈的决心与企图心。', '[]', 1, 197, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '恒安标准养老保险有限责任公司', '恒安标准养老', 'IC197-HABZYL', '/logos/恒安标准养老保险有限责任公司.png',
    'https://www.haslpension.com/henganyanglao/gkxxpl/jbxx/gsgk/gsjs/index.html', '956069', 2021, 40000.00,
    '天津市', 1, '', NULL,
    '公司经营范围为团体养老保险及年金业务；个人养老保险及年金业务；短期健康保险业务；意外伤害保险业务；上述业务的再保险业务；国家法律、法规允许的保险资金运用业务；受托管理委托人委托的以养老保障为目的的人民币、外币资金；经保险监督管理机构批准的其他业务。', '[]', 1, 198, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '富卫人寿保险（澳门）股份有限公司', '富卫澳门', 'IC198-FWAM', '/logos/富卫人寿保险（澳门）股份有限公司.png',
    'https://www.fwd.com.mo/tc/about/', '（853）8988 6060', NULL, NULL,
    '澳门商业大马路301-355号财神商业中心15楼H室市', 1, '', NULL,
    '富卫澳门为泛亚洲人寿及健康保险公司富卫集团旗下公司。富卫集团服务约三千万名客户，业务遍及亚洲十个市场。富卫澳门提供一系列人寿及医疗保险产品。\n富卫秉持以客为先的方针，利用数码科技，致力为客户带来创新定位、简单易明的产品和简单的保险体验。自2013年成立以来，富卫于部分全球发展最迅速的保险市场营运业务，专注为大众创造保险新体验。', '[]', 1, 199, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '劳合社保险（中国）有限公司', '劳合社中国', 'IC199-LHSZG', '/logos/劳合社保险（中国）有限公司.png',
    'https://www.lloyds.com.cn/#/', '4006152810转2', 2007, 100000.00,
    '中国（上海）自由贸易试验区陆家嘴环路1233号25楼2505-2508单元市', 3, 'A（2025年3季度）', 579.24,
    '劳合社中国是一家经中国监管机构批准，总部位于上海的财产保险公司，参加中国平台的劳合社辛迪加通过在劳合社中国设立的承保部参与中国市场的保险和再保险业务。劳合社中国的承保部可以单独承保，也可以联合其他的承保部以共保的形式承保业务。', '[]', 1, 200, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '新加坡人寿有限公司', '新加坡人寿', 'IC200-XJPRS', '/logos/新加坡人寿有限公司.png',
    'https://singlife.com/en', '（65)68279933', NULL, NULL,
    'NULL', 1, '', NULL,
    '', '[]', 1, 201, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);

INSERT INTO `insurance_company` (
    `company_name`, `company_short_name`, `company_code`, `logo_url`,
    `official_website`, `service_phone`, `established_year`, `registered_capital`,
    `headquarters`, `company_type`, `credit_rating`, `solvency_ratio`,
    `introduction`, `feature_tags`, `cooperation_status`, `sort_order`, `is_hot`,
    `remark`, `created_by`
) VALUES (
    '中路财产保险股份有限公司', '中路保险', 'IC201-ZLBX', '/logos/中路财产保险股份有限公司.png',
    'https://www.zhlic.com.cn', '400-900-1234', 2015, 143900.00,
    '青岛市', 1, 'B（2025年3季度）', 162.52,
    '中路财产保险股份有限公司主营业务包括机动车辆保险、家庭财产保险、企业财产保险、工程保险、责任保险、货物运输保险、船舶保险、意外伤害保险、短期健康保险等，已形成11个大类、288个主险、1074个附加险的产品体系。\n    成立以来，公司积极承担城市保险顾问角色，为政府、经济、民生运行提供全方位支持保障。先后为“上合组织青岛峰会”“海军成立70周年多国海军活动”“跨国公司领导人峰会”等大型活动提供保险保障。参与青岛胶州湾两条海底隧道、胶东国际机场、青岛地铁线路、辽阳路和重庆路快速路等大型城市基础设施项目的保险保障。截至2024年底累计为全社会提供风险保障超47万亿元。经办“青岛市道路交通事故救助基金保险项目”，累计救助困难群众5500余人次，垫付金额2.43亿元，形成的“青岛模式”全省推广；经办青岛市“长期护理保险项目”，服务覆盖300多万人，广受群众好评。', '["国有背景"]', 1, 202, 0,
    '股权结构: \'\', 实际控制人: \'\'', 1
);
