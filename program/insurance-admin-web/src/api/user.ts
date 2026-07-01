import { get, post, put } from './request'

export interface User {
  id: number
  username: string
  nickname: string
  avatar: string
  phone: string
  email: string
  status: number
  vipLevel: number
  vipExpireTime: string
  lastLoginTime: string
  createTime: string
}

export interface UserQuery {
  page?: number
  size?: number
  keyword?: string
  status?: number
  vipLevel?: number
}

export interface PageResult<T> {
  list: T[]
  total: number
  page: number
  size: number
}

export function getUserList(params: UserQuery): Promise<PageResult<User>> {
  return get<PageResult<User>>('/v1/admin/user/list', { params })
}

export function getUserDetail(id: number): Promise<User> {
  return get<User>(`/v1/admin/user/${id}`)
}

export function updateUserStatus(id: number, status: number): Promise<void> {
  return put(`/v1/admin/user/${id}/status`, { status })
}

export function resetUserPassword(id: number): Promise<{ newPassword: string }> {
  return post<{ newPassword: string }>(`/v1/admin/user/${id}/reset-password`)
}
