import { get } from './request'

export interface DashboardStats {
  totalProductCount: number
  totalCompanyCount: number
  totalUserCount: number
  vipUserCount: number
  totalCardTemplateCount: number
  totalVipOrderAmount: number
  todayNewUserCount: number
  onSaleProductCount: number
  cooperationCompanyCount: number
  totalCardUseCount: number
  totalVipOrderCount: number
}

export interface ProductDistribution {
  name: string
  value: number
}

export interface UserTrend {
  date: string
  newUsers: number
  activeUsers: number
  vipUsers: number
}

export interface CardGenerationStats {
  date: string
  count: number
  type: string
}

export function getDashboardStats(): Promise<DashboardStats> {
  return get<DashboardStats>('/v1/admin/dashboard/stats')
}

export function getProductDistribution(): Promise<ProductDistribution[]> {
  return get<ProductDistribution[]>('/v1/admin/dashboard/product-distribution')
}

export function getUserTrend(days: number = 30): Promise<UserTrend[]> {
  return get<UserTrend[]>(`/v1/admin/dashboard/user-trend?days=${days}`)
}

export function getCardGenerationStats(days: number = 30): Promise<CardGenerationStats[]> {
  return get<CardGenerationStats[]>(`/v1/admin/dashboard/card-generation?days=${days}`)
}
