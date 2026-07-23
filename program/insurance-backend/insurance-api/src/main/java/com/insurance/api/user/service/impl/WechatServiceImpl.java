package com.insurance.api.user.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.insurance.api.entity.UserInfo;
import com.insurance.api.mapper.UserInfoMapper;
import com.insurance.api.user.dto.WechatBindDTO;
import com.insurance.api.user.dto.WechatMpLoginDTO;
import com.insurance.api.user.service.WechatService;
import com.insurance.api.user.vo.LoginVO;
import com.insurance.api.user.vo.UserInfoVO;
import com.insurance.common.exception.BusinessException;
import com.insurance.common.utils.JwtUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * 微信登录Service实现类
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class WechatServiceImpl implements WechatService {

    private final UserInfoMapper userInfoMapper;
    private final StringRedisTemplate redisTemplate;

    @Value("${wechat.open.app-id:}")
    private String openAppId;

    @Value("${wechat.open.app-secret:}")
    private String openAppSecret;

    @Value("${wechat.mp.app-id:}")
    private String mpAppId;

    @Value("${wechat.mp.app-secret:}")
    private String mpAppSecret;

    /** 微信开放平台获取access_token的URL */
    private static final String OPEN_ACCESS_TOKEN_URL =
            "https://api.weixin.qq.com/sns/oauth2/access_token?appid=%s&secret=%s&code=%s&grant_type=authorization_code";

    /** 微信开放平台获取扫码二维码的URL */
    private static final String OPEN_QRCONNECT_URL =
            "https://open.weixin.qq.com/connect/qrconnect?appid=%s&redirect_uri=%s&response_type=code&scope=snsapi_login&state=%s#wechat_redirect";

    /** 微信小程序获取access_token的URL */
    private static final String MP_ACCESS_TOKEN_URL =
            "https://api.weixin.qq.com/sns/jscode2session?appid=%s&secret=%s&js_code=%s&grant_type=authorization_code";

    /** Redis扫码会话前缀 */
    private static final String WECHAT_QR_SESSION_PREFIX = "wechat:qr:session:";

    /** 扫码会话过期时间（15分钟） */
    private static final long QR_SESSION_EXPIRE_MINUTES = 15;

    /** 扫码轮询间隔（秒） */
    private static final long QR_POLL_INTERVAL_SECONDS = 3;

    private final RestTemplate restTemplate = new RestTemplate();

    @Override
    public Map<String, String> getQrCode() {
        if (openAppId == null || openAppId.isEmpty()) {
            throw new BusinessException("微信开放平台未配置，暂不支持微信扫码登录");
        }

        // 生成唯一的sessionId
        String sessionId = UUID.randomUUID().toString().replace("-", "");

        // 生成微信扫码授权URL
        String state = sessionId;
        String redirectUri = "https://your-domain.com/api/wechat/callback";
        String qrCodeUrl = String.format(OPEN_QRCONNECT_URL, openAppId, redirectUri, state);

        // 将sessionId存入Redis，初始状态为WAITING，15分钟过期
        String sessionKey = WECHAT_QR_SESSION_PREFIX + sessionId;
        Map<String, String> sessionData = new HashMap<>();
        sessionData.put("status", "WAITING");
        sessionData.put("sessionId", sessionId);
        redisTemplate.opsForHash().putAll(sessionKey, sessionData);
        redisTemplate.expire(sessionKey, QR_SESSION_EXPIRE_MINUTES, TimeUnit.MINUTES);

        // 返回二维码URL和sessionId
        Map<String, String> result = new HashMap<>();
        result.put("sessionId", sessionId);
        result.put("qrCodeUrl", qrCodeUrl);
        result.put("expireIn", String.valueOf(QR_SESSION_EXPIRE_MINUTES * 60));
        result.put("pollInterval", String.valueOf(QR_POLL_INTERVAL_SECONDS));
        return result;
    }

    @Override
    public Map<String, Object> checkQrCodeStatus(String sessionId) {
        String sessionKey = WECHAT_QR_SESSION_PREFIX + sessionId;
        Map<Object, Object> sessionData = redisTemplate.opsForHash().entries(sessionKey);

        if (sessionData.isEmpty()) {
            Map<String, Object> result = new HashMap<>();
            result.put("status", "EXPIRED");
            result.put("message", "二维码已过期，请刷新重试");
            return result;
        }

        String status = (String) sessionData.get("status");
        Map<String, Object> result = new HashMap<>();
        result.put("status", status);

        if ("CONFIRMED".equals(status)) {
            // 扫码确认，返回登录Token
            String accessToken = (String) sessionData.get("accessToken");
            String refreshToken = (String) sessionData.get("refreshToken");
            Long expiresIn = sessionData.get("expiresIn") != null
                    ? Long.valueOf((String) sessionData.get("expiresIn")) : 86400L;

            result.put("accessToken", accessToken);
            result.put("refreshToken", refreshToken);
            result.put("expiresIn", expiresIn);
            result.put("tokenType", "Bearer");

            // 获取用户信息
            String userIdStr = (String) sessionData.get("userId");
            if (userIdStr != null) {
                UserInfo user = userInfoMapper.selectById(Long.valueOf(userIdStr));
                if (user != null) {
                    UserInfoVO userInfoVO = new UserInfoVO();
                    BeanUtils.copyProperties(user, userInfoVO);
                    result.put("userInfo", userInfoVO);
                }
            }

            // 登录成功后删除session
            redisTemplate.delete(sessionKey);
        }

        return result;
    }

    @Override
    public void handleQrCodeCallback(String code, String state) {
        String sessionId = state;
        String sessionKey = WECHAT_QR_SESSION_PREFIX + sessionId;

        // 检查session是否存在
        Boolean hasKey = redisTemplate.hasKey(sessionKey);
        if (hasKey == null || !hasKey) {
            throw new BusinessException("扫码会话已过期");
        }

        // 先标记为已扫码
        redisTemplate.opsForHash().put(sessionKey, "status", "SCANNED");

        // 通过code换取access_token和openid
        String url = String.format(OPEN_ACCESS_TOKEN_URL, openAppId, openAppSecret, code);
        Map<String, Object> wxResult = callWechatApi(url);

        String openid = (String) wxResult.get("openid");
        String unionid = (String) wxResult.get("unionid");
        String accessToken = (String) wxResult.get("access_token");

        if (openid == null || openid.isEmpty()) {
            String errcode = wxResult.get("errcode") != null ? wxResult.get("errcode").toString() : "unknown";
            log.error("微信扫码换取openid失败, errcode={}, errmsg={}", errcode, wxResult.get("errmsg"));
            throw new BusinessException("微信授权失败");
        }

        log.info("微信扫码回调成功, openid={}, unionid={}", openid, unionid);

        // 根据openid查找用户
        LambdaQueryWrapper<UserInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserInfo::getWechatOpenid, openid);
        UserInfo user = userInfoMapper.selectOne(wrapper);

        if (user == null) {
            // 首次微信扫码，自动注册
            user = new UserInfo();
            user.setUsername("wx_" + openid.substring(0, 8) + UUID.randomUUID().toString().substring(0, 4));
            user.setPassword(org.springframework.util.DigestUtils.md5DigestAsHex(
                    UUID.randomUUID().toString().getBytes()));
            user.setNickname("微信用户");
            user.setWechatOpenid(openid);
            user.setWechatUnionid(unionid);
            user.setWechatBound(1);
            user.setMemberLevel(0);
            user.setStatus(1);
            userInfoMapper.insert(user);
            log.info("微信扫码用户自动注册成功, userId={}, openid={}", user.getUserId(), openid);
        } else {
            // 更新微信信息
            user.setWechatUnionid(unionid);
            user.setWechatBound(1);
            userInfoMapper.updateById(user);
        }

        // 生成登录Token
        LoginVO loginVO = generateLoginVO(user);

        // 更新Redis session为已确认，并存储登录信息
        redisTemplate.opsForHash().put(sessionKey, "status", "CONFIRMED");
        redisTemplate.opsForHash().put(sessionKey, "accessToken", loginVO.getAccessToken());
        redisTemplate.opsForHash().put(sessionKey, "refreshToken", loginVO.getRefreshToken());
        redisTemplate.opsForHash().put(sessionKey, "expiresIn", String.valueOf(loginVO.getExpiresIn()));
        redisTemplate.opsForHash().put(sessionKey, "userId", String.valueOf(user.getUserId()));
    }

    @Override
    public LoginVO mpLogin(WechatMpLoginDTO dto) {
        if (mpAppId == null || mpAppId.isEmpty()) {
            throw new BusinessException("微信小程序未配置，暂不支持微信登录");
        }

        // 调用微信小程序API换取openid和session_key
        String url = String.format(MP_ACCESS_TOKEN_URL, mpAppId, mpAppSecret, dto.getCode());
        Map<String, Object> wxResult = callWechatApi(url);

        String openid = (String) wxResult.get("openid");
        String unionid = (String) wxResult.get("unionid");
        String sessionKey = (String) wxResult.get("session_key");

        if (openid == null || openid.isEmpty()) {
            String errcode = wxResult.get("errcode") != null ? wxResult.get("errcode").toString() : "unknown";
            log.error("微信小程序登录失败, errcode={}, errmsg={}", errcode, wxResult.get("errmsg"));
            throw new BusinessException("微信登录失败，请重试");
        }

        log.info("微信小程序登录成功, openid={}, unionid={}", openid, unionid);

        // 根据openid查找用户
        LambdaQueryWrapper<UserInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserInfo::getWechatOpenid, openid);
        UserInfo user = userInfoMapper.selectOne(wrapper);

        if (user == null) {
            // 首次微信登录，自动注册
            user = new UserInfo();
            user.setUsername("wx_" + openid.substring(0, 8) + UUID.randomUUID().toString().substring(0, 4));
            user.setPassword(org.springframework.util.DigestUtils.md5DigestAsHex(
                    UUID.randomUUID().toString().getBytes()));
            user.setNickname(dto.getNickname() != null ? dto.getNickname() : "微信用户");
            user.setAvatarUrl(dto.getAvatarUrl());
            user.setWechatOpenid(openid);
            user.setWechatUnionid(unionid);
            user.setWechatNickname(dto.getNickname());
            user.setWechatAvatar(dto.getAvatarUrl());
            user.setWechatBound(1);
            user.setMemberLevel(0);
            user.setStatus(1);
            userInfoMapper.insert(user);
            log.info("微信用户自动注册成功, userId={}, openid={}", user.getUserId(), openid);
        } else {
            // 已有用户，更新微信信息
            user.setWechatUnionid(unionid);
            if (dto.getNickname() != null) {
                user.setWechatNickname(dto.getNickname());
            }
            if (dto.getAvatarUrl() != null) {
                user.setWechatAvatar(dto.getAvatarUrl());
            }
            user.setWechatBound(1);
            userInfoMapper.updateById(user);
        }

        return generateLoginVO(user);
    }

    @Override
    public void bindWechat(Long userId, WechatBindDTO dto) {
        UserInfo user = userInfoMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }

        if (user.getWechatBound() != null && user.getWechatBound() == 1) {
            throw new BusinessException("该账号已绑定微信，请先解绑再重新绑定");
        }

        // 通过code换取openid（此处使用小程序方式，PC端可替换为开放平台方式）
        String url = String.format(MP_ACCESS_TOKEN_URL, mpAppId, mpAppSecret, dto.getCode());
        Map<String, Object> wxResult = callWechatApi(url);

        String openid = (String) wxResult.get("openid");
        String unionid = (String) wxResult.get("unionid");

        if (openid == null || openid.isEmpty()) {
            throw new BusinessException("获取微信信息失败，请重试");
        }

        // 检查该openid是否已被其他账号绑定
        LambdaQueryWrapper<UserInfo> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserInfo::getWechatOpenid, openid);
        wrapper.ne(UserInfo::getUserId, userId);
        if (userInfoMapper.selectCount(wrapper) > 0) {
            throw new BusinessException("该微信已被其他账号绑定");
        }

        // 绑定微信
        LambdaUpdateWrapper<UserInfo> updateWrapper = new LambdaUpdateWrapper<>();
        updateWrapper.eq(UserInfo::getUserId, userId)
                .set(UserInfo::getWechatOpenid, openid)
                .set(UserInfo::getWechatUnionid, unionid)
                .set(UserInfo::getWechatNickname, dto.getNickname())
                .set(UserInfo::getWechatAvatar, dto.getAvatarUrl())
                .set(UserInfo::getWechatBound, 1)
                .set(UserInfo::getUpdatedAt, LocalDateTime.now());
        userInfoMapper.update(null, updateWrapper);

        log.info("用户绑定微信成功, userId={}, openid={}", userId, openid);
    }

    @Override
    public void unbindWechat(Long userId) {
        UserInfo user = userInfoMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }

        if (user.getWechatBound() == null || user.getWechatBound() == 0) {
            throw new BusinessException("该账号未绑定微信");
        }

        LambdaUpdateWrapper<UserInfo> updateWrapper = new LambdaUpdateWrapper<>();
        updateWrapper.eq(UserInfo::getUserId, userId)
                .set(UserInfo::getWechatOpenid, null)
                .set(UserInfo::getWechatUnionid, null)
                .set(UserInfo::getWechatNickname, null)
                .set(UserInfo::getWechatAvatar, null)
                .set(UserInfo::getWechatBound, 0)
                .set(UserInfo::getUpdatedAt, LocalDateTime.now());
        userInfoMapper.update(null, updateWrapper);

        log.info("用户解绑微信成功, userId={}", userId);
    }

    /**
     * 调用微信API
     *
     * @param url API地址
     * @return 返回结果Map
     */
    @SuppressWarnings("unchecked")
    private Map<String, Object> callWechatApi(String url) {
        try {
            return restTemplate.getForObject(url, Map.class);
        } catch (Exception e) {
            log.error("调用微信API失败, url={}", url, e);
            throw new BusinessException("微信服务调用失败，请稍后重试");
        }
    }

    /**
     * 生成登录VO
     *
     * @param user 用户信息
     * @return 登录VO
     */
    private LoginVO generateLoginVO(UserInfo user) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("username", user.getUsername());
        claims.put("memberLevel", user.getMemberLevel());
        String accessToken = JwtUtil.generateToken(user.getUserId(), claims);
        String refreshToken = JwtUtil.generateToken(user.getUserId(), claims);

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
