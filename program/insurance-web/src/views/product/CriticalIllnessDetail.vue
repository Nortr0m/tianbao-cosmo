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

        <!-- 产品一句话简介 -->
        <div v-if="detail.productBrief" class="product-brief">
          {{ detail.productBrief }}
        </div>

        <!-- 产品亮点 -->
        <div v-if="parsedHighlights.length > 0" class="product-highlights">
          <div
            v-for="(h, idx) in parsedHighlights"
            :key="idx"
            class="highlight-item"
          >
            <span class="highlight-icon">✦</span>
            <span>{{ h }}</span>
          </div>
        </div>

        <el-descriptions :column="3" border>
          <el-descriptions-item label="产品类型">{{ detail.productTypeDesc || detail.productType }}</el-descriptions-item>
          <el-descriptions-item label="投保年龄">{{ detail.minAge }} - {{ detail.maxAge }} 岁</el-descriptions-item>
          <el-descriptions-item label="职业类别">{{ detail.occupationClass }}</el-descriptions-item>
          <el-descriptions-item label="缴费期限">{{ parsedPaymentPeriods.join('、') }}年</el-descriptions-item>
          <el-descriptions-item label="缴费方式">{{ parsedPaymentFrequencies.length ? parsedPaymentFrequencies.map(f => f.label).join('、') : '年缴' }}</el-descriptions-item>
          <el-descriptions-item label="等待期">{{ detail?.terms?.waitingPeriod || '-' }}</el-descriptions-item>
          <el-descriptions-item label="保险期间" v-if="detail?.terms?.insurancePeriod">{{ detail.terms.insurancePeriod }}</el-descriptions-item>
          <el-descriptions-item label="犹豫期" v-if="detail?.terms?.hesitationPeriod">{{ detail.terms.hesitationPeriod }}</el-descriptions-item>
          <el-descriptions-item label="销售地区" v-if="detail?.terms?.saleRegion">{{ detail.terms.saleRegion }}</el-descriptions-item>
        </el-descriptions>
      </el-card>

      <!-- 核心保障指标 -->
      <el-card v-if="detail?.subProductData" class="section-card">
        <template #header><span class="section-header-icon">◆</span><span>核心保障指标</span></template>
        <el-descriptions :column="3" border>
          <el-descriptions-item label="等待期">
            <template v-if="detail.subProductData.waitingPeriod">
              {{ detail.subProductData.waitingPeriod }}天
            </template>
            <template v-else>{{ detail?.terms?.waitingPeriod || '-' }}</template>
          </el-descriptions-item>
          <el-descriptions-item label="犹豫期">{{ detail?.terms?.hesitationPeriod || '-' }}</el-descriptions-item>
          <el-descriptions-item label="保险期间">{{ detail?.terms?.insurancePeriod || '终身' }}</el-descriptions-item>
          <el-descriptions-item label="法定重疾覆盖">
            <span class="stat-highlight">28种全覆盖</span>
          </el-descriptions-item>
          <el-descriptions-item label="疾病总数量">
            <span class="stat-highlight">{{ totalDiseaseCount }}种</span>
          </el-descriptions-item>
          <el-descriptions-item label="高发疾病覆盖">
            <span class="stat-highlight">{{ highRiskDiseaseCount }}种</span>
          </el-descriptions-item>
        </el-descriptions>

        <!-- 重疾/中症/轻症统计卡片 -->
        <div v-if="detail.subProductData.criticalCount || detail.subProductData.mediumCount || detail.subProductData.lightCount" class="disease-stats">
          <el-row :gutter="16">
            <el-col :span="8">
              <div class="stat-card stat-critical tb-immortal-card">
                <div class="stat-icon">重</div>
                <div class="stat-label">重大疾病</div>
                <div class="stat-value">{{ detail.subProductData.criticalCount || '-' }}<span class="stat-unit">种</span></div>
                <div class="stat-detail" v-if="detail.subProductData.criticalRatio">赔付{{ detail.subProductData.criticalRatio }}%</div>
                <div class="stat-detail" v-if="detail.subProductData.criticalPayTimes">最多{{ detail.subProductData.criticalPayTimes }}次</div>
                <div class="stat-badge stat-badge-gold" v-if="statutoryCriticalCount > 0">
                  含法定{{ statutoryCriticalCount }}种
                </div>
              </div>
            </el-col>
            <el-col :span="8">
              <div class="stat-card stat-medium tb-immortal-card">
                <div class="stat-icon">中</div>
                <div class="stat-label">中症疾病</div>
                <div class="stat-value">{{ detail.subProductData.mediumCount || '-' }}<span class="stat-unit">种</span></div>
                <div class="stat-detail" v-if="detail.subProductData.mediumRatio">赔付{{ detail.subProductData.mediumRatio }}%</div>
                <div class="stat-detail" v-if="detail.subProductData.mediumPayTimes">最多{{ detail.subProductData.mediumPayTimes }}次</div>
                <div class="stat-badge stat-badge-orange">
                  不分组赔付
                </div>
              </div>
            </el-col>
            <el-col :span="8">
              <div class="stat-card stat-light tb-immortal-card">
                <div class="stat-icon">轻</div>
                <div class="stat-label">轻症疾病</div>
                <div class="stat-value">{{ detail.subProductData.lightCount || '-' }}<span class="stat-unit">种</span></div>
                <div class="stat-detail" v-if="detail.subProductData.lightRatio">赔付{{ detail.subProductData.lightRatio }}%</div>
                <div class="stat-detail" v-if="detail.subProductData.lightPayTimes">最多{{ detail.subProductData.lightPayTimes }}次</div>
                <div class="stat-badge stat-badge-cyan" v-if="statutoryLightCount > 0">
                  含法定{{ statutoryLightCount }}种
                </div>
              </div>
            </el-col>
          </el-row>
        </div>

        <el-alert
          v-if="detail.subProductData.diseaseCareAge"
          :title="`疾病关爱金：${detail.subProductData.diseaseCareAge}岁前额外赔付 重疾${detail.subProductData.diseaseCareCriticalRatio || '-'}% / 中症${detail.subProductData.diseaseCareMediumRatio || '-'}% / 轻症${detail.subProductData.diseaseCareLightRatio || '-'}%`"
          type="warning"
          :closable="false"
          class="care-alert"
        />
      </el-card>

      <!-- Responsibility Config -->
      <el-card class="section-card">
        <template #header>
          <span class="section-header-icon">◇</span><span>方案配置</span>
        </template>
        <ResponsibilityConfig
          v-if="detail?.responsibilities?.length"
          v-model="responsibilityConfig"
          :items="detail.responsibilities"
          @change="handleResponsibilityChange"
        />
        <el-empty v-else description="暂无责任配置数据" />
      </el-card>

      <!-- Premium Calculator -->
      <el-card class="section-card">
        <template #header>
          <span class="section-header-icon">¥</span><span>保费计算器</span>
        </template>
        <PremiumCalculator
          ref="premiumCalcRef"
          :payment-periods="parsedPaymentPeriods"
          :payment-frequencies="parsedPaymentFrequencies"
          :default-coverage="500000"
          :min-age="detail.minAge"
          :max-age="detail.maxAge"
          @calculate="handleCalculatePremium"
        />
      </el-card>

      <!-- Tabs - 使用 lazy 属性实现懒加载，非激活tab的内容首次激活时才渲染 -->
      <el-card class="section-card">
        <el-tabs v-model="activeTab">
          <!-- 保障责任tab -->
          <el-tab-pane label="保障责任" name="benefits" lazy>
            <div v-if="benefitCategories.length > 0" class="benefits-container">
              <div v-for="category in benefitCategories" :key="category.key" class="benefit-category">
                <div class="category-header">
                  <span class="category-icon">{{ category.icon }}</span>
                  <span class="category-title">{{ category.label }}</span>
                  <el-tag v-if="category.key === 'BASE'" size="small" type="primary" effect="dark" class="category-tag">
                    必选责任
                  </el-tag>
                  <el-tag v-else size="small" type="warning" effect="plain" class="category-tag">
                    可选责任
                  </el-tag>
                </div>
                <div class="benefit-cards">
                  <div
                    v-for="(item, index) in category.items"
                    :key="index"
                    class="benefit-card"
                    :class="{ 'benefit-required': item.isRequired, 'benefit-optional': !item.isRequired && item.supported }"
                  >
                    <div class="benefit-card-header">
                      <div class="benefit-name">
                        <span class="benefit-icon">✦</span>
                        {{ item.name }}
                      </div>
                      <div class="benefit-tags">
                        <el-tag v-if="item.isRequired && item.supported" size="small" type="primary" effect="dark">
                          必选
                        </el-tag>
                        <el-tag v-else-if="item.supported" size="small" type="success" effect="plain">
                          可选
                        </el-tag>
                        <el-tag v-else size="small" type="info" effect="plain">
                          不支持
                        </el-tag>
                      </div>
                    </div>
                    <div class="benefit-desc">{{ item.description }}</div>
                    <div class="benefit-footer">
                      <div class="benefit-value" v-if="item.value">
                        {{ item.value }}
                      </div>
                      <div class="benefit-type" v-if="item.optionType">
                        <el-tag size="small" :type="item.optionType === 'switch' ? 'primary' : 'warning'" effect="plain">
                          {{ item.optionType === 'switch' ? '开关型' : '选择型' }}
                        </el-tag>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div v-else class="empty-placeholder">
              <el-icon class="empty-icon"><Document /></el-icon>
              <p>具体保障责任请参阅产品条款</p>
            </div>
          </el-tab-pane>

          <!-- 疾病清单tab - 懒加载，减少初始渲染开销 -->
          <el-tab-pane label="疾病清单" name="diseases" lazy>
            <DiseaseList v-if="detail?.diseases?.length" :diseases="detail.diseases" />
            <div v-else class="empty-placeholder">
              <el-icon class="empty-icon"><List /></el-icon>
              <p>具体疾病清单请参阅产品条款</p>
              <p class="empty-sub">本产品保障的疾病种类及定义以保险合同条款为准</p>
            </div>
          </el-tab-pane>

          <!-- 保险公司tab - 懒加载 -->
          <el-tab-pane label="保险公司" name="company" lazy>
            <div class="company-tab-content">
              <div class="company-tab-header">
                <div class="company-tab-info">
                  <div class="company-tab-logo">
                    {{ detail.companyName.substring(0, 2) }}
                  </div>
                  <div>
                    <h3 class="company-tab-name">{{ detail.companyName }}</h3>
                    <div class="company-tab-tags">
                      <el-tag size="small" type="primary">{{ detail.company?.companyTypeDesc || '-' }}</el-tag>
                      <el-tag v-if="detail.company?.riskRating" size="small" type="warning">{{ detail.company.riskRating }}级</el-tag>
                    </div>
                  </div>
                </div>
                <el-button type="primary" size="default" @click="handleViewCompanyDetail">
                  <el-icon><View /></el-icon> 查看公司详情
                </el-button>
              </div>

              <el-descriptions :column="2" border class="company-desc">
                <el-descriptions-item label="成立时间">{{ detail.company?.foundedYear || '-' }}年</el-descriptions-item>
                <el-descriptions-item label="注册资本">{{ detail.company?.registeredCapital ? formatCurrency(detail.company.registeredCapital, 0) : '-' }}亿元</el-descriptions-item>
                <el-descriptions-item label="公司性质">{{ detail.company?.companyTypeDesc || '-' }}</el-descriptions-item>
                <el-descriptions-item label="风险评级">{{ detail.company?.riskRating || '-' }}</el-descriptions-item>
                <el-descriptions-item label="偿付能力">{{ detail.company?.solvencyRatio ? detail.company.solvencyRatio + '%' : '-' }}</el-descriptions-item>
                <el-descriptions-item label="客服热线">{{ detail.company?.hotline || '-' }}</el-descriptions-item>
                <el-descriptions-item label="官网" :span="2">
                  <el-link v-if="detail.company?.website" :href="'https://' + detail.company.website" target="_blank" type="primary">
                    {{ detail.company.website }}
                  </el-link>
                  <span v-else>-</span>
                </el-descriptions-item>
                <el-descriptions-item label="公司简介" :span="2">
                  {{ detail.company?.description || '暂无简介' }}
                </el-descriptions-item>
              </el-descriptions>

              <!-- 主要股东 -->
              <div v-if="detail.company?.shareholders && detail.company.shareholders.length > 0" class="shareholders-section">
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
          </el-tab-pane>

          <!-- 责任免除tab - 懒加载 -->
          <el-tab-pane label="责任免除" name="exclusion" lazy>
            <div v-if="detail?.terms?.exclusionSummary" class="rule-text">
              {{ detail.terms.exclusionSummary }}
            </div>
            <div v-else class="empty-placeholder">
              <el-icon class="empty-icon"><Warning /></el-icon>
              <p>具体责任免除请参阅产品条款</p>
            </div>
          </el-tab-pane>
        </el-tabs>
      </el-card>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Document, List, Warning, View } from '@element-plus/icons-vue'
