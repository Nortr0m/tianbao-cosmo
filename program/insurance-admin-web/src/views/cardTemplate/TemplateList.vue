<template>
  <div class="template-list-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>背景图库管理</span>
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>新增模板
          </el-button>
        </div>
      </template>

      <el-form :model="queryForm" inline class="search-form">
        <el-form-item label="关键词">
          <el-input v-model="queryForm.keyword" placeholder="模板名称" clearable />
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="queryForm.categoryCode" placeholder="全部" clearable style="width: 130px">
            <el-option v-for="(label, key) in CATEGORY_LABEL_MAP" :key="key" :label="label" :value="key" />
          </el-select>
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
        <el-table-column prop="templateName" label="模板名称" min-width="160" show-overflow-tooltip />
        <el-table-column label="预览" width="100">
          <template #default="{ row }">
            <el-image
              v-if="row.backgroundUrl"
              :src="row.backgroundUrl"
              style="width: 60px; height: 60px; border-radius: 4px"
              fit="cover"
              :preview-src-list="[row.backgroundUrl]"
            />
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column label="分类" width="100">
          <template #default="{ row }">
            {{ CATEGORY_LABEL_MAP[row.categoryCode] || row.categoryCode || '-' }}
          </template>
        </el-table-column>
        <el-table-column label="标签" min-width="150">
          <template #default="{ row }">
            <template v-if="parsedTags(row.tags).length > 0">
              <el-tag v-for="tag in parsedTags(row.tags)" :key="tag" size="small" style="margin-right: 4px">
                {{ tag }}
              </el-tag>
            </template>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column prop="useCountTotal" label="使用次数" width="100" />
        <el-table-column label="推荐" width="80">
          <template #default="{ row }">
            <el-tag v-if="row.isRecommended === 1" type="danger" size="small">热门</el-tag>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-switch
              :model-value="row.isActive === 1"
              :active-value="true"
              :inactive-value="false"
              @change="(val: boolean) => handleStatusChange(row.templateId, val ? 1 : 0)"
            />
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

    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑模板' : '新增模板'" width="600px">
      <el-form ref="dialogFormRef" :model="dialogForm" :rules="dialogRules" label-width="100px">
        <el-form-item label="模板名称" prop="templateName">
          <el-input v-model="dialogForm.templateName" placeholder="请输入模板名称" />
        </el-form-item>
        <el-form-item label="分类" prop="categoryCode">
          <el-select v-model="dialogForm.categoryCode" placeholder="请选择分类" style="width: 100%">
            <el-option v-for="(label, key) in CATEGORY_LABEL_MAP" :key="key" :label="label" :value="key" />
          </el-select>
        </el-form-item>
        <el-form-item label="标签">
          <el-input v-model="dialogForm.tags" placeholder="多个标签用逗号分隔" />
        </el-form-item>
        <el-form-item label="默认标题">
          <el-input v-model="dialogForm.defaultTitle" placeholder="请输入默认标题" />
        </el-form-item>
        <el-form-item label="默认副标题">
          <el-input v-model="dialogForm.defaultSubtitle" placeholder="请输入默认副标题" />
        </el-form-item>
        <el-form-item label="背景图片">
          <el-upload
            class="avatar-uploader"
            action="#"
            :auto-upload="false"
            :show-file-list="false"
            :on-change="handleImageChange"
          >
            <img v-if="dialogForm.backgroundUrl" :src="dialogForm.backgroundUrl" class="avatar" />
            <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
          </el-upload>
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
  getTemplateList,
  createTemplate,
  updateTemplate,
  deleteTemplate,
  updateTemplateStatus,
  uploadTemplateImage,
  CATEGORY_LABEL_MAP,
} from '@/api/cardTemplate'
import type { CardTemplate, CardTemplateForm, TemplateQuery } from '@/api/cardTemplate'
import type { FormInstance, FormRules, UploadFile } from 'element-plus'

