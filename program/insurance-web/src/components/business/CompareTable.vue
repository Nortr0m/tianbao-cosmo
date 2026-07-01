<template>
  <div class="compare-table-wrapper">
    <el-table
      :data="tableData"
      :border="true"
      :stripe="true"
      style="width: 100%"
    >
      <el-table-column prop="dimension" label="对比维度" width="160" fixed>
        <template #default="{ row }">
          <span class="dimension-label">{{ row.dimension }}</span>
        </template>
      </el-table-column>
      <el-table-column
        v-for="item in compareItems"
        :key="item.productId"
        :label="item.productName"
        min-width="200"
        align="center"
      >
        <template #header>
          <div class="column-header">
            <span class="product-name">{{ item.productName }}</span>
            <el-tag size="small" type="info">{{ item.companyName }}</el-tag>
          </div>
        </template>
        <template #default="{ row }">
          <div
            class="cell-value"
            :class="{
              'is-winner': row.winnerId === item.productId && row.highlight,
              'is-loser': row.loserId === item.productId && row.highlight
            }"
          >
            <template v-if="row.type === 'score'">
              <el-progress
                :percentage="Number(row.values[item.productId]) || 0"
                :color="getScoreColor(Number(row.values[item.productId]))"
                :stroke-width="16"
                :show-text="true"
              />
            </template>
            <template v-else-if="row.type === 'currency'">
              {{ formatCurrency(row.values[item.productId]) }}
            </template>
            <template v-else-if="row.type === 'percent'">
              {{ formatPercent(row.values[item.productId]) }}
            </template>
            <template v-else>
              {{ row.values[item.productId] ?? '-' }}
            </template>
          </div>
        </template>
      </el-table-column>
    </el-table>

    <div v-if="winnerId" class="compare-winner">
      <el-alert
        :title="`推荐产品：${winnerProductName}`"
        type="success"
        :closable="false"
        show-icon
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { CompareItem } from '@/api/compare'
import { formatCurrency, formatPercent } from '@/utils/format'

interface TableRow {
  dimension: string
  values: Record<number, string | number>
  type: 'text' | 'currency' | 'percent' | 'score'
  winnerId?: number
  loserId?: number
  highlight: boolean
}

interface Props {
  compareItems: CompareItem[]
  dimensions: string[]
  winnerId: number | null
}

const props = defineProps<Props>()

const winnerProductName = computed(() => {
  if (!props.winnerId) return ''
  const item = props.compareItems.find((i) => i.productId === props.winnerId)
  return item?.productName || ''
})

const tableData = computed<TableRow[]>(() => {
  const rows: TableRow[] = []

  // 基础信息行
  rows.push({
    dimension: '保险公司',
    values: Object.fromEntries(props.compareItems.map((i) => [i.productId, i.companyName])),
    type: 'text',
    highlight: false
  })

  rows.push({
    dimension: '产品类型',
    values: Object.fromEntries(props.compareItems.map((i) => [i.productId, i.productType])),
    type: 'text',
    highlight: false
  })

  rows.push({
    dimension: '年缴保费',
    values: Object.fromEntries(props.compareItems.map((i) => [i.productId, i.premium])),
    type: 'currency',
    highlight: false
  })

  rows.push({
    dimension: '保额',
    values: Object.fromEntries(props.compareItems.map((i) => [i.productId, i.coverage])),
    type: 'currency',
    highlight: false
  })

  // 各维度评分
  props.dimensions.forEach((dim) => {
    const values = Object.fromEntries(
      props.compareItems.map((i) => [i.productId, i.scores[dim] || 0])
    )
    const scores = Object.values(values).map(Number)
    const maxScore = Math.max(...scores)
    const minScore = Math.min(...scores)
    const winner = props.compareItems.find((i) => Number(i.scores[dim]) === maxScore)?.productId
    const loser = props.compareItems.find((i) => Number(i.scores[dim]) === minScore)?.productId

    rows.push({
      dimension: dim,
      values,
      type: 'score',
      winnerId: winner,
      loserId: loser,
      highlight: true
    })
  })

  // 总评分
  const totalValues = Object.fromEntries(
    props.compareItems.map((i) => [i.productId, i.totalScore])
  )
  const totalScores = Object.values(totalValues).map(Number)
  const maxTotal = Math.max(...totalScores)
  const minTotal = Math.min(...totalScores)
  const totalWinner = props.compareItems.find((i) => Number(i.totalScore) === maxTotal)?.productId
  const totalLoser = props.compareItems.find((i) => Number(i.totalScore) === minTotal)?.productId

  rows.push({
    dimension: '综合评分',
    values: totalValues,
    type: 'score',
    winnerId: totalWinner,
    loserId: totalLoser,
    highlight: true
  })

  return rows
})

function getScoreColor(score: number): string {
  if (score >= 90) return '#67c23a'
  if (score >= 75) return '#409eff'
  if (score >= 60) return '#e6a23c'
  return '#f56c6c'
}
</script>

<style scoped>
.compare-table-wrapper {
  width: 100%;
  overflow-x: auto;
}

.dimension-label {
  font-weight: 600;
  color: #303133;
}

.column-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.column-header .product-name {
  font-weight: 600;
  font-size: 14px;
  color: #303133;
}

.cell-value {
  padding: 8px;
}

.cell-value.is-winner {
  background-color: #f0f9eb;
  border-radius: 4px;
  font-weight: 600;
  color: #67c23a;
}

.cell-value.is-loser {
  background-color: #fdf6ec;
  border-radius: 4px;
  color: #e6a23c;
}

.compare-winner {
  margin-top: 16px;
}
</style>
