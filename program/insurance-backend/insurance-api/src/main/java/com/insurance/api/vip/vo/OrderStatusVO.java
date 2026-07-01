package com.insurance.api.vip.vo;

import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 订单状态VO
 */
@Data
public class OrderStatusVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 订单ID */
    private Long orderId;

    /** 订单号 */
    private String orderNo;

    /** 订单状态（pending/paid/cancelled/expired） */
    private String status;

    /** 支付时间 */
    private LocalDateTime paidAt;

    /** VIP过期时间 */
    private LocalDateTime vipExpireAt;
}
