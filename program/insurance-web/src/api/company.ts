import { get } from './request'

// 股东信息项（后端返回格式）
export interface ShareholderInfoVO {
  shareholderId: number
  shareholderName: string
  shareholderType: number
  shareholderTypeDesc: string
  country: string
  isActualController: number
  isStateOwned: number
  description: string
  shareRatio: number
  shareAmount: number
  shareType: number
  isControlling: number
  ranking: number
}

// 公司关联关系项（后端返回格式）
export interface CompanyRelationInfoVO {
  relationId: number
  relatedCompanyId: number
  relatedCompanyName: string
  relatedCompanyShortName: string
  relatedCompanyLogo: string
  relationType: number
  relationTypeDesc: string
  relationName: string
  shareRatio: number
  description: string
}

// 股东信息项（前端兼容格式）
export interface ShareholderItem {
  name: string
  ratio: string
  ratioValue: number
  type: string
  isControlling: boolean
  isStateOwned?: boolean
  isForeign?: boolean
}

// 公司关联关系项（前端兼容格式）
export interface CompanyRelationItem {
  companyId: number
  companyName: string
  relationType: number // 1:同一集团 2:同一大股东 3:母子公司 4:参股投资
  relationName: string
}

export interface Company {
  companyId: number
  companyName: string
  companyShortName: string
  logoUrl: string
  introduction: string
  officialWebsite: string
  servicePhone: string
  establishedYear: number
  registeredCapital: number
  headquarters: string
  companyType: number
  companyTypeDesc: string
  creditRating: string
  cooperationStatus: number
  isHot: number
  shareholders?: ShareholderItem[]
  relations?: CompanyRelationItem[]
  riskRating?: string
  solvencyRatio?: number
}

export interface CompanyCosmos {
  companyId: number
  companyName: string
  companyShortName: string
  nature: string
  capital: number
  productCount: number
  productTypes: string[]
  productNames?: string[]
  shareholders?: ShareholderItem[]
  relations?: CompanyRelationItem[]
}

export interface CompanyListResult {
  list: Company[]
  total: number
}

export function getCompanyList(page = 1, pageSize = 50): Promise<CompanyListResult> {
  return get<CompanyListResult>('/v1/company/list', { params: { page, pageSize } })
}

export function getCompanyDetail(id: number): Promise<Company> {
  return get<Company>(`/v1/company/${id}`)
}

export function getAllCompanies(): Promise<Company[]> {
  return get<Company[]>('/v1/company/all')
}

export function searchCompanies(keyword: string): Promise<Company[]> {
  return get<Company[]>('/v1/company/search', { params: { keyword } })
}

export function getCosmosData(): Promise<CompanyCosmos[]> {
  return get<CompanyCosmos[]>('/v1/company/cosmos-data')
}

// 获取公司股东列表
export function getCompanyShareholders(companyId: number): Promise<ShareholderInfoVO[]> {
  return get<ShareholderInfoVO[]>(`/v1/company/${companyId}/shareholders`)
}

// 获取公司关联关系
export function getCompanyRelations(companyId: number): Promise<CompanyRelationInfoVO[]> {
  return get<CompanyRelationInfoVO[]>(`/v1/company/${companyId}/relations`)
}
