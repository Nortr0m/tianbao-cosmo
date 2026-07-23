<template>
  <div class="product-detail-page">
    <el-page-header @back="handleBack">
      <template #content>
        <span class="detail-title">{{ detail?.productName }}</span>
        <el-tag :color="currentProductTypeColor" size="small" class="type-tag">
          {{ currentProductTypeLabel }}
        </el-tag>
        <el-tag :type="detail?.saleStatus === 1 ? 'success' : detail?.saleStatus === 2 ? 'warning' : 'info'" size="small" class="status-tag">
          {{ detail?.saleStatus === 1 ? '在售' : detail?.saleStatus === 2 ? '预售中' : '已停售' }}
        </el-tag>
      </template>
    </el-page-header>

    <el-breadcrumb class="detail-breadcrumb">
      <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item :to="{ path: '/product/list' }">产品列表</el-breadcrumb-item>
      <el-breadcrumb-item>产品详情</el-breadcrumb-item>
    </el-breadcrumb>

    <el-skeleton v-if="isLoading" :rows="10" animated />

    <template v-else-if="detail">
      <!-- Product Info Card -->
      <el-card class="info-card">
        <div class="product-header">
          <div class="company-info">
            <img v-if="detail.companyLogo" :src="detail.companyLogo" class="company-logo-large" />
            <div>
              <h2>{{ detail.productName }}</h2>
              <p>{{ detail.companyName }}</p>
            </div>
          </div>
          <div class="product-actions">
            <el-button
              :type="compareStore.isProductSelected(detail.productId) ? 'success' : 'default'"
              @click="handleToggleCompare"
            >
              {{ compareStore.isProductSelected(detail.productId) ? '已加入对比' : '加入对比' }}
            </el-button>
            <el-button type="primary" @click="goToCardGenerate">
              生成展业卡片
            </el-button>
          </div>
        </div>

        <el-descriptions :column="3" border>
          <el-descriptions-item label="产品类型">{{ detail.productTypeDesc || detail.productType }}</el-descriptions-item>
          <el-descriptions-item label="投保年龄">{{ detail.minAge }} - {{ detail.maxAge }} 岁</el-descriptions-item>
          <el-descriptions-item label="职业类别">{{ detail.occupationClass }}类</el-descriptions-item>
          <el-descriptions-item label="缴费期限">{{ parsedPaymentPeriods.join('、') }}年</el-descriptions-item>
          <el-descriptions-item label="缴费方式">{{ parsedPaymentFrequencies.length ? parsedPaymentFrequencies.map(f => f.label).join('、') : '年缴' }}</el-descriptions-item>
          <el-descriptions-item label="收益类型">
            <el-tag :type="detail.yieldType === '分红型' ? 'warning' : 'success'" size="small">{{ detail.yieldType || '固收型' }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="保险期间">{{ detail?.terms?.insurancePeriod || '终身' }}</el-descriptions-item>
          <el-descriptions-item label="犹豫期">{{ detail?.terms?.hesitationPeriod || '-' }}</el-descriptions-item>
          <el-descriptions-item label="等待期">{{ detail?.terms?.waitingPeriod || '无' }}</el-descriptions-item>
        </el-descriptions>
      </el-card>

      <!-- 分红/利率配置 -->
      <el-card v-if="detail?.dividendConfig" class="section-card">
        <template #header><span class="section-header-icon">%</span><span>利率信息</span></template>
        <el-descriptions :column="3" border>
          <el-descriptions-item v-if="detail.dividendConfig.scheduledRate != null" label="预定利率">{{ formatRate(detail.dividendConfig.scheduledRate) }}</el-descriptions-item>
          <el-descriptions-item v-if="detail.dividendConfig.guaranteedRate != null" label="保证利率">{{ formatRate(detail.dividendConfig.guaranteedRate) }}</el-descriptions-item>
          <el-descriptions-item v-if="detail.dividendConfig.increaseRate != null" label="增额比例">{{ formatRate(detail.dividendConfig.increaseRate) }}</el-descriptions-item>
          <el-descriptions-item v-if="detail.dividendConfig.dividendLowRate != null" label="低档演示利率">{{ formatRate(detail.dividendConfig.dividendLowRate) }}</el-descriptions-item>
          <el-descriptions-item v-if="detail.dividendConfig.dividendMidRate != null" label="中档演示利率">{{ formatRate(detail.dividendConfig.dividendMidRate) }}</el-descriptions-item>
          <el-descriptions-item v-if="detail.dividendConfig.dividendHighRate != null" label="高档演示利率">{{ formatRate(detail.dividendConfig.dividendHighRate) }}</el-descriptions-item>
        </el-descriptions>
      </el-card>

      <!-- 核心产品特性 -->
      <el-card v-if="detail?.wholeLifeExt || detail?.responsibilities?.length" class="section-card">
        <template #header><span class="section-header-icon">◆</span><span>核心产品特性</span></template>
        <el-descriptions :column="2" border v-if="detail?.wholeLifeExt">
          <el-descriptions-item label="身故赔付规则">{{ detail.wholeLifeExt.deathPayoutRule || '按监管标准' }}</el-descriptions-item>
          <el-descriptions-item label="减保规则">{{ detail.wholeLifeExt.reductionRuleText || '-' }}</el-descriptions-item>
          <el-descriptions-item label="加保规则">{{ detail.wholeLifeExt.addRuleText || '不支持' }}</el-descriptions-item>
          <el-descriptions-item label="第二投保人">{{ detail.wholeLifeExt.secondApplicantRule || '不支持' }}</el-descriptions-item>
          <el-descriptions-item label="隔代投保">{{ detail.wholeLifeExt.crossGeneration ? '支持' : '不支持' }}</el-descriptions-item>
          <el-descriptions-item label="信托对接">{{ detail.wholeLifeExt.trustLinkage ? '支持' : '不支持' }}</el-descriptions-item>
          <el-descriptions-item label="最低保费">{{ detail.wholeLifeExt.minPremium ? formatCurrency(detail.wholeLifeExt.minPremium) : '-' }}</el-descriptions-item>
          <el-descriptions-item label="最低保额">{{ detail.wholeLifeExt.minSumAssured ? formatCurrency(detail.wholeLifeExt.minSumAssured) : '-' }}</el-descriptions-item>
        </el-descriptions>

        <!-- 责任配置 -->
        <div v-if="detail?.responsibilities?.length" class="responsibilities-section">
          <h4 class="section-subtitle">保险责任</h4>
          <div class="benefits-container">
            <div v-for="(item, index) in detail.responsibilities" :key="index" class="benefit-item">
              <div class="benefit-name">
                <span class="benefit-icon">✦</span>
                {{ item.name }}
              </div>
              <div class="benefit-desc">{{ item.description }}</div>
            </div>
          </div>
        </div>
      </el-card>

      <!-- 减保领取计划 -->
      <el-card v-if="reductionSupported" class="section-card">
        <template #header>
          <span class="section-header-icon">◇</span><span>减保领取计划</span>
          <el-switch
            v-model="withdrawalEnabled"
            active-text="开启"
            inactive-text="关闭"
            inline-prompt
            class="header-switch"
          />
        </template>
        <WithdrawalPlan
          v-if="withdrawalEnabled"
          v-model="withdrawalForm"
          :summary="withdrawalSummary"
          :reduction-rule="detail?.wholeLifeExt?.reductionRuleText"
          :reduction-start-year="detail?.wholeLifeExt?.reductionStartYear"
          :reduction-times-limit="detail?.wholeLifeExt?.reductionTimesLimit"
          @change="handleWithdrawalChange"
        />
        <el-empty v-else description="开启减保领取后可设置领取计划" :image-size="80" />
      </el-card>

      <!-- 分红实现率 -->
      <el-card v-if="detail?.yieldType === '分红型'" class="section-card">
        <template #header>
          <span class="section-header-icon">◈</span><span>分红实现率</span>
        </template>
        <DividendSelector v-model="dividendRate" @change="handleDividendChange" />
      </el-card>

      <!-- 保费计算器 -->
      <el-card class="section-card">
        <template #header>
          <span class="section-header-icon">¥</span><span>保费计算器</span>
        </template>
        <PremiumCalculator
          ref="premiumCalcRef"
          :payment-periods="parsedPaymentPeriods"
          :payment-frequencies="parsedPaymentFrequencies"
          :default-coverage="100000"
          :min-age="detail.minAge"
          :max-age="detail.maxAge"
          @calculate="handleCalculatePremium"
        />
      </el-card>

      <!-- 利益演示 Tabs -->
      <el-card class="section-card">
        <el-tabs v-model="activeTab">
          <!-- 利益演示 tab -->
          <el-tab-pane label="利益演示" name="projection" lazy>
            <div class="projection-header">
              <el-form :model="projectionForm" inline class="projection-form-inline">
                <el-form-item label="年龄">
                  <el-input-number v-model="projectionForm.age" :min="detail.minAge" :max="detail.maxAge" />
                </el-form-item>
                <el-form-item label="性别">
                  <el-radio-group v-model="projectionForm.gender">
                    <el-radio-button value="male">男</el-radio-button>
                    <el-radio-button value="female">女</el-radio-button>
                  </el-radio-group>
                </el-form-item>
                <el-form-item label="缴费期限">
                  <el-select v-model="projectionForm.paymentPeriod">
                    <el-option
                      v-for="p in parsedPaymentPeriods"
                      :key="p"
                      :label="p + '年'"
                      :value="p"
                    />
                  </el-select>
                </el-form-item>
                <el-form-item label="年缴保费">
                  <el-input-number v-model="projectionForm.coverage" :min="5000" :step="5000" />
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" :loading="projecting" @click="handleProjection">
                    计算演示
                  </el-button>
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" text @click="columnDialogVisible = true">
                    <el-icon><Setting /></el-icon>自定义列
                  </el-button>
                </el-form-item>
              </el-form>
            </div>

            <!-- 核心指标汇总卡片 -->
            <div v-if="projectionResult" class="summary-cards">
              <el-row :gutter="16">
                <el-col :xs="12" :sm="6">
                  <div class="metric-card tb-star-trail">
                    <div class="metric-label">总保费</div>
                    <div class="metric-value neon-text-cyan">{{ formatCurrency(projectionResult.summary.totalPremium) }}</div>
                  </div>
                </el-col>
                <el-col :xs="12" :sm="6">
                  <div class="metric-card tb-star-trail">
                    <div class="metric-label">现金价值({{ targetAge }}岁)</div>
                    <div class="metric-value neon-text-purple">{{ formatCurrency(targetCashValue) }}</div>
                  </div>
                </el-col>
                <el-col :xs="12" :sm="6">
                  <div class="metric-card tb-star-trail">
                    <div class="metric-label">IRR</div>
                    <div class="metric-value neon-text-orange">{{ formatPercent(projectionResult.summary.irr, 2) }}%</div>
                  </div>
                </el-col>
                <el-col :xs="12" :sm="6">
                  <div class="metric-card tb-star-trail">
                    <div class="metric-label">收益倍数</div>
                    <div class="metric-value neon-text-green">{{ returnMultiple }}<span class="metric-unit">倍</span></div>
                  </div>
                </el-col>
              </el-row>
              <div class="summary-extra">
                <el-tag size="small" type="info">回本年限：{{ projectionResult.summary.breakEvenYear > 0 ? projectionResult.summary.breakEvenYear + '年' : '-' }}</el-tag>
                <el-tag v-if="projectionResult.summary.guaranteedIrr != null" size="small" type="warning">保证IRR：{{ formatPercent(projectionResult.summary.guaranteedIrr, 2) }}%</el-tag>
                <el-tag v-if="projectionResult.summary.dividendIrr != null" size="small" type="success">含分红IRR：{{ formatPercent(projectionResult.summary.dividendIrr, 2) }}%</el-tag>
              </div>
            </div>

            <!-- 现金价值图表 -->
            <div v-if="projectionResult" ref="chartRef" class="chart-container" />

            <BenefitTable
              v-if="projectionResult"
              :yearly-data="projectionResult.yearlyData"
              :summary="projectionResult.summary"
              :selected-columns="selectedColumns"
              :column-options="columnOptions"
            />
            <el-empty v-else description="请先计算利益演示" />
          </el-tab-pane>

          <!-- 投保规则 tab -->
          <el-tab-pane label="投保规则" name="rules" lazy>
            <div v-if="insuranceRules.length" class="rules-container">
              <div v-for="(rule, index) in insuranceRules" :key="index" class="rule-card">
                <div class="rule-icon">{{ rule.icon }}</div>
                <div class="rule-content">
                  <div class="rule-title">{{ rule.title }}</div>
                  <div class="rule-desc">{{ rule.desc }}</div>
                </div>
              </div>
            </div>
            <div v-else class="empty-placeholder">
              <el-icon class="empty-icon"><Document /></el-icon>
              <p>暂无投保规则数据</p>
            </div>
          </el-tab-pane>

          <!-- 责任免除 tab -->
          <el-tab-pane label="责任免除" name="exclusion" lazy>
            <div v-if="detail?.terms?.exclusionSummary" class="exclusion-content">
              <el-alert
                title="责任免除说明"
                type="warning"
                :closable="false"
                show-icon
                class="exclusion-alert"
              >
                <template #default>
                  因下列情形之一导致被保险人身故或全残的，本公司不承担给付保险金的责任：
                </template>
              </el-alert>
              <div class="exclusion-list">
                <div v-for="(item, index) in exclusionList" :key="index" class="exclusion-item">
                  <span class="exclusion-num">{{ index + 1 }}</span>
                  <span class="exclusion-text">{{ item }}</span>
                </div>
              </div>
            </div>
            <div v-else class="empty-placeholder">
              <el-icon class="empty-icon"><Warning /></el-icon>
              <p>具体责任免除请参阅产品条款</p>
            </div>
          </el-tab-pane>

          <!-- 保险公司 tab -->
          <el-tab-pane label="保险公司" name="company" lazy>
            <div v-if="detail?.company" class="company-detail">
              <div class="company-header">
                <div class="company-logo-box">
                  <span class="company-logo-text">{{ detail.companyName.substring(0, 2) }}</span>
                </div>
                <div class="company-basic">
                  <h3>{{ detail.companyName }}</h3>
                  <div class="company-tags">
                    <el-tag size="small" type="primary">{{ detail.company.companyTypeDesc || '-' }}</el-tag>
                    <el-tag size="small" :type="riskRatingType">{{ detail.company.riskRating || '-' }}级</el-tag>
                  </div>
                </div>
                <el-button type="primary" size="default" @click="handleViewCompanyDetail">
                  <el-icon><View /></el-icon> 查看公司详情
                </el-button>
              </div>

              <el-descriptions :column="2" border class="company-desc">
                <el-descriptions-item label="成立时间">{{ detail.company.foundedYear || '-' }}年</el-descriptions-item>
                <el-descriptions-item label="注册资本">{{ detail.company.registeredCapital ? formatCurrency(detail.company.registeredCapital, 0) : '-' }}亿元</el-descriptions-item>
                <el-descriptions-item label="公司性质">{{ detail.company.companyTypeDesc || '-' }}</el-descriptions-item>
                <el-descriptions-item label="风险评级">
                  <el-tag :type="riskRatingType" size="small">{{ detail.company.riskRating || '-' }}</el-tag>
                </el-descriptions-item>
                <el-descriptions-item label="偿付能力充足率">
                  <span :class="solvencyClass">{{ detail.company.solvencyRatio ? detail.company.solvencyRatio + '%' : '-' }}</span>
                </el-descriptions-item>
                <el-descriptions-item label="客服热线">{{ detail.company.hotline || '-' }}</el-descriptions-item>
                <el-descriptions-item label="官方网站" :span="2">
                  <el-link v-if="detail.company.website" :href="'https://' + detail.company.website" target="_blank" type="primary">
                    {{ detail.company.website }}
                  </el-link>
                  <span v-else>-</span>
                </el-descriptions-item>
                <el-descriptions-item label="公司简介" :span="2">
                  {{ detail.company.description || '暂无简介' }}
                </el-descriptions-item>
              </el-descriptions>

              <!-- 主要股东 -->
              <div v-if="detail.company.shareholders && detail.company.shareholders.length > 0" class="shareholders-section">
                <div class="section-head">
                  <span class="section-title">主要股东</span>
                  <span class="section-sub">前3大股东</span>
                </div>
                <div class="shareholders-list">
                  <div
                    v-for="(sh, index) in top3Shareholders"
                    :key="index"
                    class="shareholder-row"
                  >
                    <div class="sh-rank-badge">{{ index + 1 }}</div>
                    <div class="sh-info">
                      <div class="sh-name">
                        {{ sh.name }}
                        <el-tag v-if="sh.isStateOwned" type="danger" size="small" effect="light">国资</el-tag>
                        <el-tag v-else-if="sh.isForeign" type="primary" size="small" effect="light">外资</el-tag>
                      </div>
                      <div class="sh-type">{{ sh.type }}</div>
                    </div>
                    <div class="sh-ratio-block">
                      <div class="sh-ratio-num">{{ sh.ratio }}</div>
                      <div class="sh-ratio-bar">
                        <div class="sh-ratio-fill" :style="{ width: Math.min(sh.ratioValue, 100) + '%' }"></div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div v-else class="empty-placeholder">
              <el-icon class="empty-icon"><OfficeBuilding /></el-icon>
              <p>暂无保险公司信息</p>
            </div>
          </el-tab-pane>
        </el-tabs>
      </el-card>
    </template>

    <!-- Column Selection Dialog -->
    <el-dialog v-model="columnDialogVisible" title="自定义列" width="600px">
      <el-checkbox-group v-model="selectedColumns">
        <el-row :gutter="20">
          <el-col :span="8">
            <h4>基本利益</h4>
            <el-checkbox v-for="col in columnOptions.basic" :key="col.value" :label="col.value">
              {{ col.label }}
            </el-checkbox>
          </el-col>
          <el-col :span="8">
            <h4>保证利益</h4>
            <el-checkbox v-for="col in columnOptions.guaranteed" :key="col.value" :label="col.value">
              {{ col.label }}
            </el-checkbox>
          </el-col>
          <el-col :span="8">
            <h4>红利利益</h4>
            <el-checkbox v-for="col in columnOptions.dividend" :key="col.value" :label="col.value">
              {{ col.label }}
            </el-checkbox>
          </el-col>
        </el-row>
      </el-checkbox-group>
      <template #footer>
        <el-button type="warning" text @click="resetColumns">恢复默认</el-button>
        <el-button @click="columnDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveColumnPreference">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Setting, Document, Warning, OfficeBuilding, View } from '@element-plus/icons-vue'
