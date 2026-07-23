<template>
  <div class="login-view">
    <div class="login-logo">
      <img src="/logo.jpg" alt="天保星君" class="login-logo-img" />
    </div>
    <h2 class="auth-title">欢迎登录</h2>
    <p class="auth-subtitle">登录后即可使用全部功能</p>

    <!-- 登录方式切换 -->
    <div class="login-switch">
      <div
        class="switch-item"
        :class="{ active: loginMode === 'password' }"
        @click="switchLoginMode('password')"
      >
        <el-icon><Lock /></el-icon>
        <span>账号密码</span>
      </div>
      <div
        class="switch-item"
        :class="{ active: loginMode === 'wechat' }"
        @click="switchLoginMode('wechat')"
      >
        <el-icon><ChatDotRound /></el-icon>
        <span>微信扫码</span>
      </div>
    </div>

    <!-- 账号密码登录 -->
    <el-form
      v-if="loginMode === 'password'"
      ref="formRef"
      :model="form"
      :rules="rules"
      class="auth-form"
      @keyup.enter="handleSubmit"
    >
      <el-form-item prop="username">
        <el-input
          v-model="form.username"
          placeholder="用户名/手机号"
          size="large"
          :prefix-icon="User"
        />
      </el-form-item>

      <el-form-item prop="password">
        <el-input
          v-model="form.password"
          type="password"
          placeholder="密码"
          size="large"
          show-password
          :prefix-icon="Lock"
        />
      </el-form-item>

      <el-form-item>
        <el-button
          type="primary"
          size="large"
          class="submit-btn neon-btn"
          :loading="loading"
          @click="handleSubmit"
        >
          登录
        </el-button>
      </el-form-item>
    </el-form>

    <!-- 微信扫码登录 -->
    <div v-if="loginMode === 'wechat'" class="wechat-qrcode-panel">
      <div class="qrcode-container">
        <!-- 加载中 -->
        <div v-if="qrLoading" class="qrcode-loading">
          <el-icon :size="32" class="is-loading"><Loading /></el-icon>
          <p>正在获取二维码...</p>
        </div>

        <!-- 二维码显示 -->
        <template v-else-if="qrCodeUrl">
          <img :src="qrCodeUrl" alt="微信扫码登录" class="qrcode-img" />
          <div class="qrcode-status">
            <div v-if="qrStatus === 'WAITING'" class="status-waiting">
              <el-icon><ChatDotRound /></el-icon>
              <span>请使用微信扫描二维码登录</span>
            </div>
            <div v-else-if="qrStatus === 'SCANNED'" class="status-scanned">
              <el-icon><CircleCheck /></el-icon>
              <span>已扫码，请在手机上确认登录</span>
            </div>
            <div v-else-if="qrStatus === 'EXPIRED'" class="status-expired">
              <el-icon><Warning /></el-icon>
              <span>二维码已过期</span>
              <el-button type="primary" size="small" @click="refreshQrCode">
                点击刷新
              </el-button>
            </div>
          </div>
        </template>

        <!-- 获取失败 -->
        <div v-else class="qrcode-error">
          <el-icon :size="32"><WarningFilled /></el-icon>
          <p>二维码获取失败</p>
          <el-button type="primary" size="small" @click="refreshQrCode">
            重新获取
          </el-button>
        </div>
      </div>
    </div>

    <div class="wechat-bind-hint">
      <p>登录后可在个人中心绑定微信，实现快捷登录</p>
    </div>

    <div class="auth-footer">
      <span>还没有账号？</span>
      <el-button type="primary" link @click="router.push('/register')">
        立即注册
      </el-button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { User, Lock, ChatDotRound, Loading, CircleCheck, Warning, WarningFilled } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { useAuth } from '@/composables/useAuth'
import { useUserStore } from '@/stores/userStore'
import { getWechatQrCode, checkWechatQrCode } from '@/api/auth'
import type { FormInstance, FormRules } from 'element-plus'

const route = useRoute()
const router = useRouter()
const { login } = useAuth()
const userStore = useUserStore()

const formRef = ref<FormInstance>()
const loading = ref(false)

// 登录模式切换
const loginMode = ref<'password' | 'wechat'>('password')

// 微信扫码相关状态
const qrLoading = ref(false)
const qrCodeUrl = ref('')
const qrSessionId = ref('')
const qrStatus = ref<'WAITING' | 'SCANNED' | 'CONFIRMED' | 'EXPIRED'>('WAITING')
let pollTimer: ReturnType<typeof setInterval> | null = null

const form = ref({
  username: '',
  password: ''
})

const rules: FormRules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

async function handleSubmit() {
  if (!formRef.value) return
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    loading.value = true
    const redirect = route.query.redirect as string
    await login(form.value, redirect)
    loading.value = false
  })
}

function switchLoginMode(mode: 'password' | 'wechat') {
  if (mode === loginMode.value) return
  loginMode.value = mode
  if (mode === 'wechat') {
    fetchQrCode()
  } else {
    clearPollTimer()
  }
}

