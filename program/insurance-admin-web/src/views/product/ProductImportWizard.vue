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
        <el-form :model="form" label-width="120px">
          <el-form-item label="产品名称" required>
            <el-input v-model="form.productName" placeholder="请输入产品名称" />
          </el-form-item>
          <el-form-item label="保险公司" required>
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
        <el-form label-width="120px">
          <el-form-item label="保险条款">
            <el-upload
              action="/api/v1/upload"
              :limit="1"
              accept=".pdf"
              @success="(r: any) => form.hasTerms = true"
            >
              <el-button type="primary">上传PDF</el-button>
            </el-upload>
          </el-form-item>
          <el-form-item label="产品说明书">
            <el-upload
              action="/api/v1/upload"
              :limit="1"
              accept=".pdf"
              @success="(r: any) => form.hasBrochure = true"
            >
              <el-button type="primary">上传PDF</el-button>
            </el-upload>
          </el-form-item>
          <el-form-item label="投保规则">
            <el-upload
              action="/api/v1/upload"
              :limit="1"
              accept=".pdf"
              @success="(r: any) => form.hasRules = true"
            >
              <el-button type="primary">上传PDF</el-button>
            </el-upload>
          </el-form-item>
          <el-form-item label="费率表">
            <el-upload
              action="/api/v1/upload"
              :limit="1"
              accept=".xlsx,.xls"
              @success="(r: any) => form.hasRateTable = true"
            >
              <el-button type="primary">上传Excel</el-button>
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
          <el-descriptions-item label="产品类型">{{ form.productType === 1 ? '重疾险' : form.productType === 2 ? '增额终身寿险' : '年金险' }}</el-descriptions-item>
          <el-descriptions-item label="保险公司">{{ getCompanyName(form.companyId) }}</el-descriptions-item>
          <el-descriptions-item label="子类型">{{ form.subType === 1 ? '分红型' : form.subType === 2 ? '固收型' : '传统型' }}</el-descriptions-item>
          <el-descriptions-item label="投保年龄">{{ form.minAge }}-{{ form.maxAge }}岁</el-descriptions-item>
          <el-descriptions-item label="资料完整度">
            <el-tag :type="docCompletePercent === 100 ? 'success' : 'warning'">{{ docCompletePercent }}%</el-tag>
          </el-descriptions-item>
        </el-descriptions>
        <p class="tip">提交后产品状态为「待人工确认」，管理员确认后自动上架。</p>
      </div>

      <div class="step-actions">
        <el-button v-if="currentStep > 0" @click="currentStep--">上一步</el-button>
        <el-button v-if="currentStep < 4" type="primary" @click="currentStep++">下一步</el-button>
        <el-button v-if="currentStep === 4" type="success" @click="handleSubmit">提交</el-button>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { getCompanyList } from '@/api/company'
import type { Company } from '@/api/company'

const router = useRouter()
const currentStep = ref(0)
const companyList = ref<Company[]>([])

const form = reactive({
  productType: 2 as 1 | 2 | 3,
  productName: '',
  companyId: undefined as number | undefined,
  subType: 2 as 1 | 2 | 3,
  minAge: 0,
  maxAge: 65,
  paymentYears: '[]',
  hasTerms: false,
  hasBrochure: false,
  hasRules: false,
  hasRateTable: false,
  hasCashValue: false,
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

const docCompletePercent = computed(() => {
  let count = 0
  if (form.hasTerms) count++
  if (form.hasBrochure) count++
  if (form.hasRules) count++
  if (form.hasRateTable) count++
  if (form.hasCashValue) count++
  return Math.round((count / 5) * 100)
})

function getCompanyName(id?: number) {
  if (!id) return '-'
  const c = companyList.value.find(x => x.companyId === id)
  return c ? c.companyName : '-'
}

async function handleSubmit() {
  // TODO: 调用后端创建产品接口
  ElMessage.success('产品录入成功，状态：待人工确认')
  router.push('/product/whole-life')
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
</style>
