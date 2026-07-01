package com.insurance.api.product.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 产品责任配置VO
 */
@Data
public class ProductResponsibilityVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 产品ID */
    private Long productId;

    /** 产品名称 */
    private String productName;

    /** 责任分类列表 */
    private List<ResponsibilityCategoryVO> categories;
}
