package com.insurance.admin.auth.service;

import com.insurance.admin.auth.dto.AdminLoginDTO;
import com.insurance.admin.auth.vo.AdminInfoVO;
import com.insurance.admin.auth.vo.AdminLoginVO;

/**
 * 管理员认证Service接口
 */
public interface AdminAuthService {

    /**
     * 管理员登录
     *
     * @param loginDTO 登录信息
     * @return 登录结果
     */
    AdminLoginVO login(AdminLoginDTO loginDTO);

    /**
     * 获取管理员信息
     *
     * @param adminId 管理员ID
     * @return 管理员信息
     */
    AdminInfoVO getAdminInfo(Long adminId);

    /**
     * 刷新token
     *
     * @param adminId 管理员ID
     * @return 新的登录结果
     */
    AdminLoginVO refreshToken(Long adminId);
}
