package com.insurance.admin.card.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.io.Serializable;

/**
 * 管理员创建卡片模板DTO
 */
@Data
public class AdminCardTemplateCreateDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 模板名称 */
    @NotBlank(message = "模板名称不能为空")
    private String templateName;

    /** 分类编码 */
    private String categoryCode;

    /** 标签（JSON数组） */
    private String tags;

    /** AI提示词 */
    private String aiPrompt;

    /** 搜索关键词 */
    private String searchKeywords;

    /** 背景图片地址 */
    private String backgroundUrl;

    /** 默认标题 */
    private String defaultTitle;

    /** 默认副标题 */
    private String defaultSubtitle;

    /** 是否系统模板（0-否，1-是） */
    private Integer isSystem;

    /** 是否推荐（0-否，1-是） */
    private Integer isRecommended;

    /** 排序 */
    private Integer sortOrder;

    /** 是否启用（0-禁用，1-启用） */
    private Integer isActive;
}
