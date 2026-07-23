import { defineStore } from 'pinia'
import { ref, computed, shallowRef } from 'vue'
import type { Product, ProductType, ProductListParams, ProductListResult } from '@/api/product'
import { getProductList, getProductTypes, getHotProducts } from '@/api/product'

export const useProductStore = defineStore('product', () => {
  // ============= State =============
  // 使用 shallowRef 减少深层响应式开销（产品列表数据量大且通常整体替换）
  const productList = shallowRef<Product[]>([])
  const total = ref(0)
  const currentPage = ref(1)
  const pageSize = ref(12)
  const productTypes = ref<{ value: ProductType; label: string }[]>([])
  const hotProducts = shallowRef<Product[]>([])
  const isLoading = ref(false)
  const isTypesLoading = ref(false)
  const isHotLoading = ref(false)
  const error = ref<string | null>(null)
  const currentParams = ref<ProductListParams>({})

  // ============= 缓存机制 =============
  // 缓存有效期（5分钟 = 300000ms）
  const CACHE_TTL = 5 * 60 * 1000

  interface CacheEntry {
    data: ProductListResult
    timestamp: number
  }

  // 产品列表缓存：key 为序列化后的参数字符串
  const _listCache = new Map<string, CacheEntry>()

  /**
   * 生成缓存 key：将参数对象序列化为稳定的字符串 key
   */
  function _getCacheKey(params: ProductListParams): string {
    // 按 key 排序后再序列化，确保参数顺序不同但内容相同的请求命中同一缓存
    const sortedKeys = Object.keys(params).sort()
    const sortedObj: Record<string, any> = {}
    for (const k of sortedKeys) {
      sortedObj[k] = (params as any)[k]
    }
    return JSON.stringify(sortedObj)
  }

  /**
   * 从缓存中获取数据
   */
  function _getFromCache(key: string): ProductListResult | null {
    const entry = _listCache.get(key)
    if (!entry) return null
    if (Date.now() - entry.timestamp > CACHE_TTL) {
      _listCache.delete(key) // 过期删除
      return null
    }
    return entry.data
  }

  /**
   * 写入缓存
   */
  function _setCache(key: string, data: ProductListResult) {
    _listCache.set(key, { data, timestamp: Date.now() })
    // 简单清理：当缓存条目超过 50 条时，删除最旧的一半
    if (_listCache.size > 50) {
      const keys = Array.from(_listCache.keys())
      const half = Math.floor(keys.length / 2)
      for (let i = 0; i < half; i++) {
        _listCache.delete(keys[i])
      }
    }
  }

  /**
   * 清除产品列表缓存（数据变更后调用）
   */
  function clearListCache() {
    _listCache.clear()
  }

  // 产品ID快速查找Map（延迟计算，按需生成）
  const _productMap = computed<Map<number, Product>>(() => {
    const map = new Map<number, Product>()
    for (const p of productList.value) {
      map.set(p.productId, p)
    }
    return map
  })

  // ============= Getters =============
  const hasMore = computed(() => productList.value.length < total.value)

  /** 按ID快速查找产品（使用Map，O(1)复杂度） */
  const getProductById = computed(() => {
    return (id: number) => _productMap.value.get(id)
  })

  /** 是否为空列表 */
  const isEmpty = computed(() => !isLoading.value && productList.value.length === 0)

  // ============= Actions =============

  /**
   * 获取产品列表
   * @param params 查询参数
   * @param append 是否追加到现有列表（用于分页加载更多）
   * @param useCache 是否使用缓存（默认 true，首次加载和非追加模式下生效）
   */
  async function fetchProducts(
    params: ProductListParams = {},
    append = false,
    useCache = true
  ): Promise<ProductListResult> {
    // 完全替换当前参数，避免旧参数累积
    if (!append) {
      currentParams.value = { ...params }
    }

    const requestParams: ProductListParams = {
      page: append ? currentPage.value + 1 : currentPage.value,
      pageSize: pageSize.value,
      ...params
    }

    // 非追加模式下尝试使用缓存
    if (!append && useCache) {
      const cacheKey = _getCacheKey(requestParams)
      const cached = _getFromCache(cacheKey)
      if (cached) {
        productList.value = cached.list
        total.value = cached.total
        currentPage.value = cached.pageNum
        pageSize.value = cached.pageSize
        return cached
      }
    }

    isLoading.value = true
    error.value = null

    try {
      const res: ProductListResult = await getProductList(requestParams)

      if (append) {
        productList.value = [...productList.value, ...res.list]
      } else {
        productList.value = res.list
        // 非追加模式写入缓存
        if (useCache) {
          const cacheKey = _getCacheKey(requestParams)
          _setCache(cacheKey, res)
        }
      }
      total.value = res.total
      currentPage.value = res.pageNum
      pageSize.value = res.pageSize
      return res
    } catch (err) {
      error.value = err instanceof Error ? err.message : '获取产品列表失败'
      throw err
    } finally {
      isLoading.value = false
    }
  }

  /** 加载更多（分页追加） */
  async function loadMore(params: ProductListParams = {}): Promise<ProductListResult | null> {
    if (!hasMore.value || isLoading.value) return null
    return fetchProducts(params, true)
  }

  /** 获取产品类型 */
  async function fetchProductTypes() {
    if (productTypes.value.length > 0) return productTypes.value
    isTypesLoading.value = true
    try {
      const types = await getProductTypes()
      productTypes.value = types
      return types
    } catch (err) {
      productTypes.value = []
      error.value = err instanceof Error ? err.message : '获取产品类型失败'
      return []
    } finally {
      isTypesLoading.value = false
    }
  }

  /** 获取热门产品 */
  async function fetchHotProducts(limit = 8) {
    isHotLoading.value = true
    try {
      const products = await getHotProducts(limit)
      hotProducts.value = products
      return products
    } catch (err) {
      hotProducts.value = []
      error.value = err instanceof Error ? err.message : '获取热门产品失败'
      return []
    } finally {
      isHotLoading.value = false
    }
  }

  /** 设置当前页码 */
  function setPage(page: number) {
    currentPage.value = page
  }

  /** 设置每页数量 */
  function setPageSize(size: number) {
    pageSize.value = size
    currentPage.value = 1
  }

  /** 重置筛选条件 */
  function resetFilters() {
    currentParams.value = {}
    currentPage.value = 1
    productList.value = []
    total.value = 0
    error.value = null
    clearListCache()
  }

  /** 清空错误 */
  function clearError() {
    error.value = null
  }

  return {
    // State
    productList,
    total,
    currentPage,
    pageSize,
    productTypes,
    hotProducts,
    isLoading,
    isTypesLoading,
    isHotLoading,
    error,
    currentParams,
    // Getters
    hasMore,
    getProductById,
    isEmpty,
    // Actions
    fetchProducts,
    loadMore,
    fetchProductTypes,
    fetchHotProducts,
    setPage,
    setPageSize,
    resetFilters,
    clearError,
    clearListCache
  }
})