import { useProduct } from '@/composables/useProduct'
import { useCompareStore } from '@/stores/compareStore'
import { usePermission } from '@/composables/usePermission'
import { getBenefitProjection, calculatePremium } from '@/api/calculate'
import type { CalculateResult } from '@/api/calculate'
import { formatCurrency, formatPercent } from '@/utils/format'
import { local } from '@/utils/storage'
import WithdrawalPlan from '@/components/business/WithdrawalPlan.vue'
import DividendSelector from '@/components/business/DividendSelector.vue'
import BenefitTable from '@/components/business/BenefitTable.vue'
import PremiumCalculator from '@/components/business/PremiumCalculator.vue'
import type { WithdrawalForm, WithdrawalSummary } from '@/components/business/WithdrawalPlan.vue'
import * as echarts from 'echarts'

const props = defineProps<{
  productId?: number
}>()

const route = useRoute()
const router = useRouter()
const { detail, isLoading, fetchDetail, currentProductTypeLabel, currentProductTypeColor } = useProduct()
const compareStore = useCompareStore()
const { maxCompareCount } = usePermission()

const resolvedProductId = computed(() => props.productId ?? Number(route.params.id))

function handleBack() {
  try {
    router.back()
  } catch {
    router.push('/product/list')
  }
}

const activeTab = ref('projection')
const premiumCalcRef = ref<InstanceType<typeof PremiumCalculator>>()
const withdrawalEnabled = ref(false)
const withdrawalForm = ref<WithdrawalForm>({
  startAge: 60,
  withdrawalType: 'fixed_amount',
  fixedAmount: 10000,
  fixedRate: 5,
  customRows: [],
  durationType: 'lifetime'
})
const withdrawalSummary = ref<WithdrawalSummary | undefined>(undefined)
const dividendRate = ref(100)
const columnDialogVisible = ref(false)
const chartRef = ref<HTMLDivElement>()