import { useProduct } from '@/composables/useProduct'
import { useCompareStore } from '@/stores/compareStore'
import { usePermission } from '@/composables/usePermission'
import { calculatePremium } from '@/api/calculate'
import { formatCurrency } from '@/utils/format'
import ResponsibilityConfig from '@/components/business/ResponsibilityConfig.vue'
import PremiumCalculator from '@/components/business/PremiumCalculator.vue'
import DiseaseList from '@/components/business/DiseaseList.vue'

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
  if (window.history.length > 1) {
    router.back()
  } else {
    router.push('/product/list')
  }
}

const activeTab = ref('benefits')
const responsibilityConfig = ref<Record<string, unknown>>({})
const premiumCalcRef = ref<InstanceType<typeof PremiumCalculator>>()

const parsedPaymentPeriods = computed(() => {
  const raw = safeParseJSON<string[]>(detail.value?.paymentYears ?? detail.value?.paymentPeriods, [])
  // 过滤掉非数字的异常值（如 "yearly"、"monthly" 等缴费周期字符串）
  const filtered = raw.filter((p: string) => {
    const num = parseInt(String(p).replace(/[^0-9]/g, ''))
    return !isNaN(num) && num > 0 && num <= 100
  }).map((p: string) => String(parseInt(String(p).replace(/[^0-9]/g, ''))))
  // 如果过滤后为空，使用默认值
  if (filtered.length === 0) {
    return ['10', '20', '30']
  }
  return filtered
})

