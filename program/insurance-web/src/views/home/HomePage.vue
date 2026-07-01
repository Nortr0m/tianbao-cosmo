<template>
  <div class="home-page">
    <!-- Hero Section -->
    <section class="hero-section">
      <div class="hero-bg-grid"></div>
      <div class="hero-content">
        <h1 class="hero-title">天保星君</h1>
        <p class="hero-subtitle">海量产品 · 精准计算 · 智能推荐</p>
        <div class="hero-search">
          <el-input
            v-model="searchKeyword"
            placeholder="搜索保险产品名称或保险公司"
            size="large"
            clearable
            @keyup.enter="handleSearch"
          >
            <template #append>
              <el-button type="primary" :icon="Search" @click="handleSearch">
                搜索
              </el-button>
            </template>
          </el-input>
        </div>
        <el-button type="primary" size="large" class="start-btn" @click="goToProductList()">
          开始对比
          <el-icon class="el-icon--right"><ArrowRight /></el-icon>
        </el-button>
        <div class="hero-stats">
          <div class="stat-item">
            <span class="stat-number neon-text-cyan">1000+</span>
            <span class="stat-label">保险产品</span>
          </div>
          <div class="stat-item">
            <span class="stat-number neon-text-purple">50+</span>
            <span class="stat-label">保险公司</span>
          </div>
          <div class="stat-item">
            <span class="stat-number neon-text-orange">10万+</span>
            <span class="stat-label">用户信赖</span>
          </div>
        </div>
      </div>
    </section>

    <!-- Product Types -->
    <section class="section product-types">
      <h2 class="section-title">
        <span class="title-decoration"></span>
        三大险种入口
        <span class="title-decoration"></span>
      </h2>
      <div class="type-cards">
        <div
          v-for="type in productTypeList"
          :key="type.value"
          class="type-card"
          :style="{ borderColor: type.color }"
          @click="goToProductList(type.value)"
        >
          <div class="type-icon" :style="{ backgroundColor: type.color + '20', color: type.color, boxShadow: `0 0 20px ${type.color}30` }">
            <el-icon size="32"><component :is="type.icon" /></el-icon>
          </div>
          <h3 class="type-name">{{ type.label }}</h3>
          <p class="type-desc">{{ type.description }}</p>
          <div class="type-features">
            <el-tag v-for="f in type.features" :key="f" size="small" effect="plain">{{ f }}</el-tag>
          </div>
          <el-button :type="getButtonType(type.value)" text>
            查看全部 <el-icon><ArrowRight /></el-icon>
          </el-button>
        </div>
      </div>
    </section>

    <!-- Hot Products -->
    <section class="section hot-products">
      <div class="section-header">
        <h2 class="section-title">
          <span class="title-decoration"></span>
          热门产品推荐
        </h2>
        <el-button text @click="router.push('/product/list')">
          查看更多 <el-icon><ArrowRight /></el-icon>
        </el-button>
      </div>
      <el-carousel :interval="5000" type="card" height="360px" v-if="hotProducts.length > 0" class="hot-carousel">
        <el-carousel-item v-for="product in hotProducts" :key="product.productId">
          <ProductCard
            :product="product"
            :type-label="getTypeLabel(product.productType)"
            :type-color="getTypeColor(product.productType)"
            :is-selected="compareStore.isProductSelected(product.productId)"
            @view-detail="handleViewDetail"
            @toggle-compare="handleToggleCompare"
          />
        </el-carousel-item>
      </el-carousel>
      <el-empty v-else description="暂无热门产品" />
    </section>

    <!-- Features -->
    <section class="section features-section">
      <h2 class="section-title">
        <span class="title-decoration"></span>
        平台优势
        <span class="title-decoration"></span>
      </h2>
      <div class="feature-grid">
        <div class="feature-card">
          <div class="feature-icon cyan">
            <el-icon size="32"><DataAnalysis /></el-icon>
          </div>
          <h3>智能对比</h3>
          <p>多维度产品对比，一目了然</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon green">
            <el-icon size="32"><TrendCharts /></el-icon>
          </div>
          <h3>利益演示</h3>
          <p>精准IRR计算，收益清晰可见</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon orange">
            <el-icon size="32"><Picture /></el-icon>
          </div>
          <h3>卡片生成</h3>
          <p>专业营销卡片，一键分享</p>
        </div>
        <div class="feature-card">
          <div class="feature-icon purple">
            <el-icon size="32"><Lock /></el-icon>
          </div>
          <h3>数据安全</h3>
          <p>银行级加密，保障隐私</p>
        </div>
      </div>
    </section>

    <!-- Compare Floating Bar -->
    <div v-if="compareStore.selectedProductIds.length > 0" class="compare-floating-bar">
      <span>已选择 {{ compareStore.selectedProductIds.length }} 款产品</span>
      <el-button type="primary" :disabled="compareStore.selectedProductIds.length < 2" @click="goToCompare">
        开始对比
      </el-button>
      <el-button text @click="compareStore.clearSelection">清空</el-button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Search, ArrowRight, DataAnalysis, TrendCharts, Picture, FirstAidKit, Money, Calendar, Lock } from '@element-plus/icons-vue'
