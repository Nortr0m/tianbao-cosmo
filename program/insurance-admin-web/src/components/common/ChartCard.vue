<template>
  <el-card class="chart-card" shadow="hover">
    <template #header v-if="title">
      <div class="chart-header">
        <span class="chart-title">{{ title }}</span>
        <div class="chart-extra">
          <slot name="extra" />
        </div>
      </div>
    </template>
    <div ref="chartRef" class="chart-container" :style="{ height: height + 'px' }"></div>
  </el-card>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, watch, nextTick } from 'vue'
import * as echarts from 'echarts'
import type { ECharts, EChartsOption } from 'echarts'

interface Props {
  title?: string
  option: EChartsOption
  height?: number
  loading?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  height: 300,
  loading: false
})

const chartRef = ref<HTMLDivElement>()
let chartInstance: ECharts | null = null

function initChart() {
  if (!chartRef.value) return
  chartInstance = echarts.init(chartRef.value)
  chartInstance.setOption(props.option)
  if (props.loading) {
    chartInstance.showLoading()
  }
}

function updateChart() {
  if (chartInstance) {
    chartInstance.setOption(props.option, true)
  }
}

function handleResize() {
  chartInstance?.resize()
}

watch(() => props.option, updateChart, { deep: true })

watch(() => props.loading, (val) => {
  if (!chartInstance) return
  if (val) {
    chartInstance.showLoading()
  } else {
    chartInstance.hideLoading()
  }
})

onMounted(() => {
  nextTick(() => {
    initChart()
    window.addEventListener('resize', handleResize)
  })
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  chartInstance?.dispose()
  chartInstance = null
})
</script>

<style scoped>
.chart-card {
  border-radius: 8px;
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.chart-title {
  font-size: 16px;
  font-weight: 500;
  color: #303133;
}

.chart-extra {
  display: flex;
  align-items: center;
  gap: 8px;
}

.chart-container {
  width: 100%;
}
</style>