const projectionForm = ref({
  age: 30,
  gender: 'male' as 'male' | 'female',
  paymentPeriod: '',
  coverage: 100000
})
const projecting = ref(false)
const projectionResult = ref<CalculateResult | null>(null)

const COLUMN_STORAGE_KEY = 'whole_life_columns'

const defaultColumns = [
  'year', 'age', 'premium', 'accumulatedPremium', 'deathBenefit', 'cashValue', 'totalValue', 'irr'
]

const columnOptions = {
  basic: [
    { label: '保单年度', value: 'year' },
    { label: '年龄', value: 'age' },
    { label: '当年保费', value: 'premium' },
    { label: '累计保费', value: 'accumulatedPremium' },
    { label: '身故保险金', value: 'deathBenefit' },
    { label: '现金价值', value: 'cashValue' },
    { label: '内部收益率', value: 'irr' }
  ],
  guaranteed: [
    { label: '保证现金价值', value: 'guaranteedCashValue' },
    { label: '保证身故保险金', value: 'guaranteedDeathBenefit' },
    { label: '当年度红利(保证)', value: 'guaranteedDividend' },
    { label: '累积红利(保证)', value: 'guaranteedAccumDividend' },
    { label: 'IRR(保证)', value: 'guaranteedIrrCol' }
  ],
  dividend: [
    { label: '当年红利', value: 'dividend' },
    { label: '累积红利', value: 'accumulatedDividend' },
    { label: '含红利总现金价值', value: 'totalValue' },
    { label: '含红利身故金', value: 'totalDeathBenefit' },
    { label: 'IRR(含红利)', value: 'dividendIrrCol' }
  ]
}

