<template>
  <div class="premium-calculator">
    <el-form :model="form" label-width="90px" class="calc-form">
      <el-row :gutter="16">
        <el-col :xs="24" :sm="12" :md="8">
          <el-form-item label="年龄">
            <div class="input-with-unit">
              <el-input-number
                v-model="form.age"
                :min="minAge"
                :max="maxAge"
                :step="1"
                size="default"
                controls-position="right"
                style="width: 100%"
              />
              <span class="unit">岁</span>
            </div>
          </el-form-item>
        </el-col>
        <el-col :xs="24" :sm="12" :md="8">
          <el-form-item label="性别">
            <el-radio-group v-model="form.gender" size="default" class="gender-group">
              <el-radio-button value="male">
                <el-icon><Male /></el-icon> 男
              </el-radio-button>
              <el-radio-button value="female">
                <el-icon><Female /></el-icon> 女
              </el-radio-button>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :xs="24" :sm="12" :md="8">
          <el-form-item label="保额">
            <div class="input-with-unit">
              <el-input-number
                v-model="form.coverage"
                :min="10000"
                :step="10000"
                :max="10000000"
                size="default"
                controls-position="right"
                style="width: 100%"
              />
              <span class="unit">元</span>
            </div>
          </el-form-item>
        </el-col>
        <el-col :xs="24" :sm="12" :md="8">
          <el-form-item label="缴费年限">
            <el-select v-model="form.paymentPeriod" placeholder="请选择" size="default" style="width: 100%">
              <el-option
                v-for="p in paymentPeriods"
                :key="p"
                :label="`${p}年`"
                :value="p"
              />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :xs="24" :sm="12" :md="8">
          <el-form-item label="缴费周期">
            <el-radio-group v-model="form.paymentFrequency" size="small" class="freq-group">
              <el-radio-button
                v-for="freq in supportedFrequencies"
                :key="freq.value"
                :value="freq.value"
              >
                {{ freq.label }}
              </el-radio-button>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :xs="24" :sm="12" :md="8">
          <el-form-item>
            <el-button type="primary" :loading="calculating" @click="handleCalculate" class="calc-btn">
              <el-icon><Plus /></el-icon> 计算保费
            </el-button>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>

    <div v-if="result" class="calc-result">
      <el-divider />

      <!-- 错误信息展示 -->
      <div v-if="result.errorMessage" class="calc-error">
        <el-alert
          :title="result.errorMessage"
          type="warning"
          :closable="false"
          show-icon
        />
      </div>

      <div v-else>
        <el-row :gutter="16">
        <el-col :xs="24" :sm="8">
          <div class="result-card primary tb-star-trail">
            <div class="result-label">预估保费</div>
            <div class="result-value neon-text-cyan">{{ formatCurrency(result.premium) }}</div>
            <div class="result-period">{{ frequencyLabel }}</div>
          </div>
        </el-col>
        <el-col :xs="24" :sm="8">
          <div class="result-card">
            <div class="result-label">总保费</div>
            <div class="result-value">{{ formatCurrency(result.totalPremium) }}</div>
          </div>
        </el-col>
        <el-col :xs="24" :sm="8">
          <div class="result-card">
            <div class="result-label">保障杠杆</div>
            <div class="result-value neon-text-purple">{{ leverage }}<span class="leverage-unit">倍</span></div>
          </div>
        </el-col>
      </el-row>

      <!-- 保费明细 -->
      <div v-if="result.components && result.components.length > 0" class="premium-breakdown">
        <div class="breakdown-title">保费构成明细</div>
        <div class="breakdown-list">
          <div
            v-for="(comp, idx) in result.components"
            :key="idx"
            class="breakdown-item"
            :class="{ 'is-required': comp.isRequired, 'is-optional': !comp.isRequired }"
          >
            <div class="breakdown-info">
              <span class="breakdown-name">{{ comp.itemName }}</span>
              <el-tag v-if="comp.isRequired" size="small" type="primary" effect="dark">必选</el-tag>
              <el-tag v-else size="small" type="success" effect="plain">可选</el-tag>
              <span v-if="comp.selectedOption && !['true','false','on','off','1','0'].includes(comp.selectedOption)" class="breakdown-option">
                {{ comp.selectedOption }}
              </span>
            </div>
            <div class="breakdown-amount">
              <template v-if="comp.isRequired">
                已包含
              </template>
              <template v-else-if="comp.additionalPremium !== undefined && comp.additionalPremium > 0">
                +{{ formatCurrency(comp.additionalPremium) }}
              </template>
              <template v-else>
                -
              </template>
            </div>
          </div>
        </div>
      </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { Male, Female, Plus } from '@element-plus/icons-vue'
