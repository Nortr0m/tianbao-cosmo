package com.insurance.api.vip.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 支付结果VO
 */
@Data
public class PaymentResultVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 订单ID */
    private Long orderId;

    /** 订单号 */
    private String orderNo;

    /** 支付URL */
    private String paymentUrl;

    /** 订单状态 */
    private String status;

    /** 支付金额 */
    private BigDecimal amount;

    /** 订单过期时间 */
    private LocalDateTime expireAt;
}