const selectedColumns = ref<string[]>(local.get<string[]>(COLUMN_STORAGE_KEY) || [...defaultColumns])

const parsedPaymentPeriods = computed(() => safeParseJSON<string[]>(detail.value?.paymentPeriods, []))

// 解析支持的缴费周期
const parsedPaymentFrequencies = computed(() => {
  const d = detail.value
  if (!d) return []
  const freqs: { value: string; label: string }[] = [{ value: 'year', label: '年缴' }]
  if (d.halfYearlyRatio !== null && d.halfYearlyRatio !== undefined) {
    freqs.push({ value: 'half_year', label: '半年缴' })
  }
  if (d.quarterlyRatio !== null && d.quarterlyRatio !== undefined) {
    freqs.push({ value: 'quarter', label: '季缴' })
  }
  if (d.monthlyRatio !== null && d.monthlyRatio !== undefined) {
    freqs.push({ value: 'month', label: '月缴' })
  }
  return freqs
})

// 是否支持减保
const reductionSupported = computed(() => {
  const ext = detail.value?.wholeLifeExt
  if (!ext) return false
  // 有减保规则文本或减保次数限制不为空则支持
  return !!(ext.reductionRuleText && ext.reductionRuleText.trim()) ||
    (ext.reductionTimesLimit !== null && ext.reductionTimesLimit !== undefined) ||
    (ext.reductionRuleType !== null && ext.reductionRuleType !== undefined)
})

