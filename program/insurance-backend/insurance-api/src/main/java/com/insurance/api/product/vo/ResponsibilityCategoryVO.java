package com.insurance.api.product.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 责任分类VO
 */
@Data
public class ResponsibilityCategoryVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 分类ID */
    private Long categoryId;

    /** 分类编码 */
    private String categoryCode;

    /** 分类名称 */
    private String categoryName;

    /** 排序 */
    private Integer sortOrder;

    /** 责任项列表 */
    private List<ResponsibilityItemVO> items;
}
