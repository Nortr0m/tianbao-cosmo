package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 产品-责任关联实体
 */
@Data
@TableName("product_responsibility")
public class ProductResponsibility {

    private static final long serialVersionUID = 1L;

    /** 主键ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long id;

    /** 产品ID */
    private Long productId;

    /** 责任项ID */
    private Long itemId;

    /** 是否支持（0-不支持，1-支持） */
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