// 投保规则列表
const insuranceRules = computed(() => {
  const d = detail.value
  if (!d) return []
  const rules: { icon: string; title: string; desc: string }[] = []
  rules.push({ icon: '👤', title: '投保年龄', desc: `${d.minAge} - ${d.maxAge} 周岁` })
  rules.push({ icon: '💼', title: '职业类别', desc: `${d.occupationClass}类职业可投保` })
  if (d?.terms?.insurancePeriod) {
    rules.push({ icon: '📅', title: '保险期间', desc: d.terms.insurancePeriod })
  }
  if (parsedPaymentPeriods.value.length) {
    rules.push({ icon: '💰', title: '缴费方式', desc: parsedPaymentPeriods.value.join('、') + '年交' })
  }
  if (parsedPaymentFrequencies.value.length) {
    rules.push({ icon: '📊', title: '缴费周期', desc: parsedPaymentFrequencies.value.map(f => f.label).join('、') })
  }
  if (d?.terms?.hesitationPeriod) {
    rules.push({ icon: '⏰', title: '犹豫期', desc: d.terms.hesitationPeriod })
  }
  if (d?.terms?.waitingPeriod) {
    rules.push({ icon: '⌛', title: '等待期', desc: d.terms.waitingPeriod })
  }
  if (d?.terms?.saleRegion) {
    rules.push({ icon: '📍', title: '销售地区', desc: d.terms.saleRegion })
  }
  if (d?.wholeLifeExt?.minPremium) {
    rules.push({ icon: '💵', title: '最低保费', desc: formatCurrency(d.wholeLifeExt.minPremium) + '元' })
  }
  return rules
})

// 责任免除列表
const exclusionList = computed(() => {
  const summary = detail.value?.terms?.exclusionSummary
  if (!summary) return []
  // 按数字序号分割
  const items = summary.split(/\d+[.、\)]/).filter(s => s.trim().length > 0)
  if (items.length > 1) return items.map(s => s.trim().replace(/^[：:]/, '').trim())
  // 如果没有序号，按换行分割
  const lines = summary.split('\n').filter(s => s.trim().length > 0)
  return lines.map(s => s.replace(/^\d+[.、\)\s]+/, '').trim())
})

// 风险评级类型
const riskRatingType = computed(() => {
  const rating = detail.value?.company?.riskRating
  if (rating === 'A' || rating === 'AAA' || rating === 'AA') return 'success'
  if (rating === 'B' || rating === 'BBB' || rating === 'BB') return 'warning'
  return 'info'
})

// 偿付能力样式
const solvencyClass = computed(() => {
  const ratio = detail.value?.company?.solvencyRatio
  if (!ratio) return ''
  if (ratio >= 150) return 'solvency-good'
  if (ratio >= 100) return 'solvency-normal'
  return 'solvency-bad'
})

// 目标年龄（取第30年或终身最后一年）
const targetAge = computed(() => {
  if (!projectionResult.value?.yearlyData.length) return 0
  const data = projectionResult.value.yearlyData
  // 找第30年的数据，没有则取最后
  const target = data.find(d => d.year === 30) || data[data.length - 1]
  return target.age
})

