// Storage封装

/**
 * 同步获取Storage数据
 * @param key 键名
 * @returns 存储的数据，不存在返回null
 */
export function getStorage<T = any>(key: string): T | null {
  try {
    const value = wx.getStorageSync(key);
    return value !== undefined && value !== '' ? value as T : null;
  } catch (e) {
    console.error(`获取Storage失败 [${key}]:`, e);
    return null;
  }
}

/**
 * 同步设置Storage数据
 * @param key 键名
 * @param data 数据
 */
export function setStorage<T = any>(key: string, data: T): void {
  try {
    wx.setStorageSync(key, data);
  } catch (e) {
    console.error(`设置Storage失败 [${key}]:`, e);
  }
}

/**
 * 同步移除Storage数据
 * @param key 键名
 */
export function removeStorage(key: string): void {
  try {
    wx.removeStorageSync(key);
  } catch (e) {
    console.error(`移除Storage失败 [${key}]:`, e);
  }
}

/**
 * 同步清空所有Storage数据
 */
export function clearStorage(): void {
  try {
    wx.clearStorageSync();
  } catch (e) {
    console.error('清空Storage失败:', e);
  }
}

/**
 * 异步获取Storage数据
 * @param key 键名
 * @returns Promise<T | null>
 */
export function getStorageAsync<T = any>(key: string): Promise<T | null> {
  return new Promise((resolve) => {
    wx.getStorage({
      key,
      success: (res) => {
        resolve(res.data as T);
      },
      fail: () => {
        resolve(null);
      },
    });
  });
}

/**
 * 异步设置Storage数据
 * @param key 键名
 * @param data 数据
 * @returns Promise<void>
 */
export function setStorageAsync<T = any>(key: string, data: T): Promise<void> {
  return new Promise((resolve, reject) => {
    wx.setStorage({
      key,
      data,
      success: () => {
        resolve();
      },
      fail: (err) => {
        reject(err);
      },
    });
  });
}

/**
 * 异步移除Storage数据
 * @param key 键名
 * @returns Promise<void>
 */
export function removeStorageAsync(key: string): Promise<void> {
  return new Promise((resolve, reject) => {
    wx.removeStorage({
      key,
      success: () => {
        resolve();
      },
      fail: (err) => {
        reject(err);
      },
    });
  });
}
