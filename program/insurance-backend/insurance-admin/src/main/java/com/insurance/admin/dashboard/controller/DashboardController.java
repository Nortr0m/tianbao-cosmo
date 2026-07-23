package com.insurance.admin.dashboard.controller;

import com.insurance.admin.dashboard.service.DashboardService;
import com.insurance.admin.dashboard.vo.CardGenerationVO;
import com.insurance.admin.dashboard.vo.DashboardStatsVO;
import com.insurance.admin.dashboard.vo.ProductDistributionVO;
import com.insurance.admin.dashboard.vo.UserTrendVO;
import com.insurance.common.result.Result;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 数据看板Controller
 */
@RestController
@RequestMapping("/api/v1/admin/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final DashboardService dashboardService;

    /**
     * 获取数据看板统计
     */
    @GetMapping("/stats")
    public Result<DashboardStatsVO> getDashboardStats() {
        return Result.success(dashboardService.getDashboardStats());
    }

    /**
     * 获取产品类型分布
     */
    @GetMapping("/product-distribution")
    public Result<List<ProductDistributionVO>> getProductDistribution() {
        return Result.success(dashboardService.getProductDistribution());
    }

    /**
     * 获取用户增长趋势
     */
    @GetMapping("/user-trend")
    public Result<List<UserTrendVO>> getUserTrend(@RequestParam(defaultValue = "30") int days) {
        return Result.success(dashboardService.getUserTrend(days));
    }

    /**
     * 获取卡片生成统计
     */
    @GetMapping("/card-generation")
    public Result<List<CardGenerationVO>> getCardGenerationStats(@RequestParam(defaultValue = "30") int days) {
        return Result.success(dashboardService.getCardGenerationStats(days));
    }
}
