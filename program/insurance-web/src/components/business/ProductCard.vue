<template>
  <el-card class="product-card" :body-style="{ padding: '0px' }" shadow="hover">
    <div class="product-card-header">
      <div class="product-type-tag" :style="{ backgroundColor: typeColor }">
        {{ typeLabel }}
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
        <el-button type="primary" size="small" @click="handleViewDetail">
          查看详情
        </el-button>
        <el-button
          v-if="showCompare"
          :type="isSelected ? 'success' : 'default'"
          size="small"
          @click="handleToggleCompare"
        >
          {{ isSelected ? '已加入' : '对比' }}
        </el-button>
      </div>
    </div>
  </el-card>
</template>

<script setup lang="ts">
import { computed } from 'vue'
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

function handleViewDetail() {
  emit('viewDetail', props.product.productId)
}

function handleToggleCompare() {
  emit('toggleCompare', props.product.productId)
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

.product-summary {
  font-size: 12px;
  color: var(--text-muted);
  line-height: 1.5;
  margin-bottom: 12px;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.product-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-bottom: 12px;
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
