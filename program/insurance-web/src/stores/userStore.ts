import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { UserInfo, LoginResult } from '@/api/auth'
import { getUserInfo, logout as apiLogout, unbindWechat } from '@/api/auth'
import { tokenStorage } from '@/utils/storage'

export const useUserStore = defineStore('user', () => {
  // ============= State =============
  const userInfo = ref<UserInfo | null>(null)
  const token = ref<string | null>(null)
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  // ============= Getters =============

  /** 是否已登录 */
  const isLoggedIn = computed(() => !!token.value && !!userInfo.value)

  /** 是否为VIP会员 */
  const isVip = computed(() => {
    if (!userInfo.value) return false
    if (userInfo.value.memberLevel <= 0) return false
    if (!userInfo.value.memberExpireTime) return false
    return new Date(userInfo.value.memberExpireTime) > new Date()
  })

  const vipLevel = computed(() => userInfo.value?.memberLevel ?? 0)
  const vipExpireTime = computed(() => userInfo.value?.memberExpireTime ?? null)
  const avatar = computed(() => userInfo.value?.avatarUrl || '')
  const username = computed(() => userInfo.value?.username || '')
  const nickname = computed(() => userInfo.value?.nickname || '')
  /** 真实姓名（后端暂不返回，fallback到昵称） */
  const realName = computed(() => userInfo.value?.nickname || '')
  const isWechatBound = computed(() => !!userInfo.value?.wechatBound)
  const userId = computed(() => userInfo.value?.userId ?? null)

  // ============= Actions =============

  /** 设置登录信息 */
  function setAuth(data: LoginResult) {
    token.value = data.accessToken
    userInfo.value = data.userInfo
    tokenStorage.setAccessToken(data.accessToken)
    tokenStorage.setRefreshToken(data.refreshToken)
    error.value = null
  }

  /** 清除登录信息 */
  function clearAuth() {
    token.value = null
    userInfo.value = null
    error.value = null
    tokenStorage.clear()
  }

  /**
   * 初始化认证（页面刷新时调用）
   * 从 localStorage 读取 token 并获取用户信息
   */
  async function initializeAuth() {
    const storedToken = tokenStorage.getAccessToken()
    if (!storedToken) return

    token.value = storedToken
    isLoading.value = true
    error.value = null
    try {
      const info = await getUserInfo()
      userInfo.value = info
    } catch (err) {
      error.value = err instanceof Error ? err.message : '登录状态已过期'
      clearAuth()
    } finally {
      isLoading.value = false
    }
  }

  /** 获取用户信息 */
  async function fetchUserInfo() {
    if (!token.value) return
    isLoading.value = true
    error.value = null
    try {
      const info = await getUserInfo()
      userInfo.value = info
      return info
    } catch (err) {
      error.value = err instanceof Error ? err.message : '获取用户信息失败'
      throw err
    } finally {
      isLoading.value = false
    }
  }

  /** 登出 */
  async function logout() {
    try {
      await apiLogout()
    } catch (err) {
      // 即使登出API失败，也清除本地状态
      console.warn('[UserStore] Logout API failed:', err)
    } finally {
      clearAuth()
    }
  }

  /** 更新用户资料 */
  function updateProfile(data: Partial<UserInfo>) {
    if (userInfo.value) {
      userInfo.value = { ...userInfo.value, ...data }
    }
  }

  /** 解绑微信 */
  async function unbindWechatAccount() {
    try {
      await unbindWechat()
      if (userInfo.value) {
        userInfo.value.wechatBound = 0
        userInfo.value.wechatOpenid = null
        userInfo.value.wechatUnionid = null
        userInfo.value.wechatNickname = null
        userInfo.value.wechatAvatar = null
      }
      return true
    } catch (err) {
      error.value = err instanceof Error ? err.message : '解绑失败'
      return false
    }
  }

  /** 更新VIP状态 */
  function updateVipStatus(status: { memberLevel: number; memberExpireTime: string | null }) {
    if (userInfo.value) {
      userInfo.value.memberLevel = status.memberLevel
      userInfo.value.memberExpireTime = status.memberExpireTime
    }
  }

  /** 清空错误 */
  function clearError() {
    error.value = null
  }

  return {
    // State
    userInfo,
    token,
    isLoading,
    error,
    // Getters
    isLoggedIn,
    isVip,
    vipLevel,
    vipExpireTime,
    avatar,
    username,
    nickname,
    realName,
    isWechatBound,
    userId,
    // Actions
    setAuth,
    clearAuth,
    initializeAuth,
    fetchUserInfo,
    logout,
    updateProfile,
    unbindWechatAccount,
    updateVipStatus,
    clearError
  }
})
