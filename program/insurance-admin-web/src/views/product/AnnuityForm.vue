<template>
  <div class="product-form-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>{{ isEdit ? '编辑年金险' : '新增年金险' }}</span>
        </div>
      </template>

      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="140px"
        class="product-form"
      >
        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="产品名称" prop="name">
              <el-input v-model="form.name" placeholder="请输入产品名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="保险公司" prop="companyId">
              <el-select v-model="form.companyId" placeholder="请选择保险公司" style="width: 100%">
                <el-option label="平安保险" :value="1" />
                <el-option label="中国人寿" :value="2" />
                <el-option label="太平洋保险" :value="3" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="保费" prop="premium">
              <el-input-number v-model="form.premium" :min="0" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="保额" prop="coverage">
              <el-input-number v-model="form.coverage" :min="0" :precision="0" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="保障期限" prop="term">
              <el-input v-model="form.term" placeholder="如：终身、至80周岁" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="缴费期限" prop="paymentPeriod">
              <el-input v-model="form.paymentPeriod" placeholder="如：趸交、3年、5年、10年、20年" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-divider content-position="left">年金险特有配置</el-divider>

        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="领取起始年龄" prop="annuityStartAge">
              <el-select v-model="form.annuityStartAge" placeholder="请选择领取起始年龄" style="width: 100%">
                <el-option label="55周岁" :value="55" />
                <el-option label="60周岁" :value="60" />
                <el-option label="65周岁" :value="65" />
                <el-option label="70周岁" :value="70" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="保证领取期" prop="guaranteePeriod">
              <el-select v-model="form.guaranteePeriod" placeholder="请选择保证领取期" style="width: 100%">
                <el-option label="无保证领取" :value="0" />
                <el-option label="保证领取10年" :value="10" />
                <el-option label="保证领取15年" :value="15" />
                <el-option label="保证领取20年" :value="20" />
                <el-option label="保证领取25年" :value="25" />
                <el-option label="保证领取30年" :value="30" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="祝寿金年龄" prop="longevityBonusAge">
              <el-select v-model="form.longevityBonusAge" placeholder="请选择祝寿金年龄" style="width: 100%">
                <el-option label="无祝寿金" :value="0" />
                <el-option label="80周岁" :value="80" />
                <el-option label="88周岁" :value="88" />
                <el-option label="90周岁" :value="90" />
                <el-option label="100周岁" :value="100" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="祝寿金倍数" prop="longevityBonusMultiple">
              <el-input-number
                v-model="form.longevityBonusMultiple"
                :min="0"
                :max="10"
                :precision="1"
                style="width: 100%"
                placeholder="如：1倍、3倍、5倍保额"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="年金领取方式" prop="annuityPaymentMethod">
              <el-radio-group v-model="form.annuityPaymentMethod">
                <el-radio label="annual">年领</el-radio>
                <el-radio label="monthly">月领</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="月领折算比例" prop="monthlyConversionRate">
              <el-input-number
                v-model="form.monthlyConversionRate"
                :min="0"
                :max="1"
                :precision="3"
                style="width: 100%"
                placeholder="如：0.085 表示月领为年领的8.5%"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="是否含万能账户" prop="hasUniversalAccount">
              <el-switch v-model="form.hasUniversalAccount" :active-value="1" :inactive-value="0" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="万能账户保底利率" prop="guaranteedRate">
              <el-input-number
                v-model="form.guaranteedRate"
                :min="0"
                :max="10"
                :precision="2"
                style="width: 100%"
                placeholder="%"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="是否支持加保" prop="supportAdditionalPremium">
              <el-switch v-model="form.supportAdditionalPremium" :active-value="1" :inactive-value="0" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="是否支持减保" prop="supportReducedPremium">
              <el-switch v-model="form.supportReducedPremium" :active-value="1" :inactive-value="0" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="产品描述" prop="description">
          <el-input v-model="form.description" type="textarea" :rows="4" placeholder="请输入产品描述" />
        </el-form-item>

        <el-form-item label="产品亮点">
          <div v-for="(item, index) in form.highlights" :key="index" class="dynamic-item">
            <el-input v-model="form.highlights[index]" placeholder="亮点描述" style="width: 400px" />
            <el-button link type="danger" @click="removeHighlight(index)">
              <el-icon><Delete /></el-icon>
            </el-button>
          </div>
          <el-button link type="primary" @click="addHighlight">
            <el-icon><Plus /></el-icon>添加亮点
          </el-button>
        </el-form-item>

        <el-form-item label="保障责任">
          <el-table :data="form.responsibilities" border size="small" style="width: 100%">
            <el-table-column prop="name" label="责任名称" min-width="150">
              <template #default="{ $index }">
                <el-input v-model="form.responsibilities[$index].name" size="small" />
              </template>
            </el-table-column>
            <el-table-column prop="description" label="责任描述" min-width="200">
              <template #default="{ $index }">
                <el-input v-model="form.responsibilities[$index].description" size="small" />
              </template>
            </el-table-column>
            <el-table-column prop="coverage" label="赔付额度" width="150">
              <template #default="{ $index }">
                <el-input v-model="form.responsibilities[$index].coverage" size="small" />
              </template>
            </el-table-column>
            <el-table-column label="操作" width="80" fixed="right">
              <template #default="{ $index }">
                <el-button link type="danger" size="small" @click="removeResponsibility($index)">
                  删除
                </el-button>
              </template>
            </el-table-column>
          </el-table>
          <el-button link type="primary" class="mt-8" @click="addResponsibility">
            <el-icon><Plus /></el-icon>添加责任
          </el-button>
        </el-form-item>

        <el-row :gutter="24">
          <el-col :span="8">
            <el-form-item label="销售状态">
              <el-radio-group v-model="form.status">
                <el-radio :label="1">上架</el-radio>
                <el-radio :label="0">下架</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="展示状态">
              <el-radio-group v-model="form.displayStatus">
                <el-radio :label="1">展示</el-radio>
                <el-radio :label="0">隐藏</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="排序">
              <el-input-number v-model="form.sortOrder" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item>
          <el-button type="primary" :loading="submitting" @click="handleSubmit">保存</el-button>
          <el-button @click="$router.back()">返回</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Plus, Delete } from '@element-plus/icons-vue'
