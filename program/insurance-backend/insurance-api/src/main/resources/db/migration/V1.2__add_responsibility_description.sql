-- V1.2: 新增责任项描述字段 + 产品简介演示数据

-- 1. 为 responsibility_item 表添加 description 字段
ALTER TABLE responsibility_item ADD COLUMN description VARCHAR(500) DEFAULT NULL COMMENT '责任项描述' AFTER item_name;

-- 2. 为16个系统责任项填充描述
UPDATE responsibility_item SET description = '保障重大疾病，确诊即赔，覆盖28种法定重疾' WHERE item_code = 'CRITICAL_ILLNESS';
UPDATE responsibility_item SET description = '保障中度疾病，按比例赔付，不占重疾保额' WHERE item_code = 'MEDIUM_ILLNESS';
UPDATE responsibility_item SET description = '保障轻度疾病，按比例赔付，不影响中症和重疾保障' WHERE item_code = 'LIGHT_ILLNESS';
UPDATE responsibility_item SET description = '身故时赔付保险金，可选赔保额或赔保费' WHERE item_code = 'DEATH_BENEFIT';
UPDATE responsibility_item SET description = '全残时赔付保险金，保障严重伤残风险' WHERE item_code = 'TOTAL_DISABILITY';
UPDATE responsibility_item SET description = '投保人身故/重疾/中症/轻症时，豁免后续保费，保障继续有效' WHERE item_code = 'WAIVER_OF_PREMIUM_PAYER';
UPDATE responsibility_item SET description = '被保险人罹患轻症/中症/重疾时，豁免后续应交保费' WHERE item_code = 'WAIVER_OF_PREMIUM_INSURED';
UPDATE responsibility_item SET description = '重疾可多次赔付，每次赔付后保单继续有效' WHERE item_code = 'CRITICAL_MULTI_PAY';
UPDATE responsibility_item SET description = '恶性肿瘤（癌症）可额外多次赔付，含复发、转移、新发' WHERE item_code = 'CANCER_MULTI_PAY';
UPDATE responsibility_item SET description = '心脑血管特定疾病可额外多次赔付' WHERE item_code = 'CVD_MULTI_PAY';
UPDATE responsibility_item SET description = '特定年龄前确诊重疾/中症/轻症，额外赔付一定比例保额' WHERE item_code = 'DISEASE_CARE_BONUS';
UPDATE responsibility_item SET description = '少儿特定疾病额外赔付，专为未成年人设计' WHERE item_code = 'CHILD_SPECIFIC_BONUS';
UPDATE responsibility_item SET description = '住院津贴保障，按住院天数给付补贴' WHERE item_code = 'HOSPITAL_ALLOWANCE';
UPDATE responsibility_item SET description = '重症监护室津贴，入住ICU时额外给付' WHERE item_code = 'ICU_ALLOWANCE';
UPDATE responsibility_item SET description = '提供就医绿色通道服务，协助安排专家门诊和住院' WHERE item_code = 'MEDICAL_GREEN_PASS';
UPDATE responsibility_item SET description = '提供二次诊疗意见服务，由顶级专家复核诊断结果' WHERE item_code = 'SECOND_OPINION';
