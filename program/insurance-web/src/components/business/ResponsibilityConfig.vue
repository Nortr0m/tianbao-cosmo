<template>
  <div class="responsibility-config">
    <div v-for="category in categoryList" :key="category.key" class="category-section">
      <div class="category-header" @click="toggleCategory(category.key)">
        <el-icon class="toggle-icon" :class="{ expanded: !collapsed[category.key] }">
          <ArrowDown />
        </el-icon>
        <span class="category-title">{{ category.label }}</span>
        <el-tag v-if="category.selectedCount > 0" type="success" size="small">
          已选{{ category.selectedCount }}项
        </el-tag>
      </div>

      <el-collapse-transition>
        <div v-show="!collapsed[category.key]" class="category-body">
          <div
            v-for="item in category.items"
            :key="item.code"
            class="responsibility-item"
            :class="{ disabled: !item.supported }"
          >
            <div class="item-info">
              <span class="item-name">{{ item.name }}</span>
              <el-tooltip v-if="item.description" :content="item.description" placement="top">
                <el-icon><QuestionFilled /></el-icon>
              </el-tooltip>
              <el-tag v-if="!item.supported" type="info" size="small">不支持</el-tag>
            </div>

            <div v-if="item.supported" class="item-options">
              <!-- Radio options -->
              <template v-if="item.optionType === 'radio'">
                <el-radio-group
                  v-model="selectedValues[item.code]"
                  size="small"
                  @change="handleChange(item.code, $event as string | number | boolean)"
                >
                  <el-radio-button
                    v-for="opt in item.options"
                    :key="opt.value"
                    :label="opt.value"
                  >
                    {{ opt.label }}
                  </el-radio-button>
                </el-radio-group>
              </template>

              <!-- Checkbox options -->
              <template v-else-if="item.optionType === 'checkbox'">
                <el-checkbox-group
                  v-model="selectedValues[item.code]"
                  size="small"
                  @change="handleChange(item.code, $event as string[])"
                >
                  <el-checkbox-button
                    v-for="opt in item.options"
                    :key="opt.value"
                    :label="opt.value"
                  >
                    {{ opt.label }}
                  </el-checkbox-button>
                </el-checkbox-group>
              </template>

              <!-- Amount input -->
              <template v-else-if="item.optionType === 'amount'">
                <el-input-number
                  v-model="selectedValues[item.code]"
                  :min="item.min || 0"
                  :max="item.max || 10000000"
                  :step="item.step || 10000"
                  size="small"
                  @change="handleChange(item.code, $event as number)"
                />
                <span class="unit">元</span>
              </template>

              <!-- Switch -->
              <template v-else-if="item.optionType === 'switch'">
                <el-switch
                  v-model="selectedValues[item.code]"
                  :active-text="item.activeText || '是'"
                  :inactive-text="item.inactiveText || '否'"
                  @change="handleChange(item.code, $event as boolean)"
                />
              </template>
            </div>
          </div>
        </div>
      </el-collapse-transition>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { ArrowDown, QuestionFilled } from '@element-plus/icons-vue'

export interface ResponsibilityItem {
  code: string
  name: string
  description?: string
  category: string
  supported: boolean
  optionType: 'radio' | 'checkbox' | 'amount' | 'switch'
  options?: { label: string; value: string | number }[]
  min?: number
  max?: number
  step?: number
  activeText?: string
  inactiveText?: string
  defaultValue?: string | number | boolean | string[]
}

interface Props {
  items: ResponsibilityItem[]
  modelValue: Record<string, unknown>
}

const props = defineProps<Props>()
const emit = defineEmits<{
  'update:modelValue': [value: Record<string, unknown>]
  change: [code: string, value: unknown]
}>()

const collapsed = ref<Record<string, boolean>>({})
const selectedValues = ref<Record<string, any>>({})

// Initialize selected values from props
watch(
  () => props.modelValue,
  (val) => {
    selectedValues.value = { ...val }
  },
  { immediate: true }
)

// Initialize collapsed state
watch(
  () => props.items,
  (items) => {
    const categories = [...new Set(items.map((i) => i.category))]
    categories.forEach((cat) => {
      if (collapsed.value[cat] === undefined) {
        collapsed.value[cat] = false
      }
    })
  },
  { immediate: true }
)

const categoryList = computed(() => {
  const categoryMap: Record<string, { key: string; label: string; items: ResponsibilityItem[]; selectedCount: number }> = {}

  const categoryLabels: Record<string, string> = {
    BASE: '基础保障',
    DEATH: '身故责任',
    WAIVER: '豁免责任',
    MULTI_PAY: '多次赔付',
    BONUS: '额外赔付',
    ALLOWANCE: '津贴责任',
    SPECIAL: '特色责任'
  }

  props.items.forEach((item) => {
    if (!item.supported) return // Skip unsupported items
    if (!categoryMap[item.category]) {
      categoryMap[item.category] = {
        key: item.category,
        label: categoryLabels[item.category] || item.category,
        items: [],
        selectedCount: 0
      }
    }
    categoryMap[item.category].items.push(item)
    const val = selectedValues.value[item.code]
    if (val !== undefined && val !== null && val !== false && (Array.isArray(val) ? val.length > 0 : true)) {
      categoryMap[item.category].selectedCount++
    }
  })

  return Object.values(categoryMap)
})

function toggleCategory(key: string) {
  collapsed.value[key] = !collapsed.value[key]
}

function handleChange(code: string, value: unknown) {
  const newValues = { ...selectedValues.value, [code]: value }
  selectedValues.value = newValues
  emit('update:modelValue', newValues)
  emit('change', code, value)
}
</script>

<style scoped>
.responsibility-config {
  border: 1px solid #ebeef5;
  border-radius: 8px;
  overflow: hidden;
}

.category-section {
  border-bottom: 1px solid #ebeef5;
}

.category-section:last-child {
  border-bottom: none;
}

.category-header {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 14px 16px;
  background-color: #f5f7fa;
  cursor: pointer;
  user-select: none;
}

.toggle-icon {
  transition: transform 0.3s;
  color: #909399;
}

.toggle-icon.expanded {
  transform: rotate(180deg);
}

.category-title {
  flex: 1;
  font-weight: 600;
  color: #303133;
}

.category-body {
  padding: 8px 16px;
}

.responsibility-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid #f0f0f0;
}

.responsibility-item:last-child {
  border-bottom: none;
}

.responsibility-item.disabled {
  opacity: 0.5;
}

.item-info {
  display: flex;
  align-items: center;
  gap: 8px;
}

.item-name {
  font-size: 14px;
  color: #303133;
}

.item-options {
  display: flex;
  align-items: center;
  gap: 8px;
}

.unit {
  font-size: 13px;
  color: #606266;
}
</style>