// 解析产品亮点
const parsedHighlights = computed(() => {
  const h = detail.value?.productHighlights
  if (!h) return []
  if (Array.isArray(h)) return h
  try { return JSON.parse(h) } catch { return [] }
})

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

// 疾病统计
const totalDiseaseCount = computed(() => {
  const d = detail.value
  if (!d?.diseases?.length) {
    return (d?.subProductData?.criticalCount || 0) +
      (d?.subProductData?.mediumCount || 0) +
      (d?.subProductData?.lightCount || 0)
  }
  return d.diseases.length
})

const statutoryCriticalCount = computed(() => {
  return detail.value?.diseases?.filter(d => d.type === 'critical' && d.isStatutory).length || 0
})

const statutoryLightCount = computed(() => {
  return detail.value?.diseases?.filter(d => d.type === 'light' && d.isStatutory).length || 0
})

const highRiskDiseaseCount = computed(() => {
  return detail.value?.diseases?.filter(d => d.isHighRisk).length || 0
})

// 保障责任按分类分组
const benefitCategories = computed(() => {
  const items = detail.value?.responsibilities || []
  if (!items.length) return []

  const categoryMap: Record<string, { label: string; icon: string; items: any[] }> = {}

  items.forEach((item: any) => {
    const catCode = item.category || 'OTHER'
    const catName = item.categoryName || '其他责任'

    if (!categoryMap[catCode]) {
      categoryMap[catCode] = {
        label: catName,
        icon: getCategoryIcon(catCode, catName),
        items: []
      }
    }

    // 判断是否必选：BASE分类 或 defaultOption不为空
    const isRequired = catCode === 'BASE' || (item.defaultOption !== undefined && item.defaultOption !== null && item.defaultOption !== '')

    // 扁平化后的数据已包含 name/code/supported/optionType 等兼容字段，直接使用
    categoryMap[catCode].items.push({
      name: item.name || item.itemName,
      code: item.code || item.itemCode,
      supported: item.supported ?? (item.isSupported === 1),
      description: item.description || '',
      value: parsePremiumValue(item.premiumCoefficient, item.itemCode || item.code, item.optionType),
      optionType: item.optionType || '',
      isRequired,
      defaultOption: item.defaultOption,
      options: item.options || []
    })
  })

  return Object.entries(categoryMap)
    .map(([key, cat]) => ({ key, ...cat }))
    .sort((a, b) => {
      // 基础责任排最前
      if (a.key === 'BASE') return -1
      if (b.key === 'BASE') return 1
      return 0
    })
})

