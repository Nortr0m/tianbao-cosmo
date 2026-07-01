import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export interface TagView {
  name: string
  title: string
  path: string
  fullPath: string
}

export const useAppStore = defineStore('app', () => {
  const sidebarCollapsed = ref<boolean>(localStorage.getItem('sidebar_collapsed') === 'true')
  const tagViews = ref<TagView[]>([])
  const cachedViews = ref<string[]>([])
  const activeTag = ref<string>('')

  const sidebarWidth = computed(() => (sidebarCollapsed.value ? '64px' : '210px'))

  function toggleSidebar() {
    sidebarCollapsed.value = !sidebarCollapsed.value
    localStorage.setItem('sidebar_collapsed', String(sidebarCollapsed.value))
  }

  function addTagView(tag: TagView) {
    const exists = tagViews.value.some((item) => item.path === tag.path)
    if (!exists) {
      tagViews.value.push(tag)
    }
    activeTag.value = tag.path
    if (!cachedViews.value.includes(tag.name)) {
      cachedViews.value.push(tag.name)
    }
  }

  function removeTagView(path: string) {
    const index = tagViews.value.findIndex((item) => item.path === path)
    if (index > -1) {
      const tag = tagViews.value[index]
      tagViews.value.splice(index, 1)
      const cacheIndex = cachedViews.value.indexOf(tag.name)
      if (cacheIndex > -1) {
        cachedViews.value.splice(cacheIndex, 1)
      }
    }
    if (activeTag.value === path && tagViews.value.length > 0) {
      activeTag.value = tagViews.value[Math.min(index, tagViews.value.length - 1)].path
    }
  }

  function removeOthers(path: string) {
    const current = tagViews.value.find((item) => item.path === path)
    if (current) {
      tagViews.value = [current]
      cachedViews.value = [current.name]
      activeTag.value = path
    }
  }

  function removeAll() {
    tagViews.value = []
    cachedViews.value = []
    activeTag.value = ''
  }

  function setActiveTag(path: string) {
    activeTag.value = path
  }

  return {
    sidebarCollapsed,
    tagViews,
    cachedViews,
    activeTag,
    sidebarWidth,
    toggleSidebar,
    addTagView,
    removeTagView,
    removeOthers,
    removeAll,
    setActiveTag
  }
})