import { formatCurrency } from '@/utils/format'

interface CalcForm {
  age: number
  gender: 'male' | 'female'
  coverage: number
  paymentPeriod: string
  paymentFrequency: 'year' | 'half_year' | 'quarter' | 'month'
}

interface PremiumComponent {
  itemCode: string
  itemName: string
  isRequired: boolean
  selectedOption?: string
  coefficient?: number
  additionalPremium?: number
}

interface CalcResult {
  premium: number
  totalPremium: number
  components?: PremiumComponent[]
  errorMessage?: string
}

interface FrequencyOption {
  value: string
  label: string
}

interface Props {
  paymentPeriods: string[]
  paymentFrequencies?: FrequencyOption[]
  defaultCoverage?: number
  defaultAge?: number
  minAge?: number
  maxAge?: number
}

const props = withDefaults(defineProps<Props>(), {
  defaultCoverage: 500000,
  defaultAge: 30,
  minAge: 0,
  maxAge: 65,
  paymentFrequencies: () => [
    { value: 'year', label: '年缴' },
    { value: 'half_year', label: '半年缴' },
    { value: 'quarter', label: '季缴' },
    { value: 'month', label: '月缴' }
  ]
})

const emit = defineEmits<{
  calculate: [form: CalcForm]
}>()

const defaultFreq = computed(() => {
  return (props.paymentFrequencies?.[0]?.value as CalcForm['paymentFrequency']) || 'year'
})

const form = ref<CalcForm>({
  age: props.defaultAge,
  gender: 'male',
  coverage: props.defaultCoverage,
  paymentPeriod: props.paymentPeriods[0] || '',
  paymentFrequency: defaultFreq.value
})

// 监听缴费周期变化，确保值在支持范围内
watch(
  () => props.paymentFrequencies,
  (freqs) => {
    if (freqs && freqs.length > 0) {
      const valid = freqs.some((f: { value: string }) => f.value === form.value.paymentFrequency)
      if (!valid) {
        form.value.paymentFrequency = freqs[0].value as CalcForm['paymentFrequency']
      }
    }
  }
)

const supportedFrequencies = computed(() => props.paymentFrequencies || [])

const calculating = ref(false)
const result = ref<CalcResult | null>(null)

const frequencyLabel = computed(() => {
  const map: Record<string, string> = {
    year: '每年',
    half_year: '每半年',
    quarter: '每季度',
    month: '每月'
  }
  return map[form.value.paymentFrequency] || ''
})

const leverage = computed(() => {
  if (!result.value || result.value.totalPremium <= 0) return '0'
  return (form.value.coverage / result.value.totalPremium).toFixed(1)
})

function handleCalculate() {
  calculating.value = true
  emit('calculate', { ...form.value })
}

function setResult(data: CalcResult) {
  result.value = data
  calculating.value = false
}

function setLoading(val: boolean) {
  calculating.value = val
}

defineExpose({
  setResult,
  setLoading,
  form
})
</script>

<style scoped>
.premium-calculator {
  padding: 4px 0;
}

.calc-form :deep(.el-form-item) {
  margin-bottom: 14px;
}

.calc-form :deep(.el-form-item__label) {
  color: var(--text-secondary);
  font-weight: 500;
}

.input-with-unit {
  display: flex;
  align-items: center;
  gap: 8px;
  width: 100%;
}

.input-with-unit :deep(.el-input-number) {
  flex: 1;
}

.unit {
  color: var(--text-secondary);
  font-size: 14px;
  white-space: nowrap;
}

.gender-group {
  width: 100%;
  display: flex;
}

.gender-group :deep(.el-radio-button) {
  flex: 1;
}

