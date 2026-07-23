<template>
  <el-card class="product-card" :class="{ 'is-disabled': saleStatusText === '已停售' }" :body-style="{ padding: '0px' }" shadow="hover" @click="handleCardClick">
    <div class="product-card-header">
      <div class="product-type-tag" :style="{ backgroundColor: typeColor }">
        {{ typeLabel }}
      </div>
      <div v-if="saleStatusText && saleStatusText !== '在售'" class="sale-status-tag" :class="saleStatusClass">
        {{ saleStatusText }}
      </div>
      <img v-if="product.companyLogo" :src="product.companyLogo" :alt="product.companyName" class="company-logo" />
    </div>
    <div class="product-card-body">
      <h3 class="product-name" :title="product.productName">{{ product.productName }}</h3>
      <p class="company-name">{{ product.companyName }}</p>
      <div v-if="subTypeLabel" class="product-subtype">
        <el-tag size="small" effect="plain">{{ subTypeLabel }}</el-tag>
      </div>
    </div>
    <div class="product-card-footer">
      <div class="product-meta" style="margin-top: 12px;">
        <div class="meta-item">
          <span class="meta-label">可投保年龄</span>
          <span class="meta-value">{{ displayAgeRange }}</span>
        </div>
        <div class="meta-item">
          <span class="meta-label">缴费方式</span>
          <span class="meta-value">{{ displayPaymentMethod }}</span>
        </div>
      </div>
      <div class="footer-actions">
        <el-button type="primary" size="small" @click.stop="handleViewDetail">
          查看详情
        </el-button>
        <el-button type="success" size="small" @click.stop="handleGenerateCard">
          生成卡片
        </el-button>
        <el-button
          v-if="showCompare"
          :type="isSelected ? 'success' : 'default'"
          size="small"
          @click.stop="handleToggleCompare"
        >
          {{ isSelected ? '已加入' : '对比' }}
        </el-button>
      </div>
    </div>
  </el-card>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import type { Product } from '@/api/product'
// import { formatCurrency } from '@/utils/format'

interface Props {
  product: Product
  typeLabel: string
  typeColor: string
  showCompare?: boolean
  isSelected?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  showCompare: true,
  isSelected: false
})

const emit = defineEmits<{
  viewDetail: [productId: number]
  toggleCompare: [productId: number]
}>()

const router = useRouter()

function handleViewDetail() {
  emit('viewDetail', props.product.productId)
}

function handleCardClick() {
  emit('viewDetail', props.product.productId)
}

function handleToggleCompare() {
  emit('toggleCompare', props.product.productId)
}

function handleGenerateCard() {
  router.push(`/card/generate?productId=${props.product.productId}`)
}

function safeParseJSON(val: string | string[] | undefined): string[] {
  if (!val) return []
  if (Array.isArray(val)) return val
  try {
    const parsed = JSON.parse(val)
    if (Array.isArray(parsed)) return parsed
    return [String(parsed)]
  } catch {
    return [val]
  }
}

const displayAgeRange = computed(() => {
  const min = props.product.minAge
  const max = props.product.maxAge
  if (min != null && max != null) return `${min}-${max}岁`
  if (min != null) return `${min}岁起`
  if (max != null) return `至${max}岁`
  return '-'
})

const subTypeLabel = computed(() => {
  const sub = props.product.subType
  if (sub === 1) return '分红型'
  if (sub === 2) return '固收型'
  if (sub === 3) return '传统型'
  return ''
})

// 销售状态：0-已停售，1-在售，2-预售中（与后端SaleStatusEnum一致）
const saleStatusText = computed(() => {
  const p = props.product as any
  if (p.saleStatus === 0) return '已停售'
  if (p.saleStatus === 1) return '在售'
  if (p.saleStatus === 2) return '预售中'
  return ''
})

const saleStatusClass = computed(() => {
  const p = props.product as any
  if (p.saleStatus === 2) return 'status-presale'
  if (p.saleStatus === 0) return 'status-offline'
  return ''
})

const displayPaymentMethod = computed(() => {
  const years = safeParseJSON(props.product.paymentYears)
  if (years.length > 0) {
    const formatted = years.slice(0, 3).map((y: string | number) => {
      const v = String(y)
      // 如果是纯数字，添加"年"或"趸交"
      if (/^\d+$/.test(v)) return Number(v) === 1 ? '趸交' : `${v}年`
      return v
    })
    return formatted.join('、') + (years.length > 3 ? '...' : '')
  }
  // fallback to paymentPeriods
  const periods = safeParseJSON(props.product.paymentPeriods)
  if (periods.length > 0) return periods.slice(0, 2).join('、') + (periods.length > 2 ? '...' : '')
  return '-'
})
</script>

<style scoped>
.product-card {
  border-radius: var(--radius-lg);
  overflow: hidden;
  transition: all var(--transition-normal);
  height: 100%;
  display: flex;
  flex-direction: column;
  background-color: var(--bg-card) !important;
  border: 1px solid var(--border-color) !important;
  box-shadow: var(--shadow-card) !important;
  cursor: pointer;
}

.product-card.is-disabled {
  opacity: 0.6;
  filter: grayscale(0.5);
  cursor: not-allowed;
}

.product-card.is-disabled:hover {
  transform: none;
  box-shadow: var(--shadow-card) !important;
  border-color: var(--border-color) !important;
}

.product-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-card-hover), var(--shadow-neon-purple) !important;
  border-color: var(--border-glow) !important;
}

.product-card-header {
  position: relative;
  padding: 16px;
  background: linear-gradient(135deg, var(--bg-card-hover) 0%, var(--bg-secondary) 100%);
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.product-type-tag {
  color: #fff;
  padding: 2px 10px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.sale-status-tag {
  position: absolute;
  top: 12px;
  right: 12px;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
  color: #fff;
}

.sale-status-tag.status-presale {
  background-color: #e6a23c;
}

.sale-status-tag.status-offline {
  background-color: #909399;
}

.company-logo {
  width: 40px;
  height: 40px;
  object-fit: contain;
  border-radius: var(--radius-sm);
  background: var(--bg-card);
  padding: 2px;
  border: 1px solid var(--border-color);
}

.product-card-body {
  padding: 16px;
  flex: 1;
}

.product-name {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 8px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.company-name {
  font-size: 13px;
  color: var(--text-secondary);
  margin-bottom: 8px;
}

.product-meta {
  display: flex;
  justify-content: space-between;
  padding: 12px 0;
  border-top: 1px solid var(--border-color);
}

.meta-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.meta-label {
  font-size: 12px;
  color: var(--text-muted);
}

.meta-value {
  font-size: 14px;
  font-weight: 600;
  color: var(--accent-orange);
}

.product-card-footer {
  padding: 12px 16px;
  border-top: 1px solid var(--border-color);
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.footer-actions {
  display: flex;
  gap: 8px;
}

.footer-actions .el-button {
  flex: 1;
}
</style>
