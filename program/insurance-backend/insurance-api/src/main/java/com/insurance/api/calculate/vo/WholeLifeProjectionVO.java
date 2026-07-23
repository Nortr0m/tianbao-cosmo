package com.insurance.api.calculate.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * 增额终身寿险收益测算结果VO
 */
@Data
public class WholeLifeProjectionVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 产品ID */
    private Long productId;

    /** 产品名称 */
    private String productName;

    /** 性别 */
    private Integer gender;

    /** 投保年龄 */
    private Integer age;

    /** 缴费年限 */
    private Integer paymentYear;

    /** 年缴保费 */
    private BigDecimal annualPremium;

    /** 总保费 */
    private BigDecimal totalPremium;

    /** 年度收益列表 */
    private List<YearlyProjectionVO> yearlyProjections;
}
