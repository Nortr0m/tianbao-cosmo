package com.insurance.api.product.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 产品简介VO（轻量级，用于虚空捞取等场景快速展示）
 */
@Data
public class ProductBriefVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 产品ID */
    private Long productId;

    /** 产品名称 */
    private String productName;

    /** 产品编码 */
    private String productCode;

    /** 产品类型（1-重疾险，2-增额终身寿，3-年金险） */
    private Integer productType;

    /** 产品类型描述 */
    private String productTypeDesc;

    /** 子类型 */
    private Integer subType;

    /** 公司ID */
    private Long companyId;

    /** 公司名称 */
    private String companyName;

    /** 公司Logo */
    private String companyLogo;

    /** 产品一句话简介 */
    private String productBrief;

    /** 产品亮点 */
    private List<String> productHighlights;

    /** 适合人群 */
    private String suitableFor;

    /** 最低投保年龄 */
    private Integer minAge;

    /** 最高投保年龄 */
    private Integer maxAge;

    /** 缴费年限（JSON数组） */
    private String paymentYears;

    /** 销售状态（1-在售，2-停售） */
    private Integer saleStatus;

    /** 产品标签 */
    private List<String> productTags;

    /** 保障摘要 */
    private String coverageSummary;

    /** 推荐指数（1-5） */
    private Integer recommendationScore;

    /** 简介状态（0-未生成，1-AI生成，2-审核通过，3-人工编辑） */
    private Integer briefStatus;
}
