<template>
  <div class="data-table-wrapper">
    <div v-if="showToolbar" class="table-toolbar">
      <div class="toolbar-left">
        <slot name="toolbar-left" />
      </div>
      <div class="toolbar-right">
        <slot name="toolbar-right" />
      </div>
    </div>

    <el-table
      v-bind="$attrs"
      :data="data"
      v-loading="loading"
      @selection-change="handleSelectionChange"
      @sort-change="handleSortChange"
    >
      <el-table-column v-if="showSelection" type="selection" width="55" />
      <el-table-column v-if="showIndex" type="index" width="60" label="序号" />

      <slot />

      <template #empty>
        <el-empty description="暂无数据" />
      </template>
    </el-table>

    <div v-if="showPagination && total > 0" class="table-pagination">
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="pageSizes"
        :total="total"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  data: any[]
  loading?: boolean
  total?: number
  page?: number
  size?: number
  pageSizes?: number[]
  showPagination?: boolean
  showSelection?: boolean
  showIndex?: boolean
  showToolbar?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  loading: false,
  total: 0,
  page: 1,
  size: 10,
  pageSizes: () => [10, 20, 50, 100],
  showPagination: true,
  showSelection: false,
  showIndex: true,
  showToolbar: true
})

const emit = defineEmits<{
  (e: 'update:page', page: number): void
  (e: 'update:size', size: number): void
  (e: 'page-change', page: number, size: number): void
  (e: 'selection-change', selection: any[]): void
  (e: 'sort-change', sort: { prop: string; order: string | null }): void
}>()

const currentPage = computed({
  get: () => props.page,
  set: (val) => emit('update:page', val)
})

const pageSize = computed({
  get: () => props.size,
  set: (val) => emit('update:size', val)
})

function handleSizeChange(val: number) {
  emit('update:size', val)
  emit('page-change', currentPage.value, val)
}

function handleCurrentChange(val: number) {
  emit('update:page', val)
  emit('page-change', val, pageSize.value)
}

function handleSelectionChange(selection: any[]) {
  emit('selection-change', selection)
}

function handleSortChange(sort: any) {
  emit('sort-change', sort)
}
</script>

<style scoped>
.data-table-wrapper {
  background: #fff;
  border-radius: 8px;
  padding: 16px;
}

.table-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.toolbar-left,
.toolbar-right {
  display: flex;
  align-items: center;
  gap: 8px;
}

.table-pagination {
  display: flex;
  justify-content: flex-end;
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid #ebeef5;
}
</style>
