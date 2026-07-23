<template>
  <div class="payout-plan">
    <el-form :model="form" label-width="120px">
      <el-form-item label="领取起始年龄">
        <el-radio-group v-model="form.startAge">
          <el-radio-button
            v-for="age in startAgeOptions"
            :key="age"
            :value="age"
          >
            {{ age }}岁
          </el-radio-button>
        </el-radio-group>
      </el-form-item>

      <el-form-item label="领取方式">
        <el-radio-group v-model="form.payoutMethod">
          <el-radio-button value="yearly">年领</el-radio-button>
          <el-radio-button value="monthly">月领</el-radio-button>
        </el-radio-group>
        <span class="hint">月领金额约为年领金额的8.5%</span>
      </el-form-item>

      <el-form-item label="保证领取期">
        <el-radio-group v-model="form.guaranteePeriod">
          <el-radio-button
            v-for="period in guaranteePeriodOptions"
            :key="period.value"
            :value="period.value"
          >
            {{ period.label }}
          </el-radio-button>
        </el-radio-group>
      </el-form-item>

      <el-form-item v-if="increaseOptions.length > 0" label="领取递增规则">
        <el-radio-group v-model="form.increaseRule">
          <el-radio-button
            v-for="rule in increaseOptions"
            :key="rule.value"
            :value="rule.value"
          >
            {{ rule.label }}
          </el-radio-button>
        </el-radio-group>
      </el-form-item>
    </el-form>

    <div v-if="summary" class="plan-summary">
      <el-divider />
      <el-row :gutter="20">
        <el-col :xs="24" :sm="8">
          <div class="summary-item">
            <span class="label">年领金额</span>
            <span class="value">{{ formatCurrency(summary.yearlyAmount) }}</span>
          </div>
        </el-col>
        <el-col :xs="24" :sm="8">
          <div class="summary-item">
            <span class="label">保证领取总额</span>
            <span class="value">{{ formatCurrency(summary.guaranteedTotal) }}</span>
          </div>
        </el-col>
        <el-col :xs="24" :sm="8">
          <div class="summary-item">
            <span class="label">领取至80岁总额</span>
            <span class="value">{{ formatCurrency(summary.totalTo80) }}</span>
          </div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { formatCurrency } from '@/utils/format'

export interface PayoutForm {
  startAge: number
  payoutMethod: 'yearly' | 'monthly'
  guaranteePeriod: string
  increaseRule: string
}

export interface PayoutSummary {
  yearlyAmount: number
  guaranteedTotal: number
  totalTo80: number
}

interface OptionItem {
  label: string
  value: string
}

interface Props {
  modelValue: PayoutForm
  startAgeOptions: number[]
  guaranteePeriodOptions: OptionItem[]
  increaseOptions: OptionItem[]
  summary?: PayoutSummary
}

const props = defineProps<Props>()
const emit = defineEmits<{
  'update:modelValue': [value: PayoutForm]
  change: [value: PayoutForm]
}>()

const form = ref<PayoutForm>({
  startAge: props.modelValue.startAge || props.startAgeOptions[0] || 60,
  payoutMethod: props.modelValue.payoutMethod || 'yearly',
  guaranteePeriod: props.modelValue.guaranteePeriod || props.guaranteePeriodOptions[0]?.value || '20',
  increaseRule: props.modelValue.increaseRule || props.increaseOptions[0]?.value || 'none'
})

watch(
  () => form.value,
  (val) => {
    emit('update:modelValue', { ...val })
    emit('change', { ...val })
  },
  { deep: true }
)
</script>

<style scoped>
.payout-plan {
  padding: 8px 0;
  color: var(--text-primary);
}

.hint {
  margin-left: 12px;
  font-size: 12px;
  color: var(--text-muted);
}

.plan-summary {
  margin-top: 12px;
}

.summary-item {
  background: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  padding: 16px;
  text-align: center;
  transition: all var(--transition-fast);
}

.summary-item:hover {
  border-color: var(--border-glow);
  box-shadow: var(--shadow-neon-purple);
}

.summary-item .label {
  display: block;
  font-size: 13px;
  color: var(--text-muted);
  margin-bottom: 8px;
}

.summary-item .value {
  display: block;
  font-size: 20px;
  font-weight: 700;
  color: var(--accent-cyan);
}
</style>
