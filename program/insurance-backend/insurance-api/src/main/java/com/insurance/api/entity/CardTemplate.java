package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * 卡片模板实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("card_template")
public class CardTemplate extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 模板ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long templateId;

    /** 模板名称 */
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

    /** 7日使用次数 */
    private Integer useCount7d;

    /** 30日使用次数 */
    private Integer useCount30d;

    /** 总使用次数 */
    private Integer useCountTotal;

    /** 最后使用时间 */
    private LocalDateTime lastUsedTime;

    /** 排序 */
    private Integer sortOrder;

    /** 是否启用（0-禁用，1-启用） */
    private Integer isActive;
}
