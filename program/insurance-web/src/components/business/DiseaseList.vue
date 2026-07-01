<template>
  <div class="disease-list">
    <div class="search-bar">
      <el-input
        v-model="searchKeyword"
        placeholder="搜索疾病名称"
        clearable
        :prefix-icon="Search"
        style="width: 300px"
      />
      <el-radio-group v-model="activeTab" size="small">
        <el-radio-button label="critical">重疾({{ criticalDiseases.length }})</el-radio-button>
        <el-radio-button label="medium">中症({{ mediumDiseases.length }})</el-radio-button>
        <el-radio-button label="light">轻症({{ lightDiseases.length }})</el-radio-button>
      </el-radio-group>
    </div>

    <el-table
      :data="filteredDiseases"
      :border="true"
      :stripe="true"
      height="500"
      style="width: 100%"
    >
      <el-table-column type="index" label="序号" width="60" align="center" />
      <el-table-column prop="name" label="疾病名称" min-width="200">
        <template #default="{ row }">
          <span :class="{ 'high-risk': row.isHighRisk }">{{ row.name }}</span>
          <el-tag v-if="row.isHighRisk" type="danger" size="small" effect="plain" class="risk-tag">高发</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="category" label="分类" width="120" />
      <el-table-column prop="definition" label="定义摘要" min-width="300">
        <template #default="{ row }">
          <el-tooltip v-if="row.definition" :content="row.definition" placement="top" :show-after="500">
            <span class="definition-text">{{ truncateText(row.definition, 50) }}</span>
          </el-tooltip>
          <span v-else class="no-definition">暂无定义</span>
          <el-tooltip content="该疾病的理赔定义及标准说明" placement="top" :show-after="300">
            <el-icon class="definition-help-icon"><QuestionFilled /></el-icon>
          </el-tooltip>
        </template>
      </el-table-column>
      <el-table-column prop="compensation" label="赔付比例" width="100" align="center">
        <template #default="{ row }">
          <span class="compensation">{{ row.compensation }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="waitingPeriod" label="等待期" width="100" align="center" />
    </el-table>

    <div class="disease-stats">
      <el-descriptions :column="3" border>
        <el-descriptions-item label="重疾数量">{{ criticalDiseases.length }}种</el-descriptions-item>
        <el-descriptions-item label="中症数量">{{ mediumDiseases.length }}种</el-descriptions-item>
        <el-descriptions-item label="轻症数量">{{ lightDiseases.length }}种</el-descriptions-item>
      </el-descriptions>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { Search, QuestionFilled } from '@element-plus/icons-vue'
import { truncateText } from '@/utils/format'

export interface DiseaseItem {
  name: string
  category: string
  definition?: string
  compensation: string
  waitingPeriod: string
  isHighRisk: boolean
  type: 'critical' | 'medium' | 'light'
}

interface Props {
  diseases: DiseaseItem[]
}

const props = defineProps<Props>()

const searchKeyword = ref('')
const activeTab = ref<'critical' | 'medium' | 'light'>('critical')

const criticalDiseases = computed(() => props.diseases.filter((d) => d.type === 'critical'))
const mediumDiseases = computed(() => props.diseases.filter((d) => d.type === 'medium'))
const lightDiseases = computed(() => props.diseases.filter((d) => d.type === 'light'))

const currentList = computed(() => {
  switch (activeTab.value) {
    case 'critical':
      return criticalDiseases.value
    case 'medium':
      return mediumDiseases.value
    case 'light':
      return lightDiseases.value
    default:
      return criticalDiseases.value
  }
})

const filteredDiseases = computed(() => {
  if (!searchKeyword.value.trim()) return currentList.value
  const kw = searchKeyword.value.trim().toLowerCase()
  return currentList.value.filter(
    (d) =>
      d.name.toLowerCase().includes(kw) ||
      d.category.toLowerCase().includes(kw)
  )
})
</script>

<style scoped>
.disease-list {
  padding: 8px 0;
}

.search-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.high-risk {
  color: #f56c6c;
  font-weight: 600;
}

.risk-tag {
  margin-left: 8px;
}

.definition-text {
  color: #606266;
  cursor: help;
}

.no-definition {
  color: #c0c4cc;
}

.compensation {
  color: #e6a23c;
  font-weight: 600;
}

.definition-help-icon {
  margin-left: 6px;
  color: #c0c4cc;
  cursor: help;
  vertical-align: middle;
}

.definition-help-icon:hover {
  color: #409eff;
}

.disease-stats {
  margin-top: 20px;
}
</style>
