package com.insurance.api.vip.controller;

import com.insurance.api.vip.dto.CreateOrderDTO;
import com.insurance.api.vip.service.VipService;
import com.insurance.api.vip.vo.OrderStatusVO;
import com.insurance.api.vip.vo.PaymentResultVO;
import com.insurance.api.vip.vo.VipPermissionVO;
import com.insurance.api.vip.vo.VipPlanListVO;
import com.insurance.api.vip.vo.VipStatusVO;
import com.insurance.common.result.Result;
import com.insurance.common.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;

/**
 * VIP会员Controller
 */
@RestController
@RequestMapping("/api/v1/vip")
@RequiredArgsConstructor
@Validated
public class VipController {

    private final VipService vipService;

    /**
     * 获取VIP状态
     */
    @GetMapping("/status")
    public Result<VipStatusVO> getVipStatus() {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return Result.unauthorized("请先登录");
        }
        return Result.success(vipService.getVipStatus(userId));
    }

    /**
     * 获取VIP权限
     */
    @GetMapping("/permissions")
    public Result<VipPermissionVO> getVipPermissions() {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return Result.unauthorized("请先登录");
        }
        return Result.success(vipService.getVipPermissions(userId));
    }

    /**
     * 获取VIP套餐列表
     */
    @GetMapping("/plans")
    public Result<VipPlanListVO> getVipPlans() {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return Result.unauthorized("请先登录");
        }
        return Result.success(vipService.getVipPlans(userId));
    }

    /**
     * 创建VIP订单
     */
    @PostMapping("/orders")
    public Result<PaymentResultVO> createOrder(@Valid @RequestBody CreateOrderDTO dto) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return Result.unauthorized("请先登录");
        }
        return Result.success(vipService.createOrder(userId, dto));
    }

    /**
     * 查询订单状态
     */
    @GetMapping("/orders/{orderId}/status")
    public Result<OrderStatusVO> getOrderStatus(@PathVariable Long orderId) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return Result.unauthorized("请先登录");
        }
        return Result.success(vipService.getOrderStatus(orderId));
    }

    /**
     * 模拟支付成功（仅用于测试环境）
     */
    @PostMapping("/orders/{orderId}/mock-pay")
    public Result<OrderStatusVO> mockPay(@PathVariable Long orderId) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return Result.unauthorized("请先登录");
        }
        return Result.success(vipService.mockPaySuccess(userId, orderId));
    }
}
