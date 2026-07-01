<template>
  <div class="company-list-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>保险公司列表</span>
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>新增保司
          </el-button>
        </div>
      </template>

      <el-form :model="queryForm" inline class="search-form">
        <el-form-item label="关键词">
          <el-input v-model="queryForm.keyword" placeholder="公司名称" clearable />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryForm.status" placeholder="全部" clearable style="width: 120px">
            <el-option label="正常" :value="1" />
            <el-option label="停用" :value="0" />
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
        v-model:page="queryForm.page"
        v-model:size="queryForm.size"
        @page-change="fetchData"
      >
        <el-table-column prop="companyName" label="公司名称" min-width="180" show-overflow-tooltip />
        <el-table-column prop="companyShortName" label="简称" width="120" />
        <el-table-column prop="logoUrl" label="Logo" width="80">
          <template #default="{ row }">
            <el-image v-if="row.logoUrl" :src="row.logoUrl" style="width: 40px; height: 40px" fit="contain" />
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column prop="officialWebsite" label="官网" min-width="180" show-overflow-tooltip />
        <el-table-column prop="servicePhone" label="客服电话" width="130" />
        <el-table-column label="成立年份" width="100">
          <template #default="{ row }">
            {{ row.establishedYear ? row.establishedYear + '年' : '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="registeredCapital" label="注册资本" width="120" />
        <el-table-column prop="cooperationStatus" label="状态" width="100">
          <template #default="{ row }">
            <el-switch
              :model-value="row.cooperationStatus === 1"
              :active-value="true"
              :inactive-value="false"
              @change="(val: boolean) => handleStatusChange(row.companyId, val ? 1 : 0)"
            />
          </template>
        </el-table-column>
        <el-table-column prop="sortOrder" label="排序" width="80" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" @click="handleEdit(row)">编辑</el-button>
            <el-button link type="primary" @click="handleViewDetail(row)">详情</el-button>
            <el-button link type="danger" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </DataTable>
    </el-card>

    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑保险公司' : '新增保险公司'" width="700px">
      <el-form ref="dialogFormRef" :model="dialogForm" :rules="dialogRules" label-width="100px">
        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="公司名称" prop="companyName">
              <el-input v-model="dialogForm.companyName" placeholder="请输入公司名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="公司简称" prop="companyShortName">
              <el-input v-model="dialogForm.companyShortName" placeholder="请输入公司简称" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="官网">
              <el-input v-model="dialogForm.officialWebsite" placeholder="请输入官网地址" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="客服电话">
              <el-input v-model="dialogForm.servicePhone" placeholder="请输入客服电话" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="成立年份">
              <el-input-number v-model="dialogForm.establishedYear" :min=0 style="width: 100%" placeholder="请输入成立年份" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="注册资本">
              <el-input v-model="dialogForm.registeredCapital" placeholder="如：100亿元" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="总部地址">
          <el-input v-model="dialogForm.headquarters" placeholder="请输入总部地址" />
        </el-form-item>
        <el-form-item label="公司介绍">
          <el-input v-model="dialogForm.introduction" type="textarea" :rows="3" placeholder="请输入公司介绍" />
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
  getCompanyList,
  createCompany,
  updateCompany,
  deleteCompany,
  updateCompanyStatus
} from '@/api/company'
import type { Company, CompanyDetail, CompanyQuery } from '@/api/company'
import type { FormInstance, FormRules } from 'element-plus'

const loading = ref(false)
const tableData = ref<Company[]>([])
const total = ref(0)

const queryForm = reactive<CompanyQuery>({
  page: 1,
  size: 10,
  keyword: '',
  status: undefined
})

const dialogVisible = ref(false)
const dialogSubmitting = ref(false)
const isEdit = ref(false)
const dialogFormRef = ref<FormInstance>()

const dialogForm = reactive<Partial<CompanyDetail>>({
  companyName: '',
  companyShortName: '',
  officialWebsite: '',
  servicePhone: '',
  establishedYear: undefined,
  registeredCapital: '',
  headquarters: '',
  introduction: '',
  sortOrder: 0
})

const dialogRules: FormRules = {
  companyName: [{ required: true, message: '请输入公司名称', trigger: 'blur' }],
  companyShortName: [{ required: true, message: '请输入公司简称', trigger: 'blur' }]
}

async function fetchData() {
  loading.value = true
  try {
    const res = await getCompanyList(queryForm)
    tableData.value = res.list
    total.value = res.total
  } finally {
    loading.value = false
  }
}

function handleSearch() {
  queryForm.page = 1
  fetchData()
}

function handleReset() {
  queryForm.keyword = ''
  queryForm.status = undefined
  queryForm.page = 1
  fetchData()
}

function handleAdd() {
  isEdit.value = false
  Object.assign(dialogForm, {
    companyName: '',
    companyShortName: '',
    officialWebsite: '',
    servicePhone: '',
    establishedYear: undefined,
    registeredCapital: '',
    headquarters: '',
    introduction: '',
    sortOrder: 0
  })
  dialogVisible.value = true
}

function handleEdit(row: Company) {
  isEdit.value = true
  Object.assign(dialogForm, { ...row })
  dialogVisible.value = true
}

function handleViewDetail(row: Company) {
  ElMessage.info(`查看详情: ${row.companyName}`)
}

async function handleStatusChange(companyId: number, status: number) {
  try {
    await updateCompanyStatus(companyId, status)
    ElMessage.success('状态更新成功')
  } catch {
    fetchData()
  }
}

async function handleDelete(row: Company) {
  try {
    await ElMessageBox.confirm(`确认删除保险公司 "${row.companyName}" 吗？`, '提示', { type: 'warning' })
    await deleteCompany(row.companyId)
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
      if (isEdit.value && dialogForm.companyId) {
        await updateCompany(dialogForm.companyId, dialogForm)
        ElMessage.success('更新成功')
      } else {
        await createCompany(dialogForm)
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
</style>