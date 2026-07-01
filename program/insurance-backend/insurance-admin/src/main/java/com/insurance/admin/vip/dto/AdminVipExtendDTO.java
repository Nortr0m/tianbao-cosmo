package com.insurance.admin.vip.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * VIP会员延期DTO
 */
@Data
public class AdminVipExtendDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 延期天数 */
    private Integer days;
}