<template>
  <div class="cosmos-page">
    <div id="root">
      <div id="loading">
        <div class="load-title">天保星君</div>
        <div class="load-sub">正在点亮 <span id="load-count">0</span> 家保司…</div>
        <div class="load-track"><div class="load-bar" id="load-bar"></div></div>
      </div>
    </div>

    <!-- 产品详情弹窗 -->
    <el-dialog
      v-model="productDialogVisible"
      :title="selectedProductName"
      width="90%"
      top="5vh"
      destroy-on-close
      class="product-detail-dialog"
    >
      <template #header>
        <div class="dialog-header">
          <span class="dialog-title">{{ selectedProductName }}</span>
          <div class="dialog-actions">
            <el-button @click="openProductDetailPage" size="small" type="primary">
              <el-icon><FullScreen /></el-icon> 放大查看
            </el-button>
            <el-button @click="productDialogVisible = false" size="small">
              <el-icon><Close /></el-icon> 关闭
            </el-button>
          </div>
        </div>
      </template>
      <ProductDetailWrapper
        v-if="selectedProductId && productDialogVisible"
        :product-id="selectedProductId"
        :key="selectedProductId"
      />
    </el-dialog>

    <!-- 公司详情抽屉面板 -->
    <el-drawer
      v-model="companyDetailVisible"
      :title="''"
      direction="rtl"
      size="560px"
      :with-header="false"
      class="company-detail-drawer"
    >
      <CompanyDetailPanel
        v-if="selectedCompanyId"
        :company-id="selectedCompanyId"
        :company-data="selectedCompanyData"
        @close="companyDetailVisible = false"
        @navigate-company="handleNavigateCompany"
        @view-product="handleViewProductFromCompany"
      />
    </el-drawer>
  </div>
</template>

<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { getCosmosData, getCompanyDetail, getCompanyShareholders, getCompanyRelations } from '@/api/company'
import { getProductList, getProductBrief } from '@/api/product'
import type { CompanyCosmos, Company } from '@/api/company'
import type { Product, ProductBrief } from '@/api/product'
import { COMPANIES as FALLBACK_COMPANIES } from './cosmosData'
import ProductDetailWrapper from '@/views/product/ProductDetailWrapper.vue'
import CompanyDetailPanel from './CompanyDetailPanel.vue'
import { FullScreen, Close } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import './cosmosStyle.css'

const router = useRouter()
const route = useRoute()
let cleanup: (() => void) | null = null

// 产品详情弹窗
const productDialogVisible = ref(false)
const selectedProductId = ref<number | null>(null)
const selectedProductName = ref('')

// 公司详情抽屉
const companyDetailVisible = ref(false)
const selectedCompanyId = ref<number | null>(null)
const selectedCompanyData = ref<Company | null>(null)

// 缓存公司详情数据
const companyDetailCache = new Map<number, Company>()

// 产品类型颜色映射
const productTypeColorMap: Record<number, string> = {
  1: '#ff4d4f',
  2: '#eb2f96',
  3: '#fa8c16'
}

const productTypeLabelMap: Record<number, string> = {
  1: '重疾险',
  2: '增额终身寿',
  3: '年金险'
}

// 虚空捞取：获取随机产品简介
async function handleVoidFishing() {
  try {
    // 随机获取一款产品（从产品列表中随机选）
    const randomPage = Math.floor(Math.random() * 50) + 1 // 前50页随机
    const res = await getProductList({ page: randomPage, pageSize: 1 })
    if (res.list && res.list.length > 0) {
      const product = res.list[0]
      // 获取产品简介详情
      let briefData: ProductBrief | null = null
      try {
        briefData = await getProductBrief(product.productId)
      } catch (e) {
        console.warn('获取产品简介失败:', e)
      }

      const productType = product.productType || 1
      const companyNature = (product as any).companyNature || '保险机构'

      return {
        productId: product.productId,
        productName: product.productName,
        companyName: product.companyName,
        companyNature,
        productType: productTypeLabelMap[productType] || '保险',
        productTypeColor: productTypeColorMap[productType] || '#ffd27a',
        productBrief: briefData?.productBrief || (product as any).productBrief || '',
        productHighlights: briefData?.productHighlights || (product as any).productHighlights || [],
        suitableFor: briefData?.suitableFor || (product as any).suitableFor || '',
        productTags: briefData?.productTags || (product as any).productTags || [],
        coverageSummary: briefData?.coverageSummary || '',
        recommendationScore: briefData?.recommendationScore || 0,
        briefStatus: briefData?.briefStatus || 0
      }
    }
    return null
  } catch (e) {
    console.warn('虚空捞取失败:', e)
    return null
  }
}

function handleProductClick(companyId: number, productName: string) {
  // 通过保司ID和产品名称查找产品ID
  const params: any = { keyword: productName, pageSize: 10 }
  if (companyId > 0) params.companyId = companyId
  getProductList(params).then((res) => {
    const match = res.list.find((p: Product) => p.productName === productName)
    if (match) {
      selectedProductId.value = match.productId
      selectedProductName.value = productName
      productDialogVisible.value = true
    } else if (res.list.length > 0) {
      // 没有精确匹配，取第一个
      selectedProductId.value = res.list[0].productId
      selectedProductName.value = res.list[0].productName
      productDialogVisible.value = true
    } else {
      ElMessage.warning('未找到该产品详情')
    }
  }).catch(() => {
    ElMessage.warning('查询产品失败')
  })
}

