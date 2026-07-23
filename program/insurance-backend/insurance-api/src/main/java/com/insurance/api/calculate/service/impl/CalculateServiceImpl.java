package com.insurance.api.calculate.service.impl;

import com.insurance.api.calculate.dto.AnnuityProjectionDTO;
import com.insurance.api.calculate.dto.CriticalPremiumDTO;
import com.insurance.api.calculate.dto.WholeLifeProjectionDTO;
import com.insurance.api.calculate.service.CalculateService;
import com.insurance.api.calculate.vo.*;
import com.insurance.api.entity.*;
import com.insurance.api.mapper.*;
import com.insurance.common.exception.BusinessException;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 费率计算Service实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CalculateServiceImpl implements CalculateService {

    private final ProductBaseMapper productBaseMapper;
    private final PremiumRateMapper premiumRateMapper;
    private final WholeLifeRateMapper wholeLifeRateMapper;
    private final WholeLifeDividendRateMapper wholeLifeDividendRateMapper;
    private final AnnuityRateMapper annuityRateMapper;
    private final AnnuityDividendRateMapper annuityDividendRateMapper;
    private final AnnuityProductMapper annuityProductMapper;
    private final ProductResponsibilityMapper productResponsibilityMapper;
    private final ResponsibilityItemMapper responsibilityItemMapper;
    private final ResponsibilityCategoryMapper responsibilityCategoryMapper;

    @Override
    public CriticalPremiumVO calculateCriticalPremium(CriticalPremiumDTO dto) {
        ProductBase product = productBaseMapper.selectById(dto.getProductId());
        if (product == null) {
            throw new BusinessException("产品不存在");
        }
        if (product.getProductType() != 1) {
            throw new BusinessException("该产品不是重疾险");
        }

        // 兼容 paymentPeriod 字段名
        Integer paymentYear = dto.getPaymentYear() != null ? dto.getPaymentYear() : dto.getPaymentPeriod();
        if (paymentYear == null) {
            throw new BusinessException("缴费年限不能为空");
        }

        // 参数前置校验
        if (dto.getAge() == null) {
            throw new BusinessException("投保年龄不能为空");
        }
        if (dto.getAge() < product.getMinAge() || dto.getAge() > product.getMaxAge()) {
            throw new BusinessException("投保年龄必须在 " + product.getMinAge() + "~" + product.getMaxAge() + " 岁之间");
        }
        if (dto.getCoverage() == null || dto.getCoverage().compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException("保额必须大于0");
        }

        // 校验缴费年限是否在支持范围内
        boolean paymentYearValid = true;
        String supportedYearsStr = product.getPaymentYears();
        if (supportedYearsStr != null && !supportedYearsStr.isEmpty()) {
            try {
                com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                List<String> supportedYears = mapper.readValue(supportedYearsStr, 
                    new com.fasterxml.jackson.core.type.TypeReference<List<String>>() {});
                // 检查是否为数字年（过滤掉非数字的异常值）
                final Integer py = paymentYear;
                paymentYearValid = supportedYears.stream()
                    .map(s -> {
                        try { return Integer.parseInt(s.replaceAll("[^0-9]", "")); } 
                        catch (Exception e) { return null; }
                    })
                    .filter(y -> y != null && y > 0)
                    .anyMatch(y -> y.equals(py));
                if (!paymentYearValid) {
                    String validYears = supportedYears.stream()
                        .map(s -> {
                            try { return Integer.parseInt(s.replaceAll("[^0-9]", "")) + "年"; } 
                            catch (Exception e) { return null; }
                        })
                        .filter(s -> s != null)
                        .collect(java.util.stream.Collectors.joining("、"));
                    throw new BusinessException("该产品不支持" + paymentYear + "年缴费，支持的缴费年限为：" + validYears);
                }
            } catch (BusinessException e) {
                throw e;
            } catch (Exception e) {
                // 解析失败，跳过校验
            }
        }

        LambdaQueryWrapper<PremiumRate> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(PremiumRate::getProductId, dto.getProductId())
                .eq(PremiumRate::getGender, dto.getGender())
                .eq(PremiumRate::getAge, dto.getAge())
                .eq(PremiumRate::getPaymentYear, paymentYear)
                .eq(PremiumRate::getHealthStatus, 0)
                .orderByAsc(PremiumRate::getRateId)
                .last("LIMIT 1");
        PremiumRate rate = premiumRateMapper.selectOne(wrapper);

        CriticalPremiumVO vo = new CriticalPremiumVO();
        vo.setProductId(dto.getProductId());
        vo.setProductName(product.getProductName());
        vo.setGender(dto.getGender());
        vo.setAge(dto.getAge());
        vo.setPaymentYear(paymentYear);
        vo.setCoverage(dto.getCoverage());

        if (rate == null) {
            // 费率数据缺失，设置错误提示并将年缴保费标记为-1
            vo.setErrorMessage("未查询到对应的费率数据，请检查投保条件（年龄、性别、缴费年限等）是否在产品支持范围内");
            vo.setPremiumPerK(BigDecimal.ZERO);
            vo.setAnnualPremium(BigDecimal.valueOf(-1));
            vo.setTotalPremium(BigDecimal.valueOf(-1));
            return vo;
        }

        BigDecimal premiumPerK = rate.getPremiumPerK();
        // 保额单位为万元，转换为千元：coverage * 10000 / 1000 = coverage * 10
        BigDecimal coverageK = dto.getCoverage().multiply(BigDecimal.valueOf(10));
        BigDecimal baseAnnualPremium = premiumPerK.multiply(coverageK).setScale(2, RoundingMode.HALF_UP);

        // 设置基础保费
        vo.setPremiumPerK(premiumPerK);
        vo.setBasePremium(baseAnnualPremium);

        // 计算责任系数
        BigDecimal totalCoefficient = BigDecimal.ONE;
        List<PremiumComponentVO> components = new ArrayList<>();

        // 解析用户传入的责任配置
        Map<String, Object> userConfig = parseResponsibilityConfig(dto.getResponsibilityConfig());

        // 查询产品的所有责任配置
        LambdaQueryWrapper<ProductResponsibility> prWrapper = new LambdaQueryWrapper<>();
        prWrapper.eq(ProductResponsibility::getProductId, dto.getProductId())
                 .eq(ProductResponsibility::getIsSupported, 1);
        List<ProductResponsibility> prList = productResponsibilityMapper.selectList(prWrapper);

        if (!prList.isEmpty()) {
            // 查询责任项详情
            List<Long> itemIds = prList.stream()
                .map(ProductResponsibility::getItemId)
                .distinct()
                .collect(java.util.stream.Collectors.toList());
            List<ResponsibilityItem> items = responsibilityItemMapper.selectBatchIds(itemIds);
            Map<Long, ResponsibilityItem> itemMap = items.stream()
                .collect(java.util.stream.Collectors.toMap(ResponsibilityItem::getItemId, i -> i));

            // 查询分类信息，用于判断必选责任
            Map<Long, String> categoryCodeMap = new java.util.HashMap<>();
            try {
                List<Long> categoryIds = items.stream()
                    .map(ResponsibilityItem::getCategoryId)
                    .filter(id -> id != null)
                    .distinct()
                    .collect(java.util.stream.Collectors.toList());
                if (!categoryIds.isEmpty() && responsibilityCategoryMapper != null) {
                    List<com.insurance.api.entity.ResponsibilityCategory> categories = 
                        responsibilityCategoryMapper.selectBatchIds(categoryIds);
                    for (com.insurance.api.entity.ResponsibilityCategory cat : categories) {
                        categoryCodeMap.put(cat.getCategoryId(), cat.getCategoryCode());
                    }
                }
            } catch (Exception e) {
                // 分类查询失败，降级使用编码判断
            }

            for (ProductResponsibility pr : prList) {
                ResponsibilityItem item = itemMap.get(pr.getItemId());
                if (item == null) continue;

                PremiumComponentVO comp = new PremiumComponentVO();
                comp.setItemCode(item.getItemCode());
                comp.setItemName(item.getItemName());

                // 判断是否必选：BASE分类 或 硬编码的基础责任编码
                String categoryCode = categoryCodeMap.get(item.getCategoryId());
                boolean isBase = "BASE".equalsIgnoreCase(categoryCode) ||
                                "BASE".equals(item.getItemCode()) || 
                                "CRITICAL_ILLNESS".equals(item.getItemCode()) ||
                                "MEDIUM_ILLNESS".equals(item.getItemCode()) ||
                                "LIGHT_ILLNESS".equals(item.getItemCode()) ||
                                (item.getItemCode() != null && item.getItemCode().contains("CRITICAL")) ||
                                (item.getItemName() != null && item.getItemName().contains("重疾"));
                comp.setIsRequired(isBase);

                // 获取选中的选项
                String selectedOption = null;
                Object userValue = userConfig.get(item.getItemCode());
                if (userValue != null) {
                    selectedOption = String.valueOf(userValue);
                } else if (pr.getDefaultOption() != null && !pr.getDefaultOption().isEmpty()) {
                    selectedOption = pr.getDefaultOption();
                }

                comp.setSelectedOption(selectedOption);

                // 解析保费系数JSON
                BigDecimal coeff = getCoefficientForOption(pr.getPremiumCoefficient(), selectedOption);
                if (coeff != null && coeff.compareTo(BigDecimal.ZERO) > 0) {
                    comp.setCoefficient(coeff);
                    // 计算附加保费（相对于基础保费的比例）
                    BigDecimal addPremium = baseAnnualPremium.multiply(coeff.subtract(BigDecimal.ONE))
                        .setScale(2, RoundingMode.HALF_UP);
                    comp.setAdditionalPremium(addPremium);

                    if (!isBase) {
                        // 可选责任：仅当用户选中时才叠加系数
                        if (isOptionSelected(item.getItemCode(), userValue, pr.getDefaultOption())) {
                            totalCoefficient = totalCoefficient.add(coeff.subtract(BigDecimal.ONE));
                            components.add(comp);
                        }
                    } else {
                        // 必选责任：系数已包含在基础保费中，仅记录明细
                        components.add(comp);
                    }
                }
            }
        }

        // 计算实际年缴保费 = 基础保费 × 总系数
        BigDecimal annualPremium = baseAnnualPremium.multiply(totalCoefficient)
            .setScale(2, RoundingMode.HALF_UP);
        vo.setAnnualPremium(annualPremium);
        vo.setResponsibilityCoefficient(totalCoefficient);
        vo.setPremiumComponents(components);

        if (product.getMonthlyRatio() != null) {
            vo.setMonthlyPremium(annualPremium.multiply(product.getMonthlyRatio()).setScale(2, RoundingMode.HALF_UP));
        }
        if (product.getQuarterlyRatio() != null) {
            vo.setQuarterlyPremium(annualPremium.multiply(product.getQuarterlyRatio()).setScale(2, RoundingMode.HALF_UP));
        }
        if (product.getHalfYearlyRatio() != null) {
            vo.setHalfYearlyPremium(annualPremium.multiply(product.getHalfYearlyRatio()).setScale(2, RoundingMode.HALF_UP));
        }
        vo.setTotalPremium(annualPremium.multiply(BigDecimal.valueOf(paymentYear)).setScale(2, RoundingMode.HALF_UP));
        return vo;
    }

    /**
     * 解析责任配置JSON
     */
    private Map<String, Object> parseResponsibilityConfig(String configJson) {
        if (configJson == null || configJson.isEmpty()) {
            return new java.util.HashMap<>();
        }
        try {
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            return mapper.readValue(configJson, new com.fasterxml.jackson.core.type.TypeReference<Map<String, Object>>() {});
        } catch (Exception e) {
            log.warn("解析责任配置失败: {}", configJson, e);
            return new java.util.HashMap<>();
        }
    }

    /**
     * 从保费系数JSON中获取指定选项的系数值
     * premiumCoefficient格式: {"选项1": 1.2, "选项2": 1.3}
     */
    private BigDecimal getCoefficientForOption(String premiumCoefficient, String selectedOption) {
        if (premiumCoefficient == null || premiumCoefficient.isEmpty() || selectedOption == null) {
            return null;
        }
        try {
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            Map<String, Object> coeffMap = mapper.readValue(
                premiumCoefficient, new com.fasterxml.jackson.core.type.TypeReference<Map<String, Object>>() {});
            Object value = coeffMap.get(selectedOption);
            if (value != null) {
                return new BigDecimal(value.toString());
            }
            return null;
        } catch (Exception e) {
            log.warn("解析保费系数失败: {}", premiumCoefficient, e);
            return null;
        }
    }

    /**
     * 判断选项是否被选中
     */
    private boolean isOptionSelected(String itemCode, Object userValue, String defaultOption) {
        if (userValue != null) {
            // boolean类型的开关型
            if (userValue instanceof Boolean) {
                return (Boolean) userValue;
            }
            // 字符串/数字类型的选项
            String strValue = String.valueOf(userValue);
            return !strValue.isEmpty() && !"0".equals(strValue) && !"false".equalsIgnoreCase(strValue);
        }
        // 默认选项
        return defaultOption != null && !defaultOption.isEmpty() && !"0".equals(defaultOption);
    }

    @Override
    public WholeLifeProjectionVO calculateWholeLifeProjection(WholeLifeProjectionDTO dto) {
        ProductBase product = productBaseMapper.selectById(dto.getProductId());
        if (product == null) {
            throw new BusinessException("产品不存在");
        }
        if (product.getProductType() != 2) {
            throw new BusinessException("该产品不是增额终身寿险");
        }

        boolean isDividend = product.getSubType() != null && product.getSubType() == 1;
        BigDecimal dividendRate = BigDecimal.valueOf(
                dto.getDividendRealizationRate() != null ? dto.getDividendRealizationRate() : 100);

        int maxAge = 105;
        int maxPolicyYear = maxAge - dto.getAge();

        // 系数：年缴保费 / 1000（现金价值表单位为每千元保费）
        BigDecimal premiumFactor = dto.getAnnualPremium().divide(
                new BigDecimal("1000"), 6, RoundingMode.HALF_UP);

        List<YearlyProjectionVO> projections = new ArrayList<>();

        for (int policyYear = 1; policyYear <= maxPolicyYear; policyYear++) {
            int currentAge = dto.getAge() + policyYear - 1;

            // 累计保费 = 年缴保费 × min(保单年度, 缴费年限)
            BigDecimal totalPremium = dto.getAnnualPremium().multiply(
                    BigDecimal.valueOf(Math.min(policyYear, dto.getPaymentYear())));

            YearlyProjectionVO vo = new YearlyProjectionVO();
            vo.setPolicyYear(policyYear);
            vo.setAge(currentAge);
            vo.setTotalPremium(totalPremium);

            if (isDividend) {
                // 分红型产品
                // 模式一：查询 whole_life_dividend_rate 表
                WholeLifeDividendRate divRate = wholeLifeDividendRateMapper.selectOne(
                        new LambdaQueryWrapper<WholeLifeDividendRate>()
                                .eq(WholeLifeDividendRate::getProductId, dto.getProductId())
                                .eq(WholeLifeDividendRate::getGender, dto.getGender())
                                .eq(WholeLifeDividendRate::getAge, dto.getAge())
                                .eq(WholeLifeDividendRate::getPaymentYear, dto.getPaymentYear())
                                .eq(WholeLifeDividendRate::getPolicyYear, policyYear));

                if (divRate != null) {
                    // 模式一成功：保证部分 + 含中档分红部分 × 分红实现率
                    BigDecimal guaranteedCV = divRate.getCashValueGuaranteed() != null
                            ? divRate.getCashValueGuaranteed().multiply(premiumFactor) : BigDecimal.ZERO;
                    BigDecimal midDividendCV = divRate.getCashValueMidDividend() != null
                            ? divRate.getCashValueMidDividend().multiply(premiumFactor) : BigDecimal.ZERO;

                    // 含分红现金价值 = 保证部分 + (中档分红部分 - 保证部分) × (分红实现率/100)
                    BigDecimal dividendCVPortion = midDividendCV.subtract(guaranteedCV)
                            .multiply(dividendRate.divide(new BigDecimal("100"), 6, RoundingMode.HALF_UP));
                    BigDecimal projectedCV = guaranteedCV.add(dividendCVPortion);

                    // 身故保险金同理
                    BigDecimal guaranteedDB = divRate.getDeathBenefitGuaranteed() != null
                            ? divRate.getDeathBenefitGuaranteed().multiply(premiumFactor) : BigDecimal.ZERO;
                    BigDecimal midDividendDB = divRate.getDeathBenefitMidDividend() != null
                            ? divRate.getDeathBenefitMidDividend().multiply(premiumFactor) : BigDecimal.ZERO;
                    BigDecimal dividendDBPortion = midDividendDB.subtract(guaranteedDB)
                            .multiply(dividendRate.divide(new BigDecimal("100"), 6, RoundingMode.HALF_UP));
                    BigDecimal projectedDB = guaranteedDB.add(dividendDBPortion);

                    BigDecimal actualDB = calculateDeathBenefit(currentAge, totalPremium, projectedCV, projectedDB);

                    vo.setCashValueGuaranteed(guaranteedCV.setScale(2, RoundingMode.HALF_UP));
                    vo.setCashValue(projectedCV.setScale(2, RoundingMode.HALF_UP));
                    vo.setDeathBenefitGuaranteed(guaranteedDB.setScale(2, RoundingMode.HALF_UP));
                    vo.setDeathBenefit(actualDB.setScale(2, RoundingMode.HALF_UP));
                } else {
                    // 模式二：查 whole_life_rate 保证部分，使用公式估算分红
                    WholeLifeRate rate = wholeLifeRateMapper.selectOne(
                            new LambdaQueryWrapper<WholeLifeRate>()
                                    .eq(WholeLifeRate::getProductId, dto.getProductId())
                                    .eq(WholeLifeRate::getGender, dto.getGender())
                                    .eq(WholeLifeRate::getAge, dto.getAge())
                                    .eq(WholeLifeRate::getPaymentYear, dto.getPaymentYear())
                                    .eq(WholeLifeRate::getPolicyYear, policyYear));

                    if (rate != null && rate.getCashValue() != null) {
                        BigDecimal guaranteedCV = rate.getCashValue().multiply(premiumFactor);
                        BigDecimal projectedCV = guaranteedCV; // 无分红利率配置时暂等同保证部分
                        BigDecimal tableDB = rate.getDeathBenefit() != null
                                ? rate.getDeathBenefit().multiply(premiumFactor) : BigDecimal.ZERO;
                        BigDecimal actualDB = calculateDeathBenefit(currentAge, totalPremium, projectedCV, tableDB);

                        vo.setCashValueGuaranteed(guaranteedCV.setScale(2, RoundingMode.HALF_UP));
                        vo.setCashValue(projectedCV.setScale(2, RoundingMode.HALF_UP));
                        vo.setDeathBenefitGuaranteed(actualDB);
                        vo.setDeathBenefit(actualDB.setScale(2, RoundingMode.HALF_UP));
                    }
                }
            } else {
                // 固收型产品：直接查 whole_life_rate
                WholeLifeRate rate = wholeLifeRateMapper.selectOne(
                        new LambdaQueryWrapper<WholeLifeRate>()
                                .eq(WholeLifeRate::getProductId, dto.getProductId())
                                .eq(WholeLifeRate::getGender, dto.getGender())
                                .eq(WholeLifeRate::getAge, dto.getAge())
                                .eq(WholeLifeRate::getPaymentYear, dto.getPaymentYear())
                                .eq(WholeLifeRate::getPolicyYear, policyYear));

                if (rate != null) {
                    BigDecimal actualCV = rate.getCashValue() != null
                            ? rate.getCashValue().multiply(premiumFactor) : BigDecimal.ZERO;
                    BigDecimal tableDB = rate.getDeathBenefit() != null
                            ? rate.getDeathBenefit().multiply(premiumFactor) : BigDecimal.ZERO;
                    BigDecimal actualDB = calculateDeathBenefit(currentAge, totalPremium, actualCV, tableDB);

                    vo.setCashValue(actualCV.setScale(2, RoundingMode.HALF_UP));
                    vo.setDeathBenefit(actualDB.setScale(2, RoundingMode.HALF_UP));
                }
            }

            // 收益率计算
            if (vo.getCashValue() != null && totalPremium.compareTo(BigDecimal.ZERO) > 0) {
                BigDecimal rr = vo.getCashValue().subtract(totalPremium)
                        .divide(totalPremium, 6, RoundingMode.HALF_UP);
                vo.setReturnRate(rr);
            }

            projections.add(vo);
        }

        // 组装返回VO
        BigDecimal totalPremium = dto.getAnnualPremium().multiply(BigDecimal.valueOf(dto.getPaymentYear()));
        WholeLifeProjectionVO result = new WholeLifeProjectionVO();
        result.setProductId(dto.getProductId());
        result.setProductName(product.getProductName());
        result.setGender(dto.getGender());
        result.setAge(dto.getAge());
        result.setPaymentYear(dto.getPaymentYear());
        result.setAnnualPremium(dto.getAnnualPremium());
        result.setTotalPremium(totalPremium.setScale(2, RoundingMode.HALF_UP));
        result.setYearlyProjections(projections);
        return result;
    }

    /**
     * 计算身故保险金：取 累计保费×给付比例、现金价值、有效保额 三者最大值
     */
    private BigDecimal calculateDeathBenefit(int currentAge, BigDecimal totalPremium,
                                            BigDecimal cashValue, BigDecimal tableDeathBenefit) {
        // 18周岁以下：已交保费（符合监管标准，不适用倍数规则）
        if (currentAge < 18) {
            return totalPremium.max(cashValue).max(
                    tableDeathBenefit != null ? tableDeathBenefit : BigDecimal.ZERO);
        }

        BigDecimal payoutRatio;
        // 18-40岁：1.6倍
        if (currentAge <= 40) {
            payoutRatio = new BigDecimal("1.6");
        }
        // 41-60岁：1.4倍
        else if (currentAge <= 60) {
            payoutRatio = new BigDecimal("1.4");
        }
        // 61岁以上：1.2倍
        else {
            payoutRatio = new BigDecimal("1.2");
        }

        BigDecimal deathBenefitByPremium = totalPremium.multiply(payoutRatio);
        return deathBenefitByPremium.max(cashValue).max(
                tableDeathBenefit != null ? tableDeathBenefit : BigDecimal.ZERO);
    }

    @Override
    public AnnuityProjectionVO calculateAnnuityProjection(AnnuityProjectionDTO dto) {
        ProductBase product = productBaseMapper.selectById(dto.getProductId());
        if (product == null) {
            throw new BusinessException("产品不存在");
        }
        if (product.getProductType() != 3) {
            throw new BusinessException("该产品不是年金险");
        }

        // AN-02: 根据subType区分分红型/固收型
        // subType == 1 或 subType == 2 为分红型，其他为固收型
        boolean isDividend = product.getSubType() != null
                && (product.getSubType() == 1 || product.getSubType() == 2);
        BigDecimal dividendRealizationRate = BigDecimal.valueOf(
                dto.getDividendRealizationRate() != null ? dto.getDividendRealizationRate() : 100);

        BigDecimal totalPremium = dto.getAnnualPremium().multiply(BigDecimal.valueOf(dto.getPaymentYear()));

        // 保费系数：表中数据单位为每千元保费
        BigDecimal premiumFactor = dto.getAnnualPremium().divide(BigDecimal.valueOf(1000), 10, RoundingMode.HALF_UP);

        // 查询年金险费率数据（支持startAge维度）
        LambdaQueryWrapper<AnnuityRate> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(AnnuityRate::getProductId, dto.getProductId())
                .eq(AnnuityRate::getGender, dto.getGender())
                .eq(AnnuityRate::getAge, dto.getAge())
                .eq(AnnuityRate::getPaymentYear, dto.getPaymentYear())
                .orderByAsc(AnnuityRate::getPolicyYear);
        // 养老年金需要按startAge筛选
        if (dto.getStartAge() != null) {
            wrapper.eq(AnnuityRate::getStartAge, dto.getStartAge());
        }
        List<AnnuityRate> rates = annuityRateMapper.selectList(wrapper);

        // AN-02: 分红型产品额外查询 annuity_dividend_rate 表（三档分红数据）
        List<AnnuityDividendRate> divRates = null;
        if (isDividend) {
            LambdaQueryWrapper<AnnuityDividendRate> divWrapper = new LambdaQueryWrapper<>();
            divWrapper.eq(AnnuityDividendRate::getProductId, dto.getProductId())
                    .eq(AnnuityDividendRate::getGender, dto.getGender())
                    .eq(AnnuityDividendRate::getAge, dto.getAge())
                    .eq(AnnuityDividendRate::getPaymentYear, dto.getPaymentYear());
            if (dto.getStartAge() != null) {
                divWrapper.eq(AnnuityDividendRate::getStartAge, dto.getStartAge());
            }
            divWrapper.orderByAsc(AnnuityDividendRate::getPolicyYear);
            divRates = annuityDividendRateMapper.selectList(divWrapper);
        }

        List<AnnuityYearlyVO> projections = new ArrayList<>();
        BigDecimal annualPayout = BigDecimal.ZERO;
        BigDecimal annualPayoutGuaranteed = BigDecimal.ZERO;
        BigDecimal annualPayoutDividend = BigDecimal.ZERO;
        BigDecimal monthlyPayout = BigDecimal.ZERO;

        if (rates != null && !rates.isEmpty()) {
            // 模式一：查表模式（表中数据为每千元保费对应值）
            BigDecimal totalReceived = BigDecimal.ZERO;

            if (isDividend && divRates != null && !divRates.isEmpty()) {
                // AN-02: 分红型 - 基于 annuity_dividend_rate 三档分红表数据计算
                // 保证部分: annualPayoutGuaranteed, cashValueGuaranteed, deathBenefitGuaranteed
                // 中档分红: annualPayoutMidDividend, cashValueMidDividend, deathBenefitMidDividend
                // 高档分红: annualPayoutHighDividend, cashValueHighDividend, deathBenefitHighDividend
                // 含分红 = 保证部分 + (中档分红 - 保证部分) × 分红实现率
                java.util.Map<Integer, AnnuityDividendRate> divRateMap = new java.util.HashMap<>();
                for (AnnuityDividendRate dr : divRates) {
                    divRateMap.put(dr.getPolicyYear(), dr);
                }

                for (AnnuityRate rate : rates) {
                    AnnuityYearlyVO yvo = new AnnuityYearlyVO();
                    yvo.setPolicyYear(rate.getPolicyYear());
                    yvo.setAge(dto.getAge() + rate.getPolicyYear());

                    AnnuityDividendRate divRate = divRateMap.get(rate.getPolicyYear());

                    if (divRate != null) {
                        // 保证部分
                        BigDecimal apGuaranteed = divRate.getAnnualPayoutGuaranteed() != null
                                ? divRate.getAnnualPayoutGuaranteed().multiply(premiumFactor).setScale(2, RoundingMode.HALF_UP)
                                : BigDecimal.ZERO;
                        BigDecimal cvGuaranteed = divRate.getCashValueGuaranteed() != null
                                ? divRate.getCashValueGuaranteed().multiply(premiumFactor).setScale(2, RoundingMode.HALF_UP)
                                : BigDecimal.ZERO;
                        BigDecimal dbGuaranteed = divRate.getDeathBenefitGuaranteed() != null
                                ? divRate.getDeathBenefitGuaranteed().multiply(premiumFactor).setScale(2, RoundingMode.HALF_UP)
                                : BigDecimal.ZERO;

                        // 中档分红部分
                        BigDecimal cvMidDiv = divRate.getCashValueMidDividend() != null
                                ? divRate.getCashValueMidDividend().multiply(premiumFactor).setScale(2, RoundingMode.HALF_UP)
                                : cvGuaranteed;
                        BigDecimal apMidDiv = divRate.getAnnualPayoutMidDividend() != null
                                ? divRate.getAnnualPayoutMidDividend().multiply(premiumFactor).setScale(2, RoundingMode.HALF_UP)
                                : apGuaranteed;

                        // 含分红现金价值 = 保证部分 + (中档分红 - 保证部分) × 分红实现率
                        BigDecimal divPortion = dividendRealizationRate.divide(new BigDecimal("100"), 6, RoundingMode.HALF_UP);
                        BigDecimal cvDividend = cvMidDiv.subtract(cvGuaranteed).multiply(divPortion)
                                .setScale(2, RoundingMode.HALF_UP);
                        if (cvDividend.compareTo(BigDecimal.ZERO) < 0) cvDividend = BigDecimal.ZERO;

                        // 含分红年领取 = 保证年领取 + (中档分红年领取 - 保证年领取) × 分红实现率
                        BigDecimal apDividend = apMidDiv.subtract(apGuaranteed).multiply(divPortion)
                                .setScale(2, RoundingMode.HALF_UP);
                        if (apDividend.compareTo(BigDecimal.ZERO) < 0) apDividend = BigDecimal.ZERO;

                        BigDecimal ap = apGuaranteed.add(apDividend).setScale(2, RoundingMode.HALF_UP);
                        BigDecimal cv = cvGuaranteed.add(cvDividend).setScale(2, RoundingMode.HALF_UP);

                        yvo.setAnnualPayoutGuaranteed(apGuaranteed);
                        yvo.setAnnualPayoutDividend(apDividend);
                        yvo.setCashValueGuaranteed(cvGuaranteed);
                        yvo.setDividendCashValue(cvDividend);
                        yvo.setDeathBenefitGuaranteed(dbGuaranteed);
                        yvo.setAnnualPayout(ap);
                        yvo.setCashValue(cv);
                        yvo.setDeathBenefit(dbGuaranteed);

                        // AN-05: 保证领取期纳入身故金计算
                        if (dto.getGuaranteePeriod() != null && dto.getGuaranteePeriod() > 0) {
                            yvo.setDeathBenefit(calculateAnnuityDeathBenefit(
                                    dto.getAge() + rate.getPolicyYear(),
                                    dto.getAnnualPremium(),
                                    Math.min(rate.getPolicyYear(), dto.getPaymentYear()),
                                    yvo.getCashValue(),
                                    rate.getPolicyYear(),
                                    dto.getGuaranteePeriod(),
                                    ap,
                                    yvo.getDeathBenefit()));
                        }

                        totalReceived = totalReceived.add(ap);
                    } else {
                        // 无对应分红数据，回退到 annuity_rate 基础数据
                        if (rate.getAnnualPayout() != null) {
                            BigDecimal ap = rate.getAnnualPayout().multiply(premiumFactor).setScale(2, RoundingMode.HALF_UP);
                            yvo.setAnnualPayout(ap);
                            totalReceived = totalReceived.add(ap);
                        }
                        if (rate.getCashValue() != null) {
                            yvo.setCashValue(rate.getCashValue().multiply(premiumFactor).setScale(2, RoundingMode.HALF_UP));
                        }
                        if (rate.getDeathBenefit() != null) {
                            yvo.setDeathBenefit(rate.getDeathBenefit().multiply(premiumFactor).setScale(2, RoundingMode.HALF_UP));
                        }
                    }

                    yvo.setTotalReceived(totalReceived.setScale(2, RoundingMode.HALF_UP));
                    projections.add(yvo);
                }

                // 取最后一个有领取金额的年份作为年领取金额（分红型）
                for (int i = rates.size() - 1; i >= 0; i--) {
                    if (rates.get(i).getAnnualPayout() != null && rates.get(i).getAnnualPayout().compareTo(BigDecimal.ZERO) > 0) {
                        AnnuityDividendRate lastDiv = divRateMap.get(rates.get(i).getPolicyYear());
                        if (lastDiv != null && lastDiv.getAnnualPayoutGuaranteed() != null
                                && lastDiv.getAnnualPayoutGuaranteed().compareTo(BigDecimal.ZERO) > 0) {
                            annualPayoutGuaranteed = lastDiv.getAnnualPayoutGuaranteed().multiply(premiumFactor)
                                    .setScale(2, RoundingMode.HALF_UP);
                            // 分红年领取 = 保证年领取 + (中档分红年领取 - 保证年领取) × 分红实现率
                            BigDecimal divPortion = dividendRealizationRate.divide(new BigDecimal("100"), 6, RoundingMode.HALF_UP);
                            BigDecimal apMidDiv = lastDiv.getAnnualPayoutMidDividend() != null
                                    ? lastDiv.getAnnualPayoutMidDividend().multiply(premiumFactor) : annualPayoutGuaranteed;
                            annualPayoutDividend = apMidDiv.subtract(annualPayoutGuaranteed).multiply(divPortion)
                                    .setScale(2, RoundingMode.HALF_UP);
                            if (annualPayoutDividend.compareTo(BigDecimal.ZERO) < 0) annualPayoutDividend = BigDecimal.ZERO;
                            annualPayout = annualPayoutGuaranteed.add(annualPayoutDividend)
                                    .setScale(2, RoundingMode.HALF_UP);
                        } else {
                            annualPayout = rates.get(i).getAnnualPayout().multiply(premiumFactor)
                                    .setScale(2, RoundingMode.HALF_UP);
                        }
                        break;
                    }
                }
            } else {
                // 固收型（或分红型但无分红数据）
                for (AnnuityRate rate : rates) {
                    AnnuityYearlyVO yvo = new AnnuityYearlyVO();
                    yvo.setPolicyYear(rate.getPolicyYear());
                    yvo.setAge(dto.getAge() + rate.getPolicyYear());
                    // 按保费系数换算
                    if (rate.getAnnualPayout() != null) {
                        BigDecimal ap = rate.getAnnualPayout().multiply(premiumFactor).setScale(2, RoundingMode.HALF_UP);
                        yvo.setAnnualPayout(ap);
                        totalReceived = totalReceived.add(ap);
                    }
                    if (rate.getCashValue() != null) {
                        yvo.setCashValue(rate.getCashValue().multiply(premiumFactor).setScale(2, RoundingMode.HALF_UP));
                    }
                    if (rate.getDeathBenefit() != null) {
                        yvo.setDeathBenefit(rate.getDeathBenefit().multiply(premiumFactor).setScale(2, RoundingMode.HALF_UP));
                    }

                    // AN-05: 保证领取期纳入身故金计算（固收型）
                    if (dto.getGuaranteePeriod() != null && dto.getGuaranteePeriod() > 0) {
                        yvo.setDeathBenefit(calculateAnnuityDeathBenefit(
                                dto.getAge() + rate.getPolicyYear(),
                                dto.getAnnualPremium(),
                                Math.min(rate.getPolicyYear(), dto.getPaymentYear()),
                                yvo.getCashValue(),
                                rate.getPolicyYear(),
                                dto.getGuaranteePeriod(),
                                yvo.getAnnualPayout() != null ? yvo.getAnnualPayout() : BigDecimal.ZERO,
                                yvo.getDeathBenefit()));
                    }

                    yvo.setTotalReceived(totalReceived.setScale(2, RoundingMode.HALF_UP));
                    projections.add(yvo);
                }
                // 取最后一个有领取金额的年份作为年领取金额
                for (int i = rates.size() - 1; i >= 0; i--) {
                    if (rates.get(i).getAnnualPayout() != null && rates.get(i).getAnnualPayout().compareTo(BigDecimal.ZERO) > 0) {
                        annualPayout = rates.get(i).getAnnualPayout().multiply(premiumFactor);
                        break;
                    }
                }
            }
        } else {
            // 模式二：公式估算模式
            annualPayout = calculateAnnuityByFormula(dto);
            BigDecimal totalReceived = BigDecimal.ZERO;
            int maxYear = 105 - dto.getAge();
            for (int year = 1; year <= maxYear; year++) {
                AnnuityYearlyVO yvo = new AnnuityYearlyVO();
                yvo.setPolicyYear(year);
                yvo.setAge(dto.getAge() + year);
                BigDecimal paidPremium = dto.getAnnualPremium().multiply(
                        BigDecimal.valueOf(Math.min(year, dto.getPaymentYear())));
                if (dto.getStartAge() != null && (dto.getAge() + year) >= dto.getStartAge()) {
                    yvo.setAnnualPayout(annualPayout.setScale(2, RoundingMode.HALF_UP));
                    totalReceived = totalReceived.add(annualPayout);
                }
                // 现金价值：交费期内按已缴保费的90%~100%递增，交费期后按复利增长
                double cvRatio;
                if (year <= dto.getPaymentYear()) {
                    cvRatio = 0.85 + year * 0.015;
                } else {
                    cvRatio = 0.85 + dto.getPaymentYear() * 0.015 + (year - dto.getPaymentYear()) * 0.025;
                }
                yvo.setCashValue(paidPremium.multiply(BigDecimal.valueOf(cvRatio)).setScale(2, RoundingMode.HALF_UP));
                // 身故保险金：max(已缴保费×110%, 现金价值)
                BigDecimal deathBen = paidPremium.multiply(BigDecimal.valueOf(1.1)).max(yvo.getCashValue());

                // AN-05: 保证领取期纳入身故金计算（公式估算模式）
                if (dto.getGuaranteePeriod() != null && dto.getGuaranteePeriod() > 0) {
                    deathBen = calculateAnnuityDeathBenefit(
                            dto.getAge() + year,
                            dto.getAnnualPremium(),
                            Math.min(year, dto.getPaymentYear()),
                            yvo.getCashValue(),
                            year,
                            dto.getGuaranteePeriod(),
                            yvo.getAnnualPayout() != null ? yvo.getAnnualPayout() : BigDecimal.ZERO,
                            deathBen);
                }

                yvo.setDeathBenefit(deathBen.setScale(2, RoundingMode.HALF_UP));
                yvo.setTotalReceived(totalReceived.setScale(2, RoundingMode.HALF_UP));
                projections.add(yvo);
            }
        }

        // AN-03: 月领系数修正 - 优先使用产品配置的月领系数，否则使用 0.085（年领的8.5%）
        LambdaQueryWrapper<AnnuityProduct> apWrapper = new LambdaQueryWrapper<>();
        apWrapper.eq(AnnuityProduct::getProductId, dto.getProductId());
        AnnuityProduct annuityProduct = annuityProductMapper.selectOne(apWrapper);
        BigDecimal monthlyCoefficient;
        if (annuityProduct != null && annuityProduct.getMonthlyCoefficient() != null) {
            monthlyCoefficient = annuityProduct.getMonthlyCoefficient();
        } else {
            // 使用0.085代替原来的1/12（约0.0833）
            monthlyCoefficient = new BigDecimal("0.085");
        }
        monthlyPayout = annualPayout.multiply(monthlyCoefficient).setScale(2, RoundingMode.HALF_UP);

        AnnuityProjectionVO vo = new AnnuityProjectionVO();
        vo.setProductId(dto.getProductId());
        vo.setProductName(product.getProductName());
        vo.setGender(dto.getGender());
        vo.setAge(dto.getAge());
        vo.setPaymentYear(dto.getPaymentYear());
        vo.setAnnualPremium(dto.getAnnualPremium());
        vo.setTotalPremium(totalPremium.setScale(2, RoundingMode.HALF_UP));
        vo.setStartAge(dto.getStartAge());
        vo.setSubType(product.getSubType());
        vo.setAnnualPayout(annualPayout.setScale(2, RoundingMode.HALF_UP));
        vo.setMonthlyPayout(monthlyPayout);
        vo.setYearlyProjections(projections);

        // AN-02: 分红型产品填充保证/分红分离字段
        if (isDividend) {
            vo.setAnnualPayoutGuaranteed(annualPayoutGuaranteed.setScale(2, RoundingMode.HALF_UP));
            vo.setAnnualPayoutDividend(annualPayoutDividend.setScale(2, RoundingMode.HALF_UP));
            vo.setMonthlyPayoutGuaranteed(annualPayoutGuaranteed.multiply(monthlyCoefficient).setScale(2, RoundingMode.HALF_UP));
            vo.setMonthlyPayoutDividend(annualPayoutDividend.multiply(monthlyCoefficient).setScale(2, RoundingMode.HALF_UP));
        }

        return vo;
    }

    /**
     * AN-05: 年金险身故保险金计算（含保证领取期）
     * 如果在保证期内身故，身故金应包含未领取的保证年金
     *
     * @param currentAge 当前年龄
     * @param annualPremium 年缴保费
     * @param paidYears 已缴年数
     * @param cashValue 现金价值
     * @param policyYear 当前保单年度
     * @param guaranteePeriod 保证领取期（年）
     * @param annualPayout 年领取金额
     * @param originalDeathBenefit 原始身故保险金（不含保证期逻辑）
     * @return 含保证期逻辑的身故保险金
     */
    private BigDecimal calculateAnnuityDeathBenefit(int currentAge, BigDecimal annualPremium,
                                                     int paidYears, BigDecimal cashValue,
                                                     int policyYear, int guaranteePeriod,
                                                     BigDecimal annualPayout,
                                                     BigDecimal originalDeathBenefit) {
        // 基础身故金：已缴保费与原始身故金取较大值
        BigDecimal paidPremium = annualPremium.multiply(BigDecimal.valueOf(paidYears));
        BigDecimal baseDeathBenefit = paidPremium.max(
                originalDeathBenefit != null ? originalDeathBenefit : BigDecimal.ZERO);

        // 保证领取期逻辑：如果仍在保证期内，加上未领取的保证年金
        if (policyYear <= guaranteePeriod) {
            int remainingGuaranteeYears = guaranteePeriod - policyYear + 1;
            BigDecimal unclaimedGuaranteedAnnuity = annualPayout.multiply(BigDecimal.valueOf(remainingGuaranteeYears));
            return baseDeathBenefit.max(cashValue).max(unclaimedGuaranteedAnnuity);
        }

        // 已过保证期，取基础身故金和现金价值的较大值
        return baseDeathBenefit.max(cashValue);
    }

    /**
     * 年金险公式估算模式：无费率表数据时的估算逻辑
     * 基于年缴保费、缴费年限、起始领取年龄等因素估算年领取金额
     */
    private BigDecimal calculateAnnuityByFormula(AnnuityProjectionDTO dto) {
        BigDecimal annualPremium = dto.getAnnualPremium();
        int paymentYear = dto.getPaymentYear();
        Integer startAge = dto.getStartAge();
        int currentAge = dto.getAge();

        // 基础年金系数：根据缴费年限确定基础给付比例
        BigDecimal baseRatio;
        switch (paymentYear) {
            case 1: baseRatio = BigDecimal.valueOf(0.06); break;
            case 3: baseRatio = BigDecimal.valueOf(0.065); break;
            case 5: baseRatio = BigDecimal.valueOf(0.07); break;
            case 10: baseRatio = BigDecimal.valueOf(0.075); break;
            case 15: baseRatio = BigDecimal.valueOf(0.08); break;
            case 20: baseRatio = BigDecimal.valueOf(0.085); break;
            case 30: baseRatio = BigDecimal.valueOf(0.09); break;
            default: baseRatio = BigDecimal.valueOf(0.07); break;
        }

        BigDecimal annualPayout = annualPremium.multiply(baseRatio);

        // 如果有起始领取年龄，根据领取延迟时间调整（延迟领取，年金更高）
        if (startAge != null && startAge > currentAge) {
            int delayYears = startAge - currentAge;
            // 每年延迟增加约2%的年金
            BigDecimal delayBonus = BigDecimal.valueOf(1 + delayYears * 0.02);
            annualPayout = annualPayout.multiply(delayBonus);
        }

        return annualPayout;
    }
}
