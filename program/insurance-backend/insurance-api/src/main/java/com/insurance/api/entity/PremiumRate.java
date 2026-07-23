package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;

/**
 * 重疾险费率实体
 */
@Data
@TableName("premium_rate")
public class PremiumRate {

    private static final long serialVersionUID = 1L;

    /** 费率ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long rateId;

    /** 产品ID */
    private Long productId;

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