const targetCashValue = computed(() => {
  if (!projectionResult.value?.yearlyData.length) return 0
  const data = projectionResult.value.yearlyData
  const target = data.find(d => d.year === 30) || data[data.length - 1]
  return target.cashValue || 0
})

// 收益倍数
const returnMultiple = computed(() => {
  if (!projectionResult.value) return '0'
  const totalPremium = projectionResult.value.summary.totalPremium
  const totalReturn = projectionResult.value.summary.totalReturn
  if (totalPremium <= 0) return '0'
  return ((totalPremium + totalReturn) / totalPremium).toFixed(2)
})

onMounted(async () => {
  await fetchDetail(resolvedProductId.value)
  if (parsedPaymentPeriods.value.length) {
    projectionForm.value.paymentPeriod = parsedPaymentPeriods.value[0]
  }
})

function safeParseJSON<T>(str: string | undefined, defaultVal: T): T {
  if (!str) return defaultVal
  try { return JSON.parse(str) } catch { return defaultVal }
}

function formatRate(rate: number): string {
  if (rate == null) return '-'
  return (rate * 100).toFixed(2) + '%'
}

function handleToggleCompare() {
  const result = compareStore.toggleProductSelection(resolvedProductId.value, detail.value?.productType ?? 2, maxCompareCount.value)
  if (!result.success && result.error) {
    ElMessage.warning(result.error)
  }
}

function goToCardGenerate() {
  router.push(`/card/generate?productId=${resolvedProductId.value}`)
}

function handleWithdrawalChange(val: WithdrawalForm) {
  const years = val.durationType === 'age_80' ? 80 - val.startAge : 50
  const totalWithdrawal = val.withdrawalType === 'fixed_amount'
    ? val.fixedAmount * years
    : 0
  withdrawalSummary.value = {
    totalWithdrawal,
    remainingCashValue: Math.round(totalWithdrawal * 0.5),
    years
  }
}

function handleDividendChange(val: number) {
  dividendRate.value = val
  if (projectionResult.value) {
    handleProjection()
  }
}

async function handleCalculatePremium(form: { age: number; gender: 'male' | 'female'; coverage: number; paymentPeriod: string; paymentFrequency: string }) {
  try {
    const result: any = await calculatePremium({
      productId: resolvedProductId.value,
      ...form
    }, 'whole_life')
    // 增额寿：从 projection 结果中提取保费信息
    const annualPremium = result.premium || form.coverage
    const totalPremium = result.summary?.totalPremium || form.coverage * parseInt(String(form.paymentPeriod).replace(/[^0-9]/g, ''))
    premiumCalcRef.value?.setResult({
      premium: annualPremium,
      totalPremium
    })
  } catch (e) {
    console.error('保费计算错误:', e)
    ElMessage.error('保费计算失败，请稍后重试')
  }
}

async function handleProjection() {
  if (!projectionForm.value.paymentPeriod) {
    ElMessage.warning('请选择缴费期限')
    return
  }
  projecting.value = true
  try {
    const result = await getBenefitProjection('whole_life', {
      productId: resolvedProductId.value,
      ...projectionForm.value,
      dividendRate: dividendRate.value / 100
    })
    projectionResult.value = result
    nextTick(() => {
      renderChart()
    })
  } catch {
    ElMessage.error('利益演示计算失败，请稍后重试')
  } finally {
    projecting.value = false
  }
}

function renderChart() {
  if (!chartRef.value || !projectionResult.value) return
  const chart = echarts.init(chartRef.value)
  const data = projectionResult.value.yearlyData

  const option = {
    title: { text: '现金价值走势', left: 'center', textStyle: { color: 'var(--text-primary)', fontSize: 16 } },
    tooltip: { trigger: 'axis', backgroundColor: 'rgba(0,0,0,0.8)', borderColor: 'var(--accent-purple)', textStyle: { color: '#fff' } },
    legend: { data: ['现金价值', '累计保费', '身故金'], bottom: 0, textStyle: { color: 'var(--text-secondary)' } },
    grid: { left: '3%', right: '4%', bottom: '15%', containLabel: true },
    xAxis: {
      type: 'category',
      data: data.map((d) => d.year + '年'),
      axisLine: { lineStyle: { color: 'var(--border-color)' } },
      axisLabel: { color: 'var(--text-muted)' }
    },
    yAxis: {
      type: 'value',
      axisLabel: { formatter: (val: number) => val / 10000 + '万', color: 'var(--text-muted)' },
      splitLine: { lineStyle: { color: 'var(--border-color)', type: 'dashed' } }
    },
    series: [
      {
        name: '现金价值', type: 'line', smooth: true,
        data: data.map((d) => d.cashValue),
        itemStyle: { color: '#00f0ff' },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(0, 240, 255, 0.3)' },
            { offset: 1, color: 'rgba(0, 240, 255, 0.02)' }
          ])
        },
        lineStyle: { width: 2, shadowColor: 'rgba(0, 240, 255, 0.5)', shadowBlur: 10 }
      },
      {
        name: '累计保费', type: 'line', smooth: true,
        data: data.map((d) => d.accumulatedPremium),
        itemStyle: { color: '#67c23a' },
        lineStyle: { width: 2 }
      },
      {
        name: '身故金', type: 'line', smooth: true,
        data: data.map((d) => d.deathBenefit),
        itemStyle: { color: '#c855f0' },
        lineStyle: { width: 2, type: 'dashed' }
      }
    ]
  }

  chart.setOption(option)
}

