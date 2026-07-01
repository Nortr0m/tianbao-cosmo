<template>
  <div class="product-list-page">
    <!-- Search & Filter -->
    <BaseSearch
      :model="searchForm"
      @search="handleSearch"
      @reset="handleReset"
    >
      <el-form-item label="产品类型">
        <el-radio-group v-model="searchForm.productType" @change="handleSearch">
          <el-radio-button label="">全部</el-radio-button>
          <el-radio-button
            v-for="type in productTypes"
            :key="type.value"
            :label="type.value"
          >
            {{ type.label }}
          </el-radio-button>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="保险公司">
        <el-select v-model="searchForm.companyId" placeholder="全部公司" clearable @change="handleSearch">
          <el-option
            v-for="company in companies"
            :key="company.companyId"
            :label="company.companyName"
            :value="company.companyId"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="缴费年限">
        <el-select v-model="searchForm.paymentPeriod" placeholder="全部" clearable @change="handleSearch">
          <el-option label="趸交" value="趸交" />
          <el-option label="3年" value="3年" />
          <el-option label="5年" value="5年" />
          <el-option label="10年" value="10年" />
          <el-option label="15年" value="15年" />
          <el-option label="20年" value="20年" />
          <el-option label="30年" value="30年" />
        </el-select>
      </el-form-item>
      <el-form-item label="关键词">
        <el-input v-model="searchForm.keyword" placeholder="产品名称" clearable @keyup.enter="handleSearch" />
      </el-form-item>
      <template #extra-actions>
        <el-button
          v-if="compareStore.selectedProductIds.length > 0"
          type="success"
          @click="goToCompare"
        >
          对比({{ compareStore.selectedProductIds.length }})
        </el-button>
      </template>
    </BaseSearch>

    <!-- Product Grid -->
    <div v-loading="isLoading" class="product-grid">
      <el-empty v-if="productList.length === 0 && !isLoading" description="暂无产品" />
      <el-row v-else :gutter="20">
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
import { ref, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useProduct } from '@/composables/useProduct'
import { useProductStore } from '@/stores/productStore'
import { useCompareStore } from '@/stores/compareStore'
import { useUserStore } from '@/stores/userStore'
import { getAllCompanies } from '@/api/company'
import type { Company } from '@/api/company'
import type { ProductType } from '@/api/product'
import BaseSearch from '@/components/common/BaseSearch.vue'
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

const companies = ref<Company[]>([])
const vipDialogVisible = ref(false)

const searchForm = ref<{
  productType: ProductType | ''
  companyId: number | undefined
  paymentPeriod: string
  keyword: string
}>({
  productType: (route.query.type as ProductType) || '',
  companyId: undefined,
  paymentPeriod: '',
  keyword: (route.query.keyword as string) || ''
})

onMounted(() => {
  fetchProductTypes()
  loadCompanies()
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

async function loadCompanies() {
  try {
    const res = await getAllCompanies()
    companies.value = res
  } catch {
    companies.value = []
  }
}

const typeMap: Record<string, number> = {
  critical_illness: 1,
  whole_life: 2,
  annuity: 3
}

async function loadProducts() {
  const pt = searchForm.value.productType
  await fetchProducts({
    productType: pt ? typeMap[pt] : undefined,
    companyId: searchForm.value.companyId,
    paymentPeriod: searchForm.value.paymentPeriod || undefined,
    keyword: searchForm.value.keyword || undefined
  })
}

function handleSearch() {
  productStore.currentPage = 1
  loadProducts()
}

function handleReset() {
  searchForm.value = {
    productType: '',
    companyId: undefined,
    paymentPeriod: '',
    keyword: ''
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

  const success = compareStore.toggleProductSelection(productId, max)
  if (!success) {
    ElMessage.warning('操作失败')
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
</script>

<style scoped>
.product-list-page {
  padding-bottom: 24px;
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
