package com.insurance.admin.auth.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.insurance.admin.auth.dto.AdminLoginDTO;
import com.insurance.admin.auth.service.AdminAuthService;
import com.insurance.admin.auth.vo.AdminInfoVO;
import com.insurance.admin.auth.vo.AdminLoginVO;
import com.insurance.admin.entity.AdminUser;
import com.insurance.admin.mapper.AdminUserMapper;
import com.insurance.common.exception.BusinessException;
import com.insurance.common.utils.JwtUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 管理员认证Service实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AdminAuthServiceImpl implements AdminAuthService {

    private final AdminUserMapper adminUserMapper;
    private final PasswordEncoder passwordEncoder;

    @Override
    public AdminLoginVO login(AdminLoginDTO loginDTO) {
        LambdaQueryWrapper<AdminUser> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(AdminUser::getUsername, loginDTO.getUsername());
        AdminUser admin = adminUserMapper.selectOne(wrapper);
        if (admin == null) {
            throw new BusinessException("用户名或密码错误");
        }
        if (!passwordEncoder.matches(loginDTO.getPassword(), admin.getPassword())) {
            throw new BusinessException("用户名或密码错误");
        }
        if (admin.getStatus() != null && admin.getStatus() == 0) {
            throw new BusinessException("账号已被禁用");
        }

        // 更新最后登录时间
        admin.setLastLoginTime(LocalDateTime.now());
        adminUserMapper.updateById(admin);

        return buildLoginVO(admin);
    }

    @Override
    public AdminInfoVO getAdminInfo(Long adminId) {
        AdminUser admin = adminUserMapper.selectById(adminId);
        if (admin == null) {
            throw new BusinessException("管理员不存在");
        }
        AdminInfoVO info = new AdminInfoVO();
        BeanUtils.copyProperties(admin, info);
        return info;
    }

    @Override
    public AdminLoginVO refreshToken(Long adminId) {
        AdminUser admin = adminUserMapper.selectById(adminId);
        if (admin == null) {
            throw new BusinessException("管理员不存在");
        }
        return buildLoginVO(admin);
    }

    private AdminLoginVO buildLoginVO(AdminUser admin) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("username", admin.getUsername());
        claims.put("roleId", admin.getRoleId());
        claims.put("type", "admin");
        String token = JwtUtil.generateToken(admin.getAdminId(), claims);

        AdminLoginVO vo = new AdminLoginVO();
        vo.setAccessToken(token);
        vo.setExpiresIn(86400L);

        AdminInfoVO info = new AdminInfoVO();
        BeanUtils.copyProperties(admin, info);
        vo.setAdminInfo(info);
        return vo;
    }
}
