<template>
  <el-dialog
    v-model="visible"
    title="卡片生成器"
    width="960px"
    :close-on-click-modal="false"
    class="card-generator-dialog"
  >
    <el-row :gutter="24">
      <!-- 左侧：配置区 -->
      <el-col :span="12">
        <div class="config-area">
          <h3 class="section-title">卡片配置</h3>

          <el-form :model="config" label-position="top" size="default">
            <!-- 背景图选择 -->
            <el-form-item label="背景图">
              <div class="bg-preview" @click="showBgSelector = true">
                <img
                  v-if="selectedBackground"
                  :src="selectedBackground.url"
                  :alt="selectedBackground.name"
                />
                <div v-else class="bg-placeholder">
                  <el-icon :size="32"><Picture /></el-icon>
                  <span>点击选择背景图</span>
                </div>
              </div>
            </el-form-item>

            <!-- 主标题 -->
            <el-form-item label="主标题">
              <el-input
                v-model="config.title"
                placeholder="请输入主标题"
                maxlength="20"
                show-word-limit
              />
            </el-form-item>

            <!-- 副标题 -->
            <el-form-item label="副标题">
              <el-input
                v-model="config.subtitle"
                placeholder="请输入副标题"
                maxlength="40"
                show-word-limit
              />
            </el-form-item>

            <!-- 产品数据 -->
            <el-form-item label="展示数据">
              <div class="data-fields">
                <div
                  v-for="(field, index) in config.dataFields"
                  :key="index"
                  class="data-field-row"
                >
                  <el-input v-model="field.label" placeholder="标签" size="small" />
                  <el-input v-model="field.value" placeholder="值" size="small" />
                  <el-button
                    type="danger"
                    :icon="Delete"
                    circle
                    size="small"
                    @click="removeDataField(index)"
                  />
                </div>
                <el-button type="primary" link @click="addDataField">
                  <el-icon><Plus /></el-icon>添加数据项
                </el-button>
              </div>
            </el-form-item>

            <!-- 水印配置 -->
            <el-form-item label="水印设置">
              <el-switch
                v-model="config.watermarkEnabled"
                :disabled="!canUseWatermark"
                active-text="开启水印"
              />
              <el-button
                v-if="!canUseWatermark"
                type="primary"
                link
                size="small"
                @click="goToVip"
              >
                开通VIP使用水印
              </el-button>
            </el-form-item>

            <template v-if="config.watermarkEnabled && canUseWatermark">
              <el-form-item label="水印文字">
                <el-input
                  v-model="config.watermarkText"
                  placeholder="请输入水印文字"
                  maxlength="20"
                />
              </el-form-item>

              <template v-if="canCustomizeWatermark">
                <el-form-item label="透明度">
                  <el-slider
                    v-model="config.watermarkOpacity"
                    :min="0.1"
                    :max="0.5"
                    :step="0.05"
                    show-stops
                  />
                </el-form-item>

                <el-form-item label="密度">
                  <el-radio-group v-model="config.watermarkDensity">
                    <el-radio-button label="sparse">稀疏</el-radio-button>
                    <el-radio-button label="medium">适中</el-radio-button>
                    <el-radio-button label="dense">密集</el-radio-button>
                  </el-radio-group>
                </el-form-item>

                <el-form-item label="角度">
                  <el-radio-group v-model="config.watermarkAngle">
                    <el-radio-button :label="30">30°</el-radio-button>
                    <el-radio-button :label="45">45°</el-radio-button>
                    <el-radio-button :label="60">60°</el-radio-button>
                  </el-radio-group>
                </el-form-item>

                <el-form-item label="字体大小">
                  <el-slider
                    v-model="config.watermarkFontSize"
                    :min="12"
                    :max="36"
                    :step="2"
                    show-stops
                  />
                </el-form-item>

                <el-form-item label="颜色">
                  <el-radio-group v-model="config.watermarkColor">
                    <el-radio-button label="black">黑色</el-radio-button>
                    <el-radio-button label="darkgray">深灰</el-radio-button>
                    <el-radio-button label="white">白色</el-radio-button>
                  </el-radio-group>
                </el-form-item>
              </template>

              <el-alert
                v-else
                type="info"
                :closable="false"
                show-icon
                class="watermark-tip"
              >
                开通SVIP可自定义水印样式参数
                <el-button type="primary" link size="small" @click="goToVip">
                  去升级
                </el-button>
              </el-alert>
            </template>

            <!-- 其他选项 -->
            <el-form-item label="其他选项">
              <el-checkbox v-model="config.showLogo">显示Logo</el-checkbox>
              <el-checkbox v-model="config.showQrCode" :disabled="!canUseQrcode">
                显示二维码
              </el-checkbox>
            </el-form-item>
          </el-form>

          <!-- 操作按钮 -->
          <div class="action-buttons">
            <el-button
              type="primary"
              size="large"
              :loading="isExporting"
              @click="handleGenerate"
            >
              <el-icon><View /></el-icon>
              生成预览
            </el-button>
            <el-button
              type="success"
              size="large"
              :loading="isExporting"
              :disabled="!previewUrl"
              @click="handleDownload"
            >
              <el-icon><Download /></el-icon>
              下载高清PNG
            </el-button>
          </div>
        </div>
      </el-col>

      <!-- 右侧：预览区 -->
      <el-col :span="12">
        <div class="preview-area">
          <h3 class="section-title">实时预览</h3>
          <div class="preview-container">
            <div v-if="previewUrl" class="preview-wrapper">
              <img :src="previewUrl" alt="卡片预览" class="preview-image" />
            </div>
            <el-empty v-else description="配置完成后点击生成预览">
              <template #image>
                <el-icon :size="64" color="#dcdfe6"><Picture /></el-icon>
              </template>
            </el-empty>
          </div>
          <div v-if="isExporting" class="progress-bar">
            <el-progress :percentage="exportProgress" :show-text="true" />
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 背景图选择器 -->
    <BackgroundSelector
      v-model="showBgSelector"
      :default-background-id="selectedBackground?.id"
      @select="onBackgroundSelect"
    />
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Picture, Plus, Delete, View, Download } from '@element-plus/icons-vue'
import { usePermission } from '@/composables/usePermission'
import { useCardExport } from '@/composables/useCardExport'
import { useUserStore } from '@/stores/userStore'
import BackgroundSelector from './BackgroundSelector.vue'
import type { BackgroundImage } from './BackgroundSelector.vue'
import type { WatermarkOptions } from '@/utils/watermark'

