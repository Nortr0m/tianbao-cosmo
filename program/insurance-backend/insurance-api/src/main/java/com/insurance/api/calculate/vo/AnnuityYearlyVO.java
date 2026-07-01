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
}
