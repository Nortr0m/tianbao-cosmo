package com.insurance.api.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 产品分红配置实体
 */
@Data
@TableName("product_dividend_config")
public class ProductDividendConfig {
    @TableId(type = IdType.ASSIGN_ID)
    private Long configId;
    private Long productId;
    private BigDecimal scheduledRate;      // 预定利率（如0.0250=2.5%）
    private BigDecimal guaranteedRate;    // 保证利率
    private BigDecimal minGuaranteedRate; // 最低保证利率
    private BigDecimal increaseRate;      // 增额比例（如0.0350=3.5%）
    private BigDecimal dividendLowRate;   // 分红演示-低档利率
    private BigDecimal dividendMidRate;   // 分红演示-中档利率
    private BigDecimal dividendHighRate;  // 分红演示-高档利率
    private BigDecimal dividendAssumedRate;// 假定分红利率
    private BigDecimal universalSettleRate;// 万能结算利率
    private BigDecimal minSettleRate;     // 最低结算利率
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
