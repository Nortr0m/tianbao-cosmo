package com.insurance.api.card.vo;

import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 使用卡片模板响应VO
 */
@Data
public class CardTemplateUseVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 模板ID */
    private Long templateId;

    /** 模板名称 */
    private String templateName;

    /** 使用结果 */
    private Boolean success;

    /** 使用次数 */
    private Integer useCountTotal;

    /** 使用时间 */
    private LocalDateTime usedTime;
}
