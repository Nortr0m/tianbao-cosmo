<template>
  <div class="disease-list">
    <!-- 疾病统计概览 -->
    <div class="stats-overview">
      <div class="stat-item stat-critical">
        <div class="stat-num">{{ criticalCount }}</div>
        <div class="stat-label">重疾</div>
        <div class="stat-sub" v-if="statutoryCriticalCount > 0">
          法定 {{ statutoryCriticalCount }} 种
        </div>
      </div>
      <div class="stat-item stat-medium">
        <div class="stat-num">{{ mediumCount }}</div>
        <div class="stat-label">中症</div>
        <div class="stat-sub">&nbsp;</div>
      </div>
      <div class="stat-item stat-light">
        <div class="stat-num">{{ lightCount }}</div>
        <div class="stat-label">轻症</div>
        <div class="stat-sub" v-if="statutoryLightCount > 0">
          法定 {{ statutoryLightCount }} 种
        </div>
      </div>
      <div class="stat-item stat-highrisk">
        <div class="stat-num">{{ highRiskCount }}</div>
        <div class="stat-label">高发</div>
        <div class="stat-sub">重点关注</div>
      </div>
      <div class="stat-item stat-statutory">
        <div class="stat-num">{{ statutoryTotalCount }}</div>
        <div class="stat-label">法定</div>
        <div class="stat-sub">监管规定</div>
      </div>
      <div class="stat-item stat-total">
        <div class="stat-num">{{ totalCount }}</div>
        <div class="stat-label">总计</div>
        <div class="stat-sub">疾病种类</div>
      </div>
    </div>

    <!-- 筛选栏 -->
    <div class="filter-bar">
      <div class="filter-left">
        <el-radio-group v-model="activeTab" size="default" class="type-tabs">
          <el-radio-button value="all">
            全部({{ totalCount }})
          </el-radio-button>
          <el-radio-button value="critical">
            重疾({{ criticalCount }})
          </el-radio-button>
          <el-radio-button value="medium">
            中症({{ mediumCount }})
          </el-radio-button>
          <el-radio-button value="light">
            轻症({{ lightCount }})
          </el-radio-button>
        </el-radio-group>
      </div>
      <div class="filter-right">
        <el-select
          v-model="selectedCategory"
          placeholder="疾病分类"
          size="default"
          clearable
          style="width: 140px"
          class="category-select"
        >
          <el-option
            v-for="cat in categoryOptions"
            :key="cat"
            :label="cat"
            :value="cat"
          />
        </el-select>
        <el-radio-group v-model="highRiskFilter" size="default" class="filter-group">
          <el-radio-button value="all">全部</el-radio-button>
          <el-radio-button value="high">高发</el-radio-button>
          <el-radio-button value="normal">普通</el-radio-button>
        </el-radio-group>
        <el-radio-group v-model="statutoryFilter" size="default" class="filter-group">
          <el-radio-button value="all">全部</el-radio-button>
          <el-radio-button value="statutory">法定</el-radio-button>
          <el-radio-button value="other">其他</el-radio-button>
        </el-radio-group>
        <el-input
          v-model="searchKeyword"
          placeholder="搜索疾病名称"
          clearable
          :prefix-icon="Search"
          style="width: 220px"
          class="search-input"
        />
      </div>
    </div>

    <!-- 表格 -->
    <el-table
      :data="pagedDiseases"
      :border="true"
      :stripe="true"
      height="480"
      style="width: 100%"
      class="disease-table"
    >
      <el-table-column type="index" label="序号" width="60" align="center" />
      <el-table-column prop="name" label="疾病名称" min-width="220">
        <template #default="{ row }">
          <div class="disease-name-cell">
            <span :class="{ 'high-risk-name': row.isHighRisk }">{{ row.name }}</span>
            <div class="disease-tags">
              <el-tag
                v-if="row.isStatutory"
                size="small"
                effect="dark"
                class="statutory-tag"
              >
                法定
              </el-tag>
              <el-tag
                v-if="row.isHighRisk"
                size="small"
                effect="plain"
                type="danger"
                class="risk-tag"
              >
                高发
              </el-tag>
            </div>
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="category" label="分类" width="110" align="center">
        <template #default="{ row }">
          <el-tag size="small" effect="plain" :type="getCategoryTagType(row.category)">
            {{ row.category }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="compensation" label="赔付比例" width="100" align="center">
        <template #default="{ row }">
          <span class="compensation-text" :class="getCompensationClass(row.type)">
            {{ row.compensation }}
          </span>
        </template>
      </el-table-column>
      <el-table-column label="赔付次数" width="100" align="center">
        <template #default="{ row }">
          {{ getPayTimes(row.type) }}次
        </template>
      </el-table-column>
      <el-table-column prop="definition" label="疾病定义" min-width="320">
        <template #default="{ row }">
          <div class="definition-cell">
            <el-tooltip
              v-if="row.definition"
              :content="row.definition"
              placement="top-start"
              :show-after="300"
              :hide-after="0"
            >
              <span class="definition-text">{{ truncateText(row.definition, 45) }}</span>
            </el-tooltip>
            <span v-else class="no-definition">暂无定义</span>
            <el-tooltip content="该疾病的理赔定义及赔付条件说明" placement="top" :show-after="300">
              <el-icon class="definition-help-icon"><QuestionFilled /></el-icon>
            </el-tooltip>
          </div>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <div class="pagination-wrapper">
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 30, 50]"
        :total="filteredDiseases.length"
        layout="total, sizes, prev, pager, next, jumper"
        background
        small
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { Search, QuestionFilled } from '@element-plus/icons-vue'
import { truncateText } from '@/utils/format'
import type { DiseaseItem } from '@/api/product'

