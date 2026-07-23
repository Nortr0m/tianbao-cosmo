package com.insurance.admin.card.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 管理员更新卡片分类DTO
 */
@Data
public class AdminCardCategoryUpdateDTO implements Serializable {

    private static final long serialVersionUID = 1L;

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
