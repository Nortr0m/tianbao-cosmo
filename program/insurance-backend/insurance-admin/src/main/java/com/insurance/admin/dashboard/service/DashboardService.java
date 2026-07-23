package com.insurance.admin.dashboard.service;

import com.insurance.admin.dashboard.vo.CardGenerationVO;
import com.insurance.admin.dashboard.vo.DashboardStatsVO;
import com.insurance.admin.dashboard.vo.ProductDistributionVO;
import com.insurance.admin.dashboard.vo.UserTrendVO;

import java.util.List;

/**
 * 数据看板Service接口
 */
public interface DashboardService {

    /**
     * 获取数据看板统计
     */
    DashboardStatsVO getDashboardStats();

    /**
     * 获取产品类型分布
     */
    List<ProductDistributionVO> getProductDistribution();

    /**
     * 获取用户增长趋势
     */
    List<UserTrendVO> getUserTrend(int days);

    /**
     * 获取卡片生成统计
     */
    List<CardGenerationVO> getCardGenerationStats(int days);
}
