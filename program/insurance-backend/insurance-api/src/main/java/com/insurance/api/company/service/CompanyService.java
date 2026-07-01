package com.insurance.api.company.service;

import com.insurance.api.company.dto.CompanyQueryDTO;
import com.insurance.api.company.vo.CompanyRatingVO;
import com.insurance.api.company.vo.CompanyVO;
import com.insurance.common.result.PageResult;

import java.util.List;

/**
 * 保险公司Service接口
 */
public interface CompanyService {

    /**
     * 分页查询保险公司列表
     *
     * @param queryDTO 查询参数
     * @return 分页结果
     */
    PageResult<CompanyVO> listCompanies(CompanyQueryDTO queryDTO);

    /**
     * 获取保险公司详情
     *
     * @param companyId 保险公司ID
     * @return 保险公司详情
     */
    CompanyVO getCompanyDetail(Long companyId);

    /**
     * 获取保险公司最新评级
     *
     * @param companyId 保险公司ID
     * @return 最新评级信息
     */
    CompanyRatingVO getLatestRating(Long companyId);

    /**
     * 获取所有合作保险公司列表
     *
     * @return 保险公司列表
     */
    List<CompanyVO> getAllCompanies();

    /**
     * 获取保险宇宙首页数据（公司+产品聚合统计）
     *
     * @return 保险宇宙数据
     */
    List<CompanyCosmosVO> getCosmosData();
}
