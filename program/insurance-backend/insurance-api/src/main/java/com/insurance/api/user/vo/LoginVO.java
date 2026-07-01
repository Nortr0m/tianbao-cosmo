package com.insurance.api.user.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 登录响应VO
 */
@Data
public class LoginVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 访问Token */
    private String accessToken;

    /** 刷新Token */
    private String refreshToken;

    /** Token类型 */
    private String tokenType = "Bearer";

    /** 过期时间（秒） */
    private Long expiresIn;

    /** 用户信息 */
    private UserInfoVO userInfo;
}
