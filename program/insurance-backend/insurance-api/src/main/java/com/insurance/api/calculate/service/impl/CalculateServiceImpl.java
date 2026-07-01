package com.insurance.api.calculate.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.insurance.api.calculate.dto.AnnuityProjectionDTO;
import com.insurance.api.calculate.dto.CriticalPremiumDTO;
import com.insurance.api.calculate.dto.WholeLifeProjectionDTO;
import com.insurance.api.calculate.service.CalculateService;
import com.insurance.api.calculate.vo.*;
import com.insurance.api.entity.*;
import com.insurance.api.mapper.*;
import com.insurance.common.exception.BusinessException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

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
    private final AnnuityProductMapper annuityProductMapper;

    @Override
    public CriticalPremiumVO calculateCriticalPremium(CriticalPremiumDTO dto) {
        ProductBase product = productBaseMapper.selectById(dto.getProductId());
        if (product == null) {
            throw new BusinessException("产品不存在");
        }
        if (product.getProductType() != 1) {
            throw new BusinessException("该产品不是重疾险");
        }

        LambdaQueryWrapper<PremiumRate> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(PremiumRate::getProductId, dto.getProductId())
                .eq(PremiumRate::getGender, dto.getGender())
                .eq(PremiumRate::getAge, dto.getAge())
                .eq(PremiumRate::getPaymentYear, dto.getPaymentYear())
                .eq(PremiumRate::getHealthStatus, 0)
                .last("LIMIT 1");
        PremiumRate rate = premiumRateMapper.selectOne(wrapper);

        BigDecimal premiumPerK = rate != null ? rate.getPremiumPerK() : BigDecimal.ZERO;
        // 保额单位为万元，转换为千元：coverage * 10000 / 1000 = coverage * 10
        BigDecimal coverageK = dto.getCoverage().multiply(BigDecimal.valueOf(10));
        BigDecimal annualPremium = premiumPerK.multiply(coverageK).setScale(2, RoundingMode.HALF_UP);

        CriticalPremiumVO vo = new CriticalPremiumVO();
        vo.setProductId(dto.getProductId());
        vo.setProductName(product.getProductName());
        vo.setGender(dto.getGender());
        vo.setAge(dto.getAge());
        vo.setPaymentYear(dto.getPaymentYear());
        vo.setCoverage(dto.getCoverage());
        vo.setPremiumPerK(premiumPerK);
        vo.setAnnualPremium(annualPremium);

        if (product.getMonthlyRatio() != null) {
            vo.setMonthlyPremium(annualPremium.multiply(product.getMonthlyRatio()).setScale(2, RoundingMode.HALF_UP));
        }
        if (product.getQuarterlyRatio() != null) {
            vo.setQuarterlyPremium(annualPremium.multiply(product.getQuarterlyRatio()).setScale(2, RoundingMode.HALF_UP));
        }
        if (product.getHalfYearlyRatio() != null) {
            vo.setHalfYearlyPremium(annualPremium.multiply(product.getHalfYearlyRatio()).setScale(2, RoundingMode.HALF_UP));
        }
        vo.setTotalPremium(annualPremium.multiply(BigDecimal.valueOf(dto.getPaymentYear())).setScale(2, RoundingMode.HALF_UP));
        return vo;
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
        BigDecimal payoutRatio;
        if (currentAge < 18) {
            payoutRatio = new BigDecimal("1.6");
        } else if (currentAge <= 40) {
            payoutRatio = new BigDecimal("1.6");
        } else if (currentAge <= 60) {
            payoutRatio = new BigDecimal("1.4");
        } else {
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

        List<AnnuityYearlyVO> projections = new ArrayList<>();
        BigDecimal annualPayout = BigDecimal.ZERO;
        BigDecimal monthlyPayout = BigDecimal.ZERO;

        if (rates != null && !rates.isEmpty()) {
            // 模式一：查表模式（表中数据为每千元保费对应值）
            BigDecimal totalReceived = BigDecimal.ZERO;
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
                yvo.setDeathBenefit(deathBen.setScale(2, RoundingMode.HALF_UP));
                yvo.setTotalReceived(totalReceived.setScale(2, RoundingMode.HALF_UP));
                projections.add(yvo);
            }
        }

        LambdaQueryWrapper<AnnuityProduct> apWrapper = new LambdaQueryWrapper<>();
        apWrapper.eq(AnnuityProduct::getProductId, dto.getProductId());
        AnnuityProduct annuityProduct = annuityProductMapper.selectOne(apWrapper);
        if (annuityProduct != null && annuityProduct.getMonthlyCoefficient() != null) {
            monthlyPayout = annualPayout.multiply(annuityProduct.getMonthlyCoefficient()).setScale(2, RoundingMode.HALF_UP);
        } else {
            monthlyPayout = annualPayout.divide(BigDecimal.valueOf(12), 2, RoundingMode.HALF_UP);
        }

        AnnuityProjectionVO vo = new AnnuityProjectionVO();
        vo.setProductId(dto.getProductId());
        vo.setProductName(product.getProductName());
        vo.setGender(dto.getGender());
        vo.setAge(dto.getAge());
        vo.setPaymentYear(dto.getPaymentYear());
        vo.setAnnualPremium(dto.getAnnualPremium());
        vo.setTotalPremium(totalPremium.setScale(2, RoundingMode.HALF_UP));
        vo.setStartAge(dto.getStartAge());
        vo.setAnnualPayout(annualPayout.setScale(2, RoundingMode.HALF_UP));
        vo.setMonthlyPayout(monthlyPayout);
        vo.setYearlyProjections(projections);
        return vo;
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
