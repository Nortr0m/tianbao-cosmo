<template>
  <div class="template-stats-page">
    <el-row :gutter="16" class="chart-row">
      <el-col :xs="24">
        <ChartCard title="模板使用趋势" :option="usageTrendOption" :loading="loading" height="350" />
      </el-col>
    </el-row>

    <el-row :gutter="16" class="chart-row">
      <el-col :xs="24" :lg="12">
        <ChartCard title="模板使用排行" :option="rankingOption" :loading="loading" />
      </el-col>
      <el-col :xs="24" :lg="12">
        <el-card>
          <template #header>
            <span>热门模板 TOP10</span>
          </template>
          <div v-for="(item, index) in rankingData" :key="item.templateId" class="rank-item">
            <div class="rank-num" :class="{ top: index < 3 }">{{ index + 1 }}</div>
            <div class="rank-info">
              <div class="rank-name">{{ item.templateName }}</div>
              <div class="rank-meta">
                <el-tag size="small">{{ typeMap[item.type] || item.type || '未分类' }}</el-tag>
                <span class="rank-count">{{ item.usageCount.toLocaleString() }} 次使用</span>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import ChartCard from '@/components/common/ChartCard.vue'
import { getTemplateStats, getTemplateRanking } from '@/api/cardTemplate'
import type { TemplateStats, TemplateRanking } from '@/api/cardTemplate'
import type { EChartsOption } from 'echarts'

const typeMap: Record<string, string> = {
  festival: '节日',
  business: '商务',
  minimal: '简约'
}

const loading = ref(false)
const statsData = ref<TemplateStats[]>([])
const rankingData = ref<TemplateRanking[]>([])

const usageTrendOption = computed<EChartsOption>(() => {
  const grouped = new Map<string, number>()
  statsData.value.forEach((item) => {
    const count = grouped.get(item.date) || 0
    grouped.set(item.date, count + item.usageCount)
  })
  const dates = Array.from(grouped.keys()).sort()
  const values = dates.map((d) => grouped.get(d) || 0)

  return {
    tooltip: { trigger: 'axis' },
    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
    xAxis: { type: 'category', data: dates },
    yAxis: { type: 'value' },
    series: [{
      type: 'line',
      smooth: true,
      data: values,
      itemStyle: { color: '#409eff' },
      areaStyle: { color: 'rgba(64, 158, 255, 0.1)' }
    }]
  }
})

const rankingOption = computed<EChartsOption>(() => {
  const top10 = rankingData.value.slice(0, 10)
  const names = top10.map((item) => item.templateName)
  const values = top10.map((item) => item.usageCount)

  return {
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
    xAxis: { type: 'value' },
    yAxis: { type: 'category', data: names.reverse() },
    series: [{
      type: 'bar',
      data: values.reverse(),
      itemStyle: { color: '#67c23a', borderRadius: [0, 4, 4, 0] },
      barWidth: '60%'
    }]
  }
})

async function fetchData() {
  loading.value = true
  try {
    const [statsRes, rankingRes] = await Promise.all([
      getTemplateStats(30),
      getTemplateRanking()
    ])
    statsData.value = statsRes
    rankingData.value = rankingRes
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchData()
})
</script>

<style scoped>
.template-stats-page {
  padding-bottom: 16px;
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
}

.rank-name {
  font-size: 14px;
  color: #303133;
  margin-bottom: 4px;
}

.rank-meta {
  display: flex;
  align-items: center;
  gap: 8px;
}

.rank-count {
  font-size: 12px;
  color: #909399;
}
</style>
