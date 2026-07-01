package com.insurance.api.compare.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.insurance.api.compare.dto.AnnuityCompareDTO;
import com.insurance.api.compare.dto.CriticalIllnessCompareDTO;
import com.insurance.api.compare.dto.WholeLifeCompareDTO;
import com.insurance.api.compare.service.CompareService;
import com.insurance.api.compare.vo.CompareItemVO;
import com.insurance.api.compare.vo.CompareResultVO;
import com.insurance.api.entity.*;
import com.insurance.api.mapper.*;
import com.insurance.common.exception.BusinessException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * 产品对比Service实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CompareServiceImpl implements CompareService {

    private final ProductBaseMapper productBaseMapper;
    private final InsuranceCompanyMapper insuranceCompanyMapper;
    private final CriticalIllnessProductMapper criticalIllnessProductMapper;
    private final WholeLifeProductMapper wholeLifeProductMapper;
    private final AnnuityProductMapper annuityProductMapper;

    @Override
    public CompareResultVO compareCriticalIllness(CriticalIllnessCompareDTO dto) {
        List<Long> productIds = dto.getProductIds();
        if (productIds.size() > 5) {
            throw new BusinessException("最多对比5个产品");
        }
        List<ProductBase> products = productBaseMapper.selectBatchIds(productIds);
        Map<Long, InsuranceCompany> companyMap = getCompanyMap(products);
        Map<Long, CriticalIllnessProduct> subMap = getCriticalIllnessSubMap(productIds);

        CompareResultVO result = new CompareResultVO();
        Map<Long, Map<String, Object>> productInfos = new LinkedHashMap<>();
        for (ProductBase p : products) {
            Map<String, Object> info = new LinkedHashMap<>();
            info.put("productId", p.getProductId());
            info.put("productName", p.getProductName());
            info.put("companyName", companyMap.get(p.getCompanyId()) != null ? companyMap.get(p.getCompanyId()).getCompanyName() : "");
            productInfos.put(p.getProductId(), info);
        }
        result.setProductInfos(productInfos);

        List<CompareItemVO> items = new ArrayList<>();
        items.add(buildItem("minAge", "最小投保年龄", products, p -> p.getMinAge()));
        items.add(buildItem("maxAge", "最大投保年龄", products, p -> p.getMaxAge()));
        items.add(buildItem("waitingPeriod", "等待期（天）", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getWaitingPeriod() : null));
        items.add(buildItem("criticalCount", "重疾种类", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getCriticalCount() : null));
        items.add(buildItem("criticalRatio", "重疾赔付比例", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getCriticalRatio() : null));
        items.add(buildItem("mediumCount", "中症种类", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getMediumCount() : null));
        items.add(buildItem("mediumRatio", "中症赔付比例", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getMediumRatio() : null));
        items.add(buildItem("lightCount", "轻症种类", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getLightCount() : null));
        items.add(buildItem("lightRatio", "轻症赔付比例", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getLightRatio() : null));
        items.add(buildItem("criticalMultiInterval", "重疾多次赔付间隔", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getCriticalMultiInterval() : null));
        items.add(buildItem("cancerMultiInterval", "癌症多次赔付间隔", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getCancerMultiInterval() : null));
        result.setCompareItems(items);
        return result;
    }

    @Override
    public CompareResultVO compareWholeLife(WholeLifeCompareDTO dto) {
        List<Long> productIds = dto.getProductIds();
        if (productIds.size() > 5) {
            throw new BusinessException("最多对比5个产品");
        }
        List<ProductBase> products = productBaseMapper.selectBatchIds(productIds);
        Map<Long, InsuranceCompany> companyMap = getCompanyMap(products);
        Map<Long, WholeLifeProduct> subMap = getWholeLifeSubMap(productIds);

        CompareResultVO result = new CompareResultVO();
        Map<Long, Map<String, Object>> productInfos = new LinkedHashMap<>();
        for (ProductBase p : products) {
            Map<String, Object> info = new LinkedHashMap<>();
            info.put("productId", p.getProductId());
            info.put("productName", p.getProductName());
            info.put("companyName", companyMap.get(p.getCompanyId()) != null ? companyMap.get(p.getCompanyId()).getCompanyName() : "");
            productInfos.put(p.getProductId(), info);
        }
        result.setProductInfos(productInfos);

        List<CompareItemVO> items = new ArrayList<>();
        items.add(buildItem("minAge", "最小投保年龄", products, p -> p.getMinAge()));
        items.add(buildItem("maxAge", "最大投保年龄", products, p -> p.getMaxAge()));
        items.add(buildItem("reductionRuleType", "减保规则", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getReductionRuleType() : null));
        items.add(buildItem("reductionStartYear", "减保起始年份", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getReductionStartYear() : null));
        items.add(buildItem("maxAddAge", "最大加保年龄", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getMaxAddAge() : null));
        items.add(buildItem("loanRatio", "保单贷款比例", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getLoanRatio() : null));
        items.add(buildItem("increaseRate", "保额递增比例", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getIncreaseRate() : null));
        items.add(buildItem("increaseEndAge", "递增截止年龄", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getIncreaseEndAge() : null));
        result.setCompareItems(items);
        return result;
    }

    @Override
    public CompareResultVO compareAnnuity(AnnuityCompareDTO dto) {
        List<Long> productIds = dto.getProductIds();
        if (productIds.size() > 5) {
            throw new BusinessException("最多对比5个产品");
        }
        List<ProductBase> products = productBaseMapper.selectBatchIds(productIds);
        Map<Long, InsuranceCompany> companyMap = getCompanyMap(products);
        Map<Long, AnnuityProduct> subMap = getAnnuitySubMap(productIds);

        CompareResultVO result = new CompareResultVO();
        Map<Long, Map<String, Object>> productInfos = new LinkedHashMap<>();
        for (ProductBase p : products) {
            Map<String, Object> info = new LinkedHashMap<>();
            info.put("productId", p.getProductId());
            info.put("productName", p.getProductName());
            info.put("companyName", companyMap.get(p.getCompanyId()) != null ? companyMap.get(p.getCompanyId()).getCompanyName() : "");
            productInfos.put(p.getProductId(), info);
        }
        result.setProductInfos(productInfos);

        List<CompareItemVO> items = new ArrayList<>();
        items.add(buildItem("minAge", "最小投保年龄", products, p -> p.getMinAge()));
        items.add(buildItem("maxAge", "最大投保年龄", products, p -> p.getMaxAge()));
        items.add(buildItem("supportMonthly", "支持月领", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getSupportMonthly() : null));
        items.add(buildItem("monthlyCoefficient", "月领系数", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getMonthlyCoefficient() : null));
        items.add(buildItem("supportIncrease", "支持递增", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getSupportIncrease() : null));
        items.add(buildItem("increaseEndYear", "递增截止年份", products, p -> subMap.get(p.getProductId()) != null ? subMap.get(p.getProductId()).getIncreaseEndYear() : null));
        result.setCompareItems(items);
        return result;
    }

    private Map<Long, InsuranceCompany> getCompanyMap(List<ProductBase> products) {
        List<Long> companyIds = products.stream().map(ProductBase::getCompanyId).distinct().collect(java.util.stream.Collectors.toList());
        return insuranceCompanyMapper.selectBatchIds(companyIds).stream()
                .collect(java.util.stream.Collectors.toMap(InsuranceCompany::getCompanyId, c -> c));
    }

    private Map<Long, CriticalIllnessProduct> getCriticalIllnessSubMap(List<Long> productIds) {
        LambdaQueryWrapper<CriticalIllnessProduct> wrapper = new LambdaQueryWrapper<>();
        wrapper.in(CriticalIllnessProduct::getProductId, productIds);
        return criticalIllnessProductMapper.selectList(wrapper).stream()
                .collect(java.util.stream.Collectors.toMap(CriticalIllnessProduct::getProductId, c -> c, (a, b) -> a));
    }

    private Map<Long, WholeLifeProduct> getWholeLifeSubMap(List<Long> productIds) {
        LambdaQueryWrapper<WholeLifeProduct> wrapper = new LambdaQueryWrapper<>();
        wrapper.in(WholeLifeProduct::getProductId, productIds);
        return wholeLifeProductMapper.selectList(wrapper).stream()
                .collect(java.util.stream.Collectors.toMap(WholeLifeProduct::getProductId, c -> c, (a, b) -> a));
    }

    private Map<Long, AnnuityProduct> getAnnuitySubMap(List<Long> productIds) {
        LambdaQueryWrapper<AnnuityProduct> wrapper = new LambdaQueryWrapper<>();
        wrapper.in(AnnuityProduct::getProductId, productIds);
        return annuityProductMapper.selectList(wrapper).stream()
                .collect(java.util.stream.Collectors.toMap(AnnuityProduct::getProductId, c -> c, (a, b) -> a));
    }

    private CompareItemVO buildItem(String code, String name, List<ProductBase> products, java.util.function.Function<ProductBase, Object> valueExtractor) {
        CompareItemVO item = new CompareItemVO();
        item.setDimensionCode(code);
        item.setDimensionName(name);
        Map<Long, Object> values = new LinkedHashMap<>();
        for (ProductBase p : products) {
            values.put(p.getProductId(), valueExtractor.apply(p));
        }
        item.setValues(values);
        return item;
    }
}
