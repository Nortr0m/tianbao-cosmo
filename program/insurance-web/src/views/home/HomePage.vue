<template>
  <div class="home-page">
    <!-- Hero Section -->
    <section class="hero-section">
      <div class="hero-bg-grid"></div>
      <div class="hero-bg-orbs">
        <div class="orb orb-purple"></div>
        <div class="orb orb-cyan"></div>
        <div class="orb orb-green"></div>
      </div>
      <div class="hero-content">
        <div class="hero-badge">
          <el-icon><Star /></el-icon>
          <span>专业保险对比平台</span>
        </div>
        <h1 class="hero-title">
          <span class="title-main">天保星君</span>
          <span class="title-decor"></span>
        </h1>
        <p class="hero-subtitle">海量产品 · 精准计算 · 智能推荐 · 一键对比</p>
        <div class="hero-search">
          <el-input
            v-model="searchKeyword"
            placeholder="搜索保险产品名称或保险公司"
            size="large"
            clearable
            @keyup.enter="handleSearch"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
            <template #append>
              <el-button type="primary" @click="handleSearch">
                搜索
              </el-button>
            </template>
          </el-input>
        </div>
        <div class="hero-actions">
          <el-button type="primary" size="large" class="start-btn" @click="goToProductList()">
            开始对比
            <el-icon class="el-icon--right"><ArrowRight /></el-icon>
          </el-button>
          <el-button size="large" class="learn-btn" @click="scrollToFeatures">
            了解更多
          </el-button>
        </div>
        <div class="hero-stats">
          <div class="stat-item">
            <div class="stat-icon stat-icon-cyan">
              <el-icon :size="22"><Collection /></el-icon>
            </div>
            <div class="stat-info">
              <span class="stat-number">1200+</span>
              <span class="stat-label">保险产品</span>
            </div>
          </div>
          <div class="stat-divider"></div>
          <div class="stat-item">
            <div class="stat-icon stat-icon-purple">
              <el-icon :size="22"><OfficeBuilding /></el-icon>
            </div>
            <div class="stat-info">
              <span class="stat-number">60+</span>
              <span class="stat-label">保险公司</span>
            </div>
          </div>
          <div class="stat-divider"></div>
          <div class="stat-item">
            <div class="stat-icon stat-icon-green">
              <el-icon :size="22"><User /></el-icon>
            </div>
            <div class="stat-info">
              <span class="stat-number">15万+</span>
              <span class="stat-label">用户信赖</span>
            </div>
          </div>
          <div class="stat-divider"></div>
          <div class="stat-item">
            <div class="stat-icon stat-icon-orange">
              <el-icon :size="22"><DataAnalysis /></el-icon>
            </div>
            <div class="stat-info">
              <span class="stat-number">50万+</span>
              <span class="stat-label">对比次数</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Product Types -->
    <section class="section product-types">
      <div class="section-header">
        <h2 class="section-title">
          <span class="title-decoration"></span>
          险种分类
          <span class="title-decoration"></span>
        </h2>
        <p class="section-subtitle">精选优质保险产品，满足不同保障需求</p>
      </div>
      <div class="type-cards">
        <div
          v-for="type in productTypeList"
          :key="type.value"
          class="type-card"
          :style="{ '--accent-color': type.color }"
          @click="goToProductList(type.value)"
        >
          <div class="type-card-glow"></div>
          <div class="type-icon">
            <el-icon size="36"><component :is="type.icon" /></el-icon>
          </div>
          <h3 class="type-name">{{ type.label }}</h3>
          <p class="type-desc">{{ type.description }}</p>
          <div class="type-features">
            <el-tag v-for="f in type.features" :key="f" size="small" effect="plain">{{ f }}</el-tag>
          </div>
          <div class="type-footer">
            <span class="type-count">{{ type.count }}款产品</span>
            <el-button type="primary" text>
              查看全部 <el-icon><ArrowRight /></el-icon>
            </el-button>
          </div>
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
    <section class="section features-section" id="features-section">
      <div class="section-header center">
        <h2 class="section-title">
          <span class="title-decoration"></span>
          平台优势
          <span class="title-decoration"></span>
        </h2>
        <p class="section-subtitle">专业、智能、安全的保险对比服务</p>
      </div>
      <div class="feature-grid">
        <div class="feature-card">
          <div class="feature-icon cyan">
            <el-icon size="32"><DataAnalysis /></el-icon>
          </div>
          <h3>智能对比</h3>
          <p>多维度产品对比，一目了然，轻松找出最适合的保险方案</p>
          <div class="feature-tag">
            <el-tag size="small" type="info">8大维度</el-tag>
          </div>
        </div>
        <div class="feature-card">
          <div class="feature-icon green">
            <el-icon size="32"><TrendCharts /></el-icon>
          </div>
          <h3>利益演示</h3>
          <p>精准IRR计算，收益清晰可见，长期利益一目了然</p>
          <div class="feature-tag">
            <el-tag size="small" type="success">精准计算</el-tag>
          </div>
        </div>
        <div class="feature-card">
          <div class="feature-icon orange">
            <el-icon size="32"><Picture /></el-icon>
          </div>
          <h3>卡片生成</h3>
          <p>专业营销卡片，一键分享，助力保险顾问高效获客</p>
          <div class="feature-tag">
            <el-tag size="small" type="warning">多种模板</el-tag>
          </div>
        </div>
        <div class="feature-card">
          <div class="feature-icon purple">
            <el-icon size="32"><Lock /></el-icon>
          </div>
          <h3>数据安全</h3>
          <p>银行级加密，保障隐私，您的数据安全有保障</p>
          <div class="feature-tag">
            <el-tag size="small" type="danger">SSL加密</el-tag>
          </div>
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
import { Search, ArrowRight, DataAnalysis, TrendCharts, Picture, FirstAidKit, Money, Calendar, Lock, Star, Collection, OfficeBuilding, User } from '@element-plus/icons-vue'
import { useProduct } from '@/composables/useProduct'
import { useCompareStore } from '@/stores/compareStore'
import ProductCard from '@/components/business/ProductCard.vue'
import type { ProductType } from '@/api/product'

