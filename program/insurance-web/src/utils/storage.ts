/**
 * Storage封装
 * 统一localStorage/sessionStorage操作，支持JSON序列化/反序列化
 */

export type StorageType = 'local' | 'session'

class StorageWrapper {
  private storage: Storage

  constructor(type: StorageType = 'local') {
    this.storage = type === 'local' ? localStorage : sessionStorage
  }

  get<T>(key: string): T | null {
    try {
      const item = this.storage.getItem(key)
      if (item === null) return null
      return JSON.parse(item) as T
    } catch {
      return null
    }
  }

  set<T>(key: string, value: T): void {
    try {
      this.storage.setItem(key, JSON.stringify(value))
    } catch (e) {
      console.error(`Storage set error for key "${key}":`, e)
    }
  }

  remove(key: string): void {
    this.storage.removeItem(key)
  }

  clear(): void {
    this.storage.clear()
  }

  has(key: string): boolean {
    return this.storage.getItem(key) !== null
  }
}

export const local = new StorageWrapper('local')
export const session = new StorageWrapper('session')

// Token专用封装
const TOKEN_KEY = 'access_token'
const REFRESH_TOKEN_KEY = 'refresh_token'

export const tokenStorage = {
  getAccessToken(): string | null {
    return local.get<string>(TOKEN_KEY)
  },
  setAccessToken(token: string): void {
    local.set(TOKEN_KEY, token)
  },
  getRefreshToken(): string | null {
    return local.get<string>(REFRESH_TOKEN_KEY)
  },
  setRefreshToken(token: string): void {
    local.set(REFRESH_TOKEN_KEY, token)
  },
  clear(): void {
    local.remove(TOKEN_KEY)
    local.remove(REFRESH_TOKEN_KEY)
  }
}
