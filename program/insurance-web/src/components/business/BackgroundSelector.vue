<template>
  <el-dialog
    v-model="visible"
    title="选择背景图"
    width="800px"
    :close-on-click-modal="false"
    class="background-selector-dialog"
  >
    <!-- 顶部预览区 -->
    <div class="preview-section">
      <div
        class="preview-image"
        :style="{ backgroundImage: `url(${selectedBackground?.url || ''})` }"
      >
        <div v-if="!selectedBackground" class="preview-placeholder">
          <el-icon :size="48"><Picture /></el-icon>
          <span>请选择背景图</span>
        </div>
        <div v-else class="preview-info">
          <el-tag v-if="selectedBackground.hotTag" :type="getTagType(selectedBackground.hotTag)">
            {{ selectedBackground.hotTag }}
          </el-tag>
          <span class="preview-name">{{ selectedBackground.name }}</span>
        </div>
      </div>
    </div>

    <!-- 分类Tab + 搜索 -->
    <div class="toolbar">
      <div class="category-tabs">
        <el-scrollbar>
          <div class="tab-list">
            <div
              v-for="cat in categories"
              :key="cat.id"
              class="tab-item"
              :class="{ active: activeCategory === cat.id }"
              @click="activeCategory = cat.id"
            >
              {{ cat.name }}
            </div>
          </div>
        </el-scrollbar>
      </div>
      <el-input
        v-model="searchKeyword"
        placeholder="搜索背景名称或标签"
        clearable
        :prefix-icon="Search"
        class="search-input"
      />
    </div>

    <!-- 背景网格列表 -->
    <div class="background-grid">
      <div
        v-for="bg in filteredBackgrounds"
        :key="bg.id"
        class="bg-item"
        :class="{
          active: selectedId === bg.id,
          locked: isLocked(bg)
        }"
        @click="handleSelect(bg)"
      >
        <div class="bg-image-wrapper">
          <img :src="bg.url" :alt="bg.name" loading="lazy" />
          <div v-if="isLocked(bg)" class="lock-overlay">
            <el-icon :size="24"><Lock /></el-icon>
            <span>{{ getLockText(bg) }}</span>
          </div>
          <div v-if="bg.hotTag" class="hot-tag">
            <el-tag size="small" :type="getTagType(bg.hotTag)">
              {{ bg.hotTag }}
            </el-tag>
          </div>
        </div>
        <div class="bg-name">{{ bg.name }}</div>
      </div>
    </div>

    <!-- 空状态 -->
    <el-empty v-if="filteredBackgrounds.length === 0" description="暂无匹配的背景图" />

    <!-- 底部提示 -->
    <div v-if="!canUseAllBackgrounds" class="vip-tip">
      <el-alert type="info" :closable="false">
        <template #title>
          <el-icon><InfoFilled /></el-icon>
          免费用户仅可使用默认模板，开通VIP解锁全部背景图
          <el-button type="primary" link @click="goToVip">去开通</el-button>
        </template>
      </el-alert>
    </div>

    <template #footer>
      <el-button @click="visible = false">取消</el-button>
      <el-button type="primary" :disabled="!selectedId" @click="confirmSelect">
        确认选择
      </el-button>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Picture, Search, Lock, InfoFilled } from '@element-plus/icons-vue'
import { usePermission } from '@/composables/usePermission'

export interface BackgroundImage {
  id: number
  name: string
  url: string
  categoryId: number
  tags: string[]
  hotTag?: '热门' | '推荐' | '新品'
  isPremium: boolean
}

export interface BackgroundCategory {
  id: number
  name: string
}

const props = defineProps<{
  modelValue: boolean
  defaultBackgroundId?: number
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void
  (e: 'select', background: BackgroundImage): void
}>()

const router = useRouter()
const { canUseAllBackgrounds } = usePermission()

const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

