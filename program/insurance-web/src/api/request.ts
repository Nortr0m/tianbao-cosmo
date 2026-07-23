import axios, {
  type AxiosInstance,
  type AxiosRequestConfig,
  type AxiosResponse,
  type InternalAxiosRequestConfig,
  AxiosError
} from 'axios'
import { ElMessage, ElMessageBox } from 'element-plus'
import { tokenStorage } from '@/utils/storage'
import router from '@/router'

export interface ApiResponse<T = unknown> {
  code: number
  message: string
  data: T
  timestamp: number
}

let isRefreshing = false
let refreshSubscribers: Array<(token: string) => void> = []

function onTokenRefreshed(token: string) {
  refreshSubscribers.forEach((cb) => cb(token))
  refreshSubscribers = []
}

function addRefreshSubscriber(cb: (token: string) => void) {
  refreshSubscribers.push(cb)
}

function handleUnauthorized() {
  tokenStorage.clear()
  ElMessageBox.alert('登录已过期，请重新登录', '提示', {
    confirmButtonText: '确定',
    type: 'warning',
    callback: () => {
      router.push('/login')
    }
  })
}

const apiBase = import.meta.env.VITE_API_BASE_URL || ''
const request: AxiosInstance = axios.create({
  baseURL: apiBase.endsWith('/api') ? apiBase : `${apiBase}/api`,
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json;charset=utf-8'
  }
})

// 请求拦截器
request.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    const token = tokenStorage.getAccessToken()
    if (token && config.headers) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error: AxiosError) => {
    return Promise.reject(error)
  }
)

// 响应拦截器
request.interceptors.response.use(
  (response: AxiosResponse<ApiResponse>) => {
    const res = response.data
    if (res.code !== 200) {
      ElMessage.error(res.message || '请求失败')
      return Promise.reject(new Error(res.message || '请求失败'))
    }
    return res.data as unknown as AxiosResponse
  },
  async (error: AxiosError<ApiResponse>) => {
    const { response, config } = error
    if (!response) {
      ElMessage.error('网络错误，请检查网络连接')
      return Promise.reject(error)
    }

    const status = response.status
    const originalRequest = config as InternalAxiosRequestConfig & { _retry?: boolean }

    if (status === 401) {
      if (originalRequest.url?.includes('/auth/refresh')) {
        handleUnauthorized()
        return Promise.reject(error)
      }

      if (!isRefreshing) {
        isRefreshing = true
        try {
          const refreshToken = tokenStorage.getRefreshToken()
          if (!refreshToken) {
            handleUnauthorized()
            return Promise.reject(error)
          }
          const refreshRes = await axios.post<ApiResponse<{ accessToken: string; refreshToken: string }>>(
            '/api/v1/auth/refresh',
            { refreshToken }
          )
          const { accessToken, refreshToken: newRefreshToken } = refreshRes.data.data
          tokenStorage.setAccessToken(accessToken)
          tokenStorage.setRefreshToken(newRefreshToken)
          onTokenRefreshed(accessToken)
          isRefreshing = false
          if (originalRequest.headers) {
            originalRequest.headers.Authorization = `Bearer ${accessToken}`
          }
          return request(originalRequest)
        } catch {
          isRefreshing = false
          handleUnauthorized()
          return Promise.reject(error)
        }
      }

      return new Promise((resolve) => {
        addRefreshSubscriber((token: string) => {
          if (originalRequest.headers) {
            originalRequest.headers.Authorization = `Bearer ${token}`
          }
          resolve(request(originalRequest))
        })
      })
    }

    if (status === 403) {
      ElMessage.error('没有权限执行此操作')
    } else if (status === 404) {
      ElMessage.error('请求的资源不存在')
    } else if (status >= 500) {
      ElMessage.error('服务器错误，请稍后重试')
    } else {
      ElMessage.error(response.data?.message || '请求失败')
    }

    return Promise.reject(error)
  }
)

export function get<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
  return request.get(url, config) as Promise<T>
}

export function post<T>(url: string, data?: unknown, config?: AxiosRequestConfig): Promise<T> {
  return request.post(url, data, config) as Promise<T>
}

export function put<T>(url: string, data?: unknown, config?: AxiosRequestConfig): Promise<T> {
  return request.put(url, data, config) as Promise<T>
}

export function del<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
  return request.delete(url, config) as Promise<T>
}

export default request