// 根据分类代码或名称获取图标
function getCategoryIcon(code: string, name: string): string {
  const iconMap: Record<string, string> = {
    BASE: '🛡',
    DEATH: '⚰',
    WAIVER: '📋',
    MULTI_PAY: '♻',
    BONUS: '🎁',
    ALLOWANCE: '💰',
    SPECIAL: '⭐',
    OTHER: '📌'
  }
  if (iconMap[code]) return iconMap[code]
  // 根据名称匹配
  if (name.includes('基础') || name.includes('重疾') || name.includes('轻症') || name.includes('中症')) return '🛡'
  if (name.includes('身故') || name.includes('全残') || name.includes('终末期')) return '⚰'
  if (name.includes('豁免')) return '📋'
  if (name.includes('多次') || name.includes('癌症') || name.includes('心脑血管')) return '♻'
  if (name.includes('关爱') || name.includes('额外')) return '🎁'
  if (name.includes('津贴') || name.includes('补助')) return '💰'
  if (name.includes('特定') || name.includes('特色') || name.includes('特殊')) return '⭐'
  return '📌'
}

// 解析保费系数JSON，返回可读的赔付描述
function parsePremiumValue(premiumCoefficient: string | undefined | null, _itemCode: string, optionType: string): string {
  if (!premiumCoefficient) return ''
  let parsed = tryParse(premiumCoefficient)
  if (!parsed) return ''

  // 如果是对象形式的系数
  if (typeof parsed === 'object') {
    const entries = Object.entries(parsed)
    if (entries.length === 0) return ''

    // 对于开关型责任，显示主要赔付比例
    if (optionType === 'switch') {
      const trueVal = parsed['true'] ?? parsed['on'] ?? parsed['1']
      if (trueVal !== undefined) {
        const ratio = Number(trueVal)
        if (ratio > 1) {
          const extra = ((ratio - 1) * 100).toFixed(0)
          return `额外赔付${extra}%`
        }
        return `赔付${(ratio * 100).toFixed(0)}%保额`
      }
      return ''
    }

    // 对于选择型/单选型，返回所有选项的赔付描述
    const descriptions: string[] = []
    for (const [key, val] of entries) {
      const ratio = Number(val)
      if (isNaN(ratio)) continue

      // 根据责任代码判断展示内容
      let label = key
      if (key === 'true' || key === 'on' || key === '1') label = '开启'
      if (key === 'false' || key === 'off' || key === '0') label = '关闭'

      if (ratio > 1) {
        const extra = ((ratio - 1) * 100).toFixed(0)
        descriptions.push(`${label}: 额外${extra}%`)
      } else if (ratio > 0) {
        descriptions.push(`${label}: ${(ratio * 100).toFixed(0)}%`)
      }
    }
    return descriptions.join(' | ')
  }

  // 如果是数字形式
  const num = Number(parsed)
  if (!isNaN(num) && num > 0) {
    return `赔付${(num * 100).toFixed(0)}%保额`
  }

  return ''
}

