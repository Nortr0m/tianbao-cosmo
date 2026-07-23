import { getStorage } from './storage';

// 会员等级
export type MemberLevel = 'free' | 'vip' | 'svip';

// 会员等级配置
interface MemberLevelConfig {
  name: string;
  compareLimit: number;
  cardWatermark: boolean;
  cardTemplateAccess: string[];
  advancedFilter: boolean;
  prioritySupport: boolean;
}

// 会员等级配置映射
export const MEMBER_LEVEL_CONFIG: Record<MemberLevel, MemberLevelConfig> = {
  free: {
    name: '免费会员',
    compareLimit: 2,
    cardWatermark: true,
    cardTemplateAccess: ['basic'],
    advancedFilter: false,
    prioritySupport: false,
  },
  vip: {
    name: 'VIP会员',
    compareLimit: 3,
    cardWatermark: false,
    cardTemplateAccess: ['basic', 'premium', 'holiday'],
    advancedFilter: true,
    prioritySupport: true,
  },
  svip: {
    name: 'SVIP会员',
    compareLimit: 5,
    cardWatermark: false,
    cardTemplateAccess: ['basic', 'premium', 'holiday', 'exclusive', 'custom'],
    advancedFilter: true,
    prioritySupport: true,
  },
};

/**
 * 获取当前会员等级
 * @returns 会员等级
 */
export function getMemberLevel(): MemberLevel {
  return getStorage<MemberLevel>('memberLevel') || 'free';
}

/**
 * 获取会员等级配置
 * @param level 会员等级
 * @returns 会员等级配置
 */
export function getMemberConfig(level?: MemberLevel): MemberLevelConfig {
  const memberLevel = level || getMemberLevel();
  return MEMBER_LEVEL_CONFIG[memberLevel];
}

/**
 * 检查是否有权限
 * @param level 需要的最低会员等级
 * @returns 是否有权限
 */
export function hasPermission(level: MemberLevel): boolean {
  const currentLevel = getMemberLevel();
  const levels: MemberLevel[] = ['free', 'vip', 'svip'];
  const currentIndex = levels.indexOf(currentLevel);
  const requiredIndex = levels.indexOf(level);
  return currentIndex >= requiredIndex;
}

/**
 * 检查对比数量限制
 * @param count 当前对比数量
 * @returns 是否超过限制
 */
export function checkCompareLimit(count: number): boolean {
  const config = getMemberConfig();
  return count <= config.compareLimit;
}

/**
 * 获取对比数量限制
 * @returns 对比数量限制
 */
export function getCompareLimit(): number {
  const config = getMemberConfig();
  return config.compareLimit;
}

/**
 * 检查是否有水印权限
 * @returns 是否可以使用无水印
 */
export function hasWatermarkPermission(): boolean {
  const config = getMemberConfig();
  return !config.cardWatermark;
}

/**
 * 检查是否有高级筛选权限
 * @returns 是否可以使用高级筛选
 */
export function hasAdvancedFilterPermission(): boolean {
  const config = getMemberConfig();
  return config.advancedFilter;
}

/**
 * 检查是否有模板访问权限
 * @param templateType 模板类型
 * @returns 是否有权限
 */
export function hasTemplatePermission(templateType: string): boolean {
  const config = getMemberConfig();
  return config.cardTemplateAccess.includes(templateType);
}

/**
 * 显示权限不足提示
 * @param feature 功能名称
 */
export function showPermissionTip(feature: string): void {
  wx.showModal({
    title: '权限不足',
    content: `${feature}需要开通VIP会员才能使用，是否立即开通？`,
    confirmText: '去开通',
    cancelText: '取消',
    success: (res) => {
      if (res.confirm) {
        wx.navigateTo({
          url: '/pages/user/user',
        });
      }
    },
  });
}

/**
 * 获取会员等级名称
 * @param level 会员等级
 * @returns 会员等级名称
 */
export function getMemberLevelName(level?: MemberLevel): string {
  const config = getMemberConfig(level);
  return config.name;
}

/**
 * 获取会员等级颜色
 * @param level 会员等级
 * @returns 颜色值
 */
export function getMemberLevelColor(level?: MemberLevel): string {
  const memberLevel = level || getMemberLevel();
  switch (memberLevel) {
    case 'svip':
      return '#D4AF37';
    case 'vip':
      return '#2B6CB0';
    default:
      return '#718096';
  }
}
