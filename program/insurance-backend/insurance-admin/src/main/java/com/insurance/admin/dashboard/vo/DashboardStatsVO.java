package com.insurance.admin.dashboard.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 数据看板统计VO
 */
@Data
public class DashboardStatsVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 用户总数 */
    private Long totalUserCount;

    /** 今日新增用户 */
    private Long todayNewUserCount;

    /** VIP用户数量 */
    private Long vipUserCount;

    /** 产品总数 */
    private Long totalProductCount;

    /** 在售产品数量 */
    private Long onSaleProductCount;

    /** 保险公司总数 */
    private Long totalCompanyCount;

    /** 合作中保险公司数量 */
    private Long cooperationCompanyCount;

    /** 卡片模板总数 */
    private Long totalCardTemplateCount;

    /** 卡片模板总使用次数 */
    private Long totalCardUseCount;

    /** VIP订单总数 */
    private Long totalVipOrderCount;

    /** VIP订单总金额 */
    private java.math.BigDecimal totalVipOrderAmount;
}
