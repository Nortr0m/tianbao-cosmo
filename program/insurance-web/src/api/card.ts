import { post, get } from './request'
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
  customizations?: {
    backgroundImage?: string
    watermark?: string
    showLogo?: boolean
    showQrCode?: boolean
    customFields?: Record<string, string>
  }
}

export interface CardGenerateResult {
  id: number
  imageUrl: string
  htmlContent: string
  shareUrl: string
  createdAt?: string
}

export function getCardTemplates(productType?: ProductType): Promise<CardTemplate[]> {
  const params = productType ? { productType } : {}
  return get<CardTemplate[]>('/v1/card-template/list', { params })
}

export function generateCard(params: CardGenerateParams): Promise<CardGenerateResult> {
  return post<CardGenerateResult>('/v1/card-template/generate', params)
}

export function getCardHistory(page = 1, pageSize = 10): Promise<{ list: CardGenerateResult[]; total: number }> {
  return get<{ list: CardGenerateResult[]; total: number }>('/v1/card-template/history', { params: { page, pageSize } })
}

export function deleteCard(id: number): Promise<void> {
  return post<void>(`/v1/card-template/${id}/delete`)
}
