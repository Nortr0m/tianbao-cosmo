package com.insurance.admin.dashboard.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 产品类型分布VO
 */
@Data
public class ProductDistributionVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 类型名称 */
    private String name;

    /** 数量 */
    private Long value;
}
