<template>
  <div class="base-search-wrapper">
    <el-form
      :model="model"
      :inline="inline"
      :label-width="labelWidth"
      class="search-form"
    >
      <slot />
      <el-form-item>
        <el-button type="primary" :icon="Search" @click="handleSearch">
          查询
        </el-button>
        <el-button :icon="Refresh" @click="handleReset">
          重置
        </el-button>
        <slot name="extra-actions" />
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup lang="ts">
import { Search, Refresh } from '@element-plus/icons-vue'

interface Props {
  model: Record<string, unknown>
  inline?: boolean
  labelWidth?: string
}

const props = withDefaults(defineProps<Props>(), {
  inline: true,
  labelWidth: '80px'
})

const emit = defineEmits<{
  search: [values: Record<string, unknown>]
  reset: []
}>()

function handleSearch() {
  emit('search', { ...props.model })
}

function handleReset() {
  emit('reset')
}
</script>

<style scoped>
.base-search-wrapper {
  padding: 16px;
  background-color: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  margin-bottom: 16px;
}

.search-form {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
}
</style>
