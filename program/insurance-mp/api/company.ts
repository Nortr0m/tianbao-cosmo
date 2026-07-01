import { get } from '../utils/request';

// 保险公司信息
export interface Company {
  id: string;
  name: string;
  logo: string;
  shortName: string;
  establishDate: string;
  registeredCapital: string;
  riskRating: string;
  riskRatingColor: string;
  satisfaction: string;
  complaintRate: string;
  totalAssets: string;
  netProfit: string;
  solvencyRatio: string;
  introduction: string;
  website: string;
  hotline: string;
  productCount: number;
}

// 公司列表参数
export interface CompanyListParams {
  keyword?: string;
  page?: number;
  pageSize?: number;
}

// 公司列表响应
export interface CompanyListResult {
  list: Company[];
  total: number;
  page: number;
  pageSize: number;
  hasMore: boolean;
}

/**
 * 获取保险公司列表
 * @param params 查询参数
 * @returns 公司列表
 */
export function getCompanyList(params: CompanyListParams = {}): Promise<CompanyListResult> {
  return get<CompanyListResult>('/api/company/list', params);
}

/**
 * 获取保险公司详情
 * @param id 公司ID
 * @returns 公司详情
 */
export function getCompanyDetail(id: string): Promise<Company> {
  return get<Company>(`/api/company/detail/${id}`);
}

/**
 * 获取热门保险公司
 * @param limit 数量限制
 * @returns 热门公司列表
 */
export function getHotCompanies(limit: number = 10): Promise<Company[]> {
  return get<Company[]>('/api/company/hot', { limit });
}

/**
 * 搜索保险公司
 * @param keyword 关键词
 * @returns 搜索结果
 */
export function searchCompanies(keyword: string): Promise<Company[]> {
  return get<Company[]>('/api/company/search', { keyword });
}
