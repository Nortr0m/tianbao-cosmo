<template>
  <div class="vip-purchase-page">
    <h1 class="page-title">
      <span class="title-decoration"></span>
      VIP会员
      <span class="title-decoration"></span>
    </h1>

    <!-- 当前状态 -->
    <el-card v-if="userStore.isVip" class="status-card">
      <el-result
        icon="success"
        title="您已是VIP会员"
        :sub-title="`会员等级：${memberLabel} | 到期时间：${formatDate(userStore.vipExpireTime)}`"
      >
        <template #extra>
          <el-button type="primary" @click="fetchVipStatus">刷新状态</el-button>
        </template>
      </el-result>
    </el-card>

    <!-- 三档会员卡片 -->
    <el-row :gutter="24" class="plans-row">
      <el-col v-for="plan in plans" :key="plan.level" :span="8">
        <el-card
          class="plan-card"
          :class="{ popular: plan.isPopular, current: isCurrentPlan(plan.level) }"
          shadow="hover"
        >
          <div v-if="plan.isPopular" class="popular-badge">最受欢迎</div>
          <div v-if="isCurrentPlan(plan.level)" class="current-badge">当前套餐</div>

          <div class="plan-header">
            <h3 class="plan-name">{{ plan.name }}</h3>
            <el-tag :type="plan.tagType" size="small">{{ plan.tag }}</el-tag>
          </div>

          <div class="plan-price">
            <span v-if="plan.price > 0" class="price-symbol">¥</span>
            <span v-if="plan.price > 0" class="price-number">{{ plan.price }}</span>
            <span v-else class="price-free">免费</span>
            <span v-if="plan.price > 0" class="price-unit">/{{ plan.duration }}天</span>
          </div>

          <div v-if="plan.originalPrice > plan.price" class="original-price">
            原价 ¥{{ plan.originalPrice }}
          </div>

          <el-divider />

          <ul class="feature-list">
            <li v-for="(feature, idx) in plan.features" :key="idx">
              <el-icon :size="16" :color="feature.enabled ? '#00ff88' : '#555577'">
                <component :is="feature.enabled ? CircleCheck : CircleClose" />
              </el-icon>
              <span :class="{ disabled: !feature.enabled }">{{ feature.text }}</span>
            </li>
          </ul>

          <el-button
            :type="plan.buttonType"
            size="large"
            class="buy-button"
            :loading="creatingOrder && selectedPlanLevel === plan.level"
            :disabled="isCurrentPlan(plan.level) && plan.level !== 'free'"
            @click="handlePurchase(plan)"
          >
            {{ getButtonText(plan) }}
          </el-button>
        </el-card>
      </el-col>
    </el-row>

    <!-- 功能对比表格 -->
    <el-card class="compare-table-card">
      <template #header>
        <div class="compare-header" @click="showCompareTable = !showCompareTable">
          <span>功能对比详情</span>
          <el-icon :class="{ rotate: showCompareTable }">
            <ArrowDown />
          </el-icon>
        </div>
      </template>

      <el-collapse-transition>
        <div v-show="showCompareTable">
          <el-table :data="compareFeatures" style="width: 100%" border>
            <el-table-column prop="feature" label="功能" min-width="200" />
            <el-table-column label="免费用户" align="center" width="180">
              <template #default="{ row }">
                <el-icon v-if="row.free === true" color="#00ff88"><CircleCheck /></el-icon>
                <el-icon v-else-if="row.free === false" color="#ff3366"><CircleClose /></el-icon>
                <span v-else>{{ row.free }}</span>
              </template>
            </el-table-column>
            <el-table-column label="VIP会员" align="center" width="180">
              <template #default="{ row }">
                <el-icon v-if="row.vip === true" color="#00ff88"><CircleCheck /></el-icon>
                <el-icon v-else-if="row.vip === false" color="#ff3366"><CircleClose /></el-icon>
                <span v-else>{{ row.vip }}</span>
              </template>
            </el-table-column>
            <el-table-column label="SVIP会员" align="center" width="180">
              <template #default="{ row }">
                <el-icon v-if="row.svip === true" color="#00ff88"><CircleCheck /></el-icon>
                <el-icon v-else-if="row.svip === false" color="#ff3366"><CircleClose /></el-icon>
                <span v-else>{{ row.svip }}</span>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-collapse-transition>
    </el-card>

    <!-- 支付弹窗 -->
    <el-dialog
      v-model="paymentVisible"
      title="支付订单"
      width="420px"
      :close-on-click-modal="false"
    >
      <div v-if="currentOrder" class="payment-content">
        <div class="order-summary">
          <div class="order-item">
            <span class="order-label">套餐</span>
            <span class="order-value">{{ selectedPlan?.name }}</span>
          </div>
          <div class="order-item">
            <span class="order-label">有效期</span>
            <span class="order-value">{{ selectedPlan?.duration }}天</span>
          </div>
          <div class="order-item">
            <span class="order-label">订单号</span>
            <span class="order-value order-id">{{ currentOrder.orderId }}</span>
          </div>
        </div>

        <div class="order-amount">
          <span class="amount-label">支付金额</span>
          <span class="amount-value">¥{{ selectedPlan?.price }}</span>
        </div>

        <el-divider />

        <p class="pay-method-title">选择支付方式</p>
        <div class="pay-methods">
          <div
            class="pay-method"
            :class="{ active: payMethod === 'wechat' }"
            @click="payMethod = 'wechat'"
          >
            <div class="pay-icon wechat">
              <el-icon :size="28"><ChatDotRound /></el-icon>
            </div>
            <div class="pay-info">
              <span class="pay-name">微信支付</span>
              <span class="pay-desc">推荐使用</span>
            </div>
            <el-icon v-if="payMethod === 'wechat'" class="check-icon" color="#00ff88">
              <CircleCheckFilled />
            </el-icon>
          </div>

          <div
            class="pay-method"
            :class="{ active: payMethod === 'alipay' }"
            @click="payMethod = 'alipay'"
          >
            <div class="pay-icon alipay">
              <el-icon :size="28"><Wallet /></el-icon>
            </div>
            <div class="pay-info">
              <span class="pay-name">支付宝</span>
              <span class="pay-desc">快捷支付</span>
            </div>
            <el-icon v-if="payMethod === 'alipay'" class="check-icon" color="#00ff88">
              <CircleCheckFilled />
            </el-icon>
          </div>
        </div>

        <el-button
          type="primary"
          size="large"
          class="confirm-pay"
          :loading="paying"
          @click="confirmPay"
        >
          确认支付 ¥{{ selectedPlan?.price }}
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { ElMessage } from 'element-plus'
import {
  CircleCheck,
  CircleClose,
  CircleCheckFilled,
  ArrowDown,
  ChatDotRound,
  Wallet
} from '@element-plus/icons-vue'
import { useUserStore } from '@/stores/userStore'
import { createOrder, getOrderStatus, getVipStatus } from '@/api/vip'
import type { PaymentResult } from '@/api/vip'
import { formatDate } from '@/utils/format'