const router = useRouter()
const { hotProducts, fetchHotProducts, fetchProductTypes, getTypeLabel, getTypeColor } = useProduct()
const compareStore = useCompareStore()

const searchKeyword = ref('')

const productTypeList = ref<
  { value: ProductType; label: string; description: string; color: string; icon: unknown; features: string[]; count: number }[]
>([
  {
    value: 'critical_illness',
    label: '重疾险',
    description: '覆盖重大疾病，保障健康人生',
    color: '#f59e0b',
    icon: FirstAidKit,
    features: ['重疾保障', '中轻症赔付', '多次赔付'],
    count: 320
  },
  {
    value: 'whole_life',
    label: '增额终身寿险',
    description: '终身保障，财富传承',
    color: '#6366f1',
    icon: Money,
    features: ['保额递增', '现金价值', '灵活减保'],
    count: 280
  },
  {
    value: 'annuity',
    label: '年金险',
    description: '稳健收益，养老规划',
    color: '#10b981',
    icon: Calendar,
    features: ['定期领取', '保证领取', '祝寿金'],
    count: 240
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
  const product = hotProducts.value.find((p) => p.productId === productId)
  const result = compareStore.toggleProductSelection(productId, product?.productType ?? 0)
  if (!result.success && result.error) {
    ElMessage.warning(result.error)
  }
}

function goToCompare() {
  router.push({
    path: '/compare',
    query: { ids: compareStore.selectedProductIds.join(',') }
  })
}

function scrollToFeatures() {
  const el = document.getElementById('features-section')
  if (el) {
    el.scrollIntoView({ behavior: 'smooth' })
  }
}
</script>

<style scoped>
.home-page {
  padding-bottom: 60px;
}

/* === Hero Section === */
.hero-section {
  position: relative;
  background: var(--gradient-hero);
  border-radius: var(--radius-xl);
  padding: 80px 40px 70px;
  margin-bottom: 60px;
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
    linear-gradient(rgba(99, 102, 241, 0.05) 1px, transparent 1px),
    linear-gradient(90deg, rgba(99, 102, 241, 0.05) 1px, transparent 1px);
  background-size: 40px 40px;
  pointer-events: none;
}

/* 光晕球效果 */
.hero-bg-orbs {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
  overflow: hidden;
}

.orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.4;
  animation: orb-float 8s ease-in-out infinite;
}

.orb-purple {
  width: 300px;
  height: 300px;
  background: #8b5cf6;
  top: -100px;
  right: 10%;
  animation-delay: 0s;
}

.orb-cyan {
  width: 250px;
  height: 250px;
  background: #06b6d4;
  bottom: -80px;
  left: 15%;
  animation-delay: -3s;
}

.orb-green {
  width: 200px;
  height: 200px;
  background: #10b981;
  top: 40%;
  right: 20%;
  animation-delay: -5s;
  opacity: 0.25;
}

@keyframes orb-float {
  0%, 100% { transform: translate(0, 0) scale(1); }
  50% { transform: translate(20px, -20px) scale(1.1); }
}

.hero-content {
  position: relative;
  z-index: 1;
}

/* 顶部徽章 */
.hero-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 16px;
  background: rgba(139, 92, 246, 0.15);
  border: 1px solid rgba(139, 92, 246, 0.3);
  border-radius: 20px;
  font-size: 13px;
  color: var(--accent-purple);
  margin-bottom: 24px;
  font-weight: 500;
}

