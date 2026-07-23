package com.insurance.api.user.service;

import com.insurance.api.user.dto.LoginDTO;
import com.insurance.api.user.dto.RefreshTokenDTO;
import com.insurance.api.user.dto.RegisterDTO;
import com.insurance.api.user.vo.LoginVO;
import com.insurance.api.user.vo.UserInfoVO;

/**
 * 用户Service接口
 */
public interface UserService {

    /**
     * 用户注册
     *
     * @param registerDTO 注册信息
     * @return 登录信息
     */
    LoginVO register(RegisterDTO registerDTO);

    /**
     * 用户登录
     *
     * @param loginDTO 登录信息
     * @return 登录信息
     */
    LoginVO login(LoginDTO loginDTO);

    /**
     * 刷新Token
     *
     * @param refreshTokenDTO 刷新Token
     * @return 登录信息
     */
    LoginVO refreshToken(RefreshTokenDTO refreshTokenDTO);

    /**
     * 检查用户名是否已存在
     *
     * @param username 用户名
     * @return true-已存在, false-不存在
     */
    boolean isUsernameExists(String username);

    /**
     * 获取当前用户信息
     *
     * @param userId 用户ID
     * @return 用户信息
     */
    UserInfoVO getUserInfo(Long userId);
}
