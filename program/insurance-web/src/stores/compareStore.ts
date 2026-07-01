import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { CompareParams, CompareResult } from '@/api/compare'
import type { ProductType } from '@/api/product'
import { compareProducts, getCompareHistory, saveCompare } from '@/api/compare'

export const useCompareStore = defineStore('compare', () => {
  // State
  const compareResult = ref<CompareResult | null>(null)
  const compareParams = ref<CompareParams>({ productIds: [] })
  const compareHistory = ref<Awaited<ReturnType<typeof getCompareHistory>>>([])
  const isLoading = ref(false)
  const selectedProductIds = ref<number[]>([])
  const currentProductType = ref<ProductType>('critical_illness')

  // Getters
  const compareItems = computed(() => compareResult.value?.items ?? [])
  const dimensions = computed(() => compareResult.value?.dimensions ?? [])
  const winnerId = computed(() => compareResult.value?.winnerId ?? null)
  const hasResult = computed(() => !!compareResult.value && compareResult.value.items.length > 0)
  const canCompare = computed(() => selectedProductIds.value.length >= 2)

  // Actions
  async function doCompare(productType: ProductType, params: CompareParams) {
    isLoading.value = true
    compareParams.value = params
    currentProductType.value = productType
    try {
      const result = await compareProducts(productType, params)
      compareResult.value = result
      return result
    } finally {
      isLoading.value = false
    }
  }

  async function fetchCompareHistory() {
    try {
      const history = await getCompareHistory()
      compareHistory.value = history
      return history
    } catch {
      compareHistory.value = []
      return []
    }
  }

  async function saveCurrentCompare() {
    if (!compareParams.value) return null
    try {
      const res = await saveCompare(compareParams.value)
      return res
    } catch {
      return null
    }
  }

  function toggleProductSelection(productId: number, maxCount: number = 8) {
    const index = selectedProductIds.value.indexOf(productId)
    if (index > -1) {
      selectedProductIds.value.splice(index, 1)
    } else {
      if (selectedProductIds.value.length >= maxCount) {
        return false
      }
      selectedProductIds.value.push(productId)
    }
    return true
  }

  function isProductSelected(productId: number): boolean {
    return selectedProductIds.value.includes(productId)
  }

  function clearSelection() {
    selectedProductIds.value = []
  }

  function clearResult() {
    compareResult.value = null
    compareParams.value = { productIds: [] }
  }

  function setSelectedProductIds(ids: number[]) {
    selectedProductIds.value = ids.slice(0, 8)
  }

  return {
    compareResult,
    compareParams,
    compareHistory,
    isLoading,
    selectedProductIds,
    currentProductType,
    compareItems,
    dimensions,
    winnerId,
    hasResult,
    canCompare,
    doCompare,
    fetchCompareHistory,
    saveCurrentCompare,
    toggleProductSelection,
    isProductSelected,
    clearSelection,
    clearResult,
    setSelectedProductIds
  }
})
