import { post, get } from './request'

export interface LoginParams {
  username: string
  password: string
  captcha?: string
}

export interface RegisterParams {
  username: string
  password: string
}

export interface UserInfo {
  userId: number
  username: string
  nickname: string
  phone: string
  email: string
  gender: number | null
  birthday: string | null
  status: number
  avatarUrl: string
  memberLevel: number
  memberExpireTime: string | null
  wechatOpenid: string | null
  wechatUnionid: string | null
  wechatNickname: string | null
  wechatAvatar: string | null
  wechatBound: number
}

export interface LoginResult {
  accessToken: string
  refreshToken: string
  tokenType: string
  expiresIn: number
  userInfo: UserInfo
}

export function login(params: LoginParams): Promise<LoginResult> {
  return post<LoginResult>('/v1/auth/login', params)
}

export function register(params: RegisterParams): Promise<LoginResult> {
  return post<LoginResult>('/v1/auth/register', params)
}

export function logout(): Promise<void> {
  return post<void>('/auth/logout')
}

export function getUserInfo(): Promise<UserInfo> {
  return get<UserInfo>('/v1/user/info')
}

export function sendVerificationCode(phone: string): Promise<void> {
  return post<void>('/v1/auth/send-code', { phone })
}

export function checkUsername(username: string): Promise<{ exists: boolean }> {
  return get<{ exists: boolean }>('/v1/auth/check-username', { params: { username } })
}

export function refreshToken(refreshToken: string): Promise<{ accessToken: string; refreshToken: string }> {
  return post<{ accessToken: string; refreshToken: string }>('/v1/auth/refresh', { refreshToken })
}

// ============================================================
// 微信登录相关接口
// ============================================================

export interface WechatQrCodeResult {
  sessionId: string
  qrCodeUrl: string
  expireIn: number
  pollInterval: number
}

export interface WechatQrCodeStatus {
  status: 'WAITING' | 'SCANNED' | 'CONFIRMED' | 'EXPIRED'
  message?: string
  accessToken?: string
  refreshToken?: string
  expiresIn?: number
  tokenType?: string
  userInfo?: UserInfo
}

export interface WechatBindParams {
  code: string
  nickname?: string
  avatarUrl?: string
}

/** 获取PC微信扫码登录二维码 */
export function getWechatQrCode(): Promise<WechatQrCodeResult> {
  return get<WechatQrCodeResult>('/wechat/qrcode')
}

/** 轮询检查微信扫码状态 */
export function checkWechatQrCode(sessionId: string): Promise<WechatQrCodeStatus> {
  return get<WechatQrCodeStatus>('/wechat/qrcode/check', { params: { sessionId } })
}

/** 微信小程序登录 */
export function wechatMpLogin(code: string, nickname?: string, avatarUrl?: string): Promise<LoginResult> {
  return post<LoginResult>('/wechat/mp/login', { code, nickname, avatarUrl })
}

/** 绑定微信 */
export function bindWechat(params: WechatBindParams): Promise<void> {
  return post<void>('/wechat/bind', params)
}

/** 解绑微信 */
export function unbindWechat(): Promise<void> {
  return post<void>('/wechat/unbind')
}
