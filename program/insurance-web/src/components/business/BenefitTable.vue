<template>
  <div class="benefit-table-wrapper">
    <el-table
      :data="yearlyData"
      :border="true"
      :stripe="true"
      height="500"
      style="width: 100%"
    >
      <el-table-column prop="year" label="保单年度" width="100" align="center" fixed />
      <el-table-column prop="age" label="年龄" width="80" align="center" />
      <el-table-column prop="premium" label="当年保费" width="140" align="right">
        <template #default="{ row }">
          {{ formatCurrency(row.premium) }}
        </template>
      </el-table-column>
      <el-table-column prop="accumulatedPremium" label="累计保费" width="140" align="right">
        <template #default="{ row }">
          {{ formatCurrency(row.accumulatedPremium) }}
        </template>
      </el-table-column>
      <el-table-column prop="cashValue" label="现金价值" width="140" align="right">
        <template #default="{ row }">
          <span :class="{ 'positive-value': row.cashValue > row.accumulatedPremium }">
            {{ formatCurrency(row.cashValue) }}
          </span>
        </template>
      </el-table-column>
      <el-table-column prop="dividend" label="当年分红" width="140" align="right">
        <template #default="{ row }">
          {{ formatCurrency(row.dividend) }}
        </template>
      </el-table-column>
      <el-table-column prop="totalValue" label="总价值" width="140" align="right">
        <template #default="{ row }">
          <span class="highlight-value">{{ formatCurrency(row.totalValue) }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="deathBenefit" label="身故保险金" width="140" align="right">
        <template #default="{ row }">
          {{ formatCurrency(row.deathBenefit) }}
        </template>
      </el-table-column>
    </el-table>

    <div class="benefit-summary">
      <el-descriptions :column="4" border>
        <el-descriptions-item label="总缴保费">
          {{ formatCurrency(summary.totalPremium) }}
        </el-descriptions-item>
        <el-descriptions-item label="总回报">
          {{ formatCurrency(summary.totalReturn) }}
        </el-descriptions-item>
        <el-descriptions-item label="IRR">
          {{ formatPercent(summary.irr, 4) }}
        </el-descriptions-item>
        <el-descriptions-item label="回本年限">
          {{ summary.breakEvenYear }}年
        </el-descriptions-item>
      </el-descriptions>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { YearlyDataItem } from '@/api/calculate'
import { formatCurrency, formatPercent } from '@/utils/format'

interface Props {
  yearlyData: YearlyDataItem[]
  summary: {
    totalPremium: number
    totalReturn: number
    irr: number
    breakEvenYear: number
  }
}

defineProps<Props>()
</script>

<style scoped>
.benefit-table-wrapper {
  width: 100%;
}

.positive-value {
  color: #67c23a;
  font-weight: 600;
}

.highlight-value {
  color: #409eff;
  font-weight: 600;
}

.benefit-summary {
  margin-top: 20px;
}
</style>
