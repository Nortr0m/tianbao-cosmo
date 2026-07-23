package com.insurance.api.user.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.io.Serializable;

/**
 * 微信小程序登录DTO
 */
@Data
public class WechatMpLoginDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 微信小程序登录code */
    @NotBlank(message = "微信登录code不能为空")
    private String code;

    /** 昵称（可选，用户授权后获取） */
    private String nickname;

    /** 头像URL（可选，用户授权后获取） */
    private String avatarUrl;
}
