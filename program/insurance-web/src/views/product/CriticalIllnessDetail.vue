<template>
  <div class="product-detail-page">
    <el-page-header @back="router.back()">
      <template #content>
        <span class="detail-title">{{ detail?.productName }}</span>
        <el-tag :color="currentProductTypeColor" effect="dark" size="small" class="type-tag">
          {{ currentProductTypeLabel }}
        </el-tag>
        <el-tag :type="detail?.saleStatus === 1 ? 'success' : 'info'" size="small" class="status-tag">
          {{ detail?.saleStatus === 1 ? '在售' : '停售' }}
        </el-tag>
      </template>
    </el-page-header>

    <el-breadcrumb class="detail-breadcrumb">
      <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item :to="{ path: '/products' }">产品列表</el-breadcrumb-item>
      <el-breadcrumb-item>产品详情</el-breadcrumb-item>
    </el-breadcrumb>

    <el-skeleton v-if="isLoading" :rows="10" animated />

    <template v-else-if="detail">
      <!-- Product Info Card -->
      <el-card class="info-card">
        <div class="product-header">
          <div class="company-info">
            <img v-if="detail.companyLogo" :src="detail.companyLogo" class="company-logo-large" />
            <div>
              <h2>{{ detail.productName }}</h2>
              <p>{{ detail.companyName }}</p>
            </div>
          </div>
          <div class="product-actions">
            <el-button
              :type="compareStore.isProductSelected(detail.productId) ? 'success' : 'default'"
              @click="handleToggleCompare"
            >
              {{ compareStore.isProductSelected(detail.productId) ? '已加入对比' : '加入对比' }}
            </el-button>
            <el-button type="primary" @click="goToCardGenerate">
              生成展业卡片
            </el-button>
          </div>
        </div>

        <el-descriptions :column="3" border>
          <el-descriptions-item label="产品类型">{{ detail.productTypeDesc || detail.productType }}</el-descriptions-item>
          <el-descriptions-item label="投保年龄">{{ detail.minAge }} - {{ detail.maxAge }} 岁</el-descriptions-item>
          <el-descriptions-item label="职业类别">{{ detail.occupationClass }}</el-descriptions-item>
          <el-descriptions-item label="缴费期限">{{ parsedPaymentPeriods.join('、') }}</el-descriptions-item>
          <el-descriptions-item label="缴费年期">{{ parsedPaymentYears.join('、') }}</el-descriptions-item>
          <el-descriptions-item label="月缴比例">{{ detail.monthlyRatio }}</el-descriptions-item>
          <el-descriptions-item label="季缴比例">{{ detail.quarterlyRatio }}</el-descriptions-item>
          <el-descriptions-item label="半年缴比例">{{ detail.halfYearlyRatio }}</el-descriptions-item>
        </el-descriptions>
      </el-card>

      <!-- Responsibility Config -->
      <el-card class="section-card">
        <template #header>
          <span>方案配置</span>
        </template>
        <ResponsibilityConfig
          v-if="detail?.responsibilities?.length"
          v-model="responsibilityConfig"
          :items="detail.responsibilities"
          @change="handleResponsibilityChange"
        />
        <el-empty v-else description="暂无责任配置数据" />
      </el-card>

      <!-- Premium Calculator -->
      <el-card class="section-card">
        <template #header>
          <span>保费计算器</span>
        </template>
        <PremiumCalculator
          ref="premiumCalcRef"
          :payment-periods="parsedPaymentPeriods"
          :default-coverage="500000"
          @calculate="handleCalculatePremium"
        />
      </el-card>

      <!-- Tabs -->
      <el-card class="section-card">
        <el-tabs v-model="activeTab">
          <el-tab-pane label="保障责任" name="benefits">
            <el-table v-if="detail?.benefits?.length" :data="detail.benefits" border>
              <el-table-column prop="name" label="保障项目" width="200" />
              <el-table-column prop="description" label="说明" />
              <el-table-column prop="value" label="保额/赔付" width="200" align="right">
                <template #default="{ row }">
                  <span class="highlight">{{ row.value }}</span>
                </template>
              </el-table-column>
            </el-table>
            <el-empty v-else description="暂无保障责任数据" />
          </el-tab-pane>

          <el-tab-pane label="疾病清单" name="diseases">
            <DiseaseList v-if="detail?.diseases?.length" :diseases="detail.diseases" />
            <el-empty v-else description="暂无疾病清单数据" />
          </el-tab-pane>

          <el-tab-pane label="利益演示" name="projection">
            <div class="projection-form">
              <el-form :model="projectionForm" inline>
                <el-form-item label="年龄">
                  <el-input-number v-model="projectionForm.age" :min="0" :max="70" />
                </el-form-item>
                <el-form-item label="性别">
                  <el-radio-group v-model="projectionForm.gender">
                    <el-radio-button label="male">男</el-radio-button>
                    <el-radio-button label="female">女</el-radio-button>
                  </el-radio-group>
                </el-form-item>
                <el-form-item label="缴费期限">
                  <el-select v-model="projectionForm.paymentPeriod">
                    <el-option
                      v-for="p in parsedPaymentPeriods"
                      :key="p"
                      :label="p"
                      :value="p"
                    />
                  </el-select>
                </el-form-item>
                <el-form-item label="保额">
                  <el-input-number v-model="projectionForm.coverage" :min="10000" :step="10000" />
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" :loading="projecting" @click="handleProjection">
                    计算演示
                  </el-button>
                </el-form-item>
              </el-form>
            </div>
            <BenefitTable
              v-if="projectionResult"
              :yearly-data="projectionResult.yearlyData"
              :summary="projectionResult.summary"
            />
            <el-empty v-else description="请先计算利益演示" />
          </el-tab-pane>

          <el-tab-pane label="保险公司" name="company">
            <el-descriptions :column="2" border>
              <el-descriptions-item label="公司名称">{{ detail.companyName }}</el-descriptions-item>
              <el-descriptions-item label="成立时间">{{ detail.company?.foundedYear || '-' }}年</el-descriptions-item>
              <el-descriptions-item label="注册资本">{{ detail.company?.registeredCapital ? formatCurrency(detail.company.registeredCapital, 0) : '-' }}</el-descriptions-item>
              <el-descriptions-item label="客服热线">{{ detail.company?.hotline || '-' }}</el-descriptions-item>
              <el-descriptions-item label="官网" :span="2">
                <el-link v-if="detail.company?.website" :href="detail.company.website" target="_blank" type="primary">
                  {{ detail.company.website }}
                </el-link>
                <span v-else>-</span>
              </el-descriptions-item>
              <el-descriptions-item label="公司简介" :span="2">
                {{ detail.company?.description || '暂无简介' }}
              </el-descriptions-item>
            </el-descriptions>
          </el-tab-pane>
        </el-tabs>
      </el-card>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useProduct } from '@/composables/useProduct'