function saveColumnPreference() {
  local.set(COLUMN_STORAGE_KEY, selectedColumns.value)
  columnDialogVisible.value = false
  ElMessage.success('列偏好已保存')
}

function resetColumns() {
  selectedColumns.value = [...defaultColumns]
  ElMessage.success('已恢复默认列设置')
}

// 前3大股东
const top3Shareholders = computed(() => {
  const shareholders = detail.value?.company?.shareholders || []
  return [...shareholders]
    .sort((a: any, b: any) => b.ratioValue - a.ratioValue)
    .slice(0, 3)
})

// 查看公司详情 - 跳转到星系视图并打开对应公司
function handleViewCompanyDetail() {
  const cid = detail.value?.companyId
  if (cid) {
    router.push({ path: '/cosmos', query: { companyId: String(cid) } })
  } else {
    ElMessage.warning('暂无公司详情')
  }
}
</script>

<style scoped>
.product-detail-page {
  padding-bottom: 24px;
}

.detail-title {
  font-size: 18px;
  font-weight: 600;
  margin-right: 12px;
}

.type-tag,
.status-tag {
  vertical-align: middle;
  margin-right: 8px;
}

.info-card {
  margin-top: 20px;
}

.product-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  flex-wrap: wrap;
  gap: 12px;
}

.company-info {
  display: flex;
  align-items: center;
  gap: 16px;
}

.company-logo-large {
  width: 60px;
  height: 60px;
  object-fit: contain;
  border-radius: var(--radius-md);
  border: 1px solid var(--border-color);
  background: var(--bg-card);
  padding: 4px;
}

.company-info h2 {
  font-size: 20px;
  font-weight: 600;
  margin-bottom: 4px;
  color: var(--text-primary);
}

.company-info p {
  color: var(--text-secondary);
}

.product-actions {
  display: flex;
  gap: 12px;
}

.section-card {
  margin-top: 20px;
}

.section-header-icon {
  color: var(--accent-purple);
  margin-right: 6px;
  font-size: 14px;
}

.header-switch {
  float: right;
  margin-left: auto;
}

.section-subtitle {
  font-size: 15px;
  font-weight: 600;
  color: var(--text-primary);
  margin: 20px 0 12px;
  padding-left: 10px;
  border-left: 3px solid var(--accent-cyan);
}

.responsibilities-section {
  margin-top: 8px;
}

/* 核心指标汇总卡片 */
.summary-cards {
  margin-bottom: 20px;
}

.metric-card {
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-lg);
  padding: 16px 12px;
  text-align: center;
  position: relative;
  overflow: hidden;
  transition: all var(--transition-normal);
}

.metric-card:hover {
  border-color: var(--border-glow);
  box-shadow: var(--shadow-neon-purple);
  transform: translateY(-2px);
}

.metric-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: var(--gradient-main);
}

.metric-label {
  font-size: 12px;
  margin-bottom: 6px;
  color: var(--text-secondary);
  letter-spacing: 0.5px;
}

.metric-value {
  font-size: 22px;
  font-weight: 700;
  color: var(--text-primary);
  font-family: var(--font-display);
}

.metric-unit {
  font-size: 14px;
  margin-left: 2px;
  font-weight: 500;
}

.neon-text-cyan {
  color: var(--accent-cyan);
  text-shadow: 0 0 8px rgba(0, 240, 255, 0.5), 0 0 16px rgba(0, 240, 255, 0.3);
}

.neon-text-purple {
  color: var(--accent-purple);
  text-shadow: 0 0 8px rgba(200, 85, 240, 0.5), 0 0 16px rgba(200, 85, 240, 0.3);
}

.neon-text-orange {
  color: var(--accent-orange);
  text-shadow: 0 0 8px rgba(255, 170, 0, 0.5), 0 0 16px rgba(255, 170, 0, 0.3);
}

.neon-text-green {
  color: #67c23a;
  text-shadow: 0 0 8px rgba(103, 194, 58, 0.5), 0 0 16px rgba(103, 194, 58, 0.3);
}

.summary-extra {
  display: flex;
  gap: 8px;
  margin-top: 12px;
  flex-wrap: wrap;
}

.projection-header {
  margin-bottom: 16px;
}

.projection-form-inline {
  margin-bottom: 0;
}

.chart-container {
  width: 100%;
  height: 400px;
  margin-bottom: 20px;
}

.detail-breadcrumb {
  margin-top: 12px;
  margin-bottom: 4px;
}

/* 保障责任列表 */
.benefits-container {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.benefit-item {
  display: flex;
  align-items: center;
  padding: 14px 18px;
  background: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  transition: all var(--transition-fast);
}

.benefit-item:hover {
  border-color: var(--accent-purple);
  background: var(--bg-card-hover);
  box-shadow: 0 0 12px rgba(200, 85, 240, 0.15);
}

.benefit-name {
  flex: 0 0 200px;
  font-weight: 600;
  color: var(--text-primary);
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.benefit-icon {
  color: var(--accent-cyan);
  font-size: 12px;
}

.benefit-desc {
  flex: 1;
  color: var(--text-secondary);
  font-size: 13px;
  padding: 0 20px;
  line-height: 1.6;
}

/* 投保规则卡片 */
.rules-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 14px;
  padding: 8px 0;
}

.rule-card {
  display: flex;
  align-items: flex-start;
  gap: 14px;
  padding: 16px;
  background: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  transition: all var(--transition-fast);
}

.rule-card:hover {
  border-color: var(--accent-cyan);
  box-shadow: 0 0 12px rgba(0, 240, 255, 0.15);
  transform: translateY(-2px);
}

.rule-icon {
  font-size: 24px;
  flex-shrink: 0;
}

.rule-content {
  flex: 1;
  min-width: 0;
}

.rule-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 6px;
}

