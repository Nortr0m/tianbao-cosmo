package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 产品编码映射实体
 */
@Data
@TableName("product_encoding_map")
public class ProductEncodingMap {

    private static final long serialVersionUID = 1L;

    /** 映射ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long mapId;

    /** 产品ID */
    private Long productId;

    /** 责任分类 */
    private String respCategory;

    /** 责任编码 */
    private String respCode;

    /** 责任名称 */
    private String respName;

    /** 位位置 */
    private Integer bitPosition;

    /** 位掩码 */
    private Integer bitMask;

    /** 选项配置（JSON数组） */
    private String options;

    /** 是否启用（0-禁用，1-启用） */
    private Integer isActive;
}
