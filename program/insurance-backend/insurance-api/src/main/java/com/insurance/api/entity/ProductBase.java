package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 产品父类实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("product_base")
public class ProductBase extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 产品ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long productId;

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

    /** 销售状态（0-停售，1-在售） */
    private Integer saleStatus;

    /** 系统状态（0-禁用，1-启用） */
    private Integer systemStatus;

    /** 收益类型(固收型/分红型/万能型) */
    private String yieldType;

    /** 维护状态（0-解析中，1-待人工确认，2-已确认，3-下线） */
    private Integer maintenanceStatus;

    /** 产品一句话简介 */
    private String productBrief;

    /** 产品亮点（JSON数组） */
    private String productHighlights;

    /** 适合人群 */
    private String suitableFor;

    /** 产品详细描述 */
    private String productDescription;

    /** 产品标签（JSON数组） */
    private String productTags;

    /** 保障摘要 */
    private String coverageSummary;

    /** 推荐指数（1-5） */
    private Integer recommendationScore;

    /** 简介状态（0-未生成，1-AI生成，2-审核通过，3-人工编辑） */
    private Integer briefStatus;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;

    /** 创建人 */
    private Long createdBy;

    /** 更新人 */
    private Long updatedBy;

    /** 是否删除（0-未删除，1-已删除） */
    private Integer isDeleted;
}
