package com.insurance.api.user.controller;

import com.insurance.api.user.dto.LoginDTO;
import com.insurance.api.user.dto.RefreshTokenDTO;
import com.insurance.api.user.dto.RegisterDTO;
import com.insurance.api.user.service.UserService;
import com.insurance.api.user.vo.LoginVO;
import com.insurance.api.user.vo.UserInfoVO;
import com.insurance.common.result.Result;
import com.insurance.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 用户认证Controller
 */
@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;

    /**
     * 用户注册
     */
    @PostMapping("/auth/register")
    public Result<LoginVO> register(@Validated @RequestBody RegisterDTO registerDTO) {
        return Result.success(userService.register(registerDTO));
    }

    /**
     * 用户登录
     */
    @PostMapping("/auth/login")
    public Result<LoginVO> login(@Validated @RequestBody LoginDTO loginDTO) {
        return Result.success(userService.login(loginDTO));
    }

    /**
     * 刷新Token
     */
    @PostMapping("/auth/refresh")
    public Result<LoginVO> refreshToken(@Validated @RequestBody RefreshTokenDTO refreshTokenDTO) {
        return Result.success(userService.refreshToken(refreshTokenDTO));
    }

    /**
     * 检查用户名是否已存在
     */
    @GetMapping("/auth/check-username")
    public Result<Boolean> checkUsername(@RequestParam String username) {
        return Result.success(userService.isUsernameExists(username));
    }

    /**
     * 获取当前用户信息
     */
    @GetMapping("/user/info")
    public Result<UserInfoVO> getUserInfo() {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return Result.unauthorized("请先登录");
        }
        return Result.success(userService.getUserInfo(userId));
    }
}