interface Props {
  diseases: DiseaseItem[]
}

const props = defineProps<Props>()

// 筛选状态
const searchKeyword = ref('')
const activeTab = ref<'all' | 'critical' | 'medium' | 'light'>('all')
const selectedCategory = ref('')
const highRiskFilter = ref<'all' | 'high' | 'normal'>('all')
const statutoryFilter = ref<'all' | 'statutory' | 'other'>('all')

// 分页
const currentPage = ref(1)
const pageSize = ref(20)

// 统计数据
const criticalCount = computed(() => props.diseases.filter(d => d.type === 'critical').length)
const mediumCount = computed(() => props.diseases.filter(d => d.type === 'medium').length)
const lightCount = computed(() => props.diseases.filter(d => d.type === 'light').length)
const totalCount = computed(() => props.diseases.length)
const highRiskCount = computed(() => props.diseases.filter(d => d.isHighRisk).length)
const statutoryCriticalCount = computed(() =>
  props.diseases.filter(d => d.type === 'critical' && d.isStatutory).length
)
const statutoryLightCount = computed(() =>
  props.diseases.filter(d => d.type === 'light' && d.isStatutory).length
)
const statutoryTotalCount = computed(() =>
  props.diseases.filter(d => d.isStatutory).length
)

// 分类选项
const categoryOptions = computed(() => {
  const cats = new Set(props.diseases.map(d => d.category))
  return Array.from(cats).sort()
})

// 类型筛选后的列表
const typeFiltered = computed(() => {
  if (activeTab.value === 'all') return props.diseases
  return props.diseases.filter(d => d.type === activeTab.value)
})

// 分类筛选
const categoryFiltered = computed(() => {
  if (!selectedCategory.value) return typeFiltered.value
  return typeFiltered.value.filter(d => d.category === selectedCategory.value)
})

// 高发筛选
const highRiskFiltered = computed(() => {
  if (highRiskFilter.value === 'all') return categoryFiltered.value
  if (highRiskFilter.value === 'high') return categoryFiltered.value.filter(d => d.isHighRisk)
  return categoryFiltered.value.filter(d => !d.isHighRisk)
})

// 法定筛选
const statutoryFiltered = computed(() => {
  if (statutoryFilter.value === 'all') return highRiskFiltered.value
  if (statutoryFilter.value === 'statutory') return highRiskFiltered.value.filter(d => d.isStatutory)
  return highRiskFiltered.value.filter(d => !d.isStatutory)
})

