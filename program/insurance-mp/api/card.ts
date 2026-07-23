import { get, post } from '../utils/request';

// 卡片模板分类
export interface CardCategory {
  id: string;
  name: string;
  icon: string;
  sort: number;
}

// 卡片模板
export interface CardTemplate {
  id: string;
  name: string;
  categoryId: string;
  categoryName: string;
  thumbnail: string;
  backgroundUrl: string;
  type: 'basic' | 'premium' | 'holiday' | 'exclusive' | 'custom';
  hotScore: number;
  isHot: boolean;
  isNew: boolean;
  tags: string[];
}

// 卡片生成参数
export interface CardGenerateParams {
  templateId: string;
  productId?: string;
  title?: string;
  subtitle?: string;
  content?: string;
  watermark?: boolean;
  watermarkText?: string;
  contactInfo?: {
    name: string;
    phone: string;
    wechat: string;
  };
}

// 卡片生成结果
export interface CardGenerateResult {
  cardId: string;
  imageUrl: string;
  shareUrl: string;
  createTime: string;
}

// 我的卡片
export interface MyCard {
  id: string;
  templateId: string;
  templateName: string;
  thumbnail: string;
  imageUrl: string;
  title: string;
  createTime: string;
}

// 卡片列表参数
export interface CardListParams {
  categoryId?: string;
  keyword?: string;
  page?: number;
  pageSize?: number;
  type?: string;
}

// 卡片列表响应
export interface CardListResult {
  list: CardTemplate[];
  total: number;
  page: number;
  pageSize: number;
  hasMore: boolean;
}

/**
 * 获取卡片模板分类
 * @returns 分类列表
 */
export function getCardCategories(): Promise<CardCategory[]> {
  return get<CardCategory[]>('/api/card/categories');
}

/**
 * 获取卡片模板列表
 * @param params 查询参数
 * @returns 模板列表
 */
export function getCardTemplates(params: CardListParams = {}): Promise<CardListResult> {
  return get<CardListResult>('/api/card/templates', params);
}

/**
 * 获取卡片模板详情
 * @param id 模板ID
 * @returns 模板详情
 */
export function getCardTemplateDetail(id: string): Promise<CardTemplate> {
  return get<CardTemplate>(`/api/card/template/${id}`);
}

/**
 * 生成卡片
 * @param params 生成参数
 * @returns 生成结果
 */
export function generateCard(params: CardGenerateParams): Promise<CardGenerateResult> {
  return post<CardGenerateResult>('/api/card/generate', params);
}

/**
 * 获取我的卡片列表
 * @param page 页码
 * @param pageSize 每页数量
 * @returns 我的卡片列表
 */
export function getMyCards(page: number = 1, pageSize: number = 20): Promise<{ list: MyCard[]; hasMore: boolean }> {
  return get('/api/card/my', { page, pageSize });
}

/**
 * 删除卡片
 * @param cardId 卡片ID
 */
export function deleteCard(cardId: string): Promise<void> {
  return post<void>('/api/card/delete', { cardId });
}

/**
 * 获取热门模板
 * @param limit 数量限制
 * @returns 热门模板列表
 */
export function getHotTemplates(limit: number = 10): Promise<CardTemplate[]> {
  return get<CardTemplate[]>('/api/card/hot', { limit });
}

/**
 * 搜索模板
 * @param keyword 关键词
 * @returns 搜索结果
 */
export function searchTemplates(keyword: string): Promise<CardTemplate[]> {
  return get<CardTemplate[]>('/api/card/search', { keyword });
}
