package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 卡片分类实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("card_category")
public class CardCategory extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 分类ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long categoryId;

    /** 分类编码 */
    private String categoryCode;

    /** 分类名称 */
    private String categoryName;

    /** 分类图标 */
    private String categoryIcon;

    /** 排序 */
    private Integer sortOrder;

    /** 是否启用（0-禁用，1-启用） */
    private Integer isActive;
}
