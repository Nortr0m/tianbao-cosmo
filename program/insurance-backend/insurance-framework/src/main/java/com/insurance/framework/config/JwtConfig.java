package com.insurance.framework.config;

import com.insurance.common.utils.JwtUtil;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

/**
 * JWT配置类
 * 负责从配置文件读取JWT密钥并初始化JwtUtil
 */
@Slf4j
@Configuration
public class JwtConfig {

    @Value("${jwt.secret:}")
    private String jwtSecret;

    @PostConstruct
    public void init() {
        if (jwtSecret == null || jwtSecret.isEmpty()) {
            log.error("JWT secret is not configured. Please set jwt.secret in application.yml");
            throw new IllegalStateException("JWT secret is not configured");
        }
        JwtUtil.initSecretKey(jwtSecret);
        log.info("JWT secret key initialized successfully");
    }
}
