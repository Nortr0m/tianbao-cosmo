<template>
  <div class="compare-page">
    <div class="page-header">
      <h1 class="page-title">产品对比</h1>
      <p class="page-desc">多维度智能对比，帮您找到最适合的保险产品</p>
    </div>

    <el-alert
      v-if="compareStore.selectedProductIds.length > 0"
      :title="`当前对比类型：${compareStore.currentProductTypeLabel} · 只允许同类型产品对比`"
      type="info"
      :closable="false"
      show-icon
      class="compare-type-alert"
    />

    <!-- Empty State -->
    <div v-if="selectedProducts.length === 0" class="empty-state">
      <div class="empty-icon-wrapper">
        <el-icon :size="64"><DataLine /></el-icon>
      </div>
      <h3 class="empty-title">还没有选择对比产品</h3>
      <p class="empty-desc">前往产品列表，选择您感兴趣的保险产品进行对比</p>
      <el-button type="primary" size="large" @click="router.push('/product/list')">
        <el-icon><ShoppingBag /></el-icon>
        去选产品
      </el-button>
    </div>

    <template v-else>
      <!-- Compare Params -->
      <el-card class="params-card tb-card-enhanced">
        <template #header>
          <div class="card-header-title">
            <el-icon><Setting /></el-icon>
            <span>对比参数设置</span>
          </div>
        </template>
        <el-form :model="compareForm" inline class="params-form">
          <el-form-item label="年龄">
            <el-input-number v-model="compareForm.age" :min="0" :max="70" />
          </el-form-item>
          <el-form-item label="性别">
            <el-radio-group v-model="compareForm.gender">
              <el-radio-button value="male">男</el-radio-button>
              <el-radio-button value="female">女</el-radio-button>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="缴费期限">
            <el-select v-model="compareForm.paymentPeriod" placeholder="请选择" style="width: 140px">
              <el-option label="趸交" value="趸交" />
              <el-option label="3年" value="3年" />
              <el-option label="5年" value="5年" />
              <el-option label="10年" value="10年" />
              <el-option label="20年" value="20年" />
              <el-option label="30年" value="30年" />
            </el-select>
          </el-form-item>
          <el-form-item label="保额">
            <el-input-number v-model="compareForm.coverage" :min="10000" :step="10000" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" size="large" :loading="compareStore.isLoading" @click="handleCompare">
              <el-icon><Refresh /></el-icon>
              开始对比
            </el-button>
          </el-form-item>
        </el-form>
      </el-card>

      <!-- Selected Products -->
      <el-card class="selected-card tb-card-enhanced">
        <template #header>
          <div class="selected-header">
            <div class="header-title">
              <el-icon><List /></el-icon>
              <span>已选产品 ({{ selectedProducts.length }}/{{ maxCompareCount }})</span>
            </div>
            <div class="header-actions">
              <el-switch
                v-model="smartHide"
                active-text="隐藏相同项"
                inline-prompt
                @change="handleSmartHideChange"
              />
              <el-button type="primary" text @click="handleExportCard">
                <el-icon><Download /></el-icon>导出对比卡片
              </el-button>
              <el-button type="danger" text @click="compareStore.clearSelection">
                <el-icon><Delete /></el-icon>清空全部
              </el-button>
            </div>
          </div>
        </template>
        <div class="selected-products">
          <div
            v-for="product in selectedProducts"
            :key="product.productId"
            class="product-tag-item"
          >
            <div class="product-tag-info">
              <span class="product-tag-name">{{ product.productName }}</span>
              <span class="product-tag-company">{{ product.companyName }}</span>
            </div>
            <el-button
              type="danger"
              text
              size="small"
              class="remove-tag-btn"
              @click="removeProduct(product.productId, product.productType)"
            >
              <el-icon><Close /></el-icon>
            </el-button>
          </div>
        </div>
      </el-card>

      <!-- Compare Result -->
      <el-card v-if="compareStore.hasResult" v-loading="compareStore.isLoading" class="result-card tb-card-enhanced">
        <template #header>
          <div class="result-header">
            <div class="header-title">
              <el-icon><DataAnalysis /></el-icon>
              <span>对比结果</span>
            </div>
            <el-button type="primary" text @click="handleSaveCompare" :loading="compareStore.isSaving">
              <el-icon><Download /></el-icon>保存对比
            </el-button>
          </div>
        </template>
        <CompareTable
          :compare-items="compareStore.compareItems"
          :dimensions="compareStore.dimensions"
          :winner-id="compareStore.winnerId"
          @remove="handleRemoveProduct"
        />
      </el-card>

      <!-- 对比错误状态 -->
      <el-card v-else-if="compareStore.error" class="error-compare-card">
        <el-empty description="对比失败，请稍后重试">
          <el-button type="primary" @click="handleCompare">重新对比</el-button>
        </el-empty>
      </el-card>

      <!-- Empty compare state -->
      <el-card v-else-if="selectedProducts.length < 2" class="empty-compare-card">
        <div class="empty-compare">
          <el-icon :size="48"><Warning /></el-icon>
          <p>请至少选择2款产品进行对比</p>
          <el-button type="primary" @click="router.push('/product/list')">去选产品</el-button>
        </div>
      </el-card>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Download, DataLine, ShoppingBag, Setting, Refresh, List, DataAnalysis, Delete, Close, Warning } from '@element-plus/icons-vue'
