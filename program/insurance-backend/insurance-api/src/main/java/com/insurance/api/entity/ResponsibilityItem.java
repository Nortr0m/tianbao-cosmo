package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 二级责任项实体
 */
@Data
@TableName("responsibility_item")
public class ResponsibilityItem {

    private static final long serialVersionUID = 1L;

    /** 责任项ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long itemId;

    /** 分类ID */
    private Long categoryId;

    /** 责任项编码 */
    private String itemCode;

    /** 责任项名称 */
    private String itemName;

    /** 选项配置（JSON数组） */
    private String options;

    /** 排序 */
    private Integer sortOrder;

    /** 是否系统项（0-否，1-是） */
    private Integer isSystem;

    /** 是否启用（0-禁用，1-启用） */
    private Integer isActive;
}
