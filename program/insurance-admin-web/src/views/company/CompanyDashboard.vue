<template>
  <div class="company-dashboard-page">
    <!-- 核心指标概览 -->
    <el-row :gutter="16" class="stat-row">
      <el-col :xs="12" :sm="6">
        <el-card class="stat-card">
          <div class="stat-value">{{ overviewStats.total }}</div>
          <div class="stat-label">保司总数</div>
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="6">
        <el-card class="stat-card">
          <div class="stat-value">{{ overviewStats.cooperating }}</div>
          <div class="stat-label">合作中</div>
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="6">
        <el-card class="stat-card">
          <div class="stat-value">{{ overviewStats.aaaRating }}</div>
          <div class="stat-label">AAA评级</div>
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="6">
        <el-card class="stat-card">
          <div class="stat-value">{{ overviewStats.highSolvency }}</div>
          <div class="stat-label">偿付充足率&gt;150%</div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 排行榜 -->
    <el-row :gutter="16" class="chart-row">
      <el-col :xs="24" :lg="16">
        <ChartCard title="保险公司排行榜（按保费收入）" :option="rankingOption" :loading="loading" height="400">
          <template #extra>
            <el-radio-group v-model="rankType" size="small" @change="fetchData">
              <el-radio-button label="premium">保费</el-radio-button>
              <el-radio-button label="products">产品数</el-radio-button>
              <el-radio-button label="policies">保单数</el-radio-button>
            </el-radio-group>
          </template>
        </ChartCard>
      </el-col>
      <el-col :xs="24" :lg="8">
        <el-card>
          <template #header>
            <span>TOP5 保险公司</span>
          </template>
          <div v-for="(item, index) in topCompanies" :key="item.companyId" class="rank-item">
            <div class="rank-num" :class="{ top: index < 3 }">{{ index + 1 }}</div>
            <div class="rank-info">
              <div class="rank-name">{{ item.companyName }}</div>
              <div class="rank-value">{{ formatValue(item) }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 分布图 -->
    <el-row :gutter="16" class="chart-row">
      <el-col :xs="24" :lg="12">
        <ChartCard title="偿付能力分布" :option="solvencyOption" :loading="loading" />
      </el-col>
      <el-col :xs="24" :lg="12">
        <ChartCard title="风险评级分布" :option="ratingOption" :loading="loading" />
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import ChartCard from '@/components/common/ChartCard.vue'
import {
  getCompanyStats,
  getSolvencyDistribution,
  getRiskRatingDistribution
} from '@/api/company'
import type { CompanyStats, SolvencyDistribution, RiskRatingDistribution } from '@/api/company'
import type { EChartsOption } from 'echarts'

const loading = ref(false)
const companyStats = ref<CompanyStats[]>([])
const solvencyDist = ref<SolvencyDistribution[]>([])
const ratingDist = ref<RiskRatingDistribution[]>([])
const rankType = ref('premium')

const overviewStats = computed(() => {
  const total = companyStats.value.length
  const cooperating = companyStats.value.filter((c) => c.cooperationStatus === 1).length
  const aaaRating = companyStats.value.filter((c) => c.riskRating === 'AAA').length
  const highSolvency = companyStats.value.filter((c) => c.solvencyRatio > 150).length
  return { total, cooperating, aaaRating, highSolvency }
})

const topCompanies = computed(() => companyStats.value.slice(0, 5))

const rankingOption = computed<EChartsOption>(() => {
  const sorted = [...companyStats.value].sort((a, b) => {
    if (rankType.value === 'premium') return b.totalPremium - a.totalPremium
    if (rankType.value === 'products') return b.totalProducts - a.totalProducts
    return b.totalPolicies - a.totalPolicies
  }).slice(0, 10)

  const names = sorted.map((item) => item.companyName)
  const values = sorted.map((item) => {
    if (rankType.value === 'premium') return item.totalPremium
    if (rankType.value === 'products') return item.totalProducts
    return item.totalPolicies
  })

  return {
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
    xAxis: { type: 'value' },
    yAxis: { type: 'category', data: names.reverse() },
    series: [{
      type: 'bar',
      data: values.reverse(),
      itemStyle: { color: '#409eff', borderRadius: [0, 4, 4, 0] },
      barWidth: '60%'
    }]
  }
})

const solvencyOption = computed<EChartsOption>(() => ({
  tooltip: { trigger: 'item' },
  legend: { bottom: '5%', left: 'center' },
  series: [{
    type: 'pie',
    radius: ['40%', '70%'],
    avoidLabelOverlap: false,
    itemStyle: { borderRadius: 10, borderColor: '#fff', borderWidth: 2 },
    label: { show: false, position: 'center' },
    emphasis: { label: { show: true, fontSize: 20, fontWeight: 'bold' } },
    labelLine: { show: false },
    data: solvencyDist.value.map((item) => ({ name: item.range, value: item.count }))
  }]
}))

const ratingOption = computed<EChartsOption>(() => ({
  tooltip: { trigger: 'item' },
  legend: { bottom: '5%', left: 'center' },
  series: [{
    type: 'pie',
    radius: ['40%', '70%'],
    avoidLabelOverlap: false,
    itemStyle: { borderRadius: 10, borderColor: '#fff', borderWidth: 2 },
    label: { show: false, position: 'center' },
    emphasis: { label: { show: true, fontSize: 20, fontWeight: 'bold' } },
    labelLine: { show: false },
    data: ratingDist.value.map((item) => ({ name: item.rating, value: item.count }))
  }]
}))

function formatValue(item: CompanyStats): string {
  if (rankType.value === 'premium') return `${(item.totalPremium / 10000).toFixed(0)}万`
  if (rankType.value === 'products') return `${item.totalProducts}款`
  return `${item.totalPolicies}单`
}

async function fetchData() {
  loading.value = true
  try {
    const [statsRes, solvencyRes, ratingRes] = await Promise.all([
      getCompanyStats(),
      getSolvencyDistribution(),
      getRiskRatingDistribution()
    ])
    companyStats.value = statsRes
    solvencyDist.value = solvencyRes
    ratingDist.value = ratingRes
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchData()
})
</script>

<style scoped>
.company-dashboard-page {
  padding-bottom: 16px;
}

.stat-row {
  margin-bottom: 16px;
}

.stat-row .el-col {
  margin-bottom: 16px;
}

.stat-card {
  text-align: center;
}

.stat-card :deep(.el-card__body) {
  padding: 20px;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #303133;
  line-height: 1.2;
  margin-bottom: 8px;
}

.stat-label {
  font-size: 14px;
  color: #909399;
}

.chart-row {
  margin-bottom: 16px;
}

.chart-row .el-col {
  margin-bottom: 16px;
}

.rank-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 0;
  border-bottom: 1px solid #ebeef5;
}

.rank-item:last-child {
  border-bottom: none;
}

.rank-num {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background-color: #f0f2f5;
  color: #606266;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: 600;
  flex-shrink: 0;
}

.rank-num.top {
  background-color: #409eff;
  color: #fff;
}

.rank-info {
  flex: 1;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.rank-name {
  font-size: 14px;
  color: #303133;
}

.rank-value {
  font-size: 14px;
  color: #909399;
  font-weight: 500;
}
</style>
