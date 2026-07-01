package com.insurance.framework.aspect;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

/**
 * 权限校验切面
 */
@Slf4j
@Aspect
@Component
public class PermissionAspect {

    // TODO: 实现自定义权限注解校验
    // 示例: @Permission("user:create") 校验当前用户是否有user:create权限
}
