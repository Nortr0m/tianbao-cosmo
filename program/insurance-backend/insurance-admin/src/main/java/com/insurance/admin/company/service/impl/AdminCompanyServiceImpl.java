package com.insurance.admin.company.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.insurance.admin.company.dto.AdminCompanyCreateDTO;
import com.insurance.admin.company.dto.AdminCompanyQueryDTO;
import com.insurance.admin.company.dto.AdminCompanyUpdateDTO;
import com.insurance.admin.company.service.AdminCompanyService;
import com.insurance.admin.company.vo.*;
import com.insurance.api.entity.CompanyRatingHistory;
import com.insurance.api.entity.InsuranceCompany;
import com.insurance.api.entity.ProductBase;
import com.insurance.api.mapper.CompanyRatingHistoryMapper;
import com.insurance.api.mapper.InsuranceCompanyMapper;
import com.insurance.api.mapper.ProductBaseMapper;
import com.insurance.common.enums.CompanyTypeEnum;
import com.insurance.common.exception.BusinessException;
import com.insurance.common.result.PageResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 管理员保险公司Service实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AdminCompanyServiceImpl implements AdminCompanyService {

    private final InsuranceCompanyMapper insuranceCompanyMapper;
    private final CompanyRatingHistoryMapper companyRatingHistoryMapper;
    private final ProductBaseMapper productBaseMapper;

    @Override
    public PageResult<AdminCompanyVO> listCompanies(AdminCompanyQueryDTO queryDTO) {
        Page<InsuranceCompany> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        LambdaQueryWrapper<InsuranceCompany> wrapper = new LambdaQueryWrapper<>();

        if (queryDTO.getCompanyName() != null && !queryDTO.getCompanyName().isEmpty()) {
            wrapper.like(InsuranceCompany::getCompanyName, queryDTO.getCompanyName());
        }
        if (queryDTO.getCompanyType() != null) {
            wrapper.eq(InsuranceCompany::getCompanyType, queryDTO.getCompanyType());
        }
        if (queryDTO.getCooperationStatus() != null) {
            wrapper.eq(InsuranceCompany::getCooperationStatus, queryDTO.getCooperationStatus());
        }
        wrapper.orderByAsc(InsuranceCompany::getSortOrder);

        Page<InsuranceCompany> resultPage = insuranceCompanyMapper.selectPage(page, wrapper);
        List<AdminCompanyVO> list = resultPage.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());
        return PageResult.of(resultPage.getCurrent(), resultPage.getSize(), resultPage.getTotal(), list);
    }

    @Override
    public Long createCompany(AdminCompanyCreateDTO createDTO) {
        InsuranceCompany company = new InsuranceCompany();
        BeanUtils.copyProperties(createDTO, company);
        insuranceCompanyMapper.insert(company);
        return company.getCompanyId();
    }

    @Override
    public void updateCompany(Long companyId, AdminCompanyUpdateDTO updateDTO) {
        InsuranceCompany company = insuranceCompanyMapper.selectById(companyId);
        if (company == null) {
            throw new BusinessException("保险公司不存在");
        }
        BeanUtils.copyProperties(updateDTO, company);
        insuranceCompanyMapper.updateById(company);
    }

    @Override
    public CompanyDashboardStatsVO getDashboardStats() {
        List<InsuranceCompany> all = insuranceCompanyMapper.selectList(null);
        CompanyDashboardStatsVO vo = new CompanyDashboardStatsVO();
        vo.setTotalCount((long) all.size());
        vo.setCooperationCount(all.stream().filter(c -> c.getCooperationStatus() != null && c.getCooperationStatus() == 1).count());
        vo.setTerminatedCount(all.stream().filter(c -> c.getCooperationStatus() != null && c.getCooperationStatus() == 0).count());
        vo.setHotCount(all.stream().filter(c -> c.getIsHot() != null && c.getIsHot() == 1).count());

        BigDecimal avgSolvency = all.stream()
                .filter(c -> c.getSolvencyRatio() != null)
                .map(InsuranceCompany::getSolvencyRatio)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        long solvencyCount = all.stream().filter(c -> c.getSolvencyRatio() != null).count();
        if (solvencyCount > 0) {
            vo.setAvgSolvencyRatio(avgSolvency.divide(BigDecimal.valueOf(solvencyCount), 2, RoundingMode.HALF_UP));
        }

        vo.setStateOwnedCount(all.stream().filter(c -> c.getCompanyType() != null && c.getCompanyType() == 1).count());
        vo.setPrivateCount(all.stream().filter(c -> c.getCompanyType() != null && c.getCompanyType() == 2).count());
        vo.setForeignCount(all.stream().filter(c -> c.getCompanyType() != null && c.getCompanyType() == 3).count());
        vo.setJointVentureCount(all.stream().filter(c -> c.getCompanyType() != null && c.getCompanyType() == 4).count());
        return vo;
    }

    @Override
    public List<CompanyRankingVO> getRanking() {
        LambdaQueryWrapper<InsuranceCompany> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(InsuranceCompany::getSolvencyRatio);
        List<InsuranceCompany> list = insuranceCompanyMapper.selectList(wrapper);
        List<CompanyRankingVO> result = new ArrayList<>();
        int rank = 1;
        for (InsuranceCompany company : list) {
            CompanyRankingVO vo = new CompanyRankingVO();
            vo.setCompanyId(company.getCompanyId());
            vo.setCompanyName(company.getCompanyName());
            vo.setCreditRating(company.getCreditRating());
            vo.setSolvencyRatio(company.getSolvencyRatio());
            vo.setRegisteredCapital(company.getRegisteredCapital());
            vo.setCooperationStatus(company.getCooperationStatus());
            vo.setRank(rank++);
            result.add(vo);
        }
        return result;
    }

    @Override
    public List<CompanyRatingHistoryVO> getRatingHistory(Long companyId) {
        InsuranceCompany company = insuranceCompanyMapper.selectById(companyId);
        if (company == null) {
            throw new BusinessException("保险公司不存在");
        }
        LambdaQueryWrapper<CompanyRatingHistory> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CompanyRatingHistory::getCompanyId, companyId)
                .orderByDesc(CompanyRatingHistory::getPublishDate);
        List<CompanyRatingHistory> list = companyRatingHistoryMapper.selectList(wrapper);
        return list.stream().map(h -> {
            CompanyRatingHistoryVO vo = new CompanyRatingHistoryVO();
            BeanUtils.copyProperties(h, vo);
            return vo;
        }).collect(Collectors.toList());
    }

    @Override
    public List<CompanyStatsVO> getCompanyStats() {
        // 查询所有保险公司
        List<InsuranceCompany> allCompanies = insuranceCompanyMapper.selectList(null);

        // 查询所有产品，按companyId分组统计产品数量
        List<ProductBase> allProducts = productBaseMapper.selectList(null);
        Map<Long, Long> productCountMap = allProducts.stream()
                .filter(p -> p.getCompanyId() != null)
                .collect(Collectors.groupingBy(ProductBase::getCompanyId, Collectors.counting()));

        // 按偿付能力充足率降序排列
        List<InsuranceCompany> sorted = allCompanies.stream()
                .sorted((a, b) -> {
                    BigDecimal ra = a.getSolvencyRatio() != null ? a.getSolvencyRatio() : BigDecimal.ZERO;
                    BigDecimal rb = b.getSolvencyRatio() != null ? b.getSolvencyRatio() : BigDecimal.ZERO;
                    return rb.compareTo(ra);
                })
                .collect(Collectors.toList());

        List<CompanyStatsVO> result = new ArrayList<>();
        int rank = 1;
        for (InsuranceCompany company : sorted) {
            CompanyStatsVO vo = new CompanyStatsVO();
            vo.setCompanyId(company.getCompanyId());
            vo.setCompanyName(company.getCompanyName());
            vo.setTotalProducts(productCountMap.getOrDefault(company.getCompanyId(), 0L).intValue());
            // ProductBase没有保单和保费字段，设为0
            vo.setTotalPolicies(0);
            vo.setTotalPremium(0L);
            vo.setSolvencyRatio(company.getSolvencyRatio());
            vo.setRiskRating(company.getCreditRating());
            vo.setCooperationStatus(company.getCooperationStatus());
            vo.setRanking(rank++);
            result.add(vo);
        }
        return result;
    }

    @Override
    public List<SolvencyDistributionVO> getSolvencyDistribution() {
        List<InsuranceCompany> allCompanies = insuranceCompanyMapper.selectList(null);

        // 定义范围
        String[] ranges = {">200%", "150%-200%", "100%-150%", "<100%"};
        Map<String, Integer> countMap = new LinkedHashMap<>();
        for (String range : ranges) {
            countMap.put(range, 0);
        }

        for (InsuranceCompany company : allCompanies) {
            BigDecimal ratio = company.getSolvencyRatio();
            if (ratio == null) {
                countMap.put("<100%", countMap.get("<100%") + 1);
                continue;
            }
            if (ratio.compareTo(new BigDecimal("200")) > 0) {
                countMap.put(">200%", countMap.get(">200%") + 1);
            } else if (ratio.compareTo(new BigDecimal("150")) > 0) {
                countMap.put("150%-200%", countMap.get("150%-200%") + 1);
            } else if (ratio.compareTo(new BigDecimal("100")) > 0) {
                countMap.put("100%-150%", countMap.get("100%-150%") + 1);
            } else {
                countMap.put("<100%", countMap.get("<100%") + 1);
            }
        }

        List<SolvencyDistributionVO> result = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : countMap.entrySet()) {
            SolvencyDistributionVO vo = new SolvencyDistributionVO();
            vo.setRange(entry.getKey());
            vo.setCount(entry.getValue());
            result.add(vo);
        }
        return result;
    }

    @Override
    public List<RiskRatingDistributionVO> getRiskRatingDistribution() {
        List<InsuranceCompany> allCompanies = insuranceCompanyMapper.selectList(null);

        // 定义评级
        String[] ratings = {"AAA", "AA+", "AA", "A+", "A", "BBB+", "其他"};
        Map<String, Integer> countMap = new LinkedHashMap<>();
        for (String rating : ratings) {
            countMap.put(rating, 0);
        }

        Set<String> knownRatings = new HashSet<>(Arrays.asList(ratings).subList(0, ratings.length - 1));

        for (InsuranceCompany company : allCompanies) {
            String creditRating = company.getCreditRating();
            if (creditRating == null || creditRating.trim().isEmpty()) {
                countMap.put("其他", countMap.get("其他") + 1);
            } else if (knownRatings.contains(creditRating.trim())) {
                countMap.put(creditRating.trim(), countMap.get(creditRating.trim()) + 1);
            } else {
                countMap.put("其他", countMap.get("其他") + 1);
            }
        }

        List<RiskRatingDistributionVO> result = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : countMap.entrySet()) {
            RiskRatingDistributionVO vo = new RiskRatingDistributionVO();
            vo.setRating(entry.getKey());
            vo.setCount(entry.getValue());
            result.add(vo);
        }
        return result;
    }

    private AdminCompanyVO convertToVO(InsuranceCompany company) {
        AdminCompanyVO vo = new AdminCompanyVO();
        BeanUtils.copyProperties(company, vo);
        CompanyTypeEnum typeEnum = CompanyTypeEnum.getByCode(company.getCompanyType());
        if (typeEnum != null) {
            vo.setCompanyTypeDesc(typeEnum.getDesc());
        }
        return vo;
    }
}
