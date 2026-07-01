package com.insurance.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

/**
 * API服务启动类
 */
@SpringBootApplication
@ComponentScan(basePackages = {"com.insurance.api", "com.insurance.framework", "com.insurance.common"})
public class InsuranceApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(InsuranceApiApplication.class, args);
    }
}
