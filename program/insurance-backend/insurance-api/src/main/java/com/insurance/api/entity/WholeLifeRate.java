package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;

/**
 * 增额终身寿险费率实体
 */
@Data
@TableName("whole_life_rate")
public class WholeLifeRate {

    private static final long serialVersionUID = 1L;

    /** 费率ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long rateId;

    /** 产品ID */
    private Long productId;

    /** 性别（0-女，1-男） */
    private Integer gender;

    /** 投保年龄 */
    private Integer age;

    /** 缴费年限 */
    private Integer paymentYear;

    /** 保单年度 */
    private Integer policyYear;

    /** 现金价值 */
    private BigDecimal cashValue;

    /** 身故保险金 */
    private BigDecimal deathBenefit;
}
