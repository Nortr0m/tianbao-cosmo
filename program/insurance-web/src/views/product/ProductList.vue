<template>
  <div class="product-list-page">
    <!-- Search & Filter -->
    <div class="search-filter-bar">
      <div class="filter-section">
        <el-form :model="searchForm" :inline="true" label-width="80px" class="filter-form">
          <el-form-item label="产品类型">
            <el-radio-group v-model="searchForm.productType" @change="handleProductTypeChange">
              <el-radio-button value="">全部</el-radio-button>
              <el-radio-button
                v-for="type in productTypes"
                :key="type.value"
                :value="type.value"
              >
                {{ type.label }}
              </el-radio-button>
            </el-radio-group>
          </el-form-item>
          <el-form-item v-if="showSubTypeFilter" label="子类型">
            <el-radio-group v-model="searchForm.subType" @change="handleSearch">
              <el-radio-button value="">全部</el-radio-button>
              <el-radio-button :value="1">分红型</el-radio-button>
              <el-radio-button :value="2">固收型</el-radio-button>
              <el-radio-button :value="3">传统型</el-radio-button>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="保险公司">
            <el-select
              v-model="searchForm.companyId"
              placeholder="搜索保险公司"
              filterable
              remote
              clearable
              :remote-method="handleCompanySearch"
              :loading="companyLoading"
              style="width: 220px"
              @change="handleSearch"
              @clear="handleSearch"
            >
              <el-option
                v-for="company in companyOptions"
                :key="company.companyId"
                :label="company.companyName"
                :value="company.companyId"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="缴费年限">
            <el-select v-model="searchForm.paymentPeriod" placeholder="全部" clearable style="width: 140px" @change="handleSearch">
              <el-option label="趸交" :value="1" />
              <el-option label="3年" :value="3" />
              <el-option label="5年" :value="5" />
              <el-option label="10年" :value="10" />
              <el-option label="15年" :value="15" />
              <el-option label="20年" :value="20" />
              <el-option label="30年" :value="30" />
            </el-select>
          </el-form-item>
          <el-form-item label="关键词">
            <el-input v-model="searchForm.keyword" placeholder="产品名称" clearable style="width: 200px" @keyup.enter="handleSearch" />
          </el-form-item>
        </el-form>
      </div>
      <div class="action-section">
        <div class="view-mode-switch">
          <el-select v-model="searchForm.sortBy" placeholder="排序" style="width: 140px" @change="handleSearch">
            <el-option label="最新上线" value="createdAt" />
            <el-option label="热度最高" value="hot" />
            <el-option label="保费从低到高" value="premium_asc" />
            <el-option label="保费从高到低" value="premium_desc" />
          </el-select>
          <el-radio-group v-model="viewMode" size="small">
            <el-radio-button value="card">
              <el-icon><Grid /></el-icon> 卡片
            </el-radio-button>
            <el-radio-button value="list">
              <el-icon><List /></el-icon> 列表
            </el-radio-button>
          </el-radio-group>
          <el-button
            v-if="compareStore.selectedProductIds.length > 0"
            type="success"
            size="small"
            @click="goToCompare"
          >
            对比({{ compareStore.selectedProductIds.length }})
          </el-button>
        </div>
        <div class="action-buttons">
          <el-button type="primary" :icon="Search" @click="handleSearch">
            查询
          </el-button>
          <el-button :icon="Refresh" @click="handleReset">
            重置
          </el-button>
        </div>
      </div>
    </div>

    <!-- Product Grid / List -->
    <div class="product-grid">
      <!-- 骨架屏加载状态 -->
      <div v-if="isLoading && productList.length === 0" class="skeleton-container">
        <el-row :gutter="20">
          <el-col
            v-for="i in (viewMode === 'card' ? 8 : 10)"
            :key="i"
            :xs="24"
            :sm="12"
            :md="8"
            :lg="6"
            :style="{ display: viewMode === 'card' ? '' : 'none' }"
          >
            <el-skeleton :rows="3" animated class="card-skeleton">
              <template #template>
                <el-skeleton-item variant="image" style="width: 100%; height: 160px" />
                <div style="padding: 14px;">
                  <el-skeleton-item variant="h3" style="width: 70%" />
                  <el-skeleton-item variant="text" style="width: 50%" />
                  <el-skeleton-item variant="text" style="width: 90%" />
                </div>
              </template>
            </el-skeleton>
          </el-col>
        </el-row>
        <el-table v-if="viewMode === 'list'" :data="[]" style="width: 100%">
          <el-table-column label="产品名称" min-width="200">
            <template #default>
              <el-skeleton :rows="1" animated>
                <template #template>
                  <el-skeleton-item variant="text" style="width: 60%" />
                </template>
              </el-skeleton>
            </template>
          </el-table-column>
          <el-table-column label="保险公司" width="160" />
          <el-table-column label="产品类型" width="120" />
          <el-table-column label="投保年龄" width="120" />
          <el-table-column label="缴费方式" width="140" />
          <el-table-column label="操作" width="180" />
        </el-table>
      </div>

      <!-- 错误状态 -->
      <el-empty
        v-else-if="productStore.error && productList.length === 0"
        description="加载失败，请稍后重试"
        class="list-error"
      >
        <el-button type="primary" @click="handleSearch">重新加载</el-button>
      </el-empty>

      <!-- 空状态 -->
      <el-empty v-else-if="productList.length === 0" description="暂无产品" />

      <!-- 列表内容 -->
      <template v-else>
        <!-- Card View -->
        <el-row v-if="viewMode === 'card'" :gutter="20" v-loading="isLoading">
          <el-col
            v-for="product in productList"
            :key="product.productId"
            :xs="24"
            :sm="12"
            :md="8"
            :lg="6"
          >
            <ProductCard
              :product="product"
              :type-label="getTypeLabel(product.productType)"
              :type-color="getTypeColor(product.productType)"
              :is-selected="compareStore.isProductSelected(product.productId)"
              @view-detail="handleViewDetail"
              @toggle-compare="handleToggleCompare"
            />
          </el-col>
        </el-row>
        <!-- List View -->
        <el-table v-else :data="productList" style="width: 100%" v-loading="isLoading">
          <el-table-column prop="productName" label="产品名称" min-width="200">
            <template #default="{ row }">
              <el-link type="primary" @click="handleViewDetail(row.productId)">{{ row.productName }}</el-link>
            </template>
          </el-table-column>
          <el-table-column prop="companyName" label="保险公司" width="160" />
          <el-table-column label="产品类型" width="120">
            <template #default="{ row }">
              <el-tag :color="getTypeColor(row.productType)" size="small" style="color: #fff;">{{ getTypeLabel(row.productType) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="子类型" width="100">
            <template #default="{ row }">
              <span v-if="row.subType === 1">分红型</span>
              <span v-else-if="row.subType === 2">固收型</span>
              <span v-else-if="row.subType === 3">传统型</span>
              <span v-else>-</span>
            </template>
          </el-table-column>
          <el-table-column label="投保年龄" width="120">
            <template #default="{ row }">
              <span>{{ row.minAge != null && row.maxAge != null ? `${row.minAge}-${row.maxAge}岁` : '-' }}</span>
            </template>
          </el-table-column>
          <el-table-column label="缴费方式" width="140">
            <template #default="{ row }">
              <span>{{ formatPaymentYears(row.paymentYears) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="180" fixed="right">
            <template #default="{ row }">
              <el-button type="primary" size="small" @click="handleViewDetail(row.productId)">查看详情</el-button>
              <el-button
                :type="compareStore.isProductSelected(row.productId) ? 'success' : 'default'"
                size="small"
                @click="handleToggleCompare(row.productId)"
              >
                {{ compareStore.isProductSelected(row.productId) ? '已加入' : '对比' }}
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </template>
    </div>

    <!-- Pagination -->
    <BasePagination
      v-model="productStore.currentPage"
      v-model:page-size="productStore.pageSize"
      :total="productStore.total"
      @change="handlePageChange"
    />

    <!-- Compare Floating Bar -->
    <transition name="slide-up">
      <div v-if="compareStore.selectedProductIds.length > 0" class="compare-floating-bar">
        <div class="compare-info">
          <span>已选择 <strong>{{ compareStore.selectedProductIds.length }}</strong> 款产品</span>
          <el-tag v-if="!userStore.isLoggedIn" type="warning" size="small">登录后可对比</el-tag>
          <el-tag v-else-if="!userStore.isVip && compareStore.selectedProductIds.length > 3" type="danger" size="small">
            免费用户最多3款
          </el-tag>
        </div>
        <div class="compare-actions">
          <el-button type="primary" :disabled="compareStore.selectedProductIds.length < 2" @click="goToCompare">
            开始对比
          </el-button>
          <el-button text @click="compareStore.clearSelection">清空</el-button>
        </div>
      </div>
    </transition>

    <!-- VIP Upgrade Dialog -->
    <el-dialog v-model="vipDialogVisible" title="升级会员" width="400px" align-center>
      <p>免费用户最多可同时对比3款产品，升级VIP会员可对比更多产品。</p>
      <template #footer>
        <el-button @click="vipDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="router.push('/vip')">去升级</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Grid, List, Search, Refresh } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { useProduct } from '@/composables/useProduct'
import { useProductStore } from '@/stores/productStore'
import { useCompareStore } from '@/stores/compareStore'
import { useUserStore } from '@/stores/userStore'
import { searchCompanies, getAllCompanies } from '@/api/company'
import type { Company } from '@/api/company'
import type { ProductType } from '@/api/product'
import BasePagination from '@/components/common/BasePagination.vue'
import ProductCard from '@/components/business/ProductCard.vue'

const route = useRoute()
const router = useRouter()
const productStore = useProductStore()
const {
  productList,
  productTypes,
  isLoading,
  fetchProducts,
  fetchProductTypes,
  getTypeLabel,
  getTypeColor
} = useProduct()
const compareStore = useCompareStore()
const userStore = useUserStore()

const companyOptions = ref<Company[]>([])
const companyLoading = ref(false)
const vipDialogVisible = ref(false)
const viewMode = ref('card')

const searchForm = ref<{
  productType: ProductType | ''
  subType: number | ''
  companyId: number | undefined
  paymentPeriod: number | undefined
  keyword: string
  sortBy: string
}>({
  productType: (route.query.type as ProductType) || '',
  subType: '',
  companyId: undefined,
  paymentPeriod: undefined,
  keyword: (route.query.keyword as string) || '',
  sortBy: 'createdAt'
})

let companySearchTimer: ReturnType<typeof setTimeout> | null = null

async function handleCompanySearch(query: string) {
  if (companySearchTimer) {
    clearTimeout(companySearchTimer)
  }
  companyLoading.value = true
  companySearchTimer = setTimeout(async () => {
    try {
      const res = await searchCompanies(query)
      companyOptions.value = res || []
    } catch {
      companyOptions.value = []
    } finally {
      companyLoading.value = false
    }
  }, 300)
}

async function loadAllCompanies() {
  try {
    const res = await getAllCompanies()
    companyOptions.value = res || []
  } catch {
    companyOptions.value = []
  }
}

onMounted(() => {
  fetchProductTypes()
  loadAllCompanies()
  loadProducts()
})

watch(
  () => route.query,
  () => {
    searchForm.value.productType = (route.query.type as ProductType) || ''
    searchForm.value.keyword = (route.query.keyword as string) || ''
    loadProducts()
  }
)

const typeMap: Record<string, number> = {
  critical_illness: 1,
  whole_life: 2,
  annuity: 3,
  health: 4
}

// 子类型筛选只在选中增额寿(2)或年金险(3)时显示
const showSubTypeFilter = computed(() => {
  const pt = searchForm.value.productType
  if (!pt) return false
  const typeNum = typeMap[pt]
  return typeNum === 2 || typeNum === 3
})

async function loadProducts() {
  const pt = searchForm.value.productType
  const typeNum = pt ? typeMap[pt] : undefined
  // 解析 sortBy，判断是否包含排序方向
  let sortBy: string | undefined
  let sortOrder: 'asc' | 'desc' | undefined
  if (searchForm.value.sortBy === 'createdAt') {
    sortBy = 'createdAt'
    sortOrder = 'desc'
  } else if (searchForm.value.sortBy === 'hot') {
    sortBy = 'hot'
    sortOrder = 'desc'
  } else if (searchForm.value.sortBy === 'premium_asc') {
    sortBy = 'premium'
    sortOrder = 'asc'
  } else if (searchForm.value.sortBy === 'premium_desc') {
    sortBy = 'premium'
    sortOrder = 'desc'
  }
  await fetchProducts({
    productType: typeNum,
    subType: showSubTypeFilter.value && searchForm.value.subType !== '' ? searchForm.value.subType : undefined,
    companyId: searchForm.value.companyId,
    paymentPeriod: searchForm.value.paymentPeriod,
    keyword: searchForm.value.keyword || undefined,
    sortBy,
    sortOrder
  })
}

function handleSearch() {
  productStore.currentPage = 1
  loadProducts()
}

function handleProductTypeChange() {
  // 切换产品类型时重置子类型
  searchForm.value.subType = ''
  handleSearch()
}

function handleReset() {
  searchForm.value = {
    productType: '',
    subType: '',
    companyId: undefined,
    paymentPeriod: undefined,
    keyword: '',
    sortBy: 'createdAt'
  }
  productStore.currentPage = 1
  loadProducts()
}

function handlePageChange(page: number, size: number) {
  productStore.currentPage = page
  productStore.pageSize = size
  loadProducts()
}

function handleViewDetail(productId: number) {
  router.push(`/product/${productId}`)
}

function handleToggleCompare(productId: number) {
  const maxFree = 3
  const maxVip = 5
  const maxSvip = 8
  const max = userStore.isVip
    ? (userStore.vipLevel >= 2 ? maxSvip : maxVip)
    : maxFree

  if (!compareStore.isProductSelected(productId) && compareStore.selectedProductIds.length >= max) {
    if (!userStore.isVip) {
      vipDialogVisible.value = true
      return
    }
    ElMessage.warning(`最多对比${max}款产品`)
    return
  }

  const product = productList.value.find((p) => p.productId === productId)
  const result = compareStore.toggleProductSelection(productId, product?.productType ?? 0, max)
  if (!result.success && result.error) {
    ElMessage.warning(result.error)
  }
}

function goToCompare() {
  if (!userStore.isLoggedIn) {
    ElMessage.warning('请先登录')
    router.push(`/login?redirect=${encodeURIComponent('/compare')}`)
    return
  }
  router.push({
    path: '/compare',
    query: { ids: compareStore.selectedProductIds.join(',') }
  })
}

function formatPaymentYears(val: string | string[] | undefined): string {
  if (!val) return '-'
  if (Array.isArray(val)) {
    const formatted = val.slice(0, 3).map((y) => {
      const v = String(y)
      if (/^\d+$/.test(v)) return Number(v) === 1 ? '趸交' : `${v}年`
      return v
    })
    return formatted.join('、') + (val.length > 3 ? '...' : '')
  }
  try {
    const parsed = JSON.parse(val)
    if (Array.isArray(parsed)) {
      const formatted = parsed.slice(0, 3).map((y: string | number) => {
        const v = String(y)
        if (/^\d+$/.test(v)) return Number(v) === 1 ? '趸交' : `${v}年`
        return v
      })
      return formatted.join('、') + (parsed.length > 3 ? '...' : '')
    }
    return String(parsed)
  } catch {
    return val
  }
}
</script>

<style scoped>
.product-list-page {
  padding-bottom: 24px;
}

.search-filter-bar {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;
  padding: 16px 20px;
  background-color: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  margin-bottom: 16px;
  flex-wrap: wrap;
}

.filter-section {
  flex: 1;
  min-width: 0;
}

.filter-form {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  row-gap: 8px;
}

.filter-form :deep(.el-form-item) {
  margin-bottom: 0;
  margin-right: 16px;
}

.action-section {
  display: flex;
  align-items: center;
  gap: 16px;
  flex-shrink: 0;
}

.view-mode-switch {
  display: flex;
  align-items: center;
  gap: 8px;
}

.action-buttons {
  display: flex;
  gap: 8px;
}

.product-grid {
  min-height: 300px;
}

.product-grid .el-col {
  margin-bottom: 20px;
}

.compare-floating-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background: var(--bg-card);
  padding: 12px 24px;
  box-shadow: 0 -2px 12px rgba(0, 0, 0, 0.4), var(--shadow-neon-purple);
  display: flex;
  justify-content: space-between;
  align-items: center;
  z-index: 200;
  border-top: 1px solid var(--border-glow);
  color: var(--text-primary);
}

.compare-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.compare-actions {
  display: flex;
  gap: 8px;
}

.slide-up-enter-active,
.slide-up-leave-active {
  transition: transform 0.3s ease;
}

.slide-up-enter-from,
.slide-up-leave-to {
  transform: translateY(100%);
}
</style>
