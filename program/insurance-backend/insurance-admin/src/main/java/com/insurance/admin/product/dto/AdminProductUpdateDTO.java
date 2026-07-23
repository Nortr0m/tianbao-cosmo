package com.insurance.admin.product.dto;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 管理员更新产品DTO
 */
@Data
public class AdminProductUpdateDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 产品名称 */
    private String productName;

    /** 产品编码 */
    private String productCode;

    /** 保险公司ID */
    private Long companyId;

    /** 产品类型（1-重疾险，2-增额终身寿险，3-年金险） */
    private Integer productType;

    /** 产品子类型 */
    private Integer subType;

    /** 最小投保年龄 */
    private Integer minAge;

    /** 最大投保年龄 */
    private Integer maxAge;

    /** 缴费年限（JSON数组） */
    private String paymentYears;

    /** 职业类别 */
    private Integer occupationClass;

    /** 缴费期间（JSON数组） */
    private String paymentPeriods;

    /** 月缴比例 */
    private BigDecimal monthlyRatio;

    /** 季缴比例 */
    private BigDecimal quarterlyRatio;

    /** 半年缴比例 */
    private BigDecimal halfYearlyRatio;

    /** 销售状态 */
    private Integer saleStatus;

    /** 系统状态 */
    private Integer systemStatus;

    // ===== 增额终身寿险子类字段（productType=2时使用）=====
    /** 减保规则类型（1-20%保额 2-20%已交保费 3-无限制） */
    private Integer reductionRuleType;
    /** 减保起始年限 */
    private Integer reductionStartYear;
    /** 每年减保次数限制（0-不限） */
    private Integer reductionTimesLimit;
    /** 最高加保年龄 */
    private Integer maxAddAge;
    /** 加保费率规则（1-投保时年龄 2-加保时年龄） */
    private Integer addPremiumRule;
    /** 每年加保次数限制（0-不限） */
    private Integer addTimesLimit;
    /** 每次加保比例限制（%） */
    private Integer addRatioLimit;
    /** 保单贷款比例（%） */
    private BigDecimal loanRatio;
    /** 保单贷款利率（%） */
    private BigDecimal loanRate;
    /** 保额年递增比例（%） */
    private BigDecimal increaseRate;
    /** 递增终止年龄 */
    private Integer increaseEndAge;
    /** 支持的减保起始年龄列表（JSON数组） */
    private String supportAgeList;
}
