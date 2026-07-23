package com.insurance.api.product.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.insurance.api.entity.*;
import com.insurance.api.mapper.*;
import com.insurance.api.product.service.ProductBriefGeneratorService;
import com.insurance.api.product.vo.ProductBriefVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 产品简介自动生成服务实现
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ProductBriefGeneratorServiceImpl implements ProductBriefGeneratorService {

    private final ProductBaseMapper productBaseMapper;
    private final InsuranceCompanyMapper insuranceCompanyMapper;
    private final CriticalIllnessProductMapper criticalIllnessProductMapper;
    private final WholeLifeProductMapper wholeLifeProductMapper;
    private final AnnuityProductMapper annuityProductMapper;
    private final ProductResponsibilityMapper productResponsibilityMapper;
    private final ResponsibilityItemMapper responsibilityItemMapper;
    private final PremiumRateMapper premiumRateMapper;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public ProductBriefVO generateProductBrief(Long productId) {
        ProductBase product = productBaseMapper.selectById(productId);
        if (product == null) {
            return null;
        }

        ProductBriefVO vo = new ProductBriefVO();
        vo.setProductId(product.getProductId());
        vo.setProductName(product.getProductName());
        vo.setProductCode(product.getProductCode());
        vo.setProductType(product.getProductType());
        vo.setSubType(product.getSubType());
        vo.setMinAge(product.getMinAge());
        vo.setMaxAge(product.getMaxAge());
        vo.setPaymentYears(product.getPaymentYears());
        vo.setSaleStatus(product.getSaleStatus());

        // 公司信息
        InsuranceCompany company = insuranceCompanyMapper.selectById(product.getCompanyId());
        if (company != null) {
            vo.setCompanyId(company.getCompanyId());
            vo.setCompanyName(company.getCompanyName());
            vo.setCompanyLogo(company.getLogoUrl());
        }

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

        // 根据产品类型生成简介
        switch (product.getProductType()) {
            case 1:
                generateCriticalIllnessBrief(product, vo);
                break;
            case 2:
                generateWholeLifeBrief(product, vo);
                break;
            case 3:
                generateAnnuityBrief(product, vo);
                break;
            default:
                generateDefaultBrief(product, vo);
                break;
        }

        // 生成产品标签
        vo.setProductTags(generateTags(product));

        // 计算推荐指数
        vo.setRecommendationScore(calculateScore(product, vo));

        vo.setBriefStatus(1); // AI生成

        return vo;
    }

    @Override
    public boolean generateAndSave(Long productId) {
        try {
            ProductBriefVO vo = generateProductBrief(productId);
            if (vo == null) return false;

            ProductBase update = new ProductBase();
            update.setProductId(productId);
            update.setProductBrief(vo.getProductBrief());
            update.setSuitableFor(vo.getSuitableFor());
            update.setCoverageSummary(vo.getCoverageSummary());
            update.setBriefStatus(1);

            // 亮点转JSON
            try {
                if (vo.getProductHighlights() != null && !vo.getProductHighlights().isEmpty()) {
                    update.setProductHighlights(objectMapper.writeValueAsString(vo.getProductHighlights()));
                }
                if (vo.getProductTags() != null && !vo.getProductTags().isEmpty()) {
                    update.setProductTags(objectMapper.writeValueAsString(vo.getProductTags()));
                }
            } catch (Exception e) {
                log.warn("产品简介JSON序列化失败: productId={}", productId, e);
            }

            update.setRecommendationScore(vo.getRecommendationScore());
            productBaseMapper.updateById(update);
            return true;
        } catch (Exception e) {
            log.error("生成并保存产品简介失败: productId={}", productId, e);
            return false;
        }
    }

    /**
     * 生成重疾险简介
     */
    private void generateCriticalIllnessBrief(ProductBase product, ProductBriefVO vo) {
        String companyName = vo.getCompanyName() != null ? vo.getCompanyName() : "";
        String productName = product.getProductName();

        // 查询责任配置
        List<ProductResponsibility> responsibilities = getSupportedResponsibilities(product.getProductId());
        List<String> highlights = new ArrayList<>();
        List<String> tags = new ArrayList<>();

        // 基础信息
        int criticalCount = 0;
        int mediumCount = 0;
        int lightCount = 0;
        boolean hasDeath = false;
        boolean hasMultiplePay = false;
        boolean hasWaiver = false;

        for (ProductResponsibility pr : responsibilities) {
            ResponsibilityItem item = responsibilityItemMapper.selectById(pr.getItemId());
            if (item == null) continue;

            String code = item.getItemCode() != null ? item.getItemCode().toUpperCase() : "";
            String name = item.getItemName() != null ? item.getItemName() : "";

            if (code.contains("CRITICAL") || name.contains("重疾")) {
                criticalCount++;
                if (name.contains("多次") || code.contains("MULTI")) hasMultiplePay = true;
            }
            if (code.contains("MEDIUM") || name.contains("中症")) mediumCount++;
            if (code.contains("LIGHT") || name.contains("轻症")) lightCount++;
            if (code.contains("DEATH") || name.contains("身故") || name.contains("全残")) hasDeath = true;
            if (code.contains("WAIVER") || name.contains("豁免")) hasWaiver = true;
        }

        // 生成一句话简介
        StringBuilder brief = new StringBuilder();
        brief.append(companyName).append(productName).append("，");
        if (criticalCount > 0) brief.append(criticalCount).append("种重疾保障");
        if (mediumCount > 0) brief.append("，").append(mediumCount).append("种中症");
        if (lightCount > 0) brief.append("，").append(lightCount).append("种轻症");
        brief.append("，保障全面");
        if (hasMultiplePay) brief.append("，多次赔付");
        brief.append("。");
        vo.setProductBrief(brief.toString());

        // 保障摘要
        StringBuilder summary = new StringBuilder();
        summary.append("覆盖");
        if (criticalCount > 0) summary.append(criticalCount).append("种重疾");
        if (mediumCount > 0) summary.append("、").append(mediumCount).append("种中症");
        if (lightCount > 0) summary.append("、").append(lightCount).append("种轻症");
        summary.append("疾病保障");
        if (hasDeath) summary.append("，含身故责任");
        if (hasWaiver) summary.append("，自带豁免");
        summary.append("。");
        vo.setCoverageSummary(summary.toString());

        // 生成亮点
        if (hasMultiplePay) highlights.add("重疾多次赔付，保障更全面");
        if (hasDeath) highlights.add("含身故保障，身价有保障");
        if (hasWaiver) highlights.add("自带被保人豁免，交费无忧");
        if (mediumCount > 0) highlights.add("中症额外赔付，保障升级");
        if (lightCount > 0) highlights.add("轻症保障全，早发现早治疗");
        highlights.add("投保年龄范围广，全家可保");

        // 限制3-5条
        if (highlights.size() > 5) {
            highlights = highlights.subList(0, 5);
        }
        vo.setProductHighlights(highlights);

        // 适合人群
        StringBuilder suitable = new StringBuilder();
        suitable.append("适合").append(product.getMinAge()).append("-").append(product.getMaxAge()).append("岁");
        if (product.getOccupationClass() != null) {
            suitable.append("、").append(product.getOccupationClass()).append("类及以内职业");
        }
        suitable.append("，关注健康保障、追求");
        if (hasMultiplePay) suitable.append("多次赔付、");
        suitable.append("全面保障的人群");
        vo.setSuitableFor(suitable.toString());
    }

    /**
     * 生成增额终身寿简介
     */
    private void generateWholeLifeBrief(ProductBase product, ProductBriefVO vo) {
        String companyName = vo.getCompanyName() != null ? vo.getCompanyName() : "";
        String productName = product.getProductName();

        // 一句话简介
        vo.setProductBrief(companyName + productName + "，保额逐年递增，财富稳健增值，终身保障。");

        // 保障摘要
        vo.setCoverageSummary("终身寿险保障，保额复利递增，兼具保障与财富传承功能，支持减保取现。");

        // 亮点
        List<String> highlights = new ArrayList<>();
        highlights.add("保额逐年递增，终身复利增值");
        highlights.add("身故全残保障，守护家庭责任");
        highlights.add("支持减保取现，灵活应对资金需求");
        highlights.add("财富传承，定向指定受益人");
        vo.setProductHighlights(highlights);

        // 适合人群
        vo.setSuitableFor("适合" + product.getMinAge() + "-" + product.getMaxAge() + "岁，有财富规划、资产传承需求的人群。");
    }

    /**
     * 生成年金险简介
     */
    private void generateAnnuityBrief(ProductBase product, ProductBriefVO vo) {
        String companyName = vo.getCompanyName() != null ? vo.getCompanyName() : "";
        String productName = product.getProductName();

        // 一句话简介
        vo.setProductBrief(companyName + productName + "，定期领取年金，养老规划首选，活多久领多久。");

        // 保障摘要
        vo.setCoverageSummary("年金保险，约定年龄起定期领取，养老补充/教育金规划，锁定终身现金流。");

        // 亮点
        List<String> highlights = new ArrayList<>();
        highlights.add("定期领取年金，锁定终身现金流");
        highlights.add("养老/教育金规划，专款专用");
        highlights.add("身故保障，传承财富");
        highlights.add("复利增值，越领越多");
        vo.setProductHighlights(highlights);

        // 适合人群
        vo.setSuitableFor("适合" + product.getMinAge() + "-" + product.getMaxAge() + "岁，有养老规划、教育金储备需求的人群。");
    }

    /**
     * 默认简介生成
     */
    private void generateDefaultBrief(ProductBase product, ProductBriefVO vo) {
        String companyName = vo.getCompanyName() != null ? vo.getCompanyName() : "";
        vo.setProductBrief(companyName + product.getProductName() + "，正规保险产品，保障可靠。");
        vo.setCoverageSummary("保险产品，具体保障内容以条款为准。");
        List<String> highlights = new ArrayList<>();
        highlights.add("正规保险公司承保");
        highlights.add("保障可靠，理赔有保障");
        vo.setProductHighlights(highlights);
        vo.setSuitableFor("适合" + product.getMinAge() + "-" + product.getMaxAge() + "岁人群投保。");
    }

    /**
     * 生成产品标签
     */
    private List<String> generateTags(ProductBase product) {
        List<String> tags = new ArrayList<>();

        switch (product.getProductType()) {
            case 1:
                tags.add("重疾险");
                break;
            case 2:
                tags.add("增额终身寿");
                tags.add("理财型");
                break;
            case 3:
                tags.add("年金险");
                tags.add("养老");
                break;
        }

        // 从责任中提取标签
        List<ProductResponsibility> responsibilities = getSupportedResponsibilities(product.getProductId());
        for (ProductResponsibility pr : responsibilities) {
            ResponsibilityItem item = responsibilityItemMapper.selectById(pr.getItemId());
            if (item == null) continue;
            String name = item.getItemName() != null ? item.getItemName() : "";
            String code = item.getItemCode() != null ? item.getItemCode().toUpperCase() : "";

            if (name.contains("多次") || code.contains("MULTI")) {
                if (!tags.contains("多次赔付")) tags.add("多次赔付");
            }
            if (name.contains("身故") || code.contains("DEATH")) {
                if (!tags.contains("含身故")) tags.add("含身故");
            }
            if (name.contains("豁免") || code.contains("WAIVER")) {
                if (!tags.contains("豁免")) tags.add("豁免");
            }
        }

        // 最多6个标签
        if (tags.size() > 6) {
            tags = tags.subList(0, 6);
        }

        return tags;
    }

    /**
     * 计算推荐指数
     */
    private int calculateScore(ProductBase product, ProductBriefVO vo) {
        int score = 3; // 基础分

        // 亮点数量加分
        if (vo.getProductHighlights() != null && vo.getProductHighlights().size() >= 4) {
            score += 1;
        }

        // 投保年龄范围广加分
        if (product.getMaxAge() != null && product.getMinAge() != null
                && product.getMaxAge() - product.getMinAge() >= 50) {
            score += 1;
        }

        return Math.min(score, 5);
    }

    /**
     * 获取产品支持的责任列表
     */
    private List<ProductResponsibility> getSupportedResponsibilities(Long productId) {
        LambdaQueryWrapper<ProductResponsibility> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductResponsibility::getProductId, productId)
                .eq(ProductResponsibility::getIsSupported, 1);
        return productResponsibilityMapper.selectList(wrapper);
    }
}
