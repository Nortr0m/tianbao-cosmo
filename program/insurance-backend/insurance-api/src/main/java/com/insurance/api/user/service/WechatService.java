package com.insurance.api.user.service;

import com.insurance.api.user.dto.WechatBindDTO;
import com.insurance.api.user.dto.WechatMpLoginDTO;
import com.insurance.api.user.vo.LoginVO;

import java.util.Map;

/**
 * 微信登录Service接口
 */
public interface WechatService {

    /**
     * 获取PC微信扫码登录二维码
     *
     * @return 包含二维码URL和sessionId的Map
     */
    Map<String, String> getQrCode();

    /**
     * 检查PC微信扫码状态
     *
     * @param sessionId 扫码会话ID
     * @return 扫码状态信息（status: WAITING/SCANNED/CONFIRMED/EXPIRED）
     */
    Map<String, Object> checkQrCodeStatus(String sessionId);

    /**
     * 处理PC微信扫码回调
     * 微信回调后通过code获取用户信息，更新Redis中的扫码session状态
     *
     * @param code  微信授权码
     * @param state 状态码（即sessionId）
     */
    void handleQrCodeCallback(String code, String state);

    /**
     * 微信小程序登录
     *
     * @param dto 小程序登录参数
     * @return 登录信息
     */
    LoginVO mpLogin(WechatMpLoginDTO dto);

    /**
     * 绑定微信（已登录用户绑定微信账号）
     *
     * @param userId 当前用户ID
     * @param dto    绑定参数
     */
    void bindWechat(Long userId, WechatBindDTO dto);

    /**
     * 解绑微信
     *
     * @param userId 当前用户ID
     */
    void unbindWechat(Long userId);
}
