package com.insurance.api.card.vo;

import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 卡片生成结果VO
 */
@Data
public class CardGenerateResultVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 记录ID */
    private Long recordId;

    /** 生成的图片URL */
    private String imageUrl;

    /** 生成时间 */
    private LocalDateTime generateTime;
}