// 分类数据（10大分类）
const categories = ref<BackgroundCategory[]>([
  { id: 0, name: '全部' },
  { id: 1, name: '商务简约' },
  { id: 2, name: '自然风光' },
  { id: 3, name: '城市建筑' },
  { id: 4, name: '抽象艺术' },
  { id: 5, name: '渐变色彩' },
  { id: 6, name: '节日主题' },
  { id: 7, name: '理财金融' },
  { id: 8, name: '温馨家庭' },
  { id: 9, name: '科技未来' },
  { id: 10, name: '中国风' }
])

// 模拟背景图数据
const backgrounds = ref<BackgroundImage[]>([
  // 默认免费
  { id: 1, name: '经典深蓝', url: 'https://images.unsplash.com/photo-1557683316-973673baf926?w=400&h=600&fit=crop', categoryId: 1, tags: ['简约', '商务'], hotTag: '推荐', isPremium: false },
  { id: 2, name: '纯白极简', url: 'https://images.unsplash.com/photo-1557682250-33bd709cbe85?w=400&h=600&fit=crop', categoryId: 1, tags: ['简约', '白色'], isPremium: false },
  // 商务简约 - VIP
  { id: 3, name: '金色奢华', url: 'https://images.unsplash.com/photo-1558591710-4b4a1ae0f04d?w=400&h=600&fit=crop', categoryId: 1, tags: ['金色', '奢华'], hotTag: '热门', isPremium: true },
  { id: 4, name: '深灰质感', url: 'https://images.unsplash.com/photo-1557682224-5b8590cd9ec5?w=400&h=600&fit=crop', categoryId: 1, tags: ['灰色', '质感'], isPremium: true },
  { id: 5, name: '墨绿商务', url: 'https://images.unsplash.com/photo-1557682260-96773eb01377?w=400&h=600&fit=crop', categoryId: 1, tags: ['绿色', '商务'], isPremium: true },
  // 自然风光
  { id: 6, name: '日出山峰', url: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=600&fit=crop', categoryId: 2, tags: ['山', '日出'], hotTag: '热门', isPremium: true },
  { id: 7, name: '碧海蓝天', url: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400&h=600&fit=crop', categoryId: 2, tags: ['海', '蓝天'], isPremium: true },
  { id: 8, name: '森林小径', url: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&h=600&fit=crop', categoryId: 2, tags: ['森林', '自然'], isPremium: true },
  { id: 9, name: '樱花盛开', url: 'https://images.unsplash.com/photo-1522383225653-ed111181a951?w=400&h=600&fit=crop', categoryId: 2, tags: ['樱花', '春天'], hotTag: '新品', isPremium: true },
  // 城市建筑
  { id: 10, name: '都市夜景', url: 'https://images.unsplash.com/photo-1519501025264-65ba15a82390?w=400&h=600&fit=crop', categoryId: 3, tags: ['城市', '夜景'], hotTag: '热门', isPremium: true },
  { id: 11, name: '摩天大楼', url: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=400&h=600&fit=crop', categoryId: 3, tags: ['建筑', '高楼'], isPremium: true },
  { id: 12, name: '桥梁风光', url: 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=600&fit=crop', categoryId: 3, tags: ['桥', '风光'], isPremium: true },
  // 抽象艺术
  { id: 13, name: '流体艺术', url: 'https://images.unsplash.com/photo-1541701494587-cb58502866ab?w=400&h=600&fit=crop', categoryId: 4, tags: ['抽象', '流体'], hotTag: '新品', isPremium: true },
  { id: 14, name: '几何图案', url: 'https://images.unsplash.com/photo-1550684848-fac1c5b4e853?w=400&h=600&fit=crop', categoryId: 4, tags: ['几何', '图案'], isPremium: true },
  { id: 15, name: '霓虹光影', url: 'https://images.unsplash.com/photo-1563089145-599997674d42?w=400&h=600&fit=crop', categoryId: 4, tags: ['霓虹', '光影'], isPremium: true },
  // 渐变色彩
  { id: 16, name: '紫粉渐变', url: 'https://images.unsplash.com/photo-1557682250-33bd709cbe85?w=400&h=600&fit=crop', categoryId: 5, tags: ['渐变', '紫粉'], isPremium: true },
  { id: 17, name: '蓝绿渐变', url: 'https://images.unsplash.com/photo-1557683316-973673baf926?w=400&h=600&fit=crop', categoryId: 5, tags: ['渐变', '蓝绿'], isPremium: true },
  { id: 18, name: '橙红渐变', url: 'https://images.unsplash.com/photo-1557682268-e3955ed5d83f?w=400&h=600&fit=crop', categoryId: 5, tags: ['渐变', '橙红'], hotTag: '推荐', isPremium: true },
  // 节日主题
  { id: 19, name: '春节喜庆', url: 'https://images.unsplash.com/photo-1548625361-1f6cdf3a5ce0?w=400&h=600&fit=crop', categoryId: 6, tags: ['春节', '红色'], hotTag: '热门', isPremium: true },
  { id: 20, name: '圣诞温馨', url: 'https://images.unsplash.com/photo-1576692131267-cfcec9ac1ddb?w=400&h=600&fit=crop', categoryId: 6, tags: ['圣诞', '温馨'], isPremium: true },
  // 理财金融
  { id: 21, name: '金币财富', url: 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=400&h=600&fit=crop', categoryId: 7, tags: ['金币', '财富'], isPremium: true },
  { id: 22, name: '数据图表', url: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&h=600&fit=crop', categoryId: 7, tags: ['数据', '图表'], isPremium: true },
  // 温馨家庭
  { id: 23, name: '家庭时光', url: 'https://images.unsplash.com/photo-1511895426328-dc8714191300?w=400&h=600&fit=crop', categoryId: 8, tags: ['家庭', '温馨'], hotTag: '推荐', isPremium: true },
  { id: 24, name: '亲子互动', url: 'https://images.unsplash.com/photo-1609220136736-443140cffec6?w=400&h=600&fit=crop', categoryId: 8, tags: ['亲子', '互动'], isPremium: true },
  // 科技未来
  { id: 25, name: '数字矩阵', url: 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400&h=600&fit=crop', categoryId: 9, tags: ['科技', '数字'], hotTag: '新品', isPremium: true },
  { id: 26, name: '未来城市', url: 'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=400&h=600&fit=crop', categoryId: 9, tags: ['未来', '城市'], isPremium: true },
  // 中国风
  { id: 27, name: '水墨山水', url: 'https://images.unsplash.com/photo-1535063406830-16987365cb2e?w=400&h=600&fit=crop', categoryId: 10, tags: ['水墨', '山水'], hotTag: '热门', isPremium: true },
  { id: 28, name: '红色喜庆', url: 'https://images.unsplash.com/photo-1548625361-1f6cdf3a5ce0?w=400&h=600&fit=crop', categoryId: 10, tags: ['红色', '喜庆'], isPremium: true },
  { id: 29, name: '青花瓷韵', url: 'https://images.unsplash.com/photo-1582739501019-5c4aa6e949d9?w=400&h=600&fit=crop', categoryId: 10, tags: ['青花', '瓷器'], isPremium: true },
  { id: 30, name: '祥云瑞气', url: 'https://images.unsplash.com/photo-1528164344705-47542687000d?w=400&h=600&fit=crop', categoryId: 10, tags: ['祥云', '瑞气'], hotTag: '新品', isPremium: true }
])

const activeCategory = ref(0)
const searchKeyword = ref('')
const selectedId = ref<number | null>(props.defaultBackgroundId ?? null)

const selectedBackground = computed(() =>
  backgrounds.value.find((bg) => bg.id === selectedId.value) || null
)

// 过滤背景图
const filteredBackgrounds = computed(() => {
  let list = backgrounds.value

  // 分类过滤
  if (activeCategory.value !== 0) {
    list = list.filter((bg) => bg.categoryId === activeCategory.value)
  }

  // 搜索过滤
  if (searchKeyword.value.trim()) {
    const kw = searchKeyword.value.trim().toLowerCase()
    list = list.filter(
      (bg) =>
        bg.name.toLowerCase().includes(kw) ||
        bg.tags.some((tag) => tag.toLowerCase().includes(kw))
    )
  }

  // 免费用户只显示默认模板
  if (!canUseAllBackgrounds.value) {
    list = list.filter((bg) => !bg.isPremium)
  }

  return list
})

watch(
  () => props.defaultBackgroundId,
  (id) => {
    if (id) selectedId.value = id
  }
)

function isLocked(bg: BackgroundImage): boolean {
  return bg.isPremium && !canUseAllBackgrounds.value
}

function getLockText(bg: BackgroundImage): string {
  if (!bg.isPremium) return ''
  return 'VIP专属'
}

function getTagType(tag: string): 'info' | 'success' | 'warning' | 'danger' {
  const map: Record<string, 'info' | 'success' | 'warning' | 'danger'> = {
    '热门': 'danger',
    '推荐': 'warning',
    '新品': 'success'
  }
  return map[tag] || 'info'
}

function handleSelect(bg: BackgroundImage) {
  if (isLocked(bg)) {
    ElMessage.warning('该背景为VIP专属，请先开通VIP')
    return
  }
  selectedId.value = bg.id
}

function confirmSelect() {
  if (!selectedBackground.value) return
  emit('select', selectedBackground.value)
  visible.value = false
}

function goToVip() {
  visible.value = false
  router.push('/vip')
}
</script>

<style scoped>
.background-selector-dialog :deep(.el-dialog__body) {
  padding-top: 10px;
}

.preview-section {
  margin-bottom: 16px;
}

.preview-image {
  width: 100%;
  height: 160px;
  border-radius: 12px;
  background-size: cover;
  background-position: center;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  border: 2px solid #ebeef5;
  transition: all 0.3s;
}

.preview-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  color: #909399;
}

.preview-info {
  position: absolute;
  bottom: 12px;
  left: 12px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.preview-name {
  color: #fff;
  font-size: 16px;
  font-weight: 600;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
}

.toolbar {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 16px;
}

.category-tabs {
  flex: 1;
  overflow: hidden;
}

.tab-list {
  display: flex;
  gap: 8px;
  white-space: nowrap;
  padding-bottom: 4px;
}

.tab-item {
  padding: 6px 16px;
  border-radius: 20px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s;
  background: #f5f7fa;
  color: #606266;
  user-select: none;
}

.tab-item:hover {
  background: #ecf5ff;
  color: #409eff;
}

.tab-item.active {
  background: #409eff;
  color: #fff;
}

.search-input {
  width: 200px;
}

.background-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
  max-height: 360px;
  overflow-y: auto;
  padding-right: 4px;
}

.bg-item {
  cursor: pointer;
  border-radius: 8px;
  overflow: hidden;
  border: 2px solid transparent;
  transition: all 0.3s;
}

.bg-item:hover {
  border-color: #c6e2ff;
  transform: translateY(-2px);
}

.bg-item.active {
  border-color: #409eff;
  box-shadow: 0 0 0 2px #409eff33;
}

.bg-item.locked {
  opacity: 0.6;
  cursor: not-allowed;
}

.bg-item.locked:hover {
  transform: none;
  border-color: transparent;
}

.bg-image-wrapper {
  position: relative;
  width: 100%;
  height: 100px;
  overflow: hidden;
}

.bg-image-wrapper img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.lock-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 12px;
  gap: 4px;
}

.hot-tag {
  position: absolute;
  top: 4px;
  right: 4px;
}

.bg-name {
  padding: 8px;
  font-size: 13px;
  text-align: center;
  color: #606266;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.vip-tip {
  margin-top: 16px;
}
</style>
