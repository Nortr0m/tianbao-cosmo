package com.insurance.api.compare.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.Map;

/**
 * 对比项VO
 */
@Data
public class CompareItemVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 对比维度编码 */
    private String dimensionCode;

    /** 对比维度名称 */
    private String dimensionName;

    /** 各产品在该维度的值 key: productId, value: 值 */
    private Map<Long, Object> values;
}
