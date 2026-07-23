package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * VIP会员记录实体
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("user_vip_record")
public class UserVipRecord extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 记录ID */
    @TableId(type = IdType.ASSIGN_ID)
    private Long recordId;

    /** 用户ID */
    private Long userId;

    /** 会员等级（1-VIP，2-SVIP） */
    private Integer memberLevel;

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

    /** 状态（0-未支付，1-已支付，2-已退款） */
    private Integer status;
}
