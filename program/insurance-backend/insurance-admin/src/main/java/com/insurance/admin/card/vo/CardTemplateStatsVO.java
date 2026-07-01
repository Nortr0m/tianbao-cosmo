package com.insurance.admin.card.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 卡片模板统计VO
 */
@Data
public class CardTemplateStatsVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 模板总数 */
    private Long totalCount;

    /** 启用数量 */
    private Long activeCount;

    /** 禁用数量 */
    private Long inactiveCount;

    /** 系统模板数量 */
    private Long systemCount;

    /** 推荐模板数量 */
    private Long recommendedCount;

    /** 总使用次数 */
    private Long totalUseCount;

    /** 7日总使用次数 */
    private Long totalUseCount7d;

    /** 30日总使用次数 */
    private Long totalUseCount30d;
}
