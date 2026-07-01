package com.insurance.common.enums;

import lombok.Getter;

/**
 * 保险公司类型枚举
 * 1=中资 2=合资 3=外资
 */
@Getter
public enum CompanyTypeEnum {

    DOMESTIC(1, "中资"),
    JOINT_VENTURE(2, "合资"),
    FOREIGN(3, "外资");

    private final int code;
    private final String desc;

    CompanyTypeEnum(int code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public static CompanyTypeEnum getByCode(int code) {
        for (CompanyTypeEnum value : values()) {
            if (value.getCode() == code) {
                return value;
            }
        }
        return null;
    }
}
