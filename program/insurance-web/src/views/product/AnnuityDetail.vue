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

      <!-- Payout Plan -->
      <el-card class="section-card">
        <template #header>
          <span>领取计划</span>
        </template>
        <PayoutPlan
          v-model="payoutForm"
          :start-age-options="detail?.startAgeOptions || [55, 60, 65, 70]"
          :guarantee-period-options="detail?.guaranteePeriodOptions || []"
          :increase-options="detail?.increaseOptions || []"
          :summary="payoutSummary"
          @change="handlePayoutChange"
        />
      </el-card>

      <!-- Birthday Bonus -->
      <el-card class="section-card">
        <template #header>
          <span>祝寿金配置</span>
        </template>
        <BirthdayBonus
          v-model="birthdayForm"
          :bonus-type-options="detail?.bonusTypeOptions || []"
          :bonus-age-options="detail?.bonusAgeOptions || []"
          :summary="birthdaySummary"
          @change="handleBirthdayChange"
        />
      </el-card>

      <!-- Dividend Selector -->
      <el-card class="section-card">
        <template #header>
          <span>分红实现率</span>
        </template>
        <DividendSelector v-model="dividendRate" @change="handleDividendChange" />
      </el-card>

      <!-- Benefit Projection -->
      <el-card class="section-card">
        <template #header>
          <div class="tab-header">
            <span>利益演示</span>
            <el-button type="primary" text @click="columnDialogVisible = true">
              <el-icon><Setting /></el-icon>自定义列
            </el-button>
          </div>
        </template>
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
            <el-form-item label="年缴保费">
              <el-input-number v-model="projectionForm.coverage" :min="5000" :step="5000" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" :loading="projecting" @click="handleProjection">
                计算演示
              </el-button>
            </el-form-item>
          </el-form>
        </div>

        <!-- Cash Value Chart -->
        <div v-if="projectionResult" ref="chartRef" class="chart-container" />

        <BenefitTable
          v-if="projectionResult"
          :yearly-data="projectionResult.yearlyData"
          :summary="projectionResult.summary"
        />
        <el-empty v-else description="请先计算利益演示" />
      </el-card>
    </template>

    <!-- Column Selection Dialog -->
    <el-dialog v-model="columnDialogVisible" title="自定义列" width="600px">
      <el-checkbox-group v-model="selectedColumns">
        <el-row :gutter="20">
          <el-col :span="8">
            <h4>基本利益</h4>
            <el-checkbox v-for="col in columnOptions.basic" :key="col.value" :label="col.value">
              {{ col.label }}
            </el-checkbox>
          </el-col>
          <el-col :span="8">
            <h4>保证利益</h4>
            <el-checkbox v-for="col in columnOptions.guaranteed" :key="col.value" :label="col.value">
              {{ col.label }}
            </el-checkbox>
          </el-col>
          <el-col :span="8">
            <h4>红利利益</h4>
            <el-checkbox v-for="col in columnOptions.dividend" :key="col.value" :label="col.value">
              {{ col.label }}
            </el-checkbox>
          </el-col>
        </el-row>
      </el-checkbox-group>
      <template #footer>
        <el-button type="warning" text @click="resetColumns">恢复默认</el-button>
        <el-button @click="columnDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveColumnPreference">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Setting } from '@element-plus/icons-vue'
import { useProduct } from '@/composables/useProduct'
import { useCompareStore } from '@/stores/compareStore'
import { usePermission } from '@/composables/usePermission'
import { getBenefitProjection } from '@/api/calculate'
import type { CalculateResult } from '@/api/calculate'
// import { formatCurrency } from '@/utils/format'
import { local } from '@/utils/storage'
import PayoutPlan from '@/components/business/PayoutPlan.vue'
import BirthdayBonus from '@/components/business/BirthdayBonus.vue'
import DividendSelector from '@/components/business/DividendSelector.vue'
import BenefitTable from '@/components/business/BenefitTable.vue'
import type { PayoutForm, PayoutSummary } from '@/components/business/PayoutPlan.vue'
import type { BirthdayBonusForm, BirthdayBonusSummary } from '@/components/business/BirthdayBonus.vue'
import * as echarts from 'echarts'

const route = useRoute()
const router = useRouter()
const { detail, isLoading, fetchDetail, currentProductTypeLabel, currentProductTypeColor } = useProduct()
const compareStore = useCompareStore()
const { maxCompareCount } = usePermission()

const productId = Number(route.params.id)

const payoutForm = ref<PayoutForm>({
  startAge: 60,
  payoutMethod: 'yearly',
  guaranteePeriod: '20',
  increaseRule: 'none'
})
const payoutSummary = ref<PayoutSummary | undefined>(undefined)

