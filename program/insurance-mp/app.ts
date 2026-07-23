import { request } from './utils/request';
import { getStorage, setStorage } from './utils/storage';

interface IAppOption {
  globalData: {
    userInfo: WechatMiniprogram.UserInfo | null;
    token: string;
    memberLevel: 'free' | 'vip' | 'svip';
  };
  userInfoReadyCallback?: (userInfo: WechatMiniprogram.UserInfo) => void;
  request: typeof request;
}

App<IAppOption>({
  globalData: {
    userInfo: null,
    token: '',
    memberLevel: 'free',
  },

  onLaunch() {
    // 检查登录状态
    this.checkLoginStatus();
    // 获取系统信息
    this.getSystemInfo();
  },

  onShow() {
    // 每次显示时刷新登录状态
    this.checkLoginStatus();
  },

  // 检查登录状态
  checkLoginStatus() {
    const token = getStorage<string>('token');
    const userInfo = getStorage<WechatMiniprogram.UserInfo>('userInfo');
    const memberLevel = getStorage<'free' | 'vip' | 'svip'>('memberLevel') || 'free';

    if (token) {
      this.globalData.token = token;
      this.globalData.userInfo = userInfo || null;
      this.globalData.memberLevel = memberLevel;
    } else {
      this.globalData.token = '';
      this.globalData.userInfo = null;
      this.globalData.memberLevel = 'free';
    }
  },

  // 获取系统信息
  getSystemInfo() {
    wx.getSystemInfo({
      success: (res) => {
        console.log('系统信息:', res);
      },
    });
  },

  // 封装request方法
  request,
});
