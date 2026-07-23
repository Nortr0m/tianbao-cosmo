package com.insurance.api.vip.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * VIP套餐VO
 */
@Data
public class VipPlanVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 套餐ID */
    private Integer planId;

    /** 套餐名称 */
    private String planName;

    /** 会员等级（1-VIP, 2-SVIP） */
    private Integer memberLevel;

    /** 套餐时长（月） */
    private Integer durationMonths;

    /** 价格 */
    private BigDecimal price;

    /** 原价（用于展示划线价） */
    private BigDecimal originalPrice;

    /** 套餐描述 */
    private String description;

    /** 功能特性列表（JSON数组字符串） */
    private String features;

    /** 是否推荐 */
    private Boolean isRecommended;

    /** 排序 */
    private Integer sortOrder;
}
