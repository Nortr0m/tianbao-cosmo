package com.insurance.api.calculate.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * 重疾险保费计算结果VO
 */
@Data
public class CriticalPremiumVO implements Serializable {

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

    /** 保额（万元） */
    private BigDecimal coverage;

    /** 每千元保费 */
    private BigDecimal premiumPerK;

    /** 年缴保费 */
    private BigDecimal annualPremium;

    /** 月缴保费 */
    private BigDecimal monthlyPremium;

    /** 季缴保费 */
    private BigDecimal quarterlyPremium;

    /** 半年缴保费 */
    private BigDecimal halfYearlyPremium;

    /** 总保费 */
    private BigDecimal totalPremium;

    /** 错误信息（费率查询异常时设置） */
    private String errorMessage;

    /** 基础保费（不含可选责任） */
    private BigDecimal basePremium;

    /** 责任系数（总系数，如1.2表示基础保费×1.2） */
    private BigDecimal responsibilityCoefficient;

    /** 保费构成明细 */
    private List<PremiumComponentVO> premiumComponents;
}
