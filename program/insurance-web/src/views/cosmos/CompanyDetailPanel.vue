<template>
  <div class="company-detail-panel">
    <!-- 顶部头部 -->
    <div class="panel-header">
      <div class="header-left">
        <div class="company-logo-wrap">
          <div class="company-logo-placeholder">
            {{ companyData?.companyShortName?.charAt(0) || '保' }}
          </div>
        </div>
        <div class="company-title">
          <h2 class="company-name">{{ companyData?.companyName || '加载中...' }}</h2>
          <div class="company-tags">
            <span class="tag tag-nature">{{ companyData?.companyTypeDesc || '—' }}</span>
            <span v-if="companyData?.creditRating" class="tag tag-rating">评级 {{ companyData.creditRating }}</span>
            <span v-if="companyData?.riskRating" class="tag tag-risk">风险 {{ companyData.riskRating }}</span>
          </div>
        </div>
      </div>
      <button class="panel-close-btn" @click="$emit('close')">
        <el-icon><Close /></el-icon>
      </button>
    </div>

    <!-- 核心指标条 -->
    <div class="metrics-bar" v-if="companyData">
      <div class="metric-item">
        <div class="metric-value">{{ companyData.establishedYear || '—' }}</div>
        <div class="metric-label">成立年份</div>
      </div>
      <div class="metric-divider"></div>
      <div class="metric-item">
        <div class="metric-value">{{ companyData.registeredCapital ? companyData.registeredCapital + '亿' : '—' }}</div>
        <div class="metric-label">注册资本</div>
      </div>
      <div class="metric-divider"></div>
      <div class="metric-item">
        <div class="metric-value">{{ companyData.solvencyRatio ? companyData.solvencyRatio + '%' : '—' }}</div>
        <div class="metric-label">偿付能力</div>
      </div>
      <div class="metric-divider"></div>
      <div class="metric-item">
        <div class="metric-value">{{ companyData.headquarters || '—' }}</div>
        <div class="metric-label">总部</div>
      </div>
    </div>

    <!-- Tab 内容区 -->
    <el-tabs v-model="activeTab" class="detail-tabs" tab-position="left">
      <!-- Tab1: 基本信息 -->
      <el-tab-pane label="基本信息" name="basic">
        <template #label>
          <span class="tab-label"><el-icon><InfoFilled /></el-icon>基本信息</span>
        </template>
        <div class="tab-content">
          <div class="section-block">
            <h3 class="section-title">公司信息</h3>
            <el-descriptions :column="1" border size="default" class="info-desc">
              <el-descriptions-item label="公司全称">{{ companyData?.companyName || '—' }}</el-descriptions-item>
              <el-descriptions-item label="简称">{{ companyData?.companyShortName || '—' }}</el-descriptions-item>
              <el-descriptions-item label="成立时间">{{ companyData?.establishedYear ? companyData.establishedYear + '年' : '—' }}</el-descriptions-item>
              <el-descriptions-item label="注册资本">{{ companyData?.registeredCapital ? companyData.registeredCapital + ' 亿元人民币' : '—' }}</el-descriptions-item>
              <el-descriptions-item label="总部地点">{{ companyData?.headquarters || '—' }}</el-descriptions-item>
              <el-descriptions-item label="公司性质">{{ companyData?.companyTypeDesc || '—' }}</el-descriptions-item>
              <el-descriptions-item label="风险评级">{{ companyData?.riskRating || '—' }}</el-descriptions-item>
              <el-descriptions-item label="偿付能力">{{ companyData?.solvencyRatio ? companyData.solvencyRatio + '%' : '—' }}</el-descriptions-item>
              <el-descriptions-item label="信用评级">{{ companyData?.creditRating || '—' }}</el-descriptions-item>
              <el-descriptions-item label="客服热线">
                <el-link v-if="companyData?.servicePhone" type="primary" :underline="false">
                  {{ companyData.servicePhone }}
                </el-link>
                <span v-else>—</span>
              </el-descriptions-item>
              <el-descriptions-item label="官方网站">
                <el-link v-if="companyData?.officialWebsite" :href="'https://' + companyData.officialWebsite" target="_blank" type="primary">
                  {{ companyData.officialWebsite }}
                </el-link>
                <span v-else>—</span>
              </el-descriptions-item>
            </el-descriptions>
          </div>

          <div class="section-block">
            <h3 class="section-title">公司简介</h3>
            <div class="intro-text">
              {{ companyData?.introduction || '暂无公司简介信息。' }}
            </div>
          </div>
        </div>
      </el-tab-pane>

      <!-- Tab2: 股东结构（重点） -->
      <el-tab-pane label="股东结构" name="shareholders">
        <template #label>
          <span class="tab-label"><el-icon><User /></el-icon>股东结构</span>
        </template>
        <div class="tab-content">
          <!-- 控股股东/实际控制人 -->
          <div class="section-block" v-if="controllingShareholder">
            <h3 class="section-title">
              <span class="title-icon controlling-icon">控</span>
              控股股东 / 实际控制人
            </h3>
            <div class="controlling-card">
              <div class="controlling-main">
                <div class="controlling-name">{{ controllingShareholder.name }}</div>
                <div class="controlling-type">
                  <el-tag v-if="controllingShareholder.isStateOwned" type="danger" size="small" effect="light">国资背景</el-tag>
                  <el-tag v-else-if="controllingShareholder.isForeign" type="primary" size="small" effect="light">外资背景</el-tag>
                  <el-tag v-else size="small" effect="plain">{{ controllingShareholder.type }}</el-tag>
                </div>
              </div>
              <div class="controlling-ratio">
                <div class="ratio-value">{{ controllingShareholder.ratio }}</div>
                <div class="ratio-bar">
                  <div class="ratio-fill controlling-fill" :style="{ width: Math.min(controllingShareholder.ratioValue, 100) + '%' }"></div>
                </div>
                <div class="ratio-label">持股比例</div>
              </div>
            </div>
          </div>

          <!-- 主要股东列表 -->
          <div class="section-block">
            <h3 class="section-title">主要股东（持股≥10%）</h3>
            <div v-if="majorShareholders.length > 0" class="shareholder-list">
              <div v-for="(shareholder, index) in majorShareholders" :key="index" class="shareholder-item">
                <div class="sh-row">
                  <div class="sh-rank">{{ index + 1 }}</div>
                  <div class="sh-info">
                    <div class="sh-name">
                      {{ shareholder.name }}
                      <el-tag v-if="shareholder.isStateOwned" type="danger" size="small" effect="light" class="sh-tag">国资</el-tag>
                      <el-tag v-else-if="shareholder.isForeign" type="primary" size="small" effect="light" class="sh-tag">外资</el-tag>
                    </div>
                    <div class="sh-type">{{ shareholder.type }}</div>
                  </div>
                  <div class="sh-ratio">
                    <div class="sh-ratio-value">{{ shareholder.ratio }}</div>
                  </div>
                </div>
                <div class="sh-progress">
                  <div class="sh-progress-bar" :style="{ width: Math.min(shareholder.ratioValue, 100) + '%' }"></div>
                </div>
              </div>
            </div>
            <div v-else class="empty-tip">暂无公开股东信息</div>
          </div>

          <!-- 股权结构说明 -->
          <div class="section-block" v-if="companyData?.shareholders && companyData.shareholders.length > 0">
            <h3 class="section-title">股权结构说明</h3>
            <div class="structure-note">
              <p v-if="controllingShareholder">本公司由 <strong class="accent-text">{{ controllingShareholder.name }}</strong> 控股，持股比例 {{ controllingShareholder.ratio }}。</p>
              <p>前{{ Math.min(majorShareholders.length, 5) }}大股东合计持股 <strong class="accent-text">{{ totalTopRatio }}%</strong>。</p>
              <p class="note-text">注：以上股东信息来源于公开披露资料，仅供参考。实际股权结构以公司最新公告为准。</p>
            </div>
          </div>

          <!-- 关联公司列表 -->
          <div class="section-block">
            <h3 class="section-title">关联公司</h3>
            <div v-if="companyRelations.length > 0" class="relation-list">
              <div
                v-for="(rel, index) in companyRelations"
                :key="index"
                class="relation-item"
                @click="$emit('navigate-company', rel.companyId)"
              >
                <div class="rel-indicator" :class="'rel-type-' + rel.relationType">
                  {{ relationTypeShortNames[rel.relationType] || '关' }}
                </div>
                <div class="rel-info">
                  <div class="rel-name">{{ rel.companyName }}</div>
                  <div class="rel-desc">{{ rel.relationName }}</div>
                </div>
                <el-icon class="rel-arrow"><ArrowRight /></el-icon>
              </div>
            </div>
            <div v-else class="empty-tip">暂无关联公司数据</div>
          </div>
        </div>
      </el-tab-pane>

      <!-- Tab3: 产品列表 -->
      <el-tab-pane label="产品列表" name="products">
        <template #label>
          <span class="tab-label"><el-icon><Goods /></el-icon>产品列表</span>
        </template>
        <div class="tab-content">
          <div v-if="companyProducts.length > 0">
            <div v-for="(group, type) in productsByType" :key="type" class="section-block">
              <h3 class="section-title">
                <span class="type-dot" :style="{ background: getTypeColor(type) }"></span>
                {{ type }}
                <span class="type-count">{{ group.length }}款</span>
              </h3>
              <div class="product-grid">
                <div
                  v-for="product in group"
                  :key="product.productId"
                  class="product-card-item"
                  @click="$emit('view-product', companyId, product.productName)"
                >
                  <div class="pci-name">{{ product.productName }}</div>
                  <div class="pci-type">{{ typeDescMap[product.productType] || type }}</div>
                </div>
              </div>
            </div>
          </div>
          <div v-else class="empty-tip">暂无产品数据</div>
        </div>
      </el-tab-pane>

      <!-- Tab4: 经营数据 -->
      <el-tab-pane label="经营数据" name="business">
        <template #label>
          <span class="tab-label"><el-icon><DataAnalysis /></el-icon>经营数据</span>
        </template>
        <div class="tab-content">
          <div class="section-block">
            <h3 class="section-title">核心指标</h3>
            <div class="metrics-grid">
              <div class="metric-card">
                <div class="mc-icon risk-icon">
                  <el-icon><Warning /></el-icon>
                </div>
                <div class="mc-content">
                  <div class="mc-value">{{ companyData?.riskRating || '—' }}</div>
                  <div class="mc-label">风险综合评级</div>
                </div>
              </div>
              <div class="metric-card">
                <div class="mc-icon solvency-icon">
                  <el-icon><TrendCharts /></el-icon>
                </div>
                <div class="mc-content">
                  <div class="mc-value">{{ companyData?.solvencyRatio ? companyData.solvencyRatio + '%' : '—' }}</div>
                  <div class="mc-label">综合偿付能力充足率</div>
                </div>
              </div>
              <div class="metric-card">
                <div class="mc-icon capital-icon">
                  <el-icon><Wallet /></el-icon>
                </div>
                <div class="mc-content">
                  <div class="mc-value">{{ companyData?.registeredCapital ? companyData.registeredCapital + '亿' : '—' }}</div>
                  <div class="mc-label">注册资本金</div>
                </div>
              </div>
              <div class="metric-card">
                <div class="mc-icon year-icon">
                  <el-icon><Calendar /></el-icon>
                </div>
                <div class="mc-content">
                  <div class="mc-value">{{ companyData?.establishedYear ? (2026 - companyData.establishedYear) + '年' : '—' }}</div>
                  <div class="mc-label">经营年限</div>
                </div>
              </div>
            </div>
          </div>

          <div class="section-block">
            <h3 class="section-title">偿付能力说明</h3>
            <div class="solvency-note">
              <p v-if="companyData?.solvencyRatio">
                该公司最新披露的综合偿付能力充足率为
                <strong :class="solvencyLevel.class">{{ companyData.solvencyRatio }}%</strong>，
                {{ solvencyLevel.text }}。
              </p>
              <p v-else>暂无偿付能力数据。</p>
              <p class="note-text">
                注：根据监管要求，保险公司核心偿付能力充足率不低于50%，综合偿付能力充足率不低于100%。
                数据来源于保险公司公开披露的偿付能力报告。
              </p>
            </div>
          </div>

          <div class="section-block">
            <h3 class="section-title">公司资质</h3>
            <div class="qualification-list">
              <div class="qual-item">
                <el-icon class="qual-icon"><Check /></el-icon>
                <span>中国银行保险监督管理委员会批准设立</span>
              </div>
              <div class="qual-item" v-if="companyData?.creditRating">
                <el-icon class="qual-icon"><Check /></el-icon>
                <span>信用评级：{{ companyData.creditRating }}</span>
              </div>
              <div class="qual-item" v-if="companyData?.cooperationStatus === 1">
                <el-icon class="qual-icon"><Check /></el-icon>
                <span>平台合作保险公司</span>
              </div>
            </div>
          </div>
        </div>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { Close, InfoFilled, User, Goods, DataAnalysis, ArrowRight, Warning, TrendCharts, Wallet, Calendar, Check } from '@element-plus/icons-vue'
