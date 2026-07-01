package com.insurance.api.vip.vo;

import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * VIP状态VO
 */
@Data
public class VipStatusVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 用户ID */
    private Long userId;

    /** 用户名 */
    private String username;

    /** 当前会员等级（0-普通，1-VIP，2-SVIP） */
    private Integer memberLevel;

    /** 会员等级描述 */
    private String memberLevelDesc;

    /** 是否VIP */
    private Boolean isVip;

    /** 会员过期时间 */
    private LocalDateTime memberExpireTime;

    /** 是否已过期 */
    private Boolean isExpired;
}
