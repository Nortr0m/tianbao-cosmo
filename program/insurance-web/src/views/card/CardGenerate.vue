<template>
  <div class="card-generate-page">
    <div class="page-header">
      <div class="page-header-left">
        <h1 class="page-title">营销卡片生成</h1>
        <p class="page-desc">一键生成精美保险营销卡片，助力高效获客</p>
      </div>
      <div class="page-header-right">
        <el-button @click="goToHistory">
          <el-icon><History /></el-icon>
          历史记录
        </el-button>
      </div>
    </div>

    <el-row :gutter="24">
      <!-- Left: Settings -->
      <el-col :span="10">
        <el-card class="settings-card tb-card-enhanced">
          <template #header>
            <div class="card-header-title">
              <el-icon><Setting /></el-icon>
              <span>卡片设置</span>
            </div>
          </template>

          <el-form :model="cardForm" label-position="top" class="settings-form">
            <el-form-item label="选择产品">
              <el-select v-model="cardForm.productId" placeholder="请选择产品" filterable style="width: 100%">
                <el-option
                  v-for="product in productList"
                  :key="product.productId"
                  :label="product.productName"
                  :value="product.productId"
                />
              </el-select>
            </el-form-item>

            <el-form-item label="选择模板">
              <div class="template-grid">
                <div
                  v-for="template in templates"
                  :key="template.id"
                  class="template-item"
                  :class="{ active: cardForm.templateId === template.id, premium: template.isPremium && !isVip }"
                  @click="selectTemplate(template)"
                >
                  <div class="template-preview">
                    <img :src="template.backgroundImage" :alt="template.name" />
                    <div v-if="template.isPremium" class="template-premium-badge">
                      <el-icon><Star /></el-icon>
                    </div>
                  </div>
                  <span class="template-name">{{ template.name }}</span>
                </div>
              </div>
            </el-form-item>

            <el-row :gutter="16">
              <el-col :span="12">
                <el-form-item label="年龄">
                  <el-input-number v-model="cardForm.age" :min="0" :max="70" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="性别">
                  <el-radio-group v-model="cardForm.gender">
                    <el-radio-button value="male">男</el-radio-button>
                    <el-radio-button value="female">女</el-radio-button>
                  </el-radio-group>
                </el-form-item>
              </el-col>
            </el-row>

            <el-row :gutter="16">
              <el-col :span="12">
                <el-form-item label="缴费期限">
                  <el-select v-model="cardForm.paymentPeriod" style="width: 100%">
                    <el-option label="趸交" value="趸交" />
                    <el-option label="3年" value="3年" />
                    <el-option label="5年" value="5年" />
                    <el-option label="10年" value="10年" />
                    <el-option label="20年" value="20年" />
                    <el-option label="30年" value="30年" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="保额">
                  <el-input-number v-model="cardForm.coverage" :min="10000" :step="10000" style="width: 100%" />
                </el-form-item>
              </el-col>
            </el-row>

            <el-form-item label="年缴保费">
              <el-input-number v-model="cardForm.premium" :min="1000" :step="1000" style="width: 100%" />
            </el-form-item>

            <el-form-item label="水印文字" v-if="canUseWatermark">
              <el-input v-model="cardForm.customizations.watermark" placeholder="请输入水印文字" clearable />
            </el-form-item>

            <el-form-item>
              <el-button type="primary" size="large" :loading="generating" @click="handleGenerate" class="generate-btn">
                <el-icon><MagicStick /></el-icon>
                生成卡片
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>

      <!-- Right: Preview -->
      <el-col :span="14">
        <el-card class="preview-card tb-card-enhanced">
          <template #header>
            <div class="card-header-title">
              <el-icon><View /></el-icon>
              <span>实时预览</span>
            </div>
          </template>
          <div v-if="generatedCard" class="preview-area">
            <div class="preview-frame">
              <img :src="generatedCard.imageUrl" alt="生成的卡片" class="card-preview" />
              <div class="preview-shine"></div>
            </div>
            <div class="preview-actions">
              <el-button type="primary" size="large" @click="downloadCard" class="action-btn">
                <el-icon><Download /></el-icon>下载图片
              </el-button>
              <el-button size="large" @click="copyShareLink" class="action-btn">
                <el-icon><Link /></el-icon>复制链接
              </el-button>
            </div>
          </div>
          <div v-else class="empty-preview">
            <div class="empty-preview-icon">
              <el-icon :size="48"><Picture /></el-icon>
            </div>
            <p class="empty-preview-title">卡片预览</p>
            <p class="empty-preview-desc">设置左侧参数，点击生成按钮查看效果</p>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Download, Link, Setting, View, MagicStick, Star, Picture, History } from '@element-plus/icons-vue'
