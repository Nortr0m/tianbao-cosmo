package com.insurance.api.product.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.insurance.api.entity.*;
import com.insurance.api.mapper.*;
import com.insurance.api.product.vo.DiseaseStatVO;
import com.insurance.api.product.vo.DiseaseVO;
import com.insurance.api.product.dto.ProductQueryDTO;
import com.insurance.api.product.service.ProductService;
import com.insurance.api.product.service.ProductBriefGeneratorService;
import com.insurance.api.product.vo.*;
import com.insurance.common.exception.BusinessException;
import com.insurance.common.result.PageResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 产品Service实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ProductServiceImpl implements ProductService {

    private final ProductBaseMapper productBaseMapper;
    private final InsuranceCompanyMapper insuranceCompanyMapper;
    private final CriticalIllnessProductMapper criticalIllnessProductMapper;
    private final WholeLifeProductMapper wholeLifeProductMapper;
    private final AnnuityProductMapper annuityProductMapper;
    private final ProductResponsibilityMapper productResponsibilityMapper;
    private final ResponsibilityCategoryMapper responsibilityCategoryMapper;
    private final ResponsibilityItemMapper responsibilityItemMapper;
    private final ProductDocumentStatusMapper productDocumentStatusMapper;
    private final ProductBriefGeneratorService productBriefGeneratorService;
    private final DiseaseMapper diseaseMapper;
    private final ProductDiseaseMapper productDiseaseMapper;
    private final ProductDividendConfigMapper productDividendConfigMapper;

    @Override
    public PageResult<ProductVO> listProducts(ProductQueryDTO queryDTO) {
        Page<ProductBase> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        LambdaQueryWrapper<ProductBase> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductBase::getSystemStatus, 1)
                .in(ProductBase::getSaleStatus, 1, 2)
                .eq(ProductBase::getMaintenanceStatus, 2);

        if (queryDTO.getProductName() != null && !queryDTO.getProductName().isEmpty()) {
            wrapper.like(ProductBase::getProductName, queryDTO.getProductName());
        }
        if (queryDTO.getKeyword() != null && !queryDTO.getKeyword().isEmpty()) {
            wrapper.like(ProductBase::getProductName, queryDTO.getKeyword());
        }
        if (queryDTO.getCompanyId() != null) {
            wrapper.eq(ProductBase::getCompanyId, queryDTO.getCompanyId());
        }
        if (queryDTO.getProductType() != null) {
            wrapper.eq(ProductBase::getProductType, queryDTO.getProductType());
        }
        if (queryDTO.getSubType() != null) {
            wrapper.eq(ProductBase::getSubType, queryDTO.getSubType());
        }
        if (queryDTO.getPaymentPeriod() != null && !queryDTO.getPaymentPeriod().isEmpty()) {
            // payment_years是JSON数组，使用JSON_CONTAINS匹配
            // 第二个参数必须是JSON格式：数字直接写，字符串需要加双引号
            // 外层用单引号包裹作为SQL字符串字面量
            String periodValue = queryDTO.getPaymentPeriod();
            String jsonValue;
            try {
                // 尝试解析为数字
                Integer.parseInt(periodValue);
                jsonValue = "'" + periodValue + "'";
            } catch (NumberFormatException e) {
                jsonValue = "'\"" + periodValue + "\"'";
            }
            wrapper.isNotNull(ProductBase::getPaymentYears)
                    .apply("JSON_CONTAINS(payment_years, " + jsonValue + ")");
        }
        // 排序逻辑：默认按 createdAt DESC
        String sortBy = queryDTO.getSortBy() != null && !queryDTO.getSortBy().isEmpty() ? queryDTO.getSortBy() : "createdAt";
        String sortOrder = queryDTO.getSortOrder() != null && !queryDTO.getSortOrder().isEmpty() ? queryDTO.getSortOrder() : "desc";
        boolean isAsc = "asc".equalsIgnoreCase(sortOrder);
        if ("createdAt".equals(sortBy)) {
            if (isAsc) {
                wrapper.orderByAsc(ProductBase::getCreatedAt);
            } else {
                wrapper.orderByDesc(ProductBase::getCreatedAt);
            }
        } else {
            wrapper.orderByDesc(ProductBase::getCreatedAt);
        }

        Page<ProductBase> resultPage = productBaseMapper.selectPage(page, wrapper);
        List<Long> companyIds = resultPage.getRecords().stream()
                .map(ProductBase::getCompanyId)
                .distinct()
                .collect(Collectors.toList());
        final Map<Long, String> companyNameMap;
        final Map<Long, String> companyLogoMap;
        if (!companyIds.isEmpty()) {
            List<InsuranceCompany> companies = insuranceCompanyMapper.selectBatchIds(companyIds);
            companyNameMap = companies.stream()
                    .collect(Collectors.toMap(InsuranceCompany::getCompanyId, InsuranceCompany::getCompanyName));
            companyLogoMap = companies.stream()
                    .collect(Collectors.toMap(InsuranceCompany::getCompanyId, InsuranceCompany::getLogoUrl));
        } else {
            companyNameMap = new java.util.HashMap<>();
            companyLogoMap = new java.util.HashMap<>();
        }

        List<ProductVO> list = resultPage.getRecords().stream()
                .map(p -> convertToVO(p, companyNameMap.get(p.getCompanyId()), companyLogoMap.get(p.getCompanyId())))
                .collect(Collectors.toList());
        return PageResult.of(resultPage.getCurrent(), resultPage.getSize(), resultPage.getTotal(), list);
    }

    @Override
    public ProductVO getProductDetail(Long productId) {
        ProductBase product = productBaseMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException("产品不存在");
        }
        InsuranceCompany company = insuranceCompanyMapper.selectById(product.getCompanyId());
        String companyName = company != null ? company.getCompanyName() : null;
        String companyLogo = company != null ? company.getLogoUrl() : null;
        ProductVO vo = convertToVO(product, companyName, companyLogo);

        // 查询子类数据
        Object subData = null;
        switch (product.getProductType()) {
            case 1:
                LambdaQueryWrapper<CriticalIllnessProduct> cw = new LambdaQueryWrapper<>();
                cw.eq(CriticalIllnessProduct::getProductId, productId);
                subData = criticalIllnessProductMapper.selectOne(cw);
                break;
            case 2:
                LambdaQueryWrapper<WholeLifeProduct> ww = new LambdaQueryWrapper<>();
                ww.eq(WholeLifeProduct::getProductId, productId);
                subData = wholeLifeProductMapper.selectOne(ww);
                break;
            case 3:
                LambdaQueryWrapper<AnnuityProduct> aw = new LambdaQueryWrapper<>();
                aw.eq(AnnuityProduct::getProductId, productId);
                subData = annuityProductMapper.selectOne(aw);
                break;
            default:
                break;
        }
        vo.setSubProductData(subData);

        // 查询资料完整度
        ProductDocumentStatus docStatus = productDocumentStatusMapper.selectById(productId);
        if (docStatus != null) {
            vo.setHasTerms(docStatus.getHasTerms());
            vo.setHasBrochure(docStatus.getHasBrochure());
            vo.setHasRules(docStatus.getHasRules());
            vo.setHasRateTable(docStatus.getHasRateTable());
            vo.setHasCashValue(docStatus.getHasCashValue());
        }

        // 查询疾病列表和统计（仅重疾险产品）
        if (product.getProductType() != null && product.getProductType() == 1) {
            vo.setDiseases(getProductDiseases(productId, null));
            vo.setDiseaseStat(getDiseaseStat(productId));
        }

        // 查询分红配置
        try {
            LambdaQueryWrapper<ProductDividendConfig> dividendWrapper = new LambdaQueryWrapper<>();
            dividendWrapper.eq(ProductDividendConfig::getProductId, productId);
            ProductDividendConfig dividendConfig = productDividendConfigMapper.selectOne(dividendWrapper);
            if (dividendConfig != null) {
                ProductDividendConfigVO configVO = new ProductDividendConfigVO();
                BeanUtils.copyProperties(dividendConfig, configVO);
                vo.setDividendConfig(configVO);
            }
        } catch (Exception e) {
            log.warn("查询分红配置失败: {}", e.getMessage());
        }

        return vo;
    }

    @Override
    public ProductResponsibilityVO getProductResponsibilities(Long productId) {
        ProductBase product = productBaseMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException("产品不存在");
        }
        ProductResponsibilityVO vo = new ProductResponsibilityVO();
        vo.setProductId(productId);
        vo.setProductName(product.getProductName());

        LambdaQueryWrapper<ProductResponsibility> prWrapper = new LambdaQueryWrapper<>();
        prWrapper.eq(ProductResponsibility::getProductId, productId);
        List<ProductResponsibility> prList = productResponsibilityMapper.selectList(prWrapper);

        if (prList.isEmpty()) {
            vo.setCategories(new ArrayList<>());
            return vo;
        }

        List<Long> itemIds = prList.stream()
                .map(ProductResponsibility::getItemId)
                .distinct()
                .collect(Collectors.toList());
        List<ResponsibilityItem> items = responsibilityItemMapper.selectBatchIds(itemIds);
        Map<Long, ResponsibilityItem> itemMap = items.stream()
                .collect(Collectors.toMap(ResponsibilityItem::getItemId, i -> i));

        List<Long> categoryIds = items.stream()
                .map(ResponsibilityItem::getCategoryId)
                .distinct()
                .collect(Collectors.toList());
        List<ResponsibilityCategory> categories = responsibilityCategoryMapper.selectBatchIds(categoryIds);
        Map<Long, ResponsibilityCategory> categoryMap = categories.stream()
                .collect(Collectors.toMap(ResponsibilityCategory::getCategoryId, c -> c));

        Map<Long, List<ProductResponsibility>> prByCategory = prList.stream()
                .filter(pr -> itemMap.containsKey(pr.getItemId()))
                .collect(Collectors.groupingBy(pr -> itemMap.get(pr.getItemId()).getCategoryId()));

        List<ResponsibilityCategoryVO> categoryVOList = new ArrayList<>();
        for (ResponsibilityCategory category : categories) {
            ResponsibilityCategoryVO cvo = new ResponsibilityCategoryVO();
            cvo.setCategoryId(category.getCategoryId());
            cvo.setCategoryCode(category.getCategoryCode());
            cvo.setCategoryName(category.getCategoryName());
            cvo.setSortOrder(category.getSortOrder());

            List<ProductResponsibility> prs = prByCategory.getOrDefault(category.getCategoryId(), new ArrayList<>());
            List<ResponsibilityItemVO> itemVOList = new ArrayList<>();
            for (ProductResponsibility pr : prs) {
                ResponsibilityItem item = itemMap.get(pr.getItemId());
                if (item == null) continue;
                ResponsibilityItemVO ivo = new ResponsibilityItemVO();
                ivo.setItemId(item.getItemId());
                ivo.setItemCode(item.getItemCode());
                ivo.setItemName(item.getItemName());
                ivo.setDescription(item.getDescription());
                ivo.setIsSupported(pr.getIsSupported());
                ivo.setSupportedOptions(pr.getSupportedOptions());
                ivo.setDefaultOption(pr.getDefaultOption());
                ivo.setPremiumCoefficient(pr.getPremiumCoefficient());
                ivo.setSortOrder(pr.getSortOrder());
                itemVOList.add(ivo);
            }
            itemVOList.sort((a, b) -> {
                int sa = a.getSortOrder() != null ? a.getSortOrder() : 0;
                int sb = b.getSortOrder() != null ? b.getSortOrder() : 0;
                return Integer.compare(sa, sb);
            });
            cvo.setItems(itemVOList);
            categoryVOList.add(cvo);
        }
        categoryVOList.sort((a, b) -> {
            int sa = a.getSortOrder() != null ? a.getSortOrder() : 0;
            int sb = b.getSortOrder() != null ? b.getSortOrder() : 0;
            return Integer.compare(sa, sb);
        });
        vo.setCategories(categoryVOList);
        return vo;
    }

    @Override
    public List<ProductVO> getHotProducts(int limit) {
        LambdaQueryWrapper<ProductBase> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductBase::getSystemStatus, 1)
                .in(ProductBase::getSaleStatus, 1, 2)
                .eq(ProductBase::getMaintenanceStatus, 2)
                .orderByDesc(ProductBase::getCreatedAt)
                .last("LIMIT " + limit);
        List<ProductBase> products = productBaseMapper.selectList(wrapper);
        List<Long> companyIds = products.stream()
                .map(ProductBase::getCompanyId)
                .distinct()
                .collect(Collectors.toList());
        List<InsuranceCompany> companies = insuranceCompanyMapper.selectBatchIds(companyIds);
        Map<Long, String> companyNameMap = companies.stream()
                .collect(Collectors.toMap(InsuranceCompany::getCompanyId, InsuranceCompany::getCompanyName));
        Map<Long, String> companyLogoMap = companies.stream()
                .collect(Collectors.toMap(InsuranceCompany::getCompanyId, InsuranceCompany::getLogoUrl));
        return products.stream()
                .map(p -> convertToVO(p, companyNameMap.get(p.getCompanyId()), companyLogoMap.get(p.getCompanyId())))
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> getProductTypes() {
        List<Map<String, Object>> types = new ArrayList<>();
        Map<String, Object> type1 = new HashMap<>();
        type1.put("value", "critical_illness");
        type1.put("label", "重疾险");
        types.add(type1);
        Map<String, Object> type2 = new HashMap<>();
        type2.put("value", "whole_life");
        type2.put("label", "增额终身寿险");
        types.add(type2);
        Map<String, Object> type3 = new HashMap<>();
        type3.put("value", "annuity");
        type3.put("label", "年金险");
        types.add(type3);
        return types;
    }

    @Override
    public List<ProductVO> searchProducts(String keyword) {
        LambdaQueryWrapper<ProductBase> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductBase::getSystemStatus, 1)
                .in(ProductBase::getSaleStatus, 1, 2)
                .eq(ProductBase::getMaintenanceStatus, 2)
                .like(ProductBase::getProductName, keyword);
        wrapper.orderByDesc(ProductBase::getCreatedAt)
                .last("LIMIT 20");
        List<ProductBase> products = productBaseMapper.selectList(wrapper);
        List<Long> companyIds = products.stream()
                .map(ProductBase::getCompanyId)
                .distinct()
                .collect(Collectors.toList());
        List<InsuranceCompany> companies = insuranceCompanyMapper.selectBatchIds(companyIds);
        Map<Long, String> companyNameMap = companies.stream()
                .collect(Collectors.toMap(InsuranceCompany::getCompanyId, InsuranceCompany::getCompanyName));
        Map<Long, String> companyLogoMap = companies.stream()
                .collect(Collectors.toMap(InsuranceCompany::getCompanyId, InsuranceCompany::getLogoUrl));
        return products.stream()
                .map(p -> convertToVO(p, companyNameMap.get(p.getCompanyId()), companyLogoMap.get(p.getCompanyId())))
                .collect(Collectors.toList());
    }

    private ProductVO convertToVO(ProductBase product, String companyName, String companyLogo) {
        ProductVO vo = new ProductVO();
        BeanUtils.copyProperties(product, vo);
        vo.setCompanyName(companyName);
        vo.setCompanyLogo(companyLogo);
        vo.setSubType(product.getSubType());

        // 解析产品亮点JSON
        if (product.getProductHighlights() != null && !product.getProductHighlights().isEmpty()) {
            try {
                com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                List<String> highlights = mapper.readValue(
                    product.getProductHighlights(),
                    new com.fasterxml.jackson.core.type.TypeReference<List<String>>() {}
                );
                vo.setProductHighlights(highlights);
            } catch (Exception e) {
                // 解析失败时设置为空列表
                vo.setProductHighlights(new java.util.ArrayList<>());
            }
        } else {
            vo.setProductHighlights(new java.util.ArrayList<>());
        }

        switch (product.getProductType()) {
            case 1:
                vo.setProductTypeDesc("重疾险");
                break;
            case 2:
                vo.setProductTypeDesc("增额终身寿险");
                break;
            case 3:
                vo.setProductTypeDesc("年金险");
                break;
            default:
                vo.setProductTypeDesc("未知类型");
                break;
        }
        return vo;
    }

    @Override
    public List<DiseaseVO> getProductDiseases(Long productId, Integer diseaseType) {
        ProductBase product = productBaseMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException("产品不存在");
        }

        LambdaQueryWrapper<ProductDisease> pdWrapper = new LambdaQueryWrapper<>();
        pdWrapper.eq(ProductDisease::getProductId, productId);
        if (diseaseType != null) {
            pdWrapper.eq(ProductDisease::getDiseaseType, diseaseType);
        }
        pdWrapper.orderByAsc(ProductDisease::getDiseaseType, ProductDisease::getSortOrder);
        List<ProductDisease> pdList = productDiseaseMapper.selectList(pdWrapper);

        if (pdList.isEmpty()) {
            // 如果产品没有关联疾病，则从疾病字典表中按产品类型返回默认疾病列表
            return getDefaultDiseasesByProductType(product.getProductType(), diseaseType);
        }

        List<Long> diseaseIds = pdList.stream()
                .map(ProductDisease::getDiseaseId)
                .distinct()
                .collect(Collectors.toList());
        List<Disease> diseases = diseaseMapper.selectBatchIds(diseaseIds);
        Map<Long, Disease> diseaseMap = diseases.stream()
                .collect(Collectors.toMap(Disease::getDiseaseId, d -> d));

        return pdList.stream()
                .filter(pd -> diseaseMap.containsKey(pd.getDiseaseId()))
                .map(pd -> convertToDiseaseVO(diseaseMap.get(pd.getDiseaseId()), pd))
                .collect(Collectors.toList());
    }

    @Override
    public DiseaseStatVO getDiseaseStat(Long productId) {
        ProductBase product = productBaseMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException("产品不存在");
        }

        DiseaseStatVO stat = new DiseaseStatVO();

        LambdaQueryWrapper<ProductDisease> pdWrapper = new LambdaQueryWrapper<>();
        pdWrapper.eq(ProductDisease::getProductId, productId);
        List<ProductDisease> pdList = productDiseaseMapper.selectList(pdWrapper);

        if (pdList.isEmpty()) {
            // 如果产品没有关联疾病，则从疾病字典表中按产品类型统计
            return getDefaultDiseaseStat(product.getProductType());
        }

        List<Long> diseaseIds = pdList.stream()
                .map(ProductDisease::getDiseaseId)
                .distinct()
                .collect(Collectors.toList());
        List<Disease> diseases = diseaseMapper.selectBatchIds(diseaseIds);
        Map<Long, Disease> diseaseMap = diseases.stream()
                .collect(Collectors.toMap(Disease::getDiseaseId, d -> d));

        int criticalCount = 0;
        int mediumCount = 0;
        int lightCount = 0;
        int statutoryCriticalCount = 0;
        int statutoryLightCount = 0;
        int highIncidenceCount = 0;

        for (ProductDisease pd : pdList) {
            Disease disease = diseaseMap.get(pd.getDiseaseId());
            if (disease == null) continue;
            Integer type = pd.getDiseaseType() != null ? pd.getDiseaseType() : disease.getDiseaseType();
            if (type == null) continue;
            switch (type) {
                case 1:
                    criticalCount++;
                    if (disease.getIsStatutory() != null && disease.getIsStatutory() == 1) {
                        statutoryCriticalCount++;
                    }
                    break;
                case 2:
                    mediumCount++;
                    break;
                case 3:
                    lightCount++;
                    if (disease.getIsStatutory() != null && disease.getIsStatutory() == 1) {
                        statutoryLightCount++;
                    }
                    break;
                default:
                    break;
            }
            if (disease.getIsHighIncidence() != null && disease.getIsHighIncidence() == 1) {
                highIncidenceCount++;
            }
        }

        stat.setCriticalCount(criticalCount);
        stat.setMediumCount(mediumCount);
        stat.setLightCount(lightCount);
        stat.setStatutoryCriticalCount(statutoryCriticalCount);
        stat.setStatutoryLightCount(statutoryLightCount);
        stat.setHighIncidenceCount(highIncidenceCount);

        return stat;
    }

    /**
     * 从疾病字典表获取默认疾病列表（当产品未配置疾病关联时使用）
     */
    private List<DiseaseVO> getDefaultDiseasesByProductType(Integer productType, Integer diseaseType) {
        // 仅重疾险产品返回疾病数据
        if (productType == null || productType != 1) {
            return new ArrayList<>();
        }

        LambdaQueryWrapper<Disease> wrapper = new LambdaQueryWrapper<>();
        if (diseaseType != null) {
            wrapper.eq(Disease::getDiseaseType, diseaseType);
        }
        wrapper.orderByAsc(Disease::getDiseaseType, Disease::getSortOrder);
        List<Disease> diseases = diseaseMapper.selectList(wrapper);

        return diseases.stream()
                .map(this::convertToDiseaseVO)
                .collect(Collectors.toList());
    }

    /**
     * 从疾病字典表获取默认疾病统计（当产品未配置疾病关联时使用）
     */
    private DiseaseStatVO getDefaultDiseaseStat(Integer productType) {
        DiseaseStatVO stat = new DiseaseStatVO();
        // 仅重疾险产品返回疾病数据
        if (productType == null || productType != 1) {
            stat.setCriticalCount(0);
            stat.setMediumCount(0);
            stat.setLightCount(0);
            stat.setStatutoryCriticalCount(0);
            stat.setStatutoryLightCount(0);
            stat.setHighIncidenceCount(0);
            return stat;
        }

        LambdaQueryWrapper<Disease> criticalWrapper = new LambdaQueryWrapper<>();
        criticalWrapper.eq(Disease::getDiseaseType, 1);
        int criticalCount = Math.toIntExact(diseaseMapper.selectCount(criticalWrapper));

        LambdaQueryWrapper<Disease> mediumWrapper = new LambdaQueryWrapper<>();
        mediumWrapper.eq(Disease::getDiseaseType, 2);
        int mediumCount = Math.toIntExact(diseaseMapper.selectCount(mediumWrapper));

        LambdaQueryWrapper<Disease> lightWrapper = new LambdaQueryWrapper<>();
        lightWrapper.eq(Disease::getDiseaseType, 3);
        int lightCount = Math.toIntExact(diseaseMapper.selectCount(lightWrapper));

        LambdaQueryWrapper<Disease> statutoryCriticalWrapper = new LambdaQueryWrapper<>();
        statutoryCriticalWrapper.eq(Disease::getDiseaseType, 1)
                .eq(Disease::getIsStatutory, 1);
        int statutoryCriticalCount = Math.toIntExact(diseaseMapper.selectCount(statutoryCriticalWrapper));

        LambdaQueryWrapper<Disease> statutoryLightWrapper = new LambdaQueryWrapper<>();
        statutoryLightWrapper.eq(Disease::getDiseaseType, 3)
                .eq(Disease::getIsStatutory, 1);
        int statutoryLightCount = Math.toIntExact(diseaseMapper.selectCount(statutoryLightWrapper));

        LambdaQueryWrapper<Disease> highIncidenceWrapper = new LambdaQueryWrapper<>();
        highIncidenceWrapper.eq(Disease::getIsHighIncidence, 1);
        int highIncidenceCount = Math.toIntExact(diseaseMapper.selectCount(highIncidenceWrapper));

        stat.setCriticalCount(criticalCount);
        stat.setMediumCount(mediumCount);
        stat.setLightCount(lightCount);
        stat.setStatutoryCriticalCount(statutoryCriticalCount);
        stat.setStatutoryLightCount(statutoryLightCount);
        stat.setHighIncidenceCount(highIncidenceCount);

        return stat;
    }

    /**
     * 将疾病实体+产品疾病关联转换为疾病VO
     */
    private DiseaseVO convertToDiseaseVO(Disease disease, ProductDisease pd) {
        DiseaseVO vo = new DiseaseVO();
        BeanUtils.copyProperties(disease, vo);
        // 产品级别的配置优先
        if (pd.getDiseaseType() != null) {
            vo.setDiseaseType(pd.getDiseaseType());
        }
        vo.setPayoutRatio(pd.getPayoutRatio());
        vo.setPayoutTimes(pd.getPayoutTimes());
        vo.setIntervalDays(pd.getIntervalDays());
        vo.setWaitingPeriodDays(pd.getWaitingPeriodDays());
        vo.setIsBasic(pd.getIsBasic());
        vo.setResponsibilityCode(pd.getResponsibilityCode());
        vo.setSortOrder(pd.getSortOrder());
        return vo;
    }

    /**
     * 将疾病实体转换为疾病VO（默认配置）
     */
    private DiseaseVO convertToDiseaseVO(Disease disease) {
        DiseaseVO vo = new DiseaseVO();
        BeanUtils.copyProperties(disease, vo);
        // 默认赔付比例
        if (disease.getDiseaseType() != null) {
            switch (disease.getDiseaseType()) {
                case 1:
                    vo.setPayoutRatio(100);
                    vo.setPayoutTimes(1);
                    break;
                case 2:
                    vo.setPayoutRatio(50);
                    vo.setPayoutTimes(1);
                    break;
                case 3:
                    vo.setPayoutRatio(30);
                    vo.setPayoutTimes(1);
                    break;
                default:
                    break;
            }
        }
        vo.setIsBasic(1);
        return vo;
    }

    @Override
    public ProductBriefVO getProductBrief(Long productId) {
        ProductBase product = productBaseMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException("产品不存在");
        }
        InsuranceCompany company = insuranceCompanyMapper.selectById(product.getCompanyId());

        ProductBriefVO vo = new ProductBriefVO();
        vo.setProductId(product.getProductId());
        vo.setProductName(product.getProductName());
        vo.setProductCode(product.getProductCode());
        vo.setProductType(product.getProductType());
        vo.setSubType(product.getSubType());
        vo.setCompanyId(product.getCompanyId());
        vo.setCompanyName(company != null ? company.getCompanyName() : null);
        vo.setCompanyLogo(company != null ? company.getLogoUrl() : null);
        vo.setProductBrief(product.getProductBrief());
        vo.setSuitableFor(product.getSuitableFor());
        vo.setMinAge(product.getMinAge());
        vo.setMaxAge(product.getMaxAge());
        vo.setPaymentYears(product.getPaymentYears());
        vo.setSaleStatus(product.getSaleStatus());

        // 产品类型描述
        switch (product.getProductType()) {
            case 1:
                vo.setProductTypeDesc("重疾险");
                break;
            case 2:
                vo.setProductTypeDesc("增额终身寿险");
                break;
            case 3:
                vo.setProductTypeDesc("年金险");
                break;
            default:
                vo.setProductTypeDesc("未知类型");
                break;
        }

        // 解析产品亮点JSON
        if (product.getProductHighlights() != null && !product.getProductHighlights().isEmpty()) {
            try {
                com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                List<String> highlights = mapper.readValue(
                    product.getProductHighlights(),
                    new com.fasterxml.jackson.core.type.TypeReference<List<String>>() {}
                );
                vo.setProductHighlights(highlights);
            } catch (Exception e) {
                vo.setProductHighlights(new java.util.ArrayList<>());
            }
        } else {
            vo.setProductHighlights(new java.util.ArrayList<>());
        }

        // 解析产品标签JSON
        if (product.getProductTags() != null && !product.getProductTags().isEmpty()) {
            try {
                com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                List<String> tags = mapper.readValue(
                    product.getProductTags(),
                    new com.fasterxml.jackson.core.type.TypeReference<List<String>>() {}
                );
                vo.setProductTags(tags);
            } catch (Exception e) {
                vo.setProductTags(new java.util.ArrayList<>());
            }
        } else {
            vo.setProductTags(new java.util.ArrayList<>());
        }

        vo.setCoverageSummary(product.getCoverageSummary());
        vo.setRecommendationScore(product.getRecommendationScore());
        vo.setBriefStatus(product.getBriefStatus());

        // 如果简介为空，自动生成
        if ((vo.getProductBrief() == null || vo.getProductBrief().isEmpty())
                && productBriefGeneratorService != null) {
            try {
                ProductBriefVO generated = productBriefGeneratorService.generateProductBrief(productId);
                if (generated != null) {
                    // 使用生成的简介，但不覆盖已有非空字段
                    if (vo.getProductBrief() == null || vo.getProductBrief().isEmpty()) {
                        vo.setProductBrief(generated.getProductBrief());
                    }
                    if (vo.getProductHighlights() == null || vo.getProductHighlights().isEmpty()) {
                        vo.setProductHighlights(generated.getProductHighlights());
                    }
                    if (vo.getSuitableFor() == null || vo.getSuitableFor().isEmpty()) {
                        vo.setSuitableFor(generated.getSuitableFor());
                    }
                    if (vo.getProductTags() == null || vo.getProductTags().isEmpty()) {
                        vo.setProductTags(generated.getProductTags());
                    }
                    if (vo.getCoverageSummary() == null || vo.getCoverageSummary().isEmpty()) {
                        vo.setCoverageSummary(generated.getCoverageSummary());
                    }
                    if (vo.getRecommendationScore() == null) {
                        vo.setRecommendationScore(generated.getRecommendationScore());
                    }
                    vo.setBriefStatus(1);

                    // 异步保存生成结果
                    new Thread(() -> {
                        try {
                            productBriefGeneratorService.generateAndSave(productId);
                        } catch (Exception e) {
                            // 忽略保存错误
                        }
                    }).start();
                }
            } catch (Exception e) {
                log.warn("自动生成产品简介失败: productId={}", productId, e);
            }
        }

        return vo;
    }
}
