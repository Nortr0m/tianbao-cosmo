<template>
  <div class="birthday-bonus">
    <el-empty v-if="!hasBonus" description="该产品无祝寿金责任" />
    <template v-else>
      <el-form :model="form" label-width="120px">
        <el-form-item label="祝寿金类型">
          <el-radio-group v-model="form.bonusType">
            <el-radio-button
              v-for="type in bonusTypeOptions"
              :key="type.value"
              :label="type.value"
            >
              {{ type.label }}
            </el-radio-button>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="领取年龄">
          <el-radio-group v-model="form.bonusAge">
            <el-radio-button
              v-for="age in bonusAgeOptions"
              :key="age"
              :label="age"
            >
              {{ age }}岁
            </el-radio-button>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="祝寿金金额">
          <el-input-number v-model="form.bonusAmount" :min="0" :step="10000" :max="10000000" />
          <span class="unit">元</span>
        </el-form-item>
      </el-form>

      <div v-if="summary" class="bonus-summary">
        <el-divider />
        <el-descriptions :column="2" border>
          <el-descriptions-item label="祝寿金总额">
            {{ formatCurrency(summary.totalBonus) }}
          </el-descriptions-item>
          <el-descriptions-item label="领取年龄">
            {{ summary.bonusAge }}岁
          </el-descriptions-item>
        </el-descriptions>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import { formatCurrency } from '@/utils/format'

export interface BirthdayBonusForm {
  bonusType: string
  bonusAge: number
  bonusAmount: number
}

export interface BirthdayBonusSummary {
  totalBonus: number
  bonusAge: number
}

interface OptionItem {
  label: string
  value: string
}

interface Props {
  modelValue: BirthdayBonusForm
  bonusTypeOptions: OptionItem[]
  bonusAgeOptions: number[]
  summary?: BirthdayBonusSummary
}

const props = defineProps<Props>()
const emit = defineEmits<{
  'update:modelValue': [value: BirthdayBonusForm]
  change: [value: BirthdayBonusForm]
}>()

const hasBonus = computed(() => props.bonusTypeOptions.length > 0)

const form = ref<BirthdayBonusForm>({
  bonusType: props.modelValue.bonusType || props.bonusTypeOptions[0]?.value || '',
  bonusAge: props.modelValue.bonusAge || props.bonusAgeOptions[0] || 80,
  bonusAmount: props.modelValue.bonusAmount || 100000
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
.birthday-bonus {
  padding: 8px 0;
}

.unit {
  margin-left: 8px;
  color: #606266;
}

.bonus-summary {
  margin-top: 16px;
}
</style>
