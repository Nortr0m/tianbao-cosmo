package com.insurance.admin.auth.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 管理员登录响应VO
 */
@Data
public class AdminLoginVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 访问Token */
    private String accessToken;

    /** Token类型 */
    private String tokenType = "Bearer";

    /** 过期时间（秒） */
    private Long expiresIn;

    /** 管理员信息 */
    private AdminInfoVO adminInfo;
}
