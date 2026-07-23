// 公司股东和关联关系Mock数据
import type { ShareholderItem, CompanyRelationItem } from '../src/api/company'

// 股东类型枚举
export const SHAREHOLDER_TYPES = {
  STATE_OWNED: '国有控股',
  PRIVATE: '民营企业',
  FOREIGN: '外资企业',
  JOINT_VENTURE: '合资企业',
  FINANCIAL: '金融机构',
  INVESTMENT: '投资集团',
  INSURANCE_GROUP: '保险集团'
}

// 关联类型枚举
export const RELATION_TYPES = {
  SAME_GROUP: 1,       // 同一集团
  SAME_MAJOR: 2,       // 同一大股东
  PARENT_CHILD: 3,     // 母子公司
  EQUITY_INVESTMENT: 4 // 参股投资
}

// 15家核心公司的详细股东数据（精确持股比例）
export const companyShareholders: Record<number, ShareholderItem[]> = {
  1: [ // 中意人寿
    { name: '意大利忠利保险集团', ratio: '50%', ratioValue: 50, type: '外资保险集团', isControlling: false, isForeign: true },
    { name: '中国石油天然气集团', ratio: '50%', ratioValue: 50, type: '央企', isControlling: true, isStateOwned: true }
  ],
  2: [ // 工银安盛人寿
    { name: '中国工商银行', ratio: '60%', ratioValue: 60, type: '国有银行', isControlling: true, isStateOwned: true },
    { name: '法国安盛集团', ratio: '27.5%', ratioValue: 27.5, type: '外资保险集团', isControlling: false, isForeign: true },
    { name: '中国五矿集团', ratio: '12.5%', ratioValue: 12.5, type: '央企', isControlling: false, isStateOwned: true }
  ],
  3: [ // 同方全球人寿
    { name: '同方股份有限公司', ratio: '50%', ratioValue: 50, type: '国有企业', isControlling: true, isStateOwned: true },
    { name: '荷兰全球保险集团', ratio: '50%', ratioValue: 50, type: '外资保险集团', isControlling: false, isForeign: true }
  ],
  4: [ // 华泰人寿
    { name: '华泰保险集团', ratio: '80%', ratioValue: 80, type: '保险集团', isControlling: true },
    { name: '美国安达集团', ratio: '20%', ratioValue: 20, type: '外资保险集团', isControlling: false, isForeign: true }
  ],
  5: [ // 复星联合健康
    { name: '复星国际', ratio: '33.3%', ratioValue: 33.3, type: '民营投资集团', isControlling: true },
    { name: '复星医药', ratio: '20%', ratioValue: 20, type: '民营医药集团', isControlling: false },
    { name: '广东宝丽华新能源', ratio: '19.5%', ratioValue: 19.5, type: '民营企业', isControlling: false },
    { name: '广州恒运企业集团', ratio: '16.7%', ratioValue: 16.7, type: '国有企业', isControlling: false, isStateOwned: true },
    { name: '东阳光实业', ratio: '10.5%', ratioValue: 10.5, type: '民营企业', isControlling: false }
  ],
  6: [ // 长城人寿
    { name: '北京华融综合投资公司', ratio: '25.8%', ratioValue: 25.8, type: '国有企业', isControlling: true, isStateOwned: true },
    { name: '北京金昊房地产开发', ratio: '19.9%', ratioValue: 19.9, type: '国有企业', isControlling: false, isStateOwned: true },
    { name: '北京金融街投资', ratio: '15.6%', ratioValue: 15.6, type: '国有企业', isControlling: false, isStateOwned: true },
    { name: '北京中民广场', ratio: '11.8%', ratioValue: 11.8, type: '民营企业', isControlling: false }
  ],
  7: [ // 光大永明人寿
    { name: '中国光大集团', ratio: '50%', ratioValue: 50, type: '央企金融集团', isControlling: true, isStateOwned: true },
    { name: '加拿大永明金融集团', ratio: '24.99%', ratioValue: 24.99, type: '外资保险集团', isControlling: false, isForeign: true },
    { name: '中兵投资管理', ratio: '12.5%', ratioValue: 12.5, type: '央企', isControlling: false, isStateOwned: true },
    { name: '鞍山钢铁集团', ratio: '12.5%', ratioValue: 12.5, type: '央企', isControlling: false, isStateOwned: true }
  ],
  8: [ // 和谐健康
    { name: '福佳集团', ratio: '51%', ratioValue: 51, type: '民营企业', isControlling: true },
    { name: '扬子国投', ratio: '25%', ratioValue: 25, type: '国有企业', isControlling: false, isStateOwned: true },
    { name: '横琴金投', ratio: '13%', ratioValue: 13, type: '国有企业', isControlling: false, isStateOwned: true },
    { name: '金科地产', ratio: '11%', ratioValue: 11, type: '民营企业', isControlling: false }
  ],
  9: [ // 中英人寿
    { name: '中粮资本', ratio: '50%', ratioValue: 50, type: '央企', isControlling: true, isStateOwned: true },
    { name: '英国英杰华集团', ratio: '50%', ratioValue: 50, type: '外资保险集团', isControlling: false, isForeign: true }
  ],
  10: [ // 中信保诚人寿
    { name: '中国中信集团', ratio: '50%', ratioValue: 50, type: '央企金融集团', isControlling: true, isStateOwned: true },
    { name: '英国保诚集团', ratio: '50%', ratioValue: 50, type: '外资保险集团', isControlling: false, isForeign: true }
  ],
  11: [ // 招商信诺人寿
    { name: '招商银行', ratio: '50%', ratioValue: 50, type: '股份制银行', isControlling: true, isStateOwned: true },
    { name: '美国信诺集团', ratio: '50%', ratioValue: 50, type: '外资保险集团', isControlling: false, isForeign: true }
  ],
  12: [ // 信泰人寿
    { name: '浙江永利实业集团', ratio: '35.8%', ratioValue: 35.8, type: '民营企业', isControlling: true },
    { name: '浙江华升物流', ratio: '21.2%', ratioValue: 21.2, type: '民营企业', isControlling: false },
    { name: '利时集团', ratio: '15.6%', ratioValue: 15.6, type: '民营企业', isControlling: false },
    { name: '连云港市宾利国际贸易', ratio: '10.8%', ratioValue: 10.8, type: '民营企业', isControlling: false }
  ],
  13: [ // 昆仑健康
    { name: '福信集团', ratio: '30%', ratioValue: 30, type: '民营企业', isControlling: true },
    { name: '上海欣成投资', ratio: '20%', ratioValue: 20, type: '民营企业', isControlling: false },
    { name: '深圳中油阳光', ratio: '15%', ratioValue: 15, type: '国有企业', isControlling: false, isStateOwned: true },
    { name: '杭州永原电子', ratio: '12%', ratioValue: 12, type: '民营企业', isControlling: false }
  ],
  14: [ // 横琴人寿
    { name: '珠海铧创投资管理', ratio: '30%', ratioValue: 30, type: '国有企业', isControlling: true, isStateOwned: true },
    { name: '亨通集团', ratio: '20%', ratioValue: 20, type: '民营企业', isControlling: false },
    { name: '广东明珠集团', ratio: '15%', ratioValue: 15, type: '民营企业', isControlling: false },
    { name: '浙江万盛股份', ratio: '14%', ratioValue: 14, type: '民营企业', isControlling: false },
    { name: '中植企业集团', ratio: '10.5%', ratioValue: 10.5, type: '民营企业', isControlling: false }
  ],
  15: [ // 富德生命人寿
    { name: '富德控股集团', ratio: '31%', ratioValue: 31, type: '民营投资集团', isControlling: true },
    { name: '深圳华信投资', ratio: '20%', ratioValue: 20, type: '民营企业', isControlling: false },
    { name: '深圳国民投资', ratio: '15%', ratioValue: 15, type: '民营企业', isControlling: false },
    { name: '深圳中裕汇丰投资', ratio: '11%', ratioValue: 11, type: '民营企业', isControlling: false }
  ],
  16: [ // 平安健康
    { name: '中国平安保险集团', ratio: '100%', ratioValue: 100, type: '保险集团', isControlling: true }
  ]
}

