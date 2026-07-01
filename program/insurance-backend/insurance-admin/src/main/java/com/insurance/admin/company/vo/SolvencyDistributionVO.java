package com.insurance.admin.company.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 偿付能力分布VO
 */
@Data
public class SolvencyDistributionVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 范围，如 ">200%", "150%-200%", "100%-150%", "<100%" */
    private String range;

    /** 数量 */
    private Integer count;
}
