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

    /** 当年红利金额（分红型产品） */
    private BigDecimal annualDividend;
    /** 累积红利（分红型产品） */
    private BigDecimal accumulatedDividend;
    /** 保证部分收益率（分红型产品） */
    private BigDecimal returnRateGuaranteed;
    /** 含红利总现金价值 */
    private BigDecimal totalValueWithDividend;
    /** 年领取金额（年金险） */
    private BigDecimal annualPayout;
    /** 累计领取金额（年金险） */
    private BigDecimal totalReceived;
}