const loading = ref(false)
const tableData = ref<CardTemplate[]>([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)

const queryForm = reactive<TemplateQuery>({
  keyword: '',
  categoryCode: undefined,
  isActive: undefined,
})

const dialogVisible = ref(false)
const dialogSubmitting = ref(false)
const isEdit = ref(false)
const dialogFormRef = ref<FormInstance>()
const editingId = ref<number | null>(null)

const dialogForm = reactive<CardTemplateForm>({
  templateName: '',
  categoryCode: undefined,
  tags: '',
  defaultTitle: '',
  defaultSubtitle: '',
  backgroundUrl: '',
  sortOrder: 0,
  isActive: 1,
})

const dialogRules: FormRules = {
  templateName: [{ required: true, message: '请输入模板名称', trigger: 'blur' }],
  categoryCode: [{ required: true, message: '请选择分类', trigger: 'change' }],
}

function parsedTags(tags: string | undefined | null): string[] {
  if (!tags) return []
  try {
    const parsed = JSON.parse(tags)
    if (Array.isArray(parsed)) return parsed
    return []
  } catch {
    return tags.split(',').map((t: string) => t.trim()).filter(Boolean)
  }
}

async function fetchData() {
  loading.value = true
  try {
    const params: TemplateQuery = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      keyword: queryForm.keyword || undefined,
      categoryCode: queryForm.categoryCode,
      isActive: queryForm.isActive,
    }
    const res = await getTemplateList(params)
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
    templateName: '',
    categoryCode: undefined,
    tags: '',
    defaultTitle: '',
    defaultSubtitle: '',
    backgroundUrl: '',
    sortOrder: 0,
    isActive: 1,
  })
  dialogVisible.value = true
}

function handleEdit(row: CardTemplate) {
  isEdit.value = true
  editingId.value = row.templateId
  Object.assign(dialogForm, {
    templateName: row.templateName,
    categoryCode: row.categoryCode,
    tags: row.tags || '',
    defaultTitle: row.defaultTitle,
    defaultSubtitle: row.defaultSubtitle,
    backgroundUrl: row.backgroundUrl,
    sortOrder: row.sortOrder,
    isActive: row.isActive,
  })
  dialogVisible.value = true
}

async function handleStatusChange(id: number, status: number) {
  try {
    await updateTemplateStatus(id, status)
    ElMessage.success('状态更新成功')
  } catch {
    fetchData()
  }
}

async function handleDelete(row: CardTemplate) {
  try {
    await ElMessageBox.confirm(`确认删除模板 "${row.templateName}" 吗？`, '提示', { type: 'warning' })
    await deleteTemplate(row.templateId)
    ElMessage.success('删除成功')
    fetchData()
  } catch {
    // 用户取消或请求失败
  }
}

async function handleImageChange(file: UploadFile) {
  const raw = file.raw
  if (!raw) return
  try {
    const res = await uploadTemplateImage(raw)
    dialogForm.backgroundUrl = res.url || res.thumbnail
    ElMessage.success('上传成功')
  } catch {
    // 错误已在拦截器中处理
  }
}

async function handleDialogSubmit() {
  if (!dialogFormRef.value) return
  await dialogFormRef.value.validate(async (valid) => {
    if (!valid) return
    dialogSubmitting.value = true
    try {
      const submitData: CardTemplateForm = {
        ...dialogForm,
        tags: dialogForm.tags
          ? (Array.isArray(dialogForm.tags)
              ? JSON.stringify(dialogForm.tags)
              : /^\[/.test(dialogForm.tags)
                ? dialogForm.tags
                : JSON.stringify(dialogForm.tags.split(',').map((t: string) => t.trim()).filter(Boolean)))
          : '[]',
      }
      if (isEdit.value && editingId.value) {
        await updateTemplate(editingId.value, submitData)
        ElMessage.success('更新成功')
      } else {
        await createTemplate(submitData)
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

.avatar-uploader {
  border: 1px dashed var(--el-border-color);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: var(--el-transition-duration-fast);
  width: 178px;
  height: 178px;
}

.avatar-uploader:hover {
  border-color: var(--el-color-primary);
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 178px;
  height: 178px;
  text-align: center;
  display: flex;
  align-items: center;
  justify-content: center;
}

.avatar {
  width: 178px;
  height: 178px;
  display: block;
  object-fit: cover;
}
</style>