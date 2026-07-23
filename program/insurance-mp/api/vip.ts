import { get, post } from '../utils/request';

// VIP套餐
export interface VipPackage {
  id: string;
  name: string;
  level: 'vip' | 'svip';
  duration: number;
  durationUnit: string;
  originalPrice: number;
  price: number;
  features: string[];
  isRecommend: boolean;
  tag?: string;
}

// VIP订单
export interface VipOrder {
  orderId: string;
  packageId: string;
  packageName: string;
  price: number;
  status: 'pending' | 'paid' | 'cancelled' | 'refunded';
  createTime: string;
  payTime?: string;
  expireTime?: string;
}

// VIP状态
export interface VipStatus {
  isVip: boolean;
  level: 'free' | 'vip' | 'svip';
  expireTime?: string;
  remainingDays: number;
}

// 支付参数
export interface PaymentParams {
  orderId: string;
}

// 支付结果
export interface PaymentResult {
  timeStamp: string;
  nonceStr: string;
  package: string;
  signType: string;
  paySign: string;
}

/**
 * 获取VIP套餐列表
 * @returns VIP套餐列表
 */
export function getVipPackages(): Promise<VipPackage[]> {
  return get<VipPackage[]>('/api/vip/packages');
}

/**
 * 获取VIP状态
 * @returns VIP状态
 */
export function getVipStatus(): Promise<VipStatus> {
  return get<VipStatus>('/api/vip/status');
}

/**
 * 创建VIP订单
 * @param packageId 套餐ID
 * @returns 订单信息
 */
export function createVipOrder(packageId: string): Promise<VipOrder> {
  return post<VipOrder>('/api/vip/createOrder', { packageId });
}

/**
 * 获取支付参数
 * @param params 支付参数
 * @returns 微信支付参数
 */
export function getPaymentParams(params: PaymentParams): Promise<PaymentResult> {
  return post<PaymentResult>('/api/vip/payment', params);
}

/**
 * 查询订单状态
 * @param orderId 订单ID
 * @returns 订单信息
 */
export function queryOrder(orderId: string): Promise<VipOrder> {
  return get<VipOrder>(`/api/vip/order/${orderId}`);
}

/**
 * 获取我的订单列表
 * @param page 页码
 * @param pageSize 每页数量
 * @returns 订单列表
 */
export function getMyOrders(page: number = 1, pageSize: number = 20): Promise<{ list: VipOrder[]; hasMore: boolean }> {
  return get('/api/vip/orders', { page, pageSize });
}

/**
 * 微信支付封装
 * @param paymentParams 支付参数
 * @returns Promise<void>
 */
export function wxPay(paymentParams: PaymentResult): Promise<void> {
  return new Promise((resolve, reject) => {
    wx.requestPayment({
      timeStamp: paymentParams.timeStamp,
      nonceStr: paymentParams.nonceStr,
      package: paymentParams.package,
      signType: paymentParams.signType,
      paySign: paymentParams.paySign,
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
 * 开通VIP完整流程
 * @param packageId 套餐ID
 * @returns Promise<void>
 */
export async function purchaseVip(packageId: string): Promise<void> {
  try {
    // 创建订单
    const order = await createVipOrder(packageId);

    // 获取支付参数
    const paymentParams = await getPaymentParams({ orderId: order.orderId });

    // 调起支付
    await wxPay(paymentParams);

    // 支付成功，更新本地会员状态
    wx.setStorageSync('memberLevel', order.packageName.includes('SVIP') ? 'svip' : 'vip');

    wx.showToast({
      title: '开通成功',
      icon: 'success',
    });
  } catch (error) {
    wx.showToast({
      title: '支付失败',
      icon: 'none',
    });
    throw error;
  }
}
