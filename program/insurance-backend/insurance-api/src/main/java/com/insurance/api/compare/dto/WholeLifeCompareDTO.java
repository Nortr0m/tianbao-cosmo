package com.insurance.api.compare.dto;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 增额终身寿险对比DTO
 */
@Data
public class WholeLifeCompareDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 产品ID列表 */
    @NotEmpty(message = "产品ID列表不能为空")
    private List<Long> productIds;
}
