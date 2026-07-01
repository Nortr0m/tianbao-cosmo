package com.insurance.admin.company.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 公司统计VO
 */
@Data
public class CompanyStatsVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 公司ID */
    private Long companyId;

    /** 公司名称 */
    private String companyName;

    /** 产品总数 */
    private Integer totalProducts;

    /** 保单总数 */
    private Integer totalPolicies;

    /** 总保费 */
    private Long totalPremium;

    /** 偿付能力充足率 */
    private java.math.BigDecimal solvencyRatio;

    /** 风险评级 */
    private String riskRating;

    /** 合作状态 */
    private Integer cooperationStatus;

    /** 排名 */
    private Integer ranking;
}