function openProductDetailPage() {
  if (selectedProductId.value) {
    router.push(`/product/${selectedProductId.value}`)
    productDialogVisible.value = false
  }
}

// 打开公司详情
async function handleCompanyClick(companyId: number, companyCosmosData?: any) {
  selectedCompanyId.value = companyId

  // 先尝试从缓存获取
  if (companyDetailCache.has(companyId)) {
    selectedCompanyData.value = companyDetailCache.get(companyId)!
    companyDetailVisible.value = true
    return
  }

  // 设置一个基础数据（从星系数据中提取）
  if (companyCosmosData) {
    selectedCompanyData.value = {
      companyId: companyCosmosData.companyId || companyId,
      companyName: companyCosmosData.fullName || companyCosmosData.name,
      companyShortName: companyCosmosData.name,
      logoUrl: '',
      introduction: '',
      officialWebsite: '',
      servicePhone: '',
      establishedYear: 0,
      registeredCapital: companyCosmosData.capital || 0,
      headquarters: '',
      companyType: 0,
      companyTypeDesc: companyCosmosData.nature || '',
      creditRating: '',
      cooperationStatus: 1,
      isHot: 0,
      shareholders: companyCosmosData.shareholders || [],
      relations: companyCosmosData.relations || [],
      riskRating: '',
      solvencyRatio: 0
    }
  }

  companyDetailVisible.value = true

  // 异步加载完整详情
  try {
    const detail = await getCompanyDetail(companyId)
    if (detail) {
      // 同时加载股东和关系数据
      try {
        const [shareholdersData, relationsData] = await Promise.all([
          getCompanyShareholders(companyId),
          getCompanyRelations(companyId)
        ])
        // 转换股东数据格式
        const shareholders = shareholdersData.map((s: any) => ({
          name: s.shareholderName,
          ratio: s.shareRatio + '%',
          ratioValue: s.shareRatio,
          type: s.shareholderTypeDesc || '其他',
          isControlling: s.isControlling === 1,
          isStateOwned: s.isStateOwned === 1,
          isForeign: s.shareholderType === 6
        }))
        // 转换关系数据格式
        const relations = relationsData.map((r: any) => ({
          companyId: r.relatedCompanyId,
          companyName: r.relatedCompanyName,
          relationType: r.relationType,
          relationName: r.relationName
        }))
        ;(detail as any).shareholders = shareholders
        ;(detail as any).relations = relations
      } catch (e) {
        console.warn('获取股东/关系数据失败:', e)
      }
      selectedCompanyData.value = detail
      companyDetailCache.set(companyId, detail)
    }
  } catch (e) {
    console.warn('获取公司详情失败，使用星系数据:', e)
  }
}

// 从公司详情跳转到另一个公司
function handleNavigateCompany(companyId: number) {
  companyDetailVisible.value = false
  // 延迟一点再打开，让抽屉有个动画过渡
  setTimeout(() => {
    handleCompanyClick(companyId)
  }, 200)
}

// 从公司详情查看产品
function handleViewProductFromCompany(companyId: number, productName: string) {
  companyDetailVisible.value = false
  handleProductClick(companyId, productName)
}

onMounted(async () => {
  const queryCompanyId = route.query.companyId ? parseInt(route.query.companyId as string) : null

  try {
    // 使用聚合接口获取保险宇宙数据（避免N+1查询）
    const cosmosList = await getCosmosData()
    const cosmosData = buildCosmosData(cosmosList)
    const relations = buildEquityRelations(cosmosData)

    const mod = await import('./cosmosMain')
    cleanup = mod.initCosmosScene(
      cosmosData,
      relations,
      (path: string) => { router.push(path) },
      handleProductClick,
      handleCompanyClick,
      handleVoidFishing
    )

    // 如果有query参数中的companyId，延迟打开公司详情
    if (queryCompanyId) {
      setTimeout(() => {
        const targetCompany = cosmosData.find((c: any) => c.companyId === queryCompanyId)
        if (targetCompany) {
          handleCompanyClick(queryCompanyId, targetCompany)
        }
      }, 800)
    }
  } catch (err) {
    console.warn('后端接口不可用，使用演示数据:', err)
    const fallbackData = FALLBACK_COMPANIES.map((c: any) => ({
      companyId: c.companyId,
      name: c.name,
      fullName: c.name,
      nature: c.nature,
      capital: c.capital,
      products: c.products,
      shareholders: c.shareholders || [],
      relations: c.relations || []
    }))
    const relations = buildEquityRelations(fallbackData)
    const mod = await import('./cosmosMain')
    cleanup = mod.initCosmosScene(
      fallbackData,
      relations,
      (path: string) => { router.push(path) },
      handleProductClick,
      handleCompanyClick
      // 演示数据模式下不使用真实产品简介
    )

    // 如果有query参数中的companyId，延迟打开公司详情
    if (queryCompanyId) {
      setTimeout(() => {
        const targetCompany = fallbackData.find((c: any) => c.companyId === queryCompanyId)
        if (targetCompany) {
          handleCompanyClick(queryCompanyId, targetCompany)
        }
      }, 800)
    }
  }
})

