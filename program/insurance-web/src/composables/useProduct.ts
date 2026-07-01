import { ref, computed } from 'vue'
import type { ProductType, ProductDetail } from '@/api/product'
import { getProductDetail, getProductList } from '@/api/product'
import { useProductStore } from '@/stores/productStore'

export function useProduct() {
  const productStore = useProductStore()

  const detail = ref<ProductDetail | null>(null)
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  const productTypeMap: Record<string, string> = {
    critical_illness: '重疾险',
    whole_life: '增额终身寿险',
    annuity: '年金险',
    '1': '重疾险',
    '2': '增额终身寿险',
    '3': '年金险'
  }

  const productTypeColorMap: Record<string, string> = {
    critical_illness: '#e6a23c',
    whole_life: '#409eff',
    annuity: '#67c23a',
    '1': '#e6a23c',
    '2': '#409eff',
    '3': '#67c23a'
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
      const data = await getProductDetail(id)
      detail.value = data
      return data
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
