package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;

/**
 * 增额终身寿险子类实体
 */
@Data
@TableName("whole_life_product")
public class WholeLifeProduct {

    private static final long serialVersionUID = 1L;

    /** 主键ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long id;

    /** 产品ID */
    private Long productId;

    /** 减保规则类型（1-每年最多20%，2-无限制） */
    private Integer reductionRuleType;

    /** 减保起始年份 */
    private Integer reductionStartYear;

    /** 减保次数限制（0-不限） */
    private Integer reductionTimesLimit;

    /** 最大加保年龄 */
    private Integer maxAddAge;

    /** 加保保费规则（1-按新年龄，2-按原年龄） */
    private Integer addPremiumRule;

    /** 加保次数限制（0-不限） */
    private Integer addTimesLimit;

    /** 加保比例限制 */
    private Integer addRatioLimit;

    /** 保单贷款比例 */
    private BigDecimal loanRatio;

    /** 保单贷款利率 */
    private BigDecimal loanRate;

    /** 保额递增比例 */
    private BigDecimal increaseRate;

    /** 递增截止年龄 */
    private Integer increaseEndAge;

    /** 支持年龄列表（JSON数组） */
    private String supportAgeList;

    /** 减保限制规则文字版 */
    private String reductionRuleText;
    /** 加保规则文字说明 */
    private String addRuleText;
    /** 第二投保人规则 */
    private String secondApplicantRule;
    /** 是否支持隔代投保 */
    private Integer crossGeneration;
    /** 是否支持信托对接 */
    private Integer trustLinkage;
    /** 最低保费要求 */
    private BigDecimal minPremium;
    /** 最低保额要求 */
    private BigDecimal minSumAssured;
    /** 健康分级规则 */
    private String healthClass;
    /** 典型费率示例 */
    private String typicalRateExample;
    /** 身故赔付规则(K值说明) */
    private String deathPayoutRule;
}
