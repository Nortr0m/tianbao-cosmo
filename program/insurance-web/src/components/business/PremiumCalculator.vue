<template>
  <div class="premium-calculator">
    <el-form :model="form" label-width="100px" class="calc-form">
      <el-row :gutter="20">
        <el-col :xs="24" :sm="12" :md="8">
          <el-form-item label="年龄">
            <el-slider v-model="form.age" :min="0" :max="65" show-stops show-input :marks="ageMarks" />
          </el-form-item>
        </el-col>
        <el-col :xs="24" :sm="12" :md="8">
          <el-form-item label="性别">
            <el-radio-group v-model="form.gender" size="large">
              <el-radio-button label="male">
                <el-icon><Male /></el-icon> 男
              </el-radio-button>
              <el-radio-button label="female">
                <el-icon><Female /></el-icon> 女
              </el-radio-button>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :xs="24" :sm="12" :md="8">
          <el-form-item label="保额">
            <el-input-number v-model="form.coverage" :min="10000" :step="10000" :max="10000000" style="width: 180px" />
            <span class="unit">元</span>
          </el-form-item>
        </el-col>
        <el-col :xs="24" :sm="12" :md="8">
          <el-form-item label="缴费年限">
            <el-select v-model="form.paymentPeriod" placeholder="请选择" style="width: 180px">
              <el-option
                v-for="p in paymentPeriods"
                :key="p"
                :label="p"
                :value="p"
              />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :xs="24" :sm="12" :md="8">
          <el-form-item label="缴费周期">
            <el-radio-group v-model="form.paymentFrequency" size="small">
              <el-radio-button label="year">年缴</el-radio-button>
              <el-radio-button label="half_year">半年缴</el-radio-button>
              <el-radio-button label="quarter">季缴</el-radio-button>
              <el-radio-button label="month">月缴</el-radio-button>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :xs="24" :sm="12" :md="8">
          <el-form-item>
            <el-button type="primary" :loading="calculating" @click="handleCalculate">
              <el-icon><Plus /></el-icon> 计算保费
            </el-button>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>

    <div v-if="result" class="calc-result">
      <el-divider />
      <el-row :gutter="20">
        <el-col :xs="24" :sm="8">
          <div class="result-card primary">
            <div class="result-label">预估保费</div>
            <div class="result-value">{{ formatCurrency(result.premium) }}</div>
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
            <div class="result-value">{{ leverage }}倍</div>
          </div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { Male, Female, Plus } from '@element-plus/icons-vue'
import { formatCurrency } from '@/utils/format'

interface CalcForm {
  age: number
  gender: 'male' | 'female'
  coverage: number
  paymentPeriod: string
  paymentFrequency: 'year' | 'half_year' | 'quarter' | 'month'
}

interface CalcResult {
  premium: number
  totalPremium: number
}

interface Props {
  paymentPeriods: string[]
  defaultCoverage?: number
  defaultAge?: number
}

const props = withDefaults(defineProps<Props>(), {
  defaultCoverage: 500000,
  defaultAge: 30
})

const emit = defineEmits<{
  calculate: [form: CalcForm]
}>()

const form = ref<CalcForm>({
  age: props.defaultAge,
  gender: 'male',
  coverage: props.defaultCoverage,
  paymentPeriod: props.paymentPeriods[0] || '',
  paymentFrequency: 'year'
})

const calculating = ref(false)
const result = ref<CalcResult | null>(null)

const ageMarks = computed(() => {
  const marks: Record<number, string> = {}
  for (let i = 0; i <= 60; i += 10) {
    marks[i] = `${i}岁`
  }
  return marks
})

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
  if (!result.value || result.value.totalPremium <= 0) return 0
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
  padding: 8px 0;
}

.calc-form :deep(.el-form-item) {
  margin-bottom: 16px;
}

.unit {
  margin-left: 8px;
  color: #606266;
}

.calc-result {
  margin-top: 8px;
}

.result-card {
  background: #f5f7fa;
  border-radius: 8px;
  padding: 20px;
  text-align: center;
}

.result-card.primary {
  background: linear-gradient(135deg, #409eff 0%, #67c23a 100%);
  color: #fff;
}

.result-label {
  font-size: 14px;
  margin-bottom: 8px;
  opacity: 0.9;
}

.result-value {
  font-size: 24px;
  font-weight: 700;
}

.result-period {
  font-size: 12px;
  margin-top: 4px;
  opacity: 0.85;
}
</style>
