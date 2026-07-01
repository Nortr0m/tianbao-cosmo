package com.insurance.admin.auth.vo;

import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 管理员信息VO
 */
@Data
public class AdminInfoVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 管理员ID */
    private Long adminId;

    /** 用户名 */
    private String username;

    /** 真实姓名 */
    private String realName;

    /** 手机号 */
    private String phone;

    /** 邮箱 */
    private String email;

    /** 头像地址 */
    private String avatarUrl;

    /** 角色ID */
    private Long roleId;

    /** 状态（0-禁用，1-正常） */
    private Integer status;

    /** 最后登录时间 */
    private LocalDateTime lastLoginTime;
}
