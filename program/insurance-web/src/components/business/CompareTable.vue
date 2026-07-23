<template>
  <div class="compare-table-wrapper">
    <div class="compare-table-container">
      <el-table
        :data="tableData"
        :border="true"
        :stripe="false"
        height="500"
        style="width: 100%"
        class="compare-table"
        :row-class-name="getRowClassName"
      >
        <el-table-column prop="dimension" label="对比维度" width="160" fixed>
          <template #default="{ row }">
            <span class="dimension-label" :class="{ 'dim-label': isSameRow(row) }">
              {{ row.dimension }}
            </span>
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
              <el-tag size="small" type="info" effect="plain">{{ item.companyName }}</el-tag>
              <el-button
                class="remove-btn"
                type="danger"
                text
                size="small"
                @click.stop="$emit('remove', item.productId)"
              >
                <el-icon><Close /></el-icon>
              </el-button>
            </div>
          </template>
          <template #default="{ row }">
            <div
              class="cell-value"
              :class="{
                'is-winner': row.winnerId === item.productId && row.highlight,
                'is-loser': row.loserId === item.productId && row.highlight,
                'is-same': isSameRow(row)
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
    </div>

    <div v-if="winnerId" class="compare-winner">
      <div class="winner-card">
        <div class="winner-icon">
          <el-icon :size="28"><Trophy /></el-icon>
        </div>
        <div class="winner-info">
          <span class="winner-label">综合推荐</span>
          <span class="winner-name">{{ winnerProductName }}</span>
        </div>
        <el-tag type="success" effect="dark" size="large">
          <el-icon><Star /></el-icon>
          最优选择
        </el-tag>
      </div>
    </div>

    <!-- 图例说明 -->
    <div class="compare-legend">
      <div class="legend-item">
        <span class="legend-dot winner-dot"></span>
        <span>最优项</span>
      </div>
      <div class="legend-item">
        <span class="legend-dot loser-dot"></span>
        <span>待优化项</span>
      </div>
      <div class="legend-item">
        <span class="legend-dot same-dot"></span>
        <span>相同项</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { Trophy, Star, Close } from '@element-plus/icons-vue'
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

defineEmits<{
  remove: [productId: number]
}>()

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
  if (score >= 90) return '#10b981'
  if (score >= 75) return '#06b6d4'
  if (score >= 60) return '#f59e0b'
  return '#ef4444'
}

// 判断行内所有值是否相同
function isSameRow(row: any): boolean {
  const values = Object.values(row.values || {})
  if (values.length <= 1) return true
  const firstVal = String(values[0])
  return values.every(v => String(v) === firstVal)
}

// 行类名
function getRowClassName({ row }: { row: any }): string {
  if (isSameRow(row as TableRow)) {
    return 'same-row'
  }
  return ''
}
</script>

<style scoped>
.compare-table-wrapper {
  width: 100%;
}

.compare-table-container {
  border-radius: var(--radius-lg);
  overflow: hidden;
  border: 1px solid var(--border-color);
}

.compare-table {
  --el-table-header-bg-color: var(--bg-secondary) !important;
  --el-table-tr-bg-color: var(--bg-card) !important;
  --el-table-row-hover-bg-color: var(--bg-card-hover) !important;
  --el-table-border-color: var(--border-color) !important;
  --el-table-text-color: var(--text-primary) !important;
  --el-table-header-text-color: var(--text-secondary) !important;
}

/* 表头样式 */
.compare-table :deep(.el-table__header-wrapper) {
  background: var(--bg-secondary);
}

.compare-table :deep(.el-table__header th) {
  background: var(--bg-secondary) !important;
  color: var(--text-secondary) !important;
  font-weight: 600;
  border-bottom: 2px solid var(--border-color) !important;
}

.dimension-label {
  font-weight: 600;
  color: var(--text-primary);
  font-size: 14px;
}

.dimension-label.dim-label {
  color: var(--text-muted);
  font-weight: 500;
}

.column-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  padding: 4px 0;
  position: relative;
}

.column-header .product-name {
  font-weight: 600;
  font-size: 14px;
  color: var(--text-primary);
}

.remove-btn {
  position: absolute;
  top: 4px;
  right: 4px;
  opacity: 0;
  transition: opacity 0.2s;
  padding: 4px !important;
}

.column-header:hover .remove-btn {
  opacity: 1;
}

.cell-value {
  padding: 8px;
  transition: all 0.2s;
}

.cell-value.is-winner {
  background: rgba(16, 185, 129, 0.12);
  border-radius: 6px;
  font-weight: 600;
  color: var(--accent-green);
}

.cell-value.is-loser {
  background: rgba(239, 68, 68, 0.08);
  border-radius: 6px;
  color: var(--accent-red);
}

.cell-value.is-same {
  opacity: 0.6;
}

/* 相同行弱化 */
:deep(.el-table .same-row td) {
  background: rgba(100, 116, 139, 0.05) !important;
}

:deep(.el-table .same-row:hover td) {
  background: rgba(100, 116, 139, 0.08) !important;
}

/* 推荐产品卡片 */
.compare-winner {
  margin-top: 20px;
}

.winner-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px 24px;
  background: linear-gradient(135deg, rgba(16, 185, 129, 0.12) 0%, rgba(6, 182, 212, 0.08) 100%);
  border: 1px solid rgba(16, 185, 129, 0.3);
  border-radius: var(--radius-lg);
  position: relative;
  overflow: hidden;
}

.winner-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, transparent, var(--accent-green), var(--accent-cyan), transparent);
}

.winner-icon {
  width: 56px;
  height: 56px;
  border-radius: 14px;
  background: linear-gradient(135deg, #10b981, #06b6d4);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  box-shadow: 0 0 20px rgba(16, 185, 129, 0.4);
  flex-shrink: 0;
}

.winner-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.winner-label {
  font-size: 13px;
  color: var(--text-muted);
}

.winner-name {
  font-size: 18px;
  font-weight: 700;
  color: var(--text-primary);
}

/* 图例说明 */
.compare-legend {
  display: flex;
  justify-content: center;
  gap: 24px;
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid var(--border-color);
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: var(--text-secondary);
}

.legend-dot {
  width: 12px;
  height: 12px;
  border-radius: 3px;
}

.winner-dot {
  background: rgba(16, 185, 129, 0.3);
  border: 1px solid var(--accent-green);
}

.loser-dot {
  background: rgba(239, 68, 68, 0.2);
  border: 1px solid var(--accent-red);
}

.same-dot {
  background: rgba(100, 116, 139, 0.2);
  border: 1px solid var(--text-muted);
}
</style>
