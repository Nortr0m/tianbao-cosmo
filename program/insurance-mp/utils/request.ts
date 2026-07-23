import { getStorage } from './storage';

// API基础URL
const BASE_URL = 'https://api.tianbaoxingjun.com';

// 请求配置接口
interface RequestOptions {
  url: string;
  method?: 'GET' | 'POST' | 'PUT' | 'DELETE' | 'PATCH';
  data?: Record<string, any>;
  header?: Record<string, string>;
  loading?: boolean;
  loadingText?: string;
}

// 响应数据接口
interface ResponseData<T = any> {
  code: number;
  message: string;
  data: T;
}

// 请求封装
export function request<T = any>(options: RequestOptions): Promise<T> {
  return new Promise((resolve, reject) => {
    const { url, method = 'GET', data, header = {}, loading = true, loadingText = '加载中...' } = options;

    // 获取Token
    const token = getStorage<string>('token');

    // 显示加载中
    if (loading) {
      wx.showLoading({
        title: loadingText,
        mask: true,
      });
    }

    wx.request({
      url: `${BASE_URL}${url}`,
      method,
      data,
      header: {
        'Content-Type': 'application/json',
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
        ...header,
      },
      success: (res) => {
        const { statusCode, data: responseData } = res;

        if (statusCode === 200) {
          const result = responseData as ResponseData<T>;

          if (result.code === 200) {
            resolve(result.data);
          } else if (result.code === 401) {
            // Token过期，清除登录状态
            wx.removeStorageSync('token');
            wx.removeStorageSync('userInfo');
            wx.showToast({
              title: '登录已过期，请重新登录',
              icon: 'none',
            });
            reject(new Error(result.message || '登录已过期'));
          } else {
            wx.showToast({
              title: result.message || '请求失败',
              icon: 'none',
            });
            reject(new Error(result.message || '请求失败'));
          }
        } else if (statusCode === 401) {
          wx.removeStorageSync('token');
          wx.removeStorageSync('userInfo');
          wx.showToast({
            title: '登录已过期，请重新登录',
            icon: 'none',
          });
          reject(new Error('登录已过期'));
        } else {
          wx.showToast({
            title: `请求失败: ${statusCode}`,
            icon: 'none',
          });
          reject(new Error(`HTTP ${statusCode}`));
        }
      },
      fail: (err) => {
        wx.showToast({
          title: '网络请求失败',
          icon: 'none',
        });
        reject(err);
      },
      complete: () => {
        if (loading) {
          wx.hideLoading();
        }
      },
    });
  });
}

// GET请求
export function get<T = any>(url: string, data?: Record<string, any>, options?: Omit<RequestOptions, 'url' | 'method' | 'data'>): Promise<T> {
  return request<T>({
    url,
    method: 'GET',
    data,
    ...options,
  });
}

// POST请求
export function post<T = any>(url: string, data?: Record<string, any>, options?: Omit<RequestOptions, 'url' | 'method' | 'data'>): Promise<T> {
  return request<T>({
    url,
    method: 'POST',
    data,
    ...options,
  });
}

// PUT请求
export function put<T = any>(url: string, data?: Record<string, any>, options?: Omit<RequestOptions, 'url' | 'method' | 'data'>): Promise<T> {
  return request<T>({
    url,
    method: 'PUT',
    data,
    ...options,
  });
}

// DELETE请求
export function del<T = any>(url: string, data?: Record<string, any>, options?: Omit<RequestOptions, 'url' | 'method' | 'data'>): Promise<T> {
  return request<T>({
    url,
    method: 'DELETE',
    data,
    ...options,
  });
}