async function fetchQrCode() {
  qrLoading.value = true
  qrCodeUrl.value = ''
  qrSessionId.value = ''
  qrStatus.value = 'WAITING'
  clearPollTimer()

  try {
    const result = await getWechatQrCode()
    qrCodeUrl.value = result.qrCodeUrl
    qrSessionId.value = result.sessionId
    startPolling()
  } catch (error) {
    const msg = error instanceof Error ? error.message : '获取二维码失败'
    ElMessage.error(msg)
  } finally {
    qrLoading.value = false
  }
}

function startPolling() {
  clearPollTimer()
  pollTimer = setInterval(async () => {
    if (!qrSessionId.value) return
    try {
      const result = await checkWechatQrCode(qrSessionId.value)
      qrStatus.value = result.status

      if (result.status === 'CONFIRMED') {
        clearPollTimer()
        // 微信扫码登录成功，使用返回的 token 信息设置登录状态
        if (result.accessToken && result.userInfo) {
          userStore.setAuth({
            accessToken: result.accessToken,
            refreshToken: result.refreshToken || '',
            expiresIn: result.expiresIn || 0,
            tokenType: result.tokenType || 'Bearer',
            userInfo: result.userInfo
          })
          ElMessage.success('微信登录成功')
          const redirect = route.query.redirect as string
          router.push(redirect || '/')
        } else {
          ElMessage.error('登录数据异常，请重试')
          refreshQrCode()
        }
      } else if (result.status === 'EXPIRED') {
        clearPollTimer()
      }
    } catch {
      // 轮询失败不中断，继续尝试
    }
  }, 2000)
}

function clearPollTimer() {
  if (pollTimer) {
    clearInterval(pollTimer)
    pollTimer = null
  }
}

function refreshQrCode() {
  fetchQrCode()
}

// 组件卸载时清除定时器
onUnmounted(() => {
  clearPollTimer()
})
</script>

<style scoped>
.login-view {
  position: relative;
}

.login-logo {
  text-align: center;
  margin-bottom: 24px;
}

.login-logo-img {
  width: 64px;
  height: 64px;
  border-radius: 16px;
  object-fit: contain;
  box-shadow: var(--shadow-neon-purple);
}

.auth-title {
  font-size: 24px;
  font-weight: 600;
  text-align: center;
  margin-bottom: 8px;
  color: var(--text-primary);
  font-family: var(--font-family-display);
  letter-spacing: 2px;
}

.auth-subtitle {
  text-align: center;
  color: var(--text-secondary);
  margin-bottom: 24px;
}

/* 登录方式切换 */
.login-switch {
  display: flex;
  gap: 0;
  margin-bottom: 24px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 12px;
  padding: 4px;
  border: 1px solid rgba(255, 255, 255, 0.08);
}

.switch-item {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  padding: 10px 0;
  border-radius: 8px;
  cursor: pointer;
  color: var(--text-secondary);
  font-size: 14px;
  transition: all var(--transition-normal);
}

.switch-item:hover {
  color: var(--text-primary);
  background: rgba(255, 255, 255, 0.05);
}

.switch-item.active {
  background: var(--gradient-main);
  color: #fff;
  font-weight: 600;
  box-shadow: var(--shadow-neon-purple);
}

.auth-form {
  margin-bottom: 16px;
}

.submit-btn {
  width: 100%;
  background: var(--gradient-main) !important;
  border: none !important;
  color: #fff !important;
  font-weight: 600;
  font-size: 16px;
  letter-spacing: 2px;
  box-shadow: var(--shadow-neon-purple);
  transition: all var(--transition-normal);
}

.submit-btn:hover {
  box-shadow: 0 0 25px rgba(179, 71, 217, 0.5), 0 0 25px rgba(0, 229, 255, 0.3) !important;
  transform: translateY(-2px);
}

/* 微信扫码面板 */
.wechat-qrcode-panel {
  margin-bottom: 16px;
}

.qrcode-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
  background: rgba(255, 255, 255, 0.03);
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.08);
}

.qrcode-img {
  width: 200px;
  height: 200px;
  border-radius: 8px;
  border: 2px solid rgba(255, 255, 255, 0.1);
  margin-bottom: 16px;
}

.qrcode-loading,
.qrcode-error {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  padding: 40px 0;
  color: var(--text-secondary);
}

.qrcode-status {
  text-align: center;
}

.status-waiting,
.status-scanned,
.status-expired {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  font-size: 14px;
}

.status-waiting {
  color: var(--text-secondary);
}

.status-scanned {
  color: #67c23a;
}

.status-scanned .el-icon {
  animation: pulse 1.5s infinite;
}

.status-expired {
  color: #f56c6c;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

.wechat-bind-hint {
  text-align: center;
  margin-bottom: 24px;
}

.wechat-bind-hint p {
  font-size: 12px;
  color: var(--text-secondary);
}

.auth-footer {
  text-align: center;
  color: var(--text-secondary);
}
</style>
