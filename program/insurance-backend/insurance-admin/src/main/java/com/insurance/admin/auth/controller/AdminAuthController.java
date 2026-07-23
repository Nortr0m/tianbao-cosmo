package com.insurance.admin.auth.controller;

import com.insurance.admin.auth.dto.AdminLoginDTO;
import com.insurance.admin.auth.service.AdminAuthService;
import com.insurance.admin.auth.vo.AdminInfoVO;
import com.insurance.admin.auth.vo.AdminLoginVO;
import com.insurance.common.result.Result;
import com.insurance.common.utils.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 管理员认证Controller
 */
@RestController
@RequestMapping("/api/v1/admin/auth")
@RequiredArgsConstructor
public class AdminAuthController {

    private final AdminAuthService adminAuthService;

    /**
     * 管理员登录
     */
    @PostMapping("/login")
    public Result<AdminLoginVO> login(@Validated @RequestBody AdminLoginDTO loginDTO) {
        return Result.success(adminAuthService.login(loginDTO));
    }

    /**
     * 获取当前管理员信息
     */
    @GetMapping("/info")
    public Result<AdminInfoVO> getAdminInfo(HttpServletRequest request) {
        String token = extractToken(request);
        if (token == null) {
            return Result.unauthorized("未登录");
        }
        Long adminId = JwtUtil.getUserId(token);
        if (adminId == null) {
            return Result.unauthorized("无效的token");
        }
        return Result.success(adminAuthService.getAdminInfo(adminId));
    }

    /**
     * 管理员登出
     */
    @PostMapping("/logout")
    public Result<Void> logout() {
        // 无状态JWT，客户端清除token即可
        return Result.success();
    }

    /**
     * 刷新token
     */
    @PostMapping("/refresh")
    public Result<AdminLoginVO> refreshToken(HttpServletRequest request) {
        String token = extractToken(request);
        if (token == null) {
            return Result.unauthorized("未登录");
        }
        Long adminId = JwtUtil.getUserId(token);
        if (adminId == null) {
            return Result.unauthorized("无效的token");
        }
        return Result.success(adminAuthService.refreshToken(adminId));
    }

    private String extractToken(HttpServletRequest request) {
        String bearer = request.getHeader("Authorization");
        if (bearer != null && bearer.startsWith("Bearer ")) {
            return bearer.substring(7);
        }
        return null;
    }
}