// 搜索筛选
const filteredDiseases = computed(() => {
  if (!searchKeyword.value.trim()) return statutoryFiltered.value
  const kw = searchKeyword.value.trim().toLowerCase()
  return statutoryFiltered.value.filter(
    d =>
      d.name.toLowerCase().includes(kw) ||
      d.category.toLowerCase().includes(kw) ||
      d.code.toLowerCase().includes(kw)
  )
})

// 分页数据
const pagedDiseases = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  return filteredDiseases.value.slice(start, start + pageSize.value)
})

// 监听筛选变化，重置页码
watch(
  [activeTab, selectedCategory, highRiskFilter, statutoryFilter, searchKeyword],
  () => {
    currentPage.value = 1
  }
)

// 获取分类标签颜色
function getCategoryTagType(category: string): 'primary' | 'success' | 'warning' | 'danger' | 'info' {
  const typeMap: Record<string, 'primary' | 'success' | 'warning' | 'danger' | 'info'> = {
    '恶性肿瘤': 'danger',
    '心脑血管': 'warning',
    '神经系统': 'primary',
    '器官移植': 'success',
    '消化系统': 'info',
    '呼吸系统': 'success',
    '内分泌代谢': 'warning',
    '血液免疫': 'danger',
    '其他': 'info'
  }
  return typeMap[category] || 'info'
}

// 获取赔付比例样式类
function getCompensationClass(type: string): string {
  const classMap: Record<string, string> = {
    critical: 'comp-critical',
    medium: 'comp-medium',
    light: 'comp-light'
  }
  return classMap[type] || ''
}

// 获取赔付次数（基于产品配置的默认值）
function getPayTimes(type: string): number {
  const timesMap: Record<string, number> = {
    critical: 1,
    medium: 2,
    light: 3
  }
  return timesMap[type] || 1
}
</script>

<style scoped>
.disease-list {
  padding: 8px 0;
}

/* 统计概览 */
.stats-overview {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  gap: 12px;
  margin-bottom: 20px;
}

.stat-item {
  padding: 16px 12px;
  border-radius: var(--radius-lg);
  text-align: center;
  border: 1px solid var(--border-color);
  background: var(--bg-secondary);
  transition: all var(--transition-fast);
  position: relative;
  overflow: hidden;
}

.stat-item::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: var(--accent-purple);
}

