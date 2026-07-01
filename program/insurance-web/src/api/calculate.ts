import { post, get } from './request'
import type { ProductType } from './product'

export interface CalculateParams {
  productId: number
  age: number
  gender: 'male' | 'female'
  paymentPeriod: string
  coverage: number
  dividendRate?: number
  startAge?: number
}

export interface CalculateResult {
  premium: number
  yearlyData: YearlyDataItem[]
  summary: {
    totalPremium: number
    totalReturn: number
    irr: number
    breakEvenYear: number
  }
}

export interface YearlyDataItem {
  year: number
  age: number
  premium: number
  accumulatedPremium: number
  cashValue: number
  dividend: number
  totalValue: number
  deathBenefit: number
}

export interface RateTableParams {
  productId: number
  gender: 'male' | 'female'
  paymentPeriod: string
}

export interface RateTableItem {
  age: number
  ratePerThousand: number
}

export function calculatePremium(params: CalculateParams): Promise<CalculateResult> {
  return post<CalculateResult>('/v1/calculate/critical-premium', params)
}

export function getRateTable(params: RateTableParams): Promise<RateTableItem[]> {
  return get<RateTableItem[]>('/v1/calculate/rate-table', { params })
}

export function getPaymentPeriods(productId: number): Promise<string[]> {
  return get<string[]>(`/v1/calculate/payment-periods/${productId}`)
}

export function getCoverageRange(productId: number): Promise<{ min: number; max: number; step: number }> {
  return get<{ min: number; max: number; step: number }>(`/v1/calculate/coverage-range/${productId}`)
}

export function getBenefitProjection(productType: ProductType, params: CalculateParams): Promise<CalculateResult> {
  const endpointMap: Record<string, string> = {
    'critical_illness': '/v1/calculate/critical-premium',
    'whole_life': '/v1/calculate/whole-life-projection',
    'annuity': '/v1/calculate/annuity-projection'
  }
  const endpoint = endpointMap[productType] || `/v1/calculate/projection/${productType}`

  // 根据产品类型转换参数格式以匹配后端 DTO
  let requestBody: any = { ...params }
  if (productType === 'whole_life') {
    requestBody = {
      productId: params.productId,
      age: params.age,
      gender: params.gender === 'male' ? 1 : 0,
      paymentYear: parseInt(params.paymentPeriod) || 10,
      annualPremium: params.coverage,
      dividendRate: params.dividendRate
    }
  } else if (productType === 'annuity') {
    requestBody = {
      productId: params.productId,
      age: params.age,
      gender: params.gender === 'male' ? 1 : 0,
      paymentYear: parseInt(params.paymentPeriod) || 10,
      annualPremium: params.coverage,
      startAge: params.startAge
    }
  } else if (productType === 'critical_illness') {
    requestBody = {
      productId: params.productId,
      age: params.age,
      gender: params.gender === 'male' ? 1 : 0,
      paymentPeriod: params.paymentPeriod,
      coverage: params.coverage
    }
  }

  return post<any>(endpoint, requestBody).then((data: any) => {

    if (productType === 'whole_life') {
      // 转换后端 WholeLifeProjectionVO 格式为前端 CalculateResult 格式
      const yearlyProjections = data.yearlyProjections || []
      const yearlyData: YearlyDataItem[] = yearlyProjections.map((p: any) => ({
        year: p.policyYear,
        age: p.age,
        premium: p.policyYear <= data.paymentYear ? data.annualPremium : 0,
        accumulatedPremium: p.totalPremium,
        cashValue: p.cashValue || 0,
        dividend: 0,
        totalValue: p.cashValue || 0,
        deathBenefit: p.deathBenefit || 0
      }))

      // 计算 summary
      const lastProjection = yearlyProjections[yearlyProjections.length - 1]
      const lastItem = yearlyData[yearlyData.length - 1]
      const totalPremium = data.totalPremium || 0
      const totalReturn = lastItem ? (lastItem.cashValue - totalPremium) : 0
      const breakEvenYear = yearlyData.findIndex((d: YearlyDataItem) => d.cashValue >= totalPremium) + 1

      return {
        premium: data.annualPremium || 0,
        yearlyData,
        summary: {
          totalPremium,
          totalReturn,
          irr: lastProjection?.returnRate || 0,
          breakEvenYear: breakEvenYear > 0 ? breakEvenYear : 0
        }
      } as CalculateResult
    } else if (productType === 'annuity') {
      // 转换后端 AnnuityProjectionVO 格式为前端 CalculateResult 格式
      const yearlyProjections = data.yearlyProjections || []
      const yearlyData: YearlyDataItem[] = yearlyProjections.map((p: any) => ({
        year: p.policyYear,
        age: p.age,
        premium: p.policyYear <= data.paymentYear ? data.annualPremium : 0,
        accumulatedPremium: p.totalPremium || (p.policyYear <= data.paymentYear ? p.policyYear * data.annualPremium : data.paymentYear * data.annualPremium),
        cashValue: p.cashValue || 0,
        dividend: p.annualPayout || 0,
        totalValue: (p.cashValue || 0) + (p.totalReceived || 0),
        deathBenefit: p.deathBenefit || 0
      }))

      const lastItem = yearlyData[yearlyData.length - 1]
      const totalPremium = data.totalPremium || 0
      const totalReturn = lastItem ? (lastItem.totalValue - totalPremium) : 0

      return {
        premium: data.annualPremium || 0,
        yearlyData,
        summary: {
          totalPremium,
          totalReturn,
          irr: 0,
          breakEvenYear: 0
        }
      } as CalculateResult
    }

    // critical_illness 直接返回
    return data as CalculateResult
  })
}
