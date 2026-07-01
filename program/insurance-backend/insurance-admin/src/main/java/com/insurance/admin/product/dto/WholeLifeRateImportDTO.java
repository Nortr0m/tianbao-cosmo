package com.insurance.admin.product.dto;

import lombok.Data;
import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 增额寿费率导入行DTO
 */
@Data
public class WholeLifeRateImportDTO implements Serializable {
    private Integer gender;
    private Integer age;
    private Integer paymentYear;
    private Integer policyYear;
    private BigDecimal cashValue;
    private BigDecimal deathBenefit;
}
