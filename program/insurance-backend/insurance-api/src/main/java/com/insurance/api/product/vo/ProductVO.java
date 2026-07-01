package com.insurance.api.product.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 产品VO
 */
@Data
public class ProductVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 产品ID */
    private Long productId;

    /** 产品名称 */
    private String productName;

    /** 产品编码 */
    private String productCode;

    /** 保险公司ID */
    private Long companyId;

    /** 保险公司名称 */
    private String companyName;

    /** 产品类型（1-重疾险，2-增额终身寿险，3-年金险） */
    private Integer productType;

    /** 产品类型描述 */
    private String productTypeDesc;

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

    /** 维护状态（0-解析中，1-待人工确认，2-已确认，3-下线） */
    private Integer maintenanceStatus;

    /** 子类型（1-分红型，2-固收型，3-传统型） */
    private Integer subType;

    /** 是否有保险条款 */
    private Boolean hasTerms;

    /** 是否有产品说明书 */
    private Boolean hasBrochure;

    /** 是否有投保规则 */
    private Boolean hasRules;

    /** 是否有费率表 */
    private Boolean hasRateTable;

    /** 是否有现金价值表 */
    private Boolean hasCashValue;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 子类数据 */
    private Object subProductData;
}
