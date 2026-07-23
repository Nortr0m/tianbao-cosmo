<template>
  <div class="cosmos-layout">
    <!-- 顶部导航栏容器 -->
    <div class="cosmos-nav-bar">
      <!-- 品牌触发点：加载完成后显示，悬停时展开导航栏 -->
      <div
        class="brand-trigger"
        :class="{ show: showTrigger, hide: showNav }"
        @mouseenter="onBrandEnter"
      >
        <img src="/logo.jpg" alt="天保星君" class="trigger-logo" />
        <span class="trigger-text">天保星君</span>
        <span class="trigger-slogan">天保定尔 · 星辉引路</span>
      </div>

      <!-- 完整导航栏：悬停时展开，离开时收起 -->
      <div
        class="nav-bar-full"
        :class="{ show: showNav }"
        @mouseleave="onNavLeave"
      >
        <div class="nav-inner">
          <!-- 左侧品牌标识 -->
          <div class="nav-brand" @click="showNav = false; router.push('/')">
            <img src="/logo.jpg" alt="天保星君" class="nav-brand-logo" />
            <div class="nav-brand-text-group">
              <span class="nav-brand-text">天保星君</span>
              <span class="nav-brand-slogan">天保定尔 · 星辉引路</span>
            </div>
          </div>
          <!-- 中间导航链接 -->
          <nav class="nav-links">
            <router-link
              v-for="item in navItems"
              :key="item.path"
              :to="item.path"
              :class="['nav-link', { active: route.path === item.path }]"
              @click="showNav = false"
            >
              {{ item.title }}
            </router-link>
          </nav>
          <!-- 用户操作（右侧） -->
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
              <el-button type="primary" size="small" @click="showNav = false; router.push('/login')">登录</el-button>
              <el-button size="small" @click="showNav = false; router.push('/register')">注册</el-button>
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
import { ref, onMounted, onUnmounted } from 'vue'
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
const showTrigger = ref(false)
const navCooldown = ref(false)

const route = useRoute()

const navItems = [
  { title: '首页', path: '/' },
  { title: '产品列表', path: '/product/list' },
  { title: '产品对比', path: '/compare' },
  { title: '卡片生成', path: '/card/generate' }
]

function onBrandEnter() {
  if (navCooldown.value) return
  showNav.value = true
}

function onNavLeave() {
  showNav.value = false
  navCooldown.value = true
  setTimeout(() => (navCooldown.value = false), 300)
}

function handleCommand(command: string) {
  showNav.value = false
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

// 星空加载完成后显示品牌触发点
function onCosmosLoaded() {
  showTrigger.value = true
}

onMounted(() => {
  window.addEventListener('cosmos-loaded', onCosmosLoaded)
})

onUnmounted(() => {
  window.removeEventListener('cosmos-loaded', onCosmosLoaded)
})
</script>

<style scoped>
.cosmos-layout {
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  background: #000;
  position: relative;
}

/* 导航栏容器 */
.cosmos-nav-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 64px;
  z-index: 200;
  pointer-events: none;
}

/* 品牌触发点：初始完全隐藏，加载完成后淡入 */
.brand-trigger {
  position: fixed;
  top: 8px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
  padding: 8px 20px;
  z-index: 201;
  pointer-events: auto;
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.3s ease, visibility 0s 0.3s;
}

.brand-trigger.show {
  opacity: 1;
  visibility: visible;
  transition: opacity 0.3s ease, visibility 0s;
}

/* 展开时原地隐藏，延迟 visibility 以避免 mouseleave 误触发 */
.brand-trigger.hide {
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.25s ease, visibility 0s 0.35s;
}

/* 品牌触发点放大 */
.trigger-logo {
  width: 56px;
  height: 56px;
  border-radius: 12px;
  object-fit: contain;
  box-shadow: 0 0 16px rgba(179, 71, 217, 0.55);
}

.trigger-text {
  font-size: 30px;
  font-weight: 700;
  color: #ffd27a;
  letter-spacing: 5px;
  white-space: nowrap;
  text-shadow: 0 0 16px rgba(255, 215, 122, 0.4);
}

.trigger-slogan {
  font-size: 14px;
  color: rgba(255,210,122,0.6);
  font-weight: 400;
  letter-spacing: 2px;
  margin-left: 4px;
  border-left: 1px solid rgba(255,210,122,0.3);
  padding-left: 16px;
  margin-left: 16px;
}

/* 导航栏左侧品牌标识 */
.nav-brand {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.nav-brand:hover {
  filter: brightness(1.2);
}

.nav-brand-logo {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  object-fit: contain;
  box-shadow: 0 0 16px rgba(179, 71, 217, 0.55);
}

.nav-brand-text-group {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.nav-brand-text {
  font-size: 22px;
  font-weight: 700;
  background: linear-gradient(135deg, #c855f0, #00f0ff);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  letter-spacing: 2px;
  white-space: nowrap;
  line-height: 1.2;
}

.nav-brand-slogan {
  font-size: 11px;
  color: rgba(136, 136, 170, 0.8);
  font-weight: 400;
  letter-spacing: 0.5px;
  line-height: 1.2;
  white-space: nowrap;
}

/* 完整导航栏：悬停时展开 */
.nav-bar-full {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 64px;
  background-color: rgba(10, 10, 15, 0.92);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(42, 42, 74, 0.6);
  transform: translateY(-100%);
  opacity: 0;
  transition: transform 0.35s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.35s ease;
  pointer-events: auto;
}

.nav-bar-full.show {
  transform: translateY(0);
  opacity: 1;
}

.nav-inner {
  max-width: 1400px;
  margin: 0 auto;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  position: relative;
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

/* 导航链接 */
.nav-links {
  display: flex;
  gap: 32px;
}

.nav-link {
  text-decoration: none;
  color: #8888aa;
  font-size: 15px;
  font-weight: 500;
  padding: 8px 0;
  position: relative;
  transition: all 0.2s ease;
  letter-spacing: 1px;
}

.nav-link:hover,
.nav-link.active {
  color: #00e5ff;
  text-shadow: 0 0 10px rgba(0, 229, 255, 0.5);
}

.nav-link.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, #b347d9, #00e5ff);
  border-radius: 2px;
  box-shadow: 0 0 8px rgba(179, 71, 217, 0.5), 0 0 8px rgba(0, 229, 255, 0.3);
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
