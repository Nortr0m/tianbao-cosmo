package com.insurance.api.calculate.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 年度收益VO
 */
@Data
public class YearlyProjectionVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 保单年度 */
    private Integer policyYear;

    /** 年龄 */
    private Integer age;

    /** 现金价值 */
    private BigDecimal cashValue;

    /** 身故保险金 */
    private BigDecimal deathBenefit;

    /** 累计保费 */
    private BigDecimal totalPremium;

    /** 收益率 */
    private BigDecimal returnRate;

    /** 保证部分现金价值（分红型产品） */
    private BigDecimal cashValueGuaranteed;

    /** 保证部分身故保险金（分红型产品） */
    private BigDecimal deathBenefitGuaranteed;
}
