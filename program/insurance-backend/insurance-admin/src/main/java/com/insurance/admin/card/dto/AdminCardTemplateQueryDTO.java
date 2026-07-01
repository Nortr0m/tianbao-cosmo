package com.insurance.admin.card.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 管理员卡片模板查询DTO - 支持keyword模糊搜索
 */
@Data
public class AdminCardTemplateQueryDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 页码 */
    private Integer pageNum = 1;

    /** 每页数量 */
    private Integer pageSize = 10;

    /** 关键词（搜索模板名称和搜索关键词） */
    private String keyword;

    /** 模板名称 */
    private String templateName;

    /** 分类编码 */
    private String categoryCode;

    /** 是否启用 */
    private Integer isActive;
}