.hero-badge .el-icon {
  color: var(--accent-gold);
}

.hero-title {
  font-size: 56px;
  font-weight: 800;
  margin-bottom: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 16px;
  font-family: var(--font-family-display);
  letter-spacing: 6px;
}

.title-main {
  background: var(--gradient-main);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  filter: drop-shadow(0 0 30px rgba(139, 92, 246, 0.3));
}

.title-decor {
  display: inline-block;
  width: 80px;
  height: 3px;
  background: var(--gradient-main);
  border-radius: 2px;
  box-shadow: 0 0 12px rgba(139, 92, 246, 0.6);
}

.hero-subtitle {
  font-size: 20px;
  color: var(--text-secondary);
  margin-bottom: 40px;
  letter-spacing: 6px;
  font-weight: 400;
}

.hero-search {
  max-width: 640px;
  margin: 0 auto 28px;
}

.hero-search :deep(.el-input__wrapper) {
  border-radius: var(--radius-lg) 0 0 var(--radius-lg);
  padding-left: 8px;
}

.hero-search :deep(.el-input-group__append) {
  border-radius: 0 var(--radius-lg) var(--radius-lg) 0;
  background-color: var(--bg-card);
  padding: 0;
  border-left: none;
}

.hero-search :deep(.el-input-group__append .el-button) {
  border-radius: 0 var(--radius-lg) var(--radius-lg) 0;
  margin: 0;
  height: 100%;
  padding: 0 28px;
}

.hero-actions {
  display: flex;
  justify-content: center;
  gap: 16px;
  margin-bottom: 48px;
}

.start-btn {
  font-size: 16px;
  padding: 14px 40px;
  font-weight: 600;
}

.learn-btn {
  font-size: 16px;
  padding: 14px 32px;
  background: transparent;
  border: 1px solid var(--border-color);
  color: var(--text-secondary);
  transition: all var(--transition-normal);
}

.learn-btn:hover {
  border-color: var(--accent-cyan);
  color: var(--accent-cyan);
  background: rgba(6, 182, 212, 0.08);
}