interface DataField {
  label: string
  value: string
}

interface CardConfig {
  title: string
  subtitle: string
  backgroundImage: string
  dataFields: DataField[]
  watermarkEnabled: boolean
  watermarkText: string
  watermarkOpacity: number
  watermarkDensity: 'sparse' | 'medium' | 'dense'
  watermarkAngle: 30 | 45 | 60
  watermarkFontSize: number
  watermarkColor: 'black' | 'darkgray' | 'white'
  showLogo: boolean
  showQrCode: boolean
}

const props = defineProps<{
  modelValue: boolean
  defaultTitle?: string
  defaultSubtitle?: string
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void
  (e: 'generated', imageUrl: string): void
}>()

const router = useRouter()
const userStore = useUserStore()
const {
  canUseWatermark,
  canCustomizeWatermark,
  canUseQrcode
} = usePermission()
const { isExporting, exportProgress, exportCard, previewCard } = useCardExport()

const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

const showBgSelector = ref(false)
const selectedBackground = ref<BackgroundImage | null>(null)
const previewUrl = ref('')

const config = ref<CardConfig>({
  title: props.defaultTitle || '优选保险产品',
  subtitle: props.defaultSubtitle || '专业对比 安心选择',
  backgroundImage: '',
  dataFields: [
    { label: '保障期限', value: '终身' },
    { label: '年缴保费', value: '¥10,000' }
  ],
  watermarkEnabled: false,
  watermarkText: userStore.username || '保险优选',
  watermarkOpacity: 0.15,
  watermarkDensity: 'medium',
  watermarkAngle: 45,
  watermarkFontSize: 16,
  watermarkColor: 'darkgray',
  showLogo: true,
  showQrCode: false
})