type PlanLevel = 'free' | 'vip' | 'svip'

interface PlanFeature {
  text: string
  enabled: boolean
}

interface VipPlanUI {
  level: PlanLevel
  name: string
  tag: string
  tagType: 'success' | 'warning' | 'danger' | 'info'
  price: number
  originalPrice: number
  duration: number
  features: PlanFeature[]
  isPopular: boolean
  buttonType: '' | 'primary' | 'success' | 'warning' | 'danger'
}

interface CompareFeature {
  feature: string
  free: boolean | string
  vip: boolean | string
  svip: boolean | string
}

const userStore = useUserStore()

const creatingOrder = ref(false)
const paying = ref(false)
const paymentVisible = ref(false)
const currentOrder = ref<PaymentResult | null>(null)
const selectedPlanLevel = ref<PlanLevel | null>(null)
const payMethod = ref<'alipay' | 'wechat'>('wechat')
const showCompareTable = ref(false)

const memberLabel = computed(() => {
  if (userStore.vipLevel >= 2) return 'SVIP'
  if (userStore.vipLevel >= 1) return 'VIP'
  return '免费用户'
})

const plans = ref<VipPlanUI[]>([
  {
    level: 'free',
    name: '免费用户',
    tag: '基础版',
    tagType: 'info',
    price: 0,
    originalPrice: 0,
    duration: 0,
    isPopular: false,
    buttonType: '',
    features: [
      { text: '对比2款产品', enabled: true },
      { text: '基础利益演示', enabled: true },
      { text: '默认背景模板', enabled: true },
      { text: '产品对比5款', enabled: false },
      { text: '固定水印', enabled: false },
      { text: '全部分红率', enabled: false },
      { text: '自定义列', enabled: false },
      { text: '自定义水印', enabled: false },
      { text: '自定义背景', enabled: false },
      { text: '批量生成卡片', enabled: false }
    ]
  },
  {
    level: 'vip',
    name: 'VIP会员',
    tag: '推荐',
    tagType: 'warning',
    price: 19.9,
    originalPrice: 39.9,
    duration: 30,
    isPopular: true,
    buttonType: 'primary',
    features: [
      { text: '对比5款产品', enabled: true },
      { text: '固定水印', enabled: true },
      { text: '全部分红率', enabled: true },
      { text: '自定义列', enabled: true },
      { text: '全部背景模板', enabled: true },
      { text: '个人二维码', enabled: true },
      { text: '对比2款产品', enabled: true },
      { text: '基础利益演示', enabled: true },
      { text: '自定义水印', enabled: false },
      { text: '批量生成卡片', enabled: false }
    ]
  },
  {
    level: 'svip',
    name: 'SVIP会员',
    tag: '尊享',
    tagType: 'danger',
    price: 29.9,
    originalPrice: 59.9,
    duration: 30,
    isPopular: false,
    buttonType: 'success',
    features: [
      { text: '对比8款产品', enabled: true },
      { text: '自定义水印', enabled: true },
      { text: '自定义背景', enabled: true },
      { text: '批量生成卡片', enabled: true },
      { text: '全部VIP功能', enabled: true },
      { text: '优先客服支持', enabled: true },
      { text: '对比5款产品', enabled: true },
      { text: '固定水印', enabled: true },
      { text: '全部分红率', enabled: true },
      { text: '自定义列', enabled: true }
    ]
  }
])

