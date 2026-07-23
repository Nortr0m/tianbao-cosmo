package com.insurance.api.compare.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * 对比结果VO
 */
@Data
public class CompareResultVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 产品基本信息 key: productId */
    private Map<Long, Map<String, Object>> productInfos;

    /** 对比维度列表 */
    private List<CompareItemVO> compareItems;
}
