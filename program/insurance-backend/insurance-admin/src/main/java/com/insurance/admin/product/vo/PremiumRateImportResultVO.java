package com.insurance.admin.product.vo;

import lombok.Data;

/**
 * 重疾险费率导入结果VO
 */
@Data
public class PremiumRateImportResultVO {

    /** 总条数 */
    private int totalCount;

    /** 成功条数 */
    private int successCount;

    /** 失败条数 */
    private int failCount;

    /** 结果消息 */
    private String message;
}
