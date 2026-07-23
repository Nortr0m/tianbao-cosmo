package com.insurance.admin.product.dto;

import lombok.Data;
import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 年金险费率导入行DTO
 */
@Data
public class AnnuityRateImportDTO implements Serializable {
    private Integer gender;
    private Integer age;
    private Integer paymentYear;
    private Integer startAge;
    private String planId;
    private Integer policyYear;
    private BigDecimal annualPayout;
    private BigDecimal cashValue;
    private BigDecimal deathBenefit;
}