/* 统计数据区 */
.hero-stats {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 0;
  padding-top: 32px;
  border-top: 1px solid var(--border-color);
  max-width: 900px;
  margin: 0 auto;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 0 32px;
  flex: 1;
  justify-content: center;
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.stat-icon-cyan {
  background: rgba(6, 182, 212, 0.15);
  color: var(--accent-cyan);
  box-shadow: 0 0 20px rgba(6, 182, 212, 0.2);
}

.stat-icon-purple {
  background: rgba(139, 92, 246, 0.15);
  color: var(--accent-purple);
  box-shadow: 0 0 20px rgba(139, 92, 246, 0.2);
}

.stat-icon-green {
  background: rgba(16, 185, 129, 0.15);
  color: var(--accent-green);
  box-shadow: 0 0 20px rgba(16, 185, 129, 0.2);
}

.stat-icon-orange {
  background: rgba(245, 158, 11, 0.15);
  color: var(--accent-orange);
  box-shadow: 0 0 20px rgba(245, 158, 11, 0.2);
}

.stat-info {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 2px;
}

.stat-number {
  font-size: 26px;
  font-weight: 700;
  font-family: var(--font-family-display);
  color: var(--text-bright);
  line-height: 1.2;
}

.stat-label {
  font-size: 13px;
  color: var(--text-muted);
}

.stat-divider {
  width: 1px;
  height: 40px;
  background: var(--border-color);
}

/* === Section 通用 === */
.section {
  margin-bottom: 60px;
}

.section-header {
  margin-bottom: 32px;
}

.section-header.center {
  text-align: center;
}

.section-title {
  font-size: 26px;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 12px;
}

.section-header.center .section-title {
  justify-content: center;
}

.section-subtitle {
  font-size: 14px;
  color: var(--text-secondary);
  margin: 0;
}

.section-header.center .section-subtitle {
  text-align: center;
}

.title-decoration {
  display: inline-block;
  width: 36px;
  height: 3px;
  background: var(--gradient-main);
  border-radius: 2px;
  box-shadow: 0 0 10px rgba(139, 92, 246, 0.5);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
}

/* === Type Cards === */
.type-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
}

.type-card {
  background: var(--bg-card);
  border-radius: var(--radius-xl);
  padding: 36px 28px;
  text-align: center;
  border: 1px solid var(--border-color);
  cursor: pointer;
  transition: all var(--transition-normal);
  position: relative;
  overflow: hidden;
}

.type-card-glow {
  position: absolute;
  top: -50%;
  left: 50%;
  transform: translateX(-50%);
  width: 200px;
  height: 200px;
  background: radial-gradient(circle, var(--accent-color, var(--accent-purple)) 0%, transparent 70%);
  opacity: 0;
  transition: opacity var(--transition-normal);
  pointer-events: none;
}

.type-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, transparent, var(--accent-color, var(--accent-purple)), transparent);
  opacity: 0;
  transition: opacity var(--transition-normal);
}

.type-card:hover {
  transform: translateY(-6px);
  box-shadow: var(--shadow-card-hover), 0 0 30px color-mix(in srgb, var(--accent-color, var(--accent-purple)) 25%, transparent);
  border-color: color-mix(in srgb, var(--accent-color, var(--accent-purple)) 40%, transparent);
}

.type-card:hover .type-card-glow {
  opacity: 0.15;
}

.type-card:hover::before {
  opacity: 1;
}

.type-icon {
  width: 72px;
  height: 72px;
  border-radius: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 20px;
  transition: all var(--transition-normal);
  background: color-mix(in srgb, var(--accent-color, var(--accent-purple)) 15%, transparent);
  color: var(--accent-color, var(--accent-purple));
  box-shadow: 0 0 24px color-mix(in srgb, var(--accent-color, var(--accent-purple)) 20%, transparent);
}

.type-card:hover .type-icon {
  transform: scale(1.1) rotate(-5deg);
}

.type-name {
  font-size: 20px;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 8px;
}

.type-desc {
  font-size: 14px;
  color: var(--text-secondary);
  margin-bottom: 16px;
  line-height: 1.6;
}

.type-features {
  display: flex;
  justify-content: center;
  gap: 8px;
  margin-bottom: 20px;
  flex-wrap: wrap;
}

.type-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 16px;
  border-top: 1px solid var(--border-color);
}

.type-count {
  font-size: 13px;
  color: var(--text-muted);
}

