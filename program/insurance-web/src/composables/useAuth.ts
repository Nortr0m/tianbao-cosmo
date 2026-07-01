import { computed } from 'vue'
import { useUserStore } from '@/stores/userStore'
import { login as apiLogin, register as apiRegister, logout as apiLogout } from '@/api/auth'
import type { LoginParams, RegisterParams } from '@/api/auth'
import { ElMessage } from 'element-plus'
import { useRouter } from 'vue-router'

export function useAuth() {
  const userStore = useUserStore()
  const router = useRouter()

  const isLoggedIn = computed(() => userStore.isLoggedIn)
  const isLoading = computed(() => userStore.isLoading)
  const userInfo = computed(() => userStore.userInfo)

  async function login(params: LoginParams, redirect?: string) {
    try {
      const result = await apiLogin(params)
      userStore.setAuth(result)
      ElMessage.success('登录成功')
      router.push(redirect || '/')
      return true
    } catch (error) {
      const msg = error instanceof Error ? error.message : '登录失败'
      ElMessage.error(msg)
      return false
    }
  }

  async function register(params: RegisterParams) {
    try {
      const result = await apiRegister(params)
      userStore.setAuth(result)
      ElMessage.success('注册成功')
      router.push('/')
      return true
    } catch (error) {
      const msg = error instanceof Error ? error.message : '注册失败'
      ElMessage.error(msg)
      return false
    }
  }

  async function logout() {
    try {
      await apiLogout()
      userStore.clearAuth()
      ElMessage.success('已退出登录')
      router.push('/login')
    } catch {
      userStore.clearAuth()
      router.push('/login')
    }
  }

  function requireAuth(): boolean {
    if (!isLoggedIn.value) {
      ElMessage.warning('请先登录')
      router.push(`/login?redirect=${encodeURIComponent(router.currentRoute.value.fullPath)}`)
      return false
    }
    return true
  }

  return {
    isLoggedIn,
    isLoading,
    userInfo,
    login,
    register,
    logout,
    requireAuth
  }
}
