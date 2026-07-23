import { get, post, put, del, upload } from './request'

/**
 * 卡片模板接口 - 与后端 AdminCardTemplateVO 对齐
 */
export interface CardTemplate {
  /** 模板ID */
  templateId: number
  /** 模板名称 */
  templateName: string
  /** 分类编码 */
  categoryCode: string
  /** 标签（JSON数组字符串） */
  tags: string
  /** AI提示词 */
  aiPrompt: string
  /** 搜索关键词 */
  searchKeywords: string
  /** 背景图片地址 */
  backgroundUrl: string
  /** 默认标题 */
  defaultTitle: string
  /** 默认副标题 */
  defaultSubtitle: string
  /** 是否系统模板 0-否 1-是 */
  isSystem: number
  /** 是否推荐 0-否 1-是 */
  isRecommended: number
  /** 7日使用次数 */
  useCount7d: number
  /** 30日使用次数 */
  useCount30d: number
  /** 总使用次数 */
  useCountTotal: number
  /** 最后使用时间 */
  lastUsedTime: string
  /** 排序 */
  sortOrder: number
  /** 是否启用 0-禁用 1-启用 */
  isActive: number
  /** 创建时间 */
  createdAt: string
  /** 更新时间 */
  updatedAt: string
}

/** 创建/更新卡片模板参数 */
export interface CardTemplateForm {
  templateName?: string
  categoryCode?: string
  tags?: string
  aiPrompt?: string
  searchKeywords?: string
  backgroundUrl?: string
  defaultTitle?: string
  defaultSubtitle?: string
  isSystem?: number
  isRecommended?: number
  sortOrder?: number
  isActive?: number
}

export interface TemplateQuery {
  pageNum?: number
  pageSize?: number
  keyword?: string
  categoryCode?: string
  isActive?: number
}

export interface PageResult<T> {
  pageNum: number
  pageSize: number
  total: number
  totalPages: number
  list: T[]
}

export interface TemplateStats {
  date: string
  templateId: number
  templateName: string
  usageCount: number
  userCount: number
}

export interface TemplateRanking {
  templateId: number
  templateName: string
  type: string
  usageCount: number
  ranking: number
}

/** 分类编码 -> 显示名称映射 */
export const CATEGORY_LABEL_MAP: Record<string, string> = {
  pension: '养老规划',
  medical: '医疗安心',
  women: '女性专属',
  education: '子女教育',
  family: '家庭保障',
  accident: '意外防护',
  career: '职业保障',
  festival: '节日关怀',
}

export function getTemplateList(params: TemplateQuery): Promise<PageResult<CardTemplate>> {
  return get<PageResult<CardTemplate>>('/v1/admin/card-template/list', { params })
}

export function getTemplateDetail(id: number): Promise<CardTemplate> {
  return get<CardTemplate>(`/v1/admin/card-template/${id}`)
}

export function createTemplate(data: CardTemplateForm): Promise<number> {
  return post<number>('/v1/admin/card-template', data)
}

export function updateTemplate(id: number, data: CardTemplateForm): Promise<void> {
  return put<void>(`/v1/admin/card-template/${id}`, data)
}

export function deleteTemplate(id: number): Promise<void> {
  return del(`/v1/admin/card-template/${id}`)
}

export function updateTemplateStatus(id: number, status: number): Promise<void> {
  return put(`/v1/admin/card-template/${id}/status`, { isActive: status })
}

export function uploadTemplateImage(file: File): Promise<{ url: string; thumbnail: string }> {
  return upload('/v1/admin/card-template/upload', file)
}

export function getTemplateStats(days: number = 30): Promise<TemplateStats[]> {
  return get<TemplateStats[]>(`/v1/admin/card-template/stats?days=${days}`)
}

export function getTemplateRanking(): Promise<TemplateRanking[]> {
  return get<TemplateRanking[]>('/v1/admin/card-template/ranking')
}