.gender-group :deep(.el-radio-button__inner) {
  width: 100%;
  text-align: center;
}

.freq-group {
  display: flex;
  flex-wrap: wrap;
}

.freq-group :deep(.el-radio-button) {
  flex: 1;
  min-width: 60px;
}

.freq-group :deep(.el-radio-button__inner) {
  width: 100%;
  text-align: center;
  padding: 8px 10px;
}

.calc-btn {
  width: 100%;
  height: 38px;
  font-size: 15px;
}

.calc-result {
  margin-top: 4px;
}

.result-card {
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-lg);
  padding: 18px 16px;
  text-align: center;
  position: relative;
  overflow: hidden;
  transition: all var(--transition-normal);
}

.result-card:hover {
  border-color: var(--border-glow);
  box-shadow: var(--shadow-neon-purple);
}

.result-card.primary {
  background: linear-gradient(135deg, rgba(200, 85, 240, 0.15) 0%, rgba(0, 240, 255, 0.15) 100%);
  border-color: var(--accent-purple);
  box-shadow: 0 0 20px rgba(200, 85, 240, 0.2);
}

.result-card.primary::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: var(--gradient-main);
}

.result-label {
  font-size: 13px;
  margin-bottom: 8px;
  color: var(--text-secondary);
  letter-spacing: 1px;
}

.result-value {
  font-size: 26px;
  font-weight: 700;
  color: var(--text-primary);
  font-family: var(--font-display);
}

.result-period {
  font-size: 12px;
  margin-top: 6px;
  color: var(--text-muted);
}

.leverage-unit {
  font-size: 16px;
  margin-left: 2px;
  font-weight: 500;
}

.premium-breakdown {
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px dashed var(--border-color);
}

.breakdown-title {
  font-size: 13px;
  font-weight: 600;
  color: var(--text-secondary);
  margin-bottom: 12px;
  letter-spacing: 0.5px;
}

.breakdown-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.breakdown-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 12px;
  background: var(--bg-soft);
  border-radius: var(--radius-md);
  font-size: 13px;
}

.breakdown-item.is-required {
  background: rgba(0, 240, 255, 0.05);
  border-left: 3px solid var(--accent-cyan);
}

.breakdown-item.is-optional {
  background: rgba(0, 255, 170, 0.03);
  border-left: 3px solid var(--accent-green);
}

.breakdown-info {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.breakdown-name {
  color: var(--text-primary);
  font-weight: 500;
}

.breakdown-option {
  color: var(--text-muted);
  font-size: 12px;
  padding: 2px 8px;
  background: var(--bg-input);
  border-radius: 10px;
}

.breakdown-amount {
  color: var(--accent-orange);
  font-weight: 600;
  font-variant-numeric: tabular-nums;
}

.breakdown-item.is-required .breakdown-amount {
  color: var(--accent-cyan);
  font-weight: 400;
}

.neon-text-cyan {
  color: var(--accent-cyan);
  text-shadow: 0 0 10px rgba(0, 240, 255, 0.5), 0 0 20px rgba(0, 240, 255, 0.3);
}

.neon-text-purple {
  color: var(--accent-purple);
  text-shadow: 0 0 10px rgba(200, 85, 240, 0.5), 0 0 20px rgba(200, 85, 240, 0.3);
}

/* el-input-number 暗色主题微调 */
:deep(.el-input-number .el-input__wrapper) {
  background-color: var(--bg-input);
  border-color: var(--border-color);
}

:deep(.el-input-number .el-input__wrapper:hover) {
  border-color: var(--accent-purple);
}

:deep(.el-input-number .el-input__wrapper.is-focus) {
  border-color: var(--accent-cyan);
  box-shadow: var(--shadow-neon-cyan);
}

:deep(.el-input-number .el-input-number__decrease),
:deep(.el-input-number .el-input-number__increase) {
  background-color: var(--bg-secondary);
  border-color: var(--border-color);
  color: var(--text-secondary);
}

:deep(.el-input-number .el-input-number__decrease:hover),
:deep(.el-input-number .el-input-number__increase:hover) {
  color: var(--accent-cyan);
}
</style>
