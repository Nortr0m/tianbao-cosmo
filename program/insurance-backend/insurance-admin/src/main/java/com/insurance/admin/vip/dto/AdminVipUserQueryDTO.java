package com.insurance.admin.vip.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * VIP用户查询DTO
 */
@Data
public class AdminVipUserQueryDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 页码 */
    private Integer pageNum = 1;

    /** 每页数量 */
    private Integer pageSize = 10;

    /** 用户名 */
    private String username;

    /** 会员等级 */
    private Integer memberLevel;

    /** 状态 */
    private Integer status;
}
