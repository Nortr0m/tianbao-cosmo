package com.insurance.common.enums;

import lombok.Getter;

/**
 * 产品类型枚举
 */
@Getter
public enum ProductTypeEnum {

    LIFE("LIFE", "人寿保险"),
    HEALTH("HEALTH", "健康保险"),
    ACCIDENT("ACCIDENT", "意外保险"),
    PROPERTY("PROPERTY", "财产保险"),
    AUTO("AUTO", "车险"),
    TRAVEL("TRAVEL", "旅游保险"),
    PENSION("PENSION", "养老保险");

    private final String code;
    private final String desc;

    ProductTypeEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public static ProductTypeEnum getByCode(String code) {
        for (ProductTypeEnum value : values()) {
            if (value.getCode().equals(code)) {
                return value;
            }
        }
        return null;
    }
}
