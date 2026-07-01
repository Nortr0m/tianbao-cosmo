package com.insurance.api.product.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.insurance.api.entity.*;
import com.insurance.api.mapper.*;
import com.insurance.api.product.dto.ProductQueryDTO;
import com.insurance.api.product.service.ProductService;
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
        if (queryDTO.getCompanyId() != null) {
            wrapper.eq(ProductBase::getCompanyId, queryDTO.getCompanyId());
        }
        if (queryDTO.getProductType() != null) {
            wrapper.eq(ProductBase::getProductType, queryDTO.getProductType());
        }
        wrapper.orderByDesc(ProductBase::getCreatedAt);

        Page<ProductBase> resultPage = productBaseMapper.selectPage(page, wrapper);
        List<Long> companyIds = resultPage.getRecords().stream()
                .map(ProductBase::getCompanyId)
                .distinct()
                .collect(Collectors.toList());
        Map<Long, String> companyNameMap = insuranceCompanyMapper.selectBatchIds(companyIds).stream()
                .collect(Collectors.toMap(InsuranceCompany::getCompanyId, InsuranceCompany::getCompanyName));

        List<ProductVO> list = resultPage.getRecords().stream()
                .map(p -> convertToVO(p, companyNameMap.get(p.getCompanyId())))
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
        ProductVO vo = convertToVO(product, companyName);

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
        Map<Long, String> companyNameMap = insuranceCompanyMapper.selectBatchIds(companyIds).stream()
                .collect(Collectors.toMap(InsuranceCompany::getCompanyId, InsuranceCompany::getCompanyName));
        return products.stream()
                .map(p -> convertToVO(p, companyNameMap.get(p.getCompanyId())))
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
        Map<Long, String> companyNameMap = insuranceCompanyMapper.selectBatchIds(companyIds).stream()
                .collect(Collectors.toMap(InsuranceCompany::getCompanyId, InsuranceCompany::getCompanyName));
        return products.stream()
                .map(p -> convertToVO(p, companyNameMap.get(p.getCompanyId())))
                .collect(Collectors.toList());
    }

    private ProductVO convertToVO(ProductBase product, String companyName) {
        ProductVO vo = new ProductVO();
        BeanUtils.copyProperties(product, vo);
        vo.setCompanyName(companyName);
        vo.setSubType(product.getSubType());
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
}
