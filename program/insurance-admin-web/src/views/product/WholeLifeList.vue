<template>
  <div class="product-list-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>增额终身寿险管理</span>
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>新增产品
          </el-button>
          <el-button type="success" @click="$router.push('/product/whole-life/rate-import?type=2')">
            <el-icon><Upload /></el-icon>导入数据
          </el-button>
        </div>
      </template>

      <el-form :model="queryForm" inline class="search-form">
        <el-form-item label="关键词">
          <el-input v-model="queryForm.keyword" placeholder="产品名称" clearable />
        </el-form-item>
        <el-form-item label="保险公司">
          <el-select v-model="queryForm.companyId" placeholder="全部" clearable style="width: 160px">
            <el-option
              v-for="company in companyList"
              :key="company.companyId"
              :label="company.companyName"
              :value="company.companyId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="销售状态">
          <el-select v-model="queryForm.saleStatus" placeholder="全部" clearable style="width: 120px">
            <el-option label="在售" :value="1" />
            <el-option label="停售" :value="0" />
          </el-select>
        </el-form-item>
        <el-form-item label="系统状态">
          <el-select v-model="queryForm.systemStatus" placeholder="全部" clearable style="width: 120px">
            <el-option label="上架" :value="1" />
            <el-option label="下架" :value="0" />
          </el-select>
        </el-form-item>
        <el-form-item label="维护状态">
          <el-select v-model="queryForm.maintenanceStatus" placeholder="全部" clearable style="width: 120px">
            <el-option label="解析中" :value="0" />
            <el-option label="待人工确认" :value="1" />
            <el-option label="已确认" :value="2" />
            <el-option label="下线" :value="3" />
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
        v-model:page="queryForm.pageNum"
        v-model:size="queryForm.pageSize"
        @page-change="fetchData"
      >
        <el-table-column type="index" width="50" />
        <el-table-column prop="productName" label="产品名称" min-width="180" show-overflow-tooltip>
          <template #default="{ row }">
            <el-link type="primary" @click.stop="handleView(row)">{{ row.productName }}</el-link>
          </template>
        </el-table-column>
        <el-table-column prop="companyName" label="保险公司" width="140" />
        <el-table-column prop="productTypeDesc" label="产品类型" width="120" />
        <el-table-column label="投保年龄" width="120">
          <template #default="{ row }">
            {{ row.minAge ?? '-' }} - {{ row.maxAge ?? '-' }} 岁
          </template>
        </el-table-column>
        <el-table-column label="缴费年限" width="140">
          <template #default="{ row }">
            {{ formatPaymentYears(row.paymentYears) }}
          </template>
        </el-table-column>
        <el-table-column label="销售状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.saleStatus === 1 ? 'success' : 'info'" size="small">
              {{ row.saleStatus === 1 ? '在售' : '已停售' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="系统状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.systemStatus === 1 ? 'success' : 'danger'" size="small">
              {{ row.systemStatus === 1 ? '上架' : '下架' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="维护状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.maintenanceStatus === 2 ? 'success' : row.maintenanceStatus === 1 ? 'warning' : 'info'" size="small">
              {{ row.maintenanceStatus === 0 ? '解析中' : row.maintenanceStatus === 1 ? '待确认' : row.maintenanceStatus === 2 ? '已确认' : '下线' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="160" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" @click="handleView(row)">详情</el-button>
            <el-button link type="primary" @click="handleEdit(row)">编辑</el-button>
            <el-button link type="danger" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </DataTable>
    </el-card>

    <!-- 产品详情/编辑抽屉 -->
    <el-drawer
      v-model="drawerVisible"
      :title="drawerTitle"
      size="720px"
      :destroy-on-close="true"
    >
      <div v-loading="drawerLoading" class="drawer-content">
        <el-form
          ref="editFormRef"
          :model="editForm"
          :rules="editRules"
          label-width="120px"
          :disabled="!isEditMode"
        >
          <el-form-item label="产品ID">
            <el-input v-model="editForm.productId" disabled />
          </el-form-item>
          <el-form-item label="产品名称" prop="productName">
            <el-input v-model="editForm.productName" placeholder="请输入产品名称" />
          </el-form-item>
          <el-form-item label="产品编码" prop="productCode">
            <el-input v-model="editForm.productCode" placeholder="请输入产品编码" />
          </el-form-item>
          <el-form-item label="保险公司" prop="companyId">
            <el-select v-model="editForm.companyId" placeholder="请选择保险公司" style="width: 100%">
              <el-option
                v-for="company in companyList"
                :key="company.companyId"
                :label="company.companyName"
                :value="company.companyId"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="产品类型">
            <el-input v-model="editForm.productTypeDesc" disabled />
          </el-form-item>
          <el-form-item label="最小投保年龄" prop="minAge">
            <el-input-number v-model="editForm.minAge" :min="0" :max="100" style="width: 100%" />
          </el-form-item>
          <el-form-item label="最大投保年龄" prop="maxAge">
            <el-input-number v-model="editForm.maxAge" :min="0" :max="100" style="width: 100%" />
          </el-form-item>
          <el-form-item label="缴费年限" prop="paymentYears">
            <el-input v-model="editForm.paymentYears" placeholder='如：["趸交","3年","5年","10年"]' />
          </el-form-item>
          <el-form-item label="销售状态" prop="saleStatus">
            <el-radio-group v-model="editForm.saleStatus">
              <el-radio :label="1">在售</el-radio>
              <el-radio :label="0">停售</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="系统状态" prop="systemStatus">
            <el-radio-group v-model="editForm.systemStatus">
              <el-radio :label="1">上架</el-radio>
              <el-radio :label="0">下架</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="维护状态" prop="maintenanceStatus">
            <el-radio-group v-model="editForm.maintenanceStatus">
              <el-radio :label="0">解析中</el-radio>
              <el-radio :label="1">待人工确认</el-radio>
              <el-radio :label="2">已确认</el-radio>
              <el-radio :label="3">下线</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-form>

        <div class="drawer-actions">
          <template v-if="!isEditMode">
            <el-button type="primary" @click="switchToEdit">编辑</el-button>
            <el-button @click="drawerVisible = false">关闭</el-button>
          </template>
          <template v-else>
            <el-button type="primary" @click="handleSave">保存</el-button>
            <el-button @click="isEditMode = false">取消</el-button>
          </template>
        </div>
      </div>
    </el-drawer>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Upload } from '@element-plus/icons-vue'
import DataTable from '@/components/common/DataTable.vue'
import { getProductList, updateProduct, deleteProduct } from '@/api/product'
import { getCompanyList } from '@/api/company'
import type { Product, ProductQuery } from '@/api/product'
import type { Company } from '@/api/company'

const router = useRouter()
const loading = ref(false)
const tableData = ref<Product[]>([])
const total = ref(0)
const companyList = ref<Company[]>([])

const drawerVisible = ref(false)
const drawerLoading = ref(false)
const isEditMode = ref(false)
const drawerTitle = ref('产品详情')
const editFormRef = ref()

const editForm = reactive({
  productId: 0,
  productName: '',
  productCode: '',
  companyId: undefined as number | undefined,
  productTypeDesc: '',
  minAge: undefined as number | undefined,
  maxAge: undefined as number | undefined,
  paymentYears: '',
  saleStatus: 1,
  systemStatus: 1
})

const editRules = {
  productName: [{ required: true, message: '请输入产品名称', trigger: 'blur' }],
  companyId: [{ required: true, message: '请选择保险公司', trigger: 'change' }]
}

const queryForm = reactive<ProductQuery>({
  pageNum: 1,
  pageSize: 10,
  keyword: '',
  companyId: undefined,
  saleStatus: undefined,
  systemStatus: undefined,
  maintenanceStatus: undefined
})

async function fetchData() {
  loading.value = true
  try {
    const res = await getProductList({ ...queryForm, productType: 2 })
    tableData.value = res.list
    total.value = res.total
  } finally {
    loading.value = false
  }
}

function handleSearch() { queryForm.pageNum = 1; fetchData() }
function handleReset() {
  queryForm.keyword = ''
  queryForm.companyId = undefined
  queryForm.saleStatus = undefined
  queryForm.systemStatus = undefined
  queryForm.maintenanceStatus = undefined
  queryForm.pageNum = 1
  fetchData()
}
function handleAdd() { router.push('/product/whole-life/form') }

function handleView(row: Product) {
  isEditMode.value = false
  drawerTitle.value = '产品详情'
  fillForm(row)
  drawerVisible.value = true
}

function handleEdit(row: Product) {
  isEditMode.value = true
  drawerTitle.value = '编辑产品'
  fillForm(row)
  drawerVisible.value = true
}

function switchToEdit() {
  isEditMode.value = true
  drawerTitle.value = '编辑产品'
}

function fillForm(row: Product) {
  Object.assign(editForm, {
    productId: row.productId,
    productName: row.productName || '',
    productCode: row.productCode || '',
    companyId: row.companyId,
    productTypeDesc: row.productTypeDesc || '',
    minAge: row.minAge,
    maxAge: row.maxAge,
    paymentYears: row.paymentYears || '',
    saleStatus: row.saleStatus ?? 1,
    systemStatus: row.systemStatus ?? 1
  })
}

async function handleSave() {
  if (!editFormRef.value) return
  try {
    await editFormRef.value.validate()
    await updateProduct(editForm.productId, {
      name: editForm.productName,
      productCode: editForm.productCode,
      companyId: editForm.companyId!,
      category: 'whole_life',
      subCategory: '',
      premium: 0,
      coverage: 0,
      term: '',
      paymentPeriod: editForm.paymentYears,
      description: '',
      highlights: [],
      responsibilities: [],
      status: editForm.saleStatus,
      displayStatus: editForm.systemStatus,
      sortOrder: 0,
      productType: 2,
      saleStatus: editForm.saleStatus,
      systemStatus: editForm.systemStatus,
      paymentYears: editForm.paymentYears,
      minAge: editForm.minAge,
      maxAge: editForm.maxAge
    } as any)
    ElMessage.success('保存成功')
    drawerVisible.value = false
    fetchData()
  } catch (e: any) {
    if (e?.message) ElMessage.error(e.message)
  }
}

function formatPaymentYears(paymentYears: string | undefined | null): string {
  if (!paymentYears) return '-'
  try {
    const years = JSON.parse(paymentYears)
    if (Array.isArray(years) && years.length > 0) {
      const formatted = years.map((y: string | number) => {
        const v = String(y).trim()
        const numMatch = v.match(/^(\d+)/)
        if (numMatch) {
          const num = parseInt(numMatch[1])
          return num === 1 ? '趸交' : `${num}`
        }
        if (v === '趸交' || v === '趸') return '趸交'
        return v
      })
      return formatted.join('/') + '年'
    }
  } catch { }
  return paymentYears
}

async function handleDelete(row: Product) {
  try {
    await ElMessageBox.confirm(`确认删除产品 "${row.productName}" 吗？`, '提示', { type: 'warning' })
    await deleteProduct(row.productId)
    ElMessage.success('删除成功')
    fetchData()
  } catch { }
}

async function loadCompanies() {
  try {
    const res = await getCompanyList({ page: 1, size: 999 })
    companyList.value = res.list
  } catch {
    companyList.value = []
  }
}

onMounted(() => {
  loadCompanies()
  fetchData()
})
</script>

<style scoped>
.card-header { display: flex; justify-content: space-between; align-items: center; }
.search-form { margin-bottom: 16px; }
.drawer-content { padding: 0 8px; }
.drawer-actions { margin-top: 24px; display: flex; justify-content: center; gap: 16px; }
</style>
