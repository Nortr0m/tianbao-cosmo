package com.insurance.api.user.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.io.Serializable;

/**
 * 刷新Token DTO
 */
@Data
public class RefreshTokenDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 刷新Token */
    @NotBlank(message = "刷新Token不能为空")
    private String refreshToken;
}
