import { get, post } from '../utils/request';

// 产品类型
export type ProductType = 'critical_illness' | 'whole_life' | 'annuity';

// 产品信息
export interface Product {
  id: string;
  name: string;
  companyId: string;
  companyName: string;
  companyLogo: string;
  type: ProductType;
  typeName: string;
  tags: string[];
  price: number;
  priceUnit: string;
  coverage: number;
  coverageUnit: string;
  summary: string;
  hotScore: number;
  isHot: boolean;
  isNew: boolean;
  createTime: string;
}

// 产品详情
export interface ProductDetail extends Product {
  description: string;
  features: string[];
  responsibilities: Responsibility[];
  benefitDemo: BenefitDemo[];
  companyInfo: CompanyInfo;
  conditions: string[];
  exclusions: string[];
}

// 保险责任
export interface Responsibility {
  name: string;
  description: string;
  amount: string;
  isMain: boolean;
}

// 利益演示
export interface BenefitDemo {
  year: number;
  age: number;
  premium: number;
  cashValue: number;
  deathBenefit: number;
  surrenderValue: number;
}

// 公司信息
export interface CompanyInfo {
  id: string;
  name: string;
  logo: string;
  establishDate: string;
  registeredCapital: string;
  riskRating: string;
  satisfaction: string;
  complaintRate: string;
  introduction: string;
}

// 产品列表参数
export interface ProductListParams {
  type?: ProductType;
  keyword?: string;
  page?: number;
  pageSize?: number;
  sort?: string;
  order?: 'asc' | 'desc';
  minPrice?: number;
  maxPrice?: number;
  minCoverage?: number;
  maxCoverage?: number;
}

// 产品列表响应
export interface ProductListResult {
  list: Product[];
  total: number;
  page: number;
  pageSize: number;
  hasMore: boolean;
}

// 对比产品参数
export interface CompareParams {
  productIds: string[];
}

// 对比结果
export interface CompareResult {
  products: ProductDetail[];
  comparison: ComparisonItem[];
}

// 对比项
export interface ComparisonItem {
  key: string;
  label: string;
  values: (string | number)[];
  highlight?: number;
}

/**
 * 获取产品列表
 * @param params 查询参数
 * @returns 产品列表
 */
export function getProductList(params: ProductListParams = {}): Promise<ProductListResult> {
  return get<ProductListResult>('/api/product/list', params);
}

/**
 * 获取产品详情
 * @param id 产品ID
 * @returns 产品详情
 */
export function getProductDetail(id: string): Promise<ProductDetail> {
  return get<ProductDetail>(`/api/product/detail/${id}`);
}

/**
 * 获取热门产品
 * @param limit 数量限制
 * @returns 热门产品列表
 */
export function getHotProducts(limit: number = 6): Promise<Product[]> {
  return get<Product[]>('/api/product/hot', { limit });
}

/**
 * 获取新品推荐
 * @param limit 数量限制
 * @returns 新品列表
 */
export function getNewProducts(limit: number = 6): Promise<Product[]> {
  return get<Product[]>('/api/product/new', { limit });
}

/**
 * 搜索产品
 * @param keyword 关键词
 * @returns 搜索结果
 */
export function searchProducts(keyword: string): Promise<Product[]> {
  return get<Product[]>('/api/product/search', { keyword });
}

/**
 * 获取产品对比数据
 * @param params 对比参数
 * @returns 对比结果
 */
export function compareProducts(params: CompareParams): Promise<CompareResult> {
  return post<CompareResult>('/api/product/compare', params);
}

/**
 * 获取产品类型列表
 * @returns 产品类型列表
 */
export function getProductTypes(): Promise<{ value: ProductType; label: string; icon: string }[]> {
  return get('/api/product/types');
}

/**
 * 收藏/取消收藏产品
 * @param productId 产品ID
 * @param isFavorite 是否收藏
 */
export function toggleFavorite(productId: string, isFavorite: boolean): Promise<void> {
  return post<void>('/api/product/favorite', { productId, isFavorite });
}

/**
 * 获取收藏列表
 * @returns 收藏的产品列表
 */
export function getFavorites(): Promise<Product[]> {
  return get<Product[]>('/api/product/favorites');
}
