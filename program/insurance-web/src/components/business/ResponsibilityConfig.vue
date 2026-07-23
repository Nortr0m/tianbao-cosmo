<template>
  <div class="responsibility-config">
    <div v-for="category in categoryList" :key="category.key" class="category-section">
      <div class="category-header" @click="toggleCategory(category.key)">
        <el-icon class="toggle-icon" :class="{ expanded: !collapsed[category.key] }">
          <ArrowDown />
        </el-icon>
        <span class="category-icon">{{ getCategoryIcon(category.key) }}</span>
        <span class="category-title">{{ category.label }}</span>
        <el-tag v-if="category.selectedCount > 0" size="small" class="selected-tag">
          已选{{ category.selectedCount }}项
        </el-tag>
        <div class="header-line"></div>
      </div>

      <el-collapse-transition>
        <div v-show="!collapsed[category.key]" class="category-body">
          <div
            v-for="item in category.items"
            :key="item.code"
            class="responsibility-item"
            :class="{ disabled: !item.supported, 'required-item': item.isRequired }"
          >
            <div class="item-info">
              <span class="item-name">{{ item.name }}</span>
              <el-tooltip v-if="item.description" :content="item.description" placement="top" :show-after="300">
                <el-icon class="help-icon"><QuestionFilled /></el-icon>
              </el-tooltip>
              <el-tag v-if="item.isRequired && item.supported" type="primary" size="small" effect="dark">必选</el-tag>
              <el-tag v-else-if="!item.supported" type="info" size="small">暂不支持</el-tag>
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
                  controls-position="right"
                  @change="handleChange(item.code, $event as number)"
                />
                <span class="unit">元</span>
              </template>

              <!-- Switch -->
              <template v-else-if="item.optionType === 'switch'">
                <el-switch
                  v-model="selectedValues[item.code]"
                  :active-text="item.activeText || '开启'"
                  :inactive-text="item.inactiveText || '关闭'"
                  :disabled="item.isRequired"
                  inline-prompt
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
  /** 是否必选责任（不可取消） */
  isRequired?: boolean
  defaultOption?: string
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
    // 计算是否必选：isRequired=true 或 BASE分类 或 defaultOption不为空
    const isRequired = item.isRequired === true || item.category === 'BASE' || !!(item as any).defaultOption

    if (!categoryMap[item.category]) {
      categoryMap[item.category] = {
        key: item.category,
        label: categoryLabels[item.category] || item.category,
        items: [],
        selectedCount: 0
      }
    }
    categoryMap[item.category].items.push({
      ...item,
      isRequired
    })
    const val = selectedValues.value[item.code]
    if (val !== undefined && val !== null && val !== false && (Array.isArray(val) ? val.length > 0 : true)) {
      categoryMap[item.category].selectedCount++
    }
  })

  return Object.values(categoryMap)
})

function getCategoryIcon(category: string): string {
  const icons: Record<string, string> = {
    BASE: '◆',
    DEATH: '◇',
    WAIVER: '❖',
    MULTI_PAY: '✦',
    BONUS: '✧',
    ALLOWANCE: '◈',
    SPECIAL: '❂'
  }
  return icons[category] || '◆'
}

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
  border: 1px solid var(--border-color);
  border-radius: var(--radius-lg);
  overflow: hidden;
  background: var(--bg-card);
}

.category-section {
  border-bottom: 1px solid var(--border-color);
}

.category-section:last-child {
  border-bottom: none;
}

.category-header {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 14px 20px;
  background: linear-gradient(90deg, var(--bg-secondary) 0%, var(--bg-card) 100%);
  cursor: pointer;
  user-select: none;
  position: relative;
  transition: background var(--transition-fast);
}

.category-header:hover {
  background: linear-gradient(90deg, rgba(200, 85, 240, 0.08) 0%, var(--bg-card) 100%);
}

.toggle-icon {
  transition: transform 0.3s;
  color: var(--text-muted);
  font-size: 12px;
}

.toggle-icon.expanded {
  transform: rotate(180deg);
}

.category-icon {
  color: var(--accent-purple);
  font-size: 14px;
  text-shadow: 0 0 8px rgba(200, 85, 240, 0.5);
}

.category-title {
  flex: 0 0 auto;
  font-weight: 600;
  color: var(--text-primary);
  font-size: 15px;
  letter-spacing: 0.5px;
}

.selected-tag {
  background: rgba(0, 255, 170, 0.1) !important;
  border-color: rgba(0, 255, 170, 0.3) !important;
  color: var(--accent-green) !important;
  font-size: 12px;
}

.header-line {
  flex: 1;
  height: 1px;
  background: linear-gradient(90deg, var(--border-color), transparent);
  margin-left: 12px;
}

.category-body {
  padding: 4px 20px 8px;
  background: var(--bg-card);
}

.responsibility-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 0;
  border-bottom: 1px dashed var(--border-color);
  transition: all var(--transition-fast);
}

.responsibility-item:last-child {
  border-bottom: none;
}

.responsibility-item:hover {
  padding-left: 8px;
  padding-right: 8px;
  margin: 0 -8px;
  background: rgba(200, 85, 240, 0.05);
  border-radius: var(--radius-sm);
  border-bottom-color: transparent;
}

.responsibility-item:hover + .responsibility-item {
  border-top: 1px dashed var(--border-color);
}

.responsibility-item.disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.responsibility-item.required-item {
  background: rgba(0, 240, 255, 0.03);
  border-left: 3px solid var(--accent-cyan);
  padding-left: 12px;
  margin-left: -12px;
  padding-right: 12px;
  margin-right: -12px;
  border-radius: var(--radius-sm);
}

.item-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.item-name {
  font-size: 14px;
  color: var(--text-primary);
  font-weight: 500;
}

.help-icon {
  color: var(--text-muted);
  font-size: 14px;
  cursor: help;
  transition: color var(--transition-fast);
}

.help-icon:hover {
  color: var(--accent-cyan);
}

.item-options {
  display: flex;
  align-items: center;
  gap: 10px;
}

.unit {
  font-size: 13px;
  color: var(--text-secondary);
}

/* Switch 暗色主题定制 */
:deep(.el-switch) {
  --el-switch-on-color: var(--accent-purple);
  --el-switch-off-color: var(--bg-input);
  --el-switch-border-color: var(--border-color);
  --el-switch-text-color: var(--text-primary);
}

:deep(.el-switch.is-checked) {
  box-shadow: 0 0 12px rgba(200, 85, 240, 0.4);
}

:deep(.el-switch .el-switch__action) {
  background-color: var(--bg-secondary);
}

/* InputNumber 暗色主题补充 */
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

/* Radio button 暗色主题补充 */
:deep(.el-radio-button__inner) {
  background-color: var(--bg-input);
  border-color: var(--border-color);
  color: var(--text-secondary);
}

:deep(.el-radio-button__original-radio:checked + .el-radio-button__inner) {
  background: var(--gradient-main);
  border-color: var(--accent-purple);
  color: #fff;
  box-shadow: 0 0 12px rgba(200, 85, 240, 0.3);
}

:deep(.el-checkbox-button__inner) {
  background-color: var(--bg-input);
  border-color: var(--border-color);
  color: var(--text-secondary);
}

:deep(.el-checkbox-button.is-checked .el-checkbox-button__inner) {
  background: var(--gradient-main);
  border-color: var(--accent-purple);
  color: #fff;
  box-shadow: 0 0 12px rgba(200, 85, 240, 0.3);
}
</style>