import type { Company, ShareholderItem, CompanyRelationItem } from '@/api/company'
import type { Product } from '@/api/product'
import { getProductList } from '@/api/product'

const typeDescMap: Record<number, string> = {
  1: '重疾险',
  2: '增额终身寿',
  3: '年金险',
  4: '健康险'
}

const props = defineProps<{
  companyId: number
  companyData: Company | null
}>()

defineEmits<{
  (e: 'close'): void
  (e: 'navigate-company', companyId: number): void
  (e: 'view-product', companyId: number, productName: string): void
}>()

const activeTab = ref('basic')
const companyProducts = ref<Product[]>([])

// 关联类型简称
const relationTypeShortNames: Record<number, string> = {
  1: '集团',
  2: '同股',
  3: '母子',
  4: '参股'
}

// 产品类型颜色
const typeColorMap: Record<string, string> = {
  '重疾险': '#1890ff',
  '增额终身寿': '#52c41a',
  '增额终身寿险': '#52c41a',
  '年金险': '#faad14',
  '健康险': '#10b981'
}

function getTypeColor(type: string): string {
  return typeColorMap[type] || '#ffd27a'
}

// 控股股东
const controllingShareholder = computed<ShareholderItem | null>(() => {
  if (!props.companyData?.shareholders || props.companyData.shareholders.length === 0) return null
  const ctrl = props.companyData.shareholders.find(s => s.isControlling)
  if (ctrl) return ctrl
  // 如果没有标记控股股东，取持股最多的
  const sorted = [...props.companyData.shareholders].sort((a, b) => b.ratioValue - a.ratioValue)
  return sorted[0] || null
})