const selectedPlan = computed(() =>
  plans.value.find((p) => p.level === selectedPlanLevel.value)
)

const compareFeatures = ref<CompareFeature[]>([
  { feature: '产品对比数量', free: '2款', vip: '5款', svip: '8款' },
  { feature: '基础利益演示', free: true, vip: true, svip: true },
  { feature: '分红实现率调节', free: false, vip: true, svip: true },
  { feature: '自定义利益演示列', free: false, vip: true, svip: true },
  { feature: '背景图选择', free: '默认模板', vip: '全部', svip: '全部' },
  { feature: '水印功能', free: false, vip: '固定水印', svip: '自定义水印' },
  { feature: '水印透明度调节', free: false, vip: false, svip: true },
  { feature: '水印密度调节', free: false, vip: false, svip: true },
  { feature: '水印角度调节', free: false, vip: false, svip: true },
  { feature: '个人二维码', free: false, vip: true, svip: true },
  { feature: '批量生成卡片', free: false, vip: false, svip: true },
  { feature: '优先客服支持', free: false, vip: false, svip: true }
])

function isCurrentPlan(level: PlanLevel): boolean {
  if (level === 'free') return !userStore.isVip
  if (level === 'vip') return userStore.isVip && userStore.vipLevel === 1
  if (level === 'svip') return userStore.isVip && userStore.vipLevel >= 2
  return false
}

function getButtonText(plan: VipPlanUI): string {
  if (isCurrentPlan(plan.level)) {
    if (plan.level === 'free') return '当前套餐'
    return '立即续费'
  }
  if (plan.level === 'free') return '免费使用'
  if (userStore.isVip && plan.level === 'svip' && userStore.vipLevel === 1) {
    return '升级SVIP'
  }
  return '立即开通'
}

async function fetchVipStatus() {
  try {
    const status = await getVipStatus()
    userStore.updateVipStatus(status)
    ElMessage.success('状态已更新')
  } catch {
    ElMessage.error('获取状态失败')
  }
}

async function handlePurchase(plan: VipPlanUI) {
  if (plan.level === 'free') return
  selectedPlanLevel.value = plan.level
  creatingOrder.value = true
  try {
    const order = await createOrder({
      planId: plan.level === 'vip' ? 1 : 2,
      paymentMethod: payMethod.value
    })
    currentOrder.value = order
    paymentVisible.value = true
  } catch {
    ElMessage.error('创建订单失败')
  } finally {
    creatingOrder.value = false
  }
}

async function confirmPay() {
  if (!currentOrder.value) return
  paying.value = true
  try {
    window.open(currentOrder.value.paymentUrl, '_blank')
    paymentVisible.value = false
    ElMessage.success('请在新窗口完成支付')
    pollPaymentStatus(currentOrder.value.orderId)
  } finally {
    paying.value = false
  }
}

function pollPaymentStatus(orderId: number) {
  const interval = setInterval(async () => {
    try {
      const status = await getOrderStatus(orderId)
      if (status.status === 'paid') {
        clearInterval(interval)
        ElMessage.success('支付成功')
        await fetchVipStatus()
      }
    } catch {
      clearInterval(interval)
    }
  }, 3000)

  setTimeout(() => clearInterval(interval), 300000)
}
</script>

<style scoped>
.vip-purchase-page {
  padding-bottom: 24px;
}

.page-title {
  font-size: 24px;
  font-weight: 600;
  margin-bottom: 20px;
  color: var(--text-primary);
  display: flex;
  align-items: center;
  gap: 12px;
}

.title-decoration {
  display: inline-block;
  width: 30px;
  height: 2px;
  background: var(--gradient-main);
  box-shadow: 0 0 8px rgba(179, 71, 217, 0.4);
}

.status-card {
  margin-bottom: 24px;
}

.plans-row {
  margin-bottom: 32px;
}

.plan-card {
  position: relative;
  text-align: center;
  padding: 24px;
  height: 100%;
  transition: all var(--transition-normal);
  background-color: var(--bg-card) !important;
  border: 1px solid var(--border-color) !important;
  overflow: hidden;
}

