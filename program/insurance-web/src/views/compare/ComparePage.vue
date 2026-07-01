<template>
  <div class="compare-page">
    <h1 class="page-title">产品对比</h1>

    <!-- Empty State -->
    <el-empty
      v-if="selectedProducts.length === 0"
      description="请先选择要对比的产品"
    >
      <el-button type="primary" @click="router.push('/product/list')">去选产品</el-button>
    </el-empty>

    <template v-else>
      <!-- Compare Params -->
      <el-card class="params-card">
        <template #header>
          <span>对比参数</span>
        </template>
        <el-form :model="compareForm" inline>
          <el-form-item label="年龄">
            <el-input-number v-model="compareForm.age" :min="0" :max="70" />
          </el-form-item>
          <el-form-item label="性别">
            <el-radio-group v-model="compareForm.gender">
              <el-radio-button label="male">男</el-radio-button>
              <el-radio-button label="female">女</el-radio-button>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="缴费期限">
            <el-select v-model="compareForm.paymentPeriod" placeholder="请选择">
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
            <el-button type="primary" :loading="compareStore.isLoading" @click="handleCompare">
              开始对比
            </el-button>
          </el-form-item>
        </el-form>
      </el-card>

      <!-- Selected Products -->
      <el-card class="selected-card">
        <template #header>
          <div class="selected-header">
            <span>已选产品 ({{ selectedProducts.length }}/{{ maxCompareCount }})</span>
            <div class="header-actions">
              <el-switch
                v-model="smartHide"
                active-text="智能隐藏"
                inline-prompt
                @change="handleSmartHideChange"
              />
              <el-button type="primary" text @click="handleExportCard">
                <el-icon><Download /></el-icon>导出对比卡片
              </el-button>
            </div>
          </div>
        </template>
        <el-space wrap>
          <el-tag
            v-for="product in selectedProducts"
            :key="product.productId"
            closable
            size="large"
            @close="compareStore.toggleProductSelection(product.productId)"
          >
            {{ product.productName }}
          </el-tag>
        </el-space>
      </el-card>

      <!-- Compare Result -->
      <el-card v-if="compareStore.hasResult" v-loading="compareStore.isLoading" class="result-card">
        <template #header>
          <div class="result-header">
            <span>对比结果</span>
            <el-button type="primary" text @click="handleSaveCompare">
              <el-icon><Download /></el-icon>保存对比
            </el-button>
          </div>
        </template>
        <CompareTable
          :compare-items="compareStore.compareItems"
          :dimensions="compareStore.dimensions"
          :winner-id="compareStore.winnerId"
        />
      </el-card>

      <!-- Empty compare state -->
      <el-empty
        v-else-if="selectedProducts.length < 2"
        description="请至少选择2款产品进行对比"
      >
        <el-button type="primary" @click="router.push('/product/list')">去选产品</el-button>
      </el-empty>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Download } from '@element-plus/icons-vue'
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
  try {
    await compareStore.doCompare('critical_illness', {
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
</script>

<style scoped>
.compare-page {
  padding-bottom: 24px;
}

.page-title {
  font-size: 24px;
  font-weight: 600;
  margin-bottom: 20px;
}

.params-card,
.selected-card,
.result-card {
  margin-bottom: 20px;
}

.selected-header,
.result-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 16px;
}
</style>
