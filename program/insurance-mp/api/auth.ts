import { post, get } from '../utils/request';
import { setStorage } from '../utils/storage';

// 登录接口
export interface LoginParams {
  code: string;
  userInfo?: WechatMiniprogram.UserInfo;
}

export interface LoginResult {
  token: string;
  userInfo: WechatMiniprogram.UserInfo;
  memberLevel: 'free' | 'vip' | 'svip';
  memberExpireTime?: string;
}

/**
 * 微信登录
 * @param params 登录参数
 * @returns 登录结果
 */
export function login(params: LoginParams): Promise<LoginResult> {
  return post<LoginResult>('/api/auth/login', params);
}

/**
 * 获取用户信息
 * @returns 用户信息
 */
export function getUserInfo(): Promise<WechatMiniprogram.UserInfo> {
  return get<WechatMiniprogram.UserInfo>('/api/auth/userInfo');
}

/**
 * 更新用户信息
 * @param userInfo 用户信息
 * @returns 更新后的用户信息
 */
export function updateUserInfo(userInfo: Partial<WechatMiniprogram.UserInfo>): Promise<WechatMiniprogram.UserInfo> {
  return post<WechatMiniprogram.UserInfo>('/api/auth/updateUserInfo', userInfo);
}

/**
 * 退出登录
 */
export function logout(): Promise<void> {
  return post<void>('/api/auth/logout');
}

/**
 * 刷新Token
 * @returns 新的Token
 */
export function refreshToken(): Promise<{ token: string }> {
  return post<{ token: string }>('/api/auth/refreshToken');
}

/**
 * 微信一键登录封装
 * @returns Promise<LoginResult>
 */
export function wxLogin(): Promise<LoginResult> {
  return new Promise((resolve, reject) => {
    wx.login({
      success: (res) => {
        if (res.code) {
          // 获取用户信息
          wx.getUserProfile({
            desc: '用于完善用户资料',
            success: (userRes) => {
              login({
                code: res.code,
                userInfo: userRes.userInfo,
              })
                .then((result) => {
                  // 保存登录信息
                  setStorage('token', result.token);
                  setStorage('userInfo', result.userInfo);
                  setStorage('memberLevel', result.memberLevel);
                  resolve(result);
                })
                .catch(reject);
            },
            fail: (err) => {
              // 用户拒绝授权，使用静默登录
              login({ code: res.code })
                .then((result) => {
                  setStorage('token', result.token);
                  setStorage('userInfo', result.userInfo);
                  setStorage('memberLevel', result.memberLevel);
                  resolve(result);
                })
                .catch(reject);
            },
          });
        } else {
          reject(new Error('微信登录失败'));
        }
      },
      fail: reject,
    });
  });
}

/**
 * 检查登录状态
 * @returns 是否已登录
 */
export function checkLoginStatus(): Promise<boolean> {
  return new Promise((resolve) => {
    const token = wx.getStorageSync('token');
    if (!token) {
      resolve(false);
      return;
    }

    get('/api/auth/check')
      .then(() => {
        resolve(true);
      })
      .catch(() => {
        resolve(false);
      });
  });
}