import { useProductStore } from '@/stores/productStore'
import { usePermission } from '@/composables/usePermission'
import { getCardTemplates, generateCard } from '@/api/card'
import type { CardTemplate, CardGenerateResult } from '@/api/card'

const route = useRoute()
const router = useRouter()
const productStore = useProductStore()
const { isVip, canUseWatermark } = usePermission()

const templates = ref<CardTemplate[]>([])
const generating = ref(false)
const generatedCard = ref<CardGenerateResult | null>(null)

const cardForm = ref({
  productId: Number(route.query.productId) || undefined as number | undefined,
  templateId: 1,
  age: 30,
  gender: 'male' as 'male' | 'female',
  paymentPeriod: '20年',
  coverage: 500000,
  premium: 10000,
  customizations: {
    watermark: '',
    showLogo: true,
    showQrCode: true
  }
})

const productList = ref(productStore.productList)

onMounted(async () => {
  if (productStore.productList.length === 0) {
    await productStore.fetchProducts({ pageSize: 100 })
    productList.value = productStore.productList
  }
  await loadTemplates()
})

async function loadTemplates() {
  try {
    const res = await getCardTemplates()
    templates.value = res
    if (res.length > 0 && !cardForm.value.templateId) {
      cardForm.value.templateId = res[0].id
    }
  } catch {
    templates.value = []
  }
}

function selectTemplate(template: CardTemplate) {
  if (template.isPremium && !isVip.value) {
    ElMessage.warning('该模板为VIP专属，请先开通VIP')
    return
  }
  cardForm.value.templateId = template.id
}

async function handleGenerate() {
  if (!cardForm.value.productId) {
    ElMessage.warning('请选择产品')
    return
  }
  generating.value = true
  try {
    const result = await generateCard({
      productId: cardForm.value.productId,
      templateId: cardForm.value.templateId,
      age: cardForm.value.age,
      gender: cardForm.value.gender,
      paymentPeriod: cardForm.value.paymentPeriod,
      coverage: cardForm.value.coverage,
      premium: cardForm.value.premium,
      watermark: cardForm.value.customizations.watermark || undefined,
      customParams: {
        showLogo: cardForm.value.customizations.showLogo,
        showQrCode: cardForm.value.customizations.showQrCode
      }
    })
    generatedCard.value = result
    ElMessage.success('卡片生成成功')
  } catch {
    ElMessage.error('生成失败')
  } finally {
    generating.value = false
  }
}

function downloadCard() {
  if (!generatedCard.value) return
  const link = document.createElement('a')
  link.href = generatedCard.value.imageUrl
  link.download = `保险卡片_${generatedCard.value.recordId || Date.now()}.png`
  link.click()
}

function copyShareLink() {
  if (!generatedCard.value) return
  const shareUrl = `${window.location.origin}/card/generate?recordId=${generatedCard.value.recordId}`
  navigator.clipboard.writeText(shareUrl).then(() => {
    ElMessage.success('链接已复制')
  })
}

function goToHistory() {
  router.push('/card/history')
}
</script>

<style scoped>
.card-generate-page {
  padding-bottom: 40px;
}

/* 页面头部 */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.page-header-left {
  flex: 1;
}

.page-title {
  font-size: 26px;
  font-weight: 700;
  margin: 0 0 6px;
  color: var(--text-primary);
  display: flex;
  align-items: center;
  gap: 12px;
}