// 主要股东（持股≥10%，按持股比例降序）
const majorShareholders = computed<ShareholderItem[]>(() => {
  if (!props.companyData?.shareholders) return []
  return [...props.companyData.shareholders]
    .filter(s => s.ratioValue >= 10)
    .sort((a, b) => b.ratioValue - a.ratioValue)
})

// 前5大股东合计持股比例
const totalTopRatio = computed(() => {
  const top5 = majorShareholders.value.slice(0, 5)
  const total = top5.reduce((sum, s) => sum + s.ratioValue, 0)
  return total.toFixed(1)
})

// 公司关联关系
const companyRelations = computed<CompanyRelationItem[]>(() => {
  return props.companyData?.relations || []
})

// 按类型分组的产品
const productsByType = computed<Record<string, Product[]>>(() => {
  const groups: Record<string, Product[]> = {}
  companyProducts.value.forEach(p => {
    const type = typeDescMap[p.productType] || '其他'
    if (!groups[type]) groups[type] = []
    groups[type].push(p)
  })
  return groups
})

// 偿付能力等级
const solvencyLevel = computed(() => {
  const ratio = props.companyData?.solvencyRatio || 0
  if (ratio >= 200) return { text: '偿付能力充足', class: 'level-high' }
  if (ratio >= 150) return { text: '偿付能力良好', class: 'level-good' }
  if (ratio >= 100) return { text: '偿付能力达标', class: 'level-ok' }
  return { text: '需关注偿付能力风险', class: 'level-low' }
})