/* === Hot Products === */
.hot-products .el-col {
  margin-bottom: 20px;
}

.hot-carousel :deep(.el-carousel__item) {
  padding: 0 10px;
}

.hot-carousel :deep(.el-carousel__button) {
  background-color: var(--text-muted) !important;
  opacity: 0.5;
}

.hot-carousel :deep(.el-carousel__indicator.is-active .el-carousel__button) {
  background-color: var(--accent-purple) !important;
  opacity: 1;
  width: 24px;
}

/* === Feature Grid === */
.feature-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 24px;
}

.feature-card {
  background: var(--bg-card);
  border-radius: var(--radius-lg);
  padding: 32px 24px;
  text-align: center;
  border: 1px solid var(--border-color);
  transition: all var(--transition-normal);
  position: relative;
  overflow: hidden;
}

.feature-card::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: var(--gradient-main);
  opacity: 0;
  transition: opacity var(--transition-normal);
  transform: scaleX(0.5);
}

.feature-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-card-hover), var(--shadow-neon-purple);
  border-color: var(--border-glow);
}

.feature-card:hover::after {
  opacity: 1;
  transform: scaleX(1);
}

.feature-icon {
  width: 64px;
  height: 64px;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 18px;
  color: #fff;
  transition: all var(--transition-normal);
}

.feature-card:hover .feature-icon {
  transform: scale(1.1);
}

.feature-icon.cyan {
  background: linear-gradient(135deg, #06b6d4, #0891b2);
  box-shadow: var(--shadow-neon-cyan);
}

.feature-icon.green {
  background: linear-gradient(135deg, #10b981, #059669);
  box-shadow: var(--shadow-neon-green);
}

.feature-icon.orange {
  background: linear-gradient(135deg, #f59e0b, #d97706);
  box-shadow: var(--shadow-neon-orange);
}

.feature-icon.purple {
  background: linear-gradient(135deg, #8b5cf6, #7c3aed);
  box-shadow: var(--shadow-neon-purple);
}

.feature-card h3 {
  font-size: 17px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 8px;
}

.feature-card p {
  font-size: 13px;
  color: var(--text-secondary);
  line-height: 1.6;
  margin-bottom: 14px;
}

.feature-tag {
  display: flex;
  justify-content: center;
}

/* === Compare Floating Bar === */
.compare-floating-bar {
  position: fixed;
  bottom: 24px;
  left: 50%;
  transform: translateX(-50%);
  background: var(--bg-card);
  padding: 12px 24px;
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-card-hover), var(--shadow-neon-purple);
  display: flex;
  align-items: center;
  gap: 16px;
  z-index: 200;
  border: 1px solid var(--border-glow);
  color: var(--text-primary);
  backdrop-filter: blur(20px);
}

/* === Responsive === */
@media (max-width: 1024px) {
  .type-cards {
    grid-template-columns: repeat(2, 1fr);
  }
  .feature-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  .hero-stats {
    flex-wrap: wrap;
    gap: 24px;
  }
  .stat-divider {
    display: none;
  }
  .stat-item {
    flex: 0 0 calc(50% - 12px);
  }
}

@media (max-width: 768px) {
  .hero-section {
    padding: 48px 24px 40px;
    margin-bottom: 40px;
  }
  .hero-title {
    font-size: 36px;
    letter-spacing: 3px;
  }
  .title-decor {
    width: 40px;
  }
  .hero-subtitle {
    font-size: 15px;
    letter-spacing: 2px;
    margin-bottom: 28px;
  }
  .hero-actions {
    flex-direction: column;
    align-items: center;
    margin-bottom: 32px;
  }
  .start-btn,
  .learn-btn {
    width: 100%;
    max-width: 280px;
  }
  .stat-item {
    flex: 0 0 100%;
  }
  .type-cards {
    grid-template-columns: 1fr;
    gap: 16px;
  }
  .feature-grid {
    grid-template-columns: 1fr;
    gap: 16px;
  }
  .section {
    margin-bottom: 40px;
  }
  .section-title {
    font-size: 22px;
  }
}
</style>
