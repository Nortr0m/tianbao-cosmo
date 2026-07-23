<template>
  <div class="user-center-page">
    <div class="page-header">
      <h1 class="page-title">个人中心</h1>
      <p class="page-desc">管理您的账户信息和使用记录</p>
    </div>

    <el-row :gutter="24">
      <!-- 左侧：用户信息 + 菜单 -->
      <el-col :span="7">
        <!-- 个人信息卡片 -->
        <el-card class="profile-card" :class="{ 'vip-card': userStore.isVip }">
          <!-- VIP 发光效果层 -->
          <div v-if="userStore.isVip" class="vip-glow-layer"></div>
          <div class="user-profile">
            <div class="avatar-wrapper">
              <el-avatar :size="90" :src="userStore.avatar" :icon="UserFilled" class="user-avatar" />
              <div v-if="userStore.isVip" class="vip-ring"></div>
            </div>
            <h2 class="user-name">{{ userStore.realName || userStore.username }}</h2>
            <p class="user-phone">{{ userStore.userInfo?.phone }}</p>

            <div class="vip-badge">
              <div v-if="userStore.isVip" class="vip-badge-inner">
                <el-icon><Medal /></el-icon>
                <span>{{ userStore.vipLevel >= 2 ? 'SVIP' : 'VIP' }} {{ userStore.vipLevel }}</span>
              </div>
              <div v-else class="normal-badge">
                <span>普通用户</span>
              </div>
            </div>

            <p v-if="userStore.isVip && userStore.vipExpireTime" class="expire-time">
              <el-icon><Timer /></el-icon>
              到期时间：{{ formatDate(userStore.vipExpireTime) }}
            </p>

            <el-button
              v-if="!userStore.isVip"
              type="warning"
              size="large"
              class="vip-button"
              @click="router.push('/vip')"
            >
              <el-icon><Trophy /></el-icon>
              开通VIP
            </el-button>
            <el-button
              v-else-if="userStore.vipLevel === 1"
              type="danger"
              size="large"
              class="vip-button"
              @click="router.push('/vip')"
            >
              <el-icon><Trophy /></el-icon>
              升级SVIP
            </el-button>
            <el-button
              v-else
              type="success"
              size="large"
              class="vip-button"
              disabled
            >
              <el-icon><Star /></el-icon>
              SVIP尊享
            </el-button>
          </div>
        </el-card>

        <!-- 菜单卡片 -->
        <el-card class="menu-card tb-card-enhanced">
          <el-menu
            :default-active="activeTab"
            @select="handleTabChange"
            class="side-menu"
          >
            <el-menu-item index="profile" class="menu-item">
              <el-icon class="menu-icon"><User /></el-icon>
              <span>基本资料</span>
            </el-menu-item>
            <el-menu-item index="compare" class="menu-item">
              <el-icon class="menu-icon"><DocumentCopy /></el-icon>
              <span>我的对比历史</span>
              <el-badge v-if="compareHistory.length" :value="compareHistory.length" class="menu-badge" />
            </el-menu-item>
            <el-menu-item index="card" class="menu-item">
              <el-icon class="menu-icon"><Picture /></el-icon>
              <span>我的卡片记录</span>
            </el-menu-item>
            <el-menu-item index="order" class="menu-item">
              <el-icon class="menu-icon"><Tickets /></el-icon>
              <span>我的订单</span>
            </el-menu-item>
            <el-menu-item index="settings" class="menu-item">
              <el-icon class="menu-icon"><Setting /></el-icon>
              <span>账号设置</span>
            </el-menu-item>
          </el-menu>
        </el-card>
      </el-col>

      <!-- 右侧：内容区 -->
      <el-col :span="17">
        <!-- 基本资料 -->
        <el-card v-if="activeTab === 'profile'" class="content-card tb-card-enhanced">
          <template #header>
            <div class="card-header">
              <el-icon><User /></el-icon>
              <span>基本资料</span>
            </div>
          </template>
          <el-form :model="profileForm" label-width="100px" class="profile-form">
            <el-form-item label="头像">
              <el-upload
                class="avatar-uploader"
                action="/api/upload/avatar"
                :show-file-list="false"
                :on-success="handleAvatarSuccess"
                :before-upload="beforeAvatarUpload"
              >
                <el-avatar :size="80" :src="profileForm.avatar" :icon="UserFilled" />
                <div class="upload-tip">点击更换头像</div>
              </el-upload>
            </el-form-item>
            <el-form-item label="用户名">
              <el-input v-model="profileForm.username" disabled />
            </el-form-item>
            <el-form-item label="真实姓名">
              <el-input v-model="profileForm.realName" placeholder="请输入真实姓名" />
            </el-form-item>
            <el-form-item label="手机号">
              <el-input v-model="profileForm.phone" disabled />
            </el-form-item>
            <el-form-item label="邮箱">
              <el-input v-model="profileForm.email" placeholder="请输入邮箱" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleUpdateProfile">保存修改</el-button>
            </el-form-item>
          </el-form>
        </el-card>

        <!-- 对比历史 -->
        <el-card v-if="activeTab === 'compare'" class="content-card tb-card-enhanced">
          <template #header>
            <div class="card-header">
              <el-icon><DocumentCopy /></el-icon>
              <span>我的对比历史</span>
            </div>
          </template>
          <el-empty v-if="compareHistory.length === 0" description="暂无对比记录" />
          <el-timeline v-else>
            <el-timeline-item
              v-for="item in compareHistory"
              :key="item.id"
              :timestamp="formatDateTime(item.createdAt)"
              placement="top"
            >
              <el-card shadow="hover" class="history-card">
                <div class="history-content">
                  <p class="history-title">对比产品</p>
                  <p class="history-products">{{ item.productIds?.join('、') || '-' }}</p>
                </div>
                <div class="history-actions">
                  <el-button type="primary" text @click="viewCompare(item.id)">
                    查看详情
                  </el-button>
                  <el-button type="danger" text @click="deleteCompare(item.id)">
                    删除
                  </el-button>
                </div>
              </el-card>
            </el-timeline-item>
          </el-timeline>
        </el-card>

        <!-- 卡片记录 -->
        <el-card v-if="activeTab === 'card'" class="content-card tb-card-enhanced">
          <template #header>
            <div class="card-header">
              <el-icon><Picture /></el-icon>
              <span>我的卡片记录</span>
            </div>
          </template>
          <el-empty v-if="cardHistory.length === 0" description="暂无卡片记录" />
          <div v-else>
            <el-row :gutter="16">
              <el-col v-for="card in cardHistory" :key="card.id" :span="8">
                <el-card :body-style="{ padding: '0px' }" shadow="hover" class="card-record">
                  <img :src="card.imageUrl" class="card-image" loading="lazy" />
                  <div class="card-meta">
                    <p class="card-time">{{ formatDateTime(card.createdAt) }}</p>
                  </div>
                  <div class="card-actions">
                    <el-button type="primary" text @click="downloadCard(card.imageUrl)">
                      <el-icon><Download /></el-icon>下载
                    </el-button>
                    <el-button type="danger" text @click="deleteCardItem(card.id)">
                      <el-icon><Delete /></el-icon>删除
                    </el-button>
                  </div>
                </el-card>
              </el-col>
            </el-row>
            <div class="pagination-wrapper">
              <el-pagination
                v-model:current-page="cardPage"
                :page-size="cardPageSize"
                :total="cardTotal"
                layout="prev, pager, next"
                @current-change="loadCardHistory"
              />
            </div>
          </div>
        </el-card>

        <!-- 订单记录 -->
        <el-card v-if="activeTab === 'order'" class="content-card tb-card-enhanced">
          <template #header>
            <div class="card-header">
              <el-icon><Tickets /></el-icon>
              <span>我的订单</span>
            </div>
          </template>
          <el-empty v-if="orderHistory.length === 0" description="暂无订单记录" />
          <BaseTable v-else :data="orderHistory">
            <el-table-column prop="planName" label="套餐" min-width="120" />
            <el-table-column prop="price" label="金额" width="100">
              <template #default="{ row }">
                <span class="order-price">{{ formatCurrency(row.price) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="status" label="状态" width="100">
              <template #default="{ row }">
                <el-tag :type="getOrderStatusType(row.status)" size="small">
                  {{ getOrderStatusLabel(row.status) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="createdAt" label="下单时间" min-width="160">
              <template #default="{ row }">
                {{ formatDateTime(row.createdAt) }}
              </template>
            </el-table-column>
            <el-table-column prop="paidAt" label="支付时间" min-width="160">
              <template #default="{ row }">
                {{ row.paidAt ? formatDateTime(row.paidAt) : '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="expireAt" label="到期时间" min-width="160">
              <template #default="{ row }">
                {{ row.expireAt ? formatDateTime(row.expireAt) : '-' }}
              </template>
            </el-table-column>
          </BaseTable>
        </el-card>

        <!-- 账号设置 -->
        <el-card v-if="activeTab === 'settings'" class="content-card tb-card-enhanced">
          <template #header>
            <div class="card-header">
              <el-icon><Setting /></el-icon>
              <span>账号设置</span>
            </div>
          </template>

          <el-tabs v-model="settingsTab">
            <!-- 修改密码 -->
            <el-tab-pane label="修改密码" name="password">
              <el-form :model="passwordForm" label-width="100px" class="settings-form">
                <el-form-item label="当前密码">
                  <el-input
                    v-model="passwordForm.oldPassword"
                    type="password"
                    show-password
                    placeholder="请输入当前密码"
                  />
                </el-form-item>
                <el-form-item label="新密码">
                  <el-input
                    v-model="passwordForm.newPassword"
                    type="password"
                    show-password
                    placeholder="请输入新密码（6-20位）"
                  />
                </el-form-item>
                <el-form-item label="确认密码">
                  <el-input
                    v-model="passwordForm.confirmPassword"
                    type="password"
                    show-password
                    placeholder="请再次输入新密码"
                  />
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" @click="handleChangePassword">确认修改</el-button>
                </el-form-item>
              </el-form>
            </el-tab-pane>

            <!-- 绑定微信 -->
            <el-tab-pane label="绑定微信" name="wechat">
              <div class="bind-wechat">
                <div v-if="!isWechatBound" class="bind-content">
                  <el-empty description="绑定微信后可使用微信快速登录">
                    <template #image>
                      <div class="qrcode-placeholder">
                        <el-icon :size="48"><ChatDotRound /></el-icon>
                        <p>微信二维码区域</p>
                      </div>
                    </template>
                    <el-button type="primary" @click="openBindWechatDialog">获取绑定二维码</el-button>
                  </el-empty>
                </div>
                <div v-else class="bind-success">
                  <el-result icon="success" title="已绑定微信" sub-title="您可以使用微信快速登录">
                    <template #extra>
                      <el-button type="danger" @click="handleUnbindWechat">解除绑定</el-button>
                    </template>
                  </el-result>
                </div>
              </div>
            </el-tab-pane>

            <!-- 通知设置 -->
            <el-tab-pane label="通知设置" name="notification">
              <el-form label-width="140px" class="settings-form">
                <el-form-item label="对比完成通知">
                  <el-switch v-model="notificationSettings.compareComplete" />
                </el-form-item>
                <el-form-item label="卡片生成通知">
                  <el-switch v-model="notificationSettings.cardGenerated" />
                </el-form-item>
                <el-form-item label="会员到期提醒">
                  <el-switch v-model="notificationSettings.vipExpire" />
                </el-form-item>
                <el-form-item label="系统公告">
                  <el-switch v-model="notificationSettings.systemNotice" />
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" @click="saveNotificationSettings">保存设置</el-button>
                </el-form-item>
              </el-form>
            </el-tab-pane>
          </el-tabs>
        </el-card>
      </el-col>
    </el-row>

    <!-- 微信绑定扫码弹窗 -->
    <el-dialog
      v-model="bindDialogVisible"
      title="微信绑定"
      width="400px"
      :close-on-click-modal="false"
      @close="handleBindDialogClose"
    >
      <div class="bind-dialog-content">
        <!-- 加载中 -->
        <div v-if="bindQrLoading" class="bind-qr-loading">
          <el-icon :size="32" class="is-loading"><Loading /></el-icon>
          <p>正在获取二维码...</p>
        </div>

        <!-- 二维码显示 -->
        <template v-else-if="bindQrCodeUrl">
          <img :src="bindQrCodeUrl" alt="微信绑定二维码" class="bind-qr-img" />
          <div class="bind-qr-status">
            <div v-if="bindQrStatus === 'WAITING'" class="bind-status-waiting">
              <el-icon><ChatDotRound /></el-icon>
              <span>请使用微信扫描二维码完成绑定</span>
            </div>
            <div v-else-if="bindQrStatus === 'SCANNED'" class="bind-status-scanned">
              <el-icon><CircleCheck /></el-icon>
              <span>已扫码，请在手机上确认绑定</span>
            </div>
            <div v-else-if="bindQrStatus === 'EXPIRED'" class="bind-status-expired">
              <el-icon><Warning /></el-icon>
              <span>二维码已过期</span>
              <el-button type="primary" size="small" @click="fetchBindQrCode">
                点击刷新
              </el-button>
            </div>
          </div>
        </template>

        <!-- 获取失败 -->
        <div v-else class="bind-qr-error">
          <el-icon :size="32"><WarningFilled /></el-icon>
          <p>二维码获取失败</p>
          <el-button type="primary" size="small" @click="fetchBindQrCode">
            重新获取
          </el-button>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  UserFilled,
  Medal,
  User,
  DocumentCopy,
  Picture,
  Tickets,
  Setting,
  Timer,
  Trophy,
  Download,
  Delete,
  ChatDotRound,
  Loading,
  CircleCheck,
  Warning,
  WarningFilled,
  Star
} from '@element-plus/icons-vue'
import { useUserStore } from '@/stores/userStore'
import { useCompareStore } from '@/stores/compareStore'
import { getOrderHistory } from '@/api/vip'
import { getCardHistory, deleteCard } from '@/api/card'
import { getWechatQrCode, checkWechatQrCode, unbindWechat as apiUnbindWechat } from '@/api/auth'
import type { VipOrder } from '@/api/vip'
import type { CardGenerateResult } from '@/api/card'
import { formatCurrency, formatDateTime, formatDate } from '@/utils/format'
import BaseTable from '@/components/common/BaseTable.vue'

const router = useRouter()
const userStore = useUserStore()
const compareStore = useCompareStore()

const activeTab = ref('profile')
const settingsTab = ref('password')

// 对比历史
const compareHistory = ref(compareStore.compareHistory)

// 卡片记录
const cardHistory = ref<CardGenerateResult[]>([])
const cardPage = ref(1)
const cardPageSize = ref(9)
const cardTotal = ref(0)

// 订单记录
const orderHistory = ref<VipOrder[]>([])

// 个人资料表单
const profileForm = ref({
  username: userStore.username,
  realName: userStore.realName,
  phone: userStore.userInfo?.phone || '',
  email: userStore.userInfo?.email || '',
  avatar: userStore.avatar
})

// 密码表单
const passwordForm = ref({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

// 微信绑定状态
const isWechatBound = ref(false)

// 微信绑定扫码弹窗相关状态
const bindDialogVisible = ref(false)
const bindQrLoading = ref(false)
const bindQrCodeUrl = ref('')
const bindQrSessionId = ref('')
const bindQrStatus = ref<'WAITING' | 'SCANNED' | 'CONFIRMED' | 'EXPIRED'>('WAITING')
let bindPollTimer: ReturnType<typeof setInterval> | null = null

// 通知设置
const notificationSettings = ref({
  compareComplete: true,
  cardGenerated: true,
  vipExpire: true,
  systemNotice: true
})

onMounted(async () => {
  // 从用户信息获取微信绑定状态
  isWechatBound.value = !!userStore.userInfo?.wechatBound

  await Promise.all([
    compareStore.fetchCompareHistory().then(() => {
      compareHistory.value = compareStore.compareHistory
    }),
    loadCardHistory(),
    loadOrderHistory()
  ])
})

async function loadCardHistory(page = 1) {
  try {
    const res = await getCardHistory(page, cardPageSize.value)
    cardHistory.value = res.list
    cardTotal.value = res.total
    cardPage.value = page
  } catch {
    cardHistory.value = []
    cardTotal.value = 0
  }
}

async function loadOrderHistory() {
  try {
    const res = await getOrderHistory()
    orderHistory.value = res
  } catch {
    orderHistory.value = []
  }
}

function handleTabChange(index: string) {
  activeTab.value = index
}

function handleUpdateProfile() {
  // TODO: 调用API更新资料
  ElMessage.success('资料已更新')
}

function handleAvatarSuccess(response: { url: string }) {
  profileForm.value.avatar = response.url
  ElMessage.success('头像上传成功')
}

function beforeAvatarUpload(file: File): boolean {
  const isJpgOrPng = file.type === 'image/jpeg' || file.type === 'image/png'
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isJpgOrPng) {
    ElMessage.error('只支持 JPG/PNG 格式')
  }
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB')
  }
  return isJpgOrPng && isLt2M
}

function viewCompare(id: number) {
  router.push(`/compare?id=${id}`)
}

async function deleteCompare(id: number) {
  try {
    await ElMessageBox.confirm('确定删除此对比记录？', '提示', { type: 'warning' })
    // TODO: 调用删除API
    compareHistory.value = compareHistory.value.filter((item) => item.id !== id)
    ElMessage.success('已删除')
  } catch {
    // cancelled
  }
}

function downloadCard(url: string) {
  const link = document.createElement('a')
  link.href = url
  link.download = `卡片_${Date.now()}.png`
  link.click()
}

async function deleteCardItem(id: number) {
  try {
    await ElMessageBox.confirm('确定删除此卡片？', '提示', { type: 'warning' })
    await deleteCard(id)
    ElMessage.success('已删除')
    await loadCardHistory(cardPage.value)
  } catch {
    // cancelled
  }
}

function handleChangePassword() {
  if (!passwordForm.value.oldPassword) {
    ElMessage.warning('请输入当前密码')
    return
  }
  if (!passwordForm.value.newPassword || passwordForm.value.newPassword.length < 6) {
    ElMessage.warning('新密码至少6位')
    return
  }
  if (passwordForm.value.newPassword !== passwordForm.value.confirmPassword) {
    ElMessage.warning('两次输入的密码不一致')
    return
  }
  // TODO: 调用API修改密码
  ElMessage.success('密码修改成功')
  passwordForm.value = { oldPassword: '', newPassword: '', confirmPassword: '' }
}

function openBindWechatDialog() {
  bindDialogVisible.value = true
  fetchBindQrCode()
}

async function fetchBindQrCode() {
  bindQrLoading.value = true
  bindQrCodeUrl.value = ''
  bindQrSessionId.value = ''
  bindQrStatus.value = 'WAITING'
  clearBindPollTimer()

  try {
    const result = await getWechatQrCode()
    bindQrCodeUrl.value = result.qrCodeUrl
    bindQrSessionId.value = result.sessionId
    startBindPolling()
  } catch (error) {
    const msg = error instanceof Error ? error.message : '获取二维码失败'
    ElMessage.error(msg)
  } finally {
    bindQrLoading.value = false
  }
}

function startBindPolling() {
  clearBindPollTimer()
  bindPollTimer = setInterval(async () => {
    if (!bindQrSessionId.value) return
    try {
      const result = await checkWechatQrCode(bindQrSessionId.value)
      bindQrStatus.value = result.status

      if (result.status === 'CONFIRMED') {
        clearBindPollTimer()
        // 绑定成功
        isWechatBound.value = true
        bindDialogVisible.value = false
        ElMessage.success('微信绑定成功')
      } else if (result.status === 'EXPIRED') {
        clearBindPollTimer()
      }
    } catch {
      // 轮询失败不中断，继续尝试
    }
  }, 2000)
}

function clearBindPollTimer() {
  if (bindPollTimer) {
    clearInterval(bindPollTimer)
    bindPollTimer = null
  }
}

function handleBindDialogClose() {
  clearBindPollTimer()
}

async function handleUnbindWechat() {
  try {
    await ElMessageBox.confirm('确定解除微信绑定？解除后将无法使用微信快速登录', '提示', { type: 'warning' })
    await apiUnbindWechat()
    isWechatBound.value = false
    ElMessage.success('已解除微信绑定')
  } catch (error) {
    // 用户取消确认时不提示错误
    if (error !== 'cancel') {
      const msg = error instanceof Error ? error.message : '解绑失败'
      ElMessage.error(msg)
    }
  }
}

// 组件卸载时清除定时器
onUnmounted(() => {
  clearBindPollTimer()
})

function saveNotificationSettings() {
  // TODO: 调用API保存通知设置
  ElMessage.success('设置已保存')
}

function getOrderStatusType(status: string): 'info' | 'primary' | 'success' | 'warning' | 'danger' {
  const map: Record<string, 'info' | 'primary' | 'success' | 'warning' | 'danger'> = {
    pending: 'warning',
    paid: 'success',
    cancelled: 'info',
    expired: 'danger'
  }
  return map[status] || 'info'
}

function getOrderStatusLabel(status: string): string {
  const map: Record<string, string> = {
    pending: '待支付',
    paid: '已支付',
    cancelled: '已取消',
    expired: '已过期'
  }
  return map[status] || status
}
</script>

<style scoped>
.user-center-page {
  padding-bottom: 40px;
}

/* 页面头部 */
.page-header {
  margin-bottom: 24px;
}

.page-title {
  font-size: 26px;
  font-weight: 700;
  margin: 0 0 6px;
  color: var(--text-primary);
  display: flex;
  align-items: center;
  gap: 12px;
}

.page-title::before {
  content: '';
  display: inline-block;
  width: 4px;
  height: 24px;
  background: var(--gradient-main);
  border-radius: 2px;
  box-shadow: 0 0 8px rgba(139, 92, 246, 0.5);
}

.page-desc {
  font-size: 14px;
  color: var(--text-secondary);
  margin: 0;
  padding-left: 16px;
}

/* 个人信息卡片 - VIP发光效果 */
.profile-card {
  margin-bottom: 20px;
  position: relative;
  overflow: hidden;
  border-radius: var(--radius-xl) !important;
  background: var(--bg-card) !important;
  border: 1px solid var(--border-color) !important;
}

.profile-card.vip-card {
  border: 1px solid rgba(251, 191, 36, 0.35) !important;
  background: linear-gradient(160deg, rgba(251, 191, 36, 0.08) 0%, var(--bg-card) 50%) !important;
}

.vip-glow-layer {
  position: absolute;
  top: -100px;
  left: 50%;
  transform: translateX(-50%);
  width: 300px;
  height: 200px;
  background: radial-gradient(ellipse at center, rgba(251, 191, 36, 0.25) 0%, transparent 70%);
  animation: vip-glow-pulse 3s ease-in-out infinite;
  pointer-events: none;
  z-index: 0;
}

@keyframes vip-glow-pulse {
  0%, 100% { opacity: 0.6; transform: translateX(-50%) scale(1); }
  50% { opacity: 1; transform: translateX(-50%) scale(1.15); }
}

.profile-card.vip-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: var(--gradient-gold-glow);
  box-shadow: 0 0 12px rgba(251, 191, 36, 0.6);
  z-index: 1;
}

.user-profile {
  text-align: center;
  padding: 28px 20px;
  position: relative;
  z-index: 2;
}

/* 头像包装 */
.avatar-wrapper {
  position: relative;
  display: inline-block;
  margin-bottom: 16px;
}

.user-avatar {
  border: 3px solid var(--border-color);
  background: var(--bg-card-hover);
  position: relative;
  z-index: 1;
}

.vip-ring {
  position: absolute;
  top: -4px;
  left: -4px;
  right: -4px;
  bottom: -4px;
  border-radius: 50%;
  background: var(--gradient-gold);
  padding: 2px;
  animation: vip-ring-rotate 8s linear infinite;
  z-index: 0;
}

.vip-ring::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: 50%;
  background: var(--gradient-gold);
  filter: blur(8px);
  opacity: 0.5;
}

@keyframes vip-ring-rotate {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.user-name {
  font-size: 22px;
  font-weight: 700;
  margin: 0 0 4px;
  color: var(--text-primary);
}

.vip-card .user-name {
  background: var(--gradient-gold);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.user-phone {
  color: var(--text-muted);
  margin-bottom: 16px;
  font-size: 14px;
}

.vip-badge {
  margin-bottom: 14px;
  display: flex;
  justify-content: center;
}

.vip-badge-inner {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 16px;
  background: var(--gradient-gold);
  color: #fff;
  border-radius: 20px;
  font-size: 14px;
  font-weight: 600;
  box-shadow: 0 4px 16px rgba(251, 191, 36, 0.4);
}

.normal-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 16px;
  background: var(--bg-secondary);
  color: var(--text-secondary);
  border-radius: 20px;
  font-size: 14px;
  border: 1px solid var(--border-color);
}

.expire-time {
  color: var(--text-muted);
  font-size: 13px;
  margin-bottom: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
}

.vip-card .expire-time {
  color: var(--accent-gold);
  opacity: 0.8;
}

.vip-button {
  width: 100%;
  font-weight: 600;
}

/* 菜单卡片 */
.menu-card {
  border-radius: var(--radius-lg) !important;
}

.menu-card :deep(.el-card__body) {
  padding: 12px;
}

.side-menu {
  border-right: none !important;
  background: transparent !important;
}

.menu-item {
  height: 48px !important;
  line-height: 48px !important;
  border-radius: var(--radius-md);
  margin-bottom: 4px;
  padding: 0 16px !important;
  color: var(--text-secondary) !important;
  transition: all var(--transition-fast) !important;
  position: relative;
  display: flex !important;
  align-items: center !important;
}

.menu-item .menu-icon {
  font-size: 18px;
  margin-right: 12px;
  flex-shrink: 0;
}

.menu-item:hover {
  background-color: var(--bg-card-hover) !important;
  color: var(--accent-cyan) !important;
}

.menu-item.is-active {
  background: linear-gradient(135deg, rgba(99, 102, 241, 0.15), rgba(139, 92, 246, 0.1)) !important;
  color: var(--accent-purple) !important;
  font-weight: 600;
  position: relative;
}

.menu-item.is-active::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 3px;
  height: 20px;
  background: var(--gradient-main);
  border-radius: 0 2px 2px 0;
}

.menu-item.is-active .menu-icon {
  color: var(--accent-purple);
}

.menu-badge {
  margin-left: auto;
}

/* 内容卡片 */
.content-card {
  min-height: 560px;
  border-radius: var(--radius-lg) !important;
}

.card-header {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  font-size: 16px;
  color: var(--text-primary);
}

.card-header .el-icon {
  color: var(--accent-purple);
}

.profile-form {
  max-width: 480px;
}

.avatar-uploader {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 8px;
}

.upload-tip {
  font-size: 12px;
  color: var(--text-muted);
}

/* 历史卡片 */
.history-card {
  margin-bottom: 8px;
  background: var(--bg-secondary) !important;
  border: 1px solid var(--border-color) !important;
  border-radius: var(--radius-md) !important;
  transition: all var(--transition-fast) !important;
}

.history-card:hover {
  border-color: var(--border-glow) !important;
  box-shadow: var(--shadow-neon-purple) !important;
}

.history-content {
  margin-bottom: 8px;
}

.history-title {
  font-size: 13px;
  color: var(--text-muted);
  margin: 0 0 4px;
}

.history-products {
  font-size: 14px;
  color: var(--text-primary);
  margin: 0;
  font-weight: 500;
}

.history-actions {
  display: flex;
  gap: 8px;
}

/* 卡片记录 */
.card-record {
  margin-bottom: 16px;
  transition: all var(--transition-normal);
  background: var(--bg-card) !important;
  border: 1px solid var(--border-color) !important;
  border-radius: var(--radius-md) !important;
  overflow: hidden;
}

.card-record:hover {
  transform: translateY(-3px);
  border-color: var(--border-glow) !important;
  box-shadow: var(--shadow-card-hover), var(--shadow-neon-purple) !important;
}

.card-image {
  width: 100%;
  height: 140px;
  object-fit: cover;
  display: block;
}

.card-meta {
  padding: 10px 14px 0;
}

.card-time {
  font-size: 12px;
  color: var(--text-muted);
  margin: 0;
}

.card-actions {
  display: flex;
  justify-content: space-around;
  padding: 10px;
  border-top: 1px solid var(--border-color);
}

.pagination-wrapper {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.order-price {
  color: var(--accent-orange);
  font-weight: 600;
}

/* 设置表单 */
.settings-form {
  max-width: 480px;
  padding-top: 16px;
}

/* 微信绑定 */
.bind-wechat {
  padding: 20px 0;
}

.qrcode-placeholder {
  width: 160px;
  height: 160px;
  margin: 0 auto 16px;
  border: 2px dashed var(--border-color);
  border-radius: var(--radius-md);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: var(--text-muted);
  background: var(--bg-secondary);
}

.bind-success {
  padding: 20px 0;
}

/* 微信绑定弹窗样式 */
.bind-dialog-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 10px 0;
}

.bind-qr-img {
  width: 200px;
  height: 200px;
  border-radius: var(--radius-md);
  border: 2px solid var(--border-color);
  margin-bottom: 16px;
}

.bind-qr-loading,
.bind-qr-error {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  padding: 40px 0;
  color: var(--text-muted);
}

.bind-qr-status {
  text-align: center;
}

.bind-status-waiting,
.bind-status-scanned,
.bind-status-expired {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  font-size: 14px;
}

.bind-status-waiting {
  color: var(--text-secondary);
}

.bind-status-scanned {
  color: var(--accent-green);
}

.bind-status-scanned .el-icon {
  animation: pulse 1.5s infinite;
}

.bind-status-expired {
  color: var(--accent-red);
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

/* 标签页样式 */
.content-card :deep(.el-tabs__item) {
  font-size: 15px;
}

.content-card :deep(.el-tabs__item.is-active) {
  font-weight: 600;
}

/* 时间线 */
:deep(.el-timeline-item__node) {
  background-color: var(--accent-purple);
}

:deep(.el-timeline-item__tail) {
  border-left: 2px solid var(--border-color);
}

:deep(.el-timeline-item__timestamp) {
  color: var(--text-muted);
}

/* 响应式 */
@media (max-width: 992px) {
  .user-center-page .el-row {
    flex-direction: column;
  }
  .user-center-page .el-col {
    width: 100% !important;
    margin-bottom: 20px;
  }
  .content-card {
    min-height: auto;
  }
}
</style>
