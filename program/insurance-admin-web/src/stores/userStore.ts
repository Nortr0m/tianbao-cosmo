import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { login as loginApi, logout as logoutApi, getAdminInfo, refreshAccessToken } from '@/api/auth'
import type { LoginParams, LoginResult, AdminInfo } from '@/api/auth'

export const useUserStore = defineStore('user', () => {
  const token = ref<string>(localStorage.getItem('admin_token') || '')
  const refreshTokenValue = ref<string>(localStorage.getItem('admin_refresh_token') || '')
  const adminInfo = ref<AdminInfo | null>(null)

  const isLoggedIn = computed(() => !!token.value)
  const username = computed(() => adminInfo.value?.realName || adminInfo.value?.username || '')
  const avatar = computed(() => adminInfo.value?.avatarUrl || '')
  const permissions = computed(() => [])

  function setToken(access: string, refresh: string) {
    token.value = access
    refreshTokenValue.value = refresh
    localStorage.setItem('admin_token', access)
    localStorage.setItem('admin_refresh_token', refresh)
  }

  function clearToken() {
    token.value = ''
    refreshTokenValue.value = ''
    adminInfo.value = null
    localStorage.removeItem('admin_token')
    localStorage.removeItem('admin_refresh_token')
  }

  async function login(params: LoginParams) {
    const res = await loginApi(params)
    setToken(res.accessToken, res.refreshToken || '')
    adminInfo.value = res.adminInfo
    return res
  }

  async function logout() {
    try {
      await logoutApi()
    } finally {
      clearToken()
    }
  }

  async function fetchAdminInfo() {
    const res = await getAdminInfo()
    adminInfo.value = res
    return res
  }

  async function refreshToken(): Promise<string> {
    const rt = refreshTokenValue.value
    if (!rt) {
      throw new Error('No refresh token')
    }
    const res = await refreshAccessToken(rt)
    token.value = res.token
    localStorage.setItem('admin_token', res.token)
    return res.token
  }

  function hasPermission(permission: string): boolean {
    return permissions.value.includes(permission) || permissions.value.includes('*')
  }

  return {
    token,
    refreshTokenValue,
    adminInfo,
    isLoggedIn,
    username,
    avatar,
    permissions,
    login,
    logout,
    fetchAdminInfo,
    refreshToken,
    hasPermission,
    clearToken
  }
})
