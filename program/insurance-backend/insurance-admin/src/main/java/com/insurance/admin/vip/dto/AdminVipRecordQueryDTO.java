package com.insurance.admin.vip.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * VIP记录查询DTO
 */
@Data
public class AdminVipRecordQueryDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 页码 */
    private Integer pageNum = 1;

    /** 每页数量 */
    private Integer pageSize = 10;

    /** 用户ID */
    private Long userId;

    /** 会员等级 */
    private Integer memberLevel;

    /** 状态 */
    private Integer status;
}
