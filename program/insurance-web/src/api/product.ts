import { get } from './request'
import type { ShareholderItem, CompanyRelationItem } from './company'

export type ProductType = 'critical_illness' | 'whole_life' | 'annuity' | 'health'

export type DiseaseType = 'critical' | 'medium' | 'light'

export type DiseaseCategory =
  | '恶性肿瘤'
  | '心脑血管'
  | '神经系统'
  | '器官移植'
  | '消化系统'
  | '呼吸系统'
  | '内分泌代谢'
  | '血液免疫'
  | '其他'

export interface DiseaseItem {
  name: string
  code: string
  category: string
  type: DiseaseType
  compensation: string
  waitingPeriod: string
  isHighRisk: boolean
  isStatutory?: boolean
  definition?: string
}

// 疾病信息（后端返回格式）
export interface DiseaseVO {
  diseaseId: number
  diseaseName: string
  diseaseCode: string
  diseaseType: number  // 1-重疾，2-中症，3-轻症
  diseaseTypeDesc?: string
  diseaseCategory: string
  description: string
  isHighIncidence: number
  isStatutory: number
  payoutRatio: number
  payoutTimes: number
  waitingPeriodDays: number
  isBasic: number
  sortOrder: number
}

export interface DiseaseStat {
  criticalCount: number
  mediumCount: number
  lightCount: number
  statutoryCriticalCount: number
  statutoryLightCount: number
  highRiskCount: number
  totalCount: number
}

// 疾病统计（后端返回格式）
export interface DiseaseStatVO {
  criticalCount: number
  mediumCount: number
  lightCount: number
  statutoryCriticalCount: number
  statutoryLightCount: number
  highIncidenceCount: number
}

export interface ProductListParams {
  page?: number
  pageSize?: number
  productType?: number
  subType?: number
  keyword?: string
  companyId?: number
  sortBy?: string
  sortOrder?: 'asc' | 'desc'
  paymentPeriod?: string | number
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
  /** 产品一句话简介 */
  productBrief?: string
  /** 产品亮点（JSON字符串或数组） */
  productHighlights?: string | string[]
  /** 适合人群 */
  suitableFor?: string
  /** 产品详细描述 */
  productDescription?: string
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
  // 收益类型
  yieldType?: string  // '固收型' | '分红型' | '万能型'
  // 资料完整度
  hasTerms?: boolean
  hasBrochure?: boolean
  hasRules?: boolean
  hasRateTable?: boolean
  hasCashValue?: boolean
  // 条款信息（来自 product_terms 表）
  terms?: {
    insurancePeriod?: string
    hesitationPeriod?: string
    waitingPeriod?: string
    liabilitySummary?: string
    exclusionSummary?: string
    otherRights?: string
    saleRegion?: string
  }
  // 增额寿专属扩展字段
  wholeLifeExt?: {
    reductionRuleType?: number
    reductionStartYear?: number
    reductionTimesLimit?: number
    reductionRuleText?: string
    addRuleText?: string
    secondApplicantRule?: string
    crossGeneration?: boolean
    trustLinkage?: boolean
    minPremium?: number
    minSumAssured?: number
    healthClass?: string
    typicalRateExample?: string
    deathPayoutRule?: string
  }
  // 年金险专属扩展字段
  annuityExt?: {
    annuityType?: string
    payoutRuleText?: string
    isLifelong?: boolean
    minPremium?: number
    deathBenefitRule?: string
    universalAccountLinked?: boolean
    universalAccountName?: string
    universalGuaranteedRate?: number
    communityLinkage?: boolean
    communityName?: string
    firstReturnTime?: string
    returnFrequency?: string
    returnAmountRule?: string
    typicalRateExample?: string
  }
  // 扩展字段
  responsibilities?: FlatResponsibilityItem[]
  diseases?: DiseaseItem[]
  diseaseStat?: DiseaseStat
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
    shareholders?: ShareholderItem[]
    relations?: CompanyRelationItem[]
  }
  // 年金险字段
  startAgeOptions?: number[]
  guaranteePeriodOptions?: any[]
  increaseOptions?: any[]
  bonusTypeOptions?: any[]
  bonusAgeOptions?: number[]
  // 分红配置
  dividendConfig?: {
    scheduledRate: number
    guaranteedRate: number
    minGuaranteedRate: number
    increaseRate: number
    dividendLowRate: number
    dividendMidRate: number
    dividendHighRate: number
    dividendAssumedRate: number
    universalSettleRate: number
    minSettleRate: number
  }
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

// 获取产品疾病列表
export function getProductDiseases(
  productId: number,
  diseaseType?: number
): Promise<DiseaseVO[]> {
  const params = diseaseType ? { diseaseType } : undefined
  return get<DiseaseVO[]>(`/v1/product/${productId}/diseases`, { params })
}

// 获取产品疾病统计
export function getDiseaseStat(productId: number): Promise<DiseaseStatVO> {
  return get<DiseaseStatVO>(`/v1/product/${productId}/disease-stat`)
}

// ========== 产品责任 ==========

// 责任项
export interface ResponsibilityItemVO {
  itemId: number
  itemCode: string
  itemName: string
  description?: string
  isSupported: number
  supportedOptions: string
  defaultOption: string
  premiumCoefficient: string
  sortOrder: number
}

// 责任分类
export interface ResponsibilityCategoryVO {
  categoryId: number
  categoryCode: string
  categoryName: string
  sortOrder: number
  items: ResponsibilityItemVO[]
}

// 产品责任VO
export interface ProductResponsibilityVO {
  productId: number
  productName: string
  categories: ResponsibilityCategoryVO[]
}

// 扁平化后的责任项（包含分类信息和前端组件兼容字段）
export interface FlatResponsibilityItem {
  // 原始字段
  itemId: number
  itemCode: string
  itemName: string
  isSupported: number
  supportedOptions: string
  defaultOption: string
  premiumCoefficient: string
  sortOrder: number
  // 分类信息
  category: string
  categoryName: string
  categorySortOrder: number
  // 前端组件兼容字段（供 ResponsibilityConfig 等使用）
  code: string
  name: string
  supported: boolean
  options: { label: string; value: string | number }[]
  optionType: 'radio' | 'checkbox' | 'amount' | 'switch'
  defaultValue: string | number | boolean | string[]
  description: string
}

// 获取产品责任
export function getProductResponsibilities(productId: number): Promise<ProductResponsibilityVO> {
  return get<ProductResponsibilityVO>(`/v1/product/${productId}/responsibilities`)
}

// ========== 产品简介 ==========

export interface ProductBrief {
  productId: number
  productName: string
  productCode: string
  productType: number
  productTypeDesc: string
  subType: number
  companyId: number
  companyName: string
  companyLogo: string
  productBrief: string
  productHighlights: string[]
  suitableFor: string
  minAge: number
  maxAge: number
  paymentYears: string
  saleStatus: number
  /** 产品标签 */
  productTags?: string[]
  /** 保障摘要 */
  coverageSummary?: string
  /** 推荐指数 1-5 */
  recommendationScore?: number
  /** 简介状态 0未生成 1AI生成 2审核通过 3人工编辑 */
  briefStatus?: number
}

// 获取产品简介（轻量级）
export function getProductBrief(productId: number): Promise<ProductBrief> {
  return get<ProductBrief>(`/v1/product/${productId}/brief`)
}
