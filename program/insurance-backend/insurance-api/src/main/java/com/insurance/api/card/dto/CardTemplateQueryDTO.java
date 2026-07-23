package com.insurance.api.card.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 卡片模板查询DTO
 */
@Data
public class CardTemplateQueryDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 页码 */
    private Integer pageNum = 1;

    /** 每页数量 */
    private Integer pageSize = 10;

    /** 模板名称 */
    private String templateName;

    /** 分类编码 */
    private String categoryCode;

    /** 是否推荐 */
    private Integer isRecommended;
}
