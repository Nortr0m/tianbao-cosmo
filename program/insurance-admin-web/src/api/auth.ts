import { post, get } from './request'

export interface LoginParams {
  username: string
  password: string
  captcha?: string
}

export interface LoginResult {
  accessToken: string
  tokenType: string
  expiresIn: number
  adminInfo: AdminInfo
}

export interface AdminInfo {
  adminId: number
  username: string
  realName: string
  phone: string | null
  email: string | null
  avatarUrl: string | null
  roleId: number
  status: number
  lastLoginTime: string
}

export function login(data: LoginParams): Promise<LoginResult> {
  return post<LoginResult>('/v1/admin/auth/login', data)
}

export function logout(): Promise<void> {
  return post('/v1/admin/auth/logout')
}

export function getAdminInfo(): Promise<AdminInfo> {
  return get<AdminInfo>('/v1/admin/auth/info')
}

export function refreshAccessToken(refreshToken: string): Promise<{ token: string; expiresIn: number }> {
  return post('/v1/admin/auth/refresh', { refreshToken })
}