.stat-critical::before { background: linear-gradient(90deg, #ff4466, #c855f0); }
.stat-medium::before { background: linear-gradient(90deg, #ffaa00, #ff4466); }
.stat-light::before { background: linear-gradient(90deg, #00f0ff, #00ffaa); }
.stat-highrisk::before { background: linear-gradient(90deg, #ef4444, #f97316); }
.stat-statutory::before { background: linear-gradient(90deg, #fbbf24, #f59e0b); }
.stat-total::before { background: linear-gradient(90deg, #8b5cf6, #06b6d4); }

.stat-item:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-card-hover);
}

.stat-num {
  font-size: 28px;
  font-weight: 700;
  color: var(--text-primary);
  font-family: var(--font-display);
  line-height: 1.2;
  margin-bottom: 4px;
}

.stat-critical .stat-num { color: #ff6b8a; }
.stat-medium .stat-num { color: #ffbb33; }
.stat-light .stat-num { color: #33ffdd; }
.stat-highrisk .stat-num { color: #f87171; }
.stat-statutory .stat-num { color: #fbbf24; }
.stat-total .stat-num { color: #a78bfa; }

.stat-label {
  font-size: 14px;
  color: var(--text-secondary);
  margin-bottom: 4px;
}

.stat-sub {
  font-size: 12px;
  color: var(--text-muted);
}

/* 筛选栏 */
.filter-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  gap: 12px;
  flex-wrap: wrap;
}

.filter-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.filter-right {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.filter-group {
  display: flex;
}

/* 类型Tabs样式覆盖 */
.type-tabs :deep(.el-radio-button__inner) {
  padding: 8px 16px;
  font-size: 13px;
}

/* 表格样式 */
.disease-table :deep(.el-table) {
  --el-table-header-bg-color: var(--bg-secondary) !important;
  --el-table-tr-bg-color: var(--bg-card) !important;
  --el-table-row-hover-bg-color: var(--bg-card-hover) !important;
  --el-table-border-color: var(--border-color) !important;
  --el-table-text-color: var(--text-primary) !important;
  --el-table-header-text-color: var(--text-secondary) !important;
  border-radius: var(--radius-lg);
  overflow: hidden;
}

.disease-table :deep(.el-table__header th) {
  background: var(--bg-secondary) !important;
  color: var(--text-secondary) !important;
  font-weight: 600;
  border-bottom: 2px solid var(--border-color) !important;
}

.disease-table :deep(.el-table td) {
  border-bottom-color: var(--border-color) !important;
}

.disease-table :deep(.el-table--striped .el-table__body tr.el-table__row--striped td) {
  background-color: var(--bg-secondary) !important;
}

.disease-table :deep(.el-table__body tr:hover > td) {
  background-color: var(--bg-card-hover) !important;
}

/* 疾病名称单元格 */
.disease-name-cell {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.high-risk-name {
  color: var(--accent-red);
  font-weight: 600;
}

.disease-tags {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

.statutory-tag {
  background: linear-gradient(135deg, #fbbf24, #f59e0b);
  border: none;
  color: #1a1a2e;
  font-weight: 600;
  padding: 0 6px;
  height: 20px;
  line-height: 18px;
  box-shadow: 0 0 8px rgba(251, 191, 36, 0.3);
}

.risk-tag {
  margin-left: 0;
}

/* 赔付比例 */
.compensation-text {
  font-weight: 600;
  font-size: 14px;
}

.comp-critical { color: #ff6b8a; }
.comp-medium { color: #ffbb33; }
.comp-light { color: #33ffdd; }

/* 定义单元格 */
.definition-cell {
  display: flex;
  align-items: center;
  gap: 6px;
}

.definition-text {
  color: var(--text-secondary);
  cursor: help;
  flex: 1;
}

.no-definition {
  color: var(--text-muted);
  flex: 1;
}

.definition-help-icon {
  color: var(--text-muted);
  cursor: help;
  flex-shrink: 0;
  transition: color var(--transition-fast);
}

.definition-help-icon:hover {
  color: var(--accent-purple);
}

/* 分页 */
.pagination-wrapper {
  display: flex;
  justify-content: flex-end;
  margin-top: 16px;
}

.pagination-wrapper :deep(.el-pagination) {
  --el-pagination-bg-color: var(--bg-secondary);
  --el-pagination-text-color: var(--text-secondary);
  --el-pagination-hover-color: var(--accent-purple);
}

.pagination-wrapper :deep(.el-pagination button) {
  background-color: var(--bg-card);
  border-color: var(--border-color);
  color: var(--text-secondary);
}

.pagination-wrapper :deep(.el-pagination button:hover) {
  color: var(--accent-purple);
}

.pagination-wrapper :deep(.el-pagination .el-pager li) {
  background-color: var(--bg-card);
  border: 1px solid var(--border-color);
  color: var(--text-secondary);
}

.pagination-wrapper :deep(.el-pagination .el-pager li.is-active) {
  background-color: var(--accent-purple);
  border-color: var(--accent-purple);
  color: #fff;
}

.pagination-wrapper :deep(.el-pagination .el-pager li:hover) {
  color: var(--accent-purple);
}

/* 分类选择器 */
.category-select :deep(.el-input__wrapper) {
  background-color: var(--bg-input);
  box-shadow: 0 0 0 1px var(--border-color) inset;
}

.category-select :deep(.el-input__inner) {
  color: var(--text-primary);
}

.category-select :deep(.el-select__caret) {
  color: var(--text-muted);
}

/* 搜索框 */
.search-input :deep(.el-input__wrapper) {
  background-color: var(--bg-input);
  box-shadow: 0 0 0 1px var(--border-color) inset;
}

.search-input :deep(.el-input__inner) {
  color: var(--text-primary);
}

.search-input :deep(.el-input__prefix-inner) {
  color: var(--text-muted);
}

/* 响应式 */
@media (max-width: 1200px) {
  .stats-overview {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 768px) {
  .stats-overview {
    grid-template-columns: repeat(2, 1fr);
  }
  .filter-bar {
    flex-direction: column;
    align-items: stretch;
  }
  .filter-right {
    justify-content: flex-start;
  }
}
</style>
