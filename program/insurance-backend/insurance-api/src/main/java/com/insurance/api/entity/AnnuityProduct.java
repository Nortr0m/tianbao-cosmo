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

    /** 年金类型(养老年金/教育年金/普通年金) */
    private String annuityType;
    /** 领取方式文字版 */
    private String payoutRuleText;
    /** 是否终身领取 */
    private Integer isLifelong;
    /** 起投金额 */
    private BigDecimal minPremium;
    /** 身故保险金规则 */
    private String deathBenefitRule;
    /** 是否关联万能账户 */
    private Integer universalAccountLinked;
    /** 万能账户名称 */
    private String universalAccountName;
    /** 万能账户保底利率 */
    private BigDecimal universalGuaranteedRate;
    /** 是否对接养老社区 */
    private Integer communityLinkage;
    /** 养老社区名称 */
    private String communityName;
    /** 首次返还时间/规则 */
    private String firstReturnTime;
    /** 返还频率 */
    private String returnFrequency;
    /** 每期返还金额规则 */
    private String returnAmountRule;
    /** 典型费率示例 */
    private String typicalRateExample;
}
