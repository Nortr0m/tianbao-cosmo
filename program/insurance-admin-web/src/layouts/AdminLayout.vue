<template>
  <el-container class="admin-layout">
    <!-- 侧边栏 -->
    <el-aside class="sidebar" :width="appStore.sidebarWidth" :class="{ collapsed: appStore.sidebarCollapsed }">
      <div class="logo">
        <el-icon :size="28" color="#fff"><Collection /></el-icon>
        <span v-show="!appStore.sidebarCollapsed" class="logo-text">保险管理后台</span>
      </div>
      <el-scrollbar class="menu-scrollbar">
        <el-menu
          :default-active="activeMenu"
          :collapse="appStore.sidebarCollapsed"
          :collapse-transition="false"
          router
          background-color="#304156"
          text-color="#bfcbd9"
          active-text-color="#409eff"
        >
          <el-menu-item index="/dashboard">
            <el-icon><DataLine /></el-icon>
            <template #title>数据看板</template>
          </el-menu-item>

          <el-sub-menu index="/product">
            <template #title>
              <el-icon><Goods /></el-icon>
              <span>产品管理</span>
            </template>
            <el-menu-item index="/product/critical">重疾险管理</el-menu-item>
            <el-menu-item index="/product/whole-life">增额终身寿险管理</el-menu-item>
            <el-menu-item index="/product/annuity">年金险管理</el-menu-item>
          </el-sub-menu>

          <el-sub-menu index="/company">
            <template #title>
              <el-icon><OfficeBuilding /></el-icon>
              <span>保险公司管理</span>
            </template>
            <el-menu-item index="/company/list">保司列表</el-menu-item>
            <el-menu-item index="/company/dashboard">保司数据看板</el-menu-item>
            <el-menu-item index="/company/rating-history">风险评级历史</el-menu-item>
          </el-sub-menu>

          <el-sub-menu index="/card-template">
            <template #title>
              <el-icon><Picture /></el-icon>
              <span>卡片模板管理</span>
            </template>
            <el-menu-item index="/card-template/list">背景图库管理</el-menu-item>
            <el-menu-item index="/card-template/stats">使用数据统计</el-menu-item>
          </el-sub-menu>

          <el-menu-item index="/vip/management">
            <el-icon><UserFilled /></el-icon>
            <template #title>VIP会员管理</template>
          </el-menu-item>

          <el-menu-item index="/vip/redeem-code">
            <el-icon><Ticket /></el-icon>
            <template #title>兑换码管理</template>
          </el-menu-item>

          <el-menu-item index="/system/settings">
            <el-icon><Setting /></el-icon>
            <template #title>系统设置</template>
          </el-menu-item>
        </el-menu>
      </el-scrollbar>
    </el-aside>

    <el-container class="main-container">
      <!-- 顶部导航 -->
      <el-header class="header">
        <div class="header-left">
          <el-icon class="collapse-btn" :size="20" @click="appStore.toggleSidebar">
            <Fold v-if="!appStore.sidebarCollapsed" />
            <Expand v-else />
          </el-icon>
          <breadcrumb />
        </div>
        <div class="header-right">
          <el-dropdown @command="handleCommand">
            <div class="user-info">
              <el-avatar :size="32" :src="userStore.avatar">
                <el-icon><UserFilled /></el-icon>
              </el-avatar>
              <span class="username">{{ userStore.username }}</span>
              <el-icon><ArrowDown /></el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">个人中心</el-dropdown-item>
                <el-dropdown-item command="settings">系统设置</el-dropdown-item>
                <el-dropdown-item divided command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <!-- 标签页 -->
      <div v-if="appStore.tagViews.length > 0" class="tag-views">
        <div
          v-for="tag in appStore.tagViews"
          :key="tag.path"
          class="tag-item"
          :class="{ active: tag.path === appStore.activeTag }"
          @click="router.push(tag.path)"
        >
          <span class="tag-title">{{ tag.title }}</span>
          <el-icon class="tag-close" :size="12" @click.stop="closeTag(tag.path)">
            <Close />
          </el-icon>
        </div>
      </div>

      <!-- 内容区 -->
      <el-main class="main-content">
        <router-view v-slot="{ Component }">
          <keep-alive :include="appStore.cachedViews">
            <component :is="Component" />
          </keep-alive>
        </router-view>
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
  DataLine,
  Goods,
  OfficeBuilding,
  Picture,
  UserFilled,
  Ticket,
  Setting,
  Fold,
  Expand,
  ArrowDown,
  Close,
  Collection
} from '@element-plus/icons-vue'
import { useUserStore } from '@/stores/userStore'
import { useAppStore } from '@/stores/appStore'
import Breadcrumb from './Breadcrumb.vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const appStore = useAppStore()

const activeMenu = computed(() => route.path)

function handleCommand(command: string) {
  switch (command) {
    case 'profile':
      router.push('/profile')
      break
    case 'settings':
      router.push('/system/settings')
      break
    case 'logout':
      userStore.logout().then(() => {
        router.push('/login')
      })
      break
  }
}

function closeTag(path: string) {
  appStore.removeTagView(path)
  if (appStore.activeTag === path) {
    router.push(appStore.activeTag || '/dashboard')
  }
}
</script>

<style scoped>
.admin-layout {
  height: 100vh;
}

.sidebar {
  background-color: #304156;
  transition: width 0.3s;
  display: flex;
  flex-direction: column;
}

.sidebar.collapsed .logo {
  padding: 0 16px;
  justify-content: center;
}

.logo {
  height: 60px;
  display: flex;
  align-items: center;
  padding: 0 20px;
  gap: 12px;
  border-bottom: 1px solid #1f2d3d;
  flex-shrink: 0;
}

.logo-text {
  color: #fff;
  font-size: 16px;
  font-weight: 600;
  white-space: nowrap;
}

.menu-scrollbar {
  flex: 1;
}

:deep(.el-menu) {
  border-right: none;
}

.main-container {
  background-color: #f0f2f5;
}

.header {
  background-color: #fff;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  height: 60px;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.collapse-btn {
  cursor: pointer;
  color: #606266;
  transition: color 0.3s;
}

.collapse-btn:hover {
  color: #409eff;
}

.header-right {
  display: flex;
  align-items: center;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 4px 8px;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.user-info:hover {
  background-color: #f5f7fa;
}

.username {
  font-size: 14px;
  color: #606266;
}

.tag-views {
  background-color: #fff;
  padding: 4px 16px;
  border-bottom: 1px solid #e4e7ed;
  display: flex;
  gap: 4px;
  flex-wrap: wrap;
}

.tag-item {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 12px;
  border-radius: 3px;
  font-size: 12px;
  cursor: pointer;
  background-color: #fff;
  border: 1px solid #e4e7ed;
  color: #606266;
  transition: all 0.3s;
}

.tag-item:hover {
  color: #409eff;
}

.tag-item.active {
  background-color: #409eff;
  border-color: #409eff;
  color: #fff;
}

.tag-item.active .tag-close:hover {
  color: #fff;
  background-color: rgba(255, 255, 255, 0.2);
}

.tag-close {
  border-radius: 50%;
  padding: 1px;
  transition: all 0.3s;
}

.tag-close:hover {
  background-color: #f5f7fa;
}

.main-content {
  padding: 16px;
  overflow-y: auto;
}
</style>
