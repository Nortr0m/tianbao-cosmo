package com.insurance.admin.card.vo;

import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 管理员卡片分类VO
 */
@Data
public class AdminCardCategoryVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 分类ID */
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

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;
}
