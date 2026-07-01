<template>
  <div class="dashboard-page">
    <!-- 核心指标卡片 -->
    <el-row :gutter="16" class="stat-row">
      <el-col :xs="24" :sm="12" :md="8" :lg="4">
        <StatCard
          title="产品总数"
          :value="stats.totalProductCount"
          icon="Goods"
          icon-bg-color="#ecf5ff"
          icon-color="#409eff"
          to="/product/critical"
        />
      </el-col>
      <el-col :xs="24" :sm="12" :md="8" :lg="4">
        <StatCard
          title="保险公司"
          :value="stats.totalCompanyCount"
          icon="OfficeBuilding"
          icon-bg-color="#f0f9eb"
          icon-color="#67c23a"
          to="/company"
        />
      </el-col>
      <el-col :xs="24" :sm="12" :md="8" :lg="4">
        <StatCard
          title="用户总数"
          :value="stats.totalUserCount"
          icon="User"
          icon-bg-color="#fdf6ec"
          icon-color="#e6a23c"
          to="/vip/management"
        />
      </el-col>
      <el-col :xs="24" :sm="12" :md="8" :lg="4">
        <StatCard
          title="VIP会员"
          :value="stats.vipUserCount"
          icon="UserFilled"
          icon-bg-color="#f0f9eb"
          icon-color="#67c23a"
          to="/vip/management"
        />
      </el-col>
      <el-col :xs="24" :sm="12" :md="8" :lg="4">
        <StatCard
          title="卡片模板"
          :value="stats.totalCardTemplateCount"
          icon="Picture"
          icon-bg-color="#f2f6fc"
          icon-color="#909399"
          to="/card-template"
        />
      </el-col>
      <el-col :xs="24" :sm="12" :md="8" :lg="4">
        <StatCard
          title="VIP订单金额"
          :value="stats.totalVipOrderAmount"
          icon="PictureFilled"
          icon-bg-color="#ecf5ff"
          icon-color="#409eff"
          to="/vip/management"
        />
      </el-col>
    </el-row>

    <!-- 图表区域 -->
    <el-row :gutter="16" class="chart-row">
      <el-col :xs="24" :lg="12">
        <ChartCard title="产品类型分布" :option="productPieOption" :loading="chartLoading" />
      </el-col>
      <el-col :xs="24" :lg="12">
        <ChartCard title="用户增长趋势" :option="userTrendOption" :loading="chartLoading" />
      </el-col>
    </el-row>

    <el-row :gutter="16" class="chart-row">
      <el-col :xs="24">
        <ChartCard title="卡片生成统计" :option="cardGenerationOption" :loading="chartLoading" :height="320" />
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import StatCard from '@/components/common/StatCard.vue'
import ChartCard from '@/components/common/ChartCard.vue'
import {
  getDashboardStats,
  getProductDistribution,
  getUserTrend,
  getCardGenerationStats
} from '@/api/dashboard'
import type { DashboardStats, ProductDistribution, UserTrend, CardGenerationStats } from '@/api/dashboard'
import type { EChartsOption } from 'echarts'

const stats = ref<DashboardStats>({
  totalProductCount: 0,
  totalCompanyCount: 0,
  totalUserCount: 0,
  vipUserCount: 0,
  totalCardTemplateCount: 0,
  totalVipOrderAmount: 0,
  todayNewUserCount: 0,
  onSaleProductCount: 0,
  cooperationCompanyCount: 0,
  totalCardUseCount: 0,
  totalVipOrderCount: 0
})

const productDistribution = ref<ProductDistribution[]>([])
const userTrend = ref<UserTrend[]>([])
const cardGeneration = ref<CardGenerationStats[]>([])
const chartLoading = ref(false)

const productPieOption = computed<EChartsOption>(() => ({
  tooltip: { trigger: 'item' },
  legend: { bottom: '5%', left: 'center' },
  series: [
    {
      name: '产品类型',
      type: 'pie',
      radius: ['40%', '70%'],
      avoidLabelOverlap: false,
      itemStyle: { borderRadius: 10, borderColor: '#fff', borderWidth: 2 },
      label: { show: false, position: 'center' },
      emphasis: {
        label: { show: true, fontSize: 20, fontWeight: 'bold' }
      },
      labelLine: { show: false },
      data: productDistribution.value
    }
  ]
}))

const userTrendOption = computed<EChartsOption>(() => {
  const dates = userTrend.value.map((item) => item.date)
  const newUsers = userTrend.value.map((item) => item.newUsers)
  const activeUsers = userTrend.value.map((item) => item.activeUsers)
  const vipUsers = userTrend.value.map((item) => item.vipUsers)

  return {
    tooltip: { trigger: 'axis' },
    legend: { data: ['新增用户', '活跃用户', 'VIP用户'], bottom: '5%' },
    grid: { left: '3%', right: '4%', bottom: '15%', containLabel: true },
    xAxis: { type: 'category', boundaryGap: false, data: dates },
    yAxis: { type: 'value' },
    series: [
      { name: '新增用户', type: 'line', smooth: true, data: newUsers, itemStyle: { color: '#409eff' } },
      { name: '活跃用户', type: 'line', smooth: true, data: activeUsers, itemStyle: { color: '#67c23a' } },
      { name: 'VIP用户', type: 'line', smooth: true, data: vipUsers, itemStyle: { color: '#e6a23c' } }
    ]
  }
})

const cardGenerationOption = computed<EChartsOption>(() => {
  const dates = cardGeneration.value.map((item) => item.date)
  const counts = cardGeneration.value.map((item) => item.count)

  return {
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
    xAxis: { type: 'category', data: dates, axisTick: { alignWithLabel: true } },
    yAxis: { type: 'value' },
    series: [
      {
        name: '生成数量',
        type: 'bar',
        barWidth: '60%',
        data: counts,
        itemStyle: { color: '#409eff', borderRadius: [4, 4, 0, 0] }
      }
    ]
  }
})

async function fetchData() {
  chartLoading.value = true
  try {
    const statsRes = await getDashboardStats()
    stats.value = statsRes

    // 以下接口后端尚未实现，使用try/catch避免阻塞页面
    try {
      productDistribution.value = await getProductDistribution()
    } catch {
      productDistribution.value = [
        { name: '重疾险', value: 0 },
        { name: '增额终身寿险', value: 0 },
        { name: '年金险', value: 0 }
      ]
    }

    try {
      userTrend.value = await getUserTrend(30)
    } catch {
      userTrend.value = []
    }

    try {
      cardGeneration.value = await getCardGenerationStats(30)
    } catch {
      cardGeneration.value = []
    }
  } finally {
    chartLoading.value = false
  }
}

onMounted(() => {
  fetchData()
})
</script>

<style scoped>
.dashboard-page {
  padding-bottom: 16px;
}

.stat-row {
  margin-bottom: 16px;
}

.stat-row .el-col {
  margin-bottom: 16px;
}

.chart-row {
  margin-bottom: 16px;
}

.chart-row .el-col {
  margin-bottom: 16px;
}
</style>