import { useCompareStore } from '@/stores/compareStore'
import { usePermission } from '@/composables/usePermission'
import { calculatePremium, getBenefitProjection } from '@/api/calculate'
import type { CalculateResult } from '@/api/calculate'
import { formatCurrency } from '@/utils/format'
import ResponsibilityConfig from '@/components/business/ResponsibilityConfig.vue'
import PremiumCalculator from '@/components/business/PremiumCalculator.vue'
import DiseaseList from '@/components/business/DiseaseList.vue'
import BenefitTable from '@/components/business/BenefitTable.vue'
// import type { ResponsibilityItem } from '@/components/business/ResponsibilityConfig.vue'
// import type { DiseaseItem } from '@/components/business/DiseaseList.vue'

const route = useRoute()
const router = useRouter()
const { detail, isLoading, fetchDetail, currentProductTypeLabel, currentProductTypeColor } = useProduct()
const compareStore = useCompareStore()
const { maxCompareCount } = usePermission()

const productId = Number(route.params.id)

const activeTab = ref('benefits')
const responsibilityConfig = ref<Record<string, unknown>>({})
const premiumCalcRef = ref<InstanceType<typeof PremiumCalculator>>()

const projectionForm = ref({
  age: 30,
  gender: 'male' as 'male' | 'female',
  paymentPeriod: '',
  coverage: 500000
})
const projecting = ref(false)
const projectionResult = ref<CalculateResult | null>(null)

