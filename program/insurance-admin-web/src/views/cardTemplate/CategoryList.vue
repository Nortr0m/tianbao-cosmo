<template>
  <div class="category-list-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>分类管理</span>
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>新增分类
          </el-button>
        </div>
      </template>

      <el-form :model="queryForm" inline class="search-form">
        <el-form-item label="关键词">
          <el-input v-model="queryForm.keyword" placeholder="分类名称" clearable />
        </el-form-item>
        <el-form-item label="分类编码">
          <el-input v-model="queryForm.categoryCode" placeholder="请输入分类编码" clearable style="width: 150px" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryForm.isActive" placeholder="全部" clearable style="width: 120px">
            <el-option label="启用" :value="1" />
            <el-option label="禁用" :value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <DataTable
        :data="tableData"
        :loading="loading"
        :total="total"
        v-model:page="currentPage"
        v-model:size="pageSize"
        @page-change="fetchData"
      >
        <el-table-column prop="categoryCode" label="分类编码" width="140" />
        <el-table-column prop="categoryName" label="分类名称" min-width="160" show-overflow-tooltip />
        <el-table-column label="分类图标" width="100">
          <template #default="{ row }">
            <el-image
              v-if="row.categoryIcon"
              :src="row.categoryIcon"
              style="width: 40px; height: 40px; border-radius: 4px"
              fit="cover"
              :preview-src-list="[row.categoryIcon]"
            />
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column prop="sortOrder" label="排序" width="80" />
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.isActive === 1 ? 'success' : 'info'" size="small">
              {{ row.isActive === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" width="180" />
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" @click="handleEdit(row)">编辑</el-button>
            <el-button link type="danger" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </DataTable>
    </el-card>

    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑分类' : '新增分类'" width="500px">
      <el-form ref="dialogFormRef" :model="dialogForm" :rules="dialogRules" label-width="100px">
        <el-form-item label="分类编码" prop="categoryCode">
          <el-input v-model="dialogForm.categoryCode" placeholder="请输入分类编码" :disabled="isEdit" />
        </el-form-item>
        <el-form-item label="分类名称" prop="categoryName">
          <el-input v-model="dialogForm.categoryName" placeholder="请输入分类名称" />
        </el-form-item>
        <el-form-item label="分类图标">
          <el-upload
            class="icon-uploader"
            action="#"
            :auto-upload="false"
            :show-file-list="false"
            :on-change="handleIconChange"
          >
            <img v-if="dialogForm.categoryIcon" :src="dialogForm.categoryIcon" class="icon-image" />
            <el-icon v-else class="icon-uploader-icon"><Plus /></el-icon>
          </el-upload>
          <div class="upload-tip">建议尺寸 64x64，支持 JPG、PNG 格式</div>
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="dialogForm.sortOrder" :min="0" style="width: 100%" />
        </el-form-item>
        <el-form-item label="状态">
          <el-switch
            v-model="dialogForm.isActive"
            :active-value="1"
            :inactive-value="0"
            active-text="启用"
            inactive-text="禁用"
          />
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
  getCategoryList,
  createCategory,
  updateCategory,
  deleteCategory,
} from '@/api/cardCategory'
import type { CardCategory, CardCategoryForm, CardCategoryQueryParams } from '@/api/cardCategory'
import type { FormInstance, FormRules, UploadFile } from 'element-plus'

const loading = ref(false)
const tableData = ref<CardCategory[]>([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)

const queryForm = reactive<CardCategoryQueryParams>({
  keyword: '',
  categoryCode: undefined,
  isActive: undefined,
})

const dialogVisible = ref(false)
const dialogSubmitting = ref(false)
const isEdit = ref(false)
const dialogFormRef = ref<FormInstance>()
const editingId = ref<number | null>(null)

const dialogForm = reactive<CardCategoryForm>({
  categoryCode: '',
  categoryName: '',
  categoryIcon: '',
  sortOrder: 0,
  isActive: 1,
})

const dialogRules: FormRules = {
  categoryCode: [{ required: true, message: '请输入分类编码', trigger: 'blur' }],
  categoryName: [{ required: true, message: '请输入分类名称', trigger: 'blur' }],
}

async function fetchData() {
  loading.value = true
  try {
    const params: CardCategoryQueryParams = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      keyword: queryForm.keyword || undefined,
      categoryCode: queryForm.categoryCode || undefined,
      isActive: queryForm.isActive,
    }
    const res = await getCategoryList(params)
    tableData.value = res.list
    total.value = res.total
  } finally {
    loading.value = false
  }
}

function handleSearch() {
  currentPage.value = 1
  fetchData()
}

function handleReset() {
  queryForm.keyword = ''
  queryForm.categoryCode = undefined
  queryForm.isActive = undefined
  currentPage.value = 1
  fetchData()
}

function handleAdd() {
  isEdit.value = false
  editingId.value = null
  Object.assign(dialogForm, {
    categoryCode: '',
    categoryName: '',
    categoryIcon: '',
    sortOrder: 0,
    isActive: 1,
  })
  dialogVisible.value = true
}

function handleEdit(row: CardCategory) {
  isEdit.value = true
  editingId.value = row.categoryId
  Object.assign(dialogForm, {
    categoryCode: row.categoryCode,
    categoryName: row.categoryName,
    categoryIcon: row.categoryIcon,
    sortOrder: row.sortOrder,
    isActive: row.isActive,
  })
  dialogVisible.value = true
}

async function handleDelete(row: CardCategory) {
  try {
    await ElMessageBox.confirm(`确认删除分类 "${row.categoryName}" 吗？`, '提示', { type: 'warning' })
    await deleteCategory(row.categoryId)
    ElMessage.success('删除成功')
    fetchData()
  } catch {
    // 用户取消或请求失败
  }
}

async function handleIconChange(file: UploadFile) {
  const raw = file.raw
  if (!raw) return
  // 简单的本地预览
  const reader = new FileReader()
  reader.onload = (e) => {
    dialogForm.categoryIcon = e.target?.result as string
  }
  reader.readAsDataURL(raw)
  ElMessage.info('图标已选择，保存后生效')
}

async function handleDialogSubmit() {
  if (!dialogFormRef.value) return
  await dialogFormRef.value.validate(async (valid) => {
    if (!valid) return
    dialogSubmitting.value = true
    try {
      const submitData: CardCategoryForm = {
        ...dialogForm,
      }
      if (isEdit.value && editingId.value) {
        // 编辑时不提交 categoryCode
        const { categoryCode, ...updateData } = submitData
        await updateCategory(editingId.value, updateData)
        ElMessage.success('更新成功')
      } else {
        await createCategory(submitData)
        ElMessage.success('创建成功')
      }
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

.icon-uploader {
  border: 1px dashed var(--el-border-color);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: var(--el-transition-duration-fast);
  width: 80px;
  height: 80px;
}

.icon-uploader:hover {
  border-color: var(--el-color-primary);
}

.icon-uploader-icon {
  font-size: 24px;
  color: #8c939d;
  width: 80px;
  height: 80px;
  text-align: center;
  display: flex;
  align-items: center;
  justify-content: center;
}

.icon-image {
  width: 80px;
  height: 80px;
  display: block;
  object-fit: cover;
}

.upload-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 4px;
}
</style>
