<template>
  <div class="rating-history-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>风险评级历史</span>
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>新增评级
          </el-button>
        </div>
      </template>

      <el-form :model="queryForm" inline class="search-form">
        <el-form-item label="保险公司">
          <el-select v-model="queryForm.companyId" placeholder="全部" clearable style="width: 200px">
            <el-option
              v-for="item in companyOptions"
              :key="item.companyId"
              :label="item.companyName"
              :value="item.companyId"
            />
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
        :show-pagination="false"
      >
        <el-table-column prop="companyName" label="保险公司" min-width="180" />
        <el-table-column prop="rating" label="风险评级" width="120">
          <template #default="{ row }">
            <el-tag :type="getRatingType(row.rating)">{{ row.rating }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="solvencyRatio" label="偿付能力充足率" width="140">
          <template #default="{ row }">
            {{ row.solvencyRatio }}%
          </template>
        </el-table-column>
        <el-table-column prop="assessmentDate" label="评估日期" width="120" />
        <el-table-column prop="assessor" label="评估人" width="120" />
        <el-table-column prop="remark" label="备注" min-width="200" show-overflow-tooltip />
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button link type="danger" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </DataTable>
    </el-card>

    <el-dialog v-model="dialogVisible" title="新增风险评级" width="600px">
      <el-form ref="dialogFormRef" :model="dialogForm" :rules="dialogRules" label-width="120px">
        <el-form-item label="保险公司" prop="companyId">
          <el-select v-model="dialogForm.companyId" placeholder="请选择保险公司" style="width: 100%">
            <el-option
              v-for="item in companyOptions"
              :key="item.companyId"
              :label="item.companyName"
              :value="item.companyId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="风险评级" prop="rating">
          <el-select v-model="dialogForm.rating" placeholder="请选择风险评级" style="width: 100%">
            <el-option label="A" value="A" />
            <el-option label="B" value="B" />
            <el-option label="C" value="C" />
            <el-option label="D" value="D" />
          </el-select>
        </el-form-item>
        <el-form-item label="偿付能力充足率" prop="solvencyRatio">
          <el-input-number v-model="dialogForm.solvencyRatio" :min="0" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="评估日期" prop="assessmentDate">
          <el-date-picker v-model="dialogForm.assessmentDate" type="date" placeholder="选择日期" style="width: 100%" value-format="YYYY-MM-DD" />
        </el-form-item>
        <el-form-item label="评估人" prop="assessor">
          <el-input v-model="dialogForm.assessor" placeholder="请输入评估人" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="dialogForm.remark" type="textarea" :rows="3" placeholder="请输入备注" />
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
import { getRatingHistory, addRatingHistory, deleteRatingHistory, getCompanyList } from '@/api/company'
import type { RatingHistoryItem, Company } from '@/api/company'
import type { FormInstance, FormRules } from 'element-plus'

const loading = ref(false)
const tableData = ref<RatingHistoryItem[]>([])
const companyOptions = ref<Company[]>([])

const queryForm = reactive({ companyId: undefined as number | undefined })

const dialogVisible = ref(false)
const dialogSubmitting = ref(false)
const dialogFormRef = ref<FormInstance>()

const dialogForm = reactive({
  companyId: undefined as number | undefined,
  rating: '',
  solvencyRatio: 0,
  assessmentDate: '',
  assessor: '',
  remark: ''
})

const dialogRules: FormRules = {
  companyId: [{ required: true, message: '请选择保险公司', trigger: 'change' }],
  rating: [{ required: true, message: '请选择风险评级', trigger: 'change' }],
  solvencyRatio: [{ required: true, message: '请输入偿付能力充足率', trigger: 'blur' }],
  assessmentDate: [{ required: true, message: '请选择评估日期', trigger: 'change' }],
  assessor: [{ required: true, message: '请输入评估人', trigger: 'blur' }]
}

function getRatingType(rating: string): string {
  const map: Record<string, string> = { A: 'success', B: 'warning', C: 'danger', D: 'info' }
  return map[rating] || 'info'
}

async function loadCompanies() {
  try {
    const res = await getCompanyList({ page: 1, size: 100 })
    companyOptions.value = res.list
  } catch {
    // 错误已在拦截器中处理
  }
}

async function fetchData() {
  loading.value = true
  try {
    const res = await getRatingHistory(queryForm.companyId)
    tableData.value = res
  } finally {
    loading.value = false
  }
}

function handleSearch() {
  fetchData()
}

function handleReset() {
  queryForm.companyId = undefined
  fetchData()
}

function handleAdd() {
  Object.assign(dialogForm, {
    companyId: undefined,
    rating: '',
    solvencyRatio: 0,
    assessmentDate: '',
    assessor: '',
    remark: ''
  })
  dialogVisible.value = true
}

async function handleDelete(row: RatingHistoryItem) {
  try {
    await ElMessageBox.confirm(`确认删除该评级记录吗？`, '提示', { type: 'warning' })
    await deleteRatingHistory(row.id)
    ElMessage.success('删除成功')
    fetchData()
  } catch {
    // 用户取消
  }
}

async function handleDialogSubmit() {
  if (!dialogFormRef.value) return
  await dialogFormRef.value.validate(async (valid) => {
    if (!valid) return
    dialogSubmitting.value = true
    try {
      await addRatingHistory({ ...dialogForm })
      ElMessage.success('新增成功')
      dialogVisible.value = false
      fetchData()
    } finally {
      dialogSubmitting.value = false
    }
  })
}

onMounted(() => {
  loadCompanies()
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
