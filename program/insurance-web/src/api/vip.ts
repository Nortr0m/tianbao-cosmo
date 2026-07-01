import { get, post } from './request'

export interface VipPlan {
  id: number
  name: string
  duration: number
  durationUnit: 'month' | 'year'
  price: number
  originalPrice: number
  features: string[]
  isPopular: boolean
}

export interface VipOrder {
  id: number
  planId: number
  planName: string
  price: number
  status: 'pending' | 'paid' | 'cancelled' | 'expired'
  createdAt: string
  paidAt: string | null
  expireAt: string | null
}

export interface PaymentParams {
  planId: number
  paymentMethod: 'alipay' | 'wechat'
  returnUrl?: string
}

export interface PaymentResult {
  orderId: number
  paymentUrl: string
  qrCode?: string
}

export function getVipPlans(): Promise<VipPlan[]> {
  return get<VipPlan[]>('/v1/vip/plans')
}

export function createOrder(params: PaymentParams): Promise<PaymentResult> {
  return post<PaymentResult>('/v1/vip/orders', params)
}

export function getOrderStatus(orderId: number): Promise<{ status: string; paidAt: string | null }> {
  return get<{ status: string; paidAt: string | null }>(`/v1/vip/orders/${orderId}/status`)
}

export function getOrderHistory(): Promise<VipOrder[]> {
  return get<VipOrder[]>('/v1/vip/orders')
}

export function getVipStatus(): Promise<{ memberLevel: number; memberExpireTime: string | null }> {
  return get<{ memberLevel: number; memberExpireTime: string | null }>('/v1/vip/status')
}
