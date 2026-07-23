import type { Plugin } from 'vite'
import { mockProducts, mockCompanies } from './products'
import { mockProductDetail } from './productDetail'

/**
 * Mock API 中间件插件
 * 仅在开发环境生效，用于模拟后端接口
 */
export function mockApiPlugin(): Plugin {
  return {
    name: 'api-mock',
    apply: 'serve', // 仅在开发模式（serve）下生效
    configureServer(server) {
      server.middlewares.use((req, res, next) => {
        // 只拦截 /api 开头的请求
        if (!req.url?.startsWith('/api/')) {
          return next()
        }

        const url = req.url!
        console.log(`[Mock] ${req.method} ${url}`)

        // 设置JSON响应头
        res.setHeader('Content-Type', 'application/json')

        // ========== 产品相关接口 ==========

        // 产品列表 / 热门产品 / 搜索
        if (url.includes('/v1/product/list') || url.includes('/v1/product/hot') || url.includes('/v1/product/search')) {
          const filtered = mockProducts.filter(p => {
            const params = new URLSearchParams(url.split('?')[1] || '')
            const type = params.get('productType')
            if (type && p.productType !== parseInt(type)) return false
            const keyword = params.get('keyword')
            if (keyword && !p.productName.includes(keyword)) return false
            const companyId = params.get('companyId')
            if (companyId && p.companyId !== parseInt(companyId)) return false
            return true
          })
          const page = parseInt(new URLSearchParams(url.split('?')[1] || '').get('page') || '1')
          const pageSize = parseInt(new URLSearchParams(url.split('?')[1] || '').get('pageSize') || '20')
          const start = (page - 1) * pageSize
          const list = filtered.slice(start, start + pageSize)
          return res.end(JSON.stringify({
            code: 200, message: 'success',
            data: { list, total: filtered.length, pageNum: page, pageSize, totalPages: Math.ceil(filtered.length / pageSize) }
          }))
        }

        // 产品详情
        const detailMatch = url.match(/\/v1\/product\/(\d+)(\?|$)/)
        if (detailMatch) {
          const id = parseInt(detailMatch[1])
          const detail = mockProductDetail[id] || {
            productId: id,
            productName: mockProducts.find(p => p.productId === id)?.productName || '示例产品',
            productType: mockProducts.find(p => p.productId === id)?.productType || 2,
            subType: 2, companyId: 1, companyName: '示例公司', companyLogo: '',
            paymentPeriods: '[1,3,5,10]', paymentYears: '[1,3,5,10]',
            minAge: 0, maxAge: 65, productCode: 'MOCK_001', productTypeDesc: '示例产品',
            occupationClass: 1, monthlyRatio: 0.09, quarterlyRatio: 0.26, halfYearlyRatio: 0.52,
            saleStatus: 1, systemStatus: 1,
            subProductData: null, company: { foundedYear: 2000, registeredCapital: 30, riskRating: 'A', solvencyRatio: 170 }
          }
          return res.end(JSON.stringify({ code: 200, message: 'success', data: detail }))
        }

        // 产品疾病列表（需要在产品详情之前匹配）
        const diseasesMatch = url.match(/\/v1\/product\/(\d+)\/diseases/)
        if (diseasesMatch) {
          const id = parseInt(diseasesMatch[1])
          const detail = mockProductDetail[id]
          const diseases = detail?.diseases || []
          const params = new URLSearchParams(url.split('?')[1] || '')
          const diseaseType = params.get('diseaseType')
          const typeMap: Record<string, string> = { '1': 'critical', '2': 'medium', '3': 'light' }
          const filtered = diseaseType
            ? diseases.filter((d: any) => d.type === typeMap[diseaseType])
            : diseases
          const result = filtered.map((d: any, index: number) => ({
            diseaseId: 10000 + index,
            diseaseName: d.name,
            diseaseCode: d.code,
            diseaseType: d.type === 'critical' ? 1 : d.type === 'medium' ? 2 : 3,
            diseaseTypeDesc: d.type === 'critical' ? '重疾' : d.type === 'medium' ? '中症' : '轻症',
            diseaseCategory: d.category,
            description: d.definition || '',
            isHighIncidence: d.isHighRisk ? 1 : 0,
            isStatutory: d.isStatutory ? 1 : 0,
            payoutRatio: parseInt(d.compensation) || 100,
            payoutTimes: 1,
            waitingPeriodDays: parseInt(d.waitingPeriod) || 90,
            isBasic: 1,
            sortOrder: index + 1
          }))
          return res.end(JSON.stringify({ code: 200, message: 'success', data: result }))
        }

        // 产品疾病统计（需要在产品详情之前匹配）
        const diseaseStatMatch = url.match(/\/v1\/product\/(\d+)\/disease-stat/)
        if (diseaseStatMatch) {
          const id = parseInt(diseaseStatMatch[1])
          const detail = mockProductDetail[id]
          const diseases = detail?.diseases || []
          const criticalCount = diseases.filter((d: any) => d.type === 'critical').length
          const mediumCount = diseases.filter((d: any) => d.type === 'medium').length
          const lightCount = diseases.filter((d: any) => d.type === 'light').length
          const statutoryCriticalCount = diseases.filter((d: any) => d.type === 'critical' && d.isStatutory).length
          const statutoryLightCount = diseases.filter((d: any) => d.type === 'light' && d.isStatutory).length
          const highIncidenceCount = diseases.filter((d: any) => d.isHighRisk).length
          return res.end(JSON.stringify({
            code: 200,
            message: 'success',
            data: {
              criticalCount,
              mediumCount,
              lightCount,
              statutoryCriticalCount,
              statutoryLightCount,
              highIncidenceCount
            }
          }))
        }

        // 产品类型
        if (url.includes('/v1/product/types')) {
          return res.end(JSON.stringify({
            code: 200, message: 'success',
            data: [
              { value: 'critical_illness', label: '重疾险' },
              { value: 'whole_life', label: '增额终身寿险' },
              { value: 'annuity', label: '年金险' },
              { value: 'health', label: '健康险' }
            ]
          }))
        }

        // ========== 公司相关接口 ==========

        // 公司股东列表（需要在公司详情之前匹配）
        const shareholdersMatch = url.match(/\/v1\/company\/(\d+)\/shareholders/)
        if (shareholdersMatch) {
          const id = parseInt(shareholdersMatch[1])
          const company = mockCompanies.find(c => c.companyId === id)
          const shareholders = (company as any)?.shareholders || []
          const result = shareholders.filter((s: any) => s.ratioValue >= 10).map((s: any, index: number) => ({
            shareholderId: 10000 + index,
            shareholderName: s.name,
            shareholderType: s.isForeign ? 6 : s.isStateOwned ? 4 : 1,
            shareholderTypeDesc: s.type,
            country: s.isForeign ? '法国' : '中国',
            isActualController: s.isControlling ? 1 : 0,
            isStateOwned: s.isStateOwned ? 1 : 0,
            description: '',
            shareRatio: s.ratioValue,
            shareAmount: 0,
            shareType: 1,
            isControlling: s.isControlling ? 1 : 0,
            ranking: index + 1
          }))
          return res.end(JSON.stringify({ code: 200, message: 'success', data: result }))
        }

        // 公司关联关系（需要在公司详情之前匹配）
        const relationsMatch = url.match(/\/v1\/company\/(\d+)\/relations/)
        if (relationsMatch) {
          const id = parseInt(relationsMatch[1])
          const company = mockCompanies.find(c => c.companyId === id)
          const relations = (company as any)?.relations || []
          const result = relations.map((r: any, index: number) => ({
            relationId: index + 1,
            relatedCompanyId: r.companyId,
            relatedCompanyName: r.companyName,
            relatedCompanyShortName: r.companyName,
            relatedCompanyLogo: '',
            relationType: r.relationType,
            relationTypeDesc: r.relationName,
            relationName: r.relationName,
            shareRatio: 0,
            description: ''
          }))
          return res.end(JSON.stringify({ code: 200, message: 'success', data: result }))
        }

        // 公司详情
        const companyDetailMatch = url.match(/\/v1\/company\/(\d+)(\?|$)/)
        if (companyDetailMatch) {
          const id = parseInt(companyDetailMatch[1])
          const company = mockCompanies.find(c => c.companyId === id) || mockCompanies[0]
          return res.end(JSON.stringify({ code: 200, message: 'success', data: company }))
        }

        // 星系数据
        if (url.includes('/v1/company/cosmos-data')) {
          const cosmosData = mockCompanies.map(c => ({
            companyId: c.companyId,
            companyName: c.companyName,
            companyShortName: c.companyShortName,
            nature: c.companyTypeDesc || '民营',
            capital: c.registeredCapital || 10,
            productCount: mockProducts.filter(p => p.companyId === c.companyId).length,
            productTypes: Array.from(new Set(mockProducts.filter(p => p.companyId === c.companyId).map(p => {
              const typeMap: Record<number, string> = { 1: '重疾险', 2: '增额终身寿', 3: '年金险' }
              return typeMap[p.productType] || '重疾险'
            }))),
            shareholders: (c as any).shareholders?.filter((s: any) => s.ratioValue >= 10).slice(0, 5) || [],
            relations: (c as any).relations || []
          }))
          return res.end(JSON.stringify({ code: 200, message: 'success', data: cosmosData }))
        }

        // 公司搜索
        if (url.includes('/v1/company/search')) {
          const params = new URLSearchParams(url.split('?')[1] || '')
          const keyword = (params.get('keyword') || '').trim()
          const filtered = keyword
            ? mockCompanies.filter(c => c.companyName.includes(keyword) || c.companyShortName.includes(keyword))
            : mockCompanies
          return res.end(JSON.stringify({
            code: 200, message: 'success',
            data: filtered
          }))
        }

        // 公司列表
        if (url.includes('/v1/company/all') || url.includes('/v1/company/list') || url.match(/\/v1\/company(\?|$)/)) {
          return res.end(JSON.stringify({
            code: 200, message: 'success',
            data: mockCompanies
          }))
        }

        // ========== 认证相关接口 ==========

        // 登录
        if (url.includes('/v1/auth/login')) {
          return res.end(JSON.stringify({
            code: 200, message: 'success',
            data: {
              accessToken: 'mock_access_token_12345',
              refreshToken: 'mock_refresh_token_12345',
              tokenType: 'Bearer',
              expiresIn: 7200,
              userInfo: {
                userId: 1, username: 'demo', nickname: '演示用户',
                phone: '138****8888', email: 'demo@example.com',
                gender: null, birthday: null, status: 1,
                avatarUrl: '',
                memberLevel: 2, memberExpireTime: '2027-12-31 23:59:59',
                wechatOpenid: null, wechatUnionid: null,
                wechatNickname: null, wechatAvatar: null,
                wechatBound: 0
              }
            }
          }))
        }

        // 注册
        if (url.includes('/v1/auth/register')) {
          let body = ''
          req.on('data', (chunk: any) => { body += chunk })
          req.on('end', () => {
            try {
              const params = JSON.parse(body || '{}')
              const username = params.username || 'newuser'
              return res.end(JSON.stringify({
                code: 200, message: 'success',
                data: {
                  accessToken: 'mock_access_token_' + Date.now(),
                  refreshToken: 'mock_refresh_token_' + Date.now(),
                  tokenType: 'Bearer',
                  expiresIn: 7200,
                  userInfo: {
                    userId: Math.floor(Math.random() * 10000),
                    username, nickname: username,
                    phone: '', email: '',
                    gender: null, birthday: null, status: 1,
                    avatarUrl: '',
                    memberLevel: 0, memberExpireTime: null,
                    wechatOpenid: null, wechatUnionid: null,
                    wechatNickname: null, wechatAvatar: null,
                    wechatBound: 0
                  }
                }
              }))
            } catch (_e) {
              return res.end(JSON.stringify({ code: 500, message: '注册失败', data: null }))
            }
          })
          return
        }

        // 检查用户名
        if (url.includes('/v1/auth/check-username')) {
          const params = new URLSearchParams(url.split('?')[1] || '')
          const username = params.get('username') || ''
          const exists = username === 'demo' || username === 'admin'
          return res.end(JSON.stringify({
            code: 200, message: 'success',
            data: { exists }
          }))
        }

        // 刷新token
        if (url.includes('/v1/auth/refresh')) {
          return res.end(JSON.stringify({
            code: 200, message: 'success',
            data: { accessToken: 'mock_access_token_new', refreshToken: 'mock_refresh_token_new' }
          }))
        }

        // 解绑微信
        if (url.includes('/wechat/unbind')) {
          return res.end(JSON.stringify({ code: 200, message: 'success', data: null }))
        }

        // 获取用户信息
        if (url.includes('/v1/auth/user') || url.includes('/v1/user/info')) {
          return res.end(JSON.stringify({
            code: 200, message: 'success',
            data: {
              userId: 1, username: 'demo', nickname: '演示用户',
              phone: '138****8888', email: 'demo@example.com',
              gender: null, birthday: null, status: 1,
              avatarUrl: '',
              memberLevel: 2, memberExpireTime: '2027-12-31 23:59:59',
              wechatOpenid: null, wechatUnionid: null,
              wechatNickname: null, wechatAvatar: null,
              wechatBound: 0
            }
          }))
        }

        // 更新用户资料
        if (url.includes('/v1/user/profile')) {
          let body = ''
          req.on('data', (chunk: any) => { body += chunk })
          req.on('end', () => {
            try {
              const params = JSON.parse(body || '{}')
              return res.end(JSON.stringify({
                code: 200, message: 'success',
                data: {
                  userId: 1, username: 'demo',
                  nickname: params.nickname || '演示用户',
                  phone: params.phone || '138****8888',
                  email: params.email || 'demo@example.com',
                  gender: params.gender ?? null,
                  birthday: params.birthday || null,
                  status: 1,
                  avatarUrl: params.avatarUrl || '',
                  memberLevel: 2, memberExpireTime: '2027-12-31 23:59:59',
                  wechatOpenid: null, wechatUnionid: null,
                  wechatNickname: null, wechatAvatar: null,
                  wechatBound: 0
                }
              }))
            } catch (_e) {
              return res.end(JSON.stringify({ code: 500, message: '更新失败', data: null }))
            }
          })
          return
        }

        // 修改密码
        if (url.includes('/v1/user/password')) {
          let body = ''
          req.on('data', (chunk: any) => { body += chunk })
          req.on('end', () => {
            try {
              const params = JSON.parse(body || '{}')
              if (!params.oldPassword || !params.newPassword) {
                return res.end(JSON.stringify({ code: 400, message: '密码不能为空', data: null }))
              }
              return res.end(JSON.stringify({ code: 200, message: 'success', data: null }))
            } catch (_e) {
              return res.end(JSON.stringify({ code: 500, message: '修改失败', data: null }))
            }
          })
          return
        }

        // 登出
        if (url.includes('/v1/auth/logout')) {
          return res.end(JSON.stringify({ code: 200, message: 'success', data: null }))
        }

        // ========== VIP相关接口 ==========

        // VIP套餐列表
        if (url.includes('/v1/vip/plans')) {
          return res.end(JSON.stringify({
            code: 200, message: 'success',
            data: [
              { id: 1, name: '月度会员', price: 39, originalPrice: 59, duration: 30, description: '按月付费，灵活选择', features: ['全部产品对比', '导出对比卡片', '无限次计算', '专属客服'], isPopular: false },
              { id: 2, name: '年度会员', price: 299, originalPrice: 468, duration: 365, description: '年度最划算，省50%', features: ['全部产品对比', '导出对比卡片', '无限次计算', '专属客服', '高级分析报告', '优先体验新功能'], isPopular: true },
              { id: 3, name: '永久会员', price: 1999, originalPrice: 2999, duration: -1, description: '一次购买，终身使用', features: ['全部产品对比', '导出对比卡片', '无限次计算', '专属客服', '高级分析报告', '优先体验新功能', '一对一咨询服务'], isPopular: false }
            ]
          }))
        }

        // 创建VIP订单
        if (url.includes('/v1/vip/order') && req.method?.toUpperCase() === 'POST') {
          let body = ''
          req.on('data', (chunk: any) => { body += chunk })
          req.on('end', () => {
            try {
              const params = JSON.parse(body || '{}')
              return res.end(JSON.stringify({
                code: 200, message: 'success',
                data: {
                  orderId: 'VIP' + Date.now(),
                  planId: params.planId,
                  amount: params.amount || 299,
                  status: 'pending',
                  payUrl: ''
                }
              }))
            } catch (_e) {
              return res.end(JSON.stringify({ code: 500, message: '创建订单失败', data: null }))
            }
          })
          return
        }

        // VIP订单状态
        if (url.includes('/v1/vip/order/status')) {
          return res.end(JSON.stringify({
            code: 200, message: 'success',
            data: { status: 'paid', memberLevel: 2, memberExpireTime: '2027-12-31 23:59:59' }
          }))
        }

        // VIP订单历史
        if (url.includes('/v1/vip/orders') && !url.includes('/status')) {
          return res.end(JSON.stringify({
            code: 200, message: 'success',
            data: [
              { id: 1001, planId: 2, planName: '年度会员', price: 299, status: 'paid', createdAt: '2025-01-15 10:00:00', paidAt: '2025-01-15 10:05:00', expireAt: '2026-01-15 23:59:59' },
              { id: 1002, planId: 1, planName: '月度会员', price: 39, status: 'expired', createdAt: '2024-12-01 09:00:00', paidAt: '2024-12-01 09:02:00', expireAt: '2025-01-01 23:59:59' },
              { id: 1003, planId: 3, planName: '永久会员', price: 1999, status: 'pending', createdAt: '2025-06-20 15:30:00', paidAt: null, expireAt: null }
            ]
          }))
        }

        // ========== 对比相关接口 ==========

        // 对比历史
        if (url.includes('/v1/compare/history')) {
          return res.end(JSON.stringify({
            code: 200, message: 'success',
            data: [
              { id: 1, productIds: [1, 4, 7], params: { productIds: [1, 4, 7], age: 30, gender: 'male', paymentPeriod: '20', coverage: 50 }, createdAt: '2025-06-15 10:30:00' },
              { id: 2, productIds: [3, 6, 9], params: { productIds: [3, 6, 9], age: 35, gender: 'female', paymentPeriod: '30', coverage: 30 }, createdAt: '2025-06-10 14:20:00' },
              { id: 3, productIds: [2, 5, 8], params: { productIds: [2, 5, 8], age: 40, gender: 'male', paymentPeriod: '10' }, createdAt: '2025-06-05 09:15:00' }
            ]
          }))
        }

        // 删除对比记录
        const deleteCompareMatch = url.match(/\/v1\/compare\/(\d+)\/delete/)
        if (deleteCompareMatch) {
          return res.end(JSON.stringify({ code: 200, message: 'success', data: null }))
        }

        // 保存对比
        if (url.includes('/v1/compare/save')) {
          let body = ''
          req.on('data', (chunk: any) => { body += chunk })
          req.on('end', () => {
            try {
              return res.end(JSON.stringify({
                code: 200, message: 'success',
                data: { id: Date.now() }
              }))
            } catch (_e) {
              return res.end(JSON.stringify({ code: 500, message: '保存失败', data: null }))
            }
          })
          return
        }

        // 对比API
        if (url.includes('/v1/compare/')) {
          return res.end(JSON.stringify({
            code: 200, message: 'success',
            data: { items: [], dimensions: [], winnerId: null }
          }))
        }

        // ========== 计算相关接口 ==========

        // 重疾险费率计算
        if (url.includes('/v1/calculate/critical-premium')) {
          let body = ''
          req.on('data', (chunk: any) => { body += chunk })
          req.on('end', () => {
            try {
              const params = JSON.parse(body || '{}')
              const age = params.age || 30
              const gender = params.gender || 1
              const paymentPeriod = params.paymentPeriod || 30
              const coverage = params.coverage || 50
              const ageFactor = 1 + (age - 25) * 0.012
              const genderFactor = gender === 1 ? 1.05 : 1.0
              const periodFactor = 30 / Math.min(paymentPeriod, 30)
              const annualPremium = Math.round(coverage * 10 * 55 * ageFactor * genderFactor * periodFactor * 100) / 100
              const totalPremium = Math.round(annualPremium * paymentPeriod * 100) / 100
              return res.end(JSON.stringify({
                code: 200, message: 'success',
                data: {
                  annualPremium,
                  monthlyPremium: Math.round(annualPremium / 12 * 100) / 100,
                  quarterlyPremium: Math.round(annualPremium * 0.26 * 100) / 100,
                  halfYearlyPremium: Math.round(annualPremium * 0.52 * 100) / 100,
                  totalPremium
                }
              }))
            } catch (_e) {
              return res.end(JSON.stringify({ code: 200, message: 'success', data: { annualPremium: 5500, totalPremium: 165000 } }))
            }
          })
          return
        }

        // 增额终身寿险收益演示
        if (url.includes('/v1/calculate/whole-life-projection')) {
          let body = ''
          req.on('data', (chunk: any) => { body += chunk })
          req.on('end', () => {
            try {
              const params = JSON.parse(body || '{}')
              const age = params.age || 30
              const paymentYear = params.paymentYear || 5
              const annualPremium = params.annualPremium || 100000
              const maxYear = Math.min(105 - age, 75)
              const increaseRate = 0.035
              const yearlyProjections: any[] = []
              let cashValue = 0
              for (let n = 1; n <= maxYear; n++) {
                const currentAge = age + n
                const totalPremium = annualPremium * Math.min(n, paymentYear)
                if (n === 1) {
                  cashValue = Math.round(annualPremium * 0.7)
                } else if (n <= paymentYear) {
                  cashValue = Math.round((cashValue + annualPremium * 0.85) * (1 + increaseRate))
                } else {
                  cashValue = Math.round(cashValue * (1 + increaseRate))
                }
                const deathBenefit = Math.max(totalPremium, cashValue)
                yearlyProjections.push({
                  policyYear: n, age: currentAge, cashValue, cashValueGuaranteed: cashValue,
                  deathBenefit, deathBenefitGuaranteed: deathBenefit, totalPremium
                })
              }
              return res.end(JSON.stringify({
                code: 200, message: 'success',
                data: { yearlyProjections, paymentYear, annualPremium, totalPremium: annualPremium * paymentYear }
              }))
            } catch (_e) {
              return res.end(JSON.stringify({ code: 500, message: 'mock error', data: null }))
            }
          })
          return
        }

        // 年金险收益演示
        if (url.includes('/v1/calculate/annuity-projection')) {
          let body = ''
          req.on('data', (chunk: any) => { body += chunk })
          req.on('end', () => {
            try {
              const params = JSON.parse(body || '{}')
              const age = params.age || 40
              const paymentYear = params.paymentYear || 5
              const annualPremium = params.annualPremium || 100000
              const startAge = params.startAge || 60
              const maxYear = Math.min(105 - age, 75)
              const yearlyProjections: any[] = []
              let cashValue = 0
              let totalReceived = 0
              const annualPayout = Math.round(annualPremium * paymentYear * 0.0992)
              for (let n = 1; n <= maxYear; n++) {
                const currentAge = age + n
                const totalPremium = annualPremium * Math.min(n, paymentYear)
                const hasPayout = currentAge >= startAge
                if (n === 1) {
                  cashValue = Math.round(annualPremium * 0.95)
                } else if (n <= paymentYear) {
                  cashValue = Math.round((cashValue + annualPremium * 0.98) * (1 + 0.025))
                } else {
                  cashValue = Math.round(cashValue * (1 + 0.030))
                }
                let payoutThisYear = 0
                if (hasPayout) {
                  payoutThisYear = annualPayout
                  totalReceived += payoutThisYear
                  cashValue = Math.round((cashValue - payoutThisYear * 0.7) * (1 + 0.025))
                  if (cashValue < 0) cashValue = 0
                }
                const deathBenefit = Math.max(totalPremium, cashValue)
                yearlyProjections.push({
                  policyYear: n, age: currentAge, cashValue: Math.max(cashValue, 0),
                  cashValueGuaranteed: Math.max(cashValue, 0), deathBenefit, deathBenefitGuaranteed: deathBenefit,
                  totalPremium, annualPayout: hasPayout ? payoutThisYear : null,
                  totalReceived: hasPayout ? totalReceived : null
                })
              }
              return res.end(JSON.stringify({
                code: 200, message: 'success',
                data: { yearlyProjections, paymentYear, annualPremium, totalPremium: annualPremium * paymentYear }
              }))
            } catch (_e) {
              return res.end(JSON.stringify({ code: 500, message: 'mock error', data: null }))
            }
          })
          return
        }

        // ========== 卡片相关接口 ==========

        // 卡片模板列表
        if (url.includes('/v1/card-template/list')) {
          return res.end(JSON.stringify({
            code: 200, message: 'success',
            data: [
              { id: 1, name: '简约商务风', backgroundImage: '', category: 'default', isPremium: false },
              { id: 2, name: '深蓝科技感', backgroundImage: '', category: 'default', isPremium: false },
              { id: 3, name: '金色高端风', backgroundImage: '', category: 'premium', isPremium: true },
              { id: 4, name: '清新自然风', backgroundImage: '', category: 'premium', isPremium: true }
            ]
          }))
        }

        // 生成卡片
        if (url.includes('/v1/card-template/generate')) {
          let body = ''
          req.on('data', (chunk: any) => { body += chunk })
          req.on('end', () => {
            try {
              return res.end(JSON.stringify({
                code: 200, message: 'success',
                data: { id: Date.now(), imageUrl: '', htmlContent: '', shareUrl: '' }
              }))
            } catch (_e) {
              return res.end(JSON.stringify({ code: 500, message: '生成失败', data: null }))
            }
          })
          return
        }

        // 卡片生成历史
        if (url.includes('/v1/card-template/history')) {
          const params = new URLSearchParams(url.split('?')[1] || '')
          const page = parseInt(params.get('page') || '1')
          const pageSize = parseInt(params.get('pageSize') || '10')
          const allCards = [
            { id: 1, imageUrl: 'https://picsum.photos/seed/card1/400/600', htmlContent: '', shareUrl: '', createdAt: '2025-06-20 10:00:00' },
            { id: 2, imageUrl: 'https://picsum.photos/seed/card2/400/600', htmlContent: '', shareUrl: '', createdAt: '2025-06-18 14:30:00' },
            { id: 3, imageUrl: 'https://picsum.photos/seed/card3/400/600', htmlContent: '', shareUrl: '', createdAt: '2025-06-15 09:20:00' },
            { id: 4, imageUrl: 'https://picsum.photos/seed/card4/400/600', htmlContent: '', shareUrl: '', createdAt: '2025-06-12 16:45:00' },
            { id: 5, imageUrl: 'https://picsum.photos/seed/card5/400/600', htmlContent: '', shareUrl: '', createdAt: '2025-06-10 11:15:00' }
          ]
          const start = (page - 1) * pageSize
          const list = allCards.slice(start, start + pageSize)
          return res.end(JSON.stringify({
            code: 200, message: 'success',
            data: { list, total: allCards.length }
          }))
        }

        // 删除卡片
        const deleteCardMatch = url.match(/\/v1\/card-template\/(\d+)\/delete/)
        if (deleteCardMatch) {
          return res.end(JSON.stringify({ code: 200, message: 'success', data: null }))
        }

        // ========== 首页/统计相关接口 ==========

        // 首页统计
        if (url.includes('/v1/home/stats') || url.includes('/v1/stats/overview')) {
          const typeMap: Record<number, string> = { 1: '重疾险', 2: '增额终身寿险', 3: '年金险', 4: '健康险' }
          const companyStats = mockCompanies.slice(0, 10).map(c => ({
            companyId: c.companyId,
            companyName: c.companyName,
            productCount: mockProducts.filter(p => p.companyId === c.companyId).length
          })).filter(c => c.productCount > 0)
          return res.end(JSON.stringify({
            code: 200, message: 'success',
            data: {
              totalProducts: mockProducts.length,
              totalCompanies: mockCompanies.length,
              productTypes: Object.entries(typeMap).map(([type, name]) => ({
                type, name, productCount: mockProducts.filter(p => p.productType === parseInt(type)).length
              })).filter(c => c.productCount > 0)
            }
          }))
        }

        next()
      })
    }
  }
}
