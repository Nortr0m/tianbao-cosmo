package com.insurance.admin.card.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 管理员卡片分类查询DTO
 */
@Data
public class AdminCardCategoryQueryDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 页码 */
    private Integer pageNum = 1;

    /** 每页数量 */
    private Integer pageSize = 10;

    /** 分类编码 */
    private String categoryCode;

    /** 分类名称 */
    private String categoryName;

    /** 是否启用 */
    private Integer isActive;
}
