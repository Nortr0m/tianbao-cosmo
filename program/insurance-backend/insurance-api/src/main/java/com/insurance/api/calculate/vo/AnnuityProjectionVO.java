package com.insurance.api.calculate.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * 年金险收益测算结果VO
 */
@Data
public class AnnuityProjectionVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 产品ID */
    private Long productId;

    /** 产品名称 */
    private String productName;

    /** 性别 */
    private Integer gender;

    /** 投保年龄 */
    private Integer age;

    /** 缴费年限 */
    private Integer paymentYear;

    /** 年缴保费 */
    private BigDecimal annualPremium;

    /** 总保费 */
    private BigDecimal totalPremium;

    /** 起始领取年龄 */
    private Integer startAge;

    /** 年领取金额 */
    private BigDecimal annualPayout;

    /** 月领取金额 */
    private BigDecimal monthlyPayout;

    /** 年度收益列表 */
    private List<AnnuityYearlyVO> yearlyProjections;
}