import { useProduct } from '@/composables/useProduct'
import { useCompareStore } from '@/stores/compareStore'
import ProductCard from '@/components/business/ProductCard.vue'
import type { ProductType } from '@/api/product'

const router = useRouter()
const { hotProducts, fetchHotProducts, fetchProductTypes, getTypeLabel, getTypeColor } = useProduct()
const compareStore = useCompareStore()

const searchKeyword = ref('')

const productTypeList = ref<
  { value: ProductType; label: string; description: string; color: string; icon: unknown; features: string[] }[]
>([
  {
    value: 'critical_illness',
    label: '重疾险',
    description: '覆盖重大疾病，保障健康人生',
    color: '#ff8c00',
    icon: FirstAidKit,
    features: ['重疾保障', '中轻症赔付', '多次赔付']
  },
  {
    value: 'whole_life',
    label: '增额终身寿险',
    description: '终身保障，财富传承',
    color: '#00e5ff',
    icon: Money,
    features: ['保额递增', '现金价值', '灵活减保']
  },
  {
    value: 'annuity',
    label: '年金险',
    description: '稳健收益，养老规划',
    color: '#00ff88',
    icon: Calendar,
    features: ['定期领取', '保证领取', '祝寿金']
  }
])

onMounted(() => {
  fetchHotProducts(8)
  fetchProductTypes()
})

function handleSearch() {
  if (searchKeyword.value.trim()) {
    router.push({
      path: '/product/list',
      query: { keyword: searchKeyword.value }
    })
  }
}

function goToProductList(type?: ProductType) {
  if (type) {
    router.push({ path: '/product/list', query: { type } })
  } else {
    router.push('/product/list')
  }
}

function handleViewDetail(productId: number) {
  router.push(`/product/${productId}`)
}

function handleToggleCompare(productId: number) {
  const success = compareStore.toggleProductSelection(productId)
  if (!success) {
    ElMessage.warning('最多对比5款产品')
  }
}

function goToCompare() {
  router.push({
    path: '/compare',
    query: { ids: compareStore.selectedProductIds.join(',') }
  })
}

function getButtonType(type: ProductType): 'primary' | 'success' | 'warning' | 'danger' | 'info' {
  const map: Record<ProductType, 'primary' | 'success' | 'warning' | 'danger' | 'info'> = {
    critical_illness: 'warning',
    whole_life: 'primary',
    annuity: 'success'
  }
  return map[type] || 'primary'
}
</script>

<style scoped>
.home-page {
  padding-bottom: 40px;
}

/* === Hero Section === */
.hero-section {
  position: relative;
  background: linear-gradient(135deg, rgba(179, 71, 217, 0.15) 0%, rgba(0, 229, 255, 0.08) 50%, rgba(0, 255, 136, 0.05) 100%);
  border-radius: var(--radius-xl);
  padding: 60px 40px;
  margin-bottom: 40px;
  color: var(--text-bright);
  text-align: center;
  border: 1px solid var(--border-color);
  overflow: hidden;
}

.hero-bg-grid {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image:
    linear-gradient(rgba(179, 71, 217, 0.06) 1px, transparent 1px),
    linear-gradient(90deg, rgba(179, 71, 217, 0.06) 1px, transparent 1px);
  background-size: 40px 40px;
  pointer-events: none;
}

/* 霓虹光效装饰 */
.hero-section::before {
  content: '';
  position: absolute;
  top: -100px;
  right: -100px;
  width: 300px;
  height: 300px;
  background: radial-gradient(circle, rgba(179, 71, 217, 0.2) 0%, transparent 70%);
  pointer-events: none;
}

.hero-section::after {
  content: '';
  position: absolute;
  bottom: -100px;
  left: -100px;
  width: 300px;
  height: 300px;
  background: radial-gradient(circle, rgba(0, 229, 255, 0.15) 0%, transparent 70%);
  pointer-events: none;
}

.hero-content {
  position: relative;
  z-index: 1;
}

.hero-title {
  font-size: 42px;
  font-weight: 700;
  margin-bottom: 12px;
  background: var(--gradient-main);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  font-family: var(--font-family-display);
  letter-spacing: 4px;
  text-shadow: none;
}

