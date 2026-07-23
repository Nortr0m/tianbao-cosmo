/**
 * 金额/日期格式化工具
 */

import dayjs from 'dayjs'

/**
 * 格式化金额
 * @param value 金额数值
 * @param decimals 小数位数，默认2
 * @param prefix 前缀，默认¥
 */
export function formatCurrency(
  value: number | string | undefined | null,
  decimals = 2,
  prefix = '¥'
): string {
  if (value === undefined || value === null || value === '') return `${prefix}0.00`
  const num = typeof value === 'string' ? parseFloat(value) : value
  if (isNaN(num)) return `${prefix}0.00`
  const parts = num.toFixed(decimals).split('.')
  parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',')
  return `${prefix}${parts.join('.')}`
}

/**
 * 格式化百分比
 * @param value 数值（如0.05表示5%）
 * @param decimals 小数位数，默认2
 */
export function formatPercent(value: number | string | undefined | null, decimals = 2): string {
  if (value === undefined || value === null) return '0.00%'
  const num = typeof value === 'string' ? parseFloat(value) : value
  if (isNaN(num)) return '0.00%'
  return `${(num * 100).toFixed(decimals)}%`
}

/**
 * 格式化日期
 * @param value 日期值
 * @param format 格式模板，默认 YYYY-MM-DD
 */
export function formatDate(
  value: string | number | Date | undefined | null,
  format = 'YYYY-MM-DD'
): string {
  if (!value) return '-'
  return dayjs(value).format(format)
}

/**
 * 格式化日期时间
 * @param value 日期值
 */
export function formatDateTime(value: string | number | Date | undefined | null): string {
  return formatDate(value, 'YYYY-MM-DD HH:mm:ss')
}

/**
 * 格式化数字（千分位）
 * @param value 数值
 * @param decimals 小数位数
 */
export function formatNumber(value: number | string | undefined | null, decimals = 0): string {
  if (value === undefined || value === null) return '0'
  const num = typeof value === 'string' ? parseFloat(value) : value
  if (isNaN(num)) return '0'
  const parts = num.toFixed(decimals).split('.')
  parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',')
  return parts.join('.')
}

/**
 * 格式化年龄/年限
 * @param value 数值
 * @param suffix 后缀，默认"岁"
 */
export function formatAge(value: number | undefined | null, suffix = '岁'): string {
  if (value === undefined || value === null) return '-'
  return `${value}${suffix}`
}

/**
 * 格式化保险期间
 * @param years 年数
 */
export function formatInsurancePeriod(years: number | string | undefined | null): string {
  if (years === undefined || years === null) return '-'
  if (years === '终身' || years === 'life') return '终身'
  const num = typeof years === 'string' ? parseInt(years, 10) : years
  if (isNaN(num)) return String(years)
  return num === 1 ? '1年' : `${num}年`
}

/**
 * 截断文本
 * @param text 原文本
 * @param maxLength 最大长度
 * @param suffix 后缀，默认"..."
 */
export function truncateText(text: string | undefined | null, maxLength: number, suffix = '...'): string {
  if (!text) return ''
  if (text.length <= maxLength) return text
  return text.substring(0, maxLength) + suffix
}
