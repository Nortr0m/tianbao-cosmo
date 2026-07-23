<template>
  <div class="stat-card" :class="{ clickable: !!to }" @click="handleClick">
    <div class="icon-wrapper" :style="{ backgroundColor: iconBgColor }">
      <el-icon :size="28" :color="iconColor">
        <component :is="icon" />
      </el-icon>
    </div>
    <div class="content">
      <div class="value">{{ formatValue(value) }}</div>
      <div class="title">{{ title }}</div>
    </div>
    <el-icon v-if="to" class="arrow-icon" :size="16"><ArrowRight /></el-icon>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'
import { ArrowRight } from '@element-plus/icons-vue'

const props = defineProps<{
  title: string
  value: string | number
  icon: string
  iconBgColor?: string
  iconColor?: string
  to?: string
}>()

const router = useRouter()

function handleClick() {
  if (props.to) {
    router.push(props.to)
  }
}

function formatValue(val: string | number): string {
  if (typeof val === 'number') {
    return val.toLocaleString('zh-CN')
  }
  return String(val)
}
</script>

<style scoped>
.stat-card {
  display: flex;
  align-items: center;
  padding: 20px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  transition: all 0.3s;
  position: relative;
}

.stat-card.clickable {
  cursor: pointer;
}

.stat-card.clickable:hover {
  box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.icon-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 56px;
  height: 56px;
  border-radius: 12px;
  margin-right: 16px;
  flex-shrink: 0;
}

.content {
  flex: 1;
  min-width: 0;
}

.value {
  font-size: 24px;
  font-weight: 600;
  color: #303133;
  line-height: 1.2;
  margin-bottom: 4px;
}

.title {
  font-size: 14px;
  color: #909399;
}

.arrow-icon {
  color: #c0c4cc;
  margin-left: 8px;
}

.stat-card.clickable:hover .arrow-icon {
  color: #409eff;
}
</style>
