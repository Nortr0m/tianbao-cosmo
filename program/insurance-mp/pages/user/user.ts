import { getStorage, setStorage, removeStorage, clearStorage } from '../../utils/storage';
import { getMemberLevelName, getMemberLevelColor, MemberLevel } from '../../utils/permission';
import { logout } from '../../api/auth';

Page({
  data: {
    isLoggedIn: false,
    userInfo: null as WechatMiniprogram.UserInfo | null,
    memberLevel: 'free' as MemberLevel,
    memberLevelName: '免费会员',
    memberLevelColor: '#718096',
    compareCount: 0,
    cardCount: 0,
    // 功能列表
    menuList: [
      {
        id: 'compare',
        name: '我的对比',
        icon: 'exchange',
        color: '#2B6CB0',
        badge: 0,
      },
      {
        id: 'card',
        name: '我的卡片',
        icon: 'photo-o',
        color: '#38A169',
        badge: 0,
      },
      {
        id: 'vip',
        name: 'VIP开通',
        icon: 'vip-card-o',
        color: '#D69E2E',
        badge: 0,
      },
      {
        id: 'contact',
        name: '联系客服',
        icon: 'service-o',
        color: '#805AD5',
        badge: 0,
      },
      {
        id: 'about',
        name: '关于我们',
        icon: 'info-o',
        color: '#718096',
        badge: 0,
      },
      {
        id: 'setting',
        name: '设置',
        icon: 'setting-o',
        color: '#4A5568',
        badge: 0,
      },
    ] as MenuItem[],
  },

  onShow() {
    this.checkLoginStatus();
    this.loadStats();
  },

  onPullDownRefresh() {
    this.checkLoginStatus();
    this.loadStats();
    wx.stopPullDownRefresh();
  },

  onShareAppMessage() {
    return {
      title: '天保星君 - 专业保险对比平台',
      path: '/pages/index/index',
    };
  },

  // 检查登录状态
  checkLoginStatus() {
    const token = getStorage<string>('token');
    const userInfo = getStorage<WechatMiniprogram.UserInfo>('userInfo');
    const memberLevel = getStorage<MemberLevel>('memberLevel') || 'free';

    const isLoggedIn = !!token;
    const memberLevelName = getMemberLevelName(memberLevel);
    const memberLevelColor = getMemberLevelColor(memberLevel);

    this.setData({
      isLoggedIn,
      userInfo,
      memberLevel,
      memberLevelName,
      memberLevelColor,
    });
  },

  // 加载统计数据
  loadStats() {
    const compareList = getStorage<Array<unknown>>('compareList') || [];
    // 这里可以从storage或API获取卡片数量
    const cardCount = 0;

    const { menuList } = this.data;
    const newMenuList = menuList.map((item) => {
      if (item.id === 'compare') {
        return { ...item, badge: compareList.length };
      }
      if (item.id === 'card') {
        return { ...item, badge: cardCount };
      }
      return item;
    });

    this.setData({
      compareCount: compareList.length,
      cardCount,
      menuList: newMenuList,
    });
  },

  // 登录
  onLogin() {
    wx.getUserProfile({
      desc: '用于完善用户资料',
      success: (res) => {
        const userInfo = res.userInfo;
        // 模拟登录
        setStorage('token', 'mock-token-' + Date.now());
        setStorage('userInfo', userInfo);
        setStorage('memberLevel', 'free');

        this.setData({
          isLoggedIn: true,
          userInfo,
          memberLevel: 'free',
          memberLevelName: '免费会员',
          memberLevelColor: '#718096',
        });

        wx.showToast({
          title: '登录成功',
          icon: 'success',
        });
      },
      fail: () => {
        wx.showToast({
          title: '登录失败',
          icon: 'none',
        });
      },
    });
  },

  // 退出登录
  onLogout() {
    wx.showModal({
      title: '提示',
      content: '确定要退出登录吗？',
      success: (res) => {
        if (res.confirm) {
          // 调用退出登录API
          logout().catch(() => {
            // 忽略错误
          });

          // 清除本地数据
          removeStorage('token');
          removeStorage('userInfo');
          removeStorage('memberLevel');
          removeStorage('compareList');

          this.setData({
            isLoggedIn: false,
            userInfo: null,
            memberLevel: 'free',
            memberLevelName: '免费会员',
            memberLevelColor: '#718096',
            compareCount: 0,
            cardCount: 0,
          });

          wx.showToast({
            title: '已退出登录',
            icon: 'success',
          });
        }
      },
    });
  },

  // 点击功能菜单
  onMenuTap(e: WechatMiniprogram.TouchEvent) {
    const { item } = e.currentTarget.dataset;

    switch (item.id) {
      case 'compare':
        if (this.data.compareCount > 0) {
          const compareList = getStorage<Array<{ id: string }>>('compareList') || [];
          const ids = compareList.map((i) => i.id).join(',');
          wx.navigateTo({
            url: `/pages/compare/compare?ids=${ids}`,
          });
        } else {
          wx.switchTab({
            url: '/pages/product/list/list?compareMode=true',
          });
        }
        break;
      case 'card':
        wx.navigateTo({
          url: '/pages/card/generate/generate',
        });
        break;
      case 'vip':
        this.onOpenVip();
        break;
      case 'contact':
        this.onContactService();
        break;
      case 'about':
        wx.showModal({
          title: '关于天保星君',
          content: '天保星君是一款专业的保险对比工具，帮助您轻松比较不同保险产品，做出明智的投保决策。',
          showCancel: false,
        });
        break;
      case 'setting':
        wx.showActionSheet({
          itemList: ['清除缓存', '检查更新'],
          success: (res) => {
            if (res.tapIndex === 0) {
              this.onClearCache();
            } else if (res.tapIndex === 1) {
              wx.showToast({
                title: '已是最新版本',
                icon: 'success',
              });
            }
          },
        });
        break;
    }
  },

  // 开通VIP
  onOpenVip() {
    wx.showModal({
      title: 'VIP会员',
      content: '开通VIP会员可享受更多特权：\n\n1. 最多对比5款产品\n2. 无水印生成卡片\n3. 高级筛选功能\n4. 专属客服支持\n5. 更多精美模板',
      confirmText: '立即开通',
      cancelText: '暂不开通',
      success: (res) => {
        if (res.confirm) {
          // 跳转到VIP开通页面或调起支付
          wx.showToast({
            title: '功能开发中',
            icon: 'none',
          });
        }
      },
    });
  },

  // 联系客服
  onContactService() {
    wx.showModal({
      title: '联系客服',
      content: '客服电话：400-888-8888\n工作时间：周一至周五 9:00-18:00\n\n您也可以添加客服微信：tianbaoxingjun',
      showCancel: false,
      confirmText: '知道了',
    });
  },

  // 清除缓存
  onClearCache() {
    wx.showModal({
      title: '提示',
      content: '确定要清除缓存吗？清除后需要重新登录。',
      success: (res) => {
        if (res.confirm) {
          clearStorage();
          this.setData({
            isLoggedIn: false,
            userInfo: null,
            memberLevel: 'free',
            memberLevelName: '免费会员',
            memberLevelColor: '#718096',
            compareCount: 0,
            cardCount: 0,
          });
          wx.showToast({
            title: '缓存已清除',
            icon: 'success',
          });
        }
      },
    });
  },

  // 点击头像
  onAvatarTap() {
    if (!this.data.isLoggedIn) {
      this.onLogin();
    }
  },
});

// 菜单项接口
interface MenuItem {
  id: string;
  name: string;
  icon: string;
  color: string;
  badge: number;
}
