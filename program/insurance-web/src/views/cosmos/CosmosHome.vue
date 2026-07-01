<template>
  <div class="cosmos-page">
    <div id="root">
      <div id="loading">
        <div class="load-title">保险宇宙</div>
        <div class="load-sub">正在点亮 <span id="load-count">0</span> 家保司…</div>
        <div class="load-track"><div class="load-bar" id="load-bar"></div></div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { getCosmosData } from '@/api/company'
import { getProductList } from '@/api/product'
import type { CompanyCosmos } from '@/api/company'
import type { Product } from '@/api/product'
import { COMPANIES as FALLBACK_COMPANIES } from './cosmosData'
import './cosmosStyle.css'

const router = useRouter()
let cleanup: (() => void) | null = null

onMounted(async () => {
  try {
    // 使用聚合接口获取保险宇宙数据（避免N+1查询）
    const cosmosList = await getCosmosData()
    const cosmosData = buildCosmosData(cosmosList)
    const relations = buildGroupRelations(cosmosData)

    const mod = await import('./cosmosMain')
    cleanup = mod.initCosmosScene(cosmosData, relations, (path: string) => {
      router.push(path)
    })
  } catch (err) {
    console.warn('后端接口不可用，使用演示数据:', err)
    const fallbackData = FALLBACK_COMPANIES.map((c: any) => ({
      name: c.name,
      nature: c.nature,
      capital: c.capital,
      products: c.products
    }))
    const relations = buildGroupRelations(fallbackData)
    const mod = await import('./cosmosMain')
    cleanup = mod.initCosmosScene(fallbackData, relations, (path: string) => {
      router.push(path)
    })
  }
})

onUnmounted(() => {
  cleanup?.()
})

// 将聚合接口数据转换为保险宇宙需要的格式
function buildCosmosData(list: CompanyCosmos[]) {
  return list.map((c) => {
    // 根据产品类型分布生成产品名称列表（用于展示）
    const typeProducts: string[] = []
    if (c.productTypes && c.productTypes.length > 0) {
      c.productTypes.forEach((type: string) => {
        if (type) typeProducts.push(type)
      })
    }

    return {
      name: c.companyShortName || c.companyName,
      nature: c.nature || '民营',
      capital: c.capital || 10,
      products: typeProducts.length > 0 ? typeProducts : ['暂无产品'],
      productCount: c.productCount || 0
    }
  })
}

// 根据保司名称动态生成集团关系
function buildGroupRelations(companies: any[]) {
  const relations: { from: number; to: number; group: string }[] = []
  const groupKeywords = ['太平', '平安', '大家', '泰康', '阳光', '中国人寿', '中银', '招商', '中华', '中意', '复星', '富德', '恒安标准', '渤海', '人保', '人民', '合众', '前海', '新华', '友邦', '富卫', '汇丰', '香港', '国泰', '华泰', '建信', '苏黎', '英大', '安达', '安盛', '阳光']

  groupKeywords.forEach(keyword => {
    const indices: number[] = []
    companies.forEach((c, i) => {
      if (c.name.includes(keyword)) indices.push(i)
    })
    // 两两建立关系
    for (let i = 0; i < indices.length; i++) {
      for (let j = i + 1; j < indices.length; j++) {
        relations.push({ from: indices[i], to: indices[j], group: keyword })
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
