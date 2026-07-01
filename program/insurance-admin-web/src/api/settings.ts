import { get, post } from './request'

export interface BasicSettings {
  siteName: string
  siteTitle: string
  servicePhone: string
  serviceEmail: string
  companyAddress: string
  icp: string
  logo: string
  siteDescription: string
  copyright: string
}

export interface FeatureSettings {
  enableRegister: number
  enableVip: number
  enableRedeemCode: number
  dailyFreeQuota: number
  maxCardsPerGenerate: number
  serviceWorkTime: string
  logRetainDays: number
}

export interface SecuritySettings {
  loginMaxFailures: number
  loginLockDuration: number
  passwordMinLength: number
  passwordRequireComplex: number
  tokenExpireHours: number
  enableCaptcha: number
}

export interface AllSettings {
  basic: BasicSettings
  feature: FeatureSettings
  security: SecuritySettings
}

export function getSettings(): Promise<AllSettings> {
  return get<AllSettings>('/v1/admin/settings')
}

export function saveBasicSettings(data: BasicSettings): Promise<void> {
  return post<void>('/v1/admin/settings/basic', data)
}

export function saveFeatureSettings(data: FeatureSettings): Promise<void> {
  return post<void>('/v1/admin/settings/feature', data)
}

export function saveSecuritySettings(data: SecuritySettings): Promise<void> {
  return post<void>('/v1/admin/settings/security', data)
}
