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

    /** 产品子类型（1=分红型，2=万能型，其他=固收型） */
    private Integer subType;

    /** 保证部分年领取金额（分红型产品） */
    private BigDecimal annualPayoutGuaranteed;

    /** 分红部分年领取金额（分红型产品） */
    private BigDecimal annualPayoutDividend;

    /** 月领取金额（保证部分，分红型产品） */
    private BigDecimal monthlyPayoutGuaranteed;

    /** 月领取金额（分红部分，分红型产品） */
    private BigDecimal monthlyPayoutDividend;
}
