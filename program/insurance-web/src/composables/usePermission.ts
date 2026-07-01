import { computed } from 'vue'
import { useUserStore } from '@/stores/userStore'

export type MemberLevel = 'free' | 'vip' | 'svip'

export function usePermission() {
  const userStore = useUserStore()

  const isVip = computed(() => userStore.isVip)
  const vipLevel = computed(() => userStore.vipLevel)
  const isLoggedIn = computed(() => userStore.isLoggedIn)

  /**
   * 会员等级
   * - free: 免费用户 (vipLevel = 0)
   * - vip: VIP会员 (vipLevel = 1)
   * - svip: SVIP会员 (vipLevel >= 2)
   */
  const memberLevel = computed<MemberLevel>(() => {
    if (!isVip.value) return 'free'
    if (vipLevel.value >= 2) return 'svip'
    return 'vip'
  })

  /**
   * 判断可对比产品数量
   * @param count 要对比的产品数量
   * @returns 是否允许对比
   */
  function canCompare(count: number): boolean {
    if (!isLoggedIn.value) return false
    if (memberLevel.value === 'svip') return count <= 8
    if (memberLevel.value === 'vip') return count <= 5
    return count <= 3
  }

  /**
   * 判断是否可使用水印功能
   * VIP及以上可用
   */
  const canUseWatermark = computed(() => isVip.value)

  /**
   * 判断是否可自定义水印参数
   * SVIP专属
   */
  const canCustomizeWatermark = computed(() => memberLevel.value === 'svip')

  /**
   * 判断是否可使用全部背景图
   * VIP及以上可用
   */
  const canUseAllBackgrounds = computed(() => isVip.value)

  /**
   * 判断是否可调节分红实现率
   * VIP及以上可用
   */
  const canAdjustDividendRate = computed(() => isVip.value)

  /**
   * 判断是否可自定义利益演示列
   * VIP及以上可用
   */
  const canCustomizeColumns = computed(() => isVip.value)

  /**
   * 判断是否可批量生成卡片
   * SVIP专属
   */
  const canBatchGenerate = computed(() => memberLevel.value === 'svip')

  /**
   * 判断是否可使用个人二维码
   * VIP及以上可用
   */
  const canUseQrcode = computed(() => isVip.value)

  /**
   * 获取最大可对比数量
   */
  const maxCompareCount = computed(() => {
    if (memberLevel.value === 'svip') return 8
    if (memberLevel.value === 'vip') return 5
    return 3
  })

  /**
   * 检查是否有指定VIP等级
   */
  function hasVipLevel(level: number): boolean {
    return isVip.value && vipLevel.value >= level
  }

  /**
   * 检查功能是否可用，不可用则返回需要的VIP等级
   */
  function checkFeature(
    feature:
      | 'watermark'
      | 'customWatermark'
      | 'allBackgrounds'
      | 'dividendRate'
      | 'customColumns'
      | 'batchGenerate'
      | 'qrcode'
  ): { available: boolean; requiredLevel: MemberLevel } {
    switch (feature) {
      case 'watermark':
        return { available: canUseWatermark.value, requiredLevel: 'vip' }
      case 'customWatermark':
        return { available: canCustomizeWatermark.value, requiredLevel: 'svip' }
      case 'allBackgrounds':
        return { available: canUseAllBackgrounds.value, requiredLevel: 'vip' }
      case 'dividendRate':
        return { available: canAdjustDividendRate.value, requiredLevel: 'vip' }
      case 'customColumns':
        return { available: canCustomizeColumns.value, requiredLevel: 'vip' }
      case 'batchGenerate':
        return { available: canBatchGenerate.value, requiredLevel: 'svip' }
      case 'qrcode':
        return { available: canUseQrcode.value, requiredLevel: 'vip' }
      default:
        return { available: false, requiredLevel: 'vip' }
    }
  }

  return {
    isVip,
    vipLevel,
    isLoggedIn,
    memberLevel,
    maxCompareCount,
    canCompare,
    canUseWatermark,
    canCustomizeWatermark,
    canUseAllBackgrounds,
    canAdjustDividendRate,
    canCustomizeColumns,
    canBatchGenerate,
    canUseQrcode,
    hasVipLevel,
    checkFeature
  }
}
