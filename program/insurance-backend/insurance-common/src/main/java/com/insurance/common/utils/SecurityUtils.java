package com.insurance.common.utils;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

/**
 * 安全工具类
 */
public final class SecurityUtils {

    private SecurityUtils() {
    }

    /**
     * 获取当前登录用户ID
     * 优先从request attribute获取（由JwtAuthenticationFilter设置），
     * 其次尝试从SecurityContext的principal解析。
     *
     * @return 用户ID
     */
    public static Long getCurrentUserId() {
        // 优先从request attribute获取
        ServletRequestAttributes attrs = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attrs != null) {
            Object userIdObj = attrs.getRequest().getAttribute("userId");
            if (userIdObj instanceof Long) {
                return (Long) userIdObj;
            }
            if (userIdObj instanceof Number) {
                return ((Number) userIdObj).longValue();
            }
            if (userIdObj instanceof String) {
                try {
                    return Long.valueOf((String) userIdObj);
                } catch (NumberFormatException ignored) {
                }
            }
        }

        // 兼容：从SecurityContext principal解析
        Authentication authentication = getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return null;
        }
        Object principal = authentication.getPrincipal();
        if (principal instanceof Long) {
            return (Long) principal;
        }
        if (principal instanceof String) {
            try {
                return Long.valueOf((String) principal);
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }

    /**
     * 获取当前用户类型（user/admin）
     *
     * @return 用户类型
     */
    public static String getCurrentUserType() {
        ServletRequestAttributes attrs = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attrs != null) {
            Object typeObj = attrs.getRequest().getAttribute("userType");
            if (typeObj != null) {
                return typeObj.toString();
            }
        }
        return "user";
    }

    /**
     * 获取当前认证信息
     *
     * @return Authentication
     */
    public static Authentication getAuthentication() {
        return SecurityContextHolder.getContext().getAuthentication();
    }

    /**
     * 判断是否已登录
     *
     * @return 是否已登录
     */
    public static boolean isAuthenticated() {
        Authentication authentication = getAuthentication();
        return authentication != null && authentication.isAuthenticated()
                && !"anonymousUser".equals(authentication.getPrincipal());
    }

    /**
     * 获取当前用户名
     *
     * @return 用户名
     */
    public static String getCurrentUsername() {
        Authentication authentication = getAuthentication();
        if (authentication == null) {
            return null;
        }
        return authentication.getName();
    }
}
