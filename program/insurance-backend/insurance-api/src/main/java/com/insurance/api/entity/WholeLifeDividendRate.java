package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 增额终身寿险分红演示实体
 */
@Data
@TableName("whole_life_dividend_rate")
public class WholeLifeDividendRate {
    @TableId(type = IdType.ASSIGN_ID)
    private Long rateId;
    private Long productId;
    private Integer gender;                      // 0=女，1=男
    private Integer age;                         // 投保年龄
    private Integer paymentYear;                 // 缴费年限
    private Integer policyYear;                  // 保单年度
    private BigDecimal cashValueGuaranteed;       // 保证部分现金价值
    private BigDecimal cashValueMidDividend;       // 含中档分红现金价值
    private BigDecimal cashValueHighDividend;      // 含高档分红现金价值
    private BigDecimal deathBenefitGuaranteed;     // 保证部分身故保险金
    private BigDecimal deathBenefitMidDividend;     // 含中档分红身故保险金
    private BigDecimal deathBenefitHighDividend;    // 含高档分红身故保险金
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
