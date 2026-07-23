package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 卡片生成记录实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("card_record")
public class CardRecord extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 记录ID */
    @TableId(type = IdType.ASSIGN_ID)
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

    /** 自定义参数（JSON对象） */
    private String customParams;

    /** 生成时间 */
    private LocalDateTime generateTime;
}
