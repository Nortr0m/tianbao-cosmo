package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 产品-疾病关联实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("product_disease")
public class ProductDisease extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 主键ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 产品ID */
    private Long productId;

    /** 疾病ID */
    private Long diseaseId;

    /** 在该产品中的分类：1=重疾, 2=中症, 3=轻症（同一疾病在不同产品可能分类不同） */
    private Integer diseaseType;

    /** 赔付比例（%），如100表示100%保额 */
    private Integer payoutRatio;

    /** 赔付次数 */
    private Integer payoutTimes;

    /** 多次赔付间隔天数 */
    private Integer intervalDays;

    /** 等待期（天） */
    private Integer waitingPeriodDays;

    /** 是否基础责任：0=可选, 1=基础 */
    private Integer isBasic;

    /** 关联的责任项编码 */
    private String responsibilityCode;

    /** 排序 */
    private Integer sortOrder;
}
