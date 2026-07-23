<template>
  <div class="product-detail-wrapper">
    <!-- 加载状态 -->
    <el-skeleton v-if="isLoading || !detail" :rows="12" animated class="detail-skeleton">
      <template #template>
        <el-skeleton-item variant="h3" style="width: 50%" />
        <el-skeleton-item variant="text" style="width: 30%" />
        <el-skeleton-item variant="text" style="width: 80%" />
        <el-skeleton-item variant="text" style="width: 60%" />
        <el-skeleton-item variant="p" style="width: 100%" />
      </template>
    </el-skeleton>

    <!-- 错误状态 -->
    <el-empty
      v-else-if="error"
      :description="error"
      class="detail-error"
    >
      <el-button type="primary" @click="handleRetry">重新加载</el-button>
    </el-empty>

    <!-- 详情内容 - 使用异步组件懒加载不同类型的详情页 -->
    <Suspense v-else>
      <template #default>
        <component :is="detailComponent" :product-id="productId" />
      </template>
      <template #fallback>
        <div class="detail-loading">
          <el-icon class="is-loading"><Loading /></el-icon>
          <span>加载中...</span>
        </div>
      </template>
    </Suspense>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch, defineAsyncComponent, markRaw } from 'vue'
import { useRoute } from 'vue-router'
import { Loading } from '@element-plus/icons-vue'
import { useProduct } from '@/composables/useProduct'

const props = defineProps<{
  productId?: number
}>()

const route = useRoute()
const { detail, isLoading, error, fetchDetail, clearDetail } = useProduct()

const resolvedProductId = computed(() => props.productId ?? Number(route.params.id))
const productId = resolvedProductId.value

// 组件加载重试
const componentRetryKey = ref(0)

// 使用 defineAsyncComponent 懒加载详情组件
const CriticalIllnessDetail = defineAsyncComponent({
  loader: () => import('./CriticalIllnessDetail.vue'),
  delay: 200,
  timeout: 10000
})

const WholeLifeDetail = defineAsyncComponent({
  loader: () => import('./WholeLifeDetail.vue'),
  delay: 200,
  timeout: 10000
})

const AnnuityDetail = defineAsyncComponent({
  loader: () => import('./AnnuityDetail.vue'),
  delay: 200,
  timeout: 10000
})

// 组件类型映射 - 使用 markRaw 避免响应式开销
const detailComponentMap = markRaw<Record<number, ReturnType<typeof defineAsyncComponent>>>({
  1: CriticalIllnessDetail,
  2: WholeLifeDetail,
  3: AnnuityDetail,
  4: CriticalIllnessDetail // 健康险暂用重疾险模板
})

// 根据产品类型获取对应组件
const detailComponent = computed(() => {
  const type = detail.value?.productType
  if (!type) return null
  return detailComponentMap[type] || CriticalIllnessDetail
})

// 加载详情
async function loadDetail(id: number) {
  clearDetail()
  try {
    await fetchDetail(id)
  } catch (err) {
    console.error('[ProductDetail] Failed to load:', err)
  }
}

// 重试加载
function handleRetry() {
  componentRetryKey.value++
  loadDetail(productId)
}

onMounted(() => {
  loadDetail(productId)
})

// 监听路由参数变化（同类型产品切换）
watch(
  () => route.params.id,
  (newId) => {
    if (newId) {
      loadDetail(Number(newId))
    }
  }
)
</script>

<style scoped>
.product-detail-wrapper {
  min-height: 400px;
}

.detail-skeleton {
  padding: 20px;
}

.detail-error {
  padding: 60px 0;
}

.detail-loading {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 60px 0;
  gap: 12px;
  color: #909399;
  font-size: 14px;
}

.detail-loading .el-icon {
  font-size: 24px;
  color: #409eff;
}
</style>
