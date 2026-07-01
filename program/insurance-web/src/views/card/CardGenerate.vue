<template>
  <div class="card-generate-page">
    <h1 class="page-title">营销卡片生成</h1>

    <el-row :gutter="24">
      <!-- Left: Settings -->
      <el-col :span="10">
        <el-card>
          <template #header>
            <span>卡片设置</span>
          </template>

          <el-form :model="cardForm" label-position="top">
            <el-form-item label="选择产品">
              <el-select v-model="cardForm.productId" placeholder="请选择产品" filterable>
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
                  <img :src="template.backgroundImage" :alt="template.name" />
                  <span class="template-name">{{ template.name }}</span>
                  <el-tag v-if="template.isPremium" size="small" type="warning">VIP</el-tag>
                </div>
              </div>
            </el-form-item>

            <el-form-item label="年龄">
              <el-input-number v-model="cardForm.age" :min="0" :max="70" />
            </el-form-item>

            <el-form-item label="性别">
              <el-radio-group v-model="cardForm.gender">
                <el-radio-button label="male">男</el-radio-button>
                <el-radio-button label="female">女</el-radio-button>
              </el-radio-group>
            </el-form-item>

            <el-form-item label="缴费期限">
              <el-select v-model="cardForm.paymentPeriod">
                <el-option label="趸交" value="趸交" />
                <el-option label="3年" value="3年" />
                <el-option label="5年" value="5年" />
                <el-option label="10年" value="10年" />
                <el-option label="20年" value="20年" />
                <el-option label="30年" value="30年" />
              </el-select>
            </el-form-item>

            <el-form-item label="保额">
              <el-input-number v-model="cardForm.coverage" :min="10000" :step="10000" />
            </el-form-item>

            <el-form-item label="年缴保费">
              <el-input-number v-model="cardForm.premium" :min="1000" :step="1000" />
            </el-form-item>

            <el-form-item label="水印文字" v-if="canUseWatermark">
              <el-input v-model="cardForm.customizations.watermark" placeholder="请输入水印文字" />
            </el-form-item>

            <el-form-item>
              <el-button type="primary" :loading="generating" @click="handleGenerate">
                生成卡片
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>

      <!-- Right: Preview -->
      <el-col :span="14">
        <el-card>
          <template #header>
            <span>预览</span>
          </template>
          <div v-if="generatedCard" class="preview-area">
            <img :src="generatedCard.imageUrl" alt="生成的卡片" class="card-preview" />
            <div class="preview-actions">
              <el-button type="primary" @click="downloadCard">
                <el-icon><Download /></el-icon>下载图片
              </el-button>
              <el-button @click="copyShareLink">
                <el-icon><Link /></el-icon>复制链接
              </el-button>
            </div>
          </div>
          <el-empty v-else description="请设置参数并生成卡片" />
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Download, Link } from '@element-plus/icons-vue'
import { useProductStore } from '@/stores/productStore'
import { usePermission } from '@/composables/usePermission'
import { getCardTemplates, generateCard } from '@/api/card'
import type { CardTemplate, CardGenerateResult } from '@/api/card'

const route = useRoute()
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
      customizations: {
        watermark: cardForm.value.customizations.watermark || undefined,
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
  link.download = `保险卡片_${Date.now()}.png`
  link.click()
}

function copyShareLink() {
  if (!generatedCard.value) return
  navigator.clipboard.writeText(generatedCard.value.shareUrl).then(() => {
    ElMessage.success('链接已复制')
  })
}
</script>

<style scoped>
.card-generate-page {
  padding-bottom: 24px;
}

.page-title {
  font-size: 24px;
  font-weight: 600;
  margin-bottom: 20px;
}

.template-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}

.template-item {
  border: 2px solid #ebeef5;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  position: relative;
  transition: all 0.3s;
}

.template-item:hover {
  border-color: #409eff;
}

.template-item.active {
  border-color: #409eff;
  box-shadow: 0 0 0 2px #409eff33;
}

.template-item.premium {
  opacity: 0.6;
  cursor: not-allowed;
}

.template-item img {
  width: 100%;
  height: 80px;
  object-fit: cover;
}

.template-name {
  display: block;
  padding: 6px;
  font-size: 12px;
  text-align: center;
}

.template-item .el-tag {
  position: absolute;
  top: 4px;
  right: 4px;
}

.preview-area {
  text-align: center;
}

.card-preview {
  max-width: 100%;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  margin-bottom: 16px;
}

.preview-actions {
  display: flex;
  justify-content: center;
  gap: 12px;
}
</style>
