package com.insurance.api.product.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 疾病VO
 */
@Data
public class DiseaseVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 疾病ID */
    private Long diseaseId;

    /** 疾病名称 */
    private String diseaseName;

    /** 疾病编码 */
    private String diseaseCode;

    /** 疾病类型：1=重疾, 2=中症, 3=轻症 */
    private Integer diseaseType;

    /** 疾病大类：恶性肿瘤、心脑血管、神经系统等 */
    private String diseaseCategory;

    /** ICD-10编码 */
    private String icdCode;

    /** 疾病定义/描述 */
    private String description;

    /** 赔付条件 */
    private String payoutCondition;

    /** 是否高发疾病：0=否, 1=是 */
    private Integer isHighIncidence;

    /** 是否法定疾病：0=否, 1=是 */
    private Integer isStatutory;

    /** 赔付比例（%） */
    private Integer payoutRatio;

    /** 赔付次数 */
    private Integer payoutTimes;

    /** 多次赔付间隔天数 */
    private Integer intervalDays;

    /** 等待期（天） */
    private Integer waitingPeriodDays;

    /** 是否基础责任：0=可选, 1=基础 */
    private Integer isBasic;

    /** 关联的责任项编码 */
    private String responsibilityCode;

    /** 排序 */
    private Integer sortOrder;
}
