import { get, post, put, del } from './request'

export interface Company {
  companyId: number
  companyName: string
  companyShortName: string
  companyCode: string
  logoUrl: string
  officialWebsite: string
  servicePhone: string
  establishedYear: number
  registeredCapital: string
  headquarters: string
  companyType: number
  companyTypeDesc: string
  creditRating: string
  solvencyRatio: number
  introduction: string
  featureTags: string
  cooperationStatus: number
  cooperationStartDate: string
  sortOrder: number
  isHot: number
  createdAt: string
  updatedAt: string
}

export interface CompanyDetail {
  companyName: string
  companyShortName: string
  officialWebsite: string
  servicePhone: string
  establishedYear: number
  registeredCapital: string
  headquarters: string
  introduction: string
  sortOrder: number
}

export interface CompanyStats {
  companyId: number
  companyName: string
  totalProducts: number
  totalPolicies: number
  totalPremium: number
  solvencyRatio: number
  riskRating: string
  cooperationStatus: number
  ranking: number
}

export interface SolvencyDistribution {
  range: string
  count: number
}

export interface RiskRatingDistribution {
  rating: string
  count: number
}

export interface RatingHistoryItem {
  id: number
  companyId: number
  companyName: string
  rating: string
  solvencyRatio: number
  assessmentDate: string
  assessor: string
  remark: string
}

export interface CompanyQuery {
  page?: number
  size?: number
  keyword?: string
  status?: number
}

export interface PageResult<T> {
  list: T[]
  total: number
  page: number
  size: number
}

export function getCompanyList(params: CompanyQuery): Promise<PageResult<Company>> {
  return get<PageResult<Company>>('/v1/admin/company/list', { params })
}

export function getCompanyDetail(companyId: number): Promise<CompanyDetail> {
  return get<CompanyDetail>(`/v1/admin/company/${companyId}`)
}

export function createCompany(data: Partial<CompanyDetail>): Promise<Company> {
  return post<Company>('/v1/admin/company', data)
}

export function updateCompany(companyId: number, data: Partial<CompanyDetail>): Promise<Company> {
  return put<Company>(`/v1/admin/company/${companyId}`, data)
}

export function deleteCompany(companyId: number): Promise<void> {
  return del(`/v1/admin/company/${companyId}`)
}

export function updateCompanyStatus(companyId: number, status: number): Promise<void> {
  return put(`/v1/admin/company/${companyId}/status`, { status })
}

export function getCompanyStats(): Promise<CompanyStats[]> {
  return get<CompanyStats[]>('/v1/admin/company/stats')
}

export function getSolvencyDistribution(): Promise<SolvencyDistribution[]> {
  return get<SolvencyDistribution[]>('/v1/admin/company/solvency-distribution')
}

export function getRiskRatingDistribution(): Promise<RiskRatingDistribution[]> {
  return get<RiskRatingDistribution[]>('/v1/admin/company/risk-rating-distribution')
}

export function getRatingHistory(companyId?: number): Promise<RatingHistoryItem[]> {
  return get<RatingHistoryItem[]>('/v1/admin/company/rating-history', { params: { companyId } })
}

export function addRatingHistory(data: Partial<RatingHistoryItem>): Promise<RatingHistoryItem> {
  return post<RatingHistoryItem>('/v1/admin/company/rating-history', data)
}

export function deleteRatingHistory(id: number): Promise<void> {
  return del(`/v1/admin/company/rating-history/${id}`)
}