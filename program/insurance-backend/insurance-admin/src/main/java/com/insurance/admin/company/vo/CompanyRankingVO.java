package com.insurance.admin.company.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 保险公司排名VO
 */
@Data
public class CompanyRankingVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 保险公司ID */
    private Long companyId;

    /** 保险公司名称 */
    private String companyName;

    /** 信用评级 */
    private String creditRating;

    /** 偿付能力充足率 */
    private BigDecimal solvencyRatio;

    /** 注册资本（万元） */
    private BigDecimal registeredCapital;

    /** 合作状态 */
    private Integer cooperationStatus;

    /** 排名 */
    private Integer rank;
}
