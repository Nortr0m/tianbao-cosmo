package com.insurance.api.card.dto;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 生成卡片参数DTO
 */
@Data
public class CardGenerateDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 产品ID */
    private Long productId;

    /** 模板ID */
    private Long templateId;

    /** 年龄 */
    private Integer age;

    /** 性别（1-男，2-女） */
    private Integer gender;

    /** 缴费期限 */
    private String paymentPeriod;

    /** 保额 */
    private BigDecimal coverage;

    /** 年缴保费 */
    private BigDecimal premium;

    /** 水印文字 */
    private String watermark;

    /** 自定义参数（JSON字符串） */
    private String customParams;
}
