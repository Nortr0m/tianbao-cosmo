package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;

/**
 * 祝寿金配置实体
 */
@Data
@TableName("annuity_birthday_bonus")
public class AnnuityBirthdayBonus {

    private static final long serialVersionUID = 1L;

    /** 祝寿金ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long bonusId;

    /** 产品ID */
    private Long productId;

    /** 祝寿金领取年龄 */
    private Integer bonusAge;

    /** 祝寿金类型（1-固定金额，2-比例） */
    private Integer bonusType;

    /** 祝寿金金额/比例 */
    private BigDecimal bonusValue;

    /** 祝寿金描述 */
    private String bonusDesc;

    /** 是否启用（0-禁用，1-启用） */
    private Integer isActive;

    /** 排序 */
    private Integer sortOrder;
}
