<template>
  <div class="dividend-selector">
    <div class="preset-buttons">
      <el-button
        v-for="rate in presetRates"
        :key="rate"
        :type="modelValue === rate ? 'primary' : 'default'"
        size="small"
        @click="selectRate(rate)"
      >
        {{ rate }}%
      </el-button>
    </div>
    <div class="custom-input">
      <span class="label">自定义：</span>
      <el-slider v-model="localValue" :min="0" :max="200" show-input style="width: 300px" />
      <span class="unit">%</span>
    </div>
    <div class="rate-info">
      <el-tag :type="rateTagType">当前实现率: {{ modelValue }}%</el-tag>
      <span class="hint">实现率越高，红利演示金额越高</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'

interface Props {
  modelValue: number
}

const props = defineProps<Props>()
const emit = defineEmits<{
  'update:modelValue': [value: number]
  change: [value: number]
}>()

const presetRates = [50, 80, 100, 120, 150]
const localValue = ref(props.modelValue)

watch(
  () => props.modelValue,
  (val) => {
    localValue.value = val
  }
)

watch(localValue, (val) => {
  emit('update:modelValue', val)
  emit('change', val)
})

const rateTagType = computed(() => {
  if (props.modelValue >= 120) return 'success'
  if (props.modelValue >= 100) return 'primary'
  if (props.modelValue >= 80) return 'warning'
  return 'danger'
})

function selectRate(rate: number) {
  localValue.value = rate
}
</script>

<style scoped>
.dividend-selector {
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding: 8px 0;
}

.preset-buttons {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.custom-input {
  display: flex;
  align-items: center;
  gap: 8px;
}

.label {
  font-size: 14px;
  color: #606266;
  white-space: nowrap;
}

.unit {
  font-size: 14px;
  color: #606266;
}

.rate-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.hint {
  font-size: 12px;
  color: #909399;
}
</style>
