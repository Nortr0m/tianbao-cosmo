<template>
  <div class="import-wizard-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>产品录入向导</span>
        </div>
      </template>

      <el-steps :active="currentStep" finish-status="success" simple>
        <el-step title="选择类型" />
        <el-step title="基础信息" />
        <el-step title="上传资料" />
        <el-step title="子类配置" />
        <el-step title="确认提交" />
      </el-steps>

      <!-- Step 1: 选择产品类型 -->
      <div v-if="currentStep === 0" class="step-content">
        <h3>选择产品类型</h3>
        <el-radio-group v-model="form.productType" size="large">
          <el-radio-button :label="1">重疾险</el-radio-button>
          <el-radio-button :label="2">增额终身寿险</el-radio-button>
          <el-radio-button :label="3">年金险</el-radio-button>
        </el-radio-group>
      </div>

      <!-- Step 2: 基础信息 -->
      <div v-if="currentStep === 1" class="step-content">
        <h3>填写基础信息</h3>
        <el-form ref="baseFormRef" :model="form" :rules="baseRules" label-width="120px">
          <el-form-item label="产品名称" prop="productName">
            <el-input v-model="form.productName" placeholder="请输入产品名称" />
          </el-form-item>
          <el-form-item label="产品编码" prop="productCode">
            <el-input v-model="form.productCode" placeholder="请输入产品编码（如：XYZL-2024-001）" />
          </el-form-item>
          <el-form-item label="保险公司" prop="companyId">
            <el-select v-model="form.companyId" placeholder="请选择保险公司" style="width: 100%">
              <el-option
                v-for="c in companyList"
                :key="c.companyId"
                :label="c.companyName"
                :value="c.companyId"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="子类型">
            <el-radio-group v-model="form.subType">
              <el-radio :label="1">分红型</el-radio>
              <el-radio :label="2">固收型</el-radio>
              <el-radio :label="3">传统型</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="投保年龄">
            <el-col :span="11">
              <el-input-number v-model="form.minAge" :min="0" :max="100" placeholder="最小年龄" />
            </el-col>
            <el-col :span="2" class="text-center">-</el-col>
            <el-col :span="11">
              <el-input-number v-model="form.maxAge" :min="0" :max="100" placeholder="最大年龄" />
            </el-col>
          </el-form-item>
          <el-form-item label="缴费年限">
            <el-input v-model="form.paymentYears" placeholder='如：["趸交","3年","5年","10年"]' />
          </el-form-item>
        </el-form>
      </div>

      <!-- Step 3: 上传资料 -->
      <div v-if="currentStep === 2" class="step-content">
        <h3>上传产品资料</h3>
        <p class="upload-tip">资料上传为可选步骤，您也可以在产品创建后通过编辑页面上传。费率表将在产品创建后单独导入。</p>
        <el-form label-width="120px">
          <el-form-item label="保险条款">
            <el-upload
              ref="termsUploadRef"
              :auto-upload="false"
              :limit="1"
              accept=".pdf"
              :on-change="(f: any) => onFileChange(f, 'terms')"
              :on-remove="() => onFileRemove('terms')"
            >
              <el-button type="primary">选择PDF</el-button>
              <template #tip>
                <div class="upload-item-tip" v-if="uploadFiles.terms.name">{{ uploadFiles.terms.name }}</div>
              </template>
            </el-upload>
          </el-form-item>
          <el-form-item label="产品说明书">
            <el-upload
              ref="brochureUploadRef"
              :auto-upload="false"
              :limit="1"
              accept=".pdf"
              :on-change="(f: any) => onFileChange(f, 'brochure')"
              :on-remove="() => onFileRemove('brochure')"
            >
              <el-button type="primary">选择PDF</el-button>
              <template #tip>
                <div class="upload-item-tip" v-if="uploadFiles.brochure.name">{{ uploadFiles.brochure.name }}</div>
              </template>
            </el-upload>
          </el-form-item>
          <el-form-item label="投保规则">
            <el-upload
              ref="rulesUploadRef"
              :auto-upload="false"
              :limit="1"
              accept=".pdf"
              :on-change="(f: any) => onFileChange(f, 'rules')"
              :on-remove="() => onFileRemove('rules')"
            >
              <el-button type="primary">选择PDF</el-button>
              <template #tip>
                <div class="upload-item-tip" v-if="uploadFiles.rules.name">{{ uploadFiles.rules.name }}</div>
              </template>
            </el-upload>
          </el-form-item>
          <el-form-item label="费率表">
            <el-upload
              ref="rateUploadRef"
              :auto-upload="false"
              :limit="1"
              accept=".xlsx,.xls"
              :on-change="(f: any) => onFileChange(f, 'rateTable')"
              :on-remove="() => onFileRemove('rateTable')"
            >
              <el-button type="primary">选择Excel</el-button>
              <template #tip>
                <div class="upload-item-tip" v-if="uploadFiles.rateTable.name">{{ uploadFiles.rateTable.name }}</div>
              </template>
            </el-upload>
          </el-form-item>
        </el-form>
      </div>

      <!-- Step 4: 子类配置 -->
      <div v-if="currentStep === 3" class="step-content">
        <h3>配置子类信息</h3>
        <!-- 增额寿配置 -->
        <template v-if="form.productType === 2">
          <el-form :model="form.wholeLife" label-width="140px">
            <el-form-item label="减保规则类型">
              <el-select v-model="form.wholeLife.reductionRuleType" placeholder="请选择">
                <el-option label="20%保额" :value="1" />
                <el-option label="20%保费" :value="2" />
                <el-option label="无限制" :value="3" />
              </el-select>
            </el-form-item>
            <el-form-item label="保单贷款比例">
              <el-input-number v-model="form.wholeLife.loanRatio" :min="0" :max="100" :step="5" />
              <span class="unit">%</span>
            </el-form-item>
            <el-form-item label="保额递增比例">
              <el-input-number v-model="form.wholeLife.increaseRate" :min="0" :max="10" :step="0.1" />
              <span class="unit">%</span>
            </el-form-item>
          </el-form>
        </template>
        <!-- 年金险配置 -->
        <template v-if="form.productType === 3">
          <el-form :model="form.annuity" label-width="140px">
            <el-form-item label="是否支持月领">
              <el-radio-group v-model="form.annuity.supportMonthly">
                <el-radio :label="true">是</el-radio>
                <el-radio :label="false">否</el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="月领系数">
              <el-input-number v-model="form.annuity.monthlyCoefficient" :min="0" :max="1" :step="0.01" />
            </el-form-item>
            <el-form-item label="保证领取期">
              <el-input v-model="form.annuity.guaranteePeriod" placeholder="如：20年" />
            </el-form-item>
          </el-form>
        </template>
        <!-- 重疾险配置 -->
        <template v-if="form.productType === 1">
          <el-form :model="form.critical" label-width="140px">
            <el-form-item label="等待期">
              <el-input-number v-model="form.critical.waitingPeriod" :min="0" :max="365" />
              <span class="unit">天</span>
            </el-form-item>
            <el-form-item label="重疾种类数">
              <el-input-number v-model="form.critical.criticalCount" :min="1" :max="200" />
            </el-form-item>
            <el-form-item label="中症种类数">
              <el-input-number v-model="form.critical.mediumCount" :min="0" :max="100" />
            </el-form-item>
            <el-form-item label="轻症种类数">
              <el-input-number v-model="form.critical.lightCount" :min="0" :max="100" />
            </el-form-item>
          </el-form>
        </template>
      </div>

      <!-- Step 5: 确认提交 -->
      <div v-if="currentStep === 4" class="step-content">
        <h3>确认产品信息</h3>
        <el-descriptions :column="2" border>
          <el-descriptions-item label="产品名称">{{ form.productName }}</el-descriptions-item>
          <el-descriptions-item label="产品编码">{{ form.productCode || '-' }}</el-descriptions-item>
          <el-descriptions-item label="产品类型">{{ productTypeLabel }}</el-descriptions-item>
          <el-descriptions-item label="保险公司">{{ getCompanyName(form.companyId) }}</el-descriptions-item>
          <el-descriptions-item label="子类型">{{ subTypeLabel }}</el-descriptions-item>
          <el-descriptions-item label="投保年龄">{{ form.minAge }}-{{ form.maxAge }}岁</el-descriptions-item>
        </el-descriptions>

        <!-- 子类配置摘要 -->
        <h4 class="sub-summary-title">子类配置</h4>
        <el-descriptions :column="2" border v-if="form.productType === 2">
          <el-descriptions-item label="减保规则类型">{{ wholeLifeRuleLabel }}</el-descriptions-item>
          <el-descriptions-item label="保单贷款比例">{{ form.wholeLife.loanRatio }}%</el-descriptions-item>
          <el-descriptions-item label="保额递增比例">{{ form.wholeLife.increaseRate }}%</el-descriptions-item>
        </el-descriptions>
        <el-descriptions :column="2" border v-if="form.productType === 3">
          <el-descriptions-item label="支持月领">{{ form.annuity.supportMonthly ? '是' : '否' }}</el-descriptions-item>
          <el-descriptions-item label="月领系数">{{ form.annuity.monthlyCoefficient }}</el-descriptions-item>
          <el-descriptions-item label="保证领取期">{{ form.annuity.guaranteePeriod || '-' }}</el-descriptions-item>
        </el-descriptions>
        <el-descriptions :column="2" border v-if="form.productType === 1">
          <el-descriptions-item label="等待期">{{ form.critical.waitingPeriod }}天</el-descriptions-item>
          <el-descriptions-item label="重疾种类数">{{ form.critical.criticalCount }}种</el-descriptions-item>
          <el-descriptions-item label="中症种类数">{{ form.critical.mediumCount }}种</el-descriptions-item>
          <el-descriptions-item label="轻症种类数">{{ form.critical.lightCount }}种</el-descriptions-item>
        </el-descriptions>

        <!-- 资料上传摘要 -->
        <h4 class="sub-summary-title">已上传资料</h4>
        <el-descriptions :column="2" border>
          <el-descriptions-item label="保险条款">
            <el-tag :type="uploadFiles.terms.name ? 'success' : 'info'" size="small">
              {{ uploadFiles.terms.name || '未上传' }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="产品说明书">
            <el-tag :type="uploadFiles.brochure.name ? 'success' : 'info'" size="small">
              {{ uploadFiles.brochure.name || '未上传' }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="投保规则">
            <el-tag :type="uploadFiles.rules.name ? 'success' : 'info'" size="small">
              {{ uploadFiles.rules.name || '未上传' }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="费率表">
            <el-tag :type="uploadFiles.rateTable.name ? 'success' : 'info'" size="small">
              {{ uploadFiles.rateTable.name || '未上传' }}
            </el-tag>
          </el-descriptions-item>
        </el-descriptions>

        <p class="tip">提交后产品状态为「待人工确认」，管理员确认后自动上架。</p>
      </div>

      <div class="step-actions">
        <el-button v-if="currentStep > 0" @click="currentStep--">上一步</el-button>
        <el-button v-if="currentStep < 4" type="primary" @click="goNext" :loading="false">下一步</el-button>
        <el-button v-if="currentStep === 4" type="success" @click="handleSubmit" :loading="submitting">提交</el-button>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, type FormInstance, type FormRules } from 'element-plus'
import type { UploadFile } from 'element-plus'
import { getCompanyList } from '@/api/company'
import type { Company } from '@/api/company'
import { createProduct, importRates, importAnnuityRates } from '@/api/product'

const router = useRouter()
const currentStep = ref(0)
const submitting = ref(false)
const baseFormRef = ref<FormInstance>()
const companyList = ref<Company[]>([])

type UploadFileInfo = { name: string; raw: File | null }

const form = reactive({
  productType: 2 as 1 | 2 | 3,
  productName: '',
  productCode: '',
  companyId: undefined as number | undefined,
  subType: 2 as 1 | 2 | 3,
  minAge: 0,
  maxAge: 65,
  paymentYears: '[]',
  wholeLife: {
    reductionRuleType: 1,
    loanRatio: 80,
    increaseRate: 3.5
  },
  annuity: {
    supportMonthly: true,
    monthlyCoefficient: 0.085,
    guaranteePeriod: '20年'
  },
  critical: {
    waitingPeriod: 90,
    criticalCount: 120,
    mediumCount: 25,
    lightCount: 40
  }
})

const uploadFiles = reactive<Record<string, UploadFileInfo>>({
  terms: { name: '', raw: null },
  brochure: { name: '', raw: null },
  rules: { name: '', raw: null },
  rateTable: { name: '', raw: null }
})

const baseRules: FormRules = {
  productName: [{ required: true, message: '请输入产品名称', trigger: 'blur' }],
  productCode: [{ required: true, message: '请输入产品编码', trigger: 'blur' }],
  companyId: [{ required: true, message: '请选择保险公司', trigger: 'change' }]
}

const productTypeLabel = computed(() => {
  const map: Record<number, string> = { 1: '重疾险', 2: '增额终身寿险', 3: '年金险' }
  return map[form.productType] || '未知'
})

const subTypeLabel = computed(() => {
  const map: Record<number, string> = { 1: '分红型', 2: '固收型', 3: '传统型' }
  return map[form.subType] || '-'
})

const wholeLifeRuleLabel = computed(() => {
  const map: Record<number, string> = { 1: '20%保额', 2: '20%保费', 3: '无限制' }
  return map[form.wholeLife.reductionRuleType] || '-'
})

function getCompanyName(id?: number) {
  if (!id) return '-'
  const c = companyList.value.find(x => x.companyId === id)
  return c ? c.companyName : '-'
}

function onFileChange(file: UploadFile, key: string) {
  uploadFiles[key] = { name: file.name, raw: file.raw as File }
}

function onFileRemove(key: string) {
  uploadFiles[key] = { name: '', raw: null }
}

async function validateStep(step: number): Promise<boolean> {
  if (step === 0) {
    if (!form.productType) {
      ElMessage.warning('请选择产品类型')
      return false
    }
    return true
  }
  if (step === 1) {
    if (!baseFormRef.value) return false
    try {
      await baseFormRef.value.validate()
      return true
    } catch {
      return false
    }
  }
  // Step 2 (上传) 和 Step 3 (子类配置) 无强制校验
  return true
}

async function goNext() {
  const valid = await validateStep(currentStep.value)
  if (valid) {
    currentStep.value++
  }
}

async function handleSubmit() {
  submitting.value = true
  try {
    // 1. 创建产品
    const productId = await createProduct({
      productName: form.productName,
      productCode: form.productCode,
      companyId: form.companyId!,
      productType: form.productType,
      subType: form.subType,
      minAge: form.minAge,
      maxAge: form.maxAge,
      paymentYears: form.paymentYears,
      saleStatus: 0,
      systemStatus: 0,
      // 增额终身寿险子类字段
      ...(form.productType === 2 ? {
        reductionRuleType: form.wholeLife.reductionRuleType,
        loanRatio: form.wholeLife.loanRatio,
        increaseRate: form.wholeLife.increaseRate
      } : {})
    })

    // 2. 导入费率表（如果有上传且产品类型为增额寿或年金险）
    if (uploadFiles.rateTable.raw) {
      try {
        if (form.productType === 2) {
          await importRates(productId, uploadFiles.rateTable.raw)
        } else if (form.productType === 3) {
          await importAnnuityRates(productId, uploadFiles.rateTable.raw)
        }
        ElMessage.success(`费率表导入成功，共 ${uploadFiles.rateTable.name}`)
      } catch (e: any) {
        ElMessage.warning(`费率表导入失败：${e.message || '未知错误'}，请稍后在产品编辑页重新导入`)
      }
    }

    ElMessage.success('产品录入成功，状态：待人工确认')
    // 跳转到对应产品列表页
    const routeMap: Record<number, string> = { 1: '/product/critical-illness', 2: '/product/whole-life', 3: '/product/annuity' }
    router.push(routeMap[form.productType] || '/product/whole-life')
  } catch (e: any) {
    ElMessage.error(`提交失败：${e.message || '未知错误'}`)
  } finally {
    submitting.value = false
  }
}

async function loadCompanies() {
  try {
    const res = await getCompanyList(1, 999)
    companyList.value = res.list
  } catch {
    companyList.value = []
  }
}

onMounted(() => {
  loadCompanies()
})
</script>

<style scoped>
.import-wizard-page {
  padding: 20px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.step-content {
  margin: 32px 0;
  min-height: 300px;
}
.step-content h3 {
  margin-bottom: 24px;
  color: var(--text-primary);
}
.step-actions {
  display: flex;
  justify-content: center;
  gap: 16px;
  margin-top: 24px;
  padding-top: 24px;
  border-top: 1px solid var(--border-color);
}
.unit {
  margin-left: 8px;
  color: var(--text-secondary);
}
.text-center {
  text-align: center;
}
.tip {
  margin-top: 16px;
  color: var(--text-muted);
  font-size: 13px;
}
.upload-tip {
  margin-bottom: 16px;
  color: var(--text-secondary);
  font-size: 13px;
}
.upload-item-tip {
  margin-top: 4px;
  font-size: 12px;
  color: var(--text-muted);
}
.sub-summary-title {
  margin: 20px 0 12px;
  font-size: 15px;
  color: var(--text-primary);
}
</style>