import { useCompareStore } from '@/stores/compareStore'
import { useProductStore } from '@/stores/productStore'
import { useUserStore } from '@/stores/userStore'
import { local } from '@/utils/storage'
import CompareTable from '@/components/business/CompareTable.vue'

const route = useRoute()
const router = useRouter()
const compareStore = useCompareStore()
const productStore = useProductStore()
const userStore = useUserStore()

const SMART_HIDE_KEY = 'compare_smart_hide'

const compareForm = ref({
  age: 30,
  gender: 'male' as 'male' | 'female',
  paymentPeriod: '20年',
  coverage: 500000
})

const smartHide = ref(local.get<boolean>(SMART_HIDE_KEY) ?? true)

const maxCompareCount = computed(() => {
  if (!userStore.isLoggedIn) return 0
  if (!userStore.isVip) return 3
  return 8
})

const selectedProducts = computed(() => {
  return productStore.productList.filter((p) =>
    compareStore.selectedProductIds.includes(p.productId)
  )
})

onMounted(() => {
  const ids = route.query.ids as string
  if (ids) {
    const idList = ids.split(',').map(Number).filter(Boolean)
    compareStore.setSelectedProductIds(idList)
    if (idList.length >= 2) {
      handleCompare()
    }
  }
})

function handleSmartHideChange(val: string | number | boolean) {
  local.set(SMART_HIDE_KEY, Boolean(val))
}

async function handleCompare() {
  if (compareStore.selectedProductIds.length < 2) {
    ElMessage.warning('请至少选择2款产品')
    return
  }
  if (compareStore.selectedProductIds.length > maxCompareCount.value) {
    ElMessage.warning(`最多对比${maxCompareCount.value}款产品`)
    return
  }
  // 根据对比列表中产品的类型动态选择对比接口
  const typeMap: Record<number, string> = { 1: 'critical_illness', 2: 'whole_life', 3: 'annuity' }
  const productType = typeMap[compareStore.selectedProductType] || 'critical_illness'
  try {
    await compareStore.doCompare(productType as any, {
      productIds: compareStore.selectedProductIds,
      ...compareForm.value
    })
  } catch {
    ElMessage.error('对比失败')
  }
}

async function handleSaveCompare() {
  try {
    await compareStore.saveCurrentCompare()
    ElMessage.success('对比已保存')
  } catch {
    ElMessage.error('保存失败')
  }
}

function handleExportCard() {
  ElMessage.info('导出功能开发中')
}

function handleRemoveProduct(productId: number) {
  const product = selectedProducts.value.find(p => p.productId === productId)
  if (product) {
    compareStore.toggleProductSelection(productId, product.productType)
  }
}

function removeProduct(productId: number, productType: number) {
  compareStore.toggleProductSelection(productId, productType)
}
</script>

<style scoped>
.compare-page {
  padding-bottom: 40px;
}

/* 页面头部 */
.page-header {
  margin-bottom: 24px;
}

.page-title {
  font-size: 26px;
  font-weight: 700;
  margin: 0 0 6px;
  color: var(--text-primary);
  display: flex;
  align-items: center;
  gap: 12px;
}

.page-title::before {
  content: '';
  display: inline-block;
  width: 4px;
  height: 24px;
  background: var(--gradient-main);
  border-radius: 2px;
  box-shadow: 0 0 8px rgba(139, 92, 246, 0.5);
}

.page-desc {
  font-size: 14px;
  color: var(--text-secondary);
  margin: 0;
  padding-left: 16px;
}

.compare-type-alert {
  margin-bottom: 20px;
}

/* 空状态 */
.empty-state {
  padding: 80px 20px;
  text-align: center;
  background: var(--bg-card);
  border-radius: var(--radius-xl);
  border: 1px solid var(--border-color);
}

.empty-icon-wrapper {
  width: 100px;
  height: 100px;
  margin: 0 auto 24px;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(99, 102, 241, 0.15), rgba(6, 182, 212, 0.1));
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--accent-purple);
}

.empty-title {
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0 0 8px;
}

.empty-desc {
  font-size: 14px;
  color: var(--text-secondary);
  margin: 0 0 24px;
}

/* 卡片通用 */
.params-card,
.selected-card,
.result-card {
  margin-bottom: 24px;
}

.card-header-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  font-size: 16px;
  color: var(--text-primary);
}

.card-header-title .el-icon {
  color: var(--accent-purple);
}

/* 参数表单 */
.params-form {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  align-items: flex-end;
}

/* 已选产品 */
.selected-header,
.result-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  font-size: 16px;
  color: var(--text-primary);
}

.header-title .el-icon {
  color: var(--accent-purple);
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 16px;
}

.selected-products {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.product-tag-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 14px 10px 16px;
  background: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  transition: all var(--transition-fast);
}

.product-tag-item:hover {
  border-color: var(--accent-purple);
  box-shadow: 0 0 12px rgba(139, 92, 246, 0.2);
}

.product-tag-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.product-tag-name {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
}

.product-tag-company {
  font-size: 12px;
  color: var(--text-muted);
}

.remove-tag-btn {
  flex-shrink: 0;
}

/* 空对比状态 */
.empty-compare-card {
  margin-bottom: 24px;
}

.empty-compare {
  padding: 40px 20px;
  text-align: center;
  color: var(--text-muted);
}

.empty-compare .el-icon {
  margin-bottom: 12px;
  color: var(--text-muted);
}

.empty-compare p {
  margin: 0 0 16px;
  font-size: 14px;
}
</style>