.page-title::before {
  content: '';
  display: inline-block;
  width: 4px;
  height: 24px;
  background: var(--gradient-main);
  border-radius: 2px;
  box-shadow: 0 0 8px rgba(139, 92, 246, 0.5);
}

.page-desc {
  font-size: 14px;
  color: var(--text-secondary);
  margin: 0;
  padding-left: 16px;
}

/* 卡片头部标题 */
.card-header-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  font-size: 16px;
  color: var(--text-primary);
}

.card-header-title .el-icon {
  color: var(--accent-purple);
}

/* 设置表单 */
.settings-form {
  max-height: 600px;
  overflow-y: auto;
  padding-right: 8px;
}

.settings-form::-webkit-scrollbar {
  width: 4px;
}

.settings-form::-webkit-scrollbar-thumb {
  background: var(--border-color);
  border-radius: 2px;
}

/* 模板网格 */
.template-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}

.template-item {
  border: 2px solid var(--border-color);
  border-radius: var(--radius-md);
  overflow: hidden;
  cursor: pointer;
  position: relative;
  transition: all var(--transition-normal);
  background: var(--bg-secondary);
}

.template-item:hover {
  border-color: var(--accent-purple);
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(139, 92, 246, 0.2);
}

.template-item.active {
  border-color: var(--accent-purple);
  box-shadow: 0 0 0 2px rgba(139, 92, 246, 0.2), 0 4px 16px rgba(139, 92, 246, 0.25);
}

.template-item.premium {
  opacity: 0.6;
  cursor: not-allowed;
}

.template-preview {
  position: relative;
  width: 100%;
  height: 90px;
  overflow: hidden;
}

.template-preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.template-premium-badge {
  position: absolute;
  top: 6px;
  right: 6px;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: var(--gradient-gold);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  box-shadow: 0 2px 8px rgba(251, 191, 36, 0.4);
}

.template-name {
  display: block;
  padding: 8px;
  font-size: 12px;
  text-align: center;
  color: var(--text-secondary);
  font-weight: 500;
}

.template-item.active .template-name {
  color: var(--accent-purple);
  font-weight: 600;
}

/* 生成按钮 */
.generate-btn {
  width: 100%;
  padding: 14px 24px;
  font-size: 16px;
  font-weight: 600;
}

/* 预览区域 */
.preview-card :deep(.el-card__body) {
  display: flex;
  flex-direction: column;
}

.preview-area {
  text-align: center;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.preview-frame {
  position: relative;
  display: inline-block;
  margin: 0 auto 20px;
  border-radius: var(--radius-lg);
  overflow: hidden;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
}

.preview-frame::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  border: 2px solid rgba(139, 92, 246, 0.3);
  border-radius: var(--radius-lg);
  pointer-events: none;
  z-index: 1;
}

.preview-shine {
  position: absolute;
  top: 0;
  left: -100%;
  width: 50%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.15), transparent);
  animation: shine 3s ease-in-out infinite;
  pointer-events: none;
}

@keyframes shine {
  0% { left: -100%; }
  50%, 100% { left: 150%; }
}

.card-preview {
  max-width: 100%;
  max-height: 420px;
  display: block;
}

.preview-actions {
  display: flex;
  justify-content: center;
  gap: 16px;
  margin-top: auto;
  padding-top: 20px;
  border-top: 1px solid var(--border-color);
}

.action-btn {
  min-width: 140px;
}

/* 空预览状态 */
.empty-preview {
  padding: 60px 20px;
  text-align: center;
  color: var(--text-muted);
}

.empty-preview-icon {
  width: 80px;
  height: 80px;
  margin: 0 auto 20px;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(99, 102, 241, 0.1), rgba(6, 182, 212, 0.08));
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--accent-purple);
}

.empty-preview-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-secondary);
  margin: 0 0 8px;
}

.empty-preview-desc {
  font-size: 14px;
  color: var(--text-muted);
  margin: 0;
}

/* 响应式 */
@media (max-width: 1200px) {
  .template-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}
</style>
