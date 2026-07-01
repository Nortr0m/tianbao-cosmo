package com.insurance.admin.vip.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * VIP记录VO
 */
@Data
public class AdminVipRecordVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 记录ID */
    private Long recordId;

    /** 用户ID */
    private Long userId;

    /** 用户名 */
    private String username;

    /** 会员等级（1-VIP，2-SVIP） */
    private Integer memberLevel;

    /** 会员等级描述 */
    private String memberLevelDesc;

    /** 购买金额 */
    private BigDecimal purchaseAmount;

    /** 过期时间 */
    private LocalDateTime expireTime;

    /** 购买时间 */
    private LocalDateTime purchaseTime;

    /** 订单号 */
    private String orderNo;

    /** 支付方式（1-微信支付，2-支付宝） */
    private Integer payType;

    /** 支付方式描述 */
    private String payTypeDesc;

    /** 状态（0-未支付，1-已支付，2-已退款） */
    private Integer status;

    /** 状态描述 */
    private String statusDesc;
}
