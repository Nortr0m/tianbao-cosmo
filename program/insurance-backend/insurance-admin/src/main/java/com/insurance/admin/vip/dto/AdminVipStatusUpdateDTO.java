package com.insurance.admin.vip.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * VIP用户状态更新DTO
 */
@Data
public class AdminVipStatusUpdateDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 状态（0-禁用，1-正常） */
    private Integer status;
}