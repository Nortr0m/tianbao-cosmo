package com.insurance.admin.company.service;

import com.insurance.admin.company.dto.AdminCompanyCreateDTO;
import com.insurance.admin.company.dto.AdminCompanyQueryDTO;
import com.insurance.admin.company.dto.AdminCompanyUpdateDTO;
import com.insurance.admin.company.vo.*;
import com.insurance.common.result.PageResult;

import java.util.List;

/**
 * 管理员保险公司Service接口
 */
public interface AdminCompanyService {

    /**
     * 分页查询保险公司列表
     *
     * @param queryDTO 查询参数
     * @return 分页结果
     */
    PageResult<AdminCompanyVO> listCompanies(AdminCompanyQueryDTO queryDTO);

    /**
     * 创建保险公司
     *
     * @param createDTO 创建信息
     * @return 公司ID
     */
    Long createCompany(AdminCompanyCreateDTO createDTO);

    /**
     * 更新保险公司
     *
     * @param companyId 公司ID
     * @param updateDTO 更新信息
     */
    void updateCompany(Long companyId, AdminCompanyUpdateDTO updateDTO);

    /**
     * 获取保险公司看板统计
     *
     * @return 统计数据
     */
    CompanyDashboardStatsVO getDashboardStats();

    /**
     * 获取保险公司排名
     *
     * @return 排名列表
     */
    List<CompanyRankingVO> getRanking();

    /**
     * 获取保险公司评级历史
     *
     * @param companyId 公司ID
     * @return 评级历史列表
     */
    List<CompanyRatingHistoryVO> getRatingHistory(Long companyId);

    /**
     * 获取公司统计数据
     *
     * @return 公司统计列表
     */
    List<CompanyStatsVO> getCompanyStats();

    /**
     * 获取偿付能力分布
     *
     * @return 偿付能力分布列表
     */
    List<SolvencyDistributionVO> getSolvencyDistribution();

    /**
     * 获取风险评级分布
     *
     * @return 风险评级分布列表
     */
    List<RiskRatingDistributionVO> getRiskRatingDistribution();
}
