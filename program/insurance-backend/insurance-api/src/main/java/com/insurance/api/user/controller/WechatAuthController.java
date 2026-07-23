package com.insurance.api.user.controller;

import com.insurance.api.user.dto.WechatBindDTO;
import com.insurance.api.user.dto.WechatMpLoginDTO;
import com.insurance.api.user.service.WechatService;
import com.insurance.api.user.vo.LoginVO;
import com.insurance.common.result.Result;
import com.insurance.common.utils.SecurityUtils;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 微信认证Controller
 * 提供PC微信扫码登录、微信小程序登录、微信绑定/解绑等功能
 */
@Slf4j
@RestController
@RequestMapping("/api/wechat")
@RequiredArgsConstructor
public class WechatAuthController {

    private final WechatService wechatService;

    /**
     * PC微信扫码登录 - 获取二维码
     * 返回二维码URL和sessionId，前端展示二维码后轮询checkQrCodeStatus
     *
     * @return 二维码信息（sessionId, qrCodeUrl, expireIn, pollInterval）
     */
    @GetMapping("/qrcode")
    public Result<Map<String, String>> getQrCode() {
        return Result.success(wechatService.getQrCode());
    }

    /**
     * PC微信扫码登录 - 轮询扫码状态
     * 前端定时调用此接口检查用户是否已扫码/已确认
     *
     * @param sessionId 扫码会话ID（由getQrCode返回）
     * @return 扫码状态（WAITING-等待扫码, SCANNED-已扫码待确认, CONFIRMED-已确认登录, EXPIRED-已过期）
     */
    @GetMapping("/qrcode/check")
    public Result<Map<String, Object>> checkQrCodeStatus(@RequestParam String sessionId) {
        return Result.success(wechatService.checkQrCodeStatus(sessionId));
    }

    /**
     * 微信开放平台扫码回调接口
     * 用户扫码确认后，微信会回调此接口携带code
     *
     * @param code  微信授权码
     * @param state 状态码（即sessionId）
     * @return 提示信息
     */
    @GetMapping("/callback")
    public String wechatCallback(@RequestParam String code, @RequestParam String state) {
        log.info("收到微信扫码回调, code={}, state={}", code, state);

        try {
            // 通过code获取微信用户信息，并更新Redis中的扫码session
            wechatService.handleQrCodeCallback(code, state);
            return "<script>window.close();</script>";
        } catch (Exception e) {
            log.error("处理微信扫码回调失败", e);
            return "<script>alert('登录失败，请重试');window.close();</script>";
        }
    }

    /**
     * 微信小程序登录
     * 小程序端调用wx.login获取code，后端通过code换取openid实现登录
     *
     * @param dto 小程序登录参数（code, nickname, avatarUrl）
     * @return 登录信息（accessToken, refreshToken, userInfo）
     */
    @PostMapping("/mp/login")
    public Result<LoginVO> mpLogin(@Valid @RequestBody WechatMpLoginDTO dto) {
        return Result.success(wechatService.mpLogin(dto));
    }

    /**
     * 绑定微信
     * 已登录用户绑定微信账号，绑定后可使用微信扫码快捷登录
     *
     * @param dto 绑定参数（code, nickname, avatarUrl）
     * @return 操作结果
     */
    @PostMapping("/bind")
    public Result<Void> bindWechat(@Valid @RequestBody WechatBindDTO dto) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return Result.unauthorized("请先登录");
        }
        wechatService.bindWechat(userId, dto);
        return Result.success();
    }

    /**
     * 解绑微信
     * 解绑后无法使用微信扫码登录，需重新绑定
     *
     * @return 操作结果
     */
    @PostMapping("/unbind")
    public Result<Void> unbindWechat() {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return Result.unauthorized("请先登录");
        }
        wechatService.unbindWechat(userId);
        return Result.success();
    }
}
