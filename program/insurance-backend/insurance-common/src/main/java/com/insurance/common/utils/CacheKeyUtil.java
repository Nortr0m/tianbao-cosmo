package com.insurance.common.utils;

/**
 * 缓存Key工具类
 */
public final class CacheKeyUtil {

    private CacheKeyUtil() {
    }

    private static final String SEPARATOR = ":";
    private static final String PREFIX = "insurance";

    /**
     * 构建缓存Key
     *
     * @param modules 模块名
     * @param keys    键值
     */
    public static String build(String modules, String... keys) {
        StringBuilder sb = new StringBuilder(PREFIX);
        sb.append(SEPARATOR).append(modules);
        for (String key : keys) {
            sb.append(SEPARATOR).append(key);
        }
        return sb.toString();
    }

    /**
     * 用户缓存Key
     */
    public static String userKey(Long userId) {
        return build("user", String.valueOf(userId));
    }

    /**
     * 用户Token缓存Key
     */
    public static String userTokenKey(Long userId) {
        return build("user", "token", String.valueOf(userId));
    }

    /**
     * 验证码缓存Key
     */
    public static String captchaKey(String uuid) {
        return build("captcha", uuid);
    }

    /**
     * 产品缓存Key
     */
    public static String productKey(Long productId) {
        return build("product", String.valueOf(productId));
    }

    /**
     * 字典缓存Key
     */
    public static String dictKey(String dictType) {
        return build("dict", dictType);
    }

    /**
     * 限流缓存Key
     */
    public static String rateLimitKey(String key) {
        return build("rate_limit", key);
    }

    /**
     * 登录失败次数缓存Key
     */
    public static String loginFailKey(String username) {
        return build("login_fail", username);
    }
}
