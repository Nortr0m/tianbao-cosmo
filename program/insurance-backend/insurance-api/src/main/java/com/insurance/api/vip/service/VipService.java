package com.insurance.api.vip.service;

import com.insurance.api.vip.dto.CreateOrderDTO;
import com.insurance.api.vip.vo.OrderStatusVO;
import com.insurance.api.vip.vo.PaymentResultVO;
import com.insurance.api.vip.vo.VipPermissionVO;
import com.insurance.api.vip.vo.VipPlanListVO;
import com.insurance.api.vip.vo.VipStatusVO;

/**
 * VIP会员Service接口
 */
public interface VipService {

    /**
     * 获取VIP状态
     *
     * @param userId 用户ID
     * @return VIP状态
     */
    VipStatusVO getVipStatus(Long userId);

    /**
     * 获取VIP权限
     *
     * @param userId 用户ID
     * @return VIP权限
     */
    VipPermissionVO getVipPermissions(Long userId);

    /**
     * 获取VIP套餐列表
     *
     * @param userId 用户ID
     * @return VIP套餐列表（含当前用户状态）
     */
    VipPlanListVO getVipPlans(Long userId);

    /**
     * 创建VIP订单
     *
     * @param userId 用户ID
     * @param dto    创建订单参数
     * @return 支付结果
     */
    PaymentResultVO createOrder(Long userId, CreateOrderDTO dto);

    /**
     * 查询订单状态
     *
     * @param orderId 订单ID
     * @return 订单状态
     */
    OrderStatusVO getOrderStatus(Long orderId);

    /**
     * 模拟支付成功（仅用于测试环境）
     *
     * @param userId  用户ID
     * @param orderId 订单ID
     * @return 订单状态
     */
    OrderStatusVO mockPaySuccess(Long userId, Long orderId);
}
