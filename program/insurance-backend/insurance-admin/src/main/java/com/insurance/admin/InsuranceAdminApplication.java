package com.insurance.admin;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

/**
 * Admin服务启动类
 */
@SpringBootApplication
@ComponentScan(basePackages = {"com.insurance.admin", "com.insurance.framework", "com.insurance.common",
    "com.insurance.api.entity", "com.insurance.api.mapper", "com.insurance.api.service"})
@MapperScan(basePackages = {"com.insurance.api.mapper", "com.insurance.admin.mapper"})
public class InsuranceAdminApplication {

    public static void main(String[] args) {
        SpringApplication.run(InsuranceAdminApplication.class, args);
    }
}
