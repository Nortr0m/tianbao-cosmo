package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("product_terms")
public class ProductTerms {
    @TableId(value = "terms_id", type = IdType.AUTO)
    private Long termsId;
    private Long productId;
    /** 保险期间 */
    private String insurancePeriod;
    /** 犹豫期 */
    private String hesitationPeriod;
    /** 等待期 */
    private String waitingPeriod;
    /** 保险责任摘要 */
    private String liabilitySummary;
    /** 责任免除条款概要 */
    private String exclusionSummary;
    /** 其他权益 */
    private String otherRights;
    /** 销售区域 */
    private String saleRegion;
    /** 原始条款完整JSON */
    private String productTermsRaw;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Integer isDeleted;
}