.hero-subtitle {
  font-size: 18px;
  color: var(--text-secondary);
  margin-bottom: 32px;
  letter-spacing: 4px;
}

.hero-search {
  max-width: 600px;
  margin: 0 auto 24px;
}

.hero-search :deep(.el-input__wrapper) {
  border-radius: var(--radius-md) 0 0 var(--radius-md);
}

.hero-search :deep(.el-input-group__append) {
  border-radius: 0 var(--radius-md) var(--radius-md) 0;
  background-color: var(--bg-card);
  padding: 0;
}

.hero-search :deep(.el-input-group__append .el-button) {
  border-radius: 0 var(--radius-md) var(--radius-md) 0;
  margin: 0;
  height: 100%;
}

.start-btn {
  margin-bottom: 32px;
  font-size: 16px;
  padding: 12px 32px;
}

.hero-stats {
  display: flex;
  justify-content: center;
  gap: 60px;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.stat-number {
  font-size: 28px;
  font-weight: 700;
  font-family: var(--font-family-display);
}

.stat-label {
  font-size: 14px;
  color: var(--text-secondary);
}

/* === Section === */
.section {
  margin-bottom: 40px;
}

.section-title {
  font-size: 24px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 24px;
  display: flex;
  align-items: center;
  gap: 12px;
}

.title-decoration {
  display: inline-block;
  width: 30px;
  height: 2px;
  background: var(--gradient-main);
  box-shadow: 0 0 8px rgba(179, 71, 217, 0.4);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

/* === Type Cards === */
.type-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.type-card {
  background: var(--bg-card);
  border-radius: var(--radius-lg);
  padding: 32px;
  text-align: center;
  border: 1px solid var(--border-color);
  cursor: pointer;
  transition: all var(--transition-normal);
  position: relative;
  overflow: hidden;
}

.type-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: var(--gradient-main);
  opacity: 0;
  transition: opacity var(--transition-normal);
}

.type-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-card-hover), var(--shadow-neon-purple);
  border-color: var(--border-glow);
}

.type-card:hover::before {
  opacity: 1;
}

.type-icon {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 16px;
  transition: all var(--transition-normal);
}

.type-card:hover .type-icon {
  transform: scale(1.1);
}

.type-name {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 8px;
}

.type-desc {
  font-size: 14px;
  color: var(--text-secondary);
  margin-bottom: 12px;
}

.type-features {
  display: flex;
  justify-content: center;
  gap: 8px;
  margin-bottom: 16px;
  flex-wrap: wrap;
}

/* === Hot Products === */
.hot-products .el-col {
  margin-bottom: 20px;
}

.hot-carousel :deep(.el-carousel__item) {
  padding: 0 10px;
}

/* === Feature Grid === */
.feature-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.feature-card {
  background: var(--bg-card);
  border-radius: var(--radius-lg);
  padding: 32px;
  text-align: center;
  border: 1px solid var(--border-color);
  transition: all var(--transition-normal);
}

.feature-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-card-hover);
  border-color: var(--border-glow);
}

.feature-icon {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 16px;
  color: #fff;
}

.feature-icon.cyan {
  background: linear-gradient(135deg, #00e5ff, #0088aa);
  box-shadow: var(--shadow-neon-cyan);
}

.feature-icon.green {
  background: linear-gradient(135deg, #00ff88, #00aa55);
  box-shadow: var(--shadow-neon-green);
}

.feature-icon.orange {
  background: linear-gradient(135deg, #ff8c00, #cc6600);
  box-shadow: var(--shadow-neon-orange);
}

.feature-icon.purple {
  background: linear-gradient(135deg, #b347d9, #8822aa);
  box-shadow: var(--shadow-neon-purple);
}

.feature-card h3 {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 8px;
}

.feature-card p {
  font-size: 14px;
  color: var(--text-secondary);
}

/* === Compare Floating Bar === */
.compare-floating-bar {
  position: fixed;
  bottom: 24px;
  left: 50%;
  transform: translateX(-50%);
  background: var(--bg-card);
  padding: 12px 24px;
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-card-hover), var(--shadow-neon-purple);
  display: flex;
  align-items: center;
  gap: 16px;
  z-index: 200;
  border: 1px solid var(--border-glow);
  color: var(--text-primary);
}

/* === Responsive === */
@media (max-width: 992px) {
  .type-cards {
    grid-template-columns: repeat(2, 1fr);
  }
  .feature-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .hero-title {
    font-size: 28px;
  }
  .hero-stats {
    gap: 24px;
  }
  .type-cards {
    grid-template-columns: 1fr;
  }
  .feature-grid {
    grid-template-columns: 1fr;
  }
}
</style>