import { createProduct, updateProduct, getProductDetail } from '@/api/product'
import type { ProductFormData, Responsibility } from '@/api/product'
import type { FormInstance, FormRules } from 'element-plus'

interface AnnuityFormData extends ProductFormData {
  annuityStartAge: number
  guaranteePeriod: number
  longevityBonusAge: number
  longevityBonusMultiple: number
  annuityPaymentMethod: string
  monthlyConversionRate: number
  hasUniversalAccount: number
  guaranteedRate: number
  supportAdditionalPremium: number
  supportReducedPremium: number
}

const route = useRoute()
const router = useRouter()
const formRef = ref<FormInstance>()
const submitting = ref(false)

const isEdit = ref(false)
const productId = ref<number | undefined>(undefined)

const form = reactive<AnnuityFormData>({
  name: '',
  companyId: undefined as unknown as number,
  category: 'annuity',
  subCategory: '',
  premium: 0,
  coverage: 0,
  term: '',
  paymentPeriod: '',
  description: '',
  highlights: [''],
  responsibilities: [],
  status: 1,
  displayStatus: 1,
  sortOrder: 0,
  annuityStartAge: 60,
  guaranteePeriod: 20,
  longevityBonusAge: 0,
  longevityBonusMultiple: 0,
  annuityPaymentMethod: 'annual',
  monthlyConversionRate: 0.085,
  hasUniversalAccount: 0,
  guaranteedRate: 0,
  supportAdditionalPremium: 0,
  supportReducedPremium: 0
})

const rules: FormRules = {
  name: [{ required: true, message: '请输入产品名称', trigger: 'blur' }],
  companyId: [{ required: true, message: '请选择保险公司', trigger: 'change' }],
  premium: [{ required: true, message: '请输入保费', trigger: 'blur' }],
  coverage: [{ required: true, message: '请输入保额', trigger: 'blur' }],
  term: [{ required: true, message: '请输入保障期限', trigger: 'blur' }],
  paymentPeriod: [{ required: true, message: '请输入缴费期限', trigger: 'blur' }],
  annuityStartAge: [{ required: true, message: '请选择领取起始年龄', trigger: 'change' }],
  guaranteePeriod: [{ required: true, message: '请选择保证领取期', trigger: 'change' }],
  annuityPaymentMethod: [{ required: true, message: '请选择年金领取方式', trigger: 'change' }]
}

function addHighlight() {
  form.highlights.push('')
}

function removeHighlight(index: number) {
  if (form.highlights.length <= 1) return
  form.highlights.splice(index, 1)
}

function addResponsibility() {
  form.responsibilities.push({
    id: 0,
    name: '',
    description: '',
    coverage: '',
    type: 'annuity',
    sortOrder: form.responsibilities.length
  })
}

function removeResponsibility(index: number) {
  form.responsibilities.splice(index, 1)
}

async function handleSubmit() {
  if (!formRef.value) return
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    submitting.value = true
    try {
      form.highlights = form.highlights.filter((h) => h.trim() !== '')
      if (isEdit.value && productId.value) {
        await updateProduct(productId.value, form)
        ElMessage.success('更新成功')
      } else {
        await createProduct(form)
        ElMessage.success('创建成功')
      }
      router.push('/product/annuity')
    } finally {
      submitting.value = false
    }
  })
}

async function loadDetail(id: number) {
  try {
    const res = await getProductDetail(id)
    const subData = res.subProductData ?? {}
    Object.assign(form, {
      name: res.productName ?? '',
      companyId: res.companyId,
      category: 'annuity',
      subCategory: res.subType != null ? String(res.subType) : '',
      premium: res.premium ?? 0,
      coverage: res.coverage ?? 0,
      term: res.term ?? '',
      paymentPeriod: res.paymentYears ?? '',
      description: res.description ?? '',
      highlights: res.highlights?.length ? res.highlights : [''],
      responsibilities: res.responsibilities ?? [],
      status: res.saleStatus ?? 1,
      displayStatus: res.systemStatus ?? 1,
      sortOrder: res.sortOrder ?? 0,
      annuityStartAge: subData.annuityStartAge ?? 60,
      guaranteePeriod: subData.guaranteePeriod ?? 20,
      longevityBonusAge: subData.longevityBonusAge ?? 0,
      longevityBonusMultiple: subData.longevityBonusMultiple ?? 0,
      annuityPaymentMethod: subData.annuityPaymentMethod ?? 'annual',
      monthlyConversionRate: subData.monthlyConversionRate ?? 0.085,
      hasUniversalAccount: subData.hasUniversalAccount ?? 0,
      guaranteedRate: subData.guaranteedRate ?? 0,
      supportAdditionalPremium: subData.supportAdditionalPremium ?? 0,
      supportReducedPremium: subData.supportReducedPremium ?? 0
    })
  } catch {
    // 错误已在拦截器中处理
  }
}

onMounted(() => {
  const id = route.query.id
  if (id) {
    isEdit.value = true
    productId.value = Number(id)
    loadDetail(Number(id))
  }
})
</script>

<style scoped>
.card-header {
  font-weight: 500;
}

.product-form {
  max-width: 1000px;
}

.dynamic-item {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}

.mt-8 {
  margin-top: 8px;
}
</style>
