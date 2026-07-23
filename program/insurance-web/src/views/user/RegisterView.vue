<template>
  <div class="register-view">
    <h2 class="auth-title">注册账号</h2>
    <p class="auth-subtitle">创建账号，开启保险对比之旅</p>

    <!-- 注册方式切换 -->
    <div class="register-switch">
      <div
        class="switch-item"
        :class="{ active: registerMode === 'form' }"
        @click="switchRegisterMode('form')"
      >
        <el-icon><EditPen /></el-icon>
        <span>账号注册</span>
      </div>
      <div
        class="switch-item"
        :class="{ active: registerMode === 'wechat' }"
        @click="switchRegisterMode('wechat')"
      >
        <el-icon><ChatDotRound /></el-icon>
        <span>微信扫码注册</span>
      </div>
    </div>

    <!-- 账号密码注册 -->
    <el-form
      v-if="registerMode === 'form'"
      ref="formRef"
      :model="form"
      :rules="rules"
      class="auth-form"
      @keyup.enter="handleSubmit"
    >
      <el-form-item prop="username">
        <el-input
          v-model="form.username"
          placeholder="用户名"
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

      <el-form-item prop="confirmPassword">
        <el-input
          v-model="form.confirmPassword"
          type="password"
          placeholder="确认密码"
          size="large"
          show-password
          :prefix-icon="Lock"
        />
      </el-form-item>

      <div class="wechat-bind-section">
        <p class="wechat-bind-tip">注册成功后可在个人中心绑定微信，实现快捷登录</p>
      </div>

      <el-form-item>
        <el-button
          type="primary"
          size="large"
          class="submit-btn"
          :loading="loading"
          @click="handleSubmit"
        >
          注册
        </el-button>
      </el-form-item>
    </el-form>

    <!-- 微信扫码注册 -->
    <div v-if="registerMode === 'wechat'" class="wechat-qrcode-panel">
      <div class="qrcode-container">
        <!-- 加载中 -->
        <div v-if="qrLoading" class="qrcode-loading">
          <el-icon :size="32" class="is-loading"><Loading /></el-icon>
          <p>正在获取二维码...</p>
        </div>

        <!-- 二维码显示 -->
        <template v-else-if="qrCodeUrl">
          <img :src="qrCodeUrl" alt="微信扫码注册" class="qrcode-img" />
          <div class="qrcode-status">
            <div v-if="qrStatus === 'WAITING'" class="status-waiting">
              <el-icon><ChatDotRound /></el-icon>
              <span>请使用微信扫描二维码完成注册</span>
            </div>
            <div v-else-if="qrStatus === 'SCANNED'" class="status-scanned">
              <el-icon><CircleCheck /></el-icon>
              <span>已扫码，请在手机上确认注册</span>
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

    <div class="auth-footer">
      <span>已有账号？</span>
      <el-button type="primary" link @click="router.push('/login')">
        立即登录
      </el-button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock, ChatDotRound, EditPen, Loading, CircleCheck, Warning, WarningFilled } from '@element-plus/icons-vue'
import { useAuth } from '@/composables/useAuth'
import { useUserStore } from '@/stores/userStore'
import { checkUsername, getWechatQrCode, checkWechatQrCode } from '@/api/auth'
import type { FormInstance, FormRules } from 'element-plus'

const router = useRouter()
const { register } = useAuth()
const userStore = useUserStore()

const formRef = ref<FormInstance>()
const loading = ref(false)

// 注册模式切换
const registerMode = ref<'form' | 'wechat'>('form')

// 微信扫码相关状态
const qrLoading = ref(false)
const qrCodeUrl = ref('')
const qrSessionId = ref('')
const qrStatus = ref<'WAITING' | 'SCANNED' | 'CONFIRMED' | 'EXPIRED'>('WAITING')
let pollTimer: ReturnType<typeof setInterval> | null = null

const form = ref({
  username: '',
  password: '',
  confirmPassword: ''
})

function validateStrongPassword(_rule: unknown, value: string, callback: (error?: Error) => void) {
  if (!value) {
    callback(new Error('请输入密码'))
    return
  }
  if (value.length < 8) {
    callback(new Error('密码至少8位'))
    return
  }
  let types = 0
  if (/[a-z]/.test(value)) types++
  if (/[A-Z]/.test(value)) types++
  if (/\d/.test(value)) types++
  if (/[^a-zA-Z0-9]/.test(value)) types++
  if (types < 3) {
    callback(new Error('密码需包含大小写字母、数字、特殊字符中的至少3种'))
    return
  }
  callback()
}

function validateConfirmPassword(_rule: unknown, value: string, callback: (error?: Error) => void) {
  if (!value) {
    callback(new Error('请确认密码'))
    return
  }
  if (value !== form.value.password) {
    callback(new Error('两次输入的密码不一致'))
    return
  }
  callback()
}

async function validateUsername(_rule: unknown, value: string, callback: (error?: Error) => void) {
  if (!value) {
    callback(new Error('请输入用户名'))
    return
  }
  if (value.length < 3 || value.length > 20) {
    callback(new Error('用户名长度在 3 到 20 个字符'))
    return
  }
  try {
    const result = await checkUsername(value)
    if (result.exists) {
      callback(new Error('该用户名已被注册'))
      return
    }
  } catch {
    // 检查失败时不阻断，允许用户继续尝试
  }
  callback()
}

const rules: FormRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '长度在 3 到 20 个字符', trigger: 'blur' },
    { validator: validateUsername, trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { validator: validateStrongPassword, trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ]
}

async function handleSubmit() {
  if (!formRef.value) return
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    loading.value = true
    try {
      await register({
        username: form.value.username,
        password: form.value.password
      })
    } finally {
      loading.value = false
    }
  })
}

function switchRegisterMode(mode: 'form' | 'wechat') {
  if (mode === registerMode.value) return
  registerMode.value = mode
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
        // 微信扫码注册成功，使用返回的 token 信息设置登录状态
        if (result.accessToken && result.userInfo) {
          userStore.setAuth({
            accessToken: result.accessToken,
            refreshToken: result.refreshToken || '',
            expiresIn: result.expiresIn || 0,
            tokenType: result.tokenType || 'Bearer',
            userInfo: result.userInfo
          })
          ElMessage.success('微信注册成功')
          router.push('/')
        } else {
          ElMessage.error('注册数据异常，请重试')
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

/* 注册方式切换 */
.register-switch {
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
  margin-bottom: 24px;
}

/* 微信绑定提示区域 */
.wechat-bind-section {
  margin-bottom: 20px;
}

.wechat-bind-tip {
  text-align: center;
  font-size: 12px;
  color: var(--text-secondary);
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
  margin-bottom: 24px;
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

.auth-footer {
  text-align: center;
  color: var(--text-secondary);
}
</style>
