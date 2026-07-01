import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { Product, ProductType, ProductListParams, ProductListResult } from '@/api/product'
import { getProductList, getProductTypes, getHotProducts } from '@/api/product'

export const useProductStore = defineStore('product', () => {
  // State
  const productList = ref<Product[]>([])
  const total = ref(0)
  const currentPage = ref(1)
  const pageSize = ref(12)
  const productTypes = ref<{ value: ProductType; label: string }[]>([])
  const hotProducts = ref<Product[]>([])
  const isLoading = ref(false)
  const currentParams = ref<ProductListParams>({})

  // Getters
  const hasMore = computed(() => productList.value.length < total.value)
  const getProductById = computed(() => {
    return (id: number) => productList.value.find((p) => p.productId === id)
  })

  // Actions
  async function fetchProducts(params: ProductListParams = {}) {
    isLoading.value = true
    currentParams.value = { ...currentParams.value, ...params }
    try {
      const res: ProductListResult = await getProductList({
        page: currentPage.value,
        pageSize: pageSize.value,
        ...currentParams.value
      })
      productList.value = res.list
      total.value = res.total
      currentPage.value = res.pageNum
      pageSize.value = res.pageSize
      return res
    } finally {
      isLoading.value = false
    }
  }

  async function fetchProductTypes() {
    try {
      const types = await getProductTypes()
      productTypes.value = types
      return types
    } catch {
      productTypes.value = []
      return []
    }
  }

  async function fetchHotProducts(limit = 8) {
    try {
      const products = await getHotProducts(limit)
      hotProducts.value = products
      return products
    } catch {
      hotProducts.value = []
      return []
    }
  }

  function setPage(page: number) {
    currentPage.value = page
  }

  function setPageSize(size: number) {
    pageSize.value = size
    currentPage.value = 1
  }

  function resetFilters() {
    currentParams.value = {}
    currentPage.value = 1
  }

  return {
    productList,
    total,
    currentPage,
    pageSize,
    productTypes,
    hotProducts,
    isLoading,
    currentParams,
    hasMore,
    getProductById,
    fetchProducts,
    fetchProductTypes,
    fetchHotProducts,
    setPage,
    setPageSize,
    resetFilters
  }
})
