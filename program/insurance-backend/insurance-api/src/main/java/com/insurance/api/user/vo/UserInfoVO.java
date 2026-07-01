package com.insurance.api.user.vo;

import lombok.Data;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 用户信息VO
 */
@Data
public class UserInfoVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 用户ID */
    private Long userId;

    /** 用户名 */
    private String username;

    /** 昵称 */
    private String nickname;

    /** 头像地址 */
    private String avatarUrl;

    /** 手机号 */
    private String phone;

    /** 邮箱 */
    private String email;

    /** 性别（0-未知，1-男，2-女） */
    private Integer gender;

    /** 生日 */
    private LocalDate birthday;

    /** 会员等级（0-普通，1-VIP，2-SVIP） */
    private Integer memberLevel;

    /** 会员过期时间 */
    private LocalDateTime memberExpireTime;

    /** 状态（0-禁用，1-正常） */
    private Integer status;

    /** 微信OpenID */
    private String wechatOpenid;

    /** 微信UnionID */
    private String wechatUnionid;

    /** 微信昵称 */
    private String wechatNickname;

    /** 微信头像URL */
    private String wechatAvatar;

    /** 是否绑定微信（0-未绑定，1-已绑定） */
    private Integer wechatBound;
}
