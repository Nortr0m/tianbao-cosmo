package com.insurance.api.product.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 产品疾病统计VO
 */
@Data
public class DiseaseStatVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 重疾数量 */
    private Integer criticalCount;

    /** 中症数量 */
    private Integer mediumCount;

    /** 轻症数量 */
    private Integer lightCount;

    /** 法定重疾数量 */
    private Integer statutoryCriticalCount;

    /** 法定轻症数量 */
    private Integer statutoryLightCount;

    /** 高发疾病数量 */
    private Integer highIncidenceCount;
}
