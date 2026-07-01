package com.insurance.admin.company.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 保险公司看板统计VO
 */
@Data
public class CompanyDashboardStatsVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 保险公司总数 */
    private Long totalCount;

    /** 合作中数量 */
    private Long cooperationCount;

    /** 已终止数量 */
    private Long terminatedCount;

    /** 热门公司数量 */
    private Long hotCount;

    /** 平均偿付能力充足率 */
    private BigDecimal avgSolvencyRatio;

    /** 国企数量 */
    private Long stateOwnedCount;

    /** 民营数量 */
    private Long privateCount;

    /** 外资数量 */
    private Long foreignCount;

    /** 合资数量 */
    private Long jointVentureCount;
}
