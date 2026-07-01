import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/stores/userStore'
import { ElMessage } from 'element-plus'
import { tokenStorage } from '@/utils/storage'
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
        meta: { title: '保险宇宙' }
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
        meta: { title: '产品列表' }
      },
      {
        path: 'product/:id',
        name: 'ProductDetail',
        component: () => import('@/views/product/ProductDetailWrapper.vue'),
        meta: { title: '产品详情' }
      },
      {
        path: 'compare',
        name: 'Compare',
        component: () => import('@/views/compare/ComparePage.vue'),
        meta: { title: '产品对比', requiresAuth: true }
      },
      {
        path: 'card/generate',
        name: 'CardGenerate',
        component: () => import('@/views/card/CardGenerate.vue'),
        meta: { title: '卡片生成', requiresAuth: true }
      },
      {
        path: 'user',
        name: 'UserCenter',
        component: () => import('@/views/user/UserCenter.vue'),
        meta: { title: '个人中心', requiresAuth: true }
      },
      {
        path: 'vip',
        name: 'VipPurchase',
        component: () => import('@/views/vip/VipPurchase.vue'),
        meta: { title: 'VIP会员' }
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
        meta: { title: '登录', guestOnly: true }
      },
      {
        path: 'register',
        name: 'Register',
        component: () => import('@/views/user/RegisterView.vue'),
        meta: { title: '注册', guestOnly: true }
      }
    ]
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('@/views/home/HomePage.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  }
})

router.beforeEach((to, _from, next) => {
  const userStore = useUserStore()

  // Update page title
  if (to.meta.title) {
    document.title = `${to.meta.title} - 保险对比平台`
  }

  // Guest only routes (login/register) - redirect if already logged in
  if (to.meta.guestOnly && userStore.isLoggedIn) {
    next('/')
    return
  }
  // 如果localStorage有token但userInfo还没加载完成，也视为已登录，重定向guestOnly页面
  if (to.meta.guestOnly && !userStore.isLoggedIn && tokenStorage.getAccessToken()) {
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
    next(`/login?redirect=${encodeURIComponent(to.fullPath)}`)
    return
  }

  next()
})

export default router
