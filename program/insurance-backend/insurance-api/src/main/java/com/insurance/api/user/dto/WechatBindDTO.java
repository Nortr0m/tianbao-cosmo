package com.insurance.api.user.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.io.Serializable;

/**
 * 微信绑定DTO
 */
@Data
public class WechatBindDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 微信授权code（用于换取openid） */
    @NotBlank(message = "微信授权code不能为空")
    private String code;

    /** 微信昵称（可选） */
    private String nickname;

    /** 微信头像（可选） */
    private String avatarUrl;
}