.plan-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-card-hover), var(--shadow-neon-purple) !important;
}

.plan-card.popular {
  border: 2px solid var(--accent-orange) !important;
  box-shadow: var(--shadow-neon-orange) !important;
}

.plan-card.current {
  border: 2px solid var(--accent-green) !important;
  box-shadow: var(--shadow-neon-green) !important;
}

.popular-badge {
  position: absolute;
  top: 0;
  right: 0;
  background: linear-gradient(135deg, #ff8c00, #ffb300);
  color: #0a0a0f;
  padding: 4px 12px;
  font-size: 12px;
  border-bottom-left-radius: 8px;
  font-weight: 600;
}

.current-badge {
  position: absolute;
  top: 0;
  left: 0;
  background: linear-gradient(135deg, #00ff88, #00aa55);
  color: #0a0a0f;
  padding: 4px 12px;
  font-size: 12px;
  border-bottom-right-radius: 8px;
  font-weight: 600;
}

.plan-header {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin-bottom: 16px;
}

.plan-name {
  font-size: 20px;
  font-weight: 600;
  margin: 0;
  color: var(--text-primary);
}

.plan-price {
  margin-bottom: 8px;
  display: flex;
  align-items: baseline;
  justify-content: center;
  gap: 4px;
}

.price-symbol {
  font-size: 20px;
  color: var(--accent-red);
  font-weight: 600;
  text-shadow: 0 0 10px rgba(255, 51, 102, 0.4);
}

.price-number {
  font-size: 40px;
  font-weight: 700;
  color: var(--accent-red);
  text-shadow: 0 0 15px rgba(255, 51, 102, 0.4);
  font-family: var(--font-family-display);
}

.price-free {
  font-size: 32px;
  font-weight: 700;
  color: var(--accent-green);
  text-shadow: 0 0 15px rgba(0, 255, 136, 0.4);
  font-family: var(--font-family-display);
}

.price-unit {
  color: var(--text-muted);
  font-size: 14px;
}

.original-price {
  color: var(--text-muted);
  text-decoration: line-through;
  font-size: 14px;
  margin-bottom: 8px;
}

.feature-list {
  list-style: none;
  padding: 0;
  margin: 0 0 24px;
  text-align: left;
}

.feature-list li {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 0;
  color: var(--text-secondary);
  font-size: 14px;
}

.feature-list li .disabled {
  color: var(--text-muted);
  text-decoration: line-through;
}

.buy-button {
  width: 100%;
}

.compare-table-card {
  margin-top: 24px;
}

.compare-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  cursor: pointer;
  font-weight: 600;
  user-select: none;
  color: var(--text-primary);
}

.compare-header .el-icon {
  transition: transform 0.3s;
}

.compare-header .el-icon.rotate {
  transform: rotate(180deg);
}

.payment-content {
  padding: 8px;
}

.order-summary {
  background: var(--bg-secondary);
  border-radius: var(--radius-md);
  padding: 16px;
  margin-bottom: 16px;
  border: 1px solid var(--border-color);
}

.order-item {
  display: flex;
  justify-content: space-between;
  padding: 6px 0;
  font-size: 14px;
}

.order-label {
  color: var(--text-muted);
}

.order-value {
  color: var(--text-primary);
  font-weight: 500;
}

.order-id {
  font-family: monospace;
  font-size: 12px;
}

.order-amount {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
}

.amount-label {
  font-size: 14px;
  color: var(--text-secondary);
}

.amount-value {
  font-size: 28px;
  font-weight: 700;
  color: var(--accent-red);
  text-shadow: 0 0 15px rgba(255, 51, 102, 0.4);
  font-family: var(--font-family-display);
}

.pay-method-title {
  font-weight: 600;
  margin-bottom: 12px;
  font-size: 14px;
  color: var(--text-primary);
}

.pay-methods {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 24px;
}

.pay-method {
  display: flex;
  align-items: center;
  gap: 12px;
  border: 2px solid var(--border-color);
  border-radius: var(--radius-md);
  padding: 12px 16px;
  cursor: pointer;
  transition: all var(--transition-normal);
  position: relative;
}

.pay-method:hover,
.pay-method.active {
  border-color: var(--accent-cyan);
  background: var(--bg-card-hover);
  box-shadow: var(--shadow-neon-cyan);
}

.pay-icon {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
}

.pay-icon.wechat {
  background: #07c160;
}

.pay-icon.alipay {
  background: #1677ff;
}

.pay-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
  flex: 1;
}

.pay-name {
  font-size: 15px;
  font-weight: 500;
  color: var(--text-primary);
}

.pay-desc {
  font-size: 12px;
  color: var(--text-muted);
}

.check-icon {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
}

.confirm-pay {
  width: 100%;
}
</style>
