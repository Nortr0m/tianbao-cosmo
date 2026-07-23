import { post, get, del } from './request'
import type { ProductType } from './product'

export interface CardTemplate {
  id: number
  name: string
  productType: ProductType
  layout: string
  backgroundImage: string
  isDefault: boolean
  isPremium: boolean
}

export interface CardGenerateParams {
  productId: number
  templateId: number
  age: number
  gender: 'male' | 'female'
  paymentPeriod: string
  coverage: number
  premium: number
  watermark?: string
  customParams?: Record<string, any>
}

export interface CardGenerateResult {
  recordId: number
  imageUrl: string
  generateTime: string
}

export interface CardHistoryRecord {
  recordId: number
  templateId: number
  productId: number
  cardTitle: string
  cardSubtitle: string
  backgroundUrl: string
  generatedImageUrl: string
  age: number
  gender: 'male' | 'female'
  paymentPeriod: string
  coverage: number
  premium: number
  watermark: string
  generateTime: string
}

export interface CardHistoryResult {
  list: CardHistoryRecord[]
  total: number
  pageNum: number
  pageSize: number
  totalPages: number
}

export function getCardTemplates(productType?: ProductType): Promise<CardTemplate[]> {
  const params = productType ? { productType } : {}
  return get<CardTemplate[]>('/v1/card-template/list', { params })
}

export function generateCard(params: CardGenerateParams): Promise<CardGenerateResult> {
  return post<CardGenerateResult>('/v1/card/generate', params)
}

export function getCardHistory(pageNum = 1, pageSize = 10): Promise<CardHistoryResult> {
  return get<CardHistoryResult>('/v1/card/history', { params: { pageNum, pageSize } })
}

export function deleteCard(recordId: number): Promise<void> {
  return del<void>(`/v1/card/${recordId}`)
}
