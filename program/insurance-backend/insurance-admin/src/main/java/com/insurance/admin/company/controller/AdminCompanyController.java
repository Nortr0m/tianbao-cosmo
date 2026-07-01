package com.insurance.admin.company.controller;

import com.insurance.admin.company.dto.AdminCompanyCreateDTO;
import com.insurance.admin.company.dto.AdminCompanyQueryDTO;
import com.insurance.admin.company.dto.AdminCompanyUpdateDTO;
import com.insurance.admin.company.service.AdminCompanyService;
import com.insurance.admin.company.vo.*;
import com.insurance.common.result.PageResult;
import com.insurance.common.result.Result;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 管理员保险公司Controller
 */
@RestController
@RequestMapping("/api/v1/admin/company")
@RequiredArgsConstructor
public class AdminCompanyController {

    private final AdminCompanyService adminCompanyService;

    /**
     * 分页查询保险公司列表
     */
    @GetMapping("/list")
    public Result<PageResult<AdminCompanyVO>> listCompanies(@Validated AdminCompanyQueryDTO queryDTO) {
        return Result.success(adminCompanyService.listCompanies(queryDTO));
    }

    /**
     * 创建保险公司
     */
    @PostMapping
    public Result<Long> createCompany(@Validated @RequestBody AdminCompanyCreateDTO createDTO) {
        return Result.success(adminCompanyService.createCompany(createDTO));
    }

    /**
     * 更新保险公司
     */
    @PutMapping("/{companyId}")
    public Result<Void> updateCompany(@PathVariable Long companyId,
                                       @RequestBody AdminCompanyUpdateDTO updateDTO) {
        adminCompanyService.updateCompany(companyId, updateDTO);
        return Result.success();
    }

    /**
     * 获取保险公司看板统计
     */
    @GetMapping("/dashboard-stats")
    public Result<CompanyDashboardStatsVO> getDashboardStats() {
        return Result.success(adminCompanyService.getDashboardStats());
    }

    /**
     * 获取保险公司排名
     */
    @GetMapping("/ranking")
    public Result<List<CompanyRankingVO>> getRanking() {
        return Result.success(adminCompanyService.getRanking());
    }

    /**
     * 获取保险公司评级历史
     */
    @GetMapping("/{companyId}/rating-history")
    public Result<List<CompanyRatingHistoryVO>> getRatingHistory(@PathVariable Long companyId) {
        return Result.success(adminCompanyService.getRatingHistory(companyId));
    }

    /**
     * 获取公司统计数据
     */
    @GetMapping("/stats")
    public Result<List<CompanyStatsVO>> getCompanyStats() {
        return Result.success(adminCompanyService.getCompanyStats());
    }

    /**
     * 获取偿付能力分布
     */
    @GetMapping("/solvency-distribution")
    public Result<List<SolvencyDistributionVO>> getSolvencyDistribution() {
        return Result.success(adminCompanyService.getSolvencyDistribution());
    }

    /**
     * 获取风险评级分布
     */
    @GetMapping("/risk-rating-distribution")
    public Result<List<RiskRatingDistributionVO>> getRiskRatingDistribution() {
        return Result.success(adminCompanyService.getRiskRatingDistribution());
    }
}
