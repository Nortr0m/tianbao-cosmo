package com.insurance.admin.product.vo;

import lombok.Data;
import java.io.Serializable;

/**
 * 费率导入结果VO
 */
@Data
public class WholeLifeRateImportResultVO implements Serializable {
    private Integer totalCount;
    private Integer successCount;
    private Integer failCount;
    private String message;
}
