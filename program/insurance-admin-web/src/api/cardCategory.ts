import { get, post, put, del } from './request'

/**
 * 卡片分类接口 - 与后端 AdminCardCategoryVO 对齐
 */
export interface CardCategory {
  /** 分类ID */
  categoryId: number
  /** 分类编码 */
  categoryCode: string
  /** 分类名称 */
  categoryName: string
  /** 分类图标 */
  categoryIcon: string
  /** 排序 */
  sortOrder: number
  /** 是否启用 0-禁用 1-启用 */
  isActive: number
  /** 创建时间 */
  createdAt: string
  /** 更新时间 */
  updatedAt: string
}

/** 创建/更新卡片分类参数 */
export interface CardCategoryForm {
  categoryCode?: string
  categoryName?: string
  categoryIcon?: string
  sortOrder?: number
  isActive?: number
}

/** 分类查询参数 */
export interface CardCategoryQueryParams {
  pageNum?: number
  pageSize?: number
  keyword?: string
  categoryCode?: string
  isActive?: number
}

/** 分页结果 */
export interface CategoryPageResult<T> {
  pageNum: number
  pageSize: number
  total: number
  totalPages: number
  list: T[]
}

export function getCategoryList(params: CardCategoryQueryParams): Promise<CategoryPageResult<CardCategory>> {
  return get<CategoryPageResult<CardCategory>>('/v1/admin/card-category/list', { params })
}

export function createCategory(data: CardCategoryForm): Promise<number> {
  return post<number>('/v1/admin/card-category', data)
}

export function updateCategory(id: number, data: CardCategoryForm): Promise<void> {
  return put<void>(`/v1/admin/card-category/${id}`, data)
}

export function deleteCategory(id: number): Promise<void> {
  return del(`/v1/admin/card-category/${id}`)
}
