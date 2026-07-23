package com.insurance.api.calculate.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 年金险年度收益VO
 */
@Data
public class AnnuityYearlyVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 保单年度 */
    private Integer policyYear;

    /** 年龄 */
    private Integer age;

    /** 年领取金额 */
    private BigDecimal annualPayout;

    /** 现金价值 */
    private BigDecimal cashValue;

    /** 身故保险金 */
    private BigDecimal deathBenefit;

    /** 累计领取 */
    private BigDecimal totalReceived;

    /** 保证部分现金价值（分红型产品） */
    private BigDecimal cashValueGuaranteed;

    /** 分红部分现金价值（分红型产品） */
    private BigDecimal dividendCashValue;

    /** 保证部分年领取金额（分红型产品） */
    private BigDecimal annualPayoutGuaranteed;

    /** 分红部分年领取金额（分红型产品） */
    private BigDecimal annualPayoutDividend;

    /** 保证部分身故保险金（分红型产品） */
    private BigDecimal deathBenefitGuaranteed;
}