onUnmounted(() => {
  cleanup?.()
})

// 将聚合接口数据转换为保险宇宙需要的格式
function buildCosmosData(list: CompanyCosmos[]) {
  return list.map((c) => {
    // 优先使用真实产品名称列表，fallback 到产品类型
    let products: string[] = []
    if (c.productNames && c.productNames.length > 0) {
      products = c.productNames.filter((n: string) => n && n.trim().length > 0)
    }
    if (products.length === 0 && c.productTypes && c.productTypes.length > 0) {
      products = c.productTypes.filter((t: string) => t && t.trim().length > 0)
    }

    // 转换股东数据格式（后端VO -> 前端格式）
    const shareholders = (c.shareholders || []).map((s: any) => ({
      name: s.shareholderName || s.name,
      ratio: s.shareRatio ? s.shareRatio + '%' : s.ratio || '0%',
      ratioValue: s.shareRatio ?? s.ratioValue ?? 0,
      type: s.shareholderTypeDesc || s.type || '其他',
      isControlling: s.isControlling === 1 || s.isControlling === true,
      isStateOwned: s.isStateOwned === 1 || s.isStateOwned === true,
      isForeign: s.shareholderType === 6 || s.isForeign === true
    }))

    // 转换关联关系数据格式（后端VO -> 前端格式）
    const relations = (c.relations || []).map((r: any) => ({
      companyId: r.relatedCompanyId ?? r.companyId,
      companyName: r.relatedCompanyName || r.companyName || '',
      relationType: r.relationType || 1,
      relationName: r.relationName || ''
    }))

    return {
      companyId: c.companyId,
      name: c.companyShortName || c.companyName,
      fullName: c.companyName,
      nature: c.nature || '民营',
      capital: c.capital || 10,
      products,
      productCount: c.productCount || 0,
      shareholders,
      relations
    }
  })
}

// 构建股权关系数据（从公司relations字段提取）
function buildEquityRelations(companies: any[]) {
  const relations: {
    from: number
    to: number
    group: string
    relationType: number
    relationName: string
  }[] = []
  const addedPairs = new Set<string>()

  // 先从公司的relations字段提取
  companies.forEach((company, fromIdx) => {
    if (company.relations && company.relations.length > 0) {
      company.relations.forEach((rel: any) => {
        const toIdx = companies.findIndex((c: any) => c.companyId === rel.companyId)
        if (toIdx === -1) return

        const pairKey = fromIdx < toIdx ? `${fromIdx}-${toIdx}` : `${toIdx}-${fromIdx}`
        if (addedPairs.has(pairKey)) return
        addedPairs.add(pairKey)

        relations.push({
          from: fromIdx,
          to: toIdx,
          group: rel.relationName,
          relationType: rel.relationType || 1,
          relationName: rel.relationName
        })
      })
    }
  })

  // 再根据名称关键词补充同一集团关系（relationType: 1）
  const groupKeywords = ['太平', '平安', '大家', '泰康', '阳光', '中国人寿', '中银', '招商', '中华', '复星', '富德', '恒安标准', '渤海', '人保', '人民', '合众', '前海', '新华', '友邦', '富卫', '汇丰', '国泰', '华泰', '建信', '苏黎', '英大', '安达', '安盛']

  groupKeywords.forEach(keyword => {
    const indices: number[] = []
    companies.forEach((c, i) => {
      if (c.name.includes(keyword)) indices.push(i)
    })
    // 两两建立关系
    for (let i = 0; i < indices.length; i++) {
      for (let j = i + 1; j < indices.length; j++) {
        const pairKey = `${indices[i]}-${indices[j]}`
        if (!addedPairs.has(pairKey)) {
          addedPairs.add(pairKey)
          relations.push({
            from: indices[i],
            to: indices[j],
            group: keyword + '集团',
            relationType: 1,
            relationName: `同一集团（${keyword}）`
          })
        }
      }
    }
  })

  return relations
}
</script>

<style scoped>
.cosmos-page {
  width: 100%;
  height: 100%;
}
#root {
  width: 100%;
  height: 100%;
}
</style>

<style>
.product-detail-dialog :deep(.el-dialog__body) {
  padding: 0;
  max-height: 80vh;
  overflow-y: auto;
}

.product-detail-dialog .dialog-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
}

.product-detail-dialog .dialog-title {
  font-size: 18px;
  font-weight: 600;
}

.product-detail-dialog .dialog-actions {
  display: flex;
  gap: 8px;
}

/* 公司详情抽屉样式 */
.company-detail-drawer :deep(.el-drawer) {
  background: transparent !important;
  box-shadow: none !important;
}

.company-detail-drawer :deep(.el-drawer__body) {
  padding: 0;
  background: transparent;
}
</style>
