import { defineStore } from 'pinia'
import { ref, computed, shallowRef } from 'vue'
import type { CompareParams, CompareResult } from '@/api/compare'
import type { ProductType } from '@/api/product'
import { compareProducts, getCompareHistory, saveCompare, deleteCompare as apiDeleteCompare } from '@/api/compare'

// 产品类型映射常量（提取到外部，避免每次computed都重新创建）
const PRODUCT_TYPE_LABEL_MAP: Record<number, string> = {
  1: '重疾险',
  2: '增额终身寿险',
  3: '年金险',
  4: '健康险'
}

// 最大对比数量
const MAX_COMPARE_COUNT = 8

export const useCompareStore = defineStore('compare', () => {
  // ============= State =============
  // 对比结果使用 shallowRef 减少深层响应式开销
  const compareResult = shallowRef<CompareResult | null>(null)
  const compareParams = ref<CompareParams>({ productIds: [] })
  const compareHistory = ref<Awaited<ReturnType<typeof getCompareHistory>>>([])
  const isLoading = ref(false)
  const isHistoryLoading = ref(false)
  const isSaving = ref(false)
  const error = ref<string | null>(null)
  const selectedProductIds = ref<number[]>([])
  const selectedProductType = ref<number>(0)
  const currentProductType = ref<ProductType>('critical_illness')

  // ============= Getters =============
  const compareItems = computed(() => compareResult.value?.items ?? [])
  const dimensions = computed(() => compareResult.value?.dimensions ?? [])
  const winnerId = computed(() => compareResult.value?.winnerId ?? null)
  const hasResult = computed(() => !!compareResult.value && compareResult.value.items.length > 0)
  const canCompare = computed(() => selectedProductIds.value.length >= 2)
  const selectedCount = computed(() => selectedProductIds.value.length)
  const isMaxSelected = computed(() => selectedProductIds.value.length >= MAX_COMPARE_COUNT)

  /** 当前对比产品类型名称（使用外部常量映射，性能更优） */
  const currentProductTypeLabel = computed(() => {
    return PRODUCT_TYPE_LABEL_MAP[selectedProductType.value] || ''
  })

  // ============= Actions =============

  /** 执行对比 */
  async function doCompare(productType: ProductType, params: CompareParams) {
    isLoading.value = true
    error.value = null
    compareParams.value = params
    currentProductType.value = productType
    try {
      const result = await compareProducts(productType, params)
      compareResult.value = result
      return result
    } catch (err) {
      error.value = err instanceof Error ? err.message : '对比失败'
      throw err
    } finally {
      isLoading.value = false
    }
  }

  /** 获取对比历史 */
  async function fetchCompareHistory(force = false) {
    if (!force && compareHistory.value.length > 0 && !isHistoryLoading.value) {
      return compareHistory.value
    }
    isHistoryLoading.value = true
    try {
      const history = await getCompareHistory()
      compareHistory.value = history
      return history
    } catch (err) {
      compareHistory.value = []
      error.value = err instanceof Error ? err.message : '获取对比历史失败'
      return []
    } finally {
      isHistoryLoading.value = false
    }
  }

  /** 保存当前对比 */
  async function saveCurrentCompare() {
    if (!compareParams.value?.productIds?.length) return null
    isSaving.value = true
    try {
      const res = await saveCompare(compareParams.value)
      // 保存成功后刷新历史
      fetchCompareHistory(true)
      return res
    } catch (err) {
      error.value = err instanceof Error ? err.message : '保存失败'
      return null
    } finally {
      isSaving.value = false
    }
  }

  /** 删除对比记录 */
  async function deleteCompareItem(id: number): Promise<boolean> {
    try {
      await apiDeleteCompare(id)
      compareHistory.value = compareHistory.value.filter(item => item.id !== id)
      return true
    } catch (err) {
      error.value = err instanceof Error ? err.message : '删除失败'
      return false
    }
  }

  /**
   * 切换产品选中状态
   * @param productId 产品ID
   * @param productType 产品类型
   * @param maxCount 最大可选数量
   */
  function toggleProductSelection(productId: number, productType: number, maxCount: number = MAX_COMPARE_COUNT): { success: boolean; error?: string } {
    const index = selectedProductIds.value.indexOf(productId)
    if (index > -1) {
      // 取消选中
      selectedProductIds.value.splice(index, 1)
      // 如果取消后没有选中项，清空类型
      if (selectedProductIds.value.length === 0) {
        selectedProductType.value = 0
      }
      return { success: true }
    } else {
      // 新增选中
      if (selectedProductIds.value.length >= maxCount) {
        return { success: false, error: `对比列表已满（最多${maxCount}个）` }
      }
      if (selectedProductIds.value.length > 0 && productType !== selectedProductType.value) {
        return { success: false, error: `只允许同类型产品对比，当前对比列表为${currentProductTypeLabel.value}类型` }
      }
      selectedProductIds.value.push(productId)
      selectedProductType.value = productType
      return { success: true }
    }
  }

  /** 检查产品是否已选中 */
  function isProductSelected(productId: number): boolean {
    return selectedProductIds.value.includes(productId)
  }

  /** 清空选中列表 */
  function clearSelection() {
    selectedProductIds.value = []
    selectedProductType.value = 0
  }

  /** 清空对比结果 */
  function clearResult() {
    compareResult.value = null
    compareParams.value = { productIds: [] }
    error.value = null
  }

  /** 批量设置选中产品ID */
  function setSelectedProductIds(ids: number[]) {
    selectedProductIds.value = ids.slice(0, MAX_COMPARE_COUNT)
  }

  /** 清空错误 */
  function clearError() {
    error.value = null
  }

  return {
    // State
    compareResult,
    compareParams,
    compareHistory,
    isLoading,
    isHistoryLoading,
    isSaving,
    error,
    selectedProductIds,
    selectedProductType,
    currentProductType,
    // Getters
    compareItems,
    dimensions,
    winnerId,
    hasResult,
    canCompare,
    selectedCount,
    isMaxSelected,
    currentProductTypeLabel,
    // Actions
    doCompare,
    fetchCompareHistory,
    saveCurrentCompare,
    deleteCompareItem,
    toggleProductSelection,
    isProductSelected,
    clearSelection,
    clearResult,
    setSelectedProductIds,
    clearError,
    // 常量
    MAX_COMPARE_COUNT
  }
})
