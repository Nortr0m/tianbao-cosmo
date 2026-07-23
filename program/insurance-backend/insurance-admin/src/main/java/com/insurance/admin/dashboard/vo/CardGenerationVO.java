package com.insurance.admin.dashboard.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 卡片生成统计VO
 */
@Data
public class CardGenerationVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 日期 */
    private String date;

    /** 生成数量 */
    private Long count;

    /** 类型 */
    private String type;
}
