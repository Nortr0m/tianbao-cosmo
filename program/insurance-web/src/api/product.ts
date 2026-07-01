import { get } from './request'

export type ProductType = 'critical_illness' | 'whole_life' | 'annuity'

export interface ProductListParams {
  page?: number
  pageSize?: number
  productType?: number
  keyword?: string
  companyId?: number
  sortBy?: string
  sortOrder?: 'asc' | 'desc'
  paymentPeriod?: string
}

export interface Product {
  productId: number
  productName: string
  productType: number
  subType: number
  companyId: number
  companyName: string
  companyLogo: string
  paymentPeriods: string
  paymentYears: string
  minAge: number
  maxAge: number
  maintenanceStatus?: number
  createdAt: string
  updatedAt: string
}

export interface ProductDetail extends Product {
  productCode: string
  productTypeDesc: string
  subType: number
  minAge: number
  maxAge: number
  paymentYears: string
  occupationClass: number
  monthlyRatio: number | null
  quarterlyRatio: number | null
  halfYearlyRatio: number | null
  saleStatus: number
  systemStatus: number
  subProductData: Record<string, any> | null
  // 资料完整度
  hasTerms?: boolean
  hasBrochure?: boolean
  hasRules?: boolean
  hasRateTable?: boolean
  hasCashValue?: boolean
  // 扩展字段
  responsibilities?: any[]
  diseases?: any[]
  benefits?: any[]
  company?: {
    foundedYear?: number
    registeredCapital?: number
    hotline?: string
    website?: string
    description?: string
    companyTypeDesc?: string
    riskRating?: string
    solvencyRatio?: number
  }
  // 年金险字段
  startAgeOptions?: number[]
  guaranteePeriodOptions?: any[]
  increaseOptions?: any[]
  bonusTypeOptions?: any[]
  bonusAgeOptions?: number[]
}

export interface ProductListResult {
  list: Product[]
  total: number
  pageNum: number
  pageSize: number
  totalPages: number
}

export function getProductList(params: ProductListParams): Promise<ProductListResult> {
  return get<ProductListResult>('/v1/product/list', { params })
}

export function getProductDetail(id: number): Promise<ProductDetail> {
  return get<ProductDetail>(`/v1/product/${id}`)
}

export function getProductTypes(): Promise<{ value: ProductType; label: string }[]> {
  return get<{ value: ProductType; label: string }[]>('/v1/product/types')
}

export function getHotProducts(limit = 8): Promise<Product[]> {
  return get<Product[]>(`/v1/product/hot?limit=${limit}`)
}

export function searchProducts(keyword: string): Promise<Product[]> {
  return get<Product[]>(`/v1/product/search?keyword=${encodeURIComponent(keyword)}`)
}
