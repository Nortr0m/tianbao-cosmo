import { post, get } from './request'
import type { ProductType } from './product'

export interface CompareParams {
  productIds: number[]
  age?: number
  gender?: 'male' | 'female'
  paymentPeriod?: string
  coverage?: number
}

export interface CompareItem {
  productId: number
  productName: string
  companyName: string
  productType: ProductType
  premium: number
  coverage: number
  benefits: Record<string, string | number>
  scores: Record<string, number>
  totalScore: number
}

export interface CompareResult {
  items: CompareItem[]
  dimensions: string[]
  winnerId: number | null
}

export interface CompareHistory {
  id: number
  productIds: number[]
  params: CompareParams
  createdAt: string
}

/**
 * 根据产品类型获取对比API路径
 */
function getComparePath(productType: ProductType): string {
  switch (productType) {
    case 'critical_illness':
      return '/v1/compare/critical-illness'
    case 'whole_life':
      return '/v1/compare/whole-life'
    case 'annuity':
      return '/v1/compare/annuity'
    default:
      return '/v1/compare/critical-illness'
  }
}

/**
 * 产品对比（根据产品类型自动选择对比维度）
 * @param productType 产品类型
 * @param params 对比参数
 */
export function compareProducts(productType: ProductType, params: CompareParams): Promise<CompareResult> {
  return post<CompareResult>(getComparePath(productType), params)
}

export function getCompareHistory(): Promise<CompareHistory[]> {
  return get<CompareHistory[]>('/v1/compare/history')
}

export function getCompareDetail(id: number): Promise<CompareResult> {
  return get<CompareResult>(`/v1/compare/${id}`)
}

export function saveCompare(params: CompareParams): Promise<{ id: number }> {
  return post<{ id: number }>('/v1/compare/save', params)
}

export function deleteCompare(id: number): Promise<void> {
  return post<void>(`/v1/compare/${id}/delete`)
}
