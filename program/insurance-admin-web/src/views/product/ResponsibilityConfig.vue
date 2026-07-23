<template>
  <div class="responsibility-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>责任模板管理</span>
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>新增模板
          </el-button>
        </div>
      </template>

      <el-form :model="queryForm" inline class="search-form">
        <el-form-item label="产品类型">
          <el-select v-model="queryForm.category" placeholder="全部" clearable style="width: 160px">
            <el-option label="重疾险" value="critical_illness" />
            <el-option label="增额终身寿险" value="whole_life" />
            <el-option label="年金险" value="annuity" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="fetchData">查询</el-button>
        </el-form-item>
      </el-form>

      <DataTable :data="tableData" :loading="loading" :show-pagination="false">
        <el-table-column prop="name" label="责任名称" min-width="180" />
        <el-table-column prop="description" label="责任描述" min-width="250" show-overflow-tooltip />
        <el-table-column prop="coverage" label="赔付额度" width="150" />
        <el-table-column prop="type" label="适用类型" width="140">
          <template #default="{ row }">
            <el-tag>{{ typeMap[row.type] || row.type }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="sortOrder" label="排序" width="80" />
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" @click="handleEdit(row)">编辑</el-button>
            <el-button link type="danger" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </DataTable>
    </el-card>

    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑责任模板' : '新增责任模板'" width="600px">
      <el-form ref="dialogFormRef" :model="dialogForm" :rules="dialogRules" label-width="100px">
        <el-form-item label="责任名称" prop="name">
          <el-input v-model="dialogForm.name" placeholder="请输入责任名称" />
        </el-form-item>
        <el-form-item label="责任描述" prop="description">
          <el-input v-model="dialogForm.description" type="textarea" :rows="3" placeholder="请输入责任描述" />
        </el-form-item>
        <el-form-item label="赔付额度" prop="coverage">
          <el-input v-model="dialogForm.coverage" placeholder="如：100%保额" />
        </el-form-item>
        <el-form-item label="适用类型" prop="type">
          <el-select v-model="dialogForm.type" placeholder="请选择适用类型" style="width: 100%">
            <el-option label="重疾险" value="critical_illness" />
            <el-option label="增额终身寿险" value="whole_life" />
            <el-option label="年金险" value="annuity" />
          </el-select>
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="dialogForm.sortOrder" :min="0" style="width: 100%" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="dialogSubmitting" @click="handleDialogSubmit">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import DataTable from '@/components/common/DataTable.vue'
import {
  getResponsibilityTemplates,
  saveResponsibilityTemplate,
  deleteResponsibilityTemplate
} from '@/api/product'
import type { Responsibility } from '@/api/product'
import type { FormInstance, FormRules } from 'element-plus'

const typeMap: Record<string, string> = {
  critical_illness: '重疾险',
  whole_life: '增额终身寿险',
  annuity: '年金险'
}

const loading = ref(false)
const tableData = ref<Responsibility[]>([])
const queryForm = reactive({ category: '' })

const dialogVisible = ref(false)
const dialogSubmitting = ref(false)
const isEdit = ref(false)
const dialogFormRef = ref<FormInstance>()

const dialogForm = reactive<Responsibility>({
  id: 0,
  name: '',
  description: '',
  coverage: '',
  type: 'critical_illness',
  sortOrder: 0
})

const dialogRules: FormRules = {
  name: [{ required: true, message: '请输入责任名称', trigger: 'blur' }],
  description: [{ required: true, message: '请输入责任描述', trigger: 'blur' }],
  type: [{ required: true, message: '请选择适用类型', trigger: 'change' }]
}

async function fetchData() {
  loading.value = true
  try {
    const res = await getResponsibilityTemplates(queryForm.category || 'critical_illness')
    tableData.value = res
  } finally {
    loading.value = false
  }
}

function handleAdd() {
  isEdit.value = false
  Object.assign(dialogForm, {
    id: 0,
    name: '',
    description: '',
    coverage: '',
    type: queryForm.category || 'critical_illness',
    sortOrder: 0
  })
  dialogVisible.value = true
}

function handleEdit(row: Responsibility) {
  isEdit.value = true
  Object.assign(dialogForm, { ...row })
  dialogVisible.value = true
}

async function handleDelete(row: Responsibility) {
  try {
    await ElMessageBox.confirm(`确认删除责任模板 "${row.name}" 吗？`, '提示', { type: 'warning' })
    await deleteResponsibilityTemplate(row.id)
    ElMessage.success('删除成功')
    fetchData()
  } catch {
    // 用户取消或请求失败
  }
}

async function handleDialogSubmit() {
  if (!dialogFormRef.value) return
  await dialogFormRef.value.validate(async (valid) => {
    if (!valid) return
    dialogSubmitting.value = true
    try {
      await saveResponsibilityTemplate({ ...dialogForm })
      ElMessage.success(isEdit.value ? '更新成功' : '创建成功')
      dialogVisible.value = false
      fetchData()
    } finally {
      dialogSubmitting.value = false
    }
  })
}

onMounted(() => {
  fetchData()
})
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-form {
  margin-bottom: 16px;
}
</style>