// 构建水印配置
const watermarkConfig = computed((): WatermarkOptions | null => {
  if (!config.value.watermarkEnabled || !canUseWatermark.value) return null
  return {
    text: config.value.watermarkText || '保险优选',
    opacity: config.value.watermarkOpacity,
    density: config.value.watermarkDensity,
    angle: config.value.watermarkAngle,
    fontSize: config.value.watermarkFontSize,
    color: config.value.watermarkColor
  }
})

// 构建产品数据
const productData = computed(() => {
  const data: Record<string, string | number> = {}
  config.value.dataFields.forEach((field) => {
    if (field.label && field.value) {
      data[field.label] = field.value
    }
  })
  return data
})

watch(
  () => props.defaultTitle,
  (val) => {
    if (val) config.value.title = val
  }
)

watch(
  () => props.defaultSubtitle,
  (val) => {
    if (val) config.value.subtitle = val
  }
)

function onBackgroundSelect(bg: BackgroundImage) {
  selectedBackground.value = bg
  config.value.backgroundImage = bg.url
}

function addDataField() {
  config.value.dataFields.push({ label: '', value: '' })
}

function removeDataField(index: number) {
  config.value.dataFields.splice(index, 1)
}

function goToVip() {
  visible.value = false
  router.push('/vip')
}

async function handleGenerate() {
  if (!config.value.backgroundImage) {
    ElMessage.warning('请先选择背景图')
    return
  }

  try {
    const url = await previewCard({
      title: config.value.title,
      subtitle: config.value.subtitle,
      backgroundImage: config.value.backgroundImage,
      watermark: watermarkConfig.value,
      productData: productData.value,
      showLogo: config.value.showLogo,
      showQrCode: config.value.showQrCode
    })
    previewUrl.value = url
    ElMessage.success('预览生成成功')
  } catch {
    ElMessage.error('预览生成失败')
  }
}

async function handleDownload() {
  if (!config.value.backgroundImage) {
    ElMessage.warning('请先选择背景图')
    return
  }

  try {
    const url = await exportCard(
      {
        title: config.value.title,
        subtitle: config.value.subtitle,
        backgroundImage: config.value.backgroundImage,
        watermark: watermarkConfig.value,
        productData: productData.value,
        showLogo: config.value.showLogo,
        showQrCode: config.value.showQrCode
      },
      {
        scale: 2,
        filename: `保险卡片_${config.value.title}_${Date.now()}.png`
      }
    )
    emit('generated', url)
    ElMessage.success('卡片已下载')
  } catch {
    ElMessage.error('下载失败')
  }
}
</script>

<style scoped>
.card-generator-dialog :deep(.el-dialog__body) {
  padding-top: 10px;
}

.section-title {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 16px;
  color: #303133;
}

.config-area {
  max-height: 600px;
  overflow-y: auto;
  padding-right: 8px;
}

.bg-preview {
  width: 100%;
  height: 120px;
  border-radius: 8px;
  border: 2px dashed #dcdfe6;
  cursor: pointer;
  overflow: hidden;
  transition: all 0.3s;
}

.bg-preview:hover {
  border-color: #409eff;
}

.bg-preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.bg-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: #909399;
}

.data-fields {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.data-field-row {
  display: flex;
  gap: 8px;
  align-items: center;
}

.data-field-row .el-input {
  flex: 1;
}

.watermark-tip {
  margin-top: 8px;
}

.action-buttons {
  display: flex;
  gap: 12px;
  margin-top: 24px;
  padding-top: 16px;
  border-top: 1px solid #ebeef5;
}

.action-buttons .el-button {
  flex: 1;
}

.preview-area {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.preview-container {
  flex: 1;
  min-height: 400px;
  background: #f5f7fa;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.preview-wrapper {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

.preview-image {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.progress-bar {
  margin-top: 12px;
}
</style>
