package com.insurance.api.vip.dto;

import lombok.Data;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.io.Serializable;

/**
 * 创建VIP订单DTO
 */
@Data
public class CreateOrderDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** VIP套餐ID（1=VIP，2=SVIP） */
    @NotNull(message = "套餐ID不能为空")
    private Integer planId;

    /** 支付方式（wechat/alipay） */
    @NotBlank(message = "支付方式不能为空")
    private String paymentMethod;
}
