<template>
  <div class="cosmos-layout">
    <!-- 悬浮导航栏：鼠标移到顶部时显示 -->
    <div class="cosmos-nav-trigger" @mouseenter="showNav = true">
      <div class="cosmos-nav-bar" :class="{ show: showNav }" @mouseleave="showNav = false">
        <div class="nav-content">
          <!-- Logo -->
          <div class="nav-logo" @click="router.push('/')">
            <img src="/logo.jpg" alt="天保星君" class="logo-img" />
            <span class="logo-text">天保星君</span>
          </div>
          <!-- 导航链接 -->
          <nav class="nav-links">
            <router-link
              v-for="item in navItems"
              :key="item.path"
              :to="item.path"
              class="nav-link"
            >
              {{ item.title }}
            </router-link>
          </nav>
          <!-- 用户操作 -->
          <div class="nav-actions">
            <template v-if="userStore.isLoggedIn">
              <el-dropdown @command="handleCommand" trigger="click">
                <span class="user-info">
                  <el-avatar :size="28" :src="userStore.avatar" :icon="UserFilled" />
                  <span class="username">{{ userStore.realName || userStore.username }}</span>
                  <el-icon><ArrowDown /></el-icon>
                </span>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item command="user">
                      <el-icon><User /></el-icon>个人中心
                    </el-dropdown-item>
                    <el-dropdown-item command="vip">
                      <el-icon><Medal /></el-icon>VIP会员
                    </el-dropdown-item>
                    <el-dropdown-item divided command="logout">
                      <el-icon><SwitchButton /></el-icon>退出登录
                    </el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </template>
            <template v-else>
              <el-button type="primary" size="small" @click="router.push('/login')">登录</el-button>
              <el-button size="small" @click="router.push('/register')">注册</el-button>
            </template>
          </div>
        </div>
        <!-- 底部霓虹发光线 -->
        <div class="nav-glow-line"></div>
      </div>
    </div>
    <router-view />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/userStore'
import {
  UserFilled,
  ArrowDown,
  User,
  Medal,
  SwitchButton
} from '@element-plus/icons-vue'

const router = useRouter()
const userStore = useUserStore()
const showNav = ref(false)

const navItems = [
  { title: '产品列表', path: '/product/list' },
  { title: '产品对比', path: '/compare' },
  { title: '卡片生成', path: '/card/generate' }
]

function handleCommand(command: string) {
  switch (command) {
    case 'user':
      router.push('/user')
      break
    case 'vip':
      router.push('/vip')
      break
    case 'logout':
      userStore.logout()
      router.push('/login')
      break
  }
}
</script>

<style scoped>
.cosmos-layout {
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  background: #000;
  position: relative;
}

/* 触发区域：顶部 64px 热区 */
.cosmos-nav-trigger {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 64px;
  z-index: 200;
}

/* 导航栏本体 */
.cosmos-nav-bar {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 64px;
  background-color: rgba(10, 10, 15, 0.9);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(42, 42, 74, 0.6);
  transform: translateY(-100%);
  opacity: 0;
  transition: transform 0.35s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.35s ease;
}

.cosmos-nav-bar.show {
  transform: translateY(0);
  opacity: 1;
}

.nav-content {
  max-width: 1400px;
  margin: 0 auto;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
}

.nav-glow-line {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, #b347d9, #00e5ff);
  box-shadow: 0 0 10px rgba(179, 71, 217, 0.5), 0 0 20px rgba(0, 229, 255, 0.3);
}

/* Logo */
.nav-logo {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  transition: filter 0.2s;
}

.nav-logo:hover {
  filter: brightness(1.2);
}

.logo-img {
  width: 36px;
  height: 36px;
  border-radius: 8px;
  object-fit: contain;
  box-shadow: 0 0 8px rgba(179, 71, 217, 0.4);
}

.logo-text {
  font-size: 20px;
  font-weight: 700;
  background: linear-gradient(90deg, #b347d9, #00e5ff);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  letter-spacing: 2px;
}

/* 导航链接 */
.nav-links {
  display: flex;
  gap: 28px;
}

.nav-link {
  text-decoration: none;
  color: #8888aa;
  font-size: 14px;
  font-weight: 500;
  padding: 6px 0;
  position: relative;
  transition: color 0.2s, text-shadow 0.2s;
  letter-spacing: 1px;
}

.nav-link:hover {
  color: #00e5ff;
  text-shadow: 0 0 10px rgba(0, 229, 255, 0.5);
}

/* 用户操作 */
.nav-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
  padding: 4px 8px;
  border-radius: 6px;
  transition: background-color 0.2s;
}

.user-info:hover {
  background-color: rgba(255, 255, 255, 0.05);
}

.username {
  font-size: 13px;
  color: #8888aa;
  max-width: 80px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
