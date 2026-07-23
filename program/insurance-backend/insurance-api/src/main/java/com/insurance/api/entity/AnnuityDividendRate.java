package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("annuity_dividend_rate")
public class AnnuityDividendRate {
    @TableId(value = "rate_id", type = IdType.AUTO)
    private Long rateId;
    private Long productId;
    private Integer gender;
    private Integer age;
    private Integer paymentYear;
    private Integer startAge;
    private Integer policyYear;

    /** 保证年领取金额 */
    private BigDecimal annualPayoutGuaranteed;
    /** 中档分红年领取金额 */
    private BigDecimal annualPayoutMidDividend;
    /** 高档分红年领取金额 */
    private BigDecimal annualPayoutHighDividend;

    /** 保证现金价值 */
    private BigDecimal cashValueGuaranteed;
    /** 中档分红现金价值 */
    private BigDecimal cashValueMidDividend;
    /** 高档分红现金价值 */
    private BigDecimal cashValueHighDividend;

    /** 保证身故保险金 */
    private BigDecimal deathBenefitGuaranteed;
    /** 中档分红身故保险金 */
    private BigDecimal deathBenefitMidDividend;
    /** 高档分红身故保险金 */
    private BigDecimal deathBenefitHighDividend;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
