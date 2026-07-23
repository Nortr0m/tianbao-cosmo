import { post, get } from './request'
import type { ProductType } from './product'

export type { DiseaseItem, DiseaseStat, DiseaseType, DiseaseCategory } from './product'

export interface CalculateParams {
  productId: number
  age: number
  gender: 'male' | 'female'
  paymentPeriod: string
  coverage: number
  dividendRate?: number
  startAge?: number
  /** 责任配置（键为责任项编码，值为选中的选项） */
  responsibilityConfig?: Record<string, any>
}

export interface CalculateResult {
  premium: number
  yearlyData: YearlyDataItem[]
  summary: {
    totalPremium: number
    totalReturn: number
    irr: number
    breakEvenYear: number
    // 分红型扩展
    guaranteedIrr?: number
    dividendIrr?: number
    totalValueWithDividend?: number
  }
}

export interface YearlyDataItem {
  year: number
  age: number
  premium: number
  accumulatedPremium: number
  // 基本利益
  cashValue: number
  deathBenefit: number
  // 分红利益（分红型产品专用）
  dividend?: number              // 当年红利
  accumulatedDividend?: number  // 累积红利
  // 保证利益（分红型产品专用）
  guaranteedCashValue?: number
  guaranteedDeathBenefit?: number
  // 含红利总价值
  totalValue: number
  totalDeathBenefit?: number
  // 年金险专用
  annualPayout?: number
  totalReceived?: number
  // IRR
  irr?: number
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

/**
 * 使用二分法计算 IRR（内部收益率）
 * 对前 N 年的现金流序列，逐年计算截至第 N 年的 IRR
 * @param yearlyData 年度数据数组（已包含 premium 和 totalValue 字段）
 * @returns 每年对应的 IRR 值数组，与 yearlyData 等长
 */
function calculateYearlyIRR(yearlyData: YearlyDataItem[]): (number | null)[] {
  const result: (number | null)[] = []

  for (let endIdx = 0; endIdx < yearlyData.length; endIdx++) {
    // 构建截至第 endIdx 年的现金流
    // 每年的净现金流 = totalValue（含现金价值+累计领取）- premium（当年保费支出）
    const netFlows: number[] = []
    for (let i = 0; i <= endIdx; i++) {
      const row = yearlyData[i]
      // 净值：总价值（可取回的钱）减去当年保费（支出的钱）
      const netValue = (row.totalValue || 0) - (row.premium || 0)
      netFlows.push(netValue)
    }

    if (netFlows.length === 0) {
      result.push(null)
      continue
    }

    // 二分法求 IRR：找到使 NPV = 0 的折现率
    let low = -0.5, high = 2.0
    let irr: number | null = null

    for (let iter = 0; iter < 100; iter++) {
      const mid = (low + high) / 2
      let npv = 0
      for (let t = 0; t < netFlows.length; t++) {
        npv += netFlows[t] / Math.pow(1 + mid, t)
      }
      if (npv > 0) {
        low = mid
      } else {
        high = mid
      }
    }

    irr = Math.round((low + high) / 2 * 10000) / 10000

    // IRR 为负数或极端值时标记为 null
    if (irr < -0.5 || !isFinite(irr)) {
      irr = null
    }

    result.push(irr)
  }

  return result
}

export function calculatePremium(params: CalculateParams, productType: ProductType = 'critical_illness'): Promise<CalculateResult> {
  // 所有产品类型都走 getBenefitProjection（统一参数转换逻辑）
  return getBenefitProjection(productType, params)
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
      paymentYear: parseInt(String(params.paymentPeriod).replace(/[^0-9]/g, '')) || 30,
      coverage: params.coverage ? params.coverage / 10000 : 50,  // 元转万元，默认50万
      responsibilityConfig: params.responsibilityConfig ? JSON.stringify(params.responsibilityConfig) : undefined
    }
  }

  return post<any>(endpoint, requestBody).then((data: any) => {

    if (productType === 'whole_life') {
      // 转换后端 WholeLifeProjectionVO 格式为前端 CalculateResult 格式
      const yearlyProjections = data.yearlyProjections || []
      let accumulatedDiv = 0
      const yearlyData: YearlyDataItem[] = yearlyProjections.map((p: any) => {
        const cashVal = p.cashValue || 0
        const cashValGuaranteed = p.cashValueGuaranteed || cashVal
        const deathBenefitVal = p.deathBenefit || 0
        const deathBenefitGuaranteed = p.deathBenefitGuaranteed || deathBenefitVal
        // 估算当年红利 = 含分红现金价值 - 保证现金价值
        const yearDividend = cashVal > cashValGuaranteed ? cashVal - cashValGuaranteed : 0
        accumulatedDiv += yearDividend

        return {
          year: p.policyYear,
          age: p.age,
          premium: p.policyYear <= data.paymentYear ? data.annualPremium : 0,
          accumulatedPremium: p.totalPremium,
          // 保证利益（分红型才有差异）
          guaranteedCashValue: cashValGuaranteed,
          guaranteedDeathBenefit: deathBenefitGuaranteed,
          // 演示利益（含分红实现率调整后的值）
          cashValue: cashVal,
          deathBenefit: deathBenefitVal,
          totalValue: cashVal,
          totalDeathBenefit: deathBenefitVal,
          // 分红利益
          dividend: yearDividend,
          accumulatedDividend: accumulatedDiv,
          irr: undefined // 占位，下面用 IRR 计算结果替换
        }
      })

      // 使用二分法计算每年的 IRR，替换简单回报率
      const irrResults = calculateYearlyIRR(yearlyData)
      for (let i = 0; i < yearlyData.length; i++) {
        yearlyData[i].irr = irrResults[i] ?? undefined
      }

      // 计算 summary
      const lastProjection = yearlyProjections[yearlyProjections.length - 1]
      const lastItem = yearlyData[yearlyData.length - 1]
      const totalPremium = data.totalPremium || 0
      const totalReturn = lastItem ? (lastItem.totalValue - totalPremium) : 0
      const breakEvenYear = yearlyData.findIndex((d: YearlyDataItem) => d.totalValue >= totalPremium) + 1

      return {
        premium: data.annualPremium || 0,
        yearlyData,
        summary: {
          totalPremium,
          totalReturn,
          irr: lastItem?.irr || 0,
          breakEvenYear: breakEvenYear > 0 ? breakEvenYear : 0,
          guaranteedIrr: lastProjection?.returnRateGuaranteed,
          dividendIrr: lastProjection?.returnRate,
          totalValueWithDividend: lastItem?.totalValue
        }
      } as CalculateResult
    } else if (productType === 'annuity') {
      // 转换后端 AnnuityProjectionVO 格式为前端 CalculateResult 格式
      const yearlyProjections = data.yearlyProjections || []
      let accumulatedDiv = 0
      const yearlyData: YearlyDataItem[] = yearlyProjections.map((p: any) => {
        const cashVal = p.cashValue || 0
        const cashValGuaranteed = p.cashValueGuaranteed || cashVal
        const annualPay = p.annualPayout || 0
        const totalRec = p.totalReceived || 0
        const yearDividend = cashVal > cashValGuaranteed ? cashVal - cashValGuaranteed : 0
        accumulatedDiv += yearDividend

        return {
          year: p.policyYear,
          age: p.age,
          premium: p.policyYear <= data.paymentYear ? data.annualPremium : 0,
          accumulatedPremium: p.totalPremium || (p.policyYear <= data.paymentYear ? p.policyYear * data.annualPremium : data.paymentYear * data.annualPremium),
          cashValue: cashVal,
          guaranteedCashValue: cashValGuaranteed,
          deathBenefit: p.deathBenefit || 0,
          totalValue: cashVal + totalRec,
          // 年金专用字段（不再复用dividend）
          annualPayout: annualPay,
          totalReceived: totalRec,
          // 分红利益
          dividend: yearDividend,
          accumulatedDividend: accumulatedDiv,
          irr: undefined // 占位，下面用 IRR 计算结果替换
        }
      })

      // 使用二分法计算每年的 IRR，填补后端缺失的 returnRate 字段
      const irrResults = calculateYearlyIRR(yearlyData)
      for (let i = 0; i < yearlyData.length; i++) {
        yearlyData[i].irr = irrResults[i] ?? undefined
      }

      const lastItem = yearlyData[yearlyData.length - 1]
      const totalPremium = data.totalPremium || 0
      const totalReturn = lastItem ? (lastItem.totalValue - totalPremium) : 0
      const lastProjection = yearlyProjections[yearlyProjections.length - 1]

      return {
        premium: data.annualPremium || 0,
        yearlyData,
        summary: {
          totalPremium,
          totalReturn,
          irr: lastItem?.irr || 0,
          breakEvenYear: yearlyData.findIndex((d: YearlyDataItem) => d.totalValue >= totalPremium) + 1 || 0,
          guaranteedIrr: lastProjection?.returnRateGuaranteed,
          dividendIrr: lastProjection?.returnRate,
          totalValueWithDividend: lastItem?.totalValue
        }
      } as CalculateResult
    }

    // critical_illness 直接返回
    return data as CalculateResult
  })
}
