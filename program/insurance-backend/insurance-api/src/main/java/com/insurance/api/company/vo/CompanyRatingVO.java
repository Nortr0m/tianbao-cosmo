package com.insurance.api.company.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 保险公司最新评级VO
 */
@Data
public class CompanyRatingVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 保险公司ID */
    private Long companyId;

    /** 保险公司名称 */
    private String companyName;

    /** 信用评级 */
    private String creditRating;

    /** 综合偿付能力充足率 */
    private BigDecimal solvencyRatio;

    /** 核心偿付能力充足率 */
    private BigDecimal coreSolvencyRatio;

    /** 评级季度 */
    private String ratingQuarter;
}
