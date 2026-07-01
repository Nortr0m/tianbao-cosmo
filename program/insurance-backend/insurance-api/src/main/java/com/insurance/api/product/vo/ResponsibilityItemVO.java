package com.insurance.api.product.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 责任项VO
 */
@Data
public class ResponsibilityItemVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 责任项ID */
    private Long itemId;

    /** 责任项编码 */
    private String itemCode;

    /** 责任项名称 */
    private String itemName;

    /** 是否支持 */
    private Integer isSupported;

    /** 支持的选项（JSON数组） */
    private String supportedOptions;

    /** 默认选项 */
    private String defaultOption;

    /** 保费系数（JSON对象） */
    private String premiumCoefficient;

    /** 排序 */
    private Integer sortOrder;
}
