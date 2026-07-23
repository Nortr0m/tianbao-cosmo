package com.insurance.api.product.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 产品查询DTO
 */
@Data
public class ProductQueryDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 页码 */
    private Integer pageNum = 1;

    /** 每页数量 */
    private Integer pageSize = 10;

    /** 产品名称 */
    private String productName;

    /** 关键词搜索（产品名模糊匹配） */
    private String keyword;

    /** 保险公司ID */
    private Long companyId;

    /** 产品类型 */
    private Integer productType;

    /** 产品子类型 */
    private Integer subType;

    /** 缴费年限筛选 */
    private String paymentPeriod;

    /** 排序字段 */
    private String sortBy;

    /** 排序方式（asc/desc） */
    private String sortOrder;
}