// 加载公司产品
watch(() => props.companyId, async (id) => {
  if (id && id > 0) {
    try {
      const res = await getProductList({ companyId: id, pageSize: 50 })
      companyProducts.value = res.list || []
    } catch (e) {
      console.warn('获取公司产品列表失败:', e)
      companyProducts.value = []
    }
  }
}, { immediate: true })
</script>

<style scoped>
.company-detail-panel {
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: radial-gradient(120% 40% at 50% 0%, #ffd27a14 0%, transparent 60%),
              linear-gradient(180deg, #0e101a 0%, #07080e 100%);
  color: var(--fg, #e8ecf4);
  border-left: 1px solid #ffd27a24;
  box-shadow: -8px 0 40px rgba(0, 0, 0, 0.5);
  overflow: hidden;
}

/* 头部 */
.panel-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  padding: 24px 24px 16px;
  position: relative;
  border-bottom: 1px solid #ffffff0d;
}
.panel-header::before {
  content: '';
  position: absolute;
  top: 0;
  left: 20%;
  right: 20%;
  height: 1px;
  background: linear-gradient(90deg, transparent, #ffd27a80, transparent);
  opacity: 0.6;
}
.header-left {
  display: flex;
  gap: 16px;
  align-items: center;
  flex: 1;
}
.company-logo-wrap {
  flex-shrink: 0;
}
.company-logo-placeholder {
  width: 56px;
  height: 56px;
  border-radius: 14px;
  background: linear-gradient(135deg, #ffd27a33, #ffd27a11);
  border: 1px solid #ffd27a40;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  font-weight: 600;
  color: #ffd27a;
  font-family: 'Kaiti SC', 'STKaiti', 'KaiTi', serif;
  letter-spacing: 0.05em;
}
.company-title {
  flex: 1;
  min-width: 0;
}
.company-name {
  font-size: 22px;
  font-weight: 600;
  color: #ffd27a;
  margin: 0 0 6px 0;
  font-family: 'Kaiti SC', 'STKaiti', 'KaiTi', serif;
  letter-spacing: 0.05em;
  text-shadow: 0 1px 16px #ffd27a28;
}
.company-tags {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}
.tag {
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 4px;
  border: 1px solid #ffffff1a;
  background: #ffffff0a;
  color: #8b93a7;
}
.tag-nature {
  color: #67e8f9;
  border-color: #06b6d440;
  background: #06b6d414;
}
.tag-rating {
  color: #fbbf24;
  border-color: #f59e0b40;
  background: #f59e0b14;
}
.tag-risk {
  color: #34d399;
  border-color: #10b98140;
  background: #10b98114;
}
.panel-close-btn {
  background: none;
  border: none;
  color: #8b93a7;
  font-size: 22px;
  cursor: pointer;
  padding: 4px;
  border-radius: 6px;
  transition: all 0.15s;
  flex-shrink: 0;
}
.panel-close-btn:hover {
  color: #e8ecf4;
  background: #ffffff10;
}

/* 核心指标条 */
.metrics-bar {
  display: flex;
  align-items: center;
  justify-content: space-around;
  padding: 16px 24px;
  border-bottom: 1px solid #ffffff0d;
  background: #ffffff04;
}
.metric-item {
  text-align: center;
  flex: 1;
}
.metric-value {
  font-size: 18px;
  font-weight: 600;
  color: #e8ecf4;
  margin-bottom: 2px;
  font-variant-numeric: tabular-nums;
}
.metric-label {
  font-size: 11px;
  color: #8b93a7;
  letter-spacing: 0.05em;
}
.metric-divider {
  width: 1px;
  height: 28px;
  background: #ffffff12;
}

/* Tabs */
.detail-tabs {
  flex: 1;
  overflow: hidden;
  display: flex;
}
.detail-tabs :deep(.el-tabs) {
  flex: 1;
  display: flex;
}
.detail-tabs :deep(.el-tabs__header) {
  margin: 0;
  border: none;
  width: 110px;
  background: #ffffff04;
  border-right: 1px solid #ffffff0d;
}
.detail-tabs :deep(.el-tabs__nav-wrap::after) {
  display: none;
}
.detail-tabs :deep(.el-tabs__item) {
  height: 48px;
  line-height: 48px;
  font-size: 13px;
  color: #8b93a7;
  padding: 0 20px;
  text-align: left;
}
.detail-tabs :deep(.el-tabs__item:hover) {
  color: #e8ecf4;
}
.detail-tabs :deep(.el-tabs__item.is-active) {
  color: #ffd27a;
  background: #ffd27a10;
}
.detail-tabs :deep(.el-tabs__active-bar) {
  width: 2px !important;
  background: #ffd27a;
  right: 0;
  left: auto !important;
}
.detail-tabs :deep(.el-tabs__content) {
  flex: 1;
  overflow-y: auto;
  padding: 0;
}
.detail-tabs :deep(.el-tab-pane) {
  height: 100%;
}
.tab-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
}

.tab-content {
  padding: 20px 24px 40px;
}

.section-block {
  margin-bottom: 24px;
}
.section-block:last-child {
  margin-bottom: 0;
}

.section-title {
  font-size: 15px;
  font-weight: 600;
  color: #e8ecf4;
  margin: 0 0 12px 0;
  display: flex;
  align-items: center;
  gap: 8px;
  letter-spacing: 0.03em;
}
.title-icon {
  width: 22px;
  height: 22px;
  border-radius: 6px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 700;
  flex-shrink: 0;
}
.controlling-icon {
  background: linear-gradient(135deg, #f59e0b, #d97706);
  color: #fff;
  box-shadow: 0 0 12px #f59e0b40;
}

/* 基本信息 */
.info-desc :deep(.el-descriptions__label) {
  background: #ffffff05;
  color: #8b93a7;
  width: 100px;
  font-size: 13px;
}
.info-desc :deep(.el-descriptions__body .el-descriptions__cell) {
  color: #e8ecf4;
  font-size: 13px;
}
.info-desc :deep(.el-descriptions__body .el-descriptions__row .el-descriptions__cell) {
  padding: 10px 14px;
}

.intro-text {
  font-size: 13px;
  line-height: 1.8;
  color: #b8bfce;
  background: #ffffff04;
  border: 1px solid #ffffff0d;
  border-radius: 10px;
  padding: 16px;
  text-align: justify;
}

/* 股东结构 */
.controlling-card {
  background: linear-gradient(135deg, #f59e0b1a 0%, #f59e0b06 50%, transparent 100%);
  border: 1px solid #f59e0b40;
  border-radius: 12px;
  padding: 18px 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
}
.controlling-main {
  flex: 1;
}
.controlling-name {
  font-size: 17px;
  font-weight: 600;
  color: #e8ecf4;
  margin-bottom: 6px;
}
.controlling-type {
  display: flex;
  gap: 6px;
}
.controlling-ratio {
  text-align: right;
  min-width: 140px;
}
.ratio-value {
  font-size: 24px;
  font-weight: 700;
  color: #f59e0b;
  font-variant-numeric: tabular-nums;
  text-shadow: 0 0 20px #f59e0b40;
}
.ratio-bar {
  width: 120px;
  height: 6px;
  background: #ffffff14;
  border-radius: 3px;
  margin: 6px 0 4px auto;
  overflow: hidden;
}
.ratio-fill {
  height: 100%;
  border-radius: 3px;
  transition: width 0.5s ease;
}
.controlling-fill {
  background: linear-gradient(90deg, #f59e0b, #fbbf24);
  box-shadow: 0 0 8px #f59e0b80;
}
.ratio-label {
  font-size: 11px;
  color: #8b93a7;
}

/* 股东列表 */
.shareholder-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.shareholder-item {
  background: #ffffff05;
  border: 1px solid #ffffff0d;
  border-radius: 10px;
  padding: 12px 14px;
  transition: all 0.15s;
}
.shareholder-item:hover {
  background: #ffffff08;
  border-color: #ffffff17;
}
.sh-row {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 8px;
}
.sh-rank {
  width: 22px;
  height: 22px;
  border-radius: 6px;
  background: #ffffff10;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 600;
  color: #8b93a7;
  flex-shrink: 0;
}
.shareholder-item:nth-child(1) .sh-rank {
  background: linear-gradient(135deg, #f59e0b, #d97706);
  color: #fff;
}
.shareholder-item:nth-child(2) .sh-rank {
  background: linear-gradient(135deg, #94a3b8, #64748b);
  color: #fff;
}
.shareholder-item:nth-child(3) .sh-rank {
  background: linear-gradient(135deg, #cd7f32, #a0522d);
  color: #fff;
}
.sh-info {
  flex: 1;
  min-width: 0;
}
.sh-name {
  font-size: 14px;
  font-weight: 500;
  color: #e8ecf4;
  display: flex;
  align-items: center;
  gap: 8px;
}
.sh-tag {
  flex-shrink: 0;
}
.sh-type {
  font-size: 12px;
  color: #8b93a7;
  margin-top: 2px;
}
.sh-ratio {
  flex-shrink: 0;
  text-align: right;
}
.sh-ratio-value {
  font-size: 15px;
  font-weight: 600;
  color: #ffd27a;
  font-variant-numeric: tabular-nums;
}
.sh-progress {
  height: 4px;
  background: #ffffff10;
  border-radius: 2px;
  overflow: hidden;
}
.sh-progress-bar {
  height: 100%;
  background: linear-gradient(90deg, #ffd27a, #fbbf24);
  border-radius: 2px;
  transition: width 0.5s ease;
}

/* 股权结构说明 */
.structure-note {
  background: #ffffff04;
  border: 1px solid #ffffff0d;
  border-radius: 10px;
  padding: 14px 16px;
  font-size: 13px;
  line-height: 1.8;
  color: #b8bfce;
}
.structure-note p {
  margin: 0 0 6px 0;
}
.structure-note p:last-child {
  margin-bottom: 0;
}
.accent-text {
  color: #ffd27a;
  font-weight: 600;
}
.note-text {
  color: #6b7280 !important;
  font-size: 12px !important;
  margin-top: 8px !important;
}

/* 关联公司列表 */
.relation-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.relation-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 14px;
  background: #ffffff05;
  border: 1px solid #ffffff0d;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.15s;
}
.relation-item:hover {
  background: #ffffff0a;
  border-color: #ffd27a40;
  transform: translateX(2px);
}
.rel-indicator {
  width: 36px;
  height: 36px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 11px;
  font-weight: 600;
  flex-shrink: 0;
  color: #fff;
}
.rel-type-1 {
  background: linear-gradient(135deg, #06b6d4, #0891b2);
  box-shadow: 0 0 10px #06b6d440;
}
.rel-type-2 {
  background: linear-gradient(135deg, #8b5cf6, #7c3aed);
  box-shadow: 0 0 10px #8b5cf640;
}
.rel-type-3 {
  background: linear-gradient(135deg, #f59e0b, #d97706);
  box-shadow: 0 0 10px #f59e0b40;
}
.rel-type-4 {
  background: linear-gradient(135deg, #10b981, #059669);
  box-shadow: 0 0 10px #10b98140;
}
.rel-info {
  flex: 1;
  min-width: 0;
}
.rel-name {
  font-size: 14px;
  font-weight: 500;
  color: #e8ecf4;
  margin-bottom: 2px;
}
.rel-desc {
  font-size: 12px;
  color: #8b93a7;
}
.rel-arrow {
  color: #8b93a7;
  flex-shrink: 0;
  transition: transform 0.15s;
}
.relation-item:hover .rel-arrow {
  color: #ffd27a;
  transform: translateX(3px);
}

/* 产品列表 */
.product-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}
.product-card-item {
  background: #ffffff05;
  border: 1px solid #ffffff0d;
  border-radius: 10px;
  padding: 14px;
  cursor: pointer;
  transition: all 0.15s;
}
.product-card-item:hover {
  background: #ffd27a10;
  border-color: #ffd27a40;
  transform: translateY(-1px);
}
.pci-name {
  font-size: 13px;
  font-weight: 500;
  color: #e8ecf4;
  margin-bottom: 4px;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.pci-type {
  font-size: 11px;
  color: #8b93a7;
}
.type-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  flex-shrink: 0;
}
.type-count {
  font-size: 12px;
  color: #8b93a7;
  font-weight: 400;
  margin-left: auto;
}

/* 经营数据 */
.metrics-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}
.metric-card {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px;
  background: #ffffff05;
  border: 1px solid #ffffff0d;
  border-radius: 12px;
}
.mc-icon {
  width: 42px;
  height: 42px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  flex-shrink: 0;
}
.risk-icon {
  background: #f59e0b1a;
  color: #f59e0b;
}
.solvency-icon {
  background: #10b9811a;
  color: #10b981;
}
.capital-icon {
  background: #8b5cf61a;
  color: #8b5cf6;
}
.year-icon {
  background: #06b6d41a;
  color: #06b6d4;
}
.mc-content {
  flex: 1;
  min-width: 0;
}
.mc-value {
  font-size: 18px;
  font-weight: 600;
  color: #e8ecf4;
  margin-bottom: 2px;
  font-variant-numeric: tabular-nums;
}
.mc-label {
  font-size: 12px;
  color: #8b93a7;
}

.solvency-note {
  background: #ffffff04;
  border: 1px solid #ffffff0d;
  border-radius: 10px;
  padding: 14px 16px;
  font-size: 13px;
  line-height: 1.8;
  color: #b8bfce;
}
.solvency-note p {
  margin: 0 0 6px 0;
}
.solvency-note p:last-child {
  margin-bottom: 0;
}
.level-high { color: #10b981; }
.level-good { color: #34d399; }
.level-ok { color: #fbbf24; }
.level-low { color: #ef4444; }

.qualification-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.qual-item {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 13px;
  color: #b8bfce;
  padding: 10px 14px;
  background: #ffffff04;
  border-radius: 8px;
}
.qual-icon {
  color: #10b981;
  font-size: 16px;
  flex-shrink: 0;
}

.empty-tip {
  text-align: center;
  padding: 40px 20px;
  color: #6b7280;
  font-size: 13px;
  background: #ffffff04;
  border: 1px dashed #ffffff14;
  border-radius: 10px;
}

/* 滚动条 */
.detail-tabs :deep(.el-tabs__content)::-webkit-scrollbar {
  width: 6px;
}
.detail-tabs :deep(.el-tabs__content)::-webkit-scrollbar-thumb {
  background: #ffd27a40;
  border-radius: 3px;
}
.detail-tabs :deep(.el-tabs__content)::-webkit-scrollbar-track {
  background: transparent;
}
</style>