function tryParse(str: string): any {
  try { return JSON.parse(str) } catch { return null }
}

// 初始化responsibilityConfig默认值
function initResponsibilityConfig(items: any[]) {
  const config: Record<string, unknown> = {}
  items.forEach(item => {
    // 判断是否必选
    const isRequired = item.category === 'BASE' || (item.defaultOption !== undefined && item.defaultOption !== null && item.defaultOption !== '')
    if (item.defaultValue !== undefined) {
      config[item.code] = item.defaultValue
    } else if (item.optionType === 'switch') {
      // 必选责任默认开启，可选责任默认关闭
      config[item.code] = isRequired ? true : false
    } else if (item.optionType === 'checkbox') {
      config[item.code] = []
    } else if (item.optionType === 'amount') {
      config[item.code] = item.min || 0
    } else {
      config[item.code] = item.options?.[0]?.value || ''
    }
  })
  return config
}

onMounted(async () => {
  await fetchDetail(resolvedProductId.value)
  // 初始化责任配置默认值
  if (detail.value?.responsibilities?.length) {
    responsibilityConfig.value = initResponsibilityConfig(detail.value.responsibilities)
  }
})

function safeParseJSON<T>(str: string | undefined, defaultVal: T): T {
  if (!str) return defaultVal
  try { return JSON.parse(str) } catch { return defaultVal }
}

