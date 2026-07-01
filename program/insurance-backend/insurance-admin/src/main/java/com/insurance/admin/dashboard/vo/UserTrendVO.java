package com.insurance.admin.dashboard.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 用户增长趋势VO
 */
@Data
public class UserTrendVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 日期 */
    private String date;

    /** 新增用户 */
    private Long newUsers;

    /** 活跃用户 */
    private Long activeUsers;

    /** VIP用户 */
    private Long vipUsers;
}
