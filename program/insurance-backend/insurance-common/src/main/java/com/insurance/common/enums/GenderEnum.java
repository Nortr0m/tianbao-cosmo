package com.insurance.common.enums;

import lombok.Getter;

/**
 * 性别枚举
 */
@Getter
public enum GenderEnum {

    MALE("MALE", "男"),
    FEMALE("FEMALE", "女"),
    UNKNOWN("UNKNOWN", "未知");

    private final String code;
    private final String desc;

    GenderEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public static GenderEnum getByCode(String code) {
        for (GenderEnum value : values()) {
            if (value.getCode().equals(code)) {
                return value;
            }
        }
        return null;
    }
}
