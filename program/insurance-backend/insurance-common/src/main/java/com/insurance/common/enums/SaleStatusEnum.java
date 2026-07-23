package com.insurance.common.enums;

import lombok.Getter;

/**
 * 销售状态枚举
 * 0=已停售 1=正常在售 2=预售中
 */
@Getter
public enum SaleStatusEnum {

    OFF_SALE(0, "已停售"),
    ON_SALE(1, "正常在售"),
    PRE_SALE(2, "预售中");

    private final int code;
    private final String desc;

    SaleStatusEnum(int code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public static SaleStatusEnum getByCode(int code) {
        for (SaleStatusEnum value : values()) {
            if (value.getCode() == code) {
                return value;
            }
        }
        return null;
    }
}
