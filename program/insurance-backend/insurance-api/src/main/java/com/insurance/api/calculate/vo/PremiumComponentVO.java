package com.insurance.api.calculate.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 保费构成明细VO
 */
@Data
public class PremiumComponentVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 责任项编码 */
    private String itemCode;

    /** 责任项名称 */
    private String itemName;

    /** 选中的选项 */
    private String selectedOption;

    /** 保费系数 */
    private BigDecimal coefficient;

    /** 附加保费（年缴） */
    private BigDecimal additionalPremium;

    /** 是否必选 */
    private Boolean isRequired;
}
