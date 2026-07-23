package com.insurance.common.utils;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * JWT工具类
 */
@Slf4j
public final class JwtUtil {

    private JwtUtil() {
    }

    /** Access Token默认过期时间（2小时） */
    private static final long DEFAULT_EXPIRATION = 7200000L;

    /** Refresh Token默认过期时间（7天） */
    private static final long REFRESH_EXPIRATION = 604800000L;

    private static SecretKey SECRET_KEY;

    /**
     * 初始化密钥（由配置类调用）
     *
     * @param secret 密钥字符串
     */
    public static synchronized void initSecretKey(String secret) {
        if (secret == null || secret.isEmpty()) {
            throw new IllegalArgumentException("JWT secret cannot be null or empty");
        }
        if (secret.length() < 32) {
            throw new IllegalArgumentException("JWT secret must be at least 32 characters long");
        }
        SECRET_KEY = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
    }

    private static SecretKey getSecretKey() {
        if (SECRET_KEY == null) {
            throw new IllegalStateException("JWT secret key has not been initialized. Please configure jwt.secret in application.yml");
        }
        return SECRET_KEY;
    }

    /**
     * 生成JWT Token
     *
     * @param userId 用户ID
     * @return Token字符串
     */
    public static String generateToken(Long userId) {
        return generateToken(userId, new HashMap<>());
    }

    /**
     * 生成JWT Access Token
     *
     * @param userId  用户ID
     * @param claims  自定义声明
     * @return Token字符串
     */
    public static String generateToken(Long userId, Map<String, Object> claims) {
        return generateToken(userId, claims, DEFAULT_EXPIRATION);
    }

    /**
     * 生成JWT Refresh Token
     *
     * @param userId  用户ID
     * @param claims  自定义声明
     * @return Token字符串
     */
    public static String generateRefreshToken(Long userId, Map<String, Object> claims) {
        return generateToken(userId, claims, REFRESH_EXPIRATION);
    }

    /**
     * 生成JWT Token（指定过期时间）
     *
     * @param userId     用户ID
     * @param claims     自定义声明
     * @param expiration 过期时间（毫秒）
     * @return Token字符串
     */
    public static String generateToken(Long userId, Map<String, Object> claims, long expiration) {
        Date now = new Date();
        Date expirationDate = new Date(now.getTime() + expiration);

        return Jwts.builder()
                .claims(claims)
                .subject(String.valueOf(userId))
                .issuedAt(now)
                .expiration(expirationDate)
                .signWith(getSecretKey(), Jwts.SIG.HS256)
                .compact();
    }

    /**
     * 解析JWT Token
     *
     * @param token Token字符串
     * @return Claims
     */
    public static Claims parseToken(String token) {
        try {
            return Jwts.parser()
                    .verifyWith(getSecretKey())
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
        } catch (ExpiredJwtException e) {
            log.warn("JWT Token已过期");
            throw e;
        } catch (UnsupportedJwtException e) {
            log.warn("不支持的JWT Token");
            throw e;
        } catch (MalformedJwtException e) {
            log.warn("JWT Token格式错误");
            throw e;
        } catch (SecurityException e) {
            log.warn("JWT Token签名验证失败");
            throw e;
        }
    }

    /**
     * 从Token中获取用户ID
     *
     * @param token Token字符串
     * @return 用户ID
     */
    public static Long getUserId(String token) {
        Claims claims = parseToken(token);
        return Long.valueOf(claims.getSubject());
    }

    /**
     * 验证Token是否有效
     *
     * @param token Token字符串
     * @return 是否有效
     */
    public static boolean validateToken(String token) {
        try {
            parseToken(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 判断Token是否过期
     *
     * @param token Token字符串
     * @return 是否过期
     */
    public static boolean isExpired(String token) {
        try {
            Claims claims = parseToken(token);
            return claims.getExpiration().before(new Date());
        } catch (ExpiredJwtException e) {
            return true;
        } catch (Exception e) {
            return true;
        }
    }

    /**
     * 从Token中获取指定Claim
     *
     * @param token Token字符串
     * @param key   Claim键
     * @return Claim值，不存在返回null
     */
    public static Object getClaim(String token, String key) {
        Claims claims = parseToken(token);
        return claims.get(key);
    }

    /**
     * 从Token中获取过期时间
     *
     * @param token Token字符串
     * @return 过期时间
     */
    public static Date getExpiration(String token) {
        Claims claims = parseToken(token);
        return claims.getExpiration();
    }
}
