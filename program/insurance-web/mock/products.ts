import type { Product } from '../src/api/product'
import { companyShareholders, companyRelations } from './companyShareholders'

// ========== 重疾险（15个） productType: 1 ==========
export const mockProducts: Product[] = [
  {
    productId: 101, productName: '工银安盛御享欣生重大疾病保险（龙腾版）', productType: 1, subType: 2,
    companyId: 2, companyName: '工银安盛人寿', companyLogo: '',
    paymentPeriods: '[10,15,20,30]', paymentYears: '[10,15,20,30]',
    minAge: 0, maxAge: 55, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 102, productName: '复星联合达尔文7号重大疾病保险', productType: 1, subType: 2,
    companyId: 5, companyName: '复星联合健康', companyLogo: '',
    paymentPeriods: '[10,15,20,30]', paymentYears: '[10,15,20,30]',
    minAge: 0, maxAge: 55, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 103, productName: '和谐福家保重大疾病保险', productType: 1, subType: 2,
    companyId: 8, companyName: '和谐健康', companyLogo: '',
    paymentPeriods: '[10,15,20,30]', paymentYears: '[10,15,20,30]',
    minAge: 0, maxAge: 55, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 104, productName: '中信保诚明爱至尊重疾险', productType: 1, subType: 2,
    companyId: 10, companyName: '中信保诚人寿', companyLogo: '',
    paymentPeriods: '[10,15,20,30]', paymentYears: '[10,15,20,30]',
    minAge: 0, maxAge: 55, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 105, productName: '信泰超级玛丽9号重大疾病保险', productType: 1, subType: 2,
    companyId: 12, companyName: '信泰人寿', companyLogo: '',
    paymentPeriods: '[10,15,20,30]', paymentYears: '[10,15,20,30]',
    minAge: 0, maxAge: 55, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 106, productName: '昆仑健康保普惠多倍版重大疾病保险', productType: 1, subType: 2,
    companyId: 13, companyName: '昆仑健康', companyLogo: '',
    paymentPeriods: '[10,15,20,30]', paymentYears: '[10,15,20,30]',
    minAge: 0, maxAge: 55, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 107, productName: '横琴人寿无忧人生2024重大疾病保险', productType: 1, subType: 2,
    companyId: 14, companyName: '横琴人寿', companyLogo: '',
    paymentPeriods: '[10,15,20,30]', paymentYears: '[10,15,20,30]',
    minAge: 0, maxAge: 55, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 108, productName: '富德生命康惠保旗舰版重大疾病保险', productType: 1, subType: 2,
    companyId: 15, companyName: '富德生命人寿', companyLogo: '',
    paymentPeriods: '[10,15,20,30]', paymentYears: '[10,15,20,30]',
    minAge: 0, maxAge: 55, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 109, productName: '同方全球新康健一生（多倍保）重大疾病保险', productType: 1, subType: 2,
    companyId: 3, companyName: '同方全球人寿', companyLogo: '',
    paymentPeriods: '[10,15,20,30]', paymentYears: '[10,15,20,30]',
    minAge: 0, maxAge: 55, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 110, productName: '中意一生中意重大疾病保险', productType: 1, subType: 2,
    companyId: 1, companyName: '中意人寿', companyLogo: '',
    paymentPeriods: '[10,15,20,30]', paymentYears: '[10,15,20,30]',
    minAge: 0, maxAge: 55, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 111, productName: '光大永明光明健康重大疾病保险', productType: 1, subType: 2,
    companyId: 7, companyName: '光大永明人寿', companyLogo: '',
    paymentPeriods: '[10,15,20,30]', paymentYears: '[10,15,20,30]',
    minAge: 0, maxAge: 55, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 112, productName: '长城人寿吉康人生2024重大疾病保险', productType: 1, subType: 2,
    companyId: 6, companyName: '长城人寿', companyLogo: '',
    paymentPeriods: '[10,15,20,30]', paymentYears: '[10,15,20,30]',
    minAge: 0, maxAge: 55, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 113, productName: '中英人寿爱守护重大疾病保险', productType: 1, subType: 2,
    companyId: 9, companyName: '中英人寿', companyLogo: '',
    paymentPeriods: '[10,15,20,30]', paymentYears: '[10,15,20,30]',
    minAge: 0, maxAge: 55, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 114, productName: '招商信诺安享康健重大疾病保险', productType: 1, subType: 2,
    companyId: 11, companyName: '招商信诺人寿', companyLogo: '',
    paymentPeriods: '[10,15,20,30]', paymentYears: '[10,15,20,30]',
    minAge: 0, maxAge: 55, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 115, productName: '华泰人寿新福佑双鑫重大疾病保险', productType: 1, subType: 2,
    companyId: 4, companyName: '华泰人寿', companyLogo: '',
    paymentPeriods: '[10,15,20,30]', paymentYears: '[10,15,20,30]',
    minAge: 0, maxAge: 55, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  // ========== 增额终身寿险（15个） productType: 2 ==========
  {
    productId: 201, productName: '中意一生保终身寿险（A款）', productType: 2, subType: 2,
    companyId: 1, companyName: '中意人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 70, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 202, productName: '工银安盛鑫如意终身寿险', productType: 2, subType: 2,
    companyId: 2, companyName: '工银安盛人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 70, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 203, productName: '同方全球「新传世」终身寿险', productType: 2, subType: 2,
    companyId: 3, companyName: '同方全球人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 70, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 204, productName: '华泰人寿鑫享终身寿险', productType: 2, subType: 2,
    companyId: 4, companyName: '华泰人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 70, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 205, productName: '复星联合鑫满意终身寿险', productType: 2, subType: 2,
    companyId: 5, companyName: '复星联合健康', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 70, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 206, productName: '长城山海关永乐版终身寿险', productType: 2, subType: 2,
    companyId: 6, companyName: '长城人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 70, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 207, productName: '光大永明光明至尊终身寿险', productType: 2, subType: 2,
    companyId: 7, companyName: '光大永明人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 70, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 208, productName: '和谐健康倍护金生终身护理保险', productType: 2, subType: 2,
    companyId: 8, companyName: '和谐健康', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 70, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 209, productName: '中英人寿鑫享未来终身寿险', productType: 2, subType: 2,
    companyId: 9, companyName: '中英人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 70, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 210, productName: '中信保诚「基石」终身寿险', productType: 2, subType: 2,
    companyId: 10, companyName: '中信保诚人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 70, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 211, productName: '招商信诺和乐一生终身寿险', productType: 2, subType: 2,
    companyId: 11, companyName: '招商信诺人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 70, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 212, productName: '信泰如意尊终身寿险', productType: 2, subType: 2,
    companyId: 12, companyName: '信泰人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 70, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 213, productName: '昆仑健康增多多增额终身护理保险', productType: 2, subType: 2,
    companyId: 13, companyName: '昆仑健康', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 70, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 214, productName: '横琴人寿金满意足臻享版终身寿险', productType: 2, subType: 2,
    companyId: 14, companyName: '横琴人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 70, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 215, productName: '富德生命康乾2号终身寿险', productType: 2, subType: 2,
    companyId: 15, companyName: '富德生命人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 70, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  // ========== 年金险（16个） productType: 3 ==========
  {
    productId: 301, productName: '中意一生中意年金保险', productType: 3, subType: 1,
    companyId: 1, companyName: '中意人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 302, productName: '华泰泰享金生养老年金保险', productType: 3, subType: 1,
    companyId: 4, companyName: '华泰人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 303, productName: '光大永明光明一生年金保险', productType: 3, subType: 2,
    companyId: 7, companyName: '光大永明人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 304, productName: '光大永明光明慧选养老年金保险', productType: 3, subType: 2,
    companyId: 7, companyName: '光大永明人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 60, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 305, productName: '信泰如意鑫享养老年金保险', productType: 3, subType: 2,
    companyId: 12, companyName: '信泰人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 306, productName: '长城八达岭明爱金彩养老年金保险', productType: 3, subType: 2,
    companyId: 6, companyName: '长城人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 307, productName: '复星联合幸福年金保险', productType: 3, subType: 2,
    companyId: 5, companyName: '复星联合健康', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 308, productName: '工银安盛鑫丰盈年金保险', productType: 3, subType: 1,
    companyId: 2, companyName: '工银安盛人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 309, productName: '同方全球「新传世」年金保险', productType: 3, subType: 2,
    companyId: 3, companyName: '同方全球人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 310, productName: '中英人寿鑫玺传世年金保险', productType: 3, subType: 2,
    companyId: 9, companyName: '中英人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 311, productName: '招商信诺自在人生养老年金保险', productType: 3, subType: 2,
    companyId: 11, companyName: '招商信诺人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 312, productName: '和谐健康福满一生养老年金保险', productType: 3, subType: 2,
    companyId: 8, companyName: '和谐健康', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 313, productName: '昆仑健康乐享年年养老年金保险', productType: 3, subType: 2,
    companyId: 13, companyName: '昆仑健康', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 314, productName: '横琴人寿金满意足多多版养老年金保险', productType: 3, subType: 2,
    companyId: 14, companyName: '横琴人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 315, productName: '富德生命鑫禧年年养老年金保险', productType: 3, subType: 2,
    companyId: 15, companyName: '富德生命人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 316, productName: '中信保诚「基石」年金保险', productType: 3, subType: 2,
    companyId: 10, companyName: '中信保诚人寿', companyLogo: '',
    paymentPeriods: '[1,3,5,10,15,20]', paymentYears: '[1,3,5,10,15,20]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  // ========== 健康险（6个） productType: 4 ==========
  {
    productId: 401, productName: '复星联合超越保2024百万医疗保险', productType: 4, subType: 2,
    companyId: 5, companyName: '复星联合健康', companyLogo: '',
    paymentPeriods: '[1]', paymentYears: '[1]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 402, productName: '和谐健康福享e生百万医疗保险', productType: 4, subType: 2,
    companyId: 8, companyName: '和谐健康', companyLogo: '',
    paymentPeriods: '[1]', paymentYears: '[1]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 403, productName: '昆仑健康阿波罗2号多次赔付重疾险', productType: 4, subType: 2,
    companyId: 13, companyName: '昆仑健康', companyLogo: '',
    paymentPeriods: '[10,15,20,30]', paymentYears: '[10,15,20,30]',
    minAge: 0, maxAge: 55, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 404, productName: '中意人寿优享一生医疗保险', productType: 4, subType: 2,
    companyId: 1, companyName: '中意人寿', companyLogo: '',
    paymentPeriods: '[1]', paymentYears: '[1]',
    minAge: 0, maxAge: 60, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 405, productName: '光大永明光明一生医疗保险', productType: 4, subType: 2,
    companyId: 7, companyName: '光大永明人寿', companyLogo: '',
    paymentPeriods: '[1]', paymentYears: '[1]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  },
  {
    productId: 406, productName: '平安e生保长期医疗保险', productType: 4, subType: 2,
    companyId: 16, companyName: '平安健康', companyLogo: '',
    paymentPeriods: '[1]', paymentYears: '[1]',
    minAge: 0, maxAge: 65, maintenanceStatus: 3, createdAt: '', updatedAt: ''
  }
]

// Mock公司列表 - 补充完整信息（含股东和关联关系）
const companyBaseInfo: Record<number, any> = {
  1: { logoUrl: '', introduction: '中意人寿保险有限公司成立于2002年，由意大利忠利保险有限公司和中国石油天然气集团公司合资组建，是中国加入世界贸易组织后首家获准成立的中外合资保险公司。', officialWebsite: 'www.generalichina.com', servicePhone: '400-888-9888', establishedYear: 2002, registeredCapital: 37, headquarters: '北京', companyType: 3, companyTypeDesc: '合资', creditRating: 'AAA', cooperationStatus: 1, isHot: 1, riskRating: 'A', solvencyRatio: 185.5 },
  2: { logoUrl: '', introduction: '工银安盛人寿保险有限公司由中国工商银行、法国安盛集团和中国五矿集团公司共同发起组建，是国内首家银行系合资寿险公司。', officialWebsite: 'www.icbc-axa.com.cn', servicePhone: '400-600-8899', establishedYear: 1999, registeredCapital: 125.05, headquarters: '上海', companyType: 3, companyTypeDesc: '合资', creditRating: 'AAA', cooperationStatus: 1, isHot: 1, riskRating: 'A', solvencyRatio: 172.3 },
  3: { logoUrl: '', introduction: '同方全球人寿保险有限公司由同方股份有限公司与荷兰全球保险集团各出资50%组建，是一家中外合资人寿保险公司。', officialWebsite: 'www.aegonthtf.com', servicePhone: '956095', establishedYear: 2003, registeredCapital: 26.3, headquarters: '上海', companyType: 3, companyTypeDesc: '合资', creditRating: 'AA+', cooperationStatus: 1, isHot: 0, riskRating: 'A', solvencyRatio: 168.7 },
  4: { logoUrl: '', introduction: '华泰人寿保险股份有限公司是华泰保险集团旗下的专业寿险公司，成立于2005年，总部设在北京。', officialWebsite: 'www.ehuatai.com', servicePhone: '95509', establishedYear: 2005, registeredCapital: 43.12, headquarters: '北京', companyType: 4, companyTypeDesc: '外资', creditRating: 'AA+', cooperationStatus: 1, isHot: 0, riskRating: 'A', solvencyRatio: 195.2 },
  5: { logoUrl: '', introduction: '复星联合健康保险股份有限公司是由复星集团等六家企业共同发起设立的专业健康保险公司。', officialWebsite: 'www.fosun-uhi.com', servicePhone: '4006-11-7777', establishedYear: 2017, registeredCapital: 10.11, headquarters: '广州', companyType: 2, companyTypeDesc: '民营', creditRating: 'AA', cooperationStatus: 1, isHot: 1, riskRating: 'B', solvencyRatio: 132.6 },
  6: { logoUrl: '', introduction: '长城人寿保险股份有限公司是始建于2005年的全国性人寿保险公司，由北京华融综合投资公司等多家企业发起设立。', officialWebsite: 'www.greatlife.cn', servicePhone: '95576', establishedYear: 2005, registeredCapital: 68.39, headquarters: '北京', companyType: 1, companyTypeDesc: '国资', creditRating: 'AA', cooperationStatus: 1, isHot: 0, riskRating: 'A', solvencyRatio: 158.4 },
  7: { logoUrl: '', introduction: '光大永明人寿保险有限公司成立于2002年，由中国光大集团与加拿大永明金融集团合资组建。', officialWebsite: 'www.sunlife-everbright.com', servicePhone: '95348', establishedYear: 2002, registeredCapital: 54, headquarters: '天津', companyType: 3, companyTypeDesc: '合资', creditRating: 'AA+', cooperationStatus: 1, isHot: 0, riskRating: 'A', solvencyRatio: 201.3 },
  8: { logoUrl: '', introduction: '和谐健康保险股份有限公司是在原瑞福德健康保险股份有限公司基础上重组设立的专业健康保险公司。', officialWebsite: 'www.hexiehealth.com', servicePhone: '956076', establishedYear: 2006, registeredCapital: 139, headquarters: '成都', companyType: 2, companyTypeDesc: '民营', creditRating: 'AA', cooperationStatus: 1, isHot: 1, riskRating: 'B', solvencyRatio: 128.9 },
  9: { logoUrl: '', introduction: '中英人寿保险有限公司由中粮资本投资有限公司与英国英杰华集团合资组建，于2003年正式开业。', officialWebsite: 'www.aviva-cofco.com.cn', servicePhone: '95545', establishedYear: 2003, registeredCapital: 29.45, headquarters: '北京', companyType: 3, companyTypeDesc: '合资', creditRating: 'AA+', cooperationStatus: 1, isHot: 0, riskRating: 'A', solvencyRatio: 176.8 },
  10: { logoUrl: '', introduction: '中信保诚人寿保险有限公司由中国中信集团和英国保诚集团联合发起创建，是一家中外合资人寿保险公司。', officialWebsite: 'www.citic-prudential.com.cn', servicePhone: '95558', establishedYear: 2000, registeredCapital: 23.6, headquarters: '北京', companyType: 3, companyTypeDesc: '合资', creditRating: 'AAA', cooperationStatus: 1, isHot: 0, riskRating: 'A', solvencyRatio: 189.4 },
  11: { logoUrl: '', introduction: '招商信诺人寿保险有限公司是由招商银行股份有限公司与美国信诺集团合资组建的寿险公司。', officialWebsite: 'www.cignacmb.com', servicePhone: '95362', establishedYear: 2003, registeredCapital: 28, headquarters: '深圳', companyType: 3, companyTypeDesc: '合资', creditRating: 'AA+', cooperationStatus: 1, isHot: 0, riskRating: 'A', solvencyRatio: 182.1 },
  12: { logoUrl: '', introduction: '信泰人寿保险股份有限公司是经中国保险监督管理委员会批准，于2007年5月18日注册登记的全国性寿险公司。', officialWebsite: 'www.xintai.com', servicePhone: '95365', establishedYear: 2007, registeredCapital: 102.04, headquarters: '杭州', companyType: 1, companyTypeDesc: '国资', creditRating: 'AA', cooperationStatus: 1, isHot: 1, riskRating: 'B', solvencyRatio: 135.7 },
  13: { logoUrl: '', introduction: '昆仑健康保险股份有限公司是经中国保险监督管理委员会正式批准，于2006年1月12日成立的专业健康保险公司。', officialWebsite: 'www.kunlunhealth.com', servicePhone: '95506', establishedYear: 2006, registeredCapital: 23.42, headquarters: '上海', companyType: 2, companyTypeDesc: '民营', creditRating: 'A+', cooperationStatus: 1, isHot: 0, riskRating: 'B', solvencyRatio: 142.8 },
  14: { logoUrl: '', introduction: '横琴人寿保险有限公司是经中国保险监督管理委员会批准，于2016年12月成立的全国性寿险公司。', officialWebsite: 'www.hqlife.com.cn', servicePhone: '400-888-0089', establishedYear: 2016, registeredCapital: 31.37, headquarters: '珠海', companyType: 2, companyTypeDesc: '民营', creditRating: 'A+', cooperationStatus: 1, isHot: 0, riskRating: 'B', solvencyRatio: 148.5 },
  15: { logoUrl: '', introduction: '富德生命人寿保险股份有限公司是一家全国性的专业寿险公司，成立于2002年3月4日，总部现位于深圳。', officialWebsite: 'www.funde-life.com', servicePhone: '95535', establishedYear: 2002, registeredCapital: 117.52, headquarters: '深圳', companyType: 2, companyTypeDesc: '民营', creditRating: 'AA', cooperationStatus: 1, isHot: 0, riskRating: 'B', solvencyRatio: 118.6 },
  16: { logoUrl: '', introduction: '平安健康保险股份有限公司是中国平安保险（集团）股份有限公司旗下的专业健康保险公司。', officialWebsite: 'health.pingan.com', servicePhone: '95511', establishedYear: 2005, registeredCapital: 46.17, headquarters: '上海', companyType: 2, companyTypeDesc: '民营', creditRating: 'AAA', cooperationStatus: 1, isHot: 1, riskRating: 'A', solvencyRatio: 215.3 }
}

export const mockCompanies = Object.entries(companyBaseInfo).map(([id, info]) => ({
  companyId: parseInt(id),
  companyName: info.companyName || ['中意人寿', '工银安盛人寿', '同方全球人寿', '华泰人寿', '复星联合健康', '长城人寿', '光大永明人寿', '和谐健康', '中英人寿', '中信保诚人寿', '招商信诺人寿', '信泰人寿', '昆仑健康', '横琴人寿', '富德生命人寿', '平安健康'][parseInt(id) - 1],
  companyShortName: info.companyShortName || ['中意', '工银安盛', '同方全球', '华泰', '复星联合', '长城', '光大永明', '和谐健康', '中英', '中信保诚', '招商信诺', '信泰', '昆仑健康', '横琴', '富德生命', '平安健康'][parseInt(id) - 1],
  ...info,
  shareholders: companyShareholders[parseInt(id)] || [],
  relations: companyRelations[parseInt(id)] || []
}))
