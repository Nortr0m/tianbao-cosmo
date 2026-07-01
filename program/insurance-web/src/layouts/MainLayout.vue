<template>
  <el-container class="main-layout">
    <el-header class="main-header" height="64px">
      <div class="header-content">
        <div class="logo" @click="router.push('/')">
          <img src="/logo.jpg" alt="天保星君" class="logo-img" />
          <span class="logo-text">天保星君</span>
        </div>
        <nav class="main-nav">
          <router-link
            v-for="item in navItems"
            :key="item.path"
            :to="item.path"
            :class="['nav-link', { active: route.path === item.path }]"
          >
            {{ item.title }}
          </router-link>
        </nav>
        <div class="header-actions">
          <template v-if="userStore.isLoggedIn">
            <el-dropdown @command="handleCommand">
              <span class="user-info">
                <el-avatar :size="32" :src="userStore.avatar" :icon="UserFilled" />
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
            <el-button type="primary" @click="router.push('/login')">登录</el-button>
            <el-button @click="router.push('/register')">注册</el-button>
          </template>
        </div>
      </div>
      <!-- 底部霓虹发光线 -->
      <div class="header-glow-line"></div>
    </el-header>

    <el-main class="main-content">
      <router-view v-slot="{ Component }">
        <transition name="fade" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </el-main>

    <el-footer class="main-footer" height="120px">
      <div class="footer-content">
        <div class="footer-links">
          <a href="#">关于我们</a>
          <a href="#">服务条款</a>
          <a href="#">隐私政策</a>
          <a href="#">联系我们</a>
        </div>
        <p class="copyright">天保星君 版权所有</p>
      </div>
    </el-footer>
  </el-container>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useUserStore } from '@/stores/userStore'
import {
  UserFilled,
  ArrowDown,
  User,
  Medal,
  SwitchButton
} from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const navItems = computed(() => [
  { title: '首页', path: '/' },
  { title: '产品列表', path: '/product/list' },
  { title: '产品对比', path: '/compare' },
  { title: '卡片生成', path: '/card/generate' }
])

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
.main-layout {
  min-height: 100vh;
  background-color: var(--bg-primary);
}

.main-header {
  background-color: rgba(10, 10, 15, 0.9);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  position: sticky;
  top: 0;
  z-index: 100;
  padding: 0;
  border-bottom: 1px solid var(--border-color);
}

.header-content {
  max-width: 1400px;
  margin: 0 auto;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
}

.header-glow-line {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: var(--gradient-main);
  box-shadow: 0 0 10px rgba(179, 71, 217, 0.5), 0 0 20px rgba(0, 229, 255, 0.3);
}

.logo {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  transition: all var(--transition-normal);
}

.logo:hover {
  filter: brightness(1.2);
}

.logo-img {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  object-fit: contain;
  box-shadow: var(--shadow-neon-purple);
}

.logo-text {
  font-size: 22px;
  font-weight: 700;
  background: var(--gradient-main);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  letter-spacing: 2px;
  font-family: var(--font-family-display);
}

.main-nav {
  display: flex;
  gap: 32px;
}

.nav-link {
  text-decoration: none;
  color: var(--text-secondary);
  font-size: 15px;
  font-weight: 500;
  padding: 8px 0;
  position: relative;
  transition: all var(--transition-normal);
  letter-spacing: 1px;
}

.nav-link:hover,
.nav-link.active {
  color: var(--accent-cyan);
  text-shadow: 0 0 10px rgba(0, 229, 255, 0.5);
}

.nav-link.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: var(--gradient-main);
  border-radius: 2px;
  box-shadow: 0 0 8px rgba(179, 71, 217, 0.5), 0 0 8px rgba(0, 229, 255, 0.3);
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 4px 8px;
  border-radius: var(--radius-md);
  transition: all var(--transition-normal);
}

.user-info:hover {
  background-color: var(--bg-card-hover);
}

.username {
  font-size: 14px;
  color: var(--text-secondary);
  max-width: 100px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.main-content {
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  padding: 24px;
  min-height: calc(100vh - 64px - 120px);
}

.main-footer {
  background-color: var(--bg-secondary);
  color: var(--text-muted);
  padding: 0;
  border-top: 1px solid var(--border-color);
}

.footer-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 24px;
  text-align: center;
}

.footer-links {
  display: flex;
  justify-content: center;
  gap: 24px;
  margin-bottom: 16px;
}

.footer-links a {
  color: var(--text-muted);
  text-decoration: none;
  font-size: 14px;
  transition: all var(--transition-normal);
}

.footer-links a:hover {
  color: var(--accent-cyan);
  text-shadow: 0 0 8px rgba(0, 229, 255, 0.4);
}

.copyright {
  font-size: 13px;
  color: var(--text-muted);
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