const birthdayForm = ref<BirthdayBonusForm>({
  bonusType: 'fixed',
  bonusAge: 80,
  bonusAmount: 100000
})
const birthdaySummary = ref<BirthdayBonusSummary | undefined>(undefined)

const dividendRate = ref(100)
const columnDialogVisible = ref(false)
const chartRef = ref<HTMLDivElement>()

const projectionForm = ref({
  age: 35,
  gender: 'male' as 'male' | 'female',
  paymentPeriod: '',
  coverage: 100000
})
const projecting = ref(false)
const projectionResult = ref<CalculateResult | null>(null)

const COLUMN_STORAGE_KEY = 'annuity_columns'

const defaultColumns = [
  'year', 'age', 'premium', 'accumulatedPremium', 'cashValue', 'dividend', 'totalValue'
]

const columnOptions = {
  basic: [
    { label: '保单年度', value: 'year' },
    { label: '年龄', value: 'age' },
    { label: '当年保费', value: 'premium' },
    { label: '累计保费', value: 'accumulatedPremium' }
  ],
  guaranteed: [
    { label: '保证年金', value: 'guaranteedAnnuity' },
    { label: '累计领取', value: 'accumulatedPayout' },
    { label: '保证现金价值', value: 'guaranteedCashValue' }
  ],
  dividend: [
    { label: '红利年金', value: 'dividendAnnuity' },
    { label: '当年红利', value: 'dividend' },
    { label: '总现金价值', value: 'totalValue' },
    { label: '总领取', value: 'totalPayout' },
    { label: 'IRR', value: 'irr' }
  ]
}

const selectedColumns = ref<string[]>(local.get<string[]>(COLUMN_STORAGE_KEY) || [...defaultColumns])

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

function handlePayoutChange(val: PayoutForm) {
  const yearlyAmount = Math.round(projectionForm.value.coverage * 0.08)
  const guaranteeYears = parseInt(val.guaranteePeriod) || 20
  payoutSummary.value = {
    yearlyAmount,
    guaranteedTotal: yearlyAmount * guaranteeYears,
    totalTo80: yearlyAmount * (80 - val.startAge)
  }
}

function handleBirthdayChange(val: BirthdayBonusForm) {
  birthdaySummary.value = {
    totalBonus: val.bonusAmount,
    bonusAge: val.bonusAge
  }
}

function handleDividendChange(val: number) {
  dividendRate.value = val
  if (projectionResult.value) {
    handleProjection()
  }
}

async function handleProjection() {
  if (!projectionForm.value.paymentPeriod) {
    ElMessage.warning('请选择缴费期限')
    return
  }
  projecting.value = true
  try {
    const result = await getBenefitProjection('annuity', {
      productId,
      ...projectionForm.value,
      dividendRate: dividendRate.value / 100
    })
    projectionResult.value = result
    nextTick(() => {
      renderChart()
    })
  } catch {
    ElMessage.error('利益演示计算失败，请稍后重试')
  } finally {
    projecting.value = false
  }
}



function renderChart() {
  if (!chartRef.value || !projectionResult.value) return
  const chart = echarts.init(chartRef.value)
  const data = projectionResult.value.yearlyData

  const option = {
    title: { text: '年金领取与现金价值走势', left: 'center' },
    tooltip: { trigger: 'axis' },
    legend: { data: ['现金价值', '累计保费', '年金领取'], bottom: 0 },
    grid: { left: '3%', right: '4%', bottom: '15%', containLabel: true },
    xAxis: { type: 'category', data: data.map((d) => d.year + '年') },
    yAxis: { type: 'value', axisLabel: { formatter: (val: number) => val / 10000 + '万' } },
    series: [
      { name: '现金价值', type: 'line', smooth: true, data: data.map((d) => d.cashValue), itemStyle: { color: '#409eff' } },
      { name: '累计保费', type: 'line', smooth: true, data: data.map((d) => d.accumulatedPremium), itemStyle: { color: '#67c23a' } },
      { name: '年金领取', type: 'bar', data: data.map((d) => d.deathBenefit - d.totalValue > 0 ? d.deathBenefit - d.totalValue : 0), itemStyle: { color: '#e6a23c' } }
    ]
  }

  chart.setOption(option)
}

function saveColumnPreference() {
  local.set(COLUMN_STORAGE_KEY, selectedColumns.value)
  columnDialogVisible.value = false
  ElMessage.success('列偏好已保存')
}

function resetColumns() {
  selectedColumns.value = [...defaultColumns]
  ElMessage.success('已恢复默认列设置')
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

.tab-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
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

.chart-container {
  width: 100%;
  height: 400px;
  margin-bottom: 20px;
}

.detail-breadcrumb {
  margin-top: 12px;
  margin-bottom: 4px;
}
</style>
