<template>
  <div class="redeem-code-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>兑换码管理</span>
          <el-button type="primary" @click="handleGenerate">
            <el-icon><Plus /></el-icon>批量生成
          </el-button>
        </div>
      </template>

      <el-form :model="queryForm" inline class="search-form">
        <el-form-item label="关键词">
          <el-input v-model="queryForm.keyword" placeholder="兑换码" clearable />
        </el-form-item>
        <el-form-item label="会员等级">
          <el-select v-model="queryForm.vipLevel" placeholder="全部" clearable style="width: 140px">
            <el-option label="普通会员" :value="1" />
            <el-option label="高级会员" :value="2" />
            <el-option label="至尊会员" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryForm.status" placeholder="全部" clearable style="width: 120px">
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
        v-model:page="queryForm.page"
        v-model:size="queryForm.size"
        @page-change="fetchData"
      >
        <el-table-column prop="code" label="兑换码" min-width="180" show-overflow-tooltip />
        <el-table-column prop="vipLevelName" label="会员等级" width="120">
          <template #default="{ row }">
            <el-tag :type="getVipLevelType(row.vipLevel)">
              {{ row.vipLevelName }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="durationDays" label="有效期天数" width="110" />
        <el-table-column prop="usedQuantity" label="使用情况" width="140">
          <template #default="{ row }">
            <span>{{ row.usedQuantity }} / {{ row.totalQuantity }}</span>
            <el-progress
              :percentage="Math.round((row.usedQuantity / row.totalQuantity) * 100)"
              :stroke-width="4"
              :show-text="false"
              style="width: 60px; display: inline-block; margin-left: 8px; vertical-align: middle"
            />
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-switch
              v-model="row.status"
              :active-value="1"
              :inactive-value="0"
              @change="(val: number) => handleStatusChange(row.id, val)"
            />
          </template>
        </el-table-column>
        <el-table-column prop="validStartTime" label="有效期开始" width="170" />
        <el-table-column prop="validEndTime" label="有效期结束" width="170" />
        <el-table-column prop="createTime" label="创建时间" width="170" />
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button link type="danger" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </DataTable>
    </el-card>

    <!-- 批量生成弹窗 -->
    <el-dialog v-model="generateDialogVisible" title="批量生成兑换码" width="500px">
      <el-form ref="generateFormRef" :model="generateForm" :rules="generateRules" label-width="120px">
        <el-form-item label="会员等级" prop="vipLevel">
          <el-select v-model="generateForm.vipLevel" placeholder="请选择会员等级" style="width: 100%">
            <el-option label="普通会员" :value="1" />
            <el-option label="高级会员" :value="2" />
            <el-option label="至尊会员" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="有效期天数" prop="durationDays">
          <el-input-number v-model="generateForm.durationDays" :min="1" :max="365" style="width: 100%" />
        </el-form-item>
        <el-form-item label="生成数量" prop="quantity">
          <el-input-number v-model="generateForm.quantity" :min="1" :max="1000" style="width: 100%" />
        </el-form-item>
        <el-form-item label="有效期范围" prop="validRange">
          <el-date-picker
            v-model="generateForm.validRange"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            value-format="YYYY-MM-DD HH:mm:ss"
            style="width: 100%"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="generateDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="generateLoading" @click="confirmGenerate">确认生成</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import DataTable from '@/components/common/DataTable.vue'
import { getRedeemCodeList, generateRedeemCodes, updateRedeemCodeStatus, deleteRedeemCode } from '@/api/vip'
import type { RedeemCode, RedeemCodeQuery, GenerateCodeParams } from '@/api/vip'
import type { FormInstance, FormRules } from 'element-plus'

const loading = ref(false)
const tableData = ref<RedeemCode[]>([])
const total = ref(0)

const queryForm = reactive<RedeemCodeQuery>({
  page: 1,
  size: 10,
  keyword: '',
  vipLevel: undefined,
  status: undefined
})

const generateDialogVisible = ref(false)
const generateLoading = ref(false)
const generateFormRef = ref<FormInstance>()

const generateForm = reactive({
  vipLevel: 1,
  durationDays: 30,
  quantity: 10,
  validRange: [] as string[]
})

const generateRules: FormRules = {
  vipLevel: [{ required: true, message: '请选择会员等级', trigger: 'change' }],
  durationDays: [{ required: true, message: '请输入有效期天数', trigger: 'blur' }],
  quantity: [{ required: true, message: '请输入生成数量', trigger: 'blur' }],
  validRange: [
    {
      required: true,
      message: '请选择有效期范围',
      trigger: 'change',
      validator: (_rule: any, value: string[]) => {
        return value && value.length === 2 && value[0] && value[1]
      }
    }
  ]
}

function getVipLevelType(level: number) {
  switch (level) {
    case 1:
      return ''
    case 2:
      return 'warning'
    case 3:
      return 'danger'
    default:
      return 'info'
  }
}

async function fetchData() {
  loading.value = true
  try {
    const res = await getRedeemCodeList(queryForm)
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
  queryForm.vipLevel = undefined
  queryForm.status = undefined
  queryForm.page = 1
  fetchData()
}

function handleGenerate() {
  generateForm.vipLevel = 1
  generateForm.durationDays = 30
  generateForm.quantity = 10
  generateForm.validRange = []
  generateDialogVisible.value = true
}

async function confirmGenerate() {
  if (!generateFormRef.value) return
  await generateFormRef.value.validate(async (valid) => {
    if (!valid) return
    generateLoading.value = true
    try {
      const params: GenerateCodeParams = {
        vipLevel: generateForm.vipLevel,
        durationDays: generateForm.durationDays,
        quantity: generateForm.quantity,
        validStartTime: generateForm.validRange[0],
        validEndTime: generateForm.validRange[1]
      }
      const codes = await generateRedeemCodes(params)
      ElMessage.success(`成功生成 ${codes.length} 个兑换码`)
      generateDialogVisible.value = false
      fetchData()
    } finally {
      generateLoading.value = false
    }
  })
}

async function handleStatusChange(id: number, status: number) {
  try {
    await updateRedeemCodeStatus(id, status)
    ElMessage.success('状态更新成功')
  } catch {
    fetchData()
  }
}

async function handleDelete(row: RedeemCode) {
  try {
    await ElMessageBox.confirm(`确认删除兑换码 "${row.code}" 吗？`, '提示', { type: 'warning' })
    await deleteRedeemCode(row.id)
    ElMessage.success('删除成功')
    fetchData()
  } catch {
    // 用户取消或请求失败
  }
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
