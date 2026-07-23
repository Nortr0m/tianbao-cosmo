package com.insurance.api.company.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.insurance.api.company.dto.CompanyQueryDTO;
import com.insurance.api.company.service.CompanyService;
import com.insurance.api.company.vo.CompanyCosmosVO;
import com.insurance.api.company.vo.CompanyRatingVO;
import com.insurance.api.company.vo.CompanyRelationInfoVO;
import com.insurance.api.company.vo.CompanyVO;
import com.insurance.api.company.vo.ShareholderInfoVO;
import com.insurance.api.entity.CompanyRatingHistory;
import com.insurance.api.entity.CompanyRelation;
import com.insurance.api.entity.CompanyShareholder;
import com.insurance.api.entity.InsuranceCompany;
import com.insurance.api.entity.Shareholder;
import com.insurance.api.mapper.CompanyRatingHistoryMapper;
import com.insurance.api.mapper.CompanyRelationMapper;
import com.insurance.api.mapper.CompanyShareholderMapper;
import com.insurance.api.mapper.InsuranceCompanyMapper;
import com.insurance.api.mapper.ShareholderMapper;
import com.insurance.common.enums.CompanyRelationTypeEnum;
import com.insurance.common.enums.CompanyTypeEnum;
import com.insurance.common.enums.ShareholderTypeEnum;
import com.insurance.common.exception.BusinessException;
import com.insurance.common.result.PageResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
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
    private final ShareholderMapper shareholderMapper;
    private final CompanyShareholderMapper companyShareholderMapper;
    private final CompanyRelationMapper companyRelationMapper;

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
        // 处理productTypes字符串转列表，并填充股东、关联公司和热门产品数据
        for (CompanyCosmosVO vo : list) {
            if (vo.getProductTypes() == null) {
                vo.setProductTypes(new java.util.ArrayList<>());
            }
            // 填充热门产品名称（按创建时间倒序取前6款）
            List<String> productNames = insuranceCompanyMapper.selectProductNamesByCompanyId(vo.getCompanyId(), 6);
            vo.setProductNames(productNames != null ? productNames : new java.util.ArrayList<>());
            // 填充股东数据
            vo.setShareholders(getCompanyShareholders(vo.getCompanyId()));
            // 填充关联公司数据
            vo.setRelations(getCompanyRelations(vo.getCompanyId()));
        }
        return list;
    }

    @Override
    public List<ShareholderInfoVO> getCompanyShareholders(Long companyId) {
        InsuranceCompany company = insuranceCompanyMapper.selectById(companyId);
        if (company == null) {
            throw new BusinessException("保险公司不存在");
        }

        // 查询持股比例>=10%的股东关联关系，按持股比例降序
        LambdaQueryWrapper<CompanyShareholder> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CompanyShareholder::getCompanyId, companyId)
                .ge(CompanyShareholder::getShareRatio, new BigDecimal("10"))
                .orderByDesc(CompanyShareholder::getShareRatio);
        List<CompanyShareholder> relations = companyShareholderMapper.selectList(wrapper);

        if (relations.isEmpty()) {
            return java.util.Collections.emptyList();
        }

        // 批量查询股东信息
        List<Long> shareholderIds = relations.stream()
                .map(CompanyShareholder::getShareholderId)
                .collect(Collectors.toList());
        List<Shareholder> shareholders = shareholderMapper.selectBatchIds(shareholderIds);
        Map<Long, Shareholder> shareholderMap = shareholders.stream()
                .collect(Collectors.toMap(Shareholder::getShareholderId, s -> s));

        // 组装VO
        return relations.stream().map(relation -> {
            ShareholderInfoVO vo = new ShareholderInfoVO();
            Shareholder shareholder = shareholderMap.get(relation.getShareholderId());
            if (shareholder != null) {
                BeanUtils.copyProperties(shareholder, vo);
                ShareholderTypeEnum typeEnum = ShareholderTypeEnum.getByCode(shareholder.getShareholderType());
                if (typeEnum != null) {
                    vo.setShareholderTypeDesc(typeEnum.getDesc());
                }
            }
            vo.setShareRatio(relation.getShareRatio());
            vo.setShareAmount(relation.getShareAmount());
            vo.setShareType(relation.getShareType());
            vo.setIsControlling(relation.getIsControlling());
            vo.setRanking(relation.getRanking());
            return vo;
        }).collect(Collectors.toList());
    }

    @Override
    public List<CompanyRelationInfoVO> getCompanyRelations(Long companyId) {
        InsuranceCompany company = insuranceCompanyMapper.selectById(companyId);
        if (company == null) {
            throw new BusinessException("保险公司不存在");
        }

        // 查询该公司的所有关联关系
        LambdaQueryWrapper<CompanyRelation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CompanyRelation::getCompanyId, companyId)
                .orderByAsc(CompanyRelation::getRelationType);
        List<CompanyRelation> relations = companyRelationMapper.selectList(wrapper);

        if (relations.isEmpty()) {
            return java.util.Collections.emptyList();
        }

        // 批量查询关联公司信息
        List<Long> relatedCompanyIds = relations.stream()
                .map(CompanyRelation::getRelatedCompanyId)
                .collect(Collectors.toList());
        List<InsuranceCompany> relatedCompanies = insuranceCompanyMapper.selectBatchIds(relatedCompanyIds);
        Map<Long, InsuranceCompany> companyMap = relatedCompanies.stream()
                .collect(Collectors.toMap(InsuranceCompany::getCompanyId, c -> c));

        // 组装VO
        return relations.stream().map(relation -> {
            CompanyRelationInfoVO vo = new CompanyRelationInfoVO();
            vo.setRelationId(relation.getId());
            vo.setRelatedCompanyId(relation.getRelatedCompanyId());
            InsuranceCompany relatedCompany = companyMap.get(relation.getRelatedCompanyId());
            if (relatedCompany != null) {
                vo.setRelatedCompanyName(relatedCompany.getCompanyName());
                vo.setRelatedCompanyShortName(relatedCompany.getCompanyShortName());
                vo.setRelatedCompanyLogo(relatedCompany.getLogoUrl());
            }
            vo.setRelationType(relation.getRelationType());
            CompanyRelationTypeEnum typeEnum = CompanyRelationTypeEnum.getByCode(relation.getRelationType());
            if (typeEnum != null) {
                vo.setRelationTypeDesc(typeEnum.getDesc());
            }
            vo.setRelationName(relation.getRelationName());
            vo.setShareRatio(relation.getShareRatio());
            vo.setDescription(relation.getDescription());
            return vo;
        }).collect(Collectors.toList());
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
