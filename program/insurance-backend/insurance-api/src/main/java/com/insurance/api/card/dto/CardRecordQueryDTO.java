package com.insurance.api.card.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 卡片记录查询DTO
 */
@Data
public class CardRecordQueryDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 页码 */
    private Integer pageNum = 1;

    /** 每页数量 */
    private Integer pageSize = 10;

    /** 模板ID */
    private Long templateId;

    /** 产品ID */
    private Long productId;
}