const parsedPaymentPeriods = computed(() => safeParseJSON<string[]>(detail.value?.paymentPeriods, []))
const parsedPaymentYears = computed(() => safeParseJSON<string[]>(detail.value?.paymentYears, []))



onMounted(async () => {
  await fetchDetail(productId)
  if (parsedPaymentPeriods.value.length) {
    projectionForm.value.paymentPeriod = parsedPaymentPeriods.value[0]
  }
})

function safeParseJSON<T>(str: string | undefined, defaultVal: T): T {
  if (!str) return defaultVal
  try { return JSON.parse(str) } catch { return defaultVal }
}

function handleToggleCompare() {
  const success = compareStore.toggleProductSelection(productId, maxCompareCount.value)
  if (!success) {
    ElMessage.warning(`最多对比${maxCompareCount.value}款产品`)
  }
}

function goToCardGenerate() {
  router.push(`/card/generate?productId=${productId}`)
}

function handleResponsibilityChange(code: string, value: unknown) {
  console.log('Responsibility changed:', code, value)
  // Trigger premium recalculation
  if (premiumCalcRef.value) {
    premiumCalcRef.value.setLoading(false)
  }
}

async function handleCalculatePremium(form: { age: number; gender: 'male' | 'female'; coverage: number; paymentPeriod: string; paymentFrequency: string }) {
  try {
    const result = await calculatePremium({
      productId,
      ...form
    })
    premiumCalcRef.value?.setResult({
      premium: result.premium,
      totalPremium: result.summary.totalPremium
    })
  } catch {
    ElMessage.error('保费计算失败，请稍后重试')
  }
}

async function handleProjection() {
  if (!projectionForm.value.paymentPeriod) {
    ElMessage.warning('请选择缴费期限')
    return
  }
  projecting.value = true
  try {
    const result = await getBenefitProjection('critical_illness', {
      productId,
      ...projectionForm.value
    })
    projectionResult.value = result
  } catch {
    ElMessage.error('利益演示计算失败，请稍后重试')
  } finally {
    projecting.value = false
  }
}


</script>

<style scoped>
.product-detail-page {
  padding-bottom: 24px;
}

.detail-title {
  font-size: 18px;
  font-weight: 600;
  margin-right: 12px;
}

.type-tag,
.status-tag {
  vertical-align: middle;
  margin-right: 8px;
}

.info-card {
  margin-top: 20px;
}

.product-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  flex-wrap: wrap;
  gap: 12px;
}

.company-info {
  display: flex;
  align-items: center;
  gap: 16px;
}

.company-logo-large {
  width: 60px;
  height: 60px;
  object-fit: contain;
  border-radius: var(--radius-md);
  border: 1px solid var(--border-color);
  background: var(--bg-card);
  padding: 4px;
}

.company-info h2 {
  font-size: 20px;
  font-weight: 600;
  margin-bottom: 4px;
  color: var(--text-primary);
}

.company-info p {
  color: var(--text-secondary);
}

.product-actions {
  display: flex;
  gap: 12px;
}

.section-card {
  margin-top: 20px;
}

.highlight {
  color: var(--accent-orange);
  font-weight: 600;
}

.projection-form {
  margin-bottom: 20px;
  padding: 16px;
  background: var(--bg-secondary);
  border-radius: var(--radius-md);
}

.detail-breadcrumb {
  margin-top: 12px;
  margin-bottom: 4px;
}
</style>
