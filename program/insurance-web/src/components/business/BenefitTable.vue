<template>
  <div class="benefit-table-wrapper">
    <el-table
      :data="yearlyData"
      :border="true"
      :stripe="true"
      height="500"
      style="width: 100%"
    >
      <template v-for="col in activeColumns" :key="col.value">
        <el-table-column
          :prop="col.value"
          :label="col.label"
          :width="col.width"
          :min-width="col.minWidth"
          :align="col.align || 'right'"
          :fixed="col.fixed"
          :class-name="col.className"
        >
          <template #default="{ row }">
            <template v-if="col.value === 'year' || col.value === 'age'">
              <span class="center-cell">{{ row[col.value] }}</span>
            </template>
            <template v-else-if="col.value === 'irr'">
              <span :class="{ 'positive-value': (row[col.value] || 0) > 0 }">
                {{ formatPercent(row[col.value], 4) }}
              </span>
            </template>
            <template v-else-if="col.format === 'currency'">
              <span :class="col.valueClass ? col.valueClass(row as YearlyDataItem) : ''">
                {{ formatCurrency(row[col.value]) }}
              </span>
            </template>
            <template v-else>
              {{ row[col.value] != null ? row[col.value] : '-' }}
            </template>
          </template>
        </el-table-column>
      </template>
    </el-table>

    <div class="benefit-summary">
      <el-descriptions :column="summaryColumnCount" border>
        <el-descriptions-item label="总缴保费">
          {{ formatCurrency(summary.totalPremium) }}
        </el-descriptions-item>
        <el-descriptions-item label="总回报">
          <span class="highlight-value">{{ formatCurrency(summary.totalReturn) }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="IRR">
          <span class="positive-value">{{ formatPercent(summary.irr, 4) }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="回本年限">
          {{ summary.breakEvenYear > 0 ? summary.breakEvenYear + '年' : '-' }}
        </el-descriptions-item>
        <el-descriptions-item v-if="summary.guaranteedIrr != null" label="保证IRR">
          {{ formatPercent(summary.guaranteedIrr, 4) }}
        </el-descriptions-item>
        <el-descriptions-item v-if="summary.dividendIrr != null" label="含分红IRR">
          <span class="positive-value">{{ formatPercent(summary.dividendIrr, 4) }}</span>
        </el-descriptions-item>
        <el-descriptions-item v-if="summary.totalValueWithDividend != null" label="含分红总价值">
          <span class="highlight-value">{{ formatCurrency(summary.totalValueWithDividend) }}</span>
        </el-descriptions-item>
      </el-descriptions>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { YearlyDataItem } from '@/api/calculate'
import { formatCurrency, formatPercent } from '@/utils/format'

interface ColumnOption {
  label: string
  value: string
}

interface ColumnMeta {
  label: string
  value: string
  width?: number
  minWidth?: number
  align?: string
  fixed?: string | boolean
  format?: string
  className?: string
  valueClass?: (row: YearlyDataItem) => string
}

interface ColumnGroup {
  basic: ColumnOption[]
  guaranteed?: ColumnOption[]
  dividend?: ColumnOption[]
}

interface Props {
  yearlyData: YearlyDataItem[]
  summary: {
    totalPremium: number
    totalReturn: number
    irr: number
    breakEvenYear: number
    guaranteedIrr?: number
    dividendIrr?: number
    totalValueWithDividend?: number
  }
  selectedColumns?: string[]
  columnOptions?: ColumnGroup
}

const props = withDefaults(defineProps<Props>(), {
  selectedColumns: () => [],
  columnOptions: () => ({ basic: [] })
})

// 全量字段元数据映射表
const columnMetaMap: Record<string, ColumnMeta> = {
  year: { label: '保单年度', value: 'year', width: 100, align: 'center', fixed: 'left' },
  age: { label: '年龄', value: 'age', width: 80, align: 'center' },
  premium: { label: '当年保费', value: 'premium', width: 130, align: 'right', format: 'currency' },
  accumulatedPremium: { label: '累计保费', value: 'accumulatedPremium', width: 130, align: 'right', format: 'currency' },
  cashValue: { label: '现金价值', value: 'cashValue', width: 130, align: 'right', format: 'currency', valueClass: (row) => row.cashValue > row.accumulatedPremium ? 'positive-value' : '' },
  deathBenefit: { label: '身故保险金', value: 'deathBenefit', width: 140, align: 'right', format: 'currency' },
  totalValue: { label: '总价值', value: 'totalValue', width: 140, align: 'right', format: 'currency', className: 'highlight-value' },
  totalDeathBenefit: { label: '含红利身故金', value: 'totalDeathBenefit', width: 150, align: 'right', format: 'currency' },
  dividend: { label: '当年红利', value: 'dividend', width: 120, align: 'right', format: 'currency' },
  accumulatedDividend: { label: '累积红利', value: 'accumulatedDividend', width: 130, align: 'right', format: 'currency' },
  guaranteedCashValue: { label: '保证现金价值', value: 'guaranteedCashValue', width: 140, align: 'right', format: 'currency' },
  guaranteedDeathBenefit: { label: '保证身故保险金', value: 'guaranteedDeathBenefit', width: 160, align: 'right', format: 'currency' },
  annualPayout: { label: '养老保险金', value: 'annualPayout', width: 130, align: 'right', format: 'currency' },
  totalReceived: { label: '累计生存金', value: 'totalReceived', width: 130, align: 'right', format: 'currency' },
  irr: { label: '内部收益率', value: 'irr', width: 120, align: 'right' },
  // 保证利益组
  guaranteedDividend: { label: '当年度红利(保证)', value: 'guaranteedDividend', width: 160, align: 'right', format: 'currency' },
  guaranteedAccumDividend: { label: '累积红利(保证)', value: 'guaranteedAccumDividend', width: 160, align: 'right', format: 'currency' },
  guaranteedAnnuity: { label: '养老保险金(保证)', value: 'guaranteedAnnuity', width: 160, align: 'right', format: 'currency' },
  guaranteedSurvivalTotal: { label: '累计生存金(保证)', value: 'guaranteedSurvivalTotal', width: 160, align: 'right', format: 'currency' },
  guaranteedIrrCol: { label: 'IRR(保证)', value: 'guaranteedIrrCol', width: 120, align: 'right' },
  // 红利利益组
  dividendAnnuity: { label: '养老保险金(含红利)', value: 'dividendAnnuity', width: 170, align: 'right', format: 'currency' },
  dividendSurvivalTotal: { label: '累计生存金(含红利)', value: 'dividendSurvivalTotal', width: 170, align: 'right', format: 'currency' },
  dividendIrrCol: { label: 'IRR(含红利)', value: 'dividendIrrCol', width: 130, align: 'right' }
}

// 固定列（始终显示）
const fixedColumns: ColumnMeta[] = [columnMetaMap.year, columnMetaMap.age]

// 合并所有可选列（根据 selectedColumns 过滤）
const activeColumns = computed<ColumnMeta[]>(() => {
  // 如果没有传入 selectedColumns 或 columnOptions，使用默认列
  if (!props.selectedColumns || props.selectedColumns.length === 0 || !props.columnOptions) {
    // 默认显示的基本列
    const defaultKeys = ['premium', 'accumulatedPremium', 'cashValue', 'dividend', 'totalValue', 'deathBenefit']
    return [...fixedColumns, ...defaultKeys.map(k => columnMetaMap[k]).filter(Boolean)]
  }

  // 根据 selectedColumns 动态生成列
  const dynamicCols = props.selectedColumns
    .map(key => columnMetaMap[key])
    .filter(Boolean)

  return [...fixedColumns, ...dynamicCols]
})

// summary 列数：有分红数据时显示更多列
const summaryColumnCount = computed(() => {
  const extraCount = [
    props.summary.guaranteedIrr != null,
    props.summary.dividendIrr != null,
    props.summary.totalValueWithDividend != null
  ].filter(Boolean).length
  return 4 + extraCount
})
</script>

<style scoped>
.benefit-table-wrapper {
  width: 100%;
}

/* 表格样式覆盖 */
.benefit-table-wrapper :deep(.el-table) {
  --el-table-header-bg-color: var(--bg-secondary) !important;
  --el-table-tr-bg-color: var(--bg-card) !important;
  --el-table-row-hover-bg-color: var(--bg-card-hover) !important;
  --el-table-border-color: var(--border-color) !important;
  --el-table-text-color: var(--text-primary) !important;
  --el-table-header-text-color: var(--text-secondary) !important;
  border-radius: var(--radius-lg);
  overflow: hidden;
}

.benefit-table-wrapper :deep(.el-table__header th) {
  background: var(--bg-secondary) !important;
  color: var(--text-secondary) !important;
  font-weight: 600;
  border-bottom: 2px solid var(--border-color) !important;
}

.benefit-table-wrapper :deep(.el-table td) {
  border-bottom-color: var(--border-color) !important;
}

.benefit-table-wrapper :deep(.el-table--striped .el-table__body tr.el-table__row--striped td) {
  background-color: var(--bg-secondary) !important;
}

.benefit-table-wrapper :deep(.el-table__body tr:hover > td) {
  background-color: var(--bg-card-hover) !important;
}

.center-cell {
  font-weight: 500;
  color: var(--text-primary);
}

.positive-value {
  color: var(--accent-green);
  font-weight: 600;
}

.highlight-value {
  color: var(--accent-purple);
  font-weight: 600;
}

.benefit-summary {
  margin-top: 24px;
}

.benefit-summary :deep(.el-descriptions) {
  --el-descriptions-table-border: var(--border-color) !important;
  border-radius: var(--radius-lg);
  overflow: hidden;
}

.benefit-summary :deep(.el-descriptions__label) {
  background-color: var(--bg-secondary) !important;
  color: var(--text-secondary) !important;
  border-color: var(--border-color) !important;
  font-weight: 500;
}

.benefit-summary :deep(.el-descriptions__content) {
  background-color: var(--bg-card) !important;
  color: var(--text-primary) !important;
  border-color: var(--border-color) !important;
}

.benefit-summary :deep(.el-descriptions__cell) {
  border-color: var(--border-color) !important;
}
</style>