.rule-desc {
  font-size: 13px;
  color: var(--text-secondary);
  line-height: 1.6;
}

/* 责任免除 */
.exclusion-content {
  padding: 8px 0;
}

.exclusion-alert {
  margin-bottom: 20px;
  --el-alert-warning-bg-color: rgba(255, 170, 0, 0.08);
  --el-alert-warning-text-color: var(--accent-orange);
  --el-alert-warning-border-color: rgba(255, 170, 0, 0.3);
}

.exclusion-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.exclusion-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 12px 16px;
  background: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
}

.exclusion-num {
  flex-shrink: 0;
  width: 24px;
  height: 24px;
  line-height: 24px;
  text-align: center;
  background: rgba(255, 68, 102, 0.15);
  color: #ff4466;
  border-radius: 50%;
  font-size: 12px;
  font-weight: 600;
}

.exclusion-text {
  flex: 1;
  font-size: 13px;
  color: var(--text-secondary);
  line-height: 1.8;
}

/* 保险公司详情 */
.company-detail {
  padding: 8px 0;
}

.company-header {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 24px;
  padding-bottom: 20px;
  border-bottom: 1px solid var(--border-color);
}

.company-logo-box {
  width: 72px;
  height: 72px;
  border-radius: var(--radius-lg);
  background: var(--gradient-main);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  box-shadow: 0 0 20px rgba(200, 85, 240, 0.3);
}

.company-logo-text {
  color: #fff;
  font-size: 24px;
  font-weight: 700;
}

.company-basic h3 {
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 8px;
}

.company-tags {
  display: flex;
  gap: 8px;
}

.company-desc {
  margin-top: 16px;
}

.solvency-good {
  color: #67c23a;
  font-weight: 600;
}

.solvency-normal {
  color: var(--accent-orange);
  font-weight: 600;
}

.solvency-bad {
  color: #ff4466;
  font-weight: 600;
}

/* 空状态占位 */
.empty-placeholder {
  text-align: center;
  padding: 60px 20px;
  color: var(--text-muted);
}

.empty-icon {
  font-size: 48px;
  color: var(--text-muted);
  margin-bottom: 16px;
}

.empty-placeholder p {
  margin: 8px 0;
  font-size: 14px;
}

/* Tab 样式微调 */
:deep(.el-tabs__header) {
  margin-bottom: 20px;
}

:deep(.el-tabs__item) {
  font-size: 14px;
}

:deep(.el-tabs__active-bar) {
  background: var(--gradient-main);
}

/* 响应式适配 */
@media (max-width: 768px) {
  .benefit-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }
  .benefit-name {
    flex: none;
  }
  .benefit-desc {
    padding: 0;
  }
  .rules-container {
    grid-template-columns: 1fr;
  }
}

/* 股东部分样式 */
.shareholders-section {
  margin-top: 20px;
  padding-top: 16px;
  border-top: 1px solid var(--border-color-light, #ebeef5);
}
.section-head {
  display: flex;
  align-items: baseline;
  gap: 10px;
  margin-bottom: 12px;
}
.section-title {
  font-size: 15px;
  font-weight: 600;
  color: var(--text-primary);
}
.section-sub {
  font-size: 12px;
  color: var(--text-secondary, #909399);
}
.shareholders-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.shareholder-row {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 14px;
  background: var(--bg-page, #f5f7fa);
  border-radius: 10px;
  transition: background 0.15s;
}
.shareholder-row:hover {
  background: var(--bg-card-hover, #eef1f6);
}
.sh-rank-badge {
  width: 24px;
  height: 24px;
  border-radius: 6px;
  background: #c0c4cc;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 600;
  flex-shrink: 0;
}
.shareholder-row:nth-child(1) .sh-rank-badge {
  background: linear-gradient(135deg, #f59e0b, #d97706);
}
.shareholder-row:nth-child(2) .sh-rank-badge {
  background: linear-gradient(135deg, #94a3b8, #64748b);
}
.shareholder-row:nth-child(3) .sh-rank-badge {
  background: linear-gradient(135deg, #cd7f32, #a0522d);
}
.sh-info {
  flex: 1;
  min-width: 0;
}
.sh-name {
  font-size: 14px;
  font-weight: 500;
  color: var(--text-primary);
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 2px;
}
.sh-type {
  font-size: 12px;
  color: var(--text-secondary, #909399);
}
.sh-ratio-block {
  flex-shrink: 0;
  text-align: right;
  min-width: 90px;
}
.sh-ratio-num {
  font-size: 15px;
  font-weight: 600;
  color: #ffd27a;
  font-variant-numeric: tabular-nums;
  margin-bottom: 4px;
}
.sh-ratio-bar {
  width: 80px;
  height: 4px;
  background: #e4e7ed;
  border-radius: 2px;
  overflow: hidden;
  margin-left: auto;
}
.sh-ratio-fill {
  height: 100%;
  background: linear-gradient(90deg, #ffd27a, #fbbf24);
  border-radius: 2px;
  transition: width 0.5s ease;
}

/* 公司详情头部按钮适配 */
.company-header {
  position: relative;
}
.company-header .el-button {
  margin-left: auto;
}
</style>
