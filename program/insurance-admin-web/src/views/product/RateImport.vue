<template>
  <div class="rate-import-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>{{ isWholeLife ? '现金价值导入' : '费率导入' }}</span>
          <el-tag v-if="isWholeLife" type="warning" size="small">增额终身寿险</el-tag>
          <el-tag v-else type="primary" size="small">重疾险</el-tag>
        </div>
      </template>

      <el-steps :active="activeStep" finish-status="success" simple>
        <el-step title="选择产品" />
        <el-step title="上传文件" />
        <el-step title="导入完成" />
      </el-steps>

      <div class="step-content">
        <!-- 步骤1：选择产品 -->
        <div v-if="activeStep === 0" class="step-panel">
          <el-form label-width="120px">
            <el-form-item label="选择产品">
              <el-select v-model="selectedProductId" placeholder="请选择要导入费率的产品" style="width: 400px">
                <el-option
                  v-for="item in productOptions"
                  :key="item.id"
                  :label="item.name"
                  :value="item.id"
                />
              </el-select>
            </el-form-item>
          </el-form>
          <div class="step-actions">
            <el-button type="primary" :disabled="!selectedProductId" @click="activeStep = 1">
              下一步
            </el-button>
          </div>
        </div>

        <!-- 步骤2：上传文件 -->
        <div v-if="activeStep === 1" class="step-panel">
          <el-alert
            v-if="isWholeLife"
            title="请上传 Excel 格式的现金价值表文件，文件需包含以下列：性别（0-女/1-男）、投保年龄、缴费年限、保单年度、现金价值（每千元保费对应）、身故保险金"
            type="info"
            :closable="false"
            style="margin-bottom: 16px"
          />
          <el-alert
            v-else
            title="请上传 Excel 格式的费率表文件，文件需包含以下列：年龄、性别、保费、保额、缴费期限"
            type="info"
            :closable="false"
            style="margin-bottom: 16px"
          />
          <el-upload
            drag
            action="#"
            :auto-upload="false"
            :on-change="handleFileChange"
            :limit="1"
            accept=".xlsx,.xls,.pdf"
            class="upload-area"
          >
            <el-icon class="el-icon--upload"><Upload /></el-icon>
            <div class="el-upload__text">
              拖拽文件到此处或 <em>点击上传</em>
            </div>
            <template #tip>
              <div class="el-upload__tip">
                支持 Excel(.xlsx/.xls) 或 PDF(.pdf) 格式，文件大小不超过10MB
              </div>
              <div class="el-upload__tip">
                系统会自动检测表格格式（宽表/长表），宽表会自动转换为长表导入
              </div>
            </template>
          </el-upload>
          <div class="step-actions">
            <el-button @click="activeStep = 0">上一步</el-button>
            <el-button type="primary" :loading="importing" :disabled="!uploadFile" @click="handleImport">
              开始导入
            </el-button>
          </div>
        </div>

        <!-- 步骤3：导入完成 -->
        <div v-if="activeStep === 2" class="step-panel">
          <el-result icon="success" title="导入成功" :sub-title="isWholeLife ? '现金价值数据已成功导入系统' : '费率数据已成功导入系统'">
            <template #extra>
              <el-button type="primary" @click="resetImport">继续导入</el-button>
              <el-button @click="goBack">返回列表</el-button>
            </template>
          </el-result>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Upload } from '@element-plus/icons-vue'
import { importRates, getProductList } from '@/api/product'
import type { Product } from '@/api/product'
import type { UploadFile } from 'element-plus'

const router = useRouter()
const route = useRoute()
const productType = Number(route.query.type) || 1
const isWholeLife = productType === 2

const activeStep = ref(0)
const selectedProductId = ref<number | undefined>(undefined)
const productOptions = ref<Product[]>([])
const uploadFile = ref<File | null>(null)
const importing = ref(false)

async function loadProducts() {
  try {
    const res = await getProductList({ page: 1, size: 100, productType: productType })
    productOptions.value = res.list
  } catch {
    // 错误已在拦截器中处理
  }
}

function handleFileChange(file: UploadFile) {
  uploadFile.value = file.raw || null
}

async function handleImport() {
  if (!selectedProductId.value || !uploadFile.value) return
  importing.value = true
  try {
    await importRates(selectedProductId.value, uploadFile.value)
    ElMessage.success('导入成功')
    activeStep.value = 2
  } finally {
    importing.value = false
  }
}

function resetImport() {
  activeStep.value = 0
  selectedProductId.value = undefined
  uploadFile.value = null
}

function goBack() {
  router.push(isWholeLife ? '/product/whole-life' : '/product/critical')
}

onMounted(() => {
  loadProducts()
})
</script>

<style scoped>
.card-header {
  font-weight: 500;
}

.step-content {
  margin-top: 32px;
}

.step-panel {
  padding: 24px;
}

.step-actions {
  margin-top: 24px;
  text-align: center;
}

.upload-area {
  max-width: 600px;
  margin: 0 auto;
}
</style>
