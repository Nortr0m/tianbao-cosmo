import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/stores/userStore'
import { ElMessage } from 'element-plus'
import { tokenStorage } from '@/utils/storage'
import NProgress from '@/utils/nprogress'
import type { RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    component: () => import('@/layouts/CosmosLayout.vue'),
    children: [
      {
        path: '',
        name: 'Home',
        component: () => import('@/views/cosmos/CosmosHome.vue'),
        meta: { title: '保险宇宙', keepAlive: false }
      }
    ]
  },
  {
    path: '/',
    component: () => import('@/layouts/MainLayout.vue'),
    children: [
      {
        path: 'product/list',
        name: 'ProductList',
        component: () => import('@/views/product/ProductList.vue'),
        meta: { title: '产品列表', keepAlive: true }
      },
      {
        path: 'product/:id',
        name: 'ProductDetail',
        component: () => import('@/views/product/ProductDetailWrapper.vue'),
        meta: { title: '产品详情', keepAlive: false }
      },
      {
        path: 'compare',
        name: 'Compare',
        component: () => import('@/views/compare/ComparePage.vue'),
        meta: { title: '产品对比', requiresAuth: true, keepAlive: false }
      },
      {
        path: 'card/generate',
        name: 'CardGenerate',
        component: () => import('@/views/card/CardGenerate.vue'),
        meta: { title: '卡片生成', requiresAuth: true, keepAlive: false }
      },
      {
        path: 'card/history',
        name: 'CardHistory',
        component: () => import('@/views/card/CardHistory.vue'),
        meta: { title: '卡片历史', requiresAuth: true, keepAlive: false }
      },
      {
        path: 'user',
        name: 'UserCenter',
        component: () => import('@/views/user/UserCenter.vue'),
        meta: { title: '个人中心', requiresAuth: true, keepAlive: false }
      },
      {
        path: 'vip',
        name: 'VipPurchase',
        component: () => import('@/views/vip/VipPurchase.vue'),
        meta: { title: 'VIP会员', keepAlive: false }
      }
    ]
  },
  {
    path: '/',
    component: () => import('@/layouts/AuthLayout.vue'),
    children: [
      {
        path: 'login',
        name: 'Login',
        component: () => import('@/views/user/LoginView.vue'),
        meta: { title: '登录', guestOnly: true, keepAlive: false }
      },
      {
        path: 'register',
        name: 'Register',
        component: () => import('@/views/user/RegisterView.vue'),
        meta: { title: '注册', guestOnly: true, keepAlive: false }
      }
    ]
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('@/views/home/HomePage.vue'),
    meta: { title: '页面未找到', keepAlive: false }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  /**
   * 路由滚动行为配置
   * - 从列表页进入详情页：滚动到顶部
   * - 从详情页返回列表页：记住滚动位置（savedPosition）
   * - 路由切换时平滑滚动（使用 behavior: 'smooth'）
   */
  scrollBehavior(to, from, savedPosition) {
    // 如果有保存的位置（浏览器前进/后退），恢复到该位置
    if (savedPosition) {
      // 延迟一点执行，确保内容已渲染
      return new Promise((resolve) => {
        setTimeout(() => {
          resolve({ ...savedPosition, behavior: 'smooth' as ScrollBehavior })
        }, 100)
      })
    }

    // 从列表页进入详情页，滚动到顶部
    if (from.name === 'ProductList' && to.name === 'ProductDetail') {
      return { top: 0, behavior: 'smooth' as ScrollBehavior }
    }

    // 详情页返回列表页时，使用浏览器原生的 savedPosition 处理
    // 如果没有 savedPosition，则滚动到顶部
    if (to.name === 'ProductList') {
      // 如果有锚点，滚动到锚点
      if (to.hash) {
        return {
          el: to.hash,
          behavior: 'smooth' as ScrollBehavior,
          top: 80
        }
      }
      // 列表页默认滚动到顶部（配合 keepAlive 时由组件内部管理滚动位置）
      return { top: 0 }
    }

    // 默认行为：滚动到顶部
    return { top: 0, behavior: 'smooth' as ScrollBehavior }
  }
})

/**
 * 全局前置守卫
 * 1. 显示路由进度条
 * 2. 更新页面标题
 * 3. 权限检查（需要登录的路由 / 仅游客可访问的路由）
 */
router.beforeEach((to, _from, next) => {
  // 启动进度条
  NProgress.start()

  const userStore = useUserStore()

  // Update page title
  if (to.meta.title) {
    document.title = `${to.meta.title} - 保险对比平台`
  }

  // Guest only routes (login/register) - redirect if already logged in
  if (to.meta.guestOnly && userStore.isLoggedIn) {
    NProgress.done()
    next('/')
    return
  }
  // 如果localStorage有token但userInfo还没加载完成，也视为已登录，重定向guestOnly页面
  if (to.meta.guestOnly && !userStore.isLoggedIn && tokenStorage.getAccessToken()) {
    NProgress.done()
    next('/')
    return
  }

  // Auth required routes
  if (to.meta.requiresAuth && !userStore.isLoggedIn) {
    // 如果localStorage中有token但userInfo还没加载（页面刷新后initializeAuth尚未完成），允许通过
    if (tokenStorage.getAccessToken()) {
      next()
      return
    }
    ElMessage.warning('请先登录')
    NProgress.done()
    next(`/login?redirect=${encodeURIComponent(to.fullPath)}`)
    return
  }

  next()
})

/**
 * 全局后置钩子
 * 1. 完成进度条
 * 2. 页面埋点/统计（预留）
 */
router.afterEach((_to, _from) => {
  // 完成进度条
  NProgress.done()

  // 预留：页面访问统计
  // console.log(`[PageView] ${from.path} -> ${to.path}`)
})

/**
 * 全局路由错误处理
 */
router.onError((error) => {
  NProgress.done()
  console.error('[Router Error]', error)
})

export default router