function handleToggleCompare() {
  const result = compareStore.toggleProductSelection(resolvedProductId.value, detail.value?.productType ?? 1, maxCompareCount.value)
  if (!result.success && result.error) {
    ElMessage.warning(result.error)
  }
}

function goToCardGenerate() {
  router.push(`/card/generate?productId=${resolvedProductId.value}`)
}

function handleResponsibilityChange(code: string, value: unknown) {
  console.log('Responsibility changed:', code, value)
  // 方案变化后重置计算结果
  if (premiumCalcRef.value) {
    premiumCalcRef.value.setLoading(false)
  }
}

async function handleCalculatePremium(form: { age: number; gender: 'male' | 'female'; coverage: number; paymentPeriod: string; paymentFrequency: string }) {
  try {
    const result: any = await calculatePremium({
      productId: resolvedProductId.value,
      ...form,
      responsibilityConfig: responsibilityConfig.value
    }, 'critical_illness')

    // 业务错误：后端返回 errorMessage
    if (result.errorMessage) {
      premiumCalcRef.value?.setResult({
        premium: 0,
        totalPremium: 0,
        components: [],
        errorMessage: result.errorMessage
      })
      return
    }

    // 后端返回 CriticalPremiumVO: { annualPremium, monthlyPremium, quarterlyPremium, halfYearlyPremium, totalPremium, premiumComponents }
    // 根据缴费周期选择对应保费
    const premiumMap: Record<string, number> = {
      year: result.annualPremium || 0,
      half_year: result.halfYearlyPremium || result.annualPremium || 0,
      quarter: result.quarterlyPremium || result.annualPremium || 0,
      month: result.monthlyPremium || result.annualPremium || 0
    }
    premiumCalcRef.value?.setResult({
      premium: premiumMap[form.paymentFrequency] || result.annualPremium || 0,
      totalPremium: result.totalPremium || 0,
      components: result.premiumComponents || []
    })
  } catch (e: any) {
    console.error('保费计算错误:', e)
    const errorMsg = e?.message || '保费计算失败，请稍后重试'
    premiumCalcRef.value?.setResult({
      premium: 0,
      totalPremium: 0,
      components: [],
      errorMessage: errorMsg
    })
  }
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

.product-brief {
  background: linear-gradient(135deg, var(--primary-light), var(--primary-soft));
  border-left: 4px solid var(--primary-color);
  padding: 14px 20px;
  border-radius: var(--radius-md);
  font-size: 15px;
  color: var(--text-primary);
  line-height: 1.6;
  margin-bottom: 16px;
}

.product-highlights {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 16px;
}

.highlight-item {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 14px;
  background: var(--bg-soft);
  border: 1px solid var(--border-color);
  border-radius: 20px;
  font-size: 13px;
  color: var(--text-secondary);
}

.highlight-icon {
  color: var(--primary-color);
  font-size: 12px;
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

.stat-highlight {
  color: var(--accent-cyan);
  font-weight: 600;
  font-size: 15px;
}

/* 核心保障指标卡片 */
.disease-stats {
  margin-top: 20px;
}

.stat-card {
  text-align: center;
  padding: 24px 12px 20px;
  position: relative;
  border-radius: var(--radius-lg);
  border: 1px solid var(--border-color);
  background: var(--bg-secondary);
  transition: all var(--transition-normal);
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-card-hover);
}

.stat-icon {
  width: 48px;
  height: 48px;
  line-height: 48px;
  margin: 0 auto 12px;
  border-radius: 50%;
  font-size: 20px;
  font-weight: 700;
  color: #fff;
}

.stat-critical .stat-icon {
  background: linear-gradient(135deg, #ff4466, #c855f0);
  box-shadow: 0 0 16px rgba(255, 68, 102, 0.4);
}

.stat-medium .stat-icon {
  background: linear-gradient(135deg, #ffaa00, #ff4466);
  box-shadow: 0 0 16px rgba(255, 170, 0, 0.4);
}

.stat-light .stat-icon {
  background: linear-gradient(135deg, #00f0ff, #00ffaa);
  box-shadow: 0 0 16px rgba(0, 240, 255, 0.4);
  color: #070714;
}

.stat-label {
  font-size: 14px;
  color: var(--text-secondary);
  margin-bottom: 8px;
}

.stat-value {
  font-size: 32px;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 4px;
  font-family: var(--font-display);
}

.stat-unit {
  font-size: 16px;
  font-weight: 500;
  margin-left: 2px;
}

.stat-detail {
  font-size: 12px;
  color: var(--text-muted);
  margin-top: 2px;
}

/* 统计徽章 */
.stat-badge {
  position: absolute;
  top: 12px;
  right: 12px;
  padding: 2px 8px;
  border-radius: 10px;
  font-size: 11px;
  font-weight: 600;
}

.stat-badge-gold {
  background: linear-gradient(135deg, rgba(251, 191, 36, 0.2), rgba(245, 158, 11, 0.2));
  color: #fbbf24;
  border: 1px solid rgba(251, 191, 36, 0.4);
}

.stat-badge-orange {
  background: linear-gradient(135deg, rgba(255, 170, 0, 0.2), rgba(255, 68, 102, 0.2));
  color: #ffaa00;
  border: 1px solid rgba(255, 170, 0, 0.4);
}

.stat-badge-cyan {
  background: linear-gradient(135deg, rgba(0, 240, 255, 0.2), rgba(0, 255, 170, 0.2));
  color: #00f0ff;
  border: 1px solid rgba(0, 240, 255, 0.4);
}

.care-alert {
  margin-top: 16px;
  --el-alert-warning-bg-color: rgba(255, 170, 0, 0.1);
  --el-alert-warning-text-color: var(--accent-orange);
  --el-alert-warning-border-color: rgba(255, 170, 0, 0.3);
}

/* ===== 保障责任 - 分类卡片样式 ===== */
.benefits-container {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.benefit-category {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.category-header {
  display: flex;
  align-items: center;
  gap: 10px;
  padding-bottom: 8px;
  border-bottom: 1px solid var(--border-color);
}

.category-icon {
  font-size: 18px;
}

.category-title {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
}

.category-tag {
  margin-left: 4px;
}

.benefit-cards {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 12px;
}

.benefit-card {
  padding: 16px;
  background: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  transition: all var(--transition-fast);
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.benefit-card:hover {
  border-color: var(--accent-purple);
  background: var(--bg-card-hover);
  box-shadow: 0 0 12px rgba(200, 85, 240, 0.15);
  transform: translateY(-2px);
}

.benefit-optional {
  border-left: 3px solid var(--accent-orange);
}

.benefit-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.benefit-name {
  font-weight: 600;
  color: var(--text-primary);
  font-size: 15px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.benefit-icon {
  color: var(--accent-cyan);
  font-size: 12px;
}

.benefit-desc {
  color: var(--text-secondary);
  font-size: 13px;
  line-height: 1.6;
  flex: 1;
}

.benefit-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 8px;
  border-top: 1px dashed var(--border-color);
}

.benefit-value {
  color: var(--accent-orange);
  font-weight: 600;
  font-size: 14px;
}

.benefit-type {
  font-size: 12px;
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

.empty-sub {
  font-size: 12px !important;
  color: var(--text-muted);
  opacity: 0.7;
}

.detail-breadcrumb {
  margin-top: 12px;
  margin-bottom: 4px;
}

.rule-text {
  font-size: 13px;
  line-height: 1.8;
  color: var(--text-secondary);
  white-space: pre-wrap;
  padding: 8px 0;
}

/* 响应式适配 */
@media (max-width: 768px) {
  .benefit-cards {
    grid-template-columns: 1fr;
  }
}

/* 保险公司Tab增强样式 */
.company-tab-content {
  padding: 4px 0;
}
.company-tab-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
  padding-bottom: 16px;
  border-bottom: 1px solid var(--border-color-light, #ebeef5);
}
.company-tab-info {
  display: flex;
  align-items: center;
  gap: 14px;
}
.company-tab-logo {
  width: 52px;
  height: 52px;
  border-radius: 12px;
  background: linear-gradient(135deg, #ffd27a33, #ffd27a11);
  border: 1px solid #ffd27a40;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  font-weight: 600;
  color: #ffd27a;
  font-family: 'Kaiti SC', 'STKaiti', 'KaiTi', serif;
}
.company-tab-name {
  font-size: 18px;
  font-weight: 600;
  margin: 0 0 4px 0;
  color: var(--text-primary);
}
.company-tab-tags {
  display: flex;
  gap: 6px;
}
.company-desc {
  margin-bottom: 20px;
}

/* 股东部分 */
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
</style>
