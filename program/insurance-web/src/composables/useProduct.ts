import { ref, computed } from 'vue'
import type { ProductType, ProductDetail, ProductResponsibilityVO, FlatResponsibilityItem } from '@/api/product'
import { getProductDetail, getProductList, getProductResponsibilities } from '@/api/product'
import { useProductStore } from '@/stores/productStore'

/**
 * 将产品责任数据扁平化并转换为前端组件友好格式：
 * - 将 categories 中的 items 展开为一维数组
 * - 为每个 item 添加 category 和 categoryName 字段
 * - 同时提供 ResponsibilityConfig 组件所需的 code/name/supported 等字段
 */
function flattenResponsibilities(resp: ProductResponsibilityVO | null | undefined): FlatResponsibilityItem[] {
  if (!resp?.categories?.length) return []
  const result: FlatResponsibilityItem[] = []
  for (const cat of resp.categories) {
    for (const item of cat.items) {
      const supported = item.isSupported === 1
      const options = parseOptions(item.supportedOptions)
      const optionType = detectOptionType(item.supportedOptions)

      result.push({
        // 原始字段
        itemId: item.itemId,
        itemCode: item.itemCode,
        itemName: item.itemName,
        isSupported: item.isSupported,
        supportedOptions: item.supportedOptions,
        defaultOption: item.defaultOption,
        premiumCoefficient: item.premiumCoefficient,
        sortOrder: item.sortOrder,
        // 分类信息
        category: cat.categoryCode,
        categoryName: cat.categoryName,
        categorySortOrder: cat.sortOrder,
        // 前端组件兼容字段（供 ResponsibilityConfig 等组件使用
        code: item.itemCode,
        name: item.itemName,
        supported,
        options,
        optionType: optionType as any,
        defaultValue: parseDefaultValue(item.defaultOption, optionType, options),
        description: item.description || ''
      } as FlatResponsibilityItem)
    }
  }
  // 按分类排序 + 项内排序
  result.sort((a, b) => {
    if (a.categorySortOrder !== b.categorySortOrder) return a.categorySortOrder - b.categorySortOrder
    return a.sortOrder - b.sortOrder
  })
  return result
}

/** 解析支持的选项列表 */
function parseOptions(supportedOptions: string): { label: string; value: string | number }[] {
  if (!supportedOptions) return []
  try {
    const parsed = JSON.parse(supportedOptions)
    if (Array.isArray(parsed)) {
      return parsed.map((opt: any) => {
        if (typeof opt === 'object' && opt !== null) {
          return {
            label: opt.label ?? opt.name ?? String(opt.value ?? ''),
            value: opt.value ?? opt.code ?? opt
          }
        }
        return { label: String(opt), value: opt }
      })
    }
  } catch {
    // 解析失败返回空
  }
  return []
}

/** 检测选项类型 */
function detectOptionType(supportedOptions: string): 'radio' | 'checkbox' | 'amount' | 'switch' | '' {
  if (!supportedOptions) return 'switch' // 无选项默认开关型
  try {
    const parsed = JSON.parse(supportedOptions)
    if (Array.isArray(parsed)) {
      if (parsed.length === 0) return 'switch'
      // 检查是否是 0/1 开关型
      if (parsed.length === 2 && parsed.every((o: any) =>
        o === 0 || o === 1 || o === '0' || o === '1' ||
        (typeof o === 'object' && (o.value === 0 || o.value === 1)))) {
        return 'switch'
      }
      return 'radio'
    }
    if (typeof parsed === 'object' && parsed !== null) {
      if (parsed.type === 'amount') return 'amount'
      if (parsed.type === 'checkbox') return 'checkbox'
    }
  } catch {
    // 解析失败
  }
  return 'radio'
}

/** 解析默认值 */
function parseDefaultValue(
  defaultOption: string,
  optionType: string,
  options: { label: string; value: string | number }[]
): string | number | boolean | string[] {
  if (optionType === 'switch') {
    return defaultOption === '1' || defaultOption === 'true'
  }
  if (optionType === 'checkbox') {
    try {
      const parsed = JSON.parse(defaultOption)
      return Array.isArray(parsed) ? parsed : []
    } catch {
      return []
    }
  }
  if (options.length > 0) {
    // 如果 defaultOption 可能是 value 值，找到对应的值
    const matched = options.find(o => String(o.value) === String(defaultOption))
    if (matched) return matched.value
    return options[0].value
  }
  return defaultOption || ''
}

export function useProduct() {
  const productStore = useProductStore()

  const detail = ref<ProductDetail | null>(null)
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  const productTypeMap: Record<string, string> = {
    critical_illness: '重疾险',
    whole_life: '增额终身寿险',
    annuity: '年金险',
    health: '健康险',
    '1': '重疾险',
    '2': '增额终身寿险',
    '3': '年金险',
    '4': '健康险'
  }

  const productTypeColorMap: Record<string, string> = {
    critical_illness: '#1890ff',
    whole_life: '#52c41a',
    annuity: '#faad14',
    health: '#eb2f96',
    '1': '#1890ff',
    '2': '#52c41a',
    '3': '#faad14',
    '4': '#eb2f96'
  }

  const currentProductTypeLabel = computed(() => {
    if (!detail.value) return ''
    return productTypeMap[detail.value.productType] || '未知类型'
  })

  const currentProductTypeColor = computed(() => {
    if (!detail.value) return ''
    return productTypeColorMap[detail.value.productType] || '#909399'
  })

  async function fetchDetail(id: number) {
    isLoading.value = true
    error.value = null
    try {
      // 并行请求产品详情和责任数据，提高性能
      const [detailData, respData] = await Promise.all([
        getProductDetail(id),
        getProductResponsibilities(id).catch(() => null) // 责任接口失败不影响详情展示
      ])

      // 将责任数据扁平化后合并到 detail 中
      detailData.responsibilities = flattenResponsibilities(respData)

      detail.value = detailData
      return detailData
    } catch (err) {
      error.value = err instanceof Error ? err.message : '获取产品详情失败'
      throw err
    } finally {
      isLoading.value = false
    }
  }

  async function searchProducts(keyword: string) {
    isLoading.value = true
    try {
      const result = await getProductList({ keyword, page: 1, pageSize: 20 })
      return result.list
    } finally {
      isLoading.value = false
    }
  }

  function getTypeLabel(type: ProductType | number | string): string {
    return productTypeMap[String(type)] || String(type)
  }

  function getTypeColor(type: ProductType | number | string): string {
    return productTypeColorMap[String(type)] || '#909399'
  }

  function clearDetail() {
    detail.value = null
    error.value = null
  }

  return {
    detail,
    isLoading,
    error,
    currentProductTypeLabel,
    currentProductTypeColor,
    fetchDetail,
    searchProducts,
    getTypeLabel,
    getTypeColor,
    clearDetail,
    productList: computed(() => productStore.productList),
    hotProducts: computed(() => productStore.hotProducts),
    productTypes: computed(() => productStore.productTypes),
    fetchProducts: productStore.fetchProducts,
    fetchHotProducts: productStore.fetchHotProducts,
    fetchProductTypes: productStore.fetchProductTypes
  }
}
