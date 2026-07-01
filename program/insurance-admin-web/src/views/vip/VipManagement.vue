<template>
  <div class="vip-management-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>VIP会员管理</span>
        </div>
      </template>

      <el-form :model="queryForm" inline class="search-form">
        <el-form-item label="关键词">
          <el-input v-model="queryForm.keyword" placeholder="用户名/昵称" clearable />
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
            <el-option label="正常" :value="1" />
            <el-option label="已过期" :value="0" />
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
        <el-table-column prop="username" label="用户名" min-width="140" show-overflow-tooltip />
        <el-table-column prop="nickname" label="昵称" min-width="140" show-overflow-tooltip />
        <el-table-column prop="vipLevelName" label="会员等级" width="120">
          <template #default="{ row }">
            <el-tag :type="getVipLevelType(row.vipLevel)">
              {{ row.vipLevelName }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="expireTime" label="过期时间" width="170" />
        <el-table-column prop="totalUsage" label="使用次数" width="100" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'info'">
              {{ row.status === 1 ? '正常' : '已过期' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="开通时间" width="170" />
        <el-table-column label="操作" width="220" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" @click="handleExtend(row)">延长会员</el-button>
            <el-button link type="danger" @click="handleCancel(row)">取消会员</el-button>
          </template>
        </el-table-column>
      </DataTable>
    </el-card>

    <!-- 延长会员弹窗 -->
    <el-dialog v-model="extendDialogVisible" title="延长会员" width="400px">
      <el-form :model="extendForm" label-width="100px">
        <el-form-item label="当前用户">
          <span>{{ currentRow?.username }}</span>
        </el-form-item>
        <el-form-item label="当前等级">
          <span>{{ currentRow?.vipLevelName }}</span>
        </el-form-item>
        <el-form-item label="延长天数" prop="days">
          <el-input-number v-model="extendForm.days" :min="1" :max="365" style="width: 100%" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="extendDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="extendLoading" @click="confirmExtend">确认</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import DataTable from '@/components/common/DataTable.vue'
import { getVipUserList, extendVip, updateVipStatus } from '@/api/vip'
import type { VipUser, VipQuery } from '@/api/vip'

const loading = ref(false)
const tableData = ref<VipUser[]>([])
const total = ref(0)

const queryForm = reactive<VipQuery>({
  page: 1,
  size: 10,
  keyword: '',
  vipLevel: undefined,
  status: undefined
})

const extendDialogVisible = ref(false)
const extendLoading = ref(false)
const currentRow = ref<VipUser | null>(null)
const extendForm = reactive({
  days: 30
})

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
    const res = await getVipUserList(queryForm)
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

function handleExtend(row: VipUser) {
  currentRow.value = row
  extendForm.days = 30
  extendDialogVisible.value = true
}

async function confirmExtend() {
  if (!currentRow.value) return
  extendLoading.value = true
  try {
    await extendVip(currentRow.value.id, extendForm.days)
    ElMessage.success('会员延长成功')
    extendDialogVisible.value = false
    fetchData()
  } finally {
    extendLoading.value = false
  }
}

async function handleCancel(row: VipUser) {
  try {
    await ElMessageBox.confirm(
      `确认取消用户 "${row.username}" 的会员资格吗？取消后该用户将失去所有VIP权益。`,
      '提示',
      { type: 'warning' }
    )
    await updateVipStatus(row.id, 0)
    ElMessage.success('会员已取消')
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
