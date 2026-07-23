package com.insurance.api.calculate.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 重疾险保费计算DTO
 */
@Data
public class CriticalPremiumDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 产品ID */
    @NotNull(message = "产品ID不能为空")
    private Long productId;

    /** 性别（0-女，1-男） */
    @NotNull(message = "性别不能为空")
    private Integer gender;

    /** 投保年龄 */
    @NotNull(message = "投保年龄不能为空")
    private Integer age;

    /** 缴费年限 */
    private Integer paymentYear;

    /** 缴费年限（兼容字段，同 paymentYear） */
    private Integer paymentPeriod;

    /** 保额（万元） */
    @NotNull(message = "保额不能为空")
    private BigDecimal coverage;

    /** 责任配置（JSON格式：键为责任项编码，值为选中的选项） */
    private String responsibilityConfig;
}