// 公司间关联关系数据（20组关联，覆盖4种类型）
export const companyRelations: Record<number, CompanyRelationItem[]> = {
  1: [ // 中意人寿
    { companyId: 5, companyName: '复星联合健康', relationType: 2, relationName: '同一参股方（复星系）' }
  ],
  2: [ // 工银安盛人寿
    { companyId: 11, companyName: '招商信诺人寿', relationType: 2, relationName: '同一银行系股东' },
    { companyId: 7, companyName: '光大永明人寿', relationType: 2, relationName: '同一央企背景' }
  ],
  3: [ // 同方全球人寿
    { companyId: 9, companyName: '中英人寿', relationType: 2, relationName: '同属中英合资' }
  ],
  4: [ // 华泰人寿
    { companyId: 16, companyName: '平安健康', relationType: 2, relationName: '同属保险集团子公司' }
  ],
  5: [ // 复星联合健康
    { companyId: 1, companyName: '中意人寿', relationType: 2, relationName: '同一参股方（复星系）' },
    { companyId: 15, companyName: '富德生命人寿', relationType: 4, relationName: '参股投资关系' }
  ],
  6: [ // 长城人寿
    { companyId: 8, companyName: '和谐健康', relationType: 2, relationName: '同有北京国资背景' }
  ],
  7: [ // 光大永明人寿
    { companyId: 2, companyName: '工银安盛人寿', relationType: 2, relationName: '同一央企背景' },
    { companyId: 9, companyName: '中英人寿', relationType: 2, relationName: '同属央企+外资合资' }
  ],
  8: [ // 和谐健康
    { companyId: 6, companyName: '长城人寿', relationType: 2, relationName: '同有北京国资背景' },
    { companyId: 15, companyName: '富德生命人寿', relationType: 4, relationName: '曾经同属安邦系' }
  ],
  9: [ // 中英人寿
    { companyId: 3, companyName: '同方全球人寿', relationType: 2, relationName: '同属中英合资' },
    { companyId: 7, companyName: '光大永明人寿', relationType: 2, relationName: '同属央企+外资合资' },
    { companyId: 10, companyName: '中信保诚人寿', relationType: 2, relationName: '同有英国保险集团股东' }
  ],
  10: [ // 中信保诚人寿
    { companyId: 9, companyName: '中英人寿', relationType: 2, relationName: '同有英国保险集团股东' },
    { companyId: 11, companyName: '招商信诺人寿', relationType: 2, relationName: '同有银行系背景' }
  ],
  11: [ // 招商信诺人寿
    { companyId: 2, companyName: '工银安盛人寿', relationType: 2, relationName: '同一银行系股东' },
    { companyId: 10, companyName: '中信保诚人寿', relationType: 2, relationName: '同有银行系背景' }
  ],
  12: [ // 信泰人寿
    { companyId: 14, companyName: '横琴人寿', relationType: 4, relationName: '参股投资关系' },
    { companyId: 15, companyName: '富德生命人寿', relationType: 2, relationName: '同属民营系' }
  ],
  13: [ // 昆仑健康
    { companyId: 5, companyName: '复星联合健康', relationType: 1, relationName: '同属健康险公司' }
  ],
  14: [ // 横琴人寿
    { companyId: 12, companyName: '信泰人寿', relationType: 4, relationName: '参股投资关系' },
    { companyId: 8, companyName: '和谐健康', relationType: 2, relationName: '同有横琴国资背景' }
  ],
  15: [ // 富德生命人寿
    { companyId: 5, companyName: '复星联合健康', relationType: 4, relationName: '参股投资关系' },
    { companyId: 8, companyName: '和谐健康', relationType: 4, relationName: '曾经同属安邦系' },
    { companyId: 12, companyName: '信泰人寿', relationType: 2, relationName: '同属民营系' }
  ],
  16: [ // 平安健康
    { companyId: 4, companyName: '华泰人寿', relationType: 2, relationName: '同属保险集团子公司' },
    { companyId: 1, companyName: '中意人寿', relationType: 3, relationName: '母子公司（平安集团）' }
  ]
}

// 关联类型对应的颜色和样式配置
export const relationTypeConfig: Record<number, { color: string; name: string; lineStyle: string }> = {
  1: { color: '#06b6d4', name: '同一集团', lineStyle: 'solid' },    // 青色实线
  2: { color: '#8b5cf6', name: '同一大股东', lineStyle: 'dashed' },  // 紫色虚线
  3: { color: '#f59e0b', name: '母子公司', lineStyle: 'solid' },     // 金色实线+箭头
  4: { color: '#10b981', name: '参股投资', lineStyle: 'dotted' }     // 绿色细虚线
}
