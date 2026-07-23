import { get, post, put, del } from './request'

export interface VipUser {
  id: number
  userId: number
  username: string
  nickname: string
  avatar: string
  vipLevel: number
  vipLevelName: string
  expireTime: string
  status: number
  totalUsage: number
  createTime: string
}

export interface VipQuery {
  page?: number
  size?: number
  keyword?: string
  vipLevel?: number
  status?: number
}

export interface RedeemCode {
  id: number
  code: string
  vipLevel: number
  vipLevelName: string
  durationDays: number
  totalQuantity: number
  usedQuantity: number
  status: number
  validStartTime: string
  validEndTime: string
  createTime: string
}

export interface RedeemCodeQuery {
  page?: number
  size?: number
  keyword?: string
  vipLevel?: number
  status?: number
}

export interface GenerateCodeParams {
  vipLevel: number
  durationDays: number
  quantity: number
  validStartTime: string
  validEndTime: string
}

export interface PageResult<T> {
  list: T[]
  total: number
  page: number
  size: number
}

export function getVipUserList(params: VipQuery): Promise<PageResult<VipUser>> {
  return get<PageResult<VipUser>>('/v1/admin/vip/users', { params })
}

export function updateVipStatus(id: number, status: number): Promise<void> {
  return put(`/v1/admin/vip/user/${id}/status`, { status })
}

export function extendVip(id: number, days: number): Promise<void> {
  return put(`/v1/admin/vip/user/${id}/extend`, { days })
}

export function getRedeemCodeList(params: RedeemCodeQuery): Promise<PageResult<RedeemCode>> {
  return get<PageResult<RedeemCode>>('/v1/admin/vip/redeem-code/list', { params })
}

export function generateRedeemCodes(params: GenerateCodeParams): Promise<string[]> {
  return post<string[]>('/v1/admin/vip/redeem-code/generate', params)
}

export function updateRedeemCodeStatus(id: number, status: number): Promise<void> {
  return put(`/v1/admin/vip/redeem-code/${id}/status`, { status })
}

export function deleteRedeemCode(id: number): Promise<void> {
  return del(`/v1/admin/vip/redeem-code/${id}`)
}
