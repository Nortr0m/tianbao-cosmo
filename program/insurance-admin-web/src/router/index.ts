import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/stores/userStore'
import { useAppStore } from '@/stores/appStore'
import type { RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/login/LoginView.vue'),
    meta: { title: '登录', public: true }
  },
  {
    path: '/',
    component: () => import('@/layouts/AdminLayout.vue'),
    redirect: '/dashboard',
    children: [
      {
        path: '/dashboard',
        name: 'Dashboard',
        component: () => import('@/views/dashboard/DashboardPage.vue'),
        meta: { title: '数据看板' }
      },
      {
        path: '/product/critical',
        name: 'CriticalIllnessList',
        component: () => import('@/views/product/CriticalIllnessList.vue'),
        meta: { title: '重疾险管理', parentTitle: '产品管理' }
      },
      {
        path: '/product/critical/form',
        name: 'CriticalIllnessForm',
        component: () => import('@/views/product/CriticalIllnessForm.vue'),
        meta: { title: '重疾险编辑', parentTitle: '产品管理' }
      },
      {
        path: '/product/whole-life',
        name: 'WholeLifeList',
        component: () => import('@/views/product/WholeLifeList.vue'),
        meta: { title: '增额终身寿险管理', parentTitle: '产品管理' }
      },
      {
        path: '/product/whole-life/form',
        name: 'WholeLifeForm',
        component: () => import('@/views/product/WholeLifeForm.vue'),
        meta: { title: '增额终身寿险编辑', parentTitle: '产品管理' }
      },
      {
        path: '/product/whole-life/rate-import',
        name: 'WholeLifeRateImport',
        component: () => import('@/views/product/RateImport.vue'),
        meta: { title: '现金价值导入', parentTitle: '产品管理' }
      },
      {
        path: '/product/annuity',
        name: 'AnnuityList',
        component: () => import('@/views/product/AnnuityList.vue'),
        meta: { title: '年金险管理', parentTitle: '产品管理' }
      },
      {
        path: '/product/annuity/form',
        name: 'AnnuityForm',
        component: () => import('@/views/product/AnnuityForm.vue'),
        meta: { title: '年金险编辑', parentTitle: '产品管理' }
      },
      {
        path: '/product/annuity/rate-import',
        name: 'AnnuityRateImport',
        component: () => import('@/views/product/AnnuityRateImport.vue'),
        meta: { title: '年金险数据导入', parentTitle: '产品管理' }
      },
      {
        path: '/product/responsibility',
        name: 'ResponsibilityConfig',
        component: () => import('@/views/product/ResponsibilityConfig.vue'),
        meta: { title: '责任模板管理', parentTitle: '产品管理' }
      },
      {
        path: '/product/rate-import',
        name: 'RateImport',
        component: () => import('@/views/product/RateImport.vue'),
        meta: { title: '费率导入', parentTitle: '产品管理' }
      },
      {
        path: '/product/import-wizard',
        name: 'ProductImportWizard',
        component: () => import('@/views/product/ProductImportWizard.vue'),
        meta: { title: '产品录入向导', parentTitle: '产品管理' }
      },
      {
        path: '/company/list',
        name: 'CompanyList',
        component: () => import('@/views/company/CompanyList.vue'),
        meta: { title: '保司列表', parentTitle: '保险公司管理' }
      },
      {
        path: '/company/dashboard',
        name: 'CompanyDashboard',
        component: () => import('@/views/company/CompanyDashboard.vue'),
        meta: { title: '保司数据看板', parentTitle: '保险公司管理' }
      },
      {
        path: '/company/rating-history',
        name: 'RatingHistory',
        component: () => import('@/views/company/RatingHistory.vue'),
        meta: { title: '风险评级历史', parentTitle: '保险公司管理' }
      },
      {
        path: '/card-template/category',
        name: 'CardCategory',
        component: () => import('@/views/cardTemplate/CategoryList.vue'),
        meta: { title: '分类管理', parentTitle: '卡片模板管理' }
      },
      {
        path: '/card-template/list',
        name: 'TemplateList',
        component: () => import('@/views/cardTemplate/TemplateList.vue'),
        meta: { title: '背景图库管理', parentTitle: '卡片模板管理' }
      },
      {
        path: '/card-template/stats',
        name: 'TemplateStats',
        component: () => import('@/views/cardTemplate/TemplateStats.vue'),
        meta: { title: '使用数据统计', parentTitle: '卡片模板管理' }
      },
      {
        path: '/vip/management',
        name: 'VipManagement',
        component: () => import('@/views/vip/VipManagement.vue'),
        meta: { title: 'VIP会员管理' }
      },
      {
        path: '/vip/redeem-code',
        name: 'RedeemCode',
        component: () => import('@/views/vip/RedeemCode.vue'),
        meta: { title: '兑换码管理' }
      },
      {
        path: '/system/settings',
        name: 'Settings',
        component: () => import('@/views/system/Settings.vue'),
        meta: { title: '系统设置' }
      }
    ]
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/dashboard'
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  }
})

router.beforeEach(async (to, _from, next) => {
  const userStore = useUserStore()
  const appStore = useAppStore()

  if (to.meta?.public) {
    next()
    return
  }

  if (!userStore.isLoggedIn) {
    next('/login')
    return
  }

  if (!userStore.adminInfo) {
    try {
      await userStore.fetchAdminInfo()
    } catch {
      userStore.logout()
      next('/login')
      return
    }
  }

  if (to.meta?.title) {
    appStore.addTagView({
      name: to.name as string,
      title: to.meta.title as string,
      path: to.path,
      fullPath: to.fullPath
    })
  }

  next()
})

export default router
