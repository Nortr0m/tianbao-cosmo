package com.insurance.api.card.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 卡片记录详情VO
 */
@Data
public class CardRecordVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 记录ID */
    private Long recordId;

    /** 用户ID */
    private Long userId;

    /** 模板ID */
    private Long templateId;

    /** 产品ID */
    private Long productId;

    /** 卡片标题 */
    private String cardTitle;

    /** 卡片副标题 */
    private String cardSubtitle;

    /** 背景图URL */
    private String backgroundUrl;

    /** 生成的图片URL */
    private String generatedImageUrl;

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

    /** 生成时间 */
    private LocalDateTime generateTime;

    /** 创建时间 */
    private LocalDateTime createdAt;

    /** 更新时间 */
    private LocalDateTime updatedAt;
}
