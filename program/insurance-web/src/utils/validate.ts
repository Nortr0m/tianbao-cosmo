/**
 * 表单验证工具
 */

export const validateRules = {
  required: (message = '此项为必填项') => ({
    required: true,
    message,
    trigger: 'blur'
  }),

  phone: (message = '请输入正确的手机号码') => ({
    pattern: /^1[3-9]\d{9}$/,
    message,
    trigger: 'blur'
  }),

  email: (message = '请输入正确的邮箱地址') => ({
    type: 'email' as const,
    message,
    trigger: 'blur'
  }),

  idCard: (message = '请输入正确的身份证号码') => ({
    pattern: /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/,
    message,
    trigger: 'blur'
  }),

  minLength: (min: number, message?: string) => ({
    min,
    message: message || `长度至少为 ${min} 个字符`,
    trigger: 'blur'
  }),

  maxLength: (max: number, message?: string) => ({
    max,
    message: message || `长度最多为 ${max} 个字符`,
    trigger: 'blur'
  }),

  rangeLength: (min: number, max: number, message?: string) => ({
    min,
    max,
    message: message || `长度应在 ${min} 到 ${max} 个字符之间`,
    trigger: 'blur'
  }),

  number: (message = '请输入数字') => ({
    pattern: /^-?\d+(\.\d+)?$/,
    message,
    trigger: 'blur'
  }),

  positiveInt: (message = '请输入正整数') => ({
    pattern: /^[1-9]\d*$/,
    message,
    trigger: 'blur'
  }),

  age: (min = 0, max = 120, message = '请输入有效的年龄') => ({
    validator: (_rule: unknown, value: number, callback: (error?: Error) => void) => {
      if (value === undefined || value === null) {
        callback()
        return
      }
      if (value < min || value > max || !Number.isInteger(value)) {
        callback(new Error(message))
      } else {
        callback()
      }
    },
    trigger: 'blur'
  })
}

export function isValidPhone(phone: string): boolean {
  return /^1[3-9]\d{9}$/.test(phone)
}

export function isValidEmail(email: string): boolean {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
}

export function isValidIdCard(idCard: string): boolean {
  return /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/.test(idCard)
}
