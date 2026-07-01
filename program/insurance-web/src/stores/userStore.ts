import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { UserInfo, LoginResult } from '@/api/auth'
import { getUserInfo, logout as apiLogout } from '@/api/auth'
import { tokenStorage } from '@/utils/storage'

export const useUserStore = defineStore('user', () => {
  // State
  const userInfo = ref<UserInfo | null>(null)
  const token = ref<string | null>(null)
  const isLoading = ref(false)

  // Getters
  const isLoggedIn = computed(() => !!token.value && !!userInfo.value)
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
  const realName = computed(() => userInfo.value?.nickname || '')
  const isWechatBound = computed(() => !!userInfo.value?.wechatBound)

  // Actions
  function setAuth(data: LoginResult) {
    token.value = data.accessToken
    userInfo.value = data.userInfo
    tokenStorage.setAccessToken(data.accessToken)
    tokenStorage.setRefreshToken(data.refreshToken)
  }

  function clearAuth() {
    token.value = null
    userInfo.value = null
    tokenStorage.clear()
  }

  async function initializeAuth() {
    const storedToken = tokenStorage.getAccessToken()
    if (!storedToken) return

    token.value = storedToken
    isLoading.value = true
    try {
      const info = await getUserInfo()
      userInfo.value = info
    } catch {
      clearAuth()
    } finally {
      isLoading.value = false
    }
  }

  async function fetchUserInfo() {
    if (!token.value) return
    isLoading.value = true
    try {
      const info = await getUserInfo()
      userInfo.value = info
    } finally {
      isLoading.value = false
    }
  }

  async function logout() {
    try {
      await apiLogout()
    } finally {
      clearAuth()
    }
  }

  function updateVipStatus(status: { memberLevel: number; memberExpireTime: string | null }) {
    if (userInfo.value) {
      userInfo.value.memberLevel = status.memberLevel
      userInfo.value.memberExpireTime = status.memberExpireTime
    }
  }

  return {
    userInfo,
    token,
    isLoading,
    isLoggedIn,
    isVip,
    vipLevel,
    vipExpireTime,
    avatar,
    username,
    nickname,
    realName,
    isWechatBound,
    setAuth,
    clearAuth,
    initializeAuth,
    fetchUserInfo,
    logout,
    updateVipStatus
  }
})
