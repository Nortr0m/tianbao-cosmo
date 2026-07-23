package com.insurance.admin.product.dto;

import lombok.Data;

import java.math.BigDecimal;

/**
 * 重疾险费率导入DTO
 */
@Data
public class PremiumRateImportDTO {

    /** 组合编码 */
    private Integer comboCode;

    /** 性别（0-女，1-男） */
    private Integer gender;

    /** 投保年龄 */
    private Integer age;

    /** 缴费年限 */
    private Integer paymentYear;

    /** 每千元保额保费 */
    private BigDecimal premiumPerK;

    /** 健康状态（0-标准体，1-非标体） */
    private Integer healthStatus;
}
