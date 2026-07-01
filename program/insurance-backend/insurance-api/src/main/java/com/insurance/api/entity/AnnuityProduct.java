package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;

/**
 * 年金险子类实体
 */
@Data
@TableName("annuity_product")
public class AnnuityProduct {

    private static final long serialVersionUID = 1L;

    /** 主键ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long id;

    /** 产品ID */
    private Long productId;

    /** 女性起始领取年龄（JSON数组） */
    private String startAgeFemale;

    /** 男性起始领取年龄（JSON数组） */
    private String startAgeMale;

    /** 是否支持月领（0-否，1-是） */
    private Integer supportMonthly;

    /** 月领系数 */
    private BigDecimal monthlyCoefficient;

    /** 保证领取选项（JSON数组） */
    private String guaranteeOptions;

    /** 是否支持递增（0-否，1-是） */
    private Integer supportIncrease;

    /** 递增比例选项（JSON数组） */
    private String increaseRateOptions;

    /** 递增截止年份 */
    private Integer increaseEndYear;
}
