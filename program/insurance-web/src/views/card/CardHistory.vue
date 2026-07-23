<template>
  <div class="card-history-page">
    <div class="page-header">
      <div class="page-header-left">
        <h1 class="page-title">卡片生成历史</h1>
        <p class="page-desc">查看和管理您生成过的所有营销卡片</p>
      </div>
      <div class="page-header-right">
        <el-button type="primary" @click="goToGenerate">
          <el-icon><MagicStick /></el-icon>
          生成新卡片
        </el-button>
      </div>
    </div>

    <!-- 加载状态 -->
    <div v-loading="loading" element-loading-text="加载中..." class="history-content">
      <!-- 卡片网格 -->
      <div v-if="historyList.length > 0" class="card-grid">
        <div
          v-for="record in historyList"
          :key="record.recordId"
          class="history-card tb-card-enhanced"
        >
          <div class="card-image-wrapper" @click="viewLargeImage(record)">
            <img :src="record.generatedImageUrl" :alt="record.cardTitle" class="card-image" />
            <div class="card-image-overlay">
              <el-icon :size="32"><ZoomIn /></el-icon>
              <span>查看大图</span>
            </div>
          </div>
          <div class="card-info">
            <h3 class="card-title" :title="record.cardTitle">{{ record.cardTitle }}</h3>
            <p class="card-subtitle" :title="record.cardSubtitle">{{ record.cardSubtitle }}</p>
            <div class="card-meta">
              <span class="meta-item">
                <el-icon><Clock /></el-icon>
                {{ formatTime(record.generateTime) }}
              </span>
            </div>
            <div class="card-actions">
              <el-button type="primary" size="small" @click="viewLargeImage(record)">
                <el-icon><ZoomIn /></el-icon>
                查看
              </el-button>
              <el-button size="small" @click="downloadCard(record)">
                <el-icon><Download /></el-icon>
                下载
              </el-button>
              <el-button type="danger" size="small" @click="handleDelete(record)">
                <el-icon><Delete /></el-icon>
                删除
              </el-button>
            </div>
          </div>
        </div>
      </div>

      <!-- 空状态 -->
      <div v-else-if="!loading" class="empty-state">
        <div class="empty-icon">
          <el-icon :size="64"><Picture /></el-icon>
        </div>
        <h3 class="empty-title">暂无历史记录</h3>
        <p class="empty-desc">您还没有生成过任何卡片，快去生成第一张吧</p>
        <el-button type="primary" size="large" @click="goToGenerate">
          <el-icon><MagicStick /></el-icon>
          立即生成
        </el-button>
      </div>
    </div>

    <!-- 分页 -->
    <div v-if="total > 0" class="pagination-wrapper">
      <BasePagination
        v-model="pageNum"
        v-model:page-size="pageSize"
        :total="total"
        @change="handlePageChange"
      />
    </div>

    <!-- 大图预览对话框 -->
    <el-dialog
      v-model="previewVisible"
      :title="previewRecord?.cardTitle || '卡片预览'"
      width="auto"
      :close-on-click-modal="true"
      class="preview-dialog"
    >
      <div class="preview-image-container">
        <img
          v-if="previewRecord"
          :src="previewRecord.generatedImageUrl"
          :alt="previewRecord.cardTitle"
          class="preview-image"
        />
      </div>
      <template #footer>
        <el-button @click="previewVisible = false">关闭</el-button>
        <el-button type="primary" @click="downloadCard(previewRecord!)">
          <el-icon><Download /></el-icon>
          下载图片
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Download, Delete, MagicStick, Picture, ZoomIn, Clock } from '@element-plus/icons-vue'
import { getCardHistory, deleteCard } from '@/api/card'
import type { CardHistoryRecord } from '@/api/card'
import BasePagination from '@/components/common/BasePagination.vue'

const router = useRouter()

