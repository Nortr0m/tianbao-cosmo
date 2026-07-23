package com.insurance.api.company.controller;

import com.insurance.api.company.dto.CompanyQueryDTO;
import com.insurance.api.company.service.CompanyService;
import com.insurance.api.company.vo.CompanyCosmosVO;
import com.insurance.api.company.vo.CompanyRatingVO;
import com.insurance.api.company.vo.CompanyRelationInfoVO;
import com.insurance.api.company.vo.CompanyVO;
import com.insurance.api.company.vo.ShareholderInfoVO;
import com.insurance.common.result.PageResult;
import com.insurance.common.result.Result;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 保险公司Controller
 */
@RestController
@RequestMapping("/api/v1/company")
@RequiredArgsConstructor
public class CompanyController {

    private final CompanyService companyService;

    /**
     * 分页查询保险公司列表
     */
    @GetMapping("/list")
    public Result<PageResult<CompanyVO>> listCompanies(@Validated CompanyQueryDTO queryDTO) {
        return Result.success(companyService.listCompanies(queryDTO));
    }

    /**
     * 获取保险公司详情
     */
    @GetMapping("/{companyId}")
    public Result<CompanyVO> getCompanyDetail(@PathVariable Long companyId) {
        return Result.success(companyService.getCompanyDetail(companyId));
    }

    /**
     * 获取保险公司最新评级
     */
    @GetMapping("/{companyId}/rating")
    public Result<CompanyRatingVO> getLatestRating(@PathVariable Long companyId) {
        return Result.success(companyService.getLatestRating(companyId));
    }

    /**
     * 获取所有合作保险公司列表
     */
    @GetMapping("/all")
    public Result<List<CompanyVO>> getAllCompanies() {
        return Result.success(companyService.getAllCompanies());
    }

    /**
     * 获取保险宇宙首页数据
     */
    @GetMapping("/cosmos-data")
    public Result<List<CompanyCosmosVO>> getCosmosData() {
        return Result.success(companyService.getCosmosData());
    }

    /**
     * 获取保险公司股东列表（持股比例≥10%，按持股比例降序）
     */
    @GetMapping("/{companyId}/shareholders")
    public Result<List<ShareholderInfoVO>> getCompanyShareholders(@PathVariable Long companyId) {
        return Result.success(companyService.getCompanyShareholders(companyId));
    }

    /**
     * 获取保险公司关联公司列表
     */
    @GetMapping("/{companyId}/relations")
    public Result<List<CompanyRelationInfoVO>> getCompanyRelations(@PathVariable Long companyId) {
        return Result.success(companyService.getCompanyRelations(companyId));
    }
}
