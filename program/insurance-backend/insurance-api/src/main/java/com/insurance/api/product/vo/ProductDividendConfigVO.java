package com.insurance.api.product.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 产品分红配置VO
 */
@Data
public class ProductDividendConfigVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long configId;

    private Long productId;

    /** 预定利率（如0.0250=2.5%） */
    private BigDecimal scheduledRate;

    /** 保证利率 */
    private BigDecimal guaranteedRate;

    /** 最低保证利率 */
    private BigDecimal minGuaranteedRate;

    /** 增额比例（如0.0350=3.5%） */
    private BigDecimal increaseRate;

    /** 分红演示-低档利率 */
    private BigDecimal dividendLowRate;

    /** 分红演示-中档利率 */
    private BigDecimal dividendMidRate;

    /** 分红演示-高档利率 */
    private BigDecimal dividendHighRate;

    /** 假定分红利率 */
    private BigDecimal dividendAssumedRate;

    /** 万能结算利率 */
    private BigDecimal universalSettleRate;

    /** 最低结算利率 */
    private BigDecimal minSettleRate;
}