const loading = ref(false)
const historyList = ref<CardHistoryRecord[]>([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(12)

const previewVisible = ref(false)
const previewRecord = ref<CardHistoryRecord | null>(null)

onMounted(() => {
  loadHistory()
})

async function loadHistory() {
  loading.value = true
  try {
    const res = await getCardHistory(pageNum.value, pageSize.value)
    historyList.value = res.list
    total.value = res.total
  } catch {
    historyList.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

function handlePageChange(page: number, size: number) {
  pageNum.value = page
  pageSize.value = size
  loadHistory()
}

function viewLargeImage(record: CardHistoryRecord) {
  previewRecord.value = record
  previewVisible.value = true
}

function downloadCard(record: CardHistoryRecord) {
  const link = document.createElement('a')
  link.href = record.generatedImageUrl
  link.download = `${record.cardTitle}_${record.recordId}.png`
  link.click()
}

async function handleDelete(record: CardHistoryRecord) {
  try {
    await ElMessageBox.confirm(
      `确定要删除卡片"${record.cardTitle}"吗？此操作不可恢复。`,
      '删除确认',
      {
        confirmButtonText: '确定删除',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    await deleteCard(record.recordId)
    ElMessage.success('删除成功')
    // 重新加载列表
    if (historyList.value.length === 1 && pageNum.value > 1) {
      pageNum.value -= 1
    }
    loadHistory()
  } catch {
    // 用户取消删除
  }
}

function goToGenerate() {
  router.push('/card/generate')
}

function formatTime(timeStr: string): string {
  if (!timeStr) return ''
  const date = new Date(timeStr)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hour = String(date.getHours()).padStart(2, '0')
  const minute = String(date.getMinutes()).padStart(2, '0')
  return `${year}-${month}-${day} ${hour}:${minute}`
}
</script>

<style scoped>
.card-history-page {
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

/* 历史内容区 */
.history-content {
  min-height: 400px;
}

/* 卡片网格 */
.card-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.history-card {
  border-radius: var(--radius-lg);
  overflow: hidden;
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  transition: all var(--transition-normal);
}

.history-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(139, 92, 246, 0.15);
  border-color: var(--accent-purple);
}

.card-image-wrapper {
  position: relative;
  width: 100%;
  aspect-ratio: 3 / 4;
  overflow: hidden;
  cursor: pointer;
  background: var(--bg-secondary);
}

.card-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform var(--transition-normal);
}

.history-card:hover .card-image {
  transform: scale(1.05);
}

.card-image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: #fff;
  opacity: 0;
  transition: opacity var(--transition-normal);
}

.card-image-wrapper:hover .card-image-overlay {
  opacity: 1;
}

.card-image-overlay .el-icon {
  font-size: 32px;
}

.card-image-overlay span {
  font-size: 14px;
}

/* 卡片信息 */
.card-info {
  padding: 16px;
}

.card-title {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0 0 6px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.card-subtitle {
  font-size: 13px;
  color: var(--text-secondary);
  margin: 0 0 12px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.card-meta {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--border-color);
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  color: var(--text-muted);
}

.meta-item .el-icon {
  font-size: 14px;
}

.card-actions {
  display: flex;
  gap: 8px;
}

.card-actions .el-button {
  flex: 1;
}

/* 空状态 */
.empty-state {
  padding: 80px 20px;
  text-align: center;
  color: var(--text-muted);
}

.empty-icon {
  width: 100px;
  height: 100px;
  margin: 0 auto 24px;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(99, 102, 241, 0.1), rgba(6, 182, 212, 0.08));
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--accent-purple);
}

.empty-title {
  font-size: 20px;
  font-weight: 600;
  color: var(--text-secondary);
  margin: 0 0 8px;
}

.empty-desc {
  font-size: 14px;
  color: var(--text-muted);
  margin: 0 0 24px;
}

/* 分页 */
.pagination-wrapper {
  margin-top: 24px;
}

/* 大图预览 */
.preview-dialog :deep(.el-dialog__body) {
  padding: 20px;
}

.preview-image-container {
  display: flex;
  justify-content: center;
  align-items: center;
  max-height: 70vh;
  overflow: auto;
}

.preview-image {
  max-width: 100%;
  max-height: 70vh;
  border-radius: var(--radius-md);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);
}

/* 响应式 */
@media (max-width: 1400px) {
  .card-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 1024px) {
  .card-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 640px) {
  .card-grid {
    grid-template-columns: 1fr;
  }

  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
  }
}
</style>
