<template>
  <div class="base-table-wrapper">
    <el-table
      v-bind="$attrs"
      :data="data"
      :loading="loading"
      :stripe="stripe"
      :border="border"
      :size="size"
      :header-cell-style="headerCellStyle"
      :cell-style="cellStyle"
      @selection-change="handleSelectionChange"
      @sort-change="handleSortChange"
    >
      <el-table-column
        v-if="showSelection"
        type="selection"
        width="55"
        align="center"
      />
      <el-table-column
        v-if="showIndex"
        type="index"
        :index="indexMethod"
        width="60"
        align="center"
        label="序号"
      />
      <slot />
      <template #empty>
        <el-empty :description="emptyText" />
      </template>
    </el-table>
  </div>
</template>

<script setup lang="ts">
import type { CSSProperties } from 'vue'

interface Props {
  data: Record<string, unknown>[]
  loading?: boolean
  stripe?: boolean
  border?: boolean
  size?: 'large' | 'default' | 'small'
  showSelection?: boolean
  showIndex?: boolean
  emptyText?: string
  page?: number
  pageSize?: number
}

const props = withDefaults(defineProps<Props>(), {
  loading: false,
  stripe: true,
  border: true,
  size: 'default',
  showSelection: false,
  showIndex: true,
  emptyText: '暂无数据',
  page: 1,
  pageSize: 10
})

const emit = defineEmits<{
  selectionChange: [selection: Record<string, unknown>[]]
  sortChange: [data: { column: any; prop: string | null; order: string | null }]
}>()

function indexMethod(index: number): number {
  return (props.page - 1) * props.pageSize + index + 1
}

function handleSelectionChange(selection: Record<string, unknown>[]) {
  emit('selectionChange', selection)
}

function handleSortChange(data: { column: any; prop: string | null; order: string | null }) {
  emit('sortChange', data)
}

const headerCellStyle = (): CSSProperties => ({
  backgroundColor: '#f5f7fa',
  color: '#303133',
  fontWeight: 600
})

const cellStyle = (): CSSProperties => ({
  padding: '12px 0'
})
</script>

<style scoped>
.base-table-wrapper {
  width: 100%;
}
</style>
