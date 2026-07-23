import { get, post, put, del, upload } from './request'

export interface ProductQuery {
  pageNum?: number
  pageSize?: number
  keyword?: string
  companyId?: number
  productType?: number
  status?: number
  saleStatus?: number
  systemStatus?: number
  maintenanceStatus?: number
  sortField?: string
  sortOrder?: string
}

export interface Product {
  productId: number
  productName: string
  productCode: string
  companyId: number
  companyName: string
  productType: number
  productTypeDesc: string
  subType: number
  minAge: number
  maxAge: number
  paymentYears: string
  occupationClass: number
  paymentPeriods: string
  monthlyRatio: number
  quarterlyRatio: number
  halfYearlyRatio: number
  saleStatus: number
  systemStatus: number
  createdAt: string
  updatedAt: string
  subProductData: Record<string, any>
}

export interface ProductDetail extends Product {
  description: string
  highlights: string[]
  responsibilities: Responsibility[]
  rates: RateItem[]
  clauses: string[]
  faq: FAQItem[]
}

export interface Responsibility {
  id: number
  name: string
  description: string
  coverage: string
  type: string
  sortOrder: number
}

export interface RateItem {
  id: number
  age: number
  gender: string
  premium: number
  coverage: number
  paymentPeriod: string
}

export interface FAQItem {
  question: string
  answer: string
}

export interface ProductFormData {
  id?: number
  name: string
  productCode?: string
  companyId: number
  category: string
  subCategory: string
  premium: number
  coverage: number
  term: string
  paymentPeriod: string
  description: string
  highlights: string[]
  responsibilities: Responsibility[]
  status: number
  displayStatus: number
  sortOrder: number
  productType?: number
  subType?: number
  minAge?: number
  maxAge?: number
  paymentYears?: string
  occupationClass?: number
  paymentPeriods?: string
  monthlyRatio?: number
  quarterlyRatio?: number
  halfYearlyRatio?: number
  saleStatus?: number
  systemStatus?: number
}

export interface PageResult<T> {
  list: T[]
  total: number
  page: number
  size: number
}

export function getProductList(params: ProductQuery): Promise<PageResult<Product>> {
  return get<PageResult<Product>>('/v1/admin/product/list', { params })
}

export function getProductDetail(id: number): Promise<ProductDetail> {
  return get<ProductDetail>(`/v1/admin/product/${id}`)
}

export function createProduct(data: ProductFormData): Promise<Product> {
  return post<Product>('/v1/admin/product', data)
}

export function updateProduct(id: number, data: ProductFormData): Promise<Product> {
  return put<Product>(`/v1/admin/product/${id}`, data)
}

export function deleteProduct(id: number): Promise<void> {
  return del(`/v1/admin/product/${id}`)
}

export function updateProductSaleStatus(id: number, status: number): Promise<void> {
  return put(`/v1/admin/product/${id}/sale-status`, { saleStatus: status })
}

export function updateProductSystemStatus(id: number, status: number): Promise<void> {
  return put(`/v1/admin/product/${id}/system-status`, { systemStatus: status })
}

export function updateProductDisplayStatus(id: number, displayStatus: number): Promise<void> {
  return put(`/v1/admin/product/${id}/display-status`, { displayStatus })
}

export function importRates(productId: number, file: File): Promise<void> {
  return upload(`/v1/admin/product/${productId}/import-rates`, file)
}

export function importAnnuityRates(productId: number, file: File): Promise<void> {
  return upload(`/v1/admin/product/${productId}/import-annuity-rates`, file)
}

export function getResponsibilityTemplates(category: string): Promise<Responsibility[]> {
  return get<Responsibility[]>(`/v1/admin/product/responsibility-templates`, { params: { category } })
}

export function saveResponsibilityTemplate(data: Responsibility): Promise<Responsibility> {
  return post<Responsibility>('/v1/admin/product/responsibility-template', data)
}

export function deleteResponsibilityTemplate(id: number): Promise<void> {
  return del(`/v1/admin/product/responsibility-template/${id}`)
}
