package com.insurance.api.user.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.insurance.api.entity.UserInfo;
import com.insurance.api.mapper.UserInfoMapper;
import com.insurance.api.user.dto.LoginDTO;
import com.insurance.api.user.dto.RefreshTokenDTO;
import com.insurance.api.user.dto.RegisterDTO;
import com.insurance.api.user.service.UserService;
import com.insurance.api.user.vo.LoginVO;
import com.insurance.api.user.vo.UserInfoVO;
import com.insurance.common.exception.BusinessException;
import com.insurance.common.utils.JwtUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

/**
 * 用户Service实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserInfoMapper userInfoMapper;
    private final PasswordEncoder passwordEncoder;

    @Override
    public LoginVO register(RegisterDTO registerDTO) {
        // 用户名唯一性检查
        if (isUsernameExists(registerDTO.getUsername())) {
            throw new BusinessException("用户名已存在");
        }

        // 密码强度校验
        validatePasswordStrength(registerDTO.getPassword());

        UserInfo user = new UserInfo();
        user.setUsername(registerDTO.getUsername());
        user.setPassword(passwordEncoder.encode(registerDTO.getPassword()));
        user.setNickname(registerDTO.getUsername());
        user.setMemberLevel(0);
        user.setStatus(1);
        userInfoMapper.insert(user);

        return generateLoginVO(user);
    }

    @Override
    public boolean isUsernameExists(String username) {
        LambdaQueryWrapper<UserInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserInfo::getUsername, username)
               .eq(UserInfo::getIsDeleted, 0);
        return userInfoMapper.selectCount(wrapper) > 0;
    }

    private void validatePasswordStrength(String password) {
        if (password == null || password.length() < 8 || password.length() > 32) {
            throw new BusinessException("密码长度必须在8-32个字符之间");
        }
        int count = 0;
        if (password.matches(".*[A-Z].*")) count++;
        if (password.matches(".*[a-z].*")) count++;
        if (password.matches(".*\\d.*")) count++;
        if (password.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?].*")) count++;
        if (count < 3) {
            throw new BusinessException("密码必须包含大写字母、小写字母、数字、特殊字符中的至少3种");
        }
    }

    @Override
    public LoginVO login(LoginDTO loginDTO) {
        LambdaQueryWrapper<UserInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserInfo::getUsername, loginDTO.getUsername());
        UserInfo user = userInfoMapper.selectOne(wrapper);
        if (user == null) {
            throw new BusinessException("用户名或密码错误");
        }
        if (!passwordEncoder.matches(loginDTO.getPassword(), user.getPassword())) {
            throw new BusinessException("用户名或密码错误");
        }
        if (user.getStatus() != null && user.getStatus() == 0) {
            throw new BusinessException("账号已被禁用");
        }
        return generateLoginVO(user);
    }

    @Override
    public LoginVO refreshToken(RefreshTokenDTO refreshTokenDTO) {
        String refreshToken = refreshTokenDTO.getRefreshToken();
        if (!JwtUtil.validateToken(refreshToken)) {
            throw new BusinessException("Token无效或已过期");
        }
        Long userId = JwtUtil.getUserId(refreshToken);
        UserInfo user = userInfoMapper.selectById(userId);
        if (user == null || user.getStatus() == 0) {
            throw new BusinessException("用户不存在或已被禁用");
        }
        return generateLoginVO(user);
    }

    @Override
    public UserInfoVO getUserInfo(Long userId) {
        UserInfo user = userInfoMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        UserInfoVO vo = new UserInfoVO();
        BeanUtils.copyProperties(user, vo);
        return vo;
    }

    private LoginVO generateLoginVO(UserInfo user) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("username", user.getUsername());
        claims.put("memberLevel", user.getMemberLevel());
        String accessToken = JwtUtil.generateToken(user.getUserId(), claims);
        String refreshToken = JwtUtil.generateRefreshToken(user.getUserId(), claims);

        LoginVO loginVO = new LoginVO();
        loginVO.setAccessToken(accessToken);
        loginVO.setRefreshToken(refreshToken);
        loginVO.setExpiresIn(86400L);

        UserInfoVO userInfoVO = new UserInfoVO();
        BeanUtils.copyProperties(user, userInfoVO);
        loginVO.setUserInfo(userInfoVO);
        return loginVO;
    }
}
