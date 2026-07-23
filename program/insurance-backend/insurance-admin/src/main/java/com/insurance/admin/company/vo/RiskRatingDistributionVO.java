package com.insurance.admin.company.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 风险评级分布VO
 */
@Data
public class RiskRatingDistributionVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 评级，如 "AAA", "AA+", "AA", "A+", "A", "BBB+", "其他" */
    private String rating;

    /** 数量 */
    private Integer count;
}
