package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 产品资料完整度实体
 */
@Data
@TableName("product_document_status")
public class ProductDocumentStatus {

    private static final long serialVersionUID = 1L;

    /** 产品ID */
    @TableId(type = IdType.INPUT)
    private Long productId;

    /** 是否有保险条款 */
    private Boolean hasTerms;

    /** 是否有产品说明书 */
    private Boolean hasBrochure;

    /** 是否有投保规则 */
    private Boolean hasRules;

    /** 是否有费率表 */
    private Boolean hasRateTable;

    /** 是否有现金价值表 */
    private Boolean hasCashValue;

    /** 产品资料文件夹路径 */
    private String folderPath;

    /** 更新时间 */
    private LocalDateTime updateTime;
}
