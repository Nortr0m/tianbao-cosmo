package com.insurance.api.company.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 公司关联关系信息VO
 */
@Data
public class CompanyRelationInfoVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 关联关系ID */
    private Long relationId;

    /** 关联公司ID */
    private Long relatedCompanyId;

    /** 关联公司名称 */
    private String relatedCompanyName;

    /** 关联公司简称 */
    private String relatedCompanyShortName;

    /** 关联公司Logo */
    private String relatedCompanyLogo;

    /** 关联类型：1=同一集团, 2=同一股东, 3=母子公司, 4=参股投资, 5=接管重组 */
    private Integer relationType;

    /** 关联类型描述 */
    private String relationTypeDesc;

    /** 关联名称/说明 */
    private String relationName;

    /** 持股比例（如果是参股） */
    private BigDecimal shareRatio;

    /** 关联说明 */
    private String description;
}
