<template>
  <div class="withdrawal-plan">
    <el-form :model="form" label-width="120px">
      <el-form-item label="减保起始年龄">
        <el-radio-group v-model="form.startAge">
          <el-radio-button v-for="age in startAgeOptions" :key="age" :label="age">
            {{ age }}岁
          </el-radio-button>
        </el-radio-group>
      </el-form-item>

      <el-form-item label="减保方式">
        <el-radio-group v-model="form.withdrawalType">
          <el-radio-button label="fixed_amount">固定金额</el-radio-button>
          <el-radio-button label="fixed_rate">固定比例</el-radio-button>
          <el-radio-button label="custom">自定义</el-radio-button>
        </el-radio-group>
      </el-form-item>

      <el-form-item v-if="form.withdrawalType === 'fixed_amount'" label="每年减保金额">
        <el-input-number v-model="form.fixedAmount" :min="1000" :step="1000" :max="1000000" />
        <span class="unit">元</span>
      </el-form-item>

      <el-form-item v-if="form.withdrawalType === 'fixed_rate'" label="减保比例">
        <el-slider v-model="form.fixedRate" :min="1" :max="20" show-stops show-input />
        <span class="unit">%</span>
      </el-form-item>

      <el-form-item v-if="form.withdrawalType === 'custom'" label="自定义计划">
        <el-button type="primary" size="small" @click="addCustomRow">添加年度</el-button>
        <div class="custom-rows">
          <div v-for="(row, index) in form.customRows" :key="index" class="custom-row">
            <el-input-number v-model="row.age" :min="form.startAge" :max="120" placeholder="年龄" />
            <el-input-number v-model="row.amount" :min="0" :step="1000" placeholder="金额" />
            <el-button type="danger" size="small" circle @click="removeCustomRow(index)">
              <el-icon><Delete /></el-icon>
            </el-button>
          </div>
        </div>
      </el-form-item>

      <el-form-item label="减保期限">
        <el-radio-group v-model="form.durationType">
          <el-radio-button label="age_80">至80岁</el-radio-button>
          <el-radio-button label="lifetime">至终身</el-radio-button>
          <el-radio-button label="zero_value">至现金价值为0</el-radio-button>
        </el-radio-group>
      </el-form-item>
    </el-form>

    <div v-if="summary" class="plan-summary">
      <el-divider />
      <el-row :gutter="20">
        <el-col :xs="24" :sm="8">
          <div class="summary-item">
            <span class="label">累计领取</span>
            <span class="value">{{ formatCurrency(summary.totalWithdrawal) }}</span>
          </div>
        </el-col>
        <el-col :xs="24" :sm="8">
          <div class="summary-item">
            <span class="label">剩余现金价值</span>
            <span class="value">{{ formatCurrency(summary.remainingCashValue) }}</span>
          </div>
        </el-col>
        <el-col :xs="24" :sm="8">
          <div class="summary-item">
            <span class="label">领取年数</span>
            <span class="value">{{ summary.years }}年</span>
          </div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { Delete } from '@element-plus/icons-vue'
import { formatCurrency } from '@/utils/format'

export interface WithdrawalForm {
  startAge: number
  withdrawalType: 'fixed_amount' | 'fixed_rate' | 'custom'
  fixedAmount: number
  fixedRate: number
  customRows: { age: number; amount: number }[]
  durationType: 'age_80' | 'lifetime' | 'zero_value'
}

export interface WithdrawalSummary {
  totalWithdrawal: number
  remainingCashValue: number
  years: number
}

interface Props {
  modelValue: WithdrawalForm
  summary?: WithdrawalSummary
}

const props = defineProps<Props>()
const emit = defineEmits<{
  'update:modelValue': [value: WithdrawalForm]
  change: [value: WithdrawalForm]
}>()

const startAgeOptions = [50, 55, 60, 65, 70]

const form = ref<WithdrawalForm>({
  startAge: props.modelValue.startAge || 60,
  withdrawalType: props.modelValue.withdrawalType || 'fixed_amount',
  fixedAmount: props.modelValue.fixedAmount || 10000,
  fixedRate: props.modelValue.fixedRate || 5,
  customRows: props.modelValue.customRows || [],
  durationType: props.modelValue.durationType || 'lifetime'
})

watch(
  () => form.value,
  (val) => {
    emit('update:modelValue', { ...val })
    emit('change', { ...val })
  },
  { deep: true }
)

function addCustomRow() {
  form.value.customRows.push({
    age: form.value.startAge,
    amount: 10000
  })
}

function removeCustomRow(index: number) {
  form.value.customRows.splice(index, 1)
}
</script>

<style scoped>
.withdrawal-plan {
  padding: 8px 0;
}

.unit {
  margin-left: 8px;
  color: #606266;
}

.custom-rows {
  margin-top: 12px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.custom-row {
  display: flex;
  align-items: center;
  gap: 12px;
}

.plan-summary {
  margin-top: 8px;
}

.summary-item {
  background: #f5f7fa;
  border-radius: 8px;
  padding: 16px;
  text-align: center;
}

.summary-item .label {
  display: block;
  font-size: 13px;
  color: #909399;
  margin-bottom: 8px;
}

.summary-item .value {
  display: block;
  font-size: 20px;
  font-weight: 700;
  color: #409eff;
}
</style>
