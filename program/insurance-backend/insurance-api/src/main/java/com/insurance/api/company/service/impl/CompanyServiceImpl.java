package com.insurance.api.company.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.insurance.api.company.dto.CompanyQueryDTO;
import com.insurance.api.company.service.CompanyService;
import com.insurance.api.company.vo.CompanyCosmosVO;
import com.insurance.api.company.vo.CompanyRatingVO;
import com.insurance.api.company.vo.CompanyVO;
import com.insurance.api.entity.CompanyRatingHistory;
import com.insurance.api.entity.InsuranceCompany;
import com.insurance.api.mapper.CompanyRatingHistoryMapper;
import com.insurance.api.mapper.InsuranceCompanyMapper;
import com.insurance.common.enums.CompanyTypeEnum;
import com.insurance.common.exception.BusinessException;
import com.insurance.common.result.PageResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 保险公司Service实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CompanyServiceImpl implements CompanyService {

    private final InsuranceCompanyMapper insuranceCompanyMapper;
    private final CompanyRatingHistoryMapper companyRatingHistoryMapper;

    @Override
    public PageResult<CompanyVO> listCompanies(CompanyQueryDTO queryDTO) {
        Page<InsuranceCompany> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        LambdaQueryWrapper<InsuranceCompany> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(InsuranceCompany::getCooperationStatus, 1);

        if (queryDTO.getCompanyName() != null && !queryDTO.getCompanyName().isEmpty()) {
            wrapper.like(InsuranceCompany::getCompanyName, queryDTO.getCompanyName());
        }
        if (queryDTO.getCompanyType() != null) {
            wrapper.eq(InsuranceCompany::getCompanyType, queryDTO.getCompanyType());
        }
        if (queryDTO.getCooperationStatus() != null) {
            wrapper.eq(InsuranceCompany::getCooperationStatus, queryDTO.getCooperationStatus());
        }
        if (queryDTO.getIsHot() != null) {
            wrapper.eq(InsuranceCompany::getIsHot, queryDTO.getIsHot());
        }
        wrapper.orderByAsc(InsuranceCompany::getSortOrder);

        Page<InsuranceCompany> resultPage = insuranceCompanyMapper.selectPage(page, wrapper);
        List<CompanyVO> list = resultPage.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());
        return PageResult.of(resultPage.getCurrent(), resultPage.getSize(), resultPage.getTotal(), list);
    }

    @Override
    public CompanyVO getCompanyDetail(Long companyId) {
        InsuranceCompany company = insuranceCompanyMapper.selectById(companyId);
        if (company == null) {
            throw new BusinessException("保险公司不存在");
        }
        return convertToVO(company);
    }

    @Override
    public CompanyRatingVO getLatestRating(Long companyId) {
        InsuranceCompany company = insuranceCompanyMapper.selectById(companyId);
        if (company == null) {
            throw new BusinessException("保险公司不存在");
        }
        LambdaQueryWrapper<CompanyRatingHistory> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CompanyRatingHistory::getCompanyId, companyId)
                .orderByDesc(CompanyRatingHistory::getPublishDate)
                .last("LIMIT 1");
        CompanyRatingHistory history = companyRatingHistoryMapper.selectOne(wrapper);

        CompanyRatingVO vo = new CompanyRatingVO();
        vo.setCompanyId(companyId);
        vo.setCompanyName(company.getCompanyName());
        if (history != null) {
            vo.setCreditRating(history.getCreditRating());
            vo.setSolvencyRatio(history.getSolvencyRatio());
            vo.setCoreSolvencyRatio(history.getCoreSolvencyRatio());
            vo.setRatingQuarter(history.getRatingQuarter());
        } else {
            vo.setCreditRating(company.getCreditRating());
            vo.setSolvencyRatio(company.getSolvencyRatio());
        }
        return vo;
    }

    @Override
    public List<CompanyVO> getAllCompanies() {
        LambdaQueryWrapper<InsuranceCompany> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(InsuranceCompany::getCooperationStatus, 1)
               .orderByAsc(InsuranceCompany::getSortOrder);
        List<InsuranceCompany> list = insuranceCompanyMapper.selectList(wrapper);
        return list.stream().map(this::convertToVO).collect(Collectors.toList());
    }

    @Override
    public List<CompanyCosmosVO> getCosmosData() {
        List<CompanyCosmosVO> list = insuranceCompanyMapper.selectCosmosData();
        // 处理productTypes字符串转列表
        for (CompanyCosmosVO vo : list) {
            if (vo.getProductTypes() == null) {
                vo.setProductTypes(new java.util.ArrayList<>());
            }
        }
        return list;
    }

    private CompanyVO convertToVO(InsuranceCompany company) {
        CompanyVO vo = new CompanyVO();
        BeanUtils.copyProperties(company, vo);
        CompanyTypeEnum typeEnum = CompanyTypeEnum.getByCode(company.getCompanyType());
        if (typeEnum != null) {
            vo.setCompanyTypeDesc(typeEnum.getDesc());
        }
        return vo;
    }
}
