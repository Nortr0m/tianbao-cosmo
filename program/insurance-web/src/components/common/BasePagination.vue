<template>
  <div class="base-pagination-wrapper">
    <el-pagination
      v-model:current-page="currentPage"
      v-model:page-size="currentPageSize"
      :total="total"
      :page-sizes="pageSizes"
      :layout="layout"
      :background="background"
      :disabled="disabled"
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
    />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  modelValue: number
  pageSize: number
  total: number
  pageSizes?: number[]
  layout?: string
  background?: boolean
  disabled?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  pageSizes: () => [10, 20, 50, 100],
  layout: 'total, sizes, prev, pager, next, jumper',
  background: true,
  disabled: false
})

const emit = defineEmits<{
  'update:modelValue': [page: number]
  'update:pageSize': [pageSize: number]
  change: [page: number, pageSize: number]
}>()

const currentPage = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

const currentPageSize = computed({
  get: () => props.pageSize,
  set: (val) => emit('update:pageSize', val)
})

function handleSizeChange(size: number) {
  emit('update:pageSize', size)
  emit('change', 1, size)
}

function handleCurrentChange(page: number) {
  emit('update:modelValue', page)
  emit('change', page, props.pageSize)
}
</script>

<style scoped>
.base-pagination-wrapper {
  display: flex;
  justify-content: flex-end;
  padding: 16px 0;
}
</style>
