package com.insurance.admin.company.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 保险公司评级历史VO
 */
@Data
public class CompanyRatingHistoryVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 历史记录ID */
    private Long historyId;

    /** 保险公司ID */
    private Long companyId;

    /** 评级季度（如：2024Q1） */
    private String ratingQuarter;

    /** 信用评级 */
    private String creditRating;

    /** 综合偿付能力充足率 */
    private BigDecimal solvencyRatio;

    /** 核心偿付能力充足率 */
    private BigDecimal coreSolvencyRatio;

    /** 净利润（万元） */
    private BigDecimal netProfit;

    /** 保费收入（万元） */
    private BigDecimal premiumIncome;

    /** 发布日期 */
    private LocalDate publishDate;

    /** 备注 */
    private String remark;
}
