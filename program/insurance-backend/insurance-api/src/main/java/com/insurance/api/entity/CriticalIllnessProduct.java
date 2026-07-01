package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 重疾险子类实体
 */
@Data
@TableName("critical_illness_product")
public class CriticalIllnessProduct {

    private static final long serialVersionUID = 1L;

    /** 主键ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long id;

    /** 产品ID */
    private Long productId;

    /** 等待期（天） */
    private Integer waitingPeriod;

    /** 等待期规则（1-发病日期，2-确诊日期） */
    private Integer waitingPeriodRule;

    /** 重疾种类数量 */
    private Integer criticalCount;

    /** 重疾赔付比例 */
    private Integer criticalRatio;

    /** 中症种类数量 */
    private Integer mediumCount;

    /** 中症赔付比例 */
    private Integer mediumRatio;

    /** 轻症种类数量 */
    private Integer lightCount;

    /** 轻症赔付比例 */
    private Integer lightRatio;

    /** 重疾多次赔付间隔（年） */
    private Integer criticalMultiInterval;

    /** 癌症多次赔付间隔（年） */
    private Integer cancerMultiInterval;

    /** 心脑血管疾病多次赔付间隔（年） */
    private Integer cvdMultiInterval;

    /** 疾病关爱金保障年龄 */
    private Integer diseaseCareAge;

    /** 疾病关爱金重疾赔付比例 */
    private Integer diseaseCareCriticalRatio;

    /** 疾病关爱金中症赔付比例 */
    private Integer diseaseCareMediumRatio;

    /** 疾病关爱金轻症赔付比例 */
    private Integer diseaseCareLightRatio;
}
