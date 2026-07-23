package com.insurance.admin.vip.vo;

import lombok.Data;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * VIP用户VO
 */
@Data
public class AdminVipUserVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 用户ID */
    private Long userId;

    /** 用户名 */
    private String username;

    /** 昵称 */
    private String nickname;

    /** 手机号 */
    private String phone;

    /** 会员等级（0-普通，1-VIP，2-SVIP） */
    private Integer memberLevel;

    /** 会员等级描述 */
    private String memberLevelDesc;

    /** 会员过期时间 */
    private LocalDateTime memberExpireTime;

    /** 状态（0-禁用，1-正常） */
    private Integer status;

    /** 注册时间 */
    private LocalDateTime createdAt;
}
