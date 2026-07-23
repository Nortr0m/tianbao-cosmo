<template>
  <el-breadcrumb separator="/">
    <el-breadcrumb-item v-for="item in breadcrumbs" :key="item.path" :to="item.path">
      {{ item.title }}
    </el-breadcrumb-item>
  </el-breadcrumb>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'

interface BreadcrumbItem {
  path: string
  title: string
}

const route = useRoute()

const breadcrumbs = computed<BreadcrumbItem[]>(() => {
  const items: BreadcrumbItem[] = []
  const matched = route.matched.filter((item) => item.meta?.title)

  matched.forEach((item) => {
    items.push({
      path: item.path,
      title: item.meta.title as string
    })
  })

  return items
})
</script>

<style scoped>
:deep(.el-breadcrumb__item) {
  font-size: 14px;
}
</style>
