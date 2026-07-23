package com.insurance.admin.product.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 管理员产品查询DTO
 */
@Data
public class AdminProductQueryDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 页码 */
    private Integer pageNum = 1;

    /** 每页数量 */
    private Integer pageSize = 10;

    /** 搜索关键词 */
    private String keyword;

    /** 保险公司ID */
    private Long companyId;

    /** 产品类型 */
    private Integer productType;

    /** 系统状态 */
    private Integer systemStatus;

    /** 销售状态 */
    private Integer saleStatus;

    /** 维护状态 */
    private Integer maintenanceStatus;
}
