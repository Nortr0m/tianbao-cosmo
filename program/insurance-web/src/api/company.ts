import { get } from './request'

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
}

export interface CompanyCosmos {
  companyId: number
  companyName: string
  companyShortName: string
  nature: string
  capital: number
  productCount: number
  productTypes: string[]
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

export function getCosmosData(): Promise<CompanyCosmos[]> {
  return get<CompanyCosmos[]>('/v1/company/cosmos-data')
